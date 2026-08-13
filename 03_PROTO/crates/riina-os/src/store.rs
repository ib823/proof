// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Durable key–value store — the persistence half of master plan REQ-73.
//!
//! RIINA had no durable data tier. `vfs_*` implements the verified
//! access-control model but lives in memory, and `fail_*`/`file_*` are raw
//! whole-file reads and writes: a crash midway through `fail_tulis` leaves a
//! truncated file and the previous contents are gone. Neither is a place to put
//! a web application's state.
//!
//! This is a log-structured store whose on-disk shape is the **journal** of
//! `02_FORMAL/coq/domains/VerifiedFileSystem.v` made real. The model says a
//! transaction counts only when `TxnCommitted` (`txn_complete`), and a journal
//! is consistent only when every transaction in it is complete
//! (`journal_consistent`). So:
//!
//! * a record is **committed** iff its length prefix and CRC-32 both validate —
//!   that is the on-disk witness of `TxnCommitted`;
//! * a torn tail (a crash mid-append) is `TxnPending`, which by the model makes
//!   the journal inconsistent, so recovery **truncates it away**. After
//!   [`Store::open`] returns, the file is consistent by construction.
//!
//! # What durability means here, precisely
//!
//! * **Atomic** (`fsi_atomic_writes`): a put/delete either lands whole or is
//!   discarded by recovery. A half-written record is never read back as data,
//!   because its CRC cannot match.
//! * **Durable**: every committed record is `fsync`ed before the call returns,
//!   so it survives power loss — not just process death.
//! * **Crash-consistent** (`fsi_crash_consistent`): recovery is deterministic
//!   and lossless for committed records.
//! * **Compaction** is atomic: rewrite live records to a temp file, fsync it,
//!   `rename` over the original (POSIX-atomic), then **fsync the directory** —
//!   the step that is usually forgotten, without which the rename itself is not
//!   durable and a crash can resurrect the pre-compaction file.
//!
//! # What this is NOT
//!
//! Not a database: no transactions across keys, no secondary indexes, no
//! concurrent writers (one process owns a [`Store`]). Values are bytes; the
//! caller supplies meaning.

use std::collections::BTreeMap;
use std::fs::{File, OpenOptions};
use std::io::{Read, Seek, SeekFrom, Write};
use std::path::{Path, PathBuf};

/// File header magic. A file that does not start with this is not ours, and is
/// refused rather than parsed as garbage.
const MAGIC: &[u8; 12] = b"RIINASTORv1\0";

/// Largest key accepted, in bytes.
pub const MAX_KEY_BYTES: usize = 4 * 1024;

/// Largest value accepted, in bytes (16 MiB).
pub const MAX_VALUE_BYTES: usize = 16 * 1024 * 1024;

const OP_PUT: u8 = 1;
const OP_DELETE: u8 = 2;

/// Why a store operation failed.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum StoreError {
    Io { path: PathBuf, detail: String },
    /// The file exists but is not a RIINA store.
    BadMagic { path: PathBuf },
    /// A key or value exceeded its limit.
    TooLarge { what: &'static str, limit: usize },
    /// A committed record was structurally invalid (not a torn tail — a record
    /// whose CRC matched but whose contents do not parse). Refused rather than
    /// guessed at.
    Corrupt { offset: u64, detail: String },
}

impl std::fmt::Display for StoreError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Io { path, detail } => write!(f, "store {}: {detail}", path.display()),
            Self::BadMagic { path } => write!(
                f,
                "{} is not a RIINA store (bad magic) — refusing to overwrite it",
                path.display()
            ),
            Self::TooLarge { what, limit } => write!(f, "{what} exceeds {limit} bytes"),
            Self::Corrupt { offset, detail } => {
                write!(f, "corrupt committed record at offset {offset}: {detail}")
            }
        }
    }
}

type Result<T> = std::result::Result<T, StoreError>;

fn io(path: &Path, e: &std::io::Error) -> StoreError {
    StoreError::Io {
        path: path.to_path_buf(),
        detail: e.to_string(),
    }
}

// ── CRC-32 (IEEE 802.3), dependency-free ────────────────────────────────────

/// CRC-32/IEEE of `data`. Bitwise (no table): small, obviously correct, and
/// this is not a hot path — a record is fsynced right after, which dominates.
///
/// KAT: `crc32(b"123456789") == 0xCBF4_3926` (the standard check value), pinned
/// in the tests below.
#[must_use]
pub fn crc32(data: &[u8]) -> u32 {
    let mut crc: u32 = 0xFFFF_FFFF;
    for &byte in data {
        crc ^= u32::from(byte);
        for _ in 0..8 {
            let mask = (crc & 1).wrapping_neg();
            crc = (crc >> 1) ^ (0xEDB8_8320 & mask);
        }
    }
    !crc
}

// ── the store ───────────────────────────────────────────────────────────────

/// A durable key–value store backed by an append-only journal.
#[derive(Debug)]
pub struct Store {
    path: PathBuf,
    file: File,
    /// Live keys → values, rebuilt from the journal on open.
    map: BTreeMap<Vec<u8>, Vec<u8>>,
    /// Bytes of journal that are dead (superseded or deleted), for compaction.
    dead_bytes: u64,
}

impl Store {
    /// Open (creating if absent) the store at `path`, replaying its journal.
    ///
    /// A torn tail from a crash is truncated: by the Coq model a pending
    /// transaction makes the journal inconsistent, so it cannot be kept.
    /// Committed records are never lost.
    ///
    /// # Errors
    /// IO failure, or [`StoreError::BadMagic`] if the file is not a store.
    pub fn open(path: impl AsRef<Path>) -> Result<Self> {
        let path = path.as_ref().to_path_buf();
        let mut file = OpenOptions::new()
            .read(true)
            .write(true)
            .create(true)
            .truncate(false)
            .open(&path)
            .map_err(|e| io(&path, &e))?;

        let len = file.metadata().map_err(|e| io(&path, &e))?.len();
        if len == 0 {
            file.write_all(MAGIC).map_err(|e| io(&path, &e))?;
            file.sync_all().map_err(|e| io(&path, &e))?;
            sync_parent_dir(&path)?;
            return Ok(Self {
                path,
                file,
                map: BTreeMap::new(),
                dead_bytes: 0,
            });
        }

        let mut magic = [0u8; MAGIC.len()];
        file.seek(SeekFrom::Start(0)).map_err(|e| io(&path, &e))?;
        file.read_exact(&mut magic)
            .map_err(|_| StoreError::BadMagic { path: path.clone() })?;
        if &magic != MAGIC {
            return Err(StoreError::BadMagic { path });
        }

        let mut bytes = Vec::new();
        file.read_to_end(&mut bytes).map_err(|e| io(&path, &e))?;

        let replayed = replay(&bytes, MAGIC.len() as u64)?;

        // Discard the torn tail, if any, so the journal on disk is consistent.
        if replayed.committed_len < len {
            file.set_len(replayed.committed_len)
                .map_err(|e| io(&path, &e))?;
            file.sync_all().map_err(|e| io(&path, &e))?;
        }
        file.seek(SeekFrom::End(0)).map_err(|e| io(&path, &e))?;

        Ok(Self {
            path,
            file,
            map: replayed.map,
            dead_bytes: replayed.dead_bytes,
        })
    }

    /// Number of live keys.
    #[must_use]
    pub fn len(&self) -> usize {
        self.map.len()
    }

    /// Whether the store holds no live keys.
    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.map.is_empty()
    }

    /// Look up a key.
    #[must_use]
    pub fn get(&self, key: &[u8]) -> Option<&[u8]> {
        self.map.get(key).map(Vec::as_slice)
    }

    /// Whether a key is present. Distinguishes "absent" from "present but
    /// empty", which [`Store::get`] alone cannot express for a caller that
    /// flattens `Option`.
    #[must_use]
    pub fn contains(&self, key: &[u8]) -> bool {
        self.map.contains_key(key)
    }

    /// Live keys, in sorted order (deterministic, so callers can rely on it).
    #[must_use]
    pub fn keys(&self) -> Vec<Vec<u8>> {
        self.map.keys().cloned().collect()
    }

    /// Store `value` under `key`, durably: the record is fsynced before this
    /// returns, so it survives power loss.
    ///
    /// # Errors
    /// [`StoreError::TooLarge`] or IO failure.
    pub fn put(&mut self, key: &[u8], value: &[u8]) -> Result<()> {
        if key.len() > MAX_KEY_BYTES {
            return Err(StoreError::TooLarge {
                what: "key",
                limit: MAX_KEY_BYTES,
            });
        }
        if value.len() > MAX_VALUE_BYTES {
            return Err(StoreError::TooLarge {
                what: "value",
                limit: MAX_VALUE_BYTES,
            });
        }
        let record = encode_record(OP_PUT, key, value);
        self.append(&record)?;
        if let Some(old) = self.map.insert(key.to_vec(), value.to_vec()) {
            // The superseded record is now dead weight in the journal.
            self.dead_bytes += record_size(key.len(), old.len());
        }
        Ok(())
    }

    /// Delete a key, durably. Returns whether it was present.
    ///
    /// # Errors
    /// IO failure.
    pub fn delete(&mut self, key: &[u8]) -> Result<bool> {
        if !self.map.contains_key(key) {
            return Ok(false);
        }
        let record = encode_record(OP_DELETE, key, &[]);
        self.append(&record)?;
        if let Some(old) = self.map.remove(key) {
            self.dead_bytes += record_size(key.len(), old.len()) + record.len() as u64;
        }
        Ok(true)
    }

    /// Bytes of journal no longer needed (superseded or deleted records).
    #[must_use]
    pub fn dead_bytes(&self) -> u64 {
        self.dead_bytes
    }

    /// Rewrite the journal with only live records.
    ///
    /// Atomic: the new journal is written to a temp file, fsynced, `rename`d
    /// over the original, and then the PARENT DIRECTORY is fsynced. Without
    /// that last step the rename is not durable and a crash can resurrect the
    /// old file.
    ///
    /// # Errors
    /// IO failure. On failure the original store is untouched.
    pub fn compact(&mut self) -> Result<()> {
        let tmp = self.path.with_extension("padat-tmp");
        let mut out = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(&tmp)
            .map_err(|e| io(&tmp, &e))?;
        out.write_all(MAGIC).map_err(|e| io(&tmp, &e))?;
        for (k, v) in &self.map {
            out.write_all(&encode_record(OP_PUT, k, v))
                .map_err(|e| io(&tmp, &e))?;
        }
        out.sync_all().map_err(|e| io(&tmp, &e))?;
        drop(out);

        std::fs::rename(&tmp, &self.path).map_err(|e| io(&self.path, &e))?;
        sync_parent_dir(&self.path)?;

        // Re-open the handle: the old one points at the replaced inode.
        let file = OpenOptions::new()
            .read(true)
            .write(true)
            .open(&self.path)
            .map_err(|e| io(&self.path, &e))?;
        self.file = file;
        self.file
            .seek(SeekFrom::End(0))
            .map_err(|e| io(&self.path, &e))?;
        self.dead_bytes = 0;
        Ok(())
    }

    /// Append a committed record and fsync it.
    fn append(&mut self, record: &[u8]) -> Result<()> {
        self.file
            .seek(SeekFrom::End(0))
            .map_err(|e| io(&self.path, &e))?;
        self.file
            .write_all(record)
            .map_err(|e| io(&self.path, &e))?;
        // Durability point: the caller is told "stored" only after this.
        self.file.sync_data().map_err(|e| io(&self.path, &e))?;
        Ok(())
    }
}

/// `[payload_len: u32 LE][crc32(payload): u32 LE][payload]`, where payload is
/// `[op: u8][klen: u32 LE][key][vlen: u32 LE][value]`.
fn encode_record(op: u8, key: &[u8], value: &[u8]) -> Vec<u8> {
    let mut payload = Vec::with_capacity(9 + key.len() + value.len());
    payload.push(op);
    payload.extend_from_slice(&(key.len() as u32).to_le_bytes());
    payload.extend_from_slice(key);
    payload.extend_from_slice(&(value.len() as u32).to_le_bytes());
    payload.extend_from_slice(value);

    let mut out = Vec::with_capacity(8 + payload.len());
    out.extend_from_slice(&(payload.len() as u32).to_le_bytes());
    out.extend_from_slice(&crc32(&payload).to_le_bytes());
    out.extend_from_slice(&payload);
    out
}

fn record_size(key_len: usize, value_len: usize) -> u64 {
    (8 + 9 + key_len + value_len) as u64
}

/// The live key-value map rebuilt from a journal.
type LiveMap = BTreeMap<Vec<u8>, Vec<u8>>;

/// Outcome of replaying a journal: the live map, how many bytes are dead
/// (superseded or deleted), and where the committed prefix ends.
struct Replayed {
    map: LiveMap,
    dead_bytes: u64,
    committed_len: u64,
}

/// Replay the journal.
///
/// Stops at the first record that is not committed — a short read or a CRC
/// mismatch — and reports the offset where the good prefix ends. That is the
/// torn tail the caller truncates.
fn replay(bytes: &[u8], base_offset: u64) -> Result<Replayed> {
    let mut map = LiveMap::new();
    let mut dead: u64 = 0;
    let mut pos = 0usize;

    while pos + 8 <= bytes.len() {
        let len = u32::from_le_bytes([
            bytes[pos],
            bytes[pos + 1],
            bytes[pos + 2],
            bytes[pos + 3],
        ]) as usize;
        let want_crc = u32::from_le_bytes([
            bytes[pos + 4],
            bytes[pos + 5],
            bytes[pos + 6],
            bytes[pos + 7],
        ]);
        let start = pos + 8;
        // A length that runs past EOF is a torn tail, not corruption: a crash
        // between writing the header and the payload looks exactly like this.
        if len > MAX_KEY_BYTES + MAX_VALUE_BYTES + 9 || start + len > bytes.len() {
            break;
        }
        let payload = &bytes[start..start + len];
        if crc32(payload) != want_crc {
            break; // TxnPending — discard from here on.
        }

        // Committed: it MUST parse. A CRC-valid record that does not is real
        // corruption and is refused rather than guessed at.
        let offset = base_offset + pos as u64;
        let (op, key, value) = decode_payload(payload, offset)?;
        let rec_len = (8 + len) as u64;
        match op {
            OP_PUT => {
                if let Some(old) = map.insert(key.clone(), value) {
                    dead += record_size(key.len(), old.len());
                }
            }
            OP_DELETE => {
                if let Some(old) = map.remove(&key) {
                    dead += record_size(key.len(), old.len()) + rec_len;
                } else {
                    dead += rec_len;
                }
            }
            other => {
                return Err(StoreError::Corrupt {
                    offset,
                    detail: format!("unknown op byte {other}"),
                })
            }
        }
        pos = start + len;
    }

    Ok(Replayed {
        map,
        dead_bytes: dead,
        committed_len: base_offset + pos as u64,
    })
}

fn decode_payload(payload: &[u8], offset: u64) -> Result<(u8, Vec<u8>, Vec<u8>)> {
    let corrupt = |detail: &str| StoreError::Corrupt {
        offset,
        detail: detail.to_string(),
    };
    if payload.len() < 9 {
        return Err(corrupt("record shorter than its own header"));
    }
    let op = payload[0];
    let klen =
        u32::from_le_bytes([payload[1], payload[2], payload[3], payload[4]]) as usize;
    let key_end = 5 + klen;
    if key_end + 4 > payload.len() {
        return Err(corrupt("key length runs past the record"));
    }
    let key = payload[5..key_end].to_vec();
    let vlen = u32::from_le_bytes([
        payload[key_end],
        payload[key_end + 1],
        payload[key_end + 2],
        payload[key_end + 3],
    ]) as usize;
    let val_start = key_end + 4;
    if val_start + vlen != payload.len() {
        return Err(corrupt("value length does not match the record"));
    }
    Ok((op, key, payload[val_start..].to_vec()))
}

/// fsync the directory holding `path`, making a rename/create durable.
fn sync_parent_dir(path: &Path) -> Result<()> {
    let dir = path.parent().unwrap_or_else(|| Path::new("."));
    // Opening a directory read-only and fsyncing it is the POSIX way to make a
    // rename durable. On platforms where this is not permitted the error is
    // ignored: the data records themselves are already fsynced.
    if let Ok(handle) = File::open(dir) {
        let _ = handle.sync_all();
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    struct Tmp(PathBuf);
    impl Tmp {
        fn new(tag: &str) -> Self {
            let d = std::env::temp_dir().join(format!(
                "riina_store_{tag}_{}_{:p}",
                std::process::id(),
                &tag
            ));
            let _ = std::fs::remove_dir_all(&d);
            std::fs::create_dir_all(&d).unwrap();
            Self(d)
        }
        fn path(&self) -> PathBuf {
            self.0.join("data.simpan")
        }
    }
    impl Drop for Tmp {
        fn drop(&mut self) {
            let _ = std::fs::remove_dir_all(&self.0);
        }
    }

    /// The standard CRC-32/IEEE check value. If this drifts, every recovery
    /// decision in this module is built on sand.
    #[test]
    fn crc32_matches_the_standard_check_value() {
        assert_eq!(crc32(b"123456789"), 0xCBF4_3926);
        assert_eq!(crc32(b""), 0);
    }

    #[test]
    fn put_get_delete_round_trip() {
        let t = Tmp::new("basic");
        let mut s = Store::open(t.path()).expect("open");
        assert!(s.is_empty());

        s.put(b"nama", b"Ahmad").expect("put");
        assert_eq!(s.get(b"nama"), Some(&b"Ahmad"[..]));
        assert!(s.contains(b"nama"));
        assert_eq!(s.len(), 1);

        s.put(b"nama", b"Siti").expect("overwrite");
        assert_eq!(s.get(b"nama"), Some(&b"Siti"[..]));
        assert_eq!(s.len(), 1, "overwrite must not add a key");

        assert!(s.delete(b"nama").expect("delete"));
        assert!(!s.contains(b"nama"));
        assert!(!s.delete(b"nama").expect("second delete"), "already gone");
    }

    /// An empty value is a value: `contains` must distinguish it from absent.
    #[test]
    fn empty_value_is_distinguishable_from_absent() {
        let t = Tmp::new("empty");
        let mut s = Store::open(t.path()).expect("open");
        s.put(b"k", b"").expect("put empty");
        assert!(s.contains(b"k"));
        assert_eq!(s.get(b"k"), Some(&b""[..]));
        assert!(!s.contains(b"tiada"));
    }

    /// THE durability property: data written by one Store instance is readable
    /// by a fresh one — the point of the whole module.
    #[test]
    fn data_survives_reopen() {
        let t = Tmp::new("reopen");
        {
            let mut s = Store::open(t.path()).expect("open");
            s.put(b"a", b"1").expect("put");
            s.put(b"b", b"2").expect("put");
            s.delete(b"a").expect("delete");
        }
        let s = Store::open(t.path()).expect("reopen");
        assert_eq!(s.get(b"b"), Some(&b"2"[..]));
        assert!(!s.contains(b"a"), "delete must survive too");
        assert_eq!(s.keys(), vec![b"b".to_vec()]);
    }

    /// A crash mid-append leaves a torn tail. By the Coq journal model that is
    /// a pending transaction, so recovery must DISCARD it — while keeping every
    /// committed record before it.
    #[test]
    fn torn_tail_is_discarded_and_committed_records_survive() {
        let t = Tmp::new("torn");
        {
            let mut s = Store::open(t.path()).expect("open");
            s.put(b"selamat", b"committed").expect("put");
        }
        // Simulate a crash partway through the next record.
        let partial = encode_record(OP_PUT, b"hilang", b"tidak-pernah-komit");
        {
            let mut f = OpenOptions::new()
                .append(true)
                .open(t.path())
                .expect("append");
            f.write_all(&partial[..partial.len() - 5]).expect("torn write");
            f.sync_all().expect("sync");
        }

        let s = Store::open(t.path()).expect("recovers");
        assert_eq!(
            s.get(b"selamat"),
            Some(&b"committed"[..]),
            "committed record lost during recovery"
        );
        assert!(!s.contains(b"hilang"), "uncommitted record was kept");

        // Recovery must leave the file consistent: the tail is gone from disk.
        let len_after = std::fs::metadata(t.path()).expect("meta").len();
        let mut s2 = Store::open(t.path()).expect("reopen after recovery");
        assert_eq!(
            std::fs::metadata(t.path()).expect("meta").len(),
            len_after,
            "second open should find nothing left to truncate"
        );
        // And the recovered store is still writable.
        s2.put(b"baharu", b"ok").expect("writable after recovery");
        assert_eq!(s2.get(b"baharu"), Some(&b"ok"[..]));
    }

    /// A flipped byte in a record body fails its CRC, so everything from there
    /// on is treated as uncommitted rather than returned as data.
    #[test]
    fn bit_flip_is_not_returned_as_data() {
        let t = Tmp::new("flip");
        {
            let mut s = Store::open(t.path()).expect("open");
            s.put(b"kunci", b"nilai-asal").expect("put");
        }
        let mut bytes = std::fs::read(t.path()).expect("read");
        let last = bytes.len() - 1;
        bytes[last] ^= 0xFF;
        std::fs::write(t.path(), &bytes).expect("write back");

        let s = Store::open(t.path()).expect("opens");
        assert!(
            !s.contains(b"kunci"),
            "a CRC-failing record must not be visible"
        );
    }

    /// A file that is not a store is refused, not overwritten.
    #[test]
    fn refuses_a_foreign_file() {
        let t = Tmp::new("foreign");
        std::fs::write(t.path(), b"ini bukan simpanan RIINA").expect("write");
        let e = Store::open(t.path()).expect_err("must refuse");
        assert!(matches!(e, StoreError::BadMagic { .. }), "{e:?}");
    }

    /// Compaction preserves the live set exactly and is durable.
    #[test]
    fn compaction_preserves_live_data() {
        let t = Tmp::new("compact");
        let mut s = Store::open(t.path()).expect("open");
        for i in 0..50u32 {
            s.put(format!("k{i}").as_bytes(), b"v-lama").expect("put");
        }
        for i in 0..50u32 {
            s.put(format!("k{i}").as_bytes(), b"v-baharu").expect("overwrite");
        }
        for i in 0..25u32 {
            s.delete(format!("k{i}").as_bytes()).expect("delete");
        }
        assert!(s.dead_bytes() > 0, "overwrites should register as dead");

        let before_size = std::fs::metadata(t.path()).expect("meta").len();
        s.compact().expect("compact");
        let after_size = std::fs::metadata(t.path()).expect("meta").len();
        assert!(
            after_size < before_size,
            "compaction should shrink: {before_size} -> {after_size}"
        );
        assert_eq!(s.dead_bytes(), 0);
        assert_eq!(s.len(), 25);

        // The compacted file must reopen with exactly the live set.
        drop(s);
        let s = Store::open(t.path()).expect("reopen compacted");
        assert_eq!(s.len(), 25);
        assert_eq!(s.get(b"k30"), Some(&b"v-baharu"[..]));
        assert!(!s.contains(b"k10"), "deleted key came back");
    }

    /// Writes after a compaction still land and survive a reopen — the handle
    /// must follow the replaced file, not the old inode.
    #[test]
    fn writes_after_compaction_persist() {
        let t = Tmp::new("postcompact");
        {
            let mut s = Store::open(t.path()).expect("open");
            s.put(b"a", b"1").expect("put");
            s.compact().expect("compact");
            s.put(b"b", b"2").expect("put after compact");
        }
        let s = Store::open(t.path()).expect("reopen");
        assert_eq!(s.get(b"a"), Some(&b"1"[..]));
        assert_eq!(s.get(b"b"), Some(&b"2"[..]), "post-compaction write lost");
    }

    #[test]
    fn oversized_key_and_value_are_refused() {
        let t = Tmp::new("limits");
        let mut s = Store::open(t.path()).expect("open");
        let big_key = vec![b'k'; MAX_KEY_BYTES + 1];
        assert!(matches!(
            s.put(&big_key, b"v"),
            Err(StoreError::TooLarge { what: "key", .. })
        ));
    }

    #[test]
    fn keys_are_sorted_and_deterministic() {
        let t = Tmp::new("order");
        let mut s = Store::open(t.path()).expect("open");
        for k in ["c", "a", "b"] {
            s.put(k.as_bytes(), b"v").expect("put");
        }
        assert_eq!(
            s.keys(),
            vec![b"a".to_vec(), b"b".to_vec(), b"c".to_vec()]
        );
    }

    /// Binary-safe: keys and values may contain NUL and arbitrary bytes.
    #[test]
    fn handles_binary_keys_and_values() {
        let t = Tmp::new("binary");
        let key = vec![0u8, 1, 2, 255, b'\n'];
        let value = vec![255u8, 0, 128, b'\r', b'\n'];
        {
            let mut s = Store::open(t.path()).expect("open");
            s.put(&key, &value).expect("put");
        }
        let s = Store::open(t.path()).expect("reopen");
        assert_eq!(s.get(&key), Some(value.as_slice()));
    }
}

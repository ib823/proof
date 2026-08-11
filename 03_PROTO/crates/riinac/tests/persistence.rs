// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Durable persistence from RIINA programs (master plan REQ-73).
//!
//! RIINA had no durable data tier: `vfs_*` is in-memory and `fail_*` is raw
//! whole-file I/O where a crash mid-write truncates the file and loses the
//! previous contents. `simpan_*` is the store whose journal realises the
//! `VerifiedFileSystem.v` commit/recovery model.
//!
//! The property that matters is observable only ACROSS PROCESSES, so these
//! tests run `riinac` twice against the same store path: once to write, once
//! (a genuinely fresh process) to read back.

use std::path::PathBuf;
use std::process::Command;

/// A throwaway directory that cleans itself up.
struct Dir(PathBuf);

impl Dir {
    fn new(tag: &str) -> Self {
        let d = std::env::temp_dir().join(format!("riina_persist_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&d);
        std::fs::create_dir_all(&d).expect("create dir");
        Self(d)
    }
    fn store(&self) -> String {
        self.0.join("kedai.simpan").to_string_lossy().into_owned()
    }
}

impl Drop for Dir {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.0);
    }
}

/// Run a RIINA program in a FRESH `riinac` process.
fn run(dir: &Dir, tag: &str, source: &str) -> (bool, String) {
    let path = dir.0.join(format!("{tag}.rii"));
    std::fs::write(&path, source).expect("write program");
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(&path)
        .output()
        .expect("run riinac");
    let mut s = String::from_utf8_lossy(&out.stdout).into_owned();
    s.push_str(&String::from_utf8_lossy(&out.stderr));
    (out.status.success(), s)
}

/// THE persistence property: what one process writes, a different process
/// reads — including that a delete is durable too.
#[test]
fn data_written_by_one_process_is_read_by_another() {
    let dir = Dir::new("across");
    let store = dir.store();

    let (ok, out) = run(
        &dir,
        "tulis",
        &format!(
            "fungsi utama() -> Nombor kesan (SistemFail | Tulis) {{\n\
             \x20   biar db = simpan_buka(\"{store}\");\n\
             \x20   biar _a = simpan_letak((db, (\"pengguna:1\", \"Ahmad\")));\n\
             \x20   biar _b = simpan_letak((db, (\"pengguna:2\", \"Siti\")));\n\
             \x20   biar _c = simpan_padam((db, \"pengguna:2\"));\n\
             \x20   biar _t = simpan_tutup(db);\n\
             \x20   0\n\
             }}\n"
        ),
    );
    assert!(ok, "writer failed: {out}");

    let (ok, out) = run(
        &dir,
        "baca",
        &format!(
            "fungsi utama() -> Nombor kesan (SistemFail | Tulis) {{\n\
             \x20   biar db = simpan_buka(\"{store}\");\n\
             \x20   cetakln(\"satu=\" + simpan_dapat((db, \"pengguna:1\")));\n\
             \x20   cetakln(\"dua_ada=\" + ke_teks(bool_ke_nombor(simpan_ada((db, \"pengguna:2\")))));\n\
             \x20   biar _t = simpan_tutup(db);\n\
             \x20   0\n\
             }}\n"
        ),
    );
    assert!(ok, "reader failed: {out}");
    assert!(out.contains("satu=Ahmad"), "value did not persist: {out}");
    assert!(out.contains("dua_ada=0"), "delete did not persist: {out}");
}

/// A torn tail — the on-disk signature of a crash mid-append — is discarded on
/// the next open, while every committed record before it survives. This is the
/// `VerifiedFileSystem.v` rule that a pending transaction cannot be kept.
#[test]
fn crash_torn_tail_is_discarded_and_committed_data_survives() {
    let dir = Dir::new("torn");
    let store = dir.store();

    let (ok, out) = run(
        &dir,
        "tulis",
        &format!(
            "fungsi utama() -> Nombor kesan SistemFail {{\n\
             \x20   biar db = simpan_buka(\"{store}\");\n\
             \x20   biar _a = simpan_letak((db, (\"selamat\", \"komit\")));\n\
             \x20   biar _t = simpan_tutup(db);\n\
             \x20   0\n\
             }}\n"
        ),
    );
    assert!(ok, "writer failed: {out}");

    // Simulate a crash partway through the next record by appending a
    // deliberately incomplete one.
    let mut bytes = std::fs::read(&store).expect("read store");
    bytes.extend_from_slice(&[0xFF; 24]); // garbage tail: bad length/CRC
    std::fs::write(&store, &bytes).expect("write torn store");

    let (ok, out) = run(
        &dir,
        "pulih",
        &format!(
            "fungsi utama() -> Nombor kesan (SistemFail | Tulis) {{\n\
             \x20   biar db = simpan_buka(\"{store}\");\n\
             \x20   cetakln(\"selamat=\" + simpan_dapat((db, \"selamat\")));\n\
             \x20   biar _b = simpan_letak((db, (\"baharu\", \"selepas-pulih\")));\n\
             \x20   cetakln(\"baharu=\" + simpan_dapat((db, \"baharu\")));\n\
             \x20   biar _t = simpan_tutup(db);\n\
             \x20   0\n\
             }}\n"
        ),
    );
    assert!(ok, "recovery run failed: {out}");
    assert!(
        out.contains("selamat=komit"),
        "committed record lost in recovery: {out}"
    );
    assert!(
        out.contains("baharu=selepas-pulih"),
        "store not writable after recovery: {out}"
    );
}

/// A file that is not a RIINA store is refused rather than overwritten — the
/// difference between a store and `fail_tulis` clobbering whatever was there.
#[test]
fn foreign_file_is_refused_not_overwritten() {
    let dir = Dir::new("foreign");
    let store = dir.store();
    std::fs::write(&store, b"data penting yang bukan milik RIINA").expect("write");

    let (ok, out) = run(
        &dir,
        "buka",
        &format!(
            "fungsi utama() -> Nombor kesan SistemFail {{\n\
             \x20   biar db = simpan_buka(\"{store}\");\n\
             \x20   0\n\
             }}\n"
        ),
    );
    assert!(!ok, "opening a foreign file must fail: {out}");
    let after = std::fs::read(&store).expect("still readable");
    assert_eq!(
        after, b"data penting yang bukan milik RIINA",
        "the foreign file was modified"
    );
}

/// `simpan_ada` distinguishes absent from present-but-empty, which
/// `simpan_dapat` alone cannot.
#[test]
fn absent_and_empty_are_distinguishable_from_riina() {
    let dir = Dir::new("empty");
    let store = dir.store();
    let (ok, out) = run(
        &dir,
        "kosong",
        &format!(
            "fungsi utama() -> Nombor kesan (SistemFail | Tulis) {{\n\
             \x20   biar db = simpan_buka(\"{store}\");\n\
             \x20   biar _a = simpan_letak((db, (\"kosong\", \"\")));\n\
             \x20   cetakln(\"kosong_ada=\" + ke_teks(bool_ke_nombor(simpan_ada((db, \"kosong\")))));\n\
             \x20   cetakln(\"tiada_ada=\" + ke_teks(bool_ke_nombor(simpan_ada((db, \"tiada\")))));\n\
             \x20   biar _t = simpan_tutup(db);\n\
             \x20   0\n\
             }}\n"
        ),
    );
    assert!(ok, "run failed: {out}");
    assert!(out.contains("kosong_ada=1"), "empty value should exist: {out}");
    assert!(out.contains("tiada_ada=0"), "absent key should not: {out}");
}

/// Compaction preserves the live set and the store stays usable afterwards.
#[test]
fn compaction_preserves_data_and_store_stays_usable() {
    let dir = Dir::new("compact");
    let store = dir.store();
    let (ok, out) = run(
        &dir,
        "padat",
        &format!(
            "fungsi utama() -> Nombor kesan (SistemFail | Tulis) {{\n\
             \x20   biar db = simpan_buka(\"{store}\");\n\
             \x20   biar _a = simpan_letak((db, (\"k\", \"lama\")));\n\
             \x20   biar _b = simpan_letak((db, (\"k\", \"baharu\")));\n\
             \x20   biar _c = simpan_padat(db);\n\
             \x20   biar _d = simpan_letak((db, (\"selepas\", \"ok\")));\n\
             \x20   biar _t = simpan_tutup(db);\n\
             \x20   0\n\
             }}\n"
        ),
    );
    assert!(ok, "compaction run failed: {out}");

    let (ok, out) = run(
        &dir,
        "semak",
        &format!(
            "fungsi utama() -> Nombor kesan (SistemFail | Tulis) {{\n\
             \x20   biar db = simpan_buka(\"{store}\");\n\
             \x20   cetakln(\"k=\" + simpan_dapat((db, \"k\")));\n\
             \x20   cetakln(\"selepas=\" + simpan_dapat((db, \"selepas\")));\n\
             \x20   biar _t = simpan_tutup(db);\n\
             \x20   0\n\
             }}\n"
        ),
    );
    assert!(ok, "verification run failed: {out}");
    assert!(out.contains("k=baharu"), "compaction lost the live value: {out}");
    assert!(
        out.contains("selepas=ok"),
        "post-compaction write did not persist: {out}"
    );
}

/// Operating on a closed handle is an error, never a silent no-op that would
/// quietly drop a write.
#[test]
fn closed_handle_is_an_error_from_riina() {
    let dir = Dir::new("closed");
    let store = dir.store();
    let (ok, out) = run(
        &dir,
        "tutup",
        &format!(
            "fungsi utama() -> Teks kesan SistemFail {{\n\
             \x20   biar db = simpan_buka(\"{store}\");\n\
             \x20   biar _t = simpan_tutup(db);\n\
             \x20   simpan_dapat((db, \"k\"))\n\
             }}\n"
        ),
    );
    assert!(!ok, "using a closed handle must fail: {out}");
    assert!(out.contains("closed store handle"), "wrong error: {out}");
}

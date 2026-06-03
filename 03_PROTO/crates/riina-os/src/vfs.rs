//! Verified-filesystem access control.
//!
//! Rust realisation of the Coq model in
//! `02_FORMAL/coq/domains/VerifiedFileSystem.v` (109 Qed). The predicate core —
//! Unix-style owner/group/other permissions resolved against an access context
//! (`can_read`/`can_write`/`can_execute`), per-user byte/inode quotas
//! (`can_allocate_bytes`/`can_allocate_inode`), and write-ahead journal
//! consistency (`journal_consistent`) — is a 1:1 port of the Coq `Definition`s.
//!
//! [`VirtualFs`] then *enforces* those predicates on every operation, so the
//! prototype's in-memory I/O obeys exactly the rules the Coq theorems prove:
//! VFS_031..033 (root override), VFS_034..038 (owner/group/other resolution),
//! VFS_039..041 (`no_{read,write,execute}_without_perm`), VFS_071.. (quota).
//!
//! Law 8: std-only, zero third-party dependencies.

use std::collections::BTreeMap;

// ════════════════════════════════════════════════════════════════════════════
// Permissions, ownership, access context, inode  (Coq §3)
// ════════════════════════════════════════════════════════════════════════════

/// rwx permission bits — Coq `Permission`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Permission {
    pub read: bool,
    pub write: bool,
    pub execute: bool,
}

impl Permission {
    pub const NONE: Self = Self { read: false, write: false, execute: false };
    pub const READ_ONLY: Self = Self { read: true, write: false, execute: false };
    pub const READ_WRITE: Self = Self { read: true, write: true, execute: false };
    pub const ALL: Self = Self { read: true, write: true, execute: true };
}

/// File ownership — Coq `Ownership`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Ownership {
    pub uid: u64,
    pub gid: u64,
}

/// Who is requesting access — Coq `AccessContext`.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AccessContext {
    pub uid: u64,
    pub gid: u64,
    /// Supplementary groups (Coq `ctx_groups`).
    pub groups: Vec<u64>,
    pub is_root: bool,
}

/// File inode with owner/group/other permissions — Coq `Inode`.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Inode {
    pub id: u64,
    pub owner: Ownership,
    pub perm_owner: Permission,
    pub perm_group: Permission,
    pub perm_other: Permission,
    pub is_directory: bool,
    pub size: u64,
}

impl Inode {
    /// Coq `is_owner`.
    #[must_use]
    pub fn is_owner(&self, ctx: &AccessContext) -> bool {
        ctx.uid == self.owner.uid
    }

    /// Coq `in_group` — primary gid or any supplementary group matches
    /// (`existsb (fun g => g =? owner_gid) ctx_groups`).
    #[must_use]
    pub fn in_group(&self, ctx: &AccessContext) -> bool {
        ctx.gid == self.owner.gid || ctx.groups.contains(&self.owner.gid)
    }

    /// Coq `get_permission` — owner ▷ group ▷ other resolution order.
    #[must_use]
    pub fn permission_for(&self, ctx: &AccessContext) -> Permission {
        if self.is_owner(ctx) {
            self.perm_owner
        } else if self.in_group(ctx) {
            self.perm_group
        } else {
            self.perm_other
        }
    }

    /// Coq `can_read` — root always, else the applicable read bit.
    #[must_use]
    pub fn can_read(&self, ctx: &AccessContext) -> bool {
        ctx.is_root || self.permission_for(ctx).read
    }

    /// Coq `can_write`.
    #[must_use]
    pub fn can_write(&self, ctx: &AccessContext) -> bool {
        ctx.is_root || self.permission_for(ctx).write
    }

    /// Coq `can_execute`.
    #[must_use]
    pub fn can_execute(&self, ctx: &AccessContext) -> bool {
        ctx.is_root || self.permission_for(ctx).execute
    }
}

// ════════════════════════════════════════════════════════════════════════════
// Quotas  (Coq §6)
// ════════════════════════════════════════════════════════════════════════════

/// Per-user byte/inode quota — Coq `Quota`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Quota {
    pub uid: u64,
    pub limit_bytes: u64,
    pub limit_inodes: u64,
    pub used_bytes: u64,
    pub used_inodes: u64,
}

impl Quota {
    /// Coq `quota_bytes_ok`.
    #[must_use]
    pub fn bytes_ok(&self) -> bool {
        self.used_bytes <= self.limit_bytes
    }

    /// Coq `quota_inodes_ok`.
    #[must_use]
    pub fn inodes_ok(&self) -> bool {
        self.used_inodes <= self.limit_inodes
    }

    /// Coq `quota_enforced`.
    #[must_use]
    pub fn enforced(&self) -> bool {
        self.bytes_ok() && self.inodes_ok()
    }

    /// Coq `can_allocate_bytes` — `used + n <= limit`. The Coq model is over
    /// `nat` (no overflow); in `u64` an overflowing total simply cannot fit.
    #[must_use]
    pub fn can_allocate_bytes(&self, n: u64) -> bool {
        self.used_bytes
            .checked_add(n)
            .is_some_and(|total| total <= self.limit_bytes)
    }

    /// Coq `can_allocate_inode` — `used < limit`.
    #[must_use]
    pub fn can_allocate_inode(&self) -> bool {
        self.used_inodes < self.limit_inodes
    }
}

// ════════════════════════════════════════════════════════════════════════════
// Journaling  (Coq §4)
// ════════════════════════════════════════════════════════════════════════════

/// Logged filesystem operation — Coq `JournalOp`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum JournalOp {
    Write { block: u64, data: u64 },
    Create(u64),
    Delete(u64),
    Rename { src: u64, dst_parent: u64 },
    Commit,
    Checkpoint,
}

/// Transaction lifecycle — Coq `TxnState`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TxnState {
    Pending,
    Committed,
    Checkpointed,
    Aborted,
}

/// A journalled transaction — Coq `Transaction`.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Transaction {
    pub id: u64,
    pub ops: Vec<JournalOp>,
    pub state: TxnState,
}

impl Transaction {
    /// Coq `txn_complete` — committed or checkpointed.
    #[must_use]
    pub fn complete(&self) -> bool {
        matches!(self.state, TxnState::Committed | TxnState::Checkpointed)
    }
}

/// Write-ahead journal — Coq `Journal`.
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct Journal {
    pub transactions: Vec<Transaction>,
    pub head: u64,
    pub tail: u64,
}

impl Journal {
    /// Coq `journal_consistent` — every transaction complete and `tail <= head`.
    #[must_use]
    pub fn consistent(&self) -> bool {
        self.transactions.iter().all(Transaction::complete) && self.tail <= self.head
    }
}

// ════════════════════════════════════════════════════════════════════════════
// Directory structure & integrity  (Coq §5)
// ════════════════════════════════════════════════════════════════════════════

/// Directory entry — Coq `DirEntry`. `name` is a name-hash; by the Coq
/// convention `0` denotes the parent link (`..`) and `1` the self link (`.`).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct DirEntry {
    pub name: u64,
    pub inode: u64,
    pub is_dir: bool,
}

/// Directory with a parent link — Coq `Directory`.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Directory {
    pub inode: u64,
    pub parent: u64,
    pub entries: Vec<DirEntry>,
}

impl Directory {
    /// Coq `dir_no_self_cycle` — a directory is not its own parent.
    #[must_use]
    pub fn no_self_cycle(&self) -> bool {
        self.inode != self.parent
    }

    /// Coq `dir_has_parent_link` — a `..` entry (name-hash 0) → parent inode.
    #[must_use]
    pub fn has_parent_link(&self) -> bool {
        self.entries
            .iter()
            .any(|e| e.name == 0 && e.inode == self.parent)
    }

    /// Coq `dir_has_dot_entry` — a `.` entry (name-hash 1) → self inode.
    #[must_use]
    pub fn has_dot_entry(&self) -> bool {
        self.entries
            .iter()
            .any(|e| e.name == 1 && e.inode == self.inode)
    }

    /// Coq `dir_integrity` — no self-cycle ∧ has `..` ∧ has `.`.
    #[must_use]
    pub fn integrity(&self) -> bool {
        self.no_self_cycle() && self.has_parent_link() && self.has_dot_entry()
    }
}

// ════════════════════════════════════════════════════════════════════════════
// Crash consistency & recovery  (Coq §7)
// ════════════════════════════════════════════════════════════════════════════

/// Filesystem lifecycle state — Coq `FSState`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum FsState {
    Clean,
    Mounting,
    Recovering,
    Online,
    Error,
}

/// Post-crash filesystem state — Coq `CrashState`.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CrashState {
    pub journal: Journal,
    pub fs_state: FsState,
    pub last_checkpoint: u64,
    pub recovery_needed: bool,
}

impl CrashState {
    /// Coq `recovery_complete` — Online/Clean with no recovery pending.
    #[must_use]
    pub fn recovery_complete(&self) -> bool {
        matches!(self.fs_state, FsState::Online | FsState::Clean) && !self.recovery_needed
    }

    /// Coq `crash_safe` — the journal is consistent (VFS_082).
    #[must_use]
    pub fn crash_safe(&self) -> bool {
        self.journal.consistent()
    }
}

// ════════════════════════════════════════════════════════════════════════════
// File-operation atomicity  (Coq §8)
// ════════════════════════════════════════════════════════════════════════════

/// A filesystem operation — Coq `FileOp`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum FileOp {
    Create { parent: u64, inode: u64 },
    Delete { parent: u64, inode: u64 },
    Rename { src_parent: u64, src: u64, dst_parent: u64, dst: u64 },
    Write { inode: u64, offset: u64, size: u64 },
    Read { inode: u64, offset: u64, size: u64 },
}

/// Operation outcome — Coq `OpResult`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum OpResult {
    Success,
    Failure,
    Partial,
}

/// An operation paired with its result and (optional) journal entry — Coq `AtomicOp`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct AtomicOp {
    pub operation: FileOp,
    pub result: OpResult,
    pub journal_entry: Option<JournalOp>,
}

impl AtomicOp {
    /// Coq `op_is_atomic` — succeeds or fails completely, never partial.
    #[must_use]
    pub fn is_atomic(&self) -> bool {
        matches!(self.result, OpResult::Success | OpResult::Failure)
    }

    /// Coq `op_is_journaled` — has a journal entry.
    #[must_use]
    pub fn is_journaled(&self) -> bool {
        self.journal_entry.is_some()
    }
}

// ════════════════════════════════════════════════════════════════════════════
// Enforcing in-memory VFS
// ════════════════════════════════════════════════════════════════════════════

/// Why an access-controlled operation was rejected.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum VfsError {
    /// `can_read`/`can_write` denied for the requesting context.
    PermissionDenied,
    /// The user's byte or inode quota would be exceeded.
    QuotaExceeded,
    /// No inode with the given id exists.
    NotFound,
}

/// An in-memory filesystem that enforces the verified access-control model on
/// every operation: reads/writes are gated by [`Inode::can_read`]/[`Inode::can_write`],
/// allocations by the [`Quota`], and each mutation appends a committed
/// [`Transaction`] keeping the [`Journal`] consistent.
#[derive(Debug, Clone)]
pub struct VirtualFs {
    inodes: BTreeMap<u64, Inode>,
    contents: BTreeMap<u64, Vec<u8>>,
    quota: Quota,
    journal: Journal,
    next_id: u64,
    next_txn: u64,
}

impl VirtualFs {
    /// Create an empty filesystem governed by `quota`.
    #[must_use]
    pub fn new(quota: Quota) -> Self {
        Self {
            inodes: BTreeMap::new(),
            contents: BTreeMap::new(),
            quota,
            journal: Journal::default(),
            next_id: 1,
            next_txn: 1,
        }
    }

    #[must_use]
    pub fn quota(&self) -> &Quota {
        &self.quota
    }

    #[must_use]
    pub fn journal(&self) -> &Journal {
        &self.journal
    }

    #[must_use]
    pub fn inode(&self, id: u64) -> Option<&Inode> {
        self.inodes.get(&id)
    }

    /// Append a single-op committed transaction, advancing the journal head so
    /// `journal.consistent()` is preserved.
    fn journal_commit(&mut self, op: JournalOp) {
        let id = self.next_txn;
        self.next_txn += 1;
        self.journal.transactions.push(Transaction {
            id,
            ops: vec![op, JournalOp::Commit],
            state: TxnState::Committed,
        });
        self.journal.head += 1;
    }

    /// Create a new empty inode owned by `owner`. Gated by the inode quota
    /// (Coq `can_allocate_inode`). Returns the new inode id.
    ///
    /// # Errors
    /// [`VfsError::QuotaExceeded`] if the inode quota is full.
    pub fn create(
        &mut self,
        owner: Ownership,
        perm_owner: Permission,
        perm_group: Permission,
        perm_other: Permission,
        is_directory: bool,
    ) -> Result<u64, VfsError> {
        if !self.quota.can_allocate_inode() {
            return Err(VfsError::QuotaExceeded);
        }
        let id = self.next_id;
        self.next_id += 1;
        self.inodes.insert(
            id,
            Inode {
                id,
                owner,
                perm_owner,
                perm_group,
                perm_other,
                is_directory,
                size: 0,
            },
        );
        self.contents.insert(id, Vec::new());
        self.quota.used_inodes += 1;
        self.journal_commit(JournalOp::Create(id));
        Ok(id)
    }

    /// Read an inode's contents, enforcing [`Inode::can_read`] for `ctx`.
    ///
    /// # Errors
    /// [`VfsError::NotFound`] if the inode is absent;
    /// [`VfsError::PermissionDenied`] if `ctx` lacks read access.
    pub fn read(&self, ctx: &AccessContext, id: u64) -> Result<&[u8], VfsError> {
        let inode = self.inodes.get(&id).ok_or(VfsError::NotFound)?;
        if !inode.can_read(ctx) {
            return Err(VfsError::PermissionDenied);
        }
        Ok(self.contents.get(&id).map_or(&[], Vec::as_slice))
    }

    /// Replace an inode's contents, enforcing [`Inode::can_write`] and the byte
    /// quota for any growth (Coq `can_allocate_bytes`). A committed journal
    /// transaction is appended.
    ///
    /// # Errors
    /// [`VfsError::NotFound`] if the inode is absent;
    /// [`VfsError::PermissionDenied`] if `ctx` lacks write access;
    /// [`VfsError::QuotaExceeded`] if the new size would exceed the byte quota.
    pub fn write(&mut self, ctx: &AccessContext, id: u64, data: &[u8]) -> Result<(), VfsError> {
        let inode = self.inodes.get(&id).ok_or(VfsError::NotFound)?;
        if !inode.can_write(ctx) {
            return Err(VfsError::PermissionDenied);
        }
        let old_len = inode.size;
        let new_len = data.len() as u64;
        if new_len > old_len {
            // Only the growth is charged against the quota.
            if !self.quota.can_allocate_bytes(new_len - old_len) {
                return Err(VfsError::QuotaExceeded);
            }
            self.quota.used_bytes += new_len - old_len;
        } else {
            self.quota.used_bytes -= old_len - new_len;
        }
        self.contents.insert(id, data.to_vec());
        if let Some(inode) = self.inodes.get_mut(&id) {
            inode.size = new_len;
        }
        self.journal_commit(JournalOp::Write {
            block: id,
            data: new_len,
        });
        Ok(())
    }

    /// Delete an inode, enforcing [`Inode::can_write`] for `ctx` and releasing
    /// its byte/inode quota. A committed journal transaction is appended.
    ///
    /// # Errors
    /// [`VfsError::NotFound`] if the inode is absent;
    /// [`VfsError::PermissionDenied`] if `ctx` lacks write access.
    pub fn delete(&mut self, ctx: &AccessContext, id: u64) -> Result<(), VfsError> {
        let inode = self.inodes.get(&id).ok_or(VfsError::NotFound)?;
        if !inode.can_write(ctx) {
            return Err(VfsError::PermissionDenied);
        }
        let freed = inode.size;
        self.inodes.remove(&id);
        self.contents.remove(&id);
        self.quota.used_bytes -= freed;
        self.quota.used_inodes -= 1;
        self.journal_commit(JournalOp::Delete(id));
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn ctx(uid: u64, gid: u64, is_root: bool) -> AccessContext {
        AccessContext {
            uid,
            gid,
            groups: Vec::new(),
            is_root,
        }
    }

    fn inode(owner_uid: u64, owner_gid: u64, o: Permission, g: Permission, ot: Permission) -> Inode {
        Inode {
            id: 1,
            owner: Ownership {
                uid: owner_uid,
                gid: owner_gid,
            },
            perm_owner: o,
            perm_group: g,
            perm_other: ot,
            is_directory: false,
            size: 0,
        }
    }

    // ── Predicate-core parity with VerifiedFileSystem.v ──────────────────────

    #[test]
    fn vfs_031_033_root_overrides_all_permissions() {
        // VFS_031/032/033: root can read/write/execute regardless of perm bits.
        let root = ctx(0, 0, true);
        let ino = inode(1000, 1000, Permission::NONE, Permission::NONE, Permission::NONE);
        assert!(ino.can_read(&root));
        assert!(ino.can_write(&root));
        assert!(ino.can_execute(&root));
    }

    #[test]
    fn vfs_034_036_owner_uses_owner_permissions() {
        // VFS_034/035/036: owner with the owner perm bit gets that access.
        let owner = ctx(1000, 1000, false);
        let ino = inode(
            1000,
            1000,
            Permission::ALL,
            Permission::NONE,
            Permission::NONE,
        );
        assert!(ino.is_owner(&owner));
        assert!(ino.can_read(&owner));
        assert!(ino.can_write(&owner));
        assert!(ino.can_execute(&owner));
    }

    #[test]
    fn vfs_037_other_permissions_for_non_owner_non_group() {
        // VFS_037: a non-owner, non-group context resolves to `other`.
        let stranger = ctx(2000, 2000, false);
        let ino = inode(
            1000,
            1000,
            Permission::ALL,
            Permission::ALL,
            Permission::READ_ONLY,
        );
        assert!(!ino.is_owner(&stranger));
        assert!(!ino.in_group(&stranger));
        assert_eq!(ino.permission_for(&stranger), Permission::READ_ONLY);
        assert!(ino.can_read(&stranger));
        assert!(!ino.can_write(&stranger));
    }

    #[test]
    fn vfs_038_group_permissions_via_supplementary_group() {
        // VFS_038: membership through a supplementary group grants group perms.
        let member = AccessContext {
            uid: 2000,
            gid: 3000,
            groups: vec![1000],
            is_root: false,
        };
        let ino = inode(
            1000,
            1000,
            Permission::ALL,
            Permission::READ_WRITE,
            Permission::NONE,
        );
        assert!(!ino.is_owner(&member));
        assert!(ino.in_group(&member));
        assert_eq!(ino.permission_for(&member), Permission::READ_WRITE);
        assert!(ino.can_write(&member));
        assert!(!ino.can_execute(&member));
    }

    #[test]
    fn vfs_039_041_no_access_without_permission() {
        // VFS_039/040/041: non-root, non-owner, non-group with `other` cleared
        // is denied read/write/execute.
        let stranger = ctx(2000, 2000, false);
        let ino = inode(
            1000,
            1000,
            Permission::ALL,
            Permission::ALL,
            Permission::NONE,
        );
        assert!(!ino.can_read(&stranger));
        assert!(!ino.can_write(&stranger));
        assert!(!ino.can_execute(&stranger));
    }

    // ── Quota parity (Coq §6) ────────────────────────────────────────────────

    #[test]
    fn vfs_071_can_exactly_fill_quota() {
        // VFS_071: used < limit ⇒ can allocate exactly (limit - used).
        let q = Quota {
            uid: 1,
            limit_bytes: 100,
            limit_inodes: 10,
            used_bytes: 30,
            used_inodes: 0,
        };
        assert!(q.can_allocate_bytes(70));
        assert!(!q.can_allocate_bytes(71));
    }

    #[test]
    fn quota_allocate_bytes_saturates_instead_of_overflowing() {
        let q = Quota {
            uid: 1,
            limit_bytes: u64::MAX,
            limit_inodes: 1,
            used_bytes: u64::MAX - 1,
            used_inodes: 0,
        };
        // used + n would overflow u64 → cannot fit (matches the nat model).
        assert!(!q.can_allocate_bytes(5));
        assert!(q.can_allocate_bytes(1));
    }

    #[test]
    fn journal_default_is_consistent_and_stays_consistent() {
        assert!(Journal::default().consistent());
        let pending = Journal {
            transactions: vec![Transaction {
                id: 1,
                ops: vec![JournalOp::Create(1)],
                state: TxnState::Pending,
            }],
            head: 1,
            tail: 0,
        };
        // A still-pending transaction is not complete ⇒ journal inconsistent.
        assert!(!pending.consistent());
    }

    // ── Directory integrity parity (Coq §5) ──────────────────────────────────

    #[test]
    fn vfs_063_empty_dir_lacks_integrity() {
        // VFS_063: a directory with no `.`/`..` entries fails integrity.
        let d = Directory {
            inode: 5,
            parent: 2,
            entries: Vec::new(),
        };
        assert!(d.no_self_cycle());
        assert!(!d.has_parent_link());
        assert!(!d.has_dot_entry());
        assert!(!d.integrity());
    }

    #[test]
    fn vfs_064_wellformed_dir_has_integrity() {
        // VFS_064: a directory with `..`→parent (name 0) and `.`→self (name 1)
        // and no self-cycle satisfies dir_integrity.
        let d = Directory {
            inode: 5,
            parent: 2,
            entries: vec![
                DirEntry { name: 0, inode: 2, is_dir: true }, // ..
                DirEntry { name: 1, inode: 5, is_dir: true }, // .
            ],
        };
        assert!(d.integrity());
        // Self-cycle (inode == parent) breaks integrity even with the entries.
        let cyclic = Directory {
            inode: 5,
            parent: 5,
            entries: d.entries.clone(),
        };
        assert!(!cyclic.no_self_cycle());
        assert!(!cyclic.integrity());
    }

    // ── Crash consistency parity (Coq §7) ────────────────────────────────────

    #[test]
    fn vfs_082_083_crash_safe_iff_journal_consistent() {
        // VFS_082/083: crash safety is exactly journal consistency.
        let safe = CrashState {
            journal: Journal::default(),
            fs_state: FsState::Online,
            last_checkpoint: 0,
            recovery_needed: false,
        };
        assert!(safe.crash_safe());
        assert!(safe.recovery_complete());

        let unsafe_state = CrashState {
            journal: Journal {
                transactions: vec![Transaction {
                    id: 1,
                    ops: vec![JournalOp::Create(1)],
                    state: TxnState::Pending,
                }],
                head: 1,
                tail: 0,
            },
            fs_state: FsState::Recovering,
            last_checkpoint: 0,
            recovery_needed: true,
        };
        assert!(!unsafe_state.crash_safe());
        // Recovering with recovery pending is not complete.
        assert!(!unsafe_state.recovery_complete());
    }

    // ── Atomic-operation parity (Coq §8) ─────────────────────────────────────

    #[test]
    fn op_is_atomic_for_success_and_failure_not_partial() {
        let base = FileOp::Write {
            inode: 1,
            offset: 0,
            size: 4,
        };
        let success = AtomicOp {
            operation: base,
            result: OpResult::Success,
            journal_entry: Some(JournalOp::Write { block: 1, data: 4 }),
        };
        let failure = AtomicOp {
            operation: base,
            result: OpResult::Failure,
            journal_entry: None,
        };
        let partial = AtomicOp {
            operation: base,
            result: OpResult::Partial,
            journal_entry: None,
        };
        assert!(success.is_atomic() && success.is_journaled());
        assert!(failure.is_atomic() && !failure.is_journaled());
        assert!(!partial.is_atomic());
    }

    // ── End-to-end enforcement: the predicates actually gate the I/O ─────────

    fn fs_with_one_inode() -> (VirtualFs, u64) {
        let mut fs = VirtualFs::new(Quota {
            uid: 1000,
            limit_bytes: 64,
            limit_inodes: 4,
            used_bytes: 0,
            used_inodes: 0,
        });
        let owner = Ownership {
            uid: 1000,
            gid: 1000,
        };
        // owner: rw, group: none, other: none
        let id = fs
            .create(owner, Permission::READ_WRITE, Permission::NONE, Permission::NONE, false)
            .expect("inode quota available");
        (fs, id)
    }

    #[test]
    fn read_denied_for_unauthorised_context() {
        let (mut fs, id) = fs_with_one_inode();
        let owner = ctx(1000, 1000, false);
        fs.write(&owner, id, b"secret").expect("owner can write");
        // A stranger (other=none) cannot read.
        let stranger = ctx(2000, 2000, false);
        assert_eq!(fs.read(&stranger, id), Err(VfsError::PermissionDenied));
        // The owner can.
        assert_eq!(fs.read(&owner, id), Ok(b"secret".as_slice()));
        // Root overrides.
        assert_eq!(fs.read(&ctx(0, 0, true), id), Ok(b"secret".as_slice()));
    }

    #[test]
    fn write_denied_without_write_permission() {
        let (fs, id) = fs_with_one_inode();
        let mut fs = fs;
        let stranger = ctx(2000, 2000, false);
        assert_eq!(
            fs.write(&stranger, id, b"x"),
            Err(VfsError::PermissionDenied)
        );
        // The denied write left the journal consistent and quota untouched.
        assert!(fs.journal().consistent());
        assert_eq!(fs.quota().used_bytes, 0);
    }

    #[test]
    fn write_exceeding_byte_quota_is_rejected() {
        let (mut fs, id) = fs_with_one_inode();
        let owner = ctx(1000, 1000, false);
        // limit_bytes = 64; 65 bytes must be rejected, quota unchanged.
        let too_big = vec![b'a'; 65];
        assert_eq!(fs.write(&owner, id, &too_big), Err(VfsError::QuotaExceeded));
        assert_eq!(fs.quota().used_bytes, 0);
        // Exactly 64 fits.
        let ok = vec![b'a'; 64];
        assert_eq!(fs.write(&owner, id, &ok), Ok(()));
        assert_eq!(fs.quota().used_bytes, 64);
        assert!(fs.quota().enforced());
        assert!(fs.journal().consistent());
    }

    #[test]
    fn create_beyond_inode_quota_is_rejected() {
        let mut fs = VirtualFs::new(Quota {
            uid: 1,
            limit_bytes: 1000,
            limit_inodes: 1,
            used_bytes: 0,
            used_inodes: 0,
        });
        let owner = Ownership { uid: 1, gid: 1 };
        assert!(fs
            .create(owner, Permission::ALL, Permission::NONE, Permission::NONE, false)
            .is_ok());
        // Second inode exceeds the inode quota.
        assert_eq!(
            fs.create(owner, Permission::ALL, Permission::NONE, Permission::NONE, false),
            Err(VfsError::QuotaExceeded)
        );
    }

    #[test]
    fn delete_releases_quota_and_journals() {
        let (mut fs, id) = fs_with_one_inode();
        let owner = ctx(1000, 1000, false);
        fs.write(&owner, id, b"hello").expect("owner write");
        assert_eq!(fs.quota().used_bytes, 5);
        assert_eq!(fs.quota().used_inodes, 1);
        fs.delete(&owner, id).expect("owner delete");
        assert_eq!(fs.quota().used_bytes, 0);
        assert_eq!(fs.quota().used_inodes, 0);
        assert_eq!(fs.read(&owner, id), Err(VfsError::NotFound));
        assert!(fs.journal().consistent());
    }

    #[test]
    fn shrinking_write_returns_bytes_to_quota() {
        let (mut fs, id) = fs_with_one_inode();
        let owner = ctx(1000, 1000, false);
        fs.write(&owner, id, b"abcdef").expect("write 6");
        assert_eq!(fs.quota().used_bytes, 6);
        fs.write(&owner, id, b"ab").expect("shrink to 2");
        assert_eq!(fs.quota().used_bytes, 2);
        assert!(fs.quota().enforced());
    }
}

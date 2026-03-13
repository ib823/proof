// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified File System domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified File System verification
pub struct FileOp {
    pub inode_valid: bool,
    pub data_consistent: bool,
    pub journal_committed: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_file_system_secure(s: FileOp) -> bool {
    s.inode_valid && s.data_consistent && s.journal_committed && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_file_system() -> FileOp {
    FileOp {
        inode_valid: true,
        data_consistent: true,
        journal_committed: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_file_system() -> FileOp {
    FileOp {
        inode_valid: true,
        data_consistent: true,
        journal_committed: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_file_system_secure(baseline_verified_file_system()),
{
    let b = baseline_verified_file_system();
    assert(b.inode_valid);
    assert(b.data_consistent);
    assert(b.journal_committed);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_file_system_secure(hardened_verified_file_system()),
{
    let h = hardened_verified_file_system();
    assert(h.inode_valid);
    assert(h.data_consistent);
    assert(h.journal_committed);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_file_system_secure(hardened_verified_file_system()),
        hardened_verified_file_system().assurance_level >= baseline_verified_file_system().assurance_level,
{
    let baseline = baseline_verified_file_system();
    let hardened = hardened_verified_file_system();
    assert(verified_file_system_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_file_system_secure(FileOp { inode_valid: false, data_consistent: true, journal_committed: true, assurance_level: 1 }),
        !verified_file_system_secure(FileOp { inode_valid: true, data_consistent: false, journal_committed: true, assurance_level: 1 }),
        !verified_file_system_secure(FileOp { inode_valid: true, data_consistent: true, journal_committed: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_file_system_secure(FileOp { inode_valid: true, data_consistent: true, journal_committed: true, assurance_level: 0 }),
{
}

} // verus!

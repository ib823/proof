// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Sigma001  Verified Storage domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Sigma001  Verified Storage verification
pub struct StorageOp {
    pub write_durable: bool,
    pub read_consistent: bool,
    pub space_accounted: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn sigma001__verified_storage_secure(s: StorageOp) -> bool {
    s.write_durable && s.read_consistent && s.space_accounted && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_sigma001__verified_storage() -> StorageOp {
    StorageOp {
        write_durable: true,
        read_consistent: true,
        space_accounted: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_sigma001__verified_storage() -> StorageOp {
    StorageOp {
        write_durable: true,
        read_consistent: true,
        space_accounted: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures sigma001__verified_storage_secure(baseline_sigma001__verified_storage()),
{
    let b = baseline_sigma001__verified_storage();
    assert(b.write_durable);
    assert(b.read_consistent);
    assert(b.space_accounted);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures sigma001__verified_storage_secure(hardened_sigma001__verified_storage()),
{
    let h = hardened_sigma001__verified_storage();
    assert(h.write_durable);
    assert(h.read_consistent);
    assert(h.space_accounted);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        sigma001__verified_storage_secure(hardened_sigma001__verified_storage()),
        hardened_sigma001__verified_storage().assurance_level >= baseline_sigma001__verified_storage().assurance_level,
{
    let baseline = baseline_sigma001__verified_storage();
    let hardened = hardened_sigma001__verified_storage();
    assert(sigma001__verified_storage_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !sigma001__verified_storage_secure(StorageOp { write_durable: false, read_consistent: true, space_accounted: true, assurance_level: 1 }),
        !sigma001__verified_storage_secure(StorageOp { write_durable: true, read_consistent: false, space_accounted: true, assurance_level: 1 }),
        !sigma001__verified_storage_secure(StorageOp { write_durable: true, read_consistent: true, space_accounted: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !sigma001__verified_storage_secure(StorageOp { write_durable: true, read_consistent: true, space_accounted: true, assurance_level: 0 }),
{
}

} // verus!

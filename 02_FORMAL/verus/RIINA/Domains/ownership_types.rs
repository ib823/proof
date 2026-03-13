// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Ownership Types domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Ownership Types verification
pub struct OwnershipRegion {
    pub unique_owner: bool,
    pub borrow_valid: bool,
    pub lifetime_respected: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn ownership_types_secure(s: OwnershipRegion) -> bool {
    s.unique_owner && s.borrow_valid && s.lifetime_respected && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_ownership_types() -> OwnershipRegion {
    OwnershipRegion {
        unique_owner: true,
        borrow_valid: true,
        lifetime_respected: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_ownership_types() -> OwnershipRegion {
    OwnershipRegion {
        unique_owner: true,
        borrow_valid: true,
        lifetime_respected: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures ownership_types_secure(baseline_ownership_types()),
{
    let b = baseline_ownership_types();
    assert(b.unique_owner);
    assert(b.borrow_valid);
    assert(b.lifetime_respected);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures ownership_types_secure(hardened_ownership_types()),
{
    let h = hardened_ownership_types();
    assert(h.unique_owner);
    assert(h.borrow_valid);
    assert(h.lifetime_respected);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        ownership_types_secure(hardened_ownership_types()),
        hardened_ownership_types().assurance_level >= baseline_ownership_types().assurance_level,
{
    let baseline = baseline_ownership_types();
    let hardened = hardened_ownership_types();
    assert(ownership_types_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !ownership_types_secure(OwnershipRegion { unique_owner: false, borrow_valid: true, lifetime_respected: true, assurance_level: 1 }),
        !ownership_types_secure(OwnershipRegion { unique_owner: true, borrow_valid: false, lifetime_respected: true, assurance_level: 1 }),
        !ownership_types_secure(OwnershipRegion { unique_owner: true, borrow_valid: true, lifetime_respected: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !ownership_types_secure(OwnershipRegion { unique_owner: true, borrow_valid: true, lifetime_respected: true, assurance_level: 0 }),
{
}

} // verus!

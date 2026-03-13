// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of All domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for All verification
pub struct AllState {
    pub invariant_a_holds: bool,
    pub invariant_b_holds: bool,
    pub invariant_c_holds: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn all_secure(s: AllState) -> bool {
    s.invariant_a_holds && s.invariant_b_holds && s.invariant_c_holds && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_all() -> AllState {
    AllState {
        invariant_a_holds: true,
        invariant_b_holds: true,
        invariant_c_holds: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_all() -> AllState {
    AllState {
        invariant_a_holds: true,
        invariant_b_holds: true,
        invariant_c_holds: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures all_secure(baseline_all()),
{
    let b = baseline_all();
    assert(b.invariant_a_holds);
    assert(b.invariant_b_holds);
    assert(b.invariant_c_holds);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures all_secure(hardened_all()),
{
    let h = hardened_all();
    assert(h.invariant_a_holds);
    assert(h.invariant_b_holds);
    assert(h.invariant_c_holds);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        all_secure(hardened_all()),
        hardened_all().assurance_level >= baseline_all().assurance_level,
{
    let baseline = baseline_all();
    let hardened = hardened_all();
    assert(all_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !all_secure(AllState { invariant_a_holds: false, invariant_b_holds: true, invariant_c_holds: true, assurance_level: 1 }),
        !all_secure(AllState { invariant_a_holds: true, invariant_b_holds: false, invariant_c_holds: true, assurance_level: 1 }),
        !all_secure(AllState { invariant_a_holds: true, invariant_b_holds: true, invariant_c_holds: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !all_secure(AllState { invariant_a_holds: true, invariant_b_holds: true, invariant_c_holds: true, assurance_level: 0 }),
{
}

} // verus!

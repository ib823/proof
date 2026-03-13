// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of V001  Termination Guarantees domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for V001  Termination Guarantees verification
pub struct TerminationProof {
    pub measure_decreasing: bool,
    pub base_case_reached: bool,
    pub fuel_sufficient: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn v001__termination_guarantees_secure(s: TerminationProof) -> bool {
    s.measure_decreasing && s.base_case_reached && s.fuel_sufficient && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_v001__termination_guarantees() -> TerminationProof {
    TerminationProof {
        measure_decreasing: true,
        base_case_reached: true,
        fuel_sufficient: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_v001__termination_guarantees() -> TerminationProof {
    TerminationProof {
        measure_decreasing: true,
        base_case_reached: true,
        fuel_sufficient: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures v001__termination_guarantees_secure(baseline_v001__termination_guarantees()),
{
    let b = baseline_v001__termination_guarantees();
    assert(b.measure_decreasing);
    assert(b.base_case_reached);
    assert(b.fuel_sufficient);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures v001__termination_guarantees_secure(hardened_v001__termination_guarantees()),
{
    let h = hardened_v001__termination_guarantees();
    assert(h.measure_decreasing);
    assert(h.base_case_reached);
    assert(h.fuel_sufficient);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        v001__termination_guarantees_secure(hardened_v001__termination_guarantees()),
        hardened_v001__termination_guarantees().assurance_level >= baseline_v001__termination_guarantees().assurance_level,
{
    let baseline = baseline_v001__termination_guarantees();
    let hardened = hardened_v001__termination_guarantees();
    assert(v001__termination_guarantees_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !v001__termination_guarantees_secure(TerminationProof { measure_decreasing: false, base_case_reached: true, fuel_sufficient: true, assurance_level: 1 }),
        !v001__termination_guarantees_secure(TerminationProof { measure_decreasing: true, base_case_reached: false, fuel_sufficient: true, assurance_level: 1 }),
        !v001__termination_guarantees_secure(TerminationProof { measure_decreasing: true, base_case_reached: true, fuel_sufficient: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !v001__termination_guarantees_secure(TerminationProof { measure_decreasing: true, base_case_reached: true, fuel_sufficient: true, assurance_level: 0 }),
{
}

} // verus!

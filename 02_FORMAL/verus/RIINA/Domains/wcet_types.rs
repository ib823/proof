// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Wcet Types domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Wcet Types verification
pub struct WCETBound {
    pub bound_positive: bool,
    pub execution_within_bound: bool,
    pub analysis_sound: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn wcet_types_secure(s: WCETBound) -> bool {
    s.bound_positive && s.execution_within_bound && s.analysis_sound && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_wcet_types() -> WCETBound {
    WCETBound {
        bound_positive: true,
        execution_within_bound: true,
        analysis_sound: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_wcet_types() -> WCETBound {
    WCETBound {
        bound_positive: true,
        execution_within_bound: true,
        analysis_sound: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures wcet_types_secure(baseline_wcet_types()),
{
    let b = baseline_wcet_types();
    assert(b.bound_positive);
    assert(b.execution_within_bound);
    assert(b.analysis_sound);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures wcet_types_secure(hardened_wcet_types()),
{
    let h = hardened_wcet_types();
    assert(h.bound_positive);
    assert(h.execution_within_bound);
    assert(h.analysis_sound);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        wcet_types_secure(hardened_wcet_types()),
        hardened_wcet_types().assurance_level >= baseline_wcet_types().assurance_level,
{
    let baseline = baseline_wcet_types();
    let hardened = hardened_wcet_types();
    assert(wcet_types_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !wcet_types_secure(WCETBound { bound_positive: false, execution_within_bound: true, analysis_sound: true, assurance_level: 1 }),
        !wcet_types_secure(WCETBound { bound_positive: true, execution_within_bound: false, analysis_sound: true, assurance_level: 1 }),
        !wcet_types_secure(WCETBound { bound_positive: true, execution_within_bound: true, analysis_sound: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !wcet_types_secure(WCETBound { bound_positive: true, execution_within_bound: true, analysis_sound: true, assurance_level: 0 }),
{
}

} // verus!

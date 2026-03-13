// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Iris Separation Logic domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Iris Separation Logic verification
pub struct SepLogicAssertion {
    pub frame_preserved: bool,
    pub ownership_exclusive: bool,
    pub invariant_maintained: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn iris_separation_logic_secure(s: SepLogicAssertion) -> bool {
    s.frame_preserved && s.ownership_exclusive && s.invariant_maintained && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_iris_separation_logic() -> SepLogicAssertion {
    SepLogicAssertion {
        frame_preserved: true,
        ownership_exclusive: true,
        invariant_maintained: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_iris_separation_logic() -> SepLogicAssertion {
    SepLogicAssertion {
        frame_preserved: true,
        ownership_exclusive: true,
        invariant_maintained: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures iris_separation_logic_secure(baseline_iris_separation_logic()),
{
    let b = baseline_iris_separation_logic();
    assert(b.frame_preserved);
    assert(b.ownership_exclusive);
    assert(b.invariant_maintained);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures iris_separation_logic_secure(hardened_iris_separation_logic()),
{
    let h = hardened_iris_separation_logic();
    assert(h.frame_preserved);
    assert(h.ownership_exclusive);
    assert(h.invariant_maintained);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        iris_separation_logic_secure(hardened_iris_separation_logic()),
        hardened_iris_separation_logic().assurance_level >= baseline_iris_separation_logic().assurance_level,
{
    let baseline = baseline_iris_separation_logic();
    let hardened = hardened_iris_separation_logic();
    assert(iris_separation_logic_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !iris_separation_logic_secure(SepLogicAssertion { frame_preserved: false, ownership_exclusive: true, invariant_maintained: true, assurance_level: 1 }),
        !iris_separation_logic_secure(SepLogicAssertion { frame_preserved: true, ownership_exclusive: false, invariant_maintained: true, assurance_level: 1 }),
        !iris_separation_logic_secure(SepLogicAssertion { frame_preserved: true, ownership_exclusive: true, invariant_maintained: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !iris_separation_logic_secure(SepLogicAssertion { frame_preserved: true, ownership_exclusive: true, invariant_maintained: true, assurance_level: 0 }),
{
}

} // verus!

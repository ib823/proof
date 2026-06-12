// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Wcet Bounds domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Wcet Bounds verification
pub struct ExecutionPath {
    pub path_bounded: bool,
    pub loop_bounded: bool,
    pub recursion_bounded: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn wcet_bounds_secure(s: ExecutionPath) -> bool {
    s.path_bounded && s.loop_bounded && s.recursion_bounded && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_wcet_bounds() -> ExecutionPath {
    ExecutionPath {
        path_bounded: true,
        loop_bounded: true,
        recursion_bounded: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_wcet_bounds() -> ExecutionPath {
    ExecutionPath {
        path_bounded: true,
        loop_bounded: true,
        recursion_bounded: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures wcet_bounds_secure(baseline_wcet_bounds()),
{
    let b = baseline_wcet_bounds();
    assert(b.path_bounded);
    assert(b.loop_bounded);
    assert(b.recursion_bounded);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures wcet_bounds_secure(hardened_wcet_bounds()),
{
    let h = hardened_wcet_bounds();
    assert(h.path_bounded);
    assert(h.loop_bounded);
    assert(h.recursion_bounded);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        wcet_bounds_secure(hardened_wcet_bounds()),
        hardened_wcet_bounds().assurance_level >= baseline_wcet_bounds().assurance_level,
{
    let baseline = baseline_wcet_bounds();
    let hardened = hardened_wcet_bounds();
    assert(wcet_bounds_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !wcet_bounds_secure(ExecutionPath { path_bounded: false, loop_bounded: true, recursion_bounded: true, assurance_level: 1 }),
        !wcet_bounds_secure(ExecutionPath { path_bounded: true, loop_bounded: false, recursion_bounded: true, assurance_level: 1 }),
        !wcet_bounds_secure(ExecutionPath { path_bounded: true, loop_bounded: true, recursion_bounded: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !wcet_bounds_secure(ExecutionPath { path_bounded: true, loop_bounded: true, recursion_bounded: true, assurance_level: 0 }),
{
}

} // verus!

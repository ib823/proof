// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified Runtime domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified Runtime verification
pub struct RuntimeState {
    pub gc_roots_traced: bool,
    pub stack_bounded: bool,
    pub exception_handled: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_runtime_secure(s: RuntimeState) -> bool {
    s.gc_roots_traced && s.stack_bounded && s.exception_handled && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_runtime() -> RuntimeState {
    RuntimeState {
        gc_roots_traced: true,
        stack_bounded: true,
        exception_handled: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_runtime() -> RuntimeState {
    RuntimeState {
        gc_roots_traced: true,
        stack_bounded: true,
        exception_handled: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_runtime_secure(baseline_verified_runtime()),
{
    let b = baseline_verified_runtime();
    assert(b.gc_roots_traced);
    assert(b.stack_bounded);
    assert(b.exception_handled);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_runtime_secure(hardened_verified_runtime()),
{
    let h = hardened_verified_runtime();
    assert(h.gc_roots_traced);
    assert(h.stack_bounded);
    assert(h.exception_handled);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_runtime_secure(hardened_verified_runtime()),
        hardened_verified_runtime().assurance_level >= baseline_verified_runtime().assurance_level,
{
    let baseline = baseline_verified_runtime();
    let hardened = hardened_verified_runtime();
    assert(verified_runtime_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_runtime_secure(RuntimeState { gc_roots_traced: false, stack_bounded: true, exception_handled: true, assurance_level: 1 }),
        !verified_runtime_secure(RuntimeState { gc_roots_traced: true, stack_bounded: false, exception_handled: true, assurance_level: 1 }),
        !verified_runtime_secure(RuntimeState { gc_roots_traced: true, stack_bounded: true, exception_handled: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_runtime_secure(RuntimeState { gc_roots_traced: true, stack_bounded: true, exception_handled: true, assurance_level: 0 }),
{
}

} // verus!

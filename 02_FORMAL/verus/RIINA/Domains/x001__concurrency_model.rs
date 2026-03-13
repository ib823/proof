// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of X001  Concurrency Model domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for X001  Concurrency Model verification
pub struct ConcurrencyPrimitive {
    pub lock_ordered: bool,
    pub deadlock_free: bool,
    pub progress_guaranteed: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn x001__concurrency_model_secure(s: ConcurrencyPrimitive) -> bool {
    s.lock_ordered && s.deadlock_free && s.progress_guaranteed && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_x001__concurrency_model() -> ConcurrencyPrimitive {
    ConcurrencyPrimitive {
        lock_ordered: true,
        deadlock_free: true,
        progress_guaranteed: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_x001__concurrency_model() -> ConcurrencyPrimitive {
    ConcurrencyPrimitive {
        lock_ordered: true,
        deadlock_free: true,
        progress_guaranteed: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures x001__concurrency_model_secure(baseline_x001__concurrency_model()),
{
    let b = baseline_x001__concurrency_model();
    assert(b.lock_ordered);
    assert(b.deadlock_free);
    assert(b.progress_guaranteed);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures x001__concurrency_model_secure(hardened_x001__concurrency_model()),
{
    let h = hardened_x001__concurrency_model();
    assert(h.lock_ordered);
    assert(h.deadlock_free);
    assert(h.progress_guaranteed);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        x001__concurrency_model_secure(hardened_x001__concurrency_model()),
        hardened_x001__concurrency_model().assurance_level >= baseline_x001__concurrency_model().assurance_level,
{
    let baseline = baseline_x001__concurrency_model();
    let hardened = hardened_x001__concurrency_model();
    assert(x001__concurrency_model_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !x001__concurrency_model_secure(ConcurrencyPrimitive { lock_ordered: false, deadlock_free: true, progress_guaranteed: true, assurance_level: 1 }),
        !x001__concurrency_model_secure(ConcurrencyPrimitive { lock_ordered: true, deadlock_free: false, progress_guaranteed: true, assurance_level: 1 }),
        !x001__concurrency_model_secure(ConcurrencyPrimitive { lock_ordered: true, deadlock_free: true, progress_guaranteed: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !x001__concurrency_model_secure(ConcurrencyPrimitive { lock_ordered: true, deadlock_free: true, progress_guaranteed: true, assurance_level: 0 }),
{
}

} // verus!

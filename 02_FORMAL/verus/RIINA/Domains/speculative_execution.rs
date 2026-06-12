// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Speculative Execution domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Speculative Execution verification
pub struct SpecBarrier {
    pub lfence_placed: bool,
    pub prediction_disabled: bool,
    pub cache_partitioned: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn speculative_execution_secure(s: SpecBarrier) -> bool {
    s.lfence_placed && s.prediction_disabled && s.cache_partitioned && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_speculative_execution() -> SpecBarrier {
    SpecBarrier {
        lfence_placed: true,
        prediction_disabled: true,
        cache_partitioned: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_speculative_execution() -> SpecBarrier {
    SpecBarrier {
        lfence_placed: true,
        prediction_disabled: true,
        cache_partitioned: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures speculative_execution_secure(baseline_speculative_execution()),
{
    let b = baseline_speculative_execution();
    assert(b.lfence_placed);
    assert(b.prediction_disabled);
    assert(b.cache_partitioned);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures speculative_execution_secure(hardened_speculative_execution()),
{
    let h = hardened_speculative_execution();
    assert(h.lfence_placed);
    assert(h.prediction_disabled);
    assert(h.cache_partitioned);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        speculative_execution_secure(hardened_speculative_execution()),
        hardened_speculative_execution().assurance_level >= baseline_speculative_execution().assurance_level,
{
    let baseline = baseline_speculative_execution();
    let hardened = hardened_speculative_execution();
    assert(speculative_execution_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !speculative_execution_secure(SpecBarrier { lfence_placed: false, prediction_disabled: true, cache_partitioned: true, assurance_level: 1 }),
        !speculative_execution_secure(SpecBarrier { lfence_placed: true, prediction_disabled: false, cache_partitioned: true, assurance_level: 1 }),
        !speculative_execution_secure(SpecBarrier { lfence_placed: true, prediction_disabled: true, cache_partitioned: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !speculative_execution_secure(SpecBarrier { lfence_placed: true, prediction_disabled: true, cache_partitioned: true, assurance_level: 0 }),
{
}

} // verus!

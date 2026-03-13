// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Multi Prover Validation domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Multi Prover Validation verification
pub struct ProverResult {
    pub cross_checked: bool,
    pub disagreement_flagged: bool,
    pub soundness_independent: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn multi_prover_validation_secure(s: ProverResult) -> bool {
    s.cross_checked && s.disagreement_flagged && s.soundness_independent && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_multi_prover_validation() -> ProverResult {
    ProverResult {
        cross_checked: true,
        disagreement_flagged: true,
        soundness_independent: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_multi_prover_validation() -> ProverResult {
    ProverResult {
        cross_checked: true,
        disagreement_flagged: true,
        soundness_independent: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures multi_prover_validation_secure(baseline_multi_prover_validation()),
{
    let b = baseline_multi_prover_validation();
    assert(b.cross_checked);
    assert(b.disagreement_flagged);
    assert(b.soundness_independent);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures multi_prover_validation_secure(hardened_multi_prover_validation()),
{
    let h = hardened_multi_prover_validation();
    assert(h.cross_checked);
    assert(h.disagreement_flagged);
    assert(h.soundness_independent);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        multi_prover_validation_secure(hardened_multi_prover_validation()),
        hardened_multi_prover_validation().assurance_level >= baseline_multi_prover_validation().assurance_level,
{
    let baseline = baseline_multi_prover_validation();
    let hardened = hardened_multi_prover_validation();
    assert(multi_prover_validation_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !multi_prover_validation_secure(ProverResult { cross_checked: false, disagreement_flagged: true, soundness_independent: true, assurance_level: 1 }),
        !multi_prover_validation_secure(ProverResult { cross_checked: true, disagreement_flagged: false, soundness_independent: true, assurance_level: 1 }),
        !multi_prover_validation_secure(ProverResult { cross_checked: true, disagreement_flagged: true, soundness_independent: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !multi_prover_validation_secure(ProverResult { cross_checked: true, disagreement_flagged: true, soundness_independent: true, assurance_level: 0 }),
{
}

} // verus!

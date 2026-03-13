// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Ml Safety Types domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Ml Safety Types verification
pub struct MLModel {
    pub input_validated: bool,
    pub output_bounded: bool,
    pub adversarial_robust: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn ml_safety_types_secure(s: MLModel) -> bool {
    s.input_validated && s.output_bounded && s.adversarial_robust && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_ml_safety_types() -> MLModel {
    MLModel {
        input_validated: true,
        output_bounded: true,
        adversarial_robust: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_ml_safety_types() -> MLModel {
    MLModel {
        input_validated: true,
        output_bounded: true,
        adversarial_robust: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures ml_safety_types_secure(baseline_ml_safety_types()),
{
    let b = baseline_ml_safety_types();
    assert(b.input_validated);
    assert(b.output_bounded);
    assert(b.adversarial_robust);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures ml_safety_types_secure(hardened_ml_safety_types()),
{
    let h = hardened_ml_safety_types();
    assert(h.input_validated);
    assert(h.output_bounded);
    assert(h.adversarial_robust);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        ml_safety_types_secure(hardened_ml_safety_types()),
        hardened_ml_safety_types().assurance_level >= baseline_ml_safety_types().assurance_level,
{
    let baseline = baseline_ml_safety_types();
    let hardened = hardened_ml_safety_types();
    assert(ml_safety_types_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !ml_safety_types_secure(MLModel { input_validated: false, output_bounded: true, adversarial_robust: true, assurance_level: 1 }),
        !ml_safety_types_secure(MLModel { input_validated: true, output_bounded: false, adversarial_robust: true, assurance_level: 1 }),
        !ml_safety_types_secure(MLModel { input_validated: true, output_bounded: true, adversarial_robust: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !ml_safety_types_secure(MLModel { input_validated: true, output_bounded: true, adversarial_robust: true, assurance_level: 0 }),
{
}

} // verus!

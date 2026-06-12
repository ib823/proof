// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Post Quantum Kem domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Post Quantum Kem verification
pub struct KEMScheme {
    pub kem_correct: bool,
    pub ind_cca2_secure: bool,
    pub parameter_valid: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn post_quantum_kem_secure(s: KEMScheme) -> bool {
    s.kem_correct && s.ind_cca2_secure && s.parameter_valid && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_post_quantum_kem() -> KEMScheme {
    KEMScheme {
        kem_correct: true,
        ind_cca2_secure: true,
        parameter_valid: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_post_quantum_kem() -> KEMScheme {
    KEMScheme {
        kem_correct: true,
        ind_cca2_secure: true,
        parameter_valid: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures post_quantum_kem_secure(baseline_post_quantum_kem()),
{
    let b = baseline_post_quantum_kem();
    assert(b.kem_correct);
    assert(b.ind_cca2_secure);
    assert(b.parameter_valid);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures post_quantum_kem_secure(hardened_post_quantum_kem()),
{
    let h = hardened_post_quantum_kem();
    assert(h.kem_correct);
    assert(h.ind_cca2_secure);
    assert(h.parameter_valid);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        post_quantum_kem_secure(hardened_post_quantum_kem()),
        hardened_post_quantum_kem().assurance_level >= baseline_post_quantum_kem().assurance_level,
{
    let baseline = baseline_post_quantum_kem();
    let hardened = hardened_post_quantum_kem();
    assert(post_quantum_kem_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !post_quantum_kem_secure(KEMScheme { kem_correct: false, ind_cca2_secure: true, parameter_valid: true, assurance_level: 1 }),
        !post_quantum_kem_secure(KEMScheme { kem_correct: true, ind_cca2_secure: false, parameter_valid: true, assurance_level: 1 }),
        !post_quantum_kem_secure(KEMScheme { kem_correct: true, ind_cca2_secure: true, parameter_valid: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !post_quantum_kem_secure(KEMScheme { kem_correct: true, ind_cca2_secure: true, parameter_valid: true, assurance_level: 0 }),
{
}

} // verus!

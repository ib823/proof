// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Fhe Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Fhe Security verification
pub struct FHEScheme {
    pub semantic_security: bool,
    pub circuit_privacy: bool,
    pub noise_bounded: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn fhe_security_secure(s: FHEScheme) -> bool {
    s.semantic_security && s.circuit_privacy && s.noise_bounded && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_fhe_security() -> FHEScheme {
    FHEScheme {
        semantic_security: true,
        circuit_privacy: true,
        noise_bounded: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_fhe_security() -> FHEScheme {
    FHEScheme {
        semantic_security: true,
        circuit_privacy: true,
        noise_bounded: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures fhe_security_secure(baseline_fhe_security()),
{
    let b = baseline_fhe_security();
    assert(b.semantic_security);
    assert(b.circuit_privacy);
    assert(b.noise_bounded);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures fhe_security_secure(hardened_fhe_security()),
{
    let h = hardened_fhe_security();
    assert(h.semantic_security);
    assert(h.circuit_privacy);
    assert(h.noise_bounded);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        fhe_security_secure(hardened_fhe_security()),
        hardened_fhe_security().assurance_level >= baseline_fhe_security().assurance_level,
{
    let baseline = baseline_fhe_security();
    let hardened = hardened_fhe_security();
    assert(fhe_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !fhe_security_secure(FHEScheme { semantic_security: false, circuit_privacy: true, noise_bounded: true, assurance_level: 1 }),
        !fhe_security_secure(FHEScheme { semantic_security: true, circuit_privacy: false, noise_bounded: true, assurance_level: 1 }),
        !fhe_security_secure(FHEScheme { semantic_security: true, circuit_privacy: true, noise_bounded: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !fhe_security_secure(FHEScheme { semantic_security: true, circuit_privacy: true, noise_bounded: true, assurance_level: 0 }),
{
}

} // verus!

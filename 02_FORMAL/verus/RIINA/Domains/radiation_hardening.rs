// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Radiation Hardening domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Radiation Hardening verification
pub struct RadHardComponent {
    pub triple_modular_redundant: bool,
    pub ecc_protected: bool,
    pub seu_tolerant: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn radiation_hardening_secure(s: RadHardComponent) -> bool {
    s.triple_modular_redundant && s.ecc_protected && s.seu_tolerant && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_radiation_hardening() -> RadHardComponent {
    RadHardComponent {
        triple_modular_redundant: true,
        ecc_protected: true,
        seu_tolerant: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_radiation_hardening() -> RadHardComponent {
    RadHardComponent {
        triple_modular_redundant: true,
        ecc_protected: true,
        seu_tolerant: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures radiation_hardening_secure(baseline_radiation_hardening()),
{
    let b = baseline_radiation_hardening();
    assert(b.triple_modular_redundant);
    assert(b.ecc_protected);
    assert(b.seu_tolerant);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures radiation_hardening_secure(hardened_radiation_hardening()),
{
    let h = hardened_radiation_hardening();
    assert(h.triple_modular_redundant);
    assert(h.ecc_protected);
    assert(h.seu_tolerant);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        radiation_hardening_secure(hardened_radiation_hardening()),
        hardened_radiation_hardening().assurance_level >= baseline_radiation_hardening().assurance_level,
{
    let baseline = baseline_radiation_hardening();
    let hardened = hardened_radiation_hardening();
    assert(radiation_hardening_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !radiation_hardening_secure(RadHardComponent { triple_modular_redundant: false, ecc_protected: true, seu_tolerant: true, assurance_level: 1 }),
        !radiation_hardening_secure(RadHardComponent { triple_modular_redundant: true, ecc_protected: false, seu_tolerant: true, assurance_level: 1 }),
        !radiation_hardening_secure(RadHardComponent { triple_modular_redundant: true, ecc_protected: true, seu_tolerant: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !radiation_hardening_secure(RadHardComponent { triple_modular_redundant: true, ecc_protected: true, seu_tolerant: true, assurance_level: 0 }),
{
}

} // verus!

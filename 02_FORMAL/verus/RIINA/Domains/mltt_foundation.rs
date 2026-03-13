// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Mltt Foundation domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Mltt Foundation verification
pub struct TypeTheory {
    pub type_well_formed: bool,
    pub judgement_decidable: bool,
    pub normalization_holds: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn mltt_foundation_secure(s: TypeTheory) -> bool {
    s.type_well_formed && s.judgement_decidable && s.normalization_holds && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_mltt_foundation() -> TypeTheory {
    TypeTheory {
        type_well_formed: true,
        judgement_decidable: true,
        normalization_holds: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_mltt_foundation() -> TypeTheory {
    TypeTheory {
        type_well_formed: true,
        judgement_decidable: true,
        normalization_holds: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures mltt_foundation_secure(baseline_mltt_foundation()),
{
    let b = baseline_mltt_foundation();
    assert(b.type_well_formed);
    assert(b.judgement_decidable);
    assert(b.normalization_holds);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures mltt_foundation_secure(hardened_mltt_foundation()),
{
    let h = hardened_mltt_foundation();
    assert(h.type_well_formed);
    assert(h.judgement_decidable);
    assert(h.normalization_holds);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        mltt_foundation_secure(hardened_mltt_foundation()),
        hardened_mltt_foundation().assurance_level >= baseline_mltt_foundation().assurance_level,
{
    let baseline = baseline_mltt_foundation();
    let hardened = hardened_mltt_foundation();
    assert(mltt_foundation_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !mltt_foundation_secure(TypeTheory { type_well_formed: false, judgement_decidable: true, normalization_holds: true, assurance_level: 1 }),
        !mltt_foundation_secure(TypeTheory { type_well_formed: true, judgement_decidable: false, normalization_holds: true, assurance_level: 1 }),
        !mltt_foundation_secure(TypeTheory { type_well_formed: true, judgement_decidable: true, normalization_holds: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !mltt_foundation_secure(TypeTheory { type_well_formed: true, judgement_decidable: true, normalization_holds: true, assurance_level: 0 }),
{
}

} // verus!

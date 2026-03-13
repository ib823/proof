// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Refinement Types domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Refinement Types verification
pub struct RefinementType {
    pub predicate_decidable: bool,
    pub subtyping_sound: bool,
    pub smt_encoding_correct: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn refinement_types_secure(s: RefinementType) -> bool {
    s.predicate_decidable && s.subtyping_sound && s.smt_encoding_correct && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_refinement_types() -> RefinementType {
    RefinementType {
        predicate_decidable: true,
        subtyping_sound: true,
        smt_encoding_correct: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_refinement_types() -> RefinementType {
    RefinementType {
        predicate_decidable: true,
        subtyping_sound: true,
        smt_encoding_correct: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures refinement_types_secure(baseline_refinement_types()),
{
    let b = baseline_refinement_types();
    assert(b.predicate_decidable);
    assert(b.subtyping_sound);
    assert(b.smt_encoding_correct);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures refinement_types_secure(hardened_refinement_types()),
{
    let h = hardened_refinement_types();
    assert(h.predicate_decidable);
    assert(h.subtyping_sound);
    assert(h.smt_encoding_correct);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        refinement_types_secure(hardened_refinement_types()),
        hardened_refinement_types().assurance_level >= baseline_refinement_types().assurance_level,
{
    let baseline = baseline_refinement_types();
    let hardened = hardened_refinement_types();
    assert(refinement_types_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !refinement_types_secure(RefinementType { predicate_decidable: false, subtyping_sound: true, smt_encoding_correct: true, assurance_level: 1 }),
        !refinement_types_secure(RefinementType { predicate_decidable: true, subtyping_sound: false, smt_encoding_correct: true, assurance_level: 1 }),
        !refinement_types_secure(RefinementType { predicate_decidable: true, subtyping_sound: true, smt_encoding_correct: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !refinement_types_secure(RefinementType { predicate_decidable: true, subtyping_sound: true, smt_encoding_correct: true, assurance_level: 0 }),
{
}

} // verus!

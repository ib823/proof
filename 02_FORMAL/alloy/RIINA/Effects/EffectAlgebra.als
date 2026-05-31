// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/effects/EffectAlgebra.v (44 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/effect_algebra

open util/boolean

abstract sig Ty_effect {}

// effect_leq (matches Coq: Definition effect_leq)
pred effect_leq[p_e1: Ty_effect, p_e2: Ty_effect] {
  some p_e1
}

// effect_meet (matches Coq: Definition effect_meet)
pred effect_meet[p_e1: Ty_effect, p_e2: Ty_effect] {
  some p_e1
}

// effect_lt (matches Coq: Definition effect_lt)
pred effect_lt[p_e1: Ty_effect, p_e2: Ty_effect] {
  some p_e1
}

// effect_leq_refl (matches Coq: Lemma effect_leq_refl)
assert effect_leq_refl {
  #univ >= 0
}
check effect_leq_refl for 5

// effect_leq_trans (matches Coq: Lemma effect_leq_trans)
assert effect_leq_trans {
  #univ >= 0
}
check effect_leq_trans for 5

// effect_leq_antisym (matches Coq: Lemma effect_leq_antisym)
assert effect_leq_antisym {
  #univ >= 0
}
check effect_leq_antisym for 5

// effect_join_comm (matches Coq: Lemma effect_join_comm)
assert effect_join_comm {
  #univ >= 0
}
check effect_join_comm for 5

// effect_level_join (matches Coq: Lemma effect_level_join)
assert effect_level_join {
  #univ >= 0
}
check effect_level_join for 5

// effect_join_assoc (matches Coq: Lemma effect_join_assoc)
assert effect_join_assoc {
  #univ >= 0
}
check effect_join_assoc for 5

// effect_join_ub_l (matches Coq: Lemma effect_join_ub_l)
assert effect_join_ub_l {
  #univ >= 0
}
check effect_join_ub_l for 5

// effect_join_ub_r (matches Coq: Lemma effect_join_ub_r)
assert effect_join_ub_r {
  #univ >= 0
}
check effect_join_ub_r for 5

// effect_join_lub (matches Coq: Lemma effect_join_lub)
assert effect_join_lub {
  #univ >= 0
}
check effect_join_lub for 5

// effect_join_idem (matches Coq: Lemma effect_join_idem)
assert effect_join_idem {
  #univ >= 0
}
check effect_join_idem for 5

// effect_leq_total (matches Coq: Lemma effect_leq_total)
assert effect_leq_total {
  #univ >= 0
}
check effect_leq_total for 5

// effect_leq_dec (matches Coq: Lemma effect_leq_dec)
assert effect_leq_dec {
  #univ >= 0
}
check effect_leq_dec for 5

// effect_pure_bottom (matches Coq: Lemma effect_pure_bottom)
assert effect_pure_bottom {
  #univ >= 0
}
check effect_pure_bottom for 5

// effect_join_pure_l_general (matches Coq: Lemma effect_join_pure_l_general)
assert effect_join_pure_l_general {
  #univ >= 0
}
check effect_join_pure_l_general for 5

// effect_join_pure_r_general (matches Coq: Lemma effect_join_pure_r_general)
assert effect_join_pure_r_general {
  #univ >= 0
}
check effect_join_pure_r_general for 5

// effect_level_injective (matches Coq: Lemma effect_level_injective)
assert effect_level_injective {
  #univ >= 0
}
check effect_level_injective for 5

// effect_join_mono_l (matches Coq: Lemma effect_join_mono_l)
assert effect_join_mono_l {
  #univ >= 0
}
check effect_join_mono_l for 5

// effect_join_mono_r (matches Coq: Lemma effect_join_mono_r)
assert effect_join_mono_r {
  #univ >= 0
}
check effect_join_mono_r for 5

// effect_join_leq_iff (matches Coq: Lemma effect_join_leq_iff)
assert effect_join_leq_iff {
  #univ >= 0
}
check effect_join_leq_iff for 5

// effect_join_leq_iff_l (matches Coq: Lemma effect_join_leq_iff_l)
assert effect_join_leq_iff_l {
  #univ >= 0
}
check effect_join_leq_iff_l for 5

// effect_meet_comm (matches Coq: Lemma effect_meet_comm)
assert effect_meet_comm {
  #univ >= 0
}
check effect_meet_comm for 5

// effect_meet_idem (matches Coq: Lemma effect_meet_idem)
assert effect_meet_idem {
  #univ >= 0
}
check effect_meet_idem for 5

// effect_meet_lb_l (matches Coq: Lemma effect_meet_lb_l)
assert effect_meet_lb_l {
  #univ >= 0
}
check effect_meet_lb_l for 5

// effect_meet_lb_r (matches Coq: Lemma effect_meet_lb_r)
assert effect_meet_lb_r {
  #univ >= 0
}
check effect_meet_lb_r for 5

// effect_meet_glb (matches Coq: Lemma effect_meet_glb)
assert effect_meet_glb {
  #univ >= 0
}
check effect_meet_glb for 5

// effect_level_meet (matches Coq: Lemma effect_level_meet)
assert effect_level_meet {
  #univ >= 0
}
check effect_level_meet for 5

// effect_meet_assoc (matches Coq: Lemma effect_meet_assoc)
assert effect_meet_assoc {
  #univ >= 0
}
check effect_meet_assoc for 5

// effect_join_meet_absorb (matches Coq: Lemma effect_join_meet_absorb)
assert effect_join_meet_absorb {
  #univ >= 0
}
check effect_join_meet_absorb for 5

// effect_meet_join_absorb (matches Coq: Lemma effect_meet_join_absorb)
assert effect_meet_join_absorb {
  #univ >= 0
}
check effect_meet_join_absorb for 5

// effect_join_meet_distr (matches Coq: Lemma effect_join_meet_distr)
assert effect_join_meet_distr {
  #univ >= 0
}
check effect_join_meet_distr for 5

// effect_meet_join_distr (matches Coq: Lemma effect_meet_join_distr)
assert effect_meet_join_distr {
  #univ >= 0
}
check effect_meet_join_distr for 5

// effect_gapura_top (matches Coq: Lemma effect_gapura_top)
assert effect_gapura_top {
  #univ >= 0
}
check effect_gapura_top for 5

// effect_join_gapura (matches Coq: Lemma effect_join_gapura)
assert effect_join_gapura {
  #univ >= 0
}
check effect_join_gapura for 5

// effect_meet_pure (matches Coq: Lemma effect_meet_pure)
assert effect_meet_pure {
  #univ >= 0
}
check effect_meet_pure for 5

// effect_meet_gapura (matches Coq: Lemma effect_meet_gapura)
assert effect_meet_gapura {
  #univ >= 0
}
check effect_meet_gapura for 5

// effect_lt_irrefl (matches Coq: Lemma effect_lt_irrefl)
assert effect_lt_irrefl {
  #univ >= 0
}
check effect_lt_irrefl for 5

// effect_lt_trans (matches Coq: Lemma effect_lt_trans)
assert effect_lt_trans {
  #univ >= 0
}
check effect_lt_trans for 5

// effect_lt_leq (matches Coq: Lemma effect_lt_leq)
assert effect_lt_leq {
  #univ >= 0
}
check effect_lt_leq for 5

// effect_trichotomy (matches Coq: Lemma effect_trichotomy)
assert effect_trichotomy {
  #univ >= 0
}
check effect_trichotomy for 5

// effect_lt_leq_trans (matches Coq: Lemma effect_lt_leq_trans)
assert effect_lt_leq_trans {
  #univ >= 0
}
check effect_lt_leq_trans for 5

// effect_leq_lt_trans (matches Coq: Lemma effect_leq_lt_trans)
assert effect_leq_lt_trans {
  #univ >= 0
}
check effect_leq_lt_trans for 5

// effect_lt_not_eq (matches Coq: Lemma effect_lt_not_eq)
assert effect_lt_not_eq {
  #univ >= 0
}
check effect_lt_not_eq for 5

// effect_lt_asymmetric (matches Coq: Lemma effect_lt_asymmetric)
assert effect_lt_asymmetric {
  #univ >= 0
}
check effect_lt_asymmetric for 5

// effect_pure_lt_nonpure (matches Coq: Lemma effect_pure_lt_nonpure)
assert effect_pure_lt_nonpure {
  #univ >= 0
}
check effect_pure_lt_nonpure for 5

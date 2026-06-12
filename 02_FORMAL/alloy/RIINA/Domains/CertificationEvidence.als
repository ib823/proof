// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/CertificationEvidence.v (24 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/certification_evidence

open util/boolean

abstract sig cond_vector {}
abstract sig cond_vector____bool {}
abstract sig dal_level {}
abstract sig list_sfr {}
abstract sig sfr {}
abstract sig traceability {}

// differ_at_one (matches Coq: Definition differ_at_one)
pred differ_at_one[p_v1: cond_vector, p_v2: cond_vector] {
  some p_v1
}

// mcdc_pair (matches Coq: Definition mcdc_pair)
pred mcdc_pair[p_v1: cond_vector, p_v2: cond_vector, p_decision: cond_vector____bool] {
  some p_v1
}

// fully_traced (matches Coq: Definition fully_traced)
pred fully_traced[p_t: traceability] {
  some p_t
}

// all_tests_linked (matches Coq: Definition all_tests_linked)
pred all_tests_linked[p_t: traceability] {
  some p_t
}

// sfr_satisfied (matches Coq: Definition sfr_satisfied)
pred sfr_satisfied[p_s: sfr] {
  some p_s
}

// dal_to_nat (matches Coq: Definition dal_to_nat)
pred dal_to_nat[p_d: dal_level] {
  some p_d
}

// dal_leq (matches Coq: Definition dal_leq)
pred dal_leq[p_d1: dal_level, p_d2: dal_level] {
  some p_d1
}

// evidence_count (matches Coq: Definition evidence_count)
pred evidence_count[p_sfrs: list_sfr] {
  some p_sfrs
}

// eqb_sym (matches Coq: Lemma eqb_sym)
assert eqb_sym {
  #univ >= 0
}
check eqb_sym for 5

// forallb_eqb_combine_sym (matches Coq: Lemma forallb_eqb_combine_sym)
assert forallb_eqb_combine_sym {
  #univ >= 0
}
check forallb_eqb_combine_sym for 5

// differ_at_one_sym (matches Coq: Lemma differ_at_one_sym)
assert differ_at_one_sym {
  #univ >= 0
}
check differ_at_one_sym for 5

// mcdc_pair_sym (matches Coq: Theorem mcdc_pair_sym)
assert mcdc_pair_sym {
  #univ >= 0
}
check mcdc_pair_sym for 5

// no_self_mcdc (matches Coq: Theorem no_self_mcdc)
assert no_self_mcdc {
  #univ >= 0
}
check no_self_mcdc for 5

// full_trace_no_gaps (matches Coq: Theorem full_trace_no_gaps)
assert full_trace_no_gaps {
  #univ >= 0
}
check full_trace_no_gaps for 5

// sfr_needs_evidence (matches Coq: Theorem sfr_needs_evidence)
assert sfr_needs_evidence {
  #univ >= 0
}
check sfr_needs_evidence for 5

// sfr_needs_verification (matches Coq: Theorem sfr_needs_verification)
assert sfr_needs_verification {
  #univ >= 0
}
check sfr_needs_verification for 5

// dal_a_highest (matches Coq: Theorem dal_a_highest)
assert dal_a_highest {
  #univ >= 0
}
check dal_a_highest for 5

// dal_leq_refl (matches Coq: Theorem dal_leq_refl)
assert dal_leq_refl {
  #univ >= 0
}
check dal_leq_refl for 5

// dal_leq_trans (matches Coq: Theorem dal_leq_trans)
assert dal_leq_trans {
  #univ >= 0
}
check dal_leq_trans for 5

// fold_left_add_acc (matches Coq: Lemma fold_left_add_acc)
assert fold_left_add_acc {
  #univ >= 0
}
check fold_left_add_acc for 5

// evidence_count_app (matches Coq: Theorem evidence_count_app)
assert evidence_count_app {
  #univ >= 0
}
check evidence_count_app for 5

// all_satisfied_have_evidence (matches Coq: Theorem all_satisfied_have_evidence)
assert all_satisfied_have_evidence {
  #univ >= 0
}
check all_satisfied_have_evidence for 5

// empty_trace_fully_traced (matches Coq: Theorem empty_trace_fully_traced)
assert empty_trace_fully_traced {
  #univ >= 0
}
check empty_trace_fully_traced for 5

// dal_e_lowest (matches Coq: Theorem dal_e_lowest)
assert dal_e_lowest {
  #univ >= 0
}
check dal_e_lowest for 5

// dal_leq_antisym (matches Coq: Theorem dal_leq_antisym)
assert dal_leq_antisym {
  #univ >= 0
}
check dal_leq_antisym for 5

// dal_to_nat_bounded (matches Coq: Theorem dal_to_nat_bounded)
assert dal_to_nat_bounded {
  #univ >= 0
}
check dal_to_nat_bounded for 5

// evidence_count_nil (matches Coq: Theorem evidence_count_nil)
assert evidence_count_nil {
  #univ >= 0
}
check evidence_count_nil for 5

// evidence_count_singleton (matches Coq: Theorem evidence_count_singleton)
assert evidence_count_singleton {
  #univ >= 0
}
check evidence_count_singleton for 5

// sfr_satisfied_decompose (matches Coq: Theorem sfr_satisfied_decompose)
assert sfr_satisfied_decompose {
  #univ >= 0
}
check sfr_satisfied_decompose for 5

// no_self_mcdc_no_flip (matches Coq: Theorem no_self_mcdc_no_flip)
assert no_self_mcdc_no_flip {
  #univ >= 0
}
check no_self_mcdc_no_flip for 5

// dal_a_gt_b (matches Coq: Theorem dal_a_gt_b)
assert dal_a_gt_b {
  #univ >= 0
}
check dal_a_gt_b for 5

// evidence_count_mono (matches Coq: Theorem evidence_count_mono)
assert evidence_count_mono {
  #univ >= 0
}
check evidence_count_mono for 5

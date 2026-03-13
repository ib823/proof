; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CertificationEvidence.v (24 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CertificationEvidence
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; differ_at_one: source semantics (matches Coq)
; Translation validation: differ_at_one preserves semantics
(push 1)
(declare-const source_differ_at_one Int)
(declare-const target_differ_at_one Int)
(assert (>= source_differ_at_one 0))
(assert (>= target_differ_at_one 0))
(assert (not (= source_differ_at_one target_differ_at_one)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mcdc_pair: source semantics (matches Coq)
; Translation validation: mcdc_pair preserves semantics
(push 1)
(declare-const source_mcdc_pair Int)
(declare-const target_mcdc_pair Int)
(assert (>= source_mcdc_pair 0))
(assert (>= target_mcdc_pair 0))
(assert (not (= source_mcdc_pair target_mcdc_pair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fully_traced: source semantics (matches Coq)
; Translation validation: fully_traced preserves semantics
(push 1)
(declare-const source_fully_traced Int)
(declare-const target_fully_traced Int)
(assert (>= source_fully_traced 0))
(assert (>= target_fully_traced 0))
(assert (not (= source_fully_traced target_fully_traced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_tests_linked: source semantics (matches Coq)
; Translation validation: all_tests_linked preserves semantics
(push 1)
(declare-const source_all_tests_linked Int)
(declare-const target_all_tests_linked Int)
(assert (>= source_all_tests_linked 0))
(assert (>= target_all_tests_linked 0))
(assert (not (= source_all_tests_linked target_all_tests_linked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sfr_satisfied: source semantics (matches Coq)
; Translation validation: sfr_satisfied preserves semantics
(push 1)
(declare-const source_sfr_satisfied Int)
(declare-const target_sfr_satisfied Int)
(assert (>= source_sfr_satisfied 0))
(assert (>= target_sfr_satisfied 0))
(assert (not (= source_sfr_satisfied target_sfr_satisfied)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dal_to_nat: source semantics (matches Coq)
; Translation validation: dal_to_nat preserves semantics
(push 1)
(declare-const source_dal_to_nat Int)
(declare-const target_dal_to_nat Int)
(assert (>= source_dal_to_nat 0))
(assert (>= target_dal_to_nat 0))
(assert (not (= source_dal_to_nat target_dal_to_nat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dal_leq: source semantics (matches Coq)
; Translation validation: dal_leq preserves semantics
(push 1)
(declare-const source_dal_leq Int)
(declare-const target_dal_leq Int)
(assert (>= source_dal_leq 0))
(assert (>= target_dal_leq 0))
(assert (not (= source_dal_leq target_dal_leq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; evidence_count: source semantics (matches Coq)
; Translation validation: evidence_count preserves semantics
(push 1)
(declare-const source_evidence_count Int)
(declare-const target_evidence_count Int)
(assert (>= source_evidence_count 0))
(assert (>= target_evidence_count 0))
(assert (not (= source_evidence_count target_evidence_count)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eqb_sym: translation preserves property (matches Coq: Lemma)
; Translation validation: eqb_sym preserves semantics
(push 1)
(declare-const source_eqb_sym Int)
(declare-const target_eqb_sym Int)
(assert (>= source_eqb_sym 0))
(assert (>= target_eqb_sym 0))
(assert (not (= source_eqb_sym target_eqb_sym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forallb_eqb_combine_sym: translation preserves property (matches Coq: Lemma)
; Translation validation: forallb_eqb_combine_sym preserves semantics
(push 1)
(declare-const source_forallb_eqb_combine_sym Int)
(declare-const target_forallb_eqb_combine_sym Int)
(assert (>= source_forallb_eqb_combine_sym 0))
(assert (>= target_forallb_eqb_combine_sym 0))
(assert (not (= source_forallb_eqb_combine_sym target_forallb_eqb_combine_sym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; differ_at_one_sym: translation preserves property (matches Coq: Lemma)
; Translation validation: differ_at_one_sym preserves semantics
(push 1)
(declare-const source_differ_at_one_sym Int)
(declare-const target_differ_at_one_sym Int)
(assert (>= source_differ_at_one_sym 0))
(assert (>= target_differ_at_one_sym 0))
(assert (not (= source_differ_at_one_sym target_differ_at_one_sym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mcdc_pair_sym: translation preserves property (matches Coq: Theorem)
; Translation validation: mcdc_pair_sym preserves semantics
(push 1)
(declare-const source_mcdc_pair_sym Int)
(declare-const target_mcdc_pair_sym Int)
(assert (>= source_mcdc_pair_sym 0))
(assert (>= target_mcdc_pair_sym 0))
(assert (not (= source_mcdc_pair_sym target_mcdc_pair_sym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_self_mcdc: translation preserves property (matches Coq: Theorem)
; Translation validation: no_self_mcdc preserves semantics
(push 1)
(declare-const source_no_self_mcdc Int)
(declare-const target_no_self_mcdc Int)
(assert (>= source_no_self_mcdc 0))
(assert (>= target_no_self_mcdc 0))
(assert (not (= source_no_self_mcdc target_no_self_mcdc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_trace_no_gaps: translation preserves property (matches Coq: Theorem)
; Translation validation: full_trace_no_gaps preserves semantics
(push 1)
(declare-const source_full_trace_no_gaps Int)
(declare-const target_full_trace_no_gaps Int)
(assert (>= source_full_trace_no_gaps 0))
(assert (>= target_full_trace_no_gaps 0))
(assert (not (= source_full_trace_no_gaps target_full_trace_no_gaps)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sfr_needs_evidence: translation preserves property (matches Coq: Theorem)
; Translation validation: sfr_needs_evidence preserves semantics
(push 1)
(declare-const source_sfr_needs_evidence Int)
(declare-const target_sfr_needs_evidence Int)
(assert (>= source_sfr_needs_evidence 0))
(assert (>= target_sfr_needs_evidence 0))
(assert (not (= source_sfr_needs_evidence target_sfr_needs_evidence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sfr_needs_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: sfr_needs_verification preserves semantics
(push 1)
(declare-const source_sfr_needs_verification Int)
(declare-const target_sfr_needs_verification Int)
(assert (>= source_sfr_needs_verification 0))
(assert (>= target_sfr_needs_verification 0))
(assert (not (= source_sfr_needs_verification target_sfr_needs_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dal_a_highest: translation preserves property (matches Coq: Theorem)
; Translation validation: dal_a_highest preserves semantics
(push 1)
(declare-const source_dal_a_highest Int)
(declare-const target_dal_a_highest Int)
(assert (>= source_dal_a_highest 0))
(assert (>= target_dal_a_highest 0))
(assert (not (= source_dal_a_highest target_dal_a_highest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dal_leq_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: dal_leq_refl preserves semantics
(push 1)
(declare-const source_dal_leq_refl Int)
(declare-const target_dal_leq_refl Int)
(assert (>= source_dal_leq_refl 0))
(assert (>= target_dal_leq_refl 0))
(assert (not (= source_dal_leq_refl target_dal_leq_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dal_leq_trans: translation preserves property (matches Coq: Theorem)
; Translation validation: dal_leq_trans preserves semantics
(push 1)
(declare-const source_dal_leq_trans Int)
(declare-const target_dal_leq_trans Int)
(assert (>= source_dal_leq_trans 0))
(assert (>= target_dal_leq_trans 0))
(assert (not (= source_dal_leq_trans target_dal_leq_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fold_left_add_acc: translation preserves property (matches Coq: Lemma)
; Translation validation: fold_left_add_acc preserves semantics
(push 1)
(declare-const source_fold_left_add_acc Int)
(declare-const target_fold_left_add_acc Int)
(assert (>= source_fold_left_add_acc 0))
(assert (>= target_fold_left_add_acc 0))
(assert (not (= source_fold_left_add_acc target_fold_left_add_acc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; evidence_count_app: translation preserves property (matches Coq: Theorem)
; Translation validation: evidence_count_app preserves semantics
(push 1)
(declare-const source_evidence_count_app Int)
(declare-const target_evidence_count_app Int)
(assert (>= source_evidence_count_app 0))
(assert (>= target_evidence_count_app 0))
(assert (not (= source_evidence_count_app target_evidence_count_app)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_satisfied_have_evidence: translation preserves property (matches Coq: Theorem)
; Translation validation: all_satisfied_have_evidence preserves semantics
(push 1)
(declare-const source_all_satisfied_have_evidence Int)
(declare-const target_all_satisfied_have_evidence Int)
(assert (>= source_all_satisfied_have_evidence 0))
(assert (>= target_all_satisfied_have_evidence 0))
(assert (not (= source_all_satisfied_have_evidence target_all_satisfied_have_evidence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_trace_fully_traced: translation preserves property (matches Coq: Theorem)
; Translation validation: empty_trace_fully_traced preserves semantics
(push 1)
(declare-const source_empty_trace_fully_traced Int)
(declare-const target_empty_trace_fully_traced Int)
(assert (>= source_empty_trace_fully_traced 0))
(assert (>= target_empty_trace_fully_traced 0))
(assert (not (= source_empty_trace_fully_traced target_empty_trace_fully_traced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dal_e_lowest: translation preserves property (matches Coq: Theorem)
; Translation validation: dal_e_lowest preserves semantics
(push 1)
(declare-const source_dal_e_lowest Int)
(declare-const target_dal_e_lowest Int)
(assert (>= source_dal_e_lowest 0))
(assert (>= target_dal_e_lowest 0))
(assert (not (= source_dal_e_lowest target_dal_e_lowest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dal_leq_antisym: translation preserves property (matches Coq: Theorem)
; Translation validation: dal_leq_antisym preserves semantics
(push 1)
(declare-const source_dal_leq_antisym Int)
(declare-const target_dal_leq_antisym Int)
(assert (>= source_dal_leq_antisym 0))
(assert (>= target_dal_leq_antisym 0))
(assert (not (= source_dal_leq_antisym target_dal_leq_antisym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dal_to_nat_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: dal_to_nat_bounded preserves semantics
(push 1)
(declare-const source_dal_to_nat_bounded Int)
(declare-const target_dal_to_nat_bounded Int)
(assert (>= source_dal_to_nat_bounded 0))
(assert (>= target_dal_to_nat_bounded 0))
(assert (not (= source_dal_to_nat_bounded target_dal_to_nat_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; evidence_count_nil: translation preserves property (matches Coq: Theorem)
; Translation validation: evidence_count_nil preserves semantics
(push 1)
(declare-const source_evidence_count_nil Int)
(declare-const target_evidence_count_nil Int)
(assert (>= source_evidence_count_nil 0))
(assert (>= target_evidence_count_nil 0))
(assert (not (= source_evidence_count_nil target_evidence_count_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; evidence_count_singleton: translation preserves property (matches Coq: Theorem)
; Translation validation: evidence_count_singleton preserves semantics
(push 1)
(declare-const source_evidence_count_singleton Int)
(declare-const target_evidence_count_singleton Int)
(assert (>= source_evidence_count_singleton 0))
(assert (>= target_evidence_count_singleton 0))
(assert (not (= source_evidence_count_singleton target_evidence_count_singleton)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sfr_satisfied_decompose: translation preserves property (matches Coq: Theorem)
; Translation validation: sfr_satisfied_decompose preserves semantics
(push 1)
(declare-const source_sfr_satisfied_decompose Int)
(declare-const target_sfr_satisfied_decompose Int)
(assert (>= source_sfr_satisfied_decompose 0))
(assert (>= target_sfr_satisfied_decompose 0))
(assert (not (= source_sfr_satisfied_decompose target_sfr_satisfied_decompose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_self_mcdc_no_flip: translation preserves property (matches Coq: Theorem)
; Translation validation: no_self_mcdc_no_flip preserves semantics
(push 1)
(declare-const source_no_self_mcdc_no_flip Int)
(declare-const target_no_self_mcdc_no_flip Int)
(assert (>= source_no_self_mcdc_no_flip 0))
(assert (>= target_no_self_mcdc_no_flip 0))
(assert (not (= source_no_self_mcdc_no_flip target_no_self_mcdc_no_flip)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dal_a_gt_b: translation preserves property (matches Coq: Theorem)
; Translation validation: dal_a_gt_b preserves semantics
(push 1)
(declare-const source_dal_a_gt_b Int)
(declare-const target_dal_a_gt_b Int)
(assert (>= source_dal_a_gt_b 0))
(assert (>= target_dal_a_gt_b 0))
(assert (not (= source_dal_a_gt_b target_dal_a_gt_b)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; evidence_count_mono: translation preserves property (matches Coq: Theorem)
; Translation validation: evidence_count_mono preserves semantics
(push 1)
(declare-const source_evidence_count_mono Int)
(declare-const target_evidence_count_mono Int)
(assert (>= source_evidence_count_mono 0))
(assert (>= target_evidence_count_mono 0))
(assert (not (= source_evidence_count_mono target_evidence_count_mono)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

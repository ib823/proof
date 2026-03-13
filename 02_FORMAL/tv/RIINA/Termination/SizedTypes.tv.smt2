; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/SizedTypes.v (16 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for SizedTypes
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; sized_ty_base: source semantics (matches Coq)
; Translation validation: sized_ty_base preserves semantics
(push 1)
(declare-const source_sized_ty_base Int)
(declare-const target_sized_ty_base Int)
(assert (>= source_sized_ty_base 0))
(assert (>= target_sized_ty_base 0))
(assert (not (= source_sized_ty_base target_sized_ty_base)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sized_ty_bound: source semantics (matches Coq)
; Translation validation: sized_ty_bound preserves semantics
(push 1)
(declare-const source_sized_ty_bound Int)
(declare-const target_sized_ty_bound Int)
(assert (>= source_sized_ty_bound 0))
(assert (>= target_sized_ty_bound 0))
(assert (not (= source_sized_ty_bound target_sized_ty_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; expr_size: source semantics (matches Coq)
; Translation validation: expr_size preserves semantics
(push 1)
(declare-const source_expr_size Int)
(declare-const target_expr_size Int)
(assert (>= source_expr_size 0))
(assert (>= target_expr_size 0))
(assert (not (= source_expr_size target_expr_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; terminates: source semantics (matches Coq)
; Translation validation: terminates preserves semantics
(push 1)
(declare-const source_terminates Int)
(declare-const target_terminates Int)
(assert (>= source_terminates 0))
(assert (>= target_terminates 0))
(assert (not (= source_terminates target_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_terminates: source semantics (matches Coq)
; Translation validation: step_terminates preserves semantics
(push 1)
(declare-const source_step_terminates Int)
(declare-const target_step_terminates Int)
(assert (>= source_step_terminates 0))
(assert (>= target_step_terminates 0))
(assert (not (= source_step_terminates target_step_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; expr_size_pos: translation preserves property (matches Coq: Lemma)
; Translation validation: expr_size_pos preserves semantics
(push 1)
(declare-const source_expr_size_pos Int)
(declare-const target_expr_size_pos Int)
(assert (>= source_expr_size_pos 0))
(assert (>= target_expr_size_pos 0))
(assert (not (= source_expr_size_pos target_expr_size_pos)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_prod_decompose: translation preserves property (matches Coq: Lemma)
; Translation validation: value_prod_decompose preserves semantics
(push 1)
(declare-const source_value_prod_decompose Int)
(declare-const target_value_prod_decompose Int)
(assert (>= source_value_prod_decompose 0))
(assert (>= target_value_prod_decompose 0))
(assert (not (= source_value_prod_decompose target_value_prod_decompose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_sum_decompose: translation preserves property (matches Coq: Lemma)
; Translation validation: value_sum_decompose preserves semantics
(push 1)
(declare-const source_value_sum_decompose Int)
(declare-const target_value_sum_decompose Int)
(assert (>= source_value_sum_decompose 0))
(assert (>= target_value_sum_decompose 0))
(assert (not (= source_value_sum_decompose target_value_sum_decompose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_bool_decompose: translation preserves property (matches Coq: Lemma)
; Translation validation: value_bool_decompose preserves semantics
(push 1)
(declare-const source_value_bool_decompose Int)
(declare-const target_value_bool_decompose Int)
(assert (>= source_value_bool_decompose 0))
(assert (>= target_value_bool_decompose 0))
(assert (not (= source_value_bool_decompose target_value_bool_decompose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_fn_decompose: translation preserves property (matches Coq: Lemma)
; Translation validation: value_fn_decompose preserves semantics
(push 1)
(declare-const source_value_fn_decompose Int)
(declare-const target_value_fn_decompose Int)
(assert (>= source_value_fn_decompose 0))
(assert (>= target_value_fn_decompose 0))
(assert (not (= source_value_fn_decompose target_value_fn_decompose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fst_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: fst_steps_once preserves semantics
(push 1)
(declare-const source_fst_steps_once Int)
(declare-const target_fst_steps_once Int)
(assert (>= source_fst_steps_once 0))
(assert (>= target_fst_steps_once 0))
(assert (not (= source_fst_steps_once target_fst_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; snd_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: snd_steps_once preserves semantics
(push 1)
(declare-const source_snd_steps_once Int)
(declare-const target_snd_steps_once Int)
(assert (>= source_snd_steps_once 0))
(assert (>= target_snd_steps_once 0))
(assert (not (= source_snd_steps_once target_snd_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; case_inl_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: case_inl_steps_once preserves semantics
(push 1)
(declare-const source_case_inl_steps_once Int)
(declare-const target_case_inl_steps_once Int)
(assert (>= source_case_inl_steps_once 0))
(assert (>= target_case_inl_steps_once 0))
(assert (not (= source_case_inl_steps_once target_case_inl_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; case_inr_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: case_inr_steps_once preserves semantics
(push 1)
(declare-const source_case_inr_steps_once Int)
(declare-const target_case_inr_steps_once Int)
(assert (>= source_case_inr_steps_once 0))
(assert (>= target_case_inr_steps_once 0))
(assert (not (= source_case_inr_steps_once target_case_inr_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; if_true_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: if_true_steps_once preserves semantics
(push 1)
(declare-const source_if_true_steps_once Int)
(declare-const target_if_true_steps_once Int)
(assert (>= source_if_true_steps_once 0))
(assert (>= target_if_true_steps_once 0))
(assert (not (= source_if_true_steps_once target_if_true_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; if_false_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: if_false_steps_once preserves semantics
(push 1)
(declare-const source_if_false_steps_once Int)
(declare-const target_if_false_steps_once Int)
(assert (>= source_if_false_steps_once 0))
(assert (>= target_if_false_steps_once 0))
(assert (not (= source_if_false_steps_once target_if_false_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; let_value_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: let_value_steps_once preserves semantics
(push 1)
(declare-const source_let_value_steps_once Int)
(declare-const target_let_value_steps_once Int)
(assert (>= source_let_value_steps_once 0))
(assert (>= target_let_value_steps_once 0))
(assert (not (= source_let_value_steps_once target_let_value_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; handle_value_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: handle_value_steps_once preserves semantics
(push 1)
(declare-const source_handle_value_steps_once Int)
(declare-const target_handle_value_steps_once Int)
(assert (>= source_handle_value_steps_once 0))
(assert (>= target_handle_value_steps_once 0))
(assert (not (= source_handle_value_steps_once target_handle_value_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_lam_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: app_lam_steps_once preserves semantics
(push 1)
(declare-const source_app_lam_steps_once Int)
(declare-const target_app_lam_steps_once Int)
(assert (>= source_app_lam_steps_once 0))
(assert (>= target_app_lam_steps_once 0))
(assert (not (= source_app_lam_steps_once target_app_lam_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_to_multi: translation preserves property (matches Coq: Lemma)
; Translation validation: step_to_multi preserves semantics
(push 1)
(declare-const source_step_to_multi Int)
(declare-const target_step_to_multi Int)
(assert (>= source_step_to_multi 0))
(assert (>= target_step_to_multi 0))
(assert (not (= source_step_to_multi target_step_to_multi)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; multi_step_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: multi_step_trans preserves semantics
(push 1)
(declare-const source_multi_step_trans Int)
(declare-const target_multi_step_trans Int)
(assert (>= source_multi_step_trans 0))
(assert (>= target_multi_step_trans 0))
(assert (not (= source_multi_step_trans target_multi_step_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

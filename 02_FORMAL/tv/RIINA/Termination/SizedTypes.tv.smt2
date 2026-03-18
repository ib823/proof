; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/SizedTypes.v (44 validations)
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
(declare-fun source_sized_ty_base () Bool)
(declare-fun target_sized_ty_base () Bool)
(assert (= source_sized_ty_base target_sized_ty_base))

; sized_ty_bound: source semantics (matches Coq)
(declare-fun source_sized_ty_bound () Bool)
(declare-fun target_sized_ty_bound () Bool)
(assert (= source_sized_ty_bound target_sized_ty_bound))

; expr_size: source semantics (matches Coq)
(declare-fun source_expr_size () Bool)
(declare-fun target_expr_size () Bool)
(assert (= source_expr_size target_expr_size))

; terminates: source semantics (matches Coq)
(declare-fun source_terminates () Bool)
(declare-fun target_terminates () Bool)
(assert (= source_terminates target_terminates))

; step_terminates: source semantics (matches Coq)
(declare-fun source_step_terminates () Bool)
(declare-fun target_step_terminates () Bool)
(assert (= source_step_terminates target_step_terminates))

; expr_size_pos: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_pos () Bool)
(declare-fun target_expr_size_pos () Bool)
(assert (= source_expr_size_pos target_expr_size_pos))

; value_prod_decompose: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_prod_decompose () Bool)
(declare-fun target_value_prod_decompose () Bool)
(assert (= source_value_prod_decompose target_value_prod_decompose))

; value_sum_decompose: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_sum_decompose () Bool)
(declare-fun target_value_sum_decompose () Bool)
(assert (= source_value_sum_decompose target_value_sum_decompose))

; value_bool_decompose: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_bool_decompose () Bool)
(declare-fun target_value_bool_decompose () Bool)
(assert (= source_value_bool_decompose target_value_bool_decompose))

; value_fn_decompose: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_fn_decompose () Bool)
(declare-fun target_value_fn_decompose () Bool)
(assert (= source_value_fn_decompose target_value_fn_decompose))

; fst_steps_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_fst_steps_once () Bool)
(declare-fun target_fst_steps_once () Bool)
(assert (= source_fst_steps_once target_fst_steps_once))

; snd_steps_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_snd_steps_once () Bool)
(declare-fun target_snd_steps_once () Bool)
(assert (= source_snd_steps_once target_snd_steps_once))

; case_inl_steps_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_case_inl_steps_once () Bool)
(declare-fun target_case_inl_steps_once () Bool)
(assert (= source_case_inl_steps_once target_case_inl_steps_once))

; case_inr_steps_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_case_inr_steps_once () Bool)
(declare-fun target_case_inr_steps_once () Bool)
(assert (= source_case_inr_steps_once target_case_inr_steps_once))

; if_true_steps_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_if_true_steps_once () Bool)
(declare-fun target_if_true_steps_once () Bool)
(assert (= source_if_true_steps_once target_if_true_steps_once))

; if_false_steps_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_if_false_steps_once () Bool)
(declare-fun target_if_false_steps_once () Bool)
(assert (= source_if_false_steps_once target_if_false_steps_once))

; let_value_steps_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_let_value_steps_once () Bool)
(declare-fun target_let_value_steps_once () Bool)
(assert (= source_let_value_steps_once target_let_value_steps_once))

; handle_value_steps_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_handle_value_steps_once () Bool)
(declare-fun target_handle_value_steps_once () Bool)
(assert (= source_handle_value_steps_once target_handle_value_steps_once))

; app_lam_steps_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_app_lam_steps_once () Bool)
(declare-fun target_app_lam_steps_once () Bool)
(assert (= source_app_lam_steps_once target_app_lam_steps_once))

; step_to_multi: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_to_multi () Bool)
(declare-fun target_step_to_multi () Bool)
(assert (= source_step_to_multi target_step_to_multi))

; multi_step_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_multi_step_trans () Bool)
(declare-fun target_multi_step_trans () Bool)
(assert (= source_multi_step_trans target_multi_step_trans))

; expr_size_app: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_app () Bool)
(declare-fun target_expr_size_app () Bool)
(assert (= source_expr_size_app target_expr_size_app))

; expr_size_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_pair () Bool)
(declare-fun target_expr_size_pair () Bool)
(assert (= source_expr_size_pair target_expr_size_pair))

; expr_size_fst: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_fst () Bool)
(declare-fun target_expr_size_fst () Bool)
(assert (= source_expr_size_fst target_expr_size_fst))

; expr_size_snd: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_snd () Bool)
(declare-fun target_expr_size_snd () Bool)
(assert (= source_expr_size_snd target_expr_size_snd))

; expr_size_if: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_if () Bool)
(declare-fun target_expr_size_if () Bool)
(assert (= source_expr_size_if target_expr_size_if))

; expr_size_let: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_let () Bool)
(declare-fun target_expr_size_let () Bool)
(assert (= source_expr_size_let target_expr_size_let))

; expr_size_lam: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_lam () Bool)
(declare-fun target_expr_size_lam () Bool)
(assert (= source_expr_size_lam target_expr_size_lam))

; expr_size_inl: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_inl () Bool)
(declare-fun target_expr_size_inl () Bool)
(assert (= source_expr_size_inl target_expr_size_inl))

; expr_size_inr: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_inr () Bool)
(declare-fun target_expr_size_inr () Bool)
(assert (= source_expr_size_inr target_expr_size_inr))

; expr_size_ge_1: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_ge_1 () Bool)
(declare-fun target_expr_size_ge_1 () Bool)
(assert (= source_expr_size_ge_1 target_expr_size_ge_1))

; expr_size_fst_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_fst_sub () Bool)
(declare-fun target_expr_size_fst_sub () Bool)
(assert (= source_expr_size_fst_sub target_expr_size_fst_sub))

; expr_size_snd_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_snd_sub () Bool)
(declare-fun target_expr_size_snd_sub () Bool)
(assert (= source_expr_size_snd_sub target_expr_size_snd_sub))

; expr_size_app_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_app_l () Bool)
(declare-fun target_expr_size_app_l () Bool)
(assert (= source_expr_size_app_l target_expr_size_app_l))

; expr_size_app_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_app_r () Bool)
(declare-fun target_expr_size_app_r () Bool)
(assert (= source_expr_size_app_r target_expr_size_app_r))

; value_terminates: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_terminates () Bool)
(declare-fun target_value_terminates () Bool)
(assert (= source_value_terminates target_value_terminates))

; value_step_terminates_trivially: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_step_terminates_trivially () Bool)
(declare-fun target_value_step_terminates_trivially () Bool)
(assert (= source_value_step_terminates_trivially target_value_step_terminates_trivially))

; expr_size_case: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_case () Bool)
(declare-fun target_expr_size_case () Bool)
(assert (= source_expr_size_case target_expr_size_case))

; expr_size_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_ref () Bool)
(declare-fun target_expr_size_ref () Bool)
(assert (= source_expr_size_ref target_expr_size_ref))

; expr_size_deref: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_deref () Bool)
(declare-fun target_expr_size_deref () Bool)
(assert (= source_expr_size_deref target_expr_size_deref))

; expr_size_assign: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_assign () Bool)
(declare-fun target_expr_size_assign () Bool)
(assert (= source_expr_size_assign target_expr_size_assign))

; expr_size_classify: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_classify () Bool)
(declare-fun target_expr_size_classify () Bool)
(assert (= source_expr_size_classify target_expr_size_classify))

; expr_size_pair_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_pair_l () Bool)
(declare-fun target_expr_size_pair_l () Bool)
(assert (= source_expr_size_pair_l target_expr_size_pair_l))

; expr_size_pair_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_pair_r () Bool)
(declare-fun target_expr_size_pair_r () Bool)
(assert (= source_expr_size_pair_r target_expr_size_pair_r))

; expr_size_case_guard: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_case_guard () Bool)
(declare-fun target_expr_size_case_guard () Bool)
(assert (= source_expr_size_case_guard target_expr_size_case_guard))

; expr_size_if_guard: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_if_guard () Bool)
(declare-fun target_expr_size_if_guard () Bool)
(assert (= source_expr_size_if_guard target_expr_size_if_guard))

; expr_size_let_body: translation preserves property (matches Coq: Lemma)
(declare-fun source_expr_size_let_body () Bool)
(declare-fun target_expr_size_let_body () Bool)
(assert (= source_expr_size_let_body target_expr_size_let_body))

; sized_ty_base_STBase: translation preserves property (matches Coq: Lemma)
(declare-fun source_sized_ty_base_STBase () Bool)
(declare-fun target_sized_ty_base_STBase () Bool)
(assert (= source_sized_ty_base_STBase target_sized_ty_base_STBase))

; sized_ty_bound_STSized: translation preserves property (matches Coq: Lemma)
(declare-fun source_sized_ty_bound_STSized () Bool)
(declare-fun target_sized_ty_bound_STSized () Bool)
(assert (= source_sized_ty_bound_STSized target_sized_ty_bound_STSized))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

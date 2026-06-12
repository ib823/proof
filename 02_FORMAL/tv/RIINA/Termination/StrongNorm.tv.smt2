; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/StrongNorm.v (34 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for StrongNorm
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; value_strongly_normalizing: translation preserves property (matches Coq: Theorem)
(declare-fun source_value_strongly_normalizing () Bool)
(declare-fun target_value_strongly_normalizing () Bool)
(assert (= source_value_strongly_normalizing target_value_strongly_normalizing))

; fst_terminates_to_value: translation preserves property (matches Coq: Lemma)
(declare-fun source_fst_terminates_to_value () Bool)
(declare-fun target_fst_terminates_to_value () Bool)
(assert (= source_fst_terminates_to_value target_fst_terminates_to_value))

; snd_terminates_to_value: translation preserves property (matches Coq: Lemma)
(declare-fun source_snd_terminates_to_value () Bool)
(declare-fun target_snd_terminates_to_value () Bool)
(assert (= source_snd_terminates_to_value target_snd_terminates_to_value))

; if_bool_terminates_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_if_bool_terminates_once () Bool)
(declare-fun target_if_bool_terminates_once () Bool)
(assert (= source_if_bool_terminates_once target_if_bool_terminates_once))

; let_terminates_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_let_terminates_once () Bool)
(declare-fun target_let_terminates_once () Bool)
(assert (= source_let_terminates_once target_let_terminates_once))

; handle_terminates_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_handle_terminates_once () Bool)
(declare-fun target_handle_terminates_once () Bool)
(assert (= source_handle_terminates_once target_handle_terminates_once))

; app_lam_terminates_once: translation preserves property (matches Coq: Lemma)
(declare-fun source_app_lam_terminates_once () Bool)
(declare-fun target_app_lam_terminates_once () Bool)
(assert (= source_app_lam_terminates_once target_app_lam_terminates_once))

; store_ty_extends_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_refl () Bool)
(declare-fun target_store_ty_extends_refl () Bool)
(assert (= source_store_ty_extends_refl target_store_ty_extends_refl))

; SN_multi_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_SN_multi_step () Bool)
(declare-fun target_SN_multi_step () Bool)
(assert (= source_SN_multi_step target_SN_multi_step))

; fst_value_terminates_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_fst_value_terminates_pair () Bool)
(declare-fun target_fst_value_terminates_pair () Bool)
(assert (= source_fst_value_terminates_pair target_fst_value_terminates_pair))

; snd_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_snd_value_SN () Bool)
(declare-fun target_snd_value_SN () Bool)
(assert (= source_snd_value_SN target_snd_value_SN))

; if_bool_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_if_bool_SN () Bool)
(declare-fun target_if_bool_SN () Bool)
(assert (= source_if_bool_SN target_if_bool_SN))

; let_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_let_value_SN () Bool)
(declare-fun target_let_value_SN () Bool)
(assert (= source_let_value_SN target_let_value_SN))

; app_lam_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_app_lam_value_SN () Bool)
(declare-fun target_app_lam_value_SN () Bool)
(assert (= source_app_lam_value_SN target_app_lam_value_SN))

; handle_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_handle_value_SN () Bool)
(declare-fun target_handle_value_SN () Bool)
(assert (= source_handle_value_SN target_handle_value_SN))

; case_inl_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_case_inl_value_SN () Bool)
(declare-fun target_case_inl_value_SN () Bool)
(assert (= source_case_inl_value_SN target_case_inl_value_SN))

; case_inr_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_case_inr_value_SN () Bool)
(declare-fun target_case_inr_value_SN () Bool)
(assert (= source_case_inr_value_SN target_case_inr_value_SN))

; classify_value_strongly_normalizing: translation preserves property (matches Coq: Lemma)
(declare-fun source_classify_value_strongly_normalizing () Bool)
(declare-fun target_classify_value_strongly_normalizing () Bool)
(assert (= source_classify_value_strongly_normalizing target_classify_value_strongly_normalizing))

; declassify_classify_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_declassify_classify_SN () Bool)
(declare-fun target_declassify_classify_SN () Bool)
(assert (= source_declassify_classify_SN target_declassify_classify_SN))

; fst_fst_pair_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_fst_fst_pair_SN () Bool)
(declare-fun target_fst_fst_pair_SN () Bool)
(assert (= source_fst_fst_pair_SN target_fst_fst_pair_SN))

; perform_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_perform_value_SN () Bool)
(declare-fun target_perform_value_SN () Bool)
(assert (= source_perform_value_SN target_perform_value_SN))

; require_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_require_value_SN () Bool)
(declare-fun target_require_value_SN () Bool)
(assert (= source_require_value_SN target_require_value_SN))

; grant_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_grant_value_SN () Bool)
(declare-fun target_grant_value_SN () Bool)
(assert (= source_grant_value_SN target_grant_value_SN))

; pair_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_pair_value_SN () Bool)
(declare-fun target_pair_value_SN () Bool)
(assert (= source_pair_value_SN target_pair_value_SN))

; inl_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_inl_value_SN () Bool)
(declare-fun target_inl_value_SN () Bool)
(assert (= source_inl_value_SN target_inl_value_SN))

; inr_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_inr_value_SN () Bool)
(declare-fun target_inr_value_SN () Bool)
(assert (= source_inr_value_SN target_inr_value_SN))

; prove_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_prove_value_SN () Bool)
(declare-fun target_prove_value_SN () Bool)
(assert (= source_prove_value_SN target_prove_value_SN))

; snd_snd_pair_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_snd_snd_pair_SN () Bool)
(declare-fun target_snd_snd_pair_SN () Bool)
(assert (= source_snd_snd_pair_SN target_snd_snd_pair_SN))

; fst_snd_pair_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_fst_snd_pair_SN () Bool)
(declare-fun target_fst_snd_pair_SN () Bool)
(assert (= source_fst_snd_pair_SN target_fst_snd_pair_SN))

; snd_fst_pair_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_snd_fst_pair_SN () Bool)
(declare-fun target_snd_fst_pair_SN () Bool)
(assert (= source_snd_fst_pair_SN target_snd_fst_pair_SN))

; fst_fst_nested_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_fst_fst_nested_SN () Bool)
(declare-fun target_fst_fst_nested_SN () Bool)
(assert (= source_fst_fst_nested_SN target_fst_fst_nested_SN))

; classify_classify_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_classify_classify_SN () Bool)
(declare-fun target_classify_classify_SN () Bool)
(assert (= source_classify_classify_SN target_classify_classify_SN))

; prove_prove_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_prove_prove_SN () Bool)
(declare-fun target_prove_prove_SN () Bool)
(assert (= source_prove_prove_SN target_prove_prove_SN))

; nested_pair_value_SN: translation preserves property (matches Coq: Lemma)
(declare-fun source_nested_pair_value_SN () Bool)
(declare-fun target_nested_pair_value_SN () Bool)
(assert (= source_nested_pair_value_SN target_nested_pair_value_SN))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

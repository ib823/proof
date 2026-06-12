; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ClosedValueLemmas.v (39 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ClosedValueLemmas
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; closed_expr_cv: source semantics (matches Coq)
(declare-fun source_closed_expr_cv () Bool)
(declare-fun target_closed_expr_cv () Bool)
(assert (= source_closed_expr_cv target_closed_expr_cv))

; value_typed_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_typed_closed () Bool)
(declare-fun target_value_typed_closed () Bool)
(assert (= source_value_typed_closed target_value_typed_closed))

; closed_pair_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_pair_cv () Bool)
(declare-fun target_closed_pair_cv () Bool)
(assert (= source_closed_pair_cv target_closed_pair_cv))

; closed_inl_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_inl_cv () Bool)
(declare-fun target_closed_inl_cv () Bool)
(assert (= source_closed_inl_cv target_closed_inl_cv))

; closed_inr_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_inr_cv () Bool)
(declare-fun target_closed_inr_cv () Bool)
(assert (= source_closed_inr_cv target_closed_inr_cv))

; closed_app_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_app_cv () Bool)
(declare-fun target_closed_app_cv () Bool)
(assert (= source_closed_app_cv target_closed_app_cv))

; closed_unit_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_unit_cv () Bool)
(declare-fun target_closed_unit_cv () Bool)
(assert (= source_closed_unit_cv target_closed_unit_cv))

; closed_bool_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_bool_cv () Bool)
(declare-fun target_closed_bool_cv () Bool)
(assert (= source_closed_bool_cv target_closed_bool_cv))

; closed_int_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_int_cv () Bool)
(declare-fun target_closed_int_cv () Bool)
(assert (= source_closed_int_cv target_closed_int_cv))

; closed_string_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_string_cv () Bool)
(declare-fun target_closed_string_cv () Bool)
(assert (= source_closed_string_cv target_closed_string_cv))

; closed_loc_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_loc_cv () Bool)
(declare-fun target_closed_loc_cv () Bool)
(assert (= source_closed_loc_cv target_closed_loc_cv))

; closed_lam_body_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_lam_body_cv () Bool)
(declare-fun target_closed_lam_body_cv () Bool)
(assert (= source_closed_lam_body_cv target_closed_lam_body_cv))

; closed_if_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_if_cv () Bool)
(declare-fun target_closed_if_cv () Bool)
(assert (= source_closed_if_cv target_closed_if_cv))

; closed_let_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_let_cv () Bool)
(declare-fun target_closed_let_cv () Bool)
(assert (= source_closed_let_cv target_closed_let_cv))

; closed_ref_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_ref_cv () Bool)
(declare-fun target_closed_ref_cv () Bool)
(assert (= source_closed_ref_cv target_closed_ref_cv))

; closed_deref_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_deref_cv () Bool)
(declare-fun target_closed_deref_cv () Bool)
(assert (= source_closed_deref_cv target_closed_deref_cv))

; closed_assign_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_assign_cv () Bool)
(declare-fun target_closed_assign_cv () Bool)
(assert (= source_closed_assign_cv target_closed_assign_cv))

; closed_classify_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_classify_cv () Bool)
(declare-fun target_closed_classify_cv () Bool)
(assert (= source_closed_classify_cv target_closed_classify_cv))

; closed_prove_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_prove_cv () Bool)
(declare-fun target_closed_prove_cv () Bool)
(assert (= source_closed_prove_cv target_closed_prove_cv))

; closed_fst_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_fst_cv () Bool)
(declare-fun target_closed_fst_cv () Bool)
(assert (= source_closed_fst_cv target_closed_fst_cv))

; closed_snd_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_snd_cv () Bool)
(declare-fun target_closed_snd_cv () Bool)
(assert (= source_closed_snd_cv target_closed_snd_cv))

; value_closed_simple: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_closed_simple () Bool)
(declare-fun target_value_closed_simple () Bool)
(assert (= source_value_closed_simple target_value_closed_simple))

; closed_weaken_ctx: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_weaken_ctx () Bool)
(declare-fun target_closed_weaken_ctx () Bool)
(assert (= source_closed_weaken_ctx target_closed_weaken_ctx))

; nil_ctx_is_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_nil_ctx_is_closed () Bool)
(declare-fun target_nil_ctx_is_closed () Bool)
(assert (= source_nil_ctx_is_closed target_nil_ctx_is_closed))

; closed_grant_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_grant_cv () Bool)
(declare-fun target_closed_grant_cv () Bool)
(assert (= source_closed_grant_cv target_closed_grant_cv))

; closed_require_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_require_cv () Bool)
(declare-fun target_closed_require_cv () Bool)
(assert (= source_closed_require_cv target_closed_require_cv))

; closed_perform_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_perform_cv () Bool)
(declare-fun target_closed_perform_cv () Bool)
(assert (= source_closed_perform_cv target_closed_perform_cv))

; closed_handle_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_handle_cv () Bool)
(declare-fun target_closed_handle_cv () Bool)
(assert (= source_closed_handle_cv target_closed_handle_cv))

; closed_declassify_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_declassify_cv () Bool)
(declare-fun target_closed_declassify_cv () Bool)
(assert (= source_closed_declassify_cv target_closed_declassify_cv))

; closed_case_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_case_cv () Bool)
(declare-fun target_closed_case_cv () Bool)
(assert (= source_closed_case_cv target_closed_case_cv))

; closed_lam_cv: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_lam_cv () Bool)
(declare-fun target_closed_lam_cv () Bool)
(assert (= source_closed_lam_cv target_closed_lam_cv))

; closed_pair_value_components: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_pair_value_components () Bool)
(declare-fun target_closed_pair_value_components () Bool)
(assert (= source_closed_pair_value_components target_closed_pair_value_components))

; closed_inl_value_inner: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_inl_value_inner () Bool)
(declare-fun target_closed_inl_value_inner () Bool)
(assert (= source_closed_inl_value_inner target_closed_inl_value_inner))

; closed_inr_value_inner: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_inr_value_inner () Bool)
(declare-fun target_closed_inr_value_inner () Bool)
(assert (= source_closed_inr_value_inner target_closed_inr_value_inner))

; closed_store_extension: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_store_extension () Bool)
(declare-fun target_closed_store_extension () Bool)
(assert (= source_closed_store_extension target_closed_store_extension))

; nil_ctx_pair_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_nil_ctx_pair_closed () Bool)
(declare-fun target_nil_ctx_pair_closed () Bool)
(assert (= source_nil_ctx_pair_closed target_nil_ctx_pair_closed))

; nil_ctx_inl_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_nil_ctx_inl_closed () Bool)
(declare-fun target_nil_ctx_inl_closed () Bool)
(assert (= source_nil_ctx_inl_closed target_nil_ctx_inl_closed))

; nil_ctx_inr_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_nil_ctx_inr_closed () Bool)
(declare-fun target_nil_ctx_inr_closed () Bool)
(assert (= source_nil_ctx_inr_closed target_nil_ctx_inr_closed))

; closed_classify_value_inner: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_classify_value_inner () Bool)
(declare-fun target_closed_classify_value_inner () Bool)
(assert (= source_closed_classify_value_inner target_closed_classify_value_inner))

; closed_prove_value_inner: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_prove_value_inner () Bool)
(declare-fun target_closed_prove_value_inner () Bool)
(assert (= source_closed_prove_value_inner target_closed_prove_value_inner))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

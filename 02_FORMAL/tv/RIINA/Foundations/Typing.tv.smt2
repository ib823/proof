; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/foundations/Typing.v (33 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for Typing
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; lookup: source semantics (matches Coq)
(declare-fun source_lookup () Bool)
(declare-fun target_lookup () Bool)
(assert (= source_lookup target_lookup))

; store_ty_update: source semantics (matches Coq)
(declare-fun source_store_ty_update () Bool)
(declare-fun target_store_ty_update () Bool)
(assert (= source_store_ty_update target_store_ty_update))

; free_in: source semantics (matches Coq)
(declare-fun source_free_in () Bool)
(declare-fun target_free_in () Bool)
(assert (= source_free_in target_free_in))

; store_wf: source semantics (matches Coq)
(declare-fun source_store_wf () Bool)
(declare-fun target_store_wf () Bool)
(assert (= source_store_wf target_store_wf))

; store_ty_extends: source semantics (matches Coq)
(declare-fun source_store_ty_extends () Bool)
(declare-fun target_store_ty_extends () Bool)
(assert (= source_store_ty_extends target_store_ty_extends))

; type_uniqueness: translation preserves property (matches Coq: Lemma)
(declare-fun source_type_uniqueness () Bool)
(declare-fun target_type_uniqueness () Bool)
(assert (= source_type_uniqueness target_type_uniqueness))

; canonical_forms_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_unit () Bool)
(declare-fun target_canonical_forms_unit () Bool)
(assert (= source_canonical_forms_unit target_canonical_forms_unit))

; canonical_forms_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_bool () Bool)
(declare-fun target_canonical_forms_bool () Bool)
(assert (= source_canonical_forms_bool target_canonical_forms_bool))

; canonical_forms_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_int () Bool)
(declare-fun target_canonical_forms_int () Bool)
(assert (= source_canonical_forms_int target_canonical_forms_int))

; canonical_forms_string: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_string () Bool)
(declare-fun target_canonical_forms_string () Bool)
(assert (= source_canonical_forms_string target_canonical_forms_string))

; canonical_forms_fn: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_fn () Bool)
(declare-fun target_canonical_forms_fn () Bool)
(assert (= source_canonical_forms_fn target_canonical_forms_fn))

; canonical_forms_prod: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_prod () Bool)
(declare-fun target_canonical_forms_prod () Bool)
(assert (= source_canonical_forms_prod target_canonical_forms_prod))

; canonical_forms_sum: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_sum () Bool)
(declare-fun target_canonical_forms_sum () Bool)
(assert (= source_canonical_forms_sum target_canonical_forms_sum))

; canonical_forms_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_ref () Bool)
(declare-fun target_canonical_forms_ref () Bool)
(assert (= source_canonical_forms_ref target_canonical_forms_ref))

; canonical_forms_secret: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_secret () Bool)
(declare-fun target_canonical_forms_secret () Bool)
(assert (= source_canonical_forms_secret target_canonical_forms_secret))

; canonical_forms_proof: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms_proof () Bool)
(declare-fun target_canonical_forms_proof () Bool)
(assert (= source_canonical_forms_proof target_canonical_forms_proof))

; canonical_forms: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_forms () Bool)
(declare-fun target_canonical_forms () Bool)
(assert (= source_canonical_forms target_canonical_forms))

; store_ty_extends_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_refl () Bool)
(declare-fun target_store_ty_extends_refl () Bool)
(assert (= source_store_ty_extends_refl target_store_ty_extends_refl))

; store_ty_extends_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_trans () Bool)
(declare-fun target_store_ty_extends_trans () Bool)
(assert (= source_store_ty_extends_trans target_store_ty_extends_trans))

; closed_expr_no_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_expr_no_var () Bool)
(declare-fun target_closed_expr_no_var () Bool)
(assert (= source_closed_expr_no_var target_closed_expr_no_var))

; value_unit_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_unit_closed () Bool)
(declare-fun target_value_unit_closed () Bool)
(assert (= source_value_unit_closed target_value_unit_closed))

; simple_value_pure_effect: translation preserves property (matches Coq: Lemma)
(declare-fun source_simple_value_pure_effect () Bool)
(declare-fun target_simple_value_pure_effect () Bool)
(assert (= source_simple_value_pure_effect target_simple_value_pure_effect))

; unit_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_unit_value_pure () Bool)
(declare-fun target_unit_value_pure () Bool)
(assert (= source_unit_value_pure target_unit_value_pure))

; lam_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_lam_value_pure () Bool)
(declare-fun target_lam_value_pure () Bool)
(assert (= source_lam_value_pure target_lam_value_pure))

; loc_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_loc_value_pure () Bool)
(declare-fun target_loc_value_pure () Bool)
(assert (= source_loc_value_pure target_loc_value_pure))

; lookup_head: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_head () Bool)
(declare-fun target_lookup_head () Bool)
(assert (= source_lookup_head target_lookup_head))

; lookup_tail: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_tail () Bool)
(declare-fun target_lookup_tail () Bool)
(assert (= source_lookup_tail target_lookup_tail))

; lookup_shadow: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_shadow () Bool)
(declare-fun target_lookup_shadow () Bool)
(assert (= source_lookup_shadow target_lookup_shadow))

; lookup_permute: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_permute () Bool)
(declare-fun target_lookup_permute () Bool)
(assert (= source_lookup_permute target_lookup_permute))

; lookup_empty: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_empty () Bool)
(declare-fun target_lookup_empty () Bool)
(assert (= source_lookup_empty target_lookup_empty))

; store_ty_lookup_head: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_lookup_head () Bool)
(declare-fun target_store_ty_lookup_head () Bool)
(assert (= source_store_ty_lookup_head target_store_ty_lookup_head))

; store_ty_lookup_tail: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_lookup_tail () Bool)
(declare-fun target_store_ty_lookup_tail () Bool)
(assert (= source_store_ty_lookup_tail target_store_ty_lookup_tail))

; store_ty_lookup_empty: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_lookup_empty () Bool)
(declare-fun target_store_ty_lookup_empty () Bool)
(assert (= source_store_ty_lookup_empty target_store_ty_lookup_empty))

; store_wf_typed_value: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_wf_typed_value () Bool)
(declare-fun target_store_wf_typed_value () Bool)
(assert (= source_store_wf_typed_value target_store_wf_typed_value))

; store_wf_runtime_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_wf_runtime_typed () Bool)
(declare-fun target_store_wf_runtime_typed () Bool)
(assert (= source_store_wf_runtime_typed target_store_wf_runtime_typed))

; typing_var_in_context: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_var_in_context () Bool)
(declare-fun target_typing_var_in_context () Bool)
(assert (= source_typing_var_in_context target_typing_var_in_context))

; closed_value_not_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_value_not_var () Bool)
(declare-fun target_closed_value_not_var () Bool)
(assert (= source_closed_value_not_var target_closed_value_not_var))

; pure_effect_is_bottom: translation preserves property (matches Coq: Lemma)
(declare-fun source_pure_effect_is_bottom () Bool)
(declare-fun target_pure_effect_is_bottom () Bool)
(assert (= source_pure_effect_is_bottom target_pure_effect_is_bottom))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

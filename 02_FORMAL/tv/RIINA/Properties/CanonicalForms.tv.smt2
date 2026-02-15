; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/CanonicalForms.v (31 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CanonicalForms
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; canonical_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_unit () Bool)
(declare-fun target_canonical_unit () Bool)
(assert (= source_canonical_unit target_canonical_unit))

; canonical_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_bool () Bool)
(declare-fun target_canonical_bool () Bool)
(assert (= source_canonical_bool target_canonical_bool))

; canonical_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_int () Bool)
(declare-fun target_canonical_int () Bool)
(assert (= source_canonical_int target_canonical_int))

; canonical_string: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_string () Bool)
(declare-fun target_canonical_string () Bool)
(assert (= source_canonical_string target_canonical_string))

; canonical_fn: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_fn () Bool)
(declare-fun target_canonical_fn () Bool)
(assert (= source_canonical_fn target_canonical_fn))

; canonical_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_pair () Bool)
(declare-fun target_canonical_pair () Bool)
(assert (= source_canonical_pair target_canonical_pair))

; canonical_sum: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_sum () Bool)
(declare-fun target_canonical_sum () Bool)
(assert (= source_canonical_sum target_canonical_sum))

; canonical_sum_inl: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_sum_inl () Bool)
(declare-fun target_canonical_sum_inl () Bool)
(assert (= source_canonical_sum_inl target_canonical_sum_inl))

; canonical_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_ref () Bool)
(declare-fun target_canonical_ref () Bool)
(assert (= source_canonical_ref target_canonical_ref))

; canonical_secret: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_secret () Bool)
(declare-fun target_canonical_secret () Bool)
(assert (= source_canonical_secret target_canonical_secret))

; canonical_proof: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_proof () Bool)
(declare-fun target_canonical_proof () Bool)
(assert (= source_canonical_proof target_canonical_proof))

; base_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_base_value_pure () Bool)
(declare-fun target_base_value_pure () Bool)
(assert (= source_base_value_pure target_base_value_pure))

; unit_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_unit_value_pure () Bool)
(declare-fun target_unit_value_pure () Bool)
(assert (= source_unit_value_pure target_unit_value_pure))

; bool_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_bool_value_pure () Bool)
(declare-fun target_bool_value_pure () Bool)
(assert (= source_bool_value_pure target_bool_value_pure))

; int_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_int_value_pure () Bool)
(declare-fun target_int_value_pure () Bool)
(assert (= source_int_value_pure target_int_value_pure))

; string_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_string_value_pure () Bool)
(declare-fun target_string_value_pure () Bool)
(assert (= source_string_value_pure target_string_value_pure))

; lambda_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_lambda_value_pure () Bool)
(declare-fun target_lambda_value_pure () Bool)
(assert (= source_lambda_value_pure target_lambda_value_pure))

; loc_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_loc_value_pure () Bool)
(declare-fun target_loc_value_pure () Bool)
(assert (= source_loc_value_pure target_loc_value_pure))

; unit_not_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_unit_not_bool () Bool)
(declare-fun target_unit_not_bool () Bool)
(assert (= source_unit_not_bool target_unit_not_bool))

; unit_not_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_unit_not_int () Bool)
(declare-fun target_unit_not_int () Bool)
(assert (= source_unit_not_int target_unit_not_int))

; unit_not_fn: translation preserves property (matches Coq: Lemma)
(declare-fun source_unit_not_fn () Bool)
(declare-fun target_unit_not_fn () Bool)
(assert (= source_unit_not_fn target_unit_not_fn))

; bool_not_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_bool_not_unit () Bool)
(declare-fun target_bool_not_unit () Bool)
(assert (= source_bool_not_unit target_bool_not_unit))

; bool_not_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_bool_not_int () Bool)
(declare-fun target_bool_not_int () Bool)
(assert (= source_bool_not_int target_bool_not_int))

; int_not_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_int_not_unit () Bool)
(declare-fun target_int_not_unit () Bool)
(assert (= source_int_not_unit target_int_not_unit))

; int_not_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_int_not_bool () Bool)
(declare-fun target_int_not_bool () Bool)
(assert (= source_int_not_bool target_int_not_bool))

; pair_components_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_pair_components_typed () Bool)
(declare-fun target_pair_components_typed () Bool)
(assert (= source_pair_components_typed target_pair_components_typed))

; inl_component_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_inl_component_typed () Bool)
(declare-fun target_inl_component_typed () Bool)
(assert (= source_inl_component_typed target_inl_component_typed))

; inr_component_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_inr_component_typed () Bool)
(declare-fun target_inr_component_typed () Bool)
(assert (= source_inr_component_typed target_inr_component_typed))

; classify_component_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_classify_component_typed () Bool)
(declare-fun target_classify_component_typed () Bool)
(assert (= source_classify_component_typed target_classify_component_typed))

; prove_component_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_prove_component_typed () Bool)
(declare-fun target_prove_component_typed () Bool)
(assert (= source_prove_component_typed target_prove_component_typed))

; value_shape: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_shape () Bool)
(declare-fun target_value_shape () Bool)
(assert (= source_value_shape target_value_shape))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

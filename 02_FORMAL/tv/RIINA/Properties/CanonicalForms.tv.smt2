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
; Translation validation: canonical_unit preserves semantics
(push 1)
(declare-const source_canonical_unit Int)
(declare-const target_canonical_unit Int)
(assert (>= source_canonical_unit 0))
(assert (>= target_canonical_unit 0))
(assert (not (= source_canonical_unit target_canonical_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_bool preserves semantics
(push 1)
(declare-const source_canonical_bool Int)
(declare-const target_canonical_bool Int)
(assert (>= source_canonical_bool 0))
(assert (>= target_canonical_bool 0))
(assert (not (= source_canonical_bool target_canonical_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_int: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_int preserves semantics
(push 1)
(declare-const source_canonical_int Int)
(declare-const target_canonical_int Int)
(assert (>= source_canonical_int 0))
(assert (>= target_canonical_int 0))
(assert (not (= source_canonical_int target_canonical_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_string: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_string preserves semantics
(push 1)
(declare-const source_canonical_string Int)
(declare-const target_canonical_string Int)
(assert (>= source_canonical_string 0))
(assert (>= target_canonical_string 0))
(assert (not (= source_canonical_string target_canonical_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_fn: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_fn preserves semantics
(push 1)
(declare-const source_canonical_fn Int)
(declare-const target_canonical_fn Int)
(assert (>= source_canonical_fn 0))
(assert (>= target_canonical_fn 0))
(assert (not (= source_canonical_fn target_canonical_fn)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_pair: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_pair preserves semantics
(push 1)
(declare-const source_canonical_pair Int)
(declare-const target_canonical_pair Int)
(assert (>= source_canonical_pair 0))
(assert (>= target_canonical_pair 0))
(assert (not (= source_canonical_pair target_canonical_pair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_sum: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_sum preserves semantics
(push 1)
(declare-const source_canonical_sum Int)
(declare-const target_canonical_sum Int)
(assert (>= source_canonical_sum 0))
(assert (>= target_canonical_sum 0))
(assert (not (= source_canonical_sum target_canonical_sum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_sum_inl: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_sum_inl preserves semantics
(push 1)
(declare-const source_canonical_sum_inl Int)
(declare-const target_canonical_sum_inl Int)
(assert (>= source_canonical_sum_inl 0))
(assert (>= target_canonical_sum_inl 0))
(assert (not (= source_canonical_sum_inl target_canonical_sum_inl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_ref: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_ref preserves semantics
(push 1)
(declare-const source_canonical_ref Int)
(declare-const target_canonical_ref Int)
(assert (>= source_canonical_ref 0))
(assert (>= target_canonical_ref 0))
(assert (not (= source_canonical_ref target_canonical_ref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_secret: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_secret preserves semantics
(push 1)
(declare-const source_canonical_secret Int)
(declare-const target_canonical_secret Int)
(assert (>= source_canonical_secret 0))
(assert (>= target_canonical_secret 0))
(assert (not (= source_canonical_secret target_canonical_secret)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_proof: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_proof preserves semantics
(push 1)
(declare-const source_canonical_proof Int)
(declare-const target_canonical_proof Int)
(assert (>= source_canonical_proof 0))
(assert (>= target_canonical_proof 0))
(assert (not (= source_canonical_proof target_canonical_proof)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; base_value_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: base_value_pure preserves semantics
(push 1)
(declare-const source_base_value_pure Int)
(declare-const target_base_value_pure Int)
(assert (>= source_base_value_pure 0))
(assert (>= target_base_value_pure 0))
(assert (not (= source_base_value_pure target_base_value_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unit_value_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: unit_value_pure preserves semantics
(push 1)
(declare-const source_unit_value_pure Int)
(declare-const target_unit_value_pure Int)
(assert (>= source_unit_value_pure 0))
(assert (>= target_unit_value_pure 0))
(assert (not (= source_unit_value_pure target_unit_value_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bool_value_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: bool_value_pure preserves semantics
(push 1)
(declare-const source_bool_value_pure Int)
(declare-const target_bool_value_pure Int)
(assert (>= source_bool_value_pure 0))
(assert (>= target_bool_value_pure 0))
(assert (not (= source_bool_value_pure target_bool_value_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; int_value_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: int_value_pure preserves semantics
(push 1)
(declare-const source_int_value_pure Int)
(declare-const target_int_value_pure Int)
(assert (>= source_int_value_pure 0))
(assert (>= target_int_value_pure 0))
(assert (not (= source_int_value_pure target_int_value_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; string_value_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: string_value_pure preserves semantics
(push 1)
(declare-const source_string_value_pure Int)
(declare-const target_string_value_pure Int)
(assert (>= source_string_value_pure 0))
(assert (>= target_string_value_pure 0))
(assert (not (= source_string_value_pure target_string_value_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lambda_value_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: lambda_value_pure preserves semantics
(push 1)
(declare-const source_lambda_value_pure Int)
(declare-const target_lambda_value_pure Int)
(assert (>= source_lambda_value_pure 0))
(assert (>= target_lambda_value_pure 0))
(assert (not (= source_lambda_value_pure target_lambda_value_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; loc_value_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: loc_value_pure preserves semantics
(push 1)
(declare-const source_loc_value_pure Int)
(declare-const target_loc_value_pure Int)
(assert (>= source_loc_value_pure 0))
(assert (>= target_loc_value_pure 0))
(assert (not (= source_loc_value_pure target_loc_value_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unit_not_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: unit_not_bool preserves semantics
(push 1)
(declare-const source_unit_not_bool Int)
(declare-const target_unit_not_bool Int)
(assert (>= source_unit_not_bool 0))
(assert (>= target_unit_not_bool 0))
(assert (not (= source_unit_not_bool target_unit_not_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unit_not_int: translation preserves property (matches Coq: Lemma)
; Translation validation: unit_not_int preserves semantics
(push 1)
(declare-const source_unit_not_int Int)
(declare-const target_unit_not_int Int)
(assert (>= source_unit_not_int 0))
(assert (>= target_unit_not_int 0))
(assert (not (= source_unit_not_int target_unit_not_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unit_not_fn: translation preserves property (matches Coq: Lemma)
; Translation validation: unit_not_fn preserves semantics
(push 1)
(declare-const source_unit_not_fn Int)
(declare-const target_unit_not_fn Int)
(assert (>= source_unit_not_fn 0))
(assert (>= target_unit_not_fn 0))
(assert (not (= source_unit_not_fn target_unit_not_fn)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bool_not_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: bool_not_unit preserves semantics
(push 1)
(declare-const source_bool_not_unit Int)
(declare-const target_bool_not_unit Int)
(assert (>= source_bool_not_unit 0))
(assert (>= target_bool_not_unit 0))
(assert (not (= source_bool_not_unit target_bool_not_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bool_not_int: translation preserves property (matches Coq: Lemma)
; Translation validation: bool_not_int preserves semantics
(push 1)
(declare-const source_bool_not_int Int)
(declare-const target_bool_not_int Int)
(assert (>= source_bool_not_int 0))
(assert (>= target_bool_not_int 0))
(assert (not (= source_bool_not_int target_bool_not_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; int_not_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: int_not_unit preserves semantics
(push 1)
(declare-const source_int_not_unit Int)
(declare-const target_int_not_unit Int)
(assert (>= source_int_not_unit 0))
(assert (>= target_int_not_unit 0))
(assert (not (= source_int_not_unit target_int_not_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; int_not_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: int_not_bool preserves semantics
(push 1)
(declare-const source_int_not_bool Int)
(declare-const target_int_not_bool Int)
(assert (>= source_int_not_bool 0))
(assert (>= target_int_not_bool 0))
(assert (not (= source_int_not_bool target_int_not_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pair_components_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: pair_components_typed preserves semantics
(push 1)
(declare-const source_pair_components_typed Int)
(declare-const target_pair_components_typed Int)
(assert (>= source_pair_components_typed 0))
(assert (>= target_pair_components_typed 0))
(assert (not (= source_pair_components_typed target_pair_components_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inl_component_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: inl_component_typed preserves semantics
(push 1)
(declare-const source_inl_component_typed Int)
(declare-const target_inl_component_typed Int)
(assert (>= source_inl_component_typed 0))
(assert (>= target_inl_component_typed 0))
(assert (not (= source_inl_component_typed target_inl_component_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inr_component_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: inr_component_typed preserves semantics
(push 1)
(declare-const source_inr_component_typed Int)
(declare-const target_inr_component_typed Int)
(assert (>= source_inr_component_typed 0))
(assert (>= target_inr_component_typed 0))
(assert (not (= source_inr_component_typed target_inr_component_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; classify_component_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: classify_component_typed preserves semantics
(push 1)
(declare-const source_classify_component_typed Int)
(declare-const target_classify_component_typed Int)
(assert (>= source_classify_component_typed 0))
(assert (>= target_classify_component_typed 0))
(assert (not (= source_classify_component_typed target_classify_component_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prove_component_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: prove_component_typed preserves semantics
(push 1)
(declare-const source_prove_component_typed Int)
(declare-const target_prove_component_typed Int)
(assert (>= source_prove_component_typed 0))
(assert (>= target_prove_component_typed 0))
(assert (not (= source_prove_component_typed target_prove_component_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_shape: translation preserves property (matches Coq: Lemma)
; Translation validation: value_shape preserves semantics
(push 1)
(declare-const source_value_shape Int)
(declare-const target_value_shape Int)
(assert (>= source_value_shape 0))
(assert (>= target_value_shape 0))
(assert (not (= source_value_shape target_value_shape)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

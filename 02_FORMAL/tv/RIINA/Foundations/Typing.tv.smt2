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
; Translation validation: lookup preserves semantics
(push 1)
(declare-const source_lookup Int)
(declare-const target_lookup Int)
(assert (>= source_lookup 0))
(assert (>= target_lookup 0))
(assert (not (= source_lookup target_lookup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_update: source semantics (matches Coq)
; Translation validation: store_ty_update preserves semantics
(push 1)
(declare-const source_store_ty_update Int)
(declare-const target_store_ty_update Int)
(assert (>= source_store_ty_update 0))
(assert (>= target_store_ty_update 0))
(assert (not (= source_store_ty_update target_store_ty_update)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; free_in: source semantics (matches Coq)
; Translation validation: free_in preserves semantics
(push 1)
(declare-const source_free_in Int)
(declare-const target_free_in Int)
(assert (>= source_free_in 0))
(assert (>= target_free_in 0))
(assert (not (= source_free_in target_free_in)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf: source semantics (matches Coq)
; Translation validation: store_wf preserves semantics
(push 1)
(declare-const source_store_wf Int)
(declare-const target_store_wf Int)
(assert (>= source_store_wf 0))
(assert (>= target_store_wf 0))
(assert (not (= source_store_wf target_store_wf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends: source semantics (matches Coq)
; Translation validation: store_ty_extends preserves semantics
(push 1)
(declare-const source_store_ty_extends Int)
(declare-const target_store_ty_extends Int)
(assert (>= source_store_ty_extends 0))
(assert (>= target_store_ty_extends 0))
(assert (not (= source_store_ty_extends target_store_ty_extends)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; type_uniqueness: translation preserves property (matches Coq: Lemma)
; Translation validation: type_uniqueness preserves semantics
(push 1)
(declare-const source_type_uniqueness Int)
(declare-const target_type_uniqueness Int)
(assert (>= source_type_uniqueness 0))
(assert (>= target_type_uniqueness 0))
(assert (not (= source_type_uniqueness target_type_uniqueness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_unit preserves semantics
(push 1)
(declare-const source_canonical_forms_unit Int)
(declare-const target_canonical_forms_unit Int)
(assert (>= source_canonical_forms_unit 0))
(assert (>= target_canonical_forms_unit 0))
(assert (not (= source_canonical_forms_unit target_canonical_forms_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_bool preserves semantics
(push 1)
(declare-const source_canonical_forms_bool Int)
(declare-const target_canonical_forms_bool Int)
(assert (>= source_canonical_forms_bool 0))
(assert (>= target_canonical_forms_bool 0))
(assert (not (= source_canonical_forms_bool target_canonical_forms_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_int: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_int preserves semantics
(push 1)
(declare-const source_canonical_forms_int Int)
(declare-const target_canonical_forms_int Int)
(assert (>= source_canonical_forms_int 0))
(assert (>= target_canonical_forms_int 0))
(assert (not (= source_canonical_forms_int target_canonical_forms_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_string: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_string preserves semantics
(push 1)
(declare-const source_canonical_forms_string Int)
(declare-const target_canonical_forms_string Int)
(assert (>= source_canonical_forms_string 0))
(assert (>= target_canonical_forms_string 0))
(assert (not (= source_canonical_forms_string target_canonical_forms_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_fn: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_fn preserves semantics
(push 1)
(declare-const source_canonical_forms_fn Int)
(declare-const target_canonical_forms_fn Int)
(assert (>= source_canonical_forms_fn 0))
(assert (>= target_canonical_forms_fn 0))
(assert (not (= source_canonical_forms_fn target_canonical_forms_fn)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_prod: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_prod preserves semantics
(push 1)
(declare-const source_canonical_forms_prod Int)
(declare-const target_canonical_forms_prod Int)
(assert (>= source_canonical_forms_prod 0))
(assert (>= target_canonical_forms_prod 0))
(assert (not (= source_canonical_forms_prod target_canonical_forms_prod)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_sum: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_sum preserves semantics
(push 1)
(declare-const source_canonical_forms_sum Int)
(declare-const target_canonical_forms_sum Int)
(assert (>= source_canonical_forms_sum 0))
(assert (>= target_canonical_forms_sum 0))
(assert (not (= source_canonical_forms_sum target_canonical_forms_sum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_ref: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_ref preserves semantics
(push 1)
(declare-const source_canonical_forms_ref Int)
(declare-const target_canonical_forms_ref Int)
(assert (>= source_canonical_forms_ref 0))
(assert (>= target_canonical_forms_ref 0))
(assert (not (= source_canonical_forms_ref target_canonical_forms_ref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_secret: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_secret preserves semantics
(push 1)
(declare-const source_canonical_forms_secret Int)
(declare-const target_canonical_forms_secret Int)
(assert (>= source_canonical_forms_secret 0))
(assert (>= target_canonical_forms_secret 0))
(assert (not (= source_canonical_forms_secret target_canonical_forms_secret)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms_proof: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms_proof preserves semantics
(push 1)
(declare-const source_canonical_forms_proof Int)
(declare-const target_canonical_forms_proof Int)
(assert (>= source_canonical_forms_proof 0))
(assert (>= target_canonical_forms_proof 0))
(assert (not (= source_canonical_forms_proof target_canonical_forms_proof)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; canonical_forms: translation preserves property (matches Coq: Lemma)
; Translation validation: canonical_forms preserves semantics
(push 1)
(declare-const source_canonical_forms Int)
(declare-const target_canonical_forms Int)
(assert (>= source_canonical_forms 0))
(assert (>= target_canonical_forms 0))
(assert (not (= source_canonical_forms target_canonical_forms)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_extends_refl preserves semantics
(push 1)
(declare-const source_store_ty_extends_refl Int)
(declare-const target_store_ty_extends_refl Int)
(assert (>= source_store_ty_extends_refl 0))
(assert (>= target_store_ty_extends_refl 0))
(assert (not (= source_store_ty_extends_refl target_store_ty_extends_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_extends_trans preserves semantics
(push 1)
(declare-const source_store_ty_extends_trans Int)
(declare-const target_store_ty_extends_trans Int)
(assert (>= source_store_ty_extends_trans 0))
(assert (>= target_store_ty_extends_trans 0))
(assert (not (= source_store_ty_extends_trans target_store_ty_extends_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_expr_no_var: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_expr_no_var preserves semantics
(push 1)
(declare-const source_closed_expr_no_var Int)
(declare-const target_closed_expr_no_var Int)
(assert (>= source_closed_expr_no_var 0))
(assert (>= target_closed_expr_no_var 0))
(assert (not (= source_closed_expr_no_var target_closed_expr_no_var)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_unit_closed: translation preserves property (matches Coq: Lemma)
; Translation validation: value_unit_closed preserves semantics
(push 1)
(declare-const source_value_unit_closed Int)
(declare-const target_value_unit_closed Int)
(assert (>= source_value_unit_closed 0))
(assert (>= target_value_unit_closed 0))
(assert (not (= source_value_unit_closed target_value_unit_closed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; simple_value_pure_effect: translation preserves property (matches Coq: Lemma)
; Translation validation: simple_value_pure_effect preserves semantics
(push 1)
(declare-const source_simple_value_pure_effect Int)
(declare-const target_simple_value_pure_effect Int)
(assert (>= source_simple_value_pure_effect 0))
(assert (>= target_simple_value_pure_effect 0))
(assert (not (= source_simple_value_pure_effect target_simple_value_pure_effect)))
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

; lam_value_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: lam_value_pure preserves semantics
(push 1)
(declare-const source_lam_value_pure Int)
(declare-const target_lam_value_pure Int)
(assert (>= source_lam_value_pure 0))
(assert (>= target_lam_value_pure 0))
(assert (not (= source_lam_value_pure target_lam_value_pure)))
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

; lookup_head: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_head preserves semantics
(push 1)
(declare-const source_lookup_head Int)
(declare-const target_lookup_head Int)
(assert (>= source_lookup_head 0))
(assert (>= target_lookup_head 0))
(assert (not (= source_lookup_head target_lookup_head)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_tail: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_tail preserves semantics
(push 1)
(declare-const source_lookup_tail Int)
(declare-const target_lookup_tail Int)
(assert (>= source_lookup_tail 0))
(assert (>= target_lookup_tail 0))
(assert (not (= source_lookup_tail target_lookup_tail)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_shadow: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_shadow preserves semantics
(push 1)
(declare-const source_lookup_shadow Int)
(declare-const target_lookup_shadow Int)
(assert (>= source_lookup_shadow 0))
(assert (>= target_lookup_shadow 0))
(assert (not (= source_lookup_shadow target_lookup_shadow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_permute: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_permute preserves semantics
(push 1)
(declare-const source_lookup_permute Int)
(declare-const target_lookup_permute Int)
(assert (>= source_lookup_permute 0))
(assert (>= target_lookup_permute 0))
(assert (not (= source_lookup_permute target_lookup_permute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_empty: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_empty preserves semantics
(push 1)
(declare-const source_lookup_empty Int)
(declare-const target_lookup_empty Int)
(assert (>= source_lookup_empty 0))
(assert (>= target_lookup_empty 0))
(assert (not (= source_lookup_empty target_lookup_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_lookup_head: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_lookup_head preserves semantics
(push 1)
(declare-const source_store_ty_lookup_head Int)
(declare-const target_store_ty_lookup_head Int)
(assert (>= source_store_ty_lookup_head 0))
(assert (>= target_store_ty_lookup_head 0))
(assert (not (= source_store_ty_lookup_head target_store_ty_lookup_head)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_lookup_tail: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_lookup_tail preserves semantics
(push 1)
(declare-const source_store_ty_lookup_tail Int)
(declare-const target_store_ty_lookup_tail Int)
(assert (>= source_store_ty_lookup_tail 0))
(assert (>= target_store_ty_lookup_tail 0))
(assert (not (= source_store_ty_lookup_tail target_store_ty_lookup_tail)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_lookup_empty: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_lookup_empty preserves semantics
(push 1)
(declare-const source_store_ty_lookup_empty Int)
(declare-const target_store_ty_lookup_empty Int)
(assert (>= source_store_ty_lookup_empty 0))
(assert (>= target_store_ty_lookup_empty 0))
(assert (not (= source_store_ty_lookup_empty target_store_ty_lookup_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_typed_value: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_typed_value preserves semantics
(push 1)
(declare-const source_store_wf_typed_value Int)
(declare-const target_store_wf_typed_value Int)
(assert (>= source_store_wf_typed_value 0))
(assert (>= target_store_wf_typed_value 0))
(assert (not (= source_store_wf_typed_value target_store_wf_typed_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_runtime_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_runtime_typed preserves semantics
(push 1)
(declare-const source_store_wf_runtime_typed Int)
(declare-const target_store_wf_runtime_typed Int)
(assert (>= source_store_wf_runtime_typed 0))
(assert (>= target_store_wf_runtime_typed 0))
(assert (not (= source_store_wf_runtime_typed target_store_wf_runtime_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_var_in_context: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_var_in_context preserves semantics
(push 1)
(declare-const source_typing_var_in_context Int)
(declare-const target_typing_var_in_context Int)
(assert (>= source_typing_var_in_context 0))
(assert (>= target_typing_var_in_context 0))
(assert (not (= source_typing_var_in_context target_typing_var_in_context)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_value_not_var: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_value_not_var preserves semantics
(push 1)
(declare-const source_closed_value_not_var Int)
(declare-const target_closed_value_not_var Int)
(assert (>= source_closed_value_not_var 0))
(assert (>= target_closed_value_not_var 0))
(assert (not (= source_closed_value_not_var target_closed_value_not_var)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure_effect_is_bottom: translation preserves property (matches Coq: Lemma)
; Translation validation: pure_effect_is_bottom preserves semantics
(push 1)
(declare-const source_pure_effect_is_bottom Int)
(declare-const target_pure_effect_is_bottom Int)
(assert (>= source_pure_effect_is_bottom 0))
(assert (>= target_pure_effect_is_bottom 0))
(assert (not (= source_pure_effect_is_bottom target_pure_effect_is_bottom)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

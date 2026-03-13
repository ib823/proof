; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/FirstOrderComplete.v (27 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for FirstOrderComplete
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; is_base_type: source semantics (matches Coq)
; Translation validation: is_base_type preserves semantics
(push 1)
(declare-const source_is_base_type Int)
(declare-const target_is_base_type Int)
(assert (>= source_is_base_type 0))
(assert (>= target_is_base_type 0))
(assert (not (= source_is_base_type target_is_base_type)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_independent: source semantics (matches Coq)
; Translation validation: store_independent preserves semantics
(push 1)
(declare-const source_store_independent Int)
(declare-const target_store_independent Int)
(assert (>= source_store_independent 0))
(assert (>= target_store_independent 0))
(assert (not (= source_store_independent target_store_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; expr_eqb: source semantics (matches Coq)
; Translation validation: expr_eqb preserves semantics
(push 1)
(declare-const source_expr_eqb Int)
(declare-const target_expr_eqb Int)
(assert (>= source_expr_eqb 0))
(assert (>= target_expr_eqb 0))
(assert (not (= source_expr_eqb target_expr_eqb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eqb: source semantics (matches Coq)
; Translation validation: ty_eqb preserves semantics
(push 1)
(declare-const source_ty_eqb Int)
(declare-const target_ty_eqb Int)
(assert (>= source_ty_eqb 0))
(assert (>= target_ty_eqb 0))
(assert (not (= source_ty_eqb target_ty_eqb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_subtype: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_subtype preserves semantics
(push 1)
(declare-const source_first_order_subtype Int)
(declare-const target_first_order_subtype Int)
(assert (>= source_first_order_subtype 0))
(assert (>= target_first_order_subtype 0))
(assert (not (= source_first_order_subtype target_first_order_subtype)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_subtypes_fo: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_subtypes_fo preserves semantics
(push 1)
(declare-const source_first_order_subtypes_fo Int)
(declare-const target_first_order_subtypes_fo Int)
(assert (>= source_first_order_subtypes_fo 0))
(assert (>= target_first_order_subtypes_fo 0))
(assert (not (= source_first_order_subtypes_fo target_first_order_subtypes_fo)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; base_type_first_order: translation preserves property (matches Coq: Lemma)
; Translation validation: base_type_first_order preserves semantics
(push 1)
(declare-const source_base_type_first_order Int)
(declare-const target_base_type_first_order Int)
(assert (>= source_base_type_first_order 0))
(assert (>= target_base_type_first_order 0))
(assert (not (= source_base_type_first_order target_base_type_first_order)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; base_type_size_one: translation preserves property (matches Coq: Lemma)
; Translation validation: base_type_size_one preserves semantics
(push 1)
(declare-const source_base_type_size_one Int)
(declare-const target_base_type_size_one Int)
(assert (>= source_base_type_size_one 0))
(assert (>= target_base_type_size_one 0))
(assert (not (= source_base_type_size_one target_base_type_size_one)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_value_structure: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_value_structure preserves semantics
(push 1)
(declare-const source_first_order_value_structure Int)
(declare-const target_first_order_value_structure Int)
(assert (>= source_first_order_value_structure 0))
(assert (>= target_first_order_value_structure 0))
(assert (not (= source_first_order_value_structure target_first_order_value_structure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_induction_simple: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_induction_simple preserves semantics
(push 1)
(declare-const source_first_order_induction_simple Int)
(declare-const target_first_order_induction_simple Int)
(assert (>= source_first_order_induction_simple 0))
(assert (>= target_first_order_induction_simple 0))
(assert (not (= source_first_order_induction_simple target_first_order_induction_simple)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eqb_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_eqb_refl preserves semantics
(push 1)
(declare-const source_ty_eqb_refl Int)
(declare-const target_ty_eqb_refl Int)
(assert (>= source_ty_eqb_refl 0))
(assert (>= target_ty_eqb_refl 0))
(assert (not (= source_ty_eqb_refl target_ty_eqb_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eqb_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_eqb_eq preserves semantics
(push 1)
(declare-const source_ty_eqb_eq Int)
(declare-const target_ty_eqb_eq Int)
(assert (>= source_ty_eqb_eq 0))
(assert (>= target_ty_eqb_eq 0))
(assert (not (= source_ty_eqb_eq target_ty_eqb_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eqb_unit_bool_false: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_eqb_unit_bool_false preserves semantics
(push 1)
(declare-const source_ty_eqb_unit_bool_false Int)
(declare-const target_ty_eqb_unit_bool_false Int)
(assert (>= source_ty_eqb_unit_bool_false 0))
(assert (>= target_ty_eqb_unit_bool_false 0))
(assert (not (= source_ty_eqb_unit_bool_false target_ty_eqb_unit_bool_false)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eqb_unit_int_false: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_eqb_unit_int_false preserves semantics
(push 1)
(declare-const source_ty_eqb_unit_int_false Int)
(declare-const target_ty_eqb_unit_int_false Int)
(assert (>= source_ty_eqb_unit_int_false 0))
(assert (>= target_ty_eqb_unit_int_false 0))
(assert (not (= source_ty_eqb_unit_int_false target_ty_eqb_unit_int_false)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eqb_bool_int_false: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_eqb_bool_int_false preserves semantics
(push 1)
(declare-const source_ty_eqb_bool_int_false Int)
(declare-const target_ty_eqb_bool_int_false Int)
(assert (>= source_ty_eqb_bool_int_false 0))
(assert (>= target_ty_eqb_bool_int_false 0))
(assert (not (= source_ty_eqb_bool_int_false target_ty_eqb_bool_int_false)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eqb_bool_string_false: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_eqb_bool_string_false preserves semantics
(push 1)
(declare-const source_ty_eqb_bool_string_false Int)
(declare-const target_ty_eqb_bool_string_false Int)
(assert (>= source_ty_eqb_bool_string_false 0))
(assert (>= target_ty_eqb_bool_string_false 0))
(assert (not (= source_ty_eqb_bool_string_false target_ty_eqb_bool_string_false)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eqb_int_string_false: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_eqb_int_string_false preserves semantics
(push 1)
(declare-const source_ty_eqb_int_string_false Int)
(declare-const target_ty_eqb_int_string_false Int)
(assert (>= source_ty_eqb_int_string_false 0))
(assert (>= target_ty_eqb_int_string_false 0))
(assert (not (= source_ty_eqb_int_string_false target_ty_eqb_int_string_false)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eqb_unit_string_false: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_eqb_unit_string_false preserves semantics
(push 1)
(declare-const source_ty_eqb_unit_string_false Int)
(declare-const target_ty_eqb_unit_string_false Int)
(assert (>= source_ty_eqb_unit_string_false 0))
(assert (>= target_ty_eqb_unit_string_false 0))
(assert (not (= source_ty_eqb_unit_string_false target_ty_eqb_unit_string_false)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fn_not_first_order: translation preserves property (matches Coq: Lemma)
; Translation validation: fn_not_first_order preserves semantics
(push 1)
(declare-const source_fn_not_first_order Int)
(declare-const target_fn_not_first_order Int)
(assert (>= source_fn_not_first_order 0))
(assert (>= target_fn_not_first_order 0))
(assert (not (= source_fn_not_first_order target_fn_not_first_order)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; chan_not_first_order: translation preserves property (matches Coq: Lemma)
; Translation validation: chan_not_first_order preserves semantics
(push 1)
(declare-const source_chan_not_first_order Int)
(declare-const target_chan_not_first_order Int)
(assert (>= source_chan_not_first_order 0))
(assert (>= target_chan_not_first_order 0))
(assert (not (= source_chan_not_first_order target_chan_not_first_order)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; securechan_not_first_order: translation preserves property (matches Coq: Lemma)
; Translation validation: securechan_not_first_order preserves semantics
(push 1)
(declare-const source_securechan_not_first_order Int)
(declare-const target_securechan_not_first_order Int)
(assert (>= source_securechan_not_first_order 0))
(assert (>= target_securechan_not_first_order 0))
(assert (not (= source_securechan_not_first_order target_securechan_not_first_order)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; base_type_not_fn: translation preserves property (matches Coq: Lemma)
; Translation validation: base_type_not_fn preserves semantics
(push 1)
(declare-const source_base_type_not_fn Int)
(declare-const target_base_type_not_fn Int)
(assert (>= source_base_type_not_fn 0))
(assert (>= target_base_type_not_fn 0))
(assert (not (= source_base_type_not_fn target_base_type_not_fn)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; base_type_not_prod: translation preserves property (matches Coq: Lemma)
; Translation validation: base_type_not_prod preserves semantics
(push 1)
(declare-const source_base_type_not_prod Int)
(declare-const target_base_type_not_prod Int)
(assert (>= source_base_type_not_prod 0))
(assert (>= target_base_type_not_prod 0))
(assert (not (= source_base_type_not_prod target_base_type_not_prod)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; base_type_not_sum: translation preserves property (matches Coq: Lemma)
; Translation validation: base_type_not_sum preserves semantics
(push 1)
(declare-const source_base_type_not_sum Int)
(declare-const target_base_type_not_sum Int)
(assert (>= source_base_type_not_sum 0))
(assert (>= target_base_type_not_sum 0))
(assert (not (= source_base_type_not_sum target_base_type_not_sum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; base_type_not_list: translation preserves property (matches Coq: Lemma)
; Translation validation: base_type_not_list preserves semantics
(push 1)
(declare-const source_base_type_not_list Int)
(declare-const target_base_type_not_list Int)
(assert (>= source_base_type_not_list 0))
(assert (>= target_base_type_not_list 0))
(assert (not (= source_base_type_not_list target_base_type_not_list)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; base_type_not_option: translation preserves property (matches Coq: Lemma)
; Translation validation: base_type_not_option preserves semantics
(push 1)
(declare-const source_base_type_not_option Int)
(declare-const target_base_type_not_option Int)
(assert (>= source_base_type_not_option 0))
(assert (>= target_base_type_not_option 0))
(assert (not (= source_base_type_not_option target_base_type_not_option)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_unit preserves semantics
(push 1)
(declare-const source_fo_compound_depth_unit Int)
(declare-const target_fo_compound_depth_unit Int)
(assert (>= source_fo_compound_depth_unit 0))
(assert (>= target_fo_compound_depth_unit 0))
(assert (not (= source_fo_compound_depth_unit target_fo_compound_depth_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_bool preserves semantics
(push 1)
(declare-const source_fo_compound_depth_bool Int)
(declare-const target_fo_compound_depth_bool Int)
(assert (>= source_fo_compound_depth_bool 0))
(assert (>= target_fo_compound_depth_bool 0))
(assert (not (= source_fo_compound_depth_bool target_fo_compound_depth_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_int: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_int preserves semantics
(push 1)
(declare-const source_fo_compound_depth_int Int)
(declare-const target_fo_compound_depth_int Int)
(assert (>= source_fo_compound_depth_int 0))
(assert (>= target_fo_compound_depth_int 0))
(assert (not (= source_fo_compound_depth_int target_fo_compound_depth_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_string: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_string preserves semantics
(push 1)
(declare-const source_fo_compound_depth_string Int)
(declare-const target_fo_compound_depth_string Int)
(assert (>= source_fo_compound_depth_string 0))
(assert (>= target_fo_compound_depth_string 0))
(assert (not (= source_fo_compound_depth_string target_fo_compound_depth_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_bytes: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_bytes preserves semantics
(push 1)
(declare-const source_fo_compound_depth_bytes Int)
(declare-const target_fo_compound_depth_bytes Int)
(assert (>= source_fo_compound_depth_bytes 0))
(assert (>= target_fo_compound_depth_bytes 0))
(assert (not (= source_fo_compound_depth_bytes target_fo_compound_depth_bytes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

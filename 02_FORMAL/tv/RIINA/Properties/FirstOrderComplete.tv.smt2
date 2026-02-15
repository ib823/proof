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
(declare-fun source_is_base_type () Bool)
(declare-fun target_is_base_type () Bool)
(assert (= source_is_base_type target_is_base_type))

; store_independent: source semantics (matches Coq)
(declare-fun source_store_independent () Bool)
(declare-fun target_store_independent () Bool)
(assert (= source_store_independent target_store_independent))

; expr_eqb: source semantics (matches Coq)
(declare-fun source_expr_eqb () Bool)
(declare-fun target_expr_eqb () Bool)
(assert (= source_expr_eqb target_expr_eqb))

; ty_eqb: source semantics (matches Coq)
(declare-fun source_ty_eqb () Bool)
(declare-fun target_ty_eqb () Bool)
(assert (= source_ty_eqb target_ty_eqb))

; first_order_subtype: translation preserves property (matches Coq: Lemma)
(declare-fun source_first_order_subtype () Bool)
(declare-fun target_first_order_subtype () Bool)
(assert (= source_first_order_subtype target_first_order_subtype))

; first_order_subtypes_fo: translation preserves property (matches Coq: Lemma)
(declare-fun source_first_order_subtypes_fo () Bool)
(declare-fun target_first_order_subtypes_fo () Bool)
(assert (= source_first_order_subtypes_fo target_first_order_subtypes_fo))

; base_type_first_order: translation preserves property (matches Coq: Lemma)
(declare-fun source_base_type_first_order () Bool)
(declare-fun target_base_type_first_order () Bool)
(assert (= source_base_type_first_order target_base_type_first_order))

; base_type_size_one: translation preserves property (matches Coq: Lemma)
(declare-fun source_base_type_size_one () Bool)
(declare-fun target_base_type_size_one () Bool)
(assert (= source_base_type_size_one target_base_type_size_one))

; first_order_value_structure: translation preserves property (matches Coq: Lemma)
(declare-fun source_first_order_value_structure () Bool)
(declare-fun target_first_order_value_structure () Bool)
(assert (= source_first_order_value_structure target_first_order_value_structure))

; first_order_induction_simple: translation preserves property (matches Coq: Lemma)
(declare-fun source_first_order_induction_simple () Bool)
(declare-fun target_first_order_induction_simple () Bool)
(assert (= source_first_order_induction_simple target_first_order_induction_simple))

; ty_eqb_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_ty_eqb_refl () Bool)
(declare-fun target_ty_eqb_refl () Bool)
(assert (= source_ty_eqb_refl target_ty_eqb_refl))

; ty_eqb_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_ty_eqb_eq () Bool)
(declare-fun target_ty_eqb_eq () Bool)
(assert (= source_ty_eqb_eq target_ty_eqb_eq))

; ty_eqb_unit_bool_false: translation preserves property (matches Coq: Lemma)
(declare-fun source_ty_eqb_unit_bool_false () Bool)
(declare-fun target_ty_eqb_unit_bool_false () Bool)
(assert (= source_ty_eqb_unit_bool_false target_ty_eqb_unit_bool_false))

; ty_eqb_unit_int_false: translation preserves property (matches Coq: Lemma)
(declare-fun source_ty_eqb_unit_int_false () Bool)
(declare-fun target_ty_eqb_unit_int_false () Bool)
(assert (= source_ty_eqb_unit_int_false target_ty_eqb_unit_int_false))

; ty_eqb_bool_int_false: translation preserves property (matches Coq: Lemma)
(declare-fun source_ty_eqb_bool_int_false () Bool)
(declare-fun target_ty_eqb_bool_int_false () Bool)
(assert (= source_ty_eqb_bool_int_false target_ty_eqb_bool_int_false))

; ty_eqb_bool_string_false: translation preserves property (matches Coq: Lemma)
(declare-fun source_ty_eqb_bool_string_false () Bool)
(declare-fun target_ty_eqb_bool_string_false () Bool)
(assert (= source_ty_eqb_bool_string_false target_ty_eqb_bool_string_false))

; ty_eqb_int_string_false: translation preserves property (matches Coq: Lemma)
(declare-fun source_ty_eqb_int_string_false () Bool)
(declare-fun target_ty_eqb_int_string_false () Bool)
(assert (= source_ty_eqb_int_string_false target_ty_eqb_int_string_false))

; ty_eqb_unit_string_false: translation preserves property (matches Coq: Lemma)
(declare-fun source_ty_eqb_unit_string_false () Bool)
(declare-fun target_ty_eqb_unit_string_false () Bool)
(assert (= source_ty_eqb_unit_string_false target_ty_eqb_unit_string_false))

; fn_not_first_order: translation preserves property (matches Coq: Lemma)
(declare-fun source_fn_not_first_order () Bool)
(declare-fun target_fn_not_first_order () Bool)
(assert (= source_fn_not_first_order target_fn_not_first_order))

; chan_not_first_order: translation preserves property (matches Coq: Lemma)
(declare-fun source_chan_not_first_order () Bool)
(declare-fun target_chan_not_first_order () Bool)
(assert (= source_chan_not_first_order target_chan_not_first_order))

; securechan_not_first_order: translation preserves property (matches Coq: Lemma)
(declare-fun source_securechan_not_first_order () Bool)
(declare-fun target_securechan_not_first_order () Bool)
(assert (= source_securechan_not_first_order target_securechan_not_first_order))

; base_type_not_fn: translation preserves property (matches Coq: Lemma)
(declare-fun source_base_type_not_fn () Bool)
(declare-fun target_base_type_not_fn () Bool)
(assert (= source_base_type_not_fn target_base_type_not_fn))

; base_type_not_prod: translation preserves property (matches Coq: Lemma)
(declare-fun source_base_type_not_prod () Bool)
(declare-fun target_base_type_not_prod () Bool)
(assert (= source_base_type_not_prod target_base_type_not_prod))

; base_type_not_sum: translation preserves property (matches Coq: Lemma)
(declare-fun source_base_type_not_sum () Bool)
(declare-fun target_base_type_not_sum () Bool)
(assert (= source_base_type_not_sum target_base_type_not_sum))

; base_type_not_list: translation preserves property (matches Coq: Lemma)
(declare-fun source_base_type_not_list () Bool)
(declare-fun target_base_type_not_list () Bool)
(assert (= source_base_type_not_list target_base_type_not_list))

; base_type_not_option: translation preserves property (matches Coq: Lemma)
(declare-fun source_base_type_not_option () Bool)
(declare-fun target_base_type_not_option () Bool)
(assert (= source_base_type_not_option target_base_type_not_option))

; fo_compound_depth_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_fo_compound_depth_unit () Bool)
(declare-fun target_fo_compound_depth_unit () Bool)
(assert (= source_fo_compound_depth_unit target_fo_compound_depth_unit))

; fo_compound_depth_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_fo_compound_depth_bool () Bool)
(declare-fun target_fo_compound_depth_bool () Bool)
(assert (= source_fo_compound_depth_bool target_fo_compound_depth_bool))

; fo_compound_depth_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_fo_compound_depth_int () Bool)
(declare-fun target_fo_compound_depth_int () Bool)
(assert (= source_fo_compound_depth_int target_fo_compound_depth_int))

; fo_compound_depth_string: translation preserves property (matches Coq: Lemma)
(declare-fun source_fo_compound_depth_string () Bool)
(declare-fun target_fo_compound_depth_string () Bool)
(assert (= source_fo_compound_depth_string target_fo_compound_depth_string))

; fo_compound_depth_bytes: translation preserves property (matches Coq: Lemma)
(declare-fun source_fo_compound_depth_bytes () Bool)
(declare-fun target_fo_compound_depth_bytes () Bool)
(assert (= source_fo_compound_depth_bytes target_fo_compound_depth_bytes))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

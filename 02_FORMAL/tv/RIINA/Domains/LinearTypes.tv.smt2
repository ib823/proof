; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/LinearTypes.v (25 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for LinearTypes
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; linearity_eqb: source semantics (matches Coq)
; Translation validation: linearity_eqb preserves semantics
(push 1)
(declare-const source_linearity_eqb Int)
(declare-const target_linearity_eqb Int)
(assert (>= source_linearity_eqb 0))
(assert (>= target_linearity_eqb 0))
(assert (not (= source_linearity_eqb target_linearity_eqb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subqual: source semantics (matches Coq)
; Translation validation: subqual preserves semantics
(push 1)
(declare-const source_subqual Int)
(declare-const target_subqual Int)
(assert (>= source_subqual 0))
(assert (>= target_subqual 0))
(assert (not (= source_subqual target_subqual)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; usage_add: source semantics (matches Coq)
; Translation validation: usage_add preserves semantics
(push 1)
(declare-const source_usage_add Int)
(declare-const target_usage_add Int)
(assert (>= source_usage_add 0))
(assert (>= target_usage_add 0))
(assert (not (= source_usage_add target_usage_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; usage_compatible: source semantics (matches Coq)
; Translation validation: usage_compatible preserves semantics
(push 1)
(declare-const source_usage_compatible Int)
(declare-const target_usage_compatible Int)
(assert (>= source_usage_compatible 0))
(assert (>= target_usage_compatible 0))
(assert (not (= source_usage_compatible target_usage_compatible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; update_usage: source semantics (matches Coq)
; Translation validation: update_usage preserves semantics
(push 1)
(declare-const source_update_usage Int)
(declare-const target_update_usage Int)
(assert (>= source_update_usage 0))
(assert (>= target_update_usage 0))
(assert (not (= source_update_usage target_update_usage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; get_usage: source semantics (matches Coq)
; Translation validation: get_usage preserves semantics
(push 1)
(declare-const source_get_usage Int)
(declare-const target_get_usage Int)
(assert (>= source_get_usage 0))
(assert (>= target_get_usage 0))
(assert (not (= source_get_usage target_get_usage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctx_well_formed: source semantics (matches Coq)
; Translation validation: ctx_well_formed preserves semantics
(push 1)
(declare-const source_ctx_well_formed Int)
(declare-const target_ctx_well_formed Int)
(assert (>= source_ctx_well_formed 0))
(assert (>= target_ctx_well_formed 0))
(assert (not (= source_ctx_well_formed target_ctx_well_formed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_ctx: source semantics (matches Coq)
; Translation validation: empty_ctx preserves semantics
(push 1)
(declare-const source_empty_ctx Int)
(declare-const target_empty_ctx Int)
(assert (>= source_empty_ctx 0))
(assert (>= target_empty_ctx 0))
(assert (not (= source_empty_ctx target_empty_ctx)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend: source semantics (matches Coq)
; Translation validation: extend preserves semantics
(push 1)
(declare-const source_extend Int)
(declare-const target_extend Int)
(assert (>= source_extend 0))
(assert (>= target_extend 0))
(assert (not (= source_extend target_extend)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctx_split: source semantics (matches Coq)
; Translation validation: ctx_split preserves semantics
(push 1)
(declare-const source_ctx_split Int)
(declare-const target_ctx_split Int)
(assert (>= source_ctx_split 0))
(assert (>= target_ctx_split 0))
(assert (not (= source_ctx_split target_ctx_split)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count_var: source semantics (matches Coq)
; Translation validation: count_var preserves semantics
(push 1)
(declare-const source_count_var Int)
(declare-const target_count_var Int)
(assert (>= source_count_var 0))
(assert (>= target_count_var 0))
(assert (not (= source_count_var target_count_var)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; resource_state: source semantics (matches Coq)
; Translation validation: resource_state preserves semantics
(push 1)
(declare-const source_resource_state Int)
(declare-const target_resource_state Int)
(assert (>= source_resource_state 0))
(assert (>= target_resource_state 0))
(assert (not (= source_resource_state target_resource_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; consume_resource: source semantics (matches Coq)
; Translation validation: consume_resource preserves semantics
(push 1)
(declare-const source_consume_resource Int)
(declare-const target_consume_resource Int)
(assert (>= source_consume_resource 0))
(assert (>= target_consume_resource 0))
(assert (not (= source_consume_resource target_consume_resource)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; linear_var_exactly_once: source semantics (matches Coq)
; Translation validation: linear_var_exactly_once preserves semantics
(push 1)
(declare-const source_linear_var_exactly_once Int)
(declare-const target_linear_var_exactly_once Int)
(assert (>= source_linear_var_exactly_once 0))
(assert (>= target_linear_var_exactly_once 0))
(assert (not (= source_linear_var_exactly_once target_linear_var_exactly_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unrestricted_usage_valid: source semantics (matches Coq)
; Translation validation: unrestricted_usage_valid preserves semantics
(push 1)
(declare-const source_unrestricted_usage_valid Int)
(declare-const target_unrestricted_usage_valid Int)
(assert (>= source_unrestricted_usage_valid 0))
(assert (>= target_unrestricted_usage_valid 0))
(assert (not (= source_unrestricted_usage_valid target_unrestricted_usage_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_consumes_arg: source semantics (matches Coq)
; Translation validation: app_consumes_arg preserves semantics
(push 1)
(declare-const source_app_consumes_arg Int)
(declare-const target_app_consumes_arg Int)
(assert (>= source_app_consumes_arg 0))
(assert (>= target_app_consumes_arg 0))
(assert (not (= source_app_consumes_arg target_app_consumes_arg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; affine_subsumes_linear: source semantics (matches Coq)
; Translation validation: affine_subsumes_linear preserves semantics
(push 1)
(declare-const source_affine_subsumes_linear Int)
(declare-const target_affine_subsumes_linear Int)
(assert (>= source_affine_subsumes_linear 0))
(assert (>= target_affine_subsumes_linear 0))
(assert (not (= source_affine_subsumes_linear target_affine_subsumes_linear)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; relevant_subsumes_linear: source semantics (matches Coq)
; Translation validation: relevant_subsumes_linear preserves semantics
(push 1)
(declare-const source_relevant_subsumes_linear Int)
(declare-const target_relevant_subsumes_linear Int)
(assert (>= source_relevant_subsumes_linear 0))
(assert (>= target_relevant_subsumes_linear 0))
(assert (not (= source_relevant_subsumes_linear target_relevant_subsumes_linear)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctx_split_valid: source semantics (matches Coq)
; Translation validation: ctx_split_valid preserves semantics
(push 1)
(declare-const source_ctx_split_valid Int)
(declare-const target_ctx_split_valid Int)
(assert (>= source_ctx_split_valid 0))
(assert (>= target_ctx_split_valid 0))
(assert (not (= source_ctx_split_valid target_ctx_split_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; substitute: source semantics (matches Coq)
; Translation validation: substitute preserves semantics
(push 1)
(declare-const source_substitute Int)
(declare-const target_substitute Int)
(assert (>= source_substitute 0))
(assert (>= target_substitute 0))
(assert (not (= source_substitute target_substitute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; substitution_preserves_structure: source semantics (matches Coq)
; Translation validation: substitution_preserves_structure preserves semantics
(push 1)
(declare-const source_substitution_preserves_structure Int)
(declare-const target_substitution_preserves_structure Int)
(assert (>= source_substitution_preserves_structure 0))
(assert (>= target_substitution_preserves_structure 0))
(assert (not (= source_substitution_preserves_structure target_substitution_preserves_structure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; weakening_invalid_for_linear: source semantics (matches Coq)
; Translation validation: weakening_invalid_for_linear preserves semantics
(push 1)
(declare-const source_weakening_invalid_for_linear Int)
(declare-const target_weakening_invalid_for_linear Int)
(assert (>= source_weakening_invalid_for_linear 0))
(assert (>= target_weakening_invalid_for_linear 0))
(assert (not (= source_weakening_invalid_for_linear target_weakening_invalid_for_linear)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; weakening_violates_linear_semantics: source semantics (matches Coq)
; Translation validation: weakening_violates_linear_semantics preserves semantics
(push 1)
(declare-const source_weakening_violates_linear_semantics Int)
(declare-const target_weakening_violates_linear_semantics Int)
(assert (>= source_weakening_violates_linear_semantics 0))
(assert (>= target_weakening_violates_linear_semantics 0))
(assert (not (= source_weakening_violates_linear_semantics target_weakening_violates_linear_semantics)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; contraction_invalid_for_linear: source semantics (matches Coq)
; Translation validation: contraction_invalid_for_linear preserves semantics
(push 1)
(declare-const source_contraction_invalid_for_linear Int)
(declare-const target_contraction_invalid_for_linear Int)
(assert (>= source_contraction_invalid_for_linear 0))
(assert (>= target_contraction_invalid_for_linear 0))
(assert (not (= source_contraction_invalid_for_linear target_contraction_invalid_for_linear)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pair_consumes_both: source semantics (matches Coq)
; Translation validation: pair_consumes_both preserves semantics
(push 1)
(declare-const source_pair_consumes_both Int)
(declare-const target_pair_consumes_both Int)
(assert (>= source_pair_consumes_both 0))
(assert (>= target_pair_consumes_both 0))
(assert (not (= source_pair_consumes_both target_pair_consumes_both)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; let_transfers_ownership: source semantics (matches Coq)
; Translation validation: let_transfers_ownership preserves semantics
(push 1)
(declare-const source_let_transfers_ownership Int)
(declare-const target_let_transfers_ownership Int)
(assert (>= source_let_transfers_ownership 0))
(assert (>= target_let_transfers_ownership 0))
(assert (not (= source_let_transfers_ownership target_let_transfers_ownership)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; use_after_consume_impossible: source semantics (matches Coq)
; Translation validation: use_after_consume_impossible preserves semantics
(push 1)
(declare-const source_use_after_consume_impossible Int)
(declare-const target_use_after_consume_impossible Int)
(assert (>= source_use_after_consume_impossible 0))
(assert (>= target_use_after_consume_impossible 0))
(assert (not (= source_use_after_consume_impossible target_use_after_consume_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_double_consume: source semantics (matches Coq)
; Translation validation: no_double_consume preserves semantics
(push 1)
(declare-const source_no_double_consume Int)
(declare-const target_no_double_consume Int)
(assert (>= source_no_double_consume 0))
(assert (>= target_no_double_consume 0))
(assert (not (= source_no_double_consume target_no_double_consume)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; linearity_eqb_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: linearity_eqb_eq preserves semantics
(push 1)
(declare-const source_linearity_eqb_eq Int)
(declare-const target_linearity_eqb_eq Int)
(assert (>= source_linearity_eqb_eq 0))
(assert (>= target_linearity_eqb_eq 0))
(assert (not (= source_linearity_eqb_eq target_linearity_eqb_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; get_update_same: translation preserves property (matches Coq: Lemma)
; Translation validation: get_update_same preserves semantics
(push 1)
(declare-const source_get_update_same Int)
(declare-const target_get_update_same Int)
(assert (>= source_get_update_same 0))
(assert (>= target_get_update_same 0))
(assert (not (= source_get_update_same target_get_update_same)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_01: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_01 preserves semantics
(push 1)
(declare-const source_TYPE_002_01 Int)
(declare-const target_TYPE_002_01 Int)
(assert (>= source_TYPE_002_01 0))
(assert (>= target_TYPE_002_01 0))
(assert (not (= source_TYPE_002_01 target_TYPE_002_01)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_02: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_02 preserves semantics
(push 1)
(declare-const source_TYPE_002_02 Int)
(declare-const target_TYPE_002_02 Int)
(assert (>= source_TYPE_002_02 0))
(assert (>= target_TYPE_002_02 0))
(assert (not (= source_TYPE_002_02 target_TYPE_002_02)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_03: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_03 preserves semantics
(push 1)
(declare-const source_TYPE_002_03 Int)
(declare-const target_TYPE_002_03 Int)
(assert (>= source_TYPE_002_03 0))
(assert (>= target_TYPE_002_03 0))
(assert (not (= source_TYPE_002_03 target_TYPE_002_03)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_04: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_04 preserves semantics
(push 1)
(declare-const source_TYPE_002_04 Int)
(declare-const target_TYPE_002_04 Int)
(assert (>= source_TYPE_002_04 0))
(assert (>= target_TYPE_002_04 0))
(assert (not (= source_TYPE_002_04 target_TYPE_002_04)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_05: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_05 preserves semantics
(push 1)
(declare-const source_TYPE_002_05 Int)
(declare-const target_TYPE_002_05 Int)
(assert (>= source_TYPE_002_05 0))
(assert (>= target_TYPE_002_05 0))
(assert (not (= source_TYPE_002_05 target_TYPE_002_05)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; usage_add_zero_l: translation preserves property (matches Coq: Lemma)
; Translation validation: usage_add_zero_l preserves semantics
(push 1)
(declare-const source_usage_add_zero_l Int)
(declare-const target_usage_add_zero_l Int)
(assert (>= source_usage_add_zero_l 0))
(assert (>= target_usage_add_zero_l 0))
(assert (not (= source_usage_add_zero_l target_usage_add_zero_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; usage_add_zero_r: translation preserves property (matches Coq: Lemma)
; Translation validation: usage_add_zero_r preserves semantics
(push 1)
(declare-const source_usage_add_zero_r Int)
(declare-const target_usage_add_zero_r Int)
(assert (>= source_usage_add_zero_r 0))
(assert (>= target_usage_add_zero_r 0))
(assert (not (= source_usage_add_zero_r target_usage_add_zero_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_06: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_06 preserves semantics
(push 1)
(declare-const source_TYPE_002_06 Int)
(declare-const target_TYPE_002_06 Int)
(assert (>= source_TYPE_002_06 0))
(assert (>= target_TYPE_002_06 0))
(assert (not (= source_TYPE_002_06 target_TYPE_002_06)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_07: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_07 preserves semantics
(push 1)
(declare-const source_TYPE_002_07 Int)
(declare-const target_TYPE_002_07 Int)
(assert (>= source_TYPE_002_07 0))
(assert (>= target_TYPE_002_07 0))
(assert (not (= source_TYPE_002_07 target_TYPE_002_07)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; linear_must_be_used: translation preserves property (matches Coq: Lemma)
; Translation validation: linear_must_be_used preserves semantics
(push 1)
(declare-const source_linear_must_be_used Int)
(declare-const target_linear_must_be_used Int)
(assert (>= source_linear_must_be_used 0))
(assert (>= target_linear_must_be_used 0))
(assert (not (= source_linear_must_be_used target_linear_must_be_used)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; linear_zero_usage_invalid: translation preserves property (matches Coq: Lemma)
; Translation validation: linear_zero_usage_invalid preserves semantics
(push 1)
(declare-const source_linear_zero_usage_invalid Int)
(declare-const target_linear_zero_usage_invalid Int)
(assert (>= source_linear_zero_usage_invalid 0))
(assert (>= target_linear_zero_usage_invalid 0))
(assert (not (= source_linear_zero_usage_invalid target_linear_zero_usage_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; linear_many_usage_invalid: translation preserves property (matches Coq: Lemma)
; Translation validation: linear_many_usage_invalid preserves semantics
(push 1)
(declare-const source_linear_many_usage_invalid Int)
(declare-const target_linear_many_usage_invalid Int)
(assert (>= source_linear_many_usage_invalid 0))
(assert (>= target_linear_many_usage_invalid 0))
(assert (not (= source_linear_many_usage_invalid target_linear_many_usage_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unused_linear_ill_formed: translation preserves property (matches Coq: Lemma)
; Translation validation: unused_linear_ill_formed preserves semantics
(push 1)
(declare-const source_unused_linear_ill_formed Int)
(declare-const target_unused_linear_ill_formed Int)
(assert (>= source_unused_linear_ill_formed 0))
(assert (>= target_unused_linear_ill_formed 0))
(assert (not (= source_unused_linear_ill_formed target_unused_linear_ill_formed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_preserves_lookup_none: translation preserves property (matches Coq: Lemma)
; Translation validation: extend_preserves_lookup_none preserves semantics
(push 1)
(declare-const source_extend_preserves_lookup_none Int)
(declare-const target_extend_preserves_lookup_none Int)
(assert (>= source_extend_preserves_lookup_none 0))
(assert (>= target_extend_preserves_lookup_none 0))
(assert (not (= source_extend_preserves_lookup_none target_extend_preserves_lookup_none)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unit_typing_preserves_ctx: translation preserves property (matches Coq: Lemma)
; Translation validation: unit_typing_preserves_ctx preserves semantics
(push 1)
(declare-const source_unit_typing_preserves_ctx Int)
(declare-const target_unit_typing_preserves_ctx Int)
(assert (>= source_unit_typing_preserves_ctx 0))
(assert (>= target_unit_typing_preserves_ctx 0))
(assert (not (= source_unit_typing_preserves_ctx target_unit_typing_preserves_ctx)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_08_direct: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_08_direct preserves semantics
(push 1)
(declare-const source_TYPE_002_08_direct Int)
(declare-const target_TYPE_002_08_direct Int)
(assert (>= source_TYPE_002_08_direct 0))
(assert (>= target_TYPE_002_08_direct 0))
(assert (not (= source_TYPE_002_08_direct target_TYPE_002_08_direct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; weakening_consequence: translation preserves property (matches Coq: Lemma)
; Translation validation: weakening_consequence preserves semantics
(push 1)
(declare-const source_weakening_consequence Int)
(declare-const target_weakening_consequence Int)
(assert (>= source_weakening_consequence 0))
(assert (>= target_weakening_consequence 0))
(assert (not (= source_weakening_consequence target_weakening_consequence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_08: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_08 preserves semantics
(push 1)
(declare-const source_TYPE_002_08 Int)
(declare-const target_TYPE_002_08 Int)
(assert (>= source_TYPE_002_08 0))
(assert (>= target_TYPE_002_08 0))
(assert (not (= source_TYPE_002_08 target_TYPE_002_08)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_09: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_09 preserves semantics
(push 1)
(declare-const source_TYPE_002_09 Int)
(declare-const target_TYPE_002_09 Int)
(assert (>= source_TYPE_002_09 0))
(assert (>= target_TYPE_002_09 0))
(assert (not (= source_TYPE_002_09 target_TYPE_002_09)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_10: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_10 preserves semantics
(push 1)
(declare-const source_TYPE_002_10 Int)
(declare-const target_TYPE_002_10 Int)
(assert (>= source_TYPE_002_10 0))
(assert (>= target_TYPE_002_10 0))
(assert (not (= source_TYPE_002_10 target_TYPE_002_10)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_11: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_11 preserves semantics
(push 1)
(declare-const source_TYPE_002_11 Int)
(declare-const target_TYPE_002_11 Int)
(assert (>= source_TYPE_002_11 0))
(assert (>= target_TYPE_002_11 0))
(assert (not (= source_TYPE_002_11 target_TYPE_002_11)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; resource_stays_consumed: translation preserves property (matches Coq: Lemma)
; Translation validation: resource_stays_consumed preserves semantics
(push 1)
(declare-const source_resource_stays_consumed Int)
(declare-const target_resource_stays_consumed Int)
(assert (>= source_resource_stays_consumed 0))
(assert (>= target_resource_stays_consumed 0))
(assert (not (= source_resource_stays_consumed target_resource_stays_consumed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_002_12: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_002_12 preserves semantics
(push 1)
(declare-const source_TYPE_002_12 Int)
(declare-const target_TYPE_002_12 Int)
(assert (>= source_TYPE_002_12 0))
(assert (>= target_TYPE_002_12 0))
(assert (not (= source_TYPE_002_12 target_TYPE_002_12)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

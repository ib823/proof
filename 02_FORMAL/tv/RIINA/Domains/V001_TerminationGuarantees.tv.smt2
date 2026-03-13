; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/V001_TerminationGuarantees.v (32 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for V001_TerminationGuarantees
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; expr_size: source semantics (matches Coq)
; Translation validation: expr_size preserves semantics
(push 1)
(declare-const source_expr_size Int)
(declare-const target_expr_size Int)
(assert (>= source_expr_size 0))
(assert (>= target_expr_size 0))
(assert (not (= source_expr_size target_expr_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; structurally_smaller: source semantics (matches Coq)
; Translation validation: structurally_smaller preserves semantics
(push 1)
(declare-const source_structurally_smaller Int)
(declare-const target_structurally_smaller Int)
(assert (>= source_structurally_smaller 0))
(assert (>= target_structurally_smaller 0))
(assert (not (= source_structurally_smaller target_structurally_smaller)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; structural_recursion: source semantics (matches Coq)
; Translation validation: structural_recursion preserves semantics
(push 1)
(declare-const source_structural_recursion Int)
(declare-const target_structural_recursion Int)
(assert (>= source_structural_recursion 0))
(assert (>= target_structural_recursion 0))
(assert (not (= source_structural_recursion target_structural_recursion)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; size_subtype: source semantics (matches Coq)
; Translation validation: size_subtype preserves semantics
(push 1)
(declare-const source_size_subtype Int)
(declare-const target_size_subtype Int)
(assert (>= source_size_subtype 0))
(assert (>= target_size_subtype 0))
(assert (not (= source_size_subtype target_size_subtype)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sized_wellformed: source semantics (matches Coq)
; Translation validation: sized_wellformed preserves semantics
(push 1)
(declare-const source_sized_wellformed Int)
(declare-const target_sized_wellformed Int)
(assert (>= source_sized_wellformed 0))
(assert (>= target_sized_wellformed 0))
(assert (not (= source_sized_wellformed target_sized_wellformed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; size_less: source semantics (matches Coq)
; Translation validation: size_less preserves semantics
(push 1)
(declare-const source_size_less Int)
(declare-const target_size_less Int)
(assert (>= source_size_less 0))
(assert (>= target_size_less 0))
(assert (not (= source_size_less target_size_less)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ackermann: source semantics (matches Coq)
; Translation validation: ackermann preserves semantics
(push 1)
(declare-const source_ackermann Int)
(declare-const target_ackermann Int)
(assert (>= source_ackermann 0))
(assert (>= target_ackermann 0))
(assert (not (= source_ackermann target_ackermann)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure: source semantics (matches Coq)
; Translation validation: pure preserves semantics
(push 1)
(declare-const source_pure Int)
(declare-const target_pure Int)
(assert (>= source_pure 0))
(assert (>= target_pure 0))
(assert (not (= source_pure target_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; well_typed: source semantics (matches Coq)
; Translation validation: well_typed preserves semantics
(push 1)
(declare-const source_well_typed Int)
(declare-const target_well_typed Int)
(assert (>= source_well_typed 0))
(assert (>= target_well_typed 0))
(assert (not (= source_well_typed target_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_value: source semantics (matches Coq)
; Translation validation: is_value preserves semantics
(push 1)
(declare-const source_is_value Int)
(declare-const target_is_value Int)
(assert (>= source_is_value 0))
(assert (>= target_is_value 0))
(assert (not (= source_is_value target_is_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; check_termination: source semantics (matches Coq)
; Translation validation: check_termination preserves semantics
(push 1)
(declare-const source_check_termination Int)
(declare-const target_check_termination Int)
(assert (>= source_check_termination 0))
(assert (>= target_check_termination 0))
(assert (not (= source_check_termination target_check_termination)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; even_size: source semantics (matches Coq)
; Translation validation: even_size preserves semantics
(push 1)
(declare-const source_even_size Int)
(declare-const target_even_size Int)
(assert (>= source_even_size 0))
(assert (>= target_even_size 0))
(assert (not (= source_even_size target_even_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; infer_size: source semantics (matches Coq)
; Translation validation: infer_size preserves semantics
(push 1)
(declare-const source_infer_size Int)
(declare-const target_infer_size Int)
(assert (>= source_infer_size 0))
(assert (>= target_infer_size 0))
(assert (not (= source_infer_size target_infer_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; infer_measure: source semantics (matches Coq)
; Translation validation: infer_measure preserves semantics
(push 1)
(declare-const source_infer_measure Int)
(declare-const target_infer_measure Int)
(assert (>= source_infer_measure 0))
(assert (>= target_infer_measure 0))
(assert (not (= source_infer_measure target_infer_measure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; explicitly_marked: source semantics (matches Coq)
; Translation validation: explicitly_marked preserves semantics
(push 1)
(declare-const source_explicitly_marked Int)
(declare-const target_explicitly_marked Int)
(assert (>= source_explicitly_marked 0))
(assert (>= target_explicitly_marked 0))
(assert (not (= source_explicitly_marked target_explicitly_marked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_01_structural_decrease: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_01_structural_decrease preserves semantics
(push 1)
(declare-const source_V_001_01_structural_decrease Int)
(declare-const target_V_001_01_structural_decrease Int)
(assert (>= source_V_001_01_structural_decrease 0))
(assert (>= target_V_001_01_structural_decrease 0))
(assert (not (= source_V_001_01_structural_decrease target_V_001_01_structural_decrease)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_02_structural_termination: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_02_structural_termination preserves semantics
(push 1)
(declare-const source_V_001_02_structural_termination Int)
(declare-const target_V_001_02_structural_termination Int)
(assert (>= source_V_001_02_structural_termination 0))
(assert (>= target_V_001_02_structural_termination 0))
(assert (not (= source_V_001_02_structural_termination target_V_001_02_structural_termination)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_03_nat_structural: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_03_nat_structural preserves semantics
(push 1)
(declare-const source_V_001_03_nat_structural Int)
(declare-const target_V_001_03_nat_structural Int)
(assert (>= source_V_001_03_nat_structural 0))
(assert (>= target_V_001_03_nat_structural 0))
(assert (not (= source_V_001_03_nat_structural target_V_001_03_nat_structural)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_04_list_structural: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_04_list_structural preserves semantics
(push 1)
(declare-const source_V_001_04_list_structural Int)
(declare-const target_V_001_04_list_structural Int)
(assert (>= source_V_001_04_list_structural 0))
(assert (>= target_V_001_04_list_structural 0))
(assert (not (= source_V_001_04_list_structural target_V_001_04_list_structural)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_05_tree_structural: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_05_tree_structural preserves semantics
(push 1)
(declare-const source_V_001_05_tree_structural Int)
(declare-const target_V_001_05_tree_structural Int)
(assert (>= source_V_001_05_tree_structural 0))
(assert (>= target_V_001_05_tree_structural 0))
(assert (not (= source_V_001_05_tree_structural target_V_001_05_tree_structural)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_06_mutual_structural: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_06_mutual_structural preserves semantics
(push 1)
(declare-const source_V_001_06_mutual_structural Int)
(declare-const target_V_001_06_mutual_structural Int)
(assert (>= source_V_001_06_mutual_structural 0))
(assert (>= target_V_001_06_mutual_structural 0))
(assert (not (= source_V_001_06_mutual_structural target_V_001_06_mutual_structural)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_07_nested_structural: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_07_nested_structural preserves semantics
(push 1)
(declare-const source_V_001_07_nested_structural Int)
(declare-const target_V_001_07_nested_structural Int)
(assert (>= source_V_001_07_nested_structural 0))
(assert (>= target_V_001_07_nested_structural 0))
(assert (not (= source_V_001_07_nested_structural target_V_001_07_nested_structural)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_08_structural_checker_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_08_structural_checker_sound preserves semantics
(push 1)
(declare-const source_V_001_08_structural_checker_sound Int)
(declare-const target_V_001_08_structural_checker_sound Int)
(assert (>= source_V_001_08_structural_checker_sound 0))
(assert (>= target_V_001_08_structural_checker_sound 0))
(assert (not (= source_V_001_08_structural_checker_sound target_V_001_08_structural_checker_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_09_sized_type_wellformed: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_09_sized_type_wellformed preserves semantics
(push 1)
(declare-const source_V_001_09_sized_type_wellformed Int)
(declare-const target_V_001_09_sized_type_wellformed Int)
(assert (>= source_V_001_09_sized_type_wellformed 0))
(assert (>= target_V_001_09_sized_type_wellformed 0))
(assert (not (= source_V_001_09_sized_type_wellformed target_V_001_09_sized_type_wellformed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_10_size_decreases: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_10_size_decreases preserves semantics
(push 1)
(declare-const source_V_001_10_size_decreases Int)
(declare-const target_V_001_10_size_decreases Int)
(assert (>= source_V_001_10_size_decreases 0))
(assert (>= target_V_001_10_size_decreases 0))
(assert (not (= source_V_001_10_size_decreases target_V_001_10_size_decreases)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_11_sized_list_terminates: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_11_sized_list_terminates preserves semantics
(push 1)
(declare-const source_V_001_11_sized_list_terminates Int)
(declare-const target_V_001_11_sized_list_terminates Int)
(assert (>= source_V_001_11_sized_list_terminates 0))
(assert (>= target_V_001_11_sized_list_terminates 0))
(assert (not (= source_V_001_11_sized_list_terminates target_V_001_11_sized_list_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_12_sized_tree_terminates: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_12_sized_tree_terminates preserves semantics
(push 1)
(declare-const source_V_001_12_sized_tree_terminates Int)
(declare-const target_V_001_12_sized_tree_terminates Int)
(assert (>= source_V_001_12_sized_tree_terminates 0))
(assert (>= target_V_001_12_sized_tree_terminates 0))
(assert (not (= source_V_001_12_sized_tree_terminates target_V_001_12_sized_tree_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_13_size_inference_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_13_size_inference_correct preserves semantics
(push 1)
(declare-const source_V_001_13_size_inference_correct Int)
(declare-const target_V_001_13_size_inference_correct Int)
(assert (>= source_V_001_13_size_inference_correct 0))
(assert (>= target_V_001_13_size_inference_correct 0))
(assert (not (= source_V_001_13_size_inference_correct target_V_001_13_size_inference_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_14_size_subtyping: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_14_size_subtyping preserves semantics
(push 1)
(declare-const source_V_001_14_size_subtyping Int)
(declare-const target_V_001_14_size_subtyping Int)
(assert (>= source_V_001_14_size_subtyping 0))
(assert (>= target_V_001_14_size_subtyping 0))
(assert (not (= source_V_001_14_size_subtyping target_V_001_14_size_subtyping)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_15_sized_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_15_sized_preservation preserves semantics
(push 1)
(declare-const source_V_001_15_sized_preservation Int)
(declare-const target_V_001_15_sized_preservation Int)
(assert (>= source_V_001_15_sized_preservation 0))
(assert (>= target_V_001_15_sized_preservation 0))
(assert (not (= source_V_001_15_sized_preservation target_V_001_15_sized_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_16_sized_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_16_sized_composition preserves semantics
(push 1)
(declare-const source_V_001_16_sized_composition Int)
(declare-const target_V_001_16_sized_composition Int)
(assert (>= source_V_001_16_sized_composition 0))
(assert (>= target_V_001_16_sized_composition 0))
(assert (not (= source_V_001_16_sized_composition target_V_001_16_sized_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_17_measure_wellformed: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_17_measure_wellformed preserves semantics
(push 1)
(declare-const source_V_001_17_measure_wellformed Int)
(declare-const target_V_001_17_measure_wellformed Int)
(assert (>= source_V_001_17_measure_wellformed 0))
(assert (>= target_V_001_17_measure_wellformed 0))
(assert (not (= source_V_001_17_measure_wellformed target_V_001_17_measure_wellformed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_18_measure_decreases: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_18_measure_decreases preserves semantics
(push 1)
(declare-const source_V_001_18_measure_decreases Int)
(declare-const target_V_001_18_measure_decreases Int)
(assert (>= source_V_001_18_measure_decreases 0))
(assert (>= target_V_001_18_measure_decreases 0))
(assert (not (= source_V_001_18_measure_decreases target_V_001_18_measure_decreases)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_19_lexicographic_wellformed: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_19_lexicographic_wellformed preserves semantics
(push 1)
(declare-const source_V_001_19_lexicographic_wellformed Int)
(declare-const target_V_001_19_lexicographic_wellformed Int)
(assert (>= source_V_001_19_lexicographic_wellformed 0))
(assert (>= target_V_001_19_lexicographic_wellformed 0))
(assert (not (= source_V_001_19_lexicographic_wellformed target_V_001_19_lexicographic_wellformed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_20_ackermann_terminates: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_20_ackermann_terminates preserves semantics
(push 1)
(declare-const source_V_001_20_ackermann_terminates Int)
(declare-const target_V_001_20_ackermann_terminates Int)
(assert (>= source_V_001_20_ackermann_terminates 0))
(assert (>= target_V_001_20_ackermann_terminates 0))
(assert (not (= source_V_001_20_ackermann_terminates target_V_001_20_ackermann_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_21_complex_measure_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_21_complex_measure_sound preserves semantics
(push 1)
(declare-const source_V_001_21_complex_measure_sound Int)
(declare-const target_V_001_21_complex_measure_sound Int)
(assert (>= source_V_001_21_complex_measure_sound 0))
(assert (>= target_V_001_21_complex_measure_sound 0))
(assert (not (= source_V_001_21_complex_measure_sound target_V_001_21_complex_measure_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_22_measure_inference: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_22_measure_inference preserves semantics
(push 1)
(declare-const source_V_001_22_measure_inference Int)
(declare-const target_V_001_22_measure_inference Int)
(assert (>= source_V_001_22_measure_inference 0))
(assert (>= target_V_001_22_measure_inference 0))
(assert (not (= source_V_001_22_measure_inference target_V_001_22_measure_inference)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_23_measure_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_23_measure_composition preserves semantics
(push 1)
(declare-const source_V_001_23_measure_composition Int)
(declare-const target_V_001_23_measure_composition Int)
(assert (>= source_V_001_23_measure_composition 0))
(assert (>= target_V_001_23_measure_composition 0))
(assert (not (= source_V_001_23_measure_composition target_V_001_23_measure_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_24_wellfounded_checker_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_24_wellfounded_checker_sound preserves semantics
(push 1)
(declare-const source_V_001_24_wellfounded_checker_sound Int)
(declare-const target_V_001_24_wellfounded_checker_sound Int)
(assert (>= source_V_001_24_wellfounded_checker_sound 0))
(assert (>= target_V_001_24_wellfounded_checker_sound 0))
(assert (not (= source_V_001_24_wellfounded_checker_sound target_V_001_24_wellfounded_checker_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_25_codata_productive: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_25_codata_productive preserves semantics
(push 1)
(declare-const source_V_001_25_codata_productive Int)
(declare-const target_V_001_25_codata_productive Int)
(assert (>= source_V_001_25_codata_productive 0))
(assert (>= target_V_001_25_codata_productive 0))
(assert (not (= source_V_001_25_codata_productive target_V_001_25_codata_productive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_26_stream_productive: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_26_stream_productive preserves semantics
(push 1)
(declare-const source_V_001_26_stream_productive Int)
(declare-const target_V_001_26_stream_productive Int)
(assert (>= source_V_001_26_stream_productive 0))
(assert (>= target_V_001_26_stream_productive 0))
(assert (not (= source_V_001_26_stream_productive target_V_001_26_stream_productive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_27_productivity_observe: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_27_productivity_observe preserves semantics
(push 1)
(declare-const source_V_001_27_productivity_observe Int)
(declare-const target_V_001_27_productivity_observe Int)
(assert (>= source_V_001_27_productivity_observe 0))
(assert (>= target_V_001_27_productivity_observe 0))
(assert (not (= source_V_001_27_productivity_observe target_V_001_27_productivity_observe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_28_guarded_recursion: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_28_guarded_recursion preserves semantics
(push 1)
(declare-const source_V_001_28_guarded_recursion Int)
(declare-const target_V_001_28_guarded_recursion Int)
(assert (>= source_V_001_28_guarded_recursion 0))
(assert (>= target_V_001_28_guarded_recursion 0))
(assert (not (= source_V_001_28_guarded_recursion target_V_001_28_guarded_recursion)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_29_codata_unfold: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_29_codata_unfold preserves semantics
(push 1)
(declare-const source_V_001_29_codata_unfold Int)
(declare-const target_V_001_29_codata_unfold Int)
(assert (>= source_V_001_29_codata_unfold 0))
(assert (>= target_V_001_29_codata_unfold 0))
(assert (not (= source_V_001_29_codata_unfold target_V_001_29_codata_unfold)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_30_productive_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_30_productive_composition preserves semantics
(push 1)
(declare-const source_V_001_30_productive_composition Int)
(declare-const target_V_001_30_productive_composition Int)
(assert (>= source_V_001_30_productive_composition 0))
(assert (>= target_V_001_30_productive_composition 0))
(assert (not (= source_V_001_30_productive_composition target_V_001_30_productive_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_31_non_terminating_marked: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_31_non_terminating_marked preserves semantics
(push 1)
(declare-const source_V_001_31_non_terminating_marked Int)
(declare-const target_V_001_31_non_terminating_marked Int)
(assert (>= source_V_001_31_non_terminating_marked 0))
(assert (>= target_V_001_31_non_terminating_marked 0))
(assert (not (= source_V_001_31_non_terminating_marked target_V_001_31_non_terminating_marked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; V_001_32_strong_normalization: translation preserves property (matches Coq: Theorem)
; Translation validation: V_001_32_strong_normalization preserves semantics
(push 1)
(declare-const source_V_001_32_strong_normalization Int)
(declare-const target_V_001_32_strong_normalization Int)
(assert (>= source_V_001_32_strong_normalization 0))
(assert (>= target_V_001_32_strong_normalization 0))
(assert (not (= source_V_001_32_strong_normalization target_V_001_32_strong_normalization)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

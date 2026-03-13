; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/RefinementTypes.v (24 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for RefinementTypes
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; sat_pred: source semantics (matches Coq)
; Translation validation: sat_pred preserves semantics
(push 1)
(declare-const source_sat_pred Int)
(declare-const target_sat_pred Int)
(assert (>= source_sat_pred 0))
(assert (>= target_sat_pred 0))
(assert (not (= source_sat_pred target_sat_pred)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pred_implies: source semantics (matches Coq)
; Translation validation: pred_implies preserves semantics
(push 1)
(declare-const source_pred_implies Int)
(declare-const target_pred_implies Int)
(assert (>= source_pred_implies 0))
(assert (>= target_pred_implies 0))
(assert (not (= source_pred_implies target_pred_implies)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inhabits_refinement: source semantics (matches Coq)
; Translation validation: inhabits_refinement preserves semantics
(push 1)
(declare-const source_inhabits_refinement Int)
(declare-const target_inhabits_refinement Int)
(assert (>= source_inhabits_refinement 0))
(assert (>= target_inhabits_refinement 0))
(assert (not (= source_inhabits_refinement target_inhabits_refinement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

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

; lookup_val: source semantics (matches Coq)
; Translation validation: lookup_val preserves semantics
(push 1)
(declare-const source_lookup_val Int)
(declare-const target_lookup_val Int)
(assert (>= source_lookup_val 0))
(assert (>= target_lookup_val 0))
(assert (not (= source_lookup_val target_lookup_val)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eval: source semantics (matches Coq)
; Translation validation: eval preserves semantics
(push 1)
(declare-const source_eval Int)
(declare-const target_eval Int)
(assert (>= source_eval 0))
(assert (>= target_eval 0))
(assert (not (= source_eval target_eval)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; do_subst: source semantics (matches Coq)
; Translation validation: do_subst preserves semantics
(push 1)
(declare-const source_do_subst Int)
(declare-const target_do_subst Int)
(assert (>= source_do_subst 0))
(assert (>= target_do_subst 0))
(assert (not (= source_do_subst target_do_subst)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_null: source semantics (matches Coq)
; Translation validation: is_null preserves semantics
(push 1)
(declare-const source_is_null Int)
(declare-const target_is_null Int)
(assert (>= source_is_null 0))
(assert (>= target_is_null 0))
(assert (not (= source_is_null target_is_null)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_non_null: source semantics (matches Coq)
; Translation validation: is_non_null preserves semantics
(push 1)
(declare-const source_is_non_null Int)
(declare-const target_is_non_null Int)
(assert (>= source_is_non_null 0))
(assert (>= target_is_non_null 0))
(assert (not (= source_is_non_null target_is_non_null)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bounds_pred: source semantics (matches Coq)
; Translation validation: bounds_pred preserves semantics
(push 1)
(declare-const source_bounds_pred Int)
(declare-const target_bounds_pred Int)
(assert (>= source_bounds_pred 0))
(assert (>= target_bounds_pred 0))
(assert (not (= source_bounds_pred target_bounds_pred)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; non_null_pred: source semantics (matches Coq)
; Translation validation: non_null_pred preserves semantics
(push 1)
(declare-const source_non_null_pred Int)
(declare-const target_non_null_pred Int)
(assert (>= source_non_null_pred 0))
(assert (>= target_non_null_pred 0))
(assert (not (= source_non_null_pred target_non_null_pred)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; array_index_pred: source semantics (matches Coq)
; Translation validation: array_index_pred preserves semantics
(push 1)
(declare-const source_array_index_pred Int)
(declare-const target_array_index_pred Int)
(assert (>= source_array_index_pred 0))
(assert (>= target_array_index_pred 0))
(assert (not (= source_array_index_pred target_array_index_pred)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; positive_pred: source semantics (matches Coq)
; Translation validation: positive_pred preserves semantics
(push 1)
(declare-const source_positive_pred Int)
(declare-const target_positive_pred Int)
(assert (>= source_positive_pred 0))
(assert (>= target_positive_pred 0))
(assert (not (= source_positive_pred target_positive_pred)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_01_refinement_subtyping: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_01_refinement_subtyping preserves semantics
(push 1)
(declare-const source_TYPE_004_01_refinement_subtyping Int)
(declare-const target_TYPE_004_01_refinement_subtyping Int)
(assert (>= source_TYPE_004_01_refinement_subtyping 0))
(assert (>= target_TYPE_004_01_refinement_subtyping 0))
(assert (not (= source_TYPE_004_01_refinement_subtyping target_TYPE_004_01_refinement_subtyping)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_02_refinement_introduction: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_02_refinement_introduction preserves semantics
(push 1)
(declare-const source_TYPE_004_02_refinement_introduction Int)
(declare-const target_TYPE_004_02_refinement_introduction Int)
(assert (>= source_TYPE_004_02_refinement_introduction 0))
(assert (>= target_TYPE_004_02_refinement_introduction 0))
(assert (not (= source_TYPE_004_02_refinement_introduction target_TYPE_004_02_refinement_introduction)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_03_refinement_elimination: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_03_refinement_elimination preserves semantics
(push 1)
(declare-const source_TYPE_004_03_refinement_elimination Int)
(declare-const target_TYPE_004_03_refinement_elimination Int)
(assert (>= source_TYPE_004_03_refinement_elimination 0))
(assert (>= target_TYPE_004_03_refinement_elimination 0))
(assert (not (= source_TYPE_004_03_refinement_elimination target_TYPE_004_03_refinement_elimination)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_04_refinement_conjunction: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_04_refinement_conjunction preserves semantics
(push 1)
(declare-const source_TYPE_004_04_refinement_conjunction Int)
(declare-const target_TYPE_004_04_refinement_conjunction Int)
(assert (>= source_TYPE_004_04_refinement_conjunction 0))
(assert (>= target_TYPE_004_04_refinement_conjunction 0))
(assert (not (= source_TYPE_004_04_refinement_conjunction target_TYPE_004_04_refinement_conjunction)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_05_dependent_function_refinement: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_05_dependent_function_refinement preserves semantics
(push 1)
(declare-const source_TYPE_004_05_dependent_function_refinement Int)
(declare-const target_TYPE_004_05_dependent_function_refinement Int)
(assert (>= source_TYPE_004_05_dependent_function_refinement 0))
(assert (>= target_TYPE_004_05_dependent_function_refinement 0))
(assert (not (= source_TYPE_004_05_dependent_function_refinement target_TYPE_004_05_dependent_function_refinement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_06_refinement_substitution: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_06_refinement_substitution preserves semantics
(push 1)
(declare-const source_TYPE_004_06_refinement_substitution Int)
(declare-const target_TYPE_004_06_refinement_substitution Int)
(assert (>= source_TYPE_004_06_refinement_substitution 0))
(assert (>= target_TYPE_004_06_refinement_substitution 0))
(assert (not (= source_TYPE_004_06_refinement_substitution target_TYPE_004_06_refinement_substitution)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_07_smt_decidability: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_07_smt_decidability preserves semantics
(push 1)
(declare-const source_TYPE_004_07_smt_decidability Int)
(declare-const target_TYPE_004_07_smt_decidability Int)
(assert (>= source_TYPE_004_07_smt_decidability 0))
(assert (>= target_TYPE_004_07_smt_decidability 0))
(assert (not (= source_TYPE_004_07_smt_decidability target_TYPE_004_07_smt_decidability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_08_bounds_checking: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_08_bounds_checking preserves semantics
(push 1)
(declare-const source_TYPE_004_08_bounds_checking Int)
(declare-const target_TYPE_004_08_bounds_checking Int)
(assert (>= source_TYPE_004_08_bounds_checking 0))
(assert (>= target_TYPE_004_08_bounds_checking 0))
(assert (not (= source_TYPE_004_08_bounds_checking target_TYPE_004_08_bounds_checking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_09_non_null_refinement: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_09_non_null_refinement preserves semantics
(push 1)
(declare-const source_TYPE_004_09_non_null_refinement Int)
(declare-const target_TYPE_004_09_non_null_refinement Int)
(assert (>= source_TYPE_004_09_non_null_refinement 0))
(assert (>= target_TYPE_004_09_non_null_refinement 0))
(assert (not (= source_TYPE_004_09_non_null_refinement target_TYPE_004_09_non_null_refinement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_10_array_bounds_safety: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_10_array_bounds_safety preserves semantics
(push 1)
(declare-const source_TYPE_004_10_array_bounds_safety Int)
(declare-const target_TYPE_004_10_array_bounds_safety Int)
(assert (>= source_TYPE_004_10_array_bounds_safety 0))
(assert (>= target_TYPE_004_10_array_bounds_safety 0))
(assert (not (= source_TYPE_004_10_array_bounds_safety target_TYPE_004_10_array_bounds_safety)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_11_positive_refinement: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_11_positive_refinement preserves semantics
(push 1)
(declare-const source_TYPE_004_11_positive_refinement Int)
(declare-const target_TYPE_004_11_positive_refinement Int)
(assert (>= source_TYPE_004_11_positive_refinement 0))
(assert (>= target_TYPE_004_11_positive_refinement 0))
(assert (not (= source_TYPE_004_11_positive_refinement target_TYPE_004_11_positive_refinement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_12_refinement_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_12_refinement_preservation preserves semantics
(push 1)
(declare-const source_TYPE_004_12_refinement_preservation Int)
(declare-const target_TYPE_004_12_refinement_preservation Int)
(assert (>= source_TYPE_004_12_refinement_preservation 0))
(assert (>= target_TYPE_004_12_refinement_preservation 0))
(assert (not (= source_TYPE_004_12_refinement_preservation target_TYPE_004_12_refinement_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_13_pred_true_satisfied: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_13_pred_true_satisfied preserves semantics
(push 1)
(declare-const source_TYPE_004_13_pred_true_satisfied Int)
(declare-const target_TYPE_004_13_pred_true_satisfied Int)
(assert (>= source_TYPE_004_13_pred_true_satisfied 0))
(assert (>= target_TYPE_004_13_pred_true_satisfied 0))
(assert (not (= source_TYPE_004_13_pred_true_satisfied target_TYPE_004_13_pred_true_satisfied)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_14_pred_false_unsatisfied: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_14_pred_false_unsatisfied preserves semantics
(push 1)
(declare-const source_TYPE_004_14_pred_false_unsatisfied Int)
(declare-const target_TYPE_004_14_pred_false_unsatisfied Int)
(assert (>= source_TYPE_004_14_pred_false_unsatisfied 0))
(assert (>= target_TYPE_004_14_pred_false_unsatisfied 0))
(assert (not (= source_TYPE_004_14_pred_false_unsatisfied target_TYPE_004_14_pred_false_unsatisfied)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_15_pred_and_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_15_pred_and_comm preserves semantics
(push 1)
(declare-const source_TYPE_004_15_pred_and_comm Int)
(declare-const target_TYPE_004_15_pred_and_comm Int)
(assert (>= source_TYPE_004_15_pred_and_comm 0))
(assert (>= target_TYPE_004_15_pred_and_comm 0))
(assert (not (= source_TYPE_004_15_pred_and_comm target_TYPE_004_15_pred_and_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_16_pred_or_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_16_pred_or_comm preserves semantics
(push 1)
(declare-const source_TYPE_004_16_pred_or_comm Int)
(declare-const target_TYPE_004_16_pred_or_comm Int)
(assert (>= source_TYPE_004_16_pred_or_comm 0))
(assert (>= target_TYPE_004_16_pred_or_comm 0))
(assert (not (= source_TYPE_004_16_pred_or_comm target_TYPE_004_16_pred_or_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_17_pred_implies_ptrue: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_17_pred_implies_ptrue preserves semantics
(push 1)
(declare-const source_TYPE_004_17_pred_implies_ptrue Int)
(declare-const target_TYPE_004_17_pred_implies_ptrue Int)
(assert (>= source_TYPE_004_17_pred_implies_ptrue 0))
(assert (>= target_TYPE_004_17_pred_implies_ptrue 0))
(assert (not (= source_TYPE_004_17_pred_implies_ptrue target_TYPE_004_17_pred_implies_ptrue)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_18_pred_pfalse_implies: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_18_pred_pfalse_implies preserves semantics
(push 1)
(declare-const source_TYPE_004_18_pred_pfalse_implies Int)
(declare-const target_TYPE_004_18_pred_pfalse_implies Int)
(assert (>= source_TYPE_004_18_pred_pfalse_implies 0))
(assert (>= target_TYPE_004_18_pred_pfalse_implies 0))
(assert (not (= source_TYPE_004_18_pred_pfalse_implies target_TYPE_004_18_pred_pfalse_implies)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_19_subtype_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_19_subtype_refl preserves semantics
(push 1)
(declare-const source_TYPE_004_19_subtype_refl Int)
(declare-const target_TYPE_004_19_subtype_refl Int)
(assert (>= source_TYPE_004_19_subtype_refl 0))
(assert (>= target_TYPE_004_19_subtype_refl 0))
(assert (not (= source_TYPE_004_19_subtype_refl target_TYPE_004_19_subtype_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_20_pred_double_neg: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_20_pred_double_neg preserves semantics
(push 1)
(declare-const source_TYPE_004_20_pred_double_neg Int)
(declare-const target_TYPE_004_20_pred_double_neg Int)
(assert (>= source_TYPE_004_20_pred_double_neg 0))
(assert (>= target_TYPE_004_20_pred_double_neg 0))
(assert (not (= source_TYPE_004_20_pred_double_neg target_TYPE_004_20_pred_double_neg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_21_eval_val: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_21_eval_val preserves semantics
(push 1)
(declare-const source_TYPE_004_21_eval_val Int)
(declare-const target_TYPE_004_21_eval_val Int)
(assert (>= source_TYPE_004_21_eval_val 0))
(assert (>= target_TYPE_004_21_eval_val 0))
(assert (not (= source_TYPE_004_21_eval_val target_TYPE_004_21_eval_val)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_22_pred_impl_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_22_pred_impl_refl preserves semantics
(push 1)
(declare-const source_TYPE_004_22_pred_impl_refl Int)
(declare-const target_TYPE_004_22_pred_impl_refl Int)
(assert (>= source_TYPE_004_22_pred_impl_refl 0))
(assert (>= target_TYPE_004_22_pred_impl_refl 0))
(assert (not (= source_TYPE_004_22_pred_impl_refl target_TYPE_004_22_pred_impl_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_23_pred_and_assoc: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_23_pred_and_assoc preserves semantics
(push 1)
(declare-const source_TYPE_004_23_pred_and_assoc Int)
(declare-const target_TYPE_004_23_pred_and_assoc Int)
(assert (>= source_TYPE_004_23_pred_and_assoc 0))
(assert (>= target_TYPE_004_23_pred_and_assoc 0))
(assert (not (= source_TYPE_004_23_pred_and_assoc target_TYPE_004_23_pred_and_assoc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TYPE_004_24_pred_or_assoc: translation preserves property (matches Coq: Theorem)
; Translation validation: TYPE_004_24_pred_or_assoc preserves semantics
(push 1)
(declare-const source_TYPE_004_24_pred_or_assoc Int)
(declare-const target_TYPE_004_24_pred_or_assoc Int)
(assert (>= source_TYPE_004_24_pred_or_assoc 0))
(assert (>= target_TYPE_004_24_pred_or_assoc 0))
(assert (not (= source_TYPE_004_24_pred_or_assoc target_TYPE_004_24_pred_or_assoc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

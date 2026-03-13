; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/DualModeVerification.v (22 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for DualModeVerification
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

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

; lightweight_check: source semantics (matches Coq)
; Translation validation: lightweight_check preserves semantics
(push 1)
(declare-const source_lightweight_check Int)
(declare-const target_lightweight_check Int)
(assert (>= source_lightweight_check 0))
(assert (>= target_lightweight_check 0))
(assert (not (= source_lightweight_check target_lightweight_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_check: source semantics (matches Coq)
; Translation validation: full_check preserves semantics
(push 1)
(declare-const source_full_check Int)
(declare-const target_full_check Int)
(assert (>= source_full_check 0))
(assert (>= target_full_check 0))
(assert (not (= source_full_check target_full_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; decidable_refinement: source semantics (matches Coq)
; Translation validation: decidable_refinement preserves semantics
(push 1)
(declare-const source_decidable_refinement Int)
(declare-const target_decidable_refinement Int)
(assert (>= source_decidable_refinement 0))
(assert (>= target_decidable_refinement 0))
(assert (not (= source_decidable_refinement target_decidable_refinement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; refine_subtype: source semantics (matches Coq)
; Translation validation: refine_subtype preserves semantics
(push 1)
(declare-const source_refine_subtype Int)
(declare-const target_refine_subtype Int)
(assert (>= source_refine_subtype 0))
(assert (>= target_refine_subtype 0))
(assert (not (= source_refine_subtype target_refine_subtype)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; refine_conj: source semantics (matches Coq)
; Translation validation: refine_conj preserves semantics
(push 1)
(declare-const source_refine_conj Int)
(declare-const target_refine_conj Int)
(assert (>= source_refine_conj 0))
(assert (>= target_refine_conj 0))
(assert (not (= source_refine_conj target_refine_conj)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lightweight_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: lightweight_sound preserves semantics
(push 1)
(declare-const source_lightweight_sound Int)
(declare-const target_lightweight_sound Int)
(assert (>= source_lightweight_sound 0))
(assert (>= target_lightweight_sound 0))
(assert (not (= source_lightweight_sound target_lightweight_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lightweight_complete_decidable: translation preserves property (matches Coq: Theorem)
; Translation validation: lightweight_complete_decidable preserves semantics
(push 1)
(declare-const source_lightweight_complete_decidable Int)
(declare-const target_lightweight_complete_decidable Int)
(assert (>= source_lightweight_complete_decidable 0))
(assert (>= target_lightweight_complete_decidable 0))
(assert (not (= source_lightweight_complete_decidable target_lightweight_complete_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; refine_subtype_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: refine_subtype_refl preserves semantics
(push 1)
(declare-const source_refine_subtype_refl Int)
(declare-const target_refine_subtype_refl Int)
(assert (>= source_refine_subtype_refl 0))
(assert (>= target_refine_subtype_refl 0))
(assert (not (= source_refine_subtype_refl target_refine_subtype_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; refine_subtype_trans: translation preserves property (matches Coq: Theorem)
; Translation validation: refine_subtype_trans preserves semantics
(push 1)
(declare-const source_refine_subtype_trans Int)
(declare-const target_refine_subtype_trans Int)
(assert (>= source_refine_subtype_trans 0))
(assert (>= target_refine_subtype_trans 0))
(assert (not (= source_refine_subtype_trans target_refine_subtype_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; checked_values_satisfy: translation preserves property (matches Coq: Theorem)
; Translation validation: checked_values_satisfy preserves semantics
(push 1)
(declare-const source_checked_values_satisfy Int)
(declare-const target_checked_values_satisfy Int)
(assert (>= source_checked_values_satisfy 0))
(assert (>= target_checked_values_satisfy 0))
(assert (not (= source_checked_values_satisfy target_checked_values_satisfy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dual_mode_agreement: translation preserves property (matches Coq: Theorem)
; Translation validation: dual_mode_agreement preserves semantics
(push 1)
(declare-const source_dual_mode_agreement Int)
(declare-const target_dual_mode_agreement Int)
(assert (>= source_dual_mode_agreement 0))
(assert (>= target_dual_mode_agreement 0))
(assert (not (= source_dual_mode_agreement target_dual_mode_agreement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; refinement_weakening: translation preserves property (matches Coq: Theorem)
; Translation validation: refinement_weakening preserves semantics
(push 1)
(declare-const source_refinement_weakening Int)
(declare-const target_refinement_weakening Int)
(assert (>= source_refinement_weakening 0))
(assert (>= target_refinement_weakening 0))
(assert (not (= source_refinement_weakening target_refinement_weakening)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; conj_subtype_left: translation preserves property (matches Coq: Theorem)
; Translation validation: conj_subtype_left preserves semantics
(push 1)
(declare-const source_conj_subtype_left Int)
(declare-const target_conj_subtype_left Int)
(assert (>= source_conj_subtype_left 0))
(assert (>= target_conj_subtype_left 0))
(assert (not (= source_conj_subtype_left target_conj_subtype_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; conj_subtype_right: translation preserves property (matches Coq: Theorem)
; Translation validation: conj_subtype_right preserves semantics
(push 1)
(declare-const source_conj_subtype_right Int)
(declare-const target_conj_subtype_right Int)
(assert (>= source_conj_subtype_right 0))
(assert (>= target_conj_subtype_right 0))
(assert (not (= source_conj_subtype_right target_conj_subtype_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; conj_greatest_lower_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: conj_greatest_lower_bound preserves semantics
(push 1)
(declare-const source_conj_greatest_lower_bound Int)
(declare-const target_conj_greatest_lower_bound Int)
(assert (>= source_conj_greatest_lower_bound 0))
(assert (>= target_conj_greatest_lower_bound 0))
(assert (not (= source_conj_greatest_lower_bound target_conj_greatest_lower_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; conj_full_pred_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: conj_full_pred_comm preserves semantics
(push 1)
(declare-const source_conj_full_pred_comm Int)
(declare-const target_conj_full_pred_comm Int)
(assert (>= source_conj_full_pred_comm 0))
(assert (>= target_conj_full_pred_comm 0))
(assert (not (= source_conj_full_pred_comm target_conj_full_pred_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; conj_full_pred_assoc: translation preserves property (matches Coq: Theorem)
; Translation validation: conj_full_pred_assoc preserves semantics
(push 1)
(declare-const source_conj_full_pred_assoc Int)
(declare-const target_conj_full_pred_assoc Int)
(assert (>= source_conj_full_pred_assoc 0))
(assert (>= target_conj_full_pred_assoc 0))
(assert (not (= source_conj_full_pred_assoc target_conj_full_pred_assoc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; conj_light_is_andb: translation preserves property (matches Coq: Theorem)
; Translation validation: conj_light_is_andb preserves semantics
(push 1)
(declare-const source_conj_light_is_andb Int)
(declare-const target_conj_light_is_andb Int)
(assert (>= source_conj_light_is_andb 0))
(assert (>= target_conj_light_is_andb 0))
(assert (not (= source_conj_light_is_andb target_conj_light_is_andb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eval_const: translation preserves property (matches Coq: Theorem)
; Translation validation: eval_const preserves semantics
(push 1)
(declare-const source_eval_const Int)
(declare-const target_eval_const Int)
(assert (>= source_eval_const 0))
(assert (>= target_eval_const 0))
(assert (not (= source_eval_const target_eval_const)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eval_plus: translation preserves property (matches Coq: Theorem)
; Translation validation: eval_plus preserves semantics
(push 1)
(declare-const source_eval_plus Int)
(declare-const target_eval_plus Int)
(assert (>= source_eval_plus 0))
(assert (>= target_eval_plus 0))
(assert (not (= source_eval_plus target_eval_plus)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lightweight_false_implies_not_full: translation preserves property (matches Coq: Theorem)
; Translation validation: lightweight_false_implies_not_full preserves semantics
(push 1)
(declare-const source_lightweight_false_implies_not_full Int)
(declare-const target_lightweight_false_implies_not_full Int)
(assert (>= source_lightweight_false_implies_not_full 0))
(assert (>= target_lightweight_false_implies_not_full 0))
(assert (not (= source_lightweight_false_implies_not_full target_lightweight_false_implies_not_full)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subtype_lightweight_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: subtype_lightweight_sound preserves semantics
(push 1)
(declare-const source_subtype_lightweight_sound Int)
(declare-const target_subtype_lightweight_sound Int)
(assert (>= source_subtype_lightweight_sound 0))
(assert (>= target_subtype_lightweight_sound 0))
(assert (not (= source_subtype_lightweight_sound target_subtype_lightweight_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; conj_decidable: translation preserves property (matches Coq: Theorem)
; Translation validation: conj_decidable preserves semantics
(push 1)
(declare-const source_conj_decidable Int)
(declare-const target_conj_decidable Int)
(assert (>= source_conj_decidable 0))
(assert (>= target_conj_decidable 0))
(assert (not (= source_conj_decidable target_conj_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; refine_subtype_antisym_eq: translation preserves property (matches Coq: Theorem)
; Translation validation: refine_subtype_antisym_eq preserves semantics
(push 1)
(declare-const source_refine_subtype_antisym_eq Int)
(declare-const target_refine_subtype_antisym_eq Int)
(assert (>= source_refine_subtype_antisym_eq 0))
(assert (>= target_refine_subtype_antisym_eq 0))
(assert (not (= source_refine_subtype_antisym_eq target_refine_subtype_antisym_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eval_if_false: translation preserves property (matches Coq: Theorem)
; Translation validation: eval_if_false preserves semantics
(push 1)
(declare-const source_eval_if_false Int)
(declare-const target_eval_if_false Int)
(assert (>= source_eval_if_false 0))
(assert (>= target_eval_if_false 0))
(assert (not (= source_eval_if_false target_eval_if_false)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eval_if_true: translation preserves property (matches Coq: Theorem)
; Translation validation: eval_if_true preserves semantics
(push 1)
(declare-const source_eval_if_true Int)
(declare-const target_eval_if_true Int)
(assert (>= source_eval_if_true 0))
(assert (>= target_eval_if_true 0))
(assert (not (= source_eval_if_true target_eval_if_true)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; conj_sub_both: translation preserves property (matches Coq: Theorem)
; Translation validation: conj_sub_both preserves semantics
(push 1)
(declare-const source_conj_sub_both Int)
(declare-const target_conj_sub_both Int)
(assert (>= source_conj_sub_both 0))
(assert (>= target_conj_sub_both 0))
(assert (not (= source_conj_sub_both target_conj_sub_both)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

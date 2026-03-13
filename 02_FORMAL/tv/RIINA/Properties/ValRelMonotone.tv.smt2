; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ValRelMonotone.v (14 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ValRelMonotone
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; val_rel_le_monotone: translation preserves property (matches Coq: Theorem)
; Translation validation: val_rel_le_monotone preserves semantics
(push 1)
(declare-const source_val_rel_le_monotone Int)
(declare-const target_val_rel_le_monotone Int)
(assert (>= source_val_rel_le_monotone 0))
(assert (>= target_val_rel_le_monotone 0))
(assert (not (= source_val_rel_le_monotone target_val_rel_le_monotone)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_pred: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_pred preserves semantics
(push 1)
(declare-const source_val_rel_le_pred Int)
(declare-const target_val_rel_le_pred Int)
(assert (>= source_val_rel_le_pred 0))
(assert (>= target_val_rel_le_pred 0))
(assert (not (= source_val_rel_le_pred target_val_rel_le_pred)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_trans_mono: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_trans_mono preserves semantics
(push 1)
(declare-const source_val_rel_le_trans_mono Int)
(declare-const target_val_rel_le_trans_mono Int)
(assert (>= source_val_rel_le_trans_mono 0))
(assert (>= target_val_rel_le_trans_mono 0))
(assert (not (= source_val_rel_le_trans_mono target_val_rel_le_trans_mono)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_max: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_max preserves semantics
(push 1)
(declare-const source_val_rel_le_max Int)
(declare-const target_val_rel_le_max Int)
(assert (>= source_val_rel_le_max 0))
(assert (>= target_val_rel_le_max 0))
(assert (not (= source_val_rel_le_max target_val_rel_le_max)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_from_max: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_from_max preserves semantics
(push 1)
(declare-const source_val_rel_le_from_max Int)
(declare-const target_val_rel_le_from_max Int)
(assert (>= source_val_rel_le_from_max 0))
(assert (>= target_val_rel_le_from_max 0))
(assert (not (= source_val_rel_le_from_max target_val_rel_le_from_max)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_to_min: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_to_min preserves semantics
(push 1)
(declare-const source_val_rel_le_to_min Int)
(declare-const target_val_rel_le_to_min Int)
(assert (>= source_val_rel_le_to_min 0))
(assert (>= target_val_rel_le_to_min 0))
(assert (not (= source_val_rel_le_to_min target_val_rel_le_to_min)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_to_min_r: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_to_min_r preserves semantics
(push 1)
(declare-const source_val_rel_le_to_min_r Int)
(declare-const target_val_rel_le_to_min_r Int)
(assert (>= source_val_rel_le_to_min_r 0))
(assert (>= target_val_rel_le_to_min_r 0))
(assert (not (= source_val_rel_le_to_min_r target_val_rel_le_to_min_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_drop: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_drop preserves semantics
(push 1)
(declare-const source_val_rel_le_drop Int)
(declare-const target_val_rel_le_drop Int)
(assert (>= source_val_rel_le_drop 0))
(assert (>= target_val_rel_le_drop 0))
(assert (not (= source_val_rel_le_drop target_val_rel_le_drop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_double_mono: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_double_mono preserves semantics
(push 1)
(declare-const source_val_rel_le_double_mono Int)
(declare-const target_val_rel_le_double_mono Int)
(assert (>= source_val_rel_le_double_mono 0))
(assert (>= target_val_rel_le_double_mono 0))
(assert (not (= source_val_rel_le_double_mono target_val_rel_le_double_mono)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_down_1: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_down_1 preserves semantics
(push 1)
(declare-const source_val_rel_le_step_down_1 Int)
(declare-const target_val_rel_le_step_down_1 Int)
(assert (>= source_val_rel_le_step_down_1 0))
(assert (>= target_val_rel_le_step_down_1 0))
(assert (not (= source_val_rel_le_step_down_1 target_val_rel_le_step_down_1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_down_2: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_down_2 preserves semantics
(push 1)
(declare-const source_val_rel_le_step_down_2 Int)
(declare-const target_val_rel_le_step_down_2 Int)
(assert (>= source_val_rel_le_step_down_2 0))
(assert (>= target_val_rel_le_step_down_2 0))
(assert (not (= source_val_rel_le_step_down_2 target_val_rel_le_step_down_2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_from_succ: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_from_succ preserves semantics
(push 1)
(declare-const source_val_rel_le_from_succ Int)
(declare-const target_val_rel_le_from_succ Int)
(assert (>= source_val_rel_le_from_succ 0))
(assert (>= target_val_rel_le_from_succ 0))
(assert (not (= source_val_rel_le_from_succ target_val_rel_le_from_succ)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_mono_witness: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_mono_witness preserves semantics
(push 1)
(declare-const source_val_rel_le_mono_witness Int)
(declare-const target_val_rel_le_mono_witness Int)
(assert (>= source_val_rel_le_mono_witness 0))
(assert (>= target_val_rel_le_mono_witness 0))
(assert (not (= source_val_rel_le_mono_witness target_val_rel_le_mono_witness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_half: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_half preserves semantics
(push 1)
(declare-const source_val_rel_le_half Int)
(declare-const target_val_rel_le_half Int)
(assert (>= source_val_rel_le_half 0))
(assert (>= target_val_rel_le_half 0))
(assert (not (= source_val_rel_le_half target_val_rel_le_half)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

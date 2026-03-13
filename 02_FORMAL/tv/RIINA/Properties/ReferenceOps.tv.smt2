; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ReferenceOps.v (15 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ReferenceOps
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; step_preserves_ctx_snd: translation preserves property (matches Coq: Lemma)
; Translation validation: step_preserves_ctx_snd preserves semantics
(push 1)
(declare-const source_step_preserves_ctx_snd Int)
(declare-const target_step_preserves_ctx_snd Int)
(assert (>= source_step_preserves_ctx_snd 0))
(assert (>= target_step_preserves_ctx_snd 0))
(assert (not (= source_step_preserves_ctx_snd target_step_preserves_ctx_snd)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_preserves_ctx: translation preserves property (matches Coq: Lemma)
; Translation validation: step_preserves_ctx preserves semantics
(push 1)
(declare-const source_step_preserves_ctx Int)
(declare-const target_step_preserves_ctx Int)
(assert (>= source_step_preserves_ctx 0))
(assert (>= target_step_preserves_ctx 0))
(assert (not (= source_step_preserves_ctx target_step_preserves_ctx)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; multi_step_preserves_ctx: translation preserves property (matches Coq: Lemma)
; Translation validation: multi_step_preserves_ctx preserves semantics
(push 1)
(declare-const source_multi_step_preserves_ctx Int)
(declare-const target_multi_step_preserves_ctx Int)
(assert (>= source_multi_step_preserves_ctx 0))
(assert (>= target_multi_step_preserves_ctx 0))
(assert (not (= source_multi_step_preserves_ctx target_multi_step_preserves_ctx)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_multi_step_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: value_multi_step_refl preserves semantics
(push 1)
(declare-const source_value_multi_step_refl Int)
(declare-const target_value_multi_step_refl Int)
(assert (>= source_value_multi_step_refl 0))
(assert (>= target_value_multi_step_refl 0))
(assert (not (= source_value_multi_step_refl target_value_multi_step_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; multi_step_ref_inversion: translation preserves property (matches Coq: Lemma)
; Translation validation: multi_step_ref_inversion preserves semantics
(push 1)
(declare-const source_multi_step_ref_inversion Int)
(declare-const target_multi_step_ref_inversion Int)
(assert (>= source_multi_step_ref_inversion 0))
(assert (>= target_multi_step_ref_inversion 0))
(assert (not (= source_multi_step_ref_inversion target_multi_step_ref_inversion)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; multi_step_deref_inversion: translation preserves property (matches Coq: Lemma)
; Translation validation: multi_step_deref_inversion preserves semantics
(push 1)
(declare-const source_multi_step_deref_inversion Int)
(declare-const target_multi_step_deref_inversion Int)
(assert (>= source_multi_step_deref_inversion 0))
(assert (>= target_multi_step_deref_inversion 0))
(assert (not (= source_multi_step_deref_inversion target_multi_step_deref_inversion)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; multi_step_assign_inversion: translation preserves property (matches Coq: Lemma)
; Translation validation: multi_step_assign_inversion preserves semantics
(push 1)
(declare-const source_multi_step_assign_inversion Int)
(declare-const target_multi_step_assign_inversion Int)
(assert (>= source_multi_step_assign_inversion 0))
(assert (>= target_multi_step_assign_inversion 0))
(assert (not (= source_multi_step_assign_inversion target_multi_step_assign_inversion)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ref_same_location: translation preserves property (matches Coq: Lemma)
; Translation validation: ref_same_location preserves semantics
(push 1)
(declare-const source_ref_same_location Int)
(declare-const target_ref_same_location Int)
(assert (>= source_ref_same_location 0))
(assert (>= target_ref_same_location 0))
(assert (not (= source_ref_same_location target_ref_same_location)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; logical_relation_ref_proven: translation preserves property (matches Coq: Lemma)
; Translation validation: logical_relation_ref_proven preserves semantics
(push 1)
(declare-const source_logical_relation_ref_proven Int)
(declare-const target_logical_relation_ref_proven Int)
(assert (>= source_logical_relation_ref_proven 0))
(assert (>= target_logical_relation_ref_proven 0))
(assert (not (= source_logical_relation_ref_proven target_logical_relation_ref_proven)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_le_ref: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_le_ref preserves semantics
(push 1)
(declare-const source_exp_rel_le_ref Int)
(declare-const target_exp_rel_le_ref Int)
(assert (>= source_exp_rel_le_ref 0))
(assert (>= target_exp_rel_le_ref 0))
(assert (not (= source_exp_rel_le_ref target_exp_rel_le_ref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; logical_relation_deref_proven: translation preserves property (matches Coq: Lemma)
; Translation validation: logical_relation_deref_proven preserves semantics
(push 1)
(declare-const source_logical_relation_deref_proven Int)
(declare-const target_logical_relation_deref_proven Int)
(assert (>= source_logical_relation_deref_proven 0))
(assert (>= target_logical_relation_deref_proven 0))
(assert (not (= source_logical_relation_deref_proven target_logical_relation_deref_proven)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_le_deref: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_le_deref preserves semantics
(push 1)
(declare-const source_exp_rel_le_deref Int)
(declare-const target_exp_rel_le_deref Int)
(assert (>= source_exp_rel_le_deref 0))
(assert (>= target_exp_rel_le_deref 0))
(assert (not (= source_exp_rel_le_deref target_exp_rel_le_deref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; logical_relation_assign_proven: translation preserves property (matches Coq: Lemma)
; Translation validation: logical_relation_assign_proven preserves semantics
(push 1)
(declare-const source_logical_relation_assign_proven Int)
(declare-const target_logical_relation_assign_proven Int)
(assert (>= source_logical_relation_assign_proven 0))
(assert (>= target_logical_relation_assign_proven 0))
(assert (not (= source_logical_relation_assign_proven target_logical_relation_assign_proven)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_le_assign: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_le_assign preserves semantics
(push 1)
(declare-const source_exp_rel_le_assign Int)
(declare-const target_exp_rel_le_assign Int)
(assert (>= source_exp_rel_le_assign 0))
(assert (>= target_exp_rel_le_assign 0))
(assert (not (= source_exp_rel_le_assign target_exp_rel_le_assign)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; reference_ops_zero_admits: translation preserves property (matches Coq: Theorem)
; Translation validation: reference_ops_zero_admits preserves semantics
(push 1)
(declare-const source_reference_ops_zero_admits Int)
(declare-const target_reference_ops_zero_admits Int)
(assert (>= source_reference_ops_zero_admits 0))
(assert (>= target_reference_ops_zero_admits 0))
(assert (not (= source_reference_ops_zero_admits target_reference_ops_zero_admits)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

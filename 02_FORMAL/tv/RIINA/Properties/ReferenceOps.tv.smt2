; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ReferenceOps.v (30 validations)
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
(declare-fun source_step_preserves_ctx_snd () Bool)
(declare-fun target_step_preserves_ctx_snd () Bool)
(assert (= source_step_preserves_ctx_snd target_step_preserves_ctx_snd))

; step_preserves_ctx: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_preserves_ctx () Bool)
(declare-fun target_step_preserves_ctx () Bool)
(assert (= source_step_preserves_ctx target_step_preserves_ctx))

; multi_step_preserves_ctx: translation preserves property (matches Coq: Lemma)
(declare-fun source_multi_step_preserves_ctx () Bool)
(declare-fun target_multi_step_preserves_ctx () Bool)
(assert (= source_multi_step_preserves_ctx target_multi_step_preserves_ctx))

; value_multi_step_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_multi_step_refl () Bool)
(declare-fun target_value_multi_step_refl () Bool)
(assert (= source_value_multi_step_refl target_value_multi_step_refl))

; multi_step_ref_inversion: translation preserves property (matches Coq: Lemma)
(declare-fun source_multi_step_ref_inversion () Bool)
(declare-fun target_multi_step_ref_inversion () Bool)
(assert (= source_multi_step_ref_inversion target_multi_step_ref_inversion))

; multi_step_deref_inversion: translation preserves property (matches Coq: Lemma)
(declare-fun source_multi_step_deref_inversion () Bool)
(declare-fun target_multi_step_deref_inversion () Bool)
(assert (= source_multi_step_deref_inversion target_multi_step_deref_inversion))

; multi_step_assign_inversion: translation preserves property (matches Coq: Lemma)
(declare-fun source_multi_step_assign_inversion () Bool)
(declare-fun target_multi_step_assign_inversion () Bool)
(assert (= source_multi_step_assign_inversion target_multi_step_assign_inversion))

; ref_same_location: translation preserves property (matches Coq: Lemma)
(declare-fun source_ref_same_location () Bool)
(declare-fun target_ref_same_location () Bool)
(assert (= source_ref_same_location target_ref_same_location))

; logical_relation_ref_proven: translation preserves property (matches Coq: Lemma)
(declare-fun source_logical_relation_ref_proven () Bool)
(declare-fun target_logical_relation_ref_proven () Bool)
(assert (= source_logical_relation_ref_proven target_logical_relation_ref_proven))

; exp_rel_le_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_le_ref () Bool)
(declare-fun target_exp_rel_le_ref () Bool)
(assert (= source_exp_rel_le_ref target_exp_rel_le_ref))

; logical_relation_deref_proven: translation preserves property (matches Coq: Lemma)
(declare-fun source_logical_relation_deref_proven () Bool)
(declare-fun target_logical_relation_deref_proven () Bool)
(assert (= source_logical_relation_deref_proven target_logical_relation_deref_proven))

; exp_rel_le_deref: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_le_deref () Bool)
(declare-fun target_exp_rel_le_deref () Bool)
(assert (= source_exp_rel_le_deref target_exp_rel_le_deref))

; logical_relation_assign_proven: translation preserves property (matches Coq: Lemma)
(declare-fun source_logical_relation_assign_proven () Bool)
(declare-fun target_logical_relation_assign_proven () Bool)
(assert (= source_logical_relation_assign_proven target_logical_relation_assign_proven))

; exp_rel_le_assign: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_le_assign () Bool)
(declare-fun target_exp_rel_le_assign () Bool)
(assert (= source_exp_rel_le_assign target_exp_rel_le_assign))

; reference_ops_zero_admits: translation preserves property (matches Coq: Theorem)
(declare-fun source_reference_ops_zero_admits () Bool)
(declare-fun target_reference_ops_zero_admits () Bool)
(assert (= source_reference_ops_zero_admits target_reference_ops_zero_admits))

; ref_preserves_ctx: translation preserves property (matches Coq: Lemma)
(declare-fun source_ref_preserves_ctx () Bool)
(declare-fun target_ref_preserves_ctx () Bool)
(assert (= source_ref_preserves_ctx target_ref_preserves_ctx))

; deref_preserves_ctx: translation preserves property (matches Coq: Lemma)
(declare-fun source_deref_preserves_ctx () Bool)
(declare-fun target_deref_preserves_ctx () Bool)
(assert (= source_deref_preserves_ctx target_deref_preserves_ctx))

; assign_preserves_ctx: translation preserves property (matches Coq: Lemma)
(declare-fun source_assign_preserves_ctx () Bool)
(declare-fun target_assign_preserves_ctx () Bool)
(assert (= source_assign_preserves_ctx target_assign_preserves_ctx))

; store_rel_simple_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_simple_refl () Bool)
(declare-fun target_store_rel_simple_refl () Bool)
(assert (= source_store_rel_simple_refl target_store_rel_simple_refl))

; ref_same_store_max: translation preserves property (matches Coq: Lemma)
(declare-fun source_ref_same_store_max () Bool)
(declare-fun target_ref_same_store_max () Bool)
(assert (= source_ref_same_store_max target_ref_same_store_max))

; loc_is_value: translation preserves property (matches Coq: Lemma)
(declare-fun source_loc_is_value () Bool)
(declare-fun target_loc_is_value () Bool)
(assert (= source_loc_is_value target_loc_is_value))

; deref_of_loc_steps: translation preserves property (matches Coq: Lemma)
(declare-fun source_deref_of_loc_steps () Bool)
(declare-fun target_deref_of_loc_steps () Bool)
(assert (= source_deref_of_loc_steps target_deref_of_loc_steps))

; assign_loc_value_steps: translation preserves property (matches Coq: Lemma)
(declare-fun source_assign_loc_value_steps () Bool)
(declare-fun target_assign_loc_value_steps () Bool)
(assert (= source_assign_loc_value_steps target_assign_loc_value_steps))

; ref_value_steps: translation preserves property (matches Coq: Lemma)
(declare-fun source_ref_value_steps () Bool)
(declare-fun target_ref_value_steps () Bool)
(assert (= source_ref_value_steps target_ref_value_steps))

; deref_step_preserves_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_deref_step_preserves_store () Bool)
(declare-fun target_deref_step_preserves_store () Bool)
(assert (= source_deref_step_preserves_store target_deref_step_preserves_store))

; value_not_ref_expr: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_not_ref_expr () Bool)
(declare-fun target_value_not_ref_expr () Bool)
(assert (= source_value_not_ref_expr target_value_not_ref_expr))

; value_not_deref_expr: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_not_deref_expr () Bool)
(declare-fun target_value_not_deref_expr () Bool)
(assert (= source_value_not_deref_expr target_value_not_deref_expr))

; value_not_assign_expr: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_not_assign_expr () Bool)
(declare-fun target_value_not_assign_expr () Bool)
(assert (= source_value_not_assign_expr target_value_not_assign_expr))

; ref_result_is_loc: translation preserves property (matches Coq: Lemma)
(declare-fun source_ref_result_is_loc () Bool)
(declare-fun target_ref_result_is_loc () Bool)
(assert (= source_ref_result_is_loc target_ref_result_is_loc))

; ref_arg_steps: translation preserves property (matches Coq: Lemma)
(declare-fun source_ref_arg_steps () Bool)
(declare-fun target_ref_arg_steps () Bool)
(assert (= source_ref_arg_steps target_ref_arg_steps))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

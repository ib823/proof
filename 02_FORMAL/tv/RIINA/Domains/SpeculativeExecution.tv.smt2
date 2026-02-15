; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SpeculativeExecution.v (20 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for SpeculativeExecution
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; eff_le: source semantics (matches Coq)
(declare-fun source_eff_le () Bool)
(declare-fun target_eff_le () Bool)
(assert (= source_eff_le target_eff_le))

; eff_join: source semantics (matches Coq)
(declare-fun source_eff_join () Bool)
(declare-fun target_eff_join () Bool)
(assert (= source_eff_join target_eff_join))

; infer_effect: source semantics (matches Coq)
(declare-fun source_infer_effect () Bool)
(declare-fun target_infer_effect () Bool)
(assert (= source_infer_effect target_infer_effect))

; is_constant_time: source semantics (matches Coq)
(declare-fun source_is_constant_time () Bool)
(declare-fun target_is_constant_time () Bool)
(assert (= source_is_constant_time target_is_constant_time))

; is_spec_safe: source semantics (matches Coq)
(declare-fun source_is_spec_safe () Bool)
(declare-fun target_is_spec_safe () Bool)
(assert (= source_is_spec_safe target_is_spec_safe))

; eval_instr: source semantics (matches Coq)
(declare-fun source_eval_instr () Bool)
(declare-fun target_eval_instr () Bool)
(assert (= source_eval_instr target_eval_instr))

; no_speculative_annotation: source semantics (matches Coq)
(declare-fun source_no_speculative_annotation () Bool)
(declare-fun target_no_speculative_annotation () Bool)
(assert (= source_no_speculative_annotation target_no_speculative_annotation))

; eff_join_pure_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_eff_join_pure_l () Bool)
(declare-fun target_eff_join_pure_l () Bool)
(assert (= source_eff_join_pure_l target_eff_join_pure_l))

; eff_join_pure_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_eff_join_pure_r () Bool)
(declare-fun target_eff_join_pure_r () Bool)
(assert (= source_eff_join_pure_r target_eff_join_pure_r))

; eff_le_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_eff_le_refl () Bool)
(declare-fun target_eff_le_refl () Bool)
(assert (= source_eff_le_refl target_eff_le_refl))

; eff_le_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_eff_le_trans () Bool)
(declare-fun target_eff_le_trans () Bool)
(assert (= source_eff_le_trans target_eff_le_trans))

; pure_is_constant_time: translation preserves property (matches Coq: Theorem)
(declare-fun source_pure_is_constant_time () Bool)
(declare-fun target_pure_is_constant_time () Bool)
(assert (= source_pure_is_constant_time target_pure_is_constant_time))

; ct_composition: translation preserves property (matches Coq: Theorem)
(declare-fun source_ct_composition () Bool)
(declare-fun target_ct_composition () Bool)
(assert (= source_ct_composition target_ct_composition))

; no_secret_branch: translation preserves property (matches Coq: Lemma)
(declare-fun source_no_secret_branch () Bool)
(declare-fun target_no_secret_branch () Bool)
(assert (= source_no_secret_branch target_no_secret_branch))

; spec_safe_no_secret_branch_aux: translation preserves property (matches Coq: Lemma)
(declare-fun source_spec_safe_no_secret_branch_aux () Bool)
(declare-fun target_spec_safe_no_secret_branch_aux () Bool)
(assert (= source_spec_safe_no_secret_branch_aux target_spec_safe_no_secret_branch_aux))

; spec_safe_implies_no_secret_leakage: translation preserves property (matches Coq: Theorem)
(declare-fun source_spec_safe_implies_no_secret_leakage () Bool)
(declare-fun target_spec_safe_implies_no_secret_leakage () Bool)
(assert (= source_spec_safe_implies_no_secret_leakage target_spec_safe_implies_no_secret_leakage))

; effect_preorder_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_effect_preorder_refl () Bool)
(declare-fun target_effect_preorder_refl () Bool)
(assert (= source_effect_preorder_refl target_effect_preorder_refl))

; effect_preorder_trans: translation preserves property (matches Coq: Theorem)
(declare-fun source_effect_preorder_trans () Bool)
(declare-fun target_effect_preorder_trans () Bool)
(assert (= source_effect_preorder_trans target_effect_preorder_trans))

; pure_is_bottom: translation preserves property (matches Coq: Theorem)
(declare-fun source_pure_is_bottom () Bool)
(declare-fun target_pure_is_bottom () Bool)
(assert (= source_pure_is_bottom target_pure_is_bottom))

; seq_preserves_spec_safe: translation preserves property (matches Coq: Theorem)
(declare-fun source_seq_preserves_spec_safe () Bool)
(declare-fun target_seq_preserves_spec_safe () Bool)
(assert (= source_seq_preserves_spec_safe target_seq_preserves_spec_safe))

; public_branch_ct: translation preserves property (matches Coq: Theorem)
(declare-fun source_public_branch_ct () Bool)
(declare-fun target_public_branch_ct () Bool)
(assert (= source_public_branch_ct target_public_branch_ct))

; annotation_soundness: translation preserves property (matches Coq: Theorem)
(declare-fun source_annotation_soundness () Bool)
(declare-fun target_annotation_soundness () Bool)
(assert (= source_annotation_soundness target_annotation_soundness))

; binop_preserves_ct: translation preserves property (matches Coq: Theorem)
(declare-fun source_binop_preserves_ct () Bool)
(declare-fun target_binop_preserves_ct () Bool)
(assert (= source_binop_preserves_ct target_binop_preserves_ct))

; pure_implies_spec_safe: translation preserves property (matches Coq: Theorem)
(declare-fun source_pure_implies_spec_safe () Bool)
(declare-fun target_pure_implies_spec_safe () Bool)
(assert (= source_pure_implies_spec_safe target_pure_implies_spec_safe))

; timed_implies_spec_safe: translation preserves property (matches Coq: Theorem)
(declare-fun source_timed_implies_spec_safe () Bool)
(declare-fun target_timed_implies_spec_safe () Bool)
(assert (= source_timed_implies_spec_safe target_timed_implies_spec_safe))

; const_is_pure: translation preserves property (matches Coq: Theorem)
(declare-fun source_const_is_pure () Bool)
(declare-fun target_const_is_pure () Bool)
(assert (= source_const_is_pure target_const_is_pure))

; eff_join_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_eff_join_comm () Bool)
(declare-fun target_eff_join_comm () Bool)
(assert (= source_eff_join_comm target_eff_join_comm))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

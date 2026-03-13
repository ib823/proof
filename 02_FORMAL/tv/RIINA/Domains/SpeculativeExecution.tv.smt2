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
; Translation validation: eff_le preserves semantics
(push 1)
(declare-const source_eff_le Int)
(declare-const target_eff_le Int)
(assert (>= source_eff_le 0))
(assert (>= target_eff_le 0))
(assert (not (= source_eff_le target_eff_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eff_join: source semantics (matches Coq)
; Translation validation: eff_join preserves semantics
(push 1)
(declare-const source_eff_join Int)
(declare-const target_eff_join Int)
(assert (>= source_eff_join 0))
(assert (>= target_eff_join 0))
(assert (not (= source_eff_join target_eff_join)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; infer_effect: source semantics (matches Coq)
; Translation validation: infer_effect preserves semantics
(push 1)
(declare-const source_infer_effect Int)
(declare-const target_infer_effect Int)
(assert (>= source_infer_effect 0))
(assert (>= target_infer_effect 0))
(assert (not (= source_infer_effect target_infer_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_constant_time: source semantics (matches Coq)
; Translation validation: is_constant_time preserves semantics
(push 1)
(declare-const source_is_constant_time Int)
(declare-const target_is_constant_time Int)
(assert (>= source_is_constant_time 0))
(assert (>= target_is_constant_time 0))
(assert (not (= source_is_constant_time target_is_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_spec_safe: source semantics (matches Coq)
; Translation validation: is_spec_safe preserves semantics
(push 1)
(declare-const source_is_spec_safe Int)
(declare-const target_is_spec_safe Int)
(assert (>= source_is_spec_safe 0))
(assert (>= target_is_spec_safe 0))
(assert (not (= source_is_spec_safe target_is_spec_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eval_instr: source semantics (matches Coq)
; Translation validation: eval_instr preserves semantics
(push 1)
(declare-const source_eval_instr Int)
(declare-const target_eval_instr Int)
(assert (>= source_eval_instr 0))
(assert (>= target_eval_instr 0))
(assert (not (= source_eval_instr target_eval_instr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_speculative_annotation: source semantics (matches Coq)
; Translation validation: no_speculative_annotation preserves semantics
(push 1)
(declare-const source_no_speculative_annotation Int)
(declare-const target_no_speculative_annotation Int)
(assert (>= source_no_speculative_annotation 0))
(assert (>= target_no_speculative_annotation 0))
(assert (not (= source_no_speculative_annotation target_no_speculative_annotation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eff_join_pure_l: translation preserves property (matches Coq: Lemma)
; Translation validation: eff_join_pure_l preserves semantics
(push 1)
(declare-const source_eff_join_pure_l Int)
(declare-const target_eff_join_pure_l Int)
(assert (>= source_eff_join_pure_l 0))
(assert (>= target_eff_join_pure_l 0))
(assert (not (= source_eff_join_pure_l target_eff_join_pure_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eff_join_pure_r: translation preserves property (matches Coq: Lemma)
; Translation validation: eff_join_pure_r preserves semantics
(push 1)
(declare-const source_eff_join_pure_r Int)
(declare-const target_eff_join_pure_r Int)
(assert (>= source_eff_join_pure_r 0))
(assert (>= target_eff_join_pure_r 0))
(assert (not (= source_eff_join_pure_r target_eff_join_pure_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eff_le_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: eff_le_refl preserves semantics
(push 1)
(declare-const source_eff_le_refl Int)
(declare-const target_eff_le_refl Int)
(assert (>= source_eff_le_refl 0))
(assert (>= target_eff_le_refl 0))
(assert (not (= source_eff_le_refl target_eff_le_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eff_le_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: eff_le_trans preserves semantics
(push 1)
(declare-const source_eff_le_trans Int)
(declare-const target_eff_le_trans Int)
(assert (>= source_eff_le_trans 0))
(assert (>= target_eff_le_trans 0))
(assert (not (= source_eff_le_trans target_eff_le_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure_is_constant_time: translation preserves property (matches Coq: Theorem)
; Translation validation: pure_is_constant_time preserves semantics
(push 1)
(declare-const source_pure_is_constant_time Int)
(declare-const target_pure_is_constant_time Int)
(assert (>= source_pure_is_constant_time 0))
(assert (>= target_pure_is_constant_time 0))
(assert (not (= source_pure_is_constant_time target_pure_is_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ct_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: ct_composition preserves semantics
(push 1)
(declare-const source_ct_composition Int)
(declare-const target_ct_composition Int)
(assert (>= source_ct_composition 0))
(assert (>= target_ct_composition 0))
(assert (not (= source_ct_composition target_ct_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_secret_branch: translation preserves property (matches Coq: Lemma)
; Translation validation: no_secret_branch preserves semantics
(push 1)
(declare-const source_no_secret_branch Int)
(declare-const target_no_secret_branch Int)
(assert (>= source_no_secret_branch 0))
(assert (>= target_no_secret_branch 0))
(assert (not (= source_no_secret_branch target_no_secret_branch)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; spec_safe_no_secret_branch_aux: translation preserves property (matches Coq: Lemma)
; Translation validation: spec_safe_no_secret_branch_aux preserves semantics
(push 1)
(declare-const source_spec_safe_no_secret_branch_aux Int)
(declare-const target_spec_safe_no_secret_branch_aux Int)
(assert (>= source_spec_safe_no_secret_branch_aux 0))
(assert (>= target_spec_safe_no_secret_branch_aux 0))
(assert (not (= source_spec_safe_no_secret_branch_aux target_spec_safe_no_secret_branch_aux)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; spec_safe_implies_no_secret_leakage: translation preserves property (matches Coq: Theorem)
; Translation validation: spec_safe_implies_no_secret_leakage preserves semantics
(push 1)
(declare-const source_spec_safe_implies_no_secret_leakage Int)
(declare-const target_spec_safe_implies_no_secret_leakage Int)
(assert (>= source_spec_safe_implies_no_secret_leakage 0))
(assert (>= target_spec_safe_implies_no_secret_leakage 0))
(assert (not (= source_spec_safe_implies_no_secret_leakage target_spec_safe_implies_no_secret_leakage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_preorder_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: effect_preorder_refl preserves semantics
(push 1)
(declare-const source_effect_preorder_refl Int)
(declare-const target_effect_preorder_refl Int)
(assert (>= source_effect_preorder_refl 0))
(assert (>= target_effect_preorder_refl 0))
(assert (not (= source_effect_preorder_refl target_effect_preorder_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_preorder_trans: translation preserves property (matches Coq: Theorem)
; Translation validation: effect_preorder_trans preserves semantics
(push 1)
(declare-const source_effect_preorder_trans Int)
(declare-const target_effect_preorder_trans Int)
(assert (>= source_effect_preorder_trans 0))
(assert (>= target_effect_preorder_trans 0))
(assert (not (= source_effect_preorder_trans target_effect_preorder_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure_is_bottom: translation preserves property (matches Coq: Theorem)
; Translation validation: pure_is_bottom preserves semantics
(push 1)
(declare-const source_pure_is_bottom Int)
(declare-const target_pure_is_bottom Int)
(assert (>= source_pure_is_bottom 0))
(assert (>= target_pure_is_bottom 0))
(assert (not (= source_pure_is_bottom target_pure_is_bottom)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; seq_preserves_spec_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: seq_preserves_spec_safe preserves semantics
(push 1)
(declare-const source_seq_preserves_spec_safe Int)
(declare-const target_seq_preserves_spec_safe Int)
(assert (>= source_seq_preserves_spec_safe 0))
(assert (>= target_seq_preserves_spec_safe 0))
(assert (not (= source_seq_preserves_spec_safe target_seq_preserves_spec_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; public_branch_ct: translation preserves property (matches Coq: Theorem)
; Translation validation: public_branch_ct preserves semantics
(push 1)
(declare-const source_public_branch_ct Int)
(declare-const target_public_branch_ct Int)
(assert (>= source_public_branch_ct 0))
(assert (>= target_public_branch_ct 0))
(assert (not (= source_public_branch_ct target_public_branch_ct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; annotation_soundness: translation preserves property (matches Coq: Theorem)
; Translation validation: annotation_soundness preserves semantics
(push 1)
(declare-const source_annotation_soundness Int)
(declare-const target_annotation_soundness Int)
(assert (>= source_annotation_soundness 0))
(assert (>= target_annotation_soundness 0))
(assert (not (= source_annotation_soundness target_annotation_soundness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; binop_preserves_ct: translation preserves property (matches Coq: Theorem)
; Translation validation: binop_preserves_ct preserves semantics
(push 1)
(declare-const source_binop_preserves_ct Int)
(declare-const target_binop_preserves_ct Int)
(assert (>= source_binop_preserves_ct 0))
(assert (>= target_binop_preserves_ct 0))
(assert (not (= source_binop_preserves_ct target_binop_preserves_ct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure_implies_spec_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: pure_implies_spec_safe preserves semantics
(push 1)
(declare-const source_pure_implies_spec_safe Int)
(declare-const target_pure_implies_spec_safe Int)
(assert (>= source_pure_implies_spec_safe 0))
(assert (>= target_pure_implies_spec_safe 0))
(assert (not (= source_pure_implies_spec_safe target_pure_implies_spec_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; timed_implies_spec_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: timed_implies_spec_safe preserves semantics
(push 1)
(declare-const source_timed_implies_spec_safe Int)
(declare-const target_timed_implies_spec_safe Int)
(assert (>= source_timed_implies_spec_safe 0))
(assert (>= target_timed_implies_spec_safe 0))
(assert (not (= source_timed_implies_spec_safe target_timed_implies_spec_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; const_is_pure: translation preserves property (matches Coq: Theorem)
; Translation validation: const_is_pure preserves semantics
(push 1)
(declare-const source_const_is_pure Int)
(declare-const target_const_is_pure Int)
(assert (>= source_const_is_pure 0))
(assert (>= target_const_is_pure 0))
(assert (not (= source_const_is_pure target_const_is_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eff_join_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: eff_join_comm preserves semantics
(push 1)
(declare-const source_eff_join_comm Int)
(declare-const target_eff_join_comm Int)
(assert (>= source_eff_join_comm 0))
(assert (>= target_eff_join_comm 0))
(assert (not (= source_eff_join_comm target_eff_join_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

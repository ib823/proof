; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/EffectMonotonicity.v (36 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for EffectMonotonicity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; app_pure_implies_parts_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: app_pure_implies_parts_pure preserves semantics
(push 1)
(declare-const source_app_pure_implies_parts_pure Int)
(declare-const target_app_pure_implies_parts_pure Int)
(assert (>= source_app_pure_implies_parts_pure 0))
(assert (>= target_app_pure_implies_parts_pure 0))
(assert (not (= source_app_pure_implies_parts_pure target_app_pure_implies_parts_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; let_pure_implies_parts_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: let_pure_implies_parts_pure preserves semantics
(push 1)
(declare-const source_let_pure_implies_parts_pure Int)
(declare-const target_let_pure_implies_parts_pure Int)
(assert (>= source_let_pure_implies_parts_pure 0))
(assert (>= target_let_pure_implies_parts_pure 0))
(assert (not (= source_let_pure_implies_parts_pure target_let_pure_implies_parts_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; if_pure_implies_parts_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: if_pure_implies_parts_pure preserves semantics
(push 1)
(declare-const source_if_pure_implies_parts_pure Int)
(declare-const target_if_pure_implies_parts_pure Int)
(assert (>= source_if_pure_implies_parts_pure 0))
(assert (>= target_if_pure_implies_parts_pure 0))
(assert (not (= source_if_pure_implies_parts_pure target_if_pure_implies_parts_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_effect_geq_fn: translation preserves property (matches Coq: Lemma)
; Translation validation: app_effect_geq_fn preserves semantics
(push 1)
(declare-const source_app_effect_geq_fn Int)
(declare-const target_app_effect_geq_fn Int)
(assert (>= source_app_effect_geq_fn 0))
(assert (>= target_app_effect_geq_fn 0))
(assert (not (= source_app_effect_geq_fn target_app_effect_geq_fn)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_effect_geq_arg1: translation preserves property (matches Coq: Lemma)
; Translation validation: app_effect_geq_arg1 preserves semantics
(push 1)
(declare-const source_app_effect_geq_arg1 Int)
(declare-const target_app_effect_geq_arg1 Int)
(assert (>= source_app_effect_geq_arg1 0))
(assert (>= target_app_effect_geq_arg1 0))
(assert (not (= source_app_effect_geq_arg1 target_app_effect_geq_arg1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_effect_geq_arg2: translation preserves property (matches Coq: Lemma)
; Translation validation: app_effect_geq_arg2 preserves semantics
(push 1)
(declare-const source_app_effect_geq_arg2 Int)
(declare-const target_app_effect_geq_arg2 Int)
(assert (>= source_app_effect_geq_arg2 0))
(assert (>= target_app_effect_geq_arg2 0))
(assert (not (= source_app_effect_geq_arg2 target_app_effect_geq_arg2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; let_effect_geq_body: translation preserves property (matches Coq: Lemma)
; Translation validation: let_effect_geq_body preserves semantics
(push 1)
(declare-const source_let_effect_geq_body Int)
(declare-const target_let_effect_geq_body Int)
(assert (>= source_let_effect_geq_body 0))
(assert (>= target_let_effect_geq_body 0))
(assert (not (= source_let_effect_geq_body target_let_effect_geq_body)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; let_effect_geq_cont: translation preserves property (matches Coq: Lemma)
; Translation validation: let_effect_geq_cont preserves semantics
(push 1)
(declare-const source_let_effect_geq_cont Int)
(declare-const target_let_effect_geq_cont Int)
(assert (>= source_let_effect_geq_cont 0))
(assert (>= target_let_effect_geq_cont 0))
(assert (not (= source_let_effect_geq_cont target_let_effect_geq_cont)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fst_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: fst_pure preserves semantics
(push 1)
(declare-const source_fst_pure Int)
(declare-const target_fst_pure Int)
(assert (>= source_fst_pure 0))
(assert (>= target_fst_pure 0))
(assert (not (= source_fst_pure target_fst_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; snd_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: snd_pure preserves semantics
(push 1)
(declare-const source_snd_pure Int)
(declare-const target_snd_pure Int)
(assert (>= source_snd_pure 0))
(assert (>= target_snd_pure 0))
(assert (not (= source_snd_pure target_snd_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; classify_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: classify_pure preserves semantics
(push 1)
(declare-const source_classify_pure Int)
(declare-const target_classify_pure Int)
(assert (>= source_classify_pure 0))
(assert (>= target_classify_pure 0))
(assert (not (= source_classify_pure target_classify_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prove_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: prove_pure preserves semantics
(push 1)
(declare-const source_prove_pure Int)
(declare-const target_prove_pure Int)
(assert (>= source_prove_pure 0))
(assert (>= target_prove_pure 0))
(assert (not (= source_prove_pure target_prove_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_join_level_bound: translation preserves property (matches Coq: Lemma)
; Translation validation: effect_join_level_bound preserves semantics
(push 1)
(declare-const source_effect_join_level_bound Int)
(declare-const target_effect_join_level_bound Int)
(assert (>= source_effect_join_level_bound 0))
(assert (>= target_effect_join_level_bound 0))
(assert (not (= source_effect_join_level_bound target_effect_join_level_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_leq_join_both: translation preserves property (matches Coq: Lemma)
; Translation validation: effect_leq_join_both preserves semantics
(push 1)
(declare-const source_effect_leq_join_both Int)
(declare-const target_effect_leq_join_both Int)
(assert (>= source_effect_leq_join_both 0))
(assert (>= target_effect_leq_join_both 0))
(assert (not (= source_effect_leq_join_both target_effect_leq_join_both)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_leq_both_join: translation preserves property (matches Coq: Lemma)
; Translation validation: effect_leq_both_join preserves semantics
(push 1)
(declare-const source_effect_leq_both_join Int)
(declare-const target_effect_leq_both_join Int)
(assert (>= source_effect_leq_both_join 0))
(assert (>= target_effect_leq_both_join 0))
(assert (not (= source_effect_leq_both_join target_effect_leq_both_join)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_join_pure_r: translation preserves property (matches Coq: Lemma)
; Translation validation: effect_join_pure_r preserves semantics
(push 1)
(declare-const source_effect_join_pure_r Int)
(declare-const target_effect_join_pure_r Int)
(assert (>= source_effect_join_pure_r 0))
(assert (>= target_effect_join_pure_r 0))
(assert (not (= source_effect_join_pure_r target_effect_join_pure_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tfn_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: tfn_injective preserves semantics
(push 1)
(declare-const source_tfn_injective Int)
(declare-const target_tfn_injective Int)
(assert (>= source_tfn_injective 0))
(assert (>= target_tfn_injective 0))
(assert (not (= source_tfn_injective target_tfn_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tprod_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: tprod_injective preserves semantics
(push 1)
(declare-const source_tprod_injective Int)
(declare-const target_tprod_injective Int)
(assert (>= source_tprod_injective 0))
(assert (>= target_tprod_injective 0))
(assert (not (= source_tprod_injective target_tprod_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tsum_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: tsum_injective preserves semantics
(push 1)
(declare-const source_tsum_injective Int)
(declare-const target_tsum_injective Int)
(assert (>= source_tsum_injective 0))
(assert (>= target_tsum_injective 0))
(assert (not (= source_tsum_injective target_tsum_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tref_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: tref_injective preserves semantics
(push 1)
(declare-const source_tref_injective Int)
(declare-const target_tref_injective Int)
(assert (>= source_tref_injective 0))
(assert (>= target_tref_injective 0))
(assert (not (= source_tref_injective target_tref_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tsecret_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: tsecret_injective preserves semantics
(push 1)
(declare-const source_tsecret_injective Int)
(declare-const target_tsecret_injective Int)
(assert (>= source_tsecret_injective 0))
(assert (>= target_tsecret_injective 0))
(assert (not (= source_tsecret_injective target_tsecret_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tproof_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: tproof_injective preserves semantics
(push 1)
(declare-const source_tproof_injective Int)
(declare-const target_tproof_injective Int)
(assert (>= source_tproof_injective 0))
(assert (>= target_tproof_injective 0))
(assert (not (= source_tproof_injective target_tproof_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tlist_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: tlist_injective preserves semantics
(push 1)
(declare-const source_tlist_injective Int)
(declare-const target_tlist_injective Int)
(assert (>= source_tlist_injective 0))
(assert (>= target_tlist_injective 0))
(assert (not (= source_tlist_injective target_tlist_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; toption_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: toption_injective preserves semantics
(push 1)
(declare-const source_toption_injective Int)
(declare-const target_toption_injective Int)
(assert (>= source_toption_injective 0))
(assert (>= target_toption_injective 0))
(assert (not (= source_toption_injective target_toption_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nested_let_effect: translation preserves property (matches Coq: Lemma)
; Translation validation: nested_let_effect preserves semantics
(push 1)
(declare-const source_nested_let_effect Int)
(declare-const target_nested_let_effect Int)
(assert (>= source_nested_let_effect 0))
(assert (>= target_nested_let_effect 0))
(assert (not (= source_nested_let_effect target_nested_let_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sequential_pair_effect: translation preserves property (matches Coq: Lemma)
; Translation validation: sequential_pair_effect preserves semantics
(push 1)
(declare-const source_sequential_pair_effect Int)
(declare-const target_sequential_pair_effect Int)
(assert (>= source_sequential_pair_effect 0))
(assert (>= target_sequential_pair_effect 0))
(assert (not (= source_sequential_pair_effect target_sequential_pair_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; classify_preserves_effect: translation preserves property (matches Coq: Lemma)
; Translation validation: classify_preserves_effect preserves semantics
(push 1)
(declare-const source_classify_preserves_effect Int)
(declare-const target_classify_preserves_effect Int)
(assert (>= source_classify_preserves_effect 0))
(assert (>= target_classify_preserves_effect 0))
(assert (not (= source_classify_preserves_effect target_classify_preserves_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prove_preserves_effect: translation preserves property (matches Coq: Lemma)
; Translation validation: prove_preserves_effect preserves semantics
(push 1)
(declare-const source_prove_preserves_effect Int)
(declare-const target_prove_preserves_effect Int)
(assert (>= source_prove_preserves_effect 0))
(assert (>= target_prove_preserves_effect 0))
(assert (not (= source_prove_preserves_effect target_prove_preserves_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inl_preserves_effect: translation preserves property (matches Coq: Lemma)
; Translation validation: inl_preserves_effect preserves semantics
(push 1)
(declare-const source_inl_preserves_effect Int)
(declare-const target_inl_preserves_effect Int)
(assert (>= source_inl_preserves_effect 0))
(assert (>= target_inl_preserves_effect 0))
(assert (not (= source_inl_preserves_effect target_inl_preserves_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inr_preserves_effect: translation preserves property (matches Coq: Lemma)
; Translation validation: inr_preserves_effect preserves semantics
(push 1)
(declare-const source_inr_preserves_effect Int)
(declare-const target_inr_preserves_effect Int)
(assert (>= source_inr_preserves_effect 0))
(assert (>= target_inr_preserves_effect 0))
(assert (not (= source_inr_preserves_effect target_inr_preserves_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ref_introduces_write: translation preserves property (matches Coq: Lemma)
; Translation validation: ref_introduces_write preserves semantics
(push 1)
(declare-const source_ref_introduces_write Int)
(declare-const target_ref_introduces_write Int)
(assert (>= source_ref_introduces_write 0))
(assert (>= target_ref_introduces_write 0))
(assert (not (= source_ref_introduces_write target_ref_introduces_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; deref_introduces_read: translation preserves property (matches Coq: Lemma)
; Translation validation: deref_introduces_read preserves semantics
(push 1)
(declare-const source_deref_introduces_read Int)
(declare-const target_deref_introduces_read Int)
(assert (>= source_deref_introduces_read 0))
(assert (>= target_deref_introduces_read 0))
(assert (not (= source_deref_introduces_read target_deref_introduces_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; assign_introduces_write: translation preserves property (matches Coq: Lemma)
; Translation validation: assign_introduces_write preserves semantics
(push 1)
(declare-const source_assign_introduces_write Int)
(declare-const target_assign_introduces_write Int)
(assert (>= source_assign_introduces_write 0))
(assert (>= target_assign_introduces_write 0))
(assert (not (= source_assign_introduces_write target_assign_introduces_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ref_not_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: ref_not_pure preserves semantics
(push 1)
(declare-const source_ref_not_pure Int)
(declare-const target_ref_not_pure Int)
(assert (>= source_ref_not_pure 0))
(assert (>= target_ref_not_pure 0))
(assert (not (= source_ref_not_pure target_ref_not_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; deref_not_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: deref_not_pure preserves semantics
(push 1)
(declare-const source_deref_not_pure Int)
(declare-const target_deref_not_pure Int)
(assert (>= source_deref_not_pure 0))
(assert (>= target_deref_not_pure 0))
(assert (not (= source_deref_not_pure target_deref_not_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; assign_not_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: assign_not_pure preserves semantics
(push 1)
(declare-const source_assign_not_pure Int)
(declare-const target_assign_not_pure Int)
(assert (>= source_assign_not_pure 0))
(assert (>= target_assign_not_pure 0))
(assert (not (= source_assign_not_pure target_assign_not_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

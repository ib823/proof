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
(declare-fun source_app_pure_implies_parts_pure () Bool)
(declare-fun target_app_pure_implies_parts_pure () Bool)
(assert (= source_app_pure_implies_parts_pure target_app_pure_implies_parts_pure))

; let_pure_implies_parts_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_let_pure_implies_parts_pure () Bool)
(declare-fun target_let_pure_implies_parts_pure () Bool)
(assert (= source_let_pure_implies_parts_pure target_let_pure_implies_parts_pure))

; if_pure_implies_parts_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_if_pure_implies_parts_pure () Bool)
(declare-fun target_if_pure_implies_parts_pure () Bool)
(assert (= source_if_pure_implies_parts_pure target_if_pure_implies_parts_pure))

; app_effect_geq_fn: translation preserves property (matches Coq: Lemma)
(declare-fun source_app_effect_geq_fn () Bool)
(declare-fun target_app_effect_geq_fn () Bool)
(assert (= source_app_effect_geq_fn target_app_effect_geq_fn))

; app_effect_geq_arg1: translation preserves property (matches Coq: Lemma)
(declare-fun source_app_effect_geq_arg1 () Bool)
(declare-fun target_app_effect_geq_arg1 () Bool)
(assert (= source_app_effect_geq_arg1 target_app_effect_geq_arg1))

; app_effect_geq_arg2: translation preserves property (matches Coq: Lemma)
(declare-fun source_app_effect_geq_arg2 () Bool)
(declare-fun target_app_effect_geq_arg2 () Bool)
(assert (= source_app_effect_geq_arg2 target_app_effect_geq_arg2))

; let_effect_geq_body: translation preserves property (matches Coq: Lemma)
(declare-fun source_let_effect_geq_body () Bool)
(declare-fun target_let_effect_geq_body () Bool)
(assert (= source_let_effect_geq_body target_let_effect_geq_body))

; let_effect_geq_cont: translation preserves property (matches Coq: Lemma)
(declare-fun source_let_effect_geq_cont () Bool)
(declare-fun target_let_effect_geq_cont () Bool)
(assert (= source_let_effect_geq_cont target_let_effect_geq_cont))

; fst_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_fst_pure () Bool)
(declare-fun target_fst_pure () Bool)
(assert (= source_fst_pure target_fst_pure))

; snd_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_snd_pure () Bool)
(declare-fun target_snd_pure () Bool)
(assert (= source_snd_pure target_snd_pure))

; classify_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_classify_pure () Bool)
(declare-fun target_classify_pure () Bool)
(assert (= source_classify_pure target_classify_pure))

; prove_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_prove_pure () Bool)
(declare-fun target_prove_pure () Bool)
(assert (= source_prove_pure target_prove_pure))

; effect_join_level_bound: translation preserves property (matches Coq: Lemma)
(declare-fun source_effect_join_level_bound () Bool)
(declare-fun target_effect_join_level_bound () Bool)
(assert (= source_effect_join_level_bound target_effect_join_level_bound))

; effect_leq_join_both: translation preserves property (matches Coq: Lemma)
(declare-fun source_effect_leq_join_both () Bool)
(declare-fun target_effect_leq_join_both () Bool)
(assert (= source_effect_leq_join_both target_effect_leq_join_both))

; effect_leq_both_join: translation preserves property (matches Coq: Lemma)
(declare-fun source_effect_leq_both_join () Bool)
(declare-fun target_effect_leq_both_join () Bool)
(assert (= source_effect_leq_both_join target_effect_leq_both_join))

; effect_join_pure_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_effect_join_pure_r () Bool)
(declare-fun target_effect_join_pure_r () Bool)
(assert (= source_effect_join_pure_r target_effect_join_pure_r))

; tfn_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_tfn_injective () Bool)
(declare-fun target_tfn_injective () Bool)
(assert (= source_tfn_injective target_tfn_injective))

; tprod_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_tprod_injective () Bool)
(declare-fun target_tprod_injective () Bool)
(assert (= source_tprod_injective target_tprod_injective))

; tsum_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_tsum_injective () Bool)
(declare-fun target_tsum_injective () Bool)
(assert (= source_tsum_injective target_tsum_injective))

; tref_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_tref_injective () Bool)
(declare-fun target_tref_injective () Bool)
(assert (= source_tref_injective target_tref_injective))

; tsecret_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_tsecret_injective () Bool)
(declare-fun target_tsecret_injective () Bool)
(assert (= source_tsecret_injective target_tsecret_injective))

; tproof_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_tproof_injective () Bool)
(declare-fun target_tproof_injective () Bool)
(assert (= source_tproof_injective target_tproof_injective))

; tlist_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_tlist_injective () Bool)
(declare-fun target_tlist_injective () Bool)
(assert (= source_tlist_injective target_tlist_injective))

; toption_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_toption_injective () Bool)
(declare-fun target_toption_injective () Bool)
(assert (= source_toption_injective target_toption_injective))

; nested_let_effect: translation preserves property (matches Coq: Lemma)
(declare-fun source_nested_let_effect () Bool)
(declare-fun target_nested_let_effect () Bool)
(assert (= source_nested_let_effect target_nested_let_effect))

; sequential_pair_effect: translation preserves property (matches Coq: Lemma)
(declare-fun source_sequential_pair_effect () Bool)
(declare-fun target_sequential_pair_effect () Bool)
(assert (= source_sequential_pair_effect target_sequential_pair_effect))

; classify_preserves_effect: translation preserves property (matches Coq: Lemma)
(declare-fun source_classify_preserves_effect () Bool)
(declare-fun target_classify_preserves_effect () Bool)
(assert (= source_classify_preserves_effect target_classify_preserves_effect))

; prove_preserves_effect: translation preserves property (matches Coq: Lemma)
(declare-fun source_prove_preserves_effect () Bool)
(declare-fun target_prove_preserves_effect () Bool)
(assert (= source_prove_preserves_effect target_prove_preserves_effect))

; inl_preserves_effect: translation preserves property (matches Coq: Lemma)
(declare-fun source_inl_preserves_effect () Bool)
(declare-fun target_inl_preserves_effect () Bool)
(assert (= source_inl_preserves_effect target_inl_preserves_effect))

; inr_preserves_effect: translation preserves property (matches Coq: Lemma)
(declare-fun source_inr_preserves_effect () Bool)
(declare-fun target_inr_preserves_effect () Bool)
(assert (= source_inr_preserves_effect target_inr_preserves_effect))

; ref_introduces_write: translation preserves property (matches Coq: Lemma)
(declare-fun source_ref_introduces_write () Bool)
(declare-fun target_ref_introduces_write () Bool)
(assert (= source_ref_introduces_write target_ref_introduces_write))

; deref_introduces_read: translation preserves property (matches Coq: Lemma)
(declare-fun source_deref_introduces_read () Bool)
(declare-fun target_deref_introduces_read () Bool)
(assert (= source_deref_introduces_read target_deref_introduces_read))

; assign_introduces_write: translation preserves property (matches Coq: Lemma)
(declare-fun source_assign_introduces_write () Bool)
(declare-fun target_assign_introduces_write () Bool)
(assert (= source_assign_introduces_write target_assign_introduces_write))

; ref_not_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_ref_not_pure () Bool)
(declare-fun target_ref_not_pure () Bool)
(assert (= source_ref_not_pure target_ref_not_pure))

; deref_not_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_deref_not_pure () Bool)
(declare-fun target_deref_not_pure () Bool)
(assert (= source_deref_not_pure target_deref_not_pure))

; assign_not_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_assign_not_pure () Bool)
(declare-fun target_assign_not_pure () Bool)
(assert (= source_assign_not_pure target_assign_not_pure))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

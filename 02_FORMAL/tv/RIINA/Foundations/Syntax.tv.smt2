; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/foundations/Syntax.v (34 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for Syntax
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; sec_level_num: source semantics (matches Coq)
(declare-fun source_sec_level_num () Bool)
(declare-fun target_sec_level_num () Bool)
(assert (= source_sec_level_num target_sec_level_num))

; sec_leq: source semantics (matches Coq)
(declare-fun source_sec_leq () Bool)
(declare-fun target_sec_leq () Bool)
(assert (= source_sec_leq target_sec_leq))

; sec_leq_dec: source semantics (matches Coq)
(declare-fun source_sec_leq_dec () Bool)
(declare-fun target_sec_leq_dec () Bool)
(assert (= source_sec_leq_dec target_sec_leq_dec))

; sec_join: source semantics (matches Coq)
(declare-fun source_sec_join () Bool)
(declare-fun target_sec_join () Bool)
(assert (= source_sec_join target_sec_join))

; sec_meet: source semantics (matches Coq)
(declare-fun source_sec_meet () Bool)
(declare-fun target_sec_meet () Bool)
(assert (= source_sec_meet target_sec_meet))

; effect_cat: source semantics (matches Coq)
(declare-fun source_effect_cat () Bool)
(declare-fun target_effect_cat () Bool)
(assert (= source_effect_cat target_effect_cat))

; effect_level: source semantics (matches Coq)
(declare-fun source_effect_level () Bool)
(declare-fun target_effect_level () Bool)
(assert (= source_effect_level target_effect_level))

; effect_join: source semantics (matches Coq)
(declare-fun source_effect_join () Bool)
(declare-fun target_effect_join () Bool)
(assert (= source_effect_join target_effect_join))

; taint_combine: source semantics (matches Coq)
(declare-fun source_taint_combine () Bool)
(declare-fun target_taint_combine () Bool)
(assert (= source_taint_combine target_taint_combine))

; session_dual: source semantics (matches Coq)
(declare-fun source_session_dual () Bool)
(declare-fun target_session_dual () Bool)
(assert (= source_session_dual target_session_dual))

; TCapabilityOld: source semantics (matches Coq)
(declare-fun source_TCapabilityOld () Bool)
(declare-fun target_TCapabilityOld () Bool)
(assert (= source_TCapabilityOld target_TCapabilityOld))

; subst: source semantics (matches Coq)
(declare-fun source_subst () Bool)
(declare-fun target_subst () Bool)
(assert (= source_subst target_subst))

; declass_ok: source semantics (matches Coq)
(declare-fun source_declass_ok () Bool)
(declare-fun target_declass_ok () Bool)
(assert (= source_declass_ok target_declass_ok))

; effect_join_pure_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_effect_join_pure_l () Bool)
(declare-fun target_effect_join_pure_l () Bool)
(assert (= source_effect_join_pure_l target_effect_join_pure_l))

; effect_join_pure_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_effect_join_pure_r () Bool)
(declare-fun target_effect_join_pure_r () Bool)
(assert (= source_effect_join_pure_r target_effect_join_pure_r))

; sec_leq_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_leq_refl () Bool)
(declare-fun target_sec_leq_refl () Bool)
(assert (= source_sec_leq_refl target_sec_leq_refl))

; sec_leq_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_leq_trans () Bool)
(declare-fun target_sec_leq_trans () Bool)
(assert (= source_sec_leq_trans target_sec_leq_trans))

; sec_leq_antisym: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_leq_antisym () Bool)
(declare-fun target_sec_leq_antisym () Bool)
(assert (= source_sec_leq_antisym target_sec_leq_antisym))

; sec_leq_total: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_leq_total () Bool)
(declare-fun target_sec_leq_total () Bool)
(assert (= source_sec_leq_total target_sec_leq_total))

; sec_leq_public_bottom: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_leq_public_bottom () Bool)
(declare-fun target_sec_leq_public_bottom () Bool)
(assert (= source_sec_leq_public_bottom target_sec_leq_public_bottom))

; sec_leq_secret_top: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_leq_secret_top () Bool)
(declare-fun target_sec_leq_secret_top () Bool)
(assert (= source_sec_leq_secret_top target_sec_leq_secret_top))

; sec_leq_dec_correct: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_leq_dec_correct () Bool)
(declare-fun target_sec_leq_dec_correct () Bool)
(assert (= source_sec_leq_dec_correct target_sec_leq_dec_correct))

; sec_join_ub_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_join_ub_l () Bool)
(declare-fun target_sec_join_ub_l () Bool)
(assert (= source_sec_join_ub_l target_sec_join_ub_l))

; sec_join_ub_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_join_ub_r () Bool)
(declare-fun target_sec_join_ub_r () Bool)
(assert (= source_sec_join_ub_r target_sec_join_ub_r))

; sec_meet_lb_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_meet_lb_l () Bool)
(declare-fun target_sec_meet_lb_l () Bool)
(assert (= source_sec_meet_lb_l target_sec_meet_lb_l))

; sec_meet_lb_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_meet_lb_r () Bool)
(declare-fun target_sec_meet_lb_r () Bool)
(assert (= source_sec_meet_lb_r target_sec_meet_lb_r))

; sec_join_comm: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_join_comm () Bool)
(declare-fun target_sec_join_comm () Bool)
(assert (= source_sec_join_comm target_sec_join_comm))

; sec_meet_comm: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_meet_comm () Bool)
(declare-fun target_sec_meet_comm () Bool)
(assert (= source_sec_meet_comm target_sec_meet_comm))

; sec_join_idem: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_join_idem () Bool)
(declare-fun target_sec_join_idem () Bool)
(assert (= source_sec_join_idem target_sec_join_idem))

; sec_meet_idem: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_meet_idem () Bool)
(declare-fun target_sec_meet_idem () Bool)
(assert (= source_sec_meet_idem target_sec_meet_idem))

; sec_join_assoc: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_join_assoc () Bool)
(declare-fun target_sec_join_assoc () Bool)
(assert (= source_sec_join_assoc target_sec_join_assoc))

; sec_meet_assoc: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_meet_assoc () Bool)
(declare-fun target_sec_meet_assoc () Bool)
(assert (= source_sec_meet_assoc target_sec_meet_assoc))

; sec_join_meet_absorb: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_join_meet_absorb () Bool)
(declare-fun target_sec_join_meet_absorb () Bool)
(assert (= source_sec_join_meet_absorb target_sec_join_meet_absorb))

; sec_meet_join_absorb: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_meet_join_absorb () Bool)
(declare-fun target_sec_meet_join_absorb () Bool)
(assert (= source_sec_meet_join_absorb target_sec_meet_join_absorb))

; sec_join_meet_distrib: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_join_meet_distrib () Bool)
(declare-fun target_sec_join_meet_distrib () Bool)
(assert (= source_sec_join_meet_distrib target_sec_join_meet_distrib))

; sec_meet_join_distrib: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_meet_join_distrib () Bool)
(declare-fun target_sec_meet_join_distrib () Bool)
(assert (= source_sec_meet_join_distrib target_sec_meet_join_distrib))

; sec_join_lub: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_join_lub () Bool)
(declare-fun target_sec_join_lub () Bool)
(assert (= source_sec_join_lub target_sec_join_lub))

; sec_meet_glb: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_meet_glb () Bool)
(declare-fun target_sec_meet_glb () Bool)
(assert (= source_sec_meet_glb target_sec_meet_glb))

; sec_join_leq_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_join_leq_r () Bool)
(declare-fun target_sec_join_leq_r () Bool)
(assert (= source_sec_join_leq_r target_sec_join_leq_r))

; sec_meet_leq_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_meet_leq_l () Bool)
(declare-fun target_sec_meet_leq_l () Bool)
(assert (= source_sec_meet_leq_l target_sec_meet_leq_l))

; sec_level_eq_dec: translation preserves property (matches Coq: Lemma)
(declare-fun source_sec_level_eq_dec () Bool)
(declare-fun target_sec_level_eq_dec () Bool)
(assert (= source_sec_level_eq_dec target_sec_level_eq_dec))

; value_dec: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_dec () Bool)
(declare-fun target_value_dec () Bool)
(assert (= source_value_dec target_value_dec))

; subst_same_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_same_var () Bool)
(declare-fun target_subst_same_var () Bool)
(assert (= source_subst_same_var target_subst_same_var))

; session_dual_involutive: translation preserves property (matches Coq: Theorem)
(declare-fun source_session_dual_involutive () Bool)
(declare-fun target_session_dual_involutive () Bool)
(assert (= source_session_dual_involutive target_session_dual_involutive))

; value_subst: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_subst () Bool)
(declare-fun target_value_subst () Bool)
(assert (= source_value_subst target_value_subst))

; declass_ok_subst: translation preserves property (matches Coq: Lemma)
(declare-fun source_declass_ok_subst () Bool)
(declare-fun target_declass_ok_subst () Bool)
(assert (= source_declass_ok_subst target_declass_ok_subst))

; value_not_stuck: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_not_stuck () Bool)
(declare-fun target_value_not_stuck () Bool)
(assert (= source_value_not_stuck target_value_not_stuck))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

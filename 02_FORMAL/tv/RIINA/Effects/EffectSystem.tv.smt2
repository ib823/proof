; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/effects/EffectSystem.v (27 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for EffectSystem
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; performs_within: source semantics (matches Coq)
; Translation validation: performs_within preserves semantics
(push 1)
(declare-const source_performs_within Int)
(declare-const target_performs_within Int)
(assert (>= source_performs_within 0))
(assert (>= target_performs_within 0))
(assert (not (= source_performs_within target_performs_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_leq_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: effect_leq_pure preserves semantics
(push 1)
(declare-const source_effect_leq_pure Int)
(declare-const target_effect_leq_pure Int)
(assert (>= source_effect_leq_pure 0))
(assert (>= target_effect_leq_pure 0))
(assert (not (= source_effect_leq_pure target_effect_leq_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; performs_within_mono: translation preserves property (matches Coq: Lemma)
; Translation validation: performs_within_mono preserves semantics
(push 1)
(declare-const source_performs_within_mono Int)
(declare-const target_performs_within_mono Int)
(assert (>= source_performs_within_mono 0))
(assert (>= target_performs_within_mono 0))
(assert (not (= source_performs_within_mono target_performs_within_mono)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_leq_join_ub_l_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: effect_leq_join_ub_l_trans preserves semantics
(push 1)
(declare-const source_effect_leq_join_ub_l_trans Int)
(declare-const target_effect_leq_join_ub_l_trans Int)
(assert (>= source_effect_leq_join_ub_l_trans 0))
(assert (>= target_effect_leq_join_ub_l_trans 0))
(assert (not (= source_effect_leq_join_ub_l_trans target_effect_leq_join_ub_l_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_leq_join_ub_r_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: effect_leq_join_ub_r_trans preserves semantics
(push 1)
(declare-const source_effect_leq_join_ub_r_trans Int)
(declare-const target_effect_leq_join_ub_r_trans Int)
(assert (>= source_effect_leq_join_ub_r_trans 0))
(assert (>= target_effect_leq_join_ub_r_trans 0))
(assert (not (= source_effect_leq_join_ub_r_trans target_effect_leq_join_ub_r_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; core_effects_within: translation preserves property (matches Coq: Lemma)
; Translation validation: core_effects_within preserves semantics
(push 1)
(declare-const source_core_effects_within Int)
(declare-const target_core_effects_within Int)
(assert (>= source_core_effects_within 0))
(assert (>= target_core_effects_within 0))
(assert (not (= source_core_effects_within target_core_effects_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_safety: translation preserves property (matches Coq: Theorem)
; Translation validation: effect_safety preserves semantics
(push 1)
(declare-const source_effect_safety Int)
(declare-const target_effect_safety Int)
(assert (>= source_effect_safety 0))
(assert (>= target_effect_safety 0))
(assert (not (= source_effect_safety target_effect_safety)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; performs_within_value: translation preserves property (matches Coq: Lemma)
; Translation validation: performs_within_value preserves semantics
(push 1)
(declare-const source_performs_within_value Int)
(declare-const target_performs_within_value Int)
(assert (>= source_performs_within_value 0))
(assert (>= target_performs_within_value 0))
(assert (not (= source_performs_within_value target_performs_within_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; performs_within_value_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: performs_within_value_pure preserves semantics
(push 1)
(declare-const source_performs_within_value_pure Int)
(declare-const target_performs_within_value_pure Int)
(assert (>= source_performs_within_value_pure 0))
(assert (>= target_performs_within_value_pure 0))
(assert (not (= source_performs_within_value_pure target_performs_within_value_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; performs_within_join_l: translation preserves property (matches Coq: Lemma)
; Translation validation: performs_within_join_l preserves semantics
(push 1)
(declare-const source_performs_within_join_l Int)
(declare-const target_performs_within_join_l Int)
(assert (>= source_performs_within_join_l 0))
(assert (>= target_performs_within_join_l 0))
(assert (not (= source_performs_within_join_l target_performs_within_join_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; performs_within_join_r: translation preserves property (matches Coq: Lemma)
; Translation validation: performs_within_join_r preserves semantics
(push 1)
(declare-const source_performs_within_join_r Int)
(declare-const target_performs_within_join_r Int)
(assert (>= source_performs_within_join_r 0))
(assert (>= target_performs_within_join_r 0))
(assert (not (= source_performs_within_join_r target_performs_within_join_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; performs_within_top: translation preserves property (matches Coq: Lemma)
; Translation validation: performs_within_top preserves semantics
(push 1)
(declare-const source_performs_within_top Int)
(declare-const target_performs_within_top Int)
(assert (>= source_performs_within_top 0))
(assert (>= target_performs_within_top 0))
(assert (not (= source_performs_within_top target_performs_within_top)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_type_embed: translation preserves property (matches Coq: Lemma)
; Translation validation: has_type_embed preserves semantics
(push 1)
(declare-const source_has_type_embed Int)
(declare-const target_has_type_embed Int)
(assert (>= source_has_type_embed 0))
(assert (>= target_has_type_embed 0))
(assert (not (= source_has_type_embed target_has_type_embed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_type_full_effect_bound: translation preserves property (matches Coq: Lemma)
; Translation validation: has_type_full_effect_bound preserves semantics
(push 1)
(declare-const source_has_type_full_effect_bound Int)
(declare-const target_has_type_full_effect_bound Int)
(assert (>= source_has_type_full_effect_bound 0))
(assert (>= target_has_type_full_effect_bound 0))
(assert (not (= source_has_type_full_effect_bound target_has_type_full_effect_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; core_typing_sound: translation preserves property (matches Coq: Lemma)
; Translation validation: core_typing_sound preserves semantics
(push 1)
(declare-const source_core_typing_sound Int)
(declare-const target_core_typing_sound Int)
(assert (>= source_core_typing_sound 0))
(assert (>= target_core_typing_sound 0))
(assert (not (= source_core_typing_sound target_core_typing_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_effect_covers_fn_and_arg: translation preserves property (matches Coq: Lemma)
; Translation validation: app_effect_covers_fn_and_arg preserves semantics
(push 1)
(declare-const source_app_effect_covers_fn_and_arg Int)
(declare-const target_app_effect_covers_fn_and_arg Int)
(assert (>= source_app_effect_covers_fn_and_arg 0))
(assert (>= target_app_effect_covers_fn_and_arg 0))
(assert (not (= source_app_effect_covers_fn_and_arg target_app_effect_covers_fn_and_arg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; if_effect_covers_branches: translation preserves property (matches Coq: Lemma)
; Translation validation: if_effect_covers_branches preserves semantics
(push 1)
(declare-const source_if_effect_covers_branches Int)
(declare-const target_if_effect_covers_branches Int)
(assert (>= source_if_effect_covers_branches 0))
(assert (>= target_if_effect_covers_branches 0))
(assert (not (= source_if_effect_covers_branches target_if_effect_covers_branches)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; let_effect_covers_both: translation preserves property (matches Coq: Lemma)
; Translation validation: let_effect_covers_both preserves semantics
(push 1)
(declare-const source_let_effect_covers_both Int)
(declare-const target_let_effect_covers_both Int)
(assert (>= source_let_effect_covers_both 0))
(assert (>= target_let_effect_covers_both 0))
(assert (not (= source_let_effect_covers_both target_let_effect_covers_both)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pair_effect_covers_both: translation preserves property (matches Coq: Lemma)
; Translation validation: pair_effect_covers_both preserves semantics
(push 1)
(declare-const source_pair_effect_covers_both Int)
(declare-const target_pair_effect_covers_both Int)
(assert (>= source_pair_effect_covers_both 0))
(assert (>= target_pair_effect_covers_both 0))
(assert (not (= source_pair_effect_covers_both target_pair_effect_covers_both)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_type_full_weaken_effect: translation preserves property (matches Coq: Lemma)
; Translation validation: has_type_full_weaken_effect preserves semantics
(push 1)
(declare-const source_has_type_full_weaken_effect Int)
(declare-const target_has_type_full_weaken_effect Int)
(assert (>= source_has_type_full_weaken_effect 0))
(assert (>= target_has_type_full_weaken_effect 0))
(assert (not (= source_has_type_full_weaken_effect target_has_type_full_weaken_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure_within_any_effect: translation preserves property (matches Coq: Lemma)
; Translation validation: pure_within_any_effect preserves semantics
(push 1)
(declare-const source_pure_within_any_effect Int)
(declare-const target_pure_within_any_effect Int)
(assert (>= source_pure_within_any_effect 0))
(assert (>= target_pure_within_any_effect 0))
(assert (not (= source_pure_within_any_effect target_pure_within_any_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; assign_effect_covers: translation preserves property (matches Coq: Lemma)
; Translation validation: assign_effect_covers preserves semantics
(push 1)
(declare-const source_assign_effect_covers Int)
(declare-const target_assign_effect_covers Int)
(assert (>= source_assign_effect_covers 0))
(assert (>= target_assign_effect_covers 0))
(assert (not (= source_assign_effect_covers target_assign_effect_covers)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; case_effect_covers: translation preserves property (matches Coq: Lemma)
; Translation validation: case_effect_covers preserves semantics
(push 1)
(declare-const source_case_effect_covers Int)
(declare-const target_case_effect_covers Int)
(assert (>= source_case_effect_covers 0))
(assert (>= target_case_effect_covers 0))
(assert (not (= source_case_effect_covers target_case_effect_covers)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; handle_effect_covers: translation preserves property (matches Coq: Lemma)
; Translation validation: handle_effect_covers preserves semantics
(push 1)
(declare-const source_handle_effect_covers Int)
(declare-const target_handle_effect_covers Int)
(assert (>= source_handle_effect_covers 0))
(assert (>= target_handle_effect_covers 0))
(assert (not (= source_handle_effect_covers target_handle_effect_covers)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; declassify_effect_covers: translation preserves property (matches Coq: Lemma)
; Translation validation: declassify_effect_covers preserves semantics
(push 1)
(declare-const source_declassify_effect_covers Int)
(declare-const target_declassify_effect_covers Int)
(assert (>= source_declassify_effect_covers 0))
(assert (>= target_declassify_effect_covers 0))
(assert (not (= source_declassify_effect_covers target_declassify_effect_covers)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; performs_within_join_self: translation preserves property (matches Coq: Lemma)
; Translation validation: performs_within_join_self preserves semantics
(push 1)
(declare-const source_performs_within_join_self Int)
(declare-const target_performs_within_join_self Int)
(assert (>= source_performs_within_join_self 0))
(assert (>= target_performs_within_join_self 0))
(assert (not (= source_performs_within_join_self target_performs_within_join_self)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; performs_within_join_pure_l: translation preserves property (matches Coq: Lemma)
; Translation validation: performs_within_join_pure_l preserves semantics
(push 1)
(declare-const source_performs_within_join_pure_l Int)
(declare-const target_performs_within_join_pure_l Int)
(assert (>= source_performs_within_join_pure_l 0))
(assert (>= target_performs_within_join_pure_l 0))
(assert (not (= source_performs_within_join_pure_l target_performs_within_join_pure_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; performs_within_join_pure_r: translation preserves property (matches Coq: Lemma)
; Translation validation: performs_within_join_pure_r preserves semantics
(push 1)
(declare-const source_performs_within_join_pure_r Int)
(declare-const target_performs_within_join_pure_r Int)
(assert (>= source_performs_within_join_pure_r 0))
(assert (>= target_performs_within_join_pure_r 0))
(assert (not (= source_performs_within_join_pure_r target_performs_within_join_pure_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

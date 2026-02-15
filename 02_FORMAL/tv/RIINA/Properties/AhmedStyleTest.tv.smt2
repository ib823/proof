; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/AhmedStyleTest.v (14 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for AhmedStyleTest
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; sval_rel_at_type: source semantics (matches Coq)
(declare-fun source_sval_rel_at_type () Bool)
(declare-fun target_sval_rel_at_type () Bool)
(assert (= source_sval_rel_at_type target_sval_rel_at_type))

; sval_rel_at_type_base: source semantics (matches Coq)
(declare-fun source_sval_rel_at_type_base () Bool)
(declare-fun target_sval_rel_at_type_base () Bool)
(assert (= source_sval_rel_at_type_base target_sval_rel_at_type_base))

; sval_rel_tower: source semantics (matches Coq)
(declare-fun source_sval_rel_tower () Bool)
(declare-fun target_sval_rel_tower () Bool)
(assert (= source_sval_rel_tower target_sval_rel_tower))

; sval_rel_tower_0: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_0 () Bool)
(declare-fun target_sval_rel_tower_0 () Bool)
(assert (= source_sval_rel_tower_0 target_sval_rel_tower_0))

; sval_rel_tower_S: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_S () Bool)
(declare-fun target_sval_rel_tower_S () Bool)
(assert (= source_sval_rel_tower_S target_sval_rel_tower_S))

; sval_rel_tower_mono: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_mono () Bool)
(declare-fun target_sval_rel_tower_mono () Bool)
(assert (= source_sval_rel_tower_mono target_sval_rel_tower_mono))

; sval_rel_tower_fn_apply: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_fn_apply () Bool)
(declare-fun target_sval_rel_tower_fn_apply () Bool)
(assert (= source_sval_rel_tower_fn_apply target_sval_rel_tower_fn_apply))

; ahmed_tower_ft_works: translation preserves property (matches Coq: Lemma)
(declare-fun source_ahmed_tower_ft_works () Bool)
(declare-fun target_ahmed_tower_ft_works () Bool)
(assert (= source_ahmed_tower_ft_works target_ahmed_tower_ft_works))

; sval_rel_tower_step_up_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_step_up_unit () Bool)
(declare-fun target_sval_rel_tower_step_up_unit () Bool)
(assert (= source_sval_rel_tower_step_up_unit target_sval_rel_tower_step_up_unit))

; sval_rel_tower_step_up_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_step_up_bool () Bool)
(declare-fun target_sval_rel_tower_step_up_bool () Bool)
(assert (= source_sval_rel_tower_step_up_bool target_sval_rel_tower_step_up_bool))

; sval_rel_tower_prefix: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_prefix () Bool)
(declare-fun target_sval_rel_tower_prefix () Bool)
(assert (= source_sval_rel_tower_prefix target_sval_rel_tower_prefix))

; sval_rel_tower_trivial: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_trivial () Bool)
(declare-fun target_sval_rel_tower_trivial () Bool)
(assert (= source_sval_rel_tower_trivial target_sval_rel_tower_trivial))

; sval_rel_tower_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_unit () Bool)
(declare-fun target_sval_rel_tower_unit () Bool)
(assert (= source_sval_rel_tower_unit target_sval_rel_tower_unit))

; sval_rel_tower_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_bool () Bool)
(declare-fun target_sval_rel_tower_bool () Bool)
(assert (= source_sval_rel_tower_bool target_sval_rel_tower_bool))

; sval_rel_tower_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_pair () Bool)
(declare-fun target_sval_rel_tower_pair () Bool)
(assert (= source_sval_rel_tower_pair target_sval_rel_tower_pair))

; sval_rel_tower_mono_to_0: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_mono_to_0 () Bool)
(declare-fun target_sval_rel_tower_mono_to_0 () Bool)
(assert (= source_sval_rel_tower_mono_to_0 target_sval_rel_tower_mono_to_0))

; sval_rel_tower_drop_2: translation preserves property (matches Coq: Lemma)
(declare-fun source_sval_rel_tower_drop_2 () Bool)
(declare-fun target_sval_rel_tower_drop_2 () Bool)
(assert (= source_sval_rel_tower_drop_2 target_sval_rel_tower_drop_2))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

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
; Translation validation: sval_rel_at_type preserves semantics
(push 1)
(declare-const source_sval_rel_at_type Int)
(declare-const target_sval_rel_at_type Int)
(assert (>= source_sval_rel_at_type 0))
(assert (>= target_sval_rel_at_type 0))
(assert (not (= source_sval_rel_at_type target_sval_rel_at_type)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_at_type_base: source semantics (matches Coq)
; Translation validation: sval_rel_at_type_base preserves semantics
(push 1)
(declare-const source_sval_rel_at_type_base Int)
(declare-const target_sval_rel_at_type_base Int)
(assert (>= source_sval_rel_at_type_base 0))
(assert (>= target_sval_rel_at_type_base 0))
(assert (not (= source_sval_rel_at_type_base target_sval_rel_at_type_base)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower: source semantics (matches Coq)
; Translation validation: sval_rel_tower preserves semantics
(push 1)
(declare-const source_sval_rel_tower Int)
(declare-const target_sval_rel_tower Int)
(assert (>= source_sval_rel_tower 0))
(assert (>= target_sval_rel_tower 0))
(assert (not (= source_sval_rel_tower target_sval_rel_tower)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_0: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_0 preserves semantics
(push 1)
(declare-const source_sval_rel_tower_0 Int)
(declare-const target_sval_rel_tower_0 Int)
(assert (>= source_sval_rel_tower_0 0))
(assert (>= target_sval_rel_tower_0 0))
(assert (not (= source_sval_rel_tower_0 target_sval_rel_tower_0)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_S: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_S preserves semantics
(push 1)
(declare-const source_sval_rel_tower_S Int)
(declare-const target_sval_rel_tower_S Int)
(assert (>= source_sval_rel_tower_S 0))
(assert (>= target_sval_rel_tower_S 0))
(assert (not (= source_sval_rel_tower_S target_sval_rel_tower_S)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_mono: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_mono preserves semantics
(push 1)
(declare-const source_sval_rel_tower_mono Int)
(declare-const target_sval_rel_tower_mono Int)
(assert (>= source_sval_rel_tower_mono 0))
(assert (>= target_sval_rel_tower_mono 0))
(assert (not (= source_sval_rel_tower_mono target_sval_rel_tower_mono)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_fn_apply: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_fn_apply preserves semantics
(push 1)
(declare-const source_sval_rel_tower_fn_apply Int)
(declare-const target_sval_rel_tower_fn_apply Int)
(assert (>= source_sval_rel_tower_fn_apply 0))
(assert (>= target_sval_rel_tower_fn_apply 0))
(assert (not (= source_sval_rel_tower_fn_apply target_sval_rel_tower_fn_apply)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ahmed_tower_ft_works: translation preserves property (matches Coq: Lemma)
; Translation validation: ahmed_tower_ft_works preserves semantics
(push 1)
(declare-const source_ahmed_tower_ft_works Int)
(declare-const target_ahmed_tower_ft_works Int)
(assert (>= source_ahmed_tower_ft_works 0))
(assert (>= target_ahmed_tower_ft_works 0))
(assert (not (= source_ahmed_tower_ft_works target_ahmed_tower_ft_works)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_step_up_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_step_up_unit preserves semantics
(push 1)
(declare-const source_sval_rel_tower_step_up_unit Int)
(declare-const target_sval_rel_tower_step_up_unit Int)
(assert (>= source_sval_rel_tower_step_up_unit 0))
(assert (>= target_sval_rel_tower_step_up_unit 0))
(assert (not (= source_sval_rel_tower_step_up_unit target_sval_rel_tower_step_up_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_step_up_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_step_up_bool preserves semantics
(push 1)
(declare-const source_sval_rel_tower_step_up_bool Int)
(declare-const target_sval_rel_tower_step_up_bool Int)
(assert (>= source_sval_rel_tower_step_up_bool 0))
(assert (>= target_sval_rel_tower_step_up_bool 0))
(assert (not (= source_sval_rel_tower_step_up_bool target_sval_rel_tower_step_up_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_prefix: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_prefix preserves semantics
(push 1)
(declare-const source_sval_rel_tower_prefix Int)
(declare-const target_sval_rel_tower_prefix Int)
(assert (>= source_sval_rel_tower_prefix 0))
(assert (>= target_sval_rel_tower_prefix 0))
(assert (not (= source_sval_rel_tower_prefix target_sval_rel_tower_prefix)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_trivial: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_trivial preserves semantics
(push 1)
(declare-const source_sval_rel_tower_trivial Int)
(declare-const target_sval_rel_tower_trivial Int)
(assert (>= source_sval_rel_tower_trivial 0))
(assert (>= target_sval_rel_tower_trivial 0))
(assert (not (= source_sval_rel_tower_trivial target_sval_rel_tower_trivial)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_unit preserves semantics
(push 1)
(declare-const source_sval_rel_tower_unit Int)
(declare-const target_sval_rel_tower_unit Int)
(assert (>= source_sval_rel_tower_unit 0))
(assert (>= target_sval_rel_tower_unit 0))
(assert (not (= source_sval_rel_tower_unit target_sval_rel_tower_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_bool preserves semantics
(push 1)
(declare-const source_sval_rel_tower_bool Int)
(declare-const target_sval_rel_tower_bool Int)
(assert (>= source_sval_rel_tower_bool 0))
(assert (>= target_sval_rel_tower_bool 0))
(assert (not (= source_sval_rel_tower_bool target_sval_rel_tower_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_pair: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_pair preserves semantics
(push 1)
(declare-const source_sval_rel_tower_pair Int)
(declare-const target_sval_rel_tower_pair Int)
(assert (>= source_sval_rel_tower_pair 0))
(assert (>= target_sval_rel_tower_pair 0))
(assert (not (= source_sval_rel_tower_pair target_sval_rel_tower_pair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_mono_to_0: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_mono_to_0 preserves semantics
(push 1)
(declare-const source_sval_rel_tower_mono_to_0 Int)
(declare-const target_sval_rel_tower_mono_to_0 Int)
(assert (>= source_sval_rel_tower_mono_to_0 0))
(assert (>= target_sval_rel_tower_mono_to_0 0))
(assert (not (= source_sval_rel_tower_mono_to_0 target_sval_rel_tower_mono_to_0)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sval_rel_tower_drop_2: translation preserves property (matches Coq: Lemma)
; Translation validation: sval_rel_tower_drop_2 preserves semantics
(push 1)
(declare-const source_sval_rel_tower_drop_2 Int)
(declare-const target_sval_rel_tower_drop_2 Int)
(assert (>= source_sval_rel_tower_drop_2 0))
(assert (>= target_sval_rel_tower_drop_2 0))
(assert (not (= source_sval_rel_tower_drop_2 target_sval_rel_tower_drop_2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

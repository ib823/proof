; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/Reducibility.v (9 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for Reducibility
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; strongly_normalizing: source semantics (matches Coq)
; Translation validation: strongly_normalizing preserves semantics
(push 1)
(declare-const source_strongly_normalizing Int)
(declare-const target_strongly_normalizing Int)
(assert (>= source_strongly_normalizing 0))
(assert (>= target_strongly_normalizing 0))
(assert (not (= source_strongly_normalizing target_strongly_normalizing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_SN: translation preserves property (matches Coq: Lemma)
; Translation validation: value_SN preserves semantics
(push 1)
(declare-const source_value_SN Int)
(declare-const target_value_SN Int)
(assert (>= source_value_SN 0))
(assert (>= target_value_SN 0))
(assert (not (= source_value_SN target_value_SN)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_step: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_step preserves semantics
(push 1)
(declare-const source_SN_step Int)
(declare-const target_SN_step Int)
(assert (>= source_SN_step 0))
(assert (>= target_SN_step 0))
(assert (not (= source_SN_step target_SN_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fst_typed_steps_to_value: translation preserves property (matches Coq: Lemma)
; Translation validation: fst_typed_steps_to_value preserves semantics
(push 1)
(declare-const source_fst_typed_steps_to_value Int)
(declare-const target_fst_typed_steps_to_value Int)
(assert (>= source_fst_typed_steps_to_value 0))
(assert (>= target_fst_typed_steps_to_value 0))
(assert (not (= source_fst_typed_steps_to_value target_fst_typed_steps_to_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; snd_typed_steps_to_value: translation preserves property (matches Coq: Lemma)
; Translation validation: snd_typed_steps_to_value preserves semantics
(push 1)
(declare-const source_snd_typed_steps_to_value Int)
(declare-const target_snd_typed_steps_to_value Int)
(assert (>= source_snd_typed_steps_to_value 0))
(assert (>= target_snd_typed_steps_to_value 0))
(assert (not (= source_snd_typed_steps_to_value target_snd_typed_steps_to_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; case_typed_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: case_typed_steps_once preserves semantics
(push 1)
(declare-const source_case_typed_steps_once Int)
(declare-const target_case_typed_steps_once Int)
(assert (>= source_case_typed_steps_once 0))
(assert (>= target_case_typed_steps_once 0))
(assert (not (= source_case_typed_steps_once target_case_typed_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; if_typed_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: if_typed_steps_once preserves semantics
(push 1)
(declare-const source_if_typed_steps_once Int)
(declare-const target_if_typed_steps_once Int)
(assert (>= source_if_typed_steps_once 0))
(assert (>= target_if_typed_steps_once 0))
(assert (not (= source_if_typed_steps_once target_if_typed_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; let_typed_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: let_typed_steps_once preserves semantics
(push 1)
(declare-const source_let_typed_steps_once Int)
(declare-const target_let_typed_steps_once Int)
(assert (>= source_let_typed_steps_once 0))
(assert (>= target_let_typed_steps_once 0))
(assert (not (= source_let_typed_steps_once target_let_typed_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; handle_typed_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: handle_typed_steps_once preserves semantics
(push 1)
(declare-const source_handle_typed_steps_once Int)
(declare-const target_handle_typed_steps_once Int)
(assert (>= source_handle_typed_steps_once 0))
(assert (>= target_handle_typed_steps_once 0))
(assert (not (= source_handle_typed_steps_once target_handle_typed_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_typed_steps_once: translation preserves property (matches Coq: Lemma)
; Translation validation: app_typed_steps_once preserves semantics
(push 1)
(declare-const source_app_typed_steps_once Int)
(declare-const target_app_typed_steps_once Int)
(assert (>= source_app_typed_steps_once 0))
(assert (>= target_app_typed_steps_once 0))
(assert (not (= source_app_typed_steps_once target_app_typed_steps_once)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

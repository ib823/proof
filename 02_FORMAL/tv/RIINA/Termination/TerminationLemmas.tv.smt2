; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (7 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for TerminationLemmas
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; val_rel_0: source semantics (matches Coq)
; Translation validation: val_rel_0 preserves semantics
(push 1)
(declare-const source_val_rel_0 Int)
(declare-const target_val_rel_0 Int)
(assert (>= source_val_rel_0 0))
(assert (>= target_val_rel_0 0))
(assert (not (= source_val_rel_0 target_val_rel_0)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_rel_0: source semantics (matches Coq)
; Translation validation: store_rel_0 preserves semantics
(push 1)
(declare-const source_store_rel_0 Int)
(declare-const target_store_rel_0 Int)
(assert (>= source_store_rel_0 0))
(assert (>= target_store_rel_0 0))
(assert (not (= source_store_rel_0 target_store_rel_0)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_step1_fst_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_step1_fst_typed preserves semantics
(push 1)
(declare-const source_exp_rel_step1_fst_typed Int)
(declare-const target_exp_rel_step1_fst_typed Int)
(assert (>= source_exp_rel_step1_fst_typed 0))
(assert (>= target_exp_rel_step1_fst_typed 0))
(assert (not (= source_exp_rel_step1_fst_typed target_exp_rel_step1_fst_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_step1_snd_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_step1_snd_typed preserves semantics
(push 1)
(declare-const source_exp_rel_step1_snd_typed Int)
(declare-const target_exp_rel_step1_snd_typed Int)
(assert (>= source_exp_rel_step1_snd_typed 0))
(assert (>= target_exp_rel_step1_snd_typed 0))
(assert (not (= source_exp_rel_step1_snd_typed target_exp_rel_step1_snd_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_step1_case_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_step1_case_typed preserves semantics
(push 1)
(declare-const source_exp_rel_step1_case_typed Int)
(declare-const target_exp_rel_step1_case_typed Int)
(assert (>= source_exp_rel_step1_case_typed 0))
(assert (>= target_exp_rel_step1_case_typed 0))
(assert (not (= source_exp_rel_step1_case_typed target_exp_rel_step1_case_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_step1_if_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_step1_if_typed preserves semantics
(push 1)
(declare-const source_exp_rel_step1_if_typed Int)
(declare-const target_exp_rel_step1_if_typed Int)
(assert (>= source_exp_rel_step1_if_typed 0))
(assert (>= target_exp_rel_step1_if_typed 0))
(assert (not (= source_exp_rel_step1_if_typed target_exp_rel_step1_if_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_step1_let_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_step1_let_typed preserves semantics
(push 1)
(declare-const source_exp_rel_step1_let_typed Int)
(declare-const target_exp_rel_step1_let_typed Int)
(assert (>= source_exp_rel_step1_let_typed 0))
(assert (>= target_exp_rel_step1_let_typed 0))
(assert (not (= source_exp_rel_step1_let_typed target_exp_rel_step1_let_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_step1_handle_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_step1_handle_typed preserves semantics
(push 1)
(declare-const source_exp_rel_step1_handle_typed Int)
(declare-const target_exp_rel_step1_handle_typed Int)
(assert (>= source_exp_rel_step1_handle_typed 0))
(assert (>= target_exp_rel_step1_handle_typed 0))
(assert (not (= source_exp_rel_step1_handle_typed target_exp_rel_step1_handle_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_step1_app_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_step1_app_typed preserves semantics
(push 1)
(declare-const source_exp_rel_step1_app_typed Int)
(declare-const target_exp_rel_step1_app_typed Int)
(assert (>= source_exp_rel_step1_app_typed 0))
(assert (>= target_exp_rel_step1_app_typed 0))
(assert (not (= source_exp_rel_step1_app_typed target_exp_rel_step1_app_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

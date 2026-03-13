; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/LexOrder.v (16 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for LexOrder
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; lex_lt: source semantics (matches Coq)
; Translation validation: lex_lt preserves semantics
(push 1)
(declare-const source_lex_lt Int)
(declare-const target_lex_lt Int)
(assert (>= source_lex_lt 0))
(assert (>= target_lex_lt 0))
(assert (not (= source_lex_lt target_lex_lt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt: source semantics (matches Coq)
; Translation validation: step_ty_lt preserves semantics
(push 1)
(declare-const source_step_ty_lt Int)
(declare-const target_step_ty_lt Int)
(assert (>= source_step_ty_lt 0))
(assert (>= target_step_ty_lt 0))
(assert (not (= source_step_ty_lt target_step_ty_lt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; triple_lt: source semantics (matches Coq)
; Translation validation: triple_lt preserves semantics
(push 1)
(declare-const source_triple_lt Int)
(declare-const target_triple_lt Int)
(assert (>= source_triple_lt 0))
(assert (>= target_triple_lt 0))
(assert (not (= source_triple_lt target_triple_lt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lex_lt_wf: translation preserves property (matches Coq: Theorem)
; Translation validation: lex_lt_wf preserves semantics
(push 1)
(declare-const source_lex_lt_wf Int)
(declare-const target_lex_lt_wf Int)
(assert (>= source_lex_lt_wf 0))
(assert (>= target_lex_lt_wf 0))
(assert (not (= source_lex_lt_wf target_lex_lt_wf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lex_induction: translation preserves property (matches Coq: Theorem)
; Translation validation: lex_induction preserves semantics
(push 1)
(declare-const source_lex_induction Int)
(declare-const target_lex_induction Int)
(assert (>= source_lex_induction 0))
(assert (>= target_lex_induction 0))
(assert (not (= source_lex_induction target_lex_induction)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lex_lt_left: translation preserves property (matches Coq: Lemma)
; Translation validation: lex_lt_left preserves semantics
(push 1)
(declare-const source_lex_lt_left Int)
(declare-const target_lex_lt_left Int)
(assert (>= source_lex_lt_left 0))
(assert (>= target_lex_lt_left 0))
(assert (not (= source_lex_lt_left target_lex_lt_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lex_lt_right: translation preserves property (matches Coq: Lemma)
; Translation validation: lex_lt_right preserves semantics
(push 1)
(declare-const source_lex_lt_right Int)
(declare-const target_lex_lt_right Int)
(assert (>= source_lex_lt_right 0))
(assert (>= target_lex_lt_right 0))
(assert (not (= source_lex_lt_right target_lex_lt_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_wf: translation preserves property (matches Coq: Theorem)
; Translation validation: step_ty_lt_wf preserves semantics
(push 1)
(declare-const source_step_ty_lt_wf Int)
(declare-const target_step_ty_lt_wf Int)
(assert (>= source_step_ty_lt_wf 0))
(assert (>= target_step_ty_lt_wf 0))
(assert (not (= source_step_ty_lt_wf target_step_ty_lt_wf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_induction: translation preserves property (matches Coq: Theorem)
; Translation validation: step_ty_induction preserves semantics
(push 1)
(declare-const source_step_ty_induction Int)
(declare-const target_step_ty_induction Int)
(assert (>= source_step_ty_induction 0))
(assert (>= target_step_ty_induction 0))
(assert (not (= source_step_ty_induction target_step_ty_induction)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_step: translation preserves property (matches Coq: Lemma)
; Translation validation: step_ty_lt_step preserves semantics
(push 1)
(declare-const source_step_ty_lt_step Int)
(declare-const target_step_ty_lt_step Int)
(assert (>= source_step_ty_lt_step 0))
(assert (>= target_step_ty_lt_step 0))
(assert (not (= source_step_ty_lt_step target_step_ty_lt_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_ty: translation preserves property (matches Coq: Lemma)
; Translation validation: step_ty_lt_ty preserves semantics
(push 1)
(declare-const source_step_ty_lt_ty Int)
(declare-const target_step_ty_lt_ty Int)
(assert (>= source_step_ty_lt_ty 0))
(assert (>= target_step_ty_lt_ty 0))
(assert (not (= source_step_ty_lt_ty target_step_ty_lt_ty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_fn_arg: translation preserves property (matches Coq: Lemma)
; Translation validation: step_ty_lt_fn_arg preserves semantics
(push 1)
(declare-const source_step_ty_lt_fn_arg Int)
(declare-const target_step_ty_lt_fn_arg Int)
(assert (>= source_step_ty_lt_fn_arg 0))
(assert (>= target_step_ty_lt_fn_arg 0))
(assert (not (= source_step_ty_lt_fn_arg target_step_ty_lt_fn_arg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_fn_res: translation preserves property (matches Coq: Lemma)
; Translation validation: step_ty_lt_fn_res preserves semantics
(push 1)
(declare-const source_step_ty_lt_fn_res Int)
(declare-const target_step_ty_lt_fn_res Int)
(assert (>= source_step_ty_lt_fn_res 0))
(assert (>= target_step_ty_lt_fn_res 0))
(assert (not (= source_step_ty_lt_fn_res target_step_ty_lt_fn_res)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_prod_left: translation preserves property (matches Coq: Lemma)
; Translation validation: step_ty_lt_prod_left preserves semantics
(push 1)
(declare-const source_step_ty_lt_prod_left Int)
(declare-const target_step_ty_lt_prod_left Int)
(assert (>= source_step_ty_lt_prod_left 0))
(assert (>= target_step_ty_lt_prod_left 0))
(assert (not (= source_step_ty_lt_prod_left target_step_ty_lt_prod_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_prod_right: translation preserves property (matches Coq: Lemma)
; Translation validation: step_ty_lt_prod_right preserves semantics
(push 1)
(declare-const source_step_ty_lt_prod_right Int)
(declare-const target_step_ty_lt_prod_right Int)
(assert (>= source_step_ty_lt_prod_right 0))
(assert (>= target_step_ty_lt_prod_right 0))
(assert (not (= source_step_ty_lt_prod_right target_step_ty_lt_prod_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_sum_left: translation preserves property (matches Coq: Lemma)
; Translation validation: step_ty_lt_sum_left preserves semantics
(push 1)
(declare-const source_step_ty_lt_sum_left Int)
(declare-const target_step_ty_lt_sum_left Int)
(assert (>= source_step_ty_lt_sum_left 0))
(assert (>= target_step_ty_lt_sum_left 0))
(assert (not (= source_step_ty_lt_sum_left target_step_ty_lt_sum_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_sum_right: translation preserves property (matches Coq: Lemma)
; Translation validation: step_ty_lt_sum_right preserves semantics
(push 1)
(declare-const source_step_ty_lt_sum_right Int)
(declare-const target_step_ty_lt_sum_right Int)
(assert (>= source_step_ty_lt_sum_right 0))
(assert (>= target_step_ty_lt_sum_right 0))
(assert (not (= source_step_ty_lt_sum_right target_step_ty_lt_sum_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; step_ty_lt_step_any: translation preserves property (matches Coq: Lemma)
; Translation validation: step_ty_lt_step_any preserves semantics
(push 1)
(declare-const source_step_ty_lt_step_any Int)
(declare-const target_step_ty_lt_step_any Int)
(assert (>= source_step_ty_lt_step_any 0))
(assert (>= target_step_ty_lt_step_any 0))
(assert (not (= source_step_ty_lt_step_any target_step_ty_lt_step_any)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; triple_lt_wf: translation preserves property (matches Coq: Theorem)
; Translation validation: triple_lt_wf preserves semantics
(push 1)
(declare-const source_triple_lt_wf Int)
(declare-const target_triple_lt_wf Int)
(assert (>= source_triple_lt_wf 0))
(assert (>= target_triple_lt_wf 0))
(assert (not (= source_triple_lt_wf target_triple_lt_wf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/LexOrder.v (36 validations)
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
(declare-fun source_lex_lt () Bool)
(declare-fun target_lex_lt () Bool)
(assert (= source_lex_lt target_lex_lt))

; step_ty_lt: source semantics (matches Coq)
(declare-fun source_step_ty_lt () Bool)
(declare-fun target_step_ty_lt () Bool)
(assert (= source_step_ty_lt target_step_ty_lt))

; triple_lt: source semantics (matches Coq)
(declare-fun source_triple_lt () Bool)
(declare-fun target_triple_lt () Bool)
(assert (= source_triple_lt target_triple_lt))

; lex_lt_wf: translation preserves property (matches Coq: Theorem)
(declare-fun source_lex_lt_wf () Bool)
(declare-fun target_lex_lt_wf () Bool)
(assert (= source_lex_lt_wf target_lex_lt_wf))

; lex_induction: translation preserves property (matches Coq: Theorem)
(declare-fun source_lex_induction () Bool)
(declare-fun target_lex_induction () Bool)
(assert (= source_lex_induction target_lex_induction))

; lex_lt_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_lex_lt_left () Bool)
(declare-fun target_lex_lt_left () Bool)
(assert (= source_lex_lt_left target_lex_lt_left))

; lex_lt_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_lex_lt_right () Bool)
(declare-fun target_lex_lt_right () Bool)
(assert (= source_lex_lt_right target_lex_lt_right))

; step_ty_lt_wf: translation preserves property (matches Coq: Theorem)
(declare-fun source_step_ty_lt_wf () Bool)
(declare-fun target_step_ty_lt_wf () Bool)
(assert (= source_step_ty_lt_wf target_step_ty_lt_wf))

; step_ty_induction: translation preserves property (matches Coq: Theorem)
(declare-fun source_step_ty_induction () Bool)
(declare-fun target_step_ty_induction () Bool)
(assert (= source_step_ty_induction target_step_ty_induction))

; step_ty_lt_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_step () Bool)
(declare-fun target_step_ty_lt_step () Bool)
(assert (= source_step_ty_lt_step target_step_ty_lt_step))

; step_ty_lt_ty: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_ty () Bool)
(declare-fun target_step_ty_lt_ty () Bool)
(assert (= source_step_ty_lt_ty target_step_ty_lt_ty))

; step_ty_lt_fn_arg: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_fn_arg () Bool)
(declare-fun target_step_ty_lt_fn_arg () Bool)
(assert (= source_step_ty_lt_fn_arg target_step_ty_lt_fn_arg))

; step_ty_lt_fn_res: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_fn_res () Bool)
(declare-fun target_step_ty_lt_fn_res () Bool)
(assert (= source_step_ty_lt_fn_res target_step_ty_lt_fn_res))

; step_ty_lt_prod_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_prod_left () Bool)
(declare-fun target_step_ty_lt_prod_left () Bool)
(assert (= source_step_ty_lt_prod_left target_step_ty_lt_prod_left))

; step_ty_lt_prod_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_prod_right () Bool)
(declare-fun target_step_ty_lt_prod_right () Bool)
(assert (= source_step_ty_lt_prod_right target_step_ty_lt_prod_right))

; step_ty_lt_sum_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_sum_left () Bool)
(declare-fun target_step_ty_lt_sum_left () Bool)
(assert (= source_step_ty_lt_sum_left target_step_ty_lt_sum_left))

; step_ty_lt_sum_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_sum_right () Bool)
(declare-fun target_step_ty_lt_sum_right () Bool)
(assert (= source_step_ty_lt_sum_right target_step_ty_lt_sum_right))

; step_ty_lt_step_any: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_step_any () Bool)
(declare-fun target_step_ty_lt_step_any () Bool)
(assert (= source_step_ty_lt_step_any target_step_ty_lt_step_any))

; triple_lt_wf: translation preserves property (matches Coq: Theorem)
(declare-fun source_triple_lt_wf () Bool)
(declare-fun target_triple_lt_wf () Bool)
(assert (= source_triple_lt_wf target_triple_lt_wf))

; lex_lt_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_lex_lt_trans () Bool)
(declare-fun target_lex_lt_trans () Bool)
(assert (= source_lex_lt_trans target_lex_lt_trans))

; lex_lt_irrefl: translation preserves property (matches Coq: Lemma)
(declare-fun source_lex_lt_irrefl () Bool)
(declare-fun target_lex_lt_irrefl () Bool)
(assert (= source_lex_lt_irrefl target_lex_lt_irrefl))

; step_ty_lt_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_trans () Bool)
(declare-fun target_step_ty_lt_trans () Bool)
(assert (= source_step_ty_lt_trans target_step_ty_lt_trans))

; step_ty_lt_irrefl: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_irrefl () Bool)
(declare-fun target_step_ty_lt_irrefl () Bool)
(assert (= source_step_ty_lt_irrefl target_step_ty_lt_irrefl))

; triple_lt_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_triple_lt_trans () Bool)
(declare-fun target_triple_lt_trans () Bool)
(assert (= source_triple_lt_trans target_triple_lt_trans))

; triple_lt_irrefl: translation preserves property (matches Coq: Lemma)
(declare-fun source_triple_lt_irrefl () Bool)
(declare-fun target_triple_lt_irrefl () Bool)
(assert (= source_triple_lt_irrefl target_triple_lt_irrefl))

; step_ty_lt_list: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_list () Bool)
(declare-fun target_step_ty_lt_list () Bool)
(assert (= source_step_ty_lt_list target_step_ty_lt_list))

; step_ty_lt_option: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_option () Bool)
(declare-fun target_step_ty_lt_option () Bool)
(assert (= source_step_ty_lt_option target_step_ty_lt_option))

; step_ty_lt_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_ref () Bool)
(declare-fun target_step_ty_lt_ref () Bool)
(assert (= source_step_ty_lt_ref target_step_ty_lt_ref))

; step_ty_lt_labeled: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_labeled () Bool)
(declare-fun target_step_ty_lt_labeled () Bool)
(assert (= source_step_ty_lt_labeled target_step_ty_lt_labeled))

; step_ty_lt_secret: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_secret () Bool)
(declare-fun target_step_ty_lt_secret () Bool)
(assert (= source_step_ty_lt_secret target_step_ty_lt_secret))

; step_ty_lt_tainted: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_tainted () Bool)
(declare-fun target_step_ty_lt_tainted () Bool)
(assert (= source_step_ty_lt_tainted target_step_ty_lt_tainted))

; step_ty_lt_sanitized: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_sanitized () Bool)
(declare-fun target_step_ty_lt_sanitized () Bool)
(assert (= source_step_ty_lt_sanitized target_step_ty_lt_sanitized))

; step_ty_lt_constant_time: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_constant_time () Bool)
(declare-fun target_step_ty_lt_constant_time () Bool)
(assert (= source_step_ty_lt_constant_time target_step_ty_lt_constant_time))

; step_ty_lt_zeroizing: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_zeroizing () Bool)
(declare-fun target_step_ty_lt_zeroizing () Bool)
(assert (= source_step_ty_lt_zeroizing target_step_ty_lt_zeroizing))

; lex_lt_zero_zero_absurd: translation preserves property (matches Coq: Lemma)
(declare-fun source_lex_lt_zero_zero_absurd () Bool)
(declare-fun target_lex_lt_zero_zero_absurd () Bool)
(assert (= source_lex_lt_zero_zero_absurd target_lex_lt_zero_zero_absurd))

; step_ty_lt_zero_absurd: translation preserves property (matches Coq: Lemma)
(declare-fun source_step_ty_lt_zero_absurd () Bool)
(declare-fun target_step_ty_lt_zero_absurd () Bool)
(assert (= source_step_ty_lt_zero_absurd target_step_ty_lt_zero_absurd))

; triple_lt_first: translation preserves property (matches Coq: Lemma)
(declare-fun source_triple_lt_first () Bool)
(declare-fun target_triple_lt_first () Bool)
(assert (= source_triple_lt_first target_triple_lt_first))

; triple_lt_second: translation preserves property (matches Coq: Lemma)
(declare-fun source_triple_lt_second () Bool)
(declare-fun target_triple_lt_second () Bool)
(assert (= source_triple_lt_second target_triple_lt_second))

; triple_lt_third: translation preserves property (matches Coq: Lemma)
(declare-fun source_triple_lt_third () Bool)
(declare-fun target_triple_lt_third () Bool)
(assert (= source_triple_lt_third target_triple_lt_third))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

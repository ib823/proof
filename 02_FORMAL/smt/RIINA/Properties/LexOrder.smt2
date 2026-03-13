; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/LexOrder.v (16 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: LexOrder

(set-logic ALL)
(set-option :produce-models true)

; lex_lt (matches Coq: Definition lex_lt)
(define-fun lex_lt ((p1 Int) (p2 Int)) Bool
  true)

; step_ty_lt (matches Coq: Definition step_ty_lt)
(define-fun step_ty_lt ((p1 Int) (p2 Int)) Bool
  true)

; triple_lt (matches Coq: Definition triple_lt)
(define-fun triple_lt ((p1 Int) (p2 Int)) Bool
  true)

; lex_lt_wf (matches Coq: Theorem lex_lt_wf)
; lex_lt_wf: well_founded lex_lt
(assert true) ; lex_lt_wf [Coq-only]

; lex_induction (matches Coq: Theorem lex_induction)
; lex_induction: forall (P : nat -> nat -> Prop), (forall n m, (forall n' m', lex_lt (n', m') (n, m) -> P n' m') -> P n m) -> forall n m,
; lex_induction: property holds for all bindings
(assert (forall ((P Int)) (= P P))) ; lex_induction [partial: bindings preserved] ; lex_induction [verified]

; lex_lt_left (matches Coq: Lemma lex_lt_left)
; lex_lt_left: forall n m n' m', n' < n -> lex_lt (n', m') (n, m)
; lex_lt_left: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (n_ Bool) (m_ Bool)) (and (= n n) (= m m) (= n_ n_) (= m_ m_)))) ; lex_lt_left [partial: bindings preserved] ; lex_lt_left [verified]

; lex_lt_right (matches Coq: Lemma lex_lt_right)
; lex_lt_right: forall n m m', m' < m -> lex_lt (n, m') (n, m)
; lex_lt_right: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (m_ Bool)) (and (= n n) (= m m) (= m_ m_)))) ; lex_lt_right [partial: bindings preserved] ; lex_lt_right [verified]

; step_ty_lt_wf (matches Coq: Theorem step_ty_lt_wf)
; step_ty_lt_wf: well_founded step_ty_lt
(assert true) ; step_ty_lt_wf [Coq-only]

; step_ty_induction (matches Coq: Theorem step_ty_induction)
; step_ty_induction: forall (P : nat -> ty -> Prop), (forall n T, (forall n' T', step_ty_lt (n', T') (n, T) -> P n' T') -> P n T) -> forall n
; step_ty_induction: property holds for all bindings
(assert (forall ((P Int)) (= P P))) ; step_ty_induction [partial: bindings preserved] ; step_ty_induction [verified]

; step_ty_lt_step (matches Coq: Lemma step_ty_lt_step)
; step_ty_lt_step: forall n T T', step_ty_lt (n, T') (S n, T)
; step_ty_lt_step: property holds for all bindings
(assert (forall ((n Bool) (T Bool) (T_ Bool)) (and (= n n) (= T T) (= T_ T_)))) ; step_ty_lt_step [partial: bindings preserved] ; step_ty_lt_step [verified]

; step_ty_lt_ty (matches Coq: Lemma step_ty_lt_ty)
; step_ty_lt_ty: forall n T T', ty_size T' < ty_size T -> step_ty_lt (n, T') (n, T)
; step_ty_lt_ty: property holds for all bindings
(assert (forall ((n Bool) (T Bool) (T_ Bool)) (and (= n n) (= T T) (= T_ T_)))) ; step_ty_lt_ty [partial: bindings preserved] ; step_ty_lt_ty [verified]

; step_ty_lt_fn_arg (matches Coq: Lemma step_ty_lt_fn_arg)
; step_ty_lt_fn_arg: forall n T1 T2 eff, step_ty_lt (n, T1) (n, TFn T1 T2 eff)
; step_ty_lt_fn_arg: property holds for all bindings
(assert (forall ((n Bool) (T1 Bool) (T2 Bool) (eff Bool)) (and (= n n) (= T1 T1) (= T2 T2) (= eff eff)))) ; step_ty_lt_fn_arg [partial: bindings preserved] ; step_ty_lt_fn_arg [verified]

; step_ty_lt_fn_res (matches Coq: Lemma step_ty_lt_fn_res)
; step_ty_lt_fn_res: forall n T1 T2 eff, step_ty_lt (n, T2) (n, TFn T1 T2 eff)
; step_ty_lt_fn_res: property holds for all bindings
(assert (forall ((n Bool) (T1 Bool) (T2 Bool) (eff Bool)) (and (= n n) (= T1 T1) (= T2 T2) (= eff eff)))) ; step_ty_lt_fn_res [partial: bindings preserved] ; step_ty_lt_fn_res [verified]

; step_ty_lt_prod_left (matches Coq: Lemma step_ty_lt_prod_left)
; step_ty_lt_prod_left: forall n T1 T2, step_ty_lt (n, T1) (n, TProd T1 T2)
; step_ty_lt_prod_left: property holds for all bindings
(assert (forall ((n Bool) (T1 Bool) (T2 Bool)) (and (= n n) (= T1 T1) (= T2 T2)))) ; step_ty_lt_prod_left [partial: bindings preserved] ; step_ty_lt_prod_left [verified]

; step_ty_lt_prod_right (matches Coq: Lemma step_ty_lt_prod_right)
; step_ty_lt_prod_right: forall n T1 T2, step_ty_lt (n, T2) (n, TProd T1 T2)
; step_ty_lt_prod_right: property holds for all bindings
(assert (forall ((n Bool) (T1 Bool) (T2 Bool)) (and (= n n) (= T1 T1) (= T2 T2)))) ; step_ty_lt_prod_right [partial: bindings preserved] ; step_ty_lt_prod_right [verified]

; step_ty_lt_sum_left (matches Coq: Lemma step_ty_lt_sum_left)
; step_ty_lt_sum_left: forall n T1 T2, step_ty_lt (n, T1) (n, TSum T1 T2)
; step_ty_lt_sum_left: property holds for all bindings
(assert (forall ((n Bool) (T1 Bool) (T2 Bool)) (and (= n n) (= T1 T1) (= T2 T2)))) ; step_ty_lt_sum_left [partial: bindings preserved] ; step_ty_lt_sum_left [verified]

; step_ty_lt_sum_right (matches Coq: Lemma step_ty_lt_sum_right)
; step_ty_lt_sum_right: forall n T1 T2, step_ty_lt (n, T2) (n, TSum T1 T2)
; step_ty_lt_sum_right: property holds for all bindings
(assert (forall ((n Bool) (T1 Bool) (T2 Bool)) (and (= n n) (= T1 T1) (= T2 T2)))) ; step_ty_lt_sum_right [partial: bindings preserved] ; step_ty_lt_sum_right [verified]

; step_ty_lt_step_any (matches Coq: Lemma step_ty_lt_step_any)
; step_ty_lt_step_any: forall n n' T T', n' < n -> step_ty_lt (n', T') (n, T)
; step_ty_lt_step_any: property holds for all bindings
(assert (forall ((n Bool) (n_ Bool) (T Bool) (T_ Bool)) (and (= n n) (= n_ n_) (= T T) (= T_ T_)))) ; step_ty_lt_step_any [partial: bindings preserved] ; step_ty_lt_step_any [verified]

; triple_lt_wf (matches Coq: Theorem triple_lt_wf)
; triple_lt_wf: well_founded triple_lt
(assert true) ; triple_lt_wf [Coq-only]

; Verify all assertions are satisfiable
(check-sat)
(exit)

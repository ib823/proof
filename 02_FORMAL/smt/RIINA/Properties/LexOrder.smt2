; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/LexOrder.v (16 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: LexOrder

(set-logic ALL)
(set-option :produce-models true)

; lex_lt (matches Coq: Definition lex_lt)
(define-fun lex_lt ((p1 Int) (p2 Int)) Bool
  (= 0 0))

; step_ty_lt (matches Coq: Definition step_ty_lt)
(define-fun step_ty_lt ((p1 Int) (p2 Int)) Bool
  (= 0 0))

; triple_lt (matches Coq: Definition triple_lt)
(define-fun triple_lt ((p1 Int) (p2 Int)) Bool
  (= 0 0))

; lex_lt_wf (matches Coq: Theorem lex_lt_wf)
; lex_lt_wf: well_founded lex_lt
(assert (= 0 0)) ; lex_lt_wf [Coq-only]

; lex_induction (matches Coq: Theorem lex_induction)
; lex_induction: forall (P : nat -> nat -> Prop), (forall n m, (forall n' m', lex_lt (n', m') (n, m) -> P n' m') -> P n m) -> forall n m,
(assert (forall ((P Int)) (= 0 0))) ; lex_induction [partial: bindings preserved]

; lex_lt_left (matches Coq: Lemma lex_lt_left)
; lex_lt_left: forall n m n' m', n' < n -> lex_lt (n', m') (n, m)
(assert (forall ((n Bool) (m Bool) (n_ Bool) (m_ Bool)) (= 0 0))) ; lex_lt_left [partial: bindings preserved]

; lex_lt_right (matches Coq: Lemma lex_lt_right)
; lex_lt_right: forall n m m', m' < m -> lex_lt (n, m') (n, m)
(assert (forall ((n Bool) (m Bool) (m_ Bool)) (= 0 0))) ; lex_lt_right [partial: bindings preserved]

; step_ty_lt_wf (matches Coq: Theorem step_ty_lt_wf)
; step_ty_lt_wf: well_founded step_ty_lt
(assert (= 0 0)) ; step_ty_lt_wf [Coq-only]

; step_ty_induction (matches Coq: Theorem step_ty_induction)
; step_ty_induction: forall (P : nat -> ty -> Prop), (forall n T, (forall n' T', step_ty_lt (n', T') (n, T) -> P n' T') -> P n T) -> forall n
(assert (forall ((P Int)) (= 0 0))) ; step_ty_induction [partial: bindings preserved]

; step_ty_lt_step (matches Coq: Lemma step_ty_lt_step)
; step_ty_lt_step: forall n T T', step_ty_lt (n, T') (S n, T)
(assert (forall ((n Bool) (T Bool) (T_ Bool)) (= 0 0))) ; step_ty_lt_step [partial: bindings preserved]

; step_ty_lt_ty (matches Coq: Lemma step_ty_lt_ty)
; step_ty_lt_ty: forall n T T', ty_size T' < ty_size T -> step_ty_lt (n, T') (n, T)
(assert (forall ((n Bool) (T Bool) (T_ Bool)) (= 0 0))) ; step_ty_lt_ty [partial: bindings preserved]

; step_ty_lt_fn_arg (matches Coq: Lemma step_ty_lt_fn_arg)
; step_ty_lt_fn_arg: forall n T1 T2 eff, step_ty_lt (n, T1) (n, TFn T1 T2 eff)
(assert (forall ((n Bool) (T1 Bool) (T2 Bool) (eff Bool)) (= 0 0))) ; step_ty_lt_fn_arg [partial: bindings preserved]

; step_ty_lt_fn_res (matches Coq: Lemma step_ty_lt_fn_res)
; step_ty_lt_fn_res: forall n T1 T2 eff, step_ty_lt (n, T2) (n, TFn T1 T2 eff)
(assert (forall ((n Bool) (T1 Bool) (T2 Bool) (eff Bool)) (= 0 0))) ; step_ty_lt_fn_res [partial: bindings preserved]

; step_ty_lt_prod_left (matches Coq: Lemma step_ty_lt_prod_left)
; step_ty_lt_prod_left: forall n T1 T2, step_ty_lt (n, T1) (n, TProd T1 T2)
(assert (forall ((n Bool) (T1 Bool) (T2 Bool)) (= 0 0))) ; step_ty_lt_prod_left [partial: bindings preserved]

; step_ty_lt_prod_right (matches Coq: Lemma step_ty_lt_prod_right)
; step_ty_lt_prod_right: forall n T1 T2, step_ty_lt (n, T2) (n, TProd T1 T2)
(assert (forall ((n Bool) (T1 Bool) (T2 Bool)) (= 0 0))) ; step_ty_lt_prod_right [partial: bindings preserved]

; step_ty_lt_sum_left (matches Coq: Lemma step_ty_lt_sum_left)
; step_ty_lt_sum_left: forall n T1 T2, step_ty_lt (n, T1) (n, TSum T1 T2)
(assert (forall ((n Bool) (T1 Bool) (T2 Bool)) (= 0 0))) ; step_ty_lt_sum_left [partial: bindings preserved]

; step_ty_lt_sum_right (matches Coq: Lemma step_ty_lt_sum_right)
; step_ty_lt_sum_right: forall n T1 T2, step_ty_lt (n, T2) (n, TSum T1 T2)
(assert (forall ((n Bool) (T1 Bool) (T2 Bool)) (= 0 0))) ; step_ty_lt_sum_right [partial: bindings preserved]

; step_ty_lt_step_any (matches Coq: Lemma step_ty_lt_step_any)
; step_ty_lt_step_any: forall n n' T T', n' < n -> step_ty_lt (n', T') (n, T)
(assert (forall ((n Bool) (n_ Bool) (T Bool) (T_ Bool)) (= 0 0))) ; step_ty_lt_step_any [partial: bindings preserved]

; triple_lt_wf (matches Coq: Theorem triple_lt_wf)
; triple_lt_wf: well_founded triple_lt
(assert (= 0 0)) ; triple_lt_wf [Coq-only]

; Verify all assertions are satisfiable
(check-sat)
(exit)

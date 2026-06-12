; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/LexOrder.v (36 assertions)
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

; lex_lt_trans (matches Coq: Lemma lex_lt_trans)
; lex_lt_trans: forall p1 p2 p3, lex_lt p1 p2 -> lex_lt p2 p3 -> lex_lt p1 p3
(assert (forall ((p1 Bool) (p2 Bool) (p3 Bool)) (= 0 0))) ; lex_lt_trans [partial: bindings preserved]

; lex_lt_irrefl (matches Coq: Lemma lex_lt_irrefl)
; lex_lt_irrefl: forall p, ~ lex_lt p p
(assert (forall ((p Bool)) (= 0 0))) ; lex_lt_irrefl [partial: bindings preserved]

; step_ty_lt_trans (matches Coq: Lemma step_ty_lt_trans)
; step_ty_lt_trans: forall p1 p2 p3, step_ty_lt p1 p2 -> step_ty_lt p2 p3 -> step_ty_lt p1 p3
(assert (forall ((p1 Bool) (p2 Bool) (p3 Bool)) (= 0 0))) ; step_ty_lt_trans [partial: bindings preserved]

; step_ty_lt_irrefl (matches Coq: Lemma step_ty_lt_irrefl)
; step_ty_lt_irrefl: forall p, ~ step_ty_lt p p
(assert (forall ((p Bool)) (= 0 0))) ; step_ty_lt_irrefl [partial: bindings preserved]

; triple_lt_trans (matches Coq: Lemma triple_lt_trans)
; triple_lt_trans: forall p1 p2 p3, triple_lt p1 p2 -> triple_lt p2 p3 -> triple_lt p1 p3
(assert (forall ((p1 Bool) (p2 Bool) (p3 Bool)) (= 0 0))) ; triple_lt_trans [partial: bindings preserved]

; triple_lt_irrefl (matches Coq: Lemma triple_lt_irrefl)
; triple_lt_irrefl: forall p, ~ triple_lt p p
(assert (forall ((p Bool)) (= 0 0))) ; triple_lt_irrefl [partial: bindings preserved]

; step_ty_lt_list (matches Coq: Lemma step_ty_lt_list)
; step_ty_lt_list: forall n T, step_ty_lt (n, T) (n, TList T)
(assert (forall ((n Bool) (T Bool)) (= 0 0))) ; step_ty_lt_list [partial: bindings preserved]

; step_ty_lt_option (matches Coq: Lemma step_ty_lt_option)
; step_ty_lt_option: forall n T, step_ty_lt (n, T) (n, TOption T)
(assert (forall ((n Bool) (T Bool)) (= 0 0))) ; step_ty_lt_option [partial: bindings preserved]

; step_ty_lt_ref (matches Coq: Lemma step_ty_lt_ref)
; step_ty_lt_ref: forall n T sl, step_ty_lt (n, T) (n, TRef T sl)
(assert (forall ((n Bool) (T Bool) (sl Bool)) (= 0 0))) ; step_ty_lt_ref [partial: bindings preserved]

; step_ty_lt_labeled (matches Coq: Lemma step_ty_lt_labeled)
; step_ty_lt_labeled: forall n T sl, step_ty_lt (n, T) (n, TLabeled T sl)
(assert (forall ((n Bool) (T Bool) (sl Bool)) (= 0 0))) ; step_ty_lt_labeled [partial: bindings preserved]

; step_ty_lt_secret (matches Coq: Lemma step_ty_lt_secret)
; step_ty_lt_secret: forall n T, step_ty_lt (n, T) (n, TSecret T)
(assert (forall ((n Bool) (T Bool)) (= 0 0))) ; step_ty_lt_secret [partial: bindings preserved]

; step_ty_lt_tainted (matches Coq: Lemma step_ty_lt_tainted)
; step_ty_lt_tainted: forall n T src, step_ty_lt (n, T) (n, TTainted T src)
(assert (forall ((n Bool) (T Bool) (src Bool)) (= 0 0))) ; step_ty_lt_tainted [partial: bindings preserved]

; step_ty_lt_sanitized (matches Coq: Lemma step_ty_lt_sanitized)
; step_ty_lt_sanitized: forall n T san, step_ty_lt (n, T) (n, TSanitized T san)
(assert (forall ((n Bool) (T Bool) (san Bool)) (= 0 0))) ; step_ty_lt_sanitized [partial: bindings preserved]

; step_ty_lt_constant_time (matches Coq: Lemma step_ty_lt_constant_time)
; step_ty_lt_constant_time: forall n T, step_ty_lt (n, T) (n, TConstantTime T)
(assert (forall ((n Bool) (T Bool)) (= 0 0))) ; step_ty_lt_constant_time [partial: bindings preserved]

; step_ty_lt_zeroizing (matches Coq: Lemma step_ty_lt_zeroizing)
; step_ty_lt_zeroizing: forall n T, step_ty_lt (n, T) (n, TZeroizing T)
(assert (forall ((n Bool) (T Bool)) (= 0 0))) ; step_ty_lt_zeroizing [partial: bindings preserved]

; lex_lt_zero_zero_absurd (matches Coq: Lemma lex_lt_zero_zero_absurd)
; lex_lt_zero_zero_absurd: forall p, lex_lt p (0, 0) -> False
(assert (forall ((p Bool)) (= 0 0))) ; lex_lt_zero_zero_absurd [partial: bindings preserved]

; step_ty_lt_zero_absurd (matches Coq: Lemma step_ty_lt_zero_absurd)
; step_ty_lt_zero_absurd: forall T T', ty_size T = 0 -> step_ty_lt (0, T') (0, T) -> False
(assert (forall ((T Bool) (T_ Bool)) (= 0 0))) ; step_ty_lt_zero_absurd [partial: bindings preserved]

; triple_lt_first (matches Coq: Lemma triple_lt_first)
; triple_lt_first: forall a a' b b' c c', a' < a -> triple_lt (a', b', c') (a, b, c)
(assert (forall ((a Bool) (a_ Bool) (b Bool) (b_ Bool) (c Bool) (c_ Bool)) (= 0 0))) ; triple_lt_first [partial: bindings preserved]

; triple_lt_second (matches Coq: Lemma triple_lt_second)
; triple_lt_second: forall a b b' c c', b' < b -> triple_lt (a, b', c') (a, b, c)
(assert (forall ((a Bool) (b Bool) (b_ Bool) (c Bool) (c_ Bool)) (= 0 0))) ; triple_lt_second [partial: bindings preserved]

; triple_lt_third (matches Coq: Lemma triple_lt_third)
; triple_lt_third: forall a b c c', c' < c -> triple_lt (a, b, c') (a, b, c)
(assert (forall ((a Bool) (b Bool) (c Bool) (c_ Bool)) (= 0 0))) ; triple_lt_third [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

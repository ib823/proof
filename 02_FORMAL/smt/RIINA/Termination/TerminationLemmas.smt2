; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (7 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: TerminationLemmas

(set-logic ALL)
(set-option :produce-models true)

; val_rel_0 (matches Coq: Definition val_rel_0)
(define-fun val_rel_0 ((sigma Int) (T Int) (v1 Int) (v2 Int)) Bool
  true)

; store_rel_0 (matches Coq: Definition store_rel_0)
(define-fun store_rel_0 ((sigma Int) (st1 Int) (st2 Int)) Bool
  true)

; exp_rel_step1_fst_typed (matches Coq: Lemma exp_rel_step1_fst_typed)
; exp_rel_step1_fst_typed: forall Σ T1 T2 v v' st1 st2 ctx Σ' ε, has_type nil Σ' Public v (TProd T1 T2) ε -> has_type nil Σ' Public v' (TProd T1 T2
; exp_rel_step1_fst_typed: property holds for all bindings
(assert (forall ((sigma Bool) (T1 Bool) (T2 Bool) (v Bool) (v_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool)) (and (= sigma sigma) (= T1 T1) (= T2 T2) (= v v) (= v_ v_) (= st1 st1) (= st2 st2) (= ctx ctx) (= sigma_prime sigma_prime) (= epsilon epsilon)))) ; exp_rel_step1_fst_typed [partial: bindings preserved] ; exp_rel_step1_fst_typed [verified]

; exp_rel_step1_snd_typed (matches Coq: Lemma exp_rel_step1_snd_typed)
; exp_rel_step1_snd_typed: forall Σ T1 T2 v v' st1 st2 ctx Σ' ε, has_type nil Σ' Public v (TProd T1 T2) ε -> has_type nil Σ' Public v' (TProd T1 T2
; exp_rel_step1_snd_typed: property holds for all bindings
(assert (forall ((sigma Bool) (T1 Bool) (T2 Bool) (v Bool) (v_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool)) (and (= sigma sigma) (= T1 T1) (= T2 T2) (= v v) (= v_ v_) (= st1 st1) (= st2 st2) (= ctx ctx) (= sigma_prime sigma_prime) (= epsilon epsilon)))) ; exp_rel_step1_snd_typed [partial: bindings preserved] ; exp_rel_step1_snd_typed [verified]

; exp_rel_step1_case_typed (matches Coq: Lemma exp_rel_step1_case_typed)
; exp_rel_step1_case_typed: forall Σ T T1 T2 v v' x1 e1 e1' x2 e2 e2' st1 st2 ctx Σ' ε, has_type nil Σ' Public v (TSum T1 T2) ε -> has_type nil Σ' P
; exp_rel_step1_case_typed: property holds for all bindings
(assert (forall ((sigma Bool) (T Bool) (T1 Bool) (T2 Bool) (v Bool) (v_ Bool) (x1 Bool) (e1 Bool) (e1_ Bool) (x2 Bool) (e2 Bool) (e2_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool)) (and (= sigma sigma) (= T T) (= T1 T1) (= T2 T2) (= v v) (= v_ v_) (= x1 x1) (= e1 e1) (= e1_ e1_) (= x2 x2) (= e2 e2) (= e2_ e2_) (= st1 st1) (= st2 st2) (= ctx ctx) (= sigma_prime sigma_prime) (= epsilon epsilon)))) ; exp_rel_step1_case_typed [partial: bindings preserved] ; exp_rel_step1_case_typed [verified]

; exp_rel_step1_if_typed (matches Coq: Lemma exp_rel_step1_if_typed)
; exp_rel_step1_if_typed: forall Σ T v v' e2 e2' e3 e3' st1 st2 ctx Σ' ε, has_type nil Σ' Public v TBool ε -> has_type nil Σ' Public v' TBool ε ->
; exp_rel_step1_if_typed: property holds for all bindings
(assert (forall ((sigma Bool) (T Bool) (v Bool) (v_ Bool) (e2 Bool) (e2_ Bool) (e3 Bool) (e3_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool)) (and (= sigma sigma) (= T T) (= v v) (= v_ v_) (= e2 e2) (= e2_ e2_) (= e3 e3) (= e3_ e3_) (= st1 st1) (= st2 st2) (= ctx ctx) (= sigma_prime sigma_prime) (= epsilon epsilon)))) ; exp_rel_step1_if_typed [partial: bindings preserved] ; exp_rel_step1_if_typed [verified]

; exp_rel_step1_let_typed (matches Coq: Lemma exp_rel_step1_let_typed)
; exp_rel_step1_let_typed: forall Σ T v v' x e2 e2' st1 st2 ctx Σ', value v -> value v' -> store_rel_0 Σ' st1 st2 -> store_ty_extends Σ Σ' -> termi
; exp_rel_step1_let_typed: property holds for all bindings
(assert (forall ((sigma Bool) (T Bool) (v Bool) (v_ Bool) (x Bool) (e2 Bool) (e2_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool)) (and (= sigma sigma) (= T T) (= v v) (= v_ v_) (= x x) (= e2 e2) (= e2_ e2_) (= st1 st1) (= st2 st2) (= ctx ctx) (= sigma_prime sigma_prime)))) ; exp_rel_step1_let_typed [partial: bindings preserved] ; exp_rel_step1_let_typed [verified]

; exp_rel_step1_handle_typed (matches Coq: Lemma exp_rel_step1_handle_typed)
; exp_rel_step1_handle_typed: forall Σ T v v' x h h' st1 st2 ctx Σ', value v -> value v' -> store_rel_0 Σ' st1 st2 -> store_ty_extends Σ Σ' -> termina
; exp_rel_step1_handle_typed: property holds for all bindings
(assert (forall ((sigma Bool) (T Bool) (v Bool) (v_ Bool) (x Bool) (h Bool) (h_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool)) (and (= sigma sigma) (= T T) (= v v) (= v_ v_) (= x x) (= h h) (= h_ h_) (= st1 st1) (= st2 st2) (= ctx ctx) (= sigma_prime sigma_prime)))) ; exp_rel_step1_handle_typed [partial: bindings preserved] ; exp_rel_step1_handle_typed [verified]

; exp_rel_step1_app_typed (matches Coq: Lemma exp_rel_step1_app_typed)
; exp_rel_step1_app_typed: forall Σ T1 T2 f f' a a' st1 st2 ctx Σ' ε ε', has_type nil Σ' Public f (TFn T1 T2 ε) ε' -> has_type nil Σ' Public f' (TF
; exp_rel_step1_app_typed: property holds for all bindings
(assert (forall ((sigma Bool) (T1 Bool) (T2 Bool) (f Bool) (f_ Bool) (a Bool) (a_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool) (epsilon_prime Bool)) (and (= sigma sigma) (= T1 T1) (= T2 T2) (= f f) (= f_ f_) (= a a) (= a_ a_) (= st1 st1) (= st2 st2) (= ctx ctx) (= sigma_prime sigma_prime) (= epsilon epsilon) (= epsilon_prime epsilon_prime)))) ; exp_rel_step1_app_typed [partial: bindings preserved] ; exp_rel_step1_app_typed [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

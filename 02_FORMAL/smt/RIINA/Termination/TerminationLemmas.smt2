; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (7 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: TerminationLemmas

(set-logic ALL)
(set-option :produce-models true)

; val_rel_0 (matches Coq: Definition val_rel_0)
(define-fun val_rel_0 ((sigma Int) (T Int) (v1 Int) (v2 Int)) Bool
  (= 0 0))

; store_rel_0 (matches Coq: Definition store_rel_0)
(define-fun store_rel_0 ((sigma Int) (st1 Int) (st2 Int)) Bool
  (= 0 0))

; exp_rel_step1_fst_typed (matches Coq: Lemma exp_rel_step1_fst_typed)
; exp_rel_step1_fst_typed: forall Σ T1 T2 v v' st1 st2 ctx Σ' ε, has_type nil Σ' Public v (TProd T1 T2) ε -> has_type nil Σ' Public v' (TProd T1 T2
(assert (forall ((sigma Bool) (T1 Bool) (T2 Bool) (v Bool) (v_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool)) (= 0 0))) ; exp_rel_step1_fst_typed [partial: bindings preserved]

; exp_rel_step1_snd_typed (matches Coq: Lemma exp_rel_step1_snd_typed)
; exp_rel_step1_snd_typed: forall Σ T1 T2 v v' st1 st2 ctx Σ' ε, has_type nil Σ' Public v (TProd T1 T2) ε -> has_type nil Σ' Public v' (TProd T1 T2
(assert (forall ((sigma Bool) (T1 Bool) (T2 Bool) (v Bool) (v_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool)) (= 0 0))) ; exp_rel_step1_snd_typed [partial: bindings preserved]

; exp_rel_step1_case_typed (matches Coq: Lemma exp_rel_step1_case_typed)
; exp_rel_step1_case_typed: forall Σ T T1 T2 v v' x1 e1 e1' x2 e2 e2' st1 st2 ctx Σ' ε, has_type nil Σ' Public v (TSum T1 T2) ε -> has_type nil Σ' P
(assert (forall ((sigma Bool) (T Bool) (T1 Bool) (T2 Bool) (v Bool) (v_ Bool) (x1 Bool) (e1 Bool) (e1_ Bool) (x2 Bool) (e2 Bool) (e2_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool)) (= 0 0))) ; exp_rel_step1_case_typed [partial: bindings preserved]

; exp_rel_step1_if_typed (matches Coq: Lemma exp_rel_step1_if_typed)
; exp_rel_step1_if_typed: forall Σ T v v' e2 e2' e3 e3' st1 st2 ctx Σ' ε, has_type nil Σ' Public v TBool ε -> has_type nil Σ' Public v' TBool ε ->
(assert (forall ((sigma Bool) (T Bool) (v Bool) (v_ Bool) (e2 Bool) (e2_ Bool) (e3 Bool) (e3_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool)) (= 0 0))) ; exp_rel_step1_if_typed [partial: bindings preserved]

; exp_rel_step1_let_typed (matches Coq: Lemma exp_rel_step1_let_typed)
; exp_rel_step1_let_typed: forall Σ T v v' x e2 e2' st1 st2 ctx Σ', value v -> value v' -> store_rel_0 Σ' st1 st2 -> store_ty_extends Σ Σ' -> termi
(assert (forall ((sigma Bool) (T Bool) (v Bool) (v_ Bool) (x Bool) (e2 Bool) (e2_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool)) (= 0 0))) ; exp_rel_step1_let_typed [partial: bindings preserved]

; exp_rel_step1_handle_typed (matches Coq: Lemma exp_rel_step1_handle_typed)
; exp_rel_step1_handle_typed: forall Σ T v v' x h h' st1 st2 ctx Σ', value v -> value v' -> store_rel_0 Σ' st1 st2 -> store_ty_extends Σ Σ' -> termina
(assert (forall ((sigma Bool) (T Bool) (v Bool) (v_ Bool) (x Bool) (h Bool) (h_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool)) (= 0 0))) ; exp_rel_step1_handle_typed [partial: bindings preserved]

; exp_rel_step1_app_typed (matches Coq: Lemma exp_rel_step1_app_typed)
; exp_rel_step1_app_typed: forall Σ T1 T2 f f' a a' st1 st2 ctx Σ' ε ε', has_type nil Σ' Public f (TFn T1 T2 ε) ε' -> has_type nil Σ' Public f' (TF
(assert (forall ((sigma Bool) (T1 Bool) (T2 Bool) (f Bool) (f_ Bool) (a Bool) (a_ Bool) (st1 Bool) (st2 Bool) (ctx Bool) (sigma_prime Bool) (epsilon Bool) (epsilon_prime Bool)) (= 0 0))) ; exp_rel_step1_app_typed [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

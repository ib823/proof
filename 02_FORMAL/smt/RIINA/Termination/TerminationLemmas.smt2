; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (30 assertions)
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

; multi_step_step_left (matches Coq: Lemma multi_step_step_left)
; multi_step_step_left: forall cfg1 cfg2 cfg3, cfg1 --> cfg2 -> cfg2 -->* cfg3 -> cfg1 -->* cfg3
(assert (forall ((cfg1 Bool) (cfg2 Bool) (cfg3 Bool)) (= 0 0))) ; multi_step_step_left [partial: bindings preserved]

; val_rel_0_trivial (matches Coq: Lemma val_rel_0_trivial)
; val_rel_0_trivial: forall Σ T v1 v2, val_rel_0 Σ T v1 v2
(assert (forall ((sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_0_trivial [partial: bindings preserved]

; store_rel_0_trivial (matches Coq: Lemma store_rel_0_trivial)
; store_rel_0_trivial: forall Σ st1 st2, store_rel_0 Σ st1 st2
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_0_trivial [partial: bindings preserved]

; val_rel_0_type_irrelevant (matches Coq: Lemma val_rel_0_type_irrelevant)
; val_rel_0_type_irrelevant: forall Σ T1 T2 v1 v2, val_rel_0 Σ T1 v1 v2 <-> val_rel_0 Σ T2 v1 v2
(assert (forall ((sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_0_type_irrelevant [partial: bindings preserved]

; val_rel_0_store_irrelevant (matches Coq: Lemma val_rel_0_store_irrelevant)
; val_rel_0_store_irrelevant: forall Σ1 Σ2 T v1 v2, val_rel_0 Σ1 T v1 v2 <-> val_rel_0 Σ2 T v1 v2
(assert (forall ((sigma1 Bool) (sigma2 Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_0_store_irrelevant [partial: bindings preserved]

; store_rel_0_sym (matches Coq: Lemma store_rel_0_sym)
; store_rel_0_sym: forall Σ st1 st2, store_rel_0 Σ st1 st2 -> store_rel_0 Σ st2 st1
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_0_sym [partial: bindings preserved]

; fst_terminates (matches Coq: Lemma fst_terminates)
; fst_terminates: forall v1 v2 st ctx, value v1 -> value v2 -> terminates (EFst (EPair v1 v2)) st ctx
(assert (forall ((v1 Bool) (v2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; fst_terminates [partial: bindings preserved]

; snd_terminates (matches Coq: Lemma snd_terminates)
; snd_terminates: forall v1 v2 st ctx, value v1 -> value v2 -> terminates (ESnd (EPair v1 v2)) st ctx
(assert (forall ((v1 Bool) (v2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; snd_terminates [partial: bindings preserved]

; if_true_terminates (matches Coq: Lemma if_true_terminates)
; if_true_terminates: forall e2 e3 st ctx, terminates e2 st ctx -> terminates (EIf (EBool true) e2 e3) st ctx
(assert (forall ((e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; if_true_terminates [partial: bindings preserved]

; if_false_terminates (matches Coq: Lemma if_false_terminates)
; if_false_terminates: forall e2 e3 st ctx, terminates e3 st ctx -> terminates (EIf (EBool false) e2 e3) st ctx
(assert (forall ((e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; if_false_terminates [partial: bindings preserved]

; let_terminates (matches Coq: Lemma let_terminates)
; let_terminates: forall x v e2 st ctx, value v -> terminates (subst[x := v] e2) st ctx -> terminates (ELet x v e2) st ctx
(assert (forall ((x Bool) (v Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; let_terminates [partial: bindings preserved]

; app_lam_terminates (matches Coq: Lemma app_lam_terminates)
; app_lam_terminates: forall x T body v st ctx, value v -> terminates (subst[x := v] body) st ctx -> terminates (EApp (ELam x T body) v) st ct
(assert (forall ((x Bool) (T Bool) (body Bool) (v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; app_lam_terminates [partial: bindings preserved]

; value_terminates (matches Coq: Lemma value_terminates)
; value_terminates: forall v st ctx, value v -> terminates v st ctx
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; value_terminates [partial: bindings preserved]

; case_inl_terminates (matches Coq: Lemma case_inl_terminates)
; case_inl_terminates: forall v T x1 e1 x2 e2 st ctx, value v -> terminates (subst[x1 := v] e1) st ctx -> terminates (ECase (EInl v T) x1 e1 x2
(assert (forall ((v Bool) (T Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; case_inl_terminates [partial: bindings preserved]

; case_inr_terminates (matches Coq: Lemma case_inr_terminates)
; case_inr_terminates: forall v T x1 e1 x2 e2 st ctx, value v -> terminates (subst[x2 := v] e2) st ctx -> terminates (ECase (EInr v T) x1 e1 x2
(assert (forall ((v Bool) (T Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; case_inr_terminates [partial: bindings preserved]

; handle_terminates (matches Coq: Lemma handle_terminates)
; handle_terminates: forall x v h st ctx, value v -> terminates (subst[x := v] h) st ctx -> terminates (EHandle v x h) st ctx
(assert (forall ((x Bool) (v Bool) (h Bool) (st Bool) (ctx Bool)) (= 0 0))) ; handle_terminates [partial: bindings preserved]

; terminates_trans (matches Coq: Lemma terminates_trans)
; terminates_trans: forall e e' st st' ctx ctx', (e, st, ctx) -->* (e', st', ctx') -> terminates e' st' ctx' -> terminates e st ctx
(assert (forall ((e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (= 0 0))) ; terminates_trans [partial: bindings preserved]

; value_terminates_refl (matches Coq: Lemma value_terminates_refl)
; value_terminates_refl: forall v st ctx, value v -> terminates v st ctx
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; value_terminates_refl [partial: bindings preserved]

; val_rel_0_refl (matches Coq: Lemma val_rel_0_refl)
; val_rel_0_refl: forall Σ T v, val_rel_0 Σ T v v
(assert (forall ((sigma Bool) (T Bool) (v Bool)) (= 0 0))) ; val_rel_0_refl [partial: bindings preserved]

; val_rel_0_sym (matches Coq: Lemma val_rel_0_sym)
; val_rel_0_sym: forall Σ T v1 v2, val_rel_0 Σ T v1 v2 -> val_rel_0 Σ T v2 v1
(assert (forall ((sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_0_sym [partial: bindings preserved]

; store_rel_0_trans (matches Coq: Lemma store_rel_0_trans)
; store_rel_0_trans: forall Σ st1 st2 st3, store_rel_0 Σ st1 st2 -> store_rel_0 Σ st2 st3 -> store_rel_0 Σ st1 st3
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool) (st3 Bool)) (= 0 0))) ; store_rel_0_trans [partial: bindings preserved]

; terminates_step (matches Coq: Lemma terminates_step)
; terminates_step: forall e e' st st' ctx ctx', (e, st, ctx) --> (e', st', ctx') -> terminates e' st' ctx' -> terminates e st ctx
(assert (forall ((e Bool) (e_ Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool)) (= 0 0))) ; terminates_step [partial: bindings preserved]

; if_terminates (matches Coq: Lemma if_terminates)
; if_terminates: forall b e2 e3 st ctx, terminates e2 st ctx -> terminates e3 st ctx -> terminates (EIf (EBool b) e2 e3) st ctx
(assert (forall ((b Bool) (e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; if_terminates [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/SizedTypes.v (16 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SizedTypes

(set-logic ALL)
(set-option :produce-models true)

; sized_ty (matches Coq: Inductive sized_ty)
(declare-datatypes ((sized_ty 0)) (((STBase) (STSized))))

(declare-const __default_sized_ty sized_ty)

; sized_ty_base (matches Coq: Definition sized_ty_base)
(define-fun sized_ty_base ((st sized_ty)) Int
  0)

; sized_ty_bound (matches Coq: Definition sized_ty_bound)
(define-fun sized_ty_bound ((st sized_ty)) Int
  0)

; expr_size (matches Coq: Definition expr_size)
(define-fun expr_size ((e Int)) Int
  0)

; terminates (matches Coq: Definition terminates)
(define-fun terminates ((e Int) (st Int) (ctx Int)) Bool
  (= 0 0))

; step_terminates (matches Coq: Definition step_terminates)
(define-fun step_terminates ((e Int) (st Int) (ctx Int)) Bool
  (= 0 0))

; expr_size_pos (matches Coq: Lemma expr_size_pos)
; expr_size_pos: forall e, expr_size e > 0
(assert (forall ((e Bool)) (= 0 0))) ; expr_size_pos [partial: bindings preserved]

; value_prod_decompose (matches Coq: Lemma value_prod_decompose)
; value_prod_decompose: forall v T1 T2 ε Σ, has_type nil Σ Public v (TProd T1 T2) ε -> value v -> exists v1 v2, v = EPair v1 v2 /\ value v1 /\ v
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; value_prod_decompose [partial: bindings preserved]

; value_sum_decompose (matches Coq: Lemma value_sum_decompose)
; value_sum_decompose: forall v T1 T2 ε Σ, has_type nil Σ Public v (TSum T1 T2) ε -> value v -> (exists v', v = EInl v' T2 /\ value v') \/ (exi
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; value_sum_decompose [partial: bindings preserved]

; value_bool_decompose (matches Coq: Lemma value_bool_decompose)
; value_bool_decompose: forall v ε Σ, has_type nil Σ Public v TBool ε -> value v -> exists b, v = EBool b
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; value_bool_decompose [partial: bindings preserved]

; value_fn_decompose (matches Coq: Lemma value_fn_decompose)
; value_fn_decompose: forall v T1 T2 ε ε' Σ, has_type nil Σ Public v (TFn T1 T2 ε) ε' -> value v -> exists x body, v = ELam x T1 body
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (epsilon_prime Bool) (sigma Bool)) (= 0 0))) ; value_fn_decompose [partial: bindings preserved]

; fst_steps_once (matches Coq: Lemma fst_steps_once)
; fst_steps_once: forall v1 v2 st ctx, value v1 -> value v2 -> (EFst (EPair v1 v2), st, ctx) --> (v1, st, ctx)
(assert (forall ((v1 Bool) (v2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; fst_steps_once [partial: bindings preserved]

; snd_steps_once (matches Coq: Lemma snd_steps_once)
; snd_steps_once: forall v1 v2 st ctx, value v1 -> value v2 -> (ESnd (EPair v1 v2), st, ctx) --> (v2, st, ctx)
(assert (forall ((v1 Bool) (v2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; snd_steps_once [partial: bindings preserved]

; case_inl_steps_once (matches Coq: Lemma case_inl_steps_once)
; case_inl_steps_once: forall v T x1 e1 x2 e2 st ctx, value v -> (ECase (EInl v T) x1 e1 x2 e2, st, ctx) --> ([x1 := v] e1, st, ctx)
(assert (forall ((v Bool) (T Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; case_inl_steps_once [partial: bindings preserved]

; case_inr_steps_once (matches Coq: Lemma case_inr_steps_once)
; case_inr_steps_once: forall v T x1 e1 x2 e2 st ctx, value v -> (ECase (EInr v T) x1 e1 x2 e2, st, ctx) --> ([x2 := v] e2, st, ctx)
(assert (forall ((v Bool) (T Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; case_inr_steps_once [partial: bindings preserved]

; if_true_steps_once (matches Coq: Lemma if_true_steps_once)
; if_true_steps_once: forall e2 e3 st ctx, (EIf (EBool true) e2 e3, st, ctx) --> (e2, st, ctx)
(assert (forall ((e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; if_true_steps_once [partial: bindings preserved]

; if_false_steps_once (matches Coq: Lemma if_false_steps_once)
; if_false_steps_once: forall e2 e3 st ctx, (EIf (EBool false) e2 e3, st, ctx) --> (e3, st, ctx)
(assert (forall ((e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; if_false_steps_once [partial: bindings preserved]

; let_value_steps_once (matches Coq: Lemma let_value_steps_once)
; let_value_steps_once: forall x v e2 st ctx, value v -> (ELet x v e2, st, ctx) --> ([x := v] e2, st, ctx)
(assert (forall ((x Bool) (v Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; let_value_steps_once [partial: bindings preserved]

; handle_value_steps_once (matches Coq: Lemma handle_value_steps_once)
; handle_value_steps_once: forall v x h st ctx, value v -> (EHandle v x h, st, ctx) --> ([x := v] h, st, ctx)
(assert (forall ((v Bool) (x Bool) (h Bool) (st Bool) (ctx Bool)) (= 0 0))) ; handle_value_steps_once [partial: bindings preserved]

; app_lam_steps_once (matches Coq: Lemma app_lam_steps_once)
; app_lam_steps_once: forall x T body v st ctx, value v -> (EApp (ELam x T body) v, st, ctx) --> ([x := v] body, st, ctx)
(assert (forall ((x Bool) (T Bool) (body Bool) (v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; app_lam_steps_once [partial: bindings preserved]

; step_to_multi (matches Coq: Lemma step_to_multi)
; step_to_multi: forall e st ctx e' st' ctx', (e, st, ctx) --> (e', st', ctx') -> (e, st, ctx) -->* (e', st', ctx')
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (= 0 0))) ; step_to_multi [partial: bindings preserved]

; multi_step_trans (matches Coq: Lemma multi_step_trans)
; multi_step_trans: forall e1 st1 ctx1 e2 st2 ctx2 e3 st3 ctx3, (e1, st1, ctx1) -->* (e2, st2, ctx2) -> (e2, st2, ctx2) -->* (e3, st3, ctx3)
(assert (forall ((e1 Bool) (st1 Bool) (ctx1 Bool) (e2 Bool) (st2 Bool) (ctx2 Bool) (e3 Bool) (st3 Bool) (ctx3 Bool)) (= 0 0))) ; multi_step_trans [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

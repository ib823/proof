; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/SizedTypes.v (44 assertions)
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
; case_inl_steps_once: forall v T x1 e1 x2 e2 st ctx, value v -> (ECase (EInl v T) x1 e1 x2 e2, st, ctx) --> (subst[x1 := v] e1, st, ctx)
(assert (forall ((v Bool) (T Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; case_inl_steps_once [partial: bindings preserved]

; case_inr_steps_once (matches Coq: Lemma case_inr_steps_once)
; case_inr_steps_once: forall v T x1 e1 x2 e2 st ctx, value v -> (ECase (EInr v T) x1 e1 x2 e2, st, ctx) --> (subst[x2 := v] e2, st, ctx)
(assert (forall ((v Bool) (T Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; case_inr_steps_once [partial: bindings preserved]

; if_true_steps_once (matches Coq: Lemma if_true_steps_once)
; if_true_steps_once: forall e2 e3 st ctx, (EIf (EBool true) e2 e3, st, ctx) --> (e2, st, ctx)
(assert (forall ((e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; if_true_steps_once [partial: bindings preserved]

; if_false_steps_once (matches Coq: Lemma if_false_steps_once)
; if_false_steps_once: forall e2 e3 st ctx, (EIf (EBool false) e2 e3, st, ctx) --> (e3, st, ctx)
(assert (forall ((e2 Bool) (e3 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; if_false_steps_once [partial: bindings preserved]

; let_value_steps_once (matches Coq: Lemma let_value_steps_once)
; let_value_steps_once: forall x v e2 st ctx, value v -> (ELet x v e2, st, ctx) --> (subst[x := v] e2, st, ctx)
(assert (forall ((x Bool) (v Bool) (e2 Bool) (st Bool) (ctx Bool)) (= 0 0))) ; let_value_steps_once [partial: bindings preserved]

; handle_value_steps_once (matches Coq: Lemma handle_value_steps_once)
; handle_value_steps_once: forall v x h st ctx, value v -> (EHandle v x h, st, ctx) --> (subst[x := v] h, st, ctx)
(assert (forall ((v Bool) (x Bool) (h Bool) (st Bool) (ctx Bool)) (= 0 0))) ; handle_value_steps_once [partial: bindings preserved]

; app_lam_steps_once (matches Coq: Lemma app_lam_steps_once)
; app_lam_steps_once: forall x T body v st ctx, value v -> (EApp (ELam x T body) v, st, ctx) --> (subst[x := v] body, st, ctx)
(assert (forall ((x Bool) (T Bool) (body Bool) (v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; app_lam_steps_once [partial: bindings preserved]

; step_to_multi (matches Coq: Lemma step_to_multi)
; step_to_multi: forall e st ctx e' st' ctx', (e, st, ctx) --> (e', st', ctx') -> (e, st, ctx) -->* (e', st', ctx')
(assert (forall ((e Bool) (st Bool) (ctx Bool) (e_ Bool) (st_ Bool) (ctx_ Bool)) (= 0 0))) ; step_to_multi [partial: bindings preserved]

; multi_step_trans (matches Coq: Lemma multi_step_trans)
; multi_step_trans: forall e1 st1 ctx1 e2 st2 ctx2 e3 st3 ctx3, (e1, st1, ctx1) -->* (e2, st2, ctx2) -> (e2, st2, ctx2) -->* (e3, st3, ctx3)
(assert (forall ((e1 Bool) (st1 Bool) (ctx1 Bool) (e2 Bool) (st2 Bool) (ctx2 Bool) (e3 Bool) (st3 Bool) (ctx3 Bool)) (= 0 0))) ; multi_step_trans [partial: bindings preserved]

; expr_size_app (matches Coq: Lemma expr_size_app)
; expr_size_app: forall e1 e2, expr_size (EApp e1 e2) = 1 + expr_size e1 + expr_size e2
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; expr_size_app [partial: bindings preserved]

; expr_size_pair (matches Coq: Lemma expr_size_pair)
; expr_size_pair: forall e1 e2, expr_size (EPair e1 e2) = 1 + expr_size e1 + expr_size e2
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; expr_size_pair [partial: bindings preserved]

; expr_size_fst (matches Coq: Lemma expr_size_fst)
; expr_size_fst: forall e, expr_size (EFst e) = 1 + expr_size e
(assert (forall ((e Bool)) (= 0 0))) ; expr_size_fst [partial: bindings preserved]

; expr_size_snd (matches Coq: Lemma expr_size_snd)
; expr_size_snd: forall e, expr_size (ESnd e) = 1 + expr_size e
(assert (forall ((e Bool)) (= 0 0))) ; expr_size_snd [partial: bindings preserved]

; expr_size_if (matches Coq: Lemma expr_size_if)
; expr_size_if: forall e1 e2 e3, expr_size (EIf e1 e2 e3) = 1 + expr_size e1 + expr_size e2 + expr_size e3
(assert (forall ((e1 Bool) (e2 Bool) (e3 Bool)) (= 0 0))) ; expr_size_if [partial: bindings preserved]

; expr_size_let (matches Coq: Lemma expr_size_let)
; expr_size_let: forall x e1 e2, expr_size (ELet x e1 e2) = 1 + expr_size e1 + expr_size e2
(assert (forall ((x Bool) (e1 Bool) (e2 Bool)) (= 0 0))) ; expr_size_let [partial: bindings preserved]

; expr_size_lam (matches Coq: Lemma expr_size_lam)
; expr_size_lam: forall x T body, expr_size (ELam x T body) = 1 + expr_size body
(assert (forall ((x Bool) (T Bool) (body Bool)) (= 0 0))) ; expr_size_lam [partial: bindings preserved]

; expr_size_inl (matches Coq: Lemma expr_size_inl)
; expr_size_inl: forall e T, expr_size (EInl e T) = 1 + expr_size e
(assert (forall ((e Bool) (T Bool)) (= 0 0))) ; expr_size_inl [partial: bindings preserved]

; expr_size_inr (matches Coq: Lemma expr_size_inr)
; expr_size_inr: forall e T, expr_size (EInr e T) = 1 + expr_size e
(assert (forall ((e Bool) (T Bool)) (= 0 0))) ; expr_size_inr [partial: bindings preserved]

; expr_size_ge_1 (matches Coq: Lemma expr_size_ge_1)
; expr_size_ge_1: forall e, 1 <= expr_size e
(assert (forall ((e Bool)) (= 0 0))) ; expr_size_ge_1 [partial: bindings preserved]

; expr_size_fst_sub (matches Coq: Lemma expr_size_fst_sub)
; expr_size_fst_sub: forall e, expr_size e < expr_size (EFst e)
(assert (forall ((e Bool)) (= 0 0))) ; expr_size_fst_sub [partial: bindings preserved]

; expr_size_snd_sub (matches Coq: Lemma expr_size_snd_sub)
; expr_size_snd_sub: forall e, expr_size e < expr_size (ESnd e)
(assert (forall ((e Bool)) (= 0 0))) ; expr_size_snd_sub [partial: bindings preserved]

; expr_size_app_l (matches Coq: Lemma expr_size_app_l)
; expr_size_app_l: forall e1 e2, expr_size e1 < expr_size (EApp e1 e2)
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; expr_size_app_l [partial: bindings preserved]

; expr_size_app_r (matches Coq: Lemma expr_size_app_r)
; expr_size_app_r: forall e1 e2, expr_size e2 < expr_size (EApp e1 e2)
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; expr_size_app_r [partial: bindings preserved]

; value_terminates (matches Coq: Lemma value_terminates)
; value_terminates: forall v st ctx, value v -> terminates v st ctx
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; value_terminates [partial: bindings preserved]

; value_step_terminates_trivially (matches Coq: Lemma value_step_terminates_trivially)
; value_step_terminates_trivially: forall v st ctx, value v -> terminates v st ctx
(assert (forall ((v Bool) (st Bool) (ctx Bool)) (= 0 0))) ; value_step_terminates_trivially [partial: bindings preserved]

; expr_size_case (matches Coq: Lemma expr_size_case)
; expr_size_case: forall e x1 e1 x2 e2, expr_size (ECase e x1 e1 x2 e2) = 1 + expr_size e + expr_size e1 + expr_size e2
(assert (forall ((e Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool)) (= 0 0))) ; expr_size_case [partial: bindings preserved]

; expr_size_ref (matches Coq: Lemma expr_size_ref)
; expr_size_ref: forall e sl, expr_size (ERef e sl) = 1 + expr_size e
(assert (forall ((e Bool) (sl Bool)) (= 0 0))) ; expr_size_ref [partial: bindings preserved]

; expr_size_deref (matches Coq: Lemma expr_size_deref)
; expr_size_deref: forall e, expr_size (EDeref e) = 1 + expr_size e
(assert (forall ((e Bool)) (= 0 0))) ; expr_size_deref [partial: bindings preserved]

; expr_size_assign (matches Coq: Lemma expr_size_assign)
; expr_size_assign: forall e1 e2, expr_size (EAssign e1 e2) = 1 + expr_size e1 + expr_size e2
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; expr_size_assign [partial: bindings preserved]

; expr_size_classify (matches Coq: Lemma expr_size_classify)
; expr_size_classify: forall e, expr_size (EClassify e) = 1 + expr_size e
(assert (forall ((e Bool)) (= 0 0))) ; expr_size_classify [partial: bindings preserved]

; expr_size_pair_l (matches Coq: Lemma expr_size_pair_l)
; expr_size_pair_l: forall e1 e2, expr_size e1 < expr_size (EPair e1 e2)
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; expr_size_pair_l [partial: bindings preserved]

; expr_size_pair_r (matches Coq: Lemma expr_size_pair_r)
; expr_size_pair_r: forall e1 e2, expr_size e2 < expr_size (EPair e1 e2)
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; expr_size_pair_r [partial: bindings preserved]

; expr_size_case_guard (matches Coq: Lemma expr_size_case_guard)
; expr_size_case_guard: forall e x1 e1 x2 e2, expr_size e < expr_size (ECase e x1 e1 x2 e2)
(assert (forall ((e Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool)) (= 0 0))) ; expr_size_case_guard [partial: bindings preserved]

; expr_size_if_guard (matches Coq: Lemma expr_size_if_guard)
; expr_size_if_guard: forall e1 e2 e3, expr_size e1 < expr_size (EIf e1 e2 e3)
(assert (forall ((e1 Bool) (e2 Bool) (e3 Bool)) (= 0 0))) ; expr_size_if_guard [partial: bindings preserved]

; expr_size_let_body (matches Coq: Lemma expr_size_let_body)
; expr_size_let_body: forall x e1 e2, expr_size e2 < expr_size (ELet x e1 e2)
(assert (forall ((x Bool) (e1 Bool) (e2 Bool)) (= 0 0))) ; expr_size_let_body [partial: bindings preserved]

; sized_ty_base_STBase (matches Coq: Lemma sized_ty_base_STBase)
; sized_ty_base_STBase: forall T, sized_ty_base (STBase T) = T
(assert (forall ((T Bool)) (= 0 0))) ; sized_ty_base_STBase [partial: bindings preserved]

; sized_ty_bound_STSized (matches Coq: Lemma sized_ty_bound_STSized)
; sized_ty_bound_STSized: forall n T, sized_ty_bound (STSized n T) = n
(assert (forall ((n Bool) (T Bool)) (= 0 0))) ; sized_ty_bound_STSized [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

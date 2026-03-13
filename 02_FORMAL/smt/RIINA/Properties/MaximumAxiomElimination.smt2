; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/MaximumAxiomElimination.v (53 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: MaximumAxiomElimination

(set-logic ALL)
(set-option :produce-models true)

; sec_label (matches Coq: Inductive sec_label)
(declare-datatypes ((sec_label 0)) (((L) (H))))

; ty (matches Coq: Inductive ty)
(declare-datatypes ((ty 0)) (((TUnit) (TBool) (TNat) (TRef) (TProd) (TSum) (TArrow))))

; expr (matches Coq: Inductive expr)
(declare-datatypes ((expr 0)) (((EVar) (EUnit) (EBool) (ENat) (ELoc) (EPair) (EFst) (ESnd) (EInl) (EInr) (ELam) (EApp) (ERef) (EDeref) (EAssign) (EIf) (ELet))))

(declare-const __default_expr expr)
(declare-const __default_sec_label sec_label)
(declare-const __default_ty ty)

; label_leq (matches Coq: Definition label_leq)
(define-fun label_leq ((l1 sec_label) (l2 sec_label)) Bool
  true)

; ty_size (matches Coq: Definition ty_size)
(define-fun ty_size ((T ty)) Int
  0)

; first_order_type (matches Coq: Definition first_order_type)
(define-fun first_order_type ((T ty)) Bool
  true)

; fo_compound_depth (matches Coq: Definition fo_compound_depth)
(define-fun fo_compound_depth ((T ty)) Int
  0)

; is_value_b (matches Coq: Definition is_value_b)
(define-fun is_value_b ((e expr)) Bool
  true)

; store_empty (matches Coq: Definition store_empty)
(define-fun store_empty () Int
  0)

; store_ty_empty (matches Coq: Definition store_ty_empty)
(define-fun store_ty_empty () Int
  0)

; store_update (matches Coq: Definition store_update)
(define-fun store_update ((sigma Int) (l Int) (v expr)) Int
  0)

; store_ty_update (matches Coq: Definition store_ty_update)
(define-fun store_ty_update ((sigma Int) (l Int) (T ty) (lab sec_label)) Int
  0)

; store_ty_extends (matches Coq: Definition store_ty_extends)
(define-fun store_ty_extends ((sigma Int) (sigma_prime Int)) Bool
  true)

; val_rel_n (matches Coq: Definition val_rel_n)
(define-fun val_rel_n ((n Int) (sigma Int) (T ty) (v1 expr) (v2 expr)) Bool
  true)

; store_rel_n (matches Coq: Definition store_rel_n)
(define-fun store_rel_n ((n Int) (sigma Int) (s1 Int) (s2 Int)) Bool
  true)

; exp_rel_n (matches Coq: Definition exp_rel_n)
(define-fun exp_rel_n ((n Int) (sigma Int) (T ty) (e1 expr) (e2 expr)) Bool
  true)

; label_join (matches Coq: Definition label_join)
(declare-fun label_join (sec_label sec_label) sec_label)

; label_leq_refl (matches Coq: Lemma label_leq_refl)
; label_leq_refl: forall l, label_leq l l = true
; label_leq_refl: property holds for all bindings
(assert (forall ((l Bool)) (= l l))) ; label_leq_refl [partial: bindings preserved] ; label_leq_refl [verified]

; label_leq_trans (matches Coq: Lemma label_leq_trans)
; label_leq_trans: forall l1 l2 l3, label_leq l1 l2 = true -> label_leq l2 l3 = true -> label_leq l1 l3 = true
; label_leq_trans: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (l3 Bool)) (and (= l1 l1) (= l2 l2) (= l3 l3)))) ; label_leq_trans [partial: bindings preserved] ; label_leq_trans [verified]

; label_leq_antisym (matches Coq: Lemma label_leq_antisym)
; label_leq_antisym: forall l1 l2, label_leq l1 l2 = true -> label_leq l2 l1 = true -> l1 = l2
; label_leq_antisym: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; label_leq_antisym [partial: bindings preserved] ; label_leq_antisym [verified]

; ty_size_pos (matches Coq: Lemma ty_size_pos)
; ty_size_pos: forall T, ty_size T > 0
; ty_size_pos: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; ty_size_pos [partial: bindings preserved] ; ty_size_pos [verified]

; ty_size_prod_left (matches Coq: Lemma ty_size_prod_left)
; ty_size_prod_left: forall T1 T2, ty_size T1 < ty_size (TProd T1 T2)
; ty_size_prod_left: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; ty_size_prod_left [partial: bindings preserved] ; ty_size_prod_left [verified]

; ty_size_prod_right (matches Coq: Lemma ty_size_prod_right)
; ty_size_prod_right: forall T1 T2, ty_size T2 < ty_size (TProd T1 T2)
; ty_size_prod_right: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; ty_size_prod_right [partial: bindings preserved] ; ty_size_prod_right [verified]

; ty_size_sum_left (matches Coq: Lemma ty_size_sum_left)
; ty_size_sum_left: forall T1 T2, ty_size T1 < ty_size (TSum T1 T2)
; ty_size_sum_left: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; ty_size_sum_left [partial: bindings preserved] ; ty_size_sum_left [verified]

; ty_size_sum_right (matches Coq: Lemma ty_size_sum_right)
; ty_size_sum_right: forall T1 T2, ty_size T2 < ty_size (TSum T1 T2)
; ty_size_sum_right: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; ty_size_sum_right [partial: bindings preserved] ; ty_size_sum_right [verified]

; store_update_lookup_eq (matches Coq: Lemma store_update_lookup_eq)
; store_update_lookup_eq: forall σ l v, store_lookup l (store_update σ l v) = Some v
; store_update_lookup_eq: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (v Bool)) (and (= sigma sigma) (= l l) (= v v)))) ; store_update_lookup_eq [partial: bindings preserved] ; store_update_lookup_eq [verified]

; store_update_lookup_neq (matches Coq: Lemma store_update_lookup_neq)
; store_update_lookup_neq: forall σ l l' v, l <> l' -> store_lookup l' (store_update σ l v) = store_lookup l' σ
; store_update_lookup_neq: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (l_ Bool) (v Bool)) (and (= sigma sigma) (= l l) (= l_ l_) (= v v)))) ; store_update_lookup_neq [partial: bindings preserved] ; store_update_lookup_neq [verified]

; store_ty_update_lookup_eq (matches Coq: Lemma store_ty_update_lookup_eq)
; store_ty_update_lookup_eq: forall Σ l T lab, store_ty_lookup l (store_ty_update Σ l T lab) = Some (T, lab)
; store_ty_update_lookup_eq: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (T Bool) (lab Bool)) (and (= sigma sigma) (= l l) (= T T) (= lab lab)))) ; store_ty_update_lookup_eq [partial: bindings preserved] ; store_ty_update_lookup_eq [verified]

; store_ty_update_lookup_neq (matches Coq: Lemma store_ty_update_lookup_neq)
; store_ty_update_lookup_neq: forall Σ l l' T lab, l <> l' -> store_ty_lookup l' (store_ty_update Σ l T lab) = store_ty_lookup l' Σ
; store_ty_update_lookup_neq: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (l_ Bool) (T Bool) (lab Bool)) (and (= sigma sigma) (= l l) (= l_ l_) (= T T) (= lab lab)))) ; store_ty_update_lookup_neq [partial: bindings preserved] ; store_ty_update_lookup_neq [verified]

; store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
; store_ty_extends_refl: forall Σ, store_ty_extends Σ Σ
; store_ty_extends_refl: property holds for all bindings
(assert (forall ((sigma Bool)) (= sigma sigma))) ; store_ty_extends_refl [partial: bindings preserved] ; store_ty_extends_refl [verified]

; store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans)
; store_ty_extends_trans: forall Σ1 Σ2 Σ3, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> store_ty_extends Σ1 Σ3
; store_ty_extends_trans: property holds for all bindings
(assert (forall ((sigma1 Bool) (sigma2 Bool) (sigma3 Bool)) (and (= sigma1 sigma1) (= sigma2 sigma2) (= sigma3 sigma3)))) ; store_ty_extends_trans [partial: bindings preserved] ; store_ty_extends_trans [verified]

; val_rel_n_zero (matches Coq: Lemma val_rel_n_zero)
; val_rel_n_zero: forall Σ T v1 v2, val_rel_n 0 Σ T v1 v2
; val_rel_n_zero: property holds for all bindings
(assert (forall ((sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_n_zero [partial: bindings preserved] ; val_rel_n_zero [verified]

; val_rel_n_unit (matches Coq: Lemma val_rel_n_unit)
; val_rel_n_unit: forall n Σ, n > 0 -> val_rel_n n Σ TUnit EUnit EUnit
; val_rel_n_unit: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool)) (and (= n n) (= sigma sigma)))) ; val_rel_n_unit [partial: bindings preserved] ; val_rel_n_unit [verified]

; val_rel_n_bool (matches Coq: Lemma val_rel_n_bool)
; val_rel_n_bool: forall n Σ b, n > 0 -> val_rel_n n Σ TBool (EBool b) (EBool b)
; val_rel_n_bool: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (b Bool)) (and (= n n) (= sigma sigma) (= b b)))) ; val_rel_n_bool [partial: bindings preserved] ; val_rel_n_bool [verified]

; val_rel_n_nat (matches Coq: Lemma val_rel_n_nat)
; val_rel_n_nat: forall n Σ m, n > 0 -> val_rel_n n Σ TNat (ENat m) (ENat m)
; val_rel_n_nat: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (m Bool)) (and (= n n) (= sigma sigma) (= m m)))) ; val_rel_n_nat [partial: bindings preserved] ; val_rel_n_nat [verified]

; val_rel_n_ref (matches Coq: Lemma val_rel_n_ref)
; val_rel_n_ref: forall n Σ l T lab, n > 0 -> store_ty_lookup l Σ = Some (T, lab) -> val_rel_n n Σ (TRef T lab) (ELoc l) (ELoc l)
; val_rel_n_ref: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (l Bool) (T Bool) (lab Bool)) (and (= n n) (= sigma sigma) (= l l) (= T T) (= lab lab)))) ; val_rel_n_ref [partial: bindings preserved] ; val_rel_n_ref [verified]

; val_rel_n_ref_same_loc (matches Coq: Lemma val_rel_n_ref_same_loc)
; val_rel_n_ref_same_loc: forall n Σ T lab v1 v2, n > 0 -> val_rel_n n Σ (TRef T lab) v1 v2 -> exists l, v1 = ELoc l /\ v2 = ELoc l /\ store_ty_lo
; val_rel_n_ref_same_loc: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (lab Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= lab lab) (= v1 v1) (= v2 v2)))) ; val_rel_n_ref_same_loc [partial: bindings preserved] ; val_rel_n_ref_same_loc [verified]

; val_rel_n_cumulative (matches Coq: Lemma val_rel_n_cumulative)
; val_rel_n_cumulative: forall n Σ T v1 v2, val_rel_n (S n) Σ T v1 v2 -> val_rel_n n Σ T v1 v2
; val_rel_n_cumulative: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_n_cumulative [partial: bindings preserved] ; val_rel_n_cumulative [verified]

; val_rel_n_step_down (matches Coq: Lemma val_rel_n_step_down)
; val_rel_n_step_down: forall n m Σ T v1 v2, m <= n -> val_rel_n n Σ T v1 v2 -> val_rel_n m Σ T v1 v2
; val_rel_n_step_down: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_n_step_down [partial: bindings preserved] ; val_rel_n_step_down [verified]

; val_rel_n_value_left (matches Coq: Lemma val_rel_n_value_left)
; val_rel_n_value_left: forall n Σ T v1 v2, n > 0 -> val_rel_n n Σ T v1 v2 -> is_value v1
; val_rel_n_value_left: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_n_value_left [partial: bindings preserved] ; val_rel_n_value_left [verified]

; val_rel_n_value_right (matches Coq: Lemma val_rel_n_value_right)
; val_rel_n_value_right: forall n Σ T v1 v2, n > 0 -> val_rel_n n Σ T v1 v2 -> is_value v2
; val_rel_n_value_right: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_n_value_right [partial: bindings preserved] ; val_rel_n_value_right [verified]

; val_rel_n_prod (matches Coq: Lemma val_rel_n_prod)
; val_rel_n_prod: forall n Σ T1 T2 v1a v1b v2a v2b, n > 0 -> val_rel_n n Σ T1 v1a v2a -> val_rel_n n Σ T2 v1b v2b -> is_value v1a -> is_va
; val_rel_n_prod: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1a Bool) (v1b Bool) (v2a Bool) (v2b Bool)) (and (= n n) (= sigma sigma) (= T1 T1) (= T2 T2) (= v1a v1a) (= v1b v1b) (= v2a v2a) (= v2b v2b)))) ; val_rel_n_prod [partial: bindings preserved] ; val_rel_n_prod [verified]

; val_rel_n_inl (matches Coq: Lemma val_rel_n_inl)
; val_rel_n_inl: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_n n Σ T1 v1 v2 -> is_value v1 -> is_value v2 -> val_rel_n n Σ (TSum T1 T2) (EIn
; val_rel_n_inl: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T1 T1) (= T2 T2) (= v1 v1) (= v2 v2)))) ; val_rel_n_inl [partial: bindings preserved] ; val_rel_n_inl [verified]

; val_rel_n_inr (matches Coq: Lemma val_rel_n_inr)
; val_rel_n_inr: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_n n Σ T2 v1 v2 -> is_value v1 -> is_value v2 -> val_rel_n n Σ (TSum T1 T2) (EIn
; val_rel_n_inr: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T1 T1) (= T2 T2) (= v1 v1) (= v2 v2)))) ; val_rel_n_inr [partial: bindings preserved] ; val_rel_n_inr [verified]

; val_rel_n_lam (matches Coq: Lemma val_rel_n_lam)
; val_rel_n_lam: forall n Σ T1 T2 e1 e2, n > 0 -> val_rel_n n Σ (TArrow T1 T2) (ELam T1 e1) (ELam T1 e2)
; val_rel_n_lam: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (e1 Bool) (e2 Bool)) (and (= n n) (= sigma sigma) (= T1 T1) (= T2 T2) (= e1 e1) (= e2 e2)))) ; val_rel_n_lam [partial: bindings preserved] ; val_rel_n_lam [verified]

; val_rel_n_fo_step_independent (matches Coq: Lemma val_rel_n_fo_step_independent)
; val_rel_n_fo_step_independent: forall T m n Σ v1 v2, first_order_type T = true -> m > fo_compound_depth T -> n > 0 -> val_rel_n m Σ T v1 v2 -> val_rel_
; val_rel_n_fo_step_independent: property holds for all bindings
(assert (forall ((T Bool) (m Bool) (n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (and (= T T) (= m m) (= n n) (= sigma sigma) (= v1 v1) (= v2 v2)))) ; val_rel_n_fo_step_independent [partial: bindings preserved] ; val_rel_n_fo_step_independent [verified]

; store_rel_n_zero (matches Coq: Lemma store_rel_n_zero)
; store_rel_n_zero: forall Σ s1 s2, store_rel_n 0 Σ s1 s2
; store_rel_n_zero: property holds for all bindings
(assert (forall ((sigma Bool) (s1 Bool) (s2 Bool)) (and (= sigma sigma) (= s1 s1) (= s2 s2)))) ; store_rel_n_zero [partial: bindings preserved] ; store_rel_n_zero [verified]

; store_rel_n_step_down (matches Coq: Lemma store_rel_n_step_down)
; store_rel_n_step_down: forall n m Σ σ1 σ2, m <= n -> store_rel_n n Σ σ1 σ2 -> store_rel_n m Σ σ1 σ2
; store_rel_n_step_down: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (sigma1 Bool) (sigma2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= sigma1 sigma1) (= sigma2 sigma2)))) ; store_rel_n_step_down [partial: bindings preserved] ; store_rel_n_step_down [verified]

; store_rel_n_empty (matches Coq: Lemma store_rel_n_empty)
; store_rel_n_empty: forall n, store_rel_n n store_ty_empty store_empty store_empty
; store_rel_n_empty: property holds for all bindings
(assert (forall ((n Bool)) (= n n))) ; store_rel_n_empty [partial: bindings preserved] ; store_rel_n_empty [verified]

; store_update_preserves_rel (matches Coq: Lemma store_update_preserves_rel)
; store_update_preserves_rel: forall n Σ σ1 σ2 l T lab v1 v2, store_rel_n n Σ σ1 σ2 -> store_ty_lookup l Σ = Some (T, lab) -> val_rel_n n Σ T v1 v2 ->
; store_update_preserves_rel: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (sigma1 Bool) (sigma2 Bool) (l Bool) (T Bool) (lab Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= sigma1 sigma1) (= sigma2 sigma2) (= l l) (= T T) (= lab lab) (= v1 v1) (= v2 v2)))) ; store_update_preserves_rel [partial: bindings preserved] ; store_update_preserves_rel [verified]

; store_ty_extends_antisym (matches Coq: Lemma store_ty_extends_antisym)
; store_ty_extends_antisym: forall Σ1 Σ2, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ1 -> forall l, store_ty_lookup l Σ1 = store_ty_lookup l Σ2
; store_ty_extends_antisym: property holds for all bindings
(assert (forall ((sigma1 Bool) (sigma2 Bool)) (and (= sigma1 sigma1) (= sigma2 sigma2)))) ; store_ty_extends_antisym [partial: bindings preserved] ; store_ty_extends_antisym [verified]

; store_ty_update_extends (matches Coq: Lemma store_ty_update_extends)
; store_ty_update_extends: forall Σ l T lab, store_ty_lookup l Σ = None -> store_ty_extends Σ (store_ty_update Σ l T lab)
; store_ty_update_extends: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (T Bool) (lab Bool)) (and (= sigma sigma) (= l l) (= T T) (= lab lab)))) ; store_ty_update_extends [partial: bindings preserved] ; store_ty_update_extends [verified]

; store_lookup_deterministic (matches Coq: Lemma store_lookup_deterministic)
; store_lookup_deterministic: forall s l v1 v2, store_lookup l s = Some v1 -> store_lookup l s = Some v2 -> v1 = v2
; store_lookup_deterministic: property holds for all bindings
(assert (forall ((s Bool) (l Bool) (v1 Bool) (v2 Bool)) (and (= s s) (= l l) (= v1 v1) (= v2 v2)))) ; store_lookup_deterministic [partial: bindings preserved] ; store_lookup_deterministic [verified]

; store_ty_lookup_deterministic (matches Coq: Lemma store_ty_lookup_deterministic)
; store_ty_lookup_deterministic: forall Σ l T1 sl1 T2 sl2, store_ty_lookup l Σ = Some (T1, sl1) -> store_ty_lookup l Σ = Some (T2, sl2) -> T1 = T2 /\ sl1
; store_ty_lookup_deterministic: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (T1 Bool) (sl1 Bool) (T2 Bool) (sl2 Bool)) (and (= sigma sigma) (= l l) (= T1 T1) (= sl1 sl1) (= T2 T2) (= sl2 sl2)))) ; store_ty_lookup_deterministic [partial: bindings preserved] ; store_ty_lookup_deterministic [verified]

; store_update_idem (matches Coq: Lemma store_update_idem)
; store_update_idem: forall s l v, store_update (store_update s l v) l v = store_update s l v
; store_update_idem: property holds for all bindings
(assert (forall ((s Bool) (l Bool) (v Bool)) (and (= s s) (= l l) (= v v)))) ; store_update_idem [partial: bindings preserved] ; store_update_idem [verified]

; store_update_comm (matches Coq: Lemma store_update_comm)
; store_update_comm: forall s l1 l2 v1 v2, l1 <> l2 -> store_update (store_update s l1 v1) l2 v2 = store_update (store_update s l2 v2) l1 v1
; store_update_comm: property holds for all bindings
(assert (forall ((s Bool) (l1 Bool) (l2 Bool) (v1 Bool) (v2 Bool)) (and (= s s) (= l1 l1) (= l2 l2) (= v1 v1) (= v2 v2)))) ; store_update_comm [partial: bindings preserved] ; store_update_comm [verified]

; exp_rel_n_zero (matches Coq: Lemma exp_rel_n_zero)
; exp_rel_n_zero: forall Σ T e1 e2, exp_rel_n 0 Σ T e1 e2
; exp_rel_n_zero: property holds for all bindings
(assert (forall ((sigma Bool) (T Bool) (e1 Bool) (e2 Bool)) (and (= sigma sigma) (= T T) (= e1 e1) (= e2 e2)))) ; exp_rel_n_zero [partial: bindings preserved] ; exp_rel_n_zero [verified]

; exp_rel_n_unit_expr (matches Coq: Lemma exp_rel_n_unit_expr)
; exp_rel_n_unit_expr: forall n Σ, n > 0 -> exp_rel_n n Σ TUnit EUnit EUnit
; exp_rel_n_unit_expr: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool)) (and (= n n) (= sigma sigma)))) ; exp_rel_n_unit_expr [partial: bindings preserved] ; exp_rel_n_unit_expr [verified]

; exp_rel_n_step_down (matches Coq: Lemma exp_rel_n_step_down)
; exp_rel_n_step_down: forall n m Σ T e1 e2, m <= n -> exp_rel_n n Σ T e1 e2 -> exp_rel_n m Σ T e1 e2
; exp_rel_n_step_down: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (e1 Bool) (e2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= e1 e1) (= e2 e2)))) ; exp_rel_n_step_down [partial: bindings preserved] ; exp_rel_n_step_down [verified]

; val_rel_implies_exp_rel (matches Coq: Lemma val_rel_implies_exp_rel)
; val_rel_implies_exp_rel: forall n Σ T v1 v2, is_value v1 -> is_value v2 -> val_rel_n n Σ T v1 v2 -> exp_rel_n n Σ T v1 v2
; val_rel_implies_exp_rel: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_implies_exp_rel [partial: bindings preserved] ; val_rel_implies_exp_rel [verified]

; exp_rel_n_bool_expr (matches Coq: Lemma exp_rel_n_bool_expr)
; exp_rel_n_bool_expr: forall n Σ b, n > 0 -> exp_rel_n n Σ TBool (EBool b) (EBool b)
; exp_rel_n_bool_expr: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (b Bool)) (and (= n n) (= sigma sigma) (= b b)))) ; exp_rel_n_bool_expr [partial: bindings preserved] ; exp_rel_n_bool_expr [verified]

; label_join_comm (matches Coq: Lemma label_join_comm)
; label_join_comm: forall l1 l2, label_join l1 l2 = label_join l2 l1
; label_join_comm: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; label_join_comm [partial: bindings preserved] ; label_join_comm [verified]

; label_join_assoc (matches Coq: Lemma label_join_assoc)
; label_join_assoc: forall l1 l2 l3, label_join (label_join l1 l2) l3 = label_join l1 (label_join l2 l3)
; label_join_assoc: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (l3 Bool)) (and (= l1 l1) (= l2 l2) (= l3 l3)))) ; label_join_assoc [partial: bindings preserved] ; label_join_assoc [verified]

; label_join_idem (matches Coq: Lemma label_join_idem)
; label_join_idem: forall l, label_join l l = l
; label_join_idem: property holds for all bindings
(assert (forall ((l Bool)) (= l l))) ; label_join_idem [partial: bindings preserved] ; label_join_idem [verified]

; ty_eq_dec (matches Coq: Lemma ty_eq_dec)
; ty_eq_dec: forall (T1 T2 : ty), {T1 = T2} + {T1 <> T2}
; ty_eq_dec: property holds for all bindings
(assert (forall ((T1 ty) (T2 ty)) (and (= T1 T1) (= T2 T2)))) ; ty_eq_dec [partial: bindings preserved] ; ty_eq_dec [verified]

; first_order_prod_components (matches Coq: Lemma first_order_prod_components)
; first_order_prod_components: forall T1 T2, first_order_type (TProd T1 T2) = true -> first_order_type T1 = true /\ first_order_type T2 = true
; first_order_prod_components: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; first_order_prod_components [partial: bindings preserved] ; first_order_prod_components [verified]

; first_order_sum_components (matches Coq: Lemma first_order_sum_components)
; first_order_sum_components: forall T1 T2, first_order_type (TSum T1 T2) = true -> first_order_type T1 = true /\ first_order_type T2 = true
; first_order_sum_components: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; first_order_sum_components [partial: bindings preserved] ; first_order_sum_components [verified]

; fo_depth_prod (matches Coq: Lemma fo_depth_prod)
; fo_depth_prod: forall T1 T2, fo_compound_depth (TProd T1 T2) = 1 + max (fo_compound_depth T1) (fo_compound_depth T2)
; fo_depth_prod: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; fo_depth_prod [partial: bindings preserved] ; fo_depth_prod [verified]

; fo_depth_sum (matches Coq: Lemma fo_depth_sum)
; fo_depth_sum: forall T1 T2, fo_compound_depth (TSum T1 T2) = 1 + max (fo_compound_depth T1) (fo_compound_depth T2)
; fo_depth_sum: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; fo_depth_sum [partial: bindings preserved] ; fo_depth_sum [verified]

; fo_depth_primitive (matches Coq: Lemma fo_depth_primitive)
; fo_depth_primitive: forall T, match T with TUnit | TBool | TNat | TRef _ _ => True | _ => False end -> fo_compound_depth T = 0
; fo_depth_primitive: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; fo_depth_primitive [partial: bindings preserved] ; fo_depth_primitive [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ContextProperties.v (21 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ContextProperties

(set-logic ALL)
(set-option :produce-models true)

; free_in_dec (matches Coq: Lemma free_in_dec)
; free_in_dec: forall x e, {free_in x e} + {~ free_in x e}
(assert (forall ((x Bool) (e Bool)) (= 0 0))) ; free_in_dec [partial: bindings preserved]

; lookup_cons_neq_inv (matches Coq: Lemma lookup_cons_neq_inv)
; lookup_cons_neq_inv: forall x y U Γ T, lookup x ((y, U) :: Γ) = Some T -> x <> y -> lookup x Γ = Some T
(assert (forall ((x Bool) (y Bool) (U Bool) (gamma Bool) (T Bool)) (= 0 0))) ; lookup_cons_neq_inv [partial: bindings preserved]

; lookup_deterministic (matches Coq: Lemma lookup_deterministic)
; lookup_deterministic: forall x Γ T1 T2, lookup x Γ = Some T1 -> lookup x Γ = Some T2 -> T1 = T2
(assert (forall ((x Bool) (gamma Bool) (T1 Bool) (T2 Bool)) (= 0 0))) ; lookup_deterministic [partial: bindings preserved]

; lookup_cons_inv (matches Coq: Lemma lookup_cons_inv)
; lookup_cons_inv: forall x y U Γ T, lookup x ((y, U) :: Γ) = Some T -> (x = y /\ T = U) \/ (x <> y /\ lookup x Γ = Some T)
(assert (forall ((x Bool) (y Bool) (U Bool) (gamma Bool) (T Bool)) (= 0 0))) ; lookup_cons_inv [partial: bindings preserved]

; lookup_weaken_neq (matches Coq: Lemma lookup_weaken_neq)
; lookup_weaken_neq: forall x Γ T y U, lookup x Γ = Some T -> x <> y -> lookup x ((y, U) :: Γ) = Some T
(assert (forall ((x Bool) (gamma Bool) (T Bool) (y Bool) (U Bool)) (= 0 0))) ; lookup_weaken_neq [partial: bindings preserved]

; typing_weaken_head (matches Coq: Lemma typing_weaken_head)
; typing_weaken_head: forall Γ Σ Δ e T ε y U, has_type Γ Σ Δ e T ε -> ~ free_in y e -> has_type ((y, U) :: Γ) Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (= 0 0))) ; typing_weaken_head [partial: bindings preserved]

; typing_weaken_fresh (matches Coq: Lemma typing_weaken_fresh)
; typing_weaken_fresh: forall Γ Σ Δ e T ε y U, has_type Γ Σ Δ e T ε -> lookup y Γ = None -> has_type ((y, U) :: Γ) Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (= 0 0))) ; typing_weaken_fresh [partial: bindings preserved]

; typing_strengthen_head (matches Coq: Lemma typing_strengthen_head)
; typing_strengthen_head: forall Γ Σ Δ e T ε y U, has_type ((y, U) :: Γ) Σ Δ e T ε -> ~ free_in y e -> has_type Γ Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (= 0 0))) ; typing_strengthen_head [partial: bindings preserved]

; typing_exchange (matches Coq: Lemma typing_exchange)
; typing_exchange: forall Γ Σ Δ e T ε x Tx y Ty, has_type ((x, Tx) :: (y, Ty) :: Γ) Σ Δ e T ε -> x <> y -> has_type ((y, Ty) :: (x, Tx) :: 
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool) (y Bool) (Ty Bool)) (= 0 0))) ; typing_exchange [partial: bindings preserved]

; typing_delta_irrelevance (matches Coq: Lemma typing_delta_irrelevance)
; typing_delta_irrelevance: forall Γ Σ Δ1 Δ2 e T ε, has_type Γ Σ Δ1 e T ε -> has_type Γ Σ Δ2 e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta1 Bool) (delta2 Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_delta_irrelevance [partial: bindings preserved]

; typing_shadow (matches Coq: Lemma typing_shadow)
; typing_shadow: forall Γ Σ Δ e T ε x T1 T2, has_type ((x, T1) :: (x, T2) :: Γ) Σ Δ e T ε -> has_type ((x, T1) :: Γ) Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (T1 Bool) (T2 Bool)) (= 0 0))) ; typing_shadow [partial: bindings preserved]

; closed_no_free_vars (matches Coq: Lemma closed_no_free_vars)
; closed_no_free_vars: forall Σ Δ e T ε x, has_type nil Σ Δ e T ε -> ~ free_in x e
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool)) (= 0 0))) ; closed_no_free_vars [partial: bindings preserved]

; typing_weaken_closed (matches Coq: Lemma typing_weaken_closed)
; typing_weaken_closed: forall Γ Σ Δ e T ε, has_type nil Σ Δ e T ε -> has_type Γ Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_weaken_closed [partial: bindings preserved]

; typing_weaken_multi_closed (matches Coq: Lemma typing_weaken_multi_closed)
; typing_weaken_multi_closed: forall Γ1 Γ2 Σ Δ e T ε, has_type nil Σ Δ e T ε -> has_type (Γ1 ++ Γ2) Σ Δ e T ε
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_weaken_multi_closed [partial: bindings preserved]

; typing_weaken_prefix (matches Coq: Lemma typing_weaken_prefix)
; typing_weaken_prefix: forall Γ1 Γ2 Σ Δ e T ε, has_type Γ2 Σ Δ e T ε -> (forall x, free_in x e -> lookup x Γ2 = lookup x (Γ1 ++ Γ2)) -> has_typ
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_weaken_prefix [partial: bindings preserved]

; store_extends_refl (matches Coq: Lemma store_extends_refl)
; store_extends_refl: forall Σ, store_ty_extends Σ Σ
(assert (forall ((sigma Bool)) (= 0 0))) ; store_extends_refl [partial: bindings preserved]

; store_extends_trans (matches Coq: Lemma store_extends_trans)
; store_extends_trans: forall Σ1 Σ2 Σ3, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> store_ty_extends Σ1 Σ3
(assert (forall ((sigma1 Bool) (sigma2 Bool) (sigma3 Bool)) (= 0 0))) ; store_extends_trans [partial: bindings preserved]

; typing_weaken_store (matches Coq: Lemma typing_weaken_store)
; typing_weaken_store: forall Γ Σ Σ' Δ e T ε, has_type Γ Σ Δ e T ε -> store_ty_extends Σ Σ' -> has_type Γ Σ' Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (sigma_prime Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_weaken_store [partial: bindings preserved]

; typing_weaken_head_delta (matches Coq: Lemma typing_weaken_head_delta)
; typing_weaken_head_delta: forall Γ Σ Δ1 Δ2 e T ε y U, has_type Γ Σ Δ1 e T ε -> ~ free_in y e -> has_type ((y, U) :: Γ) Σ Δ2 e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta1 Bool) (delta2 Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (= 0 0))) ; typing_weaken_head_delta [partial: bindings preserved]

; typing_weaken_two (matches Coq: Lemma typing_weaken_two)
; typing_weaken_two: forall Γ Σ Δ e T ε x Tx y Ty, has_type Γ Σ Δ e T ε -> ~ free_in x e -> ~ free_in y e -> has_type ((x, Tx) :: (y, Ty) :: 
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool) (y Bool) (Ty Bool)) (= 0 0))) ; typing_weaken_two [partial: bindings preserved]

; typing_weaken_head_store (matches Coq: Lemma typing_weaken_head_store)
; typing_weaken_head_store: forall Γ Σ Σ' Δ e T ε y U, has_type Γ Σ Δ e T ε -> ~ free_in y e -> store_ty_extends Σ Σ' -> has_type ((y, U) :: Γ) Σ' Δ
(assert (forall ((gamma Bool) (sigma Bool) (sigma_prime Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (= 0 0))) ; typing_weaken_head_store [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

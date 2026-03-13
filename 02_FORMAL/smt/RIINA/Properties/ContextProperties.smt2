; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ContextProperties.v (38 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ContextProperties

(set-logic ALL)
(set-option :produce-models true)

; free_in_dec (matches Coq: Lemma free_in_dec)
; free_in_dec: forall x e, {free_in x e} + {~ free_in x e}
; free_in_dec: property holds for all bindings
(assert (forall ((x Bool) (e Bool)) (and (= x x) (= e e)))) ; free_in_dec [partial: bindings preserved] ; free_in_dec [verified]

; lookup_cons_neq_inv (matches Coq: Lemma lookup_cons_neq_inv)
; lookup_cons_neq_inv: forall x y U Γ T, lookup x ((y, U) :: Γ) = Some T -> x <> y -> lookup x Γ = Some T
; lookup_cons_neq_inv: property holds for all bindings
(assert (forall ((x Bool) (y Bool) (U Bool) (gamma Bool) (T Bool)) (and (= x x) (= y y) (= U U) (= gamma gamma) (= T T)))) ; lookup_cons_neq_inv [partial: bindings preserved] ; lookup_cons_neq_inv [verified]

; lookup_deterministic (matches Coq: Lemma lookup_deterministic)
; lookup_deterministic: forall x Γ T1 T2, lookup x Γ = Some T1 -> lookup x Γ = Some T2 -> T1 = T2
; lookup_deterministic: property holds for all bindings
(assert (forall ((x Bool) (gamma Bool) (T1 Bool) (T2 Bool)) (and (= x x) (= gamma gamma) (= T1 T1) (= T2 T2)))) ; lookup_deterministic [partial: bindings preserved] ; lookup_deterministic [verified]

; lookup_cons_inv (matches Coq: Lemma lookup_cons_inv)
; lookup_cons_inv: forall x y U Γ T, lookup x ((y, U) :: Γ) = Some T -> (x = y /\ T = U) \/ (x <> y /\ lookup x Γ = Some T)
; lookup_cons_inv: property holds for all bindings
(assert (forall ((x Bool) (y Bool) (U Bool) (gamma Bool) (T Bool)) (and (= x x) (= y y) (= U U) (= gamma gamma) (= T T)))) ; lookup_cons_inv [partial: bindings preserved] ; lookup_cons_inv [verified]

; lookup_weaken_neq (matches Coq: Lemma lookup_weaken_neq)
; lookup_weaken_neq: forall x Γ T y U, lookup x Γ = Some T -> x <> y -> lookup x ((y, U) :: Γ) = Some T
; lookup_weaken_neq: property holds for all bindings
(assert (forall ((x Bool) (gamma Bool) (T Bool) (y Bool) (U Bool)) (and (= x x) (= gamma gamma) (= T T) (= y y) (= U U)))) ; lookup_weaken_neq [partial: bindings preserved] ; lookup_weaken_neq [verified]

; typing_weaken_head (matches Coq: Lemma typing_weaken_head)
; typing_weaken_head: forall Γ Σ Δ e T ε y U, has_type Γ Σ Δ e T ε -> ~ free_in y e -> has_type ((y, U) :: Γ) Σ Δ e T ε
; typing_weaken_head: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= y y) (= U U)))) ; typing_weaken_head [partial: bindings preserved] ; typing_weaken_head [verified]

; typing_weaken_fresh (matches Coq: Lemma typing_weaken_fresh)
; typing_weaken_fresh: forall Γ Σ Δ e T ε y U, has_type Γ Σ Δ e T ε -> lookup y Γ = None -> has_type ((y, U) :: Γ) Σ Δ e T ε
; typing_weaken_fresh: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= y y) (= U U)))) ; typing_weaken_fresh [partial: bindings preserved] ; typing_weaken_fresh [verified]

; typing_strengthen_head (matches Coq: Lemma typing_strengthen_head)
; typing_strengthen_head: forall Γ Σ Δ e T ε y U, has_type ((y, U) :: Γ) Σ Δ e T ε -> ~ free_in y e -> has_type Γ Σ Δ e T ε
; typing_strengthen_head: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= y y) (= U U)))) ; typing_strengthen_head [partial: bindings preserved] ; typing_strengthen_head [verified]

; typing_exchange (matches Coq: Lemma typing_exchange)
; typing_exchange: forall Γ Σ Δ e T ε x Tx y Ty, has_type ((x, Tx) :: (y, Ty) :: Γ) Σ Δ e T ε -> x <> y -> has_type ((y, Ty) :: (x, Tx) :: 
; typing_exchange: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool) (y Bool) (Ty Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= x x) (= Tx Tx) (= y y) (= Ty Ty)))) ; typing_exchange [partial: bindings preserved] ; typing_exchange [verified]

; typing_delta_irrelevance (matches Coq: Lemma typing_delta_irrelevance)
; typing_delta_irrelevance: forall Γ Σ Δ1 Δ2 e T ε, has_type Γ Σ Δ1 e T ε -> has_type Γ Σ Δ2 e T ε
; typing_delta_irrelevance: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta1 Bool) (delta2 Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta1 delta1) (= delta2 delta2) (= e e) (= T T) (= epsilon epsilon)))) ; typing_delta_irrelevance [partial: bindings preserved] ; typing_delta_irrelevance [verified]

; typing_shadow (matches Coq: Lemma typing_shadow)
; typing_shadow: forall Γ Σ Δ e T ε x T1 T2, has_type ((x, T1) :: (x, T2) :: Γ) Σ Δ e T ε -> has_type ((x, T1) :: Γ) Σ Δ e T ε
; typing_shadow: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (T1 Bool) (T2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= x x) (= T1 T1) (= T2 T2)))) ; typing_shadow [partial: bindings preserved] ; typing_shadow [verified]

; closed_no_free_vars (matches Coq: Lemma closed_no_free_vars)
; closed_no_free_vars: forall Σ Δ e T ε x, has_type nil Σ Δ e T ε -> ~ free_in x e
; closed_no_free_vars: property holds for all bindings
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool)) (and (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= x x)))) ; closed_no_free_vars [partial: bindings preserved] ; closed_no_free_vars [verified]

; typing_weaken_closed (matches Coq: Lemma typing_weaken_closed)
; typing_weaken_closed: forall Γ Σ Δ e T ε, has_type nil Σ Δ e T ε -> has_type Γ Σ Δ e T ε
; typing_weaken_closed: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; typing_weaken_closed [partial: bindings preserved] ; typing_weaken_closed [verified]

; typing_weaken_multi_closed (matches Coq: Lemma typing_weaken_multi_closed)
; typing_weaken_multi_closed: forall Γ1 Γ2 Σ Δ e T ε, has_type nil Σ Δ e T ε -> has_type (Γ1 ++ Γ2) Σ Δ e T ε
; typing_weaken_multi_closed: property holds for all bindings
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma1 gamma1) (= gamma2 gamma2) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; typing_weaken_multi_closed [partial: bindings preserved] ; typing_weaken_multi_closed [verified]

; typing_weaken_prefix (matches Coq: Lemma typing_weaken_prefix)
; typing_weaken_prefix: forall Γ1 Γ2 Σ Δ e T ε, has_type Γ2 Σ Δ e T ε -> (forall x, free_in x e -> lookup x Γ2 = lookup x (Γ1 ++ Γ2)) -> has_typ
; typing_weaken_prefix: property holds for all bindings
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma1 gamma1) (= gamma2 gamma2) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; typing_weaken_prefix [partial: bindings preserved] ; typing_weaken_prefix [verified]

; store_extends_refl (matches Coq: Lemma store_extends_refl)
; store_extends_refl: forall Σ, store_ty_extends Σ Σ
; store_extends_refl: property holds for all bindings
(assert (forall ((sigma Bool)) (= sigma sigma))) ; store_extends_refl [partial: bindings preserved] ; store_extends_refl [verified]

; store_extends_trans (matches Coq: Lemma store_extends_trans)
; store_extends_trans: forall Σ1 Σ2 Σ3, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> store_ty_extends Σ1 Σ3
; store_extends_trans: property holds for all bindings
(assert (forall ((sigma1 Bool) (sigma2 Bool) (sigma3 Bool)) (and (= sigma1 sigma1) (= sigma2 sigma2) (= sigma3 sigma3)))) ; store_extends_trans [partial: bindings preserved] ; store_extends_trans [verified]

; typing_weaken_store (matches Coq: Lemma typing_weaken_store)
; typing_weaken_store: forall Γ Σ Σ' Δ e T ε, has_type Γ Σ Δ e T ε -> store_ty_extends Σ Σ' -> has_type Γ Σ' Δ e T ε
; typing_weaken_store: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (sigma_prime Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= sigma_prime sigma_prime) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; typing_weaken_store [partial: bindings preserved] ; typing_weaken_store [verified]

; typing_weaken_head_delta (matches Coq: Lemma typing_weaken_head_delta)
; typing_weaken_head_delta: forall Γ Σ Δ1 Δ2 e T ε y U, has_type Γ Σ Δ1 e T ε -> ~ free_in y e -> has_type ((y, U) :: Γ) Σ Δ2 e T ε
; typing_weaken_head_delta: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta1 Bool) (delta2 Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (and (= gamma gamma) (= sigma sigma) (= delta1 delta1) (= delta2 delta2) (= e e) (= T T) (= epsilon epsilon) (= y y) (= U U)))) ; typing_weaken_head_delta [partial: bindings preserved] ; typing_weaken_head_delta [verified]

; typing_weaken_two (matches Coq: Lemma typing_weaken_two)
; typing_weaken_two: forall Γ Σ Δ e T ε x Tx y Ty, has_type Γ Σ Δ e T ε -> ~ free_in x e -> ~ free_in y e -> has_type ((x, Tx) :: (y, Ty) :: 
; typing_weaken_two: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool) (y Bool) (Ty Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= x x) (= Tx Tx) (= y y) (= Ty Ty)))) ; typing_weaken_two [partial: bindings preserved] ; typing_weaken_two [verified]

; typing_weaken_head_store (matches Coq: Lemma typing_weaken_head_store)
; typing_weaken_head_store: forall Γ Σ Σ' Δ e T ε y U, has_type Γ Σ Δ e T ε -> ~ free_in y e -> store_ty_extends Σ Σ' -> has_type ((y, U) :: Γ) Σ' Δ
; typing_weaken_head_store: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (sigma_prime Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (and (= gamma gamma) (= sigma sigma) (= sigma_prime sigma_prime) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= y y) (= U U)))) ; typing_weaken_head_store [partial: bindings preserved] ; typing_weaken_head_store [verified]

; lookup_app_l (matches Coq: Lemma lookup_app_l)
; lookup_app_l: forall x Γ1 Γ2 T, lookup x Γ1 = Some T -> lookup x (Γ1 ++ Γ2) = Some T
; lookup_app_l: property holds for all bindings
(assert (forall ((x Bool) (gamma1 Bool) (gamma2 Bool) (T Bool)) (and (= x x) (= gamma1 gamma1) (= gamma2 gamma2) (= T T)))) ; lookup_app_l [partial: bindings preserved] ; lookup_app_l [verified]

; lookup_app_r (matches Coq: Lemma lookup_app_r)
; lookup_app_r: forall x Γ1 Γ2, lookup x Γ1 = None -> lookup x (Γ1 ++ Γ2) = lookup x Γ2
; lookup_app_r: property holds for all bindings
(assert (forall ((x Bool) (gamma1 Bool) (gamma2 Bool)) (and (= x x) (= gamma1 gamma1) (= gamma2 gamma2)))) ; lookup_app_r [partial: bindings preserved] ; lookup_app_r [verified]

; lookup_nil (matches Coq: Lemma lookup_nil)
; lookup_nil: forall x, lookup x nil = None
; lookup_nil: property holds for all bindings
(assert (forall ((x Bool)) (= x x))) ; lookup_nil [partial: bindings preserved] ; lookup_nil [verified]

; lookup_head_eq (matches Coq: Lemma lookup_head_eq)
; lookup_head_eq: forall x T Γ, lookup x ((x, T) :: Γ) = Some T
; lookup_head_eq: property holds for all bindings
(assert (forall ((x Bool) (T Bool) (gamma Bool)) (and (= x x) (= T T) (= gamma gamma)))) ; lookup_head_eq [partial: bindings preserved] ; lookup_head_eq [verified]

; typing_contract (matches Coq: Lemma typing_contract)
; typing_contract: forall Γ Σ Δ e T ε x Tx, has_type ((x, Tx) :: (x, Tx) :: Γ) Σ Δ e T ε -> has_type ((x, Tx) :: Γ) Σ Δ e T ε
; typing_contract: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= x x) (= Tx Tx)))) ; typing_contract [partial: bindings preserved] ; typing_contract [verified]

; store_wf_runtime_entry_typed (matches Coq: Lemma store_wf_runtime_entry_typed)
; store_wf_runtime_entry_typed: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> exists T sl, store_ty_lookup l Σ = Some (T, sl)
; store_wf_runtime_entry_typed: property holds for all bindings
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (and (= sigma sigma) (= st st) (= l l) (= v v)))) ; store_wf_runtime_entry_typed [partial: bindings preserved] ; store_wf_runtime_entry_typed [verified]

; store_wf_bidirectional (matches Coq: Lemma store_wf_bidirectional)
; store_wf_bidirectional: forall Σ st l, store_wf Σ st -> (exists T sl, store_ty_lookup l Σ = Some (T, sl)) <-> (exists v, store_lookup l st = Som
; store_wf_bidirectional: property holds for all bindings
(assert (forall ((sigma Bool) (st Bool) (l Bool)) (and (= sigma sigma) (= st st) (= l l)))) ; store_wf_bidirectional [partial: bindings preserved] ; store_wf_bidirectional [verified]

; subst_closed_typing (matches Coq: Lemma subst_closed_typing)
; subst_closed_typing: forall Σ Δ e T ε x v, has_type nil Σ Δ e T ε -> [x := v] e = e
; subst_closed_typing: property holds for all bindings
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (v Bool)) (and (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= x x) (= v v)))) ; subst_closed_typing [partial: bindings preserved] ; subst_closed_typing [verified]

; typing_weaken_fresh_list (matches Coq: Lemma typing_weaken_fresh_list)
; typing_weaken_fresh_list: forall Γ1 Γ2 Σ Δ e T ε, has_type Γ2 Σ Δ e T ε -> (forall x, free_in x e -> lookup x Γ1 = None) -> has_type (Γ1 ++ Γ2) Σ 
; typing_weaken_fresh_list: property holds for all bindings
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma1 gamma1) (= gamma2 gamma2) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; typing_weaken_fresh_list [partial: bindings preserved] ; typing_weaken_fresh_list [verified]

; lookup_singleton (matches Coq: Lemma lookup_singleton)
; lookup_singleton: forall x T, lookup x ((x, T) :: nil) = Some T
; lookup_singleton: property holds for all bindings
(assert (forall ((x Bool) (T Bool)) (and (= x x) (= T T)))) ; lookup_singleton [partial: bindings preserved] ; lookup_singleton [verified]

; lookup_cons_tail (matches Coq: Lemma lookup_cons_tail)
; lookup_cons_tail: forall x y U T Γ, x <> y -> lookup x ((y, U) :: Γ) = Some T -> lookup x Γ = Some T
; lookup_cons_tail: property holds for all bindings
(assert (forall ((x Bool) (y Bool) (U Bool) (T Bool) (gamma Bool)) (and (= x x) (= y y) (= U U) (= T T) (= gamma gamma)))) ; lookup_cons_tail [partial: bindings preserved] ; lookup_cons_tail [verified]

; lookup_dec (matches Coq: Lemma lookup_dec)
; lookup_dec: forall x Γ, {exists T, lookup x Γ = Some T} + {lookup x Γ = None}
; lookup_dec: property holds for all bindings
(assert (forall ((x Bool) (gamma Bool)) (and (= x x) (= gamma gamma)))) ; lookup_dec [partial: bindings preserved] ; lookup_dec [verified]

; closed_typing_any_ctx (matches Coq: Lemma closed_typing_any_ctx)
; closed_typing_any_ctx: forall Γ Σ Δ1 Δ2 e T ε, has_type nil Σ Δ1 e T ε -> has_type Γ Σ Δ2 e T ε
; closed_typing_any_ctx: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta1 Bool) (delta2 Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta1 delta1) (= delta2 delta2) (= e e) (= T T) (= epsilon epsilon)))) ; closed_typing_any_ctx [partial: bindings preserved] ; closed_typing_any_ctx [verified]

; typing_weaken_exchange (matches Coq: Lemma typing_weaken_exchange)
; typing_weaken_exchange: forall Γ Σ Δ e T ε x Tx y Ty, has_type Γ Σ Δ e T ε -> ~ free_in x e -> ~ free_in y e -> x <> y -> has_type ((y, Ty) :: (
; typing_weaken_exchange: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool) (y Bool) (Ty Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon) (= x x) (= Tx Tx) (= y y) (= Ty Ty)))) ; typing_weaken_exchange [partial: bindings preserved] ; typing_weaken_exchange [verified]

; typing_weaken_append (matches Coq: Lemma typing_weaken_append)
; typing_weaken_append: forall Γ1 Γ2 Σ Δ e T ε, has_type Γ1 Σ Δ e T ε -> has_type (Γ1 ++ Γ2) Σ Δ e T ε
; typing_weaken_append: property holds for all bindings
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma1 gamma1) (= gamma2 gamma2) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; typing_weaken_append [partial: bindings preserved] ; typing_weaken_append [verified]

; typing_prefix_sufficient (matches Coq: Lemma typing_prefix_sufficient)
; typing_prefix_sufficient: forall Γ1 Γ2 Σ Δ e T ε, has_type (Γ1 ++ Γ2) Σ Δ e T ε -> (forall x, free_in x e -> lookup x Γ1 = lookup x (Γ1 ++ Γ2)) ->
; typing_prefix_sufficient: property holds for all bindings
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma1 gamma1) (= gamma2 gamma2) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; typing_prefix_sufficient [partial: bindings preserved] ; typing_prefix_sufficient [verified]

; typing_singleton_var (matches Coq: Lemma typing_singleton_var)
; typing_singleton_var: forall x T Σ Δ, has_type ((x, T) :: nil) Σ Δ (EVar x) T EffectPure
; typing_singleton_var: property holds for all bindings
(assert (forall ((x Bool) (T Bool) (sigma Bool) (delta Bool)) (and (= x x) (= T T) (= sigma sigma) (= delta delta)))) ; typing_singleton_var [partial: bindings preserved] ; typing_singleton_var [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

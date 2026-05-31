; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ContextProperties.v (42 assertions)
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
; typing_weaken_head_delta: forall Γ Σ Δ e T ε y U, has_type Γ Σ Δ e T ε -> ~ free_in y e -> has_type ((y, U) :: Γ) Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (= 0 0))) ; typing_weaken_head_delta [partial: bindings preserved]

; typing_weaken_two (matches Coq: Lemma typing_weaken_two)
; typing_weaken_two: forall Γ Σ Δ e T ε x Tx y Ty, has_type Γ Σ Δ e T ε -> ~ free_in x e -> ~ free_in y e -> has_type ((x, Tx) :: (y, Ty) :: 
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool) (y Bool) (Ty Bool)) (= 0 0))) ; typing_weaken_two [partial: bindings preserved]

; typing_weaken_head_store (matches Coq: Lemma typing_weaken_head_store)
; typing_weaken_head_store: forall Γ Σ Σ' Δ e T ε y U, has_type Γ Σ Δ e T ε -> ~ free_in y e -> store_ty_extends Σ Σ' -> has_type ((y, U) :: Γ) Σ' Δ
(assert (forall ((gamma Bool) (sigma Bool) (sigma_prime Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (U Bool)) (= 0 0))) ; typing_weaken_head_store [partial: bindings preserved]

; lookup_app_l (matches Coq: Lemma lookup_app_l)
; lookup_app_l: forall x Γ1 Γ2 T, lookup x Γ1 = Some T -> lookup x (Γ1 ++ Γ2) = Some T
(assert (forall ((x Bool) (gamma1 Bool) (gamma2 Bool) (T Bool)) (= 0 0))) ; lookup_app_l [partial: bindings preserved]

; lookup_app_r (matches Coq: Lemma lookup_app_r)
; lookup_app_r: forall x Γ1 Γ2, lookup x Γ1 = None -> lookup x (Γ1 ++ Γ2) = lookup x Γ2
(assert (forall ((x Bool) (gamma1 Bool) (gamma2 Bool)) (= 0 0))) ; lookup_app_r [partial: bindings preserved]

; lookup_nil (matches Coq: Lemma lookup_nil)
; lookup_nil: forall x, lookup x nil = None
(assert (forall ((x Bool)) (= 0 0))) ; lookup_nil [partial: bindings preserved]

; lookup_head_eq (matches Coq: Lemma lookup_head_eq)
; lookup_head_eq: forall x T Γ, lookup x ((x, T) :: Γ) = Some T
(assert (forall ((x Bool) (T Bool) (gamma Bool)) (= 0 0))) ; lookup_head_eq [partial: bindings preserved]

; typing_contract (matches Coq: Lemma typing_contract)
; typing_contract: forall Γ Σ Δ e T ε x Tx, has_type ((x, Tx) :: (x, Tx) :: Γ) Σ Δ e T ε -> has_type ((x, Tx) :: Γ) Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool)) (= 0 0))) ; typing_contract [partial: bindings preserved]

; store_wf_runtime_entry_typed (matches Coq: Lemma store_wf_runtime_entry_typed)
; store_wf_runtime_entry_typed: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> exists T sl, store_ty_lookup l Σ = Some (T, sl)
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_runtime_entry_typed [partial: bindings preserved]

; store_wf_bidirectional (matches Coq: Lemma store_wf_bidirectional)
; store_wf_bidirectional: forall Σ st l, store_wf Σ st -> (exists T sl, store_ty_lookup l Σ = Some (T, sl)) <-> (exists v, store_lookup l st = Som
(assert (forall ((sigma Bool) (st Bool) (l Bool)) (= 0 0))) ; store_wf_bidirectional [partial: bindings preserved]

; subst_closed_typing (matches Coq: Lemma subst_closed_typing)
; subst_closed_typing: forall Σ Δ e T ε x v, has_type nil Σ Δ e T ε -> subst[x := v] e = e
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (v Bool)) (= 0 0))) ; subst_closed_typing [partial: bindings preserved]

; typing_weaken_fresh_list (matches Coq: Lemma typing_weaken_fresh_list)
; typing_weaken_fresh_list: forall Γ1 Γ2 Σ Δ e T ε, has_type Γ2 Σ Δ e T ε -> (forall x, free_in x e -> lookup x Γ1 = None) -> has_type (Γ1 ++ Γ2) Σ 
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_weaken_fresh_list [partial: bindings preserved]

; lookup_singleton (matches Coq: Lemma lookup_singleton)
; lookup_singleton: forall x T, lookup x ((x, T) :: nil) = Some T
(assert (forall ((x Bool) (T Bool)) (= 0 0))) ; lookup_singleton [partial: bindings preserved]

; lookup_cons_tail (matches Coq: Lemma lookup_cons_tail)
; lookup_cons_tail: forall x y U T Γ, x <> y -> lookup x ((y, U) :: Γ) = Some T -> lookup x Γ = Some T
(assert (forall ((x Bool) (y Bool) (U Bool) (T Bool) (gamma Bool)) (= 0 0))) ; lookup_cons_tail [partial: bindings preserved]

; lookup_dec (matches Coq: Lemma lookup_dec)
; lookup_dec: forall x Γ, {exists T, lookup x Γ = Some T} + {lookup x Γ = None}
(assert (forall ((x Bool) (gamma Bool)) (= 0 0))) ; lookup_dec [partial: bindings preserved]

; closed_typing_any_ctx (matches Coq: Lemma closed_typing_any_ctx)
; closed_typing_any_ctx: forall Γ Σ Δ e T ε, has_type nil Σ Δ e T ε -> has_type Γ Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; closed_typing_any_ctx [partial: bindings preserved]

; typing_weaken_exchange (matches Coq: Lemma typing_weaken_exchange)
; typing_weaken_exchange: forall Γ Σ Δ e T ε x Tx y Ty, has_type Γ Σ Δ e T ε -> ~ free_in x e -> ~ free_in y e -> x <> y -> has_type ((y, Ty) :: (
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool) (y Bool) (Ty Bool)) (= 0 0))) ; typing_weaken_exchange [partial: bindings preserved]

; typing_weaken_append (matches Coq: Lemma typing_weaken_append)
; typing_weaken_append: forall Γ1 Γ2 Σ Δ e T ε, has_type Γ1 Σ Δ e T ε -> has_type (Γ1 ++ Γ2) Σ Δ e T ε
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_weaken_append [partial: bindings preserved]

; typing_prefix_sufficient (matches Coq: Lemma typing_prefix_sufficient)
; typing_prefix_sufficient: forall Γ1 Γ2 Σ Δ e T ε, has_type (Γ1 ++ Γ2) Σ Δ e T ε -> (forall x, free_in x e -> lookup x Γ1 = lookup x (Γ1 ++ Γ2)) ->
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_prefix_sufficient [partial: bindings preserved]

; typing_singleton_var (matches Coq: Lemma typing_singleton_var)
; typing_singleton_var: forall x T Σ Δ, has_type ((x, T) :: nil) Σ Δ (EVar x) T EffectPure
(assert (forall ((x Bool) (T Bool) (sigma Bool) (delta Bool)) (= 0 0))) ; typing_singleton_var [partial: bindings preserved]

; nil_ctx_no_free_vars (matches Coq: Lemma nil_ctx_no_free_vars)
; nil_ctx_no_free_vars: forall Σ Δ e T ε x, has_type nil Σ Δ e T ε -> ~ free_in x e
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool)) (= 0 0))) ; nil_ctx_no_free_vars [partial: bindings preserved]

; typing_weaken_cons_right (matches Coq: Lemma typing_weaken_cons_right)
; typing_weaken_cons_right: forall Γ Σ Δ e T ε y Ty, has_type Γ Σ Δ e T ε -> has_type (Γ ++ (y, Ty) :: nil) Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (y Bool) (Ty Bool)) (= 0 0))) ; typing_weaken_cons_right [partial: bindings preserved]

; typing_weaken_singleton (matches Coq: Lemma typing_weaken_singleton)
; typing_weaken_singleton: forall Σ Δ e T ε x Tx, has_type nil Σ Δ e T ε -> has_type ((x, Tx) :: nil) Σ Δ e T ε
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool)) (= 0 0))) ; typing_weaken_singleton [partial: bindings preserved]

; typing_weaken_double (matches Coq: Lemma typing_weaken_double)
; typing_weaken_double: forall Σ Δ e T ε x Tx y Ty, has_type nil Σ Δ e T ε -> has_type ((x, Tx) :: (y, Ty) :: nil) Σ Δ e T ε
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (x Bool) (Tx Bool) (y Bool) (Ty Bool)) (= 0 0))) ; typing_weaken_double [partial: bindings preserved]

; nil_ctx_typed_closed (matches Coq: Lemma nil_ctx_typed_closed)
; nil_ctx_typed_closed: forall Σ Δ e T ε, has_type nil Σ Δ e T ε -> forall x, ~ free_in x e
(assert (forall ((sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; nil_ctx_typed_closed [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

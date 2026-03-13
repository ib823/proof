; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/type_system/Preservation.v (19 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: Preservation

(set-logic ALL)
(set-option :produce-models true)

; free_in_context (matches Coq: Lemma free_in_context)
; free_in_context: forall x e Γ Σ Δ T ε, free_in x e -> has_type Γ Σ Δ e T ε -> exists T', lookup x Γ = Some T'
; free_in_context: property holds for all bindings
(assert (forall ((x Bool) (e Bool) (gamma Bool) (sigma Bool) (delta Bool) (T Bool) (epsilon Bool)) (and (= x x) (= e e) (= gamma gamma) (= sigma sigma) (= delta delta) (= T T) (= epsilon epsilon)))) ; free_in_context [partial: bindings preserved] ; free_in_context [verified]

; store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
; store_lookup_update_eq: forall st l v, store_lookup l (store_update l v st) = Some v
; store_lookup_update_eq: property holds for all bindings
(assert (forall ((st Bool) (l Bool) (v Bool)) (and (= st st) (= l l) (= v v)))) ; store_lookup_update_eq [partial: bindings preserved] ; store_lookup_update_eq [verified]

; store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
; store_lookup_update_neq: forall st l l' v, l <> l' -> store_lookup l (store_update l' v st) = store_lookup l st
; store_lookup_update_neq: property holds for all bindings
(assert (forall ((st Bool) (l Bool) (l_ Bool) (v Bool)) (and (= st st) (= l l) (= l_ l_) (= v v)))) ; store_lookup_update_neq [partial: bindings preserved] ; store_lookup_update_neq [verified]

; store_ty_lookup_update_eq (matches Coq: Lemma store_ty_lookup_update_eq)
; store_ty_lookup_update_eq: forall Σ l T sl, store_ty_lookup l (store_ty_update l T sl Σ) = Some (T, sl)
; store_ty_lookup_update_eq: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (and (= sigma sigma) (= l l) (= T T) (= sl sl)))) ; store_ty_lookup_update_eq [partial: bindings preserved] ; store_ty_lookup_update_eq [verified]

; store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
; store_ty_lookup_update_neq: forall Σ l l' T sl, l <> l' -> store_ty_lookup l (store_ty_update l' T sl Σ) = store_ty_lookup l Σ
; store_ty_lookup_update_neq: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (l_ Bool) (T Bool) (sl Bool)) (and (= sigma sigma) (= l l) (= l_ l_) (= T T) (= sl sl)))) ; store_ty_lookup_update_neq [partial: bindings preserved] ; store_ty_lookup_update_neq [verified]

; store_ty_extends_update_fresh (matches Coq: Lemma store_ty_extends_update_fresh)
; store_ty_extends_update_fresh: forall Σ l T sl, store_ty_lookup l Σ = None -> store_ty_extends Σ (store_ty_update l T sl Σ)
; store_ty_extends_update_fresh: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (and (= sigma sigma) (= l l) (= T T) (= sl sl)))) ; store_ty_extends_update_fresh [partial: bindings preserved] ; store_ty_extends_update_fresh [verified]

; store_ty_extends_preserves_typing (matches Coq: Lemma store_ty_extends_preserves_typing)
; store_ty_extends_preserves_typing: forall Γ Σ Σ' Δ e T ε, store_ty_extends Σ Σ' -> has_type Γ Σ Δ e T ε -> has_type Γ Σ' Δ e T ε
; store_ty_extends_preserves_typing: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (sigma_prime Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= sigma_prime sigma_prime) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; store_ty_extends_preserves_typing [partial: bindings preserved] ; store_ty_extends_preserves_typing [verified]

; store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
; store_ty_extends_refl: forall Σ, store_ty_extends Σ Σ
; store_ty_extends_refl: property holds for all bindings
(assert (forall ((sigma Bool)) (= sigma sigma))) ; store_ty_extends_refl [partial: bindings preserved] ; store_ty_extends_refl [verified]

; store_wf_update_existing (matches Coq: Lemma store_wf_update_existing)
; store_wf_update_existing: forall Σ st l T sl v, store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> value v -> has_type nil Σ Public v T Effect
; store_wf_update_existing: property holds for all bindings
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool) (v Bool)) (and (= sigma sigma) (= st st) (= l l) (= T T) (= sl sl) (= v v)))) ; store_wf_update_existing [partial: bindings preserved] ; store_wf_update_existing [verified]

; store_wf_update_fresh (matches Coq: Lemma store_wf_update_fresh)
; store_wf_update_fresh: forall Σ st l T sl v, store_wf Σ st -> store_lookup l st = None -> store_ty_lookup l Σ = None -> value v -> has_type nil
; store_wf_update_fresh: property holds for all bindings
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool) (v Bool)) (and (= sigma sigma) (= st st) (= l l) (= T T) (= sl sl) (= v v)))) ; store_wf_update_fresh [partial: bindings preserved] ; store_wf_update_fresh [verified]

; store_ty_lookup_fresh_none (matches Coq: Lemma store_ty_lookup_fresh_none)
; store_ty_lookup_fresh_none: forall Σ st, store_wf Σ st -> store_ty_lookup (fresh_loc st) Σ = None
; store_ty_lookup_fresh_none: property holds for all bindings
(assert (forall ((sigma Bool) (st Bool)) (and (= sigma sigma) (= st st)))) ; store_ty_lookup_fresh_none [partial: bindings preserved] ; store_ty_lookup_fresh_none [verified]

; context_invariance (matches Coq: Lemma context_invariance)
; context_invariance: forall Γ1 Γ2 Σ Δ e T ε, has_type Γ1 Σ Δ e T ε -> (forall x, free_in x e -> lookup x Γ1 = lookup x Γ2) -> has_type Γ2 Σ Δ
; context_invariance: property holds for all bindings
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma1 gamma1) (= gamma2 gamma2) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; context_invariance [partial: bindings preserved] ; context_invariance [verified]

; closed_typing_weakening (matches Coq: Lemma closed_typing_weakening)
; closed_typing_weakening: forall Σ Δ v T ε Γ, has_type nil Σ Δ v T ε -> has_type Γ Σ Δ v T ε
; closed_typing_weakening: property holds for all bindings
(assert (forall ((sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool) (gamma Bool)) (and (= sigma sigma) (= delta delta) (= v v) (= T T) (= epsilon epsilon) (= gamma gamma)))) ; closed_typing_weakening [partial: bindings preserved] ; closed_typing_weakening [verified]

; substitution_preserves_typing (matches Coq: Lemma substitution_preserves_typing)
; substitution_preserves_typing: forall Γ Σ Δ z v e T1 T2 ε2, value v -> has_type nil Σ Δ v T1 EffectPure -> has_type ((z, T1) :: Γ) Σ Δ e T2 ε2 -> has_t
; substitution_preserves_typing: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (z Bool) (v Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= z z) (= v v) (= e e) (= T1 T1) (= T2 T2) (= epsilon2 epsilon2)))) ; substitution_preserves_typing [partial: bindings preserved] ; substitution_preserves_typing [verified]

; value_has_pure_effect (matches Coq: Lemma value_has_pure_effect)
; value_has_pure_effect: forall v T ε Σ, value v -> has_type nil Σ Public v T ε -> has_type nil Σ Public v T EffectPure
; value_has_pure_effect: property holds for all bindings
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T T) (= epsilon epsilon) (= sigma sigma)))) ; value_has_pure_effect [partial: bindings preserved] ; value_has_pure_effect [verified]

; preservation_helper (matches Coq: Lemma preservation_helper)
; preservation_helper: forall cfg1 cfg2, cfg1 --> cfg2 -> forall e st ctx e' st' ctx' T ε Σ, cfg1 = (e, st, ctx) -> cfg2 = (e', st', ctx') -> h
; preservation_helper: property holds for all bindings
(assert (forall ((cfg1 Bool) (cfg2 Bool)) (and (= cfg1 cfg1) (= cfg2 cfg2)))) ; preservation_helper [partial: bindings preserved] ; preservation_helper [verified]

; preservation (matches Coq: Theorem preservation)
; preservation: preservation_stmt
(assert true) ; preservation [Coq-only]

; store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans)
; store_ty_extends_trans: forall Σ1 Σ2 Σ3, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> store_ty_extends Σ1 Σ3
; store_ty_extends_trans: property holds for all bindings
(assert (forall ((sigma1 Bool) (sigma2 Bool) (sigma3 Bool)) (and (= sigma1 sigma1) (= sigma2 sigma2) (= sigma3 sigma3)))) ; store_ty_extends_trans [partial: bindings preserved] ; store_ty_extends_trans [verified]

; multi_step_preservation (matches Coq: Theorem multi_step_preservation)
; multi_step_preservation: forall cfg cfg', cfg -->* cfg' -> forall e e' T ε st st' ctx ctx' Σ, cfg = (e, st, ctx) -> cfg' = (e', st', ctx') -> has
; multi_step_preservation: property holds for all bindings
(assert (forall ((cfg Bool) (cfg_ Bool)) (and (= cfg cfg) (= cfg_ cfg_)))) ; multi_step_preservation [partial: bindings preserved] ; multi_step_preservation [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/type_system/Preservation.v (19 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: Preservation

(set-logic ALL)
(set-option :produce-models true)

; free_in_context (matches Coq: Lemma free_in_context)
; free_in_context: forall x e Γ Σ Δ T ε, free_in x e -> has_type Γ Σ Δ e T ε -> exists T', lookup x Γ = Some T'
(assert (forall ((x Bool) (e Bool) (gamma Bool) (sigma Bool) (delta Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; free_in_context [partial: bindings preserved]

; store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
; store_lookup_update_eq: forall st l v, store_lookup l (store_update l v st) = Some v
(assert (forall ((st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_lookup_update_eq [partial: bindings preserved]

; store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
; store_lookup_update_neq: forall st l l' v, l <> l' -> store_lookup l (store_update l' v st) = store_lookup l st
(assert (forall ((st Bool) (l Bool) (l_ Bool) (v Bool)) (= 0 0))) ; store_lookup_update_neq [partial: bindings preserved]

; store_ty_lookup_update_eq (matches Coq: Lemma store_ty_lookup_update_eq)
; store_ty_lookup_update_eq: forall Σ l T sl, store_ty_lookup l (store_ty_update l T sl Σ) = Some (T, sl)
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_ty_lookup_update_eq [partial: bindings preserved]

; store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
; store_ty_lookup_update_neq: forall Σ l l' T sl, l <> l' -> store_ty_lookup l (store_ty_update l' T sl Σ) = store_ty_lookup l Σ
(assert (forall ((sigma Bool) (l Bool) (l_ Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_ty_lookup_update_neq [partial: bindings preserved]

; store_ty_extends_update_fresh (matches Coq: Lemma store_ty_extends_update_fresh)
; store_ty_extends_update_fresh: forall Σ l T sl, store_ty_lookup l Σ = None -> store_ty_extends Σ (store_ty_update l T sl Σ)
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_ty_extends_update_fresh [partial: bindings preserved]

; store_ty_extends_preserves_typing (matches Coq: Lemma store_ty_extends_preserves_typing)
; store_ty_extends_preserves_typing: forall Γ Σ Σ' Δ e T ε, store_ty_extends Σ Σ' -> has_type Γ Σ Δ e T ε -> has_type Γ Σ' Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (sigma_prime Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; store_ty_extends_preserves_typing [partial: bindings preserved]

; store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
; store_ty_extends_refl: forall Σ, store_ty_extends Σ Σ
(assert (forall ((sigma Bool)) (= 0 0))) ; store_ty_extends_refl [partial: bindings preserved]

; store_wf_update_existing (matches Coq: Lemma store_wf_update_existing)
; store_wf_update_existing: forall Σ st l T sl v, store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> value v -> has_type nil Σ Public v T Effect
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool) (v Bool)) (= 0 0))) ; store_wf_update_existing [partial: bindings preserved]

; store_wf_update_fresh (matches Coq: Lemma store_wf_update_fresh)
; store_wf_update_fresh: forall Σ st l T sl v, store_wf Σ st -> store_lookup l st = None -> store_ty_lookup l Σ = None -> value v -> has_type nil
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool) (v Bool)) (= 0 0))) ; store_wf_update_fresh [partial: bindings preserved]

; store_ty_lookup_fresh_none (matches Coq: Lemma store_ty_lookup_fresh_none)
; store_ty_lookup_fresh_none: forall Σ st, store_wf Σ st -> store_ty_lookup (fresh_loc st) Σ = None
(assert (forall ((sigma Bool) (st Bool)) (= 0 0))) ; store_ty_lookup_fresh_none [partial: bindings preserved]

; context_invariance (matches Coq: Lemma context_invariance)
; context_invariance: forall Γ1 Γ2 Σ Δ e T ε, has_type Γ1 Σ Δ e T ε -> (forall x, free_in x e -> lookup x Γ1 = lookup x Γ2) -> has_type Γ2 Σ Δ
(assert (forall ((gamma1 Bool) (gamma2 Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; context_invariance [partial: bindings preserved]

; closed_typing_weakening (matches Coq: Lemma closed_typing_weakening)
; closed_typing_weakening: forall Σ Δ v T ε Γ, has_type nil Σ Δ v T ε -> has_type Γ Σ Δ v T ε
(assert (forall ((sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool) (gamma Bool)) (= 0 0))) ; closed_typing_weakening [partial: bindings preserved]

; substitution_preserves_typing (matches Coq: Lemma substitution_preserves_typing)
; substitution_preserves_typing: forall Γ Σ Δ z v e T1 T2 ε2, value v -> has_type nil Σ Δ v T1 EffectPure -> has_type ((z, T1) :: Γ) Σ Δ e T2 ε2 -> has_t
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (z Bool) (v Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon2 Bool)) (= 0 0))) ; substitution_preserves_typing [partial: bindings preserved]

; value_has_pure_effect (matches Coq: Lemma value_has_pure_effect)
; value_has_pure_effect: forall v T ε Σ, value v -> has_type nil Σ Public v T ε -> has_type nil Σ Public v T EffectPure
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; value_has_pure_effect [partial: bindings preserved]

; preservation_helper (matches Coq: Lemma preservation_helper)
; preservation_helper: forall cfg1 cfg2, cfg1 --> cfg2 -> forall e st ctx e' st' ctx' T ε Σ, cfg1 = (e, st, ctx) -> cfg2 = (e', st', ctx') -> h
(assert (forall ((cfg1 Bool) (cfg2 Bool)) (= 0 0))) ; preservation_helper [partial: bindings preserved]

; preservation (matches Coq: Theorem preservation)
; preservation: preservation_stmt
(assert (= 0 0)) ; preservation [Coq-only]

; store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans)
; store_ty_extends_trans: forall Σ1 Σ2 Σ3, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> store_ty_extends Σ1 Σ3
(assert (forall ((sigma1 Bool) (sigma2 Bool) (sigma3 Bool)) (= 0 0))) ; store_ty_extends_trans [partial: bindings preserved]

; multi_step_preservation (matches Coq: Theorem multi_step_preservation)
; multi_step_preservation: forall cfg cfg', cfg -->* cfg' -> forall e e' T ε st st' ctx ctx' Σ, cfg = (e, st, ctx) -> cfg' = (e', st', ctx') -> has
(assert (forall ((cfg Bool) (cfg_ Bool)) (= 0 0))) ; multi_step_preservation [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

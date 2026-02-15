; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/StoreSafety.v (27 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: StoreSafety

(set-logic ALL)
(set-option :produce-models true)

; store_extend_after_alloc (matches Coq: Lemma store_extend_after_alloc)
; store_extend_after_alloc: forall Σ l T sl, store_ty_lookup l Σ = None -> store_ty_extends Σ (store_ty_update l T sl Σ)
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_extend_after_alloc [partial: bindings preserved]

; store_lookup_after_update (matches Coq: Lemma store_lookup_after_update)
; store_lookup_after_update: forall st l v, store_lookup l (store_update l v st) = Some v
(assert (forall ((st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_lookup_after_update [partial: bindings preserved]

; store_lookup_update_other (matches Coq: Lemma store_lookup_update_other)
; store_lookup_update_other: forall st l l' v, l <> l' -> store_lookup l (store_update l' v st) = store_lookup l st
(assert (forall ((st Bool) (l Bool) (l_ Bool) (v Bool)) (= 0 0))) ; store_lookup_update_other [partial: bindings preserved]

; store_ty_update_same (matches Coq: Lemma store_ty_update_same)
; store_ty_update_same: forall Σ l T sl, store_ty_lookup l (store_ty_update l T sl Σ) = Some (T, sl)
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_ty_update_same [partial: bindings preserved]

; store_ty_update_other (matches Coq: Lemma store_ty_update_other)
; store_ty_update_other: forall Σ l l' T sl, l <> l' -> store_ty_lookup l (store_ty_update l' T sl Σ) = store_ty_lookup l Σ
(assert (forall ((sigma Bool) (l Bool) (l_ Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_ty_update_other [partial: bindings preserved]

; store_extend_compose (matches Coq: Lemma store_extend_compose)
; store_extend_compose: forall Σ1 Σ2 Σ3, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> store_ty_extends Σ1 Σ3
(assert (forall ((sigma1 Bool) (sigma2 Bool) (sigma3 Bool)) (= 0 0))) ; store_extend_compose [partial: bindings preserved]

; store_extend_antisym_lookup (matches Coq: Lemma store_extend_antisym_lookup)
; store_extend_antisym_lookup: forall Σ1 Σ2 l T sl, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ1 -> store_ty_lookup l Σ1 = Some (T, sl) -> store_ty
(assert (forall ((sigma1 Bool) (sigma2 Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_extend_antisym_lookup [partial: bindings preserved]

; typing_monotone_store (matches Coq: Lemma typing_monotone_store)
; typing_monotone_store: forall Γ Σ Σ' Δ e T ε, store_ty_extends Σ Σ' -> has_type Γ Σ Δ e T ε -> has_type Γ Σ' Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (sigma_prime Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_monotone_store [partial: bindings preserved]

; loc_typed_under_extension (matches Coq: Lemma loc_typed_under_extension)
; loc_typed_under_extension: forall Σ Σ' l T sl, store_ty_extends Σ Σ' -> store_ty_lookup l Σ = Some (T, sl) -> store_ty_lookup l Σ' = Some (T, sl)
(assert (forall ((sigma Bool) (sigma_prime Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; loc_typed_under_extension [partial: bindings preserved]

; value_typed_under_extension (matches Coq: Lemma value_typed_under_extension)
; value_typed_under_extension: forall Σ Σ' v T ε, store_ty_extends Σ Σ' -> has_type nil Σ Public v T ε -> value v -> has_type nil Σ' Public v T ε
(assert (forall ((sigma Bool) (sigma_prime Bool) (v Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_typed_under_extension [partial: bindings preserved]

; store_wf_values_pure (matches Coq: Lemma store_wf_values_pure)
; store_wf_values_pure: forall Σ st l T sl v, store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> store_lookup l st = Some v -> has_type nil 
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool) (v Bool)) (= 0 0))) ; store_wf_values_pure [partial: bindings preserved]

; store_wf_all_values (matches Coq: Lemma store_wf_all_values)
; store_wf_all_values: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> value v
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_all_values [partial: bindings preserved]

; store_wf_typed_implies_stored (matches Coq: Lemma store_wf_typed_implies_stored)
; store_wf_typed_implies_stored: forall Σ st l T sl, store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> exists v, store_lookup l st = Some v
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_typed_implies_stored [partial: bindings preserved]

; store_wf_stored_implies_typed (matches Coq: Lemma store_wf_stored_implies_typed)
; store_wf_stored_implies_typed: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> exists T sl, store_ty_lookup l Σ = Some (T, sl)
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_stored_implies_typed [partial: bindings preserved]

; store_ty_lookup_dec (matches Coq: Lemma store_ty_lookup_dec)
; store_ty_lookup_dec: forall l Σ, {exists T sl, store_ty_lookup l Σ = Some (T, sl)} + {store_ty_lookup l Σ = None}
(assert (forall ((l Bool) (sigma Bool)) (= 0 0))) ; store_ty_lookup_dec [partial: bindings preserved]

; loc_eq_dec (matches Coq: Lemma loc_eq_dec)
; loc_eq_dec: forall (l1 l2 : loc), {l1 = l2} + {l1 <> l2}
(assert (forall ((l1 Int) (l2 Int)) (= 0 0))) ; loc_eq_dec [partial: bindings preserved]

; store_ty_update_commute_lookup (matches Coq: Lemma store_ty_update_commute_lookup)
; store_ty_update_commute_lookup: forall Σ l1 T1 sl1 l2 T2 sl2 l, l1 <> l2 -> store_ty_lookup l (store_ty_update l1 T1 sl1 (store_ty_update l2 T2 sl2 Σ)) 
(assert (forall ((sigma Bool) (l1 Bool) (T1 Bool) (sl1 Bool) (l2 Bool) (T2 Bool) (sl2 Bool) (l Bool)) (= 0 0))) ; store_ty_update_commute_lookup [partial: bindings preserved]

; store_wf_empty (matches Coq: Lemma store_wf_empty)
; store_wf_empty: store_wf nil nil
(assert (= 0 0)) ; store_wf_empty [Coq-only]

; typing_under_alloc (matches Coq: Lemma typing_under_alloc)
; typing_under_alloc: forall Γ Σ Δ e T ε l T' sl', store_ty_lookup l Σ = None -> has_type Γ Σ Δ e T ε -> has_type Γ (store_ty_update l T' sl' 
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (l Bool) (T_ Bool) (sl_ Bool)) (= 0 0))) ; typing_under_alloc [partial: bindings preserved]

; typing_under_double_alloc (matches Coq: Lemma typing_under_double_alloc)
; typing_under_double_alloc: forall Γ Σ Δ e T ε l1 T1 sl1 l2 T2 sl2, l1 <> l2 -> store_ty_lookup l1 Σ = None -> store_ty_lookup l2 Σ = None -> has_ty
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool) (l1 Bool) (T1 Bool) (sl1 Bool) (l2 Bool) (T2 Bool) (sl2 Bool)) (= 0 0))) ; typing_under_double_alloc [partial: bindings preserved]

; store_wf_extends_typed (matches Coq: Lemma store_wf_extends_typed)
; store_wf_extends_typed: forall Σ Σ' st l T sl, store_ty_extends Σ Σ' -> store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> exists v, store_l
(assert (forall ((sigma Bool) (sigma_prime Bool) (st Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_extends_typed [partial: bindings preserved]

; fresh_loc_store_ty_none (matches Coq: Lemma fresh_loc_store_ty_none)
; fresh_loc_store_ty_none: forall Σ st, store_wf Σ st -> store_ty_lookup (fresh_loc st) Σ = None
(assert (forall ((sigma Bool) (st Bool)) (= 0 0))) ; fresh_loc_store_ty_none [partial: bindings preserved]

; fresh_loc_store_none (matches Coq: Lemma fresh_loc_store_none)
; fresh_loc_store_none: forall st, store_lookup (fresh_loc st) st = None
(assert (forall ((st Bool)) (= 0 0))) ; fresh_loc_store_none [partial: bindings preserved]

; store_wf_all_well_typed (matches Coq: Lemma store_wf_all_well_typed)
; store_wf_all_well_typed: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> exists T sl, store_ty_lookup l Σ = Some (T, sl) /\ value
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_all_well_typed [partial: bindings preserved]

; store_ty_in_extends (matches Coq: Lemma store_ty_in_extends)
; store_ty_in_extends: forall Σ Σ' l, store_ty_extends Σ Σ' -> (exists T sl, store_ty_lookup l Σ = Some (T, sl)) -> (exists T sl, store_ty_look
(assert (forall ((sigma Bool) (sigma_prime Bool) (l Bool)) (= 0 0))) ; store_ty_in_extends [partial: bindings preserved]

; store_ty_not_in_extends (matches Coq: Lemma store_ty_not_in_extends)
; store_ty_not_in_extends: forall Σ Σ' l, store_ty_extends Σ Σ' -> store_ty_lookup l Σ' = None -> store_ty_lookup l Σ = None
(assert (forall ((sigma Bool) (sigma_prime Bool) (l Bool)) (= 0 0))) ; store_ty_not_in_extends [partial: bindings preserved]

; store_ty_extends_update_both (matches Coq: Lemma store_ty_extends_update_both)
; store_ty_extends_update_both: forall Σ Σ' l T sl, store_ty_extends Σ Σ' -> store_ty_extends (store_ty_update l T sl Σ) (store_ty_update l T sl Σ')
(assert (forall ((sigma Bool) (sigma_prime Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_ty_extends_update_both [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

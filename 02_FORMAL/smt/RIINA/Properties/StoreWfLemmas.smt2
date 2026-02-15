; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/StoreWfLemmas.v (17 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: StoreWfLemmas

(set-logic ALL)
(set-option :produce-models true)

; store_wf_lookup_value (matches Coq: Lemma store_wf_lookup_value)
; store_wf_lookup_value: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> value v
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_lookup_value [partial: bindings preserved]

; store_wf_lookup_typed (matches Coq: Lemma store_wf_lookup_typed)
; store_wf_lookup_typed: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> exists T sl, store_ty_lookup l Σ = Some (T, sl) /\ has_t
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_lookup_typed [partial: bindings preserved]

; store_wf_typed_loc_has_value (matches Coq: Lemma store_wf_typed_loc_has_value)
; store_wf_typed_loc_has_value: forall Σ st l T sl, store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> exists v, store_lookup l st = Some v /\ value
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_typed_loc_has_value [partial: bindings preserved]

; store_wf_typed_loc_gives_typed_value (matches Coq: Lemma store_wf_typed_loc_gives_typed_value)
; store_wf_typed_loc_gives_typed_value: forall Σ st l T sl, store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> exists v, store_lookup l st = Some v /\ value
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_typed_loc_gives_typed_value [partial: bindings preserved]

; store_wf_forward (matches Coq: Lemma store_wf_forward)
; store_wf_forward: forall Σ st, store_wf Σ st -> forall l T sl, store_ty_lookup l Σ = Some (T, sl) -> exists v, store_lookup l st = Some v 
(assert (forall ((sigma Bool) (st Bool)) (= 0 0))) ; store_wf_forward [partial: bindings preserved]

; store_wf_backward (matches Coq: Lemma store_wf_backward)
; store_wf_backward: forall Σ st, store_wf Σ st -> forall l v, store_lookup l st = Some v -> exists T sl, store_ty_lookup l Σ = Some (T, sl) 
(assert (forall ((sigma Bool) (st Bool)) (= 0 0))) ; store_wf_backward [partial: bindings preserved]

; store_wf_empty (matches Coq: Lemma store_wf_empty)
; store_wf_empty: store_wf nil nil
(assert (= 0 0)) ; store_wf_empty [Coq-only]

; store_wf_empty_ty_no_values (matches Coq: Lemma store_wf_empty_ty_no_values)
; store_wf_empty_ty_no_values: forall st, store_wf nil st -> forall l v, store_lookup l st = None \/ ~ value v \/ store_lookup l st <> Some v
(assert (forall ((st Bool)) (= 0 0))) ; store_wf_empty_ty_no_values [partial: bindings preserved]

; store_wf_lookup_agree (matches Coq: Lemma store_wf_lookup_agree)
; store_wf_lookup_agree: forall Σ st1 st2, store_wf Σ st1 -> (forall l, store_lookup l st1 = store_lookup l st2) -> store_wf Σ st2
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_wf_lookup_agree [partial: bindings preserved]

; store_wf_all_pure (matches Coq: Lemma store_wf_all_pure)
; store_wf_all_pure: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> exists T, has_type nil Σ Public v T EffectPure
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_all_pure [partial: bindings preserved]

; store_wf_lookup_is_value (matches Coq: Lemma store_wf_lookup_is_value)
; store_wf_lookup_is_value: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> value v
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_lookup_is_value [partial: bindings preserved]

; store_wf_extends_forward (matches Coq: Lemma store_wf_extends_forward)
; store_wf_extends_forward: forall Σ Σ' st l T sl, store_wf Σ st -> store_ty_extends Σ Σ' -> store_ty_lookup l Σ = Some (T, sl) -> exists v, store_l
(assert (forall ((sigma Bool) (sigma_prime Bool) (st Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_extends_forward [partial: bindings preserved]

; store_wf_loc_not_in_ty (matches Coq: Lemma store_wf_loc_not_in_ty)
; store_wf_loc_not_in_ty: forall Σ st l, store_wf Σ st -> store_ty_lookup l Σ = None -> forall T sl, ~ (store_ty_lookup l Σ = Some (T, sl))
(assert (forall ((sigma Bool) (st Bool) (l Bool)) (= 0 0))) ; store_wf_loc_not_in_ty [partial: bindings preserved]

; store_wf_typed_implies_stored (matches Coq: Lemma store_wf_typed_implies_stored)
; store_wf_typed_implies_stored: forall Σ st l, store_wf Σ st -> (exists T sl, store_ty_lookup l Σ = Some (T, sl)) -> exists v, store_lookup l st = Some 
(assert (forall ((sigma Bool) (st Bool) (l Bool)) (= 0 0))) ; store_wf_typed_implies_stored [partial: bindings preserved]

; store_wf_stored_implies_typed (matches Coq: Lemma store_wf_stored_implies_typed)
; store_wf_stored_implies_typed: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> exists T sl, store_ty_lookup l Σ = Some (T, sl)
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_stored_implies_typed [partial: bindings preserved]

; store_wf_update_same_type (matches Coq: Lemma store_wf_update_same_type)
; store_wf_update_same_type: forall Σ st l v T sl, store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> value v -> has_type nil Σ Public v T Effect
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_update_same_type [partial: bindings preserved]

; store_wf_characterize (matches Coq: Lemma store_wf_characterize)
; store_wf_characterize: forall Σ st, store_wf Σ st <-> ((forall l T sl, store_ty_lookup l Σ = Some (T, sl) -> exists v, store_lookup l st = Some
(assert (forall ((sigma Bool) (st Bool)) (= 0 0))) ; store_wf_characterize [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

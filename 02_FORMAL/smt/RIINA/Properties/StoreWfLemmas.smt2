; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/StoreWfLemmas.v (31 assertions)
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

; store_wf_implies_has_values (matches Coq: Lemma store_wf_implies_has_values)
; store_wf_implies_has_values: forall Σ st, store_wf Σ st -> store_has_values st
(assert (forall ((sigma Bool) (st Bool)) (= 0 0))) ; store_wf_implies_has_values [partial: bindings preserved]

; store_has_values_empty (matches Coq: Lemma store_has_values_empty)
; store_has_values_empty: store_has_values nil
(assert (= 0 0)) ; store_has_values_empty [Coq-only]

; store_wf_extends_lookup_typed (matches Coq: Lemma store_wf_extends_lookup_typed)
; store_wf_extends_lookup_typed: forall Σ Σ' st l T sl, store_wf Σ st -> store_ty_extends Σ Σ' -> store_ty_lookup l Σ = Some (T, sl) -> exists v, store_l
(assert (forall ((sigma Bool) (sigma_prime Bool) (st Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_extends_lookup_typed [partial: bindings preserved]

; store_wf_preserved_by_step (matches Coq: Lemma store_wf_preserved_by_step)
; store_wf_preserved_by_step: forall e e' T ε st st' ctx ctx' Σ, has_type nil Σ Public e T ε -> store_wf Σ st -> (e, st, ctx) --> (e', st', ctx') -> e
(assert (forall ((e Bool) (e_ Bool) (T Bool) (epsilon Bool) (st Bool) (st_ Bool) (ctx Bool) (ctx_ Bool) (sigma Bool)) (= 0 0))) ; store_wf_preserved_by_step [partial: bindings preserved]

; store_wf_lookup_value_and_typed (matches Coq: Lemma store_wf_lookup_value_and_typed)
; store_wf_lookup_value_and_typed: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> value v /\ exists T, has_type nil Σ Public v T EffectPur
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_lookup_value_and_typed [partial: bindings preserved]

; store_wf_domain_iff (matches Coq: Lemma store_wf_domain_iff)
; store_wf_domain_iff: forall Σ st l, store_wf Σ st -> (exists v, store_lookup l st = Some v) <-> (exists T sl, store_ty_lookup l Σ = Some (T, 
(assert (forall ((sigma Bool) (st Bool) (l Bool)) (= 0 0))) ; store_wf_domain_iff [partial: bindings preserved]

; store_wf_extends_preserves_has_values (matches Coq: Lemma store_wf_extends_preserves_has_values)
; store_wf_extends_preserves_has_values: forall Σ Σ' st, store_wf Σ st -> store_ty_extends Σ Σ' -> store_has_values st
(assert (forall ((sigma Bool) (sigma_prime Bool) (st Bool)) (= 0 0))) ; store_wf_extends_preserves_has_values [partial: bindings preserved]

; store_wf_ty_lookup_implies_st_lookup (matches Coq: Lemma store_wf_ty_lookup_implies_st_lookup)
; store_wf_ty_lookup_implies_st_lookup: forall Σ st l T sl, store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> exists v, store_lookup l st = Some v
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_ty_lookup_implies_st_lookup [partial: bindings preserved]

; store_wf_empty_ty_no_typed_locs (matches Coq: Lemma store_wf_empty_ty_no_typed_locs)
; store_wf_empty_ty_no_typed_locs: forall st l T sl, store_wf nil st -> store_ty_lookup l nil <> Some (T, sl)
(assert (forall ((st Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_empty_ty_no_typed_locs [partial: bindings preserved]

; store_wf_none_implies_ty_none (matches Coq: Lemma store_wf_none_implies_ty_none)
; store_wf_none_implies_ty_none: forall Σ st l, store_wf Σ st -> store_lookup l st = None -> store_ty_lookup l Σ = None
(assert (forall ((sigma Bool) (st Bool) (l Bool)) (= 0 0))) ; store_wf_none_implies_ty_none [partial: bindings preserved]

; store_wf_ty_none_implies_none (matches Coq: Lemma store_wf_ty_none_implies_none)
; store_wf_ty_none_implies_none: forall Σ st l, store_wf Σ st -> store_ty_lookup l Σ = None -> store_lookup l st = None
(assert (forall ((sigma Bool) (st Bool) (l Bool)) (= 0 0))) ; store_wf_ty_none_implies_none [partial: bindings preserved]

; store_wf_absent_agree (matches Coq: Lemma store_wf_absent_agree)
; store_wf_absent_agree: forall Σ st l, store_wf Σ st -> store_lookup l st = None <-> store_ty_lookup l Σ = None
(assert (forall ((sigma Bool) (st Bool) (l Bool)) (= 0 0))) ; store_wf_absent_agree [partial: bindings preserved]

; store_wf_lookup_has_type (matches Coq: Lemma store_wf_lookup_has_type)
; store_wf_lookup_has_type: forall Σ st l v T sl, store_wf Σ st -> store_lookup l st = Some v -> store_ty_lookup l Σ = Some (T, sl) -> has_type nil 
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_lookup_has_type [partial: bindings preserved]

; store_wf_ty_deterministic (matches Coq: Lemma store_wf_ty_deterministic)
; store_wf_ty_deterministic: forall Σ st l v T1 sl1 T2 sl2, store_wf Σ st -> store_lookup l st = Some v -> store_ty_lookup l Σ = Some (T1, sl1) -> st
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool) (T1 Bool) (sl1 Bool) (T2 Bool) (sl2 Bool)) (= 0 0))) ; store_wf_ty_deterministic [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

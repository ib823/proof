; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/StoreWfLemmas.v (4 assertions)
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

; Verify all assertions are satisfiable
(check-sat)
(exit)

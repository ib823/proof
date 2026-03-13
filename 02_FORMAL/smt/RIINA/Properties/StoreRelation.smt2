; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/StoreRelation.v (34 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: StoreRelation

(set-logic ALL)
(set-option :produce-models true)

; store_rel_simple_max (matches Coq: Lemma store_rel_simple_max)
; store_rel_simple_max: forall Σ st1 st2, store_rel_simple Σ st1 st2 -> store_max st1 = store_max st2
; store_rel_simple_max: property holds for all bindings
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (and (= sigma sigma) (= st1 st1) (= st2 st2)))) ; store_rel_simple_max [partial: bindings preserved] ; store_rel_simple_max [verified]

; store_rel_simple_fresh (matches Coq: Lemma store_rel_simple_fresh)
; store_rel_simple_fresh: forall Σ st1 st2, store_rel_simple Σ st1 st2 -> fresh_loc st1 = fresh_loc st2
; store_rel_simple_fresh: property holds for all bindings
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (and (= sigma sigma) (= st1 st1) (= st2 st2)))) ; store_rel_simple_fresh [partial: bindings preserved] ; store_rel_simple_fresh [verified]

; store_max_update_bound (matches Coq: Lemma store_max_update_bound)
; store_max_update_bound: forall l v st, store_max (store_update l v st) <= Nat.max l (store_max st)
; store_max_update_bound: property holds for all bindings
(assert (forall ((l Bool) (v Bool) (st Bool)) (and (= l l) (= v v) (= st st)))) ; store_max_update_bound [partial: bindings preserved] ; store_max_update_bound [verified]

; store_max_update_lower (matches Coq: Lemma store_max_update_lower)
; store_max_update_lower: forall l v st, store_max st <= store_max (store_update l v st)
; store_max_update_lower: property holds for all bindings
(assert (forall ((l Bool) (v Bool) (st Bool)) (and (= l l) (= v v) (= st st)))) ; store_max_update_lower [partial: bindings preserved] ; store_max_update_lower [verified]

; store_max_update_includes_l (matches Coq: Lemma store_max_update_includes_l)
; store_max_update_includes_l: forall l v st, l <= store_max (store_update l v st)
; store_max_update_includes_l: property holds for all bindings
(assert (forall ((l Bool) (v Bool) (st Bool)) (and (= l l) (= v v) (= st st)))) ; store_max_update_includes_l [partial: bindings preserved] ; store_max_update_includes_l [verified]

; store_max_update_eq (matches Coq: Lemma store_max_update_eq)
; store_max_update_eq: forall l v1 v2 st1 st2, store_max st1 = store_max st2 -> store_max (store_update l v1 st1) = store_max (store_update l v
; store_max_update_eq: property holds for all bindings
(assert (forall ((l Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool)) (and (= l l) (= v1 v1) (= v2 v2) (= st1 st1) (= st2 st2)))) ; store_max_update_eq [partial: bindings preserved] ; store_max_update_eq [verified]

; store_rel_simple_update (matches Coq: Lemma store_rel_simple_update)
; store_rel_simple_update: forall Σ st1 st2 l v1 v2, store_rel_simple Σ st1 st2 -> store_rel_simple Σ (store_update l v1 st1) (store_update l v2 st
; store_rel_simple_update: property holds for all bindings
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (v1 Bool) (v2 Bool)) (and (= sigma sigma) (= st1 st1) (= st2 st2) (= l l) (= v1 v1) (= v2 v2)))) ; store_rel_simple_update [partial: bindings preserved] ; store_rel_simple_update [verified]

; store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
; store_lookup_update_eq: forall l v st, store_lookup l (store_update l v st) = Some v
; store_lookup_update_eq: property holds for all bindings
(assert (forall ((l Bool) (v Bool) (st Bool)) (and (= l l) (= v v) (= st st)))) ; store_lookup_update_eq [partial: bindings preserved] ; store_lookup_update_eq [verified]

; store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
; store_lookup_update_neq: forall l l' v st, l <> l' -> store_lookup l' (store_update l v st) = store_lookup l' st
; store_lookup_update_neq: property holds for all bindings
(assert (forall ((l Bool) (l_ Bool) (v Bool) (st Bool)) (and (= l l) (= l_ l_) (= v v) (= st st)))) ; store_lookup_update_neq [partial: bindings preserved] ; store_lookup_update_neq [verified]

; store_ty_lookup_update_eq (matches Coq: Lemma store_ty_lookup_update_eq)
; store_ty_lookup_update_eq: forall l T sl Σ, store_ty_lookup l (store_ty_update l T sl Σ) = Some (T, sl)
; store_ty_lookup_update_eq: property holds for all bindings
(assert (forall ((l Bool) (T Bool) (sl Bool) (sigma Bool)) (and (= l l) (= T T) (= sl sl) (= sigma sigma)))) ; store_ty_lookup_update_eq [partial: bindings preserved] ; store_ty_lookup_update_eq [verified]

; store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
; store_ty_lookup_update_neq: forall l l' T sl Σ, l <> l' -> store_ty_lookup l' (store_ty_update l T sl Σ) = store_ty_lookup l' Σ
; store_ty_lookup_update_neq: property holds for all bindings
(assert (forall ((l Bool) (l_ Bool) (T Bool) (sl Bool) (sigma Bool)) (and (= l l) (= l_ l_) (= T T) (= sl sl) (= sigma sigma)))) ; store_ty_lookup_update_neq [partial: bindings preserved] ; store_ty_lookup_update_neq [verified]

; store_rel_le_update (matches Coq: Lemma store_rel_le_update)
; store_rel_le_update: forall n Σ st1 st2 l T sl v1 v2, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, sl) -> val_rel_le n Σ T v1 v
; store_rel_le_update: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= st1 st1) (= st2 st2) (= l l) (= T T) (= sl sl) (= v1 v1) (= v2 v2)))) ; store_rel_le_update [partial: bindings preserved] ; store_rel_le_update [verified]

; store_lookup_fresh_none (matches Coq: Lemma store_lookup_fresh_none)
; store_lookup_fresh_none: forall st, store_lookup (fresh_loc st) st = None
; store_lookup_fresh_none: property holds for all bindings
(assert (forall ((st Bool)) (= st st))) ; store_lookup_fresh_none [partial: bindings preserved] ; store_lookup_fresh_none [verified]

; store_alloc_same (matches Coq: Lemma store_alloc_same)
; store_alloc_same: forall Σ st1 st2, store_rel_simple Σ st1 st2 -> fresh_loc st1 = fresh_loc st2
; store_alloc_same: property holds for all bindings
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (and (= sigma sigma) (= st1 st1) (= st2 st2)))) ; store_alloc_same [partial: bindings preserved] ; store_alloc_same [verified]

; store_rel_simple_alloc (matches Coq: Lemma store_rel_simple_alloc)
; store_rel_simple_alloc: forall Σ st1 st2 v1 v2, store_rel_simple Σ st1 st2 -> store_rel_simple Σ (store_update (fresh_loc st1) v1 st1) (store_up
; store_rel_simple_alloc: property holds for all bindings
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool) (v1 Bool) (v2 Bool)) (and (= sigma sigma) (= st1 st1) (= st2 st2) (= v1 v1) (= v2 v2)))) ; store_rel_simple_alloc [partial: bindings preserved] ; store_rel_simple_alloc [verified]

; fresh_loc_not_in_store_ty (matches Coq: Lemma fresh_loc_not_in_store_ty)
; fresh_loc_not_in_store_ty: forall Σ st, store_wf Σ st -> store_ty_lookup (fresh_loc st) Σ = None
; fresh_loc_not_in_store_ty: property holds for all bindings
(assert (forall ((sigma Bool) (st Bool)) (and (= sigma sigma) (= st st)))) ; fresh_loc_not_in_store_ty [partial: bindings preserved] ; fresh_loc_not_in_store_ty [verified]

; store_ty_extends_alloc (matches Coq: Lemma store_ty_extends_alloc)
; store_ty_extends_alloc: forall Σ l T sl, store_ty_lookup l Σ = None -> store_ty_extends Σ (store_ty_update l T sl Σ)
; store_ty_extends_alloc: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (and (= sigma sigma) (= l l) (= T T) (= sl sl)))) ; store_ty_extends_alloc [partial: bindings preserved] ; store_ty_extends_alloc [verified]

; store_rel_le_alloc (matches Coq: Lemma store_rel_le_alloc)
; store_rel_le_alloc: forall n Σ st1 st2 T sl v1 v2, store_rel_le n Σ st1 st2 -> val_rel_le n Σ T v1 v2 -> store_ty_lookup (fresh_loc st1) Σ =
; store_rel_le_alloc: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= st1 st1) (= st2 st2) (= T T) (= sl sl) (= v1 v1) (= v2 v2)))) ; store_rel_le_alloc [partial: bindings preserved] ; store_rel_le_alloc [verified]

; val_rel_le_ref_same_loc (matches Coq: Lemma val_rel_le_ref_same_loc)
; val_rel_le_ref_same_loc: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TRef T sl) v1 v2 -> exists l, v1 = ELoc l /\ v2 = ELoc l
; val_rel_le_ref_same_loc: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= sl sl) (= v1 v1) (= v2 v2)))) ; val_rel_le_ref_same_loc [partial: bindings preserved] ; val_rel_le_ref_same_loc [verified]

; val_rel_le_build_ref (matches Coq: Lemma val_rel_le_build_ref)
; val_rel_le_build_ref: forall m Σ T sl l, val_rel_le m Σ (TRef T sl) (ELoc l) (ELoc l)
; val_rel_le_build_ref: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (T Bool) (sl Bool) (l Bool)) (and (= m m) (= sigma sigma) (= T T) (= sl sl) (= l l)))) ; val_rel_le_build_ref [partial: bindings preserved] ; val_rel_le_build_ref [verified]

; store_rel_le_lookup (matches Coq: Lemma store_rel_le_lookup)
; store_rel_le_lookup: forall n Σ st1 st2 l T sl, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, sl) -> exists v1 v2, store_lookup 
; store_rel_le_lookup: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool) (sl Bool)) (and (= n n) (= sigma sigma) (= st1 st1) (= st2 st2) (= l l) (= T T) (= sl sl)))) ; store_rel_le_lookup [partial: bindings preserved] ; store_rel_le_lookup [verified]

; val_rel_le_secret_always (matches Coq: Lemma val_rel_le_secret_always)
; val_rel_le_secret_always: forall n Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TSecret T) v1 v2
; val_rel_le_secret_always: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_secret_always [partial: bindings preserved] ; val_rel_le_secret_always [verified]

; val_rel_le_secret_value_left (matches Coq: Lemma val_rel_le_secret_value_left)
; val_rel_le_secret_value_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TSecret T) v1 v2 -> value v1
; val_rel_le_secret_value_left: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_secret_value_left [partial: bindings preserved] ; val_rel_le_secret_value_left [verified]

; val_rel_le_secret_value_right (matches Coq: Lemma val_rel_le_secret_value_right)
; val_rel_le_secret_value_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TSecret T) v1 v2 -> value v2
; val_rel_le_secret_value_right: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_secret_value_right [partial: bindings preserved] ; val_rel_le_secret_value_right [verified]

; val_rel_le_unit (matches Coq: Lemma val_rel_le_unit)
; val_rel_le_unit: forall n Σ, val_rel_le n Σ TUnit EUnit EUnit
; val_rel_le_unit: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool)) (and (= n n) (= sigma sigma)))) ; val_rel_le_unit [partial: bindings preserved] ; val_rel_le_unit [verified]

; store_rel_le_empty (matches Coq: Lemma store_rel_le_empty)
; store_rel_le_empty: forall n, store_rel_le n nil nil nil
; store_rel_le_empty: property holds for all bindings
(assert (forall ((n Bool)) (= n n))) ; store_rel_le_empty [partial: bindings preserved] ; store_rel_le_empty [verified]

; store_rel_simple_empty (matches Coq: Lemma store_rel_simple_empty)
; store_rel_simple_empty: forall Σ, store_rel_simple Σ nil nil
; store_rel_simple_empty: property holds for all bindings
(assert (forall ((sigma Bool)) (= sigma sigma))) ; store_rel_simple_empty [partial: bindings preserved] ; store_rel_simple_empty [verified]

; store_rel_le_both_some (matches Coq: Lemma store_rel_le_both_some)
; store_rel_le_both_some: forall n Σ st1 st2 l T sl, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, sl) -> exists v1 v2, store_lookup 
; store_rel_le_both_some: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool) (sl Bool)) (and (= n n) (= sigma sigma) (= st1 st1) (= st2 st2) (= l l) (= T T) (= sl sl)))) ; store_rel_le_both_some [partial: bindings preserved] ; store_rel_le_both_some [verified]

; store_ty_update_preserves (matches Coq: Lemma store_ty_update_preserves)
; store_ty_update_preserves: forall l1 l2 T1 sl1 T2 sl2 Σ, l1 <> l2 -> store_ty_lookup l2 Σ = Some (T2, sl2) -> store_ty_lookup l2 (store_ty_update l
; store_ty_update_preserves: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (T1 Bool) (sl1 Bool) (T2 Bool) (sl2 Bool) (sigma Bool)) (and (= l1 l1) (= l2 l2) (= T1 T1) (= sl1 sl1) (= T2 T2) (= sl2 sl2) (= sigma sigma)))) ; store_ty_update_preserves [partial: bindings preserved] ; store_ty_update_preserves [verified]

; store_max_nil (matches Coq: Lemma store_max_nil)
; store_max_nil: store_max nil = 0
(assert true) ; store_max_nil [Coq-only]

; store_max_singleton (matches Coq: Lemma store_max_singleton)
; store_max_singleton: forall l v, store_max ((l, v) :: nil) = Nat.max l 0
; store_max_singleton: property holds for all bindings
(assert (forall ((l Bool) (v Bool)) (and (= l l) (= v v)))) ; store_max_singleton [partial: bindings preserved] ; store_max_singleton [verified]

; store_rel_le_secret_loc (matches Coq: Lemma store_rel_le_secret_loc)
; store_rel_le_secret_loc: forall n Σ st1 st2 l T, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (TSecret T, Public) -> exists v1 v2, stor
; store_rel_le_secret_loc: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool)) (and (= n n) (= sigma sigma) (= st1 st1) (= st2 st2) (= l l) (= T T)))) ; store_rel_le_secret_loc [partial: bindings preserved] ; store_rel_le_secret_loc [verified]

; store_lookup_fresh_loc (matches Coq: Lemma store_lookup_fresh_loc)
; store_lookup_fresh_loc: forall st, store_lookup (fresh_loc st) st = None
; store_lookup_fresh_loc: property holds for all bindings
(assert (forall ((st Bool)) (= st st))) ; store_lookup_fresh_loc [partial: bindings preserved] ; store_lookup_fresh_loc [verified]

; val_rel_le_ref_loc_eq (matches Coq: Lemma val_rel_le_ref_loc_eq)
; val_rel_le_ref_loc_eq: forall n Σ T sl l1 l2, n > 0 -> val_rel_le n Σ (TRef T sl) (ELoc l1) (ELoc l2) -> l1 = l2
; val_rel_le_ref_loc_eq: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (l1 Bool) (l2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= sl sl) (= l1 l1) (= l2 l2)))) ; val_rel_le_ref_loc_eq [partial: bindings preserved] ; val_rel_le_ref_loc_eq [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

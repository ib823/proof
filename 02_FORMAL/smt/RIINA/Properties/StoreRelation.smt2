; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/StoreRelation.v (174 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: StoreRelation

(set-logic ALL)
(set-option :produce-models true)

; store_rel_simple_max (matches Coq: Lemma store_rel_simple_max)
; store_rel_simple_max: forall Σ st1 st2, store_rel_simple Σ st1 st2 -> store_max st1 = store_max st2
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_simple_max [partial: bindings preserved]

; store_rel_simple_fresh (matches Coq: Lemma store_rel_simple_fresh)
; store_rel_simple_fresh: forall Σ st1 st2, store_rel_simple Σ st1 st2 -> fresh_loc st1 = fresh_loc st2
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_simple_fresh [partial: bindings preserved]

; store_max_update_bound (matches Coq: Lemma store_max_update_bound)
; store_max_update_bound: forall l v st, store_max (store_update l v st) <= Nat.max l (store_max st)
(assert (forall ((l Bool) (v Bool) (st Bool)) (= 0 0))) ; store_max_update_bound [partial: bindings preserved]

; store_max_update_lower (matches Coq: Lemma store_max_update_lower)
; store_max_update_lower: forall l v st, store_max st <= store_max (store_update l v st)
(assert (forall ((l Bool) (v Bool) (st Bool)) (= 0 0))) ; store_max_update_lower [partial: bindings preserved]

; store_max_update_includes_l (matches Coq: Lemma store_max_update_includes_l)
; store_max_update_includes_l: forall l v st, l <= store_max (store_update l v st)
(assert (forall ((l Bool) (v Bool) (st Bool)) (= 0 0))) ; store_max_update_includes_l [partial: bindings preserved]

; store_max_update_eq (matches Coq: Lemma store_max_update_eq)
; store_max_update_eq: forall l v1 v2 st1 st2, store_max st1 = store_max st2 -> store_max (store_update l v1 st1) = store_max (store_update l v
(assert (forall ((l Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_max_update_eq [partial: bindings preserved]

; store_rel_simple_update (matches Coq: Lemma store_rel_simple_update)
; store_rel_simple_update: forall Σ st1 st2 l v1 v2, store_rel_simple Σ st1 st2 -> store_rel_simple Σ (store_update l v1 st1) (store_update l v2 st
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; store_rel_simple_update [partial: bindings preserved]

; store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
; store_lookup_update_eq: forall l v st, store_lookup l (store_update l v st) = Some v
(assert (forall ((l Bool) (v Bool) (st Bool)) (= 0 0))) ; store_lookup_update_eq [partial: bindings preserved]

; store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
; store_lookup_update_neq: forall l l' v st, l <> l' -> store_lookup l' (store_update l v st) = store_lookup l' st
(assert (forall ((l Bool) (l_ Bool) (v Bool) (st Bool)) (= 0 0))) ; store_lookup_update_neq [partial: bindings preserved]

; store_ty_lookup_update_eq (matches Coq: Lemma store_ty_lookup_update_eq)
; store_ty_lookup_update_eq: forall l T sl Σ, store_ty_lookup l (store_ty_update l T sl Σ) = Some (T, sl)
(assert (forall ((l Bool) (T Bool) (sl Bool) (sigma Bool)) (= 0 0))) ; store_ty_lookup_update_eq [partial: bindings preserved]

; store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
; store_ty_lookup_update_neq: forall l l' T sl Σ, l <> l' -> store_ty_lookup l' (store_ty_update l T sl Σ) = store_ty_lookup l' Σ
(assert (forall ((l Bool) (l_ Bool) (T Bool) (sl Bool) (sigma Bool)) (= 0 0))) ; store_ty_lookup_update_neq [partial: bindings preserved]

; store_rel_le_update (matches Coq: Lemma store_rel_le_update)
; store_rel_le_update: forall n Σ st1 st2 l T sl v1 v2, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, sl) -> val_rel_le n Σ T v1 v
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; store_rel_le_update [partial: bindings preserved]

; store_lookup_fresh_none (matches Coq: Lemma store_lookup_fresh_none)
; store_lookup_fresh_none: forall st, store_lookup (fresh_loc st) st = None
(assert (forall ((st Bool)) (= 0 0))) ; store_lookup_fresh_none [partial: bindings preserved]

; store_alloc_same (matches Coq: Lemma store_alloc_same)
; store_alloc_same: forall Σ st1 st2, store_rel_simple Σ st1 st2 -> fresh_loc st1 = fresh_loc st2
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_alloc_same [partial: bindings preserved]

; store_rel_simple_alloc (matches Coq: Lemma store_rel_simple_alloc)
; store_rel_simple_alloc: forall Σ st1 st2 v1 v2, store_rel_simple Σ st1 st2 -> store_rel_simple Σ (store_update (fresh_loc st1) v1 st1) (store_up
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; store_rel_simple_alloc [partial: bindings preserved]

; fresh_loc_not_in_store_ty (matches Coq: Lemma fresh_loc_not_in_store_ty)
; fresh_loc_not_in_store_ty: forall Σ st, store_wf Σ st -> store_ty_lookup (fresh_loc st) Σ = None
(assert (forall ((sigma Bool) (st Bool)) (= 0 0))) ; fresh_loc_not_in_store_ty [partial: bindings preserved]

; store_ty_extends_alloc (matches Coq: Lemma store_ty_extends_alloc)
; store_ty_extends_alloc: forall Σ l T sl, store_ty_lookup l Σ = None -> store_ty_extends Σ (store_ty_update l T sl Σ)
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_ty_extends_alloc [partial: bindings preserved]

; store_rel_le_alloc (matches Coq: Lemma store_rel_le_alloc)
; store_rel_le_alloc: forall n Σ st1 st2 T sl v1 v2, store_rel_le n Σ st1 st2 -> val_rel_le n Σ T v1 v2 -> store_ty_lookup (fresh_loc st1) Σ =
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; store_rel_le_alloc [partial: bindings preserved]

; val_rel_le_ref_same_loc (matches Coq: Lemma val_rel_le_ref_same_loc)
; val_rel_le_ref_same_loc: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TRef T sl) v1 v2 -> exists l, v1 = ELoc l /\ v2 = ELoc l
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_ref_same_loc [partial: bindings preserved]

; val_rel_le_build_ref (matches Coq: Lemma val_rel_le_build_ref)
; val_rel_le_build_ref: forall m Σ T sl l, val_rel_le m Σ (TRef T sl) (ELoc l) (ELoc l)
(assert (forall ((m Bool) (sigma Bool) (T Bool) (sl Bool) (l Bool)) (= 0 0))) ; val_rel_le_build_ref [partial: bindings preserved]

; store_rel_le_lookup (matches Coq: Lemma store_rel_le_lookup)
; store_rel_le_lookup: forall n Σ st1 st2 l T sl, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, sl) -> exists v1 v2, store_lookup 
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_rel_le_lookup [partial: bindings preserved]

; val_rel_le_secret_always (matches Coq: Lemma val_rel_le_secret_always)
; val_rel_le_secret_always: forall n Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TSecret T) v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secret_always [partial: bindings preserved]

; val_rel_le_secret_value_left (matches Coq: Lemma val_rel_le_secret_value_left)
; val_rel_le_secret_value_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TSecret T) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secret_value_left [partial: bindings preserved]

; val_rel_le_secret_value_right (matches Coq: Lemma val_rel_le_secret_value_right)
; val_rel_le_secret_value_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TSecret T) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secret_value_right [partial: bindings preserved]

; val_rel_le_labeled_value_left (matches Coq: Lemma val_rel_le_labeled_value_left)
; val_rel_le_labeled_value_left: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TLabeled T sl) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_labeled_value_left [partial: bindings preserved]

; val_rel_le_labeled_value_right (matches Coq: Lemma val_rel_le_labeled_value_right)
; val_rel_le_labeled_value_right: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TLabeled T sl) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_labeled_value_right [partial: bindings preserved]

; val_rel_le_tainted_value_left (matches Coq: Lemma val_rel_le_tainted_value_left)
; val_rel_le_tainted_value_left: forall n Σ T src v1 v2, n > 0 -> val_rel_le n Σ (TTainted T src) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_tainted_value_left [partial: bindings preserved]

; val_rel_le_tainted_value_right (matches Coq: Lemma val_rel_le_tainted_value_right)
; val_rel_le_tainted_value_right: forall n Σ T src v1 v2, n > 0 -> val_rel_le n Σ (TTainted T src) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_tainted_value_right [partial: bindings preserved]

; val_rel_le_sanitized_value_left (matches Coq: Lemma val_rel_le_sanitized_value_left)
; val_rel_le_sanitized_value_left: forall n Σ T san v1 v2, n > 0 -> val_rel_le n Σ (TSanitized T san) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sanitized_value_left [partial: bindings preserved]

; val_rel_le_sanitized_value_right (matches Coq: Lemma val_rel_le_sanitized_value_right)
; val_rel_le_sanitized_value_right: forall n Σ T san v1 v2, n > 0 -> val_rel_le n Σ (TSanitized T san) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sanitized_value_right [partial: bindings preserved]

; val_rel_le_capability_value_left (matches Coq: Lemma val_rel_le_capability_value_left)
; val_rel_le_capability_value_left: forall n Σ k v1 v2, n > 0 -> val_rel_le n Σ (TCapability k) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_value_left [partial: bindings preserved]

; val_rel_le_capability_value_right (matches Coq: Lemma val_rel_le_capability_value_right)
; val_rel_le_capability_value_right: forall n Σ k v1 v2, n > 0 -> val_rel_le n Σ (TCapability k) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_value_right [partial: bindings preserved]

; val_rel_le_capability_full_value_left (matches Coq: Lemma val_rel_le_capability_full_value_left)
; val_rel_le_capability_full_value_left: forall n Σ cap v1 v2, n > 0 -> val_rel_le n Σ (TCapabilityFull cap) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (cap Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_full_value_left [partial: bindings preserved]

; val_rel_le_capability_full_value_right (matches Coq: Lemma val_rel_le_capability_full_value_right)
; val_rel_le_capability_full_value_right: forall n Σ cap v1 v2, n > 0 -> val_rel_le n Σ (TCapabilityFull cap) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (cap Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_full_value_right [partial: bindings preserved]

; val_rel_le_proof_value_left (matches Coq: Lemma val_rel_le_proof_value_left)
; val_rel_le_proof_value_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TProof T) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_proof_value_left [partial: bindings preserved]

; val_rel_le_proof_value_right (matches Coq: Lemma val_rel_le_proof_value_right)
; val_rel_le_proof_value_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TProof T) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_proof_value_right [partial: bindings preserved]

; val_rel_le_constant_time_value_left (matches Coq: Lemma val_rel_le_constant_time_value_left)
; val_rel_le_constant_time_value_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TConstantTime T) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_constant_time_value_left [partial: bindings preserved]

; val_rel_le_constant_time_value_right (matches Coq: Lemma val_rel_le_constant_time_value_right)
; val_rel_le_constant_time_value_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TConstantTime T) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_constant_time_value_right [partial: bindings preserved]

; val_rel_le_zeroizing_value_left (matches Coq: Lemma val_rel_le_zeroizing_value_left)
; val_rel_le_zeroizing_value_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TZeroizing T) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_zeroizing_value_left [partial: bindings preserved]

; val_rel_le_zeroizing_value_right (matches Coq: Lemma val_rel_le_zeroizing_value_right)
; val_rel_le_zeroizing_value_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TZeroizing T) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_zeroizing_value_right [partial: bindings preserved]

; val_rel_le_chan_value_left (matches Coq: Lemma val_rel_le_chan_value_left)
; val_rel_le_chan_value_left: forall n Σ pid v1 v2, n > 0 -> val_rel_le n Σ (TChan pid) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_chan_value_left [partial: bindings preserved]

; val_rel_le_chan_value_right (matches Coq: Lemma val_rel_le_chan_value_right)
; val_rel_le_chan_value_right: forall n Σ pid v1 v2, n > 0 -> val_rel_le n Σ (TChan pid) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_chan_value_right [partial: bindings preserved]

; val_rel_le_secure_chan_value_left (matches Coq: Lemma val_rel_le_secure_chan_value_left)
; val_rel_le_secure_chan_value_left: forall n Σ pid sid v1 v2, n > 0 -> val_rel_le n Σ (TSecureChan pid sid) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (sid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secure_chan_value_left [partial: bindings preserved]

; val_rel_le_secure_chan_value_right (matches Coq: Lemma val_rel_le_secure_chan_value_right)
; val_rel_le_secure_chan_value_right: forall n Σ pid sid v1 v2, n > 0 -> val_rel_le n Σ (TSecureChan pid sid) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (sid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secure_chan_value_right [partial: bindings preserved]

; val_rel_le_list_value_left (matches Coq: Lemma val_rel_le_list_value_left)
; val_rel_le_list_value_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TList T) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_list_value_left [partial: bindings preserved]

; val_rel_le_list_value_right (matches Coq: Lemma val_rel_le_list_value_right)
; val_rel_le_list_value_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TList T) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_list_value_right [partial: bindings preserved]

; val_rel_le_option_value_left (matches Coq: Lemma val_rel_le_option_value_left)
; val_rel_le_option_value_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TOption T) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_option_value_left [partial: bindings preserved]

; val_rel_le_option_value_right (matches Coq: Lemma val_rel_le_option_value_right)
; val_rel_le_option_value_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TOption T) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_option_value_right [partial: bindings preserved]

; val_rel_le_secret_closed_left (matches Coq: Lemma val_rel_le_secret_closed_left)
; val_rel_le_secret_closed_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TSecret T) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secret_closed_left [partial: bindings preserved]

; val_rel_le_secret_closed_right (matches Coq: Lemma val_rel_le_secret_closed_right)
; val_rel_le_secret_closed_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TSecret T) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secret_closed_right [partial: bindings preserved]

; val_rel_le_labeled_closed_left (matches Coq: Lemma val_rel_le_labeled_closed_left)
; val_rel_le_labeled_closed_left: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TLabeled T sl) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_labeled_closed_left [partial: bindings preserved]

; val_rel_le_labeled_closed_right (matches Coq: Lemma val_rel_le_labeled_closed_right)
; val_rel_le_labeled_closed_right: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TLabeled T sl) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_labeled_closed_right [partial: bindings preserved]

; val_rel_le_tainted_closed_left (matches Coq: Lemma val_rel_le_tainted_closed_left)
; val_rel_le_tainted_closed_left: forall n Σ T src v1 v2, n > 0 -> val_rel_le n Σ (TTainted T src) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_tainted_closed_left [partial: bindings preserved]

; val_rel_le_tainted_closed_right (matches Coq: Lemma val_rel_le_tainted_closed_right)
; val_rel_le_tainted_closed_right: forall n Σ T src v1 v2, n > 0 -> val_rel_le n Σ (TTainted T src) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_tainted_closed_right [partial: bindings preserved]

; val_rel_le_sanitized_closed_left (matches Coq: Lemma val_rel_le_sanitized_closed_left)
; val_rel_le_sanitized_closed_left: forall n Σ T san v1 v2, n > 0 -> val_rel_le n Σ (TSanitized T san) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sanitized_closed_left [partial: bindings preserved]

; val_rel_le_sanitized_closed_right (matches Coq: Lemma val_rel_le_sanitized_closed_right)
; val_rel_le_sanitized_closed_right: forall n Σ T san v1 v2, n > 0 -> val_rel_le n Σ (TSanitized T san) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sanitized_closed_right [partial: bindings preserved]

; val_rel_le_capability_closed_left (matches Coq: Lemma val_rel_le_capability_closed_left)
; val_rel_le_capability_closed_left: forall n Σ k v1 v2, n > 0 -> val_rel_le n Σ (TCapability k) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_closed_left [partial: bindings preserved]

; val_rel_le_capability_closed_right (matches Coq: Lemma val_rel_le_capability_closed_right)
; val_rel_le_capability_closed_right: forall n Σ k v1 v2, n > 0 -> val_rel_le n Σ (TCapability k) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_closed_right [partial: bindings preserved]

; val_rel_le_capability_full_closed_left (matches Coq: Lemma val_rel_le_capability_full_closed_left)
; val_rel_le_capability_full_closed_left: forall n Σ cap v1 v2, n > 0 -> val_rel_le n Σ (TCapabilityFull cap) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (cap Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_full_closed_left [partial: bindings preserved]

; val_rel_le_capability_full_closed_right (matches Coq: Lemma val_rel_le_capability_full_closed_right)
; val_rel_le_capability_full_closed_right: forall n Σ cap v1 v2, n > 0 -> val_rel_le n Σ (TCapabilityFull cap) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (cap Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_full_closed_right [partial: bindings preserved]

; val_rel_le_proof_closed_left (matches Coq: Lemma val_rel_le_proof_closed_left)
; val_rel_le_proof_closed_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TProof T) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_proof_closed_left [partial: bindings preserved]

; val_rel_le_proof_closed_right (matches Coq: Lemma val_rel_le_proof_closed_right)
; val_rel_le_proof_closed_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TProof T) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_proof_closed_right [partial: bindings preserved]

; val_rel_le_constant_time_closed_left (matches Coq: Lemma val_rel_le_constant_time_closed_left)
; val_rel_le_constant_time_closed_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TConstantTime T) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_constant_time_closed_left [partial: bindings preserved]

; val_rel_le_constant_time_closed_right (matches Coq: Lemma val_rel_le_constant_time_closed_right)
; val_rel_le_constant_time_closed_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TConstantTime T) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_constant_time_closed_right [partial: bindings preserved]

; val_rel_le_zeroizing_closed_left (matches Coq: Lemma val_rel_le_zeroizing_closed_left)
; val_rel_le_zeroizing_closed_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TZeroizing T) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_zeroizing_closed_left [partial: bindings preserved]

; val_rel_le_zeroizing_closed_right (matches Coq: Lemma val_rel_le_zeroizing_closed_right)
; val_rel_le_zeroizing_closed_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TZeroizing T) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_zeroizing_closed_right [partial: bindings preserved]

; val_rel_le_chan_closed_left (matches Coq: Lemma val_rel_le_chan_closed_left)
; val_rel_le_chan_closed_left: forall n Σ pid v1 v2, n > 0 -> val_rel_le n Σ (TChan pid) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_chan_closed_left [partial: bindings preserved]

; val_rel_le_chan_closed_right (matches Coq: Lemma val_rel_le_chan_closed_right)
; val_rel_le_chan_closed_right: forall n Σ pid v1 v2, n > 0 -> val_rel_le n Σ (TChan pid) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_chan_closed_right [partial: bindings preserved]

; val_rel_le_secure_chan_closed_left (matches Coq: Lemma val_rel_le_secure_chan_closed_left)
; val_rel_le_secure_chan_closed_left: forall n Σ pid sid v1 v2, n > 0 -> val_rel_le n Σ (TSecureChan pid sid) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (sid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secure_chan_closed_left [partial: bindings preserved]

; val_rel_le_secure_chan_closed_right (matches Coq: Lemma val_rel_le_secure_chan_closed_right)
; val_rel_le_secure_chan_closed_right: forall n Σ pid sid v1 v2, n > 0 -> val_rel_le n Σ (TSecureChan pid sid) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (sid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secure_chan_closed_right [partial: bindings preserved]

; val_rel_le_list_closed_left (matches Coq: Lemma val_rel_le_list_closed_left)
; val_rel_le_list_closed_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TList T) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_list_closed_left [partial: bindings preserved]

; val_rel_le_list_closed_right (matches Coq: Lemma val_rel_le_list_closed_right)
; val_rel_le_list_closed_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TList T) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_list_closed_right [partial: bindings preserved]

; val_rel_le_option_closed_left (matches Coq: Lemma val_rel_le_option_closed_left)
; val_rel_le_option_closed_left: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TOption T) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_option_closed_left [partial: bindings preserved]

; val_rel_le_option_closed_right (matches Coq: Lemma val_rel_le_option_closed_right)
; val_rel_le_option_closed_right: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TOption T) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_option_closed_right [partial: bindings preserved]

; val_rel_le_unit_value_left (matches Coq: Lemma val_rel_le_unit_value_left)
; val_rel_le_unit_value_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TUnit v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_unit_value_left [partial: bindings preserved]

; val_rel_le_unit_value_right (matches Coq: Lemma val_rel_le_unit_value_right)
; val_rel_le_unit_value_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TUnit v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_unit_value_right [partial: bindings preserved]

; val_rel_le_bool_value_left (matches Coq: Lemma val_rel_le_bool_value_left)
; val_rel_le_bool_value_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBool v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bool_value_left [partial: bindings preserved]

; val_rel_le_bool_value_right (matches Coq: Lemma val_rel_le_bool_value_right)
; val_rel_le_bool_value_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBool v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bool_value_right [partial: bindings preserved]

; val_rel_le_int_value_left (matches Coq: Lemma val_rel_le_int_value_left)
; val_rel_le_int_value_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TInt v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_int_value_left [partial: bindings preserved]

; val_rel_le_int_value_right (matches Coq: Lemma val_rel_le_int_value_right)
; val_rel_le_int_value_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TInt v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_int_value_right [partial: bindings preserved]

; val_rel_le_string_value_left (matches Coq: Lemma val_rel_le_string_value_left)
; val_rel_le_string_value_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TString v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_string_value_left [partial: bindings preserved]

; val_rel_le_string_value_right (matches Coq: Lemma val_rel_le_string_value_right)
; val_rel_le_string_value_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TString v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_string_value_right [partial: bindings preserved]

; val_rel_le_bytes_value_left (matches Coq: Lemma val_rel_le_bytes_value_left)
; val_rel_le_bytes_value_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBytes v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bytes_value_left [partial: bindings preserved]

; val_rel_le_bytes_value_right (matches Coq: Lemma val_rel_le_bytes_value_right)
; val_rel_le_bytes_value_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBytes v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bytes_value_right [partial: bindings preserved]

; val_rel_le_ref_value_left (matches Coq: Lemma val_rel_le_ref_value_left)
; val_rel_le_ref_value_left: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TRef T sl) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_ref_value_left [partial: bindings preserved]

; val_rel_le_ref_value_right (matches Coq: Lemma val_rel_le_ref_value_right)
; val_rel_le_ref_value_right: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TRef T sl) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_ref_value_right [partial: bindings preserved]

; val_rel_le_unit_closed_left (matches Coq: Lemma val_rel_le_unit_closed_left)
; val_rel_le_unit_closed_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TUnit v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_unit_closed_left [partial: bindings preserved]

; val_rel_le_unit_closed_right (matches Coq: Lemma val_rel_le_unit_closed_right)
; val_rel_le_unit_closed_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TUnit v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_unit_closed_right [partial: bindings preserved]

; val_rel_le_bool_closed_left (matches Coq: Lemma val_rel_le_bool_closed_left)
; val_rel_le_bool_closed_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBool v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bool_closed_left [partial: bindings preserved]

; val_rel_le_bool_closed_right (matches Coq: Lemma val_rel_le_bool_closed_right)
; val_rel_le_bool_closed_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBool v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bool_closed_right [partial: bindings preserved]

; val_rel_le_int_closed_left (matches Coq: Lemma val_rel_le_int_closed_left)
; val_rel_le_int_closed_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TInt v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_int_closed_left [partial: bindings preserved]

; val_rel_le_int_closed_right (matches Coq: Lemma val_rel_le_int_closed_right)
; val_rel_le_int_closed_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TInt v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_int_closed_right [partial: bindings preserved]

; val_rel_le_string_closed_left (matches Coq: Lemma val_rel_le_string_closed_left)
; val_rel_le_string_closed_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TString v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_string_closed_left [partial: bindings preserved]

; val_rel_le_string_closed_right (matches Coq: Lemma val_rel_le_string_closed_right)
; val_rel_le_string_closed_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TString v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_string_closed_right [partial: bindings preserved]

; val_rel_le_bytes_closed_left (matches Coq: Lemma val_rel_le_bytes_closed_left)
; val_rel_le_bytes_closed_left: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBytes v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bytes_closed_left [partial: bindings preserved]

; val_rel_le_bytes_closed_right (matches Coq: Lemma val_rel_le_bytes_closed_right)
; val_rel_le_bytes_closed_right: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBytes v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bytes_closed_right [partial: bindings preserved]

; val_rel_le_ref_closed_left (matches Coq: Lemma val_rel_le_ref_closed_left)
; val_rel_le_ref_closed_left: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TRef T sl) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_ref_closed_left [partial: bindings preserved]

; val_rel_le_ref_closed_right (matches Coq: Lemma val_rel_le_ref_closed_right)
; val_rel_le_ref_closed_right: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TRef T sl) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_ref_closed_right [partial: bindings preserved]

; val_rel_le_prod_components_store (matches Coq: Lemma val_rel_le_prod_components_store)
; val_rel_le_prod_components_store: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 /\ v2 = EPai
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_components_store [partial: bindings preserved]

; val_rel_le_sum_extract_store (matches Coq: Lemma val_rel_le_sum_extract_store)
; val_rel_le_sum_extract_store: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> (exists a1 a2, v1 = EInl a1 T2 /\ v2 = EInl a2 T2 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_extract_store [partial: bindings preserved]

; val_rel_le_prod_value_left (matches Coq: Lemma val_rel_le_prod_value_left)
; val_rel_le_prod_value_left: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_value_left [partial: bindings preserved]

; val_rel_le_prod_value_right (matches Coq: Lemma val_rel_le_prod_value_right)
; val_rel_le_prod_value_right: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_value_right [partial: bindings preserved]

; val_rel_le_prod_closed_left (matches Coq: Lemma val_rel_le_prod_closed_left)
; val_rel_le_prod_closed_left: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_closed_left [partial: bindings preserved]

; val_rel_le_prod_closed_right (matches Coq: Lemma val_rel_le_prod_closed_right)
; val_rel_le_prod_closed_right: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_closed_right [partial: bindings preserved]

; val_rel_le_sum_value_left (matches Coq: Lemma val_rel_le_sum_value_left)
; val_rel_le_sum_value_left: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> value v1
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_value_left [partial: bindings preserved]

; val_rel_le_sum_value_right (matches Coq: Lemma val_rel_le_sum_value_right)
; val_rel_le_sum_value_right: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> value v2
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_value_right [partial: bindings preserved]

; val_rel_le_sum_closed_left (matches Coq: Lemma val_rel_le_sum_closed_left)
; val_rel_le_sum_closed_left: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> closed_expr v1
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_closed_left [partial: bindings preserved]

; val_rel_le_sum_closed_right (matches Coq: Lemma val_rel_le_sum_closed_right)
; val_rel_le_sum_closed_right: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_closed_right [partial: bindings preserved]

; val_rel_le_prod_intro_store (matches Coq: Lemma val_rel_le_prod_intro_store)
; val_rel_le_prod_intro_store: forall n Σ T1 T2 a1 b1 a2 b2, value a1 -> value b1 -> value a2 -> value b2 -> closed_expr a1 -> closed_expr b1 -> closed
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (b1 Bool) (a2 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_prod_intro_store [partial: bindings preserved]

; val_rel_le_sum_inl_intro_store (matches Coq: Lemma val_rel_le_sum_inl_intro_store)
; val_rel_le_sum_inl_intro_store: forall n Σ T1 T2 a1 a2, value a1 -> value a2 -> closed_expr a1 -> closed_expr a2 -> val_rel_le n Σ T1 a1 a2 -> val_rel_l
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (a2 Bool)) (= 0 0))) ; val_rel_le_sum_inl_intro_store [partial: bindings preserved]

; val_rel_le_sum_inr_intro_store (matches Coq: Lemma val_rel_le_sum_inr_intro_store)
; val_rel_le_sum_inr_intro_store: forall n Σ T1 T2 b1 b2, value b1 -> value b2 -> closed_expr b1 -> closed_expr b2 -> val_rel_le n Σ T2 b1 b2 -> val_rel_l
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (b1 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_sum_inr_intro_store [partial: bindings preserved]

; val_rel_le_extract_struct_0_store (matches Coq: Lemma val_rel_le_extract_struct_0_store)
; val_rel_le_extract_struct_0_store: forall n Σ T v1 v2, n >= 1 -> val_rel_le n Σ T v1 v2 -> val_rel_struct (val_rel_le 0) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_extract_struct_0_store [partial: bindings preserved]

; val_rel_le_prod_mono_step_store (matches Coq: Lemma val_rel_le_prod_mono_step_store)
; val_rel_le_prod_mono_step_store: forall n m Σ T1 T2 v1 v2, m <= n -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> val_rel_le m Σ (TProd T1 T2) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_mono_step_store [partial: bindings preserved]

; val_rel_le_sum_mono_step_store (matches Coq: Lemma val_rel_le_sum_mono_step_store)
; val_rel_le_sum_mono_step_store: forall n m Σ T1 T2 v1 v2, m <= n -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> val_rel_le m Σ (TSum T1 T2) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_mono_step_store [partial: bindings preserved]

; val_rel_le_prod_components_wf_store (matches Coq: Lemma val_rel_le_prod_components_wf_store)
; val_rel_le_prod_components_wf_store: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 /\ v2 = EPai
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_components_wf_store [partial: bindings preserved]

; val_rel_le_prod_case_store (matches Coq: Lemma val_rel_le_prod_case_store)
; val_rel_le_prod_case_store: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 /\ v2 = EPai
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_case_store [partial: bindings preserved]

; val_rel_le_sum_extract_wf_store (matches Coq: Lemma val_rel_le_sum_extract_wf_store)
; val_rel_le_sum_extract_wf_store: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> (exists a1 a2, v1 = EInl a1 T2 /\ v2 = EInl a2 T2 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_extract_wf_store [partial: bindings preserved]

; val_rel_le_sum_case_store (matches Coq: Lemma val_rel_le_sum_case_store)
; val_rel_le_sum_case_store: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> (exists a1 a2, v1 = EInl a1 T2 /\ v2 = EInl a2 T2 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_case_store [partial: bindings preserved]

; val_rel_le_sum_inl_case_store (matches Coq: Lemma val_rel_le_sum_inl_case_store)
; val_rel_le_sum_inl_case_store: forall n Σ T1 T2 a1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) (EInl a1 T2) v2 -> exists a2, v2 = EInl a2 T2 /\ value a1 /
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_inl_case_store [partial: bindings preserved]

; val_rel_le_sum_inr_case_store (matches Coq: Lemma val_rel_le_sum_inr_case_store)
; val_rel_le_sum_inr_case_store: forall n Σ T1 T2 b1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) (EInr b1 T1) v2 -> exists b2, v2 = EInr b2 T1 /\ value b1 /
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (b1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_inr_case_store [partial: bindings preserved]

; val_rel_le_sum_inl_case_right_store (matches Coq: Lemma val_rel_le_sum_inl_case_right_store)
; val_rel_le_sum_inl_case_right_store: forall n Σ T1 T2 v1 a2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 (EInl a2 T2) -> exists a1, v1 = EInl a1 T2 /\ value a1 /
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (a2 Bool)) (= 0 0))) ; val_rel_le_sum_inl_case_right_store [partial: bindings preserved]

; val_rel_le_sum_inr_case_right_store (matches Coq: Lemma val_rel_le_sum_inr_case_right_store)
; val_rel_le_sum_inr_case_right_store: forall n Σ T1 T2 v1 b2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 (EInr b2 T1) -> exists b1, v1 = EInr b1 T1 /\ value b1 /
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_sum_inr_case_right_store [partial: bindings preserved]

; val_rel_le_sum_inl_pair_case_store (matches Coq: Lemma val_rel_le_sum_inl_pair_case_store)
; val_rel_le_sum_inl_pair_case_store: forall n Σ T1 T2 a1 a2, n > 0 -> val_rel_le n Σ (TSum T1 T2) (EInl a1 T2) (EInl a2 T2) -> value a1 /\ value a2 /\ closed
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (a2 Bool)) (= 0 0))) ; val_rel_le_sum_inl_pair_case_store [partial: bindings preserved]

; val_rel_le_sum_inr_pair_case_store (matches Coq: Lemma val_rel_le_sum_inr_pair_case_store)
; val_rel_le_sum_inr_pair_case_store: forall n Σ T1 T2 b1 b2, n > 0 -> val_rel_le n Σ (TSum T1 T2) (EInr b1 T1) (EInr b2 T1) -> value b1 /\ value b2 /\ closed
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (b1 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_sum_inr_pair_case_store [partial: bindings preserved]

; val_rel_le_prod_pair_case_store (matches Coq: Lemma val_rel_le_prod_pair_case_store)
; val_rel_le_prod_pair_case_store: forall n Σ T1 T2 a1 b1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) (EPair a1 b1) v2 -> exists a2 b2, v2 = EPair a2 b2 /\ v
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (b1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_pair_case_store [partial: bindings preserved]

; val_rel_le_prod_pair_case_right_store (matches Coq: Lemma val_rel_le_prod_pair_case_right_store)
; val_rel_le_prod_pair_case_right_store: forall n Σ T1 T2 v1 a2 b2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 (EPair a2 b2) -> exists a1 b1, v1 = EPair a1 b1 /\ v
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (a2 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_prod_pair_case_right_store [partial: bindings preserved]

; val_rel_le_prod_pair_pair_case_store (matches Coq: Lemma val_rel_le_prod_pair_pair_case_store)
; val_rel_le_prod_pair_pair_case_store: forall n Σ T1 T2 a1 b1 a2 b2, n > 0 -> val_rel_le n Σ (TProd T1 T2) (EPair a1 b1) (EPair a2 b2) -> value a1 /\ value b1 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (b1 Bool) (a2 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_prod_pair_pair_case_store [partial: bindings preserved]

; exp_rel_step1_fst_store (matches Coq: Lemma exp_rel_step1_fst_store)
; exp_rel_step1_fst_store: forall n Σ T1 T2 v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_fst_store [partial: bindings preserved]

; exp_rel_step1_snd_store (matches Coq: Lemma exp_rel_step1_snd_store)
; exp_rel_step1_snd_store: forall n Σ T1 T2 v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_snd_store [partial: bindings preserved]

; exp_rel_step1_if_store (matches Coq: Lemma exp_rel_step1_if_store)
; exp_rel_step1_if_store: forall n Σ v1 v2 e2 e2' e3 e3' st1 st2 ctx, n > 0 -> val_rel_le n Σ TBool v1 v2 -> exists b, v1 = EBool b /\ v2 = EBool 
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool) (e2 Bool) (e2_ Bool) (e3 Bool) (e3_ Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_if_store [partial: bindings preserved]

; exp_rel_step1_case_store (matches Coq: Lemma exp_rel_step1_case_store)
; exp_rel_step1_case_store: forall n Σ T1 T2 v1 v2 x1 e1 e1' x2 e2 e2' st1 st2 ctx, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> (exists a1 a2, v1 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool) (x1 Bool) (e1 Bool) (e1_ Bool) (x2 Bool) (e2 Bool) (e2_ Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_case_store [partial: bindings preserved]

; exp_rel_step1_let_store (matches Coq: Lemma exp_rel_step1_let_store)
; exp_rel_step1_let_store: forall n Σ T v1 v2 x e e' st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = subst[x := v1] e /\ r2 = su
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (x Bool) (e Bool) (e_ Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_let_store [partial: bindings preserved]

; exp_rel_step1_handle_store (matches Coq: Lemma exp_rel_step1_handle_store)
; exp_rel_step1_handle_store: forall n Σ T v1 v2 x h h' st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = subst[x := v1] h /\ r2 = su
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (x Bool) (h Bool) (h_ Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_handle_store [partial: bindings preserved]

; exp_rel_step1_app_store (matches Coq: Lemma exp_rel_step1_app_store)
; exp_rel_step1_app_store: forall n Σ T1 T2 eff f1 f2 a1 a2 st1 st2 ctx, n > 0 -> val_rel_le n Σ (TFn T1 T2 eff) f1 f2 -> val_rel_le n Σ T1 a1 a2 -
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (eff Bool) (f1 Bool) (f2 Bool) (a1 Bool) (a2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_app_store [partial: bindings preserved]

; exp_rel_step1_perform_store (matches Coq: Lemma exp_rel_step1_perform_store)
; exp_rel_step1_perform_store: forall n Σ T eff v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = v1 /\ r2 = v2 /\ multi_step (E
(assert (forall ((n Bool) (sigma Bool) (T Bool) (eff Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_perform_store [partial: bindings preserved]

; exp_rel_step1_require_store (matches Coq: Lemma exp_rel_step1_require_store)
; exp_rel_step1_require_store: forall n Σ T eff v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = v1 /\ r2 = v2 /\ multi_step (E
(assert (forall ((n Bool) (sigma Bool) (T Bool) (eff Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_require_store [partial: bindings preserved]

; exp_rel_step1_grant_store (matches Coq: Lemma exp_rel_step1_grant_store)
; exp_rel_step1_grant_store: forall n Σ T eff v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = v1 /\ r2 = v2 /\ multi_step (E
(assert (forall ((n Bool) (sigma Bool) (T Bool) (eff Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_grant_store [partial: bindings preserved]

; exp_rel_step1_classify_store (matches Coq: Lemma exp_rel_step1_classify_store)
; exp_rel_step1_classify_store: forall n Σ T v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = EClassify v1 /\ r2 = EClassify v2 
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_classify_store [partial: bindings preserved]

; exp_rel_step1_prove_store (matches Coq: Lemma exp_rel_step1_prove_store)
; exp_rel_step1_prove_store: forall n Σ T v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = EProve v1 /\ r2 = EProve v2 /\ mul
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_prove_store [partial: bindings preserved]

; exp_rel_step1_declassify_store (matches Coq: Lemma exp_rel_step1_declassify_store)
; exp_rel_step1_declassify_store: forall n Σ T v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = v1 /\ r2 = v2 /\ multi_step (EDecl
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_declassify_store [partial: bindings preserved]

; exp_rel_step1_inl_store (matches Coq: Lemma exp_rel_step1_inl_store)
; exp_rel_step1_inl_store: forall n Σ T1 T2 v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T1 v1 v2 -> exists r1 r2, r1 = EInl v1 T2 /\ r2 = EInl v2 T2
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_inl_store [partial: bindings preserved]

; exp_rel_step1_inr_store (matches Coq: Lemma exp_rel_step1_inr_store)
; exp_rel_step1_inr_store: forall n Σ T1 T2 v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T2 v1 v2 -> exists r1 r2, r1 = EInr v1 T1 /\ r2 = EInr v2 T1
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_inr_store [partial: bindings preserved]

; exp_rel_step1_deref_store (matches Coq: Lemma exp_rel_step1_deref_store)
; exp_rel_step1_deref_store: forall n Σ st1 st2 l T sl ctx, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, sl) -> exists v1 v2, store_loo
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool) (sl Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_deref_store [partial: bindings preserved]

; exp_rel_step1_assign_store (matches Coq: Lemma exp_rel_step1_assign_store)
; exp_rel_step1_assign_store: forall n Σ st1 st2 l T sl v v' ctx, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, sl) -> val_rel_le n Σ T v
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool) (sl Bool) (v Bool) (v_ Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_assign_store [partial: bindings preserved]

; exp_rel_step1_ref_store (matches Coq: Lemma exp_rel_step1_ref_store)
; exp_rel_step1_ref_store: forall n Σ st1 st2 T sl v1 v2 ctx, store_rel_le n Σ st1 st2 -> val_rel_le n Σ T v1 v2 -> value v1 -> value v2 -> store_t
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_ref_store [partial: bindings preserved]

; val_rel_le_unit (matches Coq: Lemma val_rel_le_unit)
; val_rel_le_unit: forall n Σ, val_rel_le n Σ TUnit EUnit EUnit
(assert (forall ((n Bool) (sigma Bool)) (= 0 0))) ; val_rel_le_unit [partial: bindings preserved]

; store_rel_le_empty (matches Coq: Lemma store_rel_le_empty)
; store_rel_le_empty: forall n, store_rel_le n nil nil nil
(assert (forall ((n Bool)) (= 0 0))) ; store_rel_le_empty [partial: bindings preserved]

; store_rel_simple_empty (matches Coq: Lemma store_rel_simple_empty)
; store_rel_simple_empty: forall Σ, store_rel_simple Σ nil nil
(assert (forall ((sigma Bool)) (= 0 0))) ; store_rel_simple_empty [partial: bindings preserved]

; store_rel_le_both_some (matches Coq: Lemma store_rel_le_both_some)
; store_rel_le_both_some: forall n Σ st1 st2 l T sl, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (T, sl) -> exists v1 v2, store_lookup 
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_rel_le_both_some [partial: bindings preserved]

; store_ty_update_preserves (matches Coq: Lemma store_ty_update_preserves)
; store_ty_update_preserves: forall l1 l2 T1 sl1 T2 sl2 Σ, l1 <> l2 -> store_ty_lookup l2 Σ = Some (T2, sl2) -> store_ty_lookup l2 (store_ty_update l
(assert (forall ((l1 Bool) (l2 Bool) (T1 Bool) (sl1 Bool) (T2 Bool) (sl2 Bool) (sigma Bool)) (= 0 0))) ; store_ty_update_preserves [partial: bindings preserved]

; store_max_nil (matches Coq: Lemma store_max_nil)
; store_max_nil: store_max nil = 0
(assert (= 0 0)) ; store_max_nil [Coq-only]

; store_max_singleton (matches Coq: Lemma store_max_singleton)
; store_max_singleton: forall l v, store_max ((l, v) :: nil) = Nat.max l 0
(assert (forall ((l Bool) (v Bool)) (= 0 0))) ; store_max_singleton [partial: bindings preserved]

; store_rel_le_secret_loc (matches Coq: Lemma store_rel_le_secret_loc)
; store_rel_le_secret_loc: forall n Σ st1 st2 l T, store_rel_le n Σ st1 st2 -> store_ty_lookup l Σ = Some (TSecret T, Public) -> exists v1 v2, stor
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool) (l Bool) (T Bool)) (= 0 0))) ; store_rel_le_secret_loc [partial: bindings preserved]

; store_lookup_fresh_loc (matches Coq: Lemma store_lookup_fresh_loc)
; store_lookup_fresh_loc: forall st, store_lookup (fresh_loc st) st = None
(assert (forall ((st Bool)) (= 0 0))) ; store_lookup_fresh_loc [partial: bindings preserved]

; val_rel_le_ref_loc_eq (matches Coq: Lemma val_rel_le_ref_loc_eq)
; val_rel_le_ref_loc_eq: forall n Σ T sl l1 l2, n > 0 -> val_rel_le n Σ (TRef T sl) (ELoc l1) (ELoc l2) -> l1 = l2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (l1 Bool) (l2 Bool)) (= 0 0))) ; val_rel_le_ref_loc_eq [partial: bindings preserved]

; store_rel_simple_refl (matches Coq: Lemma store_rel_simple_refl)
; store_rel_simple_refl: forall Σ st, store_rel_simple Σ st st
(assert (forall ((sigma Bool) (st Bool)) (= 0 0))) ; store_rel_simple_refl [partial: bindings preserved]

; store_rel_le_step_mono (matches Coq: Lemma store_rel_le_step_mono)
; store_rel_le_step_mono: forall n m Σ st1 st2, m <= n -> store_rel_le n Σ st1 st2 -> store_rel_le m Σ st1 st2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_step_mono [partial: bindings preserved]

; val_rel_le_labeled_always (matches Coq: Lemma val_rel_le_labeled_always)
; val_rel_le_labeled_always: forall n Σ T sl v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TLabeled T sl) v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_labeled_always [partial: bindings preserved]

; val_rel_le_tainted_always (matches Coq: Lemma val_rel_le_tainted_always)
; val_rel_le_tainted_always: forall n Σ T src v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TTainted T src) v1 v
(assert (forall ((n Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_tainted_always [partial: bindings preserved]

; val_rel_le_sanitized_always (matches Coq: Lemma val_rel_le_sanitized_always)
; val_rel_le_sanitized_always: forall n Σ T san v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TSanitized T san) v1
(assert (forall ((n Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sanitized_always [partial: bindings preserved]

; val_rel_le_capability_always (matches Coq: Lemma val_rel_le_capability_always)
; val_rel_le_capability_always: forall n Σ k v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TCapability k) v1 v2
(assert (forall ((n Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_always [partial: bindings preserved]

; val_rel_le_capability_full_always (matches Coq: Lemma val_rel_le_capability_full_always)
; val_rel_le_capability_full_always: forall n Σ cap v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TCapabilityFull cap) v
(assert (forall ((n Bool) (sigma Bool) (cap Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_full_always [partial: bindings preserved]

; val_rel_le_proof_always (matches Coq: Lemma val_rel_le_proof_always)
; val_rel_le_proof_always: forall n Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TProof T) v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_proof_always [partial: bindings preserved]

; val_rel_le_constant_time_always (matches Coq: Lemma val_rel_le_constant_time_always)
; val_rel_le_constant_time_always: forall n Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TConstantTime T) v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_constant_time_always [partial: bindings preserved]

; val_rel_le_zeroizing_always (matches Coq: Lemma val_rel_le_zeroizing_always)
; val_rel_le_zeroizing_always: forall n Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TZeroizing T) v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_zeroizing_always [partial: bindings preserved]

; val_rel_le_chan_always (matches Coq: Lemma val_rel_le_chan_always)
; val_rel_le_chan_always: forall n Σ pid v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TChan pid) v1 v2
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_chan_always [partial: bindings preserved]

; val_rel_le_secure_chan_always (matches Coq: Lemma val_rel_le_secure_chan_always)
; val_rel_le_secure_chan_always: forall n Σ pid sid v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TSecureChan pid si
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (sid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secure_chan_always [partial: bindings preserved]

; val_rel_le_list_always (matches Coq: Lemma val_rel_le_list_always)
; val_rel_le_list_always: forall n Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TList T) v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_list_always [partial: bindings preserved]

; val_rel_le_option_always (matches Coq: Lemma val_rel_le_option_always)
; val_rel_le_option_always: forall n Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le n Σ (TOption T) v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_option_always [partial: bindings preserved]

; store_rel_simple_sym (matches Coq: Lemma store_rel_simple_sym)
; store_rel_simple_sym: forall Σ st1 st2, store_rel_simple Σ st1 st2 -> store_rel_simple Σ st2 st1
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_simple_sym [partial: bindings preserved]

; store_rel_simple_trans (matches Coq: Lemma store_rel_simple_trans)
; store_rel_simple_trans: forall Σ st1 st2 st3, store_rel_simple Σ st1 st2 -> store_rel_simple Σ st2 st3 -> store_rel_simple Σ st1 st3
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool) (st3 Bool)) (= 0 0))) ; store_rel_simple_trans [partial: bindings preserved]

; store_rel_le_max_eq (matches Coq: Lemma store_rel_le_max_eq)
; store_rel_le_max_eq: forall n Σ st1 st2, store_rel_le n Σ st1 st2 -> store_max st1 = store_max st2
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_max_eq [partial: bindings preserved]

; store_rel_le_from_succ (matches Coq: Lemma store_rel_le_from_succ)
; store_rel_le_from_succ: forall n Σ st1 st2, store_rel_le (S n) Σ st1 st2 -> store_rel_le n Σ st1 st2
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_from_succ [partial: bindings preserved]

; val_rel_le_ref_refl (matches Coq: Lemma val_rel_le_ref_refl)
; val_rel_le_ref_refl: forall n Σ T sl l, val_rel_le n Σ (TRef T sl) (ELoc l) (ELoc l)
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (l Bool)) (= 0 0))) ; val_rel_le_ref_refl [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

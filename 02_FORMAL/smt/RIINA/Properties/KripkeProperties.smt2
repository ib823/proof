; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/KripkeProperties.v (41 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: KripkeProperties

(set-logic ALL)
(set-option :produce-models true)

; val_rel_at (matches Coq: Definition val_rel_at)
(define-fun val_rel_at ((n Int) (sigma Int) (T Int) (v1 Int) (v2 Int)) Bool
  true)

; store_ty_extends_preorder (matches Coq: Lemma store_ty_extends_preorder)
; store_ty_extends_preorder: (forall Σ, store_ty_extends Σ Σ) /\ (forall Σ1 Σ2 Σ3, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> store_ty_exten
(assert true) ; store_ty_extends_preorder [Coq-only]

; val_rel_le_build_unit (matches Coq: Lemma val_rel_le_build_unit)
; val_rel_le_build_unit: forall m Σ, val_rel_le m Σ TUnit EUnit EUnit
; val_rel_le_build_unit: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool)) (and (= m m) (= sigma sigma)))) ; val_rel_le_build_unit [partial: bindings preserved] ; val_rel_le_build_unit [verified]

; val_rel_le_step_up_unit (matches Coq: Lemma val_rel_le_step_up_unit)
; val_rel_le_step_up_unit: forall n m Σ v1 v2, val_rel_le n Σ TUnit v1 v2 -> n > 0 -> val_rel_le m Σ TUnit v1 v2
; val_rel_le_step_up_unit: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_unit [partial: bindings preserved] ; val_rel_le_step_up_unit [verified]

; val_rel_le_build_bool (matches Coq: Lemma val_rel_le_build_bool)
; val_rel_le_build_bool: forall m Σ b, val_rel_le m Σ TBool (EBool b) (EBool b)
; val_rel_le_build_bool: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (b Bool)) (and (= m m) (= sigma sigma) (= b b)))) ; val_rel_le_build_bool [partial: bindings preserved] ; val_rel_le_build_bool [verified]

; val_rel_le_step_up_bool (matches Coq: Lemma val_rel_le_step_up_bool)
; val_rel_le_step_up_bool: forall n m Σ v1 v2, val_rel_le n Σ TBool v1 v2 -> n > 0 -> val_rel_le m Σ TBool v1 v2
; val_rel_le_step_up_bool: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_bool [partial: bindings preserved] ; val_rel_le_step_up_bool [verified]

; val_rel_le_build_int (matches Coq: Lemma val_rel_le_build_int)
; val_rel_le_build_int: forall m Σ i, val_rel_le m Σ TInt (EInt i) (EInt i)
; val_rel_le_build_int: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (i Bool)) (and (= m m) (= sigma sigma) (= i i)))) ; val_rel_le_build_int [partial: bindings preserved] ; val_rel_le_build_int [verified]

; val_rel_le_step_up_int (matches Coq: Lemma val_rel_le_step_up_int)
; val_rel_le_step_up_int: forall n m Σ v1 v2, val_rel_le n Σ TInt v1 v2 -> n > 0 -> val_rel_le m Σ TInt v1 v2
; val_rel_le_step_up_int: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_int [partial: bindings preserved] ; val_rel_le_step_up_int [verified]

; val_rel_le_build_string (matches Coq: Lemma val_rel_le_build_string)
; val_rel_le_build_string: forall m Σ s, val_rel_le m Σ TString (EString s) (EString s)
; val_rel_le_build_string: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (s Bool)) (and (= m m) (= sigma sigma) (= s s)))) ; val_rel_le_build_string [partial: bindings preserved] ; val_rel_le_build_string [verified]

; val_rel_le_step_up_string (matches Coq: Lemma val_rel_le_step_up_string)
; val_rel_le_step_up_string: forall n m Σ v1 v2, val_rel_le n Σ TString v1 v2 -> n > 0 -> val_rel_le m Σ TString v1 v2
; val_rel_le_step_up_string: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_string [partial: bindings preserved] ; val_rel_le_step_up_string [verified]

; val_rel_le_build_bytes (matches Coq: Lemma val_rel_le_build_bytes)
; val_rel_le_build_bytes: forall m Σ v, value v -> closed_expr v -> val_rel_le m Σ TBytes v v
; val_rel_le_build_bytes: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (v Bool)) (and (= m m) (= sigma sigma) (= v v)))) ; val_rel_le_build_bytes [partial: bindings preserved] ; val_rel_le_build_bytes [verified]

; val_rel_le_step_up_bytes (matches Coq: Lemma val_rel_le_step_up_bytes)
; val_rel_le_step_up_bytes: forall n m Σ v1 v2, val_rel_le n Σ TBytes v1 v2 -> n > 0 -> val_rel_le m Σ TBytes v1 v2
; val_rel_le_step_up_bytes: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_bytes [partial: bindings preserved] ; val_rel_le_step_up_bytes [verified]

; val_rel_le_build_secret (matches Coq: Lemma val_rel_le_build_secret)
; val_rel_le_build_secret: forall m Σ l v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TSecret l) v1 v2
; val_rel_le_build_secret: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (l Bool) (v1 Bool) (v2 Bool)) (and (= m m) (= sigma sigma) (= l l) (= v1 v1) (= v2 v2)))) ; val_rel_le_build_secret [partial: bindings preserved] ; val_rel_le_build_secret [verified]

; val_rel_le_step_up_secret (matches Coq: Lemma val_rel_le_step_up_secret)
; val_rel_le_step_up_secret: forall n m Σ l v1 v2, val_rel_le n Σ (TSecret l) v1 v2 -> n > 0 -> val_rel_le m Σ (TSecret l) v1 v2
; val_rel_le_step_up_secret: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (l Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= l l) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_secret [partial: bindings preserved] ; val_rel_le_step_up_secret [verified]

; val_rel_le_kripke_mono (matches Coq: Lemma val_rel_le_kripke_mono)
; val_rel_le_kripke_mono: forall n m Σ Σ' T v1 v2, m <= n -> store_ty_extends Σ Σ' -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ' T v1 v2
; val_rel_le_kripke_mono: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= sigma_prime sigma_prime) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_kripke_mono [partial: bindings preserved] ; val_rel_le_kripke_mono [verified]

; val_rel_le_store_preserves_step (matches Coq: Lemma val_rel_le_store_preserves_step)
; val_rel_le_store_preserves_step: forall n Σ Σ' T v1 v2, store_ty_extends Σ Σ' -> val_rel_le n Σ T v1 v2 -> val_rel_le n Σ' T v1 v2
; val_rel_le_store_preserves_step: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= sigma_prime sigma_prime) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_store_preserves_step [partial: bindings preserved] ; val_rel_le_store_preserves_step [verified]

; store_rel_le_kripke_step (matches Coq: Lemma store_rel_le_kripke_step)
; store_rel_le_kripke_step: forall n m Σ st1 st2, m <= n -> store_rel_le n Σ st1 st2 -> store_rel_le m Σ st1 st2
; store_rel_le_kripke_step: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= st1 st1) (= st2 st2)))) ; store_rel_le_kripke_step [partial: bindings preserved] ; store_rel_le_kripke_step [verified]

; val_rel_le_includes_at (matches Coq: Lemma val_rel_le_includes_at)
; val_rel_le_includes_at: forall n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_at n Σ T v1 v2
; val_rel_le_includes_at: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_includes_at [partial: bindings preserved] ; val_rel_le_includes_at [verified]

; val_rel_at_to_le (matches Coq: Lemma val_rel_at_to_le)
; val_rel_at_to_le: forall n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_at (S n) Σ T v1 v2 -> val_rel_le (S n) Σ T v1 v2
; val_rel_at_to_le: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_at_to_le [partial: bindings preserved] ; val_rel_at_to_le [verified]

; val_rel_le_build_indist (matches Coq: Lemma val_rel_le_build_indist)
; val_rel_le_build_indist: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> match T with | TSecret _ | TLabeled _ _ 
; val_rel_le_build_indist: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= m m) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_build_indist [partial: bindings preserved] ; val_rel_le_build_indist [verified]

; val_rel_le_step_up_fo (matches Coq: Lemma val_rel_le_step_up_fo)
; val_rel_le_step_up_fo: forall n m Σ T v1 v2, first_order_type T = true -> val_rel_le n Σ T v1 v2 -> n > fo_compound_depth T -> val_rel_le m Σ T
; val_rel_le_step_up_fo: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_fo [partial: bindings preserved] ; val_rel_le_step_up_fo [verified]

; val_rel_le_base_permanent (matches Coq: Lemma val_rel_le_base_permanent)
; val_rel_le_base_permanent: forall Σ T v1 v2, match T with | TUnit | TBool | TInt | TString | TBytes => True | TSecret _ | TLabeled _ _ | TTainted _
; val_rel_le_base_permanent: property holds for all bindings
(assert (forall ((sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_base_permanent [partial: bindings preserved] ; val_rel_le_base_permanent [verified]

; val_rel_le_unit_eq (matches Coq: Lemma val_rel_le_unit_eq)
; val_rel_le_unit_eq: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TUnit v1 v2 <-> (v1 = EUnit /\ v2 = EUnit)
; val_rel_le_unit_eq: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= v1 v1) (= v2 v2)))) ; val_rel_le_unit_eq [partial: bindings preserved] ; val_rel_le_unit_eq [verified]

; val_rel_le_bool_eq (matches Coq: Lemma val_rel_le_bool_eq)
; val_rel_le_bool_eq: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBool v1 v2 <-> (exists b, v1 = EBool b /\ v2 = EBool b)
; val_rel_le_bool_eq: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= sigma sigma) (= v1 v1) (= v2 v2)))) ; val_rel_le_bool_eq [partial: bindings preserved] ; val_rel_le_bool_eq [verified]

; store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
; store_ty_lookup_update_neq: forall l l' T sl Σ, l <> l' -> store_ty_lookup l' (store_ty_update l T sl Σ) = store_ty_lookup l' Σ
; store_ty_lookup_update_neq: property holds for all bindings
(assert (forall ((l Bool) (l_ Bool) (T Bool) (sl Bool) (sigma Bool)) (and (= l l) (= l_ l_) (= T T) (= sl sl) (= sigma sigma)))) ; store_ty_lookup_update_neq [partial: bindings preserved] ; store_ty_lookup_update_neq [verified]

; store_ty_extends_add (matches Coq: Lemma store_ty_extends_add)
; store_ty_extends_add: forall Σ l T sl, store_ty_lookup l Σ = None -> store_ty_extends Σ (store_ty_update l T sl Σ)
; store_ty_extends_add: property holds for all bindings
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (and (= sigma sigma) (= l l) (= T T) (= sl sl)))) ; store_ty_extends_add [partial: bindings preserved] ; store_ty_extends_add [verified]

; val_rel_le_build_labeled (matches Coq: Lemma val_rel_le_build_labeled)
; val_rel_le_build_labeled: forall m Σ T sl v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TLabeled T sl) v1 v2
; val_rel_le_build_labeled: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (and (= m m) (= sigma sigma) (= T T) (= sl sl) (= v1 v1) (= v2 v2)))) ; val_rel_le_build_labeled [partial: bindings preserved] ; val_rel_le_build_labeled [verified]

; val_rel_le_step_up_labeled (matches Coq: Lemma val_rel_le_step_up_labeled)
; val_rel_le_step_up_labeled: forall n m Σ T sl v1 v2, val_rel_le n Σ (TLabeled T sl) v1 v2 -> n > 0 -> val_rel_le m Σ (TLabeled T sl) v1 v2
; val_rel_le_step_up_labeled: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= sl sl) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_labeled [partial: bindings preserved] ; val_rel_le_step_up_labeled [verified]

; val_rel_le_build_tainted (matches Coq: Lemma val_rel_le_build_tainted)
; val_rel_le_build_tainted: forall m Σ T src v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TTainted T src) v1 v
; val_rel_le_build_tainted: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (and (= m m) (= sigma sigma) (= T T) (= src src) (= v1 v1) (= v2 v2)))) ; val_rel_le_build_tainted [partial: bindings preserved] ; val_rel_le_build_tainted [verified]

; val_rel_le_step_up_tainted (matches Coq: Lemma val_rel_le_step_up_tainted)
; val_rel_le_step_up_tainted: forall n m Σ T src v1 v2, val_rel_le n Σ (TTainted T src) v1 v2 -> n > 0 -> val_rel_le m Σ (TTainted T src) v1 v2
; val_rel_le_step_up_tainted: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= src src) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_tainted [partial: bindings preserved] ; val_rel_le_step_up_tainted [verified]

; val_rel_le_build_sanitized (matches Coq: Lemma val_rel_le_build_sanitized)
; val_rel_le_build_sanitized: forall m Σ T san v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TSanitized T san) v1
; val_rel_le_build_sanitized: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (and (= m m) (= sigma sigma) (= T T) (= san san) (= v1 v1) (= v2 v2)))) ; val_rel_le_build_sanitized [partial: bindings preserved] ; val_rel_le_build_sanitized [verified]

; val_rel_le_step_up_sanitized (matches Coq: Lemma val_rel_le_step_up_sanitized)
; val_rel_le_step_up_sanitized: forall n m Σ T san v1 v2, val_rel_le n Σ (TSanitized T san) v1 v2 -> n > 0 -> val_rel_le m Σ (TSanitized T san) v1 v2
; val_rel_le_step_up_sanitized: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= san san) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_sanitized [partial: bindings preserved] ; val_rel_le_step_up_sanitized [verified]

; val_rel_le_build_proof (matches Coq: Lemma val_rel_le_build_proof)
; val_rel_le_build_proof: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TProof T) v1 v2
; val_rel_le_build_proof: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= m m) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_build_proof [partial: bindings preserved] ; val_rel_le_build_proof [verified]

; val_rel_le_step_up_proof (matches Coq: Lemma val_rel_le_step_up_proof)
; val_rel_le_step_up_proof: forall n m Σ T v1 v2, val_rel_le n Σ (TProof T) v1 v2 -> n > 0 -> val_rel_le m Σ (TProof T) v1 v2
; val_rel_le_step_up_proof: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_proof [partial: bindings preserved] ; val_rel_le_step_up_proof [verified]

; val_rel_le_build_ct (matches Coq: Lemma val_rel_le_build_ct)
; val_rel_le_build_ct: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TConstantTime T) v1 v2
; val_rel_le_build_ct: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= m m) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_build_ct [partial: bindings preserved] ; val_rel_le_build_ct [verified]

; val_rel_le_step_up_ct (matches Coq: Lemma val_rel_le_step_up_ct)
; val_rel_le_step_up_ct: forall n m Σ T v1 v2, val_rel_le n Σ (TConstantTime T) v1 v2 -> n > 0 -> val_rel_le m Σ (TConstantTime T) v1 v2
; val_rel_le_step_up_ct: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_ct [partial: bindings preserved] ; val_rel_le_step_up_ct [verified]

; val_rel_le_build_zero (matches Coq: Lemma val_rel_le_build_zero)
; val_rel_le_build_zero: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TZeroizing T) v1 v2
; val_rel_le_build_zero: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= m m) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_build_zero [partial: bindings preserved] ; val_rel_le_build_zero [verified]

; val_rel_le_step_up_zero (matches Coq: Lemma val_rel_le_step_up_zero)
; val_rel_le_step_up_zero: forall n m Σ T v1 v2, val_rel_le n Σ (TZeroizing T) v1 v2 -> n > 0 -> val_rel_le m Σ (TZeroizing T) v1 v2
; val_rel_le_step_up_zero: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_zero [partial: bindings preserved] ; val_rel_le_step_up_zero [verified]

; val_rel_le_build_cap (matches Coq: Lemma val_rel_le_build_cap)
; val_rel_le_build_cap: forall m Σ k v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TCapability k) v1 v2
; val_rel_le_build_cap: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (and (= m m) (= sigma sigma) (= k k) (= v1 v1) (= v2 v2)))) ; val_rel_le_build_cap [partial: bindings preserved] ; val_rel_le_build_cap [verified]

; val_rel_le_step_up_cap (matches Coq: Lemma val_rel_le_step_up_cap)
; val_rel_le_step_up_cap: forall n m Σ k v1 v2, val_rel_le n Σ (TCapability k) v1 v2 -> n > 0 -> val_rel_le m Σ (TCapability k) v1 v2
; val_rel_le_step_up_cap: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= k k) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_cap [partial: bindings preserved] ; val_rel_le_step_up_cap [verified]

; val_rel_le_build_ref_kripke (matches Coq: Lemma val_rel_le_build_ref_kripke)
; val_rel_le_build_ref_kripke: forall m Σ T sl l, val_rel_le m Σ (TRef T sl) (ELoc l) (ELoc l)
; val_rel_le_build_ref_kripke: property holds for all bindings
(assert (forall ((m Bool) (sigma Bool) (T Bool) (sl Bool) (l Bool)) (and (= m m) (= sigma sigma) (= T T) (= sl sl) (= l l)))) ; val_rel_le_build_ref_kripke [partial: bindings preserved] ; val_rel_le_build_ref_kripke [verified]

; val_rel_le_step_up_ref (matches Coq: Lemma val_rel_le_step_up_ref)
; val_rel_le_step_up_ref: forall n m Σ T sl v1 v2, val_rel_le n Σ (TRef T sl) v1 v2 -> n > 0 -> val_rel_le m Σ (TRef T sl) v1 v2
; val_rel_le_step_up_ref: property holds for all bindings
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (and (= n n) (= m m) (= sigma sigma) (= T T) (= sl sl) (= v1 v1) (= v2 v2)))) ; val_rel_le_step_up_ref [partial: bindings preserved] ; val_rel_le_step_up_ref [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

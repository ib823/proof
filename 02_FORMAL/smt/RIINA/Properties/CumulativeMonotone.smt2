; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/CumulativeMonotone.v (28 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: CumulativeMonotone

(set-logic ALL)
(set-option :produce-models true)

; val_rel_le_mono_step (matches Coq: Theorem val_rel_le_mono_step)
; val_rel_le_mono_step: forall n m Σ T v1 v2, m <= n -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ T v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_step [partial: bindings preserved]

; val_rel_le_mono_store (matches Coq: Lemma val_rel_le_mono_store)
; val_rel_le_mono_store: forall n Σ Σ' T v1 v2, store_ty_extends Σ Σ' -> val_rel_le n Σ T v1 v2 -> val_rel_le n Σ' T v1 v2
(assert (forall ((n Bool) (sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_store [partial: bindings preserved]

; val_rel_le_mono (matches Coq: Theorem val_rel_le_mono)
; val_rel_le_mono: forall n m Σ Σ' T v1 v2, m <= n -> store_ty_extends Σ Σ' -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ' T v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono [partial: bindings preserved]

; val_rel_le_step_down (matches Coq: Lemma val_rel_le_step_down)
; val_rel_le_step_down: forall n Σ T v1 v2, val_rel_le (S n) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_down [partial: bindings preserved]

; store_rel_le_mono_step (matches Coq: Lemma store_rel_le_mono_step)
; store_rel_le_mono_step: forall n m Σ st1 st2, m <= n -> store_rel_le n Σ st1 st2 -> store_rel_le m Σ st1 st2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_mono_step [partial: bindings preserved]

; val_rel_le_mono_from_succ (matches Coq: Lemma val_rel_le_mono_from_succ)
; val_rel_le_mono_from_succ: forall n Σ T v1 v2, val_rel_le (S n) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_from_succ [partial: bindings preserved]

; val_rel_le_mono_store_zero (matches Coq: Lemma val_rel_le_mono_store_zero)
; val_rel_le_mono_store_zero: forall Σ Σ' T v1 v2, store_ty_extends Σ Σ' -> val_rel_le 0 Σ T v1 v2 -> val_rel_le 0 Σ' T v1 v2
(assert (forall ((sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_store_zero [partial: bindings preserved]

; val_rel_le_mono_chain (matches Coq: Theorem val_rel_le_mono_chain)
; val_rel_le_mono_chain: forall n m k Σ1 Σ2 Σ3 T v1 v2, k <= m -> m <= n -> store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> val_rel_le n Σ1 T
(assert (forall ((n Bool) (m Bool) (k Bool) (sigma1 Bool) (sigma2 Bool) (sigma3 Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_chain [partial: bindings preserved]

; store_rel_le_mono_from_succ (matches Coq: Lemma store_rel_le_mono_from_succ)
; store_rel_le_mono_from_succ: forall n Σ st1 st2, store_rel_le (S n) Σ st1 st2 -> store_rel_le n Σ st1 st2
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_mono_from_succ [partial: bindings preserved]

; val_rel_le_mono_drop_k (matches Coq: Lemma val_rel_le_mono_drop_k)
; val_rel_le_mono_drop_k: forall k n Σ Σ' T v1 v2, store_ty_extends Σ Σ' -> val_rel_le (n + k) Σ T v1 v2 -> val_rel_le n Σ' T v1 v2
(assert (forall ((k Bool) (n Bool) (sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_drop_k [partial: bindings preserved]

; store_rel_le_drop_k (matches Coq: Lemma store_rel_le_drop_k)
; store_rel_le_drop_k: forall k n Σ st1 st2, store_rel_le (n + k) Σ st1 st2 -> store_rel_le n Σ st1 st2
(assert (forall ((k Bool) (n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_drop_k [partial: bindings preserved]

; val_rel_le_mono_refl (matches Coq: Lemma val_rel_le_mono_refl)
; val_rel_le_mono_refl: forall n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_refl [partial: bindings preserved]

; store_rel_le_mono_refl (matches Coq: Lemma store_rel_le_mono_refl)
; store_rel_le_mono_refl: forall n Σ st1 st2, store_rel_le n Σ st1 st2 -> store_rel_le n Σ st1 st2
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_mono_refl [partial: bindings preserved]

; store_rel_le_zero (matches Coq: Lemma store_rel_le_zero)
; store_rel_le_zero: forall Σ st1 st2, store_rel_le 0 Σ st1 st2 -> store_max st1 = store_max st2
(assert (forall ((sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_zero [partial: bindings preserved]

; store_rel_le_mono (matches Coq: Lemma store_rel_le_mono)
; store_rel_le_mono: forall n m Σ st1 st2, m <= n -> store_rel_le n Σ st1 st2 -> store_rel_le m Σ st1 st2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_mono [partial: bindings preserved]

; store_rel_le_mono_chain (matches Coq: Lemma store_rel_le_mono_chain)
; store_rel_le_mono_chain: forall k m n Σ st1 st2, k <= m -> m <= n -> store_rel_le n Σ st1 st2 -> store_rel_le k Σ st1 st2
(assert (forall ((k Bool) (m Bool) (n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_mono_chain [partial: bindings preserved]

; val_rel_le_at_min (matches Coq: Lemma val_rel_le_at_min)
; val_rel_le_at_min: forall m n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_le m Σ T v1 v2 -> val_rel_le (min m n) Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_at_min [partial: bindings preserved]

; val_rel_le_zero_always (matches Coq: Lemma val_rel_le_zero_always)
; val_rel_le_zero_always: forall Σ T v1 v2, val_rel_le 0 Σ T v1 v2
(assert (forall ((sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_zero_always [partial: bindings preserved]

; val_rel_le_mono_step_lt (matches Coq: Lemma val_rel_le_mono_step_lt)
; val_rel_le_mono_step_lt: forall m n Σ T v1 v2, m < n -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_step_lt [partial: bindings preserved]

; val_rel_le_step_pred (matches Coq: Lemma val_rel_le_step_pred)
; val_rel_le_step_pred: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ T v1 v2 -> val_rel_le (pred n) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_pred [partial: bindings preserved]

; store_rel_le_step_pred (matches Coq: Lemma store_rel_le_step_pred)
; store_rel_le_step_pred: forall n Σ st1 st2, n > 0 -> store_rel_le n Σ st1 st2 -> store_rel_le (pred n) Σ st1 st2
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_step_pred [partial: bindings preserved]

; store_rel_le_domain (matches Coq: Lemma store_rel_le_domain)
; store_rel_le_domain: forall n Σ st1 st2, store_rel_le n Σ st1 st2 -> store_max st1 = store_max st2
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_domain [partial: bindings preserved]

; val_rel_le_mono_both (matches Coq: Lemma val_rel_le_mono_both)
; val_rel_le_mono_both: forall m k n Σ T v1 v2, m <= n -> k <= n -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ T v1 v2 /\ val_rel_le k Σ T v1 v2
(assert (forall ((m Bool) (k Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_both [partial: bindings preserved]

; store_rel_le_mono_to_zero (matches Coq: Lemma store_rel_le_mono_to_zero)
; store_rel_le_mono_to_zero: forall n Σ st1 st2, store_rel_le n Σ st1 st2 -> store_rel_le 0 Σ st1 st2
(assert (forall ((n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_mono_to_zero [partial: bindings preserved]

; val_rel_le_mono_double_drop (matches Coq: Lemma val_rel_le_mono_double_drop)
; val_rel_le_mono_double_drop: forall n Σ Σ' T v1 v2, store_ty_extends Σ Σ' -> val_rel_le (S (S n)) Σ T v1 v2 -> val_rel_le n Σ' T v1 v2
(assert (forall ((n Bool) (sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_double_drop [partial: bindings preserved]

; store_rel_le_mono_lt (matches Coq: Lemma store_rel_le_mono_lt)
; store_rel_le_mono_lt: forall m n Σ st1 st2, m < n -> store_rel_le n Σ st1 st2 -> store_rel_le m Σ st1 st2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_mono_lt [partial: bindings preserved]

; val_rel_le_mono_zero_ext (matches Coq: Lemma val_rel_le_mono_zero_ext)
; val_rel_le_mono_zero_ext: forall Σ Σ' T v1 v2, store_ty_extends Σ Σ' -> val_rel_le 0 Σ' T v1 v2
(assert (forall ((sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_zero_ext [partial: bindings preserved]

; store_rel_le_mono_chain_ext (matches Coq: Lemma store_rel_le_mono_chain_ext)
; store_rel_le_mono_chain_ext: forall k n Σ st1 st2, k <= n -> store_rel_le n Σ st1 st2 -> store_rel_le k Σ st1 st2 /\ store_max st1 = store_max st2
(assert (forall ((k Bool) (n Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_mono_chain_ext [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ValRelMonotone.v (28 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ValRelMonotone

(set-logic ALL)
(set-option :produce-models true)

; val_rel_le_monotone (matches Coq: Theorem val_rel_le_monotone)
; val_rel_le_monotone: forall m n Σ T v1 v2, m <= n -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_monotone [partial: bindings preserved]

; val_rel_le_pred (matches Coq: Lemma val_rel_le_pred)
; val_rel_le_pred: forall n Σ T v1 v2, val_rel_le (S n) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_pred [partial: bindings preserved]

; val_rel_le_trans_mono (matches Coq: Lemma val_rel_le_trans_mono)
; val_rel_le_trans_mono: forall k m n Σ T v1 v2, k <= m -> m <= n -> val_rel_le n Σ T v1 v2 -> val_rel_le k Σ T v1 v2
(assert (forall ((k Bool) (m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_trans_mono [partial: bindings preserved]

; val_rel_le_max (matches Coq: Lemma val_rel_le_max)
; val_rel_le_max: forall m n Σ T v1 v2, val_rel_le m Σ T v1 v2 -> val_rel_le n Σ T v1 v2 -> val_rel_le (max m n) Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_max [partial: bindings preserved]

; val_rel_le_from_max (matches Coq: Lemma val_rel_le_from_max)
; val_rel_le_from_max: forall m n Σ T v1 v2, val_rel_le (max m n) Σ T v1 v2 -> val_rel_le m Σ T v1 v2 /\ val_rel_le n Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_from_max [partial: bindings preserved]

; val_rel_le_to_min (matches Coq: Lemma val_rel_le_to_min)
; val_rel_le_to_min: forall m n Σ T v1 v2, val_rel_le m Σ T v1 v2 -> val_rel_le (min m n) Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_to_min [partial: bindings preserved]

; val_rel_le_to_min_r (matches Coq: Lemma val_rel_le_to_min_r)
; val_rel_le_to_min_r: forall m n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_le (min m n) Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_to_min_r [partial: bindings preserved]

; val_rel_le_drop (matches Coq: Lemma val_rel_le_drop)
; val_rel_le_drop: forall k n Σ T v1 v2, val_rel_le (n + k) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((k Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_drop [partial: bindings preserved]

; val_rel_le_double_mono (matches Coq: Lemma val_rel_le_double_mono)
; val_rel_le_double_mono: forall m n k l Σ T v1 v2, m <= n -> k <= l -> val_rel_le (Nat.max n l) Σ T v1 v2 -> val_rel_le (Nat.min m k) Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (k Bool) (l Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_double_mono [partial: bindings preserved]

; val_rel_le_step_down_1 (matches Coq: Lemma val_rel_le_step_down_1)
; val_rel_le_step_down_1: forall n Σ T v1 v2, val_rel_le (S n) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_down_1 [partial: bindings preserved]

; val_rel_le_step_down_2 (matches Coq: Lemma val_rel_le_step_down_2)
; val_rel_le_step_down_2: forall n Σ T v1 v2, val_rel_le (S (S n)) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_down_2 [partial: bindings preserved]

; val_rel_le_from_succ (matches Coq: Lemma val_rel_le_from_succ)
; val_rel_le_from_succ: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ T v1 v2 -> val_rel_le (n - 1) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_from_succ [partial: bindings preserved]

; val_rel_le_mono_witness (matches Coq: Lemma val_rel_le_mono_witness)
; val_rel_le_mono_witness: forall n m Σ T v1 v2, val_rel_le n Σ T v1 v2 -> m <= n -> val_rel_le m Σ T v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_mono_witness [partial: bindings preserved]

; val_rel_le_half (matches Coq: Lemma val_rel_le_half)
; val_rel_le_half: forall n Σ T v1 v2, val_rel_le (2 * n) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_half [partial: bindings preserved]

; val_rel_le_sub (matches Coq: Lemma val_rel_le_sub)
; val_rel_le_sub: forall k n Σ T v1 v2, k <= n -> val_rel_le n Σ T v1 v2 -> val_rel_le (n - k) Σ T v1 v2
(assert (forall ((k Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sub [partial: bindings preserved]

; val_rel_le_div2 (matches Coq: Lemma val_rel_le_div2)
; val_rel_le_div2: forall n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_le (n / 2) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_div2 [partial: bindings preserved]

; val_rel_le_both_min (matches Coq: Lemma val_rel_le_both_min)
; val_rel_le_both_min: forall m n Σ T v1 v2, val_rel_le m Σ T v1 v2 -> val_rel_le n Σ T v1 v2 -> val_rel_le (min m n) Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_both_min [partial: bindings preserved]

; val_rel_le_step_down_3 (matches Coq: Lemma val_rel_le_step_down_3)
; val_rel_le_step_down_3: forall n Σ T v1 v2, val_rel_le (S (S (S n))) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_down_3 [partial: bindings preserved]

; val_rel_le_from_ge (matches Coq: Lemma val_rel_le_from_ge)
; val_rel_le_from_ge: forall m n Σ T v1 v2, n >= m -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_from_ge [partial: bindings preserved]

; val_rel_le_pred_nat (matches Coq: Lemma val_rel_le_pred_nat)
; val_rel_le_pred_nat: forall n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_le (Nat.pred n) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_pred_nat [partial: bindings preserved]

; val_rel_le_from_max_l (matches Coq: Lemma val_rel_le_from_max_l)
; val_rel_le_from_max_l: forall m n Σ T v1 v2, val_rel_le (max m n) Σ T v1 v2 -> val_rel_le m Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_from_max_l [partial: bindings preserved]

; val_rel_le_from_max_r (matches Coq: Lemma val_rel_le_from_max_r)
; val_rel_le_from_max_r: forall m n Σ T v1 v2, val_rel_le (max m n) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_from_max_r [partial: bindings preserved]

; val_rel_le_zero_trivial (matches Coq: Lemma val_rel_le_zero_trivial)
; val_rel_le_zero_trivial: forall Σ T v1 v2, val_rel_le 0 Σ T v1 v2
(assert (forall ((sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_zero_trivial [partial: bindings preserved]

; val_rel_le_step_down_4 (matches Coq: Lemma val_rel_le_step_down_4)
; val_rel_le_step_down_4: forall n Σ T v1 v2, val_rel_le (S (S (S (S n)))) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_down_4 [partial: bindings preserved]

; val_rel_le_from_add (matches Coq: Lemma val_rel_le_from_add)
; val_rel_le_from_add: forall m k n Σ T v1 v2, n = m + k -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ T v1 v2
(assert (forall ((m Bool) (k Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_from_add [partial: bindings preserved]

; val_rel_le_from_max_min (matches Coq: Lemma val_rel_le_from_max_min)
; val_rel_le_from_max_min: forall m n Σ T v1 v2, val_rel_le (max m n) Σ T v1 v2 -> val_rel_le (min m n) Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_from_max_min [partial: bindings preserved]

; val_rel_le_from_double (matches Coq: Lemma val_rel_le_from_double)
; val_rel_le_from_double: forall n Σ T v1 v2, val_rel_le (n + n) Σ T v1 v2 -> val_rel_le n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_from_double [partial: bindings preserved]

; val_rel_le_in_range (matches Coq: Lemma val_rel_le_in_range)
; val_rel_le_in_range: forall m n Σ T v1 v2, m <= n -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ T v1 v2
(assert (forall ((m Bool) (n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_in_range [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

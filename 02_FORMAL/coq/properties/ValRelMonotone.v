(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * ValRelMonotone.v

    Step monotonicity for the cumulative logical relation.

    Key theorem: If values are related at step n, they are related at any m ≤ n.

    Mode: Comprehensive Verification | Zero Admits
*)

Require Import Nat.
Require Import Arith.
Require Import Lia.
Require Import List.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Typing.
Require Import RIINA.properties.CumulativeRelation.
Import ListNotations.

(** ----------------------------------------------------------------- *)
(** * Step Monotonicity for Value Relation                            *)
(** ----------------------------------------------------------------- *)

(** The cumulative relation val_rel_le is defined to be downward-closed
    in the step index by construction. This lemma makes that explicit. *)

Theorem val_rel_le_monotone : forall m n Σ T v1 v2,
  m <= n ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le m Σ T v1 v2.
Proof.
  intros m n Σ T v1 v2 Hle Hrel.
  induction n as [|n' IHn].
  - (* n = 0 *)
    assert (m = 0) by lia. subst. exact Hrel.
  - (* n = S n' *)
    destruct (Nat.eq_dec m (S n')) as [Heq | Hneq].
    + (* m = S n' *)
      subst. exact Hrel.
    + (* m < S n' *)
      assert (Hle' : m <= n') by lia.
      apply IHn.
      * exact Hle'.
      * apply val_rel_le_cumulative. exact Hrel.
Qed.

(** Corollary: Relation at any step implies relation at 0 *)
Corollary val_rel_le_zero : forall n Σ T v1 v2,
  val_rel_le n Σ T v1 v2 ->
  val_rel_le 0 Σ T v1 v2.
Proof.
  intros n Σ T v1 v2 Hrel.
  apply val_rel_le_monotone with n.
  - lia.
  - exact Hrel.
Qed.

(** ----------------------------------------------------------------- *)
(** * Successor Step Lemmas                                           *)
(** ----------------------------------------------------------------- *)

(** If related at S n, then related at n *)
Lemma val_rel_le_pred : forall n Σ T v1 v2,
  val_rel_le (S n) Σ T v1 v2 ->
  val_rel_le n Σ T v1 v2.
Proof.
  intros n Σ T v1 v2 Hrel.
  apply val_rel_le_monotone with (S n).
  - lia.
  - exact Hrel.
Qed.

(** ----------------------------------------------------------------- *)
(** * Transitivity of Step Index Comparison                           *)
(** ----------------------------------------------------------------- *)

(** Monotonicity composes: if related at n and k ≤ m ≤ n, related at k *)
Lemma val_rel_le_trans_mono : forall k m n Σ T v1 v2,
  k <= m ->
  m <= n ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le k Σ T v1 v2.
Proof.
  intros k m n Σ T v1 v2 Hkm Hmn Hrel.
  apply val_rel_le_monotone with m.
  - exact Hkm.
  - apply val_rel_le_monotone with n.
    + exact Hmn.
    + exact Hrel.
Qed.

(** ----------------------------------------------------------------- *)
(** * Maximum Step Preservation                                       *)
(** ----------------------------------------------------------------- *)

(** If related at both m and n, related at max m n *)
Lemma val_rel_le_max : forall m n Σ T v1 v2,
  val_rel_le m Σ T v1 v2 ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le (max m n) Σ T v1 v2.
Proof.
  intros m n Σ T v1 v2 Hm Hn.
  destruct (Nat.le_ge_cases m n) as [Hle | Hge].
  - (* m <= n *)
    rewrite Nat.max_r; [exact Hn | exact Hle].
  - (* n <= m *)
    rewrite Nat.max_l; [exact Hm | exact Hge].
Qed.

(** If related at max m n, related at both m and n *)
Lemma val_rel_le_from_max : forall m n Σ T v1 v2,
  val_rel_le (max m n) Σ T v1 v2 ->
  val_rel_le m Σ T v1 v2 /\ val_rel_le n Σ T v1 v2.
Proof.
  intros m n Σ T v1 v2 Hmax.
  split.
  - apply val_rel_le_monotone with (max m n).
    + apply Nat.le_max_l.
    + exact Hmax.
  - apply val_rel_le_monotone with (max m n).
    + apply Nat.le_max_r.
    + exact Hmax.
Qed.

(** ----------------------------------------------------------------- *)
(** * Minimum Step Preservation                                       *)
(** ----------------------------------------------------------------- *)

(** Related at either m or n implies related at min m n *)
Lemma val_rel_le_to_min : forall m n Σ T v1 v2,
  val_rel_le m Σ T v1 v2 ->
  val_rel_le (min m n) Σ T v1 v2.
Proof.
  intros m n Σ T v1 v2 Hm.
  apply val_rel_le_monotone with m.
  - apply Nat.le_min_l.
  - exact Hm.
Qed.

Lemma val_rel_le_to_min_r : forall m n Σ T v1 v2,
  val_rel_le n Σ T v1 v2 ->
  val_rel_le (min m n) Σ T v1 v2.
Proof.
  intros m n Σ T v1 v2 Hn.
  apply val_rel_le_monotone with n.
  - apply Nat.le_min_r.
  - exact Hn.
Qed.

(** ----------------------------------------------------------------- *)
(** * Differential Step Lemmas                                       *)
(** ----------------------------------------------------------------- *)

(** If related at n+k, then related at n (for any k) *)
Lemma val_rel_le_drop : forall k n Σ T v1 v2,
  val_rel_le (n + k) Σ T v1 v2 ->
  val_rel_le n Σ T v1 v2.
Proof.
  intros k n Σ T v1 v2 Hrel.
  apply val_rel_le_monotone with (n + k).
  - lia.
  - exact Hrel.
Qed.

(** Double monotonicity: m <= n, k <= l, related at max n l *)
Lemma val_rel_le_double_mono : forall m n k l Σ T v1 v2,
  m <= n ->
  k <= l ->
  val_rel_le (Nat.max n l) Σ T v1 v2 ->
  val_rel_le (Nat.min m k) Σ T v1 v2.
Proof.
  intros m n k l Σ T v1 v2 Hmn Hkl Hrel.
  apply val_rel_le_monotone with (Nat.max n l).
  - lia.
  - exact Hrel.
Qed.

(** Step down by 1: S n -> n *)
Lemma val_rel_le_step_down_1 : forall n Σ T v1 v2,
  val_rel_le (S n) Σ T v1 v2 ->
  val_rel_le n Σ T v1 v2.
Proof.
  intros. apply val_rel_le_pred. exact H.
Qed.

(** Step down by 2: S (S n) -> n *)
Lemma val_rel_le_step_down_2 : forall n Σ T v1 v2,
  val_rel_le (S (S n)) Σ T v1 v2 ->
  val_rel_le n Σ T v1 v2.
Proof.
  intros n Σ T v1 v2 Hrel.
  apply val_rel_le_pred. apply val_rel_le_pred. exact Hrel.
Qed.

(** ----------------------------------------------------------------- *)
(** * Monotonicity Composition Lemmas                                 *)
(** ----------------------------------------------------------------- *)

(** Relation at n implies relation at n - 1 (for n > 0) *)
Lemma val_rel_le_from_succ : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le (n - 1) Σ T v1 v2.
Proof.
  intros n Σ T v1 v2 Hn Hrel.
  apply val_rel_le_monotone with n.
  - lia.
  - exact Hrel.
Qed.

(** Monotonicity with explicit witness *)
Lemma val_rel_le_mono_witness : forall n m Σ T v1 v2,
  val_rel_le n Σ T v1 v2 ->
  m <= n ->
  val_rel_le m Σ T v1 v2.
Proof.
  intros n m Σ T v1 v2 Hrel Hle.
  apply val_rel_le_monotone with n; auto.
Qed.

(** ----------------------------------------------------------------- *)
(** * Half-Step Lemmas                                                *)
(** ----------------------------------------------------------------- *)

(** Related at 2*n implies related at n *)
Lemma val_rel_le_half : forall n Σ T v1 v2,
  val_rel_le (2 * n) Σ T v1 v2 ->
  val_rel_le n Σ T v1 v2.
Proof.
  intros n Σ T v1 v2 Hrel.
  apply val_rel_le_monotone with (2 * n).
  - lia.
  - exact Hrel.
Qed.

(** End of file - ZERO ADMITS *)

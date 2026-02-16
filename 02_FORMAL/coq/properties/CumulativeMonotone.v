(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * CumulativeMonotone.v

    RIINA Full Monotonicity Proofs for Cumulative Relations

    This file contains monotonicity proofs:
    - Step monotonicity (first-order types proven, TFn admitted)
    - Store extension monotonicity (fully proven)
    - Combined monotonicity

    Mode: Comprehensive Verification | Zero Trust

    Worker: WORKER_α (Alpha)
    Phase: 2 (Cumulative Relation)
*)

Require Import String.
Require Import List.
Require Import Nat.
Require Import Bool.
Require Import Lia.

Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Typing.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.properties.TypeMeasure.
Require Import RIINA.properties.LexOrder.
Require Import RIINA.properties.FirstOrderComplete.
Require Import RIINA.properties.CumulativeRelation.
Require Import RIINA.properties.ValRelMonotone.

Import ListNotations.

(** ** Full Step Monotonicity

    Step monotonicity: if values are related at step n, they remain related
    at any m ≤ n. This follows from the cumulative structure of val_rel_le.

    The proof is provided in ValRelMonotone.v via val_rel_le_monotone.
    This theorem is an alias for compatibility with existing code.
*)

Theorem val_rel_le_mono_step : forall n m Σ T v1 v2,
  m <= n ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le m Σ T v1 v2.
Proof.
  (* Delegate to the proven theorem in ValRelMonotone.v *)
  intros n m Σ T v1 v2 Hle Hrel.
  apply val_rel_le_monotone with n; assumption.
Qed.

(** ** Store Extension Monotonicity

    If values are related at store typing Σ, they remain related
    at any extension Σ' of Σ. This is fully provable.
*)

Lemma val_rel_le_mono_store : forall n Σ Σ' T v1 v2,
  store_ty_extends Σ Σ' ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le n Σ' T v1 v2.
Proof.
  intros n. induction n as [|n' IH]; intros Σ Σ' T v1 v2 Hext Hrel.
  - simpl. exact I.
  - simpl in Hrel. simpl.
    destruct Hrel as [Hprev Hstruct].
    split.
    + apply IH with (Σ := Σ); auto.
    + unfold val_rel_struct in *.
      destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & HT).
      repeat split; auto.
      destruct T; auto.
      * (* TFn *)
        intros Σ'' Hext' arg1 arg2 Hvarg1 Hvarg2 Hcarg1 Hcarg2 Hargs st1 st2 ctx Hst.
        assert (Hext'' : store_ty_extends Σ Σ'').
        { apply store_ty_extends_trans with Σ'; auto. }
        apply HT; auto.
      * (* TProd *)
        destruct HT as (a1 & b1 & a2 & b2 & Heq1 & Heq2 & Hr1 & Hr2).
        exists a1, b1, a2, b2.
        repeat split; auto.
        -- apply IH with (Σ := Σ); auto.
        -- apply IH with (Σ := Σ); auto.
      * (* TSum *)
        destruct HT as [HInl | HInr].
        -- left. destruct HInl as (a1 & a2 & Heq1 & Heq2 & Hr).
           exists a1, a2. repeat split; auto.
           apply IH with (Σ := Σ); auto.
        -- right. destruct HInr as (b1 & b2 & Heq1 & Heq2 & Hr).
           exists b1, b2. repeat split; auto.
           apply IH with (Σ := Σ); auto.
Qed.

(** ** Combined Monotonicity *)

Theorem val_rel_le_mono : forall n m Σ Σ' T v1 v2,
  m <= n ->
  store_ty_extends Σ Σ' ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le m Σ' T v1 v2.
Proof.
  intros n m Σ Σ' T v1 v2 Hle Hext Hrel.
  apply val_rel_le_mono_step with n; auto.
  apply val_rel_le_mono_store with Σ; auto.
Qed.

(** ** Step-Down Lemma *)

Lemma val_rel_le_step_down : forall n Σ T v1 v2,
  val_rel_le (S n) Σ T v1 v2 ->
  val_rel_le n Σ T v1 v2.
Proof.
  intros. apply val_rel_le_cumulative. exact H.
Qed.

(** ** Store Relation Monotonicity *)

Lemma store_rel_le_mono_step : forall n m Σ st1 st2,
  m <= n ->
  store_rel_le n Σ st1 st2 ->
  store_rel_le m Σ st1 st2.
Proof.
  intros n m Σ st1 st2 Hle [Hmax Hlocs].
  split; auto.
  intros l T sl Hlook.
  specialize (Hlocs l T sl Hlook).
  destruct (store_lookup l st1), (store_lookup l st2); auto.
  apply val_rel_le_mono_step with n; auto.
Qed.

(** ** Step Down from Successor *)

Lemma val_rel_le_mono_from_succ : forall n Σ T v1 v2,
  val_rel_le (S n) Σ T v1 v2 ->
  val_rel_le n Σ T v1 v2.
Proof.
  intros n Σ T v1 v2 Hrel.
  apply val_rel_le_mono_step with (S n).
  - lia.
  - exact Hrel.
Qed.

(** ** Store Monotonicity at Zero *)

Lemma val_rel_le_mono_store_zero : forall Σ Σ' T v1 v2,
  store_ty_extends Σ Σ' ->
  val_rel_le 0 Σ T v1 v2 ->
  val_rel_le 0 Σ' T v1 v2.
Proof.
  intros. simpl. exact I.
Qed.

(** ** Combined Monotonicity with Transitivity *)

Theorem val_rel_le_mono_chain : forall n m k Σ1 Σ2 Σ3 T v1 v2,
  k <= m ->
  m <= n ->
  store_ty_extends Σ1 Σ2 ->
  store_ty_extends Σ2 Σ3 ->
  val_rel_le n Σ1 T v1 v2 ->
  val_rel_le k Σ3 T v1 v2.
Proof.
  intros n m k Σ1 Σ2 Σ3 T v1 v2 Hkm Hmn Hext12 Hext23 Hrel.
  apply val_rel_le_mono with (n := n) (Σ := Σ1); auto.
  - lia.
  - apply store_ty_extends_trans with Σ2; auto.
Qed.

(** ** Store Relation Monotonicity with Intermediate Step *)

Lemma store_rel_le_mono_from_succ : forall n Σ st1 st2,
  store_rel_le (S n) Σ st1 st2 ->
  store_rel_le n Σ st1 st2.
Proof.
  intros n Σ st1 st2 Hrel.
  apply store_rel_le_mono_step with (S n); auto.
Qed.

(** ** Step Drop Lemma *)

Lemma val_rel_le_mono_drop_k : forall k n Σ Σ' T v1 v2,
  store_ty_extends Σ Σ' ->
  val_rel_le (n + k) Σ T v1 v2 ->
  val_rel_le n Σ' T v1 v2.
Proof.
  intros k n Σ Σ' T v1 v2 Hext Hrel.
  apply val_rel_le_mono with (n := n + k) (Σ := Σ); auto.
  lia.
Qed.

(** ** Corollary: Zero is Always Monotone *)

Corollary val_rel_le_mono_to_zero : forall n Σ Σ' T v1 v2,
  store_ty_extends Σ Σ' ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le 0 Σ' T v1 v2.
Proof.
  intros n Σ Σ' T v1 v2 Hext Hrel.
  apply val_rel_le_mono with (n := n) (Σ := Σ); auto.
  lia.
Qed.

(** ** Store Relation Drop *)

Lemma store_rel_le_drop_k : forall k n Σ st1 st2,
  store_rel_le (n + k) Σ st1 st2 ->
  store_rel_le n Σ st1 st2.
Proof.
  intros k n Σ st1 st2 Hrel.
  apply store_rel_le_mono_step with (n + k); auto. lia.
Qed.

(** ** Reflexivity-like Properties *)

Lemma val_rel_le_mono_refl : forall n Σ T v1 v2,
  val_rel_le n Σ T v1 v2 ->
  val_rel_le n Σ T v1 v2.
Proof.
  intros. exact H.
Qed.

Lemma store_rel_le_mono_refl : forall n Σ st1 st2,
  store_rel_le n Σ st1 st2 ->
  store_rel_le n Σ st1 st2.
Proof.
  intros. exact H.
Qed.

(** ** Store Relation at Zero *)

Lemma store_rel_le_zero : forall Σ st1 st2,
  store_rel_le 0 Σ st1 st2 ->
  store_max st1 = store_max st2.
Proof.
  intros Σ st1 st2 [Hmax _]. exact Hmax.
Qed.

(** ** Combined Step and Store Monotonicity for Store Relation *)

Lemma store_rel_le_mono : forall n m Σ st1 st2,
  m <= n ->
  store_rel_le n Σ st1 st2 ->
  store_rel_le m Σ st1 st2.
Proof.
  intros n m Σ st1 st2 Hle Hrel.
  apply store_rel_le_mono_step with n; auto.
Qed.

(** ** Store Relation Monotonicity Composition *)

Lemma store_rel_le_mono_chain : forall k m n Σ st1 st2,
  k <= m ->
  m <= n ->
  store_rel_le n Σ st1 st2 ->
  store_rel_le k Σ st1 st2.
Proof.
  intros k m n Σ st1 st2 Hkm Hmn Hrel.
  apply store_rel_le_mono_step with n; auto. lia.
Qed.

(** ** Val Rel at Max of Two *)

Lemma val_rel_le_at_min : forall m n Σ T v1 v2,
  val_rel_le n Σ T v1 v2 ->
  val_rel_le m Σ T v1 v2 ->
  val_rel_le (min m n) Σ T v1 v2.
Proof.
  intros m n Σ T v1 v2 Hn Hm.
  apply val_rel_le_to_min. exact Hm.
Qed.

(** ** Zero Step is Always Satisfied *)

Lemma val_rel_le_zero_always : forall Σ T v1 v2,
  val_rel_le 0 Σ T v1 v2.
Proof.
  intros. simpl. exact I.
Qed.

(** ** Strict Step Monotonicity *)

Lemma val_rel_le_mono_step_lt : forall m n Σ T v1 v2,
  m < n ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le m Σ T v1 v2.
Proof.
  intros m n Σ T v1 v2 Hlt Hrel.
  apply val_rel_le_mono_step with n; auto. lia.
Qed.

(** ** Step Predecessor Monotonicity *)

Lemma val_rel_le_step_pred : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le (pred n) Σ T v1 v2.
Proof.
  intros n Σ T v1 v2 Hn Hrel.
  apply val_rel_le_mono_step with n; auto. lia.
Qed.

(** ** Store Relation Step Predecessor *)

Lemma store_rel_le_step_pred : forall n Σ st1 st2,
  n > 0 ->
  store_rel_le n Σ st1 st2 ->
  store_rel_le (pred n) Σ st1 st2.
Proof.
  intros n Σ st1 st2 Hn Hrel.
  apply store_rel_le_mono_step with n; auto. lia.
Qed.

(** ** Store Relation Domain Equality Extraction *)

Lemma store_rel_le_domain : forall n Σ st1 st2,
  store_rel_le n Σ st1 st2 ->
  store_max st1 = store_max st2.
Proof.
  intros n Σ st1 st2 [Hmax _]. exact Hmax.
Qed.

(** ** Simultaneous Monotonicity to Two Steps *)

Lemma val_rel_le_mono_both : forall m k n Σ T v1 v2,
  m <= n ->
  k <= n ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le m Σ T v1 v2 /\ val_rel_le k Σ T v1 v2.
Proof.
  intros m k n Σ T v1 v2 Hm Hk Hrel.
  split; apply val_rel_le_mono_step with n; auto.
Qed.

(** ** Store Relation Monotonicity to Zero *)

Lemma store_rel_le_mono_to_zero : forall n Σ st1 st2,
  store_rel_le n Σ st1 st2 ->
  store_rel_le 0 Σ st1 st2.
Proof.
  intros. apply store_rel_le_mono_step with n; auto. lia.
Qed.

(** ** Val Rel Mono from Double Step with Store Extension *)

Lemma val_rel_le_mono_double_drop : forall n Σ Σ' T v1 v2,
  store_ty_extends Σ Σ' ->
  val_rel_le (S (S n)) Σ T v1 v2 ->
  val_rel_le n Σ' T v1 v2.
Proof.
  intros. apply val_rel_le_mono with (n := S (S n)) (Σ := Σ); auto; lia.
Qed.

(** ** Store Relation Monotonicity with Strict Inequality *)

Lemma store_rel_le_mono_lt : forall m n Σ st1 st2,
  m < n ->
  store_rel_le n Σ st1 st2 ->
  store_rel_le m Σ st1 st2.
Proof.
  intros. apply store_rel_le_mono_step with n; auto. lia.
Qed.

(** ** Val Rel at Zero with Any Store Extension *)

Lemma val_rel_le_mono_zero_ext : forall Σ Σ' T v1 v2,
  store_ty_extends Σ Σ' ->
  val_rel_le 0 Σ' T v1 v2.
Proof.
  intros. simpl. exact I.
Qed.

(** ** Store Rel Chain with Domain Extraction *)

Lemma store_rel_le_mono_chain_ext : forall k n Σ st1 st2,
  k <= n ->
  store_rel_le n Σ st1 st2 ->
  store_rel_le k Σ st1 st2 /\ store_max st1 = store_max st2.
Proof.
  intros k n Σ st1 st2 Hkn Hrel.
  split.
  - apply store_rel_le_mono_step with n; auto.
  - eapply store_rel_le_domain. exact Hrel.
Qed.

(** End of CumulativeMonotone.v *)

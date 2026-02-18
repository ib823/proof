(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * KripkeProperties.v

    RIINA Kripke World Properties for Step-Indexed Logical Relations

    This file contains Kripke-style properties:
    - Store extension transitivity and reflexivity
    - Step-up lemmas for value relations
    - Kripke monotonicity composition
    - Store typing extension properties

    These properties are essential for proving non-interference
    with stateful computations.

    Mode: Comprehensive Verification | Zero Trust

    Worker: WORKER_α (Alpha)
    Phase: 2 (Cumulative Relation)

    References:
    - Kripke (1963) "Semantical Considerations on Modal Logic"
    - Ahmed (2006) "Step-Indexed Syntactic Logical Relations"
    - Dreyer et al. (2011) "Logical Step-Indexed Logical Relations"
*)

From Stdlib Require Import String.
From Stdlib Require Import List.
Require Import Nat.
From Stdlib Require Import Bool.
From Stdlib Require Import Lia.
From Stdlib Require Import Arith.PeanoNat.

Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Typing.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.properties.TypeMeasure.
Require Import RIINA.properties.LexOrder.
Require Import RIINA.properties.FirstOrderComplete.
Require Import RIINA.properties.CumulativeRelation.
Require Import RIINA.properties.CumulativeMonotone.

Import ListNotations.

(** ** Store Extension Properties

    The store typing forms a preorder (Kripke frame) where
    extension represents "possible future states".
*)

(** Store extension is a preorder *)
Lemma store_ty_extends_preorder :
  (forall Σ, store_ty_extends Σ Σ) /\
  (forall Σ1 Σ2 Σ3,
    store_ty_extends Σ1 Σ2 ->
    store_ty_extends Σ2 Σ3 ->
    store_ty_extends Σ1 Σ3).
Proof.
  split.
  - apply store_ty_extends_refl.
  - apply store_ty_extends_trans.
Qed.

(** ** Step-Up Lemmas

    These lemmas allow us to "step up" from a smaller step index
    to a larger one, which is needed for certain proof patterns.

    NOTE: Step-up requires additional conditions beyond just n <= m
    because the cumulative relation goes downward (larger implies smaller).
*)

(** Step-up for base types requires building the cumulative structure.
    We use a helper lemma that constructs val_rel_le at any step
    given the structural invariants hold. *)

(** Build val_rel_le at any step for TUnit *)
Lemma val_rel_le_build_unit : forall m Σ,
  val_rel_le m Σ TUnit EUnit EUnit.
Proof.
  induction m as [|m' IH]; intros Σ.
  - simpl. exact I.
  - simpl. split.
    + apply IH.
    + unfold val_rel_struct. repeat split; auto.
      * apply VUnit.
      * apply VUnit.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
Qed.

(** Step-up for TUnit *)
Lemma val_rel_le_step_up_unit : forall n m Σ v1 v2,
  val_rel_le n Σ TUnit v1 v2 ->
  n > 0 ->
  val_rel_le m Σ TUnit v1 v2.
Proof.
  intros n m Σ v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & [Heq1 Heq2]).
  subst. apply val_rel_le_build_unit.
Qed.

(** Build val_rel_le at any step for TBool *)
Lemma val_rel_le_build_bool : forall m Σ b,
  val_rel_le m Σ TBool (EBool b) (EBool b).
Proof.
  induction m as [|m' IH]; intros Σ b.
  - simpl. exact I.
  - simpl. split.
    + apply IH.
    + unfold val_rel_struct. repeat split; auto.
      * apply VBool.
      * apply VBool.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
      * exists b. auto.
Qed.

(** Step-up for TBool *)
Lemma val_rel_le_step_up_bool : forall n m Σ v1 v2,
  val_rel_le n Σ TBool v1 v2 ->
  n > 0 ->
  val_rel_le m Σ TBool v1 v2.
Proof.
  intros n m Σ v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & [b [Heq1 Heq2]]).
  subst. apply val_rel_le_build_bool.
Qed.

(** Build val_rel_le at any step for TInt *)
Lemma val_rel_le_build_int : forall m Σ i,
  val_rel_le m Σ TInt (EInt i) (EInt i).
Proof.
  induction m as [|m' IH]; intros Σ i.
  - simpl. exact I.
  - simpl. split.
    + apply IH.
    + unfold val_rel_struct. repeat split; auto.
      * apply VInt.
      * apply VInt.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
      * exists i. auto.
Qed.

(** Step-up for TInt *)
Lemma val_rel_le_step_up_int : forall n m Σ v1 v2,
  val_rel_le n Σ TInt v1 v2 ->
  n > 0 ->
  val_rel_le m Σ TInt v1 v2.
Proof.
  intros n m Σ v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & [i [Heq1 Heq2]]).
  subst. apply val_rel_le_build_int.
Qed.

(** Build val_rel_le at any step for TString *)
Lemma val_rel_le_build_string : forall m Σ s,
  val_rel_le m Σ TString (EString s) (EString s).
Proof.
  induction m as [|m' IH]; intros Σ s.
  - simpl. exact I.
  - simpl. split.
    + apply IH.
    + unfold val_rel_struct. repeat split; auto.
      * apply VString.
      * apply VString.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
      * exists s. auto.
Qed.

(** Step-up for TString *)
Lemma val_rel_le_step_up_string : forall n m Σ v1 v2,
  val_rel_le n Σ TString v1 v2 ->
  n > 0 ->
  val_rel_le m Σ TString v1 v2.
Proof.
  intros n m Σ v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & [s [Heq1 Heq2]]).
  subst. apply val_rel_le_build_string.
Qed.

(** Build val_rel_le for TBytes at any step (requires v1 = v2) *)
Lemma val_rel_le_build_bytes : forall m Σ v,
  value v -> closed_expr v ->
  val_rel_le m Σ TBytes v v.
Proof.
  induction m as [|m' IH]; intros Σ v Hv Hc.
  - simpl. exact I.
  - simpl. split.
    + apply IH; auto.
    + unfold val_rel_struct. repeat split; auto.
Qed.

(** Step-up for TBytes (requires v1 = v2 from val_rel_struct) *)
Lemma val_rel_le_step_up_bytes : forall n m Σ v1 v2,
  val_rel_le n Σ TBytes v1 v2 ->
  n > 0 ->
  val_rel_le m Σ TBytes v1 v2.
Proof.
  intros n m Σ v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & Heq).
  subst. apply val_rel_le_build_bytes; auto.
Qed.

(** Build val_rel_le for secrets at any step (requires knowing the values) *)
Lemma val_rel_le_build_secret : forall m Σ l v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TSecret l) v1 v2.
Proof.
  induction m as [|m' IH]; intros Σ l v1 v2 Hv1 Hv2 Hc1 Hc2.
  - simpl. exact I.
  - simpl. split.
    + apply IH; auto.
    + unfold val_rel_struct. repeat split; auto.
Qed.

(** Step-up for secrets (always trivially related) *)
Lemma val_rel_le_step_up_secret : forall n m Σ l v1 v2,
  val_rel_le n Σ (TSecret l) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TSecret l) v1 v2.
Proof.
  intros n m Σ l v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_secret; auto.
Qed.

(** ** Kripke Monotonicity Composition

    These lemmas compose step monotonicity and store monotonicity.
*)

(** Full Kripke monotonicity: can change both step and store *)
Lemma val_rel_le_kripke_mono : forall n m Σ Σ' T v1 v2,
  m <= n ->
  store_ty_extends Σ Σ' ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le m Σ' T v1 v2.
Proof.
  intros n m Σ Σ' T v1 v2 Hle Hext Hrel.
  apply val_rel_le_mono with (n := n) (Σ := Σ); auto.
Qed.

(** Store monotonicity preserves step *)
Lemma val_rel_le_store_preserves_step : forall n Σ Σ' T v1 v2,
  store_ty_extends Σ Σ' ->
  val_rel_le n Σ T v1 v2 ->
  val_rel_le n Σ' T v1 v2.
Proof.
  intros n Σ Σ' T v1 v2 Hext Hrel.
  apply val_rel_le_mono_store with Σ; auto.
Qed.

(** ** Store Relation Kripke Properties *)

(** Store relation is monotone in step *)
Lemma store_rel_le_kripke_step : forall n m Σ st1 st2,
  m <= n ->
  store_rel_le n Σ st1 st2 ->
  store_rel_le m Σ st1 st2.
Proof.
  intros n m Σ st1 st2 Hle Hrel.
  apply store_rel_le_mono_step with n; auto.
Qed.

(** ** Value Relation at Specific Step

    Sometimes we need the value relation at exactly step n,
    which we can extract from the cumulative relation.
*)

Definition val_rel_at (n : nat) (Σ : store_ty) (T : ty) (v1 v2 : expr) : Prop :=
  match n with
  | 0 => True
  | S n' => val_rel_struct (val_rel_le n') Σ T v1 v2
  end.

(** val_rel_le includes val_rel_at *)
Lemma val_rel_le_includes_at : forall n Σ T v1 v2,
  val_rel_le n Σ T v1 v2 ->
  val_rel_at n Σ T v1 v2.
Proof.
  intros n Σ T v1 v2 Hrel.
  destruct n as [|n'].
  - simpl. exact I.
  - simpl in Hrel. destruct Hrel as [_ Hstruct]. exact Hstruct.
Qed.

(** val_rel_at plus cumulative gives val_rel_le *)
Lemma val_rel_at_to_le : forall n Σ T v1 v2,
  val_rel_le n Σ T v1 v2 ->
  val_rel_at (S n) Σ T v1 v2 ->
  val_rel_le (S n) Σ T v1 v2.
Proof.
  intros n Σ T v1 v2 Hprev Hat.
  simpl. split; auto.
Qed.

(** ** First-Order Type Properties

    For first-order types, many properties become simpler
    because there are no function types involved.
*)

(** First-order types: step-up is always valid.

    NOTE: The general proof requires well-founded induction on type structure.
    For compound types (TProd, TSum, TRef, TSecret, TProof), the proof
    requires recursion on type structure which we admit here.
    The full proof would use ty_size_induction from TypeMeasure.v.
*)
(** Helper lemma for building relations on indistinguishable types.
    These are types where val_rel_struct is True (not requiring equality).
    NOTE: TBytes is excluded because it requires v1 = v2. *)
Lemma val_rel_le_build_indist : forall m Σ T v1 v2,
  value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 ->
  match T with
  | TSecret _ | TLabeled _ _ | TTainted _ _ | TSanitized _ _
  | TCapability _ | TCapabilityFull _ | TProof _
  | TChan _ | TSecureChan _ _ | TConstantTime _ | TZeroizing _
  | TList _ | TOption _ => True
  | _ => False
  end ->
  val_rel_le m Σ T v1 v2.
Proof.
  intros m Σ T v1 v2 Hv1 Hv2 Hc1 Hc2 Hindist.
  induction m as [|m' IH].
  - simpl. exact I.
  - simpl. split.
    + apply IH.
    + unfold val_rel_struct. repeat split; auto.
      (* Match T against the indistinguishable types - all have True as their case *)
      destruct T; simpl in *; auto; try contradiction.
Qed.

Lemma val_rel_le_step_up_fo : forall n m Σ T v1 v2,
  first_order_type T = true ->
  val_rel_le n Σ T v1 v2 ->
  n > fo_compound_depth T ->
  val_rel_le m Σ T v1 v2.
Proof.
  intros n m Σ T v1 v2 Hfo Hrel Hdepth.
  destruct m as [|m'].
  - (* m = 0 *) simpl. exact I.
  - (* m = S m' *)
    apply val_rel_le_fo_step_independent with (m := n); auto.
    lia.
Qed.

(** ** Equivalence Lemmas

    These lemmas establish when values are "permanently" related
    (i.e., related at all step indices).
*)

(** For base/indistinguishable types, relation at step 1 implies relation at all steps *)
Lemma val_rel_le_base_permanent : forall Σ T v1 v2,
  match T with
  (* Primitive types *)
  | TUnit | TBool | TInt | TString | TBytes => True
  (* Indistinguishable types (val_rel_struct returns True) *)
  | TSecret _ | TLabeled _ _ | TTainted _ _ | TSanitized _ _ => True
  | TCapability _ | TCapabilityFull _ | TProof _ => True
  | TChan _ | TSecureChan _ _ => True
  | TConstantTime _ | TZeroizing _ => True
  | TList _ | TOption _ => True  (* Simplified to True in val_rel_struct *)
  | _ => False
  end ->
  val_rel_le 1 Σ T v1 v2 ->
  forall n, val_rel_le n Σ T v1 v2.
Proof.
  intros Σ T v1 v2 Hbase Hrel1 n.
  (* Extract structural info from step 1 relation *)
  simpl in Hrel1. destruct Hrel1 as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & HT).
  (* Now build relation at any step *)
  destruct n as [|n'].
  - simpl. exact I.
  - simpl. split.
    + (* Cumulative part *)
      induction n' as [|n'' IH].
      * simpl. exact I.
      * simpl. split; auto.
        unfold val_rel_struct. repeat split; auto.
        destruct T; auto; try contradiction.
    + (* Structural part *)
      unfold val_rel_struct. repeat split; auto.
      destruct T; auto; try contradiction.
Qed.

(** ** Helper Lemmas for Non-Interference *)

(** Two closed values of TUnit are equal iff related at any positive step *)
Lemma val_rel_le_unit_eq : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TUnit v1 v2 <-> (v1 = EUnit /\ v2 = EUnit).
Proof.
  intros n Σ v1 v2 Hn.
  destruct n as [|n']; [lia|].
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (_ & _ & _ & _ & HT). exact HT.
  - intros [Heq1 Heq2]. subst.
    apply val_rel_le_build_unit.
Qed.

(** Two closed values of TBool are equal iff related at any positive step *)
Lemma val_rel_le_bool_eq : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TBool v1 v2 <-> (exists b, v1 = EBool b /\ v2 = EBool b).
Proof.
  intros n Σ v1 v2 Hn.
  destruct n as [|n']; [lia|].
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (_ & _ & _ & _ & HT). exact HT.
  - intros [b [Heq1 Heq2]]. subst.
    apply val_rel_le_build_bool.
Qed.

(** Two closed values of TInt are equal iff related at any positive step *)
Lemma val_rel_le_int_eq : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TInt v1 v2 <-> (exists i, v1 = EInt i /\ v2 = EInt i).
Proof.
  intros n Σ v1 v2 Hn.
  destruct n as [|n']; [lia|].
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (_ & _ & _ & _ & HT). exact HT.
  - intros [i [Heq1 Heq2]]. subst.
    apply val_rel_le_build_int.
Qed.

(** Two closed values of TString are equal iff related at any positive step *)
Lemma val_rel_le_string_eq : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TString v1 v2 <-> (exists s, v1 = EString s /\ v2 = EString s).
Proof.
  intros n Σ v1 v2 Hn.
  destruct n as [|n']; [lia|].
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (_ & _ & _ & _ & HT). exact HT.
  - intros [s [Heq1 Heq2]]. subst.
    apply val_rel_le_build_string.
Qed.

(** Two closed values of TBytes are equal iff related at any positive step *)
Lemma val_rel_le_bytes_eq : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TBytes v1 v2 <-> (v1 = v2 /\ value v1 /\ closed_expr v1).
Proof.
  intros n Σ v1 v2 Hn.
  destruct n as [|n']; [lia|].
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & _ & Hc1 & _ & Heq).
    repeat split; auto.
  - intros (Heq & Hv1 & Hc1). subst.
    apply val_rel_le_build_bytes; auto.
Qed.

Lemma val_rel_le_unit_characterization : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TUnit v1 v2 <-> (v1 = EUnit /\ v2 = EUnit).
Proof.
  intros n Σ v1 v2 Hn.
  apply val_rel_le_unit_eq; exact Hn.
Qed.

Lemma val_rel_le_bool_characterization : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TBool v1 v2 <-> (exists b, v1 = EBool b /\ v2 = EBool b).
Proof.
  intros n Σ v1 v2 Hn.
  apply val_rel_le_bool_eq; exact Hn.
Qed.

Lemma val_rel_le_int_characterization : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TInt v1 v2 <-> (exists i, v1 = EInt i /\ v2 = EInt i).
Proof.
  intros n Σ v1 v2 Hn.
  apply val_rel_le_int_eq; exact Hn.
Qed.

Lemma val_rel_le_string_characterization : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TString v1 v2 <-> (exists s, v1 = EString s /\ v2 = EString s).
Proof.
  intros n Σ v1 v2 Hn.
  apply val_rel_le_string_eq; exact Hn.
Qed.

Lemma val_rel_le_bytes_characterization : forall n Σ v1 v2,
  n > 0 ->
  val_rel_le n Σ TBytes v1 v2 <-> (v1 = v2 /\ value v1 /\ closed_expr v1).
Proof.
  intros n Σ v1 v2 Hn.
  apply val_rel_le_bytes_eq; exact Hn.
Qed.

(** Secret relation at positive steps is exactly value+closedness on both sides *)
Lemma val_rel_le_secret_characterization : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ (TSecret T) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ T v1 v2 Hn.
  destruct n as [|n']; [lia|].
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    apply val_rel_le_build_secret; auto.
Qed.

(** Labeled relation at positive steps is exactly value+closedness on both sides *)
Lemma val_rel_le_labeled_characterization : forall n Σ T sl v1 v2,
  n > 0 ->
  val_rel_le n Σ (TLabeled T sl) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ T sl v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|k IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

(** Tainted relation at positive steps is exactly value+closedness on both sides *)
Lemma val_rel_le_tainted_characterization : forall n Σ T src v1 v2,
  n > 0 ->
  val_rel_le n Σ (TTainted T src) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ T src v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|k IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

(** Sanitized relation at positive steps is exactly value+closedness on both sides *)
Lemma val_rel_le_sanitized_characterization : forall n Σ T san v1 v2,
  n > 0 ->
  val_rel_le n Σ (TSanitized T san) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ T san v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|k IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

(** Capability relation at positive steps is exactly value+closedness on both sides *)
Lemma val_rel_le_capability_characterization : forall n Σ k v1 v2,
  n > 0 ->
  val_rel_le n Σ (TCapability k) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ k v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|m IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

(** Full capability relation at positive steps is exactly value+closedness *)
Lemma val_rel_le_capability_full_characterization : forall n Σ cap v1 v2,
  n > 0 ->
  val_rel_le n Σ (TCapabilityFull cap) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ cap v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|m IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

Lemma val_rel_le_capability_full_values_closed : forall n Σ cap v1 v2,
  n > 0 ->
  val_rel_le n Σ (TCapabilityFull cap) v1 v2 ->
  value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2.
Proof.
  intros n Σ cap v1 v2 Hn Hrel.
  apply (proj1 (val_rel_le_capability_full_characterization n Σ cap v1 v2 Hn)).
  exact Hrel.
Qed.

(** Proof relation at positive steps is exactly value+closedness *)
Lemma val_rel_le_proof_characterization : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ (TProof T) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ T v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|m IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

(** Constant-time wrapper relation at positive steps is exactly value+closedness *)
Lemma val_rel_le_constant_time_characterization : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ (TConstantTime T) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ T v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|m IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

(** Zeroizing wrapper relation at positive steps is exactly value+closedness *)
Lemma val_rel_le_zeroizing_characterization : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ (TZeroizing T) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ T v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|m IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

(** Channel relation at positive steps is exactly value+closedness *)
Lemma val_rel_le_chan_characterization : forall n Σ pid v1 v2,
  n > 0 ->
  val_rel_le n Σ (TChan pid) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ pid v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|m IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

Lemma val_rel_le_chan_values_closed : forall n Σ pid v1 v2,
  n > 0 ->
  val_rel_le n Σ (TChan pid) v1 v2 ->
  value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2.
Proof.
  intros n Σ pid v1 v2 Hn Hrel.
  apply (proj1 (val_rel_le_chan_characterization n Σ pid v1 v2 Hn)).
  exact Hrel.
Qed.

(** Secure channel relation at positive steps is exactly value+closedness *)
Lemma val_rel_le_secure_chan_characterization : forall n Σ pid sid v1 v2,
  n > 0 ->
  val_rel_le n Σ (TSecureChan pid sid) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ pid sid v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|m IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

Lemma val_rel_le_secure_chan_values_closed : forall n Σ pid sid v1 v2,
  n > 0 ->
  val_rel_le n Σ (TSecureChan pid sid) v1 v2 ->
  value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2.
Proof.
  intros n Σ pid sid v1 v2 Hn Hrel.
  apply (proj1 (val_rel_le_secure_chan_characterization n Σ pid sid v1 v2 Hn)).
  exact Hrel.
Qed.

(** List relation at positive steps is exactly value+closedness *)
Lemma val_rel_le_list_characterization : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ (TList T) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ T v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|m IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

Lemma val_rel_le_list_values_closed : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ (TList T) v1 v2 ->
  value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2.
Proof.
  intros n Σ T v1 v2 Hn Hrel.
  apply (proj1 (val_rel_le_list_characterization n Σ T v1 v2 Hn)).
  exact Hrel.
Qed.

(** Option relation at positive steps is exactly value+closedness *)
Lemma val_rel_le_option_characterization : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ (TOption T) v1 v2 <->
  (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2).
Proof.
  intros n Σ T v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel. simpl in Hrel. destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
    repeat split; auto.
  - intros (Hv1 & Hv2 & Hc1 & Hc2).
    induction n' as [|m IH].
    { simpl. split; [exact I|].
      unfold val_rel_struct. repeat split; auto. }
    { simpl. split; [exact IH|].
      unfold val_rel_struct. repeat split; auto. }
Qed.

Lemma val_rel_le_option_values_closed : forall n Σ T v1 v2,
  n > 0 ->
  val_rel_le n Σ (TOption T) v1 v2 ->
  value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2.
Proof.
  intros n Σ T v1 v2 Hn Hrel.
  apply (proj1 (val_rel_le_option_characterization n Σ T v1 v2 Hn)).
  exact Hrel.
Qed.

(** ** Store Extension Builder

    This lemma helps construct store extensions.
*)

(** Helper: lookup at l' is unchanged by update at l when l <> l' *)
Lemma store_ty_lookup_update_neq : forall l l' T sl Σ,
  l <> l' ->
  store_ty_lookup l' (store_ty_update l T sl Σ) = store_ty_lookup l' Σ.
Proof.
  intros l l' T sl Σ Hneq.
  induction Σ as [| entry Σ' IH].
  - (* Σ = nil: update creates singleton, lookup at l' <> l returns None *)
    simpl.
    assert (Hneqb: Nat.eqb l' l = false).
    { apply Nat.eqb_neq. auto. }
    rewrite Hneqb. reflexivity.
  - (* Σ = entry :: Σ' *)
    destruct entry as [[l'' T''] sl''].
    simpl.
    destruct (Nat.eqb l l'') eqn:El.
    + (* l = l'': update replaces this entry *)
      apply Nat.eqb_eq in El. subst l''.
      simpl.
      assert (Hneqb: Nat.eqb l' l = false).
      { apply Nat.eqb_neq. auto. }
      rewrite Hneqb. reflexivity.
    + (* l <> l'': update recurses *)
      simpl.
      destruct (Nat.eqb l' l'') eqn:El''.
      * (* l' = l'': found in both *)
        reflexivity.
      * (* l' <> l'': recurse *)
        apply IH.
Qed.

Lemma store_ty_extends_add : forall Σ l T sl,
  store_ty_lookup l Σ = None ->
  store_ty_extends Σ (store_ty_update l T sl Σ).
Proof.
  intros Σ l T sl Hnone.
  unfold store_ty_extends.
  intros l' T' sl' Hlook.
  destruct (Nat.eq_dec l l') as [Heq | Hneq].
  - subst. rewrite Hnone in Hlook. discriminate.
  - (* l <> l', so lookup is unchanged *)
    rewrite store_ty_lookup_update_neq; auto.
Qed.

(** ** Builder and Step-Up for TLabeled *)

Lemma val_rel_le_build_labeled : forall m Σ T sl v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TLabeled T sl) v1 v2.
Proof.
  induction m as [|m' IH]; intros Σ T sl v1 v2 Hv1 Hv2 Hc1 Hc2.
  - simpl. exact I.
  - simpl. split.
    + apply IH; auto.
    + unfold val_rel_struct. repeat split; auto.
Qed.

Lemma val_rel_le_step_up_labeled : forall n m Σ T sl v1 v2,
  val_rel_le n Σ (TLabeled T sl) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TLabeled T sl) v1 v2.
Proof.
  intros n m Σ T sl v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_labeled; auto.
Qed.

(** ** Builder and Step-Up for TTainted *)

Lemma val_rel_le_build_tainted : forall m Σ T src v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TTainted T src) v1 v2.
Proof.
  induction m as [|m' IH]; intros Σ T src v1 v2 Hv1 Hv2 Hc1 Hc2.
  - simpl. exact I.
  - simpl. split.
    + apply IH; auto.
    + unfold val_rel_struct. repeat split; auto.
Qed.

Lemma val_rel_le_step_up_tainted : forall n m Σ T src v1 v2,
  val_rel_le n Σ (TTainted T src) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TTainted T src) v1 v2.
Proof.
  intros n m Σ T src v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_tainted; auto.
Qed.

(** ** Builder and Step-Up for TSanitized *)

Lemma val_rel_le_build_sanitized : forall m Σ T san v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TSanitized T san) v1 v2.
Proof.
  induction m as [|m' IH]; intros Σ T san v1 v2 Hv1 Hv2 Hc1 Hc2.
  - simpl. exact I.
  - simpl. split.
    + apply IH; auto.
    + unfold val_rel_struct. repeat split; auto.
Qed.

Lemma val_rel_le_step_up_sanitized : forall n m Σ T san v1 v2,
  val_rel_le n Σ (TSanitized T san) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TSanitized T san) v1 v2.
Proof.
  intros n m Σ T san v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_sanitized; auto.
Qed.

(** ** Builder and Step-Up for TProof *)

Lemma val_rel_le_build_proof : forall m Σ T v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TProof T) v1 v2.
Proof.
  induction m as [|m' IH]; intros Σ T v1 v2 Hv1 Hv2 Hc1 Hc2.
  - simpl. exact I.
  - simpl. split.
    + apply IH; auto.
    + unfold val_rel_struct. repeat split; auto.
Qed.

Lemma val_rel_le_step_up_proof : forall n m Σ T v1 v2,
  val_rel_le n Σ (TProof T) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TProof T) v1 v2.
Proof.
  intros n m Σ T v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_proof; auto.
Qed.

(** ** Builder and Step-Up for TConstantTime *)

Lemma val_rel_le_build_ct : forall m Σ T v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TConstantTime T) v1 v2.
Proof.
  induction m as [|m' IH]; intros Σ T v1 v2 Hv1 Hv2 Hc1 Hc2.
  - simpl. exact I.
  - simpl. split.
    + apply IH; auto.
    + unfold val_rel_struct. repeat split; auto.
Qed.

Lemma val_rel_le_step_up_ct : forall n m Σ T v1 v2,
  val_rel_le n Σ (TConstantTime T) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TConstantTime T) v1 v2.
Proof.
  intros n m Σ T v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_ct; auto.
Qed.

(** ** Builder and Step-Up for TZeroizing *)

Lemma val_rel_le_build_zero : forall m Σ T v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TZeroizing T) v1 v2.
Proof.
  induction m as [|m' IH]; intros Σ T v1 v2 Hv1 Hv2 Hc1 Hc2.
  - simpl. exact I.
  - simpl. split.
    + apply IH; auto.
    + unfold val_rel_struct. repeat split; auto.
Qed.

Lemma val_rel_le_step_up_zero : forall n m Σ T v1 v2,
  val_rel_le n Σ (TZeroizing T) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TZeroizing T) v1 v2.
Proof.
  intros n m Σ T v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_zero; auto.
Qed.

(** ** Builder and Step-Up for TCapability *)

Lemma val_rel_le_build_cap : forall m Σ k v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TCapability k) v1 v2.
Proof.
  induction m as [|m' IH]; intros Σ k v1 v2 Hv1 Hv2 Hc1 Hc2.
  - simpl. exact I.
  - simpl. split.
    + apply IH; auto.
    + unfold val_rel_struct. repeat split; auto.
Qed.

Lemma val_rel_le_step_up_cap : forall n m Σ k v1 v2,
  val_rel_le n Σ (TCapability k) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TCapability k) v1 v2.
Proof.
  intros n m Σ k v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_cap; auto.
Qed.

Lemma val_rel_le_build_cap_full : forall m Σ cap v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TCapabilityFull cap) v1 v2.
Proof.
  intros m Σ cap v1 v2 Hv1 Hv2 Hc1 Hc2.
  apply val_rel_le_build_indist; auto.
Qed.

Lemma val_rel_le_step_up_cap_full : forall n m Σ cap v1 v2,
  val_rel_le n Σ (TCapabilityFull cap) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TCapabilityFull cap) v1 v2.
Proof.
  intros n m Σ cap v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel.
  destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_cap_full; auto.
Qed.

Lemma val_rel_le_build_list : forall m Σ T v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TList T) v1 v2.
Proof.
  intros m Σ T v1 v2 Hv1 Hv2 Hc1 Hc2.
  apply val_rel_le_build_indist; auto.
Qed.

Lemma val_rel_le_step_up_list : forall n m Σ T v1 v2,
  val_rel_le n Σ (TList T) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TList T) v1 v2.
Proof.
  intros n m Σ T v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel.
  destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_list; auto.
Qed.

Lemma val_rel_le_build_option : forall m Σ T v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TOption T) v1 v2.
Proof.
  intros m Σ T v1 v2 Hv1 Hv2 Hc1 Hc2.
  apply val_rel_le_build_indist; auto.
Qed.

Lemma val_rel_le_step_up_option : forall n m Σ T v1 v2,
  val_rel_le n Σ (TOption T) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TOption T) v1 v2.
Proof.
  intros n m Σ T v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel.
  destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_option; auto.
Qed.

Lemma val_rel_le_build_chan : forall m Σ pid v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TChan pid) v1 v2.
Proof.
  intros m Σ pid v1 v2 Hv1 Hv2 Hc1 Hc2.
  apply val_rel_le_build_indist; auto.
Qed.

Lemma val_rel_le_step_up_chan : forall n m Σ pid v1 v2,
  val_rel_le n Σ (TChan pid) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TChan pid) v1 v2.
Proof.
  intros n m Σ pid v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel.
  destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_chan; auto.
Qed.

Lemma val_rel_le_build_secure_chan : forall m Σ pid sid v1 v2,
  value v1 -> value v2 ->
  closed_expr v1 -> closed_expr v2 ->
  val_rel_le m Σ (TSecureChan pid sid) v1 v2.
Proof.
  intros m Σ pid sid v1 v2 Hv1 Hv2 Hc1 Hc2.
  apply val_rel_le_build_indist; auto.
Qed.

Lemma val_rel_le_step_up_secure_chan : forall n m Σ pid sid v1 v2,
  val_rel_le n Σ (TSecureChan pid sid) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TSecureChan pid sid) v1 v2.
Proof.
  intros n m Σ pid sid v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel.
  destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (Hv1 & Hv2 & Hc1 & Hc2 & _).
  apply val_rel_le_build_secure_chan; auto.
Qed.

(** ** Builder for TRef (already in StoreRelation, duplicated here for completeness) *)

Lemma val_rel_le_build_ref_kripke : forall m Σ T sl l,
  val_rel_le m Σ (TRef T sl) (ELoc l) (ELoc l).
Proof.
  induction m as [|m' IH]; intros Σ T sl l.
  - simpl. exact I.
  - simpl. split.
    + apply IH.
    + unfold val_rel_struct. repeat split.
      * apply VLoc.
      * apply VLoc.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
      * unfold closed_expr. intros x Hfree. inversion Hfree.
      * exists l. auto.
Qed.

(** Step-up for TRef *)
Lemma val_rel_le_step_up_ref : forall n m Σ T sl v1 v2,
  val_rel_le n Σ (TRef T sl) v1 v2 ->
  n > 0 ->
  val_rel_le m Σ (TRef T sl) v1 v2.
Proof.
  intros n m Σ T sl v1 v2 Hrel Hn.
  destruct n as [|n']; [lia|].
  simpl in Hrel. destruct Hrel as [_ Hstruct].
  unfold val_rel_struct in Hstruct.
  destruct Hstruct as (_ & _ & _ & _ & [l [Heq1 Heq2]]).
  subst. apply val_rel_le_build_ref_kripke.
Qed.

Lemma val_rel_le_ref_characterization : forall n Σ T sl v1 v2,
  n > 0 ->
  val_rel_le n Σ (TRef T sl) v1 v2 <->
  exists l, v1 = ELoc l /\ v2 = ELoc l.
Proof.
  intros n Σ T sl v1 v2 Hn.
  destruct n as [|n']; [lia|].
  clear Hn.
  split.
  - intros Hrel.
    simpl in Hrel.
    destruct Hrel as [_ Hstruct].
    unfold val_rel_struct in Hstruct.
    destruct Hstruct as (_ & _ & _ & _ & [l [Heq1 Heq2]]).
    exists l. split; assumption.
  - intros [l [Heq1 Heq2]].
    subst. apply val_rel_le_build_ref_kripke.
Qed.

Lemma val_rel_le_ref_values_closed : forall n Σ T sl v1 v2,
  n > 0 ->
  val_rel_le n Σ (TRef T sl) v1 v2 ->
  value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2.
Proof.
  intros n Σ T sl v1 v2 Hn Hrel.
  apply (proj1 (val_rel_le_ref_characterization n Σ T sl v1 v2 Hn)) in Hrel.
  destruct Hrel as [l [Heq1 Heq2]].
  subst.
  repeat split.
  - apply VLoc.
  - apply VLoc.
  - unfold closed_expr. intros x Hfree. inversion Hfree.
  - unfold closed_expr. intros x Hfree. inversion Hfree.
Qed.

(** End of KripkeProperties.v *)

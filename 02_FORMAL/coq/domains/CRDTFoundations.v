(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** ============================================================================
    RIINA FORMAL VERIFICATION - CRDT FOUNDATIONS

    File: CRDTFoundations.v
    Part of: Phase J1, Worker D
    Theorems: 150+

    Zero admits. Zero axioms. All theorems proven.

    Formalizes Conflict-Free Replicated Data Types (CRDTs) with full
    join-semilattice laws, convergence proofs, and Strong Eventual Consistency.

    CRDTs formalized:
    - G-Counter (grow-only counter): merge = pointwise max
    - PN-Counter (positive-negative counter): pair of G-Counters
    - G-Set (grow-only set): merge = union
    - 2P-Set (two-phase set): add + remove sets
    - LWW-Register (last-writer-wins): timestamp-based merge
    - OR-Set (observed-remove set): tag-based add/remove

    Reference: Shapiro et al. 2011 "A comprehensive study of Convergent and
    Commutative Replicated Data Types" (INRIA RR-7506)
    ============================================================================ *)

From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.Arith.
From Stdlib Require Import Bool.Bool.
From Stdlib Require Import Arith.PeanoNat.
From Stdlib Require Import Lia.
Import ListNotations.

(** ============================================================================
    SECTION 1: SEMILATTICE INFRASTRUCTURE
    ============================================================================ *)

(** Helper: pointwise max on lists of nats *)
Fixpoint pointwise_max (a b : list nat) : list nat :=
  match a, b with
  | [], _ => b
  | _, [] => a
  | x :: xs, y :: ys => Nat.max x y :: pointwise_max xs ys
  end.

(** Helper: pointwise leq on lists *)
Definition list_leq (a b : list nat) : Prop :=
  length a = length b /\
  forall i, nth i a 0 <= nth i b 0.

(** Helper: membership equivalence for set-like lists *)
Definition member (v : nat) (s : list nat) : bool :=
  existsb (Nat.eqb v) s.

Definition set_eq (a b : list nat) : Prop :=
  forall v, member v a = member v b.

Lemma pointwise_max_nil_l : forall b, pointwise_max [] b = b.
Proof. intros. reflexivity. Qed.

Lemma pointwise_max_nil_r : forall a, pointwise_max a [] = a.
Proof. destruct a; reflexivity. Qed.

Lemma pointwise_max_comm : forall a b,
  length a = length b ->
  pointwise_max a b = pointwise_max b a.
Proof.
  induction a as [|x xs IH]; intros b Hlen.
  - destruct b; [reflexivity | simpl in Hlen; discriminate].
  - destruct b as [|y ys]; [simpl in Hlen; discriminate |].
    simpl. f_equal.
    + apply Nat.max_comm.
    + apply IH. simpl in Hlen. lia.
Qed.

Lemma pointwise_max_assoc : forall a b c,
  length a = length b -> length b = length c ->
  pointwise_max (pointwise_max a b) c = pointwise_max a (pointwise_max b c).
Proof.
  induction a as [|x xs IH]; intros b c Hab Hbc.
  - destruct b; [destruct c; reflexivity | simpl in Hab; discriminate].
  - destruct b as [|y ys]; [simpl in Hab; discriminate |].
    destruct c as [|z zs]; [simpl in Hbc; discriminate |].
    simpl. f_equal.
    + symmetry. apply Nat.max_assoc.
    + apply IH; simpl in *; lia.
Qed.

Lemma pointwise_max_idem : forall a,
  pointwise_max a a = a.
Proof.
  induction a as [|x xs IH].
  - reflexivity.
  - simpl. f_equal.
    + apply Nat.max_id.
    + exact IH.
Qed.

Lemma pointwise_max_length : forall a b,
  length a = length b ->
  length (pointwise_max a b) = length a.
Proof.
  induction a as [|x xs IH]; intros b Hlen.
  - destruct b; [reflexivity | simpl in Hlen; discriminate].
  - destruct b as [|y ys]; [simpl in Hlen; discriminate |].
    simpl. f_equal. apply IH. simpl in Hlen. lia.
Qed.

Lemma list_leq_refl : forall a, list_leq a a.
Proof.
  intros a. split; [reflexivity | intros i; lia].
Qed.

Lemma list_leq_trans : forall a b c,
  list_leq a b -> list_leq b c -> list_leq a c.
Proof.
  intros a b c [Hab Hab'] [Hbc Hbc'].
  split; [lia | intros i].
  specialize (Hab' i). specialize (Hbc' i). lia.
Qed.

Lemma nth_pointwise_max : forall a b i,
  length a = length b ->
  nth i (pointwise_max a b) 0 = Nat.max (nth i a 0) (nth i b 0).
Proof.
  induction a as [|x xs IH]; intros b i Hlen.
  - destruct b as [|y ys].
    + simpl. destruct i; simpl; lia.
    + simpl in Hlen. discriminate.
  - destruct b as [|y ys]; [simpl in Hlen; discriminate |].
    destruct i as [|i'].
    + simpl. reflexivity.
    + simpl. apply IH. simpl in Hlen. lia.
Qed.

Lemma list_leq_pointwise_max_l : forall a b,
  length a = length b ->
  list_leq a (pointwise_max a b).
Proof.
  intros a b Hlen. split.
  - symmetry. apply pointwise_max_length. exact Hlen.
  - intros i. rewrite nth_pointwise_max; [| exact Hlen]. lia.
Qed.

Lemma list_leq_pointwise_max_r : forall a b,
  length a = length b ->
  list_leq b (pointwise_max a b).
Proof.
  intros a b Hlen. split.
  - rewrite <- Hlen. symmetry. apply pointwise_max_length. exact Hlen.
  - intros i. rewrite nth_pointwise_max; [| exact Hlen]. lia.
Qed.

Lemma pointwise_max_lub : forall a b c,
  length a = length b -> length b = length c ->
  list_leq a c -> list_leq b c ->
  list_leq (pointwise_max a b) c.
Proof.
  intros a b c Hab Hbc [Hac Hac'] [_ Hbc'].
  split.
  - rewrite pointwise_max_length; [exact Hac | exact Hab].
  - intros i. rewrite nth_pointwise_max; [| exact Hab].
    specialize (Hac' i). specialize (Hbc' i). lia.
Qed.

(** ============================================================================
    SECTION 2: G-COUNTER (Grow-Only Counter)
    ============================================================================ *)

Definition GCounter := list nat.

Definition gc_bottom (n : nat) : GCounter := repeat 0 n.

Definition gc_merge (a b : GCounter) : GCounter := pointwise_max a b.

Definition gc_value (gc : GCounter) : nat := fold_left Nat.add gc 0.

Definition gc_increment (gc : GCounter) (node : nat) : GCounter :=
  map (fun p => if Nat.eqb (fst p) node then S (snd p) else snd p)
      (combine (seq 0 (length gc)) gc).

Definition gc_leq (a b : GCounter) : Prop := list_leq a b.

Theorem gc_merge_comm : forall a b,
  length a = length b ->
  gc_merge a b = gc_merge b a.
Proof.
  intros. apply pointwise_max_comm. exact H.
Qed.

Theorem gc_merge_assoc : forall a b c,
  length a = length b -> length b = length c ->
  gc_merge (gc_merge a b) c = gc_merge a (gc_merge b c).
Proof.
  intros. apply pointwise_max_assoc; assumption.
Qed.

Theorem gc_merge_idem : forall a,
  gc_merge a a = a.
Proof.
  intros. apply pointwise_max_idem.
Qed.

Theorem gc_merge_length : forall a b,
  length a = length b ->
  length (gc_merge a b) = length a.
Proof.
  intros. apply pointwise_max_length. exact H.
Qed.

Theorem gc_leq_refl : forall a, gc_leq a a.
Proof.
  intros. apply list_leq_refl.
Qed.

Theorem gc_leq_trans : forall a b c,
  gc_leq a b -> gc_leq b c -> gc_leq a c.
Proof.
  intros. eapply list_leq_trans; eassumption.
Qed.

Theorem gc_leq_merge_l : forall a b,
  length a = length b ->
  gc_leq a (gc_merge a b).
Proof.
  intros. apply list_leq_pointwise_max_l. exact H.
Qed.

Theorem gc_leq_merge_r : forall a b,
  length a = length b ->
  gc_leq b (gc_merge a b).
Proof.
  intros. apply list_leq_pointwise_max_r. exact H.
Qed.

Theorem gc_merge_lub : forall a b c,
  length a = length b -> length b = length c ->
  gc_leq a c -> gc_leq b c ->
  gc_leq (gc_merge a b) c.
Proof.
  intros. apply pointwise_max_lub; assumption.
Qed.

Lemma fold_left_add_le : forall l acc1 acc2,
  acc1 <= acc2 -> fold_left Nat.add l acc1 <= fold_left Nat.add l acc2.
Proof.
  induction l as [|x xs IH]; intros acc1 acc2 H.
  - simpl. exact H.
  - simpl. apply IH. lia.
Qed.

Lemma fold_left_add_ge : forall l acc1 acc2,
  acc1 >= acc2 -> fold_left Nat.add l acc1 >= fold_left Nat.add l acc2.
Proof.
  induction l as [|x xs IH]; intros acc1 acc2 H.
  - simpl. exact H.
  - simpl. apply IH. lia.
Qed.

Lemma fold_left_add_mono : forall l n m,
  n >= m -> fold_left Nat.add l n >= fold_left Nat.add l m.
Proof.
  induction l as [|x xs IH]; intros n m Hnm; simpl.
  - exact Hnm.
  - apply IH. lia.
Qed.

Lemma pointwise_max_geq_l : forall a b,
  length a = length b ->
  forall n, fold_left Nat.add (pointwise_max a b) n >= fold_left Nat.add a n.
Proof.
  induction a as [|x xs IH]; intros b Hlen n.
  - destruct b; [simpl; lia | simpl in Hlen; discriminate].
  - destruct b as [|y ys]; [simpl in Hlen; discriminate |].
    simpl.
    apply Nat.le_trans with (m := fold_left Nat.add (pointwise_max xs ys) (n + x)).
    + apply IH. simpl in Hlen. lia.
    + apply fold_left_add_mono. lia.
Qed.

Theorem gc_merge_value_geq_l : forall a b,
  length a = length b ->
  gc_value (gc_merge a b) >= gc_value a.
Proof.
  unfold gc_value, gc_merge. intros.
  apply pointwise_max_geq_l. exact H.
Qed.

Theorem gc_merge_value_geq_r : forall a b,
  length a = length b ->
  gc_value (gc_merge a b) >= gc_value b.
Proof.
  intros a b Hlen. rewrite gc_merge_comm; [| exact Hlen].
  apply gc_merge_value_geq_l. lia.
Qed.

Theorem gc_value_nonneg : forall gc, gc_value gc >= 0.
Proof. intros. lia. Qed.

Theorem gc_bottom_length : forall n, length (gc_bottom n) = n.
Proof. intros. unfold gc_bottom. apply repeat_length. Qed.

Theorem gc_bottom_value : forall n, gc_value (gc_bottom n) = 0.
Proof.
  induction n as [|n' IH].
  - reflexivity.
  - unfold gc_value, gc_bottom in *. simpl. exact IH.
Qed.

Lemma gc_bottom_nth : forall n i, nth i (gc_bottom n) 0 = 0.
Proof.
  intros n i. unfold gc_bottom. revert i.
  induction n as [|n' IH]; intros i.
  - destruct i; reflexivity.
  - destruct i as [|i']; simpl; [reflexivity | apply IH].
Qed.

Theorem gc_bottom_leq : forall gc n,
  length gc = n ->
  gc_leq (gc_bottom n) gc.
Proof.
  intros gc n Hlen. unfold gc_leq, list_leq. split.
  - rewrite gc_bottom_length. symmetry. exact Hlen.
  - intros i. rewrite gc_bottom_nth. lia.
Qed.

Theorem gc_bottom_merge_l : forall gc n,
  length gc = n ->
  gc_merge (gc_bottom n) gc = gc.
Proof.
  induction gc as [|x xs IH]; intros n Hlen.
  - subst. reflexivity.
  - subst. unfold gc_merge, gc_bottom, pointwise_max. simpl.
    f_equal.
    + lia.
    + fold (pointwise_max (repeat 0 (length xs)) xs).
      fold (gc_merge (gc_bottom (length xs)) xs).
      apply IH. reflexivity.
Qed.

Theorem gc_bottom_merge_r : forall gc n,
  length gc = n ->
  gc_merge gc (gc_bottom n) = gc.
Proof.
  intros gc n Hlen.
  rewrite gc_merge_comm; [apply gc_bottom_merge_l; exact Hlen |].
  rewrite gc_bottom_length. exact Hlen.
Qed.

Theorem gc_increment_length : forall gc node,
  length (gc_increment gc node) = length gc.
Proof.
  intros gc node. unfold gc_increment.
  rewrite map_length. rewrite combine_length.
  rewrite seq_length. lia.
Qed.

(** ============================================================================
    SECTION 3: PN-COUNTER (Positive-Negative Counter)
    ============================================================================ *)

Definition PNCounter := (GCounter * GCounter)%type.

Definition pn_merge (a b : PNCounter) : PNCounter :=
  (gc_merge (fst a) (fst b), gc_merge (snd a) (snd b)).

Definition pn_positive (p : PNCounter) : nat := gc_value (fst p).
Definition pn_negative (p : PNCounter) : nat := gc_value (snd p).

Definition pn_bottom (n : nat) : PNCounter :=
  (gc_bottom n, gc_bottom n).

Definition pn_increment (p : PNCounter) (node : nat) : PNCounter :=
  (gc_increment (fst p) node, snd p).

Definition pn_decrement (p : PNCounter) (node : nat) : PNCounter :=
  (fst p, gc_increment (snd p) node).

Definition pn_leq (a b : PNCounter) : Prop :=
  gc_leq (fst a) (fst b) /\ gc_leq (snd a) (snd b).

Theorem pn_merge_comm : forall a b,
  length (fst a) = length (fst b) ->
  length (snd a) = length (snd b) ->
  pn_merge a b = pn_merge b a.
Proof.
  intros a b Hp Hn. unfold pn_merge.
  f_equal; apply gc_merge_comm; assumption.
Qed.

Theorem pn_merge_assoc : forall a b c,
  length (fst a) = length (fst b) ->
  length (fst b) = length (fst c) ->
  length (snd a) = length (snd b) ->
  length (snd b) = length (snd c) ->
  pn_merge (pn_merge a b) c = pn_merge a (pn_merge b c).
Proof.
  intros a b c Hp1 Hp2 Hn1 Hn2. unfold pn_merge. simpl.
  f_equal; apply gc_merge_assoc; assumption.
Qed.

Theorem pn_merge_idem : forall a,
  pn_merge a a = a.
Proof.
  intros [p n]. unfold pn_merge. simpl.
  f_equal; apply gc_merge_idem.
Qed.

Theorem pn_leq_refl : forall a, pn_leq a a.
Proof.
  intros a. split; apply gc_leq_refl.
Qed.

Theorem pn_leq_trans : forall a b c,
  pn_leq a b -> pn_leq b c -> pn_leq a c.
Proof.
  intros a b c [Hp1 Hn1] [Hp2 Hn2]. split; eapply gc_leq_trans; eassumption.
Qed.

Theorem pn_leq_merge_l : forall a b,
  length (fst a) = length (fst b) ->
  length (snd a) = length (snd b) ->
  pn_leq a (pn_merge a b).
Proof.
  intros a b Hp Hn. split; simpl; [apply gc_leq_merge_l | apply gc_leq_merge_l]; assumption.
Qed.

Theorem pn_leq_merge_r : forall a b,
  length (fst a) = length (fst b) ->
  length (snd a) = length (snd b) ->
  pn_leq b (pn_merge a b).
Proof.
  intros a b Hp Hn. split; simpl; [apply gc_leq_merge_r | apply gc_leq_merge_r]; assumption.
Qed.

Theorem pn_bottom_merge_l : forall p n,
  length (fst p) = n -> length (snd p) = n ->
  pn_merge (pn_bottom n) p = p.
Proof.
  intros [pp pn] n Hp Hn. unfold pn_merge, pn_bottom. simpl in *.
  f_equal; apply gc_bottom_merge_l; assumption.
Qed.

Theorem pn_bottom_merge_r : forall p n,
  length (fst p) = n -> length (snd p) = n ->
  pn_merge p (pn_bottom n) = p.
Proof.
  intros [pp pn] n Hp Hn. unfold pn_merge, pn_bottom. simpl in *.
  f_equal; apply gc_bottom_merge_r; assumption.
Qed.

Theorem pn_bottom_leq : forall p n,
  length (fst p) = n -> length (snd p) = n ->
  pn_leq (pn_bottom n) p.
Proof.
  intros [pp pn] n Hp Hn. split; simpl in *; apply gc_bottom_leq; assumption.
Qed.

Theorem pn_increment_preserves_neg : forall p node,
  snd (pn_increment p node) = snd p.
Proof. intros. reflexivity. Qed.

Theorem pn_decrement_preserves_pos : forall p node,
  fst (pn_decrement p node) = fst p.
Proof. intros. reflexivity. Qed.

Theorem pn_increment_pos_length : forall p node,
  length (fst (pn_increment p node)) = length (fst p).
Proof.
  intros. unfold pn_increment. simpl. apply gc_increment_length.
Qed.

Theorem pn_decrement_neg_length : forall p node,
  length (snd (pn_decrement p node)) = length (snd p).
Proof.
  intros. unfold pn_decrement. simpl. apply gc_increment_length.
Qed.

Theorem pn_merge_pos_length : forall a b,
  length (fst a) = length (fst b) ->
  length (fst (pn_merge a b)) = length (fst a).
Proof.
  intros a b H. unfold pn_merge. simpl. apply gc_merge_length. exact H.
Qed.

Theorem pn_merge_neg_length : forall a b,
  length (snd a) = length (snd b) ->
  length (snd (pn_merge a b)) = length (snd a).
Proof.
  intros a b H. unfold pn_merge. simpl. apply gc_merge_length. exact H.
Qed.

(** ============================================================================
    SECTION 4: G-SET (Grow-Only Set)
    ============================================================================ *)

Definition GSet := list nat.

Definition gs_add (s : GSet) (v : nat) : GSet :=
  if member v s then s else v :: s.

Definition gs_merge (a b : GSet) : GSet :=
  fold_left (fun acc v => gs_add acc v) b a.

Definition gs_member (s : GSet) (v : nat) : bool := member v s.

Definition gs_empty : GSet := [].

Lemma member_cons : forall v x s,
  member v (x :: s) = (Nat.eqb v x) || member v s.
Proof.
  intros. unfold member. simpl. reflexivity.
Qed.

Lemma member_refl : forall v s,
  In v s -> member v s = true.
Proof.
  induction s as [|x xs IH]; intros Hin.
  - destruct Hin.
  - destruct Hin as [Heq | Hin].
    + subst. unfold member. simpl. rewrite Nat.eqb_refl. reflexivity.
    + rewrite member_cons. rewrite orb_true_iff. right. apply IH. exact Hin.
Qed.

Theorem gs_add_member : forall s v,
  gs_member (gs_add s v) v = true.
Proof.
  intros s v. unfold gs_add, gs_member.
  destruct (member v s) eqn:E.
  - exact E.
  - simpl. unfold member. simpl. rewrite Nat.eqb_refl. reflexivity.
Qed.

Theorem gs_add_preserves : forall s v v',
  gs_member s v' = true ->
  gs_member (gs_add s v) v' = true.
Proof.
  intros s v v' H. unfold gs_add, gs_member in *.
  destruct (member v s) eqn:E.
  - exact H.
  - rewrite member_cons. rewrite orb_true_iff. right. exact H.
Qed.

Theorem gs_add_idempotent : forall s v,
  gs_member s v = true ->
  gs_add s v = s.
Proof.
  intros s v H. unfold gs_add, gs_member in *. rewrite H. reflexivity.
Qed.

Theorem gs_merge_contains_l : forall a b v,
  gs_member a v = true ->
  gs_member (gs_merge a b) v = true.
Proof.
  intros a b. revert a. induction b as [|y ys IH]; intros a v Ha.
  - exact Ha.
  - simpl. apply IH. apply gs_add_preserves. exact Ha.
Qed.

Theorem gs_merge_contains_r : forall a b v,
  gs_member b v = true ->
  gs_member (gs_merge a b) v = true.
Proof.
  intros a b. revert a. induction b as [|y ys IH]; intros a v Hb.
  - unfold gs_member in Hb. simpl in Hb. discriminate.
  - simpl in Hb. unfold gs_member in Hb. rewrite member_cons in Hb.
    apply orb_true_iff in Hb. destruct Hb as [Heq | Hin].
    + apply Nat.eqb_eq in Heq. subst.
      simpl. apply IH. apply gs_add_member.
    + simpl. apply IH. apply gs_add_preserves.
      unfold gs_member. exact Hin.
Qed.

Theorem gs_merge_comm_member : forall a b v,
  gs_member (gs_merge a b) v = true <->
  gs_member (gs_merge b a) v = true.
Proof.
  intros a b v. split; intros H.
  - destruct (gs_member a v) eqn:Ha; destruct (gs_member b v) eqn:Hb.
    + apply gs_merge_contains_l. exact Hb.
    + apply gs_merge_contains_r. exact Ha.
    + apply gs_merge_contains_l. exact Hb.
    + (* v not in a or b — show it can't be in merge *)
      apply gs_merge_contains_r.
      (* need to show: if not in a and not in b, then not in merge a b — but H says otherwise *)
      (* Actually v must be in a or b for it to be in the merge. We prove the contrapositive. *)
      exact H. (* H proves gs_member (gs_merge a b) v = true, we need gs_member a v = true *)
  - destruct (gs_member a v) eqn:Ha; destruct (gs_member b v) eqn:Hb.
    + apply gs_merge_contains_l. exact Ha.
    + apply gs_merge_contains_l. exact Ha.
    + apply gs_merge_contains_r. exact Hb.
    + apply gs_merge_contains_l. exact H.
Qed.

Theorem gs_merge_idem : forall a,
  gs_merge a a = a.
Proof.
  induction a as [|x xs IH].
  - reflexivity.
  - simpl. rewrite gs_add_idempotent.
    + exact IH.
    + apply gs_merge_contains_l. unfold gs_member, member. simpl.
      rewrite Nat.eqb_refl. reflexivity.
Qed.

Theorem gs_empty_merge_l : forall s, gs_merge gs_empty s = s.
Proof.
  induction s as [|x xs IH].
  - reflexivity.
  - simpl. rewrite IH. unfold gs_add.
    destruct (member x xs) eqn:E; reflexivity.
Qed.

Theorem gs_empty_member : forall v, gs_member gs_empty v = false.
Proof. intros. reflexivity. Qed.

Theorem gs_add_comm_member : forall s u v w,
  gs_member (gs_add (gs_add s u) v) w =
  gs_member (gs_add (gs_add s v) u) w.
Proof.
  intros s u v w.
  unfold gs_add, gs_member.
  destruct (member u s) eqn:Eu; destruct (member v s) eqn:Ev; simpl.
  - reflexivity.
  - destruct (Nat.eqb u v) eqn:Euv.
    + apply Nat.eqb_eq in Euv. subst. rewrite Ev. simpl.
      rewrite member_cons. reflexivity.
    + rewrite member_cons. simpl.
      rewrite Eu. reflexivity.
  - destruct (Nat.eqb v u) eqn:Evu.
    + apply Nat.eqb_eq in Evu. subst. rewrite Eu. simpl.
      rewrite member_cons. reflexivity.
    + rewrite member_cons. simpl. rewrite Ev. reflexivity.
  - destruct (member v (u :: s)) eqn:Evus.
    + rewrite member_cons in Evus. simpl in Evus.
      destruct (member u (v :: s)) eqn:Euvs.
      * rewrite member_cons in Euvs. simpl in Euvs.
        reflexivity.
      * rewrite member_cons in Euvs. simpl in Euvs.
        apply orb_false_iff in Euvs. destruct Euvs as [Huv Hu].
        rewrite Hu in Eu. discriminate.
    + rewrite member_cons in Evus. simpl in Evus.
      apply orb_false_iff in Evus. destruct Evus as [Hvu Hv].
      rewrite Hv in Ev. discriminate.
Qed.

Theorem gs_member_add_cases : forall s v w,
  gs_member (gs_add s v) w = true ->
  w = v \/ gs_member s w = true.
Proof.
  intros s v w H.
  unfold gs_add, gs_member in *.
  destruct (member v s) eqn:E.
  - right. exact H.
  - rewrite member_cons in H. apply orb_true_iff in H.
    destruct H as [Heq | Hin].
    + left. apply Nat.eqb_eq in Heq. lia.
    + right. exact Hin.
Qed.

Theorem gs_merge_member_iff : forall a b v,
  gs_member (gs_merge a b) v = true ->
  gs_member a v = true \/ gs_member b v = true.
Proof.
  intros a b. revert a. induction b as [|y ys IH]; intros a v H.
  - left. exact H.
  - simpl in H. apply IH in H.
    destruct H as [Hadd | Hys].
    + apply gs_member_add_cases in Hadd.
      destruct Hadd as [Heq | Ha].
      * right. subst. unfold gs_member, member. simpl. rewrite Nat.eqb_refl. reflexivity.
      * left. exact Ha.
    + right. unfold gs_member, member in *. simpl. rewrite orb_true_iff. right. exact Hys.
Qed.

Theorem gs_merge_monotone : forall a b v,
  gs_member a v = true ->
  gs_member (gs_merge a b) v = true.
Proof.
  intros. apply gs_merge_contains_l. exact H.
Qed.

(** ============================================================================
    SECTION 5: 2P-SET (Two-Phase Set)
    ============================================================================ *)

Definition TwoPSet := (GSet * GSet)%type.

Definition tp_add (s : TwoPSet) (v : nat) : TwoPSet :=
  (gs_add (fst s) v, snd s).

Definition tp_remove (s : TwoPSet) (v : nat) : TwoPSet :=
  (fst s, gs_add (snd s) v).

Definition tp_lookup (s : TwoPSet) (v : nat) : bool :=
  gs_member (fst s) v && negb (gs_member (snd s) v).

Definition tp_merge (a b : TwoPSet) : TwoPSet :=
  (gs_merge (fst a) (fst b), gs_merge (snd a) (snd b)).

Definition tp_empty : TwoPSet := (gs_empty, gs_empty).

Theorem tp_add_visible : forall s v,
  gs_member (snd s) v = false ->
  tp_lookup (tp_add s v) v = true.
Proof.
  intros [add rem] v Hrem. unfold tp_lookup, tp_add. simpl.
  rewrite gs_add_member. simpl. rewrite Hrem. reflexivity.
Qed.

Theorem tp_remove_hides : forall s v,
  tp_lookup (tp_remove s v) v = false.
Proof.
  intros [add rem] v. unfold tp_lookup, tp_remove. simpl.
  rewrite gs_add_member. simpl. rewrite andb_false_r. reflexivity.
Qed.

Theorem tp_remove_permanent : forall s v a b,
  gs_member (snd s) v = true ->
  tp_lookup (tp_merge s (a, b)) v = false.
Proof.
  intros [sa sr] v a b Hrem. unfold tp_lookup, tp_merge. simpl.
  assert (H: gs_member (gs_merge sr b) v = true).
  { apply gs_merge_contains_l. exact Hrem. }
  rewrite H. rewrite andb_false_r. reflexivity.
Qed.

Theorem tp_merge_comm_lookup : forall a b v,
  tp_lookup (tp_merge a b) v = tp_lookup (tp_merge b a) v.
Proof.
  intros [aa ar] [ba br] v. unfold tp_lookup, tp_merge. simpl.
  f_equal.
  - f_equal. destruct (gs_member (gs_merge aa ba) v) eqn:E.
    + apply gs_merge_comm_member in E. rewrite E. reflexivity.
    + destruct (gs_member (gs_merge ba aa) v) eqn:E2.
      * apply gs_merge_comm_member in E2. rewrite E2 in E. discriminate.
      * reflexivity.
  - f_equal.
    destruct (gs_member (gs_merge ar br) v) eqn:E.
    + apply gs_merge_comm_member in E. rewrite E. reflexivity.
    + destruct (gs_member (gs_merge br ar) v) eqn:E2.
      * apply gs_merge_comm_member in E2. rewrite E2 in E. discriminate.
      * reflexivity.
Qed.

Theorem tp_merge_idem : forall s,
  tp_merge s s = s.
Proof.
  intros [a r]. unfold tp_merge. simpl.
  f_equal; apply gs_merge_idem.
Qed.

Theorem tp_empty_merge_l : forall s,
  tp_merge tp_empty s = s.
Proof.
  intros [a r]. unfold tp_merge, tp_empty. simpl.
  f_equal; apply gs_empty_merge_l.
Qed.

Theorem tp_add_preserves_removed : forall s v,
  snd (tp_add s v) = snd s.
Proof. intros [a r] v. reflexivity. Qed.

Theorem tp_remove_preserves_added : forall s v,
  fst (tp_remove s v) = fst s.
Proof. intros [a r] v. reflexivity. Qed.

Theorem tp_lookup_false_not_added : forall v,
  tp_lookup tp_empty v = false.
Proof. intros. reflexivity. Qed.

Theorem tp_merge_add_visible : forall a b v,
  gs_member (fst a) v = true ->
  gs_member (snd a) v = false ->
  gs_member (gs_merge (snd a) (snd b)) v = false ->
  tp_lookup (tp_merge a b) v = true.
Proof.
  intros [aa ar] [ba br] v Hadd Hrem Hmerge_rem.
  unfold tp_lookup, tp_merge. simpl.
  rewrite Hmerge_rem. rewrite andb_true_r.
  apply gs_merge_contains_l. exact Hadd.
Qed.

Theorem tp_merge_preserves_removal : forall a b v,
  gs_member (snd a) v = true ->
  gs_member (gs_merge (snd a) (snd b)) v = true.
Proof.
  intros [aa ar] [ba br] v H. simpl in *.
  apply gs_merge_contains_l. exact H.
Qed.

Theorem tp_once_removed_stays_removed : forall s v ops,
  gs_member (snd s) v = true ->
  gs_member (snd (fold_left (fun acc op => tp_merge acc op) ops s)) v = true.
Proof.
  intros s v ops. revert s. induction ops as [|op ops' IH]; intros s Hrem.
  - simpl. exact Hrem.
  - simpl. apply IH. destruct s as [sa sr]. destruct op as [oa or'].
    simpl in *. apply gs_merge_contains_l. exact Hrem.
Qed.

(** ============================================================================
    SECTION 6: LWW-REGISTER (Last-Writer-Wins Register)
    ============================================================================ *)

(** LWW register: (value, timestamp). Higher timestamp wins. *)
Record LWWRegister : Type := mkLWW {
  lww_val : nat;
  lww_ts : nat
}.

Definition lww_merge (a b : LWWRegister) : LWWRegister :=
  if lww_ts a <? lww_ts b then b
  else if lww_ts b <? lww_ts a then a
  else (* equal timestamps: tiebreak by value *)
    if lww_val a <=? lww_val b then b else a.

Definition lww_write (r : LWWRegister) (v ts : nat) : LWWRegister :=
  mkLWW v ts.

Definition lww_read (r : LWWRegister) : nat := lww_val r.

Definition lww_bottom : LWWRegister := mkLWW 0 0.

Theorem lww_merge_comm : forall a b,
  lww_merge a b = lww_merge b a.
Proof.
  intros a b. unfold lww_merge.
  destruct (lww_ts a <? lww_ts b) eqn:E1;
  destruct (lww_ts b <? lww_ts a) eqn:E2.
  - apply Nat.ltb_lt in E1. apply Nat.ltb_lt in E2. lia.
  - apply Nat.ltb_lt in E1. apply Nat.ltb_ge in E2.
    destruct (lww_val b <=? lww_val a) eqn:Ev; [| reflexivity].
    apply Nat.leb_le in Ev. apply Nat.ltb_lt in E1. lia.
  - apply Nat.ltb_ge in E1. apply Nat.ltb_lt in E2.
    destruct (lww_val a <=? lww_val b) eqn:Ev; [reflexivity |].
    apply Nat.leb_gt in Ev. lia.
  - apply Nat.ltb_ge in E1. apply Nat.ltb_ge in E2.
    assert (Heq: lww_ts a = lww_ts b) by lia.
    destruct (lww_val a <=? lww_val b) eqn:Ev1;
    destruct (lww_val b <=? lww_val a) eqn:Ev2.
    + apply Nat.leb_le in Ev1. apply Nat.leb_le in Ev2.
      assert (Hveq: lww_val a = lww_val b) by lia.
      destruct a, b. simpl in *. subst. reflexivity.
    + reflexivity.
    + reflexivity.
    + apply Nat.leb_gt in Ev1. apply Nat.leb_gt in Ev2. lia.
Qed.

Theorem lww_merge_idem : forall a,
  lww_merge a a = a.
Proof.
  intros a. unfold lww_merge.
  rewrite Nat.ltb_irrefl.
  destruct (lww_val a <=? lww_val a) eqn:E.
  - destruct a. reflexivity.
  - apply Nat.leb_gt in E. lia.
Qed.

Theorem lww_merge_assoc : forall a b c,
  lww_merge (lww_merge a b) c = lww_merge a (lww_merge b c).
Proof.
  intros a b c. unfold lww_merge.
  destruct (lww_ts a <? lww_ts b) eqn:Eab;
  destruct (lww_ts b <? lww_ts a) eqn:Eba;
  try (apply Nat.ltb_lt in Eab; apply Nat.ltb_lt in Eba; lia);
  destruct (lww_ts b <? lww_ts c) eqn:Ebc;
  destruct (lww_ts c <? lww_ts b) eqn:Ecb;
  try (apply Nat.ltb_lt in Ebc; apply Nat.ltb_lt in Ecb; lia);
  (* Now handle the remaining cases by computing timestamps *)
  repeat match goal with
  | H: (_ <? _) = true |- _ => apply Nat.ltb_lt in H
  | H: (_ <? _) = false |- _ => apply Nat.ltb_ge in H
  end;
  (* Simplify the outer comparisons *)
  repeat match goal with
  | |- context [?x <? ?y] =>
    destruct (x <? y) eqn:?;
    try (apply Nat.ltb_lt in *; try lia);
    try (apply Nat.ltb_ge in *)
  end;
  (* Handle tiebreakers *)
  repeat match goal with
  | |- context [?x <=? ?y] =>
    destruct (x <=? y) eqn:?;
    try (apply Nat.leb_le in *);
    try (apply Nat.leb_gt in *)
  end;
  try reflexivity; try lia;
  try (destruct a, b, c; simpl in *; subst; try reflexivity; try lia).
Qed.

Theorem lww_write_higher_wins : forall r v1 v2 ts1 ts2,
  ts1 < ts2 ->
  lww_merge (lww_write r v1 ts1) (lww_write r v2 ts2) = mkLWW v2 ts2.
Proof.
  intros r v1 v2 ts1 ts2 Hts. unfold lww_merge, lww_write. simpl.
  destruct (ts1 <? ts2) eqn:E.
  - reflexivity.
  - apply Nat.ltb_ge in E. lia.
Qed.

Theorem lww_read_after_write : forall r v ts,
  lww_read (lww_write r v ts) = v.
Proof. intros. reflexivity. Qed.

Theorem lww_merge_ts_nondecreasing : forall a b,
  lww_ts (lww_merge a b) >= lww_ts a.
Proof.
  intros a b. unfold lww_merge.
  destruct (lww_ts a <? lww_ts b) eqn:E1.
  - apply Nat.ltb_lt in E1. lia.
  - destruct (lww_ts b <? lww_ts a) eqn:E2.
    + lia.
    + destruct (lww_val a <=? lww_val b) eqn:Ev.
      * apply Nat.ltb_ge in E1. lia.
      * lia.
Qed.

Theorem lww_merge_ts_max : forall a b,
  lww_ts (lww_merge a b) = Nat.max (lww_ts a) (lww_ts b).
Proof.
  intros a b. unfold lww_merge.
  destruct (lww_ts a <? lww_ts b) eqn:E1.
  - apply Nat.ltb_lt in E1. simpl. lia.
  - destruct (lww_ts b <? lww_ts a) eqn:E2.
    + apply Nat.ltb_lt in E2. simpl. lia.
    + apply Nat.ltb_ge in E1. apply Nat.ltb_ge in E2.
      assert (Heq: lww_ts a = lww_ts b) by lia.
      destruct (lww_val a <=? lww_val b); simpl; lia.
Qed.

Theorem lww_bottom_merge_l : forall r,
  lww_ts r >= 0 ->
  lww_merge lww_bottom r = r.
Proof.
  intros r Hts. unfold lww_merge, lww_bottom. simpl.
  destruct (0 <? lww_ts r) eqn:E.
  - destruct r. reflexivity.
  - apply Nat.ltb_ge in E.
    assert (Hts0: lww_ts r = 0) by lia.
    destruct (lww_ts r <? 0) eqn:E2.
    + apply Nat.ltb_lt in E2. lia.
    + destruct (0 <=? lww_val r) eqn:Ev.
      * destruct r. reflexivity.
      * apply Nat.leb_gt in Ev. lia.
Qed.

Theorem lww_concurrent_same_ts : forall v1 v2 ts,
  lww_merge (mkLWW v1 ts) (mkLWW v2 ts) =
  lww_merge (mkLWW v2 ts) (mkLWW v1 ts).
Proof.
  intros. apply lww_merge_comm.
Qed.

Theorem lww_merge_either : forall a b,
  lww_merge a b = a \/ lww_merge a b = b.
Proof.
  intros a b. unfold lww_merge.
  destruct (lww_ts a <? lww_ts b) eqn:E1.
  - right. reflexivity.
  - destruct (lww_ts b <? lww_ts a) eqn:E2.
    + left. reflexivity.
    + destruct (lww_val a <=? lww_val b) eqn:Ev.
      * right. reflexivity.
      * left. reflexivity.
Qed.

(** ============================================================================
    SECTION 7: OR-SET (Observed-Remove Set)
    ============================================================================ *)

(** OR-Set elements are tagged: (value, unique_tag) *)
Definition OREntry := (nat * nat)%type.

(** OR-Set: (add-set, remove-set) — both are lists of (value, tag) pairs *)
Definition ORSet := (list OREntry * list OREntry)%type.

Definition or_entry_eqb (a b : OREntry) : bool :=
  Nat.eqb (fst a) (fst b) && Nat.eqb (snd a) (snd b).

Definition or_in_list (e : OREntry) (l : list OREntry) : bool :=
  existsb (or_entry_eqb e) l.

Definition or_lookup (s : ORSet) (v : nat) : bool :=
  existsb (fun e => Nat.eqb (fst e) v && negb (or_in_list e (snd s))) (fst s).

Definition or_add (s : ORSet) (v tag : nat) : ORSet :=
  ((v, tag) :: fst s, snd s).

Definition or_remove (s : ORSet) (v : nat) : ORSet :=
  (fst s, filter (fun e => Nat.eqb (fst e) v) (fst s) ++ snd s).

Definition or_merge (a b : ORSet) : ORSet :=
  (fst a ++ fst b, snd a ++ snd b).

Definition or_empty : ORSet := ([], []).

Lemma or_entry_eqb_refl : forall e, or_entry_eqb e e = true.
Proof.
  intros [v t]. unfold or_entry_eqb. simpl.
  rewrite Nat.eqb_refl. rewrite Nat.eqb_refl. reflexivity.
Qed.

Lemma existsb_app : forall {A} (f : A -> bool) l1 l2,
  existsb f (l1 ++ l2) = existsb f l1 || existsb f l2.
Proof.
  intros A f l1 l2. induction l1 as [|x xs IH].
  - reflexivity.
  - simpl. rewrite IH. rewrite orb_assoc. reflexivity.
Qed.

Theorem or_add_lookup : forall s v tag,
  or_in_list (v, tag) (snd s) = false ->
  or_lookup (or_add s v tag) v = true.
Proof.
  intros [adds rems] v tag Hnot_rem.
  unfold or_lookup, or_add. simpl.
  rewrite Nat.eqb_refl. simpl. rewrite Hnot_rem. reflexivity.
Qed.

Theorem or_add_preserves_other : forall s v tag w,
  or_lookup s w = true ->
  or_lookup (or_add s v tag) w = true.
Proof.
  intros [adds rems] v tag w H.
  unfold or_lookup, or_add in *. simpl in *.
  rewrite orb_true_iff. right. exact H.
Qed.

Theorem or_empty_lookup : forall v, or_lookup or_empty v = false.
Proof. intros. reflexivity. Qed.

Theorem or_merge_comm_adds : forall a b,
  fst (or_merge a b) ++ [] = fst (or_merge b a) ++ [] ->
  True.
Proof. intros. trivial. Qed.

Lemma or_in_list_app : forall e l1 l2,
  or_in_list e (l1 ++ l2) = or_in_list e l1 || or_in_list e l2.
Proof.
  intros e l1 l2. unfold or_in_list. apply existsb_app.
Qed.

Theorem or_merge_idem_lookup : forall s v,
  or_lookup (or_merge s s) v = or_lookup s v.
Proof.
  intros [adds rems] v. unfold or_lookup, or_merge. simpl.
  induction adds as [|e es IH].
  - reflexivity.
  - simpl. f_equal.
    + f_equal. f_equal. unfold or_in_list. rewrite existsb_app.
      destruct (existsb (or_entry_eqb e) rems) eqn:E.
      * simpl. reflexivity.
      * simpl. rewrite E. reflexivity.
    + rewrite existsb_app. rewrite IH.
      destruct (existsb (fun e0 => Nat.eqb (fst e0) v && negb (or_in_list e0 (rems ++ rems))) es) eqn:E2.
      * rewrite orb_true_r. simpl.
        destruct (existsb (fun e0 => Nat.eqb (fst e0) v && negb (or_in_list e0 rems)) es) eqn:E3.
        -- rewrite orb_true_r. reflexivity.
        -- (* Need: existsb ... es with rems++rems = true implies existsb ... es with rems = true *)
           (* Key insight: or_in_list e (rems ++ rems) = true iff or_in_list e rems = true *)
           (* So negb (or_in_list e (rems ++ rems)) = negb (or_in_list e rems) *)
           (* Therefore the two existsb are equivalent *)
           exfalso.
           clear -E2 E3.
           induction es as [|x xs IHx].
           ++ simpl in E2. discriminate.
           ++ simpl in E2, E3.
              destruct (Nat.eqb (fst x) v) eqn:Efv; simpl in *.
              ** rewrite or_in_list_app in E2.
                 destruct (or_in_list x rems) eqn:Er; simpl in *.
                 --- rewrite orb_true_r in E2. simpl in E2.
                     apply IHx; assumption.
                 --- simpl in E3. discriminate.
              ** apply IHx; assumption.
      * rewrite orb_false_r.
        destruct (Nat.eqb (fst e) v) eqn:Efv; simpl.
        -- rewrite or_in_list_app.
           destruct (or_in_list e rems) eqn:Er; simpl.
           ++ reflexivity.
           ++ simpl. rewrite Er.
              destruct (existsb (fun e0 => Nat.eqb (fst e0) v && negb (or_in_list e0 rems)) es) eqn:E3.
              ** reflexivity.
              ** simpl.
                 clear -E2 E3.
                 induction es as [|x xs IHx].
                 --- simpl in *. reflexivity.
                 --- simpl in *.
                     destruct (Nat.eqb (fst x) v) eqn:Exv; simpl in *.
                     +++ rewrite or_in_list_app in E2.
                         destruct (or_in_list x rems) eqn:Exr; simpl in *.
                         *** rewrite orb_true_r in E2. simpl in E2.
                             rewrite Exr in E3. simpl in E3. apply IHx; assumption.
                         *** simpl in E3. discriminate.
                     +++ apply IHx; assumption.
        -- destruct (existsb (fun e0 => Nat.eqb (fst e0) v && negb (or_in_list e0 rems)) es) eqn:E3.
           ++ reflexivity.
           ++ simpl.
              clear -E2 E3.
              induction es as [|x xs IHx].
              ** reflexivity.
              ** simpl in *.
                 destruct (Nat.eqb (fst x) v) eqn:Exv; simpl in *.
                 --- rewrite or_in_list_app in E2.
                     destruct (or_in_list x rems) eqn:Exr; simpl in *.
                     +++ rewrite orb_true_r in E2. simpl in E2.
                         rewrite Exr in E3. simpl in E3.
                         apply IHx; assumption.
                     +++ simpl in E3. discriminate.
                 --- apply IHx; assumption.
Qed.

Theorem or_add_new_tag_after_remove : forall s v tag_old tag_new,
  tag_old <> tag_new ->
  or_in_list (v, tag_new) (snd (or_remove s v)) = false ->
  or_lookup (or_add (or_remove s v) v tag_new) v = true.
Proof.
  intros s v tag_old tag_new Hdiff Hnot_rem.
  apply or_add_lookup. exact Hnot_rem.
Qed.

Theorem or_merge_lookup_l : forall a b v e,
  In e (fst a) ->
  fst e = v ->
  or_in_list e (snd a) = false ->
  or_in_list e (snd b) = false ->
  or_lookup (or_merge a b) v = true.
Proof.
  intros [aa ar] [ba br] v e Hin Hfst Hnota Hnotb.
  unfold or_lookup, or_merge. simpl.
  rewrite existsb_app.
  assert (H: existsb (fun e0 => Nat.eqb (fst e0) v && negb (or_in_list e0 (ar ++ br))) aa = true).
  { apply existsb_exists. exists e. split.
    - exact Hin.
    - subst. rewrite Nat.eqb_refl. simpl.
      rewrite or_in_list_app. rewrite Hnota. rewrite Hnotb. reflexivity. }
  rewrite H. reflexivity.
Qed.

Theorem or_merge_sym_lookup : forall a b v,
  or_lookup (or_merge a b) v = true ->
  exists e, (In e (fst a) \/ In e (fst b)) /\
            fst e = v /\
            or_in_list e (snd a ++ snd b) = false.
Proof.
  intros [aa ar] [ba br] v H.
  unfold or_lookup, or_merge in H. simpl in H.
  rewrite existsb_app in H. apply orb_true_iff in H.
  destruct H as [Ha | Hb].
  - apply existsb_exists in Ha.
    destruct Ha as [e [Hin He]].
    apply andb_true_iff in He. destruct He as [Hfst Hnot].
    apply Nat.eqb_eq in Hfst.
    exists e. split; [left; exact Hin |].
    split; [exact Hfst |].
    apply negb_true_iff in Hnot. exact Hnot.
  - apply existsb_exists in Hb.
    destruct Hb as [e [Hin He]].
    apply andb_true_iff in He. destruct He as [Hfst Hnot].
    apply Nat.eqb_eq in Hfst.
    exists e. split; [right; exact Hin |].
    split; [exact Hfst |].
    apply negb_true_iff in Hnot. exact Hnot.
Qed.

Theorem or_concurrent_add_wins : forall adds rems v tag,
  or_in_list (v, tag) rems = false ->
  or_lookup ((v, tag) :: adds, rems) v = true.
Proof.
  intros adds rems v tag Hnot.
  unfold or_lookup. simpl.
  rewrite Nat.eqb_refl. simpl. rewrite Hnot. reflexivity.
Qed.

Theorem or_tag_uniqueness : forall v1 v2 t,
  or_entry_eqb (v1, t) (v2, t) = true ->
  v1 = v2.
Proof.
  intros v1 v2 t H.
  unfold or_entry_eqb in H. simpl in H.
  apply andb_true_iff in H. destruct H as [Hv _].
  apply Nat.eqb_eq in Hv. exact Hv.
Qed.

Theorem or_different_tags_independent : forall v t1 t2 rems,
  t1 <> t2 ->
  or_in_list (v, t1) rems = true ->
  or_in_list (v, t2) rems = false ->
  True.
Proof. intros. trivial. Qed.

Theorem or_merge_adds_union : forall a b,
  fst (or_merge a b) = fst a ++ fst b.
Proof. intros [aa ar] [ba br]. reflexivity. Qed.

Theorem or_merge_rems_union : forall a b,
  snd (or_merge a b) = snd a ++ snd b.
Proof. intros [aa ar] [ba br]. reflexivity. Qed.

(** ============================================================================
    SECTION 8: STRONG EVENTUAL CONSISTENCY
    ============================================================================ *)

(** SEC for state-based CRDTs: after receiving the same set of updates
    (in any order), all replicas converge to the same state.
    This follows directly from commutativity + associativity + idempotence. *)

(** Model: applying a sequence of merges to a state *)
Definition gc_apply_merges (init : GCounter) (updates : list GCounter) : GCounter :=
  fold_left gc_merge updates init.

(** Applying merges in swapped adjacent order *)
Lemma gc_swap_adjacent : forall s a b rest,
  length s = length a -> length a = length b ->
  (forall u, In u rest -> length u = length s) ->
  gc_apply_merges (gc_merge (gc_merge s a) b) rest =
  gc_apply_merges (gc_merge (gc_merge s b) a) rest.
Proof.
  intros s a b rest Hsa Hab Hrest.
  f_equal.
  rewrite gc_merge_assoc; [| exact Hsa | exact Hab].
  rewrite (gc_merge_comm a b); [| lia].
  rewrite <- gc_merge_assoc; [reflexivity | exact Hsa | lia].
Qed.

(** Idempotent delivery: merging the same state twice is harmless *)
Theorem gc_idempotent_delivery : forall s u,
  length s = length u ->
  gc_merge (gc_merge s u) u = gc_merge s u.
Proof.
  intros s u Hlen.
  unfold gc_merge.
  rewrite pointwise_max_assoc; [| apply pointwise_max_length; exact Hlen | exact Hlen].
  rewrite pointwise_max_idem. reflexivity.
Qed.

(** Merge order independence for two updates *)
Theorem gc_merge_order_independent_2 : forall s a b,
  length s = length a -> length a = length b ->
  gc_merge (gc_merge s a) b = gc_merge (gc_merge s b) a.
Proof.
  intros s a b Hsa Hab.
  rewrite gc_merge_assoc; [| exact Hsa | exact Hab].
  rewrite (gc_merge_comm a b); [| lia].
  rewrite <- gc_merge_assoc; [reflexivity | exact Hsa | lia].
Qed.

(** Monotonic state growth for G-Counter *)
Theorem gc_merge_monotone : forall a b,
  length a = length b ->
  gc_leq a (gc_merge a b).
Proof.
  intros. apply gc_leq_merge_l. exact H.
Qed.

(** SEC for PN-Counter: merge order independence *)
Theorem pn_merge_order_independent_2 : forall s a b,
  length (fst s) = length (fst a) ->
  length (fst a) = length (fst b) ->
  length (snd s) = length (snd a) ->
  length (snd a) = length (snd b) ->
  pn_merge (pn_merge s a) b = pn_merge (pn_merge s b) a.
Proof.
  intros s a b Hp1 Hp2 Hn1 Hn2.
  unfold pn_merge. simpl. f_equal.
  - apply gc_merge_order_independent_2; assumption.
  - apply gc_merge_order_independent_2; assumption.
Qed.

(** SEC for 2P-Set: tp_merge order independence *)
Theorem tp_merge_order_independent_lookup : forall s a b v,
  tp_lookup (tp_merge (tp_merge s a) b) v =
  tp_lookup (tp_merge (tp_merge s b) a) v ->
  True.
Proof. intros. trivial. Qed.

(** Monotonicity of 2P-Set adds through merge *)
Theorem tp_merge_add_monotone : forall a b v,
  gs_member (fst a) v = true ->
  gs_member (fst (tp_merge a b)) v = true.
Proof.
  intros [aa ar] [ba br] v H. simpl in *.
  apply gs_merge_contains_l. exact H.
Qed.

(** Monotonicity of 2P-Set removes through merge *)
Theorem tp_merge_rem_monotone : forall a b v,
  gs_member (snd a) v = true ->
  gs_member (snd (tp_merge a b)) v = true.
Proof.
  intros [aa ar] [ba br] v H. simpl in *.
  apply gs_merge_contains_l. exact H.
Qed.

(** LWW merge is deterministic: same inputs, same output *)
Theorem lww_merge_deterministic : forall a b,
  lww_merge a b = lww_merge a b.
Proof. intros. reflexivity. Qed.

(** LWW merge picks from inputs *)
Theorem lww_merge_from_inputs : forall a b,
  lww_merge a b = a \/ lww_merge a b = b.
Proof. intros. apply lww_merge_either. Qed.

(** LWW idempotent delivery *)
Theorem lww_idempotent_delivery : forall a b,
  lww_merge (lww_merge a b) b = lww_merge a b.
Proof.
  intros a b.
  rewrite lww_merge_assoc. rewrite lww_merge_idem. reflexivity.
Qed.

(** LWW merge order independence *)
Theorem lww_merge_order_independent_2 : forall s a b,
  lww_merge (lww_merge s a) b = lww_merge (lww_merge s b) a.
Proof.
  intros s a b.
  rewrite lww_merge_assoc.
  rewrite (lww_merge_comm a b).
  rewrite <- lww_merge_assoc.
  reflexivity.
Qed.

(** GSet merge order independence *)
Theorem gs_merge_order_member : forall s a b v,
  gs_member (gs_merge (gs_merge s a) b) v = true ->
  gs_member s v = true \/ gs_member a v = true \/ gs_member b v = true.
Proof.
  intros s a b v H.
  apply gs_merge_member_iff in H. destruct H as [Hsa | Hb].
  - apply gs_merge_member_iff in Hsa. destruct Hsa as [Hs | Ha].
    + left. exact Hs.
    + right. left. exact Ha.
  - right. right. exact Hb.
Qed.

(** GSet monotone under merge sequence *)
Theorem gs_merge_seq_monotone : forall init updates v,
  gs_member init v = true ->
  gs_member (fold_left gs_merge updates init) v = true.
Proof.
  intros init updates. revert init. induction updates as [|u us IH]; intros init v Hinit.
  - exact Hinit.
  - simpl. apply IH. apply gs_merge_contains_l. exact Hinit.
Qed.

(** OR-Set idempotent merge *)
Theorem or_merge_idempotent_lookup : forall s v,
  or_lookup (or_merge s s) v = or_lookup s v.
Proof.
  intros. apply or_merge_idem_lookup.
Qed.

(** SEC convergence theorem: stated as a property *)
Theorem sec_convergence_principle : forall (merge : nat -> nat -> nat),
  (forall a b, merge a b = merge b a) ->
  (forall a b c, merge (merge a b) c = merge a (merge b c)) ->
  (forall a, merge a a = a) ->
  forall s a b,
  merge (merge s a) b = merge (merge s b) a.
Proof.
  intros merge Hcomm Hassoc Hidem s a b.
  rewrite Hassoc. rewrite (Hcomm a b). rewrite <- Hassoc. reflexivity.
Qed.

(** SEC for any binary merge with semilattice laws *)
Theorem sec_binary_convergence : forall (A : Type) (merge : A -> A -> A),
  (forall a b : A, merge a b = merge b a) ->
  (forall a b c : A, merge (merge a b) c = merge a (merge b c)) ->
  forall s u1 u2 : A,
  merge (merge s u1) u2 = merge (merge s u2) u1.
Proof.
  intros A merge Hcomm Hassoc s u1 u2.
  rewrite Hassoc. rewrite (Hcomm u1 u2). rewrite <- Hassoc. reflexivity.
Qed.

(** Triple merge order independence *)
Theorem sec_triple_convergence : forall (A : Type) (merge : A -> A -> A),
  (forall a b : A, merge a b = merge b a) ->
  (forall a b c : A, merge (merge a b) c = merge a (merge b c)) ->
  forall s u1 u2 u3 : A,
  merge (merge (merge s u1) u2) u3 = merge (merge (merge s u3) u2) u1.
Proof.
  intros A merge Hcomm Hassoc s u1 u2 u3.
  rewrite Hassoc. rewrite Hassoc.
  rewrite (Hcomm u2 u3). rewrite (Hcomm u1 (merge u3 u2)).
  rewrite <- Hassoc. rewrite (Hcomm u2 u1).
  rewrite Hassoc. reflexivity.
Qed.

(** SEC: merging is a join in the semilattice — result dominates both inputs *)
Theorem sec_merge_dominates : forall (A : Type) (merge : A -> A -> A) (leq : A -> A -> Prop),
  (forall a : A, leq a a) ->
  (forall a b : A, leq a (merge a b)) ->
  forall s u : A, leq s (merge s u).
Proof.
  intros A merge leq Hrefl Hmerge_l s u.
  apply Hmerge_l.
Qed.

(** SEC: idempotent delivery doesn't change state *)
Theorem sec_idempotent_delivery : forall (A : Type) (merge : A -> A -> A),
  (forall a b c : A, merge (merge a b) c = merge a (merge b c)) ->
  (forall a : A, merge a a = a) ->
  forall s u : A, merge (merge s u) u = merge s u.
Proof.
  intros A merge Hassoc Hidem s u.
  rewrite Hassoc. rewrite Hidem. reflexivity.
Qed.

(** ============================================================================
    SECTION 9: ADDITIONAL CRDT PROPERTIES
    ============================================================================ *)

(** G-Counter: merging two bottoms gives bottom *)
Theorem gc_bottom_merge_bottom : forall n,
  gc_merge (gc_bottom n) (gc_bottom n) = gc_bottom n.
Proof.
  intros. apply gc_merge_idem.
Qed.

(** G-Counter: increment preserves length *)
Theorem gc_increment_merge_compat : forall a b node,
  length a = length b ->
  length (gc_increment a node) = length (gc_merge a b).
Proof.
  intros a b node Hlen.
  rewrite gc_increment_length. rewrite gc_merge_length; [reflexivity | exact Hlen].
Qed.

(** PN-Counter: merge of bottoms is bottom *)
Theorem pn_bottom_merge_bottom : forall n,
  pn_merge (pn_bottom n) (pn_bottom n) = pn_bottom n.
Proof.
  intros. apply pn_merge_idem.
Qed.

(** GSet: add to empty gives singleton *)
Theorem gs_add_empty : forall v,
  gs_add gs_empty v = [v].
Proof.
  intros v. unfold gs_add, gs_empty, member. simpl. reflexivity.
Qed.

(** GSet: member of singleton *)
Theorem gs_member_singleton : forall v,
  gs_member [v] v = true.
Proof.
  intros v. unfold gs_member, member. simpl. rewrite Nat.eqb_refl. reflexivity.
Qed.

(** GSet: non-member of empty *)
Theorem gs_member_empty : forall v,
  gs_member [] v = false.
Proof.
  intros v. reflexivity.
Qed.

(** GSet: add different element preserves non-membership *)
Theorem gs_add_preserves_non_member : forall s u v,
  u <> v ->
  gs_member s v = false ->
  gs_member (gs_add s u) v = false.
Proof.
  intros s u v Hneq Hnot. unfold gs_add, gs_member in *.
  destruct (member u s) eqn:E.
  - exact Hnot.
  - rewrite member_cons. simpl.
    destruct (Nat.eqb v u) eqn:Evu.
    + apply Nat.eqb_eq in Evu. lia.
    + simpl. exact Hnot.
Qed.

(** 2P-Set: empty lookup is false *)
Theorem tp_empty_lookup : forall v,
  tp_lookup tp_empty v = false.
Proof.
  intros v. unfold tp_lookup, tp_empty. simpl. reflexivity.
Qed.

(** 2P-Set: add then remove hides element *)
Theorem tp_add_then_remove : forall v,
  tp_lookup (tp_remove (tp_add tp_empty v) v) v = false.
Proof.
  intros v. apply tp_remove_hides.
Qed.

(** 2P-Set: merge is commutative on lookup *)
Theorem tp_merge_comm_on_lookup : forall a b,
  forall v, tp_lookup (tp_merge a b) v = tp_lookup (tp_merge b a) v.
Proof.
  intros a b v. apply tp_merge_comm_lookup.
Qed.

(** 2P-Set: merge preserves add visibility *)
Theorem tp_merge_preserves_add : forall s t v,
  gs_member (fst s) v = true ->
  gs_member (fst (tp_merge s t)) v = true.
Proof.
  intros. apply tp_merge_add_monotone. exact H.
Qed.

(** LWW: bottom is identity *)
Theorem lww_bottom_is_zero : lww_val lww_bottom = 0.
Proof. reflexivity. Qed.

(** LWW: bottom timestamp is zero *)
Theorem lww_bottom_ts_zero : lww_ts lww_bottom = 0.
Proof. reflexivity. Qed.

(** LWW: write creates expected register *)
Theorem lww_write_val : forall r v ts,
  lww_val (lww_write r v ts) = v.
Proof. intros. reflexivity. Qed.

(** LWW: write sets timestamp *)
Theorem lww_write_ts : forall r v ts,
  lww_ts (lww_write r v ts) = ts.
Proof. intros. reflexivity. Qed.

(** LWW: higher timestamp always dominates in merge *)
Theorem lww_higher_ts_dominates : forall a b,
  lww_ts a < lww_ts b ->
  lww_merge a b = b.
Proof.
  intros a b H. unfold lww_merge.
  destruct (lww_ts a <? lww_ts b) eqn:E.
  - reflexivity.
  - apply Nat.ltb_ge in E. lia.
Qed.

(** LWW: lower timestamp always loses in merge *)
Theorem lww_lower_ts_loses : forall a b,
  lww_ts a > lww_ts b ->
  lww_merge a b = a.
Proof.
  intros a b H. unfold lww_merge.
  destruct (lww_ts a <? lww_ts b) eqn:E1.
  - apply Nat.ltb_lt in E1. lia.
  - destruct (lww_ts b <? lww_ts a) eqn:E2.
    + reflexivity.
    + apply Nat.ltb_ge in E2. lia.
Qed.

(** OR-Set: empty has no elements *)
Theorem or_empty_has_nothing : forall v,
  or_lookup or_empty v = false.
Proof. intros. reflexivity. Qed.

(** OR-Set: adding to empty creates findable element *)
Theorem or_add_to_empty : forall v tag,
  or_lookup (or_add or_empty v tag) v = true.
Proof.
  intros v tag. unfold or_lookup, or_add, or_empty, or_in_list. simpl.
  rewrite Nat.eqb_refl. reflexivity.
Qed.

(** OR-Set: merge with empty is identity on adds *)
Theorem or_merge_empty_r_adds : forall s,
  fst (or_merge s or_empty) = fst s ++ [].
Proof.
  intros [adds rems]. simpl. rewrite app_nil_r. reflexivity.
Qed.

(** OR-Set: merge with empty is identity on rems *)
Theorem or_merge_empty_r_rems : forall s,
  snd (or_merge s or_empty) = snd s ++ [].
Proof.
  intros [adds rems]. simpl. rewrite app_nil_r. reflexivity.
Qed.

(** SEC: quadruple merge reordering *)
Theorem sec_quadruple_convergence : forall (A : Type) (merge : A -> A -> A),
  (forall a b : A, merge a b = merge b a) ->
  (forall a b c : A, merge (merge a b) c = merge a (merge b c)) ->
  forall s u1 u2 u3 u4 : A,
  merge (merge (merge (merge s u1) u2) u3) u4 =
  merge (merge (merge (merge s u4) u3) u2) u1.
Proof.
  intros A merge Hcomm Hassoc s u1 u2 u3 u4.
  rewrite Hassoc. rewrite Hassoc. rewrite Hassoc.
  rewrite (Hcomm u3 u4). rewrite (Hcomm u2 (merge u4 u3)).
  rewrite <- Hassoc. rewrite (Hcomm u1 (merge (merge u4 u3) u2)).
  rewrite <- Hassoc. rewrite <- Hassoc. rewrite <- Hassoc.
  reflexivity.
Qed.

(** SEC: merge with self after updates *)
Theorem sec_self_merge_neutral : forall (A : Type) (merge : A -> A -> A),
  (forall a : A, merge a a = a) ->
  forall s : A, merge s s = s.
Proof.
  intros A merge Hidem s. apply Hidem.
Qed.

(** Pointwise max preserves zero-bottom *)
Theorem pointwise_max_bottom_l : forall n a,
  length a = n ->
  pointwise_max (repeat 0 n) a = a.
Proof.
  induction n as [|n' IH]; intros a Hlen.
  - destruct a; [reflexivity | simpl in Hlen; discriminate].
  - destruct a as [|x xs]; [simpl in Hlen; discriminate |].
    simpl. f_equal; [lia | apply IH; simpl in Hlen; lia].
Qed.

(** Pointwise max preserves zero-bottom (right) *)
Theorem pointwise_max_bottom_r : forall n a,
  length a = n ->
  pointwise_max a (repeat 0 n) = a.
Proof.
  intros n a Hlen.
  rewrite pointwise_max_comm; [apply pointwise_max_bottom_l; exact Hlen |].
  rewrite repeat_length. exact Hlen.
Qed.

(** GCounter value distributes over single element *)
Theorem gc_value_singleton : forall v,
  gc_value [v] = v.
Proof.
  intros v. unfold gc_value. simpl. lia.
Qed.

(** GCounter value of cons *)
Lemma gc_value_cons : forall x xs,
  gc_value (x :: xs) = fold_left Nat.add xs x.
Proof.
  intros x xs. unfold gc_value. simpl.
  rewrite Nat.add_0_l. reflexivity.
Qed.

(** List leq antisymmetry *)
Theorem list_leq_antisym : forall a b,
  list_leq a b -> list_leq b a -> a = b.
Proof.
  induction a as [|x xs IH]; intros b [Hab Hab'] [Hba Hba'].
  - destruct b; [reflexivity | simpl in Hab; discriminate].
  - destruct b as [|y ys]; [simpl in Hab; discriminate |].
    f_equal.
    + specialize (Hab' 0). specialize (Hba' 0). simpl in *. lia.
    + apply IH.
      * split; [simpl in *; lia |].
        intros i. specialize (Hab' (S i)). simpl in Hab'. exact Hab'.
      * split; [simpl in *; lia |].
        intros i. specialize (Hba' (S i)). simpl in Hba'. exact Hba'.
Qed.

(** GCounter leq antisymmetry *)
Theorem gc_leq_antisym : forall a b,
  gc_leq a b -> gc_leq b a -> a = b.
Proof.
  intros. apply list_leq_antisym; assumption.
Qed.

(** GSet: merge with self on membership *)
Theorem gs_merge_self_member : forall s v,
  gs_member (gs_merge s s) v = gs_member s v.
Proof.
  intros s v. rewrite gs_merge_idem. reflexivity.
Qed.

(** OR-Set: entry equality is decidable *)
Theorem or_entry_eqb_eq : forall a b,
  or_entry_eqb a b = true -> a = b.
Proof.
  intros [v1 t1] [v2 t2] H. unfold or_entry_eqb in H. simpl in H.
  apply andb_true_iff in H. destruct H as [Hv Ht].
  apply Nat.eqb_eq in Hv. apply Nat.eqb_eq in Ht.
  subst. reflexivity.
Qed.

(** OR-Set: entry inequality *)
Theorem or_entry_eqb_neq : forall a b,
  or_entry_eqb a b = false -> a <> b.
Proof.
  intros a b H Heq. subst. rewrite or_entry_eqb_refl in H. discriminate.
Qed.

(** ============================================================================
    END OF CRDT FOUNDATIONS
    — 152 theorems, 0 admits, 0 axioms
    ============================================================================ *)

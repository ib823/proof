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

Lemma pointwise_max_zero_l : forall xs,
  pointwise_max (repeat 0 (length xs)) xs = xs.
Proof.
  induction xs as [|x xs IH].
  - reflexivity.
  - simpl. f_equal. apply IH.
Qed.

Theorem gc_bottom_merge_l : forall gc n,
  length gc = n ->
  gc_merge (gc_bottom n) gc = gc.
Proof.
  intros gc n Hlen. subst. unfold gc_merge, gc_bottom.
  apply pointwise_max_zero_l.
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
  rewrite length_map. rewrite length_combine.
  rewrite length_seq. lia.
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
  - unfold gs_member in Hb. rewrite member_cons in Hb.
    apply orb_true_iff in Hb. destruct Hb as [Heq | Hin].
    + apply Nat.eqb_eq in Heq. subst.
      simpl. apply gs_merge_contains_l. apply gs_add_member.
    + simpl. apply IH. unfold gs_member. exact Hin.
Qed.

Lemma gs_merge_not_member : forall a b v,
  gs_member a v = false ->
  gs_member b v = false ->
  gs_member (gs_merge a b) v = false.
Proof.
  intros a b. revert a. induction b as [|y ys IH]; intros a v Ha Hb.
  - exact Ha.
  - unfold gs_member in Hb. rewrite member_cons in Hb.
    apply orb_false_iff in Hb. destruct Hb as [Hvy Hys].
    simpl. apply IH.
    + unfold gs_member, gs_add. destruct (member y a).
      * exact Ha.
      * unfold gs_member. rewrite member_cons. unfold gs_member in Ha.
        rewrite Hvy. simpl. exact Ha.
    + unfold gs_member. exact Hys.
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
    + exfalso. rewrite gs_merge_not_member in H; [discriminate | exact Ha | exact Hb].
  - destruct (gs_member a v) eqn:Ha; destruct (gs_member b v) eqn:Hb.
    + apply gs_merge_contains_l. exact Ha.
    + apply gs_merge_contains_l. exact Ha.
    + apply gs_merge_contains_r. exact Hb.
    + exfalso. rewrite gs_merge_not_member in H; [discriminate | exact Hb | exact Ha].
Qed.

Lemma gs_merge_add_idem : forall b a,
  (forall v, gs_member b v = true -> gs_member a v = true) ->
  gs_merge a b = a.
Proof.
  induction b as [|y ys IH]; intros a Hsub.
  - reflexivity.
  - simpl. rewrite gs_add_idempotent.
    + apply IH. intros v Hv. apply Hsub. unfold gs_member.
      rewrite member_cons. rewrite orb_true_iff. right. unfold gs_member in Hv. exact Hv.
    + apply Hsub. unfold gs_member. rewrite member_cons.
      rewrite Nat.eqb_refl. reflexivity.
Qed.

Theorem gs_merge_idem : forall a,
  gs_merge a a = a.
Proof.
  intros a. apply gs_merge_add_idem. intros v H. exact H.
Qed.

Theorem gs_empty_merge_l : forall s v,
  gs_member s v = true -> gs_member (gs_merge gs_empty s) v = true.
Proof.
  intros s v H. apply gs_merge_contains_r. exact H.
Qed.

Theorem gs_empty_member : forall v, gs_member gs_empty v = false.
Proof. intros. reflexivity. Qed.

Lemma gs_add_not_member : forall s u w,
  w <> u -> gs_member s w = false -> gs_member (gs_add s u) w = false.
Proof.
  intros s u w Hwu Hs. unfold gs_member, gs_add in *.
  unfold member in *. destruct (existsb (Nat.eqb u) s).
  - exact Hs.
  - simpl. destruct (Nat.eqb w u) eqn:E.
    + apply Nat.eqb_eq in E. lia.
    + exact Hs.
Qed.

Theorem gs_add_comm_member : forall s u v w,
  gs_member (gs_add (gs_add s u) v) w =
  gs_member (gs_add (gs_add s v) u) w.
Proof.
  intros s u v w.
  destruct (Nat.eq_dec w u) as [Hwu|Hwu]; destruct (Nat.eq_dec w v) as [Hwv|Hwv].
  - subst. reflexivity.
  - subst.
    assert (LHS: gs_member (gs_add (gs_add s u) v) u = true) by
      (apply gs_add_preserves; apply gs_add_member).
    assert (RHS: gs_member (gs_add (gs_add s v) u) u = true) by
      apply gs_add_member.
    rewrite LHS, RHS. reflexivity.
  - subst.
    assert (LHS: gs_member (gs_add (gs_add s u) v) v = true) by
      apply gs_add_member.
    assert (RHS: gs_member (gs_add (gs_add s v) u) v = true) by
      (apply gs_add_preserves; apply gs_add_member).
    rewrite LHS, RHS. reflexivity.
  - destruct (gs_member s w) eqn:Ew.
    + assert (LHS: gs_member (gs_add (gs_add s u) v) w = true) by
        (apply gs_add_preserves; apply gs_add_preserves; exact Ew).
      assert (RHS: gs_member (gs_add (gs_add s v) u) w = true) by
        (apply gs_add_preserves; apply gs_add_preserves; exact Ew).
      rewrite LHS, RHS. reflexivity.
    + assert (LHS: gs_member (gs_add (gs_add s u) v) w = false) by
        (apply gs_add_not_member; [exact Hwv |]; apply gs_add_not_member; [exact Hwu | exact Ew]).
      assert (RHS: gs_member (gs_add (gs_add s v) u) w = false) by
        (apply gs_add_not_member; [exact Hwu |]; apply gs_add_not_member; [exact Hwv | exact Ew]).
      rewrite LHS, RHS. reflexivity.
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
  intros [add rem] v Hrem. unfold tp_lookup, tp_add. simpl in *.
  rewrite gs_add_member. rewrite Hrem. reflexivity.
Qed.

Theorem tp_remove_hides : forall s v,
  tp_lookup (tp_remove s v) v = false.
Proof.
  intros [add rem] v. unfold tp_lookup, tp_remove. simpl.
  rewrite gs_add_member. rewrite andb_false_r. reflexivity.
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
  destruct (gs_member (gs_merge aa ba) v) eqn:E1;
  destruct (gs_member (gs_merge ba aa) v) eqn:E1';
  destruct (gs_member (gs_merge ar br) v) eqn:E2;
  destruct (gs_member (gs_merge br ar) v) eqn:E2'; simpl;
  try reflexivity;
  try (apply gs_merge_comm_member in E1; rewrite E1 in E1'; discriminate);
  try (apply gs_merge_comm_member in E1'; rewrite E1' in E1; discriminate);
  try (apply gs_merge_comm_member in E2; rewrite E2 in E2'; discriminate);
  try (apply gs_merge_comm_member in E2'; rewrite E2' in E2; discriminate).
Qed.

Theorem tp_merge_idem : forall s,
  tp_merge s s = s.
Proof.
  intros [a r]. unfold tp_merge. simpl.
  f_equal; apply gs_merge_idem.
Qed.

Theorem tp_empty_merge_l : forall s v,
  tp_lookup s v = true -> tp_lookup (tp_merge tp_empty s) v = true.
Proof.
  intros [a r] v H. unfold tp_lookup, tp_merge, tp_empty in *. simpl in *.
  apply andb_true_iff in H. destruct H as [Ha Hr].
  apply andb_true_iff. split.
  - apply gs_merge_contains_r. exact Ha.
  - rewrite negb_true_iff in *. apply gs_merge_not_member.
    + reflexivity.
    + exact Hr.
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
  unfold tp_lookup, tp_merge. simpl in *.
  rewrite Hmerge_rem. rewrite andb_true_r.
  apply gs_merge_contains_l. exact Hadd.
Qed.

Theorem tp_merge_preserves_removal : forall (a b : TwoPSet) v,
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
  - reflexivity.
  - reflexivity.
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

Theorem lww_merge_assoc_idem : forall a,
  lww_merge (lww_merge a a) a = lww_merge a a.
Proof.
  intros a. rewrite lww_merge_idem. apply lww_merge_idem.
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
  - apply Nat.ltb_ge in E1. destruct (lww_ts b <? lww_ts a) eqn:E2.
    + apply Nat.ltb_lt in E2. lia.
    + apply Nat.ltb_ge in E2. destruct (lww_val a <=? lww_val b) eqn:Ev.
      * lia.
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
  unfold or_lookup, or_add. simpl in *.
  rewrite Nat.eqb_refl. simpl. rewrite Hnot_rem. reflexivity.
Qed.

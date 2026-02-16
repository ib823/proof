(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Effect Algebra for RIINA
    
    Algebraic structure of effects.
    
    This module proves that effects form a join-semilattice (linear order).
*)

Require Import RIINA.foundations.Syntax.
Require Import Coq.Arith.Arith.
Require Import Coq.Arith.PeanoNat.
Require Import Coq.Bool.Bool.
Require Import Lia.

(** Effect ordering based on levels *)
Definition effect_leq (e1 e2 : effect) : Prop :=
  effect_level e1 <= effect_level e2.

(** ** Partial Order Properties *)

Lemma effect_leq_refl : forall e, effect_leq e e.
Proof.
  intros e. unfold effect_leq. apply le_n.
Qed.

Lemma effect_leq_trans : forall e1 e2 e3,
  effect_leq e1 e2 -> effect_leq e2 e3 -> effect_leq e1 e3.
Proof.
  intros e1 e2 e3 H1 H2. unfold effect_leq in *.
  eapply Nat.le_trans; eassumption.
Qed.

Lemma effect_leq_antisym : forall e1 e2,
  effect_leq e1 e2 -> effect_leq e2 e1 -> e1 = e2.
Proof.
  intros e1 e2 H1 H2.
  unfold effect_leq in *.
  assert (H: effect_level e1 = effect_level e2) by (apply Nat.le_antisymm; assumption).
  destruct e1; destruct e2; simpl in H; try reflexivity; try discriminate.
Qed.

(** ** Join Semilattice Properties *)

Lemma effect_join_comm : forall e1 e2,
  effect_join e1 e2 = effect_join e2 e1.
Proof.
  intros e1 e2.
  unfold effect_join.
  destruct (effect_level e1 <? effect_level e2) eqn:H12.
  - apply Nat.ltb_lt in H12.
    destruct (effect_level e2 <? effect_level e1) eqn:H21.
    + apply Nat.ltb_lt in H21.
      exfalso. apply (Nat.lt_asymm (effect_level e1) (effect_level e2)); assumption.
    + reflexivity.
  - apply Nat.ltb_ge in H12.
    destruct (effect_level e2 <? effect_level e1) eqn:H21.
    + reflexivity.
    + apply Nat.ltb_ge in H21.
      (* e1 >= e2 and e2 >= e1 implies e1 = e2 levels *)
      assert (Heq: effect_level e1 = effect_level e2) by (apply Nat.le_antisymm; assumption).
      apply effect_leq_antisym; unfold effect_leq; rewrite Heq; apply le_n.
Qed.

Lemma effect_level_join : forall e1 e2,
  effect_level (effect_join e1 e2) = Nat.max (effect_level e1) (effect_level e2).
Proof.
  intros e1 e2. unfold effect_join.
  destruct (effect_level e1 <? effect_level e2) eqn:H.
  - apply Nat.ltb_lt in H. rewrite Nat.max_r; lia.
  - apply Nat.ltb_ge in H. rewrite Nat.max_l; lia.
Qed.

Lemma effect_join_assoc : forall e1 e2 e3,
  effect_join e1 (effect_join e2 e3) = effect_join (effect_join e1 e2) e3.
Proof.
  intros e1 e2 e3.
  apply effect_leq_antisym; unfold effect_leq; repeat rewrite effect_level_join; rewrite Nat.max_assoc; apply le_n.
Qed.

Lemma effect_join_ub_l : forall e1 e2, effect_leq e1 (effect_join e1 e2).
Proof.
  intros e1 e2. unfold effect_join, effect_leq.
  destruct (effect_level e1 <? effect_level e2) eqn:H.
  - apply Nat.ltb_lt in H. apply Nat.lt_le_incl. assumption.
  - apply Nat.ltb_ge in H. apply le_n.
Qed.

Lemma effect_join_ub_r : forall e1 e2, effect_leq e2 (effect_join e1 e2).
Proof.
  intros e1 e2. unfold effect_join, effect_leq.
  destruct (effect_level e1 <? effect_level e2) eqn:H.
  - apply Nat.ltb_lt in H. apply le_n.
  - apply Nat.ltb_ge in H. assumption.
Qed.

Lemma effect_join_lub : forall e1 e2 e3,
  effect_leq e1 e3 -> effect_leq e2 e3 -> effect_leq (effect_join e1 e2) e3.
Proof.
  intros e1 e2 e3 H1 H2. unfold effect_join, effect_leq in *.
  destruct (effect_level e1 <? effect_level e2).
  - assumption.
  - assumption.
Qed.

(** ** Additional Algebraic Properties *)

(** Effect join is idempotent: joining an effect with itself yields itself. *)
Lemma effect_join_idem : forall e, effect_join e e = e.
Proof.
  intros e. unfold effect_join.
  rewrite Nat.ltb_irrefl. reflexivity.
Qed.

(** The effect ordering is total: any two effects are comparable. *)
Lemma effect_leq_total : forall e1 e2,
  effect_leq e1 e2 \/ effect_leq e2 e1.
Proof.
  intros e1 e2. unfold effect_leq.
  destruct (le_gt_dec (effect_level e1) (effect_level e2)).
  - left. assumption.
  - right. lia.
Qed.

(** Decidability of effect ordering. *)
Lemma effect_leq_dec : forall e1 e2,
  {effect_leq e1 e2} + {~ effect_leq e1 e2}.
Proof.
  intros e1 e2. unfold effect_leq.
  apply le_dec.
Qed.

(** EffPure is the bottom element of the effect lattice. *)
Lemma effect_pure_bottom : forall e, effect_leq EffPure e.
Proof.
  intros e. unfold effect_leq. simpl. apply Nat.le_0_l.
Qed.

(** Joining with EffPure from the left (generalized statement). *)
Lemma effect_join_pure_l_general : forall e,
  effect_leq EffPure e -> effect_join EffPure e = e.
Proof.
  intros e _. apply effect_join_pure_l.
Qed.

(** Joining with EffPure from the right (generalized statement). *)
Lemma effect_join_pure_r_general : forall e,
  effect_leq EffPure e -> effect_join e EffPure = e.
Proof.
  intros e _. apply effect_join_pure_r.
Qed.

(** Effect level is injective: distinct levels imply distinct effects.
    This holds because each effect has a unique level (0 through 16). *)
Lemma effect_level_injective : forall e1 e2,
  effect_level e1 = effect_level e2 -> e1 = e2.
Proof.
  intros e1 e2.
  destruct e1; destruct e2; simpl; intro H; try reflexivity; discriminate.
Qed.

(** Effect join monotonicity: if e1 <= e2 then join(e1, e3) <= join(e2, e3). *)
Lemma effect_join_mono_l : forall e1 e2 e3,
  effect_leq e1 e2 -> effect_leq (effect_join e1 e3) (effect_join e2 e3).
Proof.
  intros e1 e2 e3 H12. unfold effect_leq in *.
  repeat rewrite effect_level_join.
  apply Nat.max_le_compat_r. assumption.
Qed.

(** Right monotonicity of effect join. *)
Lemma effect_join_mono_r : forall e1 e2 e3,
  effect_leq e1 e2 -> effect_leq (effect_join e3 e1) (effect_join e3 e2).
Proof.
  intros e1 e2 e3 H12. unfold effect_leq in *.
  repeat rewrite effect_level_join.
  apply Nat.max_le_compat_l. assumption.
Qed.

(** Join characterization: join(e1, e2) = e2 iff e1 <= e2. *)
Lemma effect_join_leq_iff : forall e1 e2,
  effect_join e1 e2 = e2 <-> effect_leq e1 e2.
Proof.
  intros e1 e2. split.
  - intros Hjoin. rewrite <- Hjoin. apply effect_join_ub_l.
  - intros Hleq. apply effect_leq_antisym.
    + apply effect_join_lub.
      * exact Hleq.
      * apply effect_leq_refl.
    + apply effect_join_ub_r.
Qed.

(** Symmetric form: join(e1, e2) = e1 iff e2 <= e1. *)
Lemma effect_join_leq_iff_l : forall e1 e2,
  effect_join e1 e2 = e1 <-> effect_leq e2 e1.
Proof.
  intros e1 e2. rewrite effect_join_comm. apply effect_join_leq_iff.
Qed.

(** ** Binary Meet (Minimum) *)

(** Effect meet: takes the minimum of two effects. *)
Definition effect_meet (e1 e2 : effect) : effect :=
  if effect_level e1 <? effect_level e2 then e1 else e2.

(** Meet is commutative. *)
Lemma effect_meet_comm : forall e1 e2,
  effect_meet e1 e2 = effect_meet e2 e1.
Proof.
  intros e1 e2. unfold effect_meet.
  destruct (effect_level e1 <? effect_level e2) eqn:H12.
  - apply Nat.ltb_lt in H12.
    destruct (effect_level e2 <? effect_level e1) eqn:H21.
    + apply Nat.ltb_lt in H21. exfalso; lia.
    + apply Nat.ltb_ge in H21.
      apply effect_leq_antisym; unfold effect_leq; lia.
  - apply Nat.ltb_ge in H12.
    destruct (effect_level e2 <? effect_level e1) eqn:H21.
    + apply Nat.ltb_lt in H21.
      apply effect_leq_antisym; unfold effect_leq; lia.
    + apply Nat.ltb_ge in H21.
      assert (Heq: effect_level e1 = effect_level e2) by lia.
      assert (e1 = e2) by (apply effect_level_injective; exact Heq).
      subst. reflexivity.
Qed.

(** Meet is idempotent. *)
Lemma effect_meet_idem : forall e, effect_meet e e = e.
Proof.
  intros e. unfold effect_meet. rewrite Nat.ltb_irrefl. reflexivity.
Qed.

(** Meet is a lower bound (left). *)
Lemma effect_meet_lb_l : forall e1 e2, effect_leq (effect_meet e1 e2) e1.
Proof.
  intros e1 e2. unfold effect_meet, effect_leq.
  destruct (effect_level e1 <? effect_level e2) eqn:H.
  - apply le_n.
  - apply Nat.ltb_ge in H. assumption.
Qed.

(** Meet is a lower bound (right). *)
Lemma effect_meet_lb_r : forall e1 e2, effect_leq (effect_meet e1 e2) e2.
Proof.
  intros e1 e2. unfold effect_meet, effect_leq.
  destruct (effect_level e1 <? effect_level e2) eqn:H.
  - apply Nat.ltb_lt in H. lia.
  - apply le_n.
Qed.

(** Meet is the greatest lower bound. *)
Lemma effect_meet_glb : forall e1 e2 e3,
  effect_leq e3 e1 -> effect_leq e3 e2 -> effect_leq e3 (effect_meet e1 e2).
Proof.
  intros e1 e2 e3 H1 H2. unfold effect_meet, effect_leq in *.
  destruct (effect_level e1 <? effect_level e2).
  - assumption.
  - assumption.
Qed.

(** Meet level equals Nat.min. *)
Lemma effect_level_meet : forall e1 e2,
  effect_level (effect_meet e1 e2) = Nat.min (effect_level e1) (effect_level e2).
Proof.
  intros e1 e2. unfold effect_meet.
  destruct (effect_level e1 <? effect_level e2) eqn:H.
  - apply Nat.ltb_lt in H. rewrite Nat.min_l; lia.
  - apply Nat.ltb_ge in H. rewrite Nat.min_r; lia.
Qed.

(** Meet is associative. *)
Lemma effect_meet_assoc : forall e1 e2 e3,
  effect_meet e1 (effect_meet e2 e3) = effect_meet (effect_meet e1 e2) e3.
Proof.
  intros e1 e2 e3.
  apply effect_leq_antisym; unfold effect_leq;
    repeat rewrite effect_level_meet; rewrite Nat.min_assoc; apply le_n.
Qed.

(** ** Absorption Laws *)

(** Join absorbs meet: join(e, meet(e, e')) = e. *)
Lemma effect_join_meet_absorb : forall e1 e2,
  effect_join e1 (effect_meet e1 e2) = e1.
Proof.
  intros e1 e2.
  apply effect_leq_antisym; unfold effect_leq;
    rewrite effect_level_join, effect_level_meet; lia.
Qed.

(** Meet absorbs join: meet(e, join(e, e')) = e. *)
Lemma effect_meet_join_absorb : forall e1 e2,
  effect_meet e1 (effect_join e1 e2) = e1.
Proof.
  intros e1 e2.
  apply effect_leq_antisym; unfold effect_leq;
    rewrite effect_level_meet, ?effect_level_join; lia.
Qed.

(** ** Distribution Laws *)

(** Join distributes over meet. *)
Lemma effect_join_meet_distr : forall e1 e2 e3,
  effect_join e1 (effect_meet e2 e3) =
  effect_meet (effect_join e1 e2) (effect_join e1 e3).
Proof.
  intros e1 e2 e3.
  apply effect_leq_antisym; unfold effect_leq;
    rewrite effect_level_join, effect_level_meet,
            effect_level_meet, !effect_level_join;
    lia.
Qed.

(** Meet distributes over join. *)
Lemma effect_meet_join_distr : forall e1 e2 e3,
  effect_meet e1 (effect_join e2 e3) =
  effect_join (effect_meet e1 e2) (effect_meet e1 e3).
Proof.
  intros e1 e2 e3.
  apply effect_leq_antisym; unfold effect_leq;
    rewrite effect_level_meet, effect_level_join,
            effect_level_join, !effect_level_meet;
    lia.
Qed.

(** ** Top Element *)

(** EffGapura is the top element (highest effect level). *)
Lemma effect_gapura_top : forall e, effect_leq e EffGapura.
Proof.
  intros e. unfold effect_leq.
  destruct e; simpl; lia.
Qed.

(** Joining with EffGapura always gives EffGapura. *)
Lemma effect_join_gapura : forall e, effect_join e EffGapura = EffGapura.
Proof.
  intros e. apply effect_join_leq_iff. apply effect_gapura_top.
Qed.

(** Meeting with EffPure always gives EffPure. *)
Lemma effect_meet_pure : forall e, effect_meet e EffPure = EffPure.
Proof.
  intros e. unfold effect_meet. destruct e; simpl; reflexivity.
Qed.

(** Meeting with EffGapura always gives the other effect. *)
Lemma effect_meet_gapura : forall e, effect_meet e EffGapura = e.
Proof.
  intros e. unfold effect_meet.
  destruct e; simpl; reflexivity.
Qed.

(** ** Strict Order *)

(** Strict effect ordering. *)
Definition effect_lt (e1 e2 : effect) : Prop :=
  effect_level e1 < effect_level e2.

(** Strict order is irreflexive. *)
Lemma effect_lt_irrefl : forall e, ~ effect_lt e e.
Proof.
  intros e H. unfold effect_lt in H. lia.
Qed.

(** Strict order is transitive. *)
Lemma effect_lt_trans : forall e1 e2 e3,
  effect_lt e1 e2 -> effect_lt e2 e3 -> effect_lt e1 e3.
Proof.
  intros e1 e2 e3 H1 H2. unfold effect_lt in *. lia.
Qed.

(** Strict implies non-strict. *)
Lemma effect_lt_leq : forall e1 e2,
  effect_lt e1 e2 -> effect_leq e1 e2.
Proof.
  intros e1 e2 H. unfold effect_lt, effect_leq in *. lia.
Qed.

(** Trichotomy: exactly one of <, =, > holds. *)
Lemma effect_trichotomy : forall e1 e2,
  effect_lt e1 e2 \/ e1 = e2 \/ effect_lt e2 e1.
Proof.
  intros e1 e2. unfold effect_lt.
  destruct (Nat.lt_trichotomy (effect_level e1) (effect_level e2)) as [H | [H | H]].
  - left. exact H.
  - right. left. apply effect_level_injective. exact H.
  - right. right. exact H.
Qed.

(** ** Strict order composition *)

Lemma effect_lt_leq_trans : forall e1 e2 e3,
  effect_lt e1 e2 -> effect_leq e2 e3 -> effect_lt e1 e3.
Proof.
  intros e1 e2 e3 H1 H2. unfold effect_lt, effect_leq in *. lia.
Qed.

Lemma effect_leq_lt_trans : forall e1 e2 e3,
  effect_leq e1 e2 -> effect_lt e2 e3 -> effect_lt e1 e3.
Proof.
  intros e1 e2 e3 H1 H2. unfold effect_lt, effect_leq in *. lia.
Qed.

(** Strict order implies distinct effects *)
Lemma effect_lt_not_eq : forall e1 e2,
  effect_lt e1 e2 -> e1 <> e2.
Proof.
  intros e1 e2 H Heq. subst. apply effect_lt_irrefl in H. exact H.
Qed.

(** Strict order is asymmetric *)
Lemma effect_lt_asymmetric : forall e1 e2,
  effect_lt e1 e2 -> ~ effect_lt e2 e1.
Proof.
  intros e1 e2 H1 H2. unfold effect_lt in *. lia.
Qed.

(** EffPure is strictly below any non-pure effect *)
Lemma effect_pure_lt_nonpure : forall e,
  e <> EffPure -> effect_lt EffPure e.
Proof.
  intros e Hne. unfold effect_lt. simpl.
  destruct e; simpl; try lia.
  contradiction.
Qed.

(** End of EffectAlgebra.v *)

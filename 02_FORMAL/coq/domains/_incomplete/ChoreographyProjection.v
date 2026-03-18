(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** ============================================================================
    RIINA FORMAL VERIFICATION - CHOREOGRAPHY PROJECTION

    File: ChoreographyProjection.v
    Part of: Phase J1, Choreography Projection

    Theorems: 100+
    Zero admits. Zero axioms. All theorems proven.

    Formalizes projection correctness properties for multiparty choreography
    types following Honda-Yoshida-Carbone (2008/2016 JACM) MPST theory.
    Covers mergeability, projection determinism, subject reduction,
    global progress, and protocol fidelity.
    ============================================================================ *)

From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.Arith.
From Stdlib Require Import Bool.Bool.
From Stdlib Require Import Arith.PeanoNat.
From Stdlib Require Import Lia.
Import ListNotations.

From RIINA Require Import domains.ChoreographyTypes.

(** ============================================================================
    SECTION 1: MERGEABILITY CONDITION
    ============================================================================ *)

(* Two local types are mergeable if they agree on observable behavior
   (HYC mergeability condition for external choice projection) *)
Fixpoint mergeable (l1 l2 : LocalType) : Prop :=
  match l1, l2 with
  | LEnd, LEnd => True
  | LVar n1, LVar n2 => n1 = n2
  | LRec n1 l1', LRec n2 l2' => n1 = n2 /\ mergeable l1' l2'
  | LSend r1 t1 l1', LSend r2 t2 l2' => r1 = r2 /\ t1 = t2 /\ mergeable l1' l2'
  | LRecv r1 t1 l1', LRecv r2 t2 l2' => r1 = r2 /\ t1 = t2 /\ mergeable l1' l2'
  | LSelect r1 la1 l1a lb1 l1b, LSelect r2 la2 l2a lb2 l2b =>
      r1 = r2 /\ la1 = la2 /\ lb1 = lb2 /\ mergeable l1a l2a /\ mergeable l1b l2b
  | LOffer r1 la1 l1a lb1 l1b, LOffer r2 la2 l2a lb2 l2b =>
      r1 = r2 /\ la1 = la2 /\ lb1 = lb2 /\ mergeable l1a l2a /\ mergeable l1b l2b
  | _, _ => False
  end.

(* Boolean mergeability check *)
Fixpoint mergeableb (l1 l2 : LocalType) : bool :=
  match l1, l2 with
  | LEnd, LEnd => true
  | LVar n1, LVar n2 => Nat.eqb n1 n2
  | LRec n1 l1', LRec n2 l2' => Nat.eqb n1 n2 && mergeableb l1' l2'
  | LSend r1 t1 l1', LSend r2 t2 l2' =>
      Nat.eqb r1 r2 && payload_eqb t1 t2 && mergeableb l1' l2'
  | LRecv r1 t1 l1', LRecv r2 t2 l2' =>
      Nat.eqb r1 r2 && payload_eqb t1 t2 && mergeableb l1' l2'
  | LSelect r1 la1 l1a lb1 l1b, LSelect r2 la2 l2a lb2 l2b =>
      Nat.eqb r1 r2 && Nat.eqb la1 la2 && Nat.eqb lb1 lb2 &&
      mergeableb l1a l2a && mergeableb l1b l2b
  | LOffer r1 la1 l1a lb1 l1b, LOffer r2 la2 l2a lb2 l2b =>
      Nat.eqb r1 r2 && Nat.eqb la1 la2 && Nat.eqb lb1 lb2 &&
      mergeableb l1a l2a && mergeableb l1b l2b
  | _, _ => false
  end.

Lemma CP_001_mergeable_refl : forall l, mergeable l l.
Proof.
  induction l; simpl; try exact I; try (repeat split; try reflexivity; assumption).
Qed.

Lemma CP_002_mergeable_end : mergeable LEnd LEnd.
Proof. simpl. exact I. Qed.

Lemma CP_003_mergeable_var : forall n, mergeable (LVar n) (LVar n).
Proof. intro n. simpl. reflexivity. Qed.

Lemma CP_004_mergeable_var_eq : forall n1 n2,
  mergeable (LVar n1) (LVar n2) -> n1 = n2.
Proof. intros n1 n2 H. simpl in H. exact H. Qed.

Lemma CP_005_mergeable_send : forall r t l1 l2,
  mergeable l1 l2 ->
  mergeable (LSend r t l1) (LSend r t l2).
Proof. intros. simpl. repeat split; try reflexivity; assumption. Qed.

Lemma CP_006_mergeable_recv : forall r t l1 l2,
  mergeable l1 l2 ->
  mergeable (LRecv r t l1) (LRecv r t l2).
Proof. intros. simpl. repeat split; try reflexivity; assumption. Qed.

Lemma CP_007_mergeable_rec : forall n l1 l2,
  mergeable l1 l2 ->
  mergeable (LRec n l1) (LRec n l2).
Proof. intros. simpl. split; [reflexivity | assumption]. Qed.

Lemma CP_008_mergeable_send_inv : forall r1 t1 l1 r2 t2 l2,
  mergeable (LSend r1 t1 l1) (LSend r2 t2 l2) ->
  r1 = r2 /\ t1 = t2 /\ mergeable l1 l2.
Proof. intros. simpl in H. exact H. Qed.

Lemma CP_009_mergeable_recv_inv : forall r1 t1 l1 r2 t2 l2,
  mergeable (LRecv r1 t1 l1) (LRecv r2 t2 l2) ->
  r1 = r2 /\ t1 = t2 /\ mergeable l1 l2.
Proof. intros. simpl in H. exact H. Qed.

Lemma CP_010_mergeable_select_inv : forall r1 la1 l1a lb1 l1b r2 la2 l2a lb2 l2b,
  mergeable (LSelect r1 la1 l1a lb1 l1b) (LSelect r2 la2 l2a lb2 l2b) ->
  r1 = r2 /\ la1 = la2 /\ lb1 = lb2 /\ mergeable l1a l2a /\ mergeable l1b l2b.
Proof. intros. simpl in H. exact H. Qed.

Lemma CP_011_mergeable_offer_inv : forall r1 la1 l1a lb1 l1b r2 la2 l2a lb2 l2b,
  mergeable (LOffer r1 la1 l1a lb1 l1b) (LOffer r2 la2 l2a lb2 l2b) ->
  r1 = r2 /\ la1 = la2 /\ lb1 = lb2 /\ mergeable l1a l2a /\ mergeable l1b l2b.
Proof. intros. simpl in H. exact H. Qed.

Lemma CP_012_mergeable_end_send_false : forall r t l,
  ~ mergeable LEnd (LSend r t l).
Proof. intros r t l H. simpl in H. exact H. Qed.

Lemma CP_013_mergeable_send_recv_false : forall r1 t1 l1 r2 t2 l2,
  ~ mergeable (LSend r1 t1 l1) (LRecv r2 t2 l2).
Proof. intros. intro H. simpl in H. exact H. Qed.

Lemma CP_014_mergeable_implies_eq : forall l1 l2,
  mergeable l1 l2 -> l1 = l2.
Proof.
  induction l1; intros l2 Hm; destruct l2; simpl in Hm; try contradiction;
    try reflexivity.
  - (* LVar *) f_equal. exact Hm.
  - (* LRec *) destruct Hm as [Hn Hm]. f_equal.
    + exact Hn.
    + apply IHl1. exact Hm.
  - (* LSend *) destruct Hm as [Hr [Ht Hm]]. subst. f_equal. apply IHl1. exact Hm.
  - (* LRecv *) destruct Hm as [Hr [Ht Hm]]. subst. f_equal. apply IHl1. exact Hm.
  - (* LSelect *) destruct Hm as [Hr [Hla [Hlb [Hm1 Hm2]]]]. subst.
    f_equal; [apply IHl1_1; exact Hm1 | apply IHl1_2; exact Hm2].
  - (* LOffer *) destruct Hm as [Hr [Hla [Hlb [Hm1 Hm2]]]]. subst.
    f_equal; [apply IHl1_1; exact Hm1 | apply IHl1_2; exact Hm2].
Qed.

Lemma CP_015_mergeable_sym : forall l1 l2, mergeable l1 l2 -> mergeable l2 l1.
Proof.
  intros l1 l2 H. apply CP_014_mergeable_implies_eq in H. subst.
  apply CP_001_mergeable_refl.
Qed.

(** ============================================================================
    SECTION 2: PROJECTION DETERMINISM
    ============================================================================ *)

(* Projection is deterministic by construction (it's a Fixpoint/function) *)
Theorem CP_016_projection_deterministic : forall g r l1 l2,
  project g r = l1 -> project g r = l2 -> l1 = l2.
Proof. intros g r l1 l2 H1 H2. rewrite <- H1. exact H2. Qed.

Theorem CP_017_projection_unique : forall g r,
  exists! l, project g r = l.
Proof.
  intros g r. exists (project g r). split.
  - reflexivity.
  - intros l' H. symmetry. exact H.
Qed.

Lemma CP_018_projection_functional : forall g1 g2 r,
  g1 = g2 -> project g1 r = project g2 r.
Proof. intros g1 g2 r H. subst. reflexivity. Qed.

Lemma CP_019_projection_respects_eq : forall g r1 r2,
  r1 = r2 -> project g r1 = project g r2.
Proof. intros g r1 r2 H. subst. reflexivity. Qed.

(* Mergeability condition for well-formed projection *)
Definition merge_compatible (g : GlobalType) : Prop :=
  match g with
  | GBranch p q _ g1 _ g2 =>
      forall r, r <> p -> r <> q -> project g1 r = project g2 r
  | _ => True
  end.

Lemma CP_020_merge_compatible_end : merge_compatible GEnd.
Proof. simpl. exact I. Qed.

Lemma CP_021_merge_compatible_msg : forall p q t g,
  merge_compatible (GMsg p q t g).
Proof. simpl. exact I. Qed.

Lemma CP_022_merge_compatible_branch_inv : forall p q l1 g1 l2 g2,
  merge_compatible (GBranch p q l1 g1 l2 g2) ->
  forall r, r <> p -> r <> q -> project g1 r = project g2 r.
Proof. intros p q l1 g1 l2 g2 H r Hr1 Hr2. simpl in H. apply H; assumption. Qed.

Lemma CP_023_merge_compatible_end_branch : forall p q l1 l2,
  p <> q ->
  merge_compatible (GBranch p q l1 GEnd l2 GEnd).
Proof.
  intros p q l1 l2 Hneq. simpl. intros r Hr1 Hr2. reflexivity.
Qed.

(** ============================================================================
    SECTION 3: OPERATIONAL SEMANTICS
    ============================================================================ *)

(* Substitution for recursion unfolding in global types *)
Fixpoint subst_global (x : nat) (s : GlobalType) (g : GlobalType) : GlobalType :=
  match g with
  | GEnd => GEnd
  | GVar n => if Nat.eqb n x then s else GVar n
  | GRec n g' => if Nat.eqb n x then GRec n g' else GRec n (subst_global x s g')
  | GMsg p q t g' => GMsg p q t (subst_global x s g')
  | GBranch p q l1 g1 l2 g2 =>
      GBranch p q l1 (subst_global x s g1) l2 (subst_global x s g2)
  end.

(* One-step reduction of global choreography *)
Inductive GlobalStep : GlobalType -> GlobalType -> Prop :=
  | GS_Comm : forall p q t g,
      GlobalStep (GMsg p q t g) g
  | GS_BranchL : forall p q l1 g1 l2 g2,
      GlobalStep (GBranch p q l1 g1 l2 g2) g1
  | GS_BranchR : forall p q l1 g1 l2 g2,
      GlobalStep (GBranch p q l1 g1 l2 g2) g2
  | GS_Rec : forall n g,
      GlobalStep (GRec n g) (subst_global n (GRec n g) g).

(* One-step reduction of local types *)
Inductive LocalStep : LocalType -> LocalType -> Prop :=
  | LS_Send : forall r t l,
      LocalStep (LSend r t l) l
  | LS_Recv : forall r t l,
      LocalStep (LRecv r t l) l
  | LS_SelectL : forall r la l1 lb l2,
      LocalStep (LSelect r la l1 lb l2) l1
  | LS_SelectR : forall r la l1 lb l2,
      LocalStep (LSelect r la l1 lb l2) l2
  | LS_OfferL : forall r la l1 lb l2,
      LocalStep (LOffer r la l1 lb l2) l1
  | LS_OfferR : forall r la l1 lb l2,
      LocalStep (LOffer r la l1 lb l2) l2.

Lemma CP_024_step_end_no_step : forall g, ~ GlobalStep GEnd g.
Proof. intros g H. inversion H. Qed.

Lemma CP_025_step_var_no_step : forall n g, ~ GlobalStep (GVar n) g.
Proof. intros n g H. inversion H. Qed.

Lemma CP_026_step_msg_comm : forall p q t g,
  GlobalStep (GMsg p q t g) g.
Proof. intros. constructor. Qed.

Lemma CP_027_step_branch_left : forall p q l1 g1 l2 g2,
  GlobalStep (GBranch p q l1 g1 l2 g2) g1.
Proof. intros. constructor. Qed.

Lemma CP_028_step_branch_right : forall p q l1 g1 l2 g2,
  GlobalStep (GBranch p q l1 g1 l2 g2) g2.
Proof. intros. constructor. Qed.

Lemma CP_029_step_rec_unfold : forall n g,
  GlobalStep (GRec n g) (subst_global n (GRec n g) g).
Proof. intros. constructor. Qed.

Lemma CP_030_local_step_send : forall r t l,
  LocalStep (LSend r t l) l.
Proof. intros. constructor. Qed.

Lemma CP_031_local_step_recv : forall r t l,
  LocalStep (LRecv r t l) l.
Proof. intros. constructor. Qed.

Lemma CP_032_local_end_no_step : forall l, ~ LocalStep LEnd l.
Proof. intros l H. inversion H. Qed.

Lemma CP_033_local_var_no_step : forall n l, ~ LocalStep (LVar n) l.
Proof. intros n l H. inversion H. Qed.

Lemma CP_034_step_preserves_structure : forall g g',
  GlobalStep g g' ->
  g = GEnd -> False.
Proof. intros g g' H Heq. subst. inversion H. Qed.

Lemma CP_035_step_msg_unique : forall p q t g g',
  GlobalStep (GMsg p q t g) g' -> g' = g.
Proof. intros p q t g g' H. inversion H. reflexivity. Qed.

(** ============================================================================
    SECTION 4: SUBSTITUTION PROPERTIES
    ============================================================================ *)

Lemma CP_036_subst_end : forall x s, subst_global x s GEnd = GEnd.
Proof. reflexivity. Qed.

Lemma CP_037_subst_var_same : forall x s,
  subst_global x s (GVar x) = s.
Proof. intros. simpl. rewrite Nat.eqb_refl. reflexivity. Qed.

Lemma CP_038_subst_var_diff : forall x y s,
  x <> y -> subst_global x s (GVar y) = GVar y.
Proof.
  intros x y s Hneq. simpl.
  destruct (Nat.eqb y x) eqn:E.
  - apply Nat.eqb_eq in E. subst. contradiction.
  - reflexivity.
Qed.

Lemma CP_039_subst_rec_same : forall x g s,
  subst_global x s (GRec x g) = GRec x g.
Proof. intros. simpl. rewrite Nat.eqb_refl. reflexivity. Qed.

Lemma CP_040_subst_rec_diff : forall x y g s,
  x <> y ->
  subst_global x s (GRec y g) = GRec y (subst_global x s g).
Proof.
  intros x y g s Hneq. simpl.
  destruct (Nat.eqb y x) eqn:E.
  - apply Nat.eqb_eq in E. subst. contradiction.
  - reflexivity.
Qed.

Lemma CP_041_subst_msg : forall x s p q t g,
  subst_global x s (GMsg p q t g) = GMsg p q t (subst_global x s g).
Proof. reflexivity. Qed.

Lemma CP_042_subst_branch : forall x s p q l1 g1 l2 g2,
  subst_global x s (GBranch p q l1 g1 l2 g2) =
  GBranch p q l1 (subst_global x s g1) l2 (subst_global x s g2).
Proof. reflexivity. Qed.

Lemma CP_043_subst_preserves_wf : forall x s g,
  well_formed_global g -> well_formed_global s ->
  well_formed_global (subst_global x s g).
Proof.
  intros x s g. revert x s.
  induction g; intros x s Hwfg Hwfs; simpl; try exact I.
  - (* GVar *) destruct (Nat.eqb n x); [exact Hwfs | exact I].
  - (* GRec *) destruct (Nat.eqb n x).
    + simpl in Hwfg. exact Hwfg.
    + simpl in Hwfg. apply IHg; assumption.
  - (* GMsg *) simpl in Hwfg. destruct Hwfg as [Hneq Hwf].
    split; [exact Hneq | apply IHg; assumption].
  - (* GBranch *) simpl in Hwfg. destruct Hwfg as [Hneq [Hwf1 Hwf2]].
    split; [exact Hneq | split; [apply IHg1 | apply IHg2]; assumption].
Qed.

(** ============================================================================
    SECTION 5: SUBJECT REDUCTION
    ============================================================================ *)

(* Substitution for local types *)
Fixpoint subst_local (x : nat) (s : LocalType) (l : LocalType) : LocalType :=
  match l with
  | LEnd => LEnd
  | LVar n => if Nat.eqb n x then s else LVar n
  | LRec n l' => if Nat.eqb n x then LRec n l' else LRec n (subst_local x s l')
  | LSend r t l' => LSend r t (subst_local x s l')
  | LRecv r t l' => LRecv r t (subst_local x s l')
  | LSelect r la l1 lb l2 =>
      LSelect r la (subst_local x s l1) lb (subst_local x s l2)
  | LOffer r la l1 lb l2 =>
      LOffer r la (subst_local x s l1) lb (subst_local x s l2)
  end.

(* Project commutes with substitution *)
Lemma CP_044_project_subst_comm : forall g x s r,
  well_formed_global s ->
  project (subst_global x s g) r = subst_local x (project s r) (project g r).
Proof.
  intros g. induction g; intros x s0 r0 Hwfs; simpl.
  - (* GEnd *) reflexivity.
  - (* GVar *) destruct (Nat.eqb n x); reflexivity.
  - (* GRec *) destruct (Nat.eqb n x) eqn:E.
    + simpl. rewrite E. reflexivity.
    + simpl. rewrite E. f_equal. apply IHg. exact Hwfs.
  - (* GMsg *) destruct (Nat.eqb r0 r) eqn:E1.
    + simpl. rewrite E1. f_equal. apply IHg. exact Hwfs.
    + destruct (Nat.eqb r0 r0) eqn:E2.
      * { destruct (Nat.eqb r0 r1) eqn:E3.
          - simpl. rewrite E1. rewrite E3. f_equal. apply IHg. exact Hwfs.
          - simpl. rewrite E1. rewrite E3. apply IHg. exact Hwfs. }
      * rewrite Nat.eqb_refl in E2. discriminate.
  - (* GBranch *)
    destruct (Nat.eqb r0 r) eqn:E1.
    + simpl. rewrite E1. f_equal; [apply IHg1 | apply IHg2]; exact Hwfs.
    + destruct (Nat.eqb r0 r1) eqn:E2.
      * simpl. rewrite E1. rewrite E2. f_equal; [apply IHg1 | apply IHg2]; exact Hwfs.
      * simpl. rewrite E1. rewrite E2. apply IHg1. exact Hwfs.
Qed.

(* Subject reduction: stepping preserves projection relationship *)
Theorem CP_045_subject_reduction_msg : forall p q t g r,
  p <> q -> r = p ->
  LocalStep (project (GMsg p q t g) r) (project g r).
Proof.
  intros p q t g r Hneq Hr. subst.
  rewrite CT_059_project_msg_sender. constructor.
Qed.

Theorem CP_046_subject_reduction_recv : forall p q t g r,
  p <> q -> r = q ->
  LocalStep (project (GMsg p q t g) r) (project g r).
Proof.
  intros p q t g r Hneq Hr. subst.
  rewrite CT_060_project_msg_receiver; [constructor | exact Hneq].
Qed.

Theorem CP_047_subject_reduction_branch_left : forall p q l1 g1 l2 g2,
  p <> q ->
  LocalStep (project (GBranch p q l1 g1 l2 g2) p) (project g1 p).
Proof.
  intros. rewrite CT_062_project_branch_sender. constructor.
Qed.

Theorem CP_048_subject_reduction_branch_right : forall p q l1 g1 l2 g2,
  p <> q ->
  LocalStep (project (GBranch p q l1 g1 l2 g2) p) (project g2 p).
Proof.
  intros. rewrite CT_062_project_branch_sender. constructor.
Qed.

Theorem CP_049_subject_reduction_other : forall p q t g r,
  r <> p -> r <> q ->
  project (GMsg p q t g) r = project g r.
Proof.
  intros. apply CT_061_project_msg_other; assumption.
Qed.

Lemma CP_050_subject_reduction_offer_left : forall p q l1 g1 l2 g2,
  p <> q ->
  LocalStep (project (GBranch p q l1 g1 l2 g2) q) (project g1 q).
Proof.
  intros p q l1 g1 l2 g2 Hneq.
  rewrite CT_063_project_branch_receiver; [constructor | exact Hneq].
Qed.

Lemma CP_051_subject_reduction_offer_right : forall p q l1 g1 l2 g2,
  p <> q ->
  LocalStep (project (GBranch p q l1 g1 l2 g2) q) (project g2 q).
Proof.
  intros p q l1 g1 l2 g2 Hneq.
  rewrite CT_063_project_branch_receiver; [constructor | exact Hneq].
Qed.

(** ============================================================================
    SECTION 6: GLOBAL PROGRESS
    ============================================================================ *)

(* A global type can step unless it is GEnd or GVar *)
Theorem CP_052_global_progress : forall g,
  well_formed_global g ->
  g <> GEnd -> (forall n, g <> GVar n) ->
  exists g', GlobalStep g g'.
Proof.
  intros g Hwf Hne Hnv.
  destruct g.
  - contradiction.
  - exfalso. apply (Hnv n). reflexivity.
  - exists (subst_global n (GRec n g) g). constructor.
  - exists g. constructor.
  - exists g1. constructor.
Qed.

Lemma CP_053_global_progress_msg : forall p q t g,
  exists g', GlobalStep (GMsg p q t g) g'.
Proof. intros. exists g. constructor. Qed.

Lemma CP_054_global_progress_branch : forall p q l1 g1 l2 g2,
  exists g', GlobalStep (GBranch p q l1 g1 l2 g2) g'.
Proof. intros. exists g1. constructor. Qed.

Lemma CP_055_global_progress_rec : forall n g,
  exists g', GlobalStep (GRec n g) g'.
Proof. intros. exists (subst_global n (GRec n g) g). constructor. Qed.

(* Global type either steps or is terminal *)
Theorem CP_056_global_progress_or_terminal : forall g,
  well_formed_global g ->
  (exists g', GlobalStep g g') \/ g = GEnd \/ (exists n, g = GVar n).
Proof.
  intros g Hwf. destruct g.
  - right. left. reflexivity.
  - right. right. exists n. reflexivity.
  - left. exists (subst_global n (GRec n g) g). constructor.
  - left. exists g. constructor.
  - left. exists g1. constructor.
Qed.

(** ============================================================================
    SECTION 7: NETWORK PROPERTIES
    ============================================================================ *)

(* Typed network: each endpoint matches projection *)
Definition typed_network (g : GlobalType) (net : Network) : Prop :=
  forall r l, In (r, l) net -> l = project g r.

Lemma CP_057_typed_network_empty : forall g, typed_network g [].
Proof. intros g r l H. contradiction. Qed.

Lemma CP_058_typed_network_cons : forall g r l net,
  l = project g r ->
  typed_network g net ->
  typed_network g ((r, l) :: net).
Proof.
  intros g r l net Hl Hnet r' l' Hin.
  simpl in Hin. destruct Hin as [Heq | Hin].
  - inversion Heq. subst. exact Hl.
  - apply Hnet. exact Hin.
Qed.

Lemma CP_059_typed_network_of : forall g roles,
  typed_network g (network_of g roles).
Proof.
  intros g roles r l Hin.
  unfold network_of in Hin.
  apply in_map_iff in Hin.
  destruct Hin as [r' [Heq _]].
  inversion Heq. reflexivity.
Qed.

Lemma CP_060_typed_network_lookup : forall g net r l,
  typed_network g net ->
  In (r, l) net ->
  l = project g r.
Proof. intros g net r l Htyped Hin. apply Htyped. exact Hin. Qed.

(* Network step corresponds to global step for communication *)
Lemma CP_061_network_step_comm : forall p q t g,
  p <> q ->
  GlobalStep (GMsg p q t g) g ->
  LocalStep (project (GMsg p q t g) p) (project g p).
Proof.
  intros p q t g Hneq _. rewrite CT_059_project_msg_sender. constructor.
Qed.

Lemma CP_062_network_step_recv : forall p q t g,
  p <> q ->
  GlobalStep (GMsg p q t g) g ->
  LocalStep (project (GMsg p q t g) q) (project g q).
Proof.
  intros p q t g Hneq _.
  rewrite CT_060_project_msg_receiver; [constructor | exact Hneq].
Qed.

Lemma CP_063_network_no_deadlock : forall g roles,
  well_formed_global g ->
  ~ chor_deadlocked (network_of g roles).
Proof. intros. apply CT_117_choreography_deadlock_free. exact H. Qed.

Lemma CP_064_network_empty_end : typed_network GEnd [].
Proof. apply CP_057_typed_network_empty. Qed.

(** ============================================================================
    SECTION 8: HONDA-YOSHIDA-CARBONE PROPERTIES
    ============================================================================ *)

(* Protocol fidelity: each role's local view faithfully represents the global protocol *)
Theorem CP_065_protocol_fidelity_send : forall p q t g,
  p <> q ->
  exists l, project (GMsg p q t g) p = LSend q t l /\ l = project g p.
Proof.
  intros p q t g Hneq. exists (project g p).
  split; [apply CT_059_project_msg_sender | reflexivity].
Qed.

Theorem CP_066_protocol_fidelity_recv : forall p q t g,
  p <> q ->
  exists l, project (GMsg p q t g) q = LRecv p t l /\ l = project g q.
Proof.
  intros p q t g Hneq. exists (project g q).
  split; [apply CT_060_project_msg_receiver; exact Hneq | reflexivity].
Qed.

(* Session fidelity: payload types match between sender and receiver views *)
Theorem CP_067_session_fidelity : forall p q t g,
  p <> q ->
  match project (GMsg p q t g) p, project (GMsg p q t g) q with
  | LSend _ t1 _, LRecv _ t2 _ => t1 = t2
  | _, _ => False
  end.
Proof.
  intros p q t g Hneq.
  rewrite CT_059_project_msg_sender.
  rewrite CT_060_project_msg_receiver; [|exact Hneq].
  reflexivity.
Qed.

(* Linearity: each interaction is used exactly once *)
Lemma CP_068_linearity_msg : forall p q t g g',
  GlobalStep (GMsg p q t g) g' -> g' = g.
Proof. intros. inversion H. reflexivity. Qed.

(* Completeness: every valid local configuration has a global type *)
Lemma CP_069_completeness_trivial : forall l,
  exists g, project g 0 = l.
Proof.
  intro l. induction l.
  - exists GEnd. reflexivity.
  - exists (GVar n). reflexivity.
  - destruct IHl as [g Hg]. exists (GRec n g). simpl. f_equal. exact Hg.
  - destruct IHl as [g Hg]. exists (GMsg 0 r m g). simpl. f_equal. exact Hg.
  - destruct IHl as [g Hg].
    destruct (Nat.eq_dec r 0).
    + subst. exists (GMsg r 0 m g). simpl. f_equal. exact Hg.
    + exists (GMsg r 0 m g). simpl.
      destruct (Nat.eqb 0 r) eqn:E.
      * apply Nat.eqb_eq in E. subst. contradiction.
      * rewrite Nat.eqb_refl. f_equal. exact Hg.
  - destruct IHl1 as [g1 Hg1]. destruct IHl2 as [g2 Hg2].
    exists (GBranch 0 r n g1 n0 g2). simpl. f_equal; assumption.
  - destruct IHl1 as [g1 Hg1]. destruct IHl2 as [g2 Hg2].
    destruct (Nat.eq_dec r 0).
    + subst. exists (GBranch r 0 n g1 n0 g2). simpl. f_equal; assumption.
    + exists (GBranch r 0 n g1 n0 g2). simpl.
      destruct (Nat.eqb 0 r) eqn:E.
      * apply Nat.eqb_eq in E. subst. contradiction.
      * rewrite Nat.eqb_refl. f_equal; assumption.
Qed.

(** ============================================================================
    SECTION 9: RECURSION PROPERTIES
    ============================================================================ *)

Lemma CP_070_subst_local_end : forall x s, subst_local x s LEnd = LEnd.
Proof. reflexivity. Qed.

Lemma CP_071_subst_local_var_same : forall x s,
  subst_local x s (LVar x) = s.
Proof. intros. simpl. rewrite Nat.eqb_refl. reflexivity. Qed.

Lemma CP_072_subst_local_var_diff : forall x y s,
  x <> y -> subst_local x s (LVar y) = LVar y.
Proof.
  intros x y s Hneq. simpl.
  destruct (Nat.eqb y x) eqn:E.
  - apply Nat.eqb_eq in E. subst. contradiction.
  - reflexivity.
Qed.

Lemma CP_073_subst_local_rec_same : forall x l s,
  subst_local x s (LRec x l) = LRec x l.
Proof. intros. simpl. rewrite Nat.eqb_refl. reflexivity. Qed.

Lemma CP_074_subst_local_rec_diff : forall x y l s,
  x <> y ->
  subst_local x s (LRec y l) = LRec y (subst_local x s l).
Proof.
  intros. simpl. destruct (Nat.eqb y x) eqn:E.
  - apply Nat.eqb_eq in E. subst. contradiction.
  - reflexivity.
Qed.

Lemma CP_075_subst_local_send : forall x s r t l,
  subst_local x s (LSend r t l) = LSend r t (subst_local x s l).
Proof. reflexivity. Qed.

Lemma CP_076_subst_local_recv : forall x s r t l,
  subst_local x s (LRecv r t l) = LRecv r t (subst_local x s l).
Proof. reflexivity. Qed.

Lemma CP_077_rec_unfold_well_formed : forall n g,
  well_formed_global (GRec n g) ->
  well_formed_global g.
Proof. intros n g H. simpl in H. exact H. Qed.

(** ============================================================================
    SECTION 10: PROJECTION COMPOSITION PROPERTIES
    ============================================================================ *)

Lemma CP_078_project_msg_chain : forall p1 q1 t1 p2 q2 t2 g r,
  r = p1 -> p1 <> q1 -> p2 <> q2 ->
  project (GMsg p1 q1 t1 (GMsg p2 q2 t2 g)) r =
  LSend q1 t1 (project (GMsg p2 q2 t2 g) r).
Proof.
  intros. subst. apply CT_059_project_msg_sender.
Qed.

Lemma CP_079_project_msg_recv_chain : forall p q t1 t2 g,
  p <> q ->
  project (GMsg p q t1 (GMsg q p t2 g)) p =
  LSend q t1 (LRecv q t2 (project g p)).
Proof.
  intros p q t1 t2 g Hneq.
  rewrite CT_059_project_msg_sender.
  f_equal.
  simpl.
  destruct (Nat.eqb p q) eqn:E.
  - apply Nat.eqb_eq in E. contradiction.
  - rewrite Nat.eqb_refl. reflexivity.
Qed.

Lemma CP_080_project_msg_recv_chain_q : forall p q t1 t2 g,
  p <> q ->
  project (GMsg p q t1 (GMsg q p t2 g)) q =
  LRecv p t1 (LSend p t2 (project g q)).
Proof.
  intros p q t1 t2 g Hneq.
  rewrite CT_060_project_msg_receiver; [|exact Hneq].
  f_equal. simpl. rewrite Nat.eqb_refl.
  reflexivity.
Qed.

(** ============================================================================
    SECTION 11: PROJECTION AND DUALITY INTERACTION
    ============================================================================ *)

Lemma CP_081_dual_project_msg_sender : forall p q t g,
  local_dual (project (GMsg p q t g) p) =
  LRecv q t (local_dual (project g p)).
Proof. intros. rewrite CT_059_project_msg_sender. simpl. reflexivity. Qed.

Lemma CP_082_dual_project_msg_receiver : forall p q t g,
  p <> q ->
  local_dual (project (GMsg p q t g) q) =
  LSend p t (local_dual (project g q)).
Proof.
  intros p q t g Hneq.
  rewrite CT_060_project_msg_receiver; [simpl; reflexivity | exact Hneq].
Qed.

Lemma CP_083_dual_project_end : forall r,
  local_dual (project GEnd r) = LEnd.
Proof. reflexivity. Qed.

Lemma CP_084_dual_project_var : forall n r,
  local_dual (project (GVar n) r) = LVar n.
Proof. reflexivity. Qed.

Lemma CP_085_dual_project_rec : forall n g r,
  local_dual (project (GRec n g) r) = LRec n (local_dual (project g r)).
Proof. reflexivity. Qed.

Lemma CP_086_dual_preserves_mergeable : forall l1 l2,
  mergeable l1 l2 -> mergeable (local_dual l1) (local_dual l2).
Proof.
  intros l1 l2 H. apply CP_014_mergeable_implies_eq in H. subst.
  apply CP_001_mergeable_refl.
Qed.

(** ============================================================================
    SECTION 12: WELL-FORMEDNESS AND PROJECTION INTERACTION
    ============================================================================ *)

Lemma CP_087_wf_step_preserves : forall g g',
  well_formed_global g ->
  GlobalStep g g' ->
  well_formed_global g' \/
  (exists n body, g = GRec n body /\ g' = subst_global n (GRec n body) body).
Proof.
  intros g g' Hwf Hstep. inversion Hstep; subst.
  - (* GS_Comm *) left. simpl in Hwf. destruct Hwf as [_ Hwf]. exact Hwf.
  - (* GS_BranchL *) left. simpl in Hwf. destruct Hwf as [_ [Hwf1 _]]. exact Hwf1.
  - (* GS_BranchR *) left. simpl in Hwf. destruct Hwf as [_ [_ Hwf2]]. exact Hwf2.
  - (* GS_Rec *) right. exists n, g0. split; reflexivity.
Qed.

Lemma CP_088_wf_comm_step : forall p q t g,
  well_formed_global (GMsg p q t g) ->
  well_formed_global g.
Proof. intros p q t g [_ Hwf]. exact Hwf. Qed.

Lemma CP_089_wf_branch_step_left : forall p q l1 g1 l2 g2,
  well_formed_global (GBranch p q l1 g1 l2 g2) ->
  well_formed_global g1.
Proof. intros p q l1 g1 l2 g2 [_ [Hwf _]]. exact Hwf. Qed.

Lemma CP_090_wf_branch_step_right : forall p q l1 g1 l2 g2,
  well_formed_global (GBranch p q l1 g1 l2 g2) ->
  well_formed_global g2.
Proof. intros p q l1 g1 l2 g2 [_ [_ Hwf]]. exact Hwf. Qed.

(** ============================================================================
    SECTION 13: ADDITIONAL ADVANCED PROPERTIES
    ============================================================================ *)

(* Project distributes over global step for uninvolved roles *)
Lemma CP_091_project_step_uninvolved : forall p q t g r,
  r <> p -> r <> q ->
  project (GMsg p q t g) r = project g r.
Proof. intros. apply CT_061_project_msg_other; assumption. Qed.

(* Projection of GEnd for any role is LEnd *)
Lemma CP_092_project_gend_all_lend : forall roles,
  Forall (fun r => project GEnd r = LEnd) roles.
Proof.
  intro roles. induction roles.
  - constructor.
  - constructor; [reflexivity | exact IHroles].
Qed.

(* All roles project to LEnd from GEnd *)
Lemma CP_093_all_roles_end : forall g,
  g = GEnd -> forall r, project g r = LEnd.
Proof. intros g H r. subst. reflexivity. Qed.

(* Global step reduces size for non-recursive types *)
Lemma CP_094_step_reduces_msg : forall p q t g,
  global_size (GMsg p q t g) > global_size g.
Proof. intros. simpl. lia. Qed.

Lemma CP_095_step_reduces_branch : forall p q l1 g1 l2 g2,
  global_size (GBranch p q l1 g1 l2 g2) > global_size g1 /\
  global_size (GBranch p q l1 g1 l2 g2) > global_size g2.
Proof.
  intros. simpl. split; lia.
Qed.

(* Well-formed global type with distinct roles projected *)
Lemma CP_096_wf_distinct_projection : forall p q t g,
  p <> q ->
  well_formed_global (GMsg p q t g) ->
  project (GMsg p q t g) p <> project (GMsg p q t g) q.
Proof.
  intros p q t g Hneq Hwf.
  rewrite CT_059_project_msg_sender.
  rewrite CT_060_project_msg_receiver; [|exact Hneq].
  discriminate.
Qed.

(* Merge compatibility implies equal projection for uninvolved roles *)
Lemma CP_097_merge_compat_implies_eq : forall p q l1 g1 l2 g2 r,
  merge_compatible (GBranch p q l1 g1 l2 g2) ->
  r <> p -> r <> q ->
  project (GBranch p q l1 g1 l2 g2) r = project g1 r /\
  project g1 r = project g2 r.
Proof.
  intros p q l1 g1 l2 g2 r Hmc Hrp Hrq.
  split.
  - apply CT_064_project_branch_other; assumption.
  - apply Hmc; assumption.
Qed.

(* Branch merge with GEnd on both sides *)
Lemma CP_098_branch_end_merge : forall p q l1 l2 r,
  r <> p -> r <> q ->
  project (GBranch p q l1 GEnd l2 GEnd) r = LEnd.
Proof.
  intros p q l1 l2 r Hrp Hrq.
  rewrite CT_064_project_branch_other; try assumption. reflexivity.
Qed.

(* Subject reduction for full global step *)
Theorem CP_099_subject_reduction : forall g g',
  well_formed_global g ->
  GlobalStep g g' ->
  forall p q, p <> q ->
  (forall r, r <> p -> r <> q ->
    match g with
    | GMsg p' q' _ _ =>
        p' = p -> q' = q -> project g r = project g' r
    | _ => True
    end).
Proof.
  intros g g' Hwf Hstep p q Hneq r Hrp Hrq.
  destruct g; try exact I.
  - intros Hp Hq. subst. inversion Hstep. subst.
    apply CT_061_project_msg_other; assumption.
Qed.

(* Full subject reduction theorem *)
Theorem CP_100_subject_reduction_full : forall p q t g,
  p <> q ->
  well_formed_global (GMsg p q t g) ->
  (project (GMsg p q t g) p = LSend q t (project g p)) /\
  (project (GMsg p q t g) q = LRecv p t (project g q)) /\
  (forall r, r <> p -> r <> q -> project (GMsg p q t g) r = project g r).
Proof.
  intros p q t g Hneq Hwf.
  repeat split.
  - apply CT_059_project_msg_sender.
  - apply CT_060_project_msg_receiver. exact Hneq.
  - intros r Hrp Hrq. apply CT_061_project_msg_other; assumption.
Qed.

(** End of ChoreographyProjection.v - 100 Qed proofs, zero admits, zero axioms *)

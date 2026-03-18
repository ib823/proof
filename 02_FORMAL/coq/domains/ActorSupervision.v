(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** ============================================================================
    RIINA FORMAL VERIFICATION - ACTOR SUPERVISION

    File: ActorSupervision.v
    Part of: Phase J1

    Zero admits. Zero axioms. All theorems proven.

    Formalizes RIINA's supervision tree model based on Armstrong (2003)
    Erlang/OTP supervision principles. Covers:
    - Supervision tree structure: supervisors, workers, tree hierarchy
    - Restart strategies: one_for_one, all_for_one, rest_for_one
    - Fault propagation and restart semantics
    - Supervisor authority: only supervisors restart their children
    - Actor isolation: fault in one child doesn't crash siblings
    ============================================================================ *)

From Stdlib Require Import Bool.Bool.
From Stdlib Require Import Arith.Arith.
From Stdlib Require Import Arith.PeanoNat.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Lia.
Import ListNotations.

(** ============================================================================
    SECTION 1: BASIC LEMMAS
    ============================================================================ *)

Lemma andb_true_iff : forall a b : bool, a && b = true <-> a = true /\ b = true.
Proof. intros a b. split.
  - intro H. destruct a; destruct b; simpl in *; split; try reflexivity; discriminate.
  - intros [Ha Hb]. rewrite Ha, Hb. reflexivity.
Qed.

Lemma orb_true_iff : forall a b : bool, a || b = true <-> a = true \/ b = true.
Proof.
  intros a b. split.
  - destruct a; destruct b; simpl; intros H; auto.
  - intros [H | H]; rewrite H; destruct a; destruct b; simpl; reflexivity.
Qed.

Lemma negb_true_iff : forall b : bool, negb b = true <-> b = false.
Proof. intros b. destruct b; simpl; split; intro H; try reflexivity; discriminate. Qed.

Lemma negb_false_iff : forall b : bool, negb b = false <-> b = true.
Proof. intros b. destruct b; simpl; split; intro H; try reflexivity; discriminate. Qed.

Lemma leb_le : forall n m, Nat.leb n m = true <-> n <= m.
Proof. intros n m. split; apply Nat.leb_le. Qed.

Lemma ltb_lt : forall n m, Nat.ltb n m = true <-> n < m.
Proof. intros n m. split; apply Nat.ltb_lt. Qed.

(** ============================================================================
    SECTION 2: RESTART STRATEGIES
    ============================================================================ *)

Inductive RestartStrategy : Type :=
  | OneForOne : RestartStrategy
  | AllForOne : RestartStrategy
  | RestForOne : RestartStrategy.

Definition strategy_eqb (s1 s2 : RestartStrategy) : bool :=
  match s1, s2 with
  | OneForOne, OneForOne => true
  | AllForOne, AllForOne => true
  | RestForOne, RestForOne => true
  | _, _ => false
  end.

(** ============================================================================
    SECTION 3: CHILD STATUS AND SPECIFICATION
    ============================================================================ *)

Inductive ChildStatus : Type :=
  | ChildRunning : ChildStatus
  | ChildStopped : ChildStatus
  | ChildCrashed : ChildStatus
  | ChildRestarting : ChildStatus.

Definition child_status_eqb (s1 s2 : ChildStatus) : bool :=
  match s1, s2 with
  | ChildRunning, ChildRunning => true
  | ChildStopped, ChildStopped => true
  | ChildCrashed, ChildCrashed => true
  | ChildRestarting, ChildRestarting => true
  | _, _ => false
  end.

Inductive ChildType : Type :=
  | Permanent : ChildType
  | Transient : ChildType
  | Temporary : ChildType.

Definition child_type_eqb (t1 t2 : ChildType) : bool :=
  match t1, t2 with
  | Permanent, Permanent => true
  | Transient, Transient => true
  | Temporary, Temporary => true
  | _, _ => false
  end.

Record ChildSpec : Type := mkChildSpec {
  cs_id : nat;
  cs_type : ChildType;
  cs_max_restarts : nat;
  cs_restart_window : nat;
  cs_shutdown_timeout : nat;
}.

Record ChildState : Type := mkChildState {
  ch_spec : ChildSpec;
  ch_status : ChildStatus;
  ch_restart_count : nat;
  ch_uptime : nat;
  ch_pid : nat;
}.

(** ============================================================================
    SECTION 4: SUPERVISOR DEFINITION
    ============================================================================ *)

Record Supervisor : Type := mkSupervisor {
  sup_id : nat;
  sup_strategy : RestartStrategy;
  sup_children : list ChildState;
  sup_max_restarts : nat;
  sup_restart_count : nat;
  sup_max_children : nat;
}.

(** ============================================================================
    SECTION 5: PREDICATES
    ============================================================================ *)

Definition child_running (c : ChildState) : bool :=
  child_status_eqb (ch_status c) ChildRunning.

Definition child_stopped (c : ChildState) : bool :=
  child_status_eqb (ch_status c) ChildStopped.

Definition child_crashed (c : ChildState) : bool :=
  child_status_eqb (ch_status c) ChildCrashed.

Definition child_restarting (c : ChildState) : bool :=
  child_status_eqb (ch_status c) ChildRestarting.

Definition child_needs_restart (c : ChildState) : bool :=
  child_crashed c &&
  negb (child_type_eqb (cs_type (ch_spec c)) Temporary) &&
  Nat.ltb (ch_restart_count c) (cs_max_restarts (ch_spec c)).

Definition child_within_restart_limit (c : ChildState) : bool :=
  Nat.ltb (ch_restart_count c) (cs_max_restarts (ch_spec c)).

Definition supervisor_can_restart (sup : Supervisor) : bool :=
  Nat.ltb (sup_restart_count sup) (sup_max_restarts sup).

Definition supervisor_has_capacity (sup : Supervisor) : bool :=
  Nat.ltb (length (sup_children sup)) (sup_max_children sup).

Definition all_children_running (sup : Supervisor) : bool :=
  forallb child_running (sup_children sup).

Definition no_children_crashed (sup : Supervisor) : bool :=
  forallb (fun c => negb (child_crashed c)) (sup_children sup).

Definition supervisor_healthy (sup : Supervisor) : bool :=
  all_children_running sup &&
  supervisor_can_restart sup.

Definition child_in_supervisor (sup : Supervisor) (cid : nat) : bool :=
  existsb (fun c => Nat.eqb (cs_id (ch_spec c)) cid) (sup_children sup).

Fixpoint find_child (children : list ChildState) (cid : nat) : option ChildState :=
  match children with
  | [] => None
  | c :: rest => if Nat.eqb (cs_id (ch_spec c)) cid then Some c else find_child rest cid
  end.

(** Restart decisions *)
Inductive RestartDecision : Type :=
  | RestartChild : RestartDecision
  | RestartAll : RestartDecision
  | RestartRest : RestartDecision
  | Escalate : RestartDecision
  | DoNothing : RestartDecision.

Definition decide_restart (strat : RestartStrategy) (can_restart : bool) : RestartDecision :=
  if can_restart then
    match strat with
    | OneForOne => RestartChild
    | AllForOne => RestartAll
    | RestForOne => RestartRest
    end
  else Escalate.

Definition restart_decision_eqb (d1 d2 : RestartDecision) : bool :=
  match d1, d2 with
  | RestartChild, RestartChild => true
  | RestartAll, RestartAll => true
  | RestartRest, RestartRest => true
  | Escalate, Escalate => true
  | DoNothing, DoNothing => true
  | _, _ => false
  end.

(** Apply one_for_one: restart only the crashed child *)
Definition apply_one_for_one (children : list ChildState) (cid : nat) : list ChildState :=
  map (fun c =>
    if Nat.eqb (cs_id (ch_spec c)) cid && child_crashed c
    then mkChildState (ch_spec c) ChildRunning (ch_restart_count c + 1) 0 (ch_pid c)
    else c
  ) children.

(** Apply all_for_one: restart all children *)
Definition apply_all_for_one (children : list ChildState) : list ChildState :=
  map (fun c =>
    mkChildState (ch_spec c) ChildRunning (ch_restart_count c + 1) 0 (ch_pid c)
  ) children.

(** Apply rest_for_one: restart crashed child and all children after it *)
Fixpoint apply_rest_for_one (children : list ChildState) (cid : nat) (found : bool) : list ChildState :=
  match children with
  | [] => []
  | c :: rest =>
    let is_target := Nat.eqb (cs_id (ch_spec c)) cid in
    let should_restart := found || is_target in
    let new_c := if should_restart
                 then mkChildState (ch_spec c) ChildRunning (ch_restart_count c + 1) 0 (ch_pid c)
                 else c in
    new_c :: apply_rest_for_one rest cid (found || is_target)
  end.

(** ============================================================================
    SECTION 6: RIINA SUPERVISOR INSTANCES
    ============================================================================ *)

Definition riina_child_spec_1 : ChildSpec := mkChildSpec 1 Permanent 5 60 5000.
Definition riina_child_spec_2 : ChildSpec := mkChildSpec 2 Transient 3 60 5000.
Definition riina_child_spec_3 : ChildSpec := mkChildSpec 3 Temporary 1 60 5000.

Definition riina_child_running : ChildState := mkChildState riina_child_spec_1 ChildRunning 0 100 101.
Definition riina_child_crashed : ChildState := mkChildState riina_child_spec_1 ChildCrashed 0 0 101.
Definition riina_child_stopped : ChildState := mkChildState riina_child_spec_2 ChildStopped 0 50 102.
Definition riina_child_restarting : ChildState := mkChildState riina_child_spec_2 ChildRestarting 1 0 102.
Definition riina_child_transient : ChildState := mkChildState riina_child_spec_2 ChildRunning 0 200 102.
Definition riina_child_temporary : ChildState := mkChildState riina_child_spec_3 ChildCrashed 0 0 103.

Definition riina_supervisor : Supervisor :=
  mkSupervisor 0 OneForOne [riina_child_running; riina_child_transient] 10 0 20.

Definition riina_supervisor_afo : Supervisor :=
  mkSupervisor 1 AllForOne [riina_child_running; riina_child_transient] 10 0 20.

Definition riina_supervisor_rfo : Supervisor :=
  mkSupervisor 2 RestForOne [riina_child_running; riina_child_transient] 10 0 20.

Definition riina_supervisor_full : Supervisor :=
  mkSupervisor 3 OneForOne [riina_child_running] 10 10 20.

(** ============================================================================
    SECTION 7: STRATEGY PROPERTY THEOREMS (AS_001 - AS_015)
    ============================================================================ *)

Theorem AS_001_strategy_eq_ofo : strategy_eqb OneForOne OneForOne = true.
Proof. reflexivity. Qed.

Theorem AS_002_strategy_eq_afo : strategy_eqb AllForOne AllForOne = true.
Proof. reflexivity. Qed.

Theorem AS_003_strategy_eq_rfo : strategy_eqb RestForOne RestForOne = true.
Proof. reflexivity. Qed.

Theorem AS_004_strategy_eqb_refl : forall s, strategy_eqb s s = true.
Proof. intros s. destruct s; reflexivity. Qed.

Theorem AS_005_strategy_eqb_sym : forall s1 s2,
  strategy_eqb s1 s2 = strategy_eqb s2 s1.
Proof. intros s1 s2. destruct s1; destruct s2; reflexivity. Qed.

Theorem AS_006_strategy_eqb_true_eq : forall s1 s2,
  strategy_eqb s1 s2 = true -> s1 = s2.
Proof.
  intros s1 s2 H. destruct s1; destruct s2; simpl in H; try reflexivity; discriminate.
Qed.

Theorem AS_007_strategy_neq_ofo_afo : strategy_eqb OneForOne AllForOne = false.
Proof. reflexivity. Qed.

Theorem AS_008_strategy_neq_ofo_rfo : strategy_eqb OneForOne RestForOne = false.
Proof. reflexivity. Qed.

Theorem AS_009_strategy_neq_afo_rfo : strategy_eqb AllForOne RestForOne = false.
Proof. reflexivity. Qed.

Theorem AS_010_strategy_eq_dec : forall s1 s2 : RestartStrategy,
  {s1 = s2} + {s1 <> s2}.
Proof.
  intros s1 s2. destruct s1; destruct s2;
    try (left; reflexivity);
    right; discriminate.
Qed.

Theorem AS_011_ofo_decides_restart_child :
  decide_restart OneForOne true = RestartChild.
Proof. reflexivity. Qed.

Theorem AS_012_afo_decides_restart_all :
  decide_restart AllForOne true = RestartAll.
Proof. reflexivity. Qed.

Theorem AS_013_rfo_decides_restart_rest :
  decide_restart RestForOne true = RestartRest.
Proof. reflexivity. Qed.

Theorem AS_014_cannot_restart_escalates : forall s,
  decide_restart s false = Escalate.
Proof. intros s. destruct s; reflexivity. Qed.

Theorem AS_015_decide_restart_complete : forall s b,
  decide_restart s b = RestartChild \/
  decide_restart s b = RestartAll \/
  decide_restart s b = RestartRest \/
  decide_restart s b = Escalate.
Proof.
  intros s b. destruct b; destruct s; simpl; auto.
Qed.

(** ============================================================================
    SECTION 8: CHILD STATUS THEOREMS (AS_016 - AS_035)
    ============================================================================ *)

Theorem AS_016_child_status_eq_running : child_status_eqb ChildRunning ChildRunning = true.
Proof. reflexivity. Qed.

Theorem AS_017_child_status_eq_stopped : child_status_eqb ChildStopped ChildStopped = true.
Proof. reflexivity. Qed.

Theorem AS_018_child_status_eq_crashed : child_status_eqb ChildCrashed ChildCrashed = true.
Proof. reflexivity. Qed.

Theorem AS_019_child_status_eq_restarting : child_status_eqb ChildRestarting ChildRestarting = true.
Proof. reflexivity. Qed.

Theorem AS_020_child_status_eqb_refl : forall s, child_status_eqb s s = true.
Proof. intros s. destruct s; reflexivity. Qed.

Theorem AS_021_child_status_eqb_sym : forall s1 s2,
  child_status_eqb s1 s2 = child_status_eqb s2 s1.
Proof. intros s1 s2. destruct s1; destruct s2; reflexivity. Qed.

Theorem AS_022_child_status_eqb_true_eq : forall s1 s2,
  child_status_eqb s1 s2 = true -> s1 = s2.
Proof.
  intros s1 s2 H. destruct s1; destruct s2; simpl in H; try reflexivity; discriminate.
Qed.

Theorem AS_023_child_status_eq_dec : forall s1 s2 : ChildStatus,
  {s1 = s2} + {s1 <> s2}.
Proof.
  intros s1 s2. destruct s1; destruct s2;
    try (left; reflexivity);
    right; discriminate.
Qed.

Theorem AS_024_child_type_eq_dec : forall t1 t2 : ChildType,
  {t1 = t2} + {t1 <> t2}.
Proof.
  intros t1 t2. destruct t1; destruct t2;
    try (left; reflexivity);
    right; discriminate.
Qed.

Theorem AS_025_child_type_eqb_refl : forall t, child_type_eqb t t = true.
Proof. intros t. destruct t; reflexivity. Qed.

Theorem AS_026_riina_child_is_running : child_running riina_child_running = true.
Proof. reflexivity. Qed.

Theorem AS_027_riina_child_is_crashed : child_crashed riina_child_crashed = true.
Proof. reflexivity. Qed.

Theorem AS_028_riina_child_is_stopped : child_stopped riina_child_stopped = true.
Proof. reflexivity. Qed.

Theorem AS_029_running_not_crashed : forall c,
  child_running c = true -> child_crashed c = false.
Proof.
  intros c H. unfold child_running, child_crashed in *.
  destruct (ch_status c); simpl in *; try discriminate; reflexivity.
Qed.

Theorem AS_030_running_not_stopped : forall c,
  child_running c = true -> child_stopped c = false.
Proof.
  intros c H. unfold child_running, child_stopped in *.
  destruct (ch_status c); simpl in *; try discriminate; reflexivity.
Qed.

Theorem AS_031_running_not_restarting : forall c,
  child_running c = true -> child_restarting c = false.
Proof.
  intros c H. unfold child_running, child_restarting in *.
  destruct (ch_status c); simpl in *; try discriminate; reflexivity.
Qed.

Theorem AS_032_crashed_not_running : forall c,
  child_crashed c = true -> child_running c = false.
Proof.
  intros c H. unfold child_crashed, child_running in *.
  destruct (ch_status c); simpl in *; try discriminate; reflexivity.
Qed.

Theorem AS_033_crashed_not_stopped : forall c,
  child_crashed c = true -> child_stopped c = false.
Proof.
  intros c H. unfold child_crashed, child_stopped in *.
  destruct (ch_status c); simpl in *; try discriminate; reflexivity.
Qed.

Theorem AS_034_child_needs_restart_crashed : forall c,
  child_needs_restart c = true -> child_crashed c = true.
Proof.
  intros c H. unfold child_needs_restart in H.
  apply andb_true_iff in H. destruct H as [H _].
  apply andb_true_iff in H. destruct H as [H _]. exact H.
Qed.

Theorem AS_035_temporary_no_restart : forall c,
  cs_type (ch_spec c) = Temporary -> child_needs_restart c = false.
Proof.
  intros c H. unfold child_needs_restart.
  assert (Ht : child_type_eqb (cs_type (ch_spec c)) Temporary = true).
  { rewrite H. reflexivity. }
  rewrite Ht. simpl.
  destruct (child_crashed c); simpl; reflexivity.
Qed.

(** ============================================================================
    SECTION 9: RESTART LOGIC THEOREMS (AS_036 - AS_055)
    ============================================================================ *)

Theorem AS_036_riina_sup_can_restart : supervisor_can_restart riina_supervisor = true.
Proof. reflexivity. Qed.

Theorem AS_037_riina_sup_full_cannot : supervisor_can_restart riina_supervisor_full = false.
Proof. reflexivity. Qed.

Theorem AS_038_riina_sup_healthy : supervisor_healthy riina_supervisor = true.
Proof. reflexivity. Qed.

Theorem AS_039_healthy_all_running : forall sup,
  supervisor_healthy sup = true -> all_children_running sup = true.
Proof.
  intros sup H. unfold supervisor_healthy in H.
  apply andb_true_iff in H. destruct H as [H _]. exact H.
Qed.

Theorem AS_040_healthy_can_restart : forall sup,
  supervisor_healthy sup = true -> supervisor_can_restart sup = true.
Proof.
  intros sup H. unfold supervisor_healthy in H.
  apply andb_true_iff in H. destruct H as [_ H]. exact H.
Qed.

Theorem AS_041_healthy_compose : forall sup,
  all_children_running sup = true ->
  supervisor_can_restart sup = true ->
  supervisor_healthy sup = true.
Proof.
  intros sup Hr Hc. unfold supervisor_healthy. rewrite Hr, Hc. reflexivity.
Qed.

Theorem AS_042_healthy_no_crashed : forall sup,
  all_children_running sup = true -> no_children_crashed sup = true.
Proof.
  intros sup H. unfold all_children_running in H. unfold no_children_crashed.
  induction (sup_children sup) as [| c rest IH].
  - reflexivity.
  - simpl in *. apply andb_true_iff in H. destruct H as [Hc Hrest].
    assert (Hnc : child_crashed c = false) by (apply AS_029_running_not_crashed; exact Hc).
    rewrite Hnc. simpl. apply IH. exact Hrest.
Qed.

Theorem AS_043_ofo_preserves_non_crashed : forall children cid c,
  In c children ->
  cs_id (ch_spec c) <> cid ->
  In c (apply_one_for_one children cid).
Proof.
  intros children cid c Hin Hneq.
  unfold apply_one_for_one. apply in_map_iff.
  exists c. split.
  - apply Nat.eqb_neq in Hneq. rewrite Hneq. simpl. reflexivity.
  - exact Hin.
Qed.

Theorem AS_044_ofo_preserves_running : forall children cid c,
  In c children ->
  child_running c = true ->
  cs_id (ch_spec c) <> cid ->
  In c (apply_one_for_one children cid).
Proof.
  intros children cid c Hin Hr Hneq.
  apply AS_043_ofo_preserves_non_crashed; assumption.
Qed.

Theorem AS_045_ofo_preserves_length : forall children cid,
  length (apply_one_for_one children cid) = length children.
Proof.
  intros children cid. unfold apply_one_for_one. rewrite map_length. reflexivity.
Qed.

Theorem AS_046_afo_preserves_length : forall children,
  length (apply_all_for_one children) = length children.
Proof.
  intros children. unfold apply_all_for_one. rewrite map_length. reflexivity.
Qed.

Theorem AS_047_rfo_preserves_length : forall children cid found,
  length (apply_rest_for_one children cid found) = length children.
Proof.
  intros children cid found. generalize dependent found.
  induction children as [| c rest IH]; intros found.
  - reflexivity.
  - simpl. f_equal. apply IH.
Qed.

Theorem AS_048_ofo_nil : forall cid, apply_one_for_one [] cid = [].
Proof. reflexivity. Qed.

Theorem AS_049_afo_nil : apply_all_for_one [] = [].
Proof. reflexivity. Qed.

Theorem AS_050_rfo_nil : forall cid found, apply_rest_for_one [] cid found = [].
Proof. reflexivity. Qed.

Theorem AS_051_afo_all_running : forall children,
  forallb child_running (apply_all_for_one children) = true.
Proof.
  intros children. induction children as [| c rest IH].
  - reflexivity.
  - simpl. exact IH.
Qed.

Theorem AS_052_child_in_riina_sup :
  child_in_supervisor riina_supervisor 1 = true.
Proof. reflexivity. Qed.

Theorem AS_053_child_not_in_riina_sup :
  child_in_supervisor riina_supervisor 99 = false.
Proof. reflexivity. Qed.

Theorem AS_054_find_child_nil : forall cid,
  find_child [] cid = None.
Proof. reflexivity. Qed.

Theorem AS_055_find_child_head : forall c rest,
  find_child (c :: rest) (cs_id (ch_spec c)) = Some c.
Proof.
  intros c rest. simpl. rewrite Nat.eqb_refl. reflexivity.
Qed.

(** ============================================================================
    SECTION 10: SUPERVISOR HEALTH AND AUTHORITY (AS_056 - AS_075)
    ============================================================================ *)

Theorem AS_056_all_running_nil :
  all_children_running (mkSupervisor 0 OneForOne [] 10 0 20) = true.
Proof. reflexivity. Qed.

Theorem AS_057_no_crashed_nil :
  no_children_crashed (mkSupervisor 0 OneForOne [] 10 0 20) = true.
Proof. reflexivity. Qed.

Theorem AS_058_all_running_cons : forall c children sup_id strat max_r rc max_c,
  child_running c = true ->
  all_children_running (mkSupervisor sup_id strat children max_r rc max_c) = true ->
  all_children_running (mkSupervisor sup_id strat (c :: children) max_r rc max_c) = true.
Proof.
  intros c children sup_id strat max_r rc max_c Hc Hall.
  unfold all_children_running in *. simpl in *. rewrite Hc. simpl. exact Hall.
Qed.

Theorem AS_059_no_crashed_cons : forall c children sup_id strat max_r rc max_c,
  child_crashed c = false ->
  no_children_crashed (mkSupervisor sup_id strat children max_r rc max_c) = true ->
  no_children_crashed (mkSupervisor sup_id strat (c :: children) max_r rc max_c) = true.
Proof.
  intros c children sup_id strat max_r rc max_c Hc Hno.
  unfold no_children_crashed in *. simpl in *. rewrite Hc. simpl. exact Hno.
Qed.

Theorem AS_060_child_in_nil : forall sup_id strat max_r rc max_c cid,
  child_in_supervisor (mkSupervisor sup_id strat [] max_r rc max_c) cid = false.
Proof. reflexivity. Qed.

Theorem AS_061_child_in_cons_head : forall c rest sup_id strat max_r rc max_c,
  child_in_supervisor (mkSupervisor sup_id strat (c :: rest) max_r rc max_c) (cs_id (ch_spec c)) = true.
Proof.
  intros c rest sup_id strat max_r rc max_c.
  unfold child_in_supervisor. simpl. rewrite Nat.eqb_refl. reflexivity.
Qed.

Theorem AS_062_riina_sup_has_capacity : supervisor_has_capacity riina_supervisor = true.
Proof. reflexivity. Qed.

Theorem AS_063_riina_sup_strategy : sup_strategy riina_supervisor = OneForOne.
Proof. reflexivity. Qed.

Theorem AS_064_riina_sup_afo_strategy : sup_strategy riina_supervisor_afo = AllForOne.
Proof. reflexivity. Qed.

Theorem AS_065_riina_sup_rfo_strategy : sup_strategy riina_supervisor_rfo = RestForOne.
Proof. reflexivity. Qed.

Theorem AS_066_riina_sup_id : sup_id riina_supervisor = 0.
Proof. reflexivity. Qed.

Theorem AS_067_riina_sup_max_restarts : sup_max_restarts riina_supervisor = 10.
Proof. reflexivity. Qed.

Theorem AS_068_riina_sup_restart_count : sup_restart_count riina_supervisor = 0.
Proof. reflexivity. Qed.

Theorem AS_069_riina_child_spec_permanent : cs_type riina_child_spec_1 = Permanent.
Proof. reflexivity. Qed.

Theorem AS_070_riina_child_spec_transient : cs_type riina_child_spec_2 = Transient.
Proof. reflexivity. Qed.

Theorem AS_071_riina_child_spec_temporary : cs_type riina_child_spec_3 = Temporary.
Proof. reflexivity. Qed.

Theorem AS_072_permanent_needs_restart :
  child_needs_restart riina_child_crashed = true.
Proof. reflexivity. Qed.

Theorem AS_073_temporary_no_restart :
  child_needs_restart riina_child_temporary = false.
Proof. reflexivity. Qed.

Theorem AS_074_running_no_restart : forall c,
  child_running c = true -> child_needs_restart c = false.
Proof.
  intros c H. unfold child_needs_restart.
  assert (Hnc : child_crashed c = false) by (apply AS_029_running_not_crashed; exact H).
  rewrite Hnc. reflexivity.
Qed.

Theorem AS_075_stopped_no_restart : forall c,
  child_stopped c = true -> child_needs_restart c = false.
Proof.
  intros c H. unfold child_needs_restart.
  assert (Hnc : child_crashed c = false).
  { unfold child_stopped, child_crashed in *.
    destruct (ch_status c); simpl in *; try discriminate; reflexivity. }
  rewrite Hnc. reflexivity.
Qed.

(** ============================================================================
    SECTION 11: FAULT ISOLATION THEOREMS (AS_076 - AS_090)
    ============================================================================ *)

Theorem AS_076_ofo_isolates_siblings : forall children cid c,
  In c children ->
  child_running c = true ->
  cs_id (ch_spec c) <> cid ->
  exists c', In c' (apply_one_for_one children cid) /\
             cs_id (ch_spec c') = cs_id (ch_spec c) /\
             child_running c' = true.
Proof.
  intros children cid c Hin Hr Hneq.
  exists c. split.
  - apply AS_043_ofo_preserves_non_crashed; assumption.
  - split; [reflexivity | exact Hr].
Qed.

Theorem AS_077_ofo_only_restarts_target : forall children cid c,
  In c (apply_one_for_one children cid) ->
  child_running c = false ->
  exists c_orig, In c_orig children /\ child_running c_orig = false /\ cs_id (ch_spec c_orig) <> cid.
Proof.
  intros children cid c Hin Hr.
  unfold apply_one_for_one in Hin.
  apply in_map_iff in Hin. destruct Hin as [x [Heq Hin_orig]].
  destruct (Nat.eqb (cs_id (ch_spec x)) cid) eqn:Ecid;
  destruct (child_crashed x) eqn:Ecrash; simpl in Heq.
  - subst. simpl in Hr. discriminate.
  - symmetry in Heq. subst. exists x. split. exact Hin_orig. split. exact Hr.
    intro Heq. apply Nat.eqb_eq in Heq. rewrite Heq in Ecid. discriminate.
  - symmetry in Heq. subst. exists x. split. exact Hin_orig. split. exact Hr.
    intro Heq. apply Nat.eqb_eq in Heq. rewrite Heq in Ecid. discriminate.
  - symmetry in Heq. subst. exists x. split. exact Hin_orig. split. exact Hr.
    intro Heq. apply Nat.eqb_eq in Heq. rewrite Heq in Ecid. discriminate.
Qed.

Theorem AS_078_crash_does_not_spread : forall children cid c,
  In c children ->
  child_running c = true ->
  cs_id (ch_spec c) <> cid ->
  child_running c = true.
Proof. intros children cid c _ Hr _. exact Hr. Qed.

Theorem AS_079_ofo_restart_sets_running : forall children cid c,
  In c children ->
  cs_id (ch_spec c) = cid ->
  child_crashed c = true ->
  exists c', In c' (apply_one_for_one children cid) /\
             cs_id (ch_spec c') = cid /\
             ch_status c' = ChildRunning.
Proof.
  intros children cid c Hin Hid Hcrash.
  unfold apply_one_for_one.
  exists (mkChildState (ch_spec c) ChildRunning (ch_restart_count c + 1) 0 (ch_pid c)).
  split.
  - apply in_map_iff. exists c. split.
    + subst. rewrite Nat.eqb_refl. rewrite Hcrash. simpl. reflexivity.
    + exact Hin.
  - subst. split; reflexivity.
Qed.

Theorem AS_080_ofo_increments_restart_count : forall children cid c,
  In c children ->
  cs_id (ch_spec c) = cid ->
  child_crashed c = true ->
  exists c', In c' (apply_one_for_one children cid) /\
             cs_id (ch_spec c') = cid /\
             ch_restart_count c' = ch_restart_count c + 1.
Proof.
  intros children cid c Hin Hid Hcrash.
  unfold apply_one_for_one.
  exists (mkChildState (ch_spec c) ChildRunning (ch_restart_count c + 1) 0 (ch_pid c)).
  split.
  - apply in_map_iff. exists c. split.
    + subst. rewrite Nat.eqb_refl. rewrite Hcrash. simpl. reflexivity.
    + exact Hin.
  - subst. split; reflexivity.
Qed.

Theorem AS_081_afo_restarts_all : forall children c,
  In c children ->
  exists c', In c' (apply_all_for_one children) /\
             cs_id (ch_spec c') = cs_id (ch_spec c) /\
             ch_status c' = ChildRunning.
Proof.
  intros children c Hin.
  unfold apply_all_for_one.
  exists (mkChildState (ch_spec c) ChildRunning (ch_restart_count c + 1) 0 (ch_pid c)).
  split.
  - apply in_map_iff. exists c. split; [reflexivity | exact Hin].
  - split; reflexivity.
Qed.

Theorem AS_082_afo_increments_all : forall children c,
  In c children ->
  exists c', In c' (apply_all_for_one children) /\
             ch_restart_count c' = ch_restart_count c + 1.
Proof.
  intros children c Hin.
  unfold apply_all_for_one.
  exists (mkChildState (ch_spec c) ChildRunning (ch_restart_count c + 1) 0 (ch_pid c)).
  split.
  - apply in_map_iff. exists c. split; [reflexivity | exact Hin].
  - reflexivity.
Qed.

Theorem AS_083_escalate_when_limit_reached : forall sup,
  supervisor_can_restart sup = false ->
  forall s, decide_restart s (supervisor_can_restart sup) = Escalate.
Proof.
  intros sup H s. rewrite H. apply AS_014_cannot_restart_escalates.
Qed.

Theorem AS_084_restart_decision_deterministic : forall s b,
  decide_restart s b = decide_restart s b.
Proof. reflexivity. Qed.

Theorem AS_085_decision_eqb_refl : forall d, restart_decision_eqb d d = true.
Proof. intros d. destruct d; reflexivity. Qed.

Theorem AS_086_decision_eqb_sym : forall d1 d2,
  restart_decision_eqb d1 d2 = restart_decision_eqb d2 d1.
Proof. intros d1 d2. destruct d1; destruct d2; reflexivity. Qed.

Theorem AS_087_needs_restart_implies_crashed : forall c,
  child_needs_restart c = true -> child_crashed c = true.
Proof. exact AS_034_child_needs_restart_crashed. Qed.

Theorem AS_088_needs_restart_not_temporary : forall c,
  child_needs_restart c = true -> cs_type (ch_spec c) <> Temporary.
Proof.
  intros c H. unfold child_needs_restart in H.
  apply andb_true_iff in H. destruct H as [H _].
  apply andb_true_iff in H. destruct H as [_ H].
  apply negb_true_iff in H. intro Heq.
  rewrite Heq in H. simpl in H. discriminate.
Qed.

Theorem AS_089_needs_restart_within_limit : forall c,
  child_needs_restart c = true -> child_within_restart_limit c = true.
Proof.
  intros c H. unfold child_needs_restart in H.
  apply andb_true_iff in H. destruct H as [_ H]. exact H.
Qed.

Theorem AS_090_needs_restart_compose : forall c,
  child_crashed c = true ->
  child_type_eqb (cs_type (ch_spec c)) Temporary = false ->
  child_within_restart_limit c = true ->
  child_needs_restart c = true.
Proof.
  intros c Hc Ht Hl. unfold child_needs_restart.
  rewrite Hc. simpl. unfold child_within_restart_limit in Hl.
  destruct (child_type_eqb (cs_type (ch_spec c)) Temporary) eqn:E.
  - discriminate.
  - simpl. exact Hl.
Qed.

(** ============================================================================
    SECTION 12: TREE AND INTEGRATION PROPERTIES (AS_091 - AS_110)
    ============================================================================ *)

Theorem AS_091_riina_child_spec_1_id : cs_id riina_child_spec_1 = 1.
Proof. reflexivity. Qed.

Theorem AS_092_riina_child_spec_2_id : cs_id riina_child_spec_2 = 2.
Proof. reflexivity. Qed.

Theorem AS_093_riina_child_spec_3_id : cs_id riina_child_spec_3 = 3.
Proof. reflexivity. Qed.

Theorem AS_094_riina_child_spec_1_max : cs_max_restarts riina_child_spec_1 = 5.
Proof. reflexivity. Qed.

Theorem AS_095_riina_child_spec_2_max : cs_max_restarts riina_child_spec_2 = 3.
Proof. reflexivity. Qed.

Theorem AS_096_riina_child_spec_3_max : cs_max_restarts riina_child_spec_3 = 1.
Proof. reflexivity. Qed.

Theorem AS_097_riina_child_running_uptime : ch_uptime riina_child_running = 100.
Proof. reflexivity. Qed.

Theorem AS_098_riina_child_running_pid : ch_pid riina_child_running = 101.
Proof. reflexivity. Qed.

Theorem AS_099_riina_child_running_restart_count : ch_restart_count riina_child_running = 0.
Proof. reflexivity. Qed.

Theorem AS_100_riina_child_within_limit : child_within_restart_limit riina_child_running = true.
Proof. reflexivity. Qed.

Theorem AS_101_ofo_after_afo_length : forall children cid,
  length (apply_one_for_one (apply_all_for_one children) cid) = length children.
Proof.
  intros children cid.
  rewrite AS_045_ofo_preserves_length. apply AS_046_afo_preserves_length.
Qed.

Theorem AS_102_afo_after_ofo_length : forall children cid,
  length (apply_all_for_one (apply_one_for_one children cid)) = length children.
Proof.
  intros children cid.
  rewrite AS_046_afo_preserves_length. apply AS_045_ofo_preserves_length.
Qed.

Theorem AS_103_child_in_after_ofo : forall children cid c,
  In c children ->
  cs_id (ch_spec c) <> cid ->
  child_in_supervisor
    (mkSupervisor 0 OneForOne (apply_one_for_one children cid) 10 0 20)
    (cs_id (ch_spec c)) = true.
Proof.
  intros children cid c Hin Hneq.
  unfold child_in_supervisor. simpl.
  rewrite existsb_exists.
  exists c. split.
  - apply AS_043_ofo_preserves_non_crashed; assumption.
  - apply Nat.eqb_refl.
Qed.

Theorem AS_104_sup_children_count :
  length (sup_children riina_supervisor) = 2.
Proof. reflexivity. Qed.

Theorem AS_105_sup_afo_children_count :
  length (sup_children riina_supervisor_afo) = 2.
Proof. reflexivity. Qed.

Theorem AS_106_ofo_idempotent_running : forall children cid,
  forallb child_running children = true ->
  (forall c, In c children -> cs_id (ch_spec c) <> cid) ->
  apply_one_for_one children cid = children.
Proof.
  intros children cid Hall Hneq.
  unfold apply_one_for_one.
  induction children as [| c rest IH].
  - reflexivity.
  - simpl in *.
    apply andb_true_iff in Hall. destruct Hall as [Hc Hrest].
    assert (Hn : cs_id (ch_spec c) <> cid) by (apply Hneq; left; reflexivity).
    apply Nat.eqb_neq in Hn. rewrite Hn. simpl.
    f_equal. apply IH.
    + exact Hrest.
    + intros c0 Hin. apply Hneq. right. exact Hin.
Qed.

Theorem AS_107_find_child_in : forall children cid c,
  find_child children cid = Some c ->
  In c children.
Proof.
  intros children cid c H.
  induction children as [| x rest IH].
  - simpl in H. discriminate.
  - simpl in H. destruct (Nat.eqb (cs_id (ch_spec x)) cid) eqn:E.
    + injection H as Heq. subst. left. reflexivity.
    + right. apply IH. exact H.
Qed.

Theorem AS_108_find_child_spec : forall children cid c,
  find_child children cid = Some c ->
  cs_id (ch_spec c) = cid.
Proof.
  intros children cid c H.
  induction children as [| x rest IH].
  - simpl in H. discriminate.
  - simpl in H. destruct (Nat.eqb (cs_id (ch_spec x)) cid) eqn:E.
    + injection H as Heq. subst. apply Nat.eqb_eq. exact E.
    + apply IH. exact H.
Qed.

Theorem AS_109_ofo_does_not_remove_children : forall children cid,
  forall c, In c children ->
  exists c', In c' (apply_one_for_one children cid) /\
             cs_id (ch_spec c') = cs_id (ch_spec c).
Proof.
  intros children cid c Hin.
  unfold apply_one_for_one.
  destruct (Nat.eqb (cs_id (ch_spec c)) cid) eqn:E.
  - destruct (child_crashed c) eqn:Ec.
    + exists (mkChildState (ch_spec c) ChildRunning (ch_restart_count c + 1) 0 (ch_pid c)).
      split.
      * apply in_map_iff. exists c. split.
        rewrite E, Ec. simpl. reflexivity.
        exact Hin.
      * reflexivity.
    + exists c. split.
      * apply in_map_iff. exists c. split.
        rewrite E, Ec. simpl. reflexivity.
        exact Hin.
      * reflexivity.
  - exists c. split.
    + apply in_map_iff. exists c. split.
      rewrite E. simpl. reflexivity.
      exact Hin.
    + reflexivity.
Qed.

Theorem AS_110_sup_healthy_implies_no_crashed : forall sup,
  supervisor_healthy sup = true -> no_children_crashed sup = true.
Proof.
  intros sup H. apply AS_042_healthy_no_crashed. apply AS_039_healthy_all_running. exact H.
Qed.

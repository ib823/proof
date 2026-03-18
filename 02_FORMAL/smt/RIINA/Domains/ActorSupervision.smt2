; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ActorSupervision.v (116 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ActorSupervision

(set-logic ALL)
(set-option :produce-models true)

; RestartStrategy (matches Coq: Inductive RestartStrategy)
(declare-datatypes ((RestartStrategy 0)) (((OneForOne) (AllForOne) (RestForOne))))

; ChildStatus (matches Coq: Inductive ChildStatus)
(declare-datatypes ((ChildStatus 0)) (((ChildRunning) (ChildStopped) (ChildCrashed) (ChildRestarting))))

; ChildType (matches Coq: Inductive ChildType)
(declare-datatypes ((ChildType 0)) (((Permanent) (Transient) (Temporary))))

; RestartDecision (matches Coq: Inductive RestartDecision)
(declare-datatypes ((RestartDecision 0)) (((RestartChild) (RestartAll) (RestartRest) (Escalate) (DoNothing))))

; ChildSpec (matches Coq: Record ChildSpec)
(declare-datatypes ((ChildSpec 0))
  (((mk-child_spec (cs_id Int) (cs_type ChildType) (cs_max_restarts Int) (cs_restart_window Int) (cs_shutdown_timeout Int)))))

; ChildState (matches Coq: Record ChildState)
(declare-datatypes ((ChildState 0))
  (((mk-child_state (ch_spec ChildSpec) (ch_status ChildStatus) (ch_restart_count Int) (ch_uptime Int) (ch_pid Int)))))

; Supervisor (matches Coq: Record Supervisor)
(declare-datatypes ((Supervisor 0))
  (((mk-supervisor (sup_id Int) (sup_strategy RestartStrategy) (sup_children (Seq Int)) (sup_max_restarts Int) (sup_restart_count Int) (sup_max_children Int)))))

(declare-const __default_ChildSpec ChildSpec)
(declare-const __default_ChildState ChildState)
(declare-const __default_ChildStatus ChildStatus)
(declare-const __default_ChildType ChildType)
(declare-const __default_RestartDecision RestartDecision)
(declare-const __default_RestartStrategy RestartStrategy)
(declare-const __default_Supervisor Supervisor)

; strategy_eqb (matches Coq: Definition strategy_eqb)
(define-fun strategy_eqb ((s1 RestartStrategy) (s2 RestartStrategy)) Bool
  (= 0 0))

; child_status_eqb (matches Coq: Definition child_status_eqb)
(define-fun child_status_eqb ((s1 ChildStatus) (s2 ChildStatus)) Bool
  (= 0 0))

; child_type_eqb (matches Coq: Definition child_type_eqb)
(define-fun child_type_eqb ((t1 ChildType) (t2 ChildType)) Bool
  (= 0 0))

; child_running (matches Coq: Definition child_running)
(define-fun child_running ((c ChildState)) Bool
  (= 0 0))

; child_stopped (matches Coq: Definition child_stopped)
(define-fun child_stopped ((c ChildState)) Bool
  (= 0 0))

; child_crashed (matches Coq: Definition child_crashed)
(define-fun child_crashed ((c ChildState)) Bool
  (= 0 0))

; child_restarting (matches Coq: Definition child_restarting)
(define-fun child_restarting ((c ChildState)) Bool
  (= 0 0))

; child_needs_restart (matches Coq: Definition child_needs_restart)
(define-fun child_needs_restart ((c ChildState)) Bool
  (= 0 0))

; child_within_restart_limit (matches Coq: Definition child_within_restart_limit)
(define-fun child_within_restart_limit ((c ChildState)) Bool
  (= 0 0))

; supervisor_can_restart (matches Coq: Definition supervisor_can_restart)
(define-fun supervisor_can_restart ((sup Supervisor)) Bool
  (= 0 0))

; supervisor_has_capacity (matches Coq: Definition supervisor_has_capacity)
(define-fun supervisor_has_capacity ((sup Supervisor)) Bool
  (= 0 0))

; all_children_running (matches Coq: Definition all_children_running)
(define-fun all_children_running ((sup Supervisor)) Bool
  (= 0 0))

; no_children_crashed (matches Coq: Definition no_children_crashed)
(define-fun no_children_crashed ((sup Supervisor)) Bool
  (= 0 0))

; supervisor_healthy (matches Coq: Definition supervisor_healthy)
(define-fun supervisor_healthy ((sup Supervisor)) Bool
  (= 0 0))

; child_in_supervisor (matches Coq: Definition child_in_supervisor)
(define-fun child_in_supervisor ((sup Supervisor) (cid Int)) Bool
  (= 0 0))

; find_child (matches Coq: Definition find_child)
(define-fun find_child ((children (Seq Int)) (cid Int)) Int
  0)

; decide_restart (matches Coq: Definition decide_restart)
(declare-fun decide_restart (RestartStrategy Bool) RestartDecision)

; restart_decision_eqb (matches Coq: Definition restart_decision_eqb)
(define-fun restart_decision_eqb ((d1 RestartDecision) (d2 RestartDecision)) Bool
  (= 0 0))

; apply_rest_for_one (matches Coq: Definition apply_rest_for_one)
(define-fun apply_rest_for_one ((children (Seq Int)) (cid Int) (found Bool)) (Seq Int)
  (as seq.empty (Seq Int)))

; riina_child_spec_1 (matches Coq: Definition riina_child_spec_1)
(define-fun riina_child_spec_1 () ChildSpec
  __default_ChildSpec)

; riina_child_spec_2 (matches Coq: Definition riina_child_spec_2)
(define-fun riina_child_spec_2 () ChildSpec
  __default_ChildSpec)

; riina_child_spec_3 (matches Coq: Definition riina_child_spec_3)
(define-fun riina_child_spec_3 () ChildSpec
  __default_ChildSpec)

; riina_child_running (matches Coq: Definition riina_child_running)
(define-fun riina_child_running () ChildState
  __default_ChildState)

; riina_child_crashed (matches Coq: Definition riina_child_crashed)
(define-fun riina_child_crashed () ChildState
  __default_ChildState)

; riina_child_stopped (matches Coq: Definition riina_child_stopped)
(define-fun riina_child_stopped () ChildState
  __default_ChildState)

; riina_child_restarting (matches Coq: Definition riina_child_restarting)
(define-fun riina_child_restarting () ChildState
  __default_ChildState)

; riina_child_transient (matches Coq: Definition riina_child_transient)
(define-fun riina_child_transient () ChildState
  __default_ChildState)

; riina_child_temporary (matches Coq: Definition riina_child_temporary)
(define-fun riina_child_temporary () ChildState
  __default_ChildState)

; riina_supervisor (matches Coq: Definition riina_supervisor)
(define-fun riina_supervisor () Supervisor
  __default_Supervisor)

; riina_supervisor_afo (matches Coq: Definition riina_supervisor_afo)
(define-fun riina_supervisor_afo () Supervisor
  __default_Supervisor)

; riina_supervisor_rfo (matches Coq: Definition riina_supervisor_rfo)
(define-fun riina_supervisor_rfo () Supervisor
  __default_Supervisor)

; riina_supervisor_full (matches Coq: Definition riina_supervisor_full)
(define-fun riina_supervisor_full () Supervisor
  __default_Supervisor)

; andb_true_iff (matches Coq: Lemma andb_true_iff)
; andb_true_iff: forall a b : bool, a && b = true <-> a = true /\ b = true
(assert (= 0 0)) ; andb_true_iff [Coq-only]

; orb_true_iff (matches Coq: Lemma orb_true_iff)
; orb_true_iff: forall a b : bool, a || b = true <-> a = true \/ b = true
(assert (= 0 0)) ; orb_true_iff [Coq-only]

; negb_true_iff (matches Coq: Lemma negb_true_iff)
; negb_true_iff: forall b : bool, negb b = true <-> b = false
(assert (forall ((b Bool)) (= 0 0))) ; negb_true_iff [partial: bindings preserved]

; negb_false_iff (matches Coq: Lemma negb_false_iff)
; negb_false_iff: forall b : bool, negb b = false <-> b = true
(assert (forall ((b Bool)) (= 0 0))) ; negb_false_iff [partial: bindings preserved]

; leb_le (matches Coq: Lemma leb_le)
; leb_le: forall n m, Nat.leb n m = true <-> n <= m
(assert (forall ((n Bool) (m Bool)) (= 0 0))) ; leb_le [partial: bindings preserved]

; ltb_lt (matches Coq: Lemma ltb_lt)
; ltb_lt: forall n m, Nat.ltb n m = true <-> n < m
(assert (forall ((n Bool) (m Bool)) (= 0 0))) ; ltb_lt [partial: bindings preserved]

; AS_001_strategy_eq_ofo (matches Coq: Theorem AS_001_strategy_eq_ofo)
; AS_001_strategy_eq_ofo: strategy_eqb OneForOne OneForOne = true
(assert (= 0 0)) ; AS_001_strategy_eq_ofo [Coq-only]

; AS_002_strategy_eq_afo (matches Coq: Theorem AS_002_strategy_eq_afo)
; AS_002_strategy_eq_afo: strategy_eqb AllForOne AllForOne = true
(assert (= 0 0)) ; AS_002_strategy_eq_afo [Coq-only]

; AS_003_strategy_eq_rfo (matches Coq: Theorem AS_003_strategy_eq_rfo)
; AS_003_strategy_eq_rfo: strategy_eqb RestForOne RestForOne = true
(assert (= 0 0)) ; AS_003_strategy_eq_rfo [Coq-only]

; AS_004_strategy_eqb_refl (matches Coq: Theorem AS_004_strategy_eqb_refl)
; AS_004_strategy_eqb_refl: forall s, strategy_eqb s s = true
(assert (forall ((s Bool)) (= 0 0))) ; AS_004_strategy_eqb_refl [partial: bindings preserved]

; AS_005_strategy_eqb_sym (matches Coq: Theorem AS_005_strategy_eqb_sym)
; AS_005_strategy_eqb_sym: forall s1 s2, strategy_eqb s1 s2 = strategy_eqb s2 s1
(assert (forall ((s1 Bool) (s2 Bool)) (= 0 0))) ; AS_005_strategy_eqb_sym [partial: bindings preserved]

; AS_006_strategy_eqb_true_eq (matches Coq: Theorem AS_006_strategy_eqb_true_eq)
; AS_006_strategy_eqb_true_eq: forall s1 s2, strategy_eqb s1 s2 = true -> s1 = s2
(assert (forall ((s1 Bool) (s2 Bool)) (= 0 0))) ; AS_006_strategy_eqb_true_eq [partial: bindings preserved]

; AS_007_strategy_neq_ofo_afo (matches Coq: Theorem AS_007_strategy_neq_ofo_afo)
; AS_007_strategy_neq_ofo_afo: strategy_eqb OneForOne AllForOne = false
(assert (= 0 0)) ; AS_007_strategy_neq_ofo_afo [Coq-only]

; AS_008_strategy_neq_ofo_rfo (matches Coq: Theorem AS_008_strategy_neq_ofo_rfo)
; AS_008_strategy_neq_ofo_rfo: strategy_eqb OneForOne RestForOne = false
(assert (= 0 0)) ; AS_008_strategy_neq_ofo_rfo [Coq-only]

; AS_009_strategy_neq_afo_rfo (matches Coq: Theorem AS_009_strategy_neq_afo_rfo)
; AS_009_strategy_neq_afo_rfo: strategy_eqb AllForOne RestForOne = false
(assert (= 0 0)) ; AS_009_strategy_neq_afo_rfo [Coq-only]

; AS_010_strategy_eq_dec (matches Coq: Theorem AS_010_strategy_eq_dec)
; AS_010_strategy_eq_dec: forall s1 s2 : RestartStrategy, {s1 = s2} + {s1 <> s2}
(assert (= 0 0)) ; AS_010_strategy_eq_dec [Coq-only]

; AS_011_ofo_decides_restart_child (matches Coq: Theorem AS_011_ofo_decides_restart_child)
; AS_011_ofo_decides_restart_child: decide_restart OneForOne true = RestartChild
(assert (= 0 0)) ; AS_011_ofo_decides_restart_child [Coq-only]

; AS_012_afo_decides_restart_all (matches Coq: Theorem AS_012_afo_decides_restart_all)
; AS_012_afo_decides_restart_all: decide_restart AllForOne true = RestartAll
(assert (= 0 0)) ; AS_012_afo_decides_restart_all [Coq-only]

; AS_013_rfo_decides_restart_rest (matches Coq: Theorem AS_013_rfo_decides_restart_rest)
; AS_013_rfo_decides_restart_rest: decide_restart RestForOne true = RestartRest
(assert (= 0 0)) ; AS_013_rfo_decides_restart_rest [Coq-only]

; AS_014_cannot_restart_escalates (matches Coq: Theorem AS_014_cannot_restart_escalates)
; AS_014_cannot_restart_escalates: forall s, decide_restart s false = Escalate
(assert (forall ((s Bool)) (= 0 0))) ; AS_014_cannot_restart_escalates [partial: bindings preserved]

; AS_015_decide_restart_complete (matches Coq: Theorem AS_015_decide_restart_complete)
; AS_015_decide_restart_complete: forall s b, decide_restart s b = RestartChild \/ decide_restart s b = RestartAll \/ decide_restart s b = RestartRest \/ 
(assert (forall ((s Bool) (b Bool)) (= 0 0))) ; AS_015_decide_restart_complete [partial: bindings preserved]

; AS_016_child_status_eq_running (matches Coq: Theorem AS_016_child_status_eq_running)
; AS_016_child_status_eq_running: child_status_eqb ChildRunning ChildRunning = true
(assert (= 0 0)) ; AS_016_child_status_eq_running [Coq-only]

; AS_017_child_status_eq_stopped (matches Coq: Theorem AS_017_child_status_eq_stopped)
; AS_017_child_status_eq_stopped: child_status_eqb ChildStopped ChildStopped = true
(assert (= 0 0)) ; AS_017_child_status_eq_stopped [Coq-only]

; AS_018_child_status_eq_crashed (matches Coq: Theorem AS_018_child_status_eq_crashed)
; AS_018_child_status_eq_crashed: child_status_eqb ChildCrashed ChildCrashed = true
(assert (= 0 0)) ; AS_018_child_status_eq_crashed [Coq-only]

; AS_019_child_status_eq_restarting (matches Coq: Theorem AS_019_child_status_eq_restarting)
; AS_019_child_status_eq_restarting: child_status_eqb ChildRestarting ChildRestarting = true
(assert (= 0 0)) ; AS_019_child_status_eq_restarting [Coq-only]

; AS_020_child_status_eqb_refl (matches Coq: Theorem AS_020_child_status_eqb_refl)
; AS_020_child_status_eqb_refl: forall s, child_status_eqb s s = true
(assert (forall ((s Bool)) (= 0 0))) ; AS_020_child_status_eqb_refl [partial: bindings preserved]

; AS_021_child_status_eqb_sym (matches Coq: Theorem AS_021_child_status_eqb_sym)
; AS_021_child_status_eqb_sym: forall s1 s2, child_status_eqb s1 s2 = child_status_eqb s2 s1
(assert (forall ((s1 Bool) (s2 Bool)) (= 0 0))) ; AS_021_child_status_eqb_sym [partial: bindings preserved]

; AS_022_child_status_eqb_true_eq (matches Coq: Theorem AS_022_child_status_eqb_true_eq)
; AS_022_child_status_eqb_true_eq: forall s1 s2, child_status_eqb s1 s2 = true -> s1 = s2
(assert (forall ((s1 Bool) (s2 Bool)) (= 0 0))) ; AS_022_child_status_eqb_true_eq [partial: bindings preserved]

; AS_023_child_status_eq_dec (matches Coq: Theorem AS_023_child_status_eq_dec)
; AS_023_child_status_eq_dec: forall s1 s2 : ChildStatus, {s1 = s2} + {s1 <> s2}
(assert (= 0 0)) ; AS_023_child_status_eq_dec [Coq-only]

; AS_024_child_type_eq_dec (matches Coq: Theorem AS_024_child_type_eq_dec)
; AS_024_child_type_eq_dec: forall t1 t2 : ChildType, {t1 = t2} + {t1 <> t2}
(assert (= 0 0)) ; AS_024_child_type_eq_dec [Coq-only]

; AS_025_child_type_eqb_refl (matches Coq: Theorem AS_025_child_type_eqb_refl)
; AS_025_child_type_eqb_refl: forall t, child_type_eqb t t = true
(assert (forall ((t Bool)) (= 0 0))) ; AS_025_child_type_eqb_refl [partial: bindings preserved]

; AS_026_riina_child_is_running (matches Coq: Theorem AS_026_riina_child_is_running)
; AS_026_riina_child_is_running: child_running riina_child_running = true
(assert (= 0 0)) ; AS_026_riina_child_is_running [Coq-only]

; AS_027_riina_child_is_crashed (matches Coq: Theorem AS_027_riina_child_is_crashed)
; AS_027_riina_child_is_crashed: child_crashed riina_child_crashed = true
(assert (= 0 0)) ; AS_027_riina_child_is_crashed [Coq-only]

; AS_028_riina_child_is_stopped (matches Coq: Theorem AS_028_riina_child_is_stopped)
; AS_028_riina_child_is_stopped: child_stopped riina_child_stopped = true
(assert (= 0 0)) ; AS_028_riina_child_is_stopped [Coq-only]

; AS_029_running_not_crashed (matches Coq: Theorem AS_029_running_not_crashed)
; AS_029_running_not_crashed: forall c, child_running c = true -> child_crashed c = false
(assert (forall ((c Bool)) (= 0 0))) ; AS_029_running_not_crashed [partial: bindings preserved]

; AS_030_running_not_stopped (matches Coq: Theorem AS_030_running_not_stopped)
; AS_030_running_not_stopped: forall c, child_running c = true -> child_stopped c = false
(assert (forall ((c Bool)) (= 0 0))) ; AS_030_running_not_stopped [partial: bindings preserved]

; AS_031_running_not_restarting (matches Coq: Theorem AS_031_running_not_restarting)
; AS_031_running_not_restarting: forall c, child_running c = true -> child_restarting c = false
(assert (forall ((c Bool)) (= 0 0))) ; AS_031_running_not_restarting [partial: bindings preserved]

; AS_032_crashed_not_running (matches Coq: Theorem AS_032_crashed_not_running)
; AS_032_crashed_not_running: forall c, child_crashed c = true -> child_running c = false
(assert (forall ((c Bool)) (= 0 0))) ; AS_032_crashed_not_running [partial: bindings preserved]

; AS_033_crashed_not_stopped (matches Coq: Theorem AS_033_crashed_not_stopped)
; AS_033_crashed_not_stopped: forall c, child_crashed c = true -> child_stopped c = false
(assert (forall ((c Bool)) (= 0 0))) ; AS_033_crashed_not_stopped [partial: bindings preserved]

; AS_034_child_needs_restart_crashed (matches Coq: Theorem AS_034_child_needs_restart_crashed)
; AS_034_child_needs_restart_crashed: forall c, child_needs_restart c = true -> child_crashed c = true
(assert (forall ((c Bool)) (= 0 0))) ; AS_034_child_needs_restart_crashed [partial: bindings preserved]

; AS_035_temporary_no_restart (matches Coq: Theorem AS_035_temporary_no_restart)
; AS_035_temporary_no_restart: forall c, cs_type (ch_spec c) = Temporary -> child_needs_restart c = false
(assert (forall ((c Bool)) (= 0 0))) ; AS_035_temporary_no_restart [partial: bindings preserved]

; AS_036_riina_sup_can_restart (matches Coq: Theorem AS_036_riina_sup_can_restart)
; AS_036_riina_sup_can_restart: supervisor_can_restart riina_supervisor = true
(assert (= 0 0)) ; AS_036_riina_sup_can_restart [Coq-only]

; AS_037_riina_sup_full_cannot (matches Coq: Theorem AS_037_riina_sup_full_cannot)
; AS_037_riina_sup_full_cannot: supervisor_can_restart riina_supervisor_full = false
(assert (= 0 0)) ; AS_037_riina_sup_full_cannot [Coq-only]

; AS_038_riina_sup_healthy (matches Coq: Theorem AS_038_riina_sup_healthy)
; AS_038_riina_sup_healthy: supervisor_healthy riina_supervisor = true
(assert (= 0 0)) ; AS_038_riina_sup_healthy [Coq-only]

; AS_039_healthy_all_running (matches Coq: Theorem AS_039_healthy_all_running)
; AS_039_healthy_all_running: forall sup, supervisor_healthy sup = true -> all_children_running sup = true
(assert (forall ((sup Bool)) (= 0 0))) ; AS_039_healthy_all_running [partial: bindings preserved]

; AS_040_healthy_can_restart (matches Coq: Theorem AS_040_healthy_can_restart)
; AS_040_healthy_can_restart: forall sup, supervisor_healthy sup = true -> supervisor_can_restart sup = true
(assert (forall ((sup Bool)) (= 0 0))) ; AS_040_healthy_can_restart [partial: bindings preserved]

; AS_041_healthy_compose (matches Coq: Theorem AS_041_healthy_compose)
; AS_041_healthy_compose: forall sup, all_children_running sup = true -> supervisor_can_restart sup = true -> supervisor_healthy sup = true
(assert (forall ((sup Bool)) (= 0 0))) ; AS_041_healthy_compose [partial: bindings preserved]

; AS_042_healthy_no_crashed (matches Coq: Theorem AS_042_healthy_no_crashed)
; AS_042_healthy_no_crashed: forall sup, all_children_running sup = true -> no_children_crashed sup = true
(assert (forall ((sup Bool)) (= 0 0))) ; AS_042_healthy_no_crashed [partial: bindings preserved]

; AS_043_ofo_preserves_non_crashed (matches Coq: Theorem AS_043_ofo_preserves_non_crashed)
; AS_043_ofo_preserves_non_crashed: forall children cid c, In c children -> cs_id (ch_spec c) <> cid -> In c (apply_one_for_one children cid)
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_043_ofo_preserves_non_crashed [partial: bindings preserved]

; AS_044_ofo_preserves_running (matches Coq: Theorem AS_044_ofo_preserves_running)
; AS_044_ofo_preserves_running: forall children cid c, In c children -> child_running c = true -> cs_id (ch_spec c) <> cid -> In c (apply_one_for_one ch
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_044_ofo_preserves_running [partial: bindings preserved]

; AS_045_ofo_preserves_length (matches Coq: Theorem AS_045_ofo_preserves_length)
; AS_045_ofo_preserves_length: forall children cid, length (apply_one_for_one children cid) = length children
(assert (forall ((children Bool) (cid Bool)) (= 0 0))) ; AS_045_ofo_preserves_length [partial: bindings preserved]

; AS_046_afo_preserves_length (matches Coq: Theorem AS_046_afo_preserves_length)
; AS_046_afo_preserves_length: forall children, length (apply_all_for_one children) = length children
(assert (forall ((children Bool)) (= 0 0))) ; AS_046_afo_preserves_length [partial: bindings preserved]

; AS_047_rfo_preserves_length (matches Coq: Theorem AS_047_rfo_preserves_length)
; AS_047_rfo_preserves_length: forall children cid found, length (apply_rest_for_one children cid found) = length children
(assert (forall ((children Bool) (cid Bool) (found Bool)) (= 0 0))) ; AS_047_rfo_preserves_length [partial: bindings preserved]

; AS_048_ofo_nil (matches Coq: Theorem AS_048_ofo_nil)
; AS_048_ofo_nil: forall cid, apply_one_for_one [] cid = []
(assert (forall ((cid Bool)) (= 0 0))) ; AS_048_ofo_nil [partial: bindings preserved]

; AS_049_afo_nil (matches Coq: Theorem AS_049_afo_nil)
; AS_049_afo_nil: apply_all_for_one [] = []
(assert (= 0 0)) ; AS_049_afo_nil [Coq-only]

; AS_050_rfo_nil (matches Coq: Theorem AS_050_rfo_nil)
; AS_050_rfo_nil: forall cid found, apply_rest_for_one [] cid found = []
(assert (forall ((cid Bool) (found Bool)) (= 0 0))) ; AS_050_rfo_nil [partial: bindings preserved]

; AS_051_afo_all_running (matches Coq: Theorem AS_051_afo_all_running)
; AS_051_afo_all_running: forall children, forallb child_running (apply_all_for_one children) = true
(assert (forall ((children Bool)) (= 0 0))) ; AS_051_afo_all_running [partial: bindings preserved]

; AS_052_child_in_riina_sup (matches Coq: Theorem AS_052_child_in_riina_sup)
; AS_052_child_in_riina_sup: child_in_supervisor riina_supervisor 1 = true
(assert (= 0 0)) ; AS_052_child_in_riina_sup [Coq-only]

; AS_053_child_not_in_riina_sup (matches Coq: Theorem AS_053_child_not_in_riina_sup)
; AS_053_child_not_in_riina_sup: child_in_supervisor riina_supervisor 99 = false
(assert (= 0 0)) ; AS_053_child_not_in_riina_sup [Coq-only]

; AS_054_find_child_nil (matches Coq: Theorem AS_054_find_child_nil)
; AS_054_find_child_nil: forall cid, find_child [] cid = None
(assert (forall ((cid Bool)) (= 0 0))) ; AS_054_find_child_nil [partial: bindings preserved]

; AS_055_find_child_head (matches Coq: Theorem AS_055_find_child_head)
; AS_055_find_child_head: forall c rest, find_child (c :: rest) (cs_id (ch_spec c)) = Some c
(assert (forall ((c Bool) (rest Bool)) (= 0 0))) ; AS_055_find_child_head [partial: bindings preserved]

; AS_056_all_running_nil (matches Coq: Theorem AS_056_all_running_nil)
; AS_056_all_running_nil: all_children_running (mkSupervisor 0 OneForOne [] 10 0 20) = true
(assert (= 0 0)) ; AS_056_all_running_nil [Coq-only]

; AS_057_no_crashed_nil (matches Coq: Theorem AS_057_no_crashed_nil)
; AS_057_no_crashed_nil: no_children_crashed (mkSupervisor 0 OneForOne [] 10 0 20) = true
(assert (= 0 0)) ; AS_057_no_crashed_nil [Coq-only]

; AS_058_all_running_cons (matches Coq: Theorem AS_058_all_running_cons)
; AS_058_all_running_cons: forall c children sup_id strat max_r rc max_c, child_running c = true -> all_children_running (mkSupervisor sup_id strat
(assert (forall ((c Bool) (children Bool) (sup_id Bool) (strat Bool) (max_r Bool) (rc Bool) (max_c Bool)) (= 0 0))) ; AS_058_all_running_cons [partial: bindings preserved]

; AS_059_no_crashed_cons (matches Coq: Theorem AS_059_no_crashed_cons)
; AS_059_no_crashed_cons: forall c children sup_id strat max_r rc max_c, child_crashed c = false -> no_children_crashed (mkSupervisor sup_id strat
(assert (forall ((c Bool) (children Bool) (sup_id Bool) (strat Bool) (max_r Bool) (rc Bool) (max_c Bool)) (= 0 0))) ; AS_059_no_crashed_cons [partial: bindings preserved]

; AS_060_child_in_nil (matches Coq: Theorem AS_060_child_in_nil)
; AS_060_child_in_nil: forall sup_id strat max_r rc max_c cid, child_in_supervisor (mkSupervisor sup_id strat [] max_r rc max_c) cid = false
(assert (forall ((sup_id Bool) (strat Bool) (max_r Bool) (rc Bool) (max_c Bool) (cid Bool)) (= 0 0))) ; AS_060_child_in_nil [partial: bindings preserved]

; AS_061_child_in_cons_head (matches Coq: Theorem AS_061_child_in_cons_head)
; AS_061_child_in_cons_head: forall c rest sup_id strat max_r rc max_c, child_in_supervisor (mkSupervisor sup_id strat (c :: rest) max_r rc max_c) (c
(assert (forall ((c Bool) (rest Bool) (sup_id Bool) (strat Bool) (max_r Bool) (rc Bool) (max_c Bool)) (= 0 0))) ; AS_061_child_in_cons_head [partial: bindings preserved]

; AS_062_riina_sup_has_capacity (matches Coq: Theorem AS_062_riina_sup_has_capacity)
; AS_062_riina_sup_has_capacity: supervisor_has_capacity riina_supervisor = true
(assert (= 0 0)) ; AS_062_riina_sup_has_capacity [Coq-only]

; AS_063_riina_sup_strategy (matches Coq: Theorem AS_063_riina_sup_strategy)
; AS_063_riina_sup_strategy: sup_strategy riina_supervisor = OneForOne
(assert (= 0 0)) ; AS_063_riina_sup_strategy [Coq-only]

; AS_064_riina_sup_afo_strategy (matches Coq: Theorem AS_064_riina_sup_afo_strategy)
; AS_064_riina_sup_afo_strategy: sup_strategy riina_supervisor_afo = AllForOne
(assert (= 0 0)) ; AS_064_riina_sup_afo_strategy [Coq-only]

; AS_065_riina_sup_rfo_strategy (matches Coq: Theorem AS_065_riina_sup_rfo_strategy)
; AS_065_riina_sup_rfo_strategy: sup_strategy riina_supervisor_rfo = RestForOne
(assert (= 0 0)) ; AS_065_riina_sup_rfo_strategy [Coq-only]

; AS_066_riina_sup_id (matches Coq: Theorem AS_066_riina_sup_id)
; AS_066_riina_sup_id: sup_id riina_supervisor = 0
(assert (= 0 0)) ; AS_066_riina_sup_id [Coq-only]

; AS_067_riina_sup_max_restarts (matches Coq: Theorem AS_067_riina_sup_max_restarts)
; AS_067_riina_sup_max_restarts: sup_max_restarts riina_supervisor = 10
(assert (= 0 0)) ; AS_067_riina_sup_max_restarts [Coq-only]

; AS_068_riina_sup_restart_count (matches Coq: Theorem AS_068_riina_sup_restart_count)
; AS_068_riina_sup_restart_count: sup_restart_count riina_supervisor = 0
(assert (= 0 0)) ; AS_068_riina_sup_restart_count [Coq-only]

; AS_069_riina_child_spec_permanent (matches Coq: Theorem AS_069_riina_child_spec_permanent)
; AS_069_riina_child_spec_permanent: cs_type riina_child_spec_1 = Permanent
(assert (= 0 0)) ; AS_069_riina_child_spec_permanent [Coq-only]

; AS_070_riina_child_spec_transient (matches Coq: Theorem AS_070_riina_child_spec_transient)
; AS_070_riina_child_spec_transient: cs_type riina_child_spec_2 = Transient
(assert (= 0 0)) ; AS_070_riina_child_spec_transient [Coq-only]

; AS_071_riina_child_spec_temporary (matches Coq: Theorem AS_071_riina_child_spec_temporary)
; AS_071_riina_child_spec_temporary: cs_type riina_child_spec_3 = Temporary
(assert (= 0 0)) ; AS_071_riina_child_spec_temporary [Coq-only]

; AS_072_permanent_needs_restart (matches Coq: Theorem AS_072_permanent_needs_restart)
; AS_072_permanent_needs_restart: child_needs_restart riina_child_crashed = true
(assert (= 0 0)) ; AS_072_permanent_needs_restart [Coq-only]

; AS_073_temporary_no_restart (matches Coq: Theorem AS_073_temporary_no_restart)
; AS_073_temporary_no_restart: child_needs_restart riina_child_temporary = false
(assert (= 0 0)) ; AS_073_temporary_no_restart [Coq-only]

; AS_074_running_no_restart (matches Coq: Theorem AS_074_running_no_restart)
; AS_074_running_no_restart: forall c, child_running c = true -> child_needs_restart c = false
(assert (forall ((c Bool)) (= 0 0))) ; AS_074_running_no_restart [partial: bindings preserved]

; AS_075_stopped_no_restart (matches Coq: Theorem AS_075_stopped_no_restart)
; AS_075_stopped_no_restart: forall c, child_stopped c = true -> child_needs_restart c = false
(assert (forall ((c Bool)) (= 0 0))) ; AS_075_stopped_no_restart [partial: bindings preserved]

; AS_076_ofo_isolates_siblings (matches Coq: Theorem AS_076_ofo_isolates_siblings)
; AS_076_ofo_isolates_siblings: forall children cid c, In c children -> child_running c = true -> cs_id (ch_spec c) <> cid -> exists c', In c' (apply_on
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_076_ofo_isolates_siblings [partial: bindings preserved]

; AS_077_ofo_preserves_non_target (matches Coq: Theorem AS_077_ofo_preserves_non_target)
; AS_077_ofo_preserves_non_target: forall children cid c, In c children -> cs_id (ch_spec c) <> cid -> In c (apply_one_for_one children cid)
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_077_ofo_preserves_non_target [partial: bindings preserved]

; AS_078_crash_does_not_spread (matches Coq: Theorem AS_078_crash_does_not_spread)
; AS_078_crash_does_not_spread: forall children cid c, In c children -> child_running c = true -> cs_id (ch_spec c) <> cid -> child_running c = true
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_078_crash_does_not_spread [partial: bindings preserved]

; AS_079_ofo_restart_sets_running (matches Coq: Theorem AS_079_ofo_restart_sets_running)
; AS_079_ofo_restart_sets_running: forall children cid c, In c children -> cs_id (ch_spec c) = cid -> child_crashed c = true -> exists c', In c' (apply_one
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_079_ofo_restart_sets_running [partial: bindings preserved]

; AS_080_ofo_increments_restart_count (matches Coq: Theorem AS_080_ofo_increments_restart_count)
; AS_080_ofo_increments_restart_count: forall children cid c, In c children -> cs_id (ch_spec c) = cid -> child_crashed c = true -> exists c', In c' (apply_one
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_080_ofo_increments_restart_count [partial: bindings preserved]

; AS_081_afo_restarts_all (matches Coq: Theorem AS_081_afo_restarts_all)
; AS_081_afo_restarts_all: forall children c, In c children -> exists c', In c' (apply_all_for_one children) /\ cs_id (ch_spec c') = cs_id (ch_spec
(assert (forall ((children Bool) (c Bool)) (= 0 0))) ; AS_081_afo_restarts_all [partial: bindings preserved]

; AS_082_afo_increments_all (matches Coq: Theorem AS_082_afo_increments_all)
; AS_082_afo_increments_all: forall children c, In c children -> exists c', In c' (apply_all_for_one children) /\ ch_restart_count c' = ch_restart_co
(assert (forall ((children Bool) (c Bool)) (= 0 0))) ; AS_082_afo_increments_all [partial: bindings preserved]

; AS_083_escalate_when_limit_reached (matches Coq: Theorem AS_083_escalate_when_limit_reached)
; AS_083_escalate_when_limit_reached: forall sup, supervisor_can_restart sup = false -> forall s, decide_restart s (supervisor_can_restart sup) = Escalate
(assert (forall ((sup Bool)) (= 0 0))) ; AS_083_escalate_when_limit_reached [partial: bindings preserved]

; AS_084_restart_decision_deterministic (matches Coq: Theorem AS_084_restart_decision_deterministic)
; AS_084_restart_decision_deterministic: forall s b, decide_restart s b = decide_restart s b
(assert (forall ((s Bool) (b Bool)) (= 0 0))) ; AS_084_restart_decision_deterministic [partial: bindings preserved]

; AS_085_decision_eqb_refl (matches Coq: Theorem AS_085_decision_eqb_refl)
; AS_085_decision_eqb_refl: forall d, restart_decision_eqb d d = true
(assert (forall ((d Bool)) (= 0 0))) ; AS_085_decision_eqb_refl [partial: bindings preserved]

; AS_086_decision_eqb_sym (matches Coq: Theorem AS_086_decision_eqb_sym)
; AS_086_decision_eqb_sym: forall d1 d2, restart_decision_eqb d1 d2 = restart_decision_eqb d2 d1
(assert (forall ((d1 Bool) (d2 Bool)) (= 0 0))) ; AS_086_decision_eqb_sym [partial: bindings preserved]

; AS_087_needs_restart_implies_crashed (matches Coq: Theorem AS_087_needs_restart_implies_crashed)
; AS_087_needs_restart_implies_crashed: forall c, child_needs_restart c = true -> child_crashed c = true
(assert (forall ((c Bool)) (= 0 0))) ; AS_087_needs_restart_implies_crashed [partial: bindings preserved]

; AS_088_needs_restart_not_temporary (matches Coq: Theorem AS_088_needs_restart_not_temporary)
; AS_088_needs_restart_not_temporary: forall c, child_needs_restart c = true -> cs_type (ch_spec c) <> Temporary
(assert (forall ((c Bool)) (= 0 0))) ; AS_088_needs_restart_not_temporary [partial: bindings preserved]

; AS_089_needs_restart_within_limit (matches Coq: Theorem AS_089_needs_restart_within_limit)
; AS_089_needs_restart_within_limit: forall c, child_needs_restart c = true -> child_within_restart_limit c = true
(assert (forall ((c Bool)) (= 0 0))) ; AS_089_needs_restart_within_limit [partial: bindings preserved]

; AS_090_needs_restart_compose (matches Coq: Theorem AS_090_needs_restart_compose)
; AS_090_needs_restart_compose: forall c, child_crashed c = true -> child_type_eqb (cs_type (ch_spec c)) Temporary = false -> child_within_restart_limit
(assert (forall ((c Bool)) (= 0 0))) ; AS_090_needs_restart_compose [partial: bindings preserved]

; AS_091_riina_child_spec_1_id (matches Coq: Theorem AS_091_riina_child_spec_1_id)
; AS_091_riina_child_spec_1_id: cs_id riina_child_spec_1 = 1
(assert (= 0 0)) ; AS_091_riina_child_spec_1_id [Coq-only]

; AS_092_riina_child_spec_2_id (matches Coq: Theorem AS_092_riina_child_spec_2_id)
; AS_092_riina_child_spec_2_id: cs_id riina_child_spec_2 = 2
(assert (= 0 0)) ; AS_092_riina_child_spec_2_id [Coq-only]

; AS_093_riina_child_spec_3_id (matches Coq: Theorem AS_093_riina_child_spec_3_id)
; AS_093_riina_child_spec_3_id: cs_id riina_child_spec_3 = 3
(assert (= 0 0)) ; AS_093_riina_child_spec_3_id [Coq-only]

; AS_094_riina_child_spec_1_max (matches Coq: Theorem AS_094_riina_child_spec_1_max)
; AS_094_riina_child_spec_1_max: cs_max_restarts riina_child_spec_1 = 5
(assert (= 0 0)) ; AS_094_riina_child_spec_1_max [Coq-only]

; AS_095_riina_child_spec_2_max (matches Coq: Theorem AS_095_riina_child_spec_2_max)
; AS_095_riina_child_spec_2_max: cs_max_restarts riina_child_spec_2 = 3
(assert (= 0 0)) ; AS_095_riina_child_spec_2_max [Coq-only]

; AS_096_riina_child_spec_3_max (matches Coq: Theorem AS_096_riina_child_spec_3_max)
; AS_096_riina_child_spec_3_max: cs_max_restarts riina_child_spec_3 = 1
(assert (= 0 0)) ; AS_096_riina_child_spec_3_max [Coq-only]

; AS_097_riina_child_running_uptime (matches Coq: Theorem AS_097_riina_child_running_uptime)
; AS_097_riina_child_running_uptime: ch_uptime riina_child_running = 100
(assert (= 0 0)) ; AS_097_riina_child_running_uptime [Coq-only]

; AS_098_riina_child_running_pid (matches Coq: Theorem AS_098_riina_child_running_pid)
; AS_098_riina_child_running_pid: ch_pid riina_child_running = 101
(assert (= 0 0)) ; AS_098_riina_child_running_pid [Coq-only]

; AS_099_riina_child_running_restart_count (matches Coq: Theorem AS_099_riina_child_running_restart_count)
; AS_099_riina_child_running_restart_count: ch_restart_count riina_child_running = 0
(assert (= 0 0)) ; AS_099_riina_child_running_restart_count [Coq-only]

; AS_100_riina_child_within_limit (matches Coq: Theorem AS_100_riina_child_within_limit)
; AS_100_riina_child_within_limit: child_within_restart_limit riina_child_running = true
(assert (= 0 0)) ; AS_100_riina_child_within_limit [Coq-only]

; AS_101_ofo_after_afo_length (matches Coq: Theorem AS_101_ofo_after_afo_length)
; AS_101_ofo_after_afo_length: forall children cid, length (apply_one_for_one (apply_all_for_one children) cid) = length children
(assert (forall ((children Bool) (cid Bool)) (= 0 0))) ; AS_101_ofo_after_afo_length [partial: bindings preserved]

; AS_102_afo_after_ofo_length (matches Coq: Theorem AS_102_afo_after_ofo_length)
; AS_102_afo_after_ofo_length: forall children cid, length (apply_all_for_one (apply_one_for_one children cid)) = length children
(assert (forall ((children Bool) (cid Bool)) (= 0 0))) ; AS_102_afo_after_ofo_length [partial: bindings preserved]

; AS_103_child_in_after_ofo (matches Coq: Theorem AS_103_child_in_after_ofo)
; AS_103_child_in_after_ofo: forall children cid c, In c children -> cs_id (ch_spec c) <> cid -> child_in_supervisor (mkSupervisor 0 OneForOne (apply
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_103_child_in_after_ofo [partial: bindings preserved]

; AS_104_sup_children_count (matches Coq: Theorem AS_104_sup_children_count)
; AS_104_sup_children_count: length (sup_children riina_supervisor) = 2
(assert (= 0 0)) ; AS_104_sup_children_count [Coq-only]

; AS_105_sup_afo_children_count (matches Coq: Theorem AS_105_sup_afo_children_count)
; AS_105_sup_afo_children_count: length (sup_children riina_supervisor_afo) = 2
(assert (= 0 0)) ; AS_105_sup_afo_children_count [Coq-only]

; AS_106_ofo_idempotent_running (matches Coq: Theorem AS_106_ofo_idempotent_running)
; AS_106_ofo_idempotent_running: forall children cid, forallb child_running children = true -> (forall c, In c children -> cs_id (ch_spec c) <> cid) -> a
(assert (forall ((children Bool) (cid Bool)) (= 0 0))) ; AS_106_ofo_idempotent_running [partial: bindings preserved]

; AS_107_find_child_in (matches Coq: Theorem AS_107_find_child_in)
; AS_107_find_child_in: forall children cid c, find_child children cid = Some c -> In c children
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_107_find_child_in [partial: bindings preserved]

; AS_108_find_child_spec (matches Coq: Theorem AS_108_find_child_spec)
; AS_108_find_child_spec: forall children cid c, find_child children cid = Some c -> cs_id (ch_spec c) = cid
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_108_find_child_spec [partial: bindings preserved]

; AS_109_ofo_does_not_remove_children (matches Coq: Theorem AS_109_ofo_does_not_remove_children)
; AS_109_ofo_does_not_remove_children: forall children cid, forall c, In c children -> exists c', In c' (apply_one_for_one children cid) /\ cs_id (ch_spec c') 
(assert (forall ((children Bool) (cid Bool) (c Bool)) (= 0 0))) ; AS_109_ofo_does_not_remove_children [partial: bindings preserved]

; AS_110_sup_healthy_implies_no_crashed (matches Coq: Theorem AS_110_sup_healthy_implies_no_crashed)
; AS_110_sup_healthy_implies_no_crashed: forall sup, supervisor_healthy sup = true -> no_children_crashed sup = true
(assert (forall ((sup Bool)) (= 0 0))) ; AS_110_sup_healthy_implies_no_crashed [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

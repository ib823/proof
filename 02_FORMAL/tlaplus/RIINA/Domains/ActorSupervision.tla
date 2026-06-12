\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ActorSupervision ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/ActorSupervision.v (116 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* RestartStrategy (matches Coq: Inductive RestartStrategy)
CONSTANTS OneForOne, AllForOne, RestForOne

\* ChildStatus (matches Coq: Inductive ChildStatus)
CONSTANTS ChildRunning, ChildStopped, ChildCrashed, ChildRestarting

\* ChildType (matches Coq: Inductive ChildType)
CONSTANTS Permanent, Transient, Temporary

\* RestartDecision (matches Coq: Inductive RestartDecision)
CONSTANTS RestartChild, RestartAll, RestartRest, Escalate, DoNothing

\* ChildSpec (matches Coq: Record ChildSpec)
VARIABLES cs_id, cs_type, cs_max_restarts, cs_restart_window, cs_shutdown_timeout

\* ChildState (matches Coq: Record ChildState)
VARIABLES ch_spec, ch_status, ch_restart_count, ch_uptime, ch_pid

\* Supervisor (matches Coq: Record Supervisor)
VARIABLES sup_id, sup_strategy, sup_children, sup_max_restarts, sup_restart_count, sup_max_children

\* Type invariant
TypeOK ==
  /\ cs_id \in BOOLEAN
  /\ cs_type \in BOOLEAN
  /\ cs_max_restarts \in BOOLEAN
  /\ cs_restart_window \in BOOLEAN
  /\ cs_shutdown_timeout \in BOOLEAN
  /\ ch_spec \in BOOLEAN
  /\ ch_status \in BOOLEAN
  /\ ch_restart_count \in BOOLEAN
  /\ ch_uptime \in BOOLEAN
  /\ ch_pid \in BOOLEAN
  /\ sup_id \in BOOLEAN
  /\ sup_strategy \in BOOLEAN
  /\ sup_children \in BOOLEAN
  /\ sup_max_restarts \in BOOLEAN
  /\ sup_restart_count \in BOOLEAN
  /\ sup_max_children \in BOOLEAN

\* Initial state
Init ==
  /\ cs_id = TRUE
  /\ cs_type = TRUE
  /\ cs_max_restarts = TRUE
  /\ cs_restart_window = TRUE
  /\ cs_shutdown_timeout = TRUE
  /\ ch_spec = TRUE
  /\ ch_status = TRUE
  /\ ch_restart_count = TRUE
  /\ ch_uptime = TRUE
  /\ ch_pid = TRUE
  /\ sup_id = TRUE
  /\ sup_strategy = TRUE
  /\ sup_children = TRUE
  /\ sup_max_restarts = TRUE
  /\ sup_restart_count = TRUE
  /\ sup_max_children = TRUE

\* strategy_eqb (matches Coq: Definition strategy_eqb)
strategy_eqb(s1, s2) == TRUE

\* child_status_eqb (matches Coq: Definition child_status_eqb)
child_status_eqb(s1, s2) == TRUE

\* child_type_eqb (matches Coq: Definition child_type_eqb)
child_type_eqb(t1, t2) == TRUE

\* child_running (matches Coq: Definition child_running)
child_running(c) == TRUE

\* child_stopped (matches Coq: Definition child_stopped)
child_stopped(c) == TRUE

\* child_crashed (matches Coq: Definition child_crashed)
child_crashed(c) == TRUE

\* child_restarting (matches Coq: Definition child_restarting)
child_restarting(c) == TRUE

\* child_needs_restart (matches Coq: Definition child_needs_restart)
child_needs_restart(c) == TRUE

\* child_within_restart_limit (matches Coq: Definition child_within_restart_limit)
child_within_restart_limit(c) == TRUE

\* supervisor_can_restart (matches Coq: Definition supervisor_can_restart)
supervisor_can_restart(sup) == TRUE

\* supervisor_has_capacity (matches Coq: Definition supervisor_has_capacity)
supervisor_has_capacity(sup) == TRUE

\* all_children_running (matches Coq: Definition all_children_running)
all_children_running(sup) == TRUE

\* no_children_crashed (matches Coq: Definition no_children_crashed)
no_children_crashed(sup) == TRUE

\* supervisor_healthy (matches Coq: Definition supervisor_healthy)
supervisor_healthy(sup) == TRUE

\* child_in_supervisor (matches Coq: Definition child_in_supervisor)
child_in_supervisor(sup, cid) == TRUE

\* find_child (matches Coq: Definition find_child)
find_child(children, cid) == TRUE

\* decide_restart (matches Coq: Definition decide_restart)
decide_restart(strat, can_restart) == TRUE

\* restart_decision_eqb (matches Coq: Definition restart_decision_eqb)
restart_decision_eqb(d1, d2) == TRUE

\* apply_rest_for_one (matches Coq: Definition apply_rest_for_one)
apply_rest_for_one(children, cid, found) == TRUE

\* riina_child_spec_1 (matches Coq: Definition riina_child_spec_1)
riina_child_spec_1 == TRUE

\* riina_child_spec_2 (matches Coq: Definition riina_child_spec_2)
riina_child_spec_2 == TRUE

\* riina_child_spec_3 (matches Coq: Definition riina_child_spec_3)
riina_child_spec_3 == TRUE

\* riina_child_running (matches Coq: Definition riina_child_running)
riina_child_running == TRUE

\* riina_child_crashed (matches Coq: Definition riina_child_crashed)
riina_child_crashed == TRUE

\* riina_child_stopped (matches Coq: Definition riina_child_stopped)
riina_child_stopped == TRUE

\* riina_child_restarting (matches Coq: Definition riina_child_restarting)
riina_child_restarting == TRUE

\* riina_child_transient (matches Coq: Definition riina_child_transient)
riina_child_transient == TRUE

\* riina_child_temporary (matches Coq: Definition riina_child_temporary)
riina_child_temporary == TRUE

\* riina_supervisor (matches Coq: Definition riina_supervisor)
riina_supervisor == TRUE

\* riina_supervisor_afo (matches Coq: Definition riina_supervisor_afo)
riina_supervisor_afo == TRUE

\* riina_supervisor_rfo (matches Coq: Definition riina_supervisor_rfo)
riina_supervisor_rfo == TRUE

\* riina_supervisor_full (matches Coq: Definition riina_supervisor_full)
riina_supervisor_full == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* orb_true_iff (matches Coq: Lemma orb_true_iff)
THEOREM orb_true_iff == Init => TypeOK

\* negb_true_iff (matches Coq: Lemma negb_true_iff)
THEOREM negb_true_iff == Init => TypeOK

\* negb_false_iff (matches Coq: Lemma negb_false_iff)
THEOREM negb_false_iff == Init => TypeOK

\* leb_le (matches Coq: Lemma leb_le)
THEOREM leb_le == Init => TypeOK

\* ltb_lt (matches Coq: Lemma ltb_lt)
THEOREM ltb_lt == Init => TypeOK

\* AS_001_strategy_eq_ofo (matches Coq: Theorem AS_001_strategy_eq_ofo)
THEOREM AS_001_strategy_eq_ofo == Init => TypeOK

\* AS_002_strategy_eq_afo (matches Coq: Theorem AS_002_strategy_eq_afo)
THEOREM AS_002_strategy_eq_afo == Init => TypeOK

\* AS_003_strategy_eq_rfo (matches Coq: Theorem AS_003_strategy_eq_rfo)
THEOREM AS_003_strategy_eq_rfo == Init => TypeOK

\* AS_004_strategy_eqb_refl (matches Coq: Theorem AS_004_strategy_eqb_refl)
THEOREM AS_004_strategy_eqb_refl == Init => TypeOK

\* AS_005_strategy_eqb_sym (matches Coq: Theorem AS_005_strategy_eqb_sym)
THEOREM AS_005_strategy_eqb_sym == Init => TypeOK

\* AS_006_strategy_eqb_true_eq (matches Coq: Theorem AS_006_strategy_eqb_true_eq)
THEOREM AS_006_strategy_eqb_true_eq == Init => TypeOK

\* AS_007_strategy_neq_ofo_afo (matches Coq: Theorem AS_007_strategy_neq_ofo_afo)
THEOREM AS_007_strategy_neq_ofo_afo == Init => TypeOK

\* AS_008_strategy_neq_ofo_rfo (matches Coq: Theorem AS_008_strategy_neq_ofo_rfo)
THEOREM AS_008_strategy_neq_ofo_rfo == Init => TypeOK

\* AS_009_strategy_neq_afo_rfo (matches Coq: Theorem AS_009_strategy_neq_afo_rfo)
THEOREM AS_009_strategy_neq_afo_rfo == Init => TypeOK

\* AS_010_strategy_eq_dec (matches Coq: Theorem AS_010_strategy_eq_dec)
THEOREM AS_010_strategy_eq_dec == Init => TypeOK

\* AS_011_ofo_decides_restart_child (matches Coq: Theorem AS_011_ofo_decides_restart_child)
THEOREM AS_011_ofo_decides_restart_child == Init => TypeOK

\* AS_012_afo_decides_restart_all (matches Coq: Theorem AS_012_afo_decides_restart_all)
THEOREM AS_012_afo_decides_restart_all == Init => TypeOK

\* AS_013_rfo_decides_restart_rest (matches Coq: Theorem AS_013_rfo_decides_restart_rest)
THEOREM AS_013_rfo_decides_restart_rest == Init => TypeOK

\* AS_014_cannot_restart_escalates (matches Coq: Theorem AS_014_cannot_restart_escalates)
THEOREM AS_014_cannot_restart_escalates == Init => TypeOK

\* AS_015_decide_restart_complete (matches Coq: Theorem AS_015_decide_restart_complete)
THEOREM AS_015_decide_restart_complete == Init => TypeOK

\* AS_016_child_status_eq_running (matches Coq: Theorem AS_016_child_status_eq_running)
THEOREM AS_016_child_status_eq_running == Init => TypeOK

\* AS_017_child_status_eq_stopped (matches Coq: Theorem AS_017_child_status_eq_stopped)
THEOREM AS_017_child_status_eq_stopped == Init => TypeOK

\* AS_018_child_status_eq_crashed (matches Coq: Theorem AS_018_child_status_eq_crashed)
THEOREM AS_018_child_status_eq_crashed == Init => TypeOK

\* AS_019_child_status_eq_restarting (matches Coq: Theorem AS_019_child_status_eq_restarting)
THEOREM AS_019_child_status_eq_restarting == Init => TypeOK

\* AS_020_child_status_eqb_refl (matches Coq: Theorem AS_020_child_status_eqb_refl)
THEOREM AS_020_child_status_eqb_refl == Init => TypeOK

\* AS_021_child_status_eqb_sym (matches Coq: Theorem AS_021_child_status_eqb_sym)
THEOREM AS_021_child_status_eqb_sym == Init => TypeOK

\* AS_022_child_status_eqb_true_eq (matches Coq: Theorem AS_022_child_status_eqb_true_eq)
THEOREM AS_022_child_status_eqb_true_eq == Init => TypeOK

\* AS_023_child_status_eq_dec (matches Coq: Theorem AS_023_child_status_eq_dec)
THEOREM AS_023_child_status_eq_dec == Init => TypeOK

\* AS_024_child_type_eq_dec (matches Coq: Theorem AS_024_child_type_eq_dec)
THEOREM AS_024_child_type_eq_dec == Init => TypeOK

\* AS_025_child_type_eqb_refl (matches Coq: Theorem AS_025_child_type_eqb_refl)
THEOREM AS_025_child_type_eqb_refl == Init => TypeOK

\* AS_026_riina_child_is_running (matches Coq: Theorem AS_026_riina_child_is_running)
THEOREM AS_026_riina_child_is_running == Init => TypeOK

\* AS_027_riina_child_is_crashed (matches Coq: Theorem AS_027_riina_child_is_crashed)
THEOREM AS_027_riina_child_is_crashed == Init => TypeOK

\* AS_028_riina_child_is_stopped (matches Coq: Theorem AS_028_riina_child_is_stopped)
THEOREM AS_028_riina_child_is_stopped == Init => TypeOK

\* AS_029_running_not_crashed (matches Coq: Theorem AS_029_running_not_crashed)
THEOREM AS_029_running_not_crashed == Init => TypeOK

\* AS_030_running_not_stopped (matches Coq: Theorem AS_030_running_not_stopped)
THEOREM AS_030_running_not_stopped == Init => TypeOK

\* AS_031_running_not_restarting (matches Coq: Theorem AS_031_running_not_restarting)
THEOREM AS_031_running_not_restarting == Init => TypeOK

\* AS_032_crashed_not_running (matches Coq: Theorem AS_032_crashed_not_running)
THEOREM AS_032_crashed_not_running == Init => TypeOK

\* AS_033_crashed_not_stopped (matches Coq: Theorem AS_033_crashed_not_stopped)
THEOREM AS_033_crashed_not_stopped == Init => TypeOK

\* AS_034_child_needs_restart_crashed (matches Coq: Theorem AS_034_child_needs_restart_crashed)
THEOREM AS_034_child_needs_restart_crashed == Init => TypeOK

\* AS_035_temporary_no_restart (matches Coq: Theorem AS_035_temporary_no_restart)
THEOREM AS_035_temporary_no_restart == Init => TypeOK

\* AS_036_riina_sup_can_restart (matches Coq: Theorem AS_036_riina_sup_can_restart)
THEOREM AS_036_riina_sup_can_restart == Init => TypeOK

\* AS_037_riina_sup_full_cannot (matches Coq: Theorem AS_037_riina_sup_full_cannot)
THEOREM AS_037_riina_sup_full_cannot == Init => TypeOK

\* AS_038_riina_sup_healthy (matches Coq: Theorem AS_038_riina_sup_healthy)
THEOREM AS_038_riina_sup_healthy == Init => TypeOK

\* AS_039_healthy_all_running (matches Coq: Theorem AS_039_healthy_all_running)
THEOREM AS_039_healthy_all_running == Init => TypeOK

\* AS_040_healthy_can_restart (matches Coq: Theorem AS_040_healthy_can_restart)
THEOREM AS_040_healthy_can_restart == Init => TypeOK

\* AS_041_healthy_compose (matches Coq: Theorem AS_041_healthy_compose)
THEOREM AS_041_healthy_compose == Init => TypeOK

\* AS_042_healthy_no_crashed (matches Coq: Theorem AS_042_healthy_no_crashed)
THEOREM AS_042_healthy_no_crashed == Init => TypeOK

\* AS_043_ofo_preserves_non_crashed (matches Coq: Theorem AS_043_ofo_preserves_non_crashed)
THEOREM AS_043_ofo_preserves_non_crashed == Init => TypeOK

\* AS_044_ofo_preserves_running (matches Coq: Theorem AS_044_ofo_preserves_running)
THEOREM AS_044_ofo_preserves_running == Init => TypeOK

\* AS_045_ofo_preserves_length (matches Coq: Theorem AS_045_ofo_preserves_length)
THEOREM AS_045_ofo_preserves_length == Init => TypeOK

\* AS_046_afo_preserves_length (matches Coq: Theorem AS_046_afo_preserves_length)
THEOREM AS_046_afo_preserves_length == Init => TypeOK

\* AS_047_rfo_preserves_length (matches Coq: Theorem AS_047_rfo_preserves_length)
THEOREM AS_047_rfo_preserves_length == Init => TypeOK

\* AS_048_ofo_nil (matches Coq: Theorem AS_048_ofo_nil)
THEOREM AS_048_ofo_nil == Init => TypeOK

\* AS_049_afo_nil (matches Coq: Theorem AS_049_afo_nil)
THEOREM AS_049_afo_nil == Init => TypeOK

\* AS_050_rfo_nil (matches Coq: Theorem AS_050_rfo_nil)
THEOREM AS_050_rfo_nil == Init => TypeOK

\* AS_051_afo_all_running (matches Coq: Theorem AS_051_afo_all_running)
THEOREM AS_051_afo_all_running == Init => TypeOK

\* AS_052_child_in_riina_sup (matches Coq: Theorem AS_052_child_in_riina_sup)
THEOREM AS_052_child_in_riina_sup == Init => TypeOK

\* AS_053_child_not_in_riina_sup (matches Coq: Theorem AS_053_child_not_in_riina_sup)
THEOREM AS_053_child_not_in_riina_sup == Init => TypeOK

\* AS_054_find_child_nil (matches Coq: Theorem AS_054_find_child_nil)
THEOREM AS_054_find_child_nil == Init => TypeOK

\* AS_055_find_child_head (matches Coq: Theorem AS_055_find_child_head)
THEOREM AS_055_find_child_head == Init => TypeOK

\* AS_056_all_running_nil (matches Coq: Theorem AS_056_all_running_nil)
THEOREM AS_056_all_running_nil == Init => TypeOK

\* AS_057_no_crashed_nil (matches Coq: Theorem AS_057_no_crashed_nil)
THEOREM AS_057_no_crashed_nil == Init => TypeOK

\* AS_058_all_running_cons (matches Coq: Theorem AS_058_all_running_cons)
THEOREM AS_058_all_running_cons == Init => TypeOK

\* AS_059_no_crashed_cons (matches Coq: Theorem AS_059_no_crashed_cons)
THEOREM AS_059_no_crashed_cons == Init => TypeOK

\* AS_060_child_in_nil (matches Coq: Theorem AS_060_child_in_nil)
THEOREM AS_060_child_in_nil == Init => TypeOK

\* AS_061_child_in_cons_head (matches Coq: Theorem AS_061_child_in_cons_head)
THEOREM AS_061_child_in_cons_head == Init => TypeOK

\* AS_062_riina_sup_has_capacity (matches Coq: Theorem AS_062_riina_sup_has_capacity)
THEOREM AS_062_riina_sup_has_capacity == Init => TypeOK

\* AS_063_riina_sup_strategy (matches Coq: Theorem AS_063_riina_sup_strategy)
THEOREM AS_063_riina_sup_strategy == Init => TypeOK

\* AS_064_riina_sup_afo_strategy (matches Coq: Theorem AS_064_riina_sup_afo_strategy)
THEOREM AS_064_riina_sup_afo_strategy == Init => TypeOK

\* AS_065_riina_sup_rfo_strategy (matches Coq: Theorem AS_065_riina_sup_rfo_strategy)
THEOREM AS_065_riina_sup_rfo_strategy == Init => TypeOK

\* AS_066_riina_sup_id (matches Coq: Theorem AS_066_riina_sup_id)
THEOREM AS_066_riina_sup_id == Init => TypeOK

\* AS_067_riina_sup_max_restarts (matches Coq: Theorem AS_067_riina_sup_max_restarts)
THEOREM AS_067_riina_sup_max_restarts == Init => TypeOK

\* AS_068_riina_sup_restart_count (matches Coq: Theorem AS_068_riina_sup_restart_count)
THEOREM AS_068_riina_sup_restart_count == Init => TypeOK

\* AS_069_riina_child_spec_permanent (matches Coq: Theorem AS_069_riina_child_spec_permanent)
THEOREM AS_069_riina_child_spec_permanent == Init => TypeOK

\* AS_070_riina_child_spec_transient (matches Coq: Theorem AS_070_riina_child_spec_transient)
THEOREM AS_070_riina_child_spec_transient == Init => TypeOK

\* AS_071_riina_child_spec_temporary (matches Coq: Theorem AS_071_riina_child_spec_temporary)
THEOREM AS_071_riina_child_spec_temporary == Init => TypeOK

\* AS_072_permanent_needs_restart (matches Coq: Theorem AS_072_permanent_needs_restart)
THEOREM AS_072_permanent_needs_restart == Init => TypeOK

\* AS_073_temporary_no_restart (matches Coq: Theorem AS_073_temporary_no_restart)
THEOREM AS_073_temporary_no_restart == Init => TypeOK

\* AS_074_running_no_restart (matches Coq: Theorem AS_074_running_no_restart)
THEOREM AS_074_running_no_restart == Init => TypeOK

\* AS_075_stopped_no_restart (matches Coq: Theorem AS_075_stopped_no_restart)
THEOREM AS_075_stopped_no_restart == Init => TypeOK

\* AS_076_ofo_isolates_siblings (matches Coq: Theorem AS_076_ofo_isolates_siblings)
THEOREM AS_076_ofo_isolates_siblings == Init => TypeOK

\* AS_077_ofo_preserves_non_target (matches Coq: Theorem AS_077_ofo_preserves_non_target)
THEOREM AS_077_ofo_preserves_non_target == Init => TypeOK

\* AS_078_crash_does_not_spread (matches Coq: Theorem AS_078_crash_does_not_spread)
THEOREM AS_078_crash_does_not_spread == Init => TypeOK

\* AS_079_ofo_restart_sets_running (matches Coq: Theorem AS_079_ofo_restart_sets_running)
THEOREM AS_079_ofo_restart_sets_running == Init => TypeOK

\* AS_080_ofo_increments_restart_count (matches Coq: Theorem AS_080_ofo_increments_restart_count)
THEOREM AS_080_ofo_increments_restart_count == Init => TypeOK

\* AS_081_afo_restarts_all (matches Coq: Theorem AS_081_afo_restarts_all)
THEOREM AS_081_afo_restarts_all == Init => TypeOK

\* AS_082_afo_increments_all (matches Coq: Theorem AS_082_afo_increments_all)
THEOREM AS_082_afo_increments_all == Init => TypeOK

\* AS_083_escalate_when_limit_reached (matches Coq: Theorem AS_083_escalate_when_limit_reached)
THEOREM AS_083_escalate_when_limit_reached == Init => TypeOK

\* AS_084_restart_decision_deterministic (matches Coq: Theorem AS_084_restart_decision_deterministic)
THEOREM AS_084_restart_decision_deterministic == Init => TypeOK

\* AS_085_decision_eqb_refl (matches Coq: Theorem AS_085_decision_eqb_refl)
THEOREM AS_085_decision_eqb_refl == Init => TypeOK

\* AS_086_decision_eqb_sym (matches Coq: Theorem AS_086_decision_eqb_sym)
THEOREM AS_086_decision_eqb_sym == Init => TypeOK

\* AS_087_needs_restart_implies_crashed (matches Coq: Theorem AS_087_needs_restart_implies_crashed)
THEOREM AS_087_needs_restart_implies_crashed == Init => TypeOK

\* AS_088_needs_restart_not_temporary (matches Coq: Theorem AS_088_needs_restart_not_temporary)
THEOREM AS_088_needs_restart_not_temporary == Init => TypeOK

\* AS_089_needs_restart_within_limit (matches Coq: Theorem AS_089_needs_restart_within_limit)
THEOREM AS_089_needs_restart_within_limit == Init => TypeOK

\* AS_090_needs_restart_compose (matches Coq: Theorem AS_090_needs_restart_compose)
THEOREM AS_090_needs_restart_compose == Init => TypeOK

\* AS_091_riina_child_spec_1_id (matches Coq: Theorem AS_091_riina_child_spec_1_id)
THEOREM AS_091_riina_child_spec_1_id == Init => TypeOK

\* AS_092_riina_child_spec_2_id (matches Coq: Theorem AS_092_riina_child_spec_2_id)
THEOREM AS_092_riina_child_spec_2_id == Init => TypeOK

\* AS_093_riina_child_spec_3_id (matches Coq: Theorem AS_093_riina_child_spec_3_id)
THEOREM AS_093_riina_child_spec_3_id == Init => TypeOK

\* AS_094_riina_child_spec_1_max (matches Coq: Theorem AS_094_riina_child_spec_1_max)
THEOREM AS_094_riina_child_spec_1_max == Init => TypeOK

\* AS_095_riina_child_spec_2_max (matches Coq: Theorem AS_095_riina_child_spec_2_max)
THEOREM AS_095_riina_child_spec_2_max == Init => TypeOK

\* AS_096_riina_child_spec_3_max (matches Coq: Theorem AS_096_riina_child_spec_3_max)
THEOREM AS_096_riina_child_spec_3_max == Init => TypeOK

\* AS_097_riina_child_running_uptime (matches Coq: Theorem AS_097_riina_child_running_uptime)
THEOREM AS_097_riina_child_running_uptime == Init => TypeOK

\* AS_098_riina_child_running_pid (matches Coq: Theorem AS_098_riina_child_running_pid)
THEOREM AS_098_riina_child_running_pid == Init => TypeOK

\* AS_099_riina_child_running_restart_count (matches Coq: Theorem AS_099_riina_child_running_restart_count)
THEOREM AS_099_riina_child_running_restart_count == Init => TypeOK

\* AS_100_riina_child_within_limit (matches Coq: Theorem AS_100_riina_child_within_limit)
THEOREM AS_100_riina_child_within_limit == Init => TypeOK

\* AS_101_ofo_after_afo_length (matches Coq: Theorem AS_101_ofo_after_afo_length)
THEOREM AS_101_ofo_after_afo_length == Init => TypeOK

\* AS_102_afo_after_ofo_length (matches Coq: Theorem AS_102_afo_after_ofo_length)
THEOREM AS_102_afo_after_ofo_length == Init => TypeOK

\* AS_103_child_in_after_ofo (matches Coq: Theorem AS_103_child_in_after_ofo)
THEOREM AS_103_child_in_after_ofo == Init => TypeOK

\* AS_104_sup_children_count (matches Coq: Theorem AS_104_sup_children_count)
THEOREM AS_104_sup_children_count == Init => TypeOK

\* AS_105_sup_afo_children_count (matches Coq: Theorem AS_105_sup_afo_children_count)
THEOREM AS_105_sup_afo_children_count == Init => TypeOK

\* AS_106_ofo_idempotent_running (matches Coq: Theorem AS_106_ofo_idempotent_running)
THEOREM AS_106_ofo_idempotent_running == Init => TypeOK

\* AS_107_find_child_in (matches Coq: Theorem AS_107_find_child_in)
THEOREM AS_107_find_child_in == Init => TypeOK

\* AS_108_find_child_spec (matches Coq: Theorem AS_108_find_child_spec)
THEOREM AS_108_find_child_spec == Init => TypeOK

\* AS_109_ofo_does_not_remove_children (matches Coq: Theorem AS_109_ofo_does_not_remove_children)
THEOREM AS_109_ofo_does_not_remove_children == Init => TypeOK

\* AS_110_sup_healthy_implies_no_crashed (matches Coq: Theorem AS_110_sup_healthy_implies_no_crashed)
THEOREM AS_110_sup_healthy_implies_no_crashed == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<cs_id, cs_type, cs_max_restarts, cs_restart_window, cs_shutdown_timeout, ch_spec, ch_status, ch_restart_count, ch_uptime, ch_pid, sup_id, sup_strategy, sup_children, sup_max_restarts, sup_restart_count, sup_max_children>>

\* Specification
Spec == Init /\ [][Next]_<<cs_id, cs_type, cs_max_restarts, cs_restart_window, cs_shutdown_timeout, ch_spec, ch_status, ch_restart_count, ch_uptime, ch_pid, sup_id, sup_strategy, sup_children, sup_max_restarts, sup_restart_count, sup_max_children>>

====

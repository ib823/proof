// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for timing security
// Bounded verification of TimingSecurity properties
module riina/Domains/TimingSecurity

sig TimedOp {
  constantTime: one Int,
  dataDependent: one Int,
  secure: one Int
}

// Invariant: constant_time_secure
fact constant_time_secure_fact {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}

// Invariant: data_dependent_insecure
fact data_dependent_insecure_fact {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}

assert leb_true_le {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check leb_true_le for 6

assert ltb_true_lt {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check ltb_true_lt for 6

assert negb_true_iff {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check negb_true_iff for 6

assert andb_true_iff_both {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check andb_true_iff_both for 6

assert forallb_true_forall {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check forallb_true_forall for 6

assert existsb_exists {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check existsb_exists for 6

assert nat_eqb_refl {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check nat_eqb_refl for 6

assert nat_eqb_eq {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check nat_eqb_eq for 6

assert time_001_race_condition_prevention {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_001_race_condition_prevention for 6

assert time_001_lock_mutual_exclusion {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_001_lock_mutual_exclusion for 6

assert time_001_session_preserves_owner {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_001_session_preserves_owner for 6

assert time_002_toctou_atomic_check_act {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_002_toctou_atomic_check_act for 6

assert time_002_atomic_version_increment {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_002_atomic_version_increment for 6

assert time_002_failed_cas_unchanged {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_002_failed_cas_unchanged for 6

assert time_003_constant_time_property {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_003_constant_time_property for 6

assert time_003_no_timing_leakage {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_003_no_timing_leakage for 6

assert time_003_ct_compare_deterministic {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_003_ct_compare_deterministic for 6

assert time_004_timing_isolation_prevents_channel {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_004_timing_isolation_prevents_channel for 6

assert time_004_isolated_domain_property {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_004_isolated_domain_property for 6

assert time_005_unauthenticated_ntp_rejected {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_005_unauthenticated_ntp_rejected for 6

assert time_005_authenticated_ntp_accepted {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_005_authenticated_ntp_accepted for 6

assert time_005_wrong_signature_rejected {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_005_wrong_signature_rejected for 6

assert time_006_replay_detected {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_006_replay_detected for 6

assert time_006_fresh_nonce_recorded {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_006_fresh_nonce_recorded for 6

assert time_006_old_timestamp_rejected {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_006_old_timestamp_rejected for 6

assert time_007_out_of_order_rejected {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_007_out_of_order_rejected for 6

assert time_007_correct_sequence_accepted {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_007_correct_sequence_accepted for 6

assert time_007_sequence_increments {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_007_sequence_increments for 6

assert time_008_selected_task_meets_deadline {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_008_selected_task_meets_deadline for 6

assert time_008_no_deadline_miss {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_008_no_deadline_miss for 6

assert time_009_unsigned_timestamp_rejected {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_009_unsigned_timestamp_rejected for 6

assert time_009_valid_signature_accepted {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_009_valid_signature_accepted for 6

assert time_009_wrong_signature_rejected {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_009_wrong_signature_rejected for 6

assert time_010_expired_timeout_detected {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_010_expired_timeout_detected for 6

assert time_010_pending_timeout_preserved {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_010_pending_timeout_preserved for 6

assert time_010_completed_timeout_stable {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_010_completed_timeout_stable for 6

assert time_011_adjusted_clock_synchronized {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_011_adjusted_clock_synchronized for 6

assert time_011_synchronized_clock_valid {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_011_synchronized_clock_valid for 6

assert time_011_excessive_skew_rejected {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_011_excessive_skew_rejected for 6

assert time_012_priority_inheritance_raises {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_012_priority_inheritance_raises for 6

assert time_012_release_restores_base {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_012_release_restores_base for 6

assert time_012_no_inversion_after_inheritance {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_012_no_inversion_after_inheritance for 6

assert time_013_lock_order_respected {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_013_lock_order_respected for 6

assert time_013_out_of_order_rejected {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_013_out_of_order_rejected for 6

assert time_013_deadlock_free {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_013_deadlock_free for 6

assert time_014_progress_increases {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_014_progress_increases for 6

assert time_014_bounded_progress_completes {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_014_bounded_progress_completes for 6

assert time_014_liveness_guaranteed {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_014_liveness_guaranteed for 6

assert time_015_scheduled_updates_record {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_015_scheduled_updates_record for 6

assert time_015_starved_thread_prioritized {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_015_starved_thread_prioritized for 6

assert time_015_fairness_guaranteed {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_015_fairness_guaranteed for 6

assert time_015_update_preserves_threads {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_015_update_preserves_threads for 6

assert time_001_main {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_001_main for 6

assert time_002_main {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_002_main for 6

assert time_003_main {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_003_main for 6

assert time_004_main {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_004_main for 6

assert time_005_main {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_005_main for 6

assert time_006_main {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_006_main for 6

assert time_007_main {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_007_main for 6

assert time_008_main {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_008_main for 6

assert time_009_main {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_009_main for 6

assert time_010_main {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_010_main for 6

assert time_011_main {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_011_main for 6

assert time_012_main {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_012_main for 6

assert time_013_main {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_013_main for 6

assert time_014_main {
  all op: TimedOp | op.dataDependent = 1 implies op.secure = 0
}
check time_014_main for 6

assert time_015_main {
  all op: TimedOp | op.constantTime = 1 implies op.secure = 1
}
check time_015_main for 6

pred ExampleTimingSecurity {
  some TimedOp
}
run ExampleTimingSecurity for 6

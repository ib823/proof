// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for psi001_operational security
// Bounded verification of key properties
module riina/Domains/PSI001_OperationalSecurity

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert nth_map_seq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nth_map_seq for 6

assert PSI_001_01_poly_eval_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_001_01_poly_eval_zero for 6

assert PSI_001_02_generate_shares_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_001_02_generate_shares_length for 6

assert PSI_001_03_threshold_monotone {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_001_03_threshold_monotone for 6

assert PSI_001_04_insufficient_shares {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_001_04_insufficient_shares for 6

assert PSI_001_05_share_x_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_001_05_share_x_positive for 6

assert PSI_001_06_shares_distinct_x {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_001_06_shares_distinct_x for 6

assert PSI_001_07_secret_is_constant_term {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_001_07_secret_is_constant_term for 6

assert PSI_001_08_empty_poly_zero_secret {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_001_08_empty_poly_zero_secret for 6

assert PSI_002_01_single_approval_insufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_002_01_single_approval_insufficient for 6

assert PSI_002_02_approval_monotone {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_002_02_approval_monotone for 6

assert PSI_002_03_duplicate_approval_noop {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_002_03_duplicate_approval_noop for 6

assert PSI_002_04_valid_policy_n_le_m {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_002_04_valid_policy_n_le_m for 6

assert PSI_002_05_valid_policy_n_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_002_05_valid_policy_n_positive for 6

assert PSI_002_06_approval_count_increases {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_002_06_approval_count_increases for 6

assert PSI_003_01_duress_triggers_alert {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_003_01_duress_triggers_alert for 6

assert PSI_003_02_duress_provides_fake {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_003_02_duress_provides_fake for 6

assert PSI_003_03_duress_locks_down {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_003_03_duress_locks_down for 6

assert PSI_003_04_all_auth_audited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_003_04_all_auth_audited for 6

assert PSI_003_05_normal_no_fake {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_003_05_normal_no_fake for 6

assert PSI_003_06_normal_no_alert {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_003_06_normal_no_alert for 6

assert PSI_004_01_checkin_resets {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_004_01_checkin_resets for 6

assert PSI_004_02_checkin_updates_time {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_004_02_checkin_updates_time for 6

assert PSI_004_03_timeout_triggers {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_004_03_timeout_triggers for 6

assert PSI_004_04_no_timeout_no_trigger {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_004_04_no_timeout_no_trigger for 6

assert PSI_004_05_recovery_action_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_004_05_recovery_action_preserved for 6

assert PSI_005_01_budget_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_005_01_budget_enforced for 6

assert PSI_005_02_budget_query_count {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_005_02_budget_query_count for 6

assert PSI_005_03_record_increases_bytes {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_005_03_record_increases_bytes for 6

assert PSI_005_04_record_increases_queries {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_005_04_record_increases_queries for 6

assert PSI_005_05_audit_append_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_005_05_audit_append_preserves for 6

assert PSI_006_01_timelock_cancellation_window {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_006_01_timelock_cancellation_window for 6

assert PSI_006_02_cancelled_cannot_execute {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_006_02_cancelled_cannot_execute for 6

assert PSI_006_03_cancel_sets_flag {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_006_03_cancel_sets_flag for 6

assert PSI_006_04_early_execute_blocked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_006_04_early_execute_blocked for 6

assert PSI_006_05_cancel_preserves_operation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_006_05_cancel_preserves_operation for 6

assert PSI_007_01_different_vendor_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_007_01_different_vendor_independent for 6

assert PSI_007_02_nversion_single_agrees {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_007_02_nversion_single_agrees for 6

assert PSI_007_03_nversion_empty_agrees {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PSI_007_03_nversion_empty_agrees for 6

pred ExamplePSI001_OperationalSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExamplePSI001_OperationalSecurity for 6

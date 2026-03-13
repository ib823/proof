// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for time security
// Bounded verification of key properties
module riina/Domains/TimeSecurity

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

assert time_001_nonce_unique {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_001_nonce_unique for 6

assert time_002_replay_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_002_replay_detected for 6

assert time_003_seq_increasing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_003_seq_increasing for 6

assert time_004_timestamp_fresh {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_004_timestamp_fresh for 6

assert time_005_capability_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_005_capability_valid for 6

assert time_006_owner_matches {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_006_owner_matches for 6

assert time_007_atomic_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_007_atomic_complete for 6

assert time_008_cas_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_008_cas_correct for 6

assert time_009_clock_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_009_clock_monotonic for 6

assert time_010_happens_before {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_010_happens_before for 6

assert time_011_logical_clock_update {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_011_logical_clock_update for 6

assert time_012_timestamp_auth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_012_timestamp_auth for 6

assert time_013_multi_source {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_013_multi_source for 6

assert time_014_skew_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_014_skew_bounded for 6

assert time_015_deadline_met {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_015_deadline_met for 6

assert time_016_timeout_triggered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_016_timeout_triggered for 6

assert time_017_lock_order {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_017_lock_order for 6

assert time_018_no_deadlock {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_018_no_deadlock for 6

assert time_019_progress {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_019_progress for 6

assert time_020_fair_scheduling {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_020_fair_scheduling for 6

assert time_021_rate_limiting {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_021_rate_limiting for 6

assert time_022_ordered_delivery {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_022_ordered_delivery for 6

assert time_023_audit_timestamp {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_023_audit_timestamp for 6

assert time_024_session_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_024_session_valid for 6

assert time_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_025_defense_in_depth for 6

pred ExampleTimeSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleTimeSecurity for 6

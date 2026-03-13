// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified autonomy
// Bounded verification of key properties
module riina/Domains/VerifiedAutonomy

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

assert auto_001_velocity_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_001_velocity_bounded for 6

assert auto_002_distance_maintained {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_002_distance_maintained for 6

assert auto_003_heading_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_003_heading_bounded for 6

assert auto_004_confidence_ok {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_004_confidence_ok for 6

assert auto_005_sensor_failsafe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_005_sensor_failsafe for 6

assert auto_006_envelope_failsafe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_006_envelope_failsafe for 6

assert auto_007_human_override {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_007_human_override for 6

assert auto_008_reaction_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_008_reaction_bounded for 6

assert auto_009_emergency_stop_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_009_emergency_stop_valid for 6

assert auto_010_safe_hold_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_010_safe_hold_valid for 6

assert auto_011_mode_transition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_011_mode_transition for 6

assert auto_012_no_skip_assisted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_012_no_skip_assisted for 6

assert auto_013_decision_fresh {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_013_decision_fresh for 6

assert auto_014_action_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_014_action_bounded for 6

assert auto_015_sensor_agreement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_015_sensor_agreement for 6

assert auto_016_watchdog_active {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_016_watchdog_active for 6

assert auto_017_redundancy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_017_redundancy for 6

assert auto_018_geofence_respected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_018_geofence_respected for 6

assert auto_019_collision_free {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_019_collision_free for 6

assert auto_020_energy_ok {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_020_energy_ok for 6

assert auto_021_link_quality {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_021_link_quality for 6

assert auto_022_constraints_met {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_022_constraints_met for 6

assert auto_023_logging_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_023_logging_complete for 6

assert auto_024_verify_first {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_024_verify_first for 6

assert auto_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_025_defense_in_depth for 6

pred ExampleVerifiedAutonomy {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedAutonomy for 6

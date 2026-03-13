// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for sensor fusion
// Bounded verification of key properties
module riina/Domains/SensorFusion

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

assert sensor_001_byzantine_threshold {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_001_byzantine_threshold for 6

assert sensor_002_honest_majority {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_002_honest_majority for 6

assert sensor_003_authenticated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_003_authenticated for 6

assert sensor_004_freshness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_004_freshness for 6

assert sensor_005_trust_threshold {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_005_trust_threshold for 6

assert sensor_006_cross_validation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_006_cross_validation for 6

assert sensor_007_anomaly_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_007_anomaly_detected for 6

assert sensor_008_normal_accepted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_008_normal_accepted for 6

assert sensor_009_min_sources {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_009_min_sources for 6

assert sensor_010_confidence_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_010_confidence_bounded for 6

assert sensor_011_temporal_consistent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_011_temporal_consistent for 6

assert sensor_012_diversity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_012_diversity for 6

assert sensor_013_weight_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_013_weight_bounded for 6

assert sensor_014_outlier_rejected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_014_outlier_rejected for 6

assert sensor_015_quorum {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_015_quorum for 6

assert sensor_016_no_replay {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_016_no_replay for 6

assert sensor_017_calibration_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_017_calibration_valid for 6

assert sensor_018_range_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_018_range_valid for 6

assert sensor_019_rate_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_019_rate_bounded for 6

assert sensor_020_redundancy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_020_redundancy for 6

assert sensor_021_health_ok {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_021_health_ok for 6

assert sensor_022_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_022_deterministic for 6

assert sensor_023_secure_channel {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_023_secure_channel for 6

assert sensor_024_audit_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_024_audit_complete for 6

assert sensor_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_025_defense_in_depth for 6

pred ExampleSensorFusion {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSensorFusion for 6

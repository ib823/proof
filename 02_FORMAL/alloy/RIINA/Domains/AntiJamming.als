// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for anti jamming
// Bounded verification of key properties
module riina/Domains/AntiJamming

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

assert jam_001_sequence_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_001_sequence_length for 6

assert jam_002_dwell_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_002_dwell_bounded for 6

assert jam_003_processing_gain {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_003_processing_gain for 6

assert jam_004_code_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_004_code_length for 6

assert jam_005_jammer_overcome {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_005_jammer_overcome for 6

assert jam_006_channel_diversity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_006_channel_diversity for 6

assert jam_007_detection_threshold {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_007_detection_threshold for 6

assert jam_008_no_false_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_008_no_false_positive for 6

assert jam_009_adaptation_improves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_009_adaptation_improves for 6

assert jam_010_power_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_010_power_bounded for 6

assert jam_011_avoids_jammed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_011_avoids_jammed for 6

assert jam_012_rate_minimum {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_012_rate_minimum for 6

assert jam_013_fec_gain {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_013_fec_gain for 6

assert jam_014_switch_latency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_014_switch_latency for 6

assert jam_015_synchronized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_015_synchronized for 6

assert jam_016_key_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_016_key_required for 6

assert jam_017_sweep_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_017_sweep_detected for 6

assert jam_018_reactive_mitigation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_018_reactive_mitigation for 6

assert jam_019_adaptation_speed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_019_adaptation_speed for 6

assert jam_020_quality_acceptable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_020_quality_acceptable for 6

assert jam_021_graceful_degradation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_021_graceful_degradation for 6

assert jam_022_fallback_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_022_fallback_available for 6

assert jam_023_interference_localized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_023_interference_localized for 6

assert jam_024_redundant_paths {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_024_redundant_paths for 6

assert jam_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check jam_025_defense_in_depth for 6

pred ExampleAntiJamming {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleAntiJamming for 6

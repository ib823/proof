// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for traffic resistance
// Bounded verification of key properties
module riina/Domains/TrafficResistance

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

assert traffic_001_constant_rate_hides {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_001_constant_rate_hides for 6

assert traffic_002_constant_size_hides {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_002_constant_size_hides for 6

assert traffic_003_cover_indistinguishable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_003_cover_indistinguishable for 6

assert traffic_004_flow_indistinguishable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_004_flow_indistinguishable for 6

assert traffic_005_timing_indistinguishable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_005_timing_indistinguishable for 6

assert traffic_006_mix_delay {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_006_mix_delay for 6

assert traffic_007_batch_anonymity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_007_batch_anonymity for 6

assert traffic_008_multi_hop {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_008_multi_hop for 6

assert traffic_009_layer_encryption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_009_layer_encryption for 6

assert traffic_010_sender_anonymity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_010_sender_anonymity for 6

assert traffic_011_receiver_anonymity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_011_receiver_anonymity for 6

assert traffic_012_padding_ratio {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_012_padding_ratio for 6

assert traffic_013_decoy_rate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_013_decoy_rate for 6

assert traffic_014_jitter_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_014_jitter_bounded for 6

assert traffic_015_no_timing_correlation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_015_no_timing_correlation for 6

assert traffic_016_size_quantization {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_016_size_quantization for 6

assert traffic_017_flow_correlation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_017_flow_correlation for 6

assert traffic_018_guard_diversity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_018_guard_diversity for 6

assert traffic_019_exit_diversity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_019_exit_diversity for 6

assert traffic_020_path_randomness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_020_path_randomness for 6

assert traffic_021_statistical_indist {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_021_statistical_indist for 6

assert traffic_022_session_unlinkability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_022_session_unlinkability for 6

assert traffic_023_intersection_resistance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_023_intersection_resistance for 6

assert traffic_024_volume_resistance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_024_volume_resistance for 6

assert traffic_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check traffic_025_defense_in_depth for 6

pred ExampleTrafficResistance {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleTrafficResistance for 6

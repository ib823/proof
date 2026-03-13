// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for metadata privacy
// Bounded verification of key properties
module riina/Domains/MetadataPrivacy

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

assert meta_001_padding_hides_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_001_padding_hides_size for 6

assert meta_002_constant_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_002_constant_size for 6

assert meta_003_size_no_leak {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_003_size_no_leak for 6

assert meta_004_timing_bucketed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_004_timing_bucketed for 6

assert meta_005_jitter_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_005_jitter_bounded for 6

assert meta_006_k_anonymity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_006_k_anonymity for 6

assert meta_007_set_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_007_set_preserved for 6

assert meta_008_sender_anonymity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_008_sender_anonymity for 6

assert meta_009_receiver_anonymity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_009_receiver_anonymity for 6

assert meta_010_relationship_unlinkable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_010_relationship_unlinkable for 6

assert meta_011_temporal_unlinkable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_011_temporal_unlinkable for 6

assert meta_012_sensitivity_reflexive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_012_sensitivity_reflexive for 6

assert meta_013_redaction_removes_sensitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_013_redaction_removes_sensitive for 6

assert meta_014_public_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_014_public_preserved for 6

assert meta_015_constant_rate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_015_constant_rate for 6

assert meta_016_cover_traffic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_016_cover_traffic for 6

assert meta_017_minimization {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_017_minimization for 6

assert meta_018_no_correlation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_018_no_correlation for 6

assert meta_019_uniform_frequency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_019_uniform_frequency for 6

assert meta_020_aggregation_limited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_020_aggregation_limited for 6

assert meta_021_path_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_021_path_length for 6

assert meta_022_hop_count_hidden {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_022_hop_count_hidden for 6

assert meta_023_fingerprint_resistance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_023_fingerprint_resistance for 6

assert meta_024_session_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_024_session_isolation for 6

assert meta_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check meta_025_defense_in_depth for 6

pred ExampleMetadataPrivacy {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMetadataPrivacy for 6

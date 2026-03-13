// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for anonymous comm
// Bounded verification of key properties
module riina/Domains/AnonymousComm

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

assert anon_001_sender_anonymity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_001_sender_anonymity for 6

assert anon_002_receiver_anonymity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_002_receiver_anonymity for 6

assert anon_003_layers_match_path {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_003_layers_match_path for 6

assert anon_004_min_path_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_004_min_path_length for 6

assert anon_005_entry_guard {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_005_entry_guard for 6

assert anon_006_exit_diversity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_006_exit_diversity for 6

assert anon_007_layer_order {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_007_layer_order for 6

assert anon_008_unique_keys {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_008_unique_keys for 6

assert anon_009_nonce_unique {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_009_nonce_unique for 6

assert anon_010_unlinkability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_010_unlinkability for 6

assert anon_011_no_sender_in_obs {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_011_no_sender_in_obs for 6

assert anon_012_no_receiver_in_obs {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_012_no_receiver_in_obs for 6

assert anon_013_compromise_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_013_compromise_bounded for 6

assert anon_014_path_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_014_path_safe for 6

assert anon_015_pseudonym_rotation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_015_pseudonym_rotation for 6

assert anon_016_circuit_lifetime {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_016_circuit_lifetime for 6

assert anon_017_constant_traffic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_017_constant_traffic for 6

assert anon_018_uniform_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_018_uniform_size for 6

assert anon_019_forward_secrecy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_019_forward_secrecy for 6

assert anon_020_intersection_resistance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_020_intersection_resistance for 6

assert anon_021_rendezvous_hidden {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_021_rendezvous_hidden for 6

assert anon_022_bidirectional {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_022_bidirectional for 6

assert anon_023_no_spof {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_023_no_spof for 6

assert anon_024_replay_prevention {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_024_replay_prevention for 6

assert anon_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anon_025_defense_in_depth for 6

pred ExampleAnonymousComm {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleAnonymousComm for 6

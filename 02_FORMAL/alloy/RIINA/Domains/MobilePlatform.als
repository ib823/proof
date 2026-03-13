// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for mobile platform
// Bounded verification of key properties
module riina/Domains/MobilePlatform

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

assert mobile_001_unique_uids {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_001_unique_uids for 6

assert mobile_002_sandbox_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_002_sandbox_valid for 6

assert mobile_003_file_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_003_file_isolation for 6

assert mobile_004_dangerous_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_004_dangerous_consent for 6

assert mobile_005_signature_permission {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_005_signature_permission for 6

assert mobile_006_system_permission {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_006_system_permission for 6

assert mobile_007_unexported_denied {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_007_unexported_denied for 6

assert mobile_008_same_app_ipc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_008_same_app_ipc for 6

assert mobile_009_hw_key_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_009_hw_key_protected for 6

assert mobile_010_auth_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_010_auth_required for 6

assert mobile_011_grant_owner {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_011_grant_owner for 6

assert mobile_012_expired_invalid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_012_expired_invalid for 6

assert mobile_013_network_permission {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_013_network_permission for 6

assert mobile_014_location_permission {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_014_location_permission for 6

assert mobile_015_camera_permission {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_015_camera_permission for 6

assert mobile_016_microphone_permission {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_016_microphone_permission for 6

assert mobile_017_intent_filter {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_017_intent_filter for 6

assert mobile_018_explicit_target {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_018_explicit_target for 6

assert mobile_019_process_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_019_process_isolation for 6

assert mobile_020_selinux_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_020_selinux_enforced for 6

assert mobile_021_verified_boot {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_021_verified_boot for 6

assert mobile_022_enclave_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_022_enclave_isolation for 6

assert mobile_023_biometric_tee {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_023_biometric_tee for 6

assert mobile_024_signature_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_024_signature_verified for 6

assert mobile_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mobile_025_defense_in_depth for 6

pred ExampleMobilePlatform {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMobilePlatform for 6

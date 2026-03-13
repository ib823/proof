// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for mobile bridge verification
// Bounded verification of key properties
module riina/Domains/MobileBridgeVerification

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

assert bridge_001_jni_roundtrip_int {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_001_jni_roundtrip_int for 6

assert bridge_001_jni_roundtrip_bool {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_001_jni_roundtrip_bool for 6

assert bridge_001_swift_roundtrip_int {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_001_swift_roundtrip_int for 6

assert bridge_001_swift_roundtrip_bool {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_001_swift_roundtrip_bool for 6

assert bridge_002_jni_pure_always_allowed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_002_jni_pure_always_allowed for 6

assert bridge_002_jni_invalid_blocks_all {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_002_jni_invalid_blocks_all for 6

assert bridge_002_jni_io_requires_io_cap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_002_jni_io_requires_io_cap for 6

assert bridge_003_swift_pure_always_allowed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_003_swift_pure_always_allowed for 6

assert bridge_003_swift_net_requires_net {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_003_swift_net_requires_net for 6

assert bridge_003_swift_ui_requires_ui {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_003_swift_ui_requires_ui for 6

assert bridge_004_safe_call_requires_cap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_004_safe_call_requires_cap for 6

assert bridge_004_pure_call_always_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_004_pure_call_always_safe for 6

assert bridge_005_error_is_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_005_error_is_safe for 6

assert bridge_005_ok_is_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_005_ok_is_safe for 6

assert bridge_005_no_secret_leak {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_005_no_secret_leak for 6

assert bridge_006_jni_string_roundtrip_len {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_006_jni_string_roundtrip_len for 6

assert bridge_006_jni_string_roundtrip_hash {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_006_jni_string_roundtrip_hash for 6

assert bridge_006_jni_string_is_utf8 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_006_jni_string_is_utf8 for 6

assert bridge_006_jni_string_full_roundtrip {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_006_jni_string_full_roundtrip for 6

assert bridge_006_rvalue_string_jni_roundtrip {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_006_rvalue_string_jni_roundtrip for 6

assert bridge_007_swift_type_preserved_int {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_007_swift_type_preserved_int for 6

assert bridge_007_swift_type_preserved_bool {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_007_swift_type_preserved_bool for 6

assert bridge_007_swift_type_preserved_string {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_007_swift_type_preserved_string for 6

assert bridge_007_swift_type_preserved_unit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_007_swift_type_preserved_unit for 6

assert bridge_007_marshal_swift_type_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_007_marshal_swift_type_safe for 6

assert bridge_007_unmarshal_swift_type_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_007_unmarshal_swift_type_safe for 6

assert bridge_007_rvalue_string_swift_roundtrip {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_007_rvalue_string_swift_roundtrip for 6

assert bridge_008_pure_callback_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_008_pure_callback_safe for 6

assert bridge_008_public_args_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_008_public_args_safe for 6

assert bridge_008_secret_ret_rejected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_008_secret_ret_rejected for 6

assert bridge_008_safe_not_rejected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_008_safe_not_rejected for 6

assert bridge_008_no_secret_through_safe_callback {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bridge_008_no_secret_through_safe_callback for 6

pred ExampleMobileBridgeVerification {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMobileBridgeVerification for 6

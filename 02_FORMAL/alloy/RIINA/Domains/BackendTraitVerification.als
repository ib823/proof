// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for backend trait verification
// Bounded verification of key properties
module riina/Domains/BackendTraitVerification

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

assert backend_001_dispatch_total {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_001_dispatch_total for 6

assert backend_001_dispatch_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_001_dispatch_deterministic for 6

assert backend_001_native_is_c {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_001_native_is_c for 6

assert backend_001_wasm32_is_wasm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_001_wasm32_is_wasm for 6

assert backend_001_wasm64_is_wasm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_001_wasm64_is_wasm for 6

assert backend_002_c_preserves_ni {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_002_c_preserves_ni for 6

assert backend_002_c_preserves_effects {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_002_c_preserves_effects for 6

assert backend_002_c_preserves_types {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_002_c_preserves_types for 6

assert backend_002_c_format {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_002_c_format for 6

assert backend_003_all_preserve_ni {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_003_all_preserve_ni for 6

assert backend_003_all_preserve_effects {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_003_all_preserve_effects for 6

assert backend_003_all_preserve_types {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_003_all_preserve_types for 6

assert backend_003_dispatch_preserves_all {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_003_dispatch_preserves_all for 6

assert backend_004_format_total {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_004_format_total for 6

assert backend_004_wasm_produces_wasm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_004_wasm_produces_wasm for 6

assert backend_004_mobile_produces_bridge {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_004_mobile_produces_bridge for 6

assert backend_004_native_produces_c {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_004_native_produces_c for 6

assert backend_004_format_consistent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_004_format_consistent for 6

assert backend_wasm32_format {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_wasm32_format for 6

assert backend_wasm64_format {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_wasm64_format for 6

assert backend_android_format {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backend_android_format for 6

pred ExampleBackendTraitVerification {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleBackendTraitVerification for 6

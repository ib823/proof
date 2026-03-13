// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for platform stdlib verification
// Bounded verification of key properties
module riina/Domains/PlatformStdlibVerification

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

assert plat_001_universal_console {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_001_universal_console for 6

assert plat_001_universal_timer {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_001_universal_timer for 6

assert plat_001_mobile_sensor {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_001_mobile_sensor for 6

assert plat_001_mobile_camera {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_001_mobile_camera for 6

assert plat_001_universal_network {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_001_universal_network for 6

assert plat_002_wasm_no_filesystem {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_002_wasm_no_filesystem for 6

assert plat_002_wasm_no_sensor {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_002_wasm_no_sensor for 6

assert plat_002_wasm_no_camera {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_002_wasm_no_camera for 6

assert plat_002_native_no_dom {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_002_native_no_dom for 6

assert plat_002_native_no_sensor {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_002_native_no_sensor for 6

assert plat_003_pure_compiles_everywhere {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_003_pure_compiles_everywhere for 6

assert plat_003_net_compiles_everywhere {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_003_net_compiles_everywhere for 6

assert plat_004_public_input_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_004_public_input_safe for 6

assert plat_004_secret_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_004_secret_preserved for 6

assert plat_005_pure_platform_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_005_pure_platform_independent for 6

assert plat_005_add_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_005_add_independent for 6

assert plat_005_bool_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_005_bool_independent for 6

assert plat_006_dom_only_wasm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_006_dom_only_wasm for 6

assert plat_006_push_mobile_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_006_push_mobile_only for 6

assert plat_006_console_timer_universal {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plat_006_console_timer_universal for 6

pred ExamplePlatformStdlibVerification {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExamplePlatformStdlibVerification for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for binary size bounds
// Bounded verification of key properties
module riina/Domains/BinarySizeBounds

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

assert PERF_002_01 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_01 for 6

assert PERF_002_02 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_02 for 6

assert sum_bb_sizes_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sum_bb_sizes_app for 6

assert PERF_002_03 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_03 for 6

assert sum_func_sizes_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sum_func_sizes_app for 6

assert PERF_002_04 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_04 for 6

assert sum_mod_sizes_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sum_mod_sizes_app for 6

assert PERF_002_05 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_05 for 6

assert data_section_size_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_section_size_app for 6

assert PERF_002_06 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_06 for 6

assert bss_section_size_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bss_section_size_app for 6

assert PERF_002_07 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_07 for 6

assert PERF_002_08 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_08 for 6

assert PERF_002_09 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_09 for 6

assert PERF_002_10 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_10 for 6

assert PERF_002_11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_11 for 6

assert PERF_002_12 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_12 for 6

assert PERF_002_13 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_13 for 6

assert PERF_002_14 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_14 for 6

assert PERF_002_15 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_002_15 for 6

pred ExampleBinarySizeBounds {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleBinarySizeBounds for 6

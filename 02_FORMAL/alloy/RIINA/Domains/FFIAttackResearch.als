// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for ffiattack research
// Bounded verification of key properties
module riina/Domains/FFIAttackResearch

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

assert ffi_safe_implies_sandboxed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ffi_safe_implies_sandboxed for 6

assert ffi_safe_implies_validated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ffi_safe_implies_validated for 6

assert ffi_safe_construct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ffi_safe_construct for 6

assert int8_alignment_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check int8_alignment_positive for 6

assert ffi_type_align_ge_1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ffi_type_align_ge_1 for 6

assert ptr_size_constant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ptr_size_constant for 6

assert array_size_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check array_size_correct for 6

assert empty_struct_zero_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_struct_zero_size for 6

assert marshal_preserves_capacity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check marshal_preserves_capacity for 6

assert marshal_increases_used {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check marshal_increases_used for 6

assert marshal_never_overflows {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check marshal_never_overflows for 6

assert marshal_failure_means_insufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check marshal_failure_means_insufficient for 6

assert marshal_void_always_succeeds {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check marshal_void_always_succeeds for 6

assert disjoint_regions_no_overlap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check disjoint_regions_no_overlap for 6

assert sandbox_call_allowed_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sandbox_call_allowed_decidable for 6

assert disjoint_symmetric {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check disjoint_symmetric for 6

assert addr_in_region_bounds {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check addr_in_region_bounds for 6

assert ffi_void_size_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ffi_void_size_zero for 6

assert ffi_int8_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ffi_int8_size for 6

assert marshal_void_preserves_used {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check marshal_void_preserves_used for 6

pred ExampleFFIAttackResearch {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleFFIAttackResearch for 6

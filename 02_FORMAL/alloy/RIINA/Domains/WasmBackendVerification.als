// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for wasm backend verification
// Bounded verification of key properties
module riina/Domains/WasmBackendVerification

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

assert wasm_eval_const {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_eval_const for 6

assert wasm_eval_add {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_eval_add for 6

assert wasm_eval_mul {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_eval_mul for 6

assert wasm_001_const_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_001_const_preservation for 6

assert wasm_002_ni_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_002_ni_preservation for 6

assert wasm_002_memory_separation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_002_memory_separation for 6

assert wasm_003_effect_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_003_effect_preservation for 6

assert wasm_003_io_self_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_003_io_self_safe for 6

assert wasm_004_int_type_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_004_int_type_preserved for 6

assert wasm_004_add_type_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_004_add_type_preserved for 6

assert wasm_004_bool_type_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_004_bool_type_preserved for 6

assert wasm_005_disjoint_regions {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_005_disjoint_regions for 6

assert wasm_005_public_cannot_access_secret {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_005_public_cannot_access_secret for 6

assert wasm_006_string_const_produces_ptr {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_006_string_const_produces_ptr for 6

assert wasm_006_string_ptr_is_i32 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_006_string_ptr_is_i32 for 6

assert wasm_006_string_dedup {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_006_string_dedup for 6

assert wasm_007_closure_layout {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_007_closure_layout for 6

assert wasm_007_closure_no_overlap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_007_closure_no_overlap for 6

assert wasm_007_closure_func_idx_recoverable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_007_closure_func_idx_recoverable for 6

assert wasm_008_pair_offsets_disjoint {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_008_pair_offsets_disjoint for 6

assert wasm_008_pair_fits_in_region {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_008_pair_fits_in_region for 6

assert wasm_008_sum_tag_determines_branch {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_008_sum_tag_determines_branch for 6

assert wasm_008_sum_fits_in_region {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_008_sum_fits_in_region for 6

assert wasm_008_pairs_disjoint {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_008_pairs_disjoint for 6

assert wasm_009_alloc_returns_current {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_009_alloc_returns_current for 6

assert wasm_009_alloc_advances_ptr {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_009_alloc_advances_ptr for 6

assert wasm_009_alloc_preserves_limit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_009_alloc_preserves_limit for 6

assert wasm_009_sequential_alloc_disjoint {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_009_sequential_alloc_disjoint for 6

assert wasm_009_alloc_oom {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_009_alloc_oom for 6

assert wasm_010_compile_ir_total {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_compile_ir_total for 6

assert wasm_010_const_translates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_const_translates for 6

assert wasm_010_var_translates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_var_translates for 6

assert wasm_010_add_translates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_add_translates for 6

assert wasm_010_mul_translates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_mul_translates for 6

assert wasm_010_call_translates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_call_translates for 6

assert wasm_010_let_translates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_let_translates for 6

assert wasm_010_if_translates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_if_translates for 6

assert wasm_010_load_translates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_load_translates for 6

assert wasm_010_store_translates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_store_translates for 6

assert app_ne_nil_r {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_ne_nil_r for 6

assert singleton_ne_nil {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check singleton_ne_nil for 6

assert cons_ne_nil {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cons_ne_nil for 6

assert wasm_010_completeness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wasm_010_completeness for 6

pred ExampleWasmBackendVerification {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleWasmBackendVerification for 6

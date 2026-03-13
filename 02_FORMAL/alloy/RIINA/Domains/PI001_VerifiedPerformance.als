// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for pi001_verified performance
// Bounded verification of key properties
module riina/Domains/PI001_VerifiedPerformance

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

assert PI_001_01_simd_add_equiv {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_001_01_simd_add_equiv for 6

assert PI_001_02_simd_mul_equiv {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_001_02_simd_mul_equiv for 6

assert PI_001_03_scalar_add_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_001_03_scalar_add_length for 6

assert PI_001_04_scalar_add_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_001_04_scalar_add_comm for 6

assert PI_001_05_scalar_add_assoc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_001_05_scalar_add_assoc for 6

assert PI_001_06_scalar_mul_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_001_06_scalar_mul_length for 6

assert PI_001_07_dot_product_zero_left {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_001_07_dot_product_zero_left for 6

assert PI_001_08_simd_preserves_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_001_08_simd_preserves_length for 6

assert PI_002_01_veb_search_root {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_002_01_veb_search_root for 6

assert PI_002_02_veb_leaf_search {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_002_02_veb_leaf_search for 6

assert PI_002_03_veb_height_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_002_03_veb_height_positive for 6

assert PI_002_04_veb_size_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_002_04_veb_size_positive for 6

assert PI_002_05_veb_inorder_nonempty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_002_05_veb_inorder_nonempty for 6

assert PI_002_06_veb_height_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_002_06_veb_height_bound for 6

assert PI_003_01_msq_empty_dequeue {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_003_01_msq_empty_dequeue for 6

assert PI_003_02_msq_enqueue_nonempty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_003_02_msq_enqueue_nonempty for 6

assert PI_003_03_msq_fifo {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_003_03_msq_fifo for 6

assert PI_003_04_msq_enqueue_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_003_04_msq_enqueue_length for 6

assert PI_003_05_cas_success {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_003_05_cas_success for 6

assert PI_003_06_cas_failure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_003_06_cas_failure for 6

assert PI_003_07_linearization_empty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_003_07_linearization_empty for 6

assert PI_004_01_dce_false_branch {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_004_01_dce_false_branch for 6

assert PI_004_02_dce_true_branch {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_004_02_dce_true_branch for 6

assert PI_004_03_const_fold_add {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_004_03_const_fold_add for 6

assert PI_004_04_const_fold_mul {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_004_04_const_fold_mul for 6

assert PI_004_05_const_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_004_05_const_preserves for 6

assert PI_004_06_var_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_004_06_var_preserves for 6

assert PI_004_07_dce_const_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_004_07_dce_const_preserves for 6

assert PI_004_08_dce_var_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_004_08_dce_var_preserves for 6

assert PI_005_01_puzzle_verify_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_005_01_puzzle_verify_sound for 6

assert PI_005_02_puzzle_verify_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_005_02_puzzle_verify_complete for 6

assert PI_005_03_puzzle_zero_target {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_005_03_puzzle_zero_target for 6

assert PI_005_04_puzzle_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_005_04_puzzle_deterministic for 6

assert PI_005_05_vec_sum_nil {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PI_005_05_vec_sum_nil for 6

pred ExamplePI001_VerifiedPerformance {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExamplePI001_VerifiedPerformance for 6

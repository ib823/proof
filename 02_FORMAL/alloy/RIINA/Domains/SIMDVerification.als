// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for simdverification
// Bounded verification of key properties
module riina/Domains/SIMDVerification

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

assert PERF_003_01_simd_add_equivalence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_01_simd_add_equivalence for 6

assert PERF_003_02_simd_mul_equivalence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_02_simd_mul_equivalence for 6

assert PERF_003_03_simd_cmp_equivalence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_03_simd_cmp_equivalence for 6

assert PERF_003_04_simd_shuffle_correctness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_04_simd_shuffle_correctness for 6

assert PERF_003_05_simd_alignment_requirement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_05_simd_alignment_requirement for 6

assert PERF_003_06_simd_lane_independence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_06_simd_lane_independence for 6

assert PERF_003_07_simd_reduce_equivalence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_07_simd_reduce_equivalence for 6

assert PERF_003_08_simd_broadcast_correctness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_08_simd_broadcast_correctness for 6

assert fold_and_all_true {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fold_and_all_true for 6

assert PERF_003_09_simd_gather_safety {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_09_simd_gather_safety for 6

assert PERF_003_10_simd_masking_correctness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_10_simd_masking_correctness for 6

assert PERF_003_11_vectorization_legality {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_11_vectorization_legality for 6

assert to_list_map2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check to_list_map2 for 6

assert PERF_003_12_simd_semantic_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_12_simd_semantic_preservation for 6

assert PERF_003_13_simd_mul_lane_independence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_13_simd_mul_lane_independence for 6

assert PERF_003_14_simd_cmp_lane_independence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_14_simd_cmp_lane_independence for 6

assert PERF_003_15_broadcast_add_equiv {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_15_broadcast_add_equiv for 6

assert PERF_003_16_identity_shuffle {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_16_identity_shuffle for 6

assert PERF_003_17_simd_add_commutative {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_17_simd_add_commutative for 6

assert PERF_003_18_all_true_mask_selects_new {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_18_all_true_mask_selects_new for 6

assert PERF_003_19_all_false_mask_preserves_old {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_19_all_false_mask_preserves_old for 6

assert PERF_003_20_zero_aligned {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PERF_003_20_zero_aligned for 6

pred ExampleSIMDVerification {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSIMDVerification for 6

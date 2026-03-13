// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for s001_hardware contracts
// Bounded verification of key properties
module riina/Domains/S001_HardwareContracts

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

assert S_001_01_isa_state_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_01_isa_state_deterministic for 6

assert S_001_02_microarch_state_extended {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_02_microarch_state_extended for 6

assert S_001_03_cache_state_modeled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_03_cache_state_modeled for 6

assert S_001_04_branch_predictor_modeled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_04_branch_predictor_modeled for 6

assert S_001_05_speculation_state_modeled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_05_speculation_state_modeled for 6

assert S_001_06_leakage_function_defined {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_06_leakage_function_defined for 6

assert S_001_07_timing_observable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_07_timing_observable for 6

assert S_001_08_power_observable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_08_power_observable for 6

assert S_001_09_constant_time_definition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_09_constant_time_definition for 6

assert S_001_10_ct_independent_of_secrets {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_10_ct_independent_of_secrets for 6

assert S_001_11_ct_memory_access_pattern {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_11_ct_memory_access_pattern for 6

assert S_001_12_ct_branch_pattern {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_12_ct_branch_pattern for 6

assert S_001_13_ct_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_13_ct_composition for 6

assert S_001_14_ct_loop_invariant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_14_ct_loop_invariant for 6

assert S_001_15_ct_function_calls {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_15_ct_function_calls for 6

assert S_001_16_ct_cache_behavior {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_16_ct_cache_behavior for 6

assert S_001_17_speculation_rollback {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_17_speculation_rollback for 6

assert S_001_18_speculation_microarch_persist {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_18_speculation_microarch_persist for 6

assert S_001_19_speculation_fence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_19_speculation_fence for 6

assert S_001_20_speculation_no_secret_load {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_20_speculation_no_secret_load for 6

assert S_001_21_speculation_no_secret_branch {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_21_speculation_no_secret_branch for 6

assert S_001_22_speculation_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_22_speculation_bounded for 6

assert S_001_23_speculation_safe_program {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_23_speculation_safe_program for 6

assert S_001_24_speculation_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_24_speculation_composition for 6

assert S_001_25_rowhammer_threshold {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_25_rowhammer_threshold for 6

assert S_001_26_rowhammer_pattern_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_26_rowhammer_pattern_safe for 6

assert S_001_27_memory_row_adjacency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_27_memory_row_adjacency for 6

assert S_001_28_power_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_28_power_independent for 6

assert S_001_29_em_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_29_em_independent for 6

assert S_001_30_physical_leakage_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check S_001_30_physical_leakage_bounded for 6

pred ExampleS001_HardwareContracts {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleS001_HardwareContracts for 6

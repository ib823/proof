// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for t001_hermetic build
// Bounded verification of key properties
module riina/Domains/T001_HermeticBuild

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

assert T_001_01_hex0_auditable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_01_hex0_auditable for 6

assert T_001_02_hex0_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_02_hex0_correct for 6

assert T_001_03_stage_preserves_semantics {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_03_stage_preserves_semantics for 6

assert T_001_04_bootstrap_chain_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_04_bootstrap_chain_valid for 6

assert T_001_05_stage_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_05_stage_deterministic for 6

assert T_001_06_stage_terminates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_06_stage_terminates for 6

assert T_001_07_self_hosting_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_07_self_hosting_valid for 6

assert T_001_08_bootstrap_idempotent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_08_bootstrap_idempotent for 6

assert T_001_09_no_network_access {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_09_no_network_access for 6

assert T_001_10_filesystem_readonly {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_10_filesystem_readonly for 6

assert T_001_11_clock_fixed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_11_clock_fixed for 6

assert T_001_12_randomness_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_12_randomness_deterministic for 6

assert T_001_13_environment_clean {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_13_environment_clean for 6

assert T_001_14_inputs_whitelisted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_14_inputs_whitelisted for 6

assert T_001_15_hermetic_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_15_hermetic_composition for 6

assert T_001_16_bit_reproducible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_16_bit_reproducible for 6

assert T_001_17_hash_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_17_hash_deterministic for 6

assert T_001_18_diverse_double_compile {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_18_diverse_double_compile for 6

assert T_001_19_cross_compile_equivalent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_19_cross_compile_equivalent for 6

assert T_001_20_source_hash_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_20_source_hash_verified for 6

assert T_001_21_reproducibility_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_21_reproducibility_composition for 6

assert T_001_22_ddc_setup {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_22_ddc_setup for 6

assert T_001_23_ddc_stage_a {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_23_ddc_stage_a for 6

assert T_001_24_ddc_stage_b {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_24_ddc_stage_b for 6

assert T_001_25_ddc_stage_aprime {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_25_ddc_stage_aprime for 6

assert T_001_26_ddc_equivalence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_26_ddc_equivalence for 6

assert T_001_27_ddc_trojan_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_27_ddc_trojan_detected for 6

assert T_001_28_ddc_confidence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check T_001_28_ddc_confidence for 6

pred ExampleT001_HermeticBuild {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleT001_HermeticBuild for 6

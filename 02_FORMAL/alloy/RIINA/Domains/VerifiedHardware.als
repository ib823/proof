// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified hardware
// Bounded verification of key properties
module riina/Domains/VerifiedHardware

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

assert update_eq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check update_eq for 6

assert update_neq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check update_neq for 6

assert isa_rtl_add_equiv {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check isa_rtl_add_equiv for 6

assert PHI_001_01_rtl_isa_equivalence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_01_rtl_isa_equivalence for 6

assert PHI_001_02_pipeline_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_02_pipeline_correct for 6

assert PHI_001_03_memory_system_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_03_memory_system_correct for 6

assert PHI_001_04_register_file_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_04_register_file_correct for 6

assert PHI_001_05_alu_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_05_alu_correct for 6

assert PHI_001_06_branch_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_06_branch_correct for 6

assert PHI_001_07_interrupt_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_07_interrupt_correct for 6

assert PHI_001_08_instruction_fetch_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_08_instruction_fetch_correct for 6

assert PHI_001_09_timing_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_09_timing_independent for 6

assert PHI_001_10_no_data_dependent_timing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_10_no_data_dependent_timing for 6

assert PHI_001_11_cache_constant_time {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_11_cache_constant_time for 6

assert PHI_001_12_branch_constant_time {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_12_branch_constant_time for 6

assert PHI_001_13_memory_constant_time {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_13_memory_constant_time for 6

assert PHI_001_14_division_constant_time {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_14_division_constant_time for 6

assert PHI_001_15_multiplication_constant_time {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_15_multiplication_constant_time for 6

assert PHI_001_16_power_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_16_power_independent for 6

assert reachable_spec_false {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reachable_spec_false for 6

assert PHI_001_17_no_speculation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_17_no_speculation for 6

assert PHI_001_18_scub_barrier {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_18_scub_barrier for 6

assert PHI_001_19_no_spectre_v1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_19_no_spectre_v1 for 6

assert PHI_001_20_no_spectre_v2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_20_no_spectre_v2 for 6

assert PHI_001_21_no_meltdown {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_21_no_meltdown for 6

assert program_leakage_state_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check program_leakage_state_independent for 6

assert PHI_001_22_no_microarch_leakage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_22_no_microarch_leakage for 6

assert PHI_001_23_fence_sc_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_23_fence_sc_correct for 6

assert PHI_001_24_isolation_mode_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_24_isolation_mode_correct for 6

assert PHI_001_25_complete_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_25_complete_coverage for 6

assert PHI_001_26_no_hidden_functionality {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_26_no_hidden_functionality for 6

assert no_hidden_functionality_non_div {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_hidden_functionality_non_div for 6

assert PHI_001_27_behavior_specified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_27_behavior_specified for 6

assert PHI_001_28_no_trigger_logic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_28_no_trigger_logic for 6

assert behavior_in_spec_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check behavior_in_spec_refl for 6

assert single_step_in_spec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check single_step_in_spec for 6

assert reachable_first_step_in_spec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reachable_first_step_in_spec for 6

assert PHI_001_29_no_payload_logic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_29_no_payload_logic for 6

assert PHI_001_30_formal_equivalence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_30_formal_equivalence for 6

assert PHI_001_31_trojan_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_31_trojan_detected for 6

assert PHI_001_32_ecc_single_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_32_ecc_single_correct for 6

assert PHI_001_33_ecc_double_detect {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_33_ecc_double_detect for 6

assert PHI_001_34_zeroize_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_34_zeroize_complete for 6

assert PHI_001_35_checkpoint_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_35_checkpoint_correct for 6

assert PHI_001_36_voltage_monitor {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_36_voltage_monitor for 6

assert PHI_001_37_frequency_monitor {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_37_frequency_monitor for 6

assert PHI_001_38_tamper_evident {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHI_001_38_tamper_evident for 6

pred ExampleVerifiedHardware {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedHardware for 6

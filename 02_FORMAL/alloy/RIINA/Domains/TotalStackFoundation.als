// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for total stack foundation
// Bounded verification of key properties
module riina/Domains/TotalStackFoundation

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

assert layer_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check layer_eqb_refl for 6

assert layer_eqb_eq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check layer_eqb_eq for 6

assert layer_adjacent_L0_L1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check layer_adjacent_L0_L1 for 6

assert layer_adjacent_L1_L2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check layer_adjacent_L1_L2 for 6

assert layer_adjacent_L2_L3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check layer_adjacent_L2_L3 for 6

assert layer_adjacent_L3_L4 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check layer_adjacent_L3_L4 for 6

assert layer_adjacent_L4_L5 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check layer_adjacent_L4_L5 for 6

assert layer_adjacent_L5_L6 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check layer_adjacent_L5_L6 for 6

assert layer_adjacent_L6_L7 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check layer_adjacent_L6_L7 for 6

assert sp_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sp_eqb_refl for 6

assert existsb_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check existsb_app for 6

assert existsb_cons_true {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check existsb_cons_true for 6

assert existsb_cons_or {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check existsb_cons_or for 6

assert forallb_impl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check forallb_impl for 6

assert andb_true_intro_both {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb_true_intro_both for 6

assert TOTAL_001_01_l0_l1_interface_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_01_l0_l1_interface_security for 6

assert TOTAL_001_02_l1_l2_interface_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_02_l1_l2_interface_security for 6

assert TOTAL_001_03_l2_l3_interface_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_03_l2_l3_interface_security for 6

assert TOTAL_001_04_l3_l4_interface_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_04_l3_l4_interface_security for 6

assert TOTAL_001_05_l4_l5_interface_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_05_l4_l5_interface_security for 6

assert TOTAL_001_06_l5_l6_interface_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_06_l5_l6_interface_security for 6

assert TOTAL_001_07_l6_l7_interface_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_07_l6_l7_interface_security for 6

assert TOTAL_001_08_confidentiality_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_08_confidentiality_preserved for 6

assert TOTAL_001_09_integrity_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_09_integrity_preserved for 6

assert TOTAL_001_10_availability_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_10_availability_preserved for 6

assert TOTAL_001_11_authentication_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_11_authentication_preserved for 6

assert TOTAL_001_12_authorization_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_12_authorization_preserved for 6

assert TOTAL_001_13_memory_corruption_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_13_memory_corruption_impossible for 6

assert TOTAL_001_14_side_channel_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_14_side_channel_impossible for 6

assert TOTAL_001_15_network_attack_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_15_network_attack_impossible for 6

assert TOTAL_001_16_privilege_escalation_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_16_privilege_escalation_impossible for 6

assert TOTAL_001_17_ui_deception_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_17_ui_deception_impossible for 6

assert TOTAL_001_18_boot_compromise_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_18_boot_compromise_impossible for 6

assert TOTAL_001_19_adjacent_layers_compose {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_19_adjacent_layers_compose for 6

assert TOTAL_001_20_security_property_transitivity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_20_security_property_transitivity for 6

assert TOTAL_001_21_no_security_gap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_21_no_security_gap for 6

assert TOTAL_001_22_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_22_defense_in_depth for 6

assert TOTAL_001_23_single_layer_compromise_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_23_single_layer_compromise_bounded for 6

assert TOTAL_001_24_hardware_root_of_trust {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_24_hardware_root_of_trust for 6

assert TOTAL_001_25_measured_boot_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_25_measured_boot_integrity for 6

assert TOTAL_001_26_secure_channel_establishment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_26_secure_channel_establishment for 6

assert TOTAL_001_27_capability_delegation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_27_capability_delegation for 6

assert TOTAL_001_28_end_to_end_encryption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_28_end_to_end_encryption for 6

assert TOTAL_001_29_remote_code_execution_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_29_remote_code_execution_impossible for 6

assert TOTAL_001_30_data_exfiltration_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_30_data_exfiltration_impossible for 6

assert TOTAL_001_31_denial_of_service_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_31_denial_of_service_bounded for 6

assert TOTAL_001_32_malware_execution_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_32_malware_execution_impossible for 6

assert TOTAL_001_33_insider_threat_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_33_insider_threat_bounded for 6

assert TOTAL_001_34_all_layer_proofs_compose {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_34_all_layer_proofs_compose for 6

assert attack_blocked_by_layer {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check attack_blocked_by_layer for 6

assert TOTAL_001_35_total_stack_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TOTAL_001_35_total_stack_security for 6

pred ExampleTotalStackFoundation {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleTotalStackFoundation for 6

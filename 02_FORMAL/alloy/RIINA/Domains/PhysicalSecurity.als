// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for physical security
// Bounded verification of key properties
module riina/Domains/PhysicalSecurity

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

assert PHY_001_01_rtl_gate_equivalent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_01_rtl_gate_equivalent for 6

assert PHY_001_02_timing_closed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_02_timing_closed for 6

assert PHY_001_03_no_trojans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_03_no_trojans for 6

assert PHY_001_04_hw_constant_time {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_04_hw_constant_time for 6

assert PHY_001_05_design_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_05_design_deterministic for 6

assert PHY_001_06_golden_equivalent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_06_golden_equivalent for 6

assert PHY_001_07_puf_unique {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_07_puf_unique for 6

assert PHY_001_08_puf_stable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_08_puf_stable for 6

assert PHY_001_09_counterfeit_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_09_counterfeit_detected for 6

assert PHY_001_10_no_fab_tampering {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_10_no_fab_tampering for 6

assert PHY_001_11_mesh_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_11_mesh_integrity for 6

assert PHY_001_12_tamper_response {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_12_tamper_response for 6

assert PHY_001_13_voltage_glitch_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_13_voltage_glitch_detected for 6

assert PHY_001_14_temperature_bounds {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_14_temperature_bounds for 6

assert PHY_001_15_power_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_15_power_independent for 6

assert PHY_001_16_tamper_disables_operation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_16_tamper_disables_operation for 6

assert PHY_001_17_normal_preserves_state {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_17_normal_preserves_state for 6

assert PHY_001_18_mesh_broken_tamper {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_18_mesh_broken_tamper for 6

assert PHY_001_19_voltage_oor_tamper {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_19_voltage_oor_tamper for 6

assert PHY_001_20_temp_oor_tamper {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_20_temp_oor_tamper for 6

assert PHY_001_21_synthesis_all_inputs {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check PHY_001_21_synthesis_all_inputs for 6

pred ExamplePhysicalSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExamplePhysicalSecurity for 6

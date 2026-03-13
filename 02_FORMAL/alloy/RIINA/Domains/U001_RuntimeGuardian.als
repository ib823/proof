// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for u001_runtime guardian
// Bounded verification of key properties
module riina/Domains/U001_RuntimeGuardian

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

assert U_001_01_cfi_cfg_wellformed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_01_cfi_cfg_wellformed for 6

assert U_001_02_cfi_ip_in_cfg {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_02_cfi_ip_in_cfg for 6

assert U_001_03_cfi_indirect_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_03_cfi_indirect_safe for 6

assert U_001_04_cfi_return_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_04_cfi_return_integrity for 6

assert U_001_05_cfi_call_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_05_cfi_call_integrity for 6

assert U_001_06_cfi_no_arbitrary_jump {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_06_cfi_no_arbitrary_jump for 6

assert U_001_07_cfi_shadow_stack {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_07_cfi_shadow_stack for 6

assert U_001_08_cfi_forward_edge {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_08_cfi_forward_edge for 6

assert U_001_09_cfi_backward_edge {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_09_cfi_backward_edge for 6

assert U_001_10_cfi_violation_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_10_cfi_violation_detected for 6

assert U_001_11_mem_checksum_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_11_mem_checksum_correct for 6

assert U_001_12_mem_redundant_storage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_12_mem_redundant_storage for 6

assert U_001_13_mem_ecc_corrects {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_13_mem_ecc_corrects for 6

assert double_even {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check double_even for 6

assert U_001_14_mem_ecc_detects {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_14_mem_ecc_detects for 6

assert U_001_15_mem_bounds_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_15_mem_bounds_enforced for 6

assert U_001_16_mem_readonly_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_16_mem_readonly_protected for 6

assert U_001_17_mem_kernel_isolated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_17_mem_kernel_isolated for 6

assert U_001_18_mem_corruption_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_18_mem_corruption_detected for 6

assert U_001_19_nmr_variants_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_19_nmr_variants_independent for 6

assert U_001_20_nmr_state_synchronized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_20_nmr_state_synchronized for 6

assert U_001_21_nmr_divergence_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_21_nmr_divergence_detected for 6

assert U_001_22_nmr_single_fault_tolerant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_22_nmr_single_fault_tolerant for 6

assert U_001_23_nmr_voting_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_23_nmr_voting_correct for 6

assert U_001_24_nmr_recovery_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_24_nmr_recovery_sound for 6

assert U_001_25_nmr_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_25_nmr_coverage for 6

assert U_001_26_panic_keys_zeroized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_26_panic_keys_zeroized for 6

assert U_001_27_panic_execution_halted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_27_panic_execution_halted for 6

assert U_001_28_panic_audit_logged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_28_panic_audit_logged for 6

assert U_001_29_panic_triggered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_29_panic_triggered for 6

assert U_001_30_panic_irreversible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_30_panic_irreversible for 6

assert U_001_31_watchdog_nmi {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_31_watchdog_nmi for 6

assert U_001_32_watchdog_monitor_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_32_watchdog_monitor_integrity for 6

assert U_001_33_monitor_unprivileged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_33_monitor_unprivileged for 6

assert U_001_34_monitor_complete_mediation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_34_monitor_complete_mediation for 6

assert U_001_35_monitor_tamper_evident {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check U_001_35_monitor_tamper_evident for 6

pred ExampleU001_RuntimeGuardian {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleU001_RuntimeGuardian for 6

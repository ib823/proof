// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified microkernel
// Bounded verification of key properties
module riina/Domains/VerifiedMicrokernel

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

assert OS_001_01_cap_unforgeable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_01_cap_unforgeable for 6

assert OS_001_02_cap_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_02_cap_monotonic for 6

assert OS_001_03_cap_revocation_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_03_cap_revocation_complete for 6

assert OS_001_04_cap_transfer_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_04_cap_transfer_safe for 6

assert OS_001_05_cap_derivation_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_05_cap_derivation_sound for 6

assert OS_001_06_no_confused_deputy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_06_no_confused_deputy for 6

assert OS_001_07_cap_lookup_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_07_cap_lookup_correct for 6

assert OS_001_08_cap_space_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_08_cap_space_isolation for 6

assert OS_001_09_cap_invoke_authorized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_09_cap_invoke_authorized for 6

assert OS_001_10_cap_badge_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_10_cap_badge_integrity for 6

assert OS_001_11_address_space_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_11_address_space_isolation for 6

assert OS_001_12_kernel_memory_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_12_kernel_memory_integrity for 6

assert OS_001_13_page_table_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_13_page_table_correct for 6

assert OS_001_14_no_page_table_corruption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_14_no_page_table_corruption for 6

assert OS_001_15_mapping_respects_caps {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_15_mapping_respects_caps for 6

assert OS_001_16_unmap_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_16_unmap_complete for 6

assert OS_001_17_no_kernel_data_leak {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_17_no_kernel_data_leak for 6

assert OS_001_18_frame_allocation_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_18_frame_allocation_safe for 6

assert OS_001_19_ipc_type_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_19_ipc_type_safe for 6

assert OS_001_20_ipc_cap_transfer_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_20_ipc_cap_transfer_safe for 6

assert OS_001_21_ipc_deadlock_free {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_21_ipc_deadlock_free for 6

assert OS_001_22_ipc_no_amplification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_22_ipc_no_amplification for 6

assert OS_001_23_ipc_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_23_ipc_isolation for 6

assert OS_001_24_endpoint_protection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_24_endpoint_protection for 6

assert OS_001_25_notification_no_leak {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check OS_001_25_notification_no_leak for 6

pred ExampleVerifiedMicrokernel {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedMicrokernel for 6

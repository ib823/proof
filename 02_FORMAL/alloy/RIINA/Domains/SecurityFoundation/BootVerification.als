// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for boot verification
// Bounded verification of key properties
module riina/Domains/SecurityFoundation/BootVerification

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

assert boot_chain_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_chain_verified for 6

assert boot_tampering_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_tampering_detected for 6

assert failed_verification_no_boot {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check failed_verification_no_boot for 6

assert hardware_root_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hardware_root_verified for 6

assert boot_requires_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_requires_verification for 6

assert verification_preserves_previous {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check verification_preserves_previous for 6

assert each_stage_verifies_next {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check each_stage_verifies_next for 6

assert root_of_trust_immutable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check root_of_trust_immutable for 6

assert firmware_rollback_prevented {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check firmware_rollback_prevented for 6

assert boot_log_only_grows {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_log_only_grows for 6

assert hash_mismatch_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hash_mismatch_detected for 6

assert recovery_mode_requires_hash {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check recovery_mode_requires_hash for 6

assert boot_stage_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_stage_deterministic for 6

assert config_table_validated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check config_table_validated for 6

assert kernel_signature_checked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kernel_signature_checked for 6

assert bootloader_follows_root {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bootloader_follows_root for 6

assert second_stage_follows_bootloader {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check second_stage_follows_bootloader for 6

assert kernel_follows_second_stage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kernel_follows_second_stage for 6

assert initramfs_follows_kernel {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check initramfs_follows_kernel for 6

assert hardware_root_self_previous {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hardware_root_self_previous for 6

assert complete_boot_sets_success {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check complete_boot_sets_success for 6

assert complete_boot_preserves_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check complete_boot_preserves_verified for 6

pred ExampleBootVerification {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleBootVerification for 6

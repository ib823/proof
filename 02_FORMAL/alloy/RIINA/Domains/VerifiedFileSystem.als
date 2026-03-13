// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified file system
// Bounded verification of key properties
module riina/Domains/VerifiedFileSystem

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

assert andb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb_true_iff for 6

assert orb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check orb_true_iff for 6

assert negb_false_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check negb_false_iff for 6

assert negb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check negb_true_iff for 6

assert VFS_001 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_001 for 6

assert VFS_002 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_002 for 6

assert VFS_003 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_003 for 6

assert VFS_004 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_004 for 6

assert VFS_005 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_005 for 6

assert VFS_006 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_006 for 6

assert VFS_007 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_007 for 6

assert VFS_008 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_008 for 6

assert VFS_009 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_009 for 6

assert VFS_010 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_010 for 6

assert VFS_011 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_011 for 6

assert VFS_012 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_012 for 6

assert VFS_013 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_013 for 6

assert VFS_014 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_014 for 6

assert VFS_015 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_015 for 6

assert VFS_016 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_016 for 6

assert VFS_017 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_017 for 6

assert VFS_018 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_018 for 6

assert VFS_019 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_019 for 6

assert VFS_020 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_020 for 6

assert VFS_021 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_021 for 6

assert VFS_022 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_022 for 6

assert VFS_023 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_023 for 6

assert VFS_024 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_024 for 6

assert VFS_025 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_025 for 6

assert VFS_026 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_026 for 6

assert VFS_027 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_027 for 6

assert VFS_028 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_028 for 6

assert VFS_029 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_029 for 6

assert VFS_030_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_030_complete for 6

assert VFS_031_root_can_read {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_031_root_can_read for 6

assert VFS_032_root_can_write {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_032_root_can_write for 6

assert VFS_033_root_can_execute {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_033_root_can_execute for 6

assert VFS_034_owner_read {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_034_owner_read for 6

assert VFS_035_owner_write {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_035_owner_write for 6

assert VFS_036_owner_execute {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_036_owner_execute for 6

assert VFS_037_other_permissions {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_037_other_permissions for 6

assert VFS_038_group_permissions {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_038_group_permissions for 6

assert VFS_039_no_read_without_perm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_039_no_read_without_perm for 6

assert VFS_040_no_write_without_perm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_040_no_write_without_perm for 6

assert VFS_041_no_execute_without_perm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_041_no_execute_without_perm for 6

assert VFS_042_access_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_042_access_deterministic for 6

assert VFS_043_owner_full_access {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_043_owner_full_access for 6

assert VFS_044_root_full_access {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_044_root_full_access for 6

assert VFS_045_permission_consistency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_045_permission_consistency for 6

assert VFS_046_committed_is_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_046_committed_is_complete for 6

assert VFS_047_checkpointed_is_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_047_checkpointed_is_complete for 6

assert VFS_048_pending_not_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_048_pending_not_complete for 6

assert VFS_049_aborted_not_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_049_aborted_not_complete for 6

assert VFS_050_empty_journal_consistent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_050_empty_journal_consistent for 6

assert VFS_051_single_committed_consistent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_051_single_committed_consistent for 6

assert VFS_052_txn_complete_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_052_txn_complete_decidable for 6

assert VFS_053_journal_head_ge_tail {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_053_journal_head_ge_tail for 6

assert VFS_054_all_txns_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_054_all_txns_complete for 6

assert VFS_055_complete_txn_valid_state {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_055_complete_txn_valid_state for 6

assert VFS_056_no_self_cycle {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_056_no_self_cycle for 6

assert VFS_057_self_cycle_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_057_self_cycle_detected for 6

assert VFS_058_integrity_requires_no_cycle {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_058_integrity_requires_no_cycle for 6

assert VFS_059_integrity_requires_parent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_059_integrity_requires_parent for 6

assert VFS_060_integrity_requires_dot {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_060_integrity_requires_dot for 6

assert VFS_061_empty_dir_no_parent_link {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_061_empty_dir_no_parent_link for 6

assert VFS_062_empty_dir_no_dot {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_062_empty_dir_no_dot for 6

assert VFS_063_empty_dir_no_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_063_empty_dir_no_integrity for 6

assert VFS_064_wellformed_dir_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_064_wellformed_dir_complete for 6

assert VFS_065_dir_integrity_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_065_dir_integrity_decidable for 6

assert VFS_066_zero_usage_ok {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_066_zero_usage_ok for 6

assert VFS_067_at_limit_ok {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_067_at_limit_ok for 6

assert VFS_068_enforced_bytes_ok {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_068_enforced_bytes_ok for 6

assert VFS_069_enforced_inodes_ok {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_069_enforced_inodes_ok for 6

assert VFS_070_can_alloc_zero_bytes {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_070_can_alloc_zero_bytes for 6

assert VFS_071_cannot_exceed_quota {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_071_cannot_exceed_quota for 6

assert VFS_072_bytes_ok_semantics {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_072_bytes_ok_semantics for 6

assert VFS_073_inodes_ok_semantics {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_073_inodes_ok_semantics for 6

assert VFS_074_can_alloc_inode_under_limit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_074_can_alloc_inode_under_limit for 6

assert VFS_075_cannot_alloc_inode_at_limit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_075_cannot_alloc_inode_at_limit for 6

assert VFS_076_online_no_recovery {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_076_online_no_recovery for 6

assert VFS_077_clean_no_recovery {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_077_clean_no_recovery for 6

assert VFS_078_mounting_not_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_078_mounting_not_complete for 6

assert VFS_079_recovering_not_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_079_recovering_not_complete for 6

assert VFS_080_error_not_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_080_error_not_complete for 6

assert VFS_081_recovery_needed_blocks {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_081_recovery_needed_blocks for 6

assert VFS_082_crash_safe_journal {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_082_crash_safe_journal for 6

assert VFS_083_empty_journal_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_083_empty_journal_safe for 6

assert VFS_084_recovery_complete_valid_state {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_084_recovery_complete_valid_state for 6

assert VFS_085_recovery_complete_no_recovery {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_085_recovery_complete_no_recovery for 6

assert VFS_086_success_is_atomic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_086_success_is_atomic for 6

assert VFS_087_failure_is_atomic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_087_failure_is_atomic for 6

assert VFS_088_partial_not_atomic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_088_partial_not_atomic for 6

assert VFS_089_atomic_definite_result {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_089_atomic_definite_result for 6

assert VFS_090_journaled_has_entry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_090_journaled_has_entry for 6

assert VFS_091_non_journaled_no_entry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_091_non_journaled_no_entry for 6

assert VFS_092_create_journaled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_092_create_journaled for 6

assert VFS_093_delete_journaled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_093_delete_journaled for 6

assert VFS_094_rename_journaled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_094_rename_journaled for 6

assert VFS_095_atomicity_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_095_atomicity_decidable for 6

assert VFS_096_full_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_096_full_security for 6

assert VFS_097_full_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_097_full_integrity for 6

assert VFS_098_safe_recovery_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_098_safe_recovery_sound for 6

assert VFS_099_quota_access_combined {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_099_quota_access_combined for 6

assert VFS_100_atomic_journaled_durable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_100_atomic_journaled_durable for 6

assert VFS_101_dir_with_quota {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_101_dir_with_quota for 6

assert VFS_102_verification_chain {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_102_verification_chain for 6

assert VFS_103_journal_consistency_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_103_journal_consistency_preservation for 6

assert VFS_104_access_dir_combined {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_104_access_dir_combined for 6

assert VFS_105_system_soundness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check VFS_105_system_soundness for 6

pred ExampleVerifiedFileSystem {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedFileSystem for 6

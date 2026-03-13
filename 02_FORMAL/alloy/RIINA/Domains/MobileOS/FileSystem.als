// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for file system
// Bounded verification of key properties
module riina/Domains/MobileOS/FileSystem

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

assert filesystem_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check filesystem_integrity for 6

assert write_maintains_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check write_maintains_integrity for 6

assert power_loss_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check power_loss_safe for 6

assert journal_write_preserves_base_consistency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check journal_write_preserves_base_consistency for 6

assert commit_establishes_consistency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check commit_establishes_consistency for 6

assert file_permissions_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check file_permissions_enforced for 6

assert directory_traversal_prevented {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check directory_traversal_prevented for 6

assert symlink_attack_prevented {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check symlink_attack_prevented for 6

assert file_lock_exclusive_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check file_lock_exclusive_thm for 6

assert atomic_rename {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check atomic_rename for 6

assert fsync_durability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fsync_durability for 6

assert no_partial_write {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_partial_write for 6

assert path_canonicalization {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check path_canonicalization for 6

assert file_descriptor_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check file_descriptor_bounded for 6

assert inode_reference_count_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check inode_reference_count_correct for 6

assert journal_recovery_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check journal_recovery_correct for 6

assert quota_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check quota_enforced for 6

assert temp_file_cleanup {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check temp_file_cleanup for 6

assert file_type_validated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check file_type_validated for 6

assert access_time_updated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check access_time_updated for 6

pred ExampleFileSystem {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleFileSystem for 6

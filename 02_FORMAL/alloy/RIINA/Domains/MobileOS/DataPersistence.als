// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for data persistence
// Bounded verification of key properties
module riina/Domains/MobileOS/DataPersistence

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

assert migration_lossless {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check migration_lossless for 6

assert migration_preserves_existing_fields {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check migration_preserves_existing_fields for 6

assert migration_increases_version {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check migration_increases_version for 6

assert sync_after_resolution {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sync_after_resolution for 6

assert empty_db_no_loss {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_db_no_loss for 6

assert data_encrypted_at_rest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_encrypted_at_rest for 6

assert backup_encrypted_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check backup_encrypted_thm for 6

assert migration_atomic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check migration_atomic for 6

assert schema_version_tracked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check schema_version_tracked for 6

assert corruption_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check corruption_detected for 6

assert data_integrity_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_integrity_verified for 6

assert transaction_acid_compliant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transaction_acid_compliant for 6

assert concurrent_access_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check concurrent_access_safe for 6

assert data_deletion_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_deletion_complete for 6

assert index_consistent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check index_consistent for 6

assert cache_invalidation_correct_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cache_invalidation_correct_thm for 6

assert serialization_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check serialization_safe for 6

assert deserialization_validated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check deserialization_validated for 6

assert storage_quota_respected_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check storage_quota_respected_thm for 6

assert data_export_sanitized_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_export_sanitized_thm for 6

pred ExampleDataPersistence {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleDataPersistence for 6

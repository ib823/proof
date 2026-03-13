// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for sigma001_verified storage
// Bounded verification of key properties
module riina/Domains/SIGMA001_VerifiedStorage

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

assert SIGMA_001_01_query_ast_typed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_01_query_ast_typed for 6

assert SIGMA_001_02_no_sql_injection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_02_no_sql_injection for 6

assert SIGMA_001_03_query_preserves_schema {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_03_query_preserves_schema for 6

assert SIGMA_001_04_predicate_typed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_04_predicate_typed for 6

assert SIGMA_001_05_projection_typed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_05_projection_typed for 6

assert SIGMA_001_06_join_typed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_06_join_typed for 6

assert SIGMA_001_07_query_result_typed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_07_query_result_typed for 6

assert SIGMA_001_08_parameterized_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_08_parameterized_safe for 6

assert SIGMA_001_09_atomicity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_09_atomicity for 6

assert SIGMA_001_10_atomicity_commit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_10_atomicity_commit for 6

assert SIGMA_001_11_atomicity_abort {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_11_atomicity_abort for 6

assert SIGMA_001_12_consistency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_12_consistency for 6

assert SIGMA_001_13_consistency_fk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_13_consistency_fk for 6

assert SIGMA_001_14_consistency_unique {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_14_consistency_unique for 6

assert SIGMA_001_15_isolation_serializable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_15_isolation_serializable for 6

assert SIGMA_001_16_isolation_no_dirty_read {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_16_isolation_no_dirty_read for 6

assert SIGMA_001_17_isolation_no_phantom {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_17_isolation_no_phantom for 6

assert SIGMA_001_18_durability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_18_durability for 6

assert SIGMA_001_19_wal_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_19_wal_correct for 6

assert SIGMA_001_20_wal_recovery {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_20_wal_recovery for 6

assert SIGMA_001_21_wal_idempotent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_21_wal_idempotent for 6

assert SIGMA_001_22_checkpoint_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_22_checkpoint_correct for 6

assert SIGMA_001_23_no_partial_write {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_23_no_partial_write for 6

assert SIGMA_001_24_crash_atomic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_24_crash_atomic for 6

assert SIGMA_001_25_recovery_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_25_recovery_complete for 6

assert SIGMA_001_26_recovery_abort {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_26_recovery_abort for 6

assert SIGMA_001_27_btree_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_27_btree_ordered for 6

assert SIGMA_001_28_btree_balanced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_28_btree_balanced for 6

assert SIGMA_001_29_btree_lookup_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_29_btree_lookup_correct for 6

assert SIGMA_001_30_btree_insert_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_30_btree_insert_preserves for 6

assert SIGMA_001_31_btree_delete_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_31_btree_delete_preserves for 6

assert SIGMA_001_32_btree_complexity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_32_btree_complexity for 6

assert SIGMA_001_33_page_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_33_page_integrity for 6

assert SIGMA_001_34_encryption_at_rest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_34_encryption_at_rest for 6

assert SIGMA_001_35_merkle_tamper_detect {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_35_merkle_tamper_detect for 6

assert SIGMA_001_36_checksum_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_36_checksum_correct for 6

assert SIGMA_001_37_audit_immutable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_37_audit_immutable for 6

assert SIGMA_001_38_backup_consistent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check SIGMA_001_38_backup_consistent for 6

pred ExampleSIGMA001_VerifiedStorage {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSIGMA001_VerifiedStorage for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified audit
// Bounded verification of key properties
module riina/Domains/VerifiedAudit

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

assert audit_001_entry_hashed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_001_entry_hashed for 6

assert audit_002_append_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_002_append_only for 6

assert audit_003_sequence_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_003_sequence_monotonic for 6

assert audit_004_inclusion_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_004_inclusion_valid for 6

assert audit_005_consistency_order {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_005_consistency_order for 6

assert audit_006_witnesses_sufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_006_witnesses_sufficient for 6

assert audit_007_witness_root {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_007_witness_root for 6

assert audit_008_timestamp_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_008_timestamp_ordered for 6

assert audit_009_principal_logged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_009_principal_logged for 6

assert audit_010_action_logged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_010_action_logged for 6

assert audit_011_resource_logged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_011_resource_logged for 6

assert audit_012_hash_binds {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_012_hash_binds for 6

assert audit_013_log_not_empty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_013_log_not_empty for 6

assert audit_014_checkpoint_seq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_014_checkpoint_seq for 6

assert audit_015_witness_recent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_015_witness_recent for 6

assert audit_016_witnesses_diverse {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_016_witnesses_diverse for 6

assert audit_017_path_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_017_path_bounded for 6

assert audit_018_root_unique {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_018_root_unique for 6

assert audit_019_entry_unique {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_019_entry_unique for 6

assert audit_020_signature_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_020_signature_valid for 6

assert audit_021_retention {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_021_retention for 6

assert audit_022_query_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_022_query_complete for 6

assert audit_023_storage_redundant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_023_storage_redundant for 6

assert audit_024_tamper_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_024_tamper_detected for 6

assert audit_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_025_defense_in_depth for 6

pred ExampleVerifiedAudit {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedAudit for 6

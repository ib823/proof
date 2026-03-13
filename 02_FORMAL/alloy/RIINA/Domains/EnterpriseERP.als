// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for enterprise erp
// Bounded verification of key properties
module riina/Domains/EnterpriseERP

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

assert erp_001_rbac_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_001_rbac_enforced for 6

assert erp_002_assignment_active {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_002_assignment_active for 6

assert erp_003_sod_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_003_sod_enforced for 6

assert erp_004_txn_authorized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_004_txn_authorized for 6

assert erp_005_no_self_approval {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_005_no_self_approval for 6

assert erp_006_audit_created {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_006_audit_created for 6

assert erp_007_audit_immutable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_007_audit_immutable for 6

assert erp_008_tenant_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_008_tenant_isolation for 6

assert erp_009_role_hierarchy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_009_role_hierarchy for 6

assert erp_010_multi_approval {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_010_multi_approval for 6

assert erp_011_budget_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_011_budget_enforced for 6

assert erp_012_period_closed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_012_period_closed for 6

assert erp_013_valid_workflow {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_013_valid_workflow for 6

assert erp_014_no_post_without_approval {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_014_no_post_without_approval for 6

assert erp_015_maker_checker {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_015_maker_checker for 6

assert erp_016_delegation_logged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_016_delegation_logged for 6

assert erp_017_time_limited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_017_time_limited for 6

assert erp_018_field_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_018_field_security for 6

assert erp_019_lock_exclusive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_019_lock_exclusive for 6

assert erp_020_concurrent_controlled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_020_concurrent_controlled for 6

assert erp_021_data_validated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_021_data_validated for 6

assert erp_022_ref_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_022_ref_integrity for 6

assert erp_023_soft_delete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_023_soft_delete for 6

assert erp_024_encrypted_at_rest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_024_encrypted_at_rest for 6

assert erp_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check erp_025_defense_in_depth for 6

pred ExampleEnterpriseERP {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleEnterpriseERP for 6

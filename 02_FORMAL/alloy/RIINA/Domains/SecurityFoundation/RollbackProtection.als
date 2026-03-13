// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for rollback protection
// Bounded verification of key properties
module riina/Domains/SecurityFoundation/RollbackProtection

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

assert rollback_protection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rollback_protection for 6

assert old_version_cannot_boot {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check old_version_cannot_boot for 6

assert current_or_newer_allowed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check current_or_newer_allowed for 6

assert min_version_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check min_version_monotonic for 6

assert no_minimum_any_allowed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_minimum_any_allowed for 6

assert disabled_rollback_allows_all {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check disabled_rollback_allows_all for 6

assert version_lt_irreflexive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check version_lt_irreflexive for 6

assert same_version_always_allowed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check same_version_always_allowed for 6

assert update_stores_new_min {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check update_stores_new_min for 6

assert record_preserves_anti_rollback {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check record_preserves_anti_rollback for 6

assert record_preserves_minimums {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check record_preserves_minimums for 6

assert update_preserves_anti_rollback {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check update_preserves_anti_rollback for 6

assert advance_preserves_anti_rollback {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check advance_preserves_anti_rollback for 6

assert equal_version_not_rollback {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check equal_version_not_rollback for 6

assert initial_state_allows_all {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check initial_state_allows_all for 6

assert initial_state_no_minimums {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check initial_state_no_minimums for 6

assert initial_state_no_current {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check initial_state_no_current for 6

assert enforced_detects_rollback {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check enforced_detects_rollback for 6

assert hardware_stored_minimum_recorded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hardware_stored_minimum_recorded for 6

assert advance_missing_current_identity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check advance_missing_current_identity for 6

assert independent_component_minimums {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check independent_component_minimums for 6

pred ExampleRollbackProtection {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleRollbackProtection for 6

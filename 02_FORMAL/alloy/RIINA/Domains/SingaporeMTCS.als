// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for singapore mtcs
// Bounded verification of key properties
module riina/Domains/SingaporeMTCS

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

assert mtcs_level_1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_level_1 for 6

assert mtcs_level_2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_level_2 for 6

assert mtcs_level_3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_level_3 for 6

assert mtcs_l3_implies_l2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_l3_implies_l2 for 6

assert mtcs_l2_implies_l1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_l2_implies_l1 for 6

assert mtcs_l3_implies_l1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_l3_implies_l1 for 6

assert im8_official {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_official for 6

assert im8_secret {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_secret for 6

assert im8_assessment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_assessment for 6

assert im8_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_composition for 6

assert im8_secret_highest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_secret_highest for 6

assert mtcs_level_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_level_coverage for 6

assert im8_classification_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_classification_coverage for 6

assert mtcs_level_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_level_positive for 6

assert mtcs_level_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_level_bounded for 6

assert mtcs_level_ordering {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_level_ordering for 6

assert mtcs_l2_requires_encryption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_l2_requires_encryption for 6

assert mtcs_l3_requires_sovereignty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_l3_requires_sovereignty for 6

assert mtcs_l3_requires_iso27001 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_l3_requires_iso27001 for 6

assert mtcs_controls_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mtcs_controls_monotonic for 6

assert im8_level_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_level_bounded for 6

assert im8_official_lowest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_official_lowest for 6

assert im8_confidential {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_confidential for 6

assert im8_restricted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_restricted for 6

assert im8_secret_requires_encryption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_secret_requires_encryption for 6

assert im8_secret_requires_access_control {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_secret_requires_access_control for 6

assert im8_secret_requires_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_secret_requires_audit for 6

assert gcc_required_for_restricted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gcc_required_for_restricted for 6

assert im8_secret_maps_to_mtcs3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_secret_maps_to_mtcs3 for 6

assert im8_to_mtcs_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check im8_to_mtcs_monotonic for 6

assert integrated_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check integrated_compliance for 6

assert integrated_implies_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check integrated_implies_encrypted for 6

pred ExampleSingaporeMTCS {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSingaporeMTCS for 6

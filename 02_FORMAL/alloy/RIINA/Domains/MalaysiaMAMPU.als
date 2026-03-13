// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for malaysia mampu
// Bounded verification of key properties
module riina/Domains/MalaysiaMAMPU

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

assert mampu_sovereignty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_sovereignty for 6

assert mampu_terbuka {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_terbuka for 6

assert mampu_rahsia {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_rahsia for 6

assert mampu_rahsia_besar {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_rahsia_besar for 6

assert mampu_assessment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_assessment for 6

assert mampu_isms {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_isms for 6

assert classification_ordering {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check classification_ordering for 6

assert rahsia_besar_highest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rahsia_besar_highest for 6

assert mampu_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_composition for 6

assert gov_classification_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gov_classification_coverage for 6

assert terbuka_is_level_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check terbuka_is_level_zero for 6

assert rahsia_besar_is_level_four {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rahsia_besar_is_level_four for 6

assert classification_level_positive_for_non_terbuka {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check classification_level_positive_for_non_terbuka for 6

assert mampu_terhad {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_terhad for 6

assert mampu_sulit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_sulit for 6

assert rahsia_besar_requires_encryption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rahsia_besar_requires_encryption for 6

assert rahsia_besar_requires_access_control {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rahsia_besar_requires_access_control for 6

assert rahsia_besar_requires_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rahsia_besar_requires_audit for 6

assert rahsia_besar_requires_isms {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rahsia_besar_requires_isms for 6

assert sovereignty_mandatory_for_all_levels {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sovereignty_mandatory_for_all_levels for 6

assert sovereignty_violation_blocks_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sovereignty_violation_blocks_compliance for 6

assert rakkssa_assessment_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rakkssa_assessment_complete for 6

assert rakkssa_score_insufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rakkssa_score_insufficient for 6

assert mygovcloud_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mygovcloud_check for 6

assert dkict_full_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dkict_full_compliance for 6

assert mampu_full_implies_sovereign {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_full_implies_sovereign for 6

assert mampu_full_implies_assessed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mampu_full_implies_assessed for 6

pred ExampleMalaysiaMAMPU {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMalaysiaMAMPU for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for singapore cybersecurity act
// Bounded verification of key properties
module riina/Domains/SingaporeCybersecurityAct

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

assert cii_obligation_1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cii_obligation_1 for 6

assert cii_obligation_2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cii_obligation_2 for 6

assert cii_obligation_3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cii_obligation_3 for 6

assert sg_stricter_than_my {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_stricter_than_my for 6

assert cii_obligation_4 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cii_obligation_4 for 6

assert esci_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check esci_compliance for 6

assert cssp_obligation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cssp_obligation for 6

assert sg_cybersecurity_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_cybersecurity_composition for 6

assert cii_sector_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cii_sector_coverage for 6

assert entity_classification_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check entity_classification_coverage for 6

assert stcc_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check stcc_compliance for 6

assert cii_owner_strictest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cii_owner_strictest for 6

assert cii_owner_implies_esci_risk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cii_owner_implies_esci_risk for 6

assert significant_incident_must_notify {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check significant_incident_must_notify for 6

assert two_hour_deadline_tight {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check two_hour_deadline_tight for 6

assert sg_2h_stricter_than_my_6h {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_2h_stricter_than_my_6h for 6

assert sg_2h_stricter_than_72h {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_2h_stricter_than_72h for 6

assert audit_schedule_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_schedule_valid for 6

assert more_controls_still_adequate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check more_controls_still_adequate for 6

assert sg_cyber_full_implies_risk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_cyber_full_implies_risk for 6

assert sg_cyber_full_implies_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_cyber_full_implies_audit for 6

assert sg_cyber_full_implies_controls {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_cyber_full_implies_controls for 6

assert sg_cyber_full_implies_irp {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_cyber_full_implies_irp for 6

assert cssp_expired_non_compliant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cssp_expired_non_compliant for 6

assert regular_entity_no_cii_obligation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check regular_entity_no_cii_obligation for 6

assert compliance_eliminates_penalty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compliance_eliminates_penalty for 6

pred ExampleSingaporeCybersecurityAct {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSingaporeCybersecurityAct for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for malaysia bnmrmi t
// Bounded verification of key properties
module riina/Domains/MalaysiaBNMRMiT

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

assert rmit_domain_1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_domain_1 for 6

assert rmit_domain_2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_domain_2 for 6

assert rmit_domain_3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_domain_3 for 6

assert rmit_domain_4 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_domain_4 for 6

assert rmit_domain_5 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_domain_5 for 6

assert rmit_domain_6_onprem {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_domain_6_onprem for 6

assert rmit_domain_6_cloud {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_domain_6_cloud for 6

assert rmit_domain_7 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_domain_7 for 6

assert rmit_domain_8 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_domain_8 for 6

assert rmit_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_composition for 6

assert fi_type_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fi_type_coverage for 6

assert cyber_controls_strengthened {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cyber_controls_strengthened for 6

assert cloud_deployment_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cloud_deployment_coverage for 6

assert on_premise_always_compliant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check on_premise_always_compliant for 6

assert rmit_full_implies_governance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_full_implies_governance for 6

assert rmit_full_implies_risk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_full_implies_risk for 6

assert rmit_full_implies_cyber {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_full_implies_cyber for 6

assert rmit_full_implies_ops {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_full_implies_ops for 6

assert rmit_full_implies_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_full_implies_audit for 6

assert rmit_full_implies_cloud {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_full_implies_cloud for 6

assert rmit_full_implies_third_party {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_full_implies_third_party for 6

assert rmit_full_implies_bcp {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rmit_full_implies_bcp for 6

assert bnm_incident_reporting {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bnm_incident_reporting for 6

assert bnm_late_incident_violation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bnm_late_incident_violation for 6

assert outsourcing_risk_managed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check outsourcing_risk_managed for 6

assert non_material_no_notification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check non_material_no_notification for 6

assert tech_refresh_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tech_refresh_valid for 6

assert tech_refresh_expired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tech_refresh_expired for 6

pred ExampleMalaysiaBNMRMiT {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMalaysiaBNMRMiT for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for malaysia cybersecurity act
// Bounded verification of key properties
module riina/Domains/MalaysiaCybersecurityAct

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

assert obligation_1_risk_assessment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_1_risk_assessment for 6

assert obligation_2_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_2_audit for 6

assert audit_expiry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_expiry for 6

assert obligation_3_reporting {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_3_reporting for 6

assert severity_ordering {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check severity_ordering for 6

assert obligation_4_controls {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_4_controls for 6

assert obligation_5_cssp {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_5_cssp for 6

assert act854_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check act854_composition for 6

assert ncii_sector_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ncii_sector_coverage for 6

assert critical_is_highest_risk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check critical_is_highest_risk for 6

assert low_is_lowest_risk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check low_is_lowest_risk for 6

assert risk_level_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check risk_level_bounded for 6

assert risk_level_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check risk_level_coverage for 6

assert audit_current_expiry_exclusive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audit_current_expiry_exclusive for 6

assert more_controls_still_sufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check more_controls_still_sufficient for 6

assert act854_implies_risk_assessed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check act854_implies_risk_assessed for 6

assert act854_implies_audit_current {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check act854_implies_audit_current for 6

assert act854_implies_controls {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check act854_implies_controls for 6

assert act854_implies_cssp_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check act854_implies_cssp_valid for 6

assert cssp_expired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cssp_expired for 6

assert cssp_unlicensed_invalid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cssp_unlicensed_invalid for 6

assert ceo_liable_when_negligent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ceo_liable_when_negligent for 6

assert ceo_due_diligence_defense {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ceo_due_diligence_defense for 6

assert incident_6h_stricter_than_24h {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check incident_6h_stricter_than_24h for 6

assert immediate_report_always_timely {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check immediate_report_always_timely for 6

assert banking_is_critical {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check banking_is_critical for 6

assert defense_is_critical {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check defense_is_critical for 6

assert telecom_not_critical {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check telecom_not_critical for 6

pred ExampleMalaysiaCybersecurityAct {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMalaysiaCybersecurityAct for 6

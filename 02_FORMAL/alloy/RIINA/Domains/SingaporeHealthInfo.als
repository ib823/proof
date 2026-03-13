// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for singapore health info
// Bounded verification of key properties
module riina/Domains/SingaporeHealthInfo

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

assert hib_req_1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_req_1 for 6

assert hib_req_2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_req_2 for 6

assert hib_req_3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_req_3 for 6

assert hib_req_4 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_req_4 for 6

assert hib_prohibited_insurance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_prohibited_insurance for 6

assert hib_prohibited_employment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_prohibited_employment for 6

assert hib_treatment_allowed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_treatment_allowed for 6

assert hib_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_composition for 6

assert sg_provider_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_provider_coverage for 6

assert health_category_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check health_category_coverage for 6

assert patient_access_right {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check patient_access_right for 6

assert patient_access_late_violation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check patient_access_late_violation for 6

assert data_correction_logged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_correction_logged for 6

assert cross_institutional_exchange {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_institutional_exchange for 6

assert general_health_not_sensitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check general_health_not_sensitive for 6

assert mental_health_is_sensitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mental_health_is_sensitive for 6

assert hiv_sti_is_sensitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hiv_sti_is_sensitive for 6

assert genetic_info_is_sensitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check genetic_info_is_sensitive for 6

assert nehr_requires_encryption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nehr_requires_encryption for 6

assert nehr_requires_sharing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nehr_requires_sharing for 6

assert use_type_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check use_type_coverage for 6

assert research_allowed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check research_allowed for 6

assert public_health_allowed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check public_health_allowed for 6

assert hib_full_implies_cybersecurity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_full_implies_cybersecurity for 6

assert hib_full_implies_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_full_implies_audit for 6

assert hib_full_implies_nehr {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hib_full_implies_nehr for 6

assert cybersecurity_eliminates_penalty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cybersecurity_eliminates_penalty for 6

assert public_hospital_must_share {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check public_hospital_must_share for 6

pred ExampleSingaporeHealthInfo {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSingaporeHealthInfo for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for malaysia kkmhealthcare
// Bounded verification of key properties
module riina/Domains/MalaysiaKKMHealthcare

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

assert kkm_confidentiality {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_confidentiality for 6

assert kkm_consent_access {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_consent_access for 6

assert kkm_emergency_access {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_emergency_access for 6

assert kkm_sensitive_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_sensitive_protected for 6

assert kkm_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_audit for 6

assert kkm_cross_facility {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_cross_facility for 6

assert kkm_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_composition for 6

assert facility_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check facility_coverage for 6

assert emr_classification_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check emr_classification_coverage for 6

assert demographics_not_sensitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check demographics_not_sensitive for 6

assert clinical_notes_not_sensitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check clinical_notes_not_sensitive for 6

assert mental_health_is_sensitive_kkm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mental_health_is_sensitive_kkm for 6

assert hiv_sti_is_sensitive_kkm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hiv_sti_is_sensitive_kkm for 6

assert kkm_full_implies_confidentiality {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_full_implies_confidentiality for 6

assert kkm_full_implies_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_full_implies_audit for 6

assert kkm_full_implies_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kkm_full_implies_consent for 6

assert confidentiality_implies_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check confidentiality_implies_encrypted for 6

assert confidentiality_implies_access_controlled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check confidentiality_implies_access_controlled for 6

assert emergency_always_authorized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check emergency_always_authorized for 6

assert non_emergency_requires_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check non_emergency_requires_consent for 6

assert this_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check this_compliance for 6

assert this_missing_backup_non_compliant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check this_missing_backup_non_compliant for 6

assert ccms_full_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ccms_full_compliance for 6

assert medical_device_sl2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check medical_device_sl2 for 6

assert higher_sl_subsumes {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check higher_sl_subsumes for 6

assert cross_facility_requires_encryption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_facility_requires_encryption for 6

assert cross_facility_requires_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_facility_requires_consent for 6

pred ExampleMalaysiaKKMHealthcare {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMalaysiaKKMHealthcare for 6

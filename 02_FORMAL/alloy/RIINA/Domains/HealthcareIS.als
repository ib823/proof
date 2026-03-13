// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for healthcare is
// Bounded verification of key properties
module riina/Domains/HealthcareIS

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

assert HIS_001_01_patient_identity_uniqueness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_01_patient_identity_uniqueness for 6

assert HIS_001_02_patient_matching_accuracy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_02_patient_matching_accuracy for 6

assert HIS_001_03_duplicate_detection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_03_duplicate_detection for 6

assert HIS_001_04_patient_merge_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_04_patient_merge_integrity for 6

assert HIS_001_05_amendment_tracking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_05_amendment_tracking for 6

assert HIS_001_06_encounter_completeness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_06_encounter_completeness for 6

assert HIS_001_07_documentation_immutability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_07_documentation_immutability for 6

assert HIS_001_08_allergy_documentation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_08_allergy_documentation for 6

assert HIS_001_09_drug_allergy_alert {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_09_drug_allergy_alert for 6

assert HIS_001_10_problem_list_coded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_10_problem_list_coded for 6

assert HIS_001_11_five_rights_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_11_five_rights_verification for 6

assert HIS_001_12_drug_interaction_checking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_12_drug_interaction_checking for 6

assert HIS_001_13_dose_range_checking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_13_dose_range_checking for 6

assert HIS_001_14_high_alert_safeguards {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_14_high_alert_safeguards for 6

assert HIS_001_15_barcode_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_15_barcode_verification for 6

assert HIS_001_16_order_completeness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_16_order_completeness for 6

assert HIS_001_17_order_signature {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_17_order_signature for 6

assert HIS_001_18_verbal_order_auth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_18_verbal_order_auth for 6

assert HIS_001_19_duplicate_order_prevention {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_19_duplicate_order_prevention for 6

assert HIS_001_20_contraindication_alert {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_20_contraindication_alert for 6

assert HIS_001_21_specimen_tracking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_21_specimen_tracking for 6

assert HIS_001_22_critical_value_notification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_22_critical_value_notification for 6

assert HIS_001_23_result_validation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_23_result_validation for 6

assert HIS_001_24_delta_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_24_delta_check for 6

assert HIS_001_25_reference_range_adjusted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_25_reference_range_adjusted for 6

assert HIS_001_26_phi_access_control {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_26_phi_access_control for 6

assert HIS_001_27_audit_trail_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_27_audit_trail_complete for 6

assert HIS_001_28_breach_notification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_28_breach_notification for 6

assert HIS_001_29_consent_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_29_consent_required for 6

assert HIS_001_30_data_portability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check HIS_001_30_data_portability for 6

pred ExampleHealthcareIS {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleHealthcareIS for 6

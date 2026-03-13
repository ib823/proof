// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for malaysia pdpa
// Bounded verification of key properties
module riina/Domains/MalaysiaPDPA

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

assert principle_1_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_1_consent for 6

assert principle_1_personal_data {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_1_personal_data for 6

assert principle_1_public_exempt {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_1_public_exempt for 6

assert consent_withdrawal_blocks {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check consent_withdrawal_blocks for 6

assert principle_2_purpose_limitation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_2_purpose_limitation for 6

assert principle_3_sensitive_explicit_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_3_sensitive_explicit_only for 6

assert principle_4_encryption_mandatory {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_4_encryption_mandatory for 6

assert principle_4_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_4_security for 6

assert principle_5_retention {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_5_retention for 6

assert retention_delete_exclusive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check retention_delete_exclusive for 6

assert principle_6_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_6_integrity for 6

assert principle_7_access_logged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principle_7_access_logged for 6

assert breach_notification_ordering {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check breach_notification_ordering for 6

assert pdpc_deadline_stricter {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pdpc_deadline_stricter for 6

assert dpo_mandatory {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dpo_mandatory for 6

assert pdpa_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pdpa_composition for 6

assert data_collection_consent_recorded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_collection_consent_recorded for 6

assert cross_border_transfer_authorized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_border_transfer_authorized for 6

assert cross_border_consent_basis {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_border_consent_basis for 6

assert data_breach_notification_timely {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_breach_notification_timely for 6

assert data_subject_access_fulfilled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_subject_access_fulfilled for 6

assert access_late_response_violation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check access_late_response_violation for 6

assert data_retention_period_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_retention_period_enforced for 6

assert data_accuracy_maintained {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_accuracy_maintained for 6

assert accuracy_expiry_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accuracy_expiry_detected for 6

assert security_measures_proportionate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check security_measures_proportionate for 6

assert sensitive_needs_more_controls {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensitive_needs_more_controls for 6

assert processor_contract_binding {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check processor_contract_binding for 6

assert dpia_conducted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dpia_conducted for 6

assert dpia_incomplete_if_risks_unmitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dpia_incomplete_if_risks_unmitigated for 6

assert children_data_additional_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check children_data_additional_consent for 6

assert adult_own_consent_sufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check adult_own_consent_sufficient for 6

assert marketing_consent_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check marketing_consent_required for 6

assert marketing_without_explicit_violates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check marketing_without_explicit_violates for 6

assert complaint_mechanism_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check complaint_mechanism_valid for 6

assert pdpa_commissioner_reportable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pdpa_commissioner_reportable for 6

assert late_report_non_compliant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check late_report_non_compliant for 6

assert public_data_lowest_harm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check public_data_lowest_harm for 6

assert sensitive_data_highest_harm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensitive_data_highest_harm for 6

assert consent_status_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check consent_status_coverage for 6

assert transfer_basis_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transfer_basis_coverage for 6

pred ExampleMalaysiaPDPA {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMalaysiaPDPA for 6

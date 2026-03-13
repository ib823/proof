// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for singapore pdpa
// Bounded verification of key properties
module riina/Domains/SingaporePDPA

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

assert obligation_1_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_1_consent for 6

assert obligation_1_business_exempt {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_1_business_exempt for 6

assert consent_withdrawal_effect {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check consent_withdrawal_effect for 6

assert obligation_2_purpose {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_2_purpose for 6

assert obligation_6_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_6_encrypted for 6

assert obligation_6_anonymized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_6_anonymized for 6

assert obligation_7_retention {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_7_retention for 6

assert obligation_8_adequate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_8_adequate for 6

assert obligation_8_contractual {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_8_contractual for 6

assert obligation_8_no_safeguards_blocked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_8_no_safeguards_blocked for 6

assert obligation_9_notification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check obligation_9_notification for 6

assert sg_pdpa_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_pdpa_composition for 6

assert purpose_limitation_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check purpose_limitation_enforced for 6

assert purpose_match_no_violation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check purpose_match_no_violation for 6

assert notification_obligation_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check notification_obligation_valid for 6

assert access_correction_right {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check access_correction_right for 6

assert correction_within_deadline {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check correction_within_deadline for 6

assert transfer_limitation_satisfied {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transfer_limitation_satisfied for 6

assert data_protection_officer_appointed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_protection_officer_appointed for 6

assert do_not_call_registry_checked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check do_not_call_registry_checked for 6

assert dnc_not_registered_allows {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dnc_not_registered_allows for 6

assert breach_notification_72_hours {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check breach_notification_72_hours for 6

assert breach_not_notifiable_threshold {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check breach_not_notifiable_threshold for 6

assert deemed_consent_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check deemed_consent_valid for 6

assert deemed_consent_notification_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check deemed_consent_notification_valid for 6

assert business_improvement_exception {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check business_improvement_exception for 6

assert accountability_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accountability_complete for 6

assert data_anonymization_excludes {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_anonymization_excludes for 6

assert sg_consent_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_consent_coverage for 6

assert sg_data_category_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sg_data_category_coverage for 6

assert transfer_adequacy_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transfer_adequacy_coverage for 6

assert notification_purposes_nonempty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check notification_purposes_nonempty for 6

assert notification_first_purpose_notified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check notification_first_purpose_notified for 6

assert access_deadline_monotone {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check access_deadline_monotone for 6

assert access_request_immediate_response {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check access_request_immediate_response for 6

assert accuracy_within_interval {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accuracy_within_interval for 6

assert accuracy_stale_requires_reverification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accuracy_stale_requires_reverification for 6

assert dnc_registered_blocks_all_marketing_types {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dnc_registered_blocks_all_marketing_types for 6

assert dnc_exempt_allows_marketing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dnc_exempt_allows_marketing for 6

assert dnc_status_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dnc_status_decidable for 6

assert portability_obligation_met {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check portability_obligation_met for 6

assert portability_late_response_violation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check portability_late_response_violation for 6

assert portability_requires_standard_format {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check portability_requires_standard_format for 6

assert pdpc_penalty_cap_respected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pdpc_penalty_cap_respected for 6

assert pdpc_minor_breach_no_fine {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pdpc_minor_breach_no_fine for 6

assert pdpc_moderate_breach_half_cap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pdpc_moderate_breach_half_cap for 6

assert pdpc_severe_breach_full_cap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pdpc_severe_breach_full_cap for 6

assert consent_explicit_always_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check consent_explicit_always_valid for 6

assert no_consent_personal_data_violation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_consent_personal_data_violation for 6

assert public_data_no_consent_needed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check public_data_no_consent_needed for 6

assert retention_within_implies_not_dispose {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check retention_within_implies_not_dispose for 6

assert retention_dispose_exclusive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check retention_dispose_exclusive for 6

assert retention_at_limit_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check retention_at_limit_valid for 6

assert retention_past_limit_dispose {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check retention_past_limit_dispose for 6

assert cross_border_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_border_composition for 6

assert cross_border_no_safeguards_fails {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_border_no_safeguards_fails for 6

assert individual_notification_harm_assessment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check individual_notification_harm_assessment for 6

assert no_harm_no_individual_notification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_harm_no_individual_notification for 6

assert breach_500_is_notifiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check breach_500_is_notifiable for 6

assert breach_harm_is_notifiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check breach_harm_is_notifiable for 6

assert dpo_qualified_implies_appointed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dpo_qualified_implies_appointed for 6

assert dpo_not_trained_not_qualified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dpo_not_trained_not_qualified for 6

assert enterprise_compliance_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check enterprise_compliance_composition for 6

assert processing_basis_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check processing_basis_coverage for 6

assert pdpc_direction_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pdpc_direction_coverage for 6

assert withdrawal_halts_processing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check withdrawal_halts_processing for 6

assert active_processing_implies_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check active_processing_implies_consent for 6

pred ExampleSingaporePDPA {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSingaporePDPA for 6

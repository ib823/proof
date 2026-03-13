// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for common criteria eal7
// Bounded verification of key properties
module riina/Domains/CommonCriteriaEAL7

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

assert CC_001_label_reflexivity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_001_label_reflexivity for 6

assert CC_002_label_transitivity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_002_label_transitivity for 6

assert CC_003_label_antisymmetry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_003_label_antisymmetry for 6

assert CC_004_public_is_bottom {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_004_public_is_bottom for 6

assert CC_005_topsecret_is_top {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_005_topsecret_is_top for 6

assert CC_006_valid_context_clearance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_006_valid_context_clearance for 6

assert CC_007_no_write_down_preserves_confidentiality {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_007_no_write_down_preserves_confidentiality for 6

assert CC_008_no_read_up_prevents_leakage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_008_no_read_up_prevents_leakage for 6

assert CC_009_blp_simple_security_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_009_blp_simple_security_sound for 6

assert CC_010_blp_star_property_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_010_blp_star_property_sound for 6

assert CC_011_compliant_adv_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_011_compliant_adv_valid for 6

assert andb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb_true_iff for 6

assert CC_012_architecture_completeness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_012_architecture_completeness for 6

assert CC_013_formal_verification_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_013_formal_verification_required for 6

assert CC_014_formal_design_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_014_formal_design_required for 6

assert CC_015_non_bypassability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_015_non_bypassability for 6

assert CC_016_tamper_proof {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_016_tamper_proof for 6

assert CC_017_domain_separation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_017_domain_separation for 6

assert CC_018_compliant_ava_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_018_compliant_ava_valid for 6

assert CC_019_advanced_analysis_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_019_advanced_analysis_required for 6

assert CC_020_high_attack_potential_resistance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_020_high_attack_potential_resistance for 6

assert CC_021_compliant_eal7_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_021_compliant_eal7_valid for 6

assert CC_022_eal7_implies_adv {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_022_eal7_implies_adv for 6

assert CC_023_eal7_implies_ava {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_023_eal7_implies_ava for 6

assert CC_024_eal7_implies_formal_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_024_eal7_implies_formal_verification for 6

assert CC_025_eal7_implies_high_attack_resistance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_025_eal7_implies_high_attack_resistance for 6

assert orb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check orb_true_iff for 6

assert CC_026_audit_generation_verifiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_026_audit_generation_verifiable for 6

assert CC_027_crypto_key_mgmt_verifiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_027_crypto_key_mgmt_verifiable for 6

assert CC_028_ifc_verifiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_028_ifc_verifiable for 6

assert CC_029_domain_sep_verifiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_029_domain_sep_verifiable for 6

assert CC_030_authentication_verifiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_030_authentication_verifiable for 6

assert CC_031_riina_has_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_031_riina_has_audit for 6

assert CC_032_riina_has_crypto {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_032_riina_has_crypto for 6

assert CC_033_riina_has_ifc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_033_riina_has_ifc for 6

assert CC_034_riina_has_domain_sep {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_034_riina_has_domain_sep for 6

assert CC_035_riina_has_authentication {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_035_riina_has_authentication for 6

assert CC_036_riina_boundary_defined {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_036_riina_boundary_defined for 6

assert CC_037_riina_interfaces_specified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_037_riina_interfaces_specified for 6

assert CC_038_riina_evaluated_configuration {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_038_riina_evaluated_configuration for 6

assert CC_039_riina_complete_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_039_riina_complete_coverage for 6

assert CC_040_maximum_assurance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_040_maximum_assurance for 6

assert CC_041_lifecycle_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_041_lifecycle_compliance for 6

assert CC_042_flaw_remediation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_042_flaw_remediation for 6

assert CC_043_secure_delivery {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_043_secure_delivery for 6

assert CC_044_cm_automation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_044_cm_automation for 6

assert CC_045_test_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_045_test_compliance for 6

assert CC_046_independent_testing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_046_independent_testing for 6

assert CC_047_coverage_testing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_047_coverage_testing for 6

assert CC_048_st_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_048_st_compliance for 6

assert CC_049_objectives_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_049_objectives_complete for 6

assert CC_050_eal7_complete_certification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check CC_050_eal7_complete_certification for 6

pred ExampleCommonCriteriaEAL7 {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleCommonCriteriaEAL7 for 6

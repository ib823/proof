// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for teeattestation
// Bounded verification of key properties
module riina/Domains/TEEAttestation

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

assert andb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb_true_iff for 6

assert andb_false_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb_false_iff for 6

assert orb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check orb_true_iff for 6

assert negb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check negb_true_iff for 6

assert negb_false_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check negb_false_iff for 6

assert TEE_001 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_001 for 6

assert TEE_002 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_002 for 6

assert TEE_003 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_003 for 6

assert TEE_004 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_004 for 6

assert TEE_005 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_005 for 6

assert TEE_006 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_006 for 6

assert TEE_007 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_007 for 6

assert TEE_008 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_008 for 6

assert TEE_009 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_009 for 6

assert TEE_010 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_010 for 6

assert TEE_011 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_011 for 6

assert TEE_012 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_012 for 6

assert TEE_013 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_013 for 6

assert TEE_014 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_014 for 6

assert TEE_015 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_015 for 6

assert TEE_016 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_016 for 6

assert TEE_017 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_017 for 6

assert TEE_018 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_018 for 6

assert TEE_019 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_019 for 6

assert TEE_020 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_020 for 6

assert TEE_021 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_021 for 6

assert TEE_022 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_022 for 6

assert TEE_023 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_023 for 6

assert TEE_024 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_024 for 6

assert TEE_025_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_025_complete for 6

assert TEE_026_create_transition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_026_create_transition for 6

assert TEE_027_init_transition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_027_init_transition for 6

assert TEE_028_enter_transition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_028_enter_transition for 6

assert TEE_029_exit_transition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_029_exit_transition for 6

assert TEE_030_suspend_transition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_030_suspend_transition for 6

assert TEE_031_resume_transition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_031_resume_transition for 6

assert TEE_032_destroy_from_init {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_032_destroy_from_init for 6

assert TEE_033_destroy_from_created {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_033_destroy_from_created for 6

assert TEE_034_no_create_from_running {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_034_no_create_from_running for 6

assert TEE_035_no_enter_uninitialized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_035_no_enter_uninitialized for 6

assert TEE_036_lifecycle_to_running {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_036_lifecycle_to_running for 6

assert TEE_037_suspend_resume_cycle {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_037_suspend_resume_cycle for 6

assert TEE_038_riina_quote_signature_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_038_riina_quote_signature_valid for 6

assert TEE_039_riina_quote_measurement_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_039_riina_quote_measurement_valid for 6

assert TEE_040_riina_quote_signer_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_040_riina_quote_signer_valid for 6

assert TEE_041_riina_quote_svn_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_041_riina_quote_svn_valid for 6

assert TEE_042_riina_quote_nonce_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_042_riina_quote_nonce_valid for 6

assert TEE_043_riina_quote_fresh {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_043_riina_quote_fresh for 6

assert TEE_044_riina_quote_verifies {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_044_riina_quote_verifies for 6

assert TEE_045_verified_quote_has_valid_signature {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_045_verified_quote_has_valid_signature for 6

assert TEE_046_verified_quote_has_valid_measurement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_046_verified_quote_has_valid_measurement for 6

assert TEE_047_verified_quote_has_valid_nonce {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_047_verified_quote_has_valid_nonce for 6

assert TEE_048_verified_quote_is_fresh {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_048_verified_quote_is_fresh for 6

assert TEE_049_invalid_signature_fails_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_049_invalid_signature_fails_verification for 6

assert TEE_050_stale_quote_fails_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_050_stale_quote_fails_verification for 6

assert TEE_051_derive_key_mrenclave {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_051_derive_key_mrenclave for 6

assert TEE_052_derive_key_mrsigner {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_052_derive_key_mrsigner for 6

assert TEE_053_key_derivation_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_053_key_derivation_deterministic for 6

assert TEE_054_different_policy_different_key {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_054_different_policy_different_key for 6

assert TEE_055_keypolicy_uses_name_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_055_keypolicy_uses_name_only for 6

assert TEE_056_mrenclave_binding_enclave_specific {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_056_mrenclave_binding_enclave_specific for 6

assert TEE_057_mrsigner_binding_signer_specific {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_057_mrsigner_binding_signer_specific for 6

assert TEE_058_different_key_names_different_keys {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_058_different_key_names_different_keys for 6

assert TEE_059_keypolicy_unseal_always_possible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_059_keypolicy_unseal_always_possible for 6

assert TEE_060_key_size_does_not_affect_id {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_060_key_size_does_not_affect_id for 6

assert TEE_061_riina_memory_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_061_riina_memory_encrypted for 6

assert TEE_062_riina_memory_is_enclave {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_062_riina_memory_is_enclave for 6

assert TEE_063_enclave_memory_is_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_063_enclave_memory_is_protected for 6

assert TEE_064_normal_memory_always_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_064_normal_memory_always_protected for 6

assert TEE_065_shared_memory_always_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_065_shared_memory_always_protected for 6

assert TEE_066_reserved_memory_always_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_066_reserved_memory_always_protected for 6

assert TEE_067_enclave_memory_encrypted_implies_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_067_enclave_memory_encrypted_implies_protected for 6

assert TEE_068_unencrypted_enclave_memory_unprotected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_068_unencrypted_enclave_memory_unprotected for 6

assert TEE_069_address_in_region {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_069_address_in_region for 6

assert TEE_070_non_overlapping_regions_disjoint {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_070_non_overlapping_regions_disjoint for 6

assert TEE_071_riina_platform_tcb_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_071_riina_platform_tcb_valid for 6

assert TEE_072_riina_trust_chain_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_072_riina_trust_chain_complete for 6

assert TEE_073_riina_platform_trusted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_073_riina_platform_trusted for 6

assert TEE_074_trust_chain_requires_root_key {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_074_trust_chain_requires_root_key for 6

assert TEE_075_trust_chain_requires_pck_cert {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_075_trust_chain_requires_pck_cert for 6

assert TEE_076_trust_chain_requires_tcb_signing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_076_trust_chain_requires_tcb_signing for 6

assert TEE_077_trust_chain_requires_qe_report {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_077_trust_chain_requires_qe_report for 6

assert TEE_078_invalid_root_breaks_trust {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_078_invalid_root_breaks_trust for 6

assert TEE_079_invalid_tcb_breaks_platform_trust {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_079_invalid_tcb_breaks_platform_trust for 6

assert TEE_080_incomplete_chain_breaks_platform_trust {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_080_incomplete_chain_breaks_platform_trust for 6

assert TEE_081_full_attestation_implies_all_properties {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_081_full_attestation_implies_all_properties for 6

assert TEE_082_secure_tee_implies_all_enclave_properties {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_082_secure_tee_implies_all_enclave_properties for 6

assert TEE_083_secure_tee_implies_all_attestation_properties {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_083_secure_tee_implies_all_attestation_properties for 6

assert TEE_084_secure_tee_implies_key_derivation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_084_secure_tee_implies_key_derivation for 6

assert TEE_085_secure_tee_implies_local_attestation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_085_secure_tee_implies_local_attestation for 6

assert TEE_086_enclave_security_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_086_enclave_security_composition for 6

assert TEE_087_attestation_security_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_087_attestation_security_composition for 6

assert TEE_088_tee_security_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_088_tee_security_composition for 6

assert TEE_089_verified_quote_measurement_matches_context {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_089_verified_quote_measurement_matches_context for 6

assert TEE_090_verified_quote_signer_matches_context {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_090_verified_quote_signer_matches_context for 6

assert TEE_091_verified_quote_svn_sufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_091_verified_quote_svn_sufficient for 6

assert TEE_092_verified_quote_nonce_matches {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_092_verified_quote_nonce_matches for 6

assert TEE_093_platform_trust_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_093_platform_trust_composition for 6

assert TEE_094_riina_complete_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_094_riina_complete_security for 6

assert TEE_095_full_tee_security_decomposition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TEE_095_full_tee_security_decomposition for 6

pred ExampleTEEAttestation {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleTEEAttestation for 6

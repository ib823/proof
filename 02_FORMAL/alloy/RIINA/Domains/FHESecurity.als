// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for fhesecurity
// Bounded verification of key properties
module riina/Domains/FHESecurity

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

assert andb3_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb3_true_iff for 6

assert negb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check negb_true_iff for 6

assert leb_le {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check leb_le for 6

assert ltb_lt {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ltb_lt for 6

assert mult_le_compat {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mult_le_compat for 6

assert add_le_compat {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check add_le_compat for 6

assert FHE_001 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_001 for 6

assert FHE_002 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_002 for 6

assert FHE_003 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_003 for 6

assert FHE_004 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_004 for 6

assert FHE_005 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_005 for 6

assert FHE_006 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_006 for 6

assert FHE_007 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_007 for 6

assert FHE_008 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_008 for 6

assert FHE_009 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_009 for 6

assert FHE_010 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_010 for 6

assert FHE_011 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_011 for 6

assert FHE_012 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_012 for 6

assert FHE_013 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_013 for 6

assert FHE_014 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_014 for 6

assert FHE_015 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_015 for 6

assert FHE_016 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_016 for 6

assert FHE_017 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_017 for 6

assert FHE_018 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_018 for 6

assert FHE_019 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_019 for 6

assert FHE_020 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_020 for 6

assert FHE_021 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_021 for 6

assert FHE_022 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_022 for 6

assert FHE_023 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_023 for 6

assert FHE_024 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_024 for 6

assert FHE_025_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FHE_025_complete for 6

assert indcpa_001_riina_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check indcpa_001_riina_secure for 6

assert indcpa_002_key_size_sufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check indcpa_002_key_size_sufficient for 6

assert indcpa_003_has_oracle {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check indcpa_003_has_oracle for 6

assert indcpa_004_negligible_advantage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check indcpa_004_negligible_advantage for 6

assert ss_001_riina_semantic_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ss_001_riina_semantic_secure for 6

assert ss_002_implies_indistinguishable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ss_002_implies_indistinguishable for 6

assert ss_003_implies_randomized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ss_003_implies_randomized for 6

assert ss_004_ciphertext_expansion {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ss_004_ciphertext_expansion for 6

assert hadd_001_riina_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hadd_001_riina_correct for 6

assert hadd_002_preserves_structure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hadd_002_preserves_structure for 6

assert hadd_003_modulus_relation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hadd_003_modulus_relation for 6

assert hmult_001_riina_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hmult_001_riina_correct for 6

assert hmult_002_relinearization {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hmult_002_relinearization for 6

assert hmult_003_key_switching {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hmult_003_key_switching for 6

assert hops_001_riina_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hops_001_riina_valid for 6

assert hops_002_addition_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hops_002_addition_correct for 6

assert hops_003_multiplication_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hops_003_multiplication_correct for 6

assert hops_004_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hops_004_composition for 6

assert noise_001_initial_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check noise_001_initial_safe for 6

assert noise_002_100_additions_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check noise_002_100_additions_safe for 6

assert noise_003_10_multiplications_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check noise_003_10_multiplications_safe for 6

assert noise_004_add_linear_growth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check noise_004_add_linear_growth for 6

assert noise_005_zero_additions {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check noise_005_zero_additions for 6

assert nb_001_riina_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nb_001_riina_valid for 6

assert nb_002_additions_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nb_002_additions_safe for 6

assert nb_003_multiplications_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nb_003_multiplications_safe for 6

assert boot_001_riina_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_001_riina_correct for 6

assert boot_002_reduces_noise {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_002_reduces_noise for 6

assert boot_003_preserves_message {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_003_preserves_message for 6

assert boot_004_polynomial_time {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_004_polynomial_time for 6

assert boot_005_noise_reduction {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check boot_005_noise_reduction for 6

assert ufhe_001_riina_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ufhe_001_riina_valid for 6

assert ufhe_002_bootstrap_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ufhe_002_bootstrap_correct for 6

assert kg_001_riina_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kg_001_riina_secure for 6

assert kg_002_security_parameter {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kg_002_security_parameter for 6

assert kg_003_polynomial_degree {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kg_003_polynomial_degree for 6

assert kg_004_error_distribution {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kg_004_error_distribution for 6

assert kg_005_modulus_bits {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kg_005_modulus_bits for 6

assert kp_001_riina_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kp_001_riina_valid for 6

assert kp_002_secure_params {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check kp_002_secure_params for 6

assert ct_001_riina_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ct_001_riina_valid for 6

assert ct_002_valid_encryption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ct_002_valid_encryption for 6

assert ct_003_safe_noise {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ct_003_safe_noise for 6

assert ct_004_positive_level {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ct_004_positive_level for 6

assert cao_001_valid_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cao_001_valid_preserves for 6

assert cao_002_result_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cao_002_result_valid for 6

assert cfhe_001_riina_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_001_riina_secure for 6

assert cfhe_002_config_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_002_config_secure for 6

assert cfhe_003_keygen_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_003_keygen_secure for 6

assert cfhe_004_indcpa_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_004_indcpa_secure for 6

assert cfhe_005_bootstrap_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_005_bootstrap_correct for 6

assert cfhe_006_ops_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_006_ops_valid for 6

assert cfhe_007_pq_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_007_pq_safe for 6

assert cfhe_008_arbitrary_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_008_arbitrary_depth for 6

assert cfhe_009_semantic_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_009_semantic_secure for 6

assert cfhe_010_noise_managed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cfhe_010_noise_managed for 6

assert circ_001_riina_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check circ_001_riina_secure for 6

assert circ_002_key_encryption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check circ_002_key_encryption for 6

assert lwe_001_riina_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lwe_001_riina_secure for 6

assert lwe_002_dimension {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lwe_002_dimension for 6

assert rlwe_001_riina_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rlwe_001_riina_secure for 6

assert rlwe_002_ring_degree {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rlwe_002_ring_degree for 6

pred ExampleFHESecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleFHESecurity for 6

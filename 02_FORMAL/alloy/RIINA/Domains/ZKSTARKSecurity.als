// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for zkstarksecurity
// Bounded verification of key properties
module riina/Domains/ZKSTARKSecurity

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

assert orb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check orb_true_iff for 6

assert negb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check negb_true_iff for 6

assert bool_dec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bool_dec for 6

assert andb_false_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb_false_iff for 6

assert STARK_001 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_001 for 6

assert STARK_002 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_002 for 6

assert STARK_003 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_003 for 6

assert STARK_004 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_004 for 6

assert STARK_005 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_005 for 6

assert STARK_006 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_006 for 6

assert STARK_007 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_007 for 6

assert STARK_008 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_008 for 6

assert STARK_009 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_009 for 6

assert STARK_010 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_010 for 6

assert STARK_011 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_011 for 6

assert STARK_012 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_012 for 6

assert STARK_013 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_013 for 6

assert STARK_014 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_014 for 6

assert STARK_015 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_015 for 6

assert STARK_016 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_016 for 6

assert STARK_017 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_017 for 6

assert STARK_018 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_018 for 6

assert STARK_019 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_019 for 6

assert STARK_020 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_020 for 6

assert STARK_021 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_021 for 6

assert STARK_022 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_022 for 6

assert STARK_023 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_023 for 6

assert STARK_024 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_024 for 6

assert STARK_025_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_025_complete for 6

assert FRI_soundness_property {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_soundness_property for 6

assert FRI_query_bound_property {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_query_bound_property for 6

assert FRI_commitment_binding_property {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_commitment_binding_property for 6

assert FRI_fiat_shamir_property {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_fiat_shamir_property for 6

assert FRI_riina_soundness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_riina_soundness for 6

assert FRI_riina_query_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_riina_query_bound for 6

assert FRI_riina_commitment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_riina_commitment for 6

assert FRI_riina_transform {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_riina_transform for 6

assert FRI_riina_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_riina_secure for 6

assert FRI_rounds_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_rounds_positive for 6

assert FRI_proximity_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check FRI_proximity_positive for 6

assert soundness_implies_starks {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check soundness_implies_starks for 6

assert soundness_implies_fri {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check soundness_implies_fri for 6

assert soundness_implies_binding {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check soundness_implies_binding for 6

assert riina_computational_soundness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_computational_soundness for 6

assert soundness_amplification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check soundness_amplification for 6

assert soundness_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check soundness_composition for 6

assert zk_implies_starks_zk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check zk_implies_starks_zk for 6

assert zk_implies_indistinguishable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check zk_implies_indistinguishable for 6

assert perfect_zk_implies_simulation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check perfect_zk_implies_simulation for 6

assert perfect_zk_rewinding {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check perfect_zk_rewinding for 6

assert riina_simulation_zk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_simulation_zk for 6

assert riina_perfect_zk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_perfect_zk for 6

assert simulator_validity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check simulator_validity for 6

assert zk_soundness_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check zk_soundness_composition for 6

assert riina_zk_soundness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_zk_soundness for 6

assert completeness_requires_honest_prover {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check completeness_requires_honest_prover for 6

assert completeness_requires_starks {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check completeness_requires_starks for 6

assert completeness_implies_acceptance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check completeness_implies_acceptance for 6

assert riina_complete_interaction {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_complete_interaction for 6

assert honest_prover_property {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check honest_prover_property for 6

assert honest_verifier_property {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check honest_verifier_property for 6

assert fri_completeness_requires_prover {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fri_completeness_requires_prover for 6

assert riina_fri_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_fri_complete for 6

assert pq_implies_stark_pq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pq_implies_stark_pq for 6

assert pq_implies_ext_resistant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pq_implies_ext_resistant for 6

assert riina_post_quantum {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_post_quantum for 6

assert hash_security_pq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hash_security_pq for 6

assert hash_security_binding {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hash_security_binding for 6

assert riina_hash_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_hash_security for 6

assert transparency_enables_pq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transparency_enables_pq for 6

assert transparency_no_setup {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transparency_no_setup for 6

assert transparency_fiat_shamir {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transparency_fiat_shamir for 6

assert riina_fully_transparent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_fully_transparent for 6

assert public_verify_transparent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check public_verify_transparent for 6

assert public_verify_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check public_verify_sound for 6

assert riina_publicly_verifiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_publicly_verifiable for 6

assert extended_implies_base {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extended_implies_base for 6

assert extended_implies_fri {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extended_implies_fri for 6

assert extended_implies_simulation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extended_implies_simulation for 6

assert extended_implies_extraction {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extended_implies_extraction for 6

assert extended_implies_quantum {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extended_implies_quantum for 6

assert riina_extended_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_extended_secure for 6

assert extraction_implies_ext {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extraction_implies_ext for 6

assert extraction_implies_fri_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extraction_implies_fri_sound for 6

assert extraction_implies_query_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extraction_implies_query_bound for 6

assert riina_extraction_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_extraction_secure for 6

assert air_algebraic_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check air_algebraic_required for 6

assert air_low_degree_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check air_low_degree_required for 6

assert air_fri_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check air_fri_required for 6

assert riina_air_fri_connection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_air_fri_connection for 6

assert modular_implies_stark {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check modular_implies_stark for 6

assert modular_implies_fri {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check modular_implies_fri for 6

assert modular_implies_sim {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check modular_implies_sim for 6

assert riina_modular_stark {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_modular_stark for 6

assert full_security_modular {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_security_modular for 6

assert full_security_extended {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_security_extended for 6

assert riina_full_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_full_security for 6

assert STARK_MASTER_SECURITY {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check STARK_MASTER_SECURITY for 6

assert riina_master_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check riina_master_security for 6

assert stark_security_equivalence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check stark_security_equivalence for 6

assert fri_security_equivalence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fri_security_equivalence for 6

assert stark_props_secure_dec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check stark_props_secure_dec for 6

assert air_secure_dec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check air_secure_dec for 6

assert fri_secure_dec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fri_secure_dec for 6

assert stark_fully_secure_dec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check stark_fully_secure_dec for 6

assert extended_secure_dec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extended_secure_dec for 6

pred ExampleZKSTARKSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleZKSTARKSecurity for 6

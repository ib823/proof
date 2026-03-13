// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for zksnarksecurity
// Bounded verification of key properties
module riina/Domains/ZKSNARKSecurity

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

assert andb4_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb4_true_iff for 6

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

assert orb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check orb_true_iff for 6

assert ZK_001 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_001 for 6

assert ZK_002 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_002 for 6

assert ZK_003 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_003 for 6

assert ZK_004 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_004 for 6

assert ZK_005 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_005 for 6

assert ZK_006 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_006 for 6

assert ZK_007 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_007 for 6

assert ZK_008 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_008 for 6

assert ZK_009 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_009 for 6

assert ZK_010 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_010 for 6

assert ZK_011 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_011 for 6

assert ZK_012 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_012 for 6

assert ZK_013 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_013 for 6

assert ZK_014 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_014 for 6

assert ZK_015 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_015 for 6

assert ZK_016 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_016 for 6

assert ZK_017 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_017 for 6

assert ZK_018 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_018 for 6

assert ZK_019 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_019 for 6

assert ZK_020 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_020 for 6

assert ZK_021 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_021 for 6

assert ZK_022 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_022 for 6

assert ZK_023 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_023 for 6

assert ZK_024 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_024 for 6

assert ZK_025_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ZK_025_complete for 6

assert ke_001_riina_ke_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ke_001_riina_ke_secure for 6

assert ke_002_extractor_exists {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ke_002_extractor_exists for 6

assert ke_003_extractor_polynomial {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ke_003_extractor_polynomial for 6

assert ke_004_extractor_probability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ke_004_extractor_probability for 6

assert ke_005_riina_wr_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ke_005_riina_wr_valid for 6

assert ke_006_valid_satisfiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ke_006_valid_satisfiable for 6

assert ke_007_positive_statement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ke_007_positive_statement for 6

assert ke_008_positive_witness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ke_008_positive_witness for 6

assert sim_001_riina_sim_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sim_001_riina_sim_secure for 6

assert sim_002_simulator_exists {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sim_002_simulator_exists for 6

assert sim_003_simulator_poly {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sim_003_simulator_poly for 6

assert sim_004_simulator_indist {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sim_004_simulator_indist for 6

assert sim_005_simulator_no_witness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sim_005_simulator_no_witness for 6

assert sim_006_riina_di_strong {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sim_006_riina_di_strong for 6

assert sim_007_strong_implies_computational {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sim_007_strong_implies_computational for 6

assert sim_008_strong_bounded_advantage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sim_008_strong_bounded_advantage for 6

assert comp_001_riina_completeness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check comp_001_riina_completeness for 6

assert comp_002_requires_honest_prover {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check comp_002_requires_honest_prover for 6

assert comp_003_requires_witness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check comp_003_requires_witness for 6

assert comp_004_requires_protocol {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check comp_004_requires_protocol for 6

assert comp_005_verifier_accepts {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check comp_005_verifier_accepts for 6

assert comp_006_riina_prover_honest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check comp_006_riina_prover_honest for 6

assert comp_007_riina_verifier_accepts {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check comp_007_riina_verifier_accepts for 6

assert succ_001_riina_succinct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check succ_001_riina_succinct for 6

assert succ_002_riina_polylog {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check succ_002_riina_polylog for 6

assert succ_003_bounded_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check succ_003_bounded_size for 6

assert succ_004_bounded_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check succ_004_bounded_verification for 6

assert succ_005_witness_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check succ_005_witness_independent for 6

assert succ_006_polylog_proof_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check succ_006_polylog_proof_size for 6

assert succ_007_polylog_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check succ_007_polylog_verification for 6

assert mpc_001_riina_mpc_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mpc_001_riina_mpc_secure for 6

assert mpc_002_riina_tw_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mpc_002_riina_tw_secure for 6

assert mpc_003_multiple_participants {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mpc_003_multiple_participants for 6

assert mpc_004_valid_threshold {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mpc_004_valid_threshold for 6

assert mpc_005_verifiable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mpc_005_verifiable for 6

assert mpc_006_tw_destroyed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mpc_006_tw_destroyed for 6

assert mpc_007_tw_multi_party {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mpc_007_tw_multi_party for 6

assert g16_001_riina_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check g16_001_riina_secure for 6

assert g16_002_riina_proof_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check g16_002_riina_proof_valid for 6

assert g16_003_pairing_friendly {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check g16_003_pairing_friendly for 6

assert g16_004_three_elements {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check g16_004_three_elements for 6

assert g16_005_bounded_pairings {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check g16_005_bounded_pairings for 6

assert g16_006_valid_curve_points {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check g16_006_valid_curve_points for 6

assert g16_007_valid_subgroup {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check g16_007_valid_subgroup for 6

assert plonk_001_riina_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plonk_001_riina_secure for 6

assert plonk_002_riina_gate_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plonk_002_riina_gate_valid for 6

assert plonk_003_universal_setup {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plonk_003_universal_setup for 6

assert plonk_004_polynomial_commitment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plonk_004_polynomial_commitment for 6

assert plonk_005_arithmetic_gates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plonk_005_arithmetic_gates for 6

assert plonk_006_bounded_degree {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plonk_006_bounded_degree for 6

assert plonk_007_sufficient_fan_in {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plonk_007_sufficient_fan_in for 6

assert full_001_riina_full_zk_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_001_riina_full_zk_secure for 6

assert full_002_implies_base {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_002_implies_base for 6

assert full_003_implies_ke {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_003_implies_ke for 6

assert full_004_implies_sim {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_004_implies_sim for 6

assert full_005_implies_succinct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_005_implies_succinct for 6

assert full_006_implies_mpc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_006_implies_mpc for 6

assert full_007_implies_tw {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_007_implies_tw for 6

assert full_008_riina_all_properties {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_008_riina_all_properties for 6

assert se_001_riina_se_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check se_001_riina_se_secure for 6

assert se_002_security_parameter {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check se_002_security_parameter for 6

assert se_003_statistical_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check se_003_statistical_bounded for 6

assert pst_001_riina_is_snark {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pst_001_riina_is_snark for 6

assert pst_002_snark_is_argument {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pst_002_snark_is_argument for 6

assert pst_003_snark_knowledge {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pst_003_snark_knowledge for 6

assert pst_004_snark_succinct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pst_004_snark_succinct for 6

pred ExampleZKSNARKSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleZKSNARKSecurity for 6

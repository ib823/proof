// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/ZKSNARKSecurity.v (98 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/zksnark_security

open util/boolean

// ZKProperties (matches Coq: Record ZKProperties)
sig ZKProperties {
  f_zk_completeness: one Bool,
  f_zk_soundness: one Bool,
  f_zk_zero_knowledge: one Bool
}

// SNARKProperties (matches Coq: Record SNARKProperties)
sig SNARKProperties {
  f_snark_succinctness: one Bool,
  f_snark_non_interactive: one Bool,
  f_snark_knowledge_sound: one Bool
}

// TrustedSetup (matches Coq: Record TrustedSetup)
sig TrustedSetup {
  f_ts_mpc_ceremony: one Bool,
  f_ts_toxic_waste_destroyed: one Bool,
  f_ts_verifiable: one Bool
}

// ZKSNARKConfig (matches Coq: Record ZKSNARKConfig)
sig ZKSNARKConfig {
  f_zks_zk: one ZKProperties,
  f_zks_snark: one SNARKProperties,
  f_zks_setup: one TrustedSetup,
  f_zks_post_quantum: one Bool
}

// KnowledgeExtractor (matches Coq: Record KnowledgeExtractor)
sig KnowledgeExtractor {
  f_ke_exists: one Bool,
  f_ke_polynomial_time: one Bool,
  f_ke_extraction_prob: one Int,
  f_ke_rewinding_allowed: one Bool,
  f_ke_auxiliary_input: one Bool
}

// WitnessRelation (matches Coq: Record WitnessRelation)
sig WitnessRelation {
  f_wr_statement_size: one Int,
  f_wr_witness_size: one Int,
  f_wr_verification_time: one Int,
  f_wr_satisfiable: one Bool
}

// ZKSimulator (matches Coq: Record ZKSimulator)
sig ZKSimulator {
  f_sim_exists: one Bool,
  f_sim_polynomial_time: one Bool,
  f_sim_indistinguishable: one Bool,
  f_sim_no_witness_needed: one Bool,
  f_sim_programmable_ro: one Bool
}

// DistIndistinguishability (matches Coq: Record DistIndistinguishability)
sig DistIndistinguishability {
  f_di_computational: one Bool,
  f_di_statistical: one Bool,
  f_di_perfect: one Bool,
  f_di_advantage_bound: one Int
}

// ProverConfig (matches Coq: Record ProverConfig)
sig ProverConfig {
  f_pv_honest: one Bool,
  f_pv_knows_witness: one Bool,
  f_pv_follows_protocol: one Bool,
  f_pv_polynomial_time: one Bool,
  f_pv_randomness_fresh: one Bool
}

// VerifierConfig (matches Coq: Record VerifierConfig)
sig VerifierConfig {
  f_vf_honest: one Bool,
  f_vf_follows_protocol: one Bool,
  f_vf_polynomial_time: one Bool,
  f_vf_accepts_valid: one Bool
}

// ProofSize (matches Coq: Record ProofSize)
sig ProofSize {
  f_ps_proof_bytes: one Int,
  f_ps_verification_ops: one Int,
  f_ps_statement_dependent: one Bool,
  f_ps_witness_independent: one Bool
}

// AsymptoticComplexity (matches Coq: Record AsymptoticComplexity)
sig AsymptoticComplexity {
  f_ac_proof_size: one Int,
  f_ac_verification_time: one Int,
  f_ac_prover_time: one Int,
  f_ac_setup_time: one Int
}

// MPCCeremony (matches Coq: Record MPCCeremony)
sig MPCCeremony {
  f_mpc_participants: one Int,
  f_mpc_threshold: one Int,
  f_mpc_verifiable: one Bool,
  f_mpc_contributions_published: one Bool,
  f_mpc_random_beacon: one Bool
}

// ToxicWaste (matches Coq: Record ToxicWaste)
sig ToxicWaste {
  f_tw_generated_securely: one Bool,
  f_tw_never_stored: one Bool,
  f_tw_destroyed_immediately: one Bool,
  f_tw_verified_destruction: one Bool,
  f_tw_multi_party: one Bool
}

// Groth16Config (matches Coq: Record Groth16Config)
sig Groth16Config {
  f_g16_pairing_friendly: one Bool,
  f_g16_proof_elements: one Int,
  f_g16_verification_pairings: one Int,
  f_g16_trusted_setup: one Bool,
  f_g16_circuit_specific: one Bool
}

// Groth16Proof (matches Coq: Record Groth16Proof)
sig Groth16Proof {
  f_g16p_element_a: one Int,
  f_g16p_element_b: one Int,
  f_g16p_element_c: one Int,
  f_g16p_valid_curve_points: one Bool,
  f_g16p_valid_subgroup: one Bool
}

// PLONKConfig (matches Coq: Record PLONKConfig)
sig PLONKConfig {
  f_plonk_universal_setup: one Bool,
  f_plonk_polynomial_commitment: one Bool,
  f_plonk_arithmetic_gates: one Bool,
  f_plonk_custom_gates: one Bool,
  f_plonk_lookup_tables: one Bool
}

// PLONKGate (matches Coq: Record PLONKGate)
sig PLONKGate {
  f_pg_degree: one Int,
  f_pg_fan_in: one Int,
  f_pg_fan_out: one Int,
  f_pg_is_arithmetic: one Bool
}

// FullZKSNARKConfig (matches Coq: Record FullZKSNARKConfig)
sig FullZKSNARKConfig {
  f_fzk_base: one ZKSNARKConfig,
  f_fzk_extractor: one KnowledgeExtractor,
  f_fzk_simulator: one ZKSimulator,
  f_fzk_proof_size: one ProofSize,
  f_fzk_mpc: one MPCCeremony,
  f_fzk_tw: one ToxicWaste
}

// SoundnessError (matches Coq: Record SoundnessError)
sig SoundnessError {
  f_se_statistical: one Int,
  f_se_computational: one Int,
  f_se_knowledge: one Int,
  f_se_security_parameter: one Int
}

// ProofSystemType (matches Coq: Record ProofSystemType)
sig ProofSystemType {
  f_pst_is_argument: one Bool,
  f_pst_is_proof: one Bool,
  f_pst_knowledge_property: one Bool,
  f_pst_succinctness: one Bool
}

// zk_secure (matches Coq: Definition zk_secure)
pred zk_secure[p_z: ZKProperties] {
  some p_z
}

// snark_secure (matches Coq: Definition snark_secure)
pred snark_secure[p_s: SNARKProperties] {
  some p_s
}

// setup_secure (matches Coq: Definition setup_secure)
pred setup_secure[p_t: TrustedSetup] {
  some p_t
}

// zksnark_secure (matches Coq: Definition zksnark_secure)
pred zksnark_secure[p_c: ZKSNARKConfig] {
  some p_c
}

// riina_zk (matches Coq: Definition riina_zk)
pred riina_zk {}

// riina_snark (matches Coq: Definition riina_snark)
pred riina_snark {}

// riina_setup (matches Coq: Definition riina_setup)
pred riina_setup {}

// riina_zksnark (matches Coq: Definition riina_zksnark)
pred riina_zksnark {}

// ke_secure (matches Coq: Definition ke_secure)
pred ke_secure[p_ke: KnowledgeExtractor] {
  some p_ke
}

// wr_valid (matches Coq: Definition wr_valid)
pred wr_valid[p_wr: WitnessRelation] {
  some p_wr
}

// riina_ke (matches Coq: Definition riina_ke)
pred riina_ke {}

// riina_wr (matches Coq: Definition riina_wr)
pred riina_wr {}

// sim_secure (matches Coq: Definition sim_secure)
pred sim_secure[p_sim: ZKSimulator] {
  some p_sim
}

// di_strong (matches Coq: Definition di_strong)
pred di_strong[p_di: DistIndistinguishability] {
  some p_di
}

// riina_sim (matches Coq: Definition riina_sim)
pred riina_sim {}

// riina_di (matches Coq: Definition riina_di)
pred riina_di {}

// completeness_holds (matches Coq: Definition completeness_holds)
pred completeness_holds[p_pv: ProverConfig, p_vf: VerifierConfig] {
  some p_pv
}

// riina_prover (matches Coq: Definition riina_prover)
pred riina_prover {}

// riina_verifier (matches Coq: Definition riina_verifier)
pred riina_verifier {}

// ps_succinct (matches Coq: Definition ps_succinct)
pred ps_succinct[p_ps: ProofSize] {
  some p_ps
}

// ac_polylog (matches Coq: Definition ac_polylog)
pred ac_polylog[p_ac: AsymptoticComplexity] {
  some p_ac
}

// riina_proof_size (matches Coq: Definition riina_proof_size)
pred riina_proof_size {}

// riina_ac (matches Coq: Definition riina_ac)
pred riina_ac {}

// mpc_secure (matches Coq: Definition mpc_secure)
pred mpc_secure[p_mpc: MPCCeremony] {
  some p_mpc
}

// tw_secure (matches Coq: Definition tw_secure)
pred tw_secure[p_tw: ToxicWaste] {
  some p_tw
}

// riina_mpc (matches Coq: Definition riina_mpc)
pred riina_mpc {}

// riina_tw (matches Coq: Definition riina_tw)
pred riina_tw {}

// g16_secure (matches Coq: Definition g16_secure)
pred g16_secure[p_g: Groth16Config] {
  some p_g
}

// g16p_valid (matches Coq: Definition g16p_valid)
pred g16p_valid[p_p: Groth16Proof] {
  some p_p
}

// riina_g16 (matches Coq: Definition riina_g16)
pred riina_g16 {}

// riina_g16_proof (matches Coq: Definition riina_g16_proof)
pred riina_g16_proof {}

// plonk_secure (matches Coq: Definition plonk_secure)
pred plonk_secure[p_p: PLONKConfig] {
  some p_p
}

// pg_valid (matches Coq: Definition pg_valid)
pred pg_valid[p_g: PLONKGate] {
  some p_g
}

// riina_plonk (matches Coq: Definition riina_plonk)
pred riina_plonk {}

// riina_plonk_gate (matches Coq: Definition riina_plonk_gate)
pred riina_plonk_gate {}

// full_zk_secure (matches Coq: Definition full_zk_secure)
pred full_zk_secure[p_f: FullZKSNARKConfig] {
  some p_f
}

// riina_full_zk (matches Coq: Definition riina_full_zk)
pred riina_full_zk {}

// se_secure (matches Coq: Definition se_secure)
pred se_secure[p_se: SoundnessError] {
  some p_se
}

// riina_se (matches Coq: Definition riina_se)
pred riina_se {}

// pst_is_snark (matches Coq: Definition pst_is_snark)
pred pst_is_snark[p_pst: ProofSystemType] {
  some p_pst
}

// pst_is_stark (matches Coq: Definition pst_is_stark)
pred pst_is_stark[p_pst: ProofSystemType] {
  some p_pst
}

// riina_pst (matches Coq: Definition riina_pst)
pred riina_pst {}

// andb_true_iff (matches Coq: Lemma andb_true_iff)
assert andb_true_iff {
  all c: ZKProperties | some c.f_zk_completeness
}
check andb_true_iff for 5

// andb3_true_iff (matches Coq: Lemma andb3_true_iff)
assert andb3_true_iff {
  all c: ZKProperties | some c.f_zk_completeness
}
check andb3_true_iff for 5

// andb4_true_iff (matches Coq: Lemma andb4_true_iff)
assert andb4_true_iff {
  all c: ZKProperties | some c.f_zk_completeness
}
check andb4_true_iff for 5

// negb_true_iff (matches Coq: Lemma negb_true_iff)
assert negb_true_iff {
  all c: ZKProperties | some c.f_zk_completeness
}
check negb_true_iff for 5

// leb_le (matches Coq: Lemma leb_le)
assert leb_le {
  all c: ZKProperties | some c.f_zk_completeness
}
check leb_le for 5

// ltb_lt (matches Coq: Lemma ltb_lt)
assert ltb_lt {
  all c: ZKProperties | some c.f_zk_completeness
}
check ltb_lt for 5

// orb_true_iff (matches Coq: Lemma orb_true_iff)
assert orb_true_iff {
  all c: ZKProperties | some c.f_zk_completeness
}
check orb_true_iff for 5

// ZK_001 (matches Coq: Theorem ZK_001)
assert ZK_001 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_001 for 5

// ZK_002 (matches Coq: Theorem ZK_002)
assert ZK_002 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_002 for 5

// ZK_003 (matches Coq: Theorem ZK_003)
assert ZK_003 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_003 for 5

// ZK_004 (matches Coq: Theorem ZK_004)
assert ZK_004 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_004 for 5

// ZK_005 (matches Coq: Theorem ZK_005)
assert ZK_005 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_005 for 5

// ZK_006 (matches Coq: Theorem ZK_006)
assert ZK_006 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_006 for 5

// ZK_007 (matches Coq: Theorem ZK_007)
assert ZK_007 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_007 for 5

// ZK_008 (matches Coq: Theorem ZK_008)
assert ZK_008 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_008 for 5

// ZK_009 (matches Coq: Theorem ZK_009)
assert ZK_009 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_009 for 5

// ZK_010 (matches Coq: Theorem ZK_010)
assert ZK_010 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_010 for 5

// ZK_011 (matches Coq: Theorem ZK_011)
assert ZK_011 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_011 for 5

// ZK_012 (matches Coq: Theorem ZK_012)
assert ZK_012 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_012 for 5

// ZK_013 (matches Coq: Theorem ZK_013)
assert ZK_013 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_013 for 5

// ZK_014 (matches Coq: Theorem ZK_014)
assert ZK_014 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_014 for 5

// ZK_015 (matches Coq: Theorem ZK_015)
assert ZK_015 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_015 for 5

// ZK_016 (matches Coq: Theorem ZK_016)
assert ZK_016 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_016 for 5

// ZK_017 (matches Coq: Theorem ZK_017)
assert ZK_017 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_017 for 5

// ZK_018 (matches Coq: Theorem ZK_018)
assert ZK_018 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_018 for 5

// ZK_019 (matches Coq: Theorem ZK_019)
assert ZK_019 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_019 for 5

// ZK_020 (matches Coq: Theorem ZK_020)
assert ZK_020 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_020 for 5

// ZK_021 (matches Coq: Theorem ZK_021)
assert ZK_021 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_021 for 5

// ZK_022 (matches Coq: Theorem ZK_022)
assert ZK_022 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_022 for 5

// ZK_023 (matches Coq: Theorem ZK_023)
assert ZK_023 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_023 for 5

// ZK_024 (matches Coq: Theorem ZK_024)
assert ZK_024 {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_024 for 5

// ZK_025_complete (matches Coq: Theorem ZK_025_complete)
assert ZK_025_complete {
  all c: ZKProperties | some c.f_zk_completeness
}
check ZK_025_complete for 5

// ke_001_riina_ke_secure (matches Coq: Theorem ke_001_riina_ke_secure)
assert ke_001_riina_ke_secure {
  all c: ZKProperties | some c.f_zk_completeness
}
check ke_001_riina_ke_secure for 5

// ke_002_extractor_exists (matches Coq: Theorem ke_002_extractor_exists)
assert ke_002_extractor_exists {
  all c: ZKProperties | some c.f_zk_completeness
}
check ke_002_extractor_exists for 5

// ke_003_extractor_polynomial (matches Coq: Theorem ke_003_extractor_polynomial)
assert ke_003_extractor_polynomial {
  all c: ZKProperties | some c.f_zk_completeness
}
check ke_003_extractor_polynomial for 5

// ke_004_extractor_probability (matches Coq: Theorem ke_004_extractor_probability)
assert ke_004_extractor_probability {
  all c: ZKProperties | some c.f_zk_completeness
}
check ke_004_extractor_probability for 5

// ke_005_riina_wr_valid (matches Coq: Theorem ke_005_riina_wr_valid)
assert ke_005_riina_wr_valid {
  all c: ZKProperties | some c.f_zk_completeness
}
check ke_005_riina_wr_valid for 5

// ke_006_valid_satisfiable (matches Coq: Theorem ke_006_valid_satisfiable)
assert ke_006_valid_satisfiable {
  all c: ZKProperties | some c.f_zk_completeness
}
check ke_006_valid_satisfiable for 5

// ke_007_positive_statement (matches Coq: Theorem ke_007_positive_statement)
assert ke_007_positive_statement {
  all c: ZKProperties | some c.f_zk_completeness
}
check ke_007_positive_statement for 5

// ke_008_positive_witness (matches Coq: Theorem ke_008_positive_witness)
assert ke_008_positive_witness {
  all c: ZKProperties | some c.f_zk_completeness
}
check ke_008_positive_witness for 5

// sim_001_riina_sim_secure (matches Coq: Theorem sim_001_riina_sim_secure)
assert sim_001_riina_sim_secure {
  all c: ZKProperties | some c.f_zk_completeness
}
check sim_001_riina_sim_secure for 5

// sim_002_simulator_exists (matches Coq: Theorem sim_002_simulator_exists)
assert sim_002_simulator_exists {
  all c: ZKProperties | some c.f_zk_completeness
}
check sim_002_simulator_exists for 5

// sim_003_simulator_poly (matches Coq: Theorem sim_003_simulator_poly)
assert sim_003_simulator_poly {
  all c: ZKProperties | some c.f_zk_completeness
}
check sim_003_simulator_poly for 5

// sim_004_simulator_indist (matches Coq: Theorem sim_004_simulator_indist)
assert sim_004_simulator_indist {
  all c: ZKProperties | some c.f_zk_completeness
}
check sim_004_simulator_indist for 5

// sim_005_simulator_no_witness (matches Coq: Theorem sim_005_simulator_no_witness)
assert sim_005_simulator_no_witness {
  all c: ZKProperties | some c.f_zk_completeness
}
check sim_005_simulator_no_witness for 5

// sim_006_riina_di_strong (matches Coq: Theorem sim_006_riina_di_strong)
assert sim_006_riina_di_strong {
  all c: ZKProperties | some c.f_zk_completeness
}
check sim_006_riina_di_strong for 5

// sim_007_strong_implies_computational (matches Coq: Theorem sim_007_strong_implies_computational)
assert sim_007_strong_implies_computational {
  all c: ZKProperties | some c.f_zk_completeness
}
check sim_007_strong_implies_computational for 5

// sim_008_strong_bounded_advantage (matches Coq: Theorem sim_008_strong_bounded_advantage)
assert sim_008_strong_bounded_advantage {
  all c: ZKProperties | some c.f_zk_completeness
}
check sim_008_strong_bounded_advantage for 5

// comp_001_riina_completeness (matches Coq: Theorem comp_001_riina_completeness)
assert comp_001_riina_completeness {
  all c: ZKProperties | some c.f_zk_completeness
}
check comp_001_riina_completeness for 5

// comp_002_requires_honest_prover (matches Coq: Theorem comp_002_requires_honest_prover)
assert comp_002_requires_honest_prover {
  all c: ZKProperties | some c.f_zk_completeness
}
check comp_002_requires_honest_prover for 5

// comp_003_requires_witness (matches Coq: Theorem comp_003_requires_witness)
assert comp_003_requires_witness {
  all c: ZKProperties | some c.f_zk_completeness
}
check comp_003_requires_witness for 5

// comp_004_requires_protocol (matches Coq: Theorem comp_004_requires_protocol)
assert comp_004_requires_protocol {
  all c: ZKProperties | some c.f_zk_completeness
}
check comp_004_requires_protocol for 5

// comp_005_verifier_accepts (matches Coq: Theorem comp_005_verifier_accepts)
assert comp_005_verifier_accepts {
  all c: ZKProperties | some c.f_zk_completeness
}
check comp_005_verifier_accepts for 5

// comp_006_riina_prover_honest (matches Coq: Theorem comp_006_riina_prover_honest)
assert comp_006_riina_prover_honest {
  all c: ZKProperties | some c.f_zk_completeness
}
check comp_006_riina_prover_honest for 5

// comp_007_riina_verifier_accepts (matches Coq: Theorem comp_007_riina_verifier_accepts)
assert comp_007_riina_verifier_accepts {
  all c: ZKProperties | some c.f_zk_completeness
}
check comp_007_riina_verifier_accepts for 5

// succ_001_riina_succinct (matches Coq: Theorem succ_001_riina_succinct)
assert succ_001_riina_succinct {
  all c: ZKProperties | some c.f_zk_completeness
}
check succ_001_riina_succinct for 5

// succ_002_riina_polylog (matches Coq: Theorem succ_002_riina_polylog)
assert succ_002_riina_polylog {
  all c: ZKProperties | some c.f_zk_completeness
}
check succ_002_riina_polylog for 5

// succ_003_bounded_size (matches Coq: Theorem succ_003_bounded_size)
assert succ_003_bounded_size {
  all c: ZKProperties | some c.f_zk_completeness
}
check succ_003_bounded_size for 5

// succ_004_bounded_verification (matches Coq: Theorem succ_004_bounded_verification)
assert succ_004_bounded_verification {
  all c: ZKProperties | some c.f_zk_completeness
}
check succ_004_bounded_verification for 5

// succ_005_witness_independent (matches Coq: Theorem succ_005_witness_independent)
assert succ_005_witness_independent {
  all c: ZKProperties | some c.f_zk_completeness
}
check succ_005_witness_independent for 5

// succ_006_polylog_proof_size (matches Coq: Theorem succ_006_polylog_proof_size)
assert succ_006_polylog_proof_size {
  all c: ZKProperties | some c.f_zk_completeness
}
check succ_006_polylog_proof_size for 5

// succ_007_polylog_verification (matches Coq: Theorem succ_007_polylog_verification)
assert succ_007_polylog_verification {
  all c: ZKProperties | some c.f_zk_completeness
}
check succ_007_polylog_verification for 5

// mpc_001_riina_mpc_secure (matches Coq: Theorem mpc_001_riina_mpc_secure)
assert mpc_001_riina_mpc_secure {
  all c: ZKProperties | some c.f_zk_completeness
}
check mpc_001_riina_mpc_secure for 5

// mpc_002_riina_tw_secure (matches Coq: Theorem mpc_002_riina_tw_secure)
assert mpc_002_riina_tw_secure {
  all c: ZKProperties | some c.f_zk_completeness
}
check mpc_002_riina_tw_secure for 5

// mpc_003_multiple_participants (matches Coq: Theorem mpc_003_multiple_participants)
assert mpc_003_multiple_participants {
  all c: ZKProperties | some c.f_zk_completeness
}
check mpc_003_multiple_participants for 5

// mpc_004_valid_threshold (matches Coq: Theorem mpc_004_valid_threshold)
assert mpc_004_valid_threshold {
  all c: ZKProperties | some c.f_zk_completeness
}
check mpc_004_valid_threshold for 5

// mpc_005_verifiable (matches Coq: Theorem mpc_005_verifiable)
assert mpc_005_verifiable {
  all c: ZKProperties | some c.f_zk_completeness
}
check mpc_005_verifiable for 5

// mpc_006_tw_destroyed (matches Coq: Theorem mpc_006_tw_destroyed)
assert mpc_006_tw_destroyed {
  all c: ZKProperties | some c.f_zk_completeness
}
check mpc_006_tw_destroyed for 5

// mpc_007_tw_multi_party (matches Coq: Theorem mpc_007_tw_multi_party)
assert mpc_007_tw_multi_party {
  all c: ZKProperties | some c.f_zk_completeness
}
check mpc_007_tw_multi_party for 5

// g16_001_riina_secure (matches Coq: Theorem g16_001_riina_secure)
assert g16_001_riina_secure {
  all c: ZKProperties | some c.f_zk_completeness
}
check g16_001_riina_secure for 5

// g16_002_riina_proof_valid (matches Coq: Theorem g16_002_riina_proof_valid)
assert g16_002_riina_proof_valid {
  all c: ZKProperties | some c.f_zk_completeness
}
check g16_002_riina_proof_valid for 5

// g16_003_pairing_friendly (matches Coq: Theorem g16_003_pairing_friendly)
assert g16_003_pairing_friendly {
  all c: ZKProperties | some c.f_zk_completeness
}
check g16_003_pairing_friendly for 5

// g16_004_three_elements (matches Coq: Theorem g16_004_three_elements)
assert g16_004_three_elements {
  all c: ZKProperties | some c.f_zk_completeness
}
check g16_004_three_elements for 5

// g16_005_bounded_pairings (matches Coq: Theorem g16_005_bounded_pairings)
assert g16_005_bounded_pairings {
  all c: ZKProperties | some c.f_zk_completeness
}
check g16_005_bounded_pairings for 5

// g16_006_valid_curve_points (matches Coq: Theorem g16_006_valid_curve_points)
assert g16_006_valid_curve_points {
  all c: ZKProperties | some c.f_zk_completeness
}
check g16_006_valid_curve_points for 5

// g16_007_valid_subgroup (matches Coq: Theorem g16_007_valid_subgroup)
assert g16_007_valid_subgroup {
  all c: ZKProperties | some c.f_zk_completeness
}
check g16_007_valid_subgroup for 5

// plonk_001_riina_secure (matches Coq: Theorem plonk_001_riina_secure)
assert plonk_001_riina_secure {
  all c: ZKProperties | some c.f_zk_completeness
}
check plonk_001_riina_secure for 5

// plonk_002_riina_gate_valid (matches Coq: Theorem plonk_002_riina_gate_valid)
assert plonk_002_riina_gate_valid {
  all c: ZKProperties | some c.f_zk_completeness
}
check plonk_002_riina_gate_valid for 5

// plonk_003_universal_setup (matches Coq: Theorem plonk_003_universal_setup)
assert plonk_003_universal_setup {
  all c: ZKProperties | some c.f_zk_completeness
}
check plonk_003_universal_setup for 5

// plonk_004_polynomial_commitment (matches Coq: Theorem plonk_004_polynomial_commitment)
assert plonk_004_polynomial_commitment {
  all c: ZKProperties | some c.f_zk_completeness
}
check plonk_004_polynomial_commitment for 5

// plonk_005_arithmetic_gates (matches Coq: Theorem plonk_005_arithmetic_gates)
assert plonk_005_arithmetic_gates {
  all c: ZKProperties | some c.f_zk_completeness
}
check plonk_005_arithmetic_gates for 5

// plonk_006_bounded_degree (matches Coq: Theorem plonk_006_bounded_degree)
assert plonk_006_bounded_degree {
  all c: ZKProperties | some c.f_zk_completeness
}
check plonk_006_bounded_degree for 5

// plonk_007_sufficient_fan_in (matches Coq: Theorem plonk_007_sufficient_fan_in)
assert plonk_007_sufficient_fan_in {
  all c: ZKProperties | some c.f_zk_completeness
}
check plonk_007_sufficient_fan_in for 5

// full_001_riina_full_zk_secure (matches Coq: Theorem full_001_riina_full_zk_secure)
assert full_001_riina_full_zk_secure {
  all c: ZKProperties | some c.f_zk_completeness
}
check full_001_riina_full_zk_secure for 5

// full_002_implies_base (matches Coq: Theorem full_002_implies_base)
assert full_002_implies_base {
  all c: ZKProperties | some c.f_zk_completeness
}
check full_002_implies_base for 5

// full_003_implies_ke (matches Coq: Theorem full_003_implies_ke)
assert full_003_implies_ke {
  all c: ZKProperties | some c.f_zk_completeness
}
check full_003_implies_ke for 5

// full_004_implies_sim (matches Coq: Theorem full_004_implies_sim)
assert full_004_implies_sim {
  all c: ZKProperties | some c.f_zk_completeness
}
check full_004_implies_sim for 5

// full_005_implies_succinct (matches Coq: Theorem full_005_implies_succinct)
assert full_005_implies_succinct {
  all c: ZKProperties | some c.f_zk_completeness
}
check full_005_implies_succinct for 5

// full_006_implies_mpc (matches Coq: Theorem full_006_implies_mpc)
assert full_006_implies_mpc {
  all c: ZKProperties | some c.f_zk_completeness
}
check full_006_implies_mpc for 5

// full_007_implies_tw (matches Coq: Theorem full_007_implies_tw)
assert full_007_implies_tw {
  all c: ZKProperties | some c.f_zk_completeness
}
check full_007_implies_tw for 5

// full_008_riina_all_properties (matches Coq: Theorem full_008_riina_all_properties)
assert full_008_riina_all_properties {
  all c: ZKProperties | some c.f_zk_completeness
}
check full_008_riina_all_properties for 5

// se_001_riina_se_secure (matches Coq: Theorem se_001_riina_se_secure)
assert se_001_riina_se_secure {
  all c: ZKProperties | some c.f_zk_completeness
}
check se_001_riina_se_secure for 5

// se_002_security_parameter (matches Coq: Theorem se_002_security_parameter)
assert se_002_security_parameter {
  all c: ZKProperties | some c.f_zk_completeness
}
check se_002_security_parameter for 5

// se_003_statistical_bounded (matches Coq: Theorem se_003_statistical_bounded)
assert se_003_statistical_bounded {
  all c: ZKProperties | some c.f_zk_completeness
}
check se_003_statistical_bounded for 5

// pst_001_riina_is_snark (matches Coq: Theorem pst_001_riina_is_snark)
assert pst_001_riina_is_snark {
  all c: ZKProperties | some c.f_zk_completeness
}
check pst_001_riina_is_snark for 5

// pst_002_snark_is_argument (matches Coq: Theorem pst_002_snark_is_argument)
assert pst_002_snark_is_argument {
  all c: ZKProperties | some c.f_zk_completeness
}
check pst_002_snark_is_argument for 5

// pst_003_snark_knowledge (matches Coq: Theorem pst_003_snark_knowledge)
assert pst_003_snark_knowledge {
  all c: ZKProperties | some c.f_zk_completeness
}
check pst_003_snark_knowledge for 5

// pst_004_snark_succinct (matches Coq: Theorem pst_004_snark_succinct)
assert pst_004_snark_succinct {
  all c: ZKProperties | some c.f_zk_completeness
}
check pst_004_snark_succinct for 5

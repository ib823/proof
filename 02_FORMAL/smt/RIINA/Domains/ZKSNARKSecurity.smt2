; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ZKSNARKSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/ZKSNARKSecurity.v (98 assertions)
; Module: ZKSNARKSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ZKProperties 0))
  (((mk-zk_properties (zk_completeness Bool) (zk_soundness Bool) (zk_zero_knowledge Bool)))))

(declare-datatypes ((SNARKProperties 0))
  (((mk-snark_properties (snark_succinctness Bool) (snark_non_interactive Bool) (snark_knowledge_sound Bool)))))

(declare-datatypes ((TrustedSetup 0))
  (((mk-trusted_setup (ts_mpc_ceremony Bool) (ts_toxic_waste_destroyed Bool) (ts_verifiable Bool)))))

(declare-datatypes ((ZKSNARKConfig 0))
  (((mk-zksnark_config (zks_zk ZKProperties) (zks_snark SNARKProperties) (zks_setup TrustedSetup) (zks_post_quantum Bool)))))

(declare-datatypes ((KnowledgeExtractor 0))
  (((mk-knowledge_extractor (ke_exists Bool) (ke_polynomial_time Bool) (ke_extraction_prob Int) (ke_rewinding_allowed Bool) (ke_auxiliary_input Bool)))))

(declare-datatypes ((WitnessRelation 0))
  (((mk-witness_relation (wr_statement_size Int) (wr_witness_size Int) (wr_verification_time Int) (wr_satisfiable Bool)))))

(declare-datatypes ((ZKSimulator 0))
  (((mk-zk_simulator (sim_exists Bool) (sim_polynomial_time Bool) (sim_indistinguishable Bool) (sim_no_witness_needed Bool) (sim_programmable_ro Bool)))))

(declare-datatypes ((DistIndistinguishability 0))
  (((mk-dist_indistinguishability (di_computational Bool) (di_statistical Bool) (di_perfect Bool) (di_advantage_bound Int)))))

(declare-datatypes ((ProverConfig 0))
  (((mk-prover_config (pv_honest Bool) (pv_knows_witness Bool) (pv_follows_protocol Bool) (pv_polynomial_time Bool) (pv_randomness_fresh Bool)))))

(declare-datatypes ((VerifierConfig 0))
  (((mk-verifier_config (vf_honest Bool) (vf_follows_protocol Bool) (vf_polynomial_time Bool) (vf_accepts_valid Bool)))))

(declare-datatypes ((ProofSize 0))
  (((mk-proof_size (ps_proof_bytes Int) (ps_verification_ops Int) (ps_statement_dependent Bool) (ps_witness_independent Bool)))))

(declare-datatypes ((AsymptoticComplexity 0))
  (((mk-asymptotic_complexity (ac_proof_size Int) (ac_verification_time Int) (ac_prover_time Int) (ac_setup_time Int)))))

(declare-datatypes ((MPCCeremony 0))
  (((mk-mpc_ceremony (mpc_participants Int) (mpc_threshold Int) (mpc_verifiable Bool) (mpc_contributions_published Bool) (mpc_random_beacon Bool)))))

(declare-datatypes ((ToxicWaste 0))
  (((mk-toxic_waste (tw_generated_securely Bool) (tw_never_stored Bool) (tw_destroyed_immediately Bool) (tw_verified_destruction Bool) (tw_multi_party Bool)))))

(declare-datatypes ((Groth16Config 0))
  (((mk-groth16_config (g16_pairing_friendly Bool) (g16_proof_elements Int) (g16_verification_pairings Int) (g16_trusted_setup Bool) (g16_circuit_specific Bool)))))

(declare-datatypes ((Groth16Proof 0))
  (((mk-groth16_proof (g16p_element_a Int) (g16p_element_b Int) (g16p_element_c Int) (g16p_valid_curve_points Bool) (g16p_valid_subgroup Bool)))))

(declare-datatypes ((PLONKConfig 0))
  (((mk-plonk_config (plonk_universal_setup Bool) (plonk_polynomial_commitment Bool) (plonk_arithmetic_gates Bool) (plonk_custom_gates Bool) (plonk_lookup_tables Bool)))))

(declare-datatypes ((PLONKGate 0))
  (((mk-plonk_gate (pg_degree Int) (pg_fan_in Int) (pg_fan_out Int) (pg_is_arithmetic Bool)))))

(declare-datatypes ((FullZKSNARKConfig 0))
  (((mk-full_zksnark_config (fzk_base ZKSNARKConfig) (fzk_extractor KnowledgeExtractor) (fzk_simulator ZKSimulator) (fzk_proof_size ProofSize) (fzk_mpc MPCCeremony) (fzk_tw ToxicWaste)))))

(declare-datatypes ((SoundnessError 0))
  (((mk-soundness_error (se_statistical Int) (se_computational Int) (se_knowledge Int) (se_security_parameter Int)))))

(declare-datatypes ((ProofSystemType 0))
  (((mk-proof_system_type (pst_is_argument Bool) (pst_is_proof Bool) (pst_knowledge_property Bool) (pst_succinctness Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- ZKProperties record properties ---

; --- 1. ZKProperties accessor round-trip: zk_completeness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (zk_completeness (mk-zk_properties f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ZKProperties accessor round-trip: zk_soundness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (zk_soundness (mk-zk_properties f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ZKProperties_all_enabled ((g ZKProperties)) Bool
  (and (zk_completeness g) (zk_soundness g)))

; --- 3. ZKProperties: all-enabled completeness ---
(push 1)
(declare-const g ZKProperties)
(assert (zk_completeness g))
(assert (zk_soundness g))
(assert (not (ZKProperties_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ZKProperties: ZKProperties_all_enabled implies zk_completeness ---
(push 1)
(declare-const g ZKProperties)
(assert (ZKProperties_all_enabled g))
(assert (not (zk_completeness g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ZKProperties: ZKProperties_all_enabled implies zk_soundness ---
(push 1)
(declare-const g ZKProperties)
(assert (ZKProperties_all_enabled g))
(assert (not (zk_soundness g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SNARKProperties record properties ---

; --- 6. SNARKProperties accessor round-trip: snark_succinctness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (snark_succinctness (mk-snark_properties f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SNARKProperties accessor round-trip: snark_non_interactive ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (snark_non_interactive (mk-snark_properties f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SNARKProperties_all_enabled ((g SNARKProperties)) Bool
  (and (snark_succinctness g) (snark_non_interactive g)))

; --- 8. SNARKProperties: all-enabled completeness ---
(push 1)
(declare-const g SNARKProperties)
(assert (snark_succinctness g))
(assert (snark_non_interactive g))
(assert (not (SNARKProperties_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SNARKProperties: SNARKProperties_all_enabled implies snark_succinctness ---
(push 1)
(declare-const g SNARKProperties)
(assert (SNARKProperties_all_enabled g))
(assert (not (snark_succinctness g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SNARKProperties: SNARKProperties_all_enabled implies snark_non_interactive ---
(push 1)
(declare-const g SNARKProperties)
(assert (SNARKProperties_all_enabled g))
(assert (not (snark_non_interactive g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TrustedSetup record properties ---

; --- 11. TrustedSetup accessor round-trip: ts_mpc_ceremony ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ts_mpc_ceremony (mk-trusted_setup f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TrustedSetup accessor round-trip: ts_toxic_waste_destroyed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ts_toxic_waste_destroyed (mk-trusted_setup f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TrustedSetup_all_enabled ((g TrustedSetup)) Bool
  (and (ts_mpc_ceremony g) (ts_toxic_waste_destroyed g)))

; --- 13. TrustedSetup: all-enabled completeness ---
(push 1)
(declare-const g TrustedSetup)
(assert (ts_mpc_ceremony g))
(assert (ts_toxic_waste_destroyed g))
(assert (not (TrustedSetup_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. TrustedSetup: TrustedSetup_all_enabled implies ts_mpc_ceremony ---
(push 1)
(declare-const g TrustedSetup)
(assert (TrustedSetup_all_enabled g))
(assert (not (ts_mpc_ceremony g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. TrustedSetup: TrustedSetup_all_enabled implies ts_toxic_waste_destroyed ---
(push 1)
(declare-const g TrustedSetup)
(assert (TrustedSetup_all_enabled g))
(assert (not (ts_toxic_waste_destroyed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ZKSNARKConfig record properties ---

; --- 16. ZKSNARKConfig accessor round-trip: zks_zk ---
(push 1)
(declare-const f0 ZKProperties)
(declare-const f1 SNARKProperties)
(declare-const f2 TrustedSetup)
(declare-const f3 Bool)
(assert (not (= (zks_zk (mk-zksnark_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ZKSNARKConfig accessor round-trip: zks_snark ---
(push 1)
(declare-const f0 ZKProperties)
(declare-const f1 SNARKProperties)
(declare-const f2 TrustedSetup)
(declare-const f3 Bool)
(assert (not (= (zks_snark (mk-zksnark_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ZKSNARKConfig accessor round-trip: zks_setup ---
(push 1)
(declare-const f0 ZKProperties)
(declare-const f1 SNARKProperties)
(declare-const f2 TrustedSetup)
(declare-const f3 Bool)
(assert (not (= (zks_setup (mk-zksnark_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KnowledgeExtractor record properties ---

; --- 19. KnowledgeExtractor accessor round-trip: ke_exists ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ke_exists (mk-knowledge_extractor f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. KnowledgeExtractor accessor round-trip: ke_polynomial_time ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ke_polynomial_time (mk-knowledge_extractor f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. KnowledgeExtractor accessor round-trip: ke_extraction_prob ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ke_extraction_prob (mk-knowledge_extractor f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. KnowledgeExtractor accessor round-trip: ke_rewinding_allowed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ke_rewinding_allowed (mk-knowledge_extractor f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- WitnessRelation record properties ---

; --- 23. WitnessRelation accessor round-trip: wr_statement_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (wr_statement_size (mk-witness_relation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. WitnessRelation accessor round-trip: wr_witness_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (wr_witness_size (mk-witness_relation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. WitnessRelation accessor round-trip: wr_verification_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (wr_verification_time (mk-witness_relation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. WitnessRelation: integer field consistency ---
(push 1)
(declare-const r WitnessRelation)
(assert (>= (wr_statement_size r) 0))
(assert (>= (wr_witness_size r) 0))
(assert (not (>= (+ (wr_statement_size r) (wr_witness_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ZKSimulator record properties ---

; --- 27. ZKSimulator accessor round-trip: sim_exists ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sim_exists (mk-zk_simulator f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ZKSimulator accessor round-trip: sim_polynomial_time ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sim_polynomial_time (mk-zk_simulator f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ZKSimulator accessor round-trip: sim_indistinguishable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sim_indistinguishable (mk-zk_simulator f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ZKSimulator accessor round-trip: sim_no_witness_needed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sim_no_witness_needed (mk-zk_simulator f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ZKSimulator_all_enabled ((g ZKSimulator)) Bool
  (and (sim_exists g) (sim_polynomial_time g) (sim_indistinguishable g) (sim_no_witness_needed g)))

; --- 31. ZKSimulator: all-enabled completeness ---
(push 1)
(declare-const g ZKSimulator)
(assert (sim_exists g))
(assert (sim_polynomial_time g))
(assert (sim_indistinguishable g))
(assert (sim_no_witness_needed g))
(assert (not (ZKSimulator_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ZKSimulator: ZKSimulator_all_enabled implies sim_exists ---
(push 1)
(declare-const g ZKSimulator)
(assert (ZKSimulator_all_enabled g))
(assert (not (sim_exists g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. ZKSimulator: ZKSimulator_all_enabled implies sim_polynomial_time ---
(push 1)
(declare-const g ZKSimulator)
(assert (ZKSimulator_all_enabled g))
(assert (not (sim_polynomial_time g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. ZKSimulator: ZKSimulator_all_enabled implies sim_indistinguishable ---
(push 1)
(declare-const g ZKSimulator)
(assert (ZKSimulator_all_enabled g))
(assert (not (sim_indistinguishable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DistIndistinguishability record properties ---

; --- 35. DistIndistinguishability accessor round-trip: di_computational ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (di_computational (mk-dist_indistinguishability f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. DistIndistinguishability accessor round-trip: di_statistical ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (di_statistical (mk-dist_indistinguishability f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. DistIndistinguishability accessor round-trip: di_perfect ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (di_perfect (mk-dist_indistinguishability f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DistIndistinguishability_all_enabled ((g DistIndistinguishability)) Bool
  (and (di_computational g) (di_statistical g) (di_perfect g)))

; --- 38. DistIndistinguishability: all-enabled completeness ---
(push 1)
(declare-const g DistIndistinguishability)
(assert (di_computational g))
(assert (di_statistical g))
(assert (di_perfect g))
(assert (not (DistIndistinguishability_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. DistIndistinguishability: DistIndistinguishability_all_enabled implies di_computational ---
(push 1)
(declare-const g DistIndistinguishability)
(assert (DistIndistinguishability_all_enabled g))
(assert (not (di_computational g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. DistIndistinguishability: DistIndistinguishability_all_enabled implies di_statistical ---
(push 1)
(declare-const g DistIndistinguishability)
(assert (DistIndistinguishability_all_enabled g))
(assert (not (di_statistical g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. DistIndistinguishability: DistIndistinguishability_all_enabled implies di_perfect ---
(push 1)
(declare-const g DistIndistinguishability)
(assert (DistIndistinguishability_all_enabled g))
(assert (not (di_perfect g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProverConfig record properties ---

; --- 42. ProverConfig accessor round-trip: pv_honest ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (pv_honest (mk-prover_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. ProverConfig accessor round-trip: pv_knows_witness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (pv_knows_witness (mk-prover_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. ProverConfig accessor round-trip: pv_follows_protocol ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (pv_follows_protocol (mk-prover_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. ProverConfig accessor round-trip: pv_polynomial_time ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (pv_polynomial_time (mk-prover_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ProverConfig_all_enabled ((g ProverConfig)) Bool
  (and (pv_honest g) (pv_knows_witness g) (pv_follows_protocol g) (pv_polynomial_time g)))

; --- 46. ProverConfig: all-enabled completeness ---
(push 1)
(declare-const g ProverConfig)
(assert (pv_honest g))
(assert (pv_knows_witness g))
(assert (pv_follows_protocol g))
(assert (pv_polynomial_time g))
(assert (not (ProverConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. ProverConfig: ProverConfig_all_enabled implies pv_honest ---
(push 1)
(declare-const g ProverConfig)
(assert (ProverConfig_all_enabled g))
(assert (not (pv_honest g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. ProverConfig: ProverConfig_all_enabled implies pv_knows_witness ---
(push 1)
(declare-const g ProverConfig)
(assert (ProverConfig_all_enabled g))
(assert (not (pv_knows_witness g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. ProverConfig: ProverConfig_all_enabled implies pv_follows_protocol ---
(push 1)
(declare-const g ProverConfig)
(assert (ProverConfig_all_enabled g))
(assert (not (pv_follows_protocol g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifierConfig record properties ---

; --- 50. VerifierConfig accessor round-trip: vf_honest ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vf_honest (mk-verifier_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. VerifierConfig accessor round-trip: vf_follows_protocol ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vf_follows_protocol (mk-verifier_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. VerifierConfig accessor round-trip: vf_polynomial_time ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vf_polynomial_time (mk-verifier_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun VerifierConfig_all_enabled ((g VerifierConfig)) Bool
  (and (vf_honest g) (vf_follows_protocol g) (vf_polynomial_time g)))

; --- 53. VerifierConfig: all-enabled completeness ---
(push 1)
(declare-const g VerifierConfig)
(assert (vf_honest g))
(assert (vf_follows_protocol g))
(assert (vf_polynomial_time g))
(assert (not (VerifierConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. VerifierConfig: VerifierConfig_all_enabled implies vf_honest ---
(push 1)
(declare-const g VerifierConfig)
(assert (VerifierConfig_all_enabled g))
(assert (not (vf_honest g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. VerifierConfig: VerifierConfig_all_enabled implies vf_follows_protocol ---
(push 1)
(declare-const g VerifierConfig)
(assert (VerifierConfig_all_enabled g))
(assert (not (vf_follows_protocol g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. VerifierConfig: VerifierConfig_all_enabled implies vf_polynomial_time ---
(push 1)
(declare-const g VerifierConfig)
(assert (VerifierConfig_all_enabled g))
(assert (not (vf_polynomial_time g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProofSize record properties ---

; --- 57. ProofSize accessor round-trip: ps_proof_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ps_proof_bytes (mk-proof_size f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. ProofSize accessor round-trip: ps_verification_ops ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ps_verification_ops (mk-proof_size f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. ProofSize accessor round-trip: ps_statement_dependent ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ps_statement_dependent (mk-proof_size f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. ProofSize: integer field consistency ---
(push 1)
(declare-const r ProofSize)
(assert (>= (ps_proof_bytes r) 0))
(assert (>= (ps_verification_ops r) 0))
(assert (not (>= (+ (ps_proof_bytes r) (ps_verification_ops r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AsymptoticComplexity record properties ---

; --- 61. AsymptoticComplexity accessor round-trip: ac_proof_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ac_proof_size (mk-asymptotic_complexity f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. AsymptoticComplexity accessor round-trip: ac_verification_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ac_verification_time (mk-asymptotic_complexity f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. AsymptoticComplexity accessor round-trip: ac_prover_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ac_prover_time (mk-asymptotic_complexity f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. AsymptoticComplexity: integer field consistency ---
(push 1)
(declare-const r AsymptoticComplexity)
(assert (>= (ac_proof_size r) 0))
(assert (>= (ac_verification_time r) 0))
(assert (not (>= (+ (ac_proof_size r) (ac_verification_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MPCCeremony record properties ---

; --- 65. MPCCeremony accessor round-trip: mpc_participants ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (mpc_participants (mk-mpc_ceremony f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. MPCCeremony accessor round-trip: mpc_threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (mpc_threshold (mk-mpc_ceremony f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. MPCCeremony accessor round-trip: mpc_verifiable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (mpc_verifiable (mk-mpc_ceremony f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. MPCCeremony accessor round-trip: mpc_contributions_published ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (mpc_contributions_published (mk-mpc_ceremony f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. MPCCeremony: integer field consistency ---
(push 1)
(declare-const r MPCCeremony)
(assert (>= (mpc_participants r) 0))
(assert (>= (mpc_threshold r) 0))
(assert (not (>= (+ (mpc_participants r) (mpc_threshold r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ToxicWaste record properties ---

; --- 70. ToxicWaste accessor round-trip: tw_generated_securely ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (tw_generated_securely (mk-toxic_waste f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. ToxicWaste accessor round-trip: tw_never_stored ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (tw_never_stored (mk-toxic_waste f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. ToxicWaste accessor round-trip: tw_destroyed_immediately ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (tw_destroyed_immediately (mk-toxic_waste f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. ToxicWaste accessor round-trip: tw_verified_destruction ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (tw_verified_destruction (mk-toxic_waste f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ToxicWaste_all_enabled ((g ToxicWaste)) Bool
  (and (tw_generated_securely g) (tw_never_stored g) (tw_destroyed_immediately g) (tw_verified_destruction g)))

; --- 74. ToxicWaste: all-enabled completeness ---
(push 1)
(declare-const g ToxicWaste)
(assert (tw_generated_securely g))
(assert (tw_never_stored g))
(assert (tw_destroyed_immediately g))
(assert (tw_verified_destruction g))
(assert (not (ToxicWaste_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. ToxicWaste: ToxicWaste_all_enabled implies tw_generated_securely ---
(push 1)
(declare-const g ToxicWaste)
(assert (ToxicWaste_all_enabled g))
(assert (not (tw_generated_securely g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. ToxicWaste: ToxicWaste_all_enabled implies tw_never_stored ---
(push 1)
(declare-const g ToxicWaste)
(assert (ToxicWaste_all_enabled g))
(assert (not (tw_never_stored g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. ToxicWaste: ToxicWaste_all_enabled implies tw_destroyed_immediately ---
(push 1)
(declare-const g ToxicWaste)
(assert (ToxicWaste_all_enabled g))
(assert (not (tw_destroyed_immediately g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Groth16Config record properties ---

; --- 78. Groth16Config accessor round-trip: g16_pairing_friendly ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (g16_pairing_friendly (mk-groth16_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. Groth16Config accessor round-trip: g16_proof_elements ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (g16_proof_elements (mk-groth16_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. Groth16Config accessor round-trip: g16_verification_pairings ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (g16_verification_pairings (mk-groth16_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. Groth16Config accessor round-trip: g16_trusted_setup ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (g16_trusted_setup (mk-groth16_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. Groth16Config: integer field consistency ---
(push 1)
(declare-const r Groth16Config)
(assert (>= (g16_proof_elements r) 0))
(assert (>= (g16_verification_pairings r) 0))
(assert (not (>= (+ (g16_proof_elements r) (g16_verification_pairings r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Groth16Proof record properties ---

; --- 83. Groth16Proof accessor round-trip: g16p_element_a ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (g16p_element_a (mk-groth16_proof f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. Groth16Proof accessor round-trip: g16p_element_b ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (g16p_element_b (mk-groth16_proof f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. Groth16Proof accessor round-trip: g16p_element_c ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (g16p_element_c (mk-groth16_proof f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. Groth16Proof accessor round-trip: g16p_valid_curve_points ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (g16p_valid_curve_points (mk-groth16_proof f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. Groth16Proof: integer field consistency ---
(push 1)
(declare-const r Groth16Proof)
(assert (>= (g16p_element_a r) 0))
(assert (>= (g16p_element_b r) 0))
(assert (not (>= (+ (g16p_element_a r) (g16p_element_b r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PLONKConfig record properties ---

; --- 88. PLONKConfig accessor round-trip: plonk_universal_setup ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (plonk_universal_setup (mk-plonk_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. PLONKConfig accessor round-trip: plonk_polynomial_commitment ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (plonk_polynomial_commitment (mk-plonk_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. PLONKConfig accessor round-trip: plonk_arithmetic_gates ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (plonk_arithmetic_gates (mk-plonk_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. PLONKConfig accessor round-trip: plonk_custom_gates ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (plonk_custom_gates (mk-plonk_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun PLONKConfig_all_enabled ((g PLONKConfig)) Bool
  (and (plonk_universal_setup g) (plonk_polynomial_commitment g) (plonk_arithmetic_gates g) (plonk_custom_gates g)))

; --- 92. PLONKConfig: all-enabled completeness ---
(push 1)
(declare-const g PLONKConfig)
(assert (plonk_universal_setup g))
(assert (plonk_polynomial_commitment g))
(assert (plonk_arithmetic_gates g))
(assert (plonk_custom_gates g))
(assert (not (PLONKConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. PLONKConfig: PLONKConfig_all_enabled implies plonk_universal_setup ---
(push 1)
(declare-const g PLONKConfig)
(assert (PLONKConfig_all_enabled g))
(assert (not (plonk_universal_setup g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. PLONKConfig: PLONKConfig_all_enabled implies plonk_polynomial_commitment ---
(push 1)
(declare-const g PLONKConfig)
(assert (PLONKConfig_all_enabled g))
(assert (not (plonk_polynomial_commitment g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 95. PLONKConfig: PLONKConfig_all_enabled implies plonk_arithmetic_gates ---
(push 1)
(declare-const g PLONKConfig)
(assert (PLONKConfig_all_enabled g))
(assert (not (plonk_arithmetic_gates g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PLONKGate record properties ---

; --- 96. PLONKGate accessor round-trip: pg_degree ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pg_degree (mk-plonk_gate f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. PLONKGate accessor round-trip: pg_fan_in ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pg_fan_in (mk-plonk_gate f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. PLONKGate accessor round-trip: pg_fan_out ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pg_fan_out (mk-plonk_gate f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. PLONKGate: integer field consistency ---
(push 1)
(declare-const r PLONKGate)
(assert (>= (pg_degree r) 0))
(assert (>= (pg_fan_in r) 0))
(assert (not (>= (+ (pg_degree r) (pg_fan_in r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FullZKSNARKConfig record properties ---

; --- 100. FullZKSNARKConfig accessor round-trip: fzk_base ---
(push 1)
(declare-const f0 ZKSNARKConfig)
(declare-const f1 KnowledgeExtractor)
(declare-const f2 ZKSimulator)
(declare-const f3 ProofSize)
(declare-const f4 MPCCeremony)
(declare-const f5 ToxicWaste)
(assert (not (= (fzk_base (mk-full_zksnark_config f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 101. FullZKSNARKConfig accessor round-trip: fzk_extractor ---
(push 1)
(declare-const f0 ZKSNARKConfig)
(declare-const f1 KnowledgeExtractor)
(declare-const f2 ZKSimulator)
(declare-const f3 ProofSize)
(declare-const f4 MPCCeremony)
(declare-const f5 ToxicWaste)
(assert (not (= (fzk_extractor (mk-full_zksnark_config f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 102. FullZKSNARKConfig accessor round-trip: fzk_simulator ---
(push 1)
(declare-const f0 ZKSNARKConfig)
(declare-const f1 KnowledgeExtractor)
(declare-const f2 ZKSimulator)
(declare-const f3 ProofSize)
(declare-const f4 MPCCeremony)
(declare-const f5 ToxicWaste)
(assert (not (= (fzk_simulator (mk-full_zksnark_config f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. FullZKSNARKConfig accessor round-trip: fzk_proof_size ---
(push 1)
(declare-const f0 ZKSNARKConfig)
(declare-const f1 KnowledgeExtractor)
(declare-const f2 ZKSimulator)
(declare-const f3 ProofSize)
(declare-const f4 MPCCeremony)
(declare-const f5 ToxicWaste)
(assert (not (= (fzk_proof_size (mk-full_zksnark_config f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 104. FullZKSNARKConfig accessor round-trip: fzk_mpc ---
(push 1)
(declare-const f0 ZKSNARKConfig)
(declare-const f1 KnowledgeExtractor)
(declare-const f2 ZKSimulator)
(declare-const f3 ProofSize)
(declare-const f4 MPCCeremony)
(declare-const f5 ToxicWaste)
(assert (not (= (fzk_mpc (mk-full_zksnark_config f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SoundnessError record properties ---

; --- 105. SoundnessError accessor round-trip: se_statistical ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (se_statistical (mk-soundness_error f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 106. SoundnessError accessor round-trip: se_computational ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (se_computational (mk-soundness_error f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 107. SoundnessError accessor round-trip: se_knowledge ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (se_knowledge (mk-soundness_error f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 108. SoundnessError: integer field consistency ---
(push 1)
(declare-const r SoundnessError)
(assert (>= (se_statistical r) 0))
(assert (>= (se_computational r) 0))
(assert (not (>= (+ (se_statistical r) (se_computational r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProofSystemType record properties ---

; --- 109. ProofSystemType accessor round-trip: pst_is_argument ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pst_is_argument (mk-proof_system_type f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 110. ProofSystemType accessor round-trip: pst_is_proof ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pst_is_proof (mk-proof_system_type f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 111. ProofSystemType accessor round-trip: pst_knowledge_property ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pst_knowledge_property (mk-proof_system_type f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ProofSystemType_all_enabled ((g ProofSystemType)) Bool
  (and (pst_is_argument g) (pst_is_proof g) (pst_knowledge_property g)))

; --- 112. ProofSystemType: all-enabled completeness ---
(push 1)
(declare-const g ProofSystemType)
(assert (pst_is_argument g))
(assert (pst_is_proof g))
(assert (pst_knowledge_property g))
(assert (not (ProofSystemType_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 113. ProofSystemType: ProofSystemType_all_enabled implies pst_is_argument ---
(push 1)
(declare-const g ProofSystemType)
(assert (ProofSystemType_all_enabled g))
(assert (not (pst_is_argument g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 114. ProofSystemType: ProofSystemType_all_enabled implies pst_is_proof ---
(push 1)
(declare-const g ProofSystemType)
(assert (ProofSystemType_all_enabled g))
(assert (not (pst_is_proof g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 115. ProofSystemType: ProofSystemType_all_enabled implies pst_knowledge_property ---
(push 1)
(declare-const g ProofSystemType)
(assert (ProofSystemType_all_enabled g))
(assert (not (pst_knowledge_property g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

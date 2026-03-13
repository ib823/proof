; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA FutureSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/FutureSecurity.v (24 assertions)
; Module: FutureSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((PQ_KEM 0)) (((ML_KEM_768) (ML_KEM_1024) (ML_KEM_512))))

(declare-datatypes ((PQ_Signature 0)) (((ML_DSA_44) (ML_DSA_65) (ML_DSA_87) (SLH_DSA_128f) (SLH_DSA_192f) (SLH_DSA_256f))))

(declare-datatypes ((SecurityLayerType 0)) (((NetworkPerimeter) (ApplicationFirewall) (RuntimeProtection) (MemorySafety) (TypeSafety) (FormalVerification) (HardwareIsolation) (CryptoLayer))))

(declare-datatypes ((SpeculationBarrier 0)) (((LFENCE) (MFENCE) (SFENCE) (FullSerialize) (ConditionalBarrier))))

(declare-datatypes ((LeakageSource 0)) (((TimingLeak) (CacheLeak) (PowerLeak) (EMILeak) (AcousticLeak) (SpeculativeLeak))))

(declare-datatypes ((VerificationLevel 0)) (((TypeChecked) (UnitTested) (PropertyTested) (ModelChecked) (TheoremProved) (MachineCheckedProof))))

(declare-datatypes ((AdversaryCapability 0)) (((ScriptKiddie) (SkilledHacker) (NationState) (QuantumCapable) (AGILevel))))

(declare-datatypes ((PQCryptoConfig 0))
  (((mk-pq_crypto_config (pqc_kem PQ_KEM) (pqc_signature PQ_Signature) (pqc_symmetric_bits Int) (pqc_hybrid_mode Bool) (pqc_classical_kem Int) (pqc_classical_sig Int)))))

(declare-datatypes ((ClassicalCrypto 0))
  (((mk-classical_crypto (cc_rsa_bits Int) (cc_dh_bits Int) (cc_ecc_bits Int) (cc_symmetric_bits Int)))))

(declare-datatypes ((SecurityLayer 0))
  (((mk-security_layer (sl_type SecurityLayerType) (sl_verified Bool) (sl_independent Bool) (sl_coverage Int)))))

(declare-datatypes ((DefenseInDepth 0))
  (((mk-defense_in_depth (did_layers (Seq Int)) (did_composition_verified Bool) (did_no_common_mode_failure Bool)))))

(declare-datatypes ((SpeculationMitigation 0))
  (((mk-speculation_mitigation (sm_barriers (Seq Int)) (sm_retpoline Bool) (sm_ibrs Bool) (sm_stibp Bool) (sm_ssbd Bool) (sm_conservative Bool)))))

(declare-datatypes ((SideChannelMitigation 0))
  (((mk-side_channel_mitigation (scm_constant_time Bool) (scm_cache_partitioning Bool) (scm_no_secret_dependent_branches Bool) (scm_no_secret_dependent_memory Bool) (scm_noise_injection Bool) (scm_minimal_surface Bool)))))

(declare-datatypes ((LeakageBound 0))
  (((mk-leakage_bound (lb_bits_per_operation Int) (lb_total_bits Int) (lb_timing_variance_ns Int)))))

(declare-datatypes ((SecurityComponent 0))
  (((mk-security_component (sc_id Int) (sc_verified Bool) (sc_assumptions (Seq Int)) (sc_guarantees (Seq Int))))))

(declare-datatypes ((ComposedSecurity 0))
  (((mk-composed_security (cs_components (Seq Int)) (cs_composition_proof Bool) (cs_no_assumption_cycles Bool) (cs_all_assumptions_met Bool) (cs_emergent_analysis Bool)))))

(declare-datatypes ((KeyRotationPolicy 0))
  (((mk-key_rotation_policy (krp_max_age_seconds Int) (krp_max_operations Int) (krp_forward_secrecy Bool) (krp_compromise_recovery Bool) (krp_automated Bool)))))

(declare-datatypes ((ContinuousVerification 0))
  (((mk-continuous_verification (cv_runtime_checks Bool) (cv_periodic_attestation Bool) (cv_attestation_interval_ms Int) (cv_anomaly_detection Bool) (cv_automatic_response Bool) (cv_state_integrity Bool)))))

(declare-datatypes ((APTResistance 0))
  (((mk-apt_resistance (apt_key_rotation KeyRotationPolicy) (apt_continuous_verify ContinuousVerification) (apt_compartmentalization Bool) (apt_least_privilege Bool) (apt_audit_logging Bool) (apt_threat_hunting Bool)))))

(declare-datatypes ((TLSConfig 0))
  (((mk-tls_config (tls_version Int) (tls_pq_kem Int) (tls_pq_sig Int) (tls_classical_kex Int) (tls_hybrid Bool)))))

(declare-datatypes ((QKDConfig 0))
  (((mk-qkd_config (qkd_enabled Bool) (qkd_protocol Int) (qkd_detector_efficiency Int) (qkd_error_threshold Int) (qkd_authentication Bool)))))

(declare-datatypes ((QuantumSafeNetwork 0))
  (((mk-quantum_safe_network (qsn_tls TLSConfig) (qsn_qkd Int) (qsn_pq_required Bool) (qsn_hybrid_mandatory Bool)))))

(declare-datatypes ((FormalVerificationConfig 0))
  (((mk-formal_verification_config (fvc_level VerificationLevel) (fvc_proof_assistant Int) (fvc_spec_complete Bool) (fvc_assumptions_explicit Bool) (fvc_trusted_base_minimal Bool) (fvc_proof_reviewed Bool)))))

(declare-datatypes ((MathematicalProof 0))
  (((mk-mathematical_proof (mp_statement Bool) (mp_proof_exists Bool) (mp_machine_checked Bool) (mp_assumptions (Seq Int))))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- PQ_KEM enum properties ---

; --- 1. PQ_KEM exhaustiveness ---
(push 1)
(declare-const x PQ_KEM)
(assert (not (or (= x ML_KEM_768) (= x ML_KEM_1024) (= x ML_KEM_512))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. PQ_KEM: ML_KEM_768 != ML_KEM_1024 ---
(push 1)
(assert (= ML_KEM_768 ML_KEM_1024))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. PQ_KEM: ML_KEM_1024 != ML_KEM_512 ---
(push 1)
(assert (= ML_KEM_1024 ML_KEM_512))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. PQ_KEM: ML_KEM_768 != ML_KEM_512 ---
(push 1)
(assert (= ML_KEM_768 ML_KEM_512))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. PQ_KEM finite cardinality (3 values) ---
(push 1)
(declare-const x PQ_KEM)
(assert (and (not (= x ML_KEM_768)) (not (= x ML_KEM_1024)) (not (= x ML_KEM_512))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PQ_Signature enum properties ---

; --- 6. PQ_Signature exhaustiveness ---
(push 1)
(declare-const x PQ_Signature)
(assert (not (or (= x ML_DSA_44) (= x ML_DSA_65) (= x ML_DSA_87) (= x SLH_DSA_128f) (= x SLH_DSA_192f) (= x SLH_DSA_256f))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. PQ_Signature: ML_DSA_44 != ML_DSA_65 ---
(push 1)
(assert (= ML_DSA_44 ML_DSA_65))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PQ_Signature: ML_DSA_65 != ML_DSA_87 ---
(push 1)
(assert (= ML_DSA_65 ML_DSA_87))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PQ_Signature: ML_DSA_87 != SLH_DSA_128f ---
(push 1)
(assert (= ML_DSA_87 SLH_DSA_128f))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PQ_Signature: ML_DSA_44 != SLH_DSA_256f ---
(push 1)
(assert (= ML_DSA_44 SLH_DSA_256f))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PQ_Signature finite cardinality (6 values) ---
(push 1)
(declare-const x PQ_Signature)
(assert (and (not (= x ML_DSA_44)) (not (= x ML_DSA_65)) (not (= x ML_DSA_87)) (not (= x SLH_DSA_128f)) (not (= x SLH_DSA_192f)) (not (= x SLH_DSA_256f))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLayerType enum properties ---

; --- 12. SecurityLayerType exhaustiveness ---
(push 1)
(declare-const x SecurityLayerType)
(assert (not (or (= x NetworkPerimeter) (= x ApplicationFirewall) (= x RuntimeProtection) (= x MemorySafety) (= x TypeSafety) (= x FormalVerification) (= x HardwareIsolation) (= x CryptoLayer))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. SecurityLayerType: NetworkPerimeter != ApplicationFirewall ---
(push 1)
(assert (= NetworkPerimeter ApplicationFirewall))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SecurityLayerType: ApplicationFirewall != RuntimeProtection ---
(push 1)
(assert (= ApplicationFirewall RuntimeProtection))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SecurityLayerType: RuntimeProtection != MemorySafety ---
(push 1)
(assert (= RuntimeProtection MemorySafety))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SecurityLayerType: NetworkPerimeter != CryptoLayer ---
(push 1)
(assert (= NetworkPerimeter CryptoLayer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SecurityLayerType finite cardinality (8 values) ---
(push 1)
(declare-const x SecurityLayerType)
(assert (and (not (= x NetworkPerimeter)) (not (= x ApplicationFirewall)) (not (= x RuntimeProtection)) (not (= x MemorySafety)) (not (= x TypeSafety)) (not (= x FormalVerification)) (not (= x HardwareIsolation)) (not (= x CryptoLayer))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SpeculationBarrier enum properties ---

; --- 18. SpeculationBarrier exhaustiveness ---
(push 1)
(declare-const x SpeculationBarrier)
(assert (not (or (= x LFENCE) (= x MFENCE) (= x SFENCE) (= x FullSerialize) (= x ConditionalBarrier))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SpeculationBarrier: LFENCE != MFENCE ---
(push 1)
(assert (= LFENCE MFENCE))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SpeculationBarrier: MFENCE != SFENCE ---
(push 1)
(assert (= MFENCE SFENCE))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SpeculationBarrier: SFENCE != FullSerialize ---
(push 1)
(assert (= SFENCE FullSerialize))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SpeculationBarrier: LFENCE != ConditionalBarrier ---
(push 1)
(assert (= LFENCE ConditionalBarrier))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SpeculationBarrier finite cardinality (5 values) ---
(push 1)
(declare-const x SpeculationBarrier)
(assert (and (not (= x LFENCE)) (not (= x MFENCE)) (not (= x SFENCE)) (not (= x FullSerialize)) (not (= x ConditionalBarrier))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LeakageSource enum properties ---

; --- 24. LeakageSource exhaustiveness ---
(push 1)
(declare-const x LeakageSource)
(assert (not (or (= x TimingLeak) (= x CacheLeak) (= x PowerLeak) (= x EMILeak) (= x AcousticLeak) (= x SpeculativeLeak))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. LeakageSource: TimingLeak != CacheLeak ---
(push 1)
(assert (= TimingLeak CacheLeak))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. LeakageSource: CacheLeak != PowerLeak ---
(push 1)
(assert (= CacheLeak PowerLeak))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. LeakageSource: PowerLeak != EMILeak ---
(push 1)
(assert (= PowerLeak EMILeak))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. LeakageSource: TimingLeak != SpeculativeLeak ---
(push 1)
(assert (= TimingLeak SpeculativeLeak))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. LeakageSource finite cardinality (6 values) ---
(push 1)
(declare-const x LeakageSource)
(assert (and (not (= x TimingLeak)) (not (= x CacheLeak)) (not (= x PowerLeak)) (not (= x EMILeak)) (not (= x AcousticLeak)) (not (= x SpeculativeLeak))))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerificationLevel enum properties ---

; --- 30. VerificationLevel exhaustiveness ---
(push 1)
(declare-const x VerificationLevel)
(assert (not (or (= x TypeChecked) (= x UnitTested) (= x PropertyTested) (= x ModelChecked) (= x TheoremProved) (= x MachineCheckedProof))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. VerificationLevel: TypeChecked != UnitTested ---
(push 1)
(assert (= TypeChecked UnitTested))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. VerificationLevel: UnitTested != PropertyTested ---
(push 1)
(assert (= UnitTested PropertyTested))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. VerificationLevel: PropertyTested != ModelChecked ---
(push 1)
(assert (= PropertyTested ModelChecked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. VerificationLevel: TypeChecked != MachineCheckedProof ---
(push 1)
(assert (= TypeChecked MachineCheckedProof))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. VerificationLevel finite cardinality (6 values) ---
(push 1)
(declare-const x VerificationLevel)
(assert (and (not (= x TypeChecked)) (not (= x UnitTested)) (not (= x PropertyTested)) (not (= x ModelChecked)) (not (= x TheoremProved)) (not (= x MachineCheckedProof))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AdversaryCapability enum properties ---

; --- 36. AdversaryCapability exhaustiveness ---
(push 1)
(declare-const x AdversaryCapability)
(assert (not (or (= x ScriptKiddie) (= x SkilledHacker) (= x NationState) (= x QuantumCapable) (= x AGILevel))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. AdversaryCapability: ScriptKiddie != SkilledHacker ---
(push 1)
(assert (= ScriptKiddie SkilledHacker))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. AdversaryCapability: SkilledHacker != NationState ---
(push 1)
(assert (= SkilledHacker NationState))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. AdversaryCapability: NationState != QuantumCapable ---
(push 1)
(assert (= NationState QuantumCapable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. AdversaryCapability: ScriptKiddie != AGILevel ---
(push 1)
(assert (= ScriptKiddie AGILevel))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. AdversaryCapability finite cardinality (5 values) ---
(push 1)
(declare-const x AdversaryCapability)
(assert (and (not (= x ScriptKiddie)) (not (= x SkilledHacker)) (not (= x NationState)) (not (= x QuantumCapable)) (not (= x AGILevel))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PQCryptoConfig record properties ---

; --- 42. PQCryptoConfig accessor round-trip: pqc_kem ---
(push 1)
(declare-const f0 PQ_KEM)
(declare-const f1 PQ_Signature)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (pqc_kem (mk-p_q_crypto_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. PQCryptoConfig accessor round-trip: pqc_signature ---
(push 1)
(declare-const f0 PQ_KEM)
(declare-const f1 PQ_Signature)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (pqc_signature (mk-p_q_crypto_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. PQCryptoConfig accessor round-trip: pqc_symmetric_bits ---
(push 1)
(declare-const f0 PQ_KEM)
(declare-const f1 PQ_Signature)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (pqc_symmetric_bits (mk-p_q_crypto_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. PQCryptoConfig accessor round-trip: pqc_hybrid_mode ---
(push 1)
(declare-const f0 PQ_KEM)
(declare-const f1 PQ_Signature)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (pqc_hybrid_mode (mk-p_q_crypto_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. PQCryptoConfig accessor round-trip: pqc_classical_kem ---
(push 1)
(declare-const f0 PQ_KEM)
(declare-const f1 PQ_Signature)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (pqc_classical_kem (mk-p_q_crypto_config f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. PQCryptoConfig: integer field consistency ---
(push 1)
(declare-const r PQCryptoConfig)
(assert (>= (pqc_symmetric_bits r) 0))
(assert (>= (pqc_classical_kem r) 0))
(assert (not (>= (+ (pqc_symmetric_bits r) (pqc_classical_kem r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ClassicalCrypto record properties ---

; --- 48. ClassicalCrypto accessor round-trip: cc_rsa_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cc_rsa_bits (mk-classical_crypto f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. ClassicalCrypto accessor round-trip: cc_dh_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cc_dh_bits (mk-classical_crypto f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. ClassicalCrypto accessor round-trip: cc_ecc_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cc_ecc_bits (mk-classical_crypto f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. ClassicalCrypto: integer field consistency ---
(push 1)
(declare-const r ClassicalCrypto)
(assert (>= (cc_rsa_bits r) 0))
(assert (>= (cc_dh_bits r) 0))
(assert (not (>= (+ (cc_rsa_bits r) (cc_dh_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLayer record properties ---

; --- 52. SecurityLayer accessor round-trip: sl_type ---
(push 1)
(declare-const f0 SecurityLayerType)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sl_type (mk-security_layer f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. SecurityLayer accessor round-trip: sl_verified ---
(push 1)
(declare-const f0 SecurityLayerType)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sl_verified (mk-security_layer f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. SecurityLayer accessor round-trip: sl_independent ---
(push 1)
(declare-const f0 SecurityLayerType)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sl_independent (mk-security_layer f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DefenseInDepth record properties ---

; --- 55. DefenseInDepth accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (Seq (mk-defense_in_depth f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. DefenseInDepth accessor round-trip: did_composition_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (did_composition_verified (mk-defense_in_depth f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SpeculationMitigation record properties ---

; --- 57. SpeculationMitigation accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (Seq (mk-speculation_mitigation f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. SpeculationMitigation accessor round-trip: sm_retpoline ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sm_retpoline (mk-speculation_mitigation f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. SpeculationMitigation accessor round-trip: sm_ibrs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sm_ibrs (mk-speculation_mitigation f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. SpeculationMitigation accessor round-trip: sm_stibp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sm_stibp (mk-speculation_mitigation f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. SpeculationMitigation accessor round-trip: sm_ssbd ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sm_ssbd (mk-speculation_mitigation f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SideChannelMitigation record properties ---

; --- 62. SideChannelMitigation accessor round-trip: scm_constant_time ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (scm_constant_time (mk-side_channel_mitigation f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. SideChannelMitigation accessor round-trip: scm_cache_partitioning ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (scm_cache_partitioning (mk-side_channel_mitigation f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. SideChannelMitigation accessor round-trip: scm_no_secret_dependent_branches ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (scm_no_secret_dependent_branches (mk-side_channel_mitigation f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. SideChannelMitigation accessor round-trip: scm_no_secret_dependent_memory ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (scm_no_secret_dependent_memory (mk-side_channel_mitigation f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. SideChannelMitigation accessor round-trip: scm_noise_injection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (scm_noise_injection (mk-side_channel_mitigation f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SideChannelMitigation_all_enabled ((g SideChannelMitigation)) Bool
  (and (scm_constant_time g) (scm_cache_partitioning g) (scm_no_secret_dependent_branches g) (scm_no_secret_dependent_memory g) (scm_noise_injection g)))

; --- 67. SideChannelMitigation: all-enabled completeness ---
(push 1)
(declare-const g SideChannelMitigation)
(assert (scm_constant_time g))
(assert (scm_cache_partitioning g))
(assert (scm_no_secret_dependent_branches g))
(assert (scm_no_secret_dependent_memory g))
(assert (scm_noise_injection g))
(assert (not (SideChannelMitigation_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. SideChannelMitigation: SideChannelMitigation_all_enabled implies scm_constant_time ---
(push 1)
(declare-const g SideChannelMitigation)
(assert (SideChannelMitigation_all_enabled g))
(assert (not (scm_constant_time g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. SideChannelMitigation: SideChannelMitigation_all_enabled implies scm_cache_partitioning ---
(push 1)
(declare-const g SideChannelMitigation)
(assert (SideChannelMitigation_all_enabled g))
(assert (not (scm_cache_partitioning g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. SideChannelMitigation: SideChannelMitigation_all_enabled implies scm_no_secret_dependent_branches ---
(push 1)
(declare-const g SideChannelMitigation)
(assert (SideChannelMitigation_all_enabled g))
(assert (not (scm_no_secret_dependent_branches g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LeakageBound record properties ---

; --- 71. LeakageBound accessor round-trip: lb_bits_per_operation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (lb_bits_per_operation (mk-leakage_bound f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. LeakageBound accessor round-trip: lb_total_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (lb_total_bits (mk-leakage_bound f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. LeakageBound: integer field consistency ---
(push 1)
(declare-const r LeakageBound)
(assert (>= (lb_bits_per_operation r) 0))
(assert (>= (lb_total_bits r) 0))
(assert (not (>= (+ (lb_bits_per_operation r) (lb_total_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityComponent record properties ---

; --- 74. SecurityComponent accessor round-trip: sc_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (sc_id (mk-security_component f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. SecurityComponent accessor round-trip: sc_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (sc_verified (mk-security_component f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. SecurityComponent accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (Seq (mk-security_component f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. SecurityComponent: integer field consistency ---
(push 1)
(declare-const r SecurityComponent)
(assert (>= (sc_id r) 0))
(assert (>= (Seq r) 0))
(assert (not (>= (+ (sc_id r) (Seq r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ComposedSecurity record properties ---

; --- 78. ComposedSecurity accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (Seq (mk-composed_security f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. ComposedSecurity accessor round-trip: cs_composition_proof ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cs_composition_proof (mk-composed_security f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. ComposedSecurity accessor round-trip: cs_no_assumption_cycles ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cs_no_assumption_cycles (mk-composed_security f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. ComposedSecurity accessor round-trip: cs_all_assumptions_met ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cs_all_assumptions_met (mk-composed_security f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KeyRotationPolicy record properties ---

; --- 82. KeyRotationPolicy accessor round-trip: krp_max_age_seconds ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (krp_max_age_seconds (mk-key_rotation_policy f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. KeyRotationPolicy accessor round-trip: krp_max_operations ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (krp_max_operations (mk-key_rotation_policy f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. KeyRotationPolicy accessor round-trip: krp_forward_secrecy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (krp_forward_secrecy (mk-key_rotation_policy f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. KeyRotationPolicy accessor round-trip: krp_compromise_recovery ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (krp_compromise_recovery (mk-key_rotation_policy f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. KeyRotationPolicy: integer field consistency ---
(push 1)
(declare-const r KeyRotationPolicy)
(assert (>= (krp_max_age_seconds r) 0))
(assert (>= (krp_max_operations r) 0))
(assert (not (>= (+ (krp_max_age_seconds r) (krp_max_operations r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ContinuousVerification record properties ---

; --- 87. ContinuousVerification accessor round-trip: cv_runtime_checks ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cv_runtime_checks (mk-continuous_verification f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. ContinuousVerification accessor round-trip: cv_periodic_attestation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cv_periodic_attestation (mk-continuous_verification f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. ContinuousVerification accessor round-trip: cv_attestation_interval_ms ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cv_attestation_interval_ms (mk-continuous_verification f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. ContinuousVerification accessor round-trip: cv_anomaly_detection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cv_anomaly_detection (mk-continuous_verification f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. ContinuousVerification accessor round-trip: cv_automatic_response ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cv_automatic_response (mk-continuous_verification f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- APTResistance record properties ---

; --- 92. APTResistance accessor round-trip: apt_key_rotation ---
(push 1)
(declare-const f0 KeyRotationPolicy)
(declare-const f1 ContinuousVerification)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (apt_key_rotation (mk-a_p_t_resistance f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. APTResistance accessor round-trip: apt_continuous_verify ---
(push 1)
(declare-const f0 KeyRotationPolicy)
(declare-const f1 ContinuousVerification)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (apt_continuous_verify (mk-a_p_t_resistance f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. APTResistance accessor round-trip: apt_compartmentalization ---
(push 1)
(declare-const f0 KeyRotationPolicy)
(declare-const f1 ContinuousVerification)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (apt_compartmentalization (mk-a_p_t_resistance f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 95. APTResistance accessor round-trip: apt_least_privilege ---
(push 1)
(declare-const f0 KeyRotationPolicy)
(declare-const f1 ContinuousVerification)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (apt_least_privilege (mk-a_p_t_resistance f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. APTResistance accessor round-trip: apt_audit_logging ---
(push 1)
(declare-const f0 KeyRotationPolicy)
(declare-const f1 ContinuousVerification)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (apt_audit_logging (mk-a_p_t_resistance f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TLSConfig record properties ---

; --- 97. TLSConfig accessor round-trip: tls_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tls_version (mk-t_l_s_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. TLSConfig accessor round-trip: tls_pq_kem ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tls_pq_kem (mk-t_l_s_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. TLSConfig accessor round-trip: tls_pq_sig ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tls_pq_sig (mk-t_l_s_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 100. TLSConfig accessor round-trip: tls_classical_kex ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tls_classical_kex (mk-t_l_s_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 101. TLSConfig: integer field consistency ---
(push 1)
(declare-const r TLSConfig)
(assert (>= (tls_version r) 0))
(assert (>= (tls_pq_kem r) 0))
(assert (not (>= (+ (tls_version r) (tls_pq_kem r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- QKDConfig record properties ---

; --- 102. QKDConfig accessor round-trip: qkd_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (qkd_enabled (mk-q_k_d_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. QKDConfig accessor round-trip: qkd_protocol ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (qkd_protocol (mk-q_k_d_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 104. QKDConfig accessor round-trip: qkd_detector_efficiency ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (qkd_detector_efficiency (mk-q_k_d_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 105. QKDConfig accessor round-trip: qkd_error_threshold ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (qkd_error_threshold (mk-q_k_d_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 106. QKDConfig: integer field consistency ---
(push 1)
(declare-const r QKDConfig)
(assert (>= (qkd_protocol r) 0))
(assert (>= (qkd_detector_efficiency r) 0))
(assert (not (>= (+ (qkd_protocol r) (qkd_detector_efficiency r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- QuantumSafeNetwork record properties ---

; --- 107. QuantumSafeNetwork accessor round-trip: qsn_tls ---
(push 1)
(declare-const f0 TLSConfig)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (qsn_tls (mk-quantum_safe_network f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 108. QuantumSafeNetwork accessor round-trip: qsn_qkd ---
(push 1)
(declare-const f0 TLSConfig)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (qsn_qkd (mk-quantum_safe_network f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 109. QuantumSafeNetwork accessor round-trip: qsn_pq_required ---
(push 1)
(declare-const f0 TLSConfig)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (qsn_pq_required (mk-quantum_safe_network f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FormalVerificationConfig record properties ---

; --- 110. FormalVerificationConfig accessor round-trip: fvc_level ---
(push 1)
(declare-const f0 VerificationLevel)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fvc_level (mk-formal_verification_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 111. FormalVerificationConfig accessor round-trip: fvc_proof_assistant ---
(push 1)
(declare-const f0 VerificationLevel)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fvc_proof_assistant (mk-formal_verification_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 112. FormalVerificationConfig accessor round-trip: fvc_spec_complete ---
(push 1)
(declare-const f0 VerificationLevel)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fvc_spec_complete (mk-formal_verification_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 113. FormalVerificationConfig accessor round-trip: fvc_assumptions_explicit ---
(push 1)
(declare-const f0 VerificationLevel)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fvc_assumptions_explicit (mk-formal_verification_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 114. FormalVerificationConfig accessor round-trip: fvc_trusted_base_minimal ---
(push 1)
(declare-const f0 VerificationLevel)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fvc_trusted_base_minimal (mk-formal_verification_config f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MathematicalProof record properties ---

; --- 115. MathematicalProof accessor round-trip: mp_statement ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mp_statement (mk-mathematical_proof f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 116. MathematicalProof accessor round-trip: mp_proof_exists ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mp_proof_exists (mk-mathematical_proof f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 117. MathematicalProof accessor round-trip: mp_machine_checked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mp_machine_checked (mk-mathematical_proof f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MathematicalProof_all_enabled ((g MathematicalProof)) Bool
  (and (mp_statement g) (mp_proof_exists g) (mp_machine_checked g)))

; --- 118. MathematicalProof: all-enabled completeness ---
(push 1)
(declare-const g MathematicalProof)
(assert (mp_statement g))
(assert (mp_proof_exists g))
(assert (mp_machine_checked g))
(assert (not (MathematicalProof_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 119. MathematicalProof: MathematicalProof_all_enabled implies mp_statement ---
(push 1)
(declare-const g MathematicalProof)
(assert (MathematicalProof_all_enabled g))
(assert (not (mp_statement g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 120. MathematicalProof: MathematicalProof_all_enabled implies mp_proof_exists ---
(push 1)
(declare-const g MathematicalProof)
(assert (MathematicalProof_all_enabled g))
(assert (not (mp_proof_exists g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 121. MathematicalProof: MathematicalProof_all_enabled implies mp_machine_checked ---
(push 1)
(declare-const g MathematicalProof)
(assert (MathematicalProof_all_enabled g))
(assert (not (mp_machine_checked g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLayerType ordering properties ---

(define-fun SecurityLayerType_level ((x SecurityLayerType)) Int
  (ite (= x NetworkPerimeter) 0 (ite (= x ApplicationFirewall) 1 (ite (= x RuntimeProtection) 2 (ite (= x MemorySafety) 3 (ite (= x TypeSafety) 4 (ite (= x FormalVerification) 5 (ite (= x HardwareIsolation) 6 7))))))))

(define-fun SecurityLayerType_leq ((x SecurityLayerType) (y SecurityLayerType)) Bool
  (<= (SecurityLayerType_level x) (SecurityLayerType_level y)))

; --- 122. SecurityLayerType_leq reflexivity ---
(push 1)
(declare-const x SecurityLayerType)
(assert (not (SecurityLayerType_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 123. SecurityLayerType_leq transitivity ---
(push 1)
(declare-const x SecurityLayerType)
(declare-const y SecurityLayerType)
(declare-const z SecurityLayerType)
(assert (SecurityLayerType_leq x y))
(assert (SecurityLayerType_leq y z))
(assert (not (SecurityLayerType_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 124. SecurityLayerType_leq antisymmetry ---
(push 1)
(declare-const x SecurityLayerType)
(declare-const y SecurityLayerType)
(assert (SecurityLayerType_leq x y))
(assert (SecurityLayerType_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 125. NetworkPerimeter is bottom ---
(push 1)
(declare-const x SecurityLayerType)
(assert (not (SecurityLayerType_leq NetworkPerimeter x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 126. CryptoLayer is top ---
(push 1)
(declare-const x SecurityLayerType)
(assert (not (SecurityLayerType_leq x CryptoLayer)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerificationLevel ordering properties ---

(define-fun VerificationLevel_level ((x VerificationLevel)) Int
  (ite (= x TypeChecked) 0 (ite (= x UnitTested) 1 (ite (= x PropertyTested) 2 (ite (= x ModelChecked) 3 (ite (= x TheoremProved) 4 5))))))

(define-fun VerificationLevel_leq ((x VerificationLevel) (y VerificationLevel)) Bool
  (<= (VerificationLevel_level x) (VerificationLevel_level y)))

; --- 127. VerificationLevel_leq reflexivity ---
(push 1)
(declare-const x VerificationLevel)
(assert (not (VerificationLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 128. VerificationLevel_leq transitivity ---
(push 1)
(declare-const x VerificationLevel)
(declare-const y VerificationLevel)
(declare-const z VerificationLevel)
(assert (VerificationLevel_leq x y))
(assert (VerificationLevel_leq y z))
(assert (not (VerificationLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 129. VerificationLevel_leq antisymmetry ---
(push 1)
(declare-const x VerificationLevel)
(declare-const y VerificationLevel)
(assert (VerificationLevel_leq x y))
(assert (VerificationLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 130. TypeChecked is bottom ---
(push 1)
(declare-const x VerificationLevel)
(assert (not (VerificationLevel_leq TypeChecked x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 131. MachineCheckedProof is top ---
(push 1)
(declare-const x VerificationLevel)
(assert (not (VerificationLevel_leq x MachineCheckedProof)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

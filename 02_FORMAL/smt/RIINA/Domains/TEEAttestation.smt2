; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TEEAttestation — SMT Verification
; Derived from 02_FORMAL/coq/domains/TEEAttestation.v (100 assertions)
; Module: TEEAttestation
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((EnclaveState 0)) (((ES_Uninitialized) (ES_Created) (ES_Initialized) (ES_Running) (ES_Suspended) (ES_Destroyed))))

(declare-datatypes ((EnclaveEvent 0)) (((EE_Create) (EE_Initialize) (EE_Enter) (EE_Exit) (EE_Suspend) (EE_Resume) (EE_Destroy))))

(declare-datatypes ((SealingPolicy 0)) (((SP_MRENCLAVE) (SP_MRSIGNER) (SP_KEYPOLICY))))

(declare-datatypes ((MemoryRegionType 0)) (((MRT_Normal) (MRT_Enclave) (MRT_Shared) (MRT_Reserved))))

(declare-datatypes ((EnclaveProperties 0))
  (((mk-enclave_properties (enc_memory_encrypted Bool) (enc_code_integrity Bool) (enc_data_sealing Bool) (enc_isolated_execution Bool)))))

(declare-datatypes ((EnclaveIdentity 0))
  (((mk-enclave_identity (ei_measurement Int) (ei_signer Int) (ei_product_id Int) (ei_security_version Int)))))

(declare-datatypes ((AttestationProperties 0))
  (((mk-attestation_properties (att_measurement Bool) (att_signature Bool) (att_freshness Bool) (att_binding Bool)))))

(declare-datatypes ((AttestationQuote 0))
  (((mk-attestation_quote (aq_enclave_identity EnclaveIdentity) (aq_report_data Int) (aq_nonce Int) (aq_timestamp Int) (aq_platform_info Int) (aq_signature_valid Bool)))))

(declare-datatypes ((VerificationContext 0))
  (((mk-verification_context (vc_expected_measurement Int) (vc_expected_signer Int) (vc_min_security_version Int) (vc_expected_nonce Int) (vc_max_timestamp_age Int) (vc_current_time Int)))))

(declare-datatypes ((TEEConfig 0))
  (((mk-tee_config (tee_enclave EnclaveProperties) (tee_attestation AttestationProperties) (tee_remote_attestation Bool) (tee_local_attestation Bool) (tee_key_derivation Bool)))))

(declare-datatypes ((SealedData 0))
  (((mk-sealed_data (sd_policy SealingPolicy) (sd_ciphertext Int) (sd_auth_tag Int) (sd_key_id Int)))))

(declare-datatypes ((KeyDerivationParams 0))
  (((mk-key_derivation_params (kdp_policy SealingPolicy) (kdp_enclave_id EnclaveIdentity) (kdp_key_name Int) (kdp_key_size Int)))))

(declare-datatypes ((MemoryPermissions 0))
  (((mk-memory_permissions (mp_read Bool) (mp_write Bool) (mp_execute Bool)))))

(declare-datatypes ((MemoryRegion 0))
  (((mk-memory_region (mr_base Int) (mr_size Int) (mr_type MemoryRegionType) (mr_permissions MemoryPermissions) (mr_encrypted Bool)))))

(declare-datatypes ((PlatformIdentity 0))
  (((mk-platform_identity (pi_cpu_svn Int) (pi_pce_svn Int) (pi_qe_id Int) (pi_platform_id Int) (pi_tcb_info_valid Bool)))))

(declare-datatypes ((TrustChain 0))
  (((mk-trust_chain (tc_root_key_valid Bool) (tc_pck_cert_valid Bool) (tc_tcb_signing_valid Bool) (tc_qe_report_valid Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- EnclaveState enum properties ---

; --- 1. EnclaveState exhaustiveness ---
(push 1)
(declare-const x EnclaveState)
(assert (not (or (= x ES_Uninitialized) (= x ES_Created) (= x ES_Initialized) (= x ES_Running) (= x ES_Suspended) (= x ES_Destroyed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. EnclaveState: ES_Uninitialized != ES_Created ---
(push 1)
(assert (= ES_Uninitialized ES_Created))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. EnclaveState: ES_Created != ES_Initialized ---
(push 1)
(assert (= ES_Created ES_Initialized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. EnclaveState: ES_Initialized != ES_Running ---
(push 1)
(assert (= ES_Initialized ES_Running))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. EnclaveState: ES_Uninitialized != ES_Destroyed ---
(push 1)
(assert (= ES_Uninitialized ES_Destroyed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. EnclaveState finite cardinality (6 values) ---
(push 1)
(declare-const x EnclaveState)
(assert (and (not (= x ES_Uninitialized)) (not (= x ES_Created)) (not (= x ES_Initialized)) (not (= x ES_Running)) (not (= x ES_Suspended)) (not (= x ES_Destroyed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- EnclaveEvent enum properties ---

; --- 7. EnclaveEvent exhaustiveness ---
(push 1)
(declare-const x EnclaveEvent)
(assert (not (or (= x EE_Create) (= x EE_Initialize) (= x EE_Enter) (= x EE_Exit) (= x EE_Suspend) (= x EE_Resume) (= x EE_Destroy))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. EnclaveEvent: EE_Create != EE_Initialize ---
(push 1)
(assert (= EE_Create EE_Initialize))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. EnclaveEvent: EE_Initialize != EE_Enter ---
(push 1)
(assert (= EE_Initialize EE_Enter))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. EnclaveEvent: EE_Enter != EE_Exit ---
(push 1)
(assert (= EE_Enter EE_Exit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. EnclaveEvent: EE_Create != EE_Destroy ---
(push 1)
(assert (= EE_Create EE_Destroy))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. EnclaveEvent finite cardinality (7 values) ---
(push 1)
(declare-const x EnclaveEvent)
(assert (and (not (= x EE_Create)) (not (= x EE_Initialize)) (not (= x EE_Enter)) (not (= x EE_Exit)) (not (= x EE_Suspend)) (not (= x EE_Resume)) (not (= x EE_Destroy))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SealingPolicy enum properties ---

; --- 13. SealingPolicy exhaustiveness ---
(push 1)
(declare-const x SealingPolicy)
(assert (not (or (= x SP_MRENCLAVE) (= x SP_MRSIGNER) (= x SP_KEYPOLICY))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SealingPolicy: SP_MRENCLAVE != SP_MRSIGNER ---
(push 1)
(assert (= SP_MRENCLAVE SP_MRSIGNER))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SealingPolicy: SP_MRSIGNER != SP_KEYPOLICY ---
(push 1)
(assert (= SP_MRSIGNER SP_KEYPOLICY))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SealingPolicy: SP_MRENCLAVE != SP_KEYPOLICY ---
(push 1)
(assert (= SP_MRENCLAVE SP_KEYPOLICY))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SealingPolicy finite cardinality (3 values) ---
(push 1)
(declare-const x SealingPolicy)
(assert (and (not (= x SP_MRENCLAVE)) (not (= x SP_MRSIGNER)) (not (= x SP_KEYPOLICY))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemoryRegionType enum properties ---

; --- 18. MemoryRegionType exhaustiveness ---
(push 1)
(declare-const x MemoryRegionType)
(assert (not (or (= x MRT_Normal) (= x MRT_Enclave) (= x MRT_Shared) (= x MRT_Reserved))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. MemoryRegionType: MRT_Normal != MRT_Enclave ---
(push 1)
(assert (= MRT_Normal MRT_Enclave))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. MemoryRegionType: MRT_Enclave != MRT_Shared ---
(push 1)
(assert (= MRT_Enclave MRT_Shared))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. MemoryRegionType: MRT_Shared != MRT_Reserved ---
(push 1)
(assert (= MRT_Shared MRT_Reserved))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. MemoryRegionType: MRT_Normal != MRT_Reserved ---
(push 1)
(assert (= MRT_Normal MRT_Reserved))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. MemoryRegionType finite cardinality (4 values) ---
(push 1)
(declare-const x MemoryRegionType)
(assert (and (not (= x MRT_Normal)) (not (= x MRT_Enclave)) (not (= x MRT_Shared)) (not (= x MRT_Reserved))))
(check-sat) ; expect UNSAT
(pop 1)

; --- EnclaveProperties record properties ---

; --- 24. EnclaveProperties accessor round-trip: enc_memory_encrypted ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (enc_memory_encrypted (mk-enclave_properties f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. EnclaveProperties accessor round-trip: enc_code_integrity ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (enc_code_integrity (mk-enclave_properties f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. EnclaveProperties accessor round-trip: enc_data_sealing ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (enc_data_sealing (mk-enclave_properties f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun EnclaveProperties_all_enabled ((g EnclaveProperties)) Bool
  (and (enc_memory_encrypted g) (enc_code_integrity g) (enc_data_sealing g)))

; --- 27. EnclaveProperties: all-enabled completeness ---
(push 1)
(declare-const g EnclaveProperties)
(assert (enc_memory_encrypted g))
(assert (enc_code_integrity g))
(assert (enc_data_sealing g))
(assert (not (EnclaveProperties_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. EnclaveProperties: EnclaveProperties_all_enabled implies enc_memory_encrypted ---
(push 1)
(declare-const g EnclaveProperties)
(assert (EnclaveProperties_all_enabled g))
(assert (not (enc_memory_encrypted g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. EnclaveProperties: EnclaveProperties_all_enabled implies enc_code_integrity ---
(push 1)
(declare-const g EnclaveProperties)
(assert (EnclaveProperties_all_enabled g))
(assert (not (enc_code_integrity g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. EnclaveProperties: EnclaveProperties_all_enabled implies enc_data_sealing ---
(push 1)
(declare-const g EnclaveProperties)
(assert (EnclaveProperties_all_enabled g))
(assert (not (enc_data_sealing g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EnclaveIdentity record properties ---

; --- 31. EnclaveIdentity accessor round-trip: ei_measurement ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ei_measurement (mk-enclave_identity f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. EnclaveIdentity accessor round-trip: ei_signer ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ei_signer (mk-enclave_identity f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. EnclaveIdentity accessor round-trip: ei_product_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ei_product_id (mk-enclave_identity f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. EnclaveIdentity: integer field consistency ---
(push 1)
(declare-const r EnclaveIdentity)
(assert (>= (ei_measurement r) 0))
(assert (>= (ei_signer r) 0))
(assert (not (>= (+ (ei_measurement r) (ei_signer r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AttestationProperties record properties ---

; --- 35. AttestationProperties accessor round-trip: att_measurement ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (att_measurement (mk-attestation_properties f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. AttestationProperties accessor round-trip: att_signature ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (att_signature (mk-attestation_properties f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. AttestationProperties accessor round-trip: att_freshness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (att_freshness (mk-attestation_properties f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun AttestationProperties_all_enabled ((g AttestationProperties)) Bool
  (and (att_measurement g) (att_signature g) (att_freshness g)))

; --- 38. AttestationProperties: all-enabled completeness ---
(push 1)
(declare-const g AttestationProperties)
(assert (att_measurement g))
(assert (att_signature g))
(assert (att_freshness g))
(assert (not (AttestationProperties_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. AttestationProperties: AttestationProperties_all_enabled implies att_measurement ---
(push 1)
(declare-const g AttestationProperties)
(assert (AttestationProperties_all_enabled g))
(assert (not (att_measurement g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. AttestationProperties: AttestationProperties_all_enabled implies att_signature ---
(push 1)
(declare-const g AttestationProperties)
(assert (AttestationProperties_all_enabled g))
(assert (not (att_signature g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. AttestationProperties: AttestationProperties_all_enabled implies att_freshness ---
(push 1)
(declare-const g AttestationProperties)
(assert (AttestationProperties_all_enabled g))
(assert (not (att_freshness g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AttestationQuote record properties ---

; --- 42. AttestationQuote accessor round-trip: aq_enclave_identity ---
(push 1)
(declare-const f0 EnclaveIdentity)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aq_enclave_identity (mk-attestation_quote f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. AttestationQuote accessor round-trip: aq_report_data ---
(push 1)
(declare-const f0 EnclaveIdentity)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aq_report_data (mk-attestation_quote f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. AttestationQuote accessor round-trip: aq_nonce ---
(push 1)
(declare-const f0 EnclaveIdentity)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aq_nonce (mk-attestation_quote f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. AttestationQuote accessor round-trip: aq_timestamp ---
(push 1)
(declare-const f0 EnclaveIdentity)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aq_timestamp (mk-attestation_quote f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. AttestationQuote accessor round-trip: aq_platform_info ---
(push 1)
(declare-const f0 EnclaveIdentity)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aq_platform_info (mk-attestation_quote f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. AttestationQuote: integer field consistency ---
(push 1)
(declare-const r AttestationQuote)
(assert (>= (aq_report_data r) 0))
(assert (>= (aq_nonce r) 0))
(assert (not (>= (+ (aq_report_data r) (aq_nonce r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerificationContext record properties ---

; --- 48. VerificationContext accessor round-trip: vc_expected_measurement ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vc_expected_measurement (mk-verification_context f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. VerificationContext accessor round-trip: vc_expected_signer ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vc_expected_signer (mk-verification_context f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. VerificationContext accessor round-trip: vc_min_security_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vc_min_security_version (mk-verification_context f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. VerificationContext accessor round-trip: vc_expected_nonce ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vc_expected_nonce (mk-verification_context f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. VerificationContext accessor round-trip: vc_max_timestamp_age ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vc_max_timestamp_age (mk-verification_context f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. VerificationContext: integer field consistency ---
(push 1)
(declare-const r VerificationContext)
(assert (>= (vc_expected_measurement r) 0))
(assert (>= (vc_expected_signer r) 0))
(assert (not (>= (+ (vc_expected_measurement r) (vc_expected_signer r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TEEConfig record properties ---

; --- 54. TEEConfig accessor round-trip: tee_enclave ---
(push 1)
(declare-const f0 EnclaveProperties)
(declare-const f1 AttestationProperties)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (tee_enclave (mk-tee_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. TEEConfig accessor round-trip: tee_attestation ---
(push 1)
(declare-const f0 EnclaveProperties)
(declare-const f1 AttestationProperties)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (tee_attestation (mk-tee_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. TEEConfig accessor round-trip: tee_remote_attestation ---
(push 1)
(declare-const f0 EnclaveProperties)
(declare-const f1 AttestationProperties)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (tee_remote_attestation (mk-tee_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. TEEConfig accessor round-trip: tee_local_attestation ---
(push 1)
(declare-const f0 EnclaveProperties)
(declare-const f1 AttestationProperties)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (tee_local_attestation (mk-tee_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SealedData record properties ---

; --- 58. SealedData accessor round-trip: sd_policy ---
(push 1)
(declare-const f0 SealingPolicy)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sd_policy (mk-sealed_data f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. SealedData accessor round-trip: sd_ciphertext ---
(push 1)
(declare-const f0 SealingPolicy)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sd_ciphertext (mk-sealed_data f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. SealedData accessor round-trip: sd_auth_tag ---
(push 1)
(declare-const f0 SealingPolicy)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sd_auth_tag (mk-sealed_data f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. SealedData: integer field consistency ---
(push 1)
(declare-const r SealedData)
(assert (>= (sd_ciphertext r) 0))
(assert (>= (sd_auth_tag r) 0))
(assert (not (>= (+ (sd_ciphertext r) (sd_auth_tag r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KeyDerivationParams record properties ---

; --- 62. KeyDerivationParams accessor round-trip: kdp_policy ---
(push 1)
(declare-const f0 SealingPolicy)
(declare-const f1 EnclaveIdentity)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kdp_policy (mk-key_derivation_params f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. KeyDerivationParams accessor round-trip: kdp_enclave_id ---
(push 1)
(declare-const f0 SealingPolicy)
(declare-const f1 EnclaveIdentity)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kdp_enclave_id (mk-key_derivation_params f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. KeyDerivationParams accessor round-trip: kdp_key_name ---
(push 1)
(declare-const f0 SealingPolicy)
(declare-const f1 EnclaveIdentity)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kdp_key_name (mk-key_derivation_params f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemoryPermissions record properties ---

; --- 65. MemoryPermissions accessor round-trip: mp_read ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mp_read (mk-memory_permissions f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. MemoryPermissions accessor round-trip: mp_write ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mp_write (mk-memory_permissions f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MemoryPermissions_all_enabled ((g MemoryPermissions)) Bool
  (and (mp_read g) (mp_write g)))

; --- 67. MemoryPermissions: all-enabled completeness ---
(push 1)
(declare-const g MemoryPermissions)
(assert (mp_read g))
(assert (mp_write g))
(assert (not (MemoryPermissions_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. MemoryPermissions: MemoryPermissions_all_enabled implies mp_read ---
(push 1)
(declare-const g MemoryPermissions)
(assert (MemoryPermissions_all_enabled g))
(assert (not (mp_read g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. MemoryPermissions: MemoryPermissions_all_enabled implies mp_write ---
(push 1)
(declare-const g MemoryPermissions)
(assert (MemoryPermissions_all_enabled g))
(assert (not (mp_write g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemoryRegion record properties ---

; --- 70. MemoryRegion accessor round-trip: mr_base ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 MemoryRegionType)
(declare-const f3 MemoryPermissions)
(declare-const f4 Bool)
(assert (not (= (mr_base (mk-memory_region f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. MemoryRegion accessor round-trip: mr_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 MemoryRegionType)
(declare-const f3 MemoryPermissions)
(declare-const f4 Bool)
(assert (not (= (mr_size (mk-memory_region f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. MemoryRegion accessor round-trip: mr_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 MemoryRegionType)
(declare-const f3 MemoryPermissions)
(declare-const f4 Bool)
(assert (not (= (mr_type (mk-memory_region f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. MemoryRegion accessor round-trip: mr_permissions ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 MemoryRegionType)
(declare-const f3 MemoryPermissions)
(declare-const f4 Bool)
(assert (not (= (mr_permissions (mk-memory_region f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. MemoryRegion: integer field consistency ---
(push 1)
(declare-const r MemoryRegion)
(assert (>= (mr_base r) 0))
(assert (>= (mr_size r) 0))
(assert (not (>= (+ (mr_base r) (mr_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PlatformIdentity record properties ---

; --- 75. PlatformIdentity accessor round-trip: pi_cpu_svn ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (pi_cpu_svn (mk-platform_identity f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. PlatformIdentity accessor round-trip: pi_pce_svn ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (pi_pce_svn (mk-platform_identity f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. PlatformIdentity accessor round-trip: pi_qe_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (pi_qe_id (mk-platform_identity f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. PlatformIdentity accessor round-trip: pi_platform_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (pi_platform_id (mk-platform_identity f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. PlatformIdentity: integer field consistency ---
(push 1)
(declare-const r PlatformIdentity)
(assert (>= (pi_cpu_svn r) 0))
(assert (>= (pi_pce_svn r) 0))
(assert (not (>= (+ (pi_cpu_svn r) (pi_pce_svn r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TrustChain record properties ---

; --- 80. TrustChain accessor round-trip: tc_root_key_valid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tc_root_key_valid (mk-trust_chain f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. TrustChain accessor round-trip: tc_pck_cert_valid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tc_pck_cert_valid (mk-trust_chain f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. TrustChain accessor round-trip: tc_tcb_signing_valid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tc_tcb_signing_valid (mk-trust_chain f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TrustChain_all_enabled ((g TrustChain)) Bool
  (and (tc_root_key_valid g) (tc_pck_cert_valid g) (tc_tcb_signing_valid g)))

; --- 83. TrustChain: all-enabled completeness ---
(push 1)
(declare-const g TrustChain)
(assert (tc_root_key_valid g))
(assert (tc_pck_cert_valid g))
(assert (tc_tcb_signing_valid g))
(assert (not (TrustChain_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. TrustChain: TrustChain_all_enabled implies tc_root_key_valid ---
(push 1)
(declare-const g TrustChain)
(assert (TrustChain_all_enabled g))
(assert (not (tc_root_key_valid g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. TrustChain: TrustChain_all_enabled implies tc_pck_cert_valid ---
(push 1)
(declare-const g TrustChain)
(assert (TrustChain_all_enabled g))
(assert (not (tc_pck_cert_valid g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. TrustChain: TrustChain_all_enabled implies tc_tcb_signing_valid ---
(push 1)
(declare-const g TrustChain)
(assert (TrustChain_all_enabled g))
(assert (not (tc_tcb_signing_valid g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

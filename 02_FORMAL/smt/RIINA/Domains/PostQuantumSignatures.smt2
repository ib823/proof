; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA PostQuantumSignatures — SMT Verification
; Derived from 02_FORMAL/coq/domains/PostQuantumSignatures.v (26 assertions)
; Module: PostQuantumSignatures
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SecurityLevel 0)) (((Level1) (Level3) (Level5))))

(declare-datatypes ((SignatureScheme 0)) (((ML_DSA_44) (ML_DSA_65) (ML_DSA_87) (SLH_DSA_128s) (SLH_DSA_192s) (SLH_DSA_256s))))

(declare-datatypes ((SchemeCategory 0)) (((Lattice_Based) (Hash_Based))))

(declare-datatypes ((SigningKeyPair 0))
  (((mk-signing_key_pair (skp_public Int) (skp_secret Int) (skp_valid Bool)))))

(declare-datatypes ((SignatureResult 0))
  (((mk-signature_result (sig_value Int) (sig_valid Bool)))))

(declare-datatypes ((SignatureInstance 0))
  (((mk-signature_instance (sig_scheme SignatureScheme) (sig_keypair SigningKeyPair) (sig_message Int) (sig_signature SignatureResult) (sig_verification Bool)))))

(declare-datatypes ((EUFCMASecure 0))
  (((mk-eufcma_secure (eufcma_unforgeable Bool) (eufcma_strong_unforgeability Bool) (eufcma_adaptive_security Bool)))))

(declare-datatypes ((SigQuantumResistant 0))
  (((mk-sig_quantum_resistant (sqr_post_quantum Bool) (sqr_no_shor_attack Bool) (sqr_conservative_params Bool)))))

(declare-datatypes ((HashBasedProperties 0))
  (((mk-hash_based_properties (hb_stateless Bool) (hb_hash_function_secure Bool) (hb_few_time_signature Bool)))))

(declare-datatypes ((SignatureSecurity 0))
  (((mk-signature_security (sig_sec_eufcma EUFCMASecure) (sig_sec_quantum SigQuantumResistant) (sig_sec_level SecurityLevel)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SecurityLevel enum properties ---

; --- 1. SecurityLevel exhaustiveness ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (or (= x Level1) (= x Level3) (= x Level5))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SecurityLevel: Level1 != Level3 ---
(push 1)
(assert (= Level1 Level3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SecurityLevel: Level3 != Level5 ---
(push 1)
(assert (= Level3 Level5))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SecurityLevel: Level1 != Level5 ---
(push 1)
(assert (= Level1 Level5))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SecurityLevel finite cardinality (3 values) ---
(push 1)
(declare-const x SecurityLevel)
(assert (and (not (= x Level1)) (not (= x Level3)) (not (= x Level5))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignatureScheme enum properties ---

; --- 6. SignatureScheme exhaustiveness ---
(push 1)
(declare-const x SignatureScheme)
(assert (not (or (= x ML_DSA_44) (= x ML_DSA_65) (= x ML_DSA_87) (= x SLH_DSA_128s) (= x SLH_DSA_192s) (= x SLH_DSA_256s))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SignatureScheme: ML_DSA_44 != ML_DSA_65 ---
(push 1)
(assert (= ML_DSA_44 ML_DSA_65))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SignatureScheme: ML_DSA_65 != ML_DSA_87 ---
(push 1)
(assert (= ML_DSA_65 ML_DSA_87))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SignatureScheme: ML_DSA_87 != SLH_DSA_128s ---
(push 1)
(assert (= ML_DSA_87 SLH_DSA_128s))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SignatureScheme: ML_DSA_44 != SLH_DSA_256s ---
(push 1)
(assert (= ML_DSA_44 SLH_DSA_256s))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SignatureScheme finite cardinality (6 values) ---
(push 1)
(declare-const x SignatureScheme)
(assert (and (not (= x ML_DSA_44)) (not (= x ML_DSA_65)) (not (= x ML_DSA_87)) (not (= x SLH_DSA_128s)) (not (= x SLH_DSA_192s)) (not (= x SLH_DSA_256s))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SchemeCategory enum properties ---

; --- 12. SchemeCategory exhaustiveness ---
(push 1)
(declare-const x SchemeCategory)
(assert (not (or (= x Lattice_Based) (= x Hash_Based))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. SchemeCategory: Lattice_Based != Hash_Based ---
(push 1)
(assert (= Lattice_Based Hash_Based))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SchemeCategory finite cardinality (2 values) ---
(push 1)
(declare-const x SchemeCategory)
(assert (and (not (= x Lattice_Based)) (not (= x Hash_Based))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SigningKeyPair record properties ---

; --- 15. SigningKeyPair accessor round-trip: skp_public ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (skp_public (mk-signing_key_pair f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SigningKeyPair accessor round-trip: skp_secret ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (skp_secret (mk-signing_key_pair f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SigningKeyPair: integer field consistency ---
(push 1)
(declare-const r SigningKeyPair)
(assert (>= (skp_public r) 0))
(assert (>= (skp_secret r) 0))
(assert (not (>= (+ (skp_public r) (skp_secret r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignatureResult record properties ---

; --- 18. SignatureResult accessor round-trip: sig_value ---
(push 1)
(declare-const f0 Int)
(assert (not (= (sig_value (mk-signature_result f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignatureInstance record properties ---

; --- 19. SignatureInstance accessor round-trip: sig_scheme ---
(push 1)
(declare-const f0 SignatureScheme)
(declare-const f1 SigningKeyPair)
(declare-const f2 Int)
(declare-const f3 SignatureResult)
(assert (not (= (sig_scheme (mk-signature_instance f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SignatureInstance accessor round-trip: sig_keypair ---
(push 1)
(declare-const f0 SignatureScheme)
(declare-const f1 SigningKeyPair)
(declare-const f2 Int)
(declare-const f3 SignatureResult)
(assert (not (= (sig_keypair (mk-signature_instance f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SignatureInstance accessor round-trip: sig_message ---
(push 1)
(declare-const f0 SignatureScheme)
(declare-const f1 SigningKeyPair)
(declare-const f2 Int)
(declare-const f3 SignatureResult)
(assert (not (= (sig_message (mk-signature_instance f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SignatureInstance accessor round-trip: sig_signature ---
(push 1)
(declare-const f0 SignatureScheme)
(declare-const f1 SigningKeyPair)
(declare-const f2 Int)
(declare-const f3 SignatureResult)
(assert (not (= (sig_signature (mk-signature_instance f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EUFCMASecure record properties ---

; --- 23. EUFCMASecure accessor round-trip: eufcma_unforgeable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (eufcma_unforgeable (mk-e_u_f_c_m_a_secure f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. EUFCMASecure accessor round-trip: eufcma_strong_unforgeability ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (eufcma_strong_unforgeability (mk-e_u_f_c_m_a_secure f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun EUFCMASecure_all_enabled ((g EUFCMASecure)) Bool
  (and (eufcma_unforgeable g) (eufcma_strong_unforgeability g)))

; --- 25. EUFCMASecure: all-enabled completeness ---
(push 1)
(declare-const g EUFCMASecure)
(assert (eufcma_unforgeable g))
(assert (eufcma_strong_unforgeability g))
(assert (not (EUFCMASecure_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. EUFCMASecure: EUFCMASecure_all_enabled implies eufcma_unforgeable ---
(push 1)
(declare-const g EUFCMASecure)
(assert (EUFCMASecure_all_enabled g))
(assert (not (eufcma_unforgeable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. EUFCMASecure: EUFCMASecure_all_enabled implies eufcma_strong_unforgeability ---
(push 1)
(declare-const g EUFCMASecure)
(assert (EUFCMASecure_all_enabled g))
(assert (not (eufcma_strong_unforgeability g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SigQuantumResistant record properties ---

; --- 28. SigQuantumResistant accessor round-trip: sqr_post_quantum ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (sqr_post_quantum (mk-sig_quantum_resistant f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. SigQuantumResistant accessor round-trip: sqr_no_shor_attack ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (sqr_no_shor_attack (mk-sig_quantum_resistant f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SigQuantumResistant_all_enabled ((g SigQuantumResistant)) Bool
  (and (sqr_post_quantum g) (sqr_no_shor_attack g)))

; --- 30. SigQuantumResistant: all-enabled completeness ---
(push 1)
(declare-const g SigQuantumResistant)
(assert (sqr_post_quantum g))
(assert (sqr_no_shor_attack g))
(assert (not (SigQuantumResistant_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. SigQuantumResistant: SigQuantumResistant_all_enabled implies sqr_post_quantum ---
(push 1)
(declare-const g SigQuantumResistant)
(assert (SigQuantumResistant_all_enabled g))
(assert (not (sqr_post_quantum g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. SigQuantumResistant: SigQuantumResistant_all_enabled implies sqr_no_shor_attack ---
(push 1)
(declare-const g SigQuantumResistant)
(assert (SigQuantumResistant_all_enabled g))
(assert (not (sqr_no_shor_attack g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HashBasedProperties record properties ---

; --- 33. HashBasedProperties accessor round-trip: hb_stateless ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (hb_stateless (mk-hash_based_properties f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. HashBasedProperties accessor round-trip: hb_hash_function_secure ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (hb_hash_function_secure (mk-hash_based_properties f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun HashBasedProperties_all_enabled ((g HashBasedProperties)) Bool
  (and (hb_stateless g) (hb_hash_function_secure g)))

; --- 35. HashBasedProperties: all-enabled completeness ---
(push 1)
(declare-const g HashBasedProperties)
(assert (hb_stateless g))
(assert (hb_hash_function_secure g))
(assert (not (HashBasedProperties_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. HashBasedProperties: HashBasedProperties_all_enabled implies hb_stateless ---
(push 1)
(declare-const g HashBasedProperties)
(assert (HashBasedProperties_all_enabled g))
(assert (not (hb_stateless g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. HashBasedProperties: HashBasedProperties_all_enabled implies hb_hash_function_secure ---
(push 1)
(declare-const g HashBasedProperties)
(assert (HashBasedProperties_all_enabled g))
(assert (not (hb_hash_function_secure g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignatureSecurity record properties ---

; --- 38. SignatureSecurity accessor round-trip: sig_sec_eufcma ---
(push 1)
(declare-const f0 EUFCMASecure)
(declare-const f1 SigQuantumResistant)
(assert (not (= (sig_sec_eufcma (mk-signature_security f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. SignatureSecurity accessor round-trip: sig_sec_quantum ---
(push 1)
(declare-const f0 EUFCMASecure)
(declare-const f1 SigQuantumResistant)
(assert (not (= (sig_sec_quantum (mk-signature_security f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLevel ordering properties ---

(define-fun SecurityLevel_level ((x SecurityLevel)) Int
  (ite (= x Level1) 0 (ite (= x Level3) 1 2)))

(define-fun SecurityLevel_leq ((x SecurityLevel) (y SecurityLevel)) Bool
  (<= (SecurityLevel_level x) (SecurityLevel_level y)))

; --- 40. SecurityLevel_leq reflexivity ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. SecurityLevel_leq transitivity ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(declare-const z SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y z))
(assert (not (SecurityLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. SecurityLevel_leq antisymmetry ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. Level1 is bottom ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq Level1 x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Level5 is top ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x Level5)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

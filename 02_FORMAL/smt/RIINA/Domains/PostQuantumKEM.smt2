; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA PostQuantumKEM — SMT Verification
; Derived from 02_FORMAL/coq/domains/PostQuantumKEM.v (26 assertions)
; Module: PostQuantumKEM
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SecurityLevel 0)) (((Level1) (Level3) (Level5))))

(declare-datatypes ((KEMParameterSet 0)) (((ML_KEM_512) (ML_KEM_768) (ML_KEM_1024))))

(declare-datatypes ((KeyPair 0))
  (((mk-key_pair (kp_public Int) (kp_secret Int) (kp_valid Bool)))))

(declare-datatypes ((EncapsResult 0))
  (((mk-encaps_result (enc_ciphertext Int) (enc_shared_secret Int) (enc_valid Bool)))))

(declare-datatypes ((KEMInstance 0))
  (((mk-kem_instance (kem_params KEMParameterSet) (kem_keypair KeyPair) (kem_encaps_result EncapsResult) (kem_decaps_result Int) (kem_decaps_valid Bool)))))

(declare-datatypes ((INDCCASecure 0))
  (((mk-indcca_secure (indcca_ciphertext_indistinguishable Bool) (indcca_key_indistinguishable Bool) (indcca_decaps_consistent Bool)))))

(declare-datatypes ((QuantumResistant 0))
  (((mk-quantum_resistant (qr_lattice_based Bool) (qr_lwe_hardness Bool) (qr_module_lwe Bool) (qr_no_known_quantum_attack Bool)))))

(declare-datatypes ((KEMSecurity 0))
  (((mk-kem_security (kem_sec_indcca INDCCASecure) (kem_sec_quantum QuantumResistant) (kem_sec_level SecurityLevel)))))

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

; --- KEMParameterSet enum properties ---

; --- 6. KEMParameterSet exhaustiveness ---
(push 1)
(declare-const x KEMParameterSet)
(assert (not (or (= x ML_KEM_512) (= x ML_KEM_768) (= x ML_KEM_1024))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. KEMParameterSet: ML_KEM_512 != ML_KEM_768 ---
(push 1)
(assert (= ML_KEM_512 ML_KEM_768))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. KEMParameterSet: ML_KEM_768 != ML_KEM_1024 ---
(push 1)
(assert (= ML_KEM_768 ML_KEM_1024))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. KEMParameterSet: ML_KEM_512 != ML_KEM_1024 ---
(push 1)
(assert (= ML_KEM_512 ML_KEM_1024))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. KEMParameterSet finite cardinality (3 values) ---
(push 1)
(declare-const x KEMParameterSet)
(assert (and (not (= x ML_KEM_512)) (not (= x ML_KEM_768)) (not (= x ML_KEM_1024))))
(check-sat) ; expect UNSAT
(pop 1)

; --- KeyPair record properties ---

; --- 11. KeyPair accessor round-trip: kp_public ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (kp_public (mk-key_pair f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. KeyPair accessor round-trip: kp_secret ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (kp_secret (mk-key_pair f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. KeyPair: integer field consistency ---
(push 1)
(declare-const r KeyPair)
(assert (>= (kp_public r) 0))
(assert (>= (kp_secret r) 0))
(assert (not (>= (+ (kp_public r) (kp_secret r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EncapsResult record properties ---

; --- 14. EncapsResult accessor round-trip: enc_ciphertext ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (enc_ciphertext (mk-encaps_result f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. EncapsResult accessor round-trip: enc_shared_secret ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (enc_shared_secret (mk-encaps_result f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. EncapsResult: integer field consistency ---
(push 1)
(declare-const r EncapsResult)
(assert (>= (enc_ciphertext r) 0))
(assert (>= (enc_shared_secret r) 0))
(assert (not (>= (+ (enc_ciphertext r) (enc_shared_secret r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KEMInstance record properties ---

; --- 17. KEMInstance accessor round-trip: kem_params ---
(push 1)
(declare-const f0 KEMParameterSet)
(declare-const f1 KeyPair)
(declare-const f2 EncapsResult)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (kem_params (mk-kem_instance f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. KEMInstance accessor round-trip: kem_keypair ---
(push 1)
(declare-const f0 KEMParameterSet)
(declare-const f1 KeyPair)
(declare-const f2 EncapsResult)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (kem_keypair (mk-kem_instance f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. KEMInstance accessor round-trip: kem_encaps_result ---
(push 1)
(declare-const f0 KEMParameterSet)
(declare-const f1 KeyPair)
(declare-const f2 EncapsResult)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (kem_encaps_result (mk-kem_instance f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. KEMInstance accessor round-trip: kem_decaps_result ---
(push 1)
(declare-const f0 KEMParameterSet)
(declare-const f1 KeyPair)
(declare-const f2 EncapsResult)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (kem_decaps_result (mk-kem_instance f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- INDCCASecure record properties ---

; --- 21. INDCCASecure accessor round-trip: indcca_ciphertext_indistinguishable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (indcca_ciphertext_indistinguishable (mk-indcca_secure f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. INDCCASecure accessor round-trip: indcca_key_indistinguishable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (indcca_key_indistinguishable (mk-indcca_secure f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun INDCCASecure_all_enabled ((g INDCCASecure)) Bool
  (and (indcca_ciphertext_indistinguishable g) (indcca_key_indistinguishable g)))

; --- 23. INDCCASecure: all-enabled completeness ---
(push 1)
(declare-const g INDCCASecure)
(assert (indcca_ciphertext_indistinguishable g))
(assert (indcca_key_indistinguishable g))
(assert (not (INDCCASecure_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. INDCCASecure: INDCCASecure_all_enabled implies indcca_ciphertext_indistinguishable ---
(push 1)
(declare-const g INDCCASecure)
(assert (INDCCASecure_all_enabled g))
(assert (not (indcca_ciphertext_indistinguishable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. INDCCASecure: INDCCASecure_all_enabled implies indcca_key_indistinguishable ---
(push 1)
(declare-const g INDCCASecure)
(assert (INDCCASecure_all_enabled g))
(assert (not (indcca_key_indistinguishable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- QuantumResistant record properties ---

; --- 26. QuantumResistant accessor round-trip: qr_lattice_based ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (qr_lattice_based (mk-quantum_resistant f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. QuantumResistant accessor round-trip: qr_lwe_hardness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (qr_lwe_hardness (mk-quantum_resistant f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. QuantumResistant accessor round-trip: qr_module_lwe ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (qr_module_lwe (mk-quantum_resistant f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun QuantumResistant_all_enabled ((g QuantumResistant)) Bool
  (and (qr_lattice_based g) (qr_lwe_hardness g) (qr_module_lwe g)))

; --- 29. QuantumResistant: all-enabled completeness ---
(push 1)
(declare-const g QuantumResistant)
(assert (qr_lattice_based g))
(assert (qr_lwe_hardness g))
(assert (qr_module_lwe g))
(assert (not (QuantumResistant_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. QuantumResistant: QuantumResistant_all_enabled implies qr_lattice_based ---
(push 1)
(declare-const g QuantumResistant)
(assert (QuantumResistant_all_enabled g))
(assert (not (qr_lattice_based g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. QuantumResistant: QuantumResistant_all_enabled implies qr_lwe_hardness ---
(push 1)
(declare-const g QuantumResistant)
(assert (QuantumResistant_all_enabled g))
(assert (not (qr_lwe_hardness g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. QuantumResistant: QuantumResistant_all_enabled implies qr_module_lwe ---
(push 1)
(declare-const g QuantumResistant)
(assert (QuantumResistant_all_enabled g))
(assert (not (qr_module_lwe g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KEMSecurity record properties ---

; --- 33. KEMSecurity accessor round-trip: kem_sec_indcca ---
(push 1)
(declare-const f0 INDCCASecure)
(declare-const f1 QuantumResistant)
(declare-const f2 SecurityLevel)
(assert (not (= (kem_sec_indcca (mk-kem_security f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. KEMSecurity accessor round-trip: kem_sec_quantum ---
(push 1)
(declare-const f0 INDCCASecure)
(declare-const f1 QuantumResistant)
(declare-const f2 SecurityLevel)
(assert (not (= (kem_sec_quantum (mk-kem_security f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLevel ordering properties ---

(define-fun SecurityLevel_level ((x SecurityLevel)) Int
  (ite (= x Level1) 0 (ite (= x Level3) 1 2)))

(define-fun SecurityLevel_leq ((x SecurityLevel) (y SecurityLevel)) Bool
  (<= (SecurityLevel_level x) (SecurityLevel_level y)))

; --- 35. SecurityLevel_leq reflexivity ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. SecurityLevel_leq transitivity ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(declare-const z SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y z))
(assert (not (SecurityLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. SecurityLevel_leq antisymmetry ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. Level1 is bottom ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq Level1 x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. Level5 is top ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x Level5)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

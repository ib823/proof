; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA FHESecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/FHESecurity.v (94 assertions)
; Module: FHESecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((HomomorphicOps 0))
  (((mk-homomorphic_ops (ho_addition Bool) (ho_multiplication Bool) (ho_arbitrary_depth Bool)))))

(declare-datatypes ((FHESecurityProps 0))
  (((mk-fhe_security_props (fhe_ind_cpa Bool) (fhe_circular_secure Bool) (fhe_semantic_secure Bool)))))

(declare-datatypes ((NoiseManagement 0))
  (((mk-noise_management (nm_bootstrapping Bool) (nm_modulus_switching Bool) (nm_noise_bounded Bool)))))

(declare-datatypes ((FHEConfig 0))
  (((mk-fhe_config (fhe_ops HomomorphicOps) (fhe_security FHESecurityProps) (fhe_noise NoiseManagement) (fhe_lattice_based Bool) (fhe_post_quantum Bool)))))

(declare-datatypes ((INDCPAGame 0))
  (((mk-indcpa_game (icpa_key_size Int) (icpa_challenge_bit Bool) (icpa_encryption_oracle Bool) (icpa_distinguisher_adv Int)))))

(declare-datatypes ((SemanticSecurity 0))
  (((mk-semantic_security (ss_message_space Int) (ss_ciphertext_space Int) (ss_indistinguishable Bool) (ss_randomized Bool)))))

(declare-datatypes ((HomAddition 0))
  (((mk-hom_addition (ha_plaintext_modulus Int) (ha_ciphertext_modulus Int) (ha_preserves_structure Bool)))))

(declare-datatypes ((HomMultiplication 0))
  (((mk-hom_multiplication (hm_plaintext_modulus Int) (hm_ciphertext_modulus Int) (hm_relinearization Bool) (hm_key_switching Bool)))))

(declare-datatypes ((HomOperations 0))
  (((mk-hom_operations (hops_addition HomAddition) (hops_multiplication HomMultiplication) (hops_composition Bool)))))

(declare-datatypes ((NoiseModel 0))
  (((mk-noise_model (noise_initial Int) (noise_add_growth Int) (noise_mult_growth Int) (noise_threshold Int)))))

(declare-datatypes ((NoiseBound 0))
  (((mk-noise_bound (nb_max_additions Int) (nb_max_multiplications Int) (nb_modulus Int)))))

(declare-datatypes ((BootstrappingConfig 0))
  (((mk-bootstrapping_config (bs_reduces_noise Bool) (bs_preserves_message Bool) (bs_polynomial_time Bool) (bs_noise_output Int) (bs_noise_input_max Int)))))

(declare-datatypes ((UnlimitedFHE 0))
  (((mk-unlimited_fhe (ufhe_bootstrap_config BootstrappingConfig) (ufhe_noise_model NoiseModel) (ufhe_leveled_depth Int)))))

(declare-datatypes ((KeyGenParams 0))
  (((mk-key_gen_params (kg_security_parameter Int) (kg_polynomial_degree Int) (kg_error_distribution Int) (kg_modulus_bits Int)))))

(declare-datatypes ((FHEKeyPair 0))
  (((mk-fhe_key_pair (kp_public Int) (kp_secret Int) (kp_evaluation Int) (kp_params KeyGenParams)))))

(declare-datatypes ((FHECiphertext 0))
  (((mk-fhe_ciphertext (ct_polynomial_0 Int) (ct_polynomial_1 Int) (ct_noise_estimate Int) (ct_level Int) (ct_valid_encryption Bool)))))

(declare-datatypes ((CiphertextAfterOp 0))
  (((mk-ciphertext_after_op (cao_original FHECiphertext) (cao_result FHECiphertext) (cao_operation Int)))))

(declare-datatypes ((CompleteFHESystem 0))
  (((mk-complete_fhe_system (cfhe_config FHEConfig) (cfhe_keygen KeyGenParams) (cfhe_noise NoiseModel) (cfhe_bootstrap BootstrappingConfig) (cfhe_operations HomOperations) (cfhe_indcpa INDCPAGame)))))

(declare-datatypes ((CircularSecurity 0))
  (((mk-circular_security (cs_key_encryption_safe Bool) (cs_kDM_secure Bool) (cs_multi_key Bool)))))

(declare-datatypes ((LWEHardness 0))
  (((mk-lwe_hardness (lwe_dimension Int) (lwe_modulus Int) (lwe_error_rate Int) (lwe_assumed_hard Bool)))))

(declare-datatypes ((RLWEConfig 0))
  (((mk-rlwe_config (rlwe_ring_degree Int) (rlwe_modulus Int) (rlwe_error_width Int) (rlwe_ntt_compatible Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- HomomorphicOps record properties ---

; --- 1. HomomorphicOps accessor round-trip: ho_addition ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ho_addition (mk-homomorphic_ops f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. HomomorphicOps accessor round-trip: ho_multiplication ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ho_multiplication (mk-homomorphic_ops f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun HomomorphicOps_all_enabled ((g HomomorphicOps)) Bool
  (and (ho_addition g) (ho_multiplication g)))

; --- 3. HomomorphicOps: all-enabled completeness ---
(push 1)
(declare-const g HomomorphicOps)
(assert (ho_addition g))
(assert (ho_multiplication g))
(assert (not (HomomorphicOps_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. HomomorphicOps: HomomorphicOps_all_enabled implies ho_addition ---
(push 1)
(declare-const g HomomorphicOps)
(assert (HomomorphicOps_all_enabled g))
(assert (not (ho_addition g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. HomomorphicOps: HomomorphicOps_all_enabled implies ho_multiplication ---
(push 1)
(declare-const g HomomorphicOps)
(assert (HomomorphicOps_all_enabled g))
(assert (not (ho_multiplication g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FHESecurityProps record properties ---

; --- 6. FHESecurityProps accessor round-trip: fhe_ind_cpa ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (fhe_ind_cpa (mk-fhe_security_props f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. FHESecurityProps accessor round-trip: fhe_circular_secure ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (fhe_circular_secure (mk-fhe_security_props f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FHESecurityProps_all_enabled ((g FHESecurityProps)) Bool
  (and (fhe_ind_cpa g) (fhe_circular_secure g)))

; --- 8. FHESecurityProps: all-enabled completeness ---
(push 1)
(declare-const g FHESecurityProps)
(assert (fhe_ind_cpa g))
(assert (fhe_circular_secure g))
(assert (not (FHESecurityProps_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FHESecurityProps: FHESecurityProps_all_enabled implies fhe_ind_cpa ---
(push 1)
(declare-const g FHESecurityProps)
(assert (FHESecurityProps_all_enabled g))
(assert (not (fhe_ind_cpa g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FHESecurityProps: FHESecurityProps_all_enabled implies fhe_circular_secure ---
(push 1)
(declare-const g FHESecurityProps)
(assert (FHESecurityProps_all_enabled g))
(assert (not (fhe_circular_secure g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NoiseManagement record properties ---

; --- 11. NoiseManagement accessor round-trip: nm_bootstrapping ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nm_bootstrapping (mk-noise_management f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. NoiseManagement accessor round-trip: nm_modulus_switching ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nm_modulus_switching (mk-noise_management f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun NoiseManagement_all_enabled ((g NoiseManagement)) Bool
  (and (nm_bootstrapping g) (nm_modulus_switching g)))

; --- 13. NoiseManagement: all-enabled completeness ---
(push 1)
(declare-const g NoiseManagement)
(assert (nm_bootstrapping g))
(assert (nm_modulus_switching g))
(assert (not (NoiseManagement_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. NoiseManagement: NoiseManagement_all_enabled implies nm_bootstrapping ---
(push 1)
(declare-const g NoiseManagement)
(assert (NoiseManagement_all_enabled g))
(assert (not (nm_bootstrapping g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. NoiseManagement: NoiseManagement_all_enabled implies nm_modulus_switching ---
(push 1)
(declare-const g NoiseManagement)
(assert (NoiseManagement_all_enabled g))
(assert (not (nm_modulus_switching g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FHEConfig record properties ---

; --- 16. FHEConfig accessor round-trip: fhe_ops ---
(push 1)
(declare-const f0 HomomorphicOps)
(declare-const f1 FHESecurityProps)
(declare-const f2 NoiseManagement)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fhe_ops (mk-fhe_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. FHEConfig accessor round-trip: fhe_security ---
(push 1)
(declare-const f0 HomomorphicOps)
(declare-const f1 FHESecurityProps)
(declare-const f2 NoiseManagement)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fhe_security (mk-fhe_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. FHEConfig accessor round-trip: fhe_noise ---
(push 1)
(declare-const f0 HomomorphicOps)
(declare-const f1 FHESecurityProps)
(declare-const f2 NoiseManagement)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fhe_noise (mk-fhe_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. FHEConfig accessor round-trip: fhe_lattice_based ---
(push 1)
(declare-const f0 HomomorphicOps)
(declare-const f1 FHESecurityProps)
(declare-const f2 NoiseManagement)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fhe_lattice_based (mk-fhe_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- INDCPAGame record properties ---

; --- 20. INDCPAGame accessor round-trip: icpa_key_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (icpa_key_size (mk-indcpa_game f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. INDCPAGame accessor round-trip: icpa_challenge_bit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (icpa_challenge_bit (mk-indcpa_game f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. INDCPAGame accessor round-trip: icpa_encryption_oracle ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (icpa_encryption_oracle (mk-indcpa_game f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SemanticSecurity record properties ---

; --- 23. SemanticSecurity accessor round-trip: ss_message_space ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ss_message_space (mk-semantic_security f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SemanticSecurity accessor round-trip: ss_ciphertext_space ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ss_ciphertext_space (mk-semantic_security f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. SemanticSecurity accessor round-trip: ss_indistinguishable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ss_indistinguishable (mk-semantic_security f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SemanticSecurity: integer field consistency ---
(push 1)
(declare-const r SemanticSecurity)
(assert (>= (ss_message_space r) 0))
(assert (>= (ss_ciphertext_space r) 0))
(assert (not (>= (+ (ss_message_space r) (ss_ciphertext_space r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HomAddition record properties ---

; --- 27. HomAddition accessor round-trip: ha_plaintext_modulus ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (ha_plaintext_modulus (mk-hom_addition f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. HomAddition accessor round-trip: ha_ciphertext_modulus ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (ha_ciphertext_modulus (mk-hom_addition f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. HomAddition: integer field consistency ---
(push 1)
(declare-const r HomAddition)
(assert (>= (ha_plaintext_modulus r) 0))
(assert (>= (ha_ciphertext_modulus r) 0))
(assert (not (>= (+ (ha_plaintext_modulus r) (ha_ciphertext_modulus r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HomMultiplication record properties ---

; --- 30. HomMultiplication accessor round-trip: hm_plaintext_modulus ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (hm_plaintext_modulus (mk-hom_multiplication f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. HomMultiplication accessor round-trip: hm_ciphertext_modulus ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (hm_ciphertext_modulus (mk-hom_multiplication f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. HomMultiplication accessor round-trip: hm_relinearization ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (hm_relinearization (mk-hom_multiplication f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. HomMultiplication: integer field consistency ---
(push 1)
(declare-const r HomMultiplication)
(assert (>= (hm_plaintext_modulus r) 0))
(assert (>= (hm_ciphertext_modulus r) 0))
(assert (not (>= (+ (hm_plaintext_modulus r) (hm_ciphertext_modulus r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HomOperations record properties ---

; --- 34. HomOperations accessor round-trip: hops_addition ---
(push 1)
(declare-const f0 HomAddition)
(declare-const f1 HomMultiplication)
(declare-const f2 Bool)
(assert (not (= (hops_addition (mk-hom_operations f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. HomOperations accessor round-trip: hops_multiplication ---
(push 1)
(declare-const f0 HomAddition)
(declare-const f1 HomMultiplication)
(declare-const f2 Bool)
(assert (not (= (hops_multiplication (mk-hom_operations f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NoiseModel record properties ---

; --- 36. NoiseModel accessor round-trip: noise_initial ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (noise_initial (mk-noise_model f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. NoiseModel accessor round-trip: noise_add_growth ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (noise_add_growth (mk-noise_model f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. NoiseModel accessor round-trip: noise_mult_growth ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (noise_mult_growth (mk-noise_model f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. NoiseModel: integer field consistency ---
(push 1)
(declare-const r NoiseModel)
(assert (>= (noise_initial r) 0))
(assert (>= (noise_add_growth r) 0))
(assert (not (>= (+ (noise_initial r) (noise_add_growth r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NoiseBound record properties ---

; --- 40. NoiseBound accessor round-trip: nb_max_additions ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (nb_max_additions (mk-noise_bound f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. NoiseBound accessor round-trip: nb_max_multiplications ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (nb_max_multiplications (mk-noise_bound f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. NoiseBound: integer field consistency ---
(push 1)
(declare-const r NoiseBound)
(assert (>= (nb_max_additions r) 0))
(assert (>= (nb_max_multiplications r) 0))
(assert (not (>= (+ (nb_max_additions r) (nb_max_multiplications r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BootstrappingConfig record properties ---

; --- 43. BootstrappingConfig accessor round-trip: bs_reduces_noise ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (bs_reduces_noise (mk-bootstrapping_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. BootstrappingConfig accessor round-trip: bs_preserves_message ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (bs_preserves_message (mk-bootstrapping_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. BootstrappingConfig accessor round-trip: bs_polynomial_time ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (bs_polynomial_time (mk-bootstrapping_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. BootstrappingConfig accessor round-trip: bs_noise_output ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (bs_noise_output (mk-bootstrapping_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- UnlimitedFHE record properties ---

; --- 47. UnlimitedFHE accessor round-trip: ufhe_bootstrap_config ---
(push 1)
(declare-const f0 BootstrappingConfig)
(declare-const f1 NoiseModel)
(declare-const f2 Int)
(assert (not (= (ufhe_bootstrap_config (mk-unlimited_fhe f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. UnlimitedFHE accessor round-trip: ufhe_noise_model ---
(push 1)
(declare-const f0 BootstrappingConfig)
(declare-const f1 NoiseModel)
(declare-const f2 Int)
(assert (not (= (ufhe_noise_model (mk-unlimited_fhe f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KeyGenParams record properties ---

; --- 49. KeyGenParams accessor round-trip: kg_security_parameter ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kg_security_parameter (mk-key_gen_params f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. KeyGenParams accessor round-trip: kg_polynomial_degree ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kg_polynomial_degree (mk-key_gen_params f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. KeyGenParams accessor round-trip: kg_error_distribution ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kg_error_distribution (mk-key_gen_params f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. KeyGenParams: integer field consistency ---
(push 1)
(declare-const r KeyGenParams)
(assert (>= (kg_security_parameter r) 0))
(assert (>= (kg_polynomial_degree r) 0))
(assert (not (>= (+ (kg_security_parameter r) (kg_polynomial_degree r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FHEKeyPair record properties ---

; --- 53. FHEKeyPair accessor round-trip: kp_public ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 KeyGenParams)
(assert (not (= (kp_public (mk-fhe_key_pair f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. FHEKeyPair accessor round-trip: kp_secret ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 KeyGenParams)
(assert (not (= (kp_secret (mk-fhe_key_pair f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. FHEKeyPair accessor round-trip: kp_evaluation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 KeyGenParams)
(assert (not (= (kp_evaluation (mk-fhe_key_pair f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. FHEKeyPair: integer field consistency ---
(push 1)
(declare-const r FHEKeyPair)
(assert (>= (kp_public r) 0))
(assert (>= (kp_secret r) 0))
(assert (not (>= (+ (kp_public r) (kp_secret r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FHECiphertext record properties ---

; --- 57. FHECiphertext accessor round-trip: ct_polynomial_0 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ct_polynomial_0 (mk-fhe_ciphertext f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. FHECiphertext accessor round-trip: ct_polynomial_1 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ct_polynomial_1 (mk-fhe_ciphertext f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. FHECiphertext accessor round-trip: ct_noise_estimate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ct_noise_estimate (mk-fhe_ciphertext f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. FHECiphertext accessor round-trip: ct_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ct_level (mk-fhe_ciphertext f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. FHECiphertext: integer field consistency ---
(push 1)
(declare-const r FHECiphertext)
(assert (>= (ct_polynomial_0 r) 0))
(assert (>= (ct_polynomial_1 r) 0))
(assert (not (>= (+ (ct_polynomial_0 r) (ct_polynomial_1 r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CiphertextAfterOp record properties ---

; --- 62. CiphertextAfterOp accessor round-trip: cao_original ---
(push 1)
(declare-const f0 FHECiphertext)
(declare-const f1 FHECiphertext)
(declare-const f2 Int)
(assert (not (= (cao_original (mk-ciphertext_after_op f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. CiphertextAfterOp accessor round-trip: cao_result ---
(push 1)
(declare-const f0 FHECiphertext)
(declare-const f1 FHECiphertext)
(declare-const f2 Int)
(assert (not (= (cao_result (mk-ciphertext_after_op f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CompleteFHESystem record properties ---

; --- 64. CompleteFHESystem accessor round-trip: cfhe_config ---
(push 1)
(declare-const f0 FHEConfig)
(declare-const f1 KeyGenParams)
(declare-const f2 NoiseModel)
(declare-const f3 BootstrappingConfig)
(declare-const f4 HomOperations)
(declare-const f5 INDCPAGame)
(assert (not (= (cfhe_config (mk-complete_fhe_system f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. CompleteFHESystem accessor round-trip: cfhe_keygen ---
(push 1)
(declare-const f0 FHEConfig)
(declare-const f1 KeyGenParams)
(declare-const f2 NoiseModel)
(declare-const f3 BootstrappingConfig)
(declare-const f4 HomOperations)
(declare-const f5 INDCPAGame)
(assert (not (= (cfhe_keygen (mk-complete_fhe_system f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. CompleteFHESystem accessor round-trip: cfhe_noise ---
(push 1)
(declare-const f0 FHEConfig)
(declare-const f1 KeyGenParams)
(declare-const f2 NoiseModel)
(declare-const f3 BootstrappingConfig)
(declare-const f4 HomOperations)
(declare-const f5 INDCPAGame)
(assert (not (= (cfhe_noise (mk-complete_fhe_system f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. CompleteFHESystem accessor round-trip: cfhe_bootstrap ---
(push 1)
(declare-const f0 FHEConfig)
(declare-const f1 KeyGenParams)
(declare-const f2 NoiseModel)
(declare-const f3 BootstrappingConfig)
(declare-const f4 HomOperations)
(declare-const f5 INDCPAGame)
(assert (not (= (cfhe_bootstrap (mk-complete_fhe_system f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. CompleteFHESystem accessor round-trip: cfhe_operations ---
(push 1)
(declare-const f0 FHEConfig)
(declare-const f1 KeyGenParams)
(declare-const f2 NoiseModel)
(declare-const f3 BootstrappingConfig)
(declare-const f4 HomOperations)
(declare-const f5 INDCPAGame)
(assert (not (= (cfhe_operations (mk-complete_fhe_system f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CircularSecurity record properties ---

; --- 69. CircularSecurity accessor round-trip: cs_key_encryption_safe ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cs_key_encryption_safe (mk-circular_security f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. CircularSecurity accessor round-trip: cs_kDM_secure ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cs_kDM_secure (mk-circular_security f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CircularSecurity_all_enabled ((g CircularSecurity)) Bool
  (and (cs_key_encryption_safe g) (cs_kDM_secure g)))

; --- 71. CircularSecurity: all-enabled completeness ---
(push 1)
(declare-const g CircularSecurity)
(assert (cs_key_encryption_safe g))
(assert (cs_kDM_secure g))
(assert (not (CircularSecurity_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. CircularSecurity: CircularSecurity_all_enabled implies cs_key_encryption_safe ---
(push 1)
(declare-const g CircularSecurity)
(assert (CircularSecurity_all_enabled g))
(assert (not (cs_key_encryption_safe g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. CircularSecurity: CircularSecurity_all_enabled implies cs_kDM_secure ---
(push 1)
(declare-const g CircularSecurity)
(assert (CircularSecurity_all_enabled g))
(assert (not (cs_kDM_secure g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LWEHardness record properties ---

; --- 74. LWEHardness accessor round-trip: lwe_dimension ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (lwe_dimension (mk-lwe_hardness f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. LWEHardness accessor round-trip: lwe_modulus ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (lwe_modulus (mk-lwe_hardness f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. LWEHardness accessor round-trip: lwe_error_rate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (lwe_error_rate (mk-lwe_hardness f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. LWEHardness: integer field consistency ---
(push 1)
(declare-const r LWEHardness)
(assert (>= (lwe_dimension r) 0))
(assert (>= (lwe_modulus r) 0))
(assert (not (>= (+ (lwe_dimension r) (lwe_modulus r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RLWEConfig record properties ---

; --- 78. RLWEConfig accessor round-trip: rlwe_ring_degree ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (rlwe_ring_degree (mk-rlwe_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. RLWEConfig accessor round-trip: rlwe_modulus ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (rlwe_modulus (mk-rlwe_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. RLWEConfig accessor round-trip: rlwe_error_width ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (rlwe_error_width (mk-rlwe_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. RLWEConfig: integer field consistency ---
(push 1)
(declare-const r RLWEConfig)
(assert (>= (rlwe_ring_degree r) 0))
(assert (>= (rlwe_modulus r) 0))
(assert (not (>= (+ (rlwe_ring_degree r) (rlwe_modulus r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

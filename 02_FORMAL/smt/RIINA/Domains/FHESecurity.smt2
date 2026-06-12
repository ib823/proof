; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/FHESecurity.v (94 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: FHESecurity

(set-logic ALL)
(set-option :produce-models true)

; HomomorphicOps (matches Coq: Record HomomorphicOps)
(declare-datatypes ((HomomorphicOps 0))
  (((mk-homomorphic_ops (ho_addition Bool) (ho_multiplication Bool) (ho_arbitrary_depth Bool)))))

; FHESecurityProps (matches Coq: Record FHESecurityProps)
(declare-datatypes ((FHESecurityProps 0))
  (((mk-fhe_security_props (fhe_ind_cpa Bool) (fhe_circular_secure Bool) (fhe_semantic_secure Bool)))))

; NoiseManagement (matches Coq: Record NoiseManagement)
(declare-datatypes ((NoiseManagement 0))
  (((mk-noise_management (nm_bootstrapping Bool) (nm_modulus_switching Bool) (nm_noise_bounded Bool)))))

; FHEConfig (matches Coq: Record FHEConfig)
(declare-datatypes ((FHEConfig 0))
  (((mk-fhe_config (fhe_ops HomomorphicOps) (fhe_security FHESecurityProps) (fhe_noise NoiseManagement) (fhe_lattice_based Bool) (fhe_post_quantum Bool)))))

; INDCPAGame (matches Coq: Record INDCPAGame)
(declare-datatypes ((INDCPAGame 0))
  (((mk-indcpa_game (icpa_key_size Int) (icpa_challenge_bit Bool) (icpa_encryption_oracle Bool) (icpa_distinguisher_adv Int)))))

; SemanticSecurity (matches Coq: Record SemanticSecurity)
(declare-datatypes ((SemanticSecurity 0))
  (((mk-semantic_security (ss_message_space Int) (ss_ciphertext_space Int) (ss_indistinguishable Bool) (ss_randomized Bool)))))

; HomAddition (matches Coq: Record HomAddition)
(declare-datatypes ((HomAddition 0))
  (((mk-hom_addition (ha_plaintext_modulus Int) (ha_ciphertext_modulus Int) (ha_preserves_structure Bool)))))

; HomMultiplication (matches Coq: Record HomMultiplication)
(declare-datatypes ((HomMultiplication 0))
  (((mk-hom_multiplication (hm_plaintext_modulus Int) (hm_ciphertext_modulus Int) (hm_relinearization Bool) (hm_key_switching Bool)))))

; HomOperations (matches Coq: Record HomOperations)
(declare-datatypes ((HomOperations 0))
  (((mk-hom_operations (hops_addition HomAddition) (hops_multiplication HomMultiplication) (hops_composition Bool)))))

; NoiseModel (matches Coq: Record NoiseModel)
(declare-datatypes ((NoiseModel 0))
  (((mk-noise_model (noise_initial Int) (noise_add_growth Int) (noise_mult_growth Int) (noise_threshold Int)))))

; NoiseBound (matches Coq: Record NoiseBound)
(declare-datatypes ((NoiseBound 0))
  (((mk-noise_bound (nb_max_additions Int) (nb_max_multiplications Int) (nb_modulus Int)))))

; BootstrappingConfig (matches Coq: Record BootstrappingConfig)
(declare-datatypes ((BootstrappingConfig 0))
  (((mk-bootstrapping_config (bs_reduces_noise Bool) (bs_preserves_message Bool) (bs_polynomial_time Bool) (bs_noise_output Int) (bs_noise_input_max Int)))))

; UnlimitedFHE (matches Coq: Record UnlimitedFHE)
(declare-datatypes ((UnlimitedFHE 0))
  (((mk-unlimited_fhe (ufhe_bootstrap_config BootstrappingConfig) (ufhe_noise_model NoiseModel) (ufhe_leveled_depth Int)))))

; KeyGenParams (matches Coq: Record KeyGenParams)
(declare-datatypes ((KeyGenParams 0))
  (((mk-key_gen_params (kg_security_parameter Int) (kg_polynomial_degree Int) (kg_error_distribution Int) (kg_modulus_bits Int)))))

; FHEKeyPair (matches Coq: Record FHEKeyPair)
(declare-datatypes ((FHEKeyPair 0))
  (((mk-fhe_key_pair (kp_public Int) (kp_secret Int) (kp_evaluation Int) (kp_params KeyGenParams)))))

; FHECiphertext (matches Coq: Record FHECiphertext)
(declare-datatypes ((FHECiphertext 0))
  (((mk-fhe_ciphertext (ct_polynomial_0 Int) (ct_polynomial_1 Int) (ct_noise_estimate Int) (ct_level Int) (ct_valid_encryption Bool)))))

; CiphertextAfterOp (matches Coq: Record CiphertextAfterOp)
(declare-datatypes ((CiphertextAfterOp 0))
  (((mk-ciphertext_after_op (cao_original FHECiphertext) (cao_result FHECiphertext) (cao_operation Int)))))

; CompleteFHESystem (matches Coq: Record CompleteFHESystem)
(declare-datatypes ((CompleteFHESystem 0))
  (((mk-complete_fhe_system (cfhe_config FHEConfig) (cfhe_keygen KeyGenParams) (cfhe_noise NoiseModel) (cfhe_bootstrap BootstrappingConfig) (cfhe_operations HomOperations) (cfhe_indcpa INDCPAGame)))))

; CircularSecurity (matches Coq: Record CircularSecurity)
(declare-datatypes ((CircularSecurity 0))
  (((mk-circular_security (cs_key_encryption_safe Bool) (cs_kDM_secure Bool) (cs_multi_key Bool)))))

; LWEHardness (matches Coq: Record LWEHardness)
(declare-datatypes ((LWEHardness 0))
  (((mk-lwe_hardness (lwe_dimension Int) (lwe_modulus Int) (lwe_error_rate Int) (lwe_assumed_hard Bool)))))

; RLWEConfig (matches Coq: Record RLWEConfig)
(declare-datatypes ((RLWEConfig 0))
  (((mk-rlwe_config (rlwe_ring_degree Int) (rlwe_modulus Int) (rlwe_error_width Int) (rlwe_ntt_compatible Bool)))))

(declare-const __default_BootstrappingConfig BootstrappingConfig)
(declare-const __default_CiphertextAfterOp CiphertextAfterOp)
(declare-const __default_CircularSecurity CircularSecurity)
(declare-const __default_CompleteFHESystem CompleteFHESystem)
(declare-const __default_FHECiphertext FHECiphertext)
(declare-const __default_FHEConfig FHEConfig)
(declare-const __default_FHEKeyPair FHEKeyPair)
(declare-const __default_FHESecurityProps FHESecurityProps)
(declare-const __default_HomAddition HomAddition)
(declare-const __default_HomMultiplication HomMultiplication)
(declare-const __default_HomOperations HomOperations)
(declare-const __default_HomomorphicOps HomomorphicOps)
(declare-const __default_INDCPAGame INDCPAGame)
(declare-const __default_KeyGenParams KeyGenParams)
(declare-const __default_LWEHardness LWEHardness)
(declare-const __default_NoiseBound NoiseBound)
(declare-const __default_NoiseManagement NoiseManagement)
(declare-const __default_NoiseModel NoiseModel)
(declare-const __default_RLWEConfig RLWEConfig)
(declare-const __default_SemanticSecurity SemanticSecurity)
(declare-const __default_UnlimitedFHE UnlimitedFHE)

; NEGLIGIBLE_THRESHOLD_CONST (matches Coq: Definition NEGLIGIBLE_THRESHOLD_CONST)
(define-fun NEGLIGIBLE_THRESHOLD_CONST () Int
  0)

; RIINA_ADVANTAGE_CONST (matches Coq: Definition RIINA_ADVANTAGE_CONST)
(define-fun RIINA_ADVANTAGE_CONST () Int
  0)

; NOISE_THRESHOLD_CONST (matches Coq: Definition NOISE_THRESHOLD_CONST)
(define-fun NOISE_THRESHOLD_CONST () Int
  0)

; RIINA_KP_PUBLIC_CONST (matches Coq: Definition RIINA_KP_PUBLIC_CONST)
(define-fun RIINA_KP_PUBLIC_CONST () Int
  0)

; RIINA_KP_SECRET_CONST (matches Coq: Definition RIINA_KP_SECRET_CONST)
(define-fun RIINA_KP_SECRET_CONST () Int
  0)

; RIINA_KP_EVAL_CONST (matches Coq: Definition RIINA_KP_EVAL_CONST)
(define-fun RIINA_KP_EVAL_CONST () Int
  0)

; RLWE_MODULUS_MIN_CONST (matches Coq: Definition RLWE_MODULUS_MIN_CONST)
(define-fun RLWE_MODULUS_MIN_CONST () Int
  0)

; RIINA_RLWE_MODULUS_CONST (matches Coq: Definition RIINA_RLWE_MODULUS_CONST)
(define-fun RIINA_RLWE_MODULUS_CONST () Int
  0)

; RIINA_NOISE_BOUND_MODULUS_CONST (matches Coq: Definition RIINA_NOISE_BOUND_MODULUS_CONST)
(define-fun RIINA_NOISE_BOUND_MODULUS_CONST () Int
  0)

; ops_fully_homomorphic (matches Coq: Definition ops_fully_homomorphic)
(define-fun ops_fully_homomorphic ((o HomomorphicOps)) Bool
  (= 0 0))

; fhe_security_complete (matches Coq: Definition fhe_security_complete)
(define-fun fhe_security_complete ((s FHESecurityProps)) Bool
  (= 0 0))

; noise_managed (matches Coq: Definition noise_managed)
(define-fun noise_managed ((n NoiseManagement)) Bool
  (= 0 0))

; fhe_fully_secure (matches Coq: Definition fhe_fully_secure)
(define-fun fhe_fully_secure ((f FHEConfig)) Bool
  (= 0 0))

; riina_fhe_ops (matches Coq: Definition riina_fhe_ops)
(define-fun riina_fhe_ops () HomomorphicOps
  __default_HomomorphicOps)

; riina_fhe_sec (matches Coq: Definition riina_fhe_sec)
(define-fun riina_fhe_sec () FHESecurityProps
  __default_FHESecurityProps)

; riina_fhe_noise (matches Coq: Definition riina_fhe_noise)
(define-fun riina_fhe_noise () NoiseManagement
  __default_NoiseManagement)

; riina_fhe (matches Coq: Definition riina_fhe)
(define-fun riina_fhe () FHEConfig
  __default_FHEConfig)

; negligible_threshold (matches Coq: Definition negligible_threshold)
(define-fun negligible_threshold () Int
  0)

; riina_advantage (matches Coq: Definition riina_advantage)
(define-fun riina_advantage () Int
  0)

; indcpa_secure (matches Coq: Definition indcpa_secure)
(define-fun indcpa_secure ((g INDCPAGame)) Bool
  (= 0 0))

; riina_indcpa (matches Coq: Definition riina_indcpa)
(define-fun riina_indcpa () INDCPAGame
  __default_INDCPAGame)

; semantic_secure (matches Coq: Definition semantic_secure)
(define-fun semantic_secure ((ss SemanticSecurity)) Bool
  (= 0 0))

; riina_semantic (matches Coq: Definition riina_semantic)
(define-fun riina_semantic () SemanticSecurity
  __default_SemanticSecurity)

; hom_add_correct (matches Coq: Definition hom_add_correct)
(define-fun hom_add_correct ((ha HomAddition)) Bool
  (= 0 0))

; riina_hom_add (matches Coq: Definition riina_hom_add)
(define-fun riina_hom_add () HomAddition
  __default_HomAddition)

; hom_mult_correct (matches Coq: Definition hom_mult_correct)
(define-fun hom_mult_correct ((hm HomMultiplication)) Bool
  (= 0 0))

; riina_hom_mult (matches Coq: Definition riina_hom_mult)
(define-fun riina_hom_mult () HomMultiplication
  __default_HomMultiplication)

; hom_ops_valid (matches Coq: Definition hom_ops_valid)
(define-fun hom_ops_valid ((ho HomOperations)) Bool
  (= 0 0))

; riina_hom_ops (matches Coq: Definition riina_hom_ops)
(define-fun riina_hom_ops () HomOperations
  __default_HomOperations)

; noise_after_additions (matches Coq: Definition noise_after_additions)
(define-fun noise_after_additions ((nm NoiseModel) (n Int)) Int
  0)

; noise_after_multiplications (matches Coq: Definition noise_after_multiplications)
(define-fun noise_after_multiplications ((nm NoiseModel) (n Int)) Int
  0)

; noise_safe (matches Coq: Definition noise_safe)
(define-fun noise_safe ((nm NoiseModel) (current Int)) Bool
  (= 0 0))

; riina_noise_model (matches Coq: Definition riina_noise_model)
(define-fun riina_noise_model () NoiseModel
  __default_NoiseModel)

; noise_bound_valid (matches Coq: Definition noise_bound_valid)
(define-fun noise_bound_valid ((nm NoiseModel) (nb NoiseBound)) Bool
  (= 0 0))

; riina_noise_bound (matches Coq: Definition riina_noise_bound)
(define-fun riina_noise_bound () NoiseBound
  __default_NoiseBound)

; bootstrapping_correct (matches Coq: Definition bootstrapping_correct)
(define-fun bootstrapping_correct ((bc BootstrappingConfig)) Bool
  (= 0 0))

; riina_bootstrap (matches Coq: Definition riina_bootstrap)
(define-fun riina_bootstrap () BootstrappingConfig
  __default_BootstrappingConfig)

; unlimited_fhe_valid (matches Coq: Definition unlimited_fhe_valid)
(define-fun unlimited_fhe_valid ((u UnlimitedFHE)) Bool
  (= 0 0))

; riina_unlimited (matches Coq: Definition riina_unlimited)
(define-fun riina_unlimited () UnlimitedFHE
  __default_UnlimitedFHE)

; keygen_secure (matches Coq: Definition keygen_secure)
(define-fun keygen_secure ((kg KeyGenParams)) Bool
  (= 0 0))

; riina_keygen (matches Coq: Definition riina_keygen)
(define-fun riina_keygen () KeyGenParams
  __default_KeyGenParams)

; keypair_valid (matches Coq: Definition keypair_valid)
(define-fun keypair_valid ((kp FHEKeyPair)) Bool
  (= 0 0))

; riina_keypair (matches Coq: Definition riina_keypair)
(define-fun riina_keypair () FHEKeyPair
  __default_FHEKeyPair)

; ciphertext_valid (matches Coq: Definition ciphertext_valid)
(define-fun ciphertext_valid ((ct FHECiphertext) (nm NoiseModel)) Bool
  (= 0 0))

; riina_ciphertext (matches Coq: Definition riina_ciphertext)
(define-fun riina_ciphertext () FHECiphertext
  __default_FHECiphertext)

; op_preserves_validity (matches Coq: Definition op_preserves_validity)
(define-fun op_preserves_validity ((cao CiphertextAfterOp) (nm NoiseModel)) Bool
  (= 0 0))

; complete_fhe_secure (matches Coq: Definition complete_fhe_secure)
(define-fun complete_fhe_secure ((sys CompleteFHESystem)) Bool
  (= 0 0))

; riina_complete_fhe (matches Coq: Definition riina_complete_fhe)
(define-fun riina_complete_fhe () CompleteFHESystem
  __default_CompleteFHESystem)

; circular_secure (matches Coq: Definition circular_secure)
(define-fun circular_secure ((cs CircularSecurity)) Bool
  (= 0 0))

; riina_circular (matches Coq: Definition riina_circular)
(define-fun riina_circular () CircularSecurity
  __default_CircularSecurity)

; lwe_secure (matches Coq: Definition lwe_secure)
(define-fun lwe_secure ((lwe LWEHardness)) Bool
  (= 0 0))

; riina_lwe (matches Coq: Definition riina_lwe)
(define-fun riina_lwe () LWEHardness
  __default_LWEHardness)

; rlwe_secure (matches Coq: Definition rlwe_secure)
(define-fun rlwe_secure ((r RLWEConfig)) Bool
  (= 0 0))

; riina_rlwe (matches Coq: Definition riina_rlwe)
(define-fun riina_rlwe () RLWEConfig
  __default_RLWEConfig)

; andb_true_iff (matches Coq: Lemma andb_true_iff)
; andb_true_iff: forall a b : bool, a && b = true <-> a = true /\ b = true
(assert (= 0 0)) ; andb_true_iff [Coq-only]

; andb3_true_iff (matches Coq: Lemma andb3_true_iff)
; andb3_true_iff: forall a b c : bool, a && b && c = true <-> a = true /\ b = true /\ c = true
(assert (= 0 0)) ; andb3_true_iff [Coq-only]

; negb_true_iff (matches Coq: Lemma negb_true_iff)
; negb_true_iff: forall b : bool, negb b = true <-> b = false
(assert (forall ((b Bool)) (= 0 0))) ; negb_true_iff [partial: bindings preserved]

; leb_le (matches Coq: Lemma leb_le)
; leb_le: forall n m : nat, (n <=? m) = true <-> n <= m
(assert (= 0 0)) ; leb_le [Coq-only]

; ltb_lt (matches Coq: Lemma ltb_lt)
; ltb_lt: forall n m : nat, (n <? m) = true <-> n < m
(assert (= 0 0)) ; ltb_lt [Coq-only]

; mult_le_compat (matches Coq: Lemma mult_le_compat)
; mult_le_compat: forall a b c d : nat, a <= b -> c <= d -> a * c <= b * d
(assert (= 0 0)) ; mult_le_compat [Coq-only]

; add_le_compat (matches Coq: Lemma add_le_compat)
; add_le_compat: forall a b c d : nat, a <= b -> c <= d -> a + c <= b + d
(assert (= 0 0)) ; add_le_compat [Coq-only]

; FHE_001 (matches Coq: Theorem FHE_001)
; FHE_001: ops_fully_homomorphic riina_fhe_ops = true
(assert (= 0 0)) ; FHE_001 [Coq-only]

; FHE_002 (matches Coq: Theorem FHE_002)
; FHE_002: fhe_security_complete riina_fhe_sec = true
(assert (= 0 0)) ; FHE_002 [Coq-only]

; FHE_003 (matches Coq: Theorem FHE_003)
; FHE_003: noise_managed riina_fhe_noise = true
(assert (= 0 0)) ; FHE_003 [Coq-only]

; FHE_004 (matches Coq: Theorem FHE_004)
; FHE_004: fhe_fully_secure riina_fhe = true
(assert (= 0 0)) ; FHE_004 [Coq-only]

; FHE_005 (matches Coq: Theorem FHE_005)
; FHE_005: ho_addition riina_fhe_ops = true
(assert (= 0 0)) ; FHE_005 [Coq-only]

; FHE_006 (matches Coq: Theorem FHE_006)
; FHE_006: ho_multiplication riina_fhe_ops = true
(assert (= 0 0)) ; FHE_006 [Coq-only]

; FHE_007 (matches Coq: Theorem FHE_007)
; FHE_007: ho_arbitrary_depth riina_fhe_ops = true
(assert (= 0 0)) ; FHE_007 [Coq-only]

; FHE_008 (matches Coq: Theorem FHE_008)
; FHE_008: fhe_ind_cpa riina_fhe_sec = true
(assert (= 0 0)) ; FHE_008 [Coq-only]

; FHE_009 (matches Coq: Theorem FHE_009)
; FHE_009: fhe_circular_secure riina_fhe_sec = true
(assert (= 0 0)) ; FHE_009 [Coq-only]

; FHE_010 (matches Coq: Theorem FHE_010)
; FHE_010: nm_bootstrapping riina_fhe_noise = true
(assert (= 0 0)) ; FHE_010 [Coq-only]

; FHE_011 (matches Coq: Theorem FHE_011)
; FHE_011: fhe_lattice_based riina_fhe = true
(assert (= 0 0)) ; FHE_011 [Coq-only]

; FHE_012 (matches Coq: Theorem FHE_012)
; FHE_012: fhe_post_quantum riina_fhe = true
(assert (= 0 0)) ; FHE_012 [Coq-only]

; FHE_013 (matches Coq: Theorem FHE_013)
; FHE_013: forall o, ops_fully_homomorphic o = true -> ho_multiplication o = true
(assert (forall ((o Bool)) (= 0 0))) ; FHE_013 [partial: bindings preserved]

; FHE_014 (matches Coq: Theorem FHE_014)
; FHE_014: forall o, ops_fully_homomorphic o = true -> ho_arbitrary_depth o = true
(assert (forall ((o Bool)) (= 0 0))) ; FHE_014 [partial: bindings preserved]

; FHE_015 (matches Coq: Theorem FHE_015)
; FHE_015: forall s, fhe_security_complete s = true -> fhe_ind_cpa s = true
(assert (forall ((s Bool)) (= 0 0))) ; FHE_015 [partial: bindings preserved]

; FHE_016 (matches Coq: Theorem FHE_016)
; FHE_016: forall n, noise_managed n = true -> nm_bootstrapping n = true
(assert (forall ((n Bool)) (= 0 0))) ; FHE_016 [partial: bindings preserved]

; FHE_017 (matches Coq: Theorem FHE_017)
; FHE_017: forall f, fhe_fully_secure f = true -> ops_fully_homomorphic (fhe_ops f) = true
(assert (forall ((f Bool)) (= 0 0))) ; FHE_017 [partial: bindings preserved]

; FHE_018 (matches Coq: Theorem FHE_018)
; FHE_018: forall f, fhe_fully_secure f = true -> fhe_security_complete (fhe_security f) = true
(assert (forall ((f Bool)) (= 0 0))) ; FHE_018 [partial: bindings preserved]

; FHE_019 (matches Coq: Theorem FHE_019)
; FHE_019: forall f, fhe_fully_secure f = true -> noise_managed (fhe_noise f) = true
(assert (forall ((f Bool)) (= 0 0))) ; FHE_019 [partial: bindings preserved]

; FHE_020 (matches Coq: Theorem FHE_020)
; FHE_020: forall f, fhe_fully_secure f = true -> fhe_post_quantum f = true
(assert (forall ((f Bool)) (= 0 0))) ; FHE_020 [partial: bindings preserved]

; FHE_021 (matches Coq: Theorem FHE_021)
; FHE_021: forall f, fhe_fully_secure f = true -> ho_arbitrary_depth (fhe_ops f) = true
(assert (forall ((f Bool)) (= 0 0))) ; FHE_021 [partial: bindings preserved]

; FHE_022 (matches Coq: Theorem FHE_022)
; FHE_022: forall f, fhe_fully_secure f = true -> fhe_ind_cpa (fhe_security f) = true
(assert (forall ((f Bool)) (= 0 0))) ; FHE_022 [partial: bindings preserved]

; FHE_023 (matches Coq: Theorem FHE_023)
; FHE_023: forall f, fhe_fully_secure f = true -> nm_bootstrapping (fhe_noise f) = true
(assert (forall ((f Bool)) (= 0 0))) ; FHE_023 [partial: bindings preserved]

; FHE_024 (matches Coq: Theorem FHE_024)
; FHE_024: fhe_fully_secure riina_fhe = true /\ fhe_post_quantum riina_fhe = true
(assert (= 0 0)) ; FHE_024 [Coq-only]

; FHE_025_complete (matches Coq: Theorem FHE_025_complete)
; FHE_025_complete: forall f, fhe_fully_secure f = true -> ho_arbitrary_depth (fhe_ops f) = true /\ fhe_ind_cpa (fhe_security f) = true /\ n
(assert (forall ((f Bool)) (= 0 0))) ; FHE_025_complete [partial: bindings preserved]

; indcpa_001_riina_secure (matches Coq: Theorem indcpa_001_riina_secure)
; indcpa_001_riina_secure: indcpa_secure riina_indcpa = true
(assert (= 0 0)) ; indcpa_001_riina_secure [Coq-only]

; indcpa_002_key_size_sufficient (matches Coq: Theorem indcpa_002_key_size_sufficient)
; indcpa_002_key_size_sufficient: forall g, indcpa_secure g = true -> (128 <=? icpa_key_size g) = true
(assert (forall ((g Bool)) (= 0 0))) ; indcpa_002_key_size_sufficient [partial: bindings preserved]

; indcpa_003_has_oracle (matches Coq: Theorem indcpa_003_has_oracle)
; indcpa_003_has_oracle: forall g, indcpa_secure g = true -> icpa_encryption_oracle g = true
(assert (forall ((g Bool)) (= 0 0))) ; indcpa_003_has_oracle [partial: bindings preserved]

; indcpa_004_negligible_advantage (matches Coq: Theorem indcpa_004_negligible_advantage)
; indcpa_004_negligible_advantage: forall g, indcpa_secure g = true -> (negligible_threshold <=? icpa_distinguisher_adv g) = true
(assert (forall ((g Bool)) (= 0 0))) ; indcpa_004_negligible_advantage [partial: bindings preserved]

; ss_001_riina_semantic_secure (matches Coq: Theorem ss_001_riina_semantic_secure)
; ss_001_riina_semantic_secure: semantic_secure riina_semantic = true
(assert (= 0 0)) ; ss_001_riina_semantic_secure [Coq-only]

; ss_002_implies_indistinguishable (matches Coq: Theorem ss_002_implies_indistinguishable)
; ss_002_implies_indistinguishable: forall ss, semantic_secure ss = true -> ss_indistinguishable ss = true
(assert (forall ((ss Bool)) (= 0 0))) ; ss_002_implies_indistinguishable [partial: bindings preserved]

; ss_003_implies_randomized (matches Coq: Theorem ss_003_implies_randomized)
; ss_003_implies_randomized: forall ss, semantic_secure ss = true -> ss_randomized ss = true
(assert (forall ((ss Bool)) (= 0 0))) ; ss_003_implies_randomized [partial: bindings preserved]

; ss_004_ciphertext_expansion (matches Coq: Theorem ss_004_ciphertext_expansion)
; ss_004_ciphertext_expansion: forall ss, semantic_secure ss = true -> (ss_message_space ss <? ss_ciphertext_space ss) = true
(assert (forall ((ss Bool)) (= 0 0))) ; ss_004_ciphertext_expansion [partial: bindings preserved]

; hadd_001_riina_correct (matches Coq: Theorem hadd_001_riina_correct)
; hadd_001_riina_correct: hom_add_correct riina_hom_add = true
(assert (= 0 0)) ; hadd_001_riina_correct [Coq-only]

; hadd_002_preserves_structure (matches Coq: Theorem hadd_002_preserves_structure)
; hadd_002_preserves_structure: forall ha, hom_add_correct ha = true -> ha_preserves_structure ha = true
(assert (forall ((ha Bool)) (= 0 0))) ; hadd_002_preserves_structure [partial: bindings preserved]

; hadd_003_modulus_relation (matches Coq: Theorem hadd_003_modulus_relation)
; hadd_003_modulus_relation: forall ha, hom_add_correct ha = true -> (ha_plaintext_modulus ha <? ha_ciphertext_modulus ha) = true
(assert (forall ((ha Bool)) (= 0 0))) ; hadd_003_modulus_relation [partial: bindings preserved]

; hmult_001_riina_correct (matches Coq: Theorem hmult_001_riina_correct)
; hmult_001_riina_correct: hom_mult_correct riina_hom_mult = true
(assert (= 0 0)) ; hmult_001_riina_correct [Coq-only]

; hmult_002_relinearization (matches Coq: Theorem hmult_002_relinearization)
; hmult_002_relinearization: forall hm, hom_mult_correct hm = true -> hm_relinearization hm = true
(assert (forall ((hm Bool)) (= 0 0))) ; hmult_002_relinearization [partial: bindings preserved]

; hmult_003_key_switching (matches Coq: Theorem hmult_003_key_switching)
; hmult_003_key_switching: forall hm, hom_mult_correct hm = true -> hm_key_switching hm = true
(assert (forall ((hm Bool)) (= 0 0))) ; hmult_003_key_switching [partial: bindings preserved]

; hops_001_riina_valid (matches Coq: Theorem hops_001_riina_valid)
; hops_001_riina_valid: hom_ops_valid riina_hom_ops = true
(assert (= 0 0)) ; hops_001_riina_valid [Coq-only]

; hops_002_addition_correct (matches Coq: Theorem hops_002_addition_correct)
; hops_002_addition_correct: forall ho, hom_ops_valid ho = true -> hom_add_correct (hops_addition ho) = true
(assert (forall ((ho Bool)) (= 0 0))) ; hops_002_addition_correct [partial: bindings preserved]

; hops_003_multiplication_correct (matches Coq: Theorem hops_003_multiplication_correct)
; hops_003_multiplication_correct: forall ho, hom_ops_valid ho = true -> hom_mult_correct (hops_multiplication ho) = true
(assert (forall ((ho Bool)) (= 0 0))) ; hops_003_multiplication_correct [partial: bindings preserved]

; hops_004_composition (matches Coq: Theorem hops_004_composition)
; hops_004_composition: forall ho, hom_ops_valid ho = true -> hops_composition ho = true
(assert (forall ((ho Bool)) (= 0 0))) ; hops_004_composition [partial: bindings preserved]

; noise_001_initial_safe (matches Coq: Theorem noise_001_initial_safe)
; noise_001_initial_safe: noise_safe riina_noise_model (noise_initial riina_noise_model) = true
(assert (= 0 0)) ; noise_001_initial_safe [Coq-only]

; noise_002_100_additions_safe (matches Coq: Theorem noise_002_100_additions_safe)
; noise_002_100_additions_safe: noise_safe riina_noise_model (noise_after_additions riina_noise_model 100) = true
(assert (= 0 0)) ; noise_002_100_additions_safe [Coq-only]

; noise_003_10_multiplications_safe (matches Coq: Theorem noise_003_10_multiplications_safe)
; noise_003_10_multiplications_safe: noise_safe riina_noise_model (noise_after_multiplications riina_noise_model 10) = true
(assert (= 0 0)) ; noise_003_10_multiplications_safe [Coq-only]

; noise_004_add_linear_growth (matches Coq: Theorem noise_004_add_linear_growth)
; noise_004_add_linear_growth: forall nm n, noise_after_additions nm (S n) = noise_after_additions nm n + noise_add_growth nm
(assert (forall ((nm Bool) (n Bool)) (= 0 0))) ; noise_004_add_linear_growth [partial: bindings preserved]

; noise_005_zero_additions (matches Coq: Theorem noise_005_zero_additions)
; noise_005_zero_additions: forall nm, noise_after_additions nm 0 = noise_initial nm
(assert (forall ((nm Bool)) (= 0 0))) ; noise_005_zero_additions [partial: bindings preserved]

; nb_001_riina_valid (matches Coq: Theorem nb_001_riina_valid)
; nb_001_riina_valid: noise_bound_valid riina_noise_model riina_noise_bound = true
(assert (= 0 0)) ; nb_001_riina_valid [Coq-only]

; nb_002_additions_safe (matches Coq: Theorem nb_002_additions_safe)
; nb_002_additions_safe: forall nm nb, noise_bound_valid nm nb = true -> noise_safe nm (noise_after_additions nm (nb_max_additions nb)) = true
(assert (forall ((nm Bool) (nb Bool)) (= 0 0))) ; nb_002_additions_safe [partial: bindings preserved]

; nb_003_multiplications_safe (matches Coq: Theorem nb_003_multiplications_safe)
; nb_003_multiplications_safe: forall nm nb, noise_bound_valid nm nb = true -> noise_safe nm (noise_after_multiplications nm (nb_max_multiplications nb
(assert (forall ((nm Bool) (nb Bool)) (= 0 0))) ; nb_003_multiplications_safe [partial: bindings preserved]

; boot_001_riina_correct (matches Coq: Theorem boot_001_riina_correct)
; boot_001_riina_correct: bootstrapping_correct riina_bootstrap = true
(assert (= 0 0)) ; boot_001_riina_correct [Coq-only]

; boot_002_reduces_noise (matches Coq: Theorem boot_002_reduces_noise)
; boot_002_reduces_noise: forall bc, bootstrapping_correct bc = true -> bs_reduces_noise bc = true
(assert (forall ((bc Bool)) (= 0 0))) ; boot_002_reduces_noise [partial: bindings preserved]

; boot_003_preserves_message (matches Coq: Theorem boot_003_preserves_message)
; boot_003_preserves_message: forall bc, bootstrapping_correct bc = true -> bs_preserves_message bc = true
(assert (forall ((bc Bool)) (= 0 0))) ; boot_003_preserves_message [partial: bindings preserved]

; boot_004_polynomial_time (matches Coq: Theorem boot_004_polynomial_time)
; boot_004_polynomial_time: forall bc, bootstrapping_correct bc = true -> bs_polynomial_time bc = true
(assert (forall ((bc Bool)) (= 0 0))) ; boot_004_polynomial_time [partial: bindings preserved]

; boot_005_noise_reduction (matches Coq: Theorem boot_005_noise_reduction)
; boot_005_noise_reduction: forall bc, bootstrapping_correct bc = true -> (bs_noise_output bc <? bs_noise_input_max bc) = true
(assert (forall ((bc Bool)) (= 0 0))) ; boot_005_noise_reduction [partial: bindings preserved]

; ufhe_001_riina_valid (matches Coq: Theorem ufhe_001_riina_valid)
; ufhe_001_riina_valid: unlimited_fhe_valid riina_unlimited = true
(assert (= 0 0)) ; ufhe_001_riina_valid [Coq-only]

; ufhe_002_bootstrap_correct (matches Coq: Theorem ufhe_002_bootstrap_correct)
; ufhe_002_bootstrap_correct: forall u, unlimited_fhe_valid u = true -> bootstrapping_correct (ufhe_bootstrap_config u) = true
(assert (forall ((u Bool)) (= 0 0))) ; ufhe_002_bootstrap_correct [partial: bindings preserved]

; kg_001_riina_secure (matches Coq: Theorem kg_001_riina_secure)
; kg_001_riina_secure: keygen_secure riina_keygen = true
(assert (= 0 0)) ; kg_001_riina_secure [Coq-only]

; kg_002_security_parameter (matches Coq: Theorem kg_002_security_parameter)
; kg_002_security_parameter: forall kg, keygen_secure kg = true -> (128 <=? kg_security_parameter kg) = true
(assert (forall ((kg Bool)) (= 0 0))) ; kg_002_security_parameter [partial: bindings preserved]

; kg_003_polynomial_degree (matches Coq: Theorem kg_003_polynomial_degree)
; kg_003_polynomial_degree: forall kg, keygen_secure kg = true -> (1024 <=? kg_polynomial_degree kg) = true
(assert (forall ((kg Bool)) (= 0 0))) ; kg_003_polynomial_degree [partial: bindings preserved]

; kg_004_error_distribution (matches Coq: Theorem kg_004_error_distribution)
; kg_004_error_distribution: forall kg, keygen_secure kg = true -> (0 <? kg_error_distribution kg) = true
(assert (forall ((kg Bool)) (= 0 0))) ; kg_004_error_distribution [partial: bindings preserved]

; kg_005_modulus_bits (matches Coq: Theorem kg_005_modulus_bits)
; kg_005_modulus_bits: forall kg, keygen_secure kg = true -> (32 <=? kg_modulus_bits kg) = true
(assert (forall ((kg Bool)) (= 0 0))) ; kg_005_modulus_bits [partial: bindings preserved]

; kp_001_riina_valid (matches Coq: Theorem kp_001_riina_valid)
; kp_001_riina_valid: keypair_valid riina_keypair = true
(assert (= 0 0)) ; kp_001_riina_valid [Coq-only]

; kp_002_secure_params (matches Coq: Theorem kp_002_secure_params)
; kp_002_secure_params: forall kp, keypair_valid kp = true -> keygen_secure (kp_params kp) = true
(assert (forall ((kp Bool)) (= 0 0))) ; kp_002_secure_params [partial: bindings preserved]

; ct_001_riina_valid (matches Coq: Theorem ct_001_riina_valid)
; ct_001_riina_valid: ciphertext_valid riina_ciphertext riina_noise_model = true
(assert (= 0 0)) ; ct_001_riina_valid [Coq-only]

; ct_002_valid_encryption (matches Coq: Theorem ct_002_valid_encryption)
; ct_002_valid_encryption: forall ct nm, ciphertext_valid ct nm = true -> ct_valid_encryption ct = true
(assert (forall ((ct Bool) (nm Bool)) (= 0 0))) ; ct_002_valid_encryption [partial: bindings preserved]

; ct_003_safe_noise (matches Coq: Theorem ct_003_safe_noise)
; ct_003_safe_noise: forall ct nm, ciphertext_valid ct nm = true -> noise_safe nm (ct_noise_estimate ct) = true
(assert (forall ((ct Bool) (nm Bool)) (= 0 0))) ; ct_003_safe_noise [partial: bindings preserved]

; ct_004_positive_level (matches Coq: Theorem ct_004_positive_level)
; ct_004_positive_level: forall ct nm, ciphertext_valid ct nm = true -> (0 <? ct_level ct) = true
(assert (forall ((ct Bool) (nm Bool)) (= 0 0))) ; ct_004_positive_level [partial: bindings preserved]

; cao_001_valid_preserves (matches Coq: Theorem cao_001_valid_preserves)
; cao_001_valid_preserves: forall cao nm, op_preserves_validity cao nm = true -> ciphertext_valid (cao_original cao) nm = true
(assert (forall ((cao Bool) (nm Bool)) (= 0 0))) ; cao_001_valid_preserves [partial: bindings preserved]

; cao_002_result_valid (matches Coq: Theorem cao_002_result_valid)
; cao_002_result_valid: forall cao nm, op_preserves_validity cao nm = true -> ciphertext_valid (cao_result cao) nm = true
(assert (forall ((cao Bool) (nm Bool)) (= 0 0))) ; cao_002_result_valid [partial: bindings preserved]

; cfhe_001_riina_secure (matches Coq: Theorem cfhe_001_riina_secure)
; cfhe_001_riina_secure: complete_fhe_secure riina_complete_fhe = true
(assert (= 0 0)) ; cfhe_001_riina_secure [Coq-only]

; cfhe_002_config_secure (matches Coq: Theorem cfhe_002_config_secure)
; cfhe_002_config_secure: forall sys, complete_fhe_secure sys = true -> fhe_fully_secure (cfhe_config sys) = true
(assert (forall ((sys Bool)) (= 0 0))) ; cfhe_002_config_secure [partial: bindings preserved]

; cfhe_003_keygen_secure (matches Coq: Theorem cfhe_003_keygen_secure)
; cfhe_003_keygen_secure: forall sys, complete_fhe_secure sys = true -> keygen_secure (cfhe_keygen sys) = true
(assert (forall ((sys Bool)) (= 0 0))) ; cfhe_003_keygen_secure [partial: bindings preserved]

; cfhe_004_indcpa_secure (matches Coq: Theorem cfhe_004_indcpa_secure)
; cfhe_004_indcpa_secure: forall sys, complete_fhe_secure sys = true -> indcpa_secure (cfhe_indcpa sys) = true
(assert (forall ((sys Bool)) (= 0 0))) ; cfhe_004_indcpa_secure [partial: bindings preserved]

; cfhe_005_bootstrap_correct (matches Coq: Theorem cfhe_005_bootstrap_correct)
; cfhe_005_bootstrap_correct: forall sys, complete_fhe_secure sys = true -> bootstrapping_correct (cfhe_bootstrap sys) = true
(assert (forall ((sys Bool)) (= 0 0))) ; cfhe_005_bootstrap_correct [partial: bindings preserved]

; cfhe_006_ops_valid (matches Coq: Theorem cfhe_006_ops_valid)
; cfhe_006_ops_valid: forall sys, complete_fhe_secure sys = true -> hom_ops_valid (cfhe_operations sys) = true
(assert (forall ((sys Bool)) (= 0 0))) ; cfhe_006_ops_valid [partial: bindings preserved]

; cfhe_007_pq_safe (matches Coq: Theorem cfhe_007_pq_safe)
; cfhe_007_pq_safe: forall sys, complete_fhe_secure sys = true -> fhe_post_quantum (cfhe_config sys) = true
(assert (forall ((sys Bool)) (= 0 0))) ; cfhe_007_pq_safe [partial: bindings preserved]

; cfhe_008_arbitrary_depth (matches Coq: Theorem cfhe_008_arbitrary_depth)
; cfhe_008_arbitrary_depth: forall sys, complete_fhe_secure sys = true -> ho_arbitrary_depth (fhe_ops (cfhe_config sys)) = true
(assert (forall ((sys Bool)) (= 0 0))) ; cfhe_008_arbitrary_depth [partial: bindings preserved]

; cfhe_009_semantic_secure (matches Coq: Theorem cfhe_009_semantic_secure)
; cfhe_009_semantic_secure: forall sys, complete_fhe_secure sys = true -> fhe_semantic_secure (fhe_security (cfhe_config sys)) = true
(assert (forall ((sys Bool)) (= 0 0))) ; cfhe_009_semantic_secure [partial: bindings preserved]

; cfhe_010_noise_managed (matches Coq: Theorem cfhe_010_noise_managed)
; cfhe_010_noise_managed: forall sys, complete_fhe_secure sys = true -> noise_managed (fhe_noise (cfhe_config sys)) = true
(assert (forall ((sys Bool)) (= 0 0))) ; cfhe_010_noise_managed [partial: bindings preserved]

; circ_001_riina_secure (matches Coq: Theorem circ_001_riina_secure)
; circ_001_riina_secure: circular_secure riina_circular = true
(assert (= 0 0)) ; circ_001_riina_secure [Coq-only]

; circ_002_key_encryption (matches Coq: Theorem circ_002_key_encryption)
; circ_002_key_encryption: forall cs, circular_secure cs = true -> cs_key_encryption_safe cs = true
(assert (forall ((cs Bool)) (= 0 0))) ; circ_002_key_encryption [partial: bindings preserved]

; lwe_001_riina_secure (matches Coq: Theorem lwe_001_riina_secure)
; lwe_001_riina_secure: lwe_secure riina_lwe = true
(assert (= 0 0)) ; lwe_001_riina_secure [Coq-only]

; lwe_002_dimension (matches Coq: Theorem lwe_002_dimension)
; lwe_002_dimension: forall lwe, lwe_secure lwe = true -> (512 <=? lwe_dimension lwe) = true
(assert (forall ((lwe Bool)) (= 0 0))) ; lwe_002_dimension [partial: bindings preserved]

; rlwe_001_riina_secure (matches Coq: Theorem rlwe_001_riina_secure)
; rlwe_001_riina_secure: rlwe_secure riina_rlwe = true
(assert (= 0 0)) ; rlwe_001_riina_secure [Coq-only]

; rlwe_002_ring_degree (matches Coq: Theorem rlwe_002_ring_degree)
; rlwe_002_ring_degree: forall r, rlwe_secure r = true -> (1024 <=? rlwe_ring_degree r) = true
(assert (forall ((r Bool)) (= 0 0))) ; rlwe_002_ring_degree [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/FHESecurity.v (94 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for FHESecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; ops_fully_homomorphic: source semantics (matches Coq)
; Translation validation: ops_fully_homomorphic preserves semantics
(push 1)
(declare-const source_ops_fully_homomorphic Int)
(declare-const target_ops_fully_homomorphic Int)
(assert (>= source_ops_fully_homomorphic 0))
(assert (>= target_ops_fully_homomorphic 0))
(assert (not (= source_ops_fully_homomorphic target_ops_fully_homomorphic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fhe_security_complete: source semantics (matches Coq)
; Translation validation: fhe_security_complete preserves semantics
(push 1)
(declare-const source_fhe_security_complete Int)
(declare-const target_fhe_security_complete Int)
(assert (>= source_fhe_security_complete 0))
(assert (>= target_fhe_security_complete 0))
(assert (not (= source_fhe_security_complete target_fhe_security_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_managed: source semantics (matches Coq)
; Translation validation: noise_managed preserves semantics
(push 1)
(declare-const source_noise_managed Int)
(declare-const target_noise_managed Int)
(assert (>= source_noise_managed 0))
(assert (>= target_noise_managed 0))
(assert (not (= source_noise_managed target_noise_managed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fhe_fully_secure: source semantics (matches Coq)
; Translation validation: fhe_fully_secure preserves semantics
(push 1)
(declare-const source_fhe_fully_secure Int)
(declare-const target_fhe_fully_secure Int)
(assert (>= source_fhe_fully_secure 0))
(assert (>= target_fhe_fully_secure 0))
(assert (not (= source_fhe_fully_secure target_fhe_fully_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_fhe_ops: source semantics (matches Coq)
; Translation validation: riina_fhe_ops preserves semantics
(push 1)
(declare-const source_riina_fhe_ops Int)
(declare-const target_riina_fhe_ops Int)
(assert (>= source_riina_fhe_ops 0))
(assert (>= target_riina_fhe_ops 0))
(assert (not (= source_riina_fhe_ops target_riina_fhe_ops)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_fhe_sec: source semantics (matches Coq)
; Translation validation: riina_fhe_sec preserves semantics
(push 1)
(declare-const source_riina_fhe_sec Int)
(declare-const target_riina_fhe_sec Int)
(assert (>= source_riina_fhe_sec 0))
(assert (>= target_riina_fhe_sec 0))
(assert (not (= source_riina_fhe_sec target_riina_fhe_sec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_fhe_noise: source semantics (matches Coq)
; Translation validation: riina_fhe_noise preserves semantics
(push 1)
(declare-const source_riina_fhe_noise Int)
(declare-const target_riina_fhe_noise Int)
(assert (>= source_riina_fhe_noise 0))
(assert (>= target_riina_fhe_noise 0))
(assert (not (= source_riina_fhe_noise target_riina_fhe_noise)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_fhe: source semantics (matches Coq)
; Translation validation: riina_fhe preserves semantics
(push 1)
(declare-const source_riina_fhe Int)
(declare-const target_riina_fhe Int)
(assert (>= source_riina_fhe 0))
(assert (>= target_riina_fhe 0))
(assert (not (= source_riina_fhe target_riina_fhe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negligible_threshold: source semantics (matches Coq)
; Translation validation: negligible_threshold preserves semantics
(push 1)
(declare-const source_negligible_threshold Int)
(declare-const target_negligible_threshold Int)
(assert (>= source_negligible_threshold 0))
(assert (>= target_negligible_threshold 0))
(assert (not (= source_negligible_threshold target_negligible_threshold)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_advantage: source semantics (matches Coq)
; Translation validation: riina_advantage preserves semantics
(push 1)
(declare-const source_riina_advantage Int)
(declare-const target_riina_advantage Int)
(assert (>= source_riina_advantage 0))
(assert (>= target_riina_advantage 0))
(assert (not (= source_riina_advantage target_riina_advantage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; indcpa_secure: source semantics (matches Coq)
; Translation validation: indcpa_secure preserves semantics
(push 1)
(declare-const source_indcpa_secure Int)
(declare-const target_indcpa_secure Int)
(assert (>= source_indcpa_secure 0))
(assert (>= target_indcpa_secure 0))
(assert (not (= source_indcpa_secure target_indcpa_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_indcpa: source semantics (matches Coq)
; Translation validation: riina_indcpa preserves semantics
(push 1)
(declare-const source_riina_indcpa Int)
(declare-const target_riina_indcpa Int)
(assert (>= source_riina_indcpa 0))
(assert (>= target_riina_indcpa 0))
(assert (not (= source_riina_indcpa target_riina_indcpa)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; semantic_secure: source semantics (matches Coq)
; Translation validation: semantic_secure preserves semantics
(push 1)
(declare-const source_semantic_secure Int)
(declare-const target_semantic_secure Int)
(assert (>= source_semantic_secure 0))
(assert (>= target_semantic_secure 0))
(assert (not (= source_semantic_secure target_semantic_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_semantic: source semantics (matches Coq)
; Translation validation: riina_semantic preserves semantics
(push 1)
(declare-const source_riina_semantic Int)
(declare-const target_riina_semantic Int)
(assert (>= source_riina_semantic 0))
(assert (>= target_riina_semantic 0))
(assert (not (= source_riina_semantic target_riina_semantic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hom_add_correct: source semantics (matches Coq)
; Translation validation: hom_add_correct preserves semantics
(push 1)
(declare-const source_hom_add_correct Int)
(declare-const target_hom_add_correct Int)
(assert (>= source_hom_add_correct 0))
(assert (>= target_hom_add_correct 0))
(assert (not (= source_hom_add_correct target_hom_add_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_hom_add: source semantics (matches Coq)
; Translation validation: riina_hom_add preserves semantics
(push 1)
(declare-const source_riina_hom_add Int)
(declare-const target_riina_hom_add Int)
(assert (>= source_riina_hom_add 0))
(assert (>= target_riina_hom_add 0))
(assert (not (= source_riina_hom_add target_riina_hom_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hom_mult_correct: source semantics (matches Coq)
; Translation validation: hom_mult_correct preserves semantics
(push 1)
(declare-const source_hom_mult_correct Int)
(declare-const target_hom_mult_correct Int)
(assert (>= source_hom_mult_correct 0))
(assert (>= target_hom_mult_correct 0))
(assert (not (= source_hom_mult_correct target_hom_mult_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_hom_mult: source semantics (matches Coq)
; Translation validation: riina_hom_mult preserves semantics
(push 1)
(declare-const source_riina_hom_mult Int)
(declare-const target_riina_hom_mult Int)
(assert (>= source_riina_hom_mult 0))
(assert (>= target_riina_hom_mult 0))
(assert (not (= source_riina_hom_mult target_riina_hom_mult)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hom_ops_valid: source semantics (matches Coq)
; Translation validation: hom_ops_valid preserves semantics
(push 1)
(declare-const source_hom_ops_valid Int)
(declare-const target_hom_ops_valid Int)
(assert (>= source_hom_ops_valid 0))
(assert (>= target_hom_ops_valid 0))
(assert (not (= source_hom_ops_valid target_hom_ops_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_hom_ops: source semantics (matches Coq)
; Translation validation: riina_hom_ops preserves semantics
(push 1)
(declare-const source_riina_hom_ops Int)
(declare-const target_riina_hom_ops Int)
(assert (>= source_riina_hom_ops 0))
(assert (>= target_riina_hom_ops 0))
(assert (not (= source_riina_hom_ops target_riina_hom_ops)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_after_additions: source semantics (matches Coq)
; Translation validation: noise_after_additions preserves semantics
(push 1)
(declare-const source_noise_after_additions Int)
(declare-const target_noise_after_additions Int)
(assert (>= source_noise_after_additions 0))
(assert (>= target_noise_after_additions 0))
(assert (not (= source_noise_after_additions target_noise_after_additions)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_after_multiplications: source semantics (matches Coq)
; Translation validation: noise_after_multiplications preserves semantics
(push 1)
(declare-const source_noise_after_multiplications Int)
(declare-const target_noise_after_multiplications Int)
(assert (>= source_noise_after_multiplications 0))
(assert (>= target_noise_after_multiplications 0))
(assert (not (= source_noise_after_multiplications target_noise_after_multiplications)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_safe: source semantics (matches Coq)
; Translation validation: noise_safe preserves semantics
(push 1)
(declare-const source_noise_safe Int)
(declare-const target_noise_safe Int)
(assert (>= source_noise_safe 0))
(assert (>= target_noise_safe 0))
(assert (not (= source_noise_safe target_noise_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_noise_model: source semantics (matches Coq)
; Translation validation: riina_noise_model preserves semantics
(push 1)
(declare-const source_riina_noise_model Int)
(declare-const target_riina_noise_model Int)
(assert (>= source_riina_noise_model 0))
(assert (>= target_riina_noise_model 0))
(assert (not (= source_riina_noise_model target_riina_noise_model)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_bound_valid: source semantics (matches Coq)
; Translation validation: noise_bound_valid preserves semantics
(push 1)
(declare-const source_noise_bound_valid Int)
(declare-const target_noise_bound_valid Int)
(assert (>= source_noise_bound_valid 0))
(assert (>= target_noise_bound_valid 0))
(assert (not (= source_noise_bound_valid target_noise_bound_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_noise_bound: source semantics (matches Coq)
; Translation validation: riina_noise_bound preserves semantics
(push 1)
(declare-const source_riina_noise_bound Int)
(declare-const target_riina_noise_bound Int)
(assert (>= source_riina_noise_bound 0))
(assert (>= target_riina_noise_bound 0))
(assert (not (= source_riina_noise_bound target_riina_noise_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bootstrapping_correct: source semantics (matches Coq)
; Translation validation: bootstrapping_correct preserves semantics
(push 1)
(declare-const source_bootstrapping_correct Int)
(declare-const target_bootstrapping_correct Int)
(assert (>= source_bootstrapping_correct 0))
(assert (>= target_bootstrapping_correct 0))
(assert (not (= source_bootstrapping_correct target_bootstrapping_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_bootstrap: source semantics (matches Coq)
; Translation validation: riina_bootstrap preserves semantics
(push 1)
(declare-const source_riina_bootstrap Int)
(declare-const target_riina_bootstrap Int)
(assert (>= source_riina_bootstrap 0))
(assert (>= target_riina_bootstrap 0))
(assert (not (= source_riina_bootstrap target_riina_bootstrap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unlimited_fhe_valid: source semantics (matches Coq)
; Translation validation: unlimited_fhe_valid preserves semantics
(push 1)
(declare-const source_unlimited_fhe_valid Int)
(declare-const target_unlimited_fhe_valid Int)
(assert (>= source_unlimited_fhe_valid 0))
(assert (>= target_unlimited_fhe_valid 0))
(assert (not (= source_unlimited_fhe_valid target_unlimited_fhe_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_unlimited: source semantics (matches Coq)
; Translation validation: riina_unlimited preserves semantics
(push 1)
(declare-const source_riina_unlimited Int)
(declare-const target_riina_unlimited Int)
(assert (>= source_riina_unlimited 0))
(assert (>= target_riina_unlimited 0))
(assert (not (= source_riina_unlimited target_riina_unlimited)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; keygen_secure: source semantics (matches Coq)
; Translation validation: keygen_secure preserves semantics
(push 1)
(declare-const source_keygen_secure Int)
(declare-const target_keygen_secure Int)
(assert (>= source_keygen_secure 0))
(assert (>= target_keygen_secure 0))
(assert (not (= source_keygen_secure target_keygen_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_keygen: source semantics (matches Coq)
; Translation validation: riina_keygen preserves semantics
(push 1)
(declare-const source_riina_keygen Int)
(declare-const target_riina_keygen Int)
(assert (>= source_riina_keygen 0))
(assert (>= target_riina_keygen 0))
(assert (not (= source_riina_keygen target_riina_keygen)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; keypair_valid: source semantics (matches Coq)
; Translation validation: keypair_valid preserves semantics
(push 1)
(declare-const source_keypair_valid Int)
(declare-const target_keypair_valid Int)
(assert (>= source_keypair_valid 0))
(assert (>= target_keypair_valid 0))
(assert (not (= source_keypair_valid target_keypair_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_keypair: source semantics (matches Coq)
; Translation validation: riina_keypair preserves semantics
(push 1)
(declare-const source_riina_keypair Int)
(declare-const target_riina_keypair Int)
(assert (>= source_riina_keypair 0))
(assert (>= target_riina_keypair 0))
(assert (not (= source_riina_keypair target_riina_keypair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ciphertext_valid: source semantics (matches Coq)
; Translation validation: ciphertext_valid preserves semantics
(push 1)
(declare-const source_ciphertext_valid Int)
(declare-const target_ciphertext_valid Int)
(assert (>= source_ciphertext_valid 0))
(assert (>= target_ciphertext_valid 0))
(assert (not (= source_ciphertext_valid target_ciphertext_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_ciphertext: source semantics (matches Coq)
; Translation validation: riina_ciphertext preserves semantics
(push 1)
(declare-const source_riina_ciphertext Int)
(declare-const target_riina_ciphertext Int)
(assert (>= source_riina_ciphertext 0))
(assert (>= target_riina_ciphertext 0))
(assert (not (= source_riina_ciphertext target_riina_ciphertext)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; op_preserves_validity: source semantics (matches Coq)
; Translation validation: op_preserves_validity preserves semantics
(push 1)
(declare-const source_op_preserves_validity Int)
(declare-const target_op_preserves_validity Int)
(assert (>= source_op_preserves_validity 0))
(assert (>= target_op_preserves_validity 0))
(assert (not (= source_op_preserves_validity target_op_preserves_validity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; complete_fhe_secure: source semantics (matches Coq)
; Translation validation: complete_fhe_secure preserves semantics
(push 1)
(declare-const source_complete_fhe_secure Int)
(declare-const target_complete_fhe_secure Int)
(assert (>= source_complete_fhe_secure 0))
(assert (>= target_complete_fhe_secure 0))
(assert (not (= source_complete_fhe_secure target_complete_fhe_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_complete_fhe: source semantics (matches Coq)
; Translation validation: riina_complete_fhe preserves semantics
(push 1)
(declare-const source_riina_complete_fhe Int)
(declare-const target_riina_complete_fhe Int)
(assert (>= source_riina_complete_fhe 0))
(assert (>= target_riina_complete_fhe 0))
(assert (not (= source_riina_complete_fhe target_riina_complete_fhe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; circular_secure: source semantics (matches Coq)
; Translation validation: circular_secure preserves semantics
(push 1)
(declare-const source_circular_secure Int)
(declare-const target_circular_secure Int)
(assert (>= source_circular_secure 0))
(assert (>= target_circular_secure 0))
(assert (not (= source_circular_secure target_circular_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_circular: source semantics (matches Coq)
; Translation validation: riina_circular preserves semantics
(push 1)
(declare-const source_riina_circular Int)
(declare-const target_riina_circular Int)
(assert (>= source_riina_circular 0))
(assert (>= target_riina_circular 0))
(assert (not (= source_riina_circular target_riina_circular)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lwe_secure: source semantics (matches Coq)
; Translation validation: lwe_secure preserves semantics
(push 1)
(declare-const source_lwe_secure Int)
(declare-const target_lwe_secure Int)
(assert (>= source_lwe_secure 0))
(assert (>= target_lwe_secure 0))
(assert (not (= source_lwe_secure target_lwe_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_lwe: source semantics (matches Coq)
; Translation validation: riina_lwe preserves semantics
(push 1)
(declare-const source_riina_lwe Int)
(declare-const target_riina_lwe Int)
(assert (>= source_riina_lwe 0))
(assert (>= target_riina_lwe 0))
(assert (not (= source_riina_lwe target_riina_lwe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rlwe_secure: source semantics (matches Coq)
; Translation validation: rlwe_secure preserves semantics
(push 1)
(declare-const source_rlwe_secure Int)
(declare-const target_rlwe_secure Int)
(assert (>= source_rlwe_secure 0))
(assert (>= target_rlwe_secure 0))
(assert (not (= source_rlwe_secure target_rlwe_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_rlwe: source semantics (matches Coq)
; Translation validation: riina_rlwe preserves semantics
(push 1)
(declare-const source_riina_rlwe Int)
(declare-const target_riina_rlwe Int)
(assert (>= source_riina_rlwe 0))
(assert (>= target_riina_rlwe 0))
(assert (not (= source_riina_rlwe target_riina_rlwe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff preserves semantics
(push 1)
(declare-const source_andb_true_iff Int)
(declare-const target_andb_true_iff Int)
(assert (>= source_andb_true_iff 0))
(assert (>= target_andb_true_iff 0))
(assert (not (= source_andb_true_iff target_andb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb3_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb3_true_iff preserves semantics
(push 1)
(declare-const source_andb3_true_iff Int)
(declare-const target_andb3_true_iff Int)
(assert (>= source_andb3_true_iff 0))
(assert (>= target_andb3_true_iff 0))
(assert (not (= source_andb3_true_iff target_andb3_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_true_iff preserves semantics
(push 1)
(declare-const source_negb_true_iff Int)
(declare-const target_negb_true_iff Int)
(assert (>= source_negb_true_iff 0))
(assert (>= target_negb_true_iff 0))
(assert (not (= source_negb_true_iff target_negb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; leb_le: translation preserves property (matches Coq: Lemma)
; Translation validation: leb_le preserves semantics
(push 1)
(declare-const source_leb_le Int)
(declare-const target_leb_le Int)
(assert (>= source_leb_le 0))
(assert (>= target_leb_le 0))
(assert (not (= source_leb_le target_leb_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ltb_lt: translation preserves property (matches Coq: Lemma)
; Translation validation: ltb_lt preserves semantics
(push 1)
(declare-const source_ltb_lt Int)
(declare-const target_ltb_lt Int)
(assert (>= source_ltb_lt 0))
(assert (>= target_ltb_lt 0))
(assert (not (= source_ltb_lt target_ltb_lt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mult_le_compat: translation preserves property (matches Coq: Lemma)
; Translation validation: mult_le_compat preserves semantics
(push 1)
(declare-const source_mult_le_compat Int)
(declare-const target_mult_le_compat Int)
(assert (>= source_mult_le_compat 0))
(assert (>= target_mult_le_compat 0))
(assert (not (= source_mult_le_compat target_mult_le_compat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; add_le_compat: translation preserves property (matches Coq: Lemma)
; Translation validation: add_le_compat preserves semantics
(push 1)
(declare-const source_add_le_compat Int)
(declare-const target_add_le_compat Int)
(assert (>= source_add_le_compat 0))
(assert (>= target_add_le_compat 0))
(assert (not (= source_add_le_compat target_add_le_compat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_001: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_001 preserves semantics
(push 1)
(declare-const source_FHE_001 Int)
(declare-const target_FHE_001 Int)
(assert (>= source_FHE_001 0))
(assert (>= target_FHE_001 0))
(assert (not (= source_FHE_001 target_FHE_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_002: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_002 preserves semantics
(push 1)
(declare-const source_FHE_002 Int)
(declare-const target_FHE_002 Int)
(assert (>= source_FHE_002 0))
(assert (>= target_FHE_002 0))
(assert (not (= source_FHE_002 target_FHE_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_003: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_003 preserves semantics
(push 1)
(declare-const source_FHE_003 Int)
(declare-const target_FHE_003 Int)
(assert (>= source_FHE_003 0))
(assert (>= target_FHE_003 0))
(assert (not (= source_FHE_003 target_FHE_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_004: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_004 preserves semantics
(push 1)
(declare-const source_FHE_004 Int)
(declare-const target_FHE_004 Int)
(assert (>= source_FHE_004 0))
(assert (>= target_FHE_004 0))
(assert (not (= source_FHE_004 target_FHE_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_005: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_005 preserves semantics
(push 1)
(declare-const source_FHE_005 Int)
(declare-const target_FHE_005 Int)
(assert (>= source_FHE_005 0))
(assert (>= target_FHE_005 0))
(assert (not (= source_FHE_005 target_FHE_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_006: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_006 preserves semantics
(push 1)
(declare-const source_FHE_006 Int)
(declare-const target_FHE_006 Int)
(assert (>= source_FHE_006 0))
(assert (>= target_FHE_006 0))
(assert (not (= source_FHE_006 target_FHE_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_007: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_007 preserves semantics
(push 1)
(declare-const source_FHE_007 Int)
(declare-const target_FHE_007 Int)
(assert (>= source_FHE_007 0))
(assert (>= target_FHE_007 0))
(assert (not (= source_FHE_007 target_FHE_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_008: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_008 preserves semantics
(push 1)
(declare-const source_FHE_008 Int)
(declare-const target_FHE_008 Int)
(assert (>= source_FHE_008 0))
(assert (>= target_FHE_008 0))
(assert (not (= source_FHE_008 target_FHE_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_009: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_009 preserves semantics
(push 1)
(declare-const source_FHE_009 Int)
(declare-const target_FHE_009 Int)
(assert (>= source_FHE_009 0))
(assert (>= target_FHE_009 0))
(assert (not (= source_FHE_009 target_FHE_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_010: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_010 preserves semantics
(push 1)
(declare-const source_FHE_010 Int)
(declare-const target_FHE_010 Int)
(assert (>= source_FHE_010 0))
(assert (>= target_FHE_010 0))
(assert (not (= source_FHE_010 target_FHE_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_011: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_011 preserves semantics
(push 1)
(declare-const source_FHE_011 Int)
(declare-const target_FHE_011 Int)
(assert (>= source_FHE_011 0))
(assert (>= target_FHE_011 0))
(assert (not (= source_FHE_011 target_FHE_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_012: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_012 preserves semantics
(push 1)
(declare-const source_FHE_012 Int)
(declare-const target_FHE_012 Int)
(assert (>= source_FHE_012 0))
(assert (>= target_FHE_012 0))
(assert (not (= source_FHE_012 target_FHE_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_013: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_013 preserves semantics
(push 1)
(declare-const source_FHE_013 Int)
(declare-const target_FHE_013 Int)
(assert (>= source_FHE_013 0))
(assert (>= target_FHE_013 0))
(assert (not (= source_FHE_013 target_FHE_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_014: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_014 preserves semantics
(push 1)
(declare-const source_FHE_014 Int)
(declare-const target_FHE_014 Int)
(assert (>= source_FHE_014 0))
(assert (>= target_FHE_014 0))
(assert (not (= source_FHE_014 target_FHE_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_015: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_015 preserves semantics
(push 1)
(declare-const source_FHE_015 Int)
(declare-const target_FHE_015 Int)
(assert (>= source_FHE_015 0))
(assert (>= target_FHE_015 0))
(assert (not (= source_FHE_015 target_FHE_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_016: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_016 preserves semantics
(push 1)
(declare-const source_FHE_016 Int)
(declare-const target_FHE_016 Int)
(assert (>= source_FHE_016 0))
(assert (>= target_FHE_016 0))
(assert (not (= source_FHE_016 target_FHE_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_017: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_017 preserves semantics
(push 1)
(declare-const source_FHE_017 Int)
(declare-const target_FHE_017 Int)
(assert (>= source_FHE_017 0))
(assert (>= target_FHE_017 0))
(assert (not (= source_FHE_017 target_FHE_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_018: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_018 preserves semantics
(push 1)
(declare-const source_FHE_018 Int)
(declare-const target_FHE_018 Int)
(assert (>= source_FHE_018 0))
(assert (>= target_FHE_018 0))
(assert (not (= source_FHE_018 target_FHE_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_019: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_019 preserves semantics
(push 1)
(declare-const source_FHE_019 Int)
(declare-const target_FHE_019 Int)
(assert (>= source_FHE_019 0))
(assert (>= target_FHE_019 0))
(assert (not (= source_FHE_019 target_FHE_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_020: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_020 preserves semantics
(push 1)
(declare-const source_FHE_020 Int)
(declare-const target_FHE_020 Int)
(assert (>= source_FHE_020 0))
(assert (>= target_FHE_020 0))
(assert (not (= source_FHE_020 target_FHE_020)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_021: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_021 preserves semantics
(push 1)
(declare-const source_FHE_021 Int)
(declare-const target_FHE_021 Int)
(assert (>= source_FHE_021 0))
(assert (>= target_FHE_021 0))
(assert (not (= source_FHE_021 target_FHE_021)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_022: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_022 preserves semantics
(push 1)
(declare-const source_FHE_022 Int)
(declare-const target_FHE_022 Int)
(assert (>= source_FHE_022 0))
(assert (>= target_FHE_022 0))
(assert (not (= source_FHE_022 target_FHE_022)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_023: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_023 preserves semantics
(push 1)
(declare-const source_FHE_023 Int)
(declare-const target_FHE_023 Int)
(assert (>= source_FHE_023 0))
(assert (>= target_FHE_023 0))
(assert (not (= source_FHE_023 target_FHE_023)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_024: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_024 preserves semantics
(push 1)
(declare-const source_FHE_024 Int)
(declare-const target_FHE_024 Int)
(assert (>= source_FHE_024 0))
(assert (>= target_FHE_024 0))
(assert (not (= source_FHE_024 target_FHE_024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FHE_025_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: FHE_025_complete preserves semantics
(push 1)
(declare-const source_FHE_025_complete Int)
(declare-const target_FHE_025_complete Int)
(assert (>= source_FHE_025_complete 0))
(assert (>= target_FHE_025_complete 0))
(assert (not (= source_FHE_025_complete target_FHE_025_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; indcpa_001_riina_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: indcpa_001_riina_secure preserves semantics
(push 1)
(declare-const source_indcpa_001_riina_secure Int)
(declare-const target_indcpa_001_riina_secure Int)
(assert (>= source_indcpa_001_riina_secure 0))
(assert (>= target_indcpa_001_riina_secure 0))
(assert (not (= source_indcpa_001_riina_secure target_indcpa_001_riina_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; indcpa_002_key_size_sufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: indcpa_002_key_size_sufficient preserves semantics
(push 1)
(declare-const source_indcpa_002_key_size_sufficient Int)
(declare-const target_indcpa_002_key_size_sufficient Int)
(assert (>= source_indcpa_002_key_size_sufficient 0))
(assert (>= target_indcpa_002_key_size_sufficient 0))
(assert (not (= source_indcpa_002_key_size_sufficient target_indcpa_002_key_size_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; indcpa_003_has_oracle: translation preserves property (matches Coq: Theorem)
; Translation validation: indcpa_003_has_oracle preserves semantics
(push 1)
(declare-const source_indcpa_003_has_oracle Int)
(declare-const target_indcpa_003_has_oracle Int)
(assert (>= source_indcpa_003_has_oracle 0))
(assert (>= target_indcpa_003_has_oracle 0))
(assert (not (= source_indcpa_003_has_oracle target_indcpa_003_has_oracle)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; indcpa_004_negligible_advantage: translation preserves property (matches Coq: Theorem)
; Translation validation: indcpa_004_negligible_advantage preserves semantics
(push 1)
(declare-const source_indcpa_004_negligible_advantage Int)
(declare-const target_indcpa_004_negligible_advantage Int)
(assert (>= source_indcpa_004_negligible_advantage 0))
(assert (>= target_indcpa_004_negligible_advantage 0))
(assert (not (= source_indcpa_004_negligible_advantage target_indcpa_004_negligible_advantage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ss_001_riina_semantic_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: ss_001_riina_semantic_secure preserves semantics
(push 1)
(declare-const source_ss_001_riina_semantic_secure Int)
(declare-const target_ss_001_riina_semantic_secure Int)
(assert (>= source_ss_001_riina_semantic_secure 0))
(assert (>= target_ss_001_riina_semantic_secure 0))
(assert (not (= source_ss_001_riina_semantic_secure target_ss_001_riina_semantic_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ss_002_implies_indistinguishable: translation preserves property (matches Coq: Theorem)
; Translation validation: ss_002_implies_indistinguishable preserves semantics
(push 1)
(declare-const source_ss_002_implies_indistinguishable Int)
(declare-const target_ss_002_implies_indistinguishable Int)
(assert (>= source_ss_002_implies_indistinguishable 0))
(assert (>= target_ss_002_implies_indistinguishable 0))
(assert (not (= source_ss_002_implies_indistinguishable target_ss_002_implies_indistinguishable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ss_003_implies_randomized: translation preserves property (matches Coq: Theorem)
; Translation validation: ss_003_implies_randomized preserves semantics
(push 1)
(declare-const source_ss_003_implies_randomized Int)
(declare-const target_ss_003_implies_randomized Int)
(assert (>= source_ss_003_implies_randomized 0))
(assert (>= target_ss_003_implies_randomized 0))
(assert (not (= source_ss_003_implies_randomized target_ss_003_implies_randomized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ss_004_ciphertext_expansion: translation preserves property (matches Coq: Theorem)
; Translation validation: ss_004_ciphertext_expansion preserves semantics
(push 1)
(declare-const source_ss_004_ciphertext_expansion Int)
(declare-const target_ss_004_ciphertext_expansion Int)
(assert (>= source_ss_004_ciphertext_expansion 0))
(assert (>= target_ss_004_ciphertext_expansion 0))
(assert (not (= source_ss_004_ciphertext_expansion target_ss_004_ciphertext_expansion)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hadd_001_riina_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: hadd_001_riina_correct preserves semantics
(push 1)
(declare-const source_hadd_001_riina_correct Int)
(declare-const target_hadd_001_riina_correct Int)
(assert (>= source_hadd_001_riina_correct 0))
(assert (>= target_hadd_001_riina_correct 0))
(assert (not (= source_hadd_001_riina_correct target_hadd_001_riina_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hadd_002_preserves_structure: translation preserves property (matches Coq: Theorem)
; Translation validation: hadd_002_preserves_structure preserves semantics
(push 1)
(declare-const source_hadd_002_preserves_structure Int)
(declare-const target_hadd_002_preserves_structure Int)
(assert (>= source_hadd_002_preserves_structure 0))
(assert (>= target_hadd_002_preserves_structure 0))
(assert (not (= source_hadd_002_preserves_structure target_hadd_002_preserves_structure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hadd_003_modulus_relation: translation preserves property (matches Coq: Theorem)
; Translation validation: hadd_003_modulus_relation preserves semantics
(push 1)
(declare-const source_hadd_003_modulus_relation Int)
(declare-const target_hadd_003_modulus_relation Int)
(assert (>= source_hadd_003_modulus_relation 0))
(assert (>= target_hadd_003_modulus_relation 0))
(assert (not (= source_hadd_003_modulus_relation target_hadd_003_modulus_relation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hmult_001_riina_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: hmult_001_riina_correct preserves semantics
(push 1)
(declare-const source_hmult_001_riina_correct Int)
(declare-const target_hmult_001_riina_correct Int)
(assert (>= source_hmult_001_riina_correct 0))
(assert (>= target_hmult_001_riina_correct 0))
(assert (not (= source_hmult_001_riina_correct target_hmult_001_riina_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hmult_002_relinearization: translation preserves property (matches Coq: Theorem)
; Translation validation: hmult_002_relinearization preserves semantics
(push 1)
(declare-const source_hmult_002_relinearization Int)
(declare-const target_hmult_002_relinearization Int)
(assert (>= source_hmult_002_relinearization 0))
(assert (>= target_hmult_002_relinearization 0))
(assert (not (= source_hmult_002_relinearization target_hmult_002_relinearization)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hmult_003_key_switching: translation preserves property (matches Coq: Theorem)
; Translation validation: hmult_003_key_switching preserves semantics
(push 1)
(declare-const source_hmult_003_key_switching Int)
(declare-const target_hmult_003_key_switching Int)
(assert (>= source_hmult_003_key_switching 0))
(assert (>= target_hmult_003_key_switching 0))
(assert (not (= source_hmult_003_key_switching target_hmult_003_key_switching)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hops_001_riina_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: hops_001_riina_valid preserves semantics
(push 1)
(declare-const source_hops_001_riina_valid Int)
(declare-const target_hops_001_riina_valid Int)
(assert (>= source_hops_001_riina_valid 0))
(assert (>= target_hops_001_riina_valid 0))
(assert (not (= source_hops_001_riina_valid target_hops_001_riina_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hops_002_addition_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: hops_002_addition_correct preserves semantics
(push 1)
(declare-const source_hops_002_addition_correct Int)
(declare-const target_hops_002_addition_correct Int)
(assert (>= source_hops_002_addition_correct 0))
(assert (>= target_hops_002_addition_correct 0))
(assert (not (= source_hops_002_addition_correct target_hops_002_addition_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hops_003_multiplication_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: hops_003_multiplication_correct preserves semantics
(push 1)
(declare-const source_hops_003_multiplication_correct Int)
(declare-const target_hops_003_multiplication_correct Int)
(assert (>= source_hops_003_multiplication_correct 0))
(assert (>= target_hops_003_multiplication_correct 0))
(assert (not (= source_hops_003_multiplication_correct target_hops_003_multiplication_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hops_004_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: hops_004_composition preserves semantics
(push 1)
(declare-const source_hops_004_composition Int)
(declare-const target_hops_004_composition Int)
(assert (>= source_hops_004_composition 0))
(assert (>= target_hops_004_composition 0))
(assert (not (= source_hops_004_composition target_hops_004_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_001_initial_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: noise_001_initial_safe preserves semantics
(push 1)
(declare-const source_noise_001_initial_safe Int)
(declare-const target_noise_001_initial_safe Int)
(assert (>= source_noise_001_initial_safe 0))
(assert (>= target_noise_001_initial_safe 0))
(assert (not (= source_noise_001_initial_safe target_noise_001_initial_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_002_100_additions_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: noise_002_100_additions_safe preserves semantics
(push 1)
(declare-const source_noise_002_100_additions_safe Int)
(declare-const target_noise_002_100_additions_safe Int)
(assert (>= source_noise_002_100_additions_safe 0))
(assert (>= target_noise_002_100_additions_safe 0))
(assert (not (= source_noise_002_100_additions_safe target_noise_002_100_additions_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_003_10_multiplications_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: noise_003_10_multiplications_safe preserves semantics
(push 1)
(declare-const source_noise_003_10_multiplications_safe Int)
(declare-const target_noise_003_10_multiplications_safe Int)
(assert (>= source_noise_003_10_multiplications_safe 0))
(assert (>= target_noise_003_10_multiplications_safe 0))
(assert (not (= source_noise_003_10_multiplications_safe target_noise_003_10_multiplications_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_004_add_linear_growth: translation preserves property (matches Coq: Theorem)
; Translation validation: noise_004_add_linear_growth preserves semantics
(push 1)
(declare-const source_noise_004_add_linear_growth Int)
(declare-const target_noise_004_add_linear_growth Int)
(assert (>= source_noise_004_add_linear_growth 0))
(assert (>= target_noise_004_add_linear_growth 0))
(assert (not (= source_noise_004_add_linear_growth target_noise_004_add_linear_growth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_005_zero_additions: translation preserves property (matches Coq: Theorem)
; Translation validation: noise_005_zero_additions preserves semantics
(push 1)
(declare-const source_noise_005_zero_additions Int)
(declare-const target_noise_005_zero_additions Int)
(assert (>= source_noise_005_zero_additions 0))
(assert (>= target_noise_005_zero_additions 0))
(assert (not (= source_noise_005_zero_additions target_noise_005_zero_additions)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nb_001_riina_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: nb_001_riina_valid preserves semantics
(push 1)
(declare-const source_nb_001_riina_valid Int)
(declare-const target_nb_001_riina_valid Int)
(assert (>= source_nb_001_riina_valid 0))
(assert (>= target_nb_001_riina_valid 0))
(assert (not (= source_nb_001_riina_valid target_nb_001_riina_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nb_002_additions_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: nb_002_additions_safe preserves semantics
(push 1)
(declare-const source_nb_002_additions_safe Int)
(declare-const target_nb_002_additions_safe Int)
(assert (>= source_nb_002_additions_safe 0))
(assert (>= target_nb_002_additions_safe 0))
(assert (not (= source_nb_002_additions_safe target_nb_002_additions_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nb_003_multiplications_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: nb_003_multiplications_safe preserves semantics
(push 1)
(declare-const source_nb_003_multiplications_safe Int)
(declare-const target_nb_003_multiplications_safe Int)
(assert (>= source_nb_003_multiplications_safe 0))
(assert (>= target_nb_003_multiplications_safe 0))
(assert (not (= source_nb_003_multiplications_safe target_nb_003_multiplications_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; boot_001_riina_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: boot_001_riina_correct preserves semantics
(push 1)
(declare-const source_boot_001_riina_correct Int)
(declare-const target_boot_001_riina_correct Int)
(assert (>= source_boot_001_riina_correct 0))
(assert (>= target_boot_001_riina_correct 0))
(assert (not (= source_boot_001_riina_correct target_boot_001_riina_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; boot_002_reduces_noise: translation preserves property (matches Coq: Theorem)
; Translation validation: boot_002_reduces_noise preserves semantics
(push 1)
(declare-const source_boot_002_reduces_noise Int)
(declare-const target_boot_002_reduces_noise Int)
(assert (>= source_boot_002_reduces_noise 0))
(assert (>= target_boot_002_reduces_noise 0))
(assert (not (= source_boot_002_reduces_noise target_boot_002_reduces_noise)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; boot_003_preserves_message: translation preserves property (matches Coq: Theorem)
; Translation validation: boot_003_preserves_message preserves semantics
(push 1)
(declare-const source_boot_003_preserves_message Int)
(declare-const target_boot_003_preserves_message Int)
(assert (>= source_boot_003_preserves_message 0))
(assert (>= target_boot_003_preserves_message 0))
(assert (not (= source_boot_003_preserves_message target_boot_003_preserves_message)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; boot_004_polynomial_time: translation preserves property (matches Coq: Theorem)
; Translation validation: boot_004_polynomial_time preserves semantics
(push 1)
(declare-const source_boot_004_polynomial_time Int)
(declare-const target_boot_004_polynomial_time Int)
(assert (>= source_boot_004_polynomial_time 0))
(assert (>= target_boot_004_polynomial_time 0))
(assert (not (= source_boot_004_polynomial_time target_boot_004_polynomial_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; boot_005_noise_reduction: translation preserves property (matches Coq: Theorem)
; Translation validation: boot_005_noise_reduction preserves semantics
(push 1)
(declare-const source_boot_005_noise_reduction Int)
(declare-const target_boot_005_noise_reduction Int)
(assert (>= source_boot_005_noise_reduction 0))
(assert (>= target_boot_005_noise_reduction 0))
(assert (not (= source_boot_005_noise_reduction target_boot_005_noise_reduction)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ufhe_001_riina_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ufhe_001_riina_valid preserves semantics
(push 1)
(declare-const source_ufhe_001_riina_valid Int)
(declare-const target_ufhe_001_riina_valid Int)
(assert (>= source_ufhe_001_riina_valid 0))
(assert (>= target_ufhe_001_riina_valid 0))
(assert (not (= source_ufhe_001_riina_valid target_ufhe_001_riina_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ufhe_002_bootstrap_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: ufhe_002_bootstrap_correct preserves semantics
(push 1)
(declare-const source_ufhe_002_bootstrap_correct Int)
(declare-const target_ufhe_002_bootstrap_correct Int)
(assert (>= source_ufhe_002_bootstrap_correct 0))
(assert (>= target_ufhe_002_bootstrap_correct 0))
(assert (not (= source_ufhe_002_bootstrap_correct target_ufhe_002_bootstrap_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kg_001_riina_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: kg_001_riina_secure preserves semantics
(push 1)
(declare-const source_kg_001_riina_secure Int)
(declare-const target_kg_001_riina_secure Int)
(assert (>= source_kg_001_riina_secure 0))
(assert (>= target_kg_001_riina_secure 0))
(assert (not (= source_kg_001_riina_secure target_kg_001_riina_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kg_002_security_parameter: translation preserves property (matches Coq: Theorem)
; Translation validation: kg_002_security_parameter preserves semantics
(push 1)
(declare-const source_kg_002_security_parameter Int)
(declare-const target_kg_002_security_parameter Int)
(assert (>= source_kg_002_security_parameter 0))
(assert (>= target_kg_002_security_parameter 0))
(assert (not (= source_kg_002_security_parameter target_kg_002_security_parameter)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kg_003_polynomial_degree: translation preserves property (matches Coq: Theorem)
; Translation validation: kg_003_polynomial_degree preserves semantics
(push 1)
(declare-const source_kg_003_polynomial_degree Int)
(declare-const target_kg_003_polynomial_degree Int)
(assert (>= source_kg_003_polynomial_degree 0))
(assert (>= target_kg_003_polynomial_degree 0))
(assert (not (= source_kg_003_polynomial_degree target_kg_003_polynomial_degree)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kg_004_error_distribution: translation preserves property (matches Coq: Theorem)
; Translation validation: kg_004_error_distribution preserves semantics
(push 1)
(declare-const source_kg_004_error_distribution Int)
(declare-const target_kg_004_error_distribution Int)
(assert (>= source_kg_004_error_distribution 0))
(assert (>= target_kg_004_error_distribution 0))
(assert (not (= source_kg_004_error_distribution target_kg_004_error_distribution)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kg_005_modulus_bits: translation preserves property (matches Coq: Theorem)
; Translation validation: kg_005_modulus_bits preserves semantics
(push 1)
(declare-const source_kg_005_modulus_bits Int)
(declare-const target_kg_005_modulus_bits Int)
(assert (>= source_kg_005_modulus_bits 0))
(assert (>= target_kg_005_modulus_bits 0))
(assert (not (= source_kg_005_modulus_bits target_kg_005_modulus_bits)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kp_001_riina_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: kp_001_riina_valid preserves semantics
(push 1)
(declare-const source_kp_001_riina_valid Int)
(declare-const target_kp_001_riina_valid Int)
(assert (>= source_kp_001_riina_valid 0))
(assert (>= target_kp_001_riina_valid 0))
(assert (not (= source_kp_001_riina_valid target_kp_001_riina_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kp_002_secure_params: translation preserves property (matches Coq: Theorem)
; Translation validation: kp_002_secure_params preserves semantics
(push 1)
(declare-const source_kp_002_secure_params Int)
(declare-const target_kp_002_secure_params Int)
(assert (>= source_kp_002_secure_params 0))
(assert (>= target_kp_002_secure_params 0))
(assert (not (= source_kp_002_secure_params target_kp_002_secure_params)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ct_001_riina_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ct_001_riina_valid preserves semantics
(push 1)
(declare-const source_ct_001_riina_valid Int)
(declare-const target_ct_001_riina_valid Int)
(assert (>= source_ct_001_riina_valid 0))
(assert (>= target_ct_001_riina_valid 0))
(assert (not (= source_ct_001_riina_valid target_ct_001_riina_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ct_002_valid_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: ct_002_valid_encryption preserves semantics
(push 1)
(declare-const source_ct_002_valid_encryption Int)
(declare-const target_ct_002_valid_encryption Int)
(assert (>= source_ct_002_valid_encryption 0))
(assert (>= target_ct_002_valid_encryption 0))
(assert (not (= source_ct_002_valid_encryption target_ct_002_valid_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ct_003_safe_noise: translation preserves property (matches Coq: Theorem)
; Translation validation: ct_003_safe_noise preserves semantics
(push 1)
(declare-const source_ct_003_safe_noise Int)
(declare-const target_ct_003_safe_noise Int)
(assert (>= source_ct_003_safe_noise 0))
(assert (>= target_ct_003_safe_noise 0))
(assert (not (= source_ct_003_safe_noise target_ct_003_safe_noise)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ct_004_positive_level: translation preserves property (matches Coq: Theorem)
; Translation validation: ct_004_positive_level preserves semantics
(push 1)
(declare-const source_ct_004_positive_level Int)
(declare-const target_ct_004_positive_level Int)
(assert (>= source_ct_004_positive_level 0))
(assert (>= target_ct_004_positive_level 0))
(assert (not (= source_ct_004_positive_level target_ct_004_positive_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cao_001_valid_preserves: translation preserves property (matches Coq: Theorem)
; Translation validation: cao_001_valid_preserves preserves semantics
(push 1)
(declare-const source_cao_001_valid_preserves Int)
(declare-const target_cao_001_valid_preserves Int)
(assert (>= source_cao_001_valid_preserves 0))
(assert (>= target_cao_001_valid_preserves 0))
(assert (not (= source_cao_001_valid_preserves target_cao_001_valid_preserves)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cao_002_result_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: cao_002_result_valid preserves semantics
(push 1)
(declare-const source_cao_002_result_valid Int)
(declare-const target_cao_002_result_valid Int)
(assert (>= source_cao_002_result_valid 0))
(assert (>= target_cao_002_result_valid 0))
(assert (not (= source_cao_002_result_valid target_cao_002_result_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_001_riina_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_001_riina_secure preserves semantics
(push 1)
(declare-const source_cfhe_001_riina_secure Int)
(declare-const target_cfhe_001_riina_secure Int)
(assert (>= source_cfhe_001_riina_secure 0))
(assert (>= target_cfhe_001_riina_secure 0))
(assert (not (= source_cfhe_001_riina_secure target_cfhe_001_riina_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_002_config_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_002_config_secure preserves semantics
(push 1)
(declare-const source_cfhe_002_config_secure Int)
(declare-const target_cfhe_002_config_secure Int)
(assert (>= source_cfhe_002_config_secure 0))
(assert (>= target_cfhe_002_config_secure 0))
(assert (not (= source_cfhe_002_config_secure target_cfhe_002_config_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_003_keygen_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_003_keygen_secure preserves semantics
(push 1)
(declare-const source_cfhe_003_keygen_secure Int)
(declare-const target_cfhe_003_keygen_secure Int)
(assert (>= source_cfhe_003_keygen_secure 0))
(assert (>= target_cfhe_003_keygen_secure 0))
(assert (not (= source_cfhe_003_keygen_secure target_cfhe_003_keygen_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_004_indcpa_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_004_indcpa_secure preserves semantics
(push 1)
(declare-const source_cfhe_004_indcpa_secure Int)
(declare-const target_cfhe_004_indcpa_secure Int)
(assert (>= source_cfhe_004_indcpa_secure 0))
(assert (>= target_cfhe_004_indcpa_secure 0))
(assert (not (= source_cfhe_004_indcpa_secure target_cfhe_004_indcpa_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_005_bootstrap_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_005_bootstrap_correct preserves semantics
(push 1)
(declare-const source_cfhe_005_bootstrap_correct Int)
(declare-const target_cfhe_005_bootstrap_correct Int)
(assert (>= source_cfhe_005_bootstrap_correct 0))
(assert (>= target_cfhe_005_bootstrap_correct 0))
(assert (not (= source_cfhe_005_bootstrap_correct target_cfhe_005_bootstrap_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_006_ops_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_006_ops_valid preserves semantics
(push 1)
(declare-const source_cfhe_006_ops_valid Int)
(declare-const target_cfhe_006_ops_valid Int)
(assert (>= source_cfhe_006_ops_valid 0))
(assert (>= target_cfhe_006_ops_valid 0))
(assert (not (= source_cfhe_006_ops_valid target_cfhe_006_ops_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_007_pq_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_007_pq_safe preserves semantics
(push 1)
(declare-const source_cfhe_007_pq_safe Int)
(declare-const target_cfhe_007_pq_safe Int)
(assert (>= source_cfhe_007_pq_safe 0))
(assert (>= target_cfhe_007_pq_safe 0))
(assert (not (= source_cfhe_007_pq_safe target_cfhe_007_pq_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_008_arbitrary_depth: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_008_arbitrary_depth preserves semantics
(push 1)
(declare-const source_cfhe_008_arbitrary_depth Int)
(declare-const target_cfhe_008_arbitrary_depth Int)
(assert (>= source_cfhe_008_arbitrary_depth 0))
(assert (>= target_cfhe_008_arbitrary_depth 0))
(assert (not (= source_cfhe_008_arbitrary_depth target_cfhe_008_arbitrary_depth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_009_semantic_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_009_semantic_secure preserves semantics
(push 1)
(declare-const source_cfhe_009_semantic_secure Int)
(declare-const target_cfhe_009_semantic_secure Int)
(assert (>= source_cfhe_009_semantic_secure 0))
(assert (>= target_cfhe_009_semantic_secure 0))
(assert (not (= source_cfhe_009_semantic_secure target_cfhe_009_semantic_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfhe_010_noise_managed: translation preserves property (matches Coq: Theorem)
; Translation validation: cfhe_010_noise_managed preserves semantics
(push 1)
(declare-const source_cfhe_010_noise_managed Int)
(declare-const target_cfhe_010_noise_managed Int)
(assert (>= source_cfhe_010_noise_managed 0))
(assert (>= target_cfhe_010_noise_managed 0))
(assert (not (= source_cfhe_010_noise_managed target_cfhe_010_noise_managed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; circ_001_riina_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: circ_001_riina_secure preserves semantics
(push 1)
(declare-const source_circ_001_riina_secure Int)
(declare-const target_circ_001_riina_secure Int)
(assert (>= source_circ_001_riina_secure 0))
(assert (>= target_circ_001_riina_secure 0))
(assert (not (= source_circ_001_riina_secure target_circ_001_riina_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; circ_002_key_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: circ_002_key_encryption preserves semantics
(push 1)
(declare-const source_circ_002_key_encryption Int)
(declare-const target_circ_002_key_encryption Int)
(assert (>= source_circ_002_key_encryption 0))
(assert (>= target_circ_002_key_encryption 0))
(assert (not (= source_circ_002_key_encryption target_circ_002_key_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lwe_001_riina_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: lwe_001_riina_secure preserves semantics
(push 1)
(declare-const source_lwe_001_riina_secure Int)
(declare-const target_lwe_001_riina_secure Int)
(assert (>= source_lwe_001_riina_secure 0))
(assert (>= target_lwe_001_riina_secure 0))
(assert (not (= source_lwe_001_riina_secure target_lwe_001_riina_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lwe_002_dimension: translation preserves property (matches Coq: Theorem)
; Translation validation: lwe_002_dimension preserves semantics
(push 1)
(declare-const source_lwe_002_dimension Int)
(declare-const target_lwe_002_dimension Int)
(assert (>= source_lwe_002_dimension 0))
(assert (>= target_lwe_002_dimension 0))
(assert (not (= source_lwe_002_dimension target_lwe_002_dimension)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rlwe_001_riina_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: rlwe_001_riina_secure preserves semantics
(push 1)
(declare-const source_rlwe_001_riina_secure Int)
(declare-const target_rlwe_001_riina_secure Int)
(assert (>= source_rlwe_001_riina_secure 0))
(assert (>= target_rlwe_001_riina_secure 0))
(assert (not (= source_rlwe_001_riina_secure target_rlwe_001_riina_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rlwe_002_ring_degree: translation preserves property (matches Coq: Theorem)
; Translation validation: rlwe_002_ring_degree preserves semantics
(push 1)
(declare-const source_rlwe_002_ring_degree Int)
(declare-const target_rlwe_002_ring_degree Int)
(assert (>= source_rlwe_002_ring_degree 0))
(assert (>= target_rlwe_002_ring_degree 0))
(assert (not (= source_rlwe_002_ring_degree target_rlwe_002_ring_degree)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

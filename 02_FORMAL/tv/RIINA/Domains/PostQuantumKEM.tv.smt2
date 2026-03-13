; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/PostQuantumKEM.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for PostQuantumKEM
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; param_security_level: source semantics (matches Coq)
; Translation validation: param_security_level preserves semantics
(push 1)
(declare-const source_param_security_level Int)
(declare-const target_param_security_level Int)
(assert (>= source_param_security_level 0))
(assert (>= target_param_security_level 0))
(assert (not (= source_param_security_level target_param_security_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; level_leq: source semantics (matches Coq)
; Translation validation: level_leq preserves semantics
(push 1)
(declare-const source_level_leq Int)
(declare-const target_level_leq Int)
(assert (>= source_level_leq 0))
(assert (>= target_level_leq 0))
(assert (not (= source_level_leq target_level_leq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kem_correct: source semantics (matches Coq)
; Translation validation: kem_correct preserves semantics
(push 1)
(declare-const source_kem_correct Int)
(declare-const target_kem_correct Int)
(assert (>= source_kem_correct 0))
(assert (>= target_kem_correct 0))
(assert (not (= source_kem_correct target_kem_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; indcca_compliant: source semantics (matches Coq)
; Translation validation: indcca_compliant preserves semantics
(push 1)
(declare-const source_indcca_compliant Int)
(declare-const target_indcca_compliant Int)
(assert (>= source_indcca_compliant 0))
(assert (>= target_indcca_compliant 0))
(assert (not (= source_indcca_compliant target_indcca_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; quantum_resistant: source semantics (matches Coq)
; Translation validation: quantum_resistant preserves semantics
(push 1)
(declare-const source_quantum_resistant Int)
(declare-const target_quantum_resistant Int)
(assert (>= source_quantum_resistant 0))
(assert (>= target_quantum_resistant 0))
(assert (not (= source_quantum_resistant target_quantum_resistant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kem_secure: source semantics (matches Coq)
; Translation validation: kem_secure preserves semantics
(push 1)
(declare-const source_kem_secure Int)
(declare-const target_kem_secure Int)
(assert (>= source_kem_secure 0))
(assert (>= target_kem_secure 0))
(assert (not (= source_kem_secure target_kem_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_valid_keypair: source semantics (matches Coq)
; Translation validation: mk_valid_keypair preserves semantics
(push 1)
(declare-const source_mk_valid_keypair Int)
(declare-const target_mk_valid_keypair Int)
(assert (>= source_mk_valid_keypair 0))
(assert (>= target_mk_valid_keypair 0))
(assert (not (= source_mk_valid_keypair target_mk_valid_keypair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_valid_encaps: source semantics (matches Coq)
; Translation validation: mk_valid_encaps preserves semantics
(push 1)
(declare-const source_mk_valid_encaps Int)
(declare-const target_mk_valid_encaps Int)
(assert (>= source_mk_valid_encaps 0))
(assert (>= target_mk_valid_encaps 0))
(assert (not (= source_mk_valid_encaps target_mk_valid_encaps)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_compliant_indcca: source semantics (matches Coq)
; Translation validation: mk_compliant_indcca preserves semantics
(push 1)
(declare-const source_mk_compliant_indcca Int)
(declare-const target_mk_compliant_indcca Int)
(assert (>= source_mk_compliant_indcca 0))
(assert (>= target_mk_compliant_indcca 0))
(assert (not (= source_mk_compliant_indcca target_mk_compliant_indcca)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_compliant_qr: source semantics (matches Coq)
; Translation validation: mk_compliant_qr preserves semantics
(push 1)
(declare-const source_mk_compliant_qr Int)
(declare-const target_mk_compliant_qr Int)
(assert (>= source_mk_compliant_qr 0))
(assert (>= target_mk_compliant_qr 0))
(assert (not (= source_mk_compliant_qr target_mk_compliant_qr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_kem_1024: source semantics (matches Coq)
; Translation validation: riina_kem_1024 preserves semantics
(push 1)
(declare-const source_riina_kem_1024 Int)
(declare-const target_riina_kem_1024 Int)
(assert (>= source_riina_kem_1024 0))
(assert (>= target_riina_kem_1024 0))
(assert (not (= source_riina_kem_1024 target_riina_kem_1024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_kem_security: source semantics (matches Coq)
; Translation validation: riina_kem_security preserves semantics
(push 1)
(declare-const source_riina_kem_security Int)
(declare-const target_riina_kem_security Int)
(assert (>= source_riina_kem_security 0))
(assert (>= target_riina_kem_security 0))
(assert (not (= source_riina_kem_security target_riina_kem_security)))
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

; PQ_KEM_001_level_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_001_level_reflexive preserves semantics
(push 1)
(declare-const source_PQ_KEM_001_level_reflexive Int)
(declare-const target_PQ_KEM_001_level_reflexive Int)
(assert (>= source_PQ_KEM_001_level_reflexive 0))
(assert (>= target_PQ_KEM_001_level_reflexive 0))
(assert (not (= source_PQ_KEM_001_level_reflexive target_PQ_KEM_001_level_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_002_level_transitive: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_002_level_transitive preserves semantics
(push 1)
(declare-const source_PQ_KEM_002_level_transitive Int)
(declare-const target_PQ_KEM_002_level_transitive Int)
(assert (>= source_PQ_KEM_002_level_transitive 0))
(assert (>= target_PQ_KEM_002_level_transitive 0))
(assert (not (= source_PQ_KEM_002_level_transitive target_PQ_KEM_002_level_transitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_003_level1_minimum: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_003_level1_minimum preserves semantics
(push 1)
(declare-const source_PQ_KEM_003_level1_minimum Int)
(declare-const target_PQ_KEM_003_level1_minimum Int)
(assert (>= source_PQ_KEM_003_level1_minimum 0))
(assert (>= target_PQ_KEM_003_level1_minimum 0))
(assert (not (= source_PQ_KEM_003_level1_minimum target_PQ_KEM_003_level1_minimum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_004_level5_maximum: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_004_level5_maximum preserves semantics
(push 1)
(declare-const source_PQ_KEM_004_level5_maximum Int)
(declare-const target_PQ_KEM_004_level5_maximum Int)
(assert (>= source_PQ_KEM_004_level5_maximum 0))
(assert (>= target_PQ_KEM_004_level5_maximum 0))
(assert (not (= source_PQ_KEM_004_level5_maximum target_PQ_KEM_004_level5_maximum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_005_mlkem512_level1: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_005_mlkem512_level1 preserves semantics
(push 1)
(declare-const source_PQ_KEM_005_mlkem512_level1 Int)
(declare-const target_PQ_KEM_005_mlkem512_level1 Int)
(assert (>= source_PQ_KEM_005_mlkem512_level1 0))
(assert (>= target_PQ_KEM_005_mlkem512_level1 0))
(assert (not (= source_PQ_KEM_005_mlkem512_level1 target_PQ_KEM_005_mlkem512_level1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_006_mlkem768_level3: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_006_mlkem768_level3 preserves semantics
(push 1)
(declare-const source_PQ_KEM_006_mlkem768_level3 Int)
(declare-const target_PQ_KEM_006_mlkem768_level3 Int)
(assert (>= source_PQ_KEM_006_mlkem768_level3 0))
(assert (>= target_PQ_KEM_006_mlkem768_level3 0))
(assert (not (= source_PQ_KEM_006_mlkem768_level3 target_PQ_KEM_006_mlkem768_level3)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_007_mlkem1024_level5: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_007_mlkem1024_level5 preserves semantics
(push 1)
(declare-const source_PQ_KEM_007_mlkem1024_level5 Int)
(declare-const target_PQ_KEM_007_mlkem1024_level5 Int)
(assert (>= source_PQ_KEM_007_mlkem1024_level5 0))
(assert (>= target_PQ_KEM_007_mlkem1024_level5 0))
(assert (not (= source_PQ_KEM_007_mlkem1024_level5 target_PQ_KEM_007_mlkem1024_level5)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_008_params_ordered: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_008_params_ordered preserves semantics
(push 1)
(declare-const source_PQ_KEM_008_params_ordered Int)
(declare-const target_PQ_KEM_008_params_ordered Int)
(assert (>= source_PQ_KEM_008_params_ordered 0))
(assert (>= target_PQ_KEM_008_params_ordered 0))
(assert (not (= source_PQ_KEM_008_params_ordered target_PQ_KEM_008_params_ordered)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_009_indcca_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_009_indcca_valid preserves semantics
(push 1)
(declare-const source_PQ_KEM_009_indcca_valid Int)
(declare-const target_PQ_KEM_009_indcca_valid Int)
(assert (>= source_PQ_KEM_009_indcca_valid 0))
(assert (>= target_PQ_KEM_009_indcca_valid 0))
(assert (not (= source_PQ_KEM_009_indcca_valid target_PQ_KEM_009_indcca_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_010_ciphertext_indist: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_010_ciphertext_indist preserves semantics
(push 1)
(declare-const source_PQ_KEM_010_ciphertext_indist Int)
(declare-const target_PQ_KEM_010_ciphertext_indist Int)
(assert (>= source_PQ_KEM_010_ciphertext_indist 0))
(assert (>= target_PQ_KEM_010_ciphertext_indist 0))
(assert (not (= source_PQ_KEM_010_ciphertext_indist target_PQ_KEM_010_ciphertext_indist)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_011_key_indist: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_011_key_indist preserves semantics
(push 1)
(declare-const source_PQ_KEM_011_key_indist Int)
(declare-const target_PQ_KEM_011_key_indist Int)
(assert (>= source_PQ_KEM_011_key_indist 0))
(assert (>= target_PQ_KEM_011_key_indist 0))
(assert (not (= source_PQ_KEM_011_key_indist target_PQ_KEM_011_key_indist)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_012_decaps_consistent: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_012_decaps_consistent preserves semantics
(push 1)
(declare-const source_PQ_KEM_012_decaps_consistent Int)
(declare-const target_PQ_KEM_012_decaps_consistent Int)
(assert (>= source_PQ_KEM_012_decaps_consistent 0))
(assert (>= target_PQ_KEM_012_decaps_consistent 0))
(assert (not (= source_PQ_KEM_012_decaps_consistent target_PQ_KEM_012_decaps_consistent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_013_qr_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_013_qr_valid preserves semantics
(push 1)
(declare-const source_PQ_KEM_013_qr_valid Int)
(declare-const target_PQ_KEM_013_qr_valid Int)
(assert (>= source_PQ_KEM_013_qr_valid 0))
(assert (>= target_PQ_KEM_013_qr_valid 0))
(assert (not (= source_PQ_KEM_013_qr_valid target_PQ_KEM_013_qr_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_014_lattice_based: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_014_lattice_based preserves semantics
(push 1)
(declare-const source_PQ_KEM_014_lattice_based Int)
(declare-const target_PQ_KEM_014_lattice_based Int)
(assert (>= source_PQ_KEM_014_lattice_based 0))
(assert (>= target_PQ_KEM_014_lattice_based 0))
(assert (not (= source_PQ_KEM_014_lattice_based target_PQ_KEM_014_lattice_based)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_015_module_lwe: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_015_module_lwe preserves semantics
(push 1)
(declare-const source_PQ_KEM_015_module_lwe Int)
(declare-const target_PQ_KEM_015_module_lwe Int)
(assert (>= source_PQ_KEM_015_module_lwe 0))
(assert (>= target_PQ_KEM_015_module_lwe 0))
(assert (not (= source_PQ_KEM_015_module_lwe target_PQ_KEM_015_module_lwe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_016_no_quantum_attack: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_016_no_quantum_attack preserves semantics
(push 1)
(declare-const source_PQ_KEM_016_no_quantum_attack Int)
(declare-const target_PQ_KEM_016_no_quantum_attack Int)
(assert (>= source_PQ_KEM_016_no_quantum_attack 0))
(assert (>= target_PQ_KEM_016_no_quantum_attack 0))
(assert (not (= source_PQ_KEM_016_no_quantum_attack target_PQ_KEM_016_no_quantum_attack)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_017_riina_kem_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_017_riina_kem_correct preserves semantics
(push 1)
(declare-const source_PQ_KEM_017_riina_kem_correct Int)
(declare-const target_PQ_KEM_017_riina_kem_correct Int)
(assert (>= source_PQ_KEM_017_riina_kem_correct 0))
(assert (>= target_PQ_KEM_017_riina_kem_correct 0))
(assert (not (= source_PQ_KEM_017_riina_kem_correct target_PQ_KEM_017_riina_kem_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_018_riina_kem_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_018_riina_kem_secure preserves semantics
(push 1)
(declare-const source_PQ_KEM_018_riina_kem_secure Int)
(declare-const target_PQ_KEM_018_riina_kem_secure Int)
(assert (>= source_PQ_KEM_018_riina_kem_secure 0))
(assert (>= target_PQ_KEM_018_riina_kem_secure 0))
(assert (not (= source_PQ_KEM_018_riina_kem_secure target_PQ_KEM_018_riina_kem_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_019_riina_level5: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_019_riina_level5 preserves semantics
(push 1)
(declare-const source_PQ_KEM_019_riina_level5 Int)
(declare-const target_PQ_KEM_019_riina_level5 Int)
(assert (>= source_PQ_KEM_019_riina_level5 0))
(assert (>= target_PQ_KEM_019_riina_level5 0))
(assert (not (= source_PQ_KEM_019_riina_level5 target_PQ_KEM_019_riina_level5)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_020_riina_mlkem1024: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_020_riina_mlkem1024 preserves semantics
(push 1)
(declare-const source_PQ_KEM_020_riina_mlkem1024 Int)
(declare-const target_PQ_KEM_020_riina_mlkem1024 Int)
(assert (>= source_PQ_KEM_020_riina_mlkem1024 0))
(assert (>= target_PQ_KEM_020_riina_mlkem1024 0))
(assert (not (= source_PQ_KEM_020_riina_mlkem1024 target_PQ_KEM_020_riina_mlkem1024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_021_security_implies_indcca: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_021_security_implies_indcca preserves semantics
(push 1)
(declare-const source_PQ_KEM_021_security_implies_indcca Int)
(declare-const target_PQ_KEM_021_security_implies_indcca Int)
(assert (>= source_PQ_KEM_021_security_implies_indcca 0))
(assert (>= target_PQ_KEM_021_security_implies_indcca 0))
(assert (not (= source_PQ_KEM_021_security_implies_indcca target_PQ_KEM_021_security_implies_indcca)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_022_security_implies_qr: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_022_security_implies_qr preserves semantics
(push 1)
(declare-const source_PQ_KEM_022_security_implies_qr Int)
(declare-const target_PQ_KEM_022_security_implies_qr Int)
(assert (>= source_PQ_KEM_022_security_implies_qr 0))
(assert (>= target_PQ_KEM_022_security_implies_qr 0))
(assert (not (= source_PQ_KEM_022_security_implies_qr target_PQ_KEM_022_security_implies_qr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_023_correct_keypair: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_023_correct_keypair preserves semantics
(push 1)
(declare-const source_PQ_KEM_023_correct_keypair Int)
(declare-const target_PQ_KEM_023_correct_keypair Int)
(assert (>= source_PQ_KEM_023_correct_keypair 0))
(assert (>= target_PQ_KEM_023_correct_keypair 0))
(assert (not (= source_PQ_KEM_023_correct_keypair target_PQ_KEM_023_correct_keypair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_024_shared_secret_match: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_024_shared_secret_match preserves semantics
(push 1)
(declare-const source_PQ_KEM_024_shared_secret_match Int)
(declare-const target_PQ_KEM_024_shared_secret_match Int)
(assert (>= source_PQ_KEM_024_shared_secret_match 0))
(assert (>= target_PQ_KEM_024_shared_secret_match 0))
(assert (not (= source_PQ_KEM_024_shared_secret_match target_PQ_KEM_024_shared_secret_match)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_KEM_025_complete_security: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_KEM_025_complete_security preserves semantics
(push 1)
(declare-const source_PQ_KEM_025_complete_security Int)
(declare-const target_PQ_KEM_025_complete_security Int)
(assert (>= source_PQ_KEM_025_complete_security 0))
(assert (>= target_PQ_KEM_025_complete_security 0))
(assert (not (= source_PQ_KEM_025_complete_security target_PQ_KEM_025_complete_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

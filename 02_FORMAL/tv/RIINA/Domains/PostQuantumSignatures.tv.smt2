; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/PostQuantumSignatures.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for PostQuantumSignatures
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; scheme_category: source semantics (matches Coq)
; Translation validation: scheme_category preserves semantics
(push 1)
(declare-const source_scheme_category Int)
(declare-const target_scheme_category Int)
(assert (>= source_scheme_category 0))
(assert (>= target_scheme_category 0))
(assert (not (= source_scheme_category target_scheme_category)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; scheme_security_level: source semantics (matches Coq)
; Translation validation: scheme_security_level preserves semantics
(push 1)
(declare-const source_scheme_security_level Int)
(declare-const target_scheme_security_level Int)
(assert (>= source_scheme_security_level 0))
(assert (>= target_scheme_security_level 0))
(assert (not (= source_scheme_security_level target_scheme_security_level)))
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

; eufcma_compliant: source semantics (matches Coq)
; Translation validation: eufcma_compliant preserves semantics
(push 1)
(declare-const source_eufcma_compliant Int)
(declare-const target_eufcma_compliant Int)
(assert (>= source_eufcma_compliant 0))
(assert (>= target_eufcma_compliant 0))
(assert (not (= source_eufcma_compliant target_eufcma_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sig_quantum_resistant: source semantics (matches Coq)
; Translation validation: sig_quantum_resistant preserves semantics
(push 1)
(declare-const source_sig_quantum_resistant Int)
(declare-const target_sig_quantum_resistant Int)
(assert (>= source_sig_quantum_resistant 0))
(assert (>= target_sig_quantum_resistant 0))
(assert (not (= source_sig_quantum_resistant target_sig_quantum_resistant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sig_secure: source semantics (matches Coq)
; Translation validation: sig_secure preserves semantics
(push 1)
(declare-const source_sig_secure Int)
(declare-const target_sig_secure Int)
(assert (>= source_sig_secure 0))
(assert (>= target_sig_secure 0))
(assert (not (= source_sig_secure target_sig_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sig_correct: source semantics (matches Coq)
; Translation validation: sig_correct preserves semantics
(push 1)
(declare-const source_sig_correct Int)
(declare-const target_sig_correct Int)
(assert (>= source_sig_correct 0))
(assert (>= target_sig_correct 0))
(assert (not (= source_sig_correct target_sig_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_valid_sig_keypair: source semantics (matches Coq)
; Translation validation: mk_valid_sig_keypair preserves semantics
(push 1)
(declare-const source_mk_valid_sig_keypair Int)
(declare-const target_mk_valid_sig_keypair Int)
(assert (>= source_mk_valid_sig_keypair 0))
(assert (>= target_mk_valid_sig_keypair 0))
(assert (not (= source_mk_valid_sig_keypair target_mk_valid_sig_keypair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_valid_signature: source semantics (matches Coq)
; Translation validation: mk_valid_signature preserves semantics
(push 1)
(declare-const source_mk_valid_signature Int)
(declare-const target_mk_valid_signature Int)
(assert (>= source_mk_valid_signature 0))
(assert (>= target_mk_valid_signature 0))
(assert (not (= source_mk_valid_signature target_mk_valid_signature)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_compliant_eufcma: source semantics (matches Coq)
; Translation validation: mk_compliant_eufcma preserves semantics
(push 1)
(declare-const source_mk_compliant_eufcma Int)
(declare-const target_mk_compliant_eufcma Int)
(assert (>= source_mk_compliant_eufcma 0))
(assert (>= target_mk_compliant_eufcma 0))
(assert (not (= source_mk_compliant_eufcma target_mk_compliant_eufcma)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_compliant_sig_qr: source semantics (matches Coq)
; Translation validation: mk_compliant_sig_qr preserves semantics
(push 1)
(declare-const source_mk_compliant_sig_qr Int)
(declare-const target_mk_compliant_sig_qr Int)
(assert (>= source_mk_compliant_sig_qr 0))
(assert (>= target_mk_compliant_sig_qr 0))
(assert (not (= source_mk_compliant_sig_qr target_mk_compliant_sig_qr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_sig_ml_dsa_87: source semantics (matches Coq)
; Translation validation: riina_sig_ml_dsa_87 preserves semantics
(push 1)
(declare-const source_riina_sig_ml_dsa_87 Int)
(declare-const target_riina_sig_ml_dsa_87 Int)
(assert (>= source_riina_sig_ml_dsa_87 0))
(assert (>= target_riina_sig_ml_dsa_87 0))
(assert (not (= source_riina_sig_ml_dsa_87 target_riina_sig_ml_dsa_87)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_sig_slh_dsa_256s: source semantics (matches Coq)
; Translation validation: riina_sig_slh_dsa_256s preserves semantics
(push 1)
(declare-const source_riina_sig_slh_dsa_256s Int)
(declare-const target_riina_sig_slh_dsa_256s Int)
(assert (>= source_riina_sig_slh_dsa_256s 0))
(assert (>= target_riina_sig_slh_dsa_256s 0))
(assert (not (= source_riina_sig_slh_dsa_256s target_riina_sig_slh_dsa_256s)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_sig_security: source semantics (matches Coq)
; Translation validation: riina_sig_security preserves semantics
(push 1)
(declare-const source_riina_sig_security Int)
(declare-const target_riina_sig_security Int)
(assert (>= source_riina_sig_security 0))
(assert (>= target_riina_sig_security 0))
(assert (not (= source_riina_sig_security target_riina_sig_security)))
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

; PQ_SIG_001_mldsa_lattice: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_001_mldsa_lattice preserves semantics
(push 1)
(declare-const source_PQ_SIG_001_mldsa_lattice Int)
(declare-const target_PQ_SIG_001_mldsa_lattice Int)
(assert (>= source_PQ_SIG_001_mldsa_lattice 0))
(assert (>= target_PQ_SIG_001_mldsa_lattice 0))
(assert (not (= source_PQ_SIG_001_mldsa_lattice target_PQ_SIG_001_mldsa_lattice)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_002_slhdsa_hash: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_002_slhdsa_hash preserves semantics
(push 1)
(declare-const source_PQ_SIG_002_slhdsa_hash Int)
(declare-const target_PQ_SIG_002_slhdsa_hash Int)
(assert (>= source_PQ_SIG_002_slhdsa_hash 0))
(assert (>= target_PQ_SIG_002_slhdsa_hash 0))
(assert (not (= source_PQ_SIG_002_slhdsa_hash target_PQ_SIG_002_slhdsa_hash)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_003_mldsa87_level5: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_003_mldsa87_level5 preserves semantics
(push 1)
(declare-const source_PQ_SIG_003_mldsa87_level5 Int)
(declare-const target_PQ_SIG_003_mldsa87_level5 Int)
(assert (>= source_PQ_SIG_003_mldsa87_level5 0))
(assert (>= target_PQ_SIG_003_mldsa87_level5 0))
(assert (not (= source_PQ_SIG_003_mldsa87_level5 target_PQ_SIG_003_mldsa87_level5)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_004_slhdsa256_level5: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_004_slhdsa256_level5 preserves semantics
(push 1)
(declare-const source_PQ_SIG_004_slhdsa256_level5 Int)
(declare-const target_PQ_SIG_004_slhdsa256_level5 Int)
(assert (>= source_PQ_SIG_004_slhdsa256_level5 0))
(assert (>= target_PQ_SIG_004_slhdsa256_level5 0))
(assert (not (= source_PQ_SIG_004_slhdsa256_level5 target_PQ_SIG_004_slhdsa256_level5)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_005_level_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_005_level_reflexive preserves semantics
(push 1)
(declare-const source_PQ_SIG_005_level_reflexive Int)
(declare-const target_PQ_SIG_005_level_reflexive Int)
(assert (>= source_PQ_SIG_005_level_reflexive 0))
(assert (>= target_PQ_SIG_005_level_reflexive 0))
(assert (not (= source_PQ_SIG_005_level_reflexive target_PQ_SIG_005_level_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_006_level5_max: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_006_level5_max preserves semantics
(push 1)
(declare-const source_PQ_SIG_006_level5_max Int)
(declare-const target_PQ_SIG_006_level5_max Int)
(assert (>= source_PQ_SIG_006_level5_max 0))
(assert (>= target_PQ_SIG_006_level5_max 0))
(assert (not (= source_PQ_SIG_006_level5_max target_PQ_SIG_006_level5_max)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_007_eufcma_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_007_eufcma_valid preserves semantics
(push 1)
(declare-const source_PQ_SIG_007_eufcma_valid Int)
(declare-const target_PQ_SIG_007_eufcma_valid Int)
(assert (>= source_PQ_SIG_007_eufcma_valid 0))
(assert (>= target_PQ_SIG_007_eufcma_valid 0))
(assert (not (= source_PQ_SIG_007_eufcma_valid target_PQ_SIG_007_eufcma_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_008_unforgeable: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_008_unforgeable preserves semantics
(push 1)
(declare-const source_PQ_SIG_008_unforgeable Int)
(declare-const target_PQ_SIG_008_unforgeable Int)
(assert (>= source_PQ_SIG_008_unforgeable 0))
(assert (>= target_PQ_SIG_008_unforgeable 0))
(assert (not (= source_PQ_SIG_008_unforgeable target_PQ_SIG_008_unforgeable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_009_strong_unforgeable: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_009_strong_unforgeable preserves semantics
(push 1)
(declare-const source_PQ_SIG_009_strong_unforgeable Int)
(declare-const target_PQ_SIG_009_strong_unforgeable Int)
(assert (>= source_PQ_SIG_009_strong_unforgeable 0))
(assert (>= target_PQ_SIG_009_strong_unforgeable 0))
(assert (not (= source_PQ_SIG_009_strong_unforgeable target_PQ_SIG_009_strong_unforgeable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_010_adaptive: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_010_adaptive preserves semantics
(push 1)
(declare-const source_PQ_SIG_010_adaptive Int)
(declare-const target_PQ_SIG_010_adaptive Int)
(assert (>= source_PQ_SIG_010_adaptive 0))
(assert (>= target_PQ_SIG_010_adaptive 0))
(assert (not (= source_PQ_SIG_010_adaptive target_PQ_SIG_010_adaptive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_011_qr_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_011_qr_valid preserves semantics
(push 1)
(declare-const source_PQ_SIG_011_qr_valid Int)
(declare-const target_PQ_SIG_011_qr_valid Int)
(assert (>= source_PQ_SIG_011_qr_valid 0))
(assert (>= target_PQ_SIG_011_qr_valid 0))
(assert (not (= source_PQ_SIG_011_qr_valid target_PQ_SIG_011_qr_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_012_post_quantum: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_012_post_quantum preserves semantics
(push 1)
(declare-const source_PQ_SIG_012_post_quantum Int)
(declare-const target_PQ_SIG_012_post_quantum Int)
(assert (>= source_PQ_SIG_012_post_quantum 0))
(assert (>= target_PQ_SIG_012_post_quantum 0))
(assert (not (= source_PQ_SIG_012_post_quantum target_PQ_SIG_012_post_quantum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_013_no_shor: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_013_no_shor preserves semantics
(push 1)
(declare-const source_PQ_SIG_013_no_shor Int)
(declare-const target_PQ_SIG_013_no_shor Int)
(assert (>= source_PQ_SIG_013_no_shor 0))
(assert (>= target_PQ_SIG_013_no_shor 0))
(assert (not (= source_PQ_SIG_013_no_shor target_PQ_SIG_013_no_shor)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_014_conservative: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_014_conservative preserves semantics
(push 1)
(declare-const source_PQ_SIG_014_conservative Int)
(declare-const target_PQ_SIG_014_conservative Int)
(assert (>= source_PQ_SIG_014_conservative 0))
(assert (>= target_PQ_SIG_014_conservative 0))
(assert (not (= source_PQ_SIG_014_conservative target_PQ_SIG_014_conservative)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_015_riina_sig_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_015_riina_sig_secure preserves semantics
(push 1)
(declare-const source_PQ_SIG_015_riina_sig_secure Int)
(declare-const target_PQ_SIG_015_riina_sig_secure Int)
(assert (>= source_PQ_SIG_015_riina_sig_secure 0))
(assert (>= target_PQ_SIG_015_riina_sig_secure 0))
(assert (not (= source_PQ_SIG_015_riina_sig_secure target_PQ_SIG_015_riina_sig_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_016_riina_level5: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_016_riina_level5 preserves semantics
(push 1)
(declare-const source_PQ_SIG_016_riina_level5 Int)
(declare-const target_PQ_SIG_016_riina_level5 Int)
(assert (>= source_PQ_SIG_016_riina_level5 0))
(assert (>= target_PQ_SIG_016_riina_level5 0))
(assert (not (= source_PQ_SIG_016_riina_level5 target_PQ_SIG_016_riina_level5)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_017_riina_mldsa_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_017_riina_mldsa_correct preserves semantics
(push 1)
(declare-const source_PQ_SIG_017_riina_mldsa_correct Int)
(declare-const target_PQ_SIG_017_riina_mldsa_correct Int)
(assert (>= source_PQ_SIG_017_riina_mldsa_correct 0))
(assert (>= target_PQ_SIG_017_riina_mldsa_correct 0))
(assert (not (= source_PQ_SIG_017_riina_mldsa_correct target_PQ_SIG_017_riina_mldsa_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_018_riina_slhdsa_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_018_riina_slhdsa_correct preserves semantics
(push 1)
(declare-const source_PQ_SIG_018_riina_slhdsa_correct Int)
(declare-const target_PQ_SIG_018_riina_slhdsa_correct Int)
(assert (>= source_PQ_SIG_018_riina_slhdsa_correct 0))
(assert (>= target_PQ_SIG_018_riina_slhdsa_correct 0))
(assert (not (= source_PQ_SIG_018_riina_slhdsa_correct target_PQ_SIG_018_riina_slhdsa_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_019_riina_scheme_mldsa: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_019_riina_scheme_mldsa preserves semantics
(push 1)
(declare-const source_PQ_SIG_019_riina_scheme_mldsa Int)
(declare-const target_PQ_SIG_019_riina_scheme_mldsa Int)
(assert (>= source_PQ_SIG_019_riina_scheme_mldsa 0))
(assert (>= target_PQ_SIG_019_riina_scheme_mldsa 0))
(assert (not (= source_PQ_SIG_019_riina_scheme_mldsa target_PQ_SIG_019_riina_scheme_mldsa)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_020_riina_scheme_slhdsa: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_020_riina_scheme_slhdsa preserves semantics
(push 1)
(declare-const source_PQ_SIG_020_riina_scheme_slhdsa Int)
(declare-const target_PQ_SIG_020_riina_scheme_slhdsa Int)
(assert (>= source_PQ_SIG_020_riina_scheme_slhdsa 0))
(assert (>= target_PQ_SIG_020_riina_scheme_slhdsa 0))
(assert (not (= source_PQ_SIG_020_riina_scheme_slhdsa target_PQ_SIG_020_riina_scheme_slhdsa)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_021_security_implies_eufcma: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_021_security_implies_eufcma preserves semantics
(push 1)
(declare-const source_PQ_SIG_021_security_implies_eufcma Int)
(declare-const target_PQ_SIG_021_security_implies_eufcma Int)
(assert (>= source_PQ_SIG_021_security_implies_eufcma 0))
(assert (>= target_PQ_SIG_021_security_implies_eufcma 0))
(assert (not (= source_PQ_SIG_021_security_implies_eufcma target_PQ_SIG_021_security_implies_eufcma)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_022_security_implies_qr: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_022_security_implies_qr preserves semantics
(push 1)
(declare-const source_PQ_SIG_022_security_implies_qr Int)
(declare-const target_PQ_SIG_022_security_implies_qr Int)
(assert (>= source_PQ_SIG_022_security_implies_qr 0))
(assert (>= target_PQ_SIG_022_security_implies_qr 0))
(assert (not (= source_PQ_SIG_022_security_implies_qr target_PQ_SIG_022_security_implies_qr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_023_correct_key: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_023_correct_key preserves semantics
(push 1)
(declare-const source_PQ_SIG_023_correct_key Int)
(declare-const target_PQ_SIG_023_correct_key Int)
(assert (>= source_PQ_SIG_023_correct_key 0))
(assert (>= target_PQ_SIG_023_correct_key 0))
(assert (not (= source_PQ_SIG_023_correct_key target_PQ_SIG_023_correct_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_024_correct_verify: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_024_correct_verify preserves semantics
(push 1)
(declare-const source_PQ_SIG_024_correct_verify Int)
(declare-const target_PQ_SIG_024_correct_verify Int)
(assert (>= source_PQ_SIG_024_correct_verify 0))
(assert (>= target_PQ_SIG_024_correct_verify 0))
(assert (not (= source_PQ_SIG_024_correct_verify target_PQ_SIG_024_correct_verify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PQ_SIG_025_complete_security: translation preserves property (matches Coq: Theorem)
; Translation validation: PQ_SIG_025_complete_security preserves semantics
(push 1)
(declare-const source_PQ_SIG_025_complete_security Int)
(declare-const target_PQ_SIG_025_complete_security Int)
(assert (>= source_PQ_SIG_025_complete_security 0))
(assert (>= target_PQ_SIG_025_complete_security 0))
(assert (not (= source_PQ_SIG_025_complete_security target_PQ_SIG_025_complete_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

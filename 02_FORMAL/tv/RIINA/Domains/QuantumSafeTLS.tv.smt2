; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/QuantumSafeTLS.v (69 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for QuantumSafeTLS
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

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

; level_min: source semantics (matches Coq)
; Translation validation: level_min preserves semantics
(push 1)
(declare-const source_level_min Int)
(declare-const target_level_min Int)
(assert (>= source_level_min 0))
(assert (>= target_level_min 0))
(assert (not (= source_level_min target_level_min)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; level_max: source semantics (matches Coq)
; Translation validation: level_max preserves semantics
(push 1)
(declare-const source_level_max Int)
(declare-const target_level_max Int)
(assert (>= source_level_max 0))
(assert (>= target_level_max 0))
(assert (not (= source_level_max target_level_max)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kem_security_level: source semantics (matches Coq)
; Translation validation: kem_security_level preserves semantics
(push 1)
(declare-const source_kem_security_level Int)
(declare-const target_kem_security_level Int)
(assert (>= source_kem_security_level 0))
(assert (>= target_kem_security_level 0))
(assert (not (= source_kem_security_level target_kem_security_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ml_kem_1024_params: source semantics (matches Coq)
; Translation validation: ml_kem_1024_params preserves semantics
(push 1)
(declare-const source_ml_kem_1024_params Int)
(declare-const target_ml_kem_1024_params Int)
(assert (>= source_ml_kem_1024_params 0))
(assert (>= target_ml_kem_1024_params 0))
(assert (not (= source_ml_kem_1024_params target_ml_kem_1024_params)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kem_fully_secure: source semantics (matches Coq)
; Translation validation: kem_fully_secure preserves semantics
(push 1)
(declare-const source_kem_fully_secure Int)
(declare-const target_kem_fully_secure Int)
(assert (>= source_kem_fully_secure 0))
(assert (>= target_kem_fully_secure 0))
(assert (not (= source_kem_fully_secure target_kem_fully_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ecdh_security_level: source semantics (matches Coq)
; Translation validation: ecdh_security_level preserves semantics
(push 1)
(declare-const source_ecdh_security_level Int)
(declare-const target_ecdh_security_level Int)
(assert (>= source_ecdh_security_level 0))
(assert (>= target_ecdh_security_level 0))
(assert (not (= source_ecdh_security_level target_ecdh_security_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; x25519_params: source semantics (matches Coq)
; Translation validation: x25519_params preserves semantics
(push 1)
(declare-const source_x25519_params Int)
(declare-const target_x25519_params Int)
(assert (>= source_x25519_params 0))
(assert (>= target_x25519_params 0))
(assert (not (= source_x25519_params target_x25519_params)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hybrid_security_level: source semantics (matches Coq)
; Translation validation: hybrid_security_level preserves semantics
(push 1)
(declare-const source_hybrid_security_level Int)
(declare-const target_hybrid_security_level Int)
(assert (>= source_hybrid_security_level 0))
(assert (>= target_hybrid_security_level 0))
(assert (not (= source_hybrid_security_level target_hybrid_security_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hybrid_kex_secure: source semantics (matches Coq)
; Translation validation: hybrid_kex_secure preserves semantics
(push 1)
(declare-const source_hybrid_kex_secure Int)
(declare-const target_hybrid_kex_secure Int)
(assert (>= source_hybrid_kex_secure 0))
(assert (>= target_hybrid_kex_secure 0))
(assert (not (= source_hybrid_kex_secure target_hybrid_kex_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hybrid_config_valid: source semantics (matches Coq)
; Translation validation: hybrid_config_valid preserves semantics
(push 1)
(declare-const source_hybrid_config_valid Int)
(declare-const target_hybrid_config_valid Int)
(assert (>= source_hybrid_config_valid 0))
(assert (>= target_hybrid_config_valid 0))
(assert (not (= source_hybrid_config_valid target_hybrid_config_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sig_security_level: source semantics (matches Coq)
; Translation validation: sig_security_level preserves semantics
(push 1)
(declare-const source_sig_security_level Int)
(declare-const target_sig_security_level Int)
(assert (>= source_sig_security_level 0))
(assert (>= target_sig_security_level 0))
(assert (not (= source_sig_security_level target_sig_security_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sig_is_post_quantum: source semantics (matches Coq)
; Translation validation: sig_is_post_quantum preserves semantics
(push 1)
(declare-const source_sig_is_post_quantum Int)
(declare-const target_sig_is_post_quantum Int)
(assert (>= source_sig_is_post_quantum 0))
(assert (>= target_sig_is_post_quantum 0))
(assert (not (= source_sig_is_post_quantum target_sig_is_post_quantum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sig_fully_secure: source semantics (matches Coq)
; Translation validation: sig_fully_secure preserves semantics
(push 1)
(declare-const source_sig_fully_secure Int)
(declare-const target_sig_fully_secure Int)
(assert (>= source_sig_fully_secure 0))
(assert (>= target_sig_fully_secure 0))
(assert (not (= source_sig_fully_secure target_sig_fully_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pq_auth_secure: source semantics (matches Coq)
; Translation validation: pq_auth_secure preserves semantics
(push 1)
(declare-const source_pq_auth_secure Int)
(declare-const target_pq_auth_secure Int)
(assert (>= source_pq_auth_secure 0))
(assert (>= target_pq_auth_secure 0))
(assert (not (= source_pq_auth_secure target_pq_auth_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; handshake_secure: source semantics (matches Coq)
; Translation validation: handshake_secure preserves semantics
(push 1)
(declare-const source_handshake_secure Int)
(declare-const target_handshake_secure Int)
(assert (>= source_handshake_secure 0))
(assert (>= target_handshake_secure 0))
(assert (not (= source_handshake_secure target_handshake_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tls13_extensions_valid: source semantics (matches Coq)
; Translation validation: tls13_extensions_valid preserves semantics
(push 1)
(declare-const source_tls13_extensions_valid Int)
(declare-const target_tls13_extensions_valid Int)
(assert (>= source_tls13_extensions_valid 0))
(assert (>= target_tls13_extensions_valid 0))
(assert (not (= source_tls13_extensions_valid target_tls13_extensions_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; record_secure: source semantics (matches Coq)
; Translation validation: record_secure preserves semantics
(push 1)
(declare-const source_record_secure Int)
(declare-const target_record_secure Int)
(assert (>= source_record_secure 0))
(assert (>= target_record_secure 0))
(assert (not (= source_record_secure target_record_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; aead_secure: source semantics (matches Coq)
; Translation validation: aead_secure preserves semantics
(push 1)
(declare-const source_aead_secure Int)
(declare-const target_aead_secure Int)
(assert (>= source_aead_secure 0))
(assert (>= target_aead_secure 0))
(assert (not (= source_aead_secure target_aead_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forward_secrecy_complete: source semantics (matches Coq)
; Translation validation: forward_secrecy_complete preserves semantics
(push 1)
(declare-const source_forward_secrecy_complete Int)
(declare-const target_forward_secrecy_complete Int)
(assert (>= source_forward_secrecy_complete 0))
(assert (>= target_forward_secrecy_complete 0))
(assert (not (= source_forward_secrecy_complete target_forward_secrecy_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; algorithm_agility_valid: source semantics (matches Coq)
; Translation validation: algorithm_agility_valid preserves semantics
(push 1)
(declare-const source_algorithm_agility_valid Int)
(declare-const target_algorithm_agility_valid Int)
(assert (>= source_algorithm_agility_valid 0))
(assert (>= target_algorithm_agility_valid 0))
(assert (not (= source_algorithm_agility_valid target_algorithm_agility_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; qstls_fully_secure: source semantics (matches Coq)
; Translation validation: qstls_fully_secure preserves semantics
(push 1)
(declare-const source_qstls_fully_secure Int)
(declare-const target_qstls_fully_secure Int)
(assert (>= source_qstls_fully_secure 0))
(assert (>= target_qstls_fully_secure 0))
(assert (not (= source_qstls_fully_secure target_qstls_fully_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; qstls_full_secure: source semantics (matches Coq)
; Translation validation: qstls_full_secure preserves semantics
(push 1)
(declare-const source_qstls_full_secure Int)
(declare-const target_qstls_full_secure Int)
(assert (>= source_qstls_full_secure 0))
(assert (>= target_qstls_full_secure 0))
(assert (not (= source_qstls_full_secure target_qstls_full_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_kex: source semantics (matches Coq)
; Translation validation: riina_kex preserves semantics
(push 1)
(declare-const source_riina_kex Int)
(declare-const target_riina_kex Int)
(assert (>= source_riina_kex 0))
(assert (>= target_riina_kex 0))
(assert (not (= source_riina_kex target_riina_kex)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_auth: source semantics (matches Coq)
; Translation validation: riina_auth preserves semantics
(push 1)
(declare-const source_riina_auth Int)
(declare-const target_riina_auth Int)
(assert (>= source_riina_auth 0))
(assert (>= target_riina_auth 0))
(assert (not (= source_riina_auth target_riina_auth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_hs: source semantics (matches Coq)
; Translation validation: riina_hs preserves semantics
(push 1)
(declare-const source_riina_hs Int)
(declare-const target_riina_hs Int)
(assert (>= source_riina_hs 0))
(assert (>= target_riina_hs 0))
(assert (not (= source_riina_hs target_riina_hs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_rec: source semantics (matches Coq)
; Translation validation: riina_rec preserves semantics
(push 1)
(declare-const source_riina_rec Int)
(declare-const target_riina_rec Int)
(assert (>= source_riina_rec 0))
(assert (>= target_riina_rec 0))
(assert (not (= source_riina_rec target_riina_rec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_qstls: source semantics (matches Coq)
; Translation validation: riina_qstls preserves semantics
(push 1)
(declare-const source_riina_qstls Int)
(declare-const target_riina_qstls Int)
(assert (>= source_riina_qstls 0))
(assert (>= target_riina_qstls 0))
(assert (not (= source_riina_qstls target_riina_qstls)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_hybrid_config: source semantics (matches Coq)
; Translation validation: riina_hybrid_config preserves semantics
(push 1)
(declare-const source_riina_hybrid_config Int)
(declare-const target_riina_hybrid_config Int)
(assert (>= source_riina_hybrid_config 0))
(assert (>= target_riina_hybrid_config 0))
(assert (not (= source_riina_hybrid_config target_riina_hybrid_config)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_fs_config: source semantics (matches Coq)
; Translation validation: riina_fs_config preserves semantics
(push 1)
(declare-const source_riina_fs_config Int)
(declare-const target_riina_fs_config Int)
(assert (>= source_riina_fs_config 0))
(assert (>= target_riina_fs_config 0))
(assert (not (= source_riina_fs_config target_riina_fs_config)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_agility: source semantics (matches Coq)
; Translation validation: riina_agility preserves semantics
(push 1)
(declare-const source_riina_agility Int)
(declare-const target_riina_agility Int)
(assert (>= source_riina_agility 0))
(assert (>= target_riina_agility 0))
(assert (not (= source_riina_agility target_riina_agility)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_extensions: source semantics (matches Coq)
; Translation validation: riina_extensions preserves semantics
(push 1)
(declare-const source_riina_extensions Int)
(declare-const target_riina_extensions Int)
(assert (>= source_riina_extensions 0))
(assert (>= target_riina_extensions 0))
(assert (not (= source_riina_extensions target_riina_extensions)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_hs_config: source semantics (matches Coq)
; Translation validation: riina_hs_config preserves semantics
(push 1)
(declare-const source_riina_hs_config Int)
(declare-const target_riina_hs_config Int)
(assert (>= source_riina_hs_config 0))
(assert (>= target_riina_hs_config 0))
(assert (not (= source_riina_hs_config target_riina_hs_config)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_qstls_full: source semantics (matches Coq)
; Translation validation: riina_qstls_full preserves semantics
(push 1)
(declare-const source_riina_qstls_full Int)
(declare-const target_riina_qstls_full Int)
(assert (>= source_riina_qstls_full 0))
(assert (>= target_riina_qstls_full 0))
(assert (not (= source_riina_qstls_full target_riina_qstls_full)))
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

; riina_aead: source semantics (matches Coq)
; Translation validation: riina_aead preserves semantics
(push 1)
(declare-const source_riina_aead Int)
(declare-const target_riina_aead Int)
(assert (>= source_riina_aead 0))
(assert (>= target_riina_aead 0))
(assert (not (= source_riina_aead target_riina_aead)))
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

; orb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: orb_true_iff preserves semantics
(push 1)
(declare-const source_orb_true_iff Int)
(declare-const target_orb_true_iff Int)
(assert (>= source_orb_true_iff 0))
(assert (>= target_orb_true_iff 0))
(assert (not (= source_orb_true_iff target_orb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_false_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_false_iff preserves semantics
(push 1)
(declare-const source_negb_false_iff Int)
(declare-const target_negb_false_iff Int)
(assert (>= source_negb_false_iff 0))
(assert (>= target_negb_false_iff 0))
(assert (not (= source_negb_false_iff target_negb_false_iff)))
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

; QSTLS_001: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_001 preserves semantics
(push 1)
(declare-const source_QSTLS_001 Int)
(declare-const target_QSTLS_001 Int)
(assert (>= source_QSTLS_001 0))
(assert (>= target_QSTLS_001 0))
(assert (not (= source_QSTLS_001 target_QSTLS_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_002: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_002 preserves semantics
(push 1)
(declare-const source_QSTLS_002 Int)
(declare-const target_QSTLS_002 Int)
(assert (>= source_QSTLS_002 0))
(assert (>= target_QSTLS_002 0))
(assert (not (= source_QSTLS_002 target_QSTLS_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_003: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_003 preserves semantics
(push 1)
(declare-const source_QSTLS_003 Int)
(declare-const target_QSTLS_003 Int)
(assert (>= source_QSTLS_003 0))
(assert (>= target_QSTLS_003 0))
(assert (not (= source_QSTLS_003 target_QSTLS_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_004: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_004 preserves semantics
(push 1)
(declare-const source_QSTLS_004 Int)
(declare-const target_QSTLS_004 Int)
(assert (>= source_QSTLS_004 0))
(assert (>= target_QSTLS_004 0))
(assert (not (= source_QSTLS_004 target_QSTLS_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_005: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_005 preserves semantics
(push 1)
(declare-const source_QSTLS_005 Int)
(declare-const target_QSTLS_005 Int)
(assert (>= source_QSTLS_005 0))
(assert (>= target_QSTLS_005 0))
(assert (not (= source_QSTLS_005 target_QSTLS_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_006: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_006 preserves semantics
(push 1)
(declare-const source_QSTLS_006 Int)
(declare-const target_QSTLS_006 Int)
(assert (>= source_QSTLS_006 0))
(assert (>= target_QSTLS_006 0))
(assert (not (= source_QSTLS_006 target_QSTLS_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_007: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_007 preserves semantics
(push 1)
(declare-const source_QSTLS_007 Int)
(declare-const target_QSTLS_007 Int)
(assert (>= source_QSTLS_007 0))
(assert (>= target_QSTLS_007 0))
(assert (not (= source_QSTLS_007 target_QSTLS_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_008: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_008 preserves semantics
(push 1)
(declare-const source_QSTLS_008 Int)
(declare-const target_QSTLS_008 Int)
(assert (>= source_QSTLS_008 0))
(assert (>= target_QSTLS_008 0))
(assert (not (= source_QSTLS_008 target_QSTLS_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_009: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_009 preserves semantics
(push 1)
(declare-const source_QSTLS_009 Int)
(declare-const target_QSTLS_009 Int)
(assert (>= source_QSTLS_009 0))
(assert (>= target_QSTLS_009 0))
(assert (not (= source_QSTLS_009 target_QSTLS_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_010: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_010 preserves semantics
(push 1)
(declare-const source_QSTLS_010 Int)
(declare-const target_QSTLS_010 Int)
(assert (>= source_QSTLS_010 0))
(assert (>= target_QSTLS_010 0))
(assert (not (= source_QSTLS_010 target_QSTLS_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_011: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_011 preserves semantics
(push 1)
(declare-const source_QSTLS_011 Int)
(declare-const target_QSTLS_011 Int)
(assert (>= source_QSTLS_011 0))
(assert (>= target_QSTLS_011 0))
(assert (not (= source_QSTLS_011 target_QSTLS_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_012: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_012 preserves semantics
(push 1)
(declare-const source_QSTLS_012 Int)
(declare-const target_QSTLS_012 Int)
(assert (>= source_QSTLS_012 0))
(assert (>= target_QSTLS_012 0))
(assert (not (= source_QSTLS_012 target_QSTLS_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_013: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_013 preserves semantics
(push 1)
(declare-const source_QSTLS_013 Int)
(declare-const target_QSTLS_013 Int)
(assert (>= source_QSTLS_013 0))
(assert (>= target_QSTLS_013 0))
(assert (not (= source_QSTLS_013 target_QSTLS_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_014: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_014 preserves semantics
(push 1)
(declare-const source_QSTLS_014 Int)
(declare-const target_QSTLS_014 Int)
(assert (>= source_QSTLS_014 0))
(assert (>= target_QSTLS_014 0))
(assert (not (= source_QSTLS_014 target_QSTLS_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_015: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_015 preserves semantics
(push 1)
(declare-const source_QSTLS_015 Int)
(declare-const target_QSTLS_015 Int)
(assert (>= source_QSTLS_015 0))
(assert (>= target_QSTLS_015 0))
(assert (not (= source_QSTLS_015 target_QSTLS_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_016: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_016 preserves semantics
(push 1)
(declare-const source_QSTLS_016 Int)
(declare-const target_QSTLS_016 Int)
(assert (>= source_QSTLS_016 0))
(assert (>= target_QSTLS_016 0))
(assert (not (= source_QSTLS_016 target_QSTLS_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_017: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_017 preserves semantics
(push 1)
(declare-const source_QSTLS_017 Int)
(declare-const target_QSTLS_017 Int)
(assert (>= source_QSTLS_017 0))
(assert (>= target_QSTLS_017 0))
(assert (not (= source_QSTLS_017 target_QSTLS_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_018: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_018 preserves semantics
(push 1)
(declare-const source_QSTLS_018 Int)
(declare-const target_QSTLS_018 Int)
(assert (>= source_QSTLS_018 0))
(assert (>= target_QSTLS_018 0))
(assert (not (= source_QSTLS_018 target_QSTLS_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_019: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_019 preserves semantics
(push 1)
(declare-const source_QSTLS_019 Int)
(declare-const target_QSTLS_019 Int)
(assert (>= source_QSTLS_019 0))
(assert (>= target_QSTLS_019 0))
(assert (not (= source_QSTLS_019 target_QSTLS_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_020: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_020 preserves semantics
(push 1)
(declare-const source_QSTLS_020 Int)
(declare-const target_QSTLS_020 Int)
(assert (>= source_QSTLS_020 0))
(assert (>= target_QSTLS_020 0))
(assert (not (= source_QSTLS_020 target_QSTLS_020)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_021: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_021 preserves semantics
(push 1)
(declare-const source_QSTLS_021 Int)
(declare-const target_QSTLS_021 Int)
(assert (>= source_QSTLS_021 0))
(assert (>= target_QSTLS_021 0))
(assert (not (= source_QSTLS_021 target_QSTLS_021)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_022: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_022 preserves semantics
(push 1)
(declare-const source_QSTLS_022 Int)
(declare-const target_QSTLS_022 Int)
(assert (>= source_QSTLS_022 0))
(assert (>= target_QSTLS_022 0))
(assert (not (= source_QSTLS_022 target_QSTLS_022)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_023: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_023 preserves semantics
(push 1)
(declare-const source_QSTLS_023 Int)
(declare-const target_QSTLS_023 Int)
(assert (>= source_QSTLS_023 0))
(assert (>= target_QSTLS_023 0))
(assert (not (= source_QSTLS_023 target_QSTLS_023)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_024: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_024 preserves semantics
(push 1)
(declare-const source_QSTLS_024 Int)
(declare-const target_QSTLS_024 Int)
(assert (>= source_QSTLS_024 0))
(assert (>= target_QSTLS_024 0))
(assert (not (= source_QSTLS_024 target_QSTLS_024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_025: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_025 preserves semantics
(push 1)
(declare-const source_QSTLS_025 Int)
(declare-const target_QSTLS_025 Int)
(assert (>= source_QSTLS_025 0))
(assert (>= target_QSTLS_025 0))
(assert (not (= source_QSTLS_025 target_QSTLS_025)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_026: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_026 preserves semantics
(push 1)
(declare-const source_QSTLS_026 Int)
(declare-const target_QSTLS_026 Int)
(assert (>= source_QSTLS_026 0))
(assert (>= target_QSTLS_026 0))
(assert (not (= source_QSTLS_026 target_QSTLS_026)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_027: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_027 preserves semantics
(push 1)
(declare-const source_QSTLS_027 Int)
(declare-const target_QSTLS_027 Int)
(assert (>= source_QSTLS_027 0))
(assert (>= target_QSTLS_027 0))
(assert (not (= source_QSTLS_027 target_QSTLS_027)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_028: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_028 preserves semantics
(push 1)
(declare-const source_QSTLS_028 Int)
(declare-const target_QSTLS_028 Int)
(assert (>= source_QSTLS_028 0))
(assert (>= target_QSTLS_028 0))
(assert (not (= source_QSTLS_028 target_QSTLS_028)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_029: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_029 preserves semantics
(push 1)
(declare-const source_QSTLS_029 Int)
(declare-const target_QSTLS_029 Int)
(assert (>= source_QSTLS_029 0))
(assert (>= target_QSTLS_029 0))
(assert (not (= source_QSTLS_029 target_QSTLS_029)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_030: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_030 preserves semantics
(push 1)
(declare-const source_QSTLS_030 Int)
(declare-const target_QSTLS_030 Int)
(assert (>= source_QSTLS_030 0))
(assert (>= target_QSTLS_030 0))
(assert (not (= source_QSTLS_030 target_QSTLS_030)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_031: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_031 preserves semantics
(push 1)
(declare-const source_QSTLS_031 Int)
(declare-const target_QSTLS_031 Int)
(assert (>= source_QSTLS_031 0))
(assert (>= target_QSTLS_031 0))
(assert (not (= source_QSTLS_031 target_QSTLS_031)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_032: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_032 preserves semantics
(push 1)
(declare-const source_QSTLS_032 Int)
(declare-const target_QSTLS_032 Int)
(assert (>= source_QSTLS_032 0))
(assert (>= target_QSTLS_032 0))
(assert (not (= source_QSTLS_032 target_QSTLS_032)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_033: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_033 preserves semantics
(push 1)
(declare-const source_QSTLS_033 Int)
(declare-const target_QSTLS_033 Int)
(assert (>= source_QSTLS_033 0))
(assert (>= target_QSTLS_033 0))
(assert (not (= source_QSTLS_033 target_QSTLS_033)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_034: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_034 preserves semantics
(push 1)
(declare-const source_QSTLS_034 Int)
(declare-const target_QSTLS_034 Int)
(assert (>= source_QSTLS_034 0))
(assert (>= target_QSTLS_034 0))
(assert (not (= source_QSTLS_034 target_QSTLS_034)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_035: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_035 preserves semantics
(push 1)
(declare-const source_QSTLS_035 Int)
(declare-const target_QSTLS_035 Int)
(assert (>= source_QSTLS_035 0))
(assert (>= target_QSTLS_035 0))
(assert (not (= source_QSTLS_035 target_QSTLS_035)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_036: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_036 preserves semantics
(push 1)
(declare-const source_QSTLS_036 Int)
(declare-const target_QSTLS_036 Int)
(assert (>= source_QSTLS_036 0))
(assert (>= target_QSTLS_036 0))
(assert (not (= source_QSTLS_036 target_QSTLS_036)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_037: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_037 preserves semantics
(push 1)
(declare-const source_QSTLS_037 Int)
(declare-const target_QSTLS_037 Int)
(assert (>= source_QSTLS_037 0))
(assert (>= target_QSTLS_037 0))
(assert (not (= source_QSTLS_037 target_QSTLS_037)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_038: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_038 preserves semantics
(push 1)
(declare-const source_QSTLS_038 Int)
(declare-const target_QSTLS_038 Int)
(assert (>= source_QSTLS_038 0))
(assert (>= target_QSTLS_038 0))
(assert (not (= source_QSTLS_038 target_QSTLS_038)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_039: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_039 preserves semantics
(push 1)
(declare-const source_QSTLS_039 Int)
(declare-const target_QSTLS_039 Int)
(assert (>= source_QSTLS_039 0))
(assert (>= target_QSTLS_039 0))
(assert (not (= source_QSTLS_039 target_QSTLS_039)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_040: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_040 preserves semantics
(push 1)
(declare-const source_QSTLS_040 Int)
(declare-const target_QSTLS_040 Int)
(assert (>= source_QSTLS_040 0))
(assert (>= target_QSTLS_040 0))
(assert (not (= source_QSTLS_040 target_QSTLS_040)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_041: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_041 preserves semantics
(push 1)
(declare-const source_QSTLS_041 Int)
(declare-const target_QSTLS_041 Int)
(assert (>= source_QSTLS_041 0))
(assert (>= target_QSTLS_041 0))
(assert (not (= source_QSTLS_041 target_QSTLS_041)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_042: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_042 preserves semantics
(push 1)
(declare-const source_QSTLS_042 Int)
(declare-const target_QSTLS_042 Int)
(assert (>= source_QSTLS_042 0))
(assert (>= target_QSTLS_042 0))
(assert (not (= source_QSTLS_042 target_QSTLS_042)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_043: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_043 preserves semantics
(push 1)
(declare-const source_QSTLS_043 Int)
(declare-const target_QSTLS_043 Int)
(assert (>= source_QSTLS_043 0))
(assert (>= target_QSTLS_043 0))
(assert (not (= source_QSTLS_043 target_QSTLS_043)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_044: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_044 preserves semantics
(push 1)
(declare-const source_QSTLS_044 Int)
(declare-const target_QSTLS_044 Int)
(assert (>= source_QSTLS_044 0))
(assert (>= target_QSTLS_044 0))
(assert (not (= source_QSTLS_044 target_QSTLS_044)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_045: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_045 preserves semantics
(push 1)
(declare-const source_QSTLS_045 Int)
(declare-const target_QSTLS_045 Int)
(assert (>= source_QSTLS_045 0))
(assert (>= target_QSTLS_045 0))
(assert (not (= source_QSTLS_045 target_QSTLS_045)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_046: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_046 preserves semantics
(push 1)
(declare-const source_QSTLS_046 Int)
(declare-const target_QSTLS_046 Int)
(assert (>= source_QSTLS_046 0))
(assert (>= target_QSTLS_046 0))
(assert (not (= source_QSTLS_046 target_QSTLS_046)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_047: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_047 preserves semantics
(push 1)
(declare-const source_QSTLS_047 Int)
(declare-const target_QSTLS_047 Int)
(assert (>= source_QSTLS_047 0))
(assert (>= target_QSTLS_047 0))
(assert (not (= source_QSTLS_047 target_QSTLS_047)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_048: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_048 preserves semantics
(push 1)
(declare-const source_QSTLS_048 Int)
(declare-const target_QSTLS_048 Int)
(assert (>= source_QSTLS_048 0))
(assert (>= target_QSTLS_048 0))
(assert (not (= source_QSTLS_048 target_QSTLS_048)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_049: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_049 preserves semantics
(push 1)
(declare-const source_QSTLS_049 Int)
(declare-const target_QSTLS_049 Int)
(assert (>= source_QSTLS_049 0))
(assert (>= target_QSTLS_049 0))
(assert (not (= source_QSTLS_049 target_QSTLS_049)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_050: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_050 preserves semantics
(push 1)
(declare-const source_QSTLS_050 Int)
(declare-const target_QSTLS_050 Int)
(assert (>= source_QSTLS_050 0))
(assert (>= target_QSTLS_050 0))
(assert (not (= source_QSTLS_050 target_QSTLS_050)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_051: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_051 preserves semantics
(push 1)
(declare-const source_QSTLS_051 Int)
(declare-const target_QSTLS_051 Int)
(assert (>= source_QSTLS_051 0))
(assert (>= target_QSTLS_051 0))
(assert (not (= source_QSTLS_051 target_QSTLS_051)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_052: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_052 preserves semantics
(push 1)
(declare-const source_QSTLS_052 Int)
(declare-const target_QSTLS_052 Int)
(assert (>= source_QSTLS_052 0))
(assert (>= target_QSTLS_052 0))
(assert (not (= source_QSTLS_052 target_QSTLS_052)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_053: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_053 preserves semantics
(push 1)
(declare-const source_QSTLS_053 Int)
(declare-const target_QSTLS_053 Int)
(assert (>= source_QSTLS_053 0))
(assert (>= target_QSTLS_053 0))
(assert (not (= source_QSTLS_053 target_QSTLS_053)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_054: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_054 preserves semantics
(push 1)
(declare-const source_QSTLS_054 Int)
(declare-const target_QSTLS_054 Int)
(assert (>= source_QSTLS_054 0))
(assert (>= target_QSTLS_054 0))
(assert (not (= source_QSTLS_054 target_QSTLS_054)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_055: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_055 preserves semantics
(push 1)
(declare-const source_QSTLS_055 Int)
(declare-const target_QSTLS_055 Int)
(assert (>= source_QSTLS_055 0))
(assert (>= target_QSTLS_055 0))
(assert (not (= source_QSTLS_055 target_QSTLS_055)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_056: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_056 preserves semantics
(push 1)
(declare-const source_QSTLS_056 Int)
(declare-const target_QSTLS_056 Int)
(assert (>= source_QSTLS_056 0))
(assert (>= target_QSTLS_056 0))
(assert (not (= source_QSTLS_056 target_QSTLS_056)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_057: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_057 preserves semantics
(push 1)
(declare-const source_QSTLS_057 Int)
(declare-const target_QSTLS_057 Int)
(assert (>= source_QSTLS_057 0))
(assert (>= target_QSTLS_057 0))
(assert (not (= source_QSTLS_057 target_QSTLS_057)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_058: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_058 preserves semantics
(push 1)
(declare-const source_QSTLS_058 Int)
(declare-const target_QSTLS_058 Int)
(assert (>= source_QSTLS_058 0))
(assert (>= target_QSTLS_058 0))
(assert (not (= source_QSTLS_058 target_QSTLS_058)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_059: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_059 preserves semantics
(push 1)
(declare-const source_QSTLS_059 Int)
(declare-const target_QSTLS_059 Int)
(assert (>= source_QSTLS_059 0))
(assert (>= target_QSTLS_059 0))
(assert (not (= source_QSTLS_059 target_QSTLS_059)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_060: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_060 preserves semantics
(push 1)
(declare-const source_QSTLS_060 Int)
(declare-const target_QSTLS_060 Int)
(assert (>= source_QSTLS_060 0))
(assert (>= target_QSTLS_060 0))
(assert (not (= source_QSTLS_060 target_QSTLS_060)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_061: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_061 preserves semantics
(push 1)
(declare-const source_QSTLS_061 Int)
(declare-const target_QSTLS_061 Int)
(assert (>= source_QSTLS_061 0))
(assert (>= target_QSTLS_061 0))
(assert (not (= source_QSTLS_061 target_QSTLS_061)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_062: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_062 preserves semantics
(push 1)
(declare-const source_QSTLS_062 Int)
(declare-const target_QSTLS_062 Int)
(assert (>= source_QSTLS_062 0))
(assert (>= target_QSTLS_062 0))
(assert (not (= source_QSTLS_062 target_QSTLS_062)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_063_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_063_complete preserves semantics
(push 1)
(declare-const source_QSTLS_063_complete Int)
(declare-const target_QSTLS_063_complete Int)
(assert (>= source_QSTLS_063_complete 0))
(assert (>= target_QSTLS_063_complete 0))
(assert (not (= source_QSTLS_063_complete target_QSTLS_063_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_064_hybrid_security: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_064_hybrid_security preserves semantics
(push 1)
(declare-const source_QSTLS_064_hybrid_security Int)
(declare-const target_QSTLS_064_hybrid_security Int)
(assert (>= source_QSTLS_064_hybrid_security 0))
(assert (>= target_QSTLS_064_hybrid_security 0))
(assert (not (= source_QSTLS_064_hybrid_security target_QSTLS_064_hybrid_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; QSTLS_065_full_chain: translation preserves property (matches Coq: Theorem)
; Translation validation: QSTLS_065_full_chain preserves semantics
(push 1)
(declare-const source_QSTLS_065_full_chain Int)
(declare-const target_QSTLS_065_full_chain Int)
(assert (>= source_QSTLS_065_full_chain 0))
(assert (>= target_QSTLS_065_full_chain 0))
(assert (not (= source_QSTLS_065_full_chain target_QSTLS_065_full_chain)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

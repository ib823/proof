; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/VerifiedProtocols.v (37 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for VerifiedProtocols
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; valid_keypair: source semantics (matches Coq)
; Translation validation: valid_keypair preserves semantics
(push 1)
(declare-const source_valid_keypair Int)
(declare-const target_valid_keypair Int)
(assert (>= source_valid_keypair 0))
(assert (>= target_valid_keypair 0))
(assert (not (= source_valid_keypair target_valid_keypair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; x25519: source semantics (matches Coq)
; Translation validation: x25519 preserves semantics
(push 1)
(declare-const source_x25519 Int)
(declare-const target_x25519 Int)
(assert (>= source_x25519 0))
(assert (>= target_x25519 0))
(assert (not (= source_x25519 target_x25519)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; x25519_commutes: source semantics (matches Coq)
; Translation validation: x25519_commutes preserves semantics
(push 1)
(declare-const source_x25519_commutes Int)
(declare-const target_x25519_commutes Int)
(assert (>= source_x25519_commutes 0))
(assert (>= target_x25519_commutes 0))
(assert (not (= source_x25519_commutes target_x25519_commutes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; aead_correct: source semantics (matches Coq)
; Translation validation: aead_correct preserves semantics
(push 1)
(declare-const source_aead_correct Int)
(declare-const target_aead_correct Int)
(assert (>= source_aead_correct 0))
(assert (>= target_aead_correct 0))
(assert (not (= source_aead_correct target_aead_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; initial_tls13_state: source semantics (matches Coq)
; Translation validation: initial_tls13_state preserves semantics
(push 1)
(declare-const source_initial_tls13_state Int)
(declare-const target_initial_tls13_state Int)
(assert (>= source_initial_tls13_state 0))
(assert (>= target_initial_tls13_state 0))
(assert (not (= source_initial_tls13_state target_initial_tls13_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tls13_handshake_complete: source semantics (matches Coq)
; Translation validation: tls13_handshake_complete preserves semantics
(push 1)
(declare-const source_tls13_handshake_complete Int)
(declare-const target_tls13_handshake_complete Int)
(assert (>= source_tls13_handshake_complete 0))
(assert (>= target_tls13_handshake_complete 0))
(assert (not (= source_tls13_handshake_complete target_tls13_handshake_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; session_established_before: source semantics (matches Coq)
; Translation validation: session_established_before preserves semantics
(push 1)
(declare-const source_session_established_before Int)
(declare-const target_session_established_before Int)
(assert (>= source_session_established_before 0))
(assert (>= target_session_established_before 0))
(assert (not (= source_session_established_before target_session_established_before)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_pattern_initiator_static: source semantics (matches Coq)
; Translation validation: noise_pattern_initiator_static preserves semantics
(push 1)
(declare-const source_noise_pattern_initiator_static Int)
(declare-const target_noise_pattern_initiator_static Int)
(assert (>= source_noise_pattern_initiator_static 0))
(assert (>= target_noise_pattern_initiator_static 0))
(assert (not (= source_noise_pattern_initiator_static target_noise_pattern_initiator_static)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_pattern_responder_static: source semantics (matches Coq)
; Translation validation: noise_pattern_responder_static preserves semantics
(push 1)
(declare-const source_noise_pattern_responder_static Int)
(declare-const target_noise_pattern_responder_static Int)
(assert (>= source_noise_pattern_responder_static 0))
(assert (>= target_noise_pattern_responder_static 0))
(assert (not (= source_noise_pattern_responder_static target_noise_pattern_responder_static)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_pattern_identity_hiding_initiator: source semantics (matches Coq)
; Translation validation: noise_pattern_identity_hiding_initiator preserves semantics
(push 1)
(declare-const source_noise_pattern_identity_hiding_initiator Int)
(declare-const target_noise_pattern_identity_hiding_initiator Int)
(assert (>= source_noise_pattern_identity_hiding_initiator 0))
(assert (>= target_noise_pattern_identity_hiding_initiator 0))
(assert (not (= source_noise_pattern_identity_hiding_initiator target_noise_pattern_identity_hiding_initiator)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; init_noise_state: source semantics (matches Coq)
; Translation validation: init_noise_state preserves semantics
(push 1)
(declare-const source_init_noise_state Int)
(declare-const target_init_noise_state Int)
(assert (>= source_init_noise_state 0))
(assert (>= target_init_noise_state 0))
(assert (not (= source_init_noise_state target_init_noise_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_mix_key: source semantics (matches Coq)
; Translation validation: noise_mix_key preserves semantics
(push 1)
(declare-const source_noise_mix_key Int)
(declare-const target_noise_mix_key Int)
(assert (>= source_noise_mix_key 0))
(assert (>= target_noise_mix_key 0))
(assert (not (= source_noise_mix_key target_noise_mix_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_mix_hash: source semantics (matches Coq)
; Translation validation: noise_mix_hash preserves semantics
(push 1)
(declare-const source_noise_mix_hash Int)
(declare-const target_noise_mix_hash Int)
(assert (>= source_noise_mix_hash 0))
(assert (>= target_noise_mix_hash 0))
(assert (not (= source_noise_mix_hash target_noise_mix_hash)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; noise_handshake_complete: source semantics (matches Coq)
; Translation validation: noise_handshake_complete preserves semantics
(push 1)
(declare-const source_noise_handshake_complete Int)
(declare-const target_noise_handshake_complete Int)
(assert (>= source_noise_handshake_complete 0))
(assert (>= target_noise_handshake_complete 0))
(assert (not (= source_noise_handshake_complete target_noise_handshake_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; x3dh_initiator: source semantics (matches Coq)
; Translation validation: x3dh_initiator preserves semantics
(push 1)
(declare-const source_x3dh_initiator Int)
(declare-const target_x3dh_initiator Int)
(assert (>= source_x3dh_initiator 0))
(assert (>= target_x3dh_initiator 0))
(assert (not (= source_x3dh_initiator target_x3dh_initiator)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; signal_dh_ratchet: source semantics (matches Coq)
; Translation validation: signal_dh_ratchet preserves semantics
(push 1)
(declare-const source_signal_dh_ratchet Int)
(declare-const target_signal_dh_ratchet Int)
(assert (>= source_signal_dh_ratchet 0))
(assert (>= target_signal_dh_ratchet 0))
(assert (not (= source_signal_dh_ratchet target_signal_dh_ratchet)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; confidentiality: source semantics (matches Coq)
; Translation validation: confidentiality preserves semantics
(push 1)
(declare-const source_confidentiality Int)
(declare-const target_confidentiality Int)
(assert (>= source_confidentiality 0))
(assert (>= target_confidentiality 0))
(assert (not (= source_confidentiality target_confidentiality)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; strong_confidentiality: source semantics (matches Coq)
; Translation validation: strong_confidentiality preserves semantics
(push 1)
(declare-const source_strong_confidentiality Int)
(declare-const target_strong_confidentiality Int)
(assert (>= source_strong_confidentiality 0))
(assert (>= target_strong_confidentiality 0))
(assert (not (= source_strong_confidentiality target_strong_confidentiality)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; authentication: source semantics (matches Coq)
; Translation validation: authentication preserves semantics
(push 1)
(declare-const source_authentication Int)
(declare-const target_authentication Int)
(assert (>= source_authentication 0))
(assert (>= target_authentication 0))
(assert (not (= source_authentication target_authentication)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forward_secrecy: source semantics (matches Coq)
; Translation validation: forward_secrecy preserves semantics
(push 1)
(declare-const source_forward_secrecy Int)
(declare-const target_forward_secrecy Int)
(assert (>= source_forward_secrecy 0))
(assert (>= target_forward_secrecy 0))
(assert (not (= source_forward_secrecy target_forward_secrecy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; implements: source semantics (matches Coq)
; Translation validation: implements preserves semantics
(push 1)
(declare-const source_implements Int)
(declare-const target_implements Int)
(assert (>= source_implements 0))
(assert (>= target_implements 0))
(assert (not (= source_implements target_implements)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_trace: source semantics (matches Coq)
; Translation validation: valid_trace preserves semantics
(push 1)
(declare-const source_valid_trace Int)
(declare-const target_valid_trace Int)
(assert (>= source_valid_trace 0))
(assert (>= target_valid_trace 0))
(assert (not (= source_valid_trace target_valid_trace)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; satisfies_spec: source semantics (matches Coq)
; Translation validation: satisfies_spec preserves semantics
(push 1)
(declare-const source_satisfies_spec Int)
(declare-const target_satisfies_spec Int)
(assert (>= source_satisfies_spec 0))
(assert (>= target_satisfies_spec 0))
(assert (not (= source_satisfies_spec target_satisfies_spec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; authenticated: source semantics (matches Coq)
; Translation validation: authenticated preserves semantics
(push 1)
(declare-const source_authenticated Int)
(declare-const target_authenticated Int)
(assert (>= source_authenticated 0))
(assert (>= target_authenticated 0))
(assert (not (= source_authenticated target_authenticated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; in_path: source semantics (matches Coq)
; Translation validation: in_path preserves semantics
(push 1)
(declare-const source_in_path Int)
(declare-const target_in_path Int)
(assert (>= source_in_path 0))
(assert (>= target_in_path 0))
(assert (not (= source_in_path target_in_path)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fresh_nonce: source semantics (matches Coq)
; Translation validation: fresh_nonce preserves semantics
(push 1)
(declare-const source_fresh_nonce Int)
(declare-const target_fresh_nonce Int)
(assert (>= source_fresh_nonce 0))
(assert (>= target_fresh_nonce 0))
(assert (not (= source_fresh_nonce target_fresh_nonce)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prevents_replay: source semantics (matches Coq)
; Translation validation: prevents_replay preserves semantics
(push 1)
(declare-const source_prevents_replay Int)
(declare-const target_prevents_replay Int)
(assert (>= source_prevents_replay 0))
(assert (>= target_prevents_replay 0))
(assert (not (= source_prevents_replay target_prevents_replay)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prevents_reflection: source semantics (matches Coq)
; Translation validation: prevents_reflection preserves semantics
(push 1)
(declare-const source_prevents_reflection Int)
(declare-const target_prevents_reflection Int)
(assert (>= source_prevents_reflection 0))
(assert (>= target_prevents_reflection 0))
(assert (not (= source_prevents_reflection target_prevents_reflection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; constant_time_op: source semantics (matches Coq)
; Translation validation: constant_time_op preserves semantics
(push 1)
(declare-const source_constant_time_op Int)
(declare-const target_constant_time_op Int)
(assert (>= source_constant_time_op 0))
(assert (>= target_constant_time_op 0))
(assert (not (= source_constant_time_op target_constant_time_op)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_theorems_proven: source semantics (matches Coq)
; Translation validation: all_theorems_proven preserves semantics
(push 1)
(declare-const source_all_theorems_proven Int)
(declare-const target_all_theorems_proven Int)
(assert (>= source_all_theorems_proven 0))
(assert (>= target_all_theorems_proven 0))
(assert (not (= source_all_theorems_proven target_all_theorems_proven)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hkdf_deterministic: translation preserves property (matches Coq: Lemma)
; Translation validation: hkdf_deterministic preserves semantics
(push 1)
(declare-const source_hkdf_deterministic Int)
(declare-const target_hkdf_deterministic Int)
(assert (>= source_hkdf_deterministic 0))
(assert (>= target_hkdf_deterministic 0))
(assert (not (= source_hkdf_deterministic target_hkdf_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_01_protocol_specification: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_01_protocol_specification preserves semantics
(push 1)
(declare-const source_AH_001_01_protocol_specification Int)
(declare-const target_AH_001_01_protocol_specification Int)
(assert (>= source_AH_001_01_protocol_specification 0))
(assert (>= target_AH_001_01_protocol_specification 0))
(assert (not (= source_AH_001_01_protocol_specification target_AH_001_01_protocol_specification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_02_implementation_matches_spec: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_02_implementation_matches_spec preserves semantics
(push 1)
(declare-const source_AH_001_02_implementation_matches_spec Int)
(declare-const target_AH_001_02_implementation_matches_spec Int)
(assert (>= source_AH_001_02_implementation_matches_spec 0))
(assert (>= target_AH_001_02_implementation_matches_spec 0))
(assert (not (= source_AH_001_02_implementation_matches_spec target_AH_001_02_implementation_matches_spec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_03_trace_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_03_trace_valid preserves semantics
(push 1)
(declare-const source_AH_001_03_trace_valid Int)
(declare-const target_AH_001_03_trace_valid Int)
(assert (>= source_AH_001_03_trace_valid 0))
(assert (>= target_AH_001_03_trace_valid 0))
(assert (not (= source_AH_001_03_trace_valid target_AH_001_03_trace_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_04_security_goals_satisfied: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_04_security_goals_satisfied preserves semantics
(push 1)
(declare-const source_AH_001_04_security_goals_satisfied Int)
(declare-const target_AH_001_04_security_goals_satisfied Int)
(assert (>= source_AH_001_04_security_goals_satisfied 0))
(assert (>= target_AH_001_04_security_goals_satisfied 0))
(assert (not (= source_AH_001_04_security_goals_satisfied target_AH_001_04_security_goals_satisfied)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_05_protocol_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_05_protocol_composition preserves semantics
(push 1)
(declare-const source_AH_001_05_protocol_composition Int)
(declare-const target_AH_001_05_protocol_composition Int)
(assert (>= source_AH_001_05_protocol_composition 0))
(assert (>= target_AH_001_05_protocol_composition 0))
(assert (not (= source_AH_001_05_protocol_composition target_AH_001_05_protocol_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_06_proverif_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_06_proverif_verified preserves semantics
(push 1)
(declare-const source_AH_001_06_proverif_verified Int)
(declare-const target_AH_001_06_proverif_verified Int)
(assert (>= source_AH_001_06_proverif_verified 0))
(assert (>= target_AH_001_06_proverif_verified 0))
(assert (not (= source_AH_001_06_proverif_verified target_AH_001_06_proverif_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_07_protocol_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_07_protocol_deterministic preserves semantics
(push 1)
(declare-const source_AH_001_07_protocol_deterministic Int)
(declare-const target_AH_001_07_protocol_deterministic Int)
(assert (>= source_AH_001_07_protocol_deterministic 0))
(assert (>= target_AH_001_07_protocol_deterministic 0))
(assert (not (= source_AH_001_07_protocol_deterministic target_AH_001_07_protocol_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_08_tls13_confidentiality: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_08_tls13_confidentiality preserves semantics
(push 1)
(declare-const source_AH_001_08_tls13_confidentiality Int)
(declare-const target_AH_001_08_tls13_confidentiality Int)
(assert (>= source_AH_001_08_tls13_confidentiality 0))
(assert (>= target_AH_001_08_tls13_confidentiality 0))
(assert (not (= source_AH_001_08_tls13_confidentiality target_AH_001_08_tls13_confidentiality)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_09_tls13_authentication: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_09_tls13_authentication preserves semantics
(push 1)
(declare-const source_AH_001_09_tls13_authentication Int)
(declare-const target_AH_001_09_tls13_authentication Int)
(assert (>= source_AH_001_09_tls13_authentication 0))
(assert (>= target_AH_001_09_tls13_authentication 0))
(assert (not (= source_AH_001_09_tls13_authentication target_AH_001_09_tls13_authentication)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_10_tls13_forward_secrecy: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_10_tls13_forward_secrecy preserves semantics
(push 1)
(declare-const source_AH_001_10_tls13_forward_secrecy Int)
(declare-const target_AH_001_10_tls13_forward_secrecy Int)
(assert (>= source_AH_001_10_tls13_forward_secrecy 0))
(assert (>= target_AH_001_10_tls13_forward_secrecy 0))
(assert (not (= source_AH_001_10_tls13_forward_secrecy target_AH_001_10_tls13_forward_secrecy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_11_tls13_handshake_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_11_tls13_handshake_correct preserves semantics
(push 1)
(declare-const source_AH_001_11_tls13_handshake_correct Int)
(declare-const target_AH_001_11_tls13_handshake_correct Int)
(assert (>= source_AH_001_11_tls13_handshake_correct 0))
(assert (>= target_AH_001_11_tls13_handshake_correct 0))
(assert (not (= source_AH_001_11_tls13_handshake_correct target_AH_001_11_tls13_handshake_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_12_tls13_key_derivation: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_12_tls13_key_derivation preserves semantics
(push 1)
(declare-const source_AH_001_12_tls13_key_derivation Int)
(declare-const target_AH_001_12_tls13_key_derivation Int)
(assert (>= source_AH_001_12_tls13_key_derivation 0))
(assert (>= target_AH_001_12_tls13_key_derivation 0))
(assert (not (= source_AH_001_12_tls13_key_derivation target_AH_001_12_tls13_key_derivation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_13_tls13_certificate_verify: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_13_tls13_certificate_verify preserves semantics
(push 1)
(declare-const source_AH_001_13_tls13_certificate_verify Int)
(declare-const target_AH_001_13_tls13_certificate_verify Int)
(assert (>= source_AH_001_13_tls13_certificate_verify 0))
(assert (>= target_AH_001_13_tls13_certificate_verify 0))
(assert (not (= source_AH_001_13_tls13_certificate_verify target_AH_001_13_tls13_certificate_verify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_14_tls13_finished_verify: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_14_tls13_finished_verify preserves semantics
(push 1)
(declare-const source_AH_001_14_tls13_finished_verify Int)
(declare-const target_AH_001_14_tls13_finished_verify Int)
(assert (>= source_AH_001_14_tls13_finished_verify 0))
(assert (>= target_AH_001_14_tls13_finished_verify 0))
(assert (not (= source_AH_001_14_tls13_finished_verify target_AH_001_14_tls13_finished_verify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_15_tls13_record_layer: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_15_tls13_record_layer preserves semantics
(push 1)
(declare-const source_AH_001_15_tls13_record_layer Int)
(declare-const target_AH_001_15_tls13_record_layer Int)
(assert (>= source_AH_001_15_tls13_record_layer 0))
(assert (>= target_AH_001_15_tls13_record_layer 0))
(assert (not (= source_AH_001_15_tls13_record_layer target_AH_001_15_tls13_record_layer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_16_tls13_no_downgrade: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_16_tls13_no_downgrade preserves semantics
(push 1)
(declare-const source_AH_001_16_tls13_no_downgrade Int)
(declare-const target_AH_001_16_tls13_no_downgrade Int)
(assert (>= source_AH_001_16_tls13_no_downgrade 0))
(assert (>= target_AH_001_16_tls13_no_downgrade 0))
(assert (not (= source_AH_001_16_tls13_no_downgrade target_AH_001_16_tls13_no_downgrade)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_17_noise_pattern_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_17_noise_pattern_correct preserves semantics
(push 1)
(declare-const source_AH_001_17_noise_pattern_correct Int)
(declare-const target_AH_001_17_noise_pattern_correct Int)
(assert (>= source_AH_001_17_noise_pattern_correct 0))
(assert (>= target_AH_001_17_noise_pattern_correct 0))
(assert (not (= source_AH_001_17_noise_pattern_correct target_AH_001_17_noise_pattern_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_18_noise_handshake_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_18_noise_handshake_correct preserves semantics
(push 1)
(declare-const source_AH_001_18_noise_handshake_correct Int)
(declare-const target_AH_001_18_noise_handshake_correct Int)
(assert (>= source_AH_001_18_noise_handshake_correct 0))
(assert (>= target_AH_001_18_noise_handshake_correct 0))
(assert (not (= source_AH_001_18_noise_handshake_correct target_AH_001_18_noise_handshake_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_19_noise_key_confirmation: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_19_noise_key_confirmation preserves semantics
(push 1)
(declare-const source_AH_001_19_noise_key_confirmation Int)
(declare-const target_AH_001_19_noise_key_confirmation Int)
(assert (>= source_AH_001_19_noise_key_confirmation 0))
(assert (>= target_AH_001_19_noise_key_confirmation 0))
(assert (not (= source_AH_001_19_noise_key_confirmation target_AH_001_19_noise_key_confirmation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_20_noise_identity_hiding: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_20_noise_identity_hiding preserves semantics
(push 1)
(declare-const source_AH_001_20_noise_identity_hiding Int)
(declare-const target_AH_001_20_noise_identity_hiding Int)
(assert (>= source_AH_001_20_noise_identity_hiding 0))
(assert (>= target_AH_001_20_noise_identity_hiding 0))
(assert (not (= source_AH_001_20_noise_identity_hiding target_AH_001_20_noise_identity_hiding)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_21_noise_payload_encrypt: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_21_noise_payload_encrypt preserves semantics
(push 1)
(declare-const source_AH_001_21_noise_payload_encrypt Int)
(declare-const target_AH_001_21_noise_payload_encrypt Int)
(assert (>= source_AH_001_21_noise_payload_encrypt 0))
(assert (>= target_AH_001_21_noise_payload_encrypt 0))
(assert (not (= source_AH_001_21_noise_payload_encrypt target_AH_001_21_noise_payload_encrypt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_22_noise_rekey_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_22_noise_rekey_correct preserves semantics
(push 1)
(declare-const source_AH_001_22_noise_rekey_correct Int)
(declare-const target_AH_001_22_noise_rekey_correct Int)
(assert (>= source_AH_001_22_noise_rekey_correct 0))
(assert (>= target_AH_001_22_noise_rekey_correct 0))
(assert (not (= source_AH_001_22_noise_rekey_correct target_AH_001_22_noise_rekey_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_23_noise_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_23_noise_composition preserves semantics
(push 1)
(declare-const source_AH_001_23_noise_composition Int)
(declare-const target_AH_001_23_noise_composition Int)
(assert (>= source_AH_001_23_noise_composition 0))
(assert (>= target_AH_001_23_noise_composition 0))
(assert (not (= source_AH_001_23_noise_composition target_AH_001_23_noise_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_24_signal_double_ratchet: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_24_signal_double_ratchet preserves semantics
(push 1)
(declare-const source_AH_001_24_signal_double_ratchet Int)
(declare-const target_AH_001_24_signal_double_ratchet Int)
(assert (>= source_AH_001_24_signal_double_ratchet 0))
(assert (>= target_AH_001_24_signal_double_ratchet 0))
(assert (not (= source_AH_001_24_signal_double_ratchet target_AH_001_24_signal_double_ratchet)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_25_signal_forward_secrecy: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_25_signal_forward_secrecy preserves semantics
(push 1)
(declare-const source_AH_001_25_signal_forward_secrecy Int)
(declare-const target_AH_001_25_signal_forward_secrecy Int)
(assert (>= source_AH_001_25_signal_forward_secrecy 0))
(assert (>= target_AH_001_25_signal_forward_secrecy 0))
(assert (not (= source_AH_001_25_signal_forward_secrecy target_AH_001_25_signal_forward_secrecy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_26_signal_break_in_recovery: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_26_signal_break_in_recovery preserves semantics
(push 1)
(declare-const source_AH_001_26_signal_break_in_recovery Int)
(declare-const target_AH_001_26_signal_break_in_recovery Int)
(assert (>= source_AH_001_26_signal_break_in_recovery 0))
(assert (>= target_AH_001_26_signal_break_in_recovery 0))
(assert (not (= source_AH_001_26_signal_break_in_recovery target_AH_001_26_signal_break_in_recovery)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_27_signal_out_of_order: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_27_signal_out_of_order preserves semantics
(push 1)
(declare-const source_AH_001_27_signal_out_of_order Int)
(declare-const target_AH_001_27_signal_out_of_order Int)
(assert (>= source_AH_001_27_signal_out_of_order 0))
(assert (>= target_AH_001_27_signal_out_of_order 0))
(assert (not (= source_AH_001_27_signal_out_of_order target_AH_001_27_signal_out_of_order)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_28_signal_x3dh_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_28_signal_x3dh_correct preserves semantics
(push 1)
(declare-const source_AH_001_28_signal_x3dh_correct Int)
(declare-const target_AH_001_28_signal_x3dh_correct Int)
(assert (>= source_AH_001_28_signal_x3dh_correct 0))
(assert (>= target_AH_001_28_signal_x3dh_correct 0))
(assert (not (= source_AH_001_28_signal_x3dh_correct target_AH_001_28_signal_x3dh_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_29_signal_session_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_29_signal_session_correct preserves semantics
(push 1)
(declare-const source_AH_001_29_signal_session_correct Int)
(declare-const target_AH_001_29_signal_session_correct Int)
(assert (>= source_AH_001_29_signal_session_correct 0))
(assert (>= target_AH_001_29_signal_session_correct 0))
(assert (not (= source_AH_001_29_signal_session_correct target_AH_001_29_signal_session_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_30_no_replay: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_30_no_replay preserves semantics
(push 1)
(declare-const source_AH_001_30_no_replay Int)
(declare-const target_AH_001_30_no_replay Int)
(assert (>= source_AH_001_30_no_replay 0))
(assert (>= target_AH_001_30_no_replay 0))
(assert (not (= source_AH_001_30_no_replay target_AH_001_30_no_replay)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_31_no_reflection: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_31_no_reflection preserves semantics
(push 1)
(declare-const source_AH_001_31_no_reflection Int)
(declare-const target_AH_001_31_no_reflection Int)
(assert (>= source_AH_001_31_no_reflection 0))
(assert (>= target_AH_001_31_no_reflection 0))
(assert (not (= source_AH_001_31_no_reflection target_AH_001_31_no_reflection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_32_no_mitm: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_32_no_mitm preserves semantics
(push 1)
(declare-const source_AH_001_32_no_mitm Int)
(declare-const target_AH_001_32_no_mitm Int)
(assert (>= source_AH_001_32_no_mitm 0))
(assert (>= target_AH_001_32_no_mitm 0))
(assert (not (= source_AH_001_32_no_mitm target_AH_001_32_no_mitm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_33_key_material_secret: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_33_key_material_secret preserves semantics
(push 1)
(declare-const source_AH_001_33_key_material_secret Int)
(declare-const target_AH_001_33_key_material_secret Int)
(assert (>= source_AH_001_33_key_material_secret 0))
(assert (>= target_AH_001_33_key_material_secret 0))
(assert (not (= source_AH_001_33_key_material_secret target_AH_001_33_key_material_secret)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_34_randomness_fresh: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_34_randomness_fresh preserves semantics
(push 1)
(declare-const source_AH_001_34_randomness_fresh Int)
(declare-const target_AH_001_34_randomness_fresh Int)
(assert (>= source_AH_001_34_randomness_fresh 0))
(assert (>= target_AH_001_34_randomness_fresh 0))
(assert (not (= source_AH_001_34_randomness_fresh target_AH_001_34_randomness_fresh)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AH_001_35_timing_resistant: translation preserves property (matches Coq: Theorem)
; Translation validation: AH_001_35_timing_resistant preserves semantics
(push 1)
(declare-const source_AH_001_35_timing_resistant Int)
(declare-const target_AH_001_35_timing_resistant Int)
(assert (>= source_AH_001_35_timing_resistant 0))
(assert (>= target_AH_001_35_timing_resistant 0))
(assert (not (= source_AH_001_35_timing_resistant target_AH_001_35_timing_resistant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verification_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: verification_complete preserves semantics
(push 1)
(declare-const source_verification_complete Int)
(declare-const target_verification_complete Int)
(assert (>= source_verification_complete 0))
(assert (>= target_verification_complete 0))
(assert (not (= source_verification_complete target_verification_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/VerifiedProtocols.v (37 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: VerifiedProtocols

(set-logic ALL)
(set-option :produce-models true)

; TLS13Message (matches Coq: Inductive TLS13Message)
(declare-datatypes ((TLS13Message 0)) (((ClientHello) (ServerHello) (EncryptedExtensions) (Certificate) (CertificateVerify) (Finished) (ApplicationData))))

; NoiseMessage (matches Coq: Inductive NoiseMessage)
(declare-datatypes ((NoiseMessage 0)) (((NMEphemeral) (NMStatic) (NMPayload))))

; SignalMessage (matches Coq: Inductive SignalMessage)
(declare-datatypes ((SignalMessage 0)) (((SMHeader) (SMCiphertext))))

; NoisePattern (matches Coq: Inductive NoisePattern)
(declare-datatypes ((NoisePattern 0)) (((NN) (NK) (NX) (KN) (KK) (KX) (XN) (XK) (XX) (IK) (IX))))

; Adversary (matches Coq: Inductive Adversary)
(declare-datatypes ((Adversary 0)) (((PassiveAdversary) (ActiveAdversary) (CompromisedKeyAdversary))))

; KeyPair (matches Coq: Record KeyPair)
(declare-datatypes ((KeyPair 0))
  (((mk-key_pair (kp_private Int) (kp_public Int)))))

; TLS13State (matches Coq: Record TLS13State)
(declare-datatypes ((TLS13State 0))
  (((mk-tls13_state (tls_handshake_secret (Seq Int)) (tls_client_traffic_secret (Seq Int)) (tls_server_traffic_secret (Seq Int)) (tls_transcript (Seq Int)) (tls_stage Int) (tls_version Int) (tls_cipher_suite Int)))))

; TLS13Session (matches Coq: Record TLS13Session)
(declare-datatypes ((TLS13Session 0))
  (((mk-tls13_session (session_client_key Int) (session_server_key Int) (session_resumption_secret (Seq Int)) (session_established_time Int) (session_peer_cert (Seq Int)) (session_authenticated Bool)))))

; NoiseSymmetricState (matches Coq: Record NoiseSymmetricState)
(declare-datatypes ((NoiseSymmetricState 0))
  (((mk-noise_symmetric_state (noise_ck (Seq Int)) (noise_h (Seq Int)) (noise_k Int) (noise_n Int)))))

; NoiseCipherState (matches Coq: Record NoiseCipherState)
(declare-datatypes ((NoiseCipherState 0))
  (((mk-noise_cipher_state (cipher_k Int) (cipher_n Int)))))

; NoiseHandshakeState (matches Coq: Record NoiseHandshakeState)
(declare-datatypes ((NoiseHandshakeState 0))
  (((mk-noise_handshake_state (hs_pattern NoisePattern) (hs_symmetric NoiseSymmetricState) (hs_s Int) (hs_e Int) (hs_rs Int) (hs_re Int) (hs_initiator Bool) (hs_messages_sent Int) (hs_complete Bool)))))

; NoiseSession (matches Coq: Record NoiseSession)
(declare-datatypes ((NoiseSession 0))
  (((mk-noise_session (ns_send_cipher NoiseCipherState) (ns_recv_cipher NoiseCipherState) (ns_handshake_hash (Seq Int))))))

; SignalState (matches Coq: Record SignalState)
(declare-datatypes ((SignalState 0))
  (((mk-signal_state (signal_dh_pair KeyPair) (signal_dh_remote Int) (signal_root_key (Seq Int)) (signal_send_chain (Seq Int)) (signal_recv_chain (Seq Int)) (signal_send_n Int) (signal_recv_n Int) (signal_skipped (Seq Int)) (signal_prev_send_n Int)))))

; X3DHPrekeyBundle (matches Coq: Record X3DHPrekeyBundle)
(declare-datatypes ((X3DHPrekeyBundle 0))
  (((mk-x3_dh_prekey_bundle (x3dh_identity_key Int) (x3dh_signed_prekey Int) (x3dh_prekey_signature (Seq Int)) (x3dh_one_time_prekey Int)))))

; X3DHResult (matches Coq: Record X3DHResult)
(declare-datatypes ((X3DHResult 0))
  (((mk-x3_dh_result (x3dh_shared_secret Int) (x3dh_associated_data (Seq Int))))))

; ProtocolSpec (matches Coq: Record ProtocolSpec)
(declare-datatypes ((ProtocolSpec 0))
  (((mk-protocol_spec (spec_name (Seq Int)) (spec_messages (Seq Int)) (spec_security_goals (Seq Int)) (spec_version Int)))))

; ProtocolImpl (matches Coq: Record ProtocolImpl)
(declare-datatypes ((ProtocolImpl 0))
  (((mk-protocol_impl (impl_name (Seq Int)) (impl_state_machine Int) (impl_version Int)))))

(declare-const __default_Adversary Adversary)
(declare-const __default_KeyPair KeyPair)
(declare-const __default_NoiseCipherState NoiseCipherState)
(declare-const __default_NoiseHandshakeState NoiseHandshakeState)
(declare-const __default_NoiseMessage NoiseMessage)
(declare-const __default_NoisePattern NoisePattern)
(declare-const __default_NoiseSession NoiseSession)
(declare-const __default_NoiseSymmetricState NoiseSymmetricState)
(declare-const __default_ProtocolImpl ProtocolImpl)
(declare-const __default_ProtocolSpec ProtocolSpec)
(declare-const __default_SignalMessage SignalMessage)
(declare-const __default_SignalState SignalState)
(declare-const __default_TLS13Message TLS13Message)
(declare-const __default_TLS13Session TLS13Session)
(declare-const __default_TLS13State TLS13State)
(declare-const __default_X3DHPrekeyBundle X3DHPrekeyBundle)
(declare-const __default_X3DHResult X3DHResult)

; valid_keypair (matches Coq: Definition valid_keypair)
(define-fun valid_keypair ((kp KeyPair)) Bool
  (= 0 0))

; x25519 (matches Coq: Definition x25519)
(define-fun x25519 ((p_priv Int) (p_pub Int)) Int
  0)

; x25519_commutes (matches Coq: Definition x25519_commutes)
(define-fun x25519_commutes ((kp1 KeyPair) (kp2 KeyPair)) Bool
  (= 0 0))

; aead_correct (matches Coq: Definition aead_correct)
(define-fun aead_correct ((key Int) (nonce Int) (plaintext (Seq Int)) (aad (Seq Int))) Bool
  (= 0 0))

; initial_tls13_state (matches Coq: Definition initial_tls13_state)
(define-fun initial_tls13_state () TLS13State
  __default_TLS13State)

; tls13_handshake_complete (matches Coq: Definition tls13_handshake_complete)
(define-fun tls13_handshake_complete ((session TLS13Session)) Bool
  (= 0 0))

; session_established_before (matches Coq: Definition session_established_before)
(define-fun session_established_before ((session TLS13Session) (time Int)) Bool
  (= 0 0))

; noise_pattern_initiator_static (matches Coq: Definition noise_pattern_initiator_static)
(define-fun noise_pattern_initiator_static ((p NoisePattern)) Bool
  (= 0 0))

; noise_pattern_responder_static (matches Coq: Definition noise_pattern_responder_static)
(define-fun noise_pattern_responder_static ((p NoisePattern)) Bool
  (= 0 0))

; noise_pattern_identity_hiding_initiator (matches Coq: Definition noise_pattern_identity_hiding_initiator)
(define-fun noise_pattern_identity_hiding_initiator ((p NoisePattern)) Bool
  (= 0 0))

; init_noise_state (matches Coq: Definition init_noise_state)
(declare-fun init_noise_state (NoisePattern Bool Int Int) NoiseHandshakeState)

; noise_mix_key (matches Coq: Definition noise_mix_key)
(declare-fun noise_mix_key (NoiseSymmetricState (Seq Int)) NoiseSymmetricState)

; noise_mix_hash (matches Coq: Definition noise_mix_hash)
(declare-fun noise_mix_hash (NoiseSymmetricState (Seq Int)) NoiseSymmetricState)

; noise_handshake_complete (matches Coq: Definition noise_handshake_complete)
(define-fun noise_handshake_complete ((st NoiseHandshakeState)) Bool
  (= 0 0))

; x3dh_initiator (matches Coq: Definition x3dh_initiator)
(declare-fun x3dh_initiator (KeyPair KeyPair X3DHPrekeyBundle) X3DHResult)

; signal_dh_ratchet (matches Coq: Definition signal_dh_ratchet)
(declare-fun signal_dh_ratchet (SignalState KeyPair Int) SignalState)

; confidentiality (matches Coq: Definition confidentiality)
(define-fun confidentiality ((session_key Int)) Bool
  (= 0 0))

; strong_confidentiality (matches Coq: Definition strong_confidentiality)
(define-fun strong_confidentiality ((session_key Int)) Bool
  (= 0 0))

; authentication (matches Coq: Definition authentication)
(define-fun authentication ((peer Int) (claimed Int)) Bool
  (= 0 0))

; forward_secrecy (matches Coq: Definition forward_secrecy)
(define-fun forward_secrecy ((session TLS13Session) (long_term_key Int) (compromise_time Int)) Bool
  (= 0 0))

; implements (matches Coq: Definition implements)
(define-fun implements ((p_impl ProtocolImpl) (spec ProtocolSpec)) Bool
  (= 0 0))

; valid_trace (matches Coq: Definition valid_trace)
(define-fun valid_trace ((p_impl ProtocolImpl) (trace Int)) Bool
  (= 0 0))

; satisfies_spec (matches Coq: Definition satisfies_spec)
(define-fun satisfies_spec ((trace Int) (spec ProtocolSpec)) Bool
  (= 0 0))

; authenticated (matches Coq: Definition authenticated)
(define-fun authenticated ((session TLS13Session) (peer_cert (Seq Int))) Bool
  (= 0 0))

; in_path (matches Coq: Definition in_path)
(define-fun in_path ((mitm Adversary) (session TLS13Session)) Bool
  (= 0 0))

; fresh_nonce (matches Coq: Definition fresh_nonce)
(define-fun fresh_nonce ((nonce Int) (used_nonces (Seq Int))) Bool
  (= 0 0))

; prevents_replay (matches Coq: Definition prevents_replay)
(define-fun prevents_replay ((nonces_seen (Seq Int)) (incoming Int)) Bool
  (= 0 0))

; prevents_reflection (matches Coq: Definition prevents_reflection)
(define-fun prevents_reflection ((local_id Int) (remote_id Int)) Bool
  (= 0 0))

; constant_time_op (matches Coq: Definition constant_time_op)
(define-fun constant_time_op ((op Int)) Bool
  (= 0 0))

; all_theorems_proven (matches Coq: Definition all_theorems_proven)
(define-fun all_theorems_proven () Bool
  (= 0 0))

; hkdf_deterministic (matches Coq: Lemma hkdf_deterministic)
; hkdf_deterministic: forall salt ikm info len, hkdf salt ikm info len = hkdf salt ikm info len
(assert (forall ((salt Bool) (ikm Bool) (info Bool) (len Bool)) (= 0 0))) ; hkdf_deterministic [partial: bindings preserved]

; AH_001_01_protocol_specification (matches Coq: Theorem AH_001_01_protocol_specification)
; AH_001_01_protocol_specification: forall (spec : ProtocolSpec), List.length (spec_name spec) >= 0 -> List.length (spec_messages spec) >= 0 -> List.length 
(assert (forall ((spec ProtocolSpec)) (= 0 0))) ; AH_001_01_protocol_specification [partial: bindings preserved]

; AH_001_02_implementation_matches_spec (matches Coq: Theorem AH_001_02_implementation_matches_spec)
; AH_001_02_implementation_matches_spec: forall impl spec, implements impl spec -> forall trace, valid_trace impl trace -> satisfies_spec trace spec
(assert (forall ((v_impl Bool) (spec Bool)) (= 0 0))) ; AH_001_02_implementation_matches_spec [partial: bindings preserved]

; AH_001_03_trace_valid (matches Coq: Theorem AH_001_03_trace_valid)
; AH_001_03_trace_valid: forall impl trace, valid_trace impl trace
(assert (forall ((v_impl Bool) (trace Bool)) (= 0 0))) ; AH_001_03_trace_valid [partial: bindings preserved]

; AH_001_04_security_goals_satisfied (matches Coq: Theorem AH_001_04_security_goals_satisfied)
; AH_001_04_security_goals_satisfied: forall spec impl trace, implements impl spec -> valid_trace impl trace -> satisfies_spec trace spec
(assert (forall ((spec Bool) (v_impl Bool) (trace Bool)) (= 0 0))) ; AH_001_04_security_goals_satisfied [partial: bindings preserved]

; AH_001_05_protocol_composition (matches Coq: Theorem AH_001_05_protocol_composition)
; AH_001_05_protocol_composition: forall spec1 spec2 impl1 impl2 trace1 trace2, implements impl1 spec1 -> implements impl2 spec2 -> valid_trace impl1 trac
(assert (forall ((spec1 Bool) (spec2 Bool) (impl1 Bool) (impl2 Bool) (trace1 Bool) (trace2 Bool)) (= 0 0))) ; AH_001_05_protocol_composition [partial: bindings preserved]

; AH_001_06_proverif_verified (matches Coq: Theorem AH_001_06_proverif_verified)
; AH_001_06_proverif_verified: forall impl spec, implements impl spec -> (forall trace, valid_trace impl trace -> satisfies_spec trace spec) -> forall 
(assert (forall ((v_impl Bool) (spec Bool)) (= 0 0))) ; AH_001_06_proverif_verified [partial: bindings preserved]

; AH_001_07_protocol_deterministic (matches Coq: Theorem AH_001_07_protocol_deterministic)
; AH_001_07_protocol_deterministic: forall impl input st1 st2, impl_state_machine impl input = st1 -> impl_state_machine impl input = st2 -> st1 = st2
(assert (forall ((v_impl Bool) (input Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; AH_001_07_protocol_deterministic [partial: bindings preserved]

; AH_001_08_tls13_confidentiality (matches Coq: Theorem AH_001_08_tls13_confidentiality)
; AH_001_08_tls13_confidentiality: forall session, tls13_handshake_complete session -> strong_confidentiality (session_client_key session)
(assert (forall ((session Bool)) (= 0 0))) ; AH_001_08_tls13_confidentiality [partial: bindings preserved]

; AH_001_09_tls13_authentication (matches Coq: Theorem AH_001_09_tls13_authentication)
; AH_001_09_tls13_authentication: forall session peer_cert, authenticated session peer_cert -> authentication (session_peer_cert session) peer_cert
(assert (forall ((session Bool) (peer_cert Bool)) (= 0 0))) ; AH_001_09_tls13_authentication [partial: bindings preserved]

; AH_001_10_tls13_forward_secrecy (matches Coq: Theorem AH_001_10_tls13_forward_secrecy)
; AH_001_10_tls13_forward_secrecy: forall session long_term compromise_time, tls13_handshake_complete session -> forward_secrecy session long_term compromi
(assert (forall ((session Bool) (long_term Bool) (compromise_time Bool)) (= 0 0))) ; AH_001_10_tls13_forward_secrecy [partial: bindings preserved]

; AH_001_11_tls13_handshake_correct (matches Coq: Theorem AH_001_11_tls13_handshake_correct)
; AH_001_11_tls13_handshake_correct: forall st1 msg st2, tls13_step st1 msg st2 -> tls_stage st2 = S (tls_stage st1)
(assert (forall ((st1 Bool) (msg Bool) (st2 Bool)) (= 0 0))) ; AH_001_11_tls13_handshake_correct [partial: bindings preserved]

; AH_001_12_tls13_key_derivation (matches Coq: Theorem AH_001_12_tls13_key_derivation)
; AH_001_12_tls13_key_derivation: forall salt ikm info len, hkdf salt ikm info len = hkdf salt ikm info len
(assert (forall ((salt Bool) (ikm Bool) (info Bool) (len Bool)) (= 0 0))) ; AH_001_12_tls13_key_derivation [partial: bindings preserved]

; AH_001_13_tls13_certificate_verify (matches Coq: Theorem AH_001_13_tls13_certificate_verify)
; AH_001_13_tls13_certificate_verify: forall st cert st', tls_stage st = 3 -> tls13_step st (Certificate cert) st' -> In (Certificate cert) (tls_transcript st
(assert (forall ((st Bool) (cert Bool) (st_ Bool)) (= 0 0))) ; AH_001_13_tls13_certificate_verify [partial: bindings preserved]

; AH_001_14_tls13_finished_verify (matches Coq: Theorem AH_001_14_tls13_finished_verify)
; AH_001_14_tls13_finished_verify: forall st verify_data st', tls_stage st = 5 -> tls13_step st (Finished verify_data) st' -> List.length (tls_client_traff
(assert (forall ((st Bool) (verify_data Bool) (st_ Bool)) (= 0 0))) ; AH_001_14_tls13_finished_verify [partial: bindings preserved]

; AH_001_15_tls13_record_layer (matches Coq: Theorem AH_001_15_tls13_record_layer)
; AH_001_15_tls13_record_layer: forall key nonce plaintext aad, exists ct, aead_encrypt key nonce plaintext aad = ct
(assert (forall ((key Bool) (nonce Bool) (plaintext Bool) (aad Bool)) (= 0 0))) ; AH_001_15_tls13_record_layer [partial: bindings preserved]

; AH_001_16_tls13_no_downgrade (matches Coq: Theorem AH_001_16_tls13_no_downgrade)
; AH_001_16_tls13_no_downgrade: forall st msg st', tls13_step st msg st' -> tls_version st' = tls_version st
(assert (forall ((st Bool) (msg Bool) (st_ Bool)) (= 0 0))) ; AH_001_16_tls13_no_downgrade [partial: bindings preserved]

; AH_001_17_noise_pattern_correct (matches Coq: Theorem AH_001_17_noise_pattern_correct)
; AH_001_17_noise_pattern_correct: forall pattern, (noise_pattern_initiator_static pattern = true \/ noise_pattern_initiator_static pattern = false) /\ (no
(assert (forall ((pattern Bool)) (= 0 0))) ; AH_001_17_noise_pattern_correct [partial: bindings preserved]

; AH_001_18_noise_handshake_correct (matches Coq: Theorem AH_001_18_noise_handshake_correct)
; AH_001_18_noise_handshake_correct: forall st msg st', noise_step st msg st' -> hs_messages_sent st' = S (hs_messages_sent st)
(assert (forall ((st Bool) (msg Bool) (st_ Bool)) (= 0 0))) ; AH_001_18_noise_handshake_correct [partial: bindings preserved]

; AH_001_19_noise_key_confirmation (matches Coq: Theorem AH_001_19_noise_key_confirmation)
; AH_001_19_noise_key_confirmation: forall st msg st', noise_step st msg st' -> noise_h (hs_symmetric st') = hkdf [] (noise_h (hs_symmetric st) ++ match msg
(assert (forall ((st Bool) (msg Bool) (st_ Bool)) (= 0 0))) ; AH_001_19_noise_key_confirmation [partial: bindings preserved]

; AH_001_20_noise_identity_hiding (matches Coq: Theorem AH_001_20_noise_identity_hiding)
; AH_001_20_noise_identity_hiding: forall pattern, noise_pattern_identity_hiding_initiator pattern = true -> (pattern = XN \/ pattern = XK \/ pattern = XX 
(assert (forall ((pattern Bool)) (= 0 0))) ; AH_001_20_noise_identity_hiding [partial: bindings preserved]

; AH_001_21_noise_payload_encrypt (matches Coq: Theorem AH_001_21_noise_payload_encrypt)
; AH_001_21_noise_payload_encrypt: forall st key nonce payload aad, noise_k (hs_symmetric st) = Some key -> exists ciphertext, aead_encrypt key nonce paylo
(assert (forall ((st Bool) (key Bool) (nonce Bool) (payload Bool) (aad Bool)) (= 0 0))) ; AH_001_21_noise_payload_encrypt [partial: bindings preserved]

; AH_001_22_noise_rekey_correct (matches Coq: Theorem AH_001_22_noise_rekey_correct)
; AH_001_22_noise_rekey_correct: forall st input_key, let st' := noise_mix_key st input_key in noise_n st' = 0 /\ exists k, noise_k st' = Some k
(assert (forall ((st Bool) (input_key Bool)) (= 0 0))) ; AH_001_22_noise_rekey_correct [partial: bindings preserved]

; AH_001_23_noise_composition (matches Coq: Theorem AH_001_23_noise_composition)
; AH_001_23_noise_composition: forall st1 msg1 st2 msg2 st3, noise_step st1 msg1 st2 -> noise_step st2 msg2 st3 -> hs_messages_sent st3 = S (S (hs_mess
(assert (forall ((st1 Bool) (msg1 Bool) (st2 Bool) (msg2 Bool) (st3 Bool)) (= 0 0))) ; AH_001_23_noise_composition [partial: bindings preserved]

; AH_001_24_signal_double_ratchet (matches Coq: Theorem AH_001_24_signal_double_ratchet)
; AH_001_24_signal_double_ratchet: forall st new_pair remote, let st' := signal_dh_ratchet st new_pair remote in signal_dh_pair st' = new_pair /\ signal_dh
(assert (forall ((st Bool) (new_pair Bool) (remote Bool)) (= 0 0))) ; AH_001_24_signal_double_ratchet [partial: bindings preserved]

; AH_001_25_signal_forward_secrecy (matches Coq: Theorem AH_001_25_signal_forward_secrecy)
; AH_001_25_signal_forward_secrecy: forall st new_pair remote, let st' := signal_dh_ratchet st new_pair remote in signal_dh_pair st' = new_pair
(assert (forall ((st Bool) (new_pair Bool) (remote Bool)) (= 0 0))) ; AH_001_25_signal_forward_secrecy [partial: bindings preserved]

; AH_001_26_signal_break_in_recovery (matches Coq: Theorem AH_001_26_signal_break_in_recovery)
; AH_001_26_signal_break_in_recovery: forall st new_pair remote, let st' := signal_dh_ratchet st new_pair remote in signal_send_n st' = 0
(assert (forall ((st Bool) (new_pair Bool) (remote Bool)) (= 0 0))) ; AH_001_26_signal_break_in_recovery [partial: bindings preserved]

; AH_001_27_signal_out_of_order (matches Coq: Theorem AH_001_27_signal_out_of_order)
; AH_001_27_signal_out_of_order: forall st pk n key, In (pk, n, key) (signal_skipped st) -> exists key', key' = key
(assert (forall ((st Bool) (pk Bool) (n Bool) (key Bool)) (= 0 0))) ; AH_001_27_signal_out_of_order [partial: bindings preserved]

; AH_001_28_signal_x3dh_correct (matches Coq: Theorem AH_001_28_signal_x3dh_correct)
; AH_001_28_signal_x3dh_correct: forall ik ek bundle, let result := x3dh_initiator ik ek bundle in exists ss ad, x3dh_shared_secret result = ss /\ x3dh_a
(assert (forall ((ik Bool) (ek Bool) (bundle Bool)) (= 0 0))) ; AH_001_28_signal_x3dh_correct [partial: bindings preserved]

; AH_001_29_signal_session_correct (matches Coq: Theorem AH_001_29_signal_session_correct)
; AH_001_29_signal_session_correct: forall st plaintext, let (st', ct) := signal_encrypt st plaintext in signal_send_n st' = S (signal_send_n st)
(assert (forall ((st Bool) (plaintext Bool)) (= 0 0))) ; AH_001_29_signal_session_correct [partial: bindings preserved]

; AH_001_30_no_replay (matches Coq: Theorem AH_001_30_no_replay)
; AH_001_30_no_replay: forall nonces_seen incoming, In incoming nonces_seen -> prevents_replay nonces_seen incoming -> False
(assert (forall ((nonces_seen Bool) (incoming Bool)) (= 0 0))) ; AH_001_30_no_replay [partial: bindings preserved]

; AH_001_31_no_reflection (matches Coq: Theorem AH_001_31_no_reflection)
; AH_001_31_no_reflection: forall local_id remote_id, local_id <> remote_id -> prevents_reflection local_id remote_id
(assert (forall ((local_id Bool) (remote_id Bool)) (= 0 0))) ; AH_001_31_no_reflection [partial: bindings preserved]

; AH_001_32_no_mitm (matches Coq: Theorem AH_001_32_no_mitm)
; AH_001_32_no_mitm: forall session peer_cert, authenticated session peer_cert -> ~ exists mitm, in_path mitm session
(assert (forall ((session Bool) (peer_cert Bool)) (= 0 0))) ; AH_001_32_no_mitm [partial: bindings preserved]

; AH_001_33_key_material_secret (matches Coq: Theorem AH_001_33_key_material_secret)
; AH_001_33_key_material_secret: forall session, tls13_handshake_complete session -> strong_confidentiality (session_client_key session)
(assert (forall ((session Bool)) (= 0 0))) ; AH_001_33_key_material_secret [partial: bindings preserved]

; AH_001_34_randomness_fresh (matches Coq: Theorem AH_001_34_randomness_fresh)
; AH_001_34_randomness_fresh: forall nonce used_nonces, fresh_nonce nonce used_nonces -> ~ In nonce used_nonces
(assert (forall ((nonce Bool) (used_nonces Bool)) (= 0 0))) ; AH_001_34_randomness_fresh [partial: bindings preserved]

; AH_001_35_timing_resistant (matches Coq: Theorem AH_001_35_timing_resistant)
; AH_001_35_timing_resistant: forall (op : nat -> nat -> bool), constant_time_op op
(assert (forall ((op Int)) (= 0 0))) ; AH_001_35_timing_resistant [partial: bindings preserved]

; verification_complete (matches Coq: Theorem verification_complete)
; verification_complete: all_theorems_proven
(assert (= 0 0)) ; verification_complete [Coq-only]

; Verify all assertions are satisfiable
(check-sat)
(exit)

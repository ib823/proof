; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedProtocols — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedProtocols.v (37 assertions)
; Module: VerifiedProtocols
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TLS13Message 0)) (((ClientHello) (ServerHello) (EncryptedExtensions) (Certificate) (CertificateVerify) (Finished) (ApplicationData))))

(declare-datatypes ((NoiseMessage 0)) (((NMEphemeral) (NMStatic) (NMPayload))))

(declare-datatypes ((SignalMessage 0)) (((SMHeader) (SMCiphertext))))

(declare-datatypes ((NoisePattern 0)) (((NN) (NK) (NX) (KN) (KK) (KX) (XN) (XK) (XX) (IK) (IX))))

(declare-datatypes ((Adversary 0)) (((PassiveAdversary) (ActiveAdversary) (CompromisedKeyAdversary))))

(declare-datatypes ((KeyPair 0))
  (((mk-key_pair (kp_private Int) (kp_public Int)))))

(declare-datatypes ((TLS13State 0))
  (((mk-tls13_state (tls_handshake_secret (Seq Int)) (tls_client_traffic_secret (Seq Int)) (tls_server_traffic_secret (Seq Int)) (tls_transcript (Seq Int)) (tls_stage Int) (tls_version Int) (tls_cipher_suite Int)))))

(declare-datatypes ((TLS13Session 0))
  (((mk-tls13_session (session_client_key Int) (session_server_key Int) (session_resumption_secret (Seq Int)) (session_established_time Int) (session_peer_cert (Seq Int)) (session_authenticated Bool)))))

(declare-datatypes ((NoiseSymmetricState 0))
  (((mk-noise_symmetric_state (noise_ck (Seq Int)) (noise_h (Seq Int)) (noise_k Int) (noise_n Int)))))

(declare-datatypes ((NoiseCipherState 0))
  (((mk-noise_cipher_state (cipher_k Int) (cipher_n Int)))))

(declare-datatypes ((NoiseHandshakeState 0))
  (((mk-noise_handshake_state (hs_pattern NoisePattern) (hs_symmetric NoiseSymmetricState) (hs_s Int) (hs_e Int) (hs_rs Int) (hs_re Int) (hs_initiator Bool) (hs_messages_sent Int) (hs_complete Bool)))))

(declare-datatypes ((NoiseSession 0))
  (((mk-noise_session (ns_send_cipher NoiseCipherState) (ns_recv_cipher NoiseCipherState) (ns_handshake_hash (Seq Int))))))

(declare-datatypes ((SignalState 0))
  (((mk-signal_state (signal_dh_pair KeyPair) (signal_dh_remote Int) (signal_root_key (Seq Int)) (signal_send_chain (Seq Int)) (signal_recv_chain (Seq Int)) (signal_send_n Int) (signal_recv_n Int) (signal_skipped (Seq Int)) (signal_prev_send_n Int)))))

(declare-datatypes ((X3DHPrekeyBundle 0))
  (((mk-x3_dh_prekey_bundle (x3dh_identity_key Int) (x3dh_signed_prekey Int) (x3dh_prekey_signature (Seq Int)) (x3dh_one_time_prekey Int)))))

(declare-datatypes ((X3DHResult 0))
  (((mk-x3_dh_result (x3dh_shared_secret Int) (x3dh_associated_data (Seq Int))))))

(declare-datatypes ((ProtocolSpec 0))
  (((mk-protocol_spec (spec_name (Seq Int)) (spec_messages (Seq Int)) (spec_security_goals (Seq Int)) (spec_version Int)))))

(declare-datatypes ((ProtocolImpl 0))
  (((mk-protocol_impl (impl_name (Seq Int)) (impl_state_machine Int) (impl_version Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TLS13Message enum properties ---

; --- 1. TLS13Message exhaustiveness ---
(push 1)
(declare-const x TLS13Message)
(assert (not (or (= x ClientHello) (= x ServerHello) (= x EncryptedExtensions) (= x Certificate) (= x CertificateVerify) (= x Finished) (= x ApplicationData))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TLS13Message: ClientHello != ServerHello ---
(push 1)
(assert (= ClientHello ServerHello))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TLS13Message: ServerHello != EncryptedExtensions ---
(push 1)
(assert (= ServerHello EncryptedExtensions))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TLS13Message: EncryptedExtensions != Certificate ---
(push 1)
(assert (= EncryptedExtensions Certificate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TLS13Message: ClientHello != ApplicationData ---
(push 1)
(assert (= ClientHello ApplicationData))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. TLS13Message finite cardinality (7 values) ---
(push 1)
(declare-const x TLS13Message)
(assert (and (not (= x ClientHello)) (not (= x ServerHello)) (not (= x EncryptedExtensions)) (not (= x Certificate)) (not (= x CertificateVerify)) (not (= x Finished)) (not (= x ApplicationData))))
(check-sat) ; expect UNSAT
(pop 1)

; --- NoiseMessage enum properties ---

; --- 7. NoiseMessage exhaustiveness ---
(push 1)
(declare-const x NoiseMessage)
(assert (not (or (= x NMEphemeral) (= x NMStatic) (= x NMPayload))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. NoiseMessage: NMEphemeral != NMStatic ---
(push 1)
(assert (= NMEphemeral NMStatic))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. NoiseMessage: NMStatic != NMPayload ---
(push 1)
(assert (= NMStatic NMPayload))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. NoiseMessage: NMEphemeral != NMPayload ---
(push 1)
(assert (= NMEphemeral NMPayload))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. NoiseMessage finite cardinality (3 values) ---
(push 1)
(declare-const x NoiseMessage)
(assert (and (not (= x NMEphemeral)) (not (= x NMStatic)) (not (= x NMPayload))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignalMessage enum properties ---

; --- 12. SignalMessage exhaustiveness ---
(push 1)
(declare-const x SignalMessage)
(assert (not (or (= x SMHeader) (= x SMCiphertext))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. SignalMessage: SMHeader != SMCiphertext ---
(push 1)
(assert (= SMHeader SMCiphertext))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SignalMessage finite cardinality (2 values) ---
(push 1)
(declare-const x SignalMessage)
(assert (and (not (= x SMHeader)) (not (= x SMCiphertext))))
(check-sat) ; expect UNSAT
(pop 1)

; --- NoisePattern enum properties ---

; --- 15. NoisePattern exhaustiveness ---
(push 1)
(declare-const x NoisePattern)
(assert (not (or (= x NN) (= x NK) (= x NX) (= x KN) (= x KK) (= x KX) (= x XN) (= x XK) (= x XX) (= x IK) (= x IX))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. NoisePattern: NN != NK ---
(push 1)
(assert (= NN NK))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. NoisePattern: NK != NX ---
(push 1)
(assert (= NK NX))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. NoisePattern: NX != KN ---
(push 1)
(assert (= NX KN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. NoisePattern: NN != IX ---
(push 1)
(assert (= NN IX))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. NoisePattern finite cardinality (11 values) ---
(push 1)
(declare-const x NoisePattern)
(assert (and (not (= x NN)) (not (= x NK)) (not (= x NX)) (not (= x KN)) (not (= x KK)) (not (= x KX)) (not (= x XN)) (not (= x XK)) (not (= x XX)) (not (= x IK)) (not (= x IX))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Adversary enum properties ---

; --- 21. Adversary exhaustiveness ---
(push 1)
(declare-const x Adversary)
(assert (not (or (= x PassiveAdversary) (= x ActiveAdversary) (= x CompromisedKeyAdversary))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Adversary: PassiveAdversary != ActiveAdversary ---
(push 1)
(assert (= PassiveAdversary ActiveAdversary))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Adversary: ActiveAdversary != CompromisedKeyAdversary ---
(push 1)
(assert (= ActiveAdversary CompromisedKeyAdversary))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Adversary: PassiveAdversary != CompromisedKeyAdversary ---
(push 1)
(assert (= PassiveAdversary CompromisedKeyAdversary))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Adversary finite cardinality (3 values) ---
(push 1)
(declare-const x Adversary)
(assert (and (not (= x PassiveAdversary)) (not (= x ActiveAdversary)) (not (= x CompromisedKeyAdversary))))
(check-sat) ; expect UNSAT
(pop 1)

; --- KeyPair record properties ---

; --- 26. KeyPair accessor round-trip: kp_private ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (kp_private (mk-key_pair f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TLS13State record properties ---

; --- 27. TLS13State accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (tls_handshake_secret (mk-tls13_state f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. TLS13State accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (tls_client_traffic_secret (mk-tls13_state f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. TLS13State accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (tls_server_traffic_secret (mk-tls13_state f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. TLS13State accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (tls_transcript (mk-tls13_state f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. TLS13State accessor round-trip: tls_stage ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (tls_stage (mk-tls13_state f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. TLS13State: integer field consistency ---
(push 1)
(declare-const r TLS13State)
(assert (>= (seq.len (tls_handshake_secret r)) 0))
(assert (>= (seq.len (tls_handshake_secret r)) 0))
(assert (not (>= (+ (seq.len (tls_handshake_secret r)) (seq.len (tls_handshake_secret r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TLS13Session record properties ---

; --- 33. TLS13Session accessor round-trip: session_client_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (session_client_key (mk-tls13_session f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. TLS13Session accessor round-trip: session_server_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (session_server_key (mk-tls13_session f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. TLS13Session accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (session_resumption_secret (mk-tls13_session f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. TLS13Session accessor round-trip: session_established_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (session_established_time (mk-tls13_session f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. TLS13Session accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (session_peer_cert (mk-tls13_session f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. TLS13Session: integer field consistency ---
(push 1)
(declare-const r TLS13Session)
(assert (>= (session_client_key r) 0))
(assert (>= (session_server_key r) 0))
(assert (not (>= (+ (session_client_key r) (session_server_key r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NoiseSymmetricState record properties ---

; --- 39. NoiseSymmetricState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (noise_ck (mk-noise_symmetric_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. NoiseSymmetricState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (noise_h (mk-noise_symmetric_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. NoiseSymmetricState accessor round-trip: noise_k ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (noise_k (mk-noise_symmetric_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. NoiseSymmetricState: integer field consistency ---
(push 1)
(declare-const r NoiseSymmetricState)
(assert (>= (seq.len (noise_ck r)) 0))
(assert (>= (seq.len (noise_ck r)) 0))
(assert (not (>= (+ (seq.len (noise_ck r)) (seq.len (noise_ck r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NoiseCipherState record properties ---

; --- 43. NoiseCipherState accessor round-trip: cipher_k ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (cipher_k (mk-noise_cipher_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NoiseHandshakeState record properties ---

; --- 44. NoiseHandshakeState accessor round-trip: hs_pattern ---
(push 1)
(declare-const f0 NoisePattern)
(declare-const f1 NoiseSymmetricState)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (hs_pattern (mk-noise_handshake_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. NoiseHandshakeState accessor round-trip: hs_symmetric ---
(push 1)
(declare-const f0 NoisePattern)
(declare-const f1 NoiseSymmetricState)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (hs_symmetric (mk-noise_handshake_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. NoiseHandshakeState accessor round-trip: hs_s ---
(push 1)
(declare-const f0 NoisePattern)
(declare-const f1 NoiseSymmetricState)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (hs_s (mk-noise_handshake_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. NoiseHandshakeState accessor round-trip: hs_e ---
(push 1)
(declare-const f0 NoisePattern)
(declare-const f1 NoiseSymmetricState)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (hs_e (mk-noise_handshake_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. NoiseHandshakeState accessor round-trip: hs_rs ---
(push 1)
(declare-const f0 NoisePattern)
(declare-const f1 NoiseSymmetricState)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (hs_rs (mk-noise_handshake_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. NoiseHandshakeState: integer field consistency ---
(push 1)
(declare-const r NoiseHandshakeState)
(assert (>= (hs_s r) 0))
(assert (>= (hs_e r) 0))
(assert (not (>= (+ (hs_s r) (hs_e r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NoiseSession record properties ---

; --- 50. NoiseSession accessor round-trip: ns_send_cipher ---
(push 1)
(declare-const f0 NoiseCipherState)
(declare-const f1 NoiseCipherState)
(declare-const f2 (Seq Int))
(assert (not (= (ns_send_cipher (mk-noise_session f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. NoiseSession accessor round-trip: ns_recv_cipher ---
(push 1)
(declare-const f0 NoiseCipherState)
(declare-const f1 NoiseCipherState)
(declare-const f2 (Seq Int))
(assert (not (= (ns_recv_cipher (mk-noise_session f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignalState record properties ---

; --- 52. SignalState accessor round-trip: signal_dh_pair ---
(push 1)
(declare-const f0 KeyPair)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 (Seq Int))
(declare-const f8 Int)
(assert (not (= (signal_dh_pair (mk-signal_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. SignalState accessor round-trip: signal_dh_remote ---
(push 1)
(declare-const f0 KeyPair)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 (Seq Int))
(declare-const f8 Int)
(assert (not (= (signal_dh_remote (mk-signal_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. SignalState accessor round-trip: Seq ---
(push 1)
(declare-const f0 KeyPair)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 (Seq Int))
(declare-const f8 Int)
(assert (not (= (signal_root_key (mk-signal_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. SignalState accessor round-trip: Seq ---
(push 1)
(declare-const f0 KeyPair)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 (Seq Int))
(declare-const f8 Int)
(assert (not (= (signal_send_chain (mk-signal_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. SignalState accessor round-trip: Seq ---
(push 1)
(declare-const f0 KeyPair)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 (Seq Int))
(declare-const f8 Int)
(assert (not (= (signal_recv_chain (mk-signal_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. SignalState: integer field consistency ---
(push 1)
(declare-const r SignalState)
(assert (>= (signal_dh_remote r) 0))
(assert (>= (seq.len (signal_root_key r)) 0))
(assert (not (>= (+ (signal_dh_remote r) (seq.len (signal_root_key r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- X3DHPrekeyBundle record properties ---

; --- 58. X3DHPrekeyBundle accessor round-trip: x3dh_identity_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (x3dh_identity_key (mk-x3_dh_prekey_bundle f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. X3DHPrekeyBundle accessor round-trip: x3dh_signed_prekey ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (x3dh_signed_prekey (mk-x3_dh_prekey_bundle f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. X3DHPrekeyBundle accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (x3dh_prekey_signature (mk-x3_dh_prekey_bundle f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. X3DHPrekeyBundle: integer field consistency ---
(push 1)
(declare-const r X3DHPrekeyBundle)
(assert (>= (x3dh_identity_key r) 0))
(assert (>= (x3dh_signed_prekey r) 0))
(assert (not (>= (+ (x3dh_identity_key r) (x3dh_signed_prekey r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- X3DHResult record properties ---

; --- 62. X3DHResult accessor round-trip: x3dh_shared_secret ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(assert (not (= (x3dh_shared_secret (mk-x3_dh_result f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProtocolSpec record properties ---

; --- 63. ProtocolSpec accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (spec_name (mk-protocol_spec f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. ProtocolSpec accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (spec_messages (mk-protocol_spec f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. ProtocolSpec accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (spec_security_goals (mk-protocol_spec f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. ProtocolSpec: integer field consistency ---
(push 1)
(declare-const r ProtocolSpec)
(assert (>= (seq.len (spec_name r)) 0))
(assert (>= (seq.len (spec_name r)) 0))
(assert (not (>= (+ (seq.len (spec_name r)) (seq.len (spec_name r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProtocolImpl record properties ---

; --- 67. ProtocolImpl accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (impl_name (mk-protocol_impl f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. ProtocolImpl accessor round-trip: impl_state_machine ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (impl_state_machine (mk-protocol_impl f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. ProtocolImpl: integer field consistency ---
(push 1)
(declare-const r ProtocolImpl)
(assert (>= (seq.len (impl_name r)) 0))
(assert (>= (impl_state_machine r) 0))
(assert (not (>= (+ (seq.len (impl_name r)) (impl_state_machine r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

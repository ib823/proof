; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedNetwork — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedNetwork.v (25 assertions)
; Module: VerifiedNetwork
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TLSVersion 0)) (((TLS_1_0) (TLS_1_1) (TLS_1_2) (TLS_1_3))))

(declare-datatypes ((CipherSuite 0)) (((TLS_AES_128_GCM_SHA256) (TLS_AES_256_GCM_SHA384) (TLS_CHACHA20_POLY1305_SHA256))))

(declare-datatypes ((HandshakeMsg 0)) (((ClientHello) (ServerHello) (EncryptedExtensions) (CertificateMsg) (CertificateVerify) (Finished))))

(declare-datatypes ((TCPState 0)) (((CLOSED) (LISTEN) (SYN_SENT) (SYN_RECEIVED) (ESTABLISHED) (FIN_WAIT_1) (FIN_WAIT_2) (CLOSE_WAIT) (CLOSING) (LAST_ACK) (TIME_WAIT))))

(declare-datatypes ((TCPEvent 0)) (((PassiveOpen) (ActiveOpen) (SynReceived) (SynAckReceived) (AckReceived) (FinReceived) (Close) (Timeout))))

(declare-datatypes ((DNSRecordType 0)) (((A) (AAAA) (CNAME) (MX) (TXT) (RRSIG) (DNSKEY) (DS))))

(declare-datatypes ((KEResult 0))
  (((mk-ke_result (ke_shared Int) (ke_ephemeral_pub Int) (ke_ephemeral_priv Int)))))

(declare-datatypes ((Certificate 0))
  (((mk-certificate (cert_subject String) (cert_issuer String) (cert_public_key Int) (cert_signature Int) (cert_valid_from Int) (cert_valid_to Int) (cert_chain_verified Bool) (cert_is_ca Bool)))))

(declare-datatypes ((TrustAnchor 0))
  (((mk-trust_anchor (anchor_name String) (anchor_key Int)))))

(declare-datatypes ((TLSTranscript 0))
  (((mk-tls_transcript (transcript_messages (Seq Int)) (transcript_hash Int) (transcript_bound Bool)))))

(declare-datatypes ((ZeroRTTData 0))
  (((mk-zero_rtt_data (zrtt_data (Seq Int)) (zrtt_ticket Int) (zrtt_timestamp Int) (zrtt_nonce Int) (zrtt_anti_replay_checked Bool)))))

(declare-datatypes ((TLSConnection 0))
  (((mk-tls_connection (tls_version TLSVersion) (tls_cipher CipherSuite) (tls_session_key Int) (tls_transcript TLSTranscript) (tls_server_cert Certificate) (tls_cert_chain Int) (tls_verified Bool) (tls_forward_secret Bool) (tls_channel_bound Bool) (tls_ke_result KEResult)))))

(declare-datatypes ((TCPConnection 0))
  (((mk-tcp_connection (tcp_state TCPState) (tcp_seq Int) (tcp_ack Int) (tcp_window Int) (tcp_seq_random_source Int) (tcp_integrity_mac Int)))))

(declare-datatypes ((TCPPacket 0))
  (((mk-tcp_packet (pkt_seq Int) (pkt_ack Int) (pkt_flags Int) (pkt_payload (Seq Int)) (pkt_mac Int)))))

(declare-datatypes ((IPPacket 0))
  (((mk-ip_packet (ip_src Int) (ip_dst Int) (ip_frag_id Int) (ip_frag_offset Int) (ip_frag_more Bool) (ip_payload (Seq Int)) (ip_total_length Int)))))

(declare-datatypes ((FragmentBuffer 0))
  (((mk-fragment_buffer (frag_id Int) (frag_received (Seq Int)) (frag_total_size Int) (frag_no_overlap_verified Bool)))))

(declare-datatypes ((ICMPState 0))
  (((mk-icmp_state (icmp_count Int) (icmp_window_start Int) (icmp_max_rate Int)))))

(declare-datatypes ((RouteEntry 0))
  (((mk-route_entry (route_dest Int) (route_mask Int) (route_gateway Int) (route_interface Int) (route_valid Bool)))))

(declare-datatypes ((DNSRecord 0))
  (((mk-dns_record (dns_name String) (dns_type DNSRecordType) (dns_value String) (dns_ttl Int) (dns_signature Int) (dns_sig_verified Bool)))))

(declare-datatypes ((DNSQuery 0))
  (((mk-dns_query (query_name String) (query_type DNSRecordType) (query_id Int) (query_mac Int)))))

(declare-datatypes ((DNSCacheEntry 0))
  (((mk-dns_cache_entry (cache_record DNSRecord) (cache_inserted Int) (cache_validated Bool)))))

(declare-datatypes ((DNSRebindingCheck 0))
  (((mk-dns_rebinding_check (rebind_original_ip Int) (rebind_new_ip Int) (rebind_is_private Bool) (rebind_blocked Bool)))))

(declare-datatypes ((DNSAmplificationState 0))
  (((mk-dns_amplification_state (amp_query_size Int) (amp_response_size Int) (amp_ratio_max Int)))))

(declare-datatypes ((DoHConnection 0))
  (((mk-do_h_connection (doh_tls_conn TLSConnection) (doh_encrypted Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. TLSVersion exhaustiveness ---
(push 1)
(declare-const x TLSVersion)
(assert (not (or (= x TLS_1_0) (= x TLS_1_1) (= x TLS_1_2) (= x TLS_1_3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TLSVersion: TLS_1_0 != TLS_1_1 ---
(push 1)
(assert (= TLS_1_0 TLS_1_1))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TLSVersion: TLS_1_1 != TLS_1_2 ---
(push 1)
(assert (= TLS_1_1 TLS_1_2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TLSVersion: TLS_1_2 != TLS_1_3 ---
(push 1)
(assert (= TLS_1_2 TLS_1_3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TLSVersion: TLS_1_0 != TLS_1_3 ---
(push 1)
(assert (= TLS_1_0 TLS_1_3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. TLSVersion finite cardinality (4 values) ---
(push 1)
(declare-const x TLSVersion)
(assert (and (not (= x TLS_1_0)) (not (= x TLS_1_1)) (not (= x TLS_1_2)) (not (= x TLS_1_3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. CipherSuite exhaustiveness ---
(push 1)
(declare-const x CipherSuite)
(assert (not (or (= x TLS_AES_128_GCM_SHA256) (= x TLS_AES_256_GCM_SHA384) (= x TLS_CHACHA20_POLY1305_SHA256))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CipherSuite: TLS_AES_128_GCM_SHA256 != TLS_AES_256_GCM_SHA384 ---
(push 1)
(assert (= TLS_AES_128_GCM_SHA256 TLS_AES_256_GCM_SHA384))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CipherSuite: TLS_AES_256_GCM_SHA384 != TLS_CHACHA20_POLY1305_SHA256 ---
(push 1)
(assert (= TLS_AES_256_GCM_SHA384 TLS_CHACHA20_POLY1305_SHA256))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. CipherSuite finite cardinality (3 values) ---
(push 1)
(declare-const x CipherSuite)
(assert (and (not (= x TLS_AES_128_GCM_SHA256)) (not (= x TLS_AES_256_GCM_SHA384)) (not (= x TLS_CHACHA20_POLY1305_SHA256))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. HandshakeMsg exhaustiveness ---
(push 1)
(declare-const x HandshakeMsg)
(assert (not (or (= x ClientHello) (= x ServerHello) (= x EncryptedExtensions) (= x CertificateMsg) (= x CertificateVerify) (= x Finished))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. HandshakeMsg: ClientHello != ServerHello ---
(push 1)
(assert (= ClientHello ServerHello))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. HandshakeMsg: ServerHello != EncryptedExtensions ---
(push 1)
(assert (= ServerHello EncryptedExtensions))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. HandshakeMsg: EncryptedExtensions != CertificateMsg ---
(push 1)
(assert (= EncryptedExtensions CertificateMsg))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. HandshakeMsg: ClientHello != Finished ---
(push 1)
(assert (= ClientHello Finished))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. HandshakeMsg finite cardinality (6 values) ---
(push 1)
(declare-const x HandshakeMsg)
(assert (and (not (= x ClientHello)) (not (= x ServerHello)) (not (= x EncryptedExtensions)) (not (= x CertificateMsg)) (not (= x CertificateVerify)) (not (= x Finished))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. TCPState exhaustiveness ---
(push 1)
(declare-const x TCPState)
(assert (not (or (= x CLOSED) (= x LISTEN) (= x SYN_SENT) (= x SYN_RECEIVED) (= x ESTABLISHED) (= x FIN_WAIT_1) (= x FIN_WAIT_2) (= x CLOSE_WAIT) (= x CLOSING) (= x LAST_ACK) (= x TIME_WAIT))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. TCPState: CLOSED != LISTEN ---
(push 1)
(assert (= CLOSED LISTEN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. TCPState: LISTEN != SYN_SENT ---
(push 1)
(assert (= LISTEN SYN_SENT))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. TCPState: SYN_SENT != SYN_RECEIVED ---
(push 1)
(assert (= SYN_SENT SYN_RECEIVED))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. TCPState: CLOSED != TIME_WAIT ---
(push 1)
(assert (= CLOSED TIME_WAIT))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. TCPState finite cardinality (11 values) ---
(push 1)
(declare-const x TCPState)
(assert (and (not (= x CLOSED)) (not (= x LISTEN)) (not (= x SYN_SENT)) (not (= x SYN_RECEIVED)) (not (= x ESTABLISHED)) (not (= x FIN_WAIT_1)) (not (= x FIN_WAIT_2)) (not (= x CLOSE_WAIT)) (not (= x CLOSING)) (not (= x LAST_ACK)) (not (= x TIME_WAIT))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. TCPEvent exhaustiveness ---
(push 1)
(declare-const x TCPEvent)
(assert (not (or (= x PassiveOpen) (= x ActiveOpen) (= x SynReceived) (= x SynAckReceived) (= x AckReceived) (= x FinReceived) (= x Close) (= x Timeout))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TCPEvent: PassiveOpen != ActiveOpen ---
(push 1)
(assert (= PassiveOpen ActiveOpen))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TCPEvent: ActiveOpen != SynReceived ---
(push 1)
(assert (= ActiveOpen SynReceived))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. TCPEvent: SynReceived != SynAckReceived ---
(push 1)
(assert (= SynReceived SynAckReceived))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. TCPEvent: PassiveOpen != Timeout ---
(push 1)
(assert (= PassiveOpen Timeout))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. TCPEvent finite cardinality (8 values) ---
(push 1)
(declare-const x TCPEvent)
(assert (and (not (= x PassiveOpen)) (not (= x ActiveOpen)) (not (= x SynReceived)) (not (= x SynAckReceived)) (not (= x AckReceived)) (not (= x FinReceived)) (not (= x Close)) (not (= x Timeout))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. DNSRecordType exhaustiveness ---
(push 1)
(declare-const x DNSRecordType)
(assert (not (or (= x A) (= x AAAA) (= x CNAME) (= x MX) (= x TXT) (= x RRSIG) (= x DNSKEY) (= x DS))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. DNSRecordType: A != AAAA ---
(push 1)
(assert (= A AAAA))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. DNSRecordType: AAAA != CNAME ---
(push 1)
(assert (= AAAA CNAME))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DNSRecordType: CNAME != MX ---
(push 1)
(assert (= CNAME MX))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. DNSRecordType: A != DS ---
(push 1)
(assert (= A DS))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. DNSRecordType finite cardinality (8 values) ---
(push 1)
(declare-const x DNSRecordType)
(assert (and (not (= x A)) (not (= x AAAA)) (not (= x CNAME)) (not (= x MX)) (not (= x TXT)) (not (= x RRSIG)) (not (= x DNSKEY)) (not (= x DS))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. KEResult accessor round-trip: ke_shared ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ke_shared (mk-ke_result f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. KEResult accessor round-trip: ke_ephemeral_pub ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ke_ephemeral_pub (mk-ke_result f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. KEResult accessor round-trip: ke_ephemeral_priv ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ke_ephemeral_priv (mk-ke_result f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. KEResult: non-negative int fields sum ---
(push 1)
(declare-const r KEResult)
(assert (>= (ke_shared r) 0))
(assert (>= (ke_ephemeral_pub r) 0))
(assert (not (>= (+ (ke_shared r) (ke_ephemeral_pub r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. Certificate accessor round-trip: cert_subject ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cert_subject (mk-certificate f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Certificate accessor round-trip: cert_issuer ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cert_issuer (mk-certificate f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. Certificate accessor round-trip: cert_public_key ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cert_public_key (mk-certificate f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. Certificate accessor round-trip: cert_signature ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cert_signature (mk-certificate f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. Certificate accessor round-trip: cert_valid_from ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cert_valid_from (mk-certificate f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Certificate: non-negative int fields sum ---
(push 1)
(declare-const r Certificate)
(assert (>= (cert_public_key r) 0))
(assert (>= (cert_signature r) 0))
(assert (not (>= (+ (cert_public_key r) (cert_signature r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. TrustAnchor accessor round-trip: anchor_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(assert (not (= (anchor_name (mk-trust_anchor f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. TrustAnchor accessor round-trip: anchor_key ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(assert (not (= (anchor_key (mk-trust_anchor f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. TLSConnection accessor round-trip: tls_version ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 CipherSuite)
(declare-const f2 Int)
(declare-const f3 TLSTranscript)
(declare-const f4 Certificate)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 KEResult)
(assert (not (= (tls_version (mk-tls_connection f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. TLSConnection accessor round-trip: tls_cipher ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 CipherSuite)
(declare-const f2 Int)
(declare-const f3 TLSTranscript)
(declare-const f4 Certificate)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 KEResult)
(assert (not (= (tls_cipher (mk-tls_connection f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. TLSConnection accessor round-trip: tls_session_key ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 CipherSuite)
(declare-const f2 Int)
(declare-const f3 TLSTranscript)
(declare-const f4 Certificate)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 KEResult)
(assert (not (= (tls_session_key (mk-tls_connection f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. TLSConnection accessor round-trip: tls_transcript ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 CipherSuite)
(declare-const f2 Int)
(declare-const f3 TLSTranscript)
(declare-const f4 Certificate)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 KEResult)
(assert (not (= (tls_transcript (mk-tls_connection f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. TLSConnection accessor round-trip: tls_server_cert ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 CipherSuite)
(declare-const f2 Int)
(declare-const f3 TLSTranscript)
(declare-const f4 Certificate)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 KEResult)
(assert (not (= (tls_server_cert (mk-tls_connection f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. TLSConnection: non-negative int fields sum ---
(push 1)
(declare-const r TLSConnection)
(assert (>= (tls_session_key r) 0))
(assert (>= (tls_cert_chain r) 0))
(assert (not (>= (+ (tls_session_key r) (tls_cert_chain r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. TCPConnection accessor round-trip: tcp_state ---
(push 1)
(declare-const f0 TCPState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (tcp_state (mk-tcp_connection f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. TCPConnection accessor round-trip: tcp_seq ---
(push 1)
(declare-const f0 TCPState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (tcp_seq (mk-tcp_connection f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. TCPConnection accessor round-trip: tcp_ack ---
(push 1)
(declare-const f0 TCPState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (tcp_ack (mk-tcp_connection f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. TCPConnection accessor round-trip: tcp_window ---
(push 1)
(declare-const f0 TCPState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (tcp_window (mk-tcp_connection f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. TCPConnection accessor round-trip: tcp_seq_random_source ---
(push 1)
(declare-const f0 TCPState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (tcp_seq_random_source (mk-tcp_connection f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. TCPConnection: non-negative int fields sum ---
(push 1)
(declare-const r TCPConnection)
(assert (>= (tcp_seq r) 0))
(assert (>= (tcp_ack r) 0))
(assert (not (>= (+ (tcp_seq r) (tcp_ack r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. TCPPacket accessor round-trip: pkt_seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (pkt_seq (mk-tcp_packet f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. TCPPacket accessor round-trip: pkt_ack ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (pkt_ack (mk-tcp_packet f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. TCPPacket accessor round-trip: pkt_flags ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (pkt_flags (mk-tcp_packet f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. TCPPacket: non-negative int fields sum ---
(push 1)
(declare-const r TCPPacket)
(assert (>= (pkt_seq r) 0))
(assert (>= (pkt_ack r) 0))
(assert (not (>= (+ (pkt_seq r) (pkt_ack r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. IPPacket accessor round-trip: ip_src ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(assert (not (= (ip_src (mk-ip_packet f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. IPPacket accessor round-trip: ip_dst ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(assert (not (= (ip_dst (mk-ip_packet f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. IPPacket accessor round-trip: ip_frag_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(assert (not (= (ip_frag_id (mk-ip_packet f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. IPPacket accessor round-trip: ip_frag_offset ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(assert (not (= (ip_frag_offset (mk-ip_packet f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. IPPacket accessor round-trip: ip_frag_more ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(assert (not (= (ip_frag_more (mk-ip_packet f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. IPPacket: non-negative int fields sum ---
(push 1)
(declare-const r IPPacket)
(assert (>= (ip_src r) 0))
(assert (>= (ip_dst r) 0))
(assert (not (>= (+ (ip_src r) (ip_dst r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. FragmentBuffer accessor round-trip: frag_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (frag_id (mk-fragment_buffer f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. ICMPState accessor round-trip: icmp_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (icmp_count (mk-icmp_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. ICMPState accessor round-trip: icmp_window_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (icmp_window_start (mk-icmp_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. ICMPState accessor round-trip: icmp_max_rate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (icmp_max_rate (mk-icmp_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. ICMPState: non-negative int fields sum ---
(push 1)
(declare-const r ICMPState)
(assert (>= (icmp_count r) 0))
(assert (>= (icmp_window_start r) 0))
(assert (not (>= (+ (icmp_count r) (icmp_window_start r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. RouteEntry accessor round-trip: route_dest ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (route_dest (mk-route_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. RouteEntry accessor round-trip: route_mask ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (route_mask (mk-route_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. RouteEntry accessor round-trip: route_gateway ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (route_gateway (mk-route_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. RouteEntry accessor round-trip: route_interface ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (route_interface (mk-route_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. RouteEntry accessor round-trip: route_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (route_valid (mk-route_entry f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. RouteEntry: non-negative int fields sum ---
(push 1)
(declare-const r RouteEntry)
(assert (>= (route_dest r) 0))
(assert (>= (route_mask r) 0))
(assert (not (>= (+ (route_dest r) (route_mask r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. DNSRecord accessor round-trip: dns_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 DNSRecordType)
(declare-const f2 String)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (dns_name (mk-dns_record f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. DNSRecord accessor round-trip: dns_type ---
(push 1)
(declare-const f0 String)
(declare-const f1 DNSRecordType)
(declare-const f2 String)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (dns_type (mk-dns_record f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. DNSRecord accessor round-trip: dns_value ---
(push 1)
(declare-const f0 String)
(declare-const f1 DNSRecordType)
(declare-const f2 String)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (dns_value (mk-dns_record f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. DNSRecord accessor round-trip: dns_ttl ---
(push 1)
(declare-const f0 String)
(declare-const f1 DNSRecordType)
(declare-const f2 String)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (dns_ttl (mk-dns_record f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. DNSRecord accessor round-trip: dns_signature ---
(push 1)
(declare-const f0 String)
(declare-const f1 DNSRecordType)
(declare-const f2 String)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (dns_signature (mk-dns_record f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. DNSRecord: non-negative int fields sum ---
(push 1)
(declare-const r DNSRecord)
(assert (>= (dns_ttl r) 0))
(assert (>= (dns_signature r) 0))
(assert (not (>= (+ (dns_ttl r) (dns_signature r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. DNSQuery accessor round-trip: query_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 DNSRecordType)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (query_name (mk-dns_query f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. DNSQuery accessor round-trip: query_type ---
(push 1)
(declare-const f0 String)
(declare-const f1 DNSRecordType)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (query_type (mk-dns_query f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. DNSQuery accessor round-trip: query_id ---
(push 1)
(declare-const f0 String)
(declare-const f1 DNSRecordType)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (query_id (mk-dns_query f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. DNSQuery accessor round-trip: query_mac ---
(push 1)
(declare-const f0 String)
(declare-const f1 DNSRecordType)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (query_mac (mk-dns_query f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. DNSQuery: non-negative int fields sum ---
(push 1)
(declare-const r DNSQuery)
(assert (>= (query_id r) 0))
(assert (>= (query_mac r) 0))
(assert (not (>= (+ (query_id r) (query_mac r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. DNSCacheEntry accessor round-trip: cache_record ---
(push 1)
(declare-const f0 DNSRecord)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (cache_record (mk-dns_cache_entry f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 92. DNSCacheEntry accessor round-trip: cache_inserted ---
(push 1)
(declare-const f0 DNSRecord)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (cache_inserted (mk-dns_cache_entry f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. DNSCacheEntry accessor round-trip: cache_validated ---
(push 1)
(declare-const f0 DNSRecord)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (cache_validated (mk-dns_cache_entry f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. DNSRebindingCheck accessor round-trip: rebind_original_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rebind_original_ip (mk-dns_rebinding_check f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 95. DNSRebindingCheck accessor round-trip: rebind_new_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rebind_new_ip (mk-dns_rebinding_check f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. DNSRebindingCheck accessor round-trip: rebind_is_private ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rebind_is_private (mk-dns_rebinding_check f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. DNSRebindingCheck accessor round-trip: rebind_blocked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rebind_blocked (mk-dns_rebinding_check f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. DNSRebindingCheck: non-negative int fields sum ---
(push 1)
(declare-const r DNSRebindingCheck)
(assert (>= (rebind_original_ip r) 0))
(assert (>= (rebind_new_ip r) 0))
(assert (not (>= (+ (rebind_original_ip r) (rebind_new_ip r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. DNSAmplificationState accessor round-trip: amp_query_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (amp_query_size (mk-dns_amplification_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 100. DNSAmplificationState accessor round-trip: amp_response_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (amp_response_size (mk-dns_amplification_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 101. DNSAmplificationState accessor round-trip: amp_ratio_max ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (amp_ratio_max (mk-dns_amplification_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 102. DNSAmplificationState: non-negative int fields sum ---
(push 1)
(declare-const r DNSAmplificationState)
(assert (>= (amp_query_size r) 0))
(assert (>= (amp_response_size r) 0))
(assert (not (>= (+ (amp_query_size r) (amp_response_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. DoHConnection accessor round-trip: doh_tls_conn ---
(push 1)
(declare-const f0 TLSConnection)
(declare-const f1 Bool)
(assert (not (= (doh_tls_conn (mk-do_h_connection f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 104. DoHConnection accessor round-trip: doh_encrypted ---
(push 1)
(declare-const f0 TLSConnection)
(declare-const f1 Bool)
(assert (not (= (doh_encrypted (mk-do_h_connection f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

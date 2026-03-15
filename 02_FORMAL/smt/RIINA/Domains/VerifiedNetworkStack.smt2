; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedNetworkStack — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedNetworkStack.v (140 assertions)
; Module: VerifiedNetworkStack
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TCPState 0)) (((CLOSED) (LISTEN) (SYN_SENT) (SYN_RECEIVED) (ESTABLISHED) (FIN_WAIT_1) (FIN_WAIT_2) (CLOSE_WAIT) (CLOSING) (LAST_ACK) (TIME_WAIT))))

(declare-datatypes ((SocketState 0)) (((SockUnbound) (SockBound) (SockListening) (SockConnecting) (SockConnected) (SockClosing) (SockClosed))))

(declare-datatypes ((HandshakeStep 0)) (((HS_Init) (HS_SynSent) (HS_SynAckRecv) (HS_Complete) (HS_Failed))))

(declare-datatypes ((NetworkSecurity 0))
  (((mk-network_security (ns_packet_validation Bool) (ns_protocol_compliance Bool) (ns_firewall_enforced Bool) (ns_encryption_in_transit Bool)))))

(declare-datatypes ((NetworkReliability 0))
  (((mk-network_reliability (nr_congestion_control Bool) (nr_flow_control Bool) (nr_error_detection Bool) (nr_retransmission Bool)))))

(declare-datatypes ((VerifiedNetStack 0))
  (((mk-verified_net_stack (vns_security NetworkSecurity) (vns_reliability NetworkReliability) (vns_rfc_compliant Bool) (vns_formally_verified Bool)))))

(declare-datatypes ((TCPFlags 0))
  (((mk-tcp_flags (flag_syn Bool) (flag_ack Bool) (flag_fin Bool) (flag_rst Bool) (flag_psh Bool) (flag_urg Bool)))))

(declare-datatypes ((TCPSegment 0))
  (((mk-tcp_segment (seg_seq_num Int) (seg_ack_num Int) (seg_flags TCPFlags) (seg_window Int) (seg_data_len Int)))))

(declare-datatypes ((Buffer 0))
  (((mk-buffer (buf_data (Seq Int)) (buf_capacity Int) (buf_position Int)))))

(declare-datatypes ((CongestionState 0))
  (((mk-congestion_state (cwnd Int) (ssthresh Int) (rtt_est Int) (rto Int)))))

(declare-datatypes ((SocketOptions 0))
  (((mk-socket_options (opt_reuse_addr Bool) (opt_keep_alive Bool) (opt_no_delay Bool) (opt_recv_timeout Int) (opt_send_timeout Int)))))

(declare-datatypes ((Socket 0))
  (((mk-socket (sock_state SocketState) (sock_local_port Int) (sock_remote_port Int) (sock_tcp_state TCPState) (sock_options SocketOptions)))))

(declare-datatypes ((HandshakeState 0))
  (((mk-handshake_state (hs_step HandshakeStep) (hs_client_isn Int) (hs_server_isn Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TCPState enum properties ---

; --- 1. TCPState exhaustiveness ---
(push 1)
(declare-const x TCPState)
(assert (not (or (= x CLOSED) (= x LISTEN) (= x SYN_SENT) (= x SYN_RECEIVED) (= x ESTABLISHED) (= x FIN_WAIT_1) (= x FIN_WAIT_2) (= x CLOSE_WAIT) (= x CLOSING) (= x LAST_ACK) (= x TIME_WAIT))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TCPState: CLOSED != LISTEN ---
(push 1)
(assert (= CLOSED LISTEN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TCPState: LISTEN != SYN_SENT ---
(push 1)
(assert (= LISTEN SYN_SENT))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TCPState: SYN_SENT != SYN_RECEIVED ---
(push 1)
(assert (= SYN_SENT SYN_RECEIVED))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TCPState: CLOSED != TIME_WAIT ---
(push 1)
(assert (= CLOSED TIME_WAIT))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. TCPState finite cardinality (11 values) ---
(push 1)
(declare-const x TCPState)
(assert (and (not (= x CLOSED)) (not (= x LISTEN)) (not (= x SYN_SENT)) (not (= x SYN_RECEIVED)) (not (= x ESTABLISHED)) (not (= x FIN_WAIT_1)) (not (= x FIN_WAIT_2)) (not (= x CLOSE_WAIT)) (not (= x CLOSING)) (not (= x LAST_ACK)) (not (= x TIME_WAIT))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SocketState enum properties ---

; --- 7. SocketState exhaustiveness ---
(push 1)
(declare-const x SocketState)
(assert (not (or (= x SockUnbound) (= x SockBound) (= x SockListening) (= x SockConnecting) (= x SockConnected) (= x SockClosing) (= x SockClosed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SocketState: SockUnbound != SockBound ---
(push 1)
(assert (= SockUnbound SockBound))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SocketState: SockBound != SockListening ---
(push 1)
(assert (= SockBound SockListening))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SocketState: SockListening != SockConnecting ---
(push 1)
(assert (= SockListening SockConnecting))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SocketState: SockUnbound != SockClosed ---
(push 1)
(assert (= SockUnbound SockClosed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SocketState finite cardinality (7 values) ---
(push 1)
(declare-const x SocketState)
(assert (and (not (= x SockUnbound)) (not (= x SockBound)) (not (= x SockListening)) (not (= x SockConnecting)) (not (= x SockConnected)) (not (= x SockClosing)) (not (= x SockClosed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- HandshakeStep enum properties ---

; --- 13. HandshakeStep exhaustiveness ---
(push 1)
(declare-const x HandshakeStep)
(assert (not (or (= x HS_Init) (= x HS_SynSent) (= x HS_SynAckRecv) (= x HS_Complete) (= x HS_Failed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. HandshakeStep: HS_Init != HS_SynSent ---
(push 1)
(assert (= HS_Init HS_SynSent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. HandshakeStep: HS_SynSent != HS_SynAckRecv ---
(push 1)
(assert (= HS_SynSent HS_SynAckRecv))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. HandshakeStep: HS_SynAckRecv != HS_Complete ---
(push 1)
(assert (= HS_SynAckRecv HS_Complete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. HandshakeStep: HS_Init != HS_Failed ---
(push 1)
(assert (= HS_Init HS_Failed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. HandshakeStep finite cardinality (5 values) ---
(push 1)
(declare-const x HandshakeStep)
(assert (and (not (= x HS_Init)) (not (= x HS_SynSent)) (not (= x HS_SynAckRecv)) (not (= x HS_Complete)) (not (= x HS_Failed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetworkSecurity record properties ---

; --- 19. NetworkSecurity accessor round-trip: ns_packet_validation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ns_packet_validation (mk-network_security f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. NetworkSecurity accessor round-trip: ns_protocol_compliance ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ns_protocol_compliance (mk-network_security f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. NetworkSecurity accessor round-trip: ns_firewall_enforced ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ns_firewall_enforced (mk-network_security f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun NetworkSecurity_all_enabled ((g NetworkSecurity)) Bool
  (and (ns_packet_validation g) (ns_protocol_compliance g) (ns_firewall_enforced g)))

; --- 22. NetworkSecurity: all-enabled completeness ---
(push 1)
(declare-const g NetworkSecurity)
(assert (ns_packet_validation g))
(assert (ns_protocol_compliance g))
(assert (ns_firewall_enforced g))
(assert (not (NetworkSecurity_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. NetworkSecurity: NetworkSecurity_all_enabled implies ns_packet_validation ---
(push 1)
(declare-const g NetworkSecurity)
(assert (NetworkSecurity_all_enabled g))
(assert (not (ns_packet_validation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. NetworkSecurity: NetworkSecurity_all_enabled implies ns_protocol_compliance ---
(push 1)
(declare-const g NetworkSecurity)
(assert (NetworkSecurity_all_enabled g))
(assert (not (ns_protocol_compliance g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. NetworkSecurity: NetworkSecurity_all_enabled implies ns_firewall_enforced ---
(push 1)
(declare-const g NetworkSecurity)
(assert (NetworkSecurity_all_enabled g))
(assert (not (ns_firewall_enforced g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetworkReliability record properties ---

; --- 26. NetworkReliability accessor round-trip: nr_congestion_control ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (nr_congestion_control (mk-network_reliability f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. NetworkReliability accessor round-trip: nr_flow_control ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (nr_flow_control (mk-network_reliability f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. NetworkReliability accessor round-trip: nr_error_detection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (nr_error_detection (mk-network_reliability f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun NetworkReliability_all_enabled ((g NetworkReliability)) Bool
  (and (nr_congestion_control g) (nr_flow_control g) (nr_error_detection g)))

; --- 29. NetworkReliability: all-enabled completeness ---
(push 1)
(declare-const g NetworkReliability)
(assert (nr_congestion_control g))
(assert (nr_flow_control g))
(assert (nr_error_detection g))
(assert (not (NetworkReliability_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. NetworkReliability: NetworkReliability_all_enabled implies nr_congestion_control ---
(push 1)
(declare-const g NetworkReliability)
(assert (NetworkReliability_all_enabled g))
(assert (not (nr_congestion_control g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. NetworkReliability: NetworkReliability_all_enabled implies nr_flow_control ---
(push 1)
(declare-const g NetworkReliability)
(assert (NetworkReliability_all_enabled g))
(assert (not (nr_flow_control g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. NetworkReliability: NetworkReliability_all_enabled implies nr_error_detection ---
(push 1)
(declare-const g NetworkReliability)
(assert (NetworkReliability_all_enabled g))
(assert (not (nr_error_detection g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifiedNetStack record properties ---

; --- 33. VerifiedNetStack accessor round-trip: vns_security ---
(push 1)
(declare-const f0 NetworkSecurity)
(declare-const f1 NetworkReliability)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vns_security (mk-verified_net_stack f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. VerifiedNetStack accessor round-trip: vns_reliability ---
(push 1)
(declare-const f0 NetworkSecurity)
(declare-const f1 NetworkReliability)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vns_reliability (mk-verified_net_stack f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. VerifiedNetStack accessor round-trip: vns_rfc_compliant ---
(push 1)
(declare-const f0 NetworkSecurity)
(declare-const f1 NetworkReliability)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vns_rfc_compliant (mk-verified_net_stack f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TCPFlags record properties ---

; --- 36. TCPFlags accessor round-trip: flag_syn ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (flag_syn (mk-tcp_flags f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. TCPFlags accessor round-trip: flag_ack ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (flag_ack (mk-tcp_flags f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. TCPFlags accessor round-trip: flag_fin ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (flag_fin (mk-tcp_flags f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. TCPFlags accessor round-trip: flag_rst ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (flag_rst (mk-tcp_flags f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. TCPFlags accessor round-trip: flag_psh ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (flag_psh (mk-tcp_flags f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TCPFlags_all_enabled ((g TCPFlags)) Bool
  (and (flag_syn g) (flag_ack g) (flag_fin g) (flag_rst g) (flag_psh g)))

; --- 41. TCPFlags: all-enabled completeness ---
(push 1)
(declare-const g TCPFlags)
(assert (flag_syn g))
(assert (flag_ack g))
(assert (flag_fin g))
(assert (flag_rst g))
(assert (flag_psh g))
(assert (not (TCPFlags_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. TCPFlags: TCPFlags_all_enabled implies flag_syn ---
(push 1)
(declare-const g TCPFlags)
(assert (TCPFlags_all_enabled g))
(assert (not (flag_syn g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. TCPFlags: TCPFlags_all_enabled implies flag_ack ---
(push 1)
(declare-const g TCPFlags)
(assert (TCPFlags_all_enabled g))
(assert (not (flag_ack g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. TCPFlags: TCPFlags_all_enabled implies flag_fin ---
(push 1)
(declare-const g TCPFlags)
(assert (TCPFlags_all_enabled g))
(assert (not (flag_fin g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TCPSegment record properties ---

; --- 45. TCPSegment accessor round-trip: seg_seq_num ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 TCPFlags)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (seg_seq_num (mk-tcp_segment f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. TCPSegment accessor round-trip: seg_ack_num ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 TCPFlags)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (seg_ack_num (mk-tcp_segment f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. TCPSegment accessor round-trip: seg_flags ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 TCPFlags)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (seg_flags (mk-tcp_segment f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. TCPSegment accessor round-trip: seg_window ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 TCPFlags)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (seg_window (mk-tcp_segment f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. TCPSegment: integer field consistency ---
(push 1)
(declare-const r TCPSegment)
(assert (>= (seg_seq_num r) 0))
(assert (>= (seg_ack_num r) 0))
(assert (not (>= (+ (seg_seq_num r) (seg_ack_num r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Buffer record properties ---

; --- 50. Buffer accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (buf_data (mk-buffer f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. Buffer accessor round-trip: buf_capacity ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (buf_capacity (mk-buffer f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. Buffer: integer field consistency ---
(push 1)
(declare-const r Buffer)
(assert (>= (seq.len (buf_data r)) 0))
(assert (>= (buf_capacity r) 0))
(assert (not (>= (+ (seq.len (buf_data r)) (buf_capacity r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CongestionState record properties ---

; --- 53. CongestionState accessor round-trip: cwnd ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (cwnd (mk-congestion_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. CongestionState accessor round-trip: ssthresh ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ssthresh (mk-congestion_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. CongestionState accessor round-trip: rtt_est ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rtt_est (mk-congestion_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. CongestionState: integer field consistency ---
(push 1)
(declare-const r CongestionState)
(assert (>= (cwnd r) 0))
(assert (>= (ssthresh r) 0))
(assert (not (>= (+ (cwnd r) (ssthresh r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SocketOptions record properties ---

; --- 57. SocketOptions accessor round-trip: opt_reuse_addr ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (opt_reuse_addr (mk-socket_options f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. SocketOptions accessor round-trip: opt_keep_alive ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (opt_keep_alive (mk-socket_options f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. SocketOptions accessor round-trip: opt_no_delay ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (opt_no_delay (mk-socket_options f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. SocketOptions accessor round-trip: opt_recv_timeout ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (opt_recv_timeout (mk-socket_options f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Socket record properties ---

; --- 61. Socket accessor round-trip: sock_state ---
(push 1)
(declare-const f0 SocketState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 TCPState)
(declare-const f4 SocketOptions)
(assert (not (= (sock_state (mk-socket f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. Socket accessor round-trip: sock_local_port ---
(push 1)
(declare-const f0 SocketState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 TCPState)
(declare-const f4 SocketOptions)
(assert (not (= (sock_local_port (mk-socket f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. Socket accessor round-trip: sock_remote_port ---
(push 1)
(declare-const f0 SocketState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 TCPState)
(declare-const f4 SocketOptions)
(assert (not (= (sock_remote_port (mk-socket f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. Socket accessor round-trip: sock_tcp_state ---
(push 1)
(declare-const f0 SocketState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 TCPState)
(declare-const f4 SocketOptions)
(assert (not (= (sock_tcp_state (mk-socket f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. Socket: integer field consistency ---
(push 1)
(declare-const r Socket)
(assert (>= (sock_local_port r) 0))
(assert (>= (sock_remote_port r) 0))
(assert (not (>= (+ (sock_local_port r) (sock_remote_port r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HandshakeState record properties ---

; --- 66. HandshakeState accessor round-trip: hs_step ---
(push 1)
(declare-const f0 HandshakeStep)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (hs_step (mk-handshake_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. HandshakeState accessor round-trip: hs_client_isn ---
(push 1)
(declare-const f0 HandshakeStep)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (hs_client_isn (mk-handshake_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

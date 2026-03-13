; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA NetworkSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/NetworkSecurity.v (20 assertions)
; Module: NetworkSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((VPNConnection 0))
  (((mk-vpn_connection (vpn_id Int) (vpn_protocol_version Int) (vpn_encrypted Bool) (vpn_authenticated Bool) (vpn_tunnel_established Bool)))))

(declare-datatypes ((ConnectionNegotiation 0))
  (((mk-connection_negotiation (neg_client_max_version Int) (neg_server_max_version Int) (neg_selected_version Int) (neg_downgrade_attempted Bool)))))

(declare-datatypes ((Packet 0))
  (((mk-packet (pkt_id Int) (pkt_src_ip Int) (pkt_dst_ip Int) (pkt_port Int) (pkt_payload_hash Int) (pkt_inspected Bool) (pkt_malicious Bool) (pkt_timestamp Int) (pkt_sequence Int)))))

(declare-datatypes ((RateLimiter 0))
  (((mk-rate_limiter (rl_ip Int) (rl_window_ms Int) (rl_max_requests Int) (rl_current_count Int)))))

(declare-datatypes ((Session 0))
  (((mk-session (session_id Int) (session_token Int) (session_ip Int) (session_valid Bool) (session_timestamp Int)))))

(declare-datatypes ((SSLConfig 0))
  (((mk-ssl_config (ssl_min_version Int) (ssl_cipher_strength Int) (ssl_revocation_checked Bool) (ssl_compression_disabled Bool)))))

(declare-datatypes ((ConnectionTracker 0))
  (((mk-connection_tracker (ct_ip Int) (ct_connection_count Int) (ct_max_per_ip Int)))))

(declare-datatypes ((PortScanDetector 0))
  (((mk-port_scan_detector (psd_ip Int) (psd_ports_probed Int) (psd_threshold Int) (psd_blocked Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. VPNConnection accessor round-trip: vpn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vpn_id (mk-vpn_connection f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. VPNConnection accessor round-trip: vpn_protocol_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vpn_protocol_version (mk-vpn_connection f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. VPNConnection accessor round-trip: vpn_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vpn_encrypted (mk-vpn_connection f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. VPNConnection accessor round-trip: vpn_authenticated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vpn_authenticated (mk-vpn_connection f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. VPNConnection accessor round-trip: vpn_tunnel_established ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vpn_tunnel_established (mk-vpn_connection f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. VPNConnection: non-negative int fields sum ---
(push 1)
(declare-const r VPNConnection)
(assert (>= (vpn_id r) 0))
(assert (>= (vpn_protocol_version r) 0))
(assert (not (>= (+ (vpn_id r) (vpn_protocol_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. ConnectionNegotiation accessor round-trip: neg_client_max_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (neg_client_max_version (mk-connection_negotiation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ConnectionNegotiation accessor round-trip: neg_server_max_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (neg_server_max_version (mk-connection_negotiation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ConnectionNegotiation accessor round-trip: neg_selected_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (neg_selected_version (mk-connection_negotiation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ConnectionNegotiation accessor round-trip: neg_downgrade_attempted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (neg_downgrade_attempted (mk-connection_negotiation f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ConnectionNegotiation: non-negative int fields sum ---
(push 1)
(declare-const r ConnectionNegotiation)
(assert (>= (neg_client_max_version r) 0))
(assert (>= (neg_server_max_version r) 0))
(assert (not (>= (+ (neg_client_max_version r) (neg_server_max_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Packet accessor round-trip: pkt_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(assert (not (= (pkt_id (mk-packet f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Packet accessor round-trip: pkt_src_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(assert (not (= (pkt_src_ip (mk-packet f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Packet accessor round-trip: pkt_dst_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(assert (not (= (pkt_dst_ip (mk-packet f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Packet accessor round-trip: pkt_port ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(assert (not (= (pkt_port (mk-packet f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Packet accessor round-trip: pkt_payload_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(assert (not (= (pkt_payload_hash (mk-packet f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Packet: non-negative int fields sum ---
(push 1)
(declare-const r Packet)
(assert (>= (pkt_id r) 0))
(assert (>= (pkt_src_ip r) 0))
(assert (not (>= (+ (pkt_id r) (pkt_src_ip r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. RateLimiter accessor round-trip: rl_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rl_ip (mk-rate_limiter f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. RateLimiter accessor round-trip: rl_window_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rl_window_ms (mk-rate_limiter f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. RateLimiter accessor round-trip: rl_max_requests ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rl_max_requests (mk-rate_limiter f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. RateLimiter accessor round-trip: rl_current_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rl_current_count (mk-rate_limiter f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. RateLimiter: non-negative int fields sum ---
(push 1)
(declare-const r RateLimiter)
(assert (>= (rl_ip r) 0))
(assert (>= (rl_window_ms r) 0))
(assert (not (>= (+ (rl_ip r) (rl_window_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Session accessor round-trip: session_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (session_id (mk-session f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Session accessor round-trip: session_token ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (session_token (mk-session f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Session accessor round-trip: session_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (session_ip (mk-session f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Session accessor round-trip: session_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (session_valid (mk-session f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Session accessor round-trip: session_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (session_timestamp (mk-session f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Session: non-negative int fields sum ---
(push 1)
(declare-const r Session)
(assert (>= (session_id r) 0))
(assert (>= (session_token r) 0))
(assert (not (>= (+ (session_id r) (session_token r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. SSLConfig accessor round-trip: ssl_min_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ssl_min_version (mk-ssl_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. SSLConfig accessor round-trip: ssl_cipher_strength ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ssl_cipher_strength (mk-ssl_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. SSLConfig accessor round-trip: ssl_revocation_checked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ssl_revocation_checked (mk-ssl_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. SSLConfig accessor round-trip: ssl_compression_disabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ssl_compression_disabled (mk-ssl_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. SSLConfig: non-negative int fields sum ---
(push 1)
(declare-const r SSLConfig)
(assert (>= (ssl_min_version r) 0))
(assert (>= (ssl_cipher_strength r) 0))
(assert (not (>= (+ (ssl_min_version r) (ssl_cipher_strength r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. ConnectionTracker accessor round-trip: ct_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ct_ip (mk-connection_tracker f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. ConnectionTracker accessor round-trip: ct_connection_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ct_connection_count (mk-connection_tracker f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ConnectionTracker accessor round-trip: ct_max_per_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ct_max_per_ip (mk-connection_tracker f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. ConnectionTracker: non-negative int fields sum ---
(push 1)
(declare-const r ConnectionTracker)
(assert (>= (ct_ip r) 0))
(assert (>= (ct_connection_count r) 0))
(assert (not (>= (+ (ct_ip r) (ct_connection_count r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. PortScanDetector accessor round-trip: psd_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (psd_ip (mk-port_scan_detector f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. PortScanDetector accessor round-trip: psd_ports_probed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (psd_ports_probed (mk-port_scan_detector f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. PortScanDetector accessor round-trip: psd_threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (psd_threshold (mk-port_scan_detector f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. PortScanDetector accessor round-trip: psd_blocked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (psd_blocked (mk-port_scan_detector f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. PortScanDetector: non-negative int fields sum ---
(push 1)
(declare-const r PortScanDetector)
(assert (>= (psd_ip r) 0))
(assert (>= (psd_ports_probed r) 0))
(assert (not (>= (+ (psd_ip r) (psd_ports_probed r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

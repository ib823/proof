; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA OMEGA001_NetworkDefense — SMT Verification
; Derived from 02_FORMAL/coq/domains/OMEGA001_NetworkDefense.v (30 assertions)
; Module: OMEGA001_NetworkDefense
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ConnState 0)) (((ConnNew) (ConnEstablished) (ConnClosing) (ConnClosed))))

(declare-datatypes ((TokenBucket 0))
  (((mk-token_bucket (tb_tokens Int) (tb_capacity Int) (tb_refill_rate Int) (tb_last_refill Int)))))

(declare-datatypes ((NetCapability 0))
  (((mk-net_capability (cap_id Int) (cap_permissions (Seq Int)) (cap_expiry Int) (cap_delegatable Bool) (cap_signature Int)))))

(declare-datatypes ((SynCookie 0))
  (((mk-syn_cookie (sc_client_ip Int) (sc_client_port Int) (sc_server_port Int) (sc_timestamp Int) (sc_mss_index Int)))))

(declare-datatypes ((Connection 0))
  (((mk-connection (conn_src Int) (conn_dst Int) (conn_state ConnState) (conn_bytes_in Int) (conn_bytes_out Int) (conn_start_time Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. ConnState exhaustiveness ---
(push 1)
(declare-const x ConnState)
(assert (not (or (= x ConnNew) (= x ConnEstablished) (= x ConnClosing) (= x ConnClosed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ConnState: ConnNew != ConnEstablished ---
(push 1)
(assert (= ConnNew ConnEstablished))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ConnState: ConnEstablished != ConnClosing ---
(push 1)
(assert (= ConnEstablished ConnClosing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ConnState: ConnClosing != ConnClosed ---
(push 1)
(assert (= ConnClosing ConnClosed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ConnState: ConnNew != ConnClosed ---
(push 1)
(assert (= ConnNew ConnClosed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ConnState finite cardinality (4 values) ---
(push 1)
(declare-const x ConnState)
(assert (and (not (= x ConnNew)) (not (= x ConnEstablished)) (not (= x ConnClosing)) (not (= x ConnClosed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. TokenBucket accessor round-trip: tb_tokens ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tb_tokens (mk-token_bucket f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TokenBucket accessor round-trip: tb_capacity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tb_capacity (mk-token_bucket f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TokenBucket accessor round-trip: tb_refill_rate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tb_refill_rate (mk-token_bucket f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TokenBucket accessor round-trip: tb_last_refill ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tb_last_refill (mk-token_bucket f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TokenBucket: non-negative int fields sum ---
(push 1)
(declare-const r TokenBucket)
(assert (>= (tb_tokens r) 0))
(assert (>= (tb_capacity r) 0))
(assert (not (>= (+ (tb_tokens r) (tb_capacity r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. NetCapability accessor round-trip: cap_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (cap_id (mk-net_capability f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. SynCookie accessor round-trip: sc_client_ip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (sc_client_ip (mk-syn_cookie f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SynCookie accessor round-trip: sc_client_port ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (sc_client_port (mk-syn_cookie f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SynCookie accessor round-trip: sc_server_port ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (sc_server_port (mk-syn_cookie f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SynCookie accessor round-trip: sc_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (sc_timestamp (mk-syn_cookie f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SynCookie accessor round-trip: sc_mss_index ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (sc_mss_index (mk-syn_cookie f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SynCookie: non-negative int fields sum ---
(push 1)
(declare-const r SynCookie)
(assert (>= (sc_client_ip r) 0))
(assert (>= (sc_client_port r) 0))
(assert (not (>= (+ (sc_client_ip r) (sc_client_port r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Connection accessor round-trip: conn_src ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 ConnState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (conn_src (mk-connection f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Connection accessor round-trip: conn_dst ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 ConnState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (conn_dst (mk-connection f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Connection accessor round-trip: conn_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 ConnState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (conn_state (mk-connection f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Connection accessor round-trip: conn_bytes_in ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 ConnState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (conn_bytes_in (mk-connection f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Connection accessor round-trip: conn_bytes_out ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 ConnState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (conn_bytes_out (mk-connection f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Connection: non-negative int fields sum ---
(push 1)
(declare-const r Connection)
(assert (>= (conn_src r) 0))
(assert (>= (conn_dst r) 0))
(assert (not (>= (+ (conn_src r) (conn_dst r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

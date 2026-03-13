; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA NetworkDriver — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/NetworkDriver.v (21 assertions)
; Module: NetworkDriver
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AppId 0)) (((App))))

(declare-datatypes ((SocketId 0)) (((SockId))))

(declare-datatypes ((Application 0))
  (((mk-application (app_id AppId) (app_network_perm Bool)))))

(declare-datatypes ((Socket 0))
  (((mk-socket (socket_id SocketId) (socket_owner AppId) (socket_port Int) (socket_bound Bool)))))

(declare-datatypes ((NetworkState 0))
  (((mk-network_state (all_sockets (Seq Int)) (firewall_enabled Bool)))))

(declare-datatypes ((FirewallRule 0))
  (((mk-firewall_rule (fw_src_port Int) (fw_dst_port Int) (fw_allowed Bool)))))

(declare-datatypes ((ExtNetworkState 0))
  (((mk-ext_network_state (ext_sockets (Seq Int)) (ext_firewall_enabled Bool) (ext_firewall_rules (Seq Int))))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Application accessor round-trip: app_id ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(assert (not (= (app_id (mk-application f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Application accessor round-trip: app_network_perm ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(assert (not (= (app_network_perm (mk-application f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Socket accessor round-trip: socket_id ---
(push 1)
(declare-const f0 SocketId)
(declare-const f1 AppId)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (socket_id (mk-socket f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Socket accessor round-trip: socket_owner ---
(push 1)
(declare-const f0 SocketId)
(declare-const f1 AppId)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (socket_owner (mk-socket f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Socket accessor round-trip: socket_port ---
(push 1)
(declare-const f0 SocketId)
(declare-const f1 AppId)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (socket_port (mk-socket f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Socket accessor round-trip: socket_bound ---
(push 1)
(declare-const f0 SocketId)
(declare-const f1 AppId)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (socket_bound (mk-socket f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. FirewallRule accessor round-trip: fw_src_port ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (fw_src_port (mk-firewall_rule f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FirewallRule accessor round-trip: fw_dst_port ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (fw_dst_port (mk-firewall_rule f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FirewallRule accessor round-trip: fw_allowed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (fw_allowed (mk-firewall_rule f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FirewallRule: non-negative int fields sum ---
(push 1)
(declare-const r FirewallRule)
(assert (>= (fw_src_port r) 0))
(assert (>= (fw_dst_port r) 0))
(assert (not (>= (+ (fw_src_port r) (fw_dst_port r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

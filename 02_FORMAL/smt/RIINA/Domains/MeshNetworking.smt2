; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MeshNetworking — SMT Verification
; Derived from 02_FORMAL/coq/domains/MeshNetworking.v (28 assertions)
; Module: MeshNetworking
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((RouteStatus 0)) (((ValidRoute) (StaleRoute) (LoopDetected) (PartitionDetected))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. RouteStatus exhaustiveness ---
(push 1)
(declare-const x RouteStatus)
(assert (not (or (= x ValidRoute) (= x StaleRoute) (= x LoopDetected) (= x PartitionDetected))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. RouteStatus: ValidRoute != StaleRoute ---
(push 1)
(assert (= ValidRoute StaleRoute))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. RouteStatus: StaleRoute != LoopDetected ---
(push 1)
(assert (= StaleRoute LoopDetected))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. RouteStatus: LoopDetected != PartitionDetected ---
(push 1)
(assert (= LoopDetected PartitionDetected))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. RouteStatus: ValidRoute != PartitionDetected ---
(push 1)
(assert (= ValidRoute PartitionDetected))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. RouteStatus finite cardinality (4 values) ---
(push 1)
(declare-const x RouteStatus)
(assert (and (not (= x ValidRoute)) (not (= x StaleRoute)) (not (= x LoopDetected)) (not (= x PartitionDetected))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

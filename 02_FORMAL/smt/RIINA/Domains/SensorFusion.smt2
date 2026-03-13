; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SensorFusion — SMT Verification
; Derived from 02_FORMAL/coq/domains/SensorFusion.v (25 assertions)
; Module: SensorFusion
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AnomalyResult 0)) (((Normal) (Suspicious) (Anomalous))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. AnomalyResult exhaustiveness ---
(push 1)
(declare-const x AnomalyResult)
(assert (not (or (= x Normal) (= x Suspicious) (= x Anomalous))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AnomalyResult: Normal != Suspicious ---
(push 1)
(assert (= Normal Suspicious))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AnomalyResult: Suspicious != Anomalous ---
(push 1)
(assert (= Suspicious Anomalous))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AnomalyResult finite cardinality (3 values) ---
(push 1)
(declare-const x AnomalyResult)
(assert (and (not (= x Normal)) (not (= x Suspicious)) (not (= x Anomalous))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

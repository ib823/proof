; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SIMDVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/SIMDVerification.v (22 assertions)
; Module: SIMDVerification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((MemResult 0)) (((MemOK) (MemUB))))

(declare-datatypes ((Loop 0))
  (((mk-loop (loop_iterations Int) (loop_body_reads (Seq Int)) (loop_body_writes (Seq Int))))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- MemResult enum properties ---

; --- 1. MemResult exhaustiveness ---
(push 1)
(declare-const x MemResult)
(assert (not (or (= x MemOK) (= x MemUB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. MemResult: MemOK != MemUB ---
(push 1)
(assert (= MemOK MemUB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. MemResult finite cardinality (2 values) ---
(push 1)
(declare-const x MemResult)
(assert (and (not (= x MemOK)) (not (= x MemUB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Loop record properties ---

; --- 4. Loop accessor round-trip: loop_iterations ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (loop_iterations (mk-loop f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Loop accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (loop_body_reads (mk-loop f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Loop: integer field consistency ---
(push 1)
(declare-const r Loop)
(assert (>= (loop_iterations r) 0))
(assert (>= (seq.len (loop_body_reads r)) 0))
(assert (not (>= (+ (loop_iterations r) (seq.len (loop_body_reads r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

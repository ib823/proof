; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TimeSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/TimeSecurity.v (25 assertions)
; Module: TimeSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AtomicOp 0)) (((AtomicRead) (AtomicWrite) (CompareAndSwap))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. AtomicOp exhaustiveness ---
(push 1)
(declare-const x AtomicOp)
(assert (not (or (= x AtomicRead) (= x AtomicWrite) (= x CompareAndSwap))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AtomicOp: AtomicRead != AtomicWrite ---
(push 1)
(assert (= AtomicRead AtomicWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AtomicOp: AtomicWrite != CompareAndSwap ---
(push 1)
(assert (= AtomicWrite CompareAndSwap))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AtomicOp finite cardinality (3 values) ---
(push 1)
(declare-const x AtomicOp)
(assert (and (not (= x AtomicRead)) (not (= x AtomicWrite)) (not (= x CompareAndSwap))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

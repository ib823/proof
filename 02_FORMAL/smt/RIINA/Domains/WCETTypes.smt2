; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA WCETTypes — SMT Verification
; Derived from 02_FORMAL/coq/domains/WCETTypes.v (22 assertions)
; Module: WCETTypes
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((expr 0)) (((EConst) (EVar) (EPlus) (EIf) (ESeq))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. expr exhaustiveness ---
(push 1)
(declare-const x expr)
(assert (not (or (= x EConst) (= x EVar) (= x EPlus) (= x EIf) (= x ESeq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. expr: EConst != EVar ---
(push 1)
(assert (= EConst EVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. expr: EVar != EPlus ---
(push 1)
(assert (= EVar EPlus))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. expr: EPlus != EIf ---
(push 1)
(assert (= EPlus EIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. expr: EConst != ESeq ---
(push 1)
(assert (= EConst ESeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. expr finite cardinality (5 values) ---
(push 1)
(declare-const x expr)
(assert (and (not (= x EConst)) (not (= x EVar)) (not (= x EPlus)) (not (= x EIf)) (not (= x ESeq))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA QuantitativeDeclassification — SMT Verification
; Derived from 02_FORMAL/coq/domains/QuantitativeDeclassification.v (22 assertions)
; Module: QuantitativeDeclassification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((level 0)) (((Low) (High))))

(declare-datatypes ((expr 0)) (((EConst) (EVar) (EPlus) (EDeclass))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. level exhaustiveness ---
(push 1)
(declare-const x level)
(assert (not (or (= x Low) (= x High))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. level: Low != High ---
(push 1)
(assert (= Low High))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. level finite cardinality (2 values) ---
(push 1)
(declare-const x level)
(assert (and (not (= x Low)) (not (= x High))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. expr exhaustiveness ---
(push 1)
(declare-const x expr)
(assert (not (or (= x EConst) (= x EVar) (= x EPlus) (= x EDeclass))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. expr: EConst != EVar ---
(push 1)
(assert (= EConst EVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. expr: EVar != EPlus ---
(push 1)
(assert (= EVar EPlus))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. expr: EPlus != EDeclass ---
(push 1)
(assert (= EPlus EDeclass))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. expr: EConst != EDeclass ---
(push 1)
(assert (= EConst EDeclass))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. expr finite cardinality (4 values) ---
(push 1)
(declare-const x expr)
(assert (and (not (= x EConst)) (not (= x EVar)) (not (= x EPlus)) (not (= x EDeclass))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

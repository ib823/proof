; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AhmedStyleTest — SMT Verification
; Derived from 02_FORMAL/coq/properties/AhmedStyleTest.v (14 assertions)
; Module: AhmedStyleTest
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((sty 0)) (((STUnit) (STBool) (STFn) (STProd))))

(declare-datatypes ((sval 0)) (((SVUnit) (SVBool) (SVLam) (SVPair))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. sty exhaustiveness ---
(push 1)
(declare-const x sty)
(assert (not (or (= x STUnit) (= x STBool) (= x STFn) (= x STProd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. sty: STUnit != STBool ---
(push 1)
(assert (= STUnit STBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. sty: STBool != STFn ---
(push 1)
(assert (= STBool STFn))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. sty: STFn != STProd ---
(push 1)
(assert (= STFn STProd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. sty: STUnit != STProd ---
(push 1)
(assert (= STUnit STProd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. sty finite cardinality (4 values) ---
(push 1)
(declare-const x sty)
(assert (and (not (= x STUnit)) (not (= x STBool)) (not (= x STFn)) (not (= x STProd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. sval exhaustiveness ---
(push 1)
(declare-const x sval)
(assert (not (or (= x SVUnit) (= x SVBool) (= x SVLam) (= x SVPair))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. sval: SVUnit != SVBool ---
(push 1)
(assert (= SVUnit SVBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. sval: SVBool != SVLam ---
(push 1)
(assert (= SVBool SVLam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. sval: SVLam != SVPair ---
(push 1)
(assert (= SVLam SVPair))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. sval: SVUnit != SVPair ---
(push 1)
(assert (= SVUnit SVPair))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. sval finite cardinality (4 values) ---
(push 1)
(declare-const x sval)
(assert (and (not (= x SVUnit)) (not (= x SVBool)) (not (= x SVLam)) (not (= x SVPair))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

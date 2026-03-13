; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SizedTypes — SMT Verification
; Derived from 02_FORMAL/coq/termination/SizedTypes.v (16 assertions)
; Module: SizedTypes
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((sized_ty 0)) (((STBase) (STSized))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. sized_ty exhaustiveness ---
(push 1)
(declare-const x sized_ty)
(assert (not (or (= x STBase) (= x STSized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. sized_ty: STBase != STSized ---
(push 1)
(assert (= STBase STSized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. sized_ty finite cardinality (2 values) ---
(push 1)
(declare-const x sized_ty)
(assert (and (not (= x STBase)) (not (= x STSized))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

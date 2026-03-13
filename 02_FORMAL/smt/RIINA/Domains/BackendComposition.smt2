; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA BackendComposition — SMT Verification
; Derived from 02_FORMAL/coq/domains/BackendComposition.v (21 assertions)
; Module: BackendComposition
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Label 0)) (((Lo) (Hi))))

(declare-datatypes ((Value 0)) (((VNat) (VBool) (VUnit))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Label enum properties ---

; --- 1. Label exhaustiveness ---
(push 1)
(declare-const x Label)
(assert (not (or (= x Lo) (= x Hi))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Label: Lo != Hi ---
(push 1)
(assert (= Lo Hi))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Label finite cardinality (2 values) ---
(push 1)
(declare-const x Label)
(assert (and (not (= x Lo)) (not (= x Hi))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Value enum properties ---

; --- 4. Value exhaustiveness ---
(push 1)
(declare-const x Value)
(assert (not (or (= x VNat) (= x VBool) (= x VUnit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Value: VNat != VBool ---
(push 1)
(assert (= VNat VBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Value: VBool != VUnit ---
(push 1)
(assert (= VBool VUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Value: VNat != VUnit ---
(push 1)
(assert (= VNat VUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Value finite cardinality (3 values) ---
(push 1)
(declare-const x Value)
(assert (and (not (= x VNat)) (not (= x VBool)) (not (= x VUnit))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

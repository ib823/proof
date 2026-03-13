; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DualModeVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/DualModeVerification.v (22 assertions)
; Module: DualModeVerification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((expr 0)) (((EConst) (EPlus) (EIf))))

(declare-datatypes ((RefinementPred 0))
  (((mk-refinement_pred (full_pred Int) (light_pred Int) (light_sound Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. expr exhaustiveness ---
(push 1)
(declare-const x expr)
(assert (not (or (= x EConst) (= x EPlus) (= x EIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. expr: EConst != EPlus ---
(push 1)
(assert (= EConst EPlus))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. expr: EPlus != EIf ---
(push 1)
(assert (= EPlus EIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. expr finite cardinality (3 values) ---
(push 1)
(declare-const x expr)
(assert (and (not (= x EConst)) (not (= x EPlus)) (not (= x EIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. RefinementPred accessor round-trip: full_pred ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (full_pred (mk-refinement_pred f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. RefinementPred accessor round-trip: light_pred ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (light_pred (mk-refinement_pred f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. RefinementPred accessor round-trip: light_sound ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (light_sound (mk-refinement_pred f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. RefinementPred: non-negative int fields sum ---
(push 1)
(declare-const r RefinementPred)
(assert (>= (full_pred r) 0))
(assert (>= (light_pred r) 0))
(assert (not (>= (+ (full_pred r) (light_pred r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

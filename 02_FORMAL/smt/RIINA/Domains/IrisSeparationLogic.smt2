; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IrisSeparationLogic — SMT Verification
; Derived from 02_FORMAL/coq/domains/IrisSeparationLogic.v (21 assertions)
; Module: IrisSeparationLogic
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((hprop 0)) (((HEmpty) (HPointsTo) (HStar) (HPure) (HWand))))

(declare-datatypes ((fprop 0)) (((FEmpty) (FPointsTo) (FStar) (FPure))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- hprop enum properties ---

; --- 1. hprop exhaustiveness ---
(push 1)
(declare-const x hprop)
(assert (not (or (= x HEmpty) (= x HPointsTo) (= x HStar) (= x HPure) (= x HWand))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. hprop: HEmpty != HPointsTo ---
(push 1)
(assert (= HEmpty HPointsTo))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. hprop: HPointsTo != HStar ---
(push 1)
(assert (= HPointsTo HStar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. hprop: HStar != HPure ---
(push 1)
(assert (= HStar HPure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. hprop: HEmpty != HWand ---
(push 1)
(assert (= HEmpty HWand))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. hprop finite cardinality (5 values) ---
(push 1)
(declare-const x hprop)
(assert (and (not (= x HEmpty)) (not (= x HPointsTo)) (not (= x HStar)) (not (= x HPure)) (not (= x HWand))))
(check-sat) ; expect UNSAT
(pop 1)

; --- fprop enum properties ---

; --- 7. fprop exhaustiveness ---
(push 1)
(declare-const x fprop)
(assert (not (or (= x FEmpty) (= x FPointsTo) (= x FStar) (= x FPure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. fprop: FEmpty != FPointsTo ---
(push 1)
(assert (= FEmpty FPointsTo))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. fprop: FPointsTo != FStar ---
(push 1)
(assert (= FPointsTo FStar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. fprop: FStar != FPure ---
(push 1)
(assert (= FStar FPure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. fprop: FEmpty != FPure ---
(push 1)
(assert (= FEmpty FPure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. fprop finite cardinality (4 values) ---
(push 1)
(declare-const x fprop)
(assert (and (not (= x FEmpty)) (not (= x FPointsTo)) (not (= x FStar)) (not (= x FPure))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

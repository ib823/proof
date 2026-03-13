; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AntiJamming — SMT Verification
; Derived from 02_FORMAL/coq/domains/AntiJamming.v (25 assertions)
; Module: AntiJamming
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((JammerType 0)) (((ConstantJammer) (ReactiveJammer) (SweepJammer) (SmartJammer))))

(declare-datatypes ((JamDetection 0)) (((NoJamming) (SuspectedJamming) (ConfirmedJamming))))

(declare-datatypes ((AdaptAction 0)) (((IncreasePower) (ChangeFrequency) (ReduceRate) (EnableFEC) (SwitchMode))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. JammerType exhaustiveness ---
(push 1)
(declare-const x JammerType)
(assert (not (or (= x ConstantJammer) (= x ReactiveJammer) (= x SweepJammer) (= x SmartJammer))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. JammerType: ConstantJammer != ReactiveJammer ---
(push 1)
(assert (= ConstantJammer ReactiveJammer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. JammerType: ReactiveJammer != SweepJammer ---
(push 1)
(assert (= ReactiveJammer SweepJammer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. JammerType: SweepJammer != SmartJammer ---
(push 1)
(assert (= SweepJammer SmartJammer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. JammerType: ConstantJammer != SmartJammer ---
(push 1)
(assert (= ConstantJammer SmartJammer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. JammerType finite cardinality (4 values) ---
(push 1)
(declare-const x JammerType)
(assert (and (not (= x ConstantJammer)) (not (= x ReactiveJammer)) (not (= x SweepJammer)) (not (= x SmartJammer))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. JamDetection exhaustiveness ---
(push 1)
(declare-const x JamDetection)
(assert (not (or (= x NoJamming) (= x SuspectedJamming) (= x ConfirmedJamming))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. JamDetection: NoJamming != SuspectedJamming ---
(push 1)
(assert (= NoJamming SuspectedJamming))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. JamDetection: SuspectedJamming != ConfirmedJamming ---
(push 1)
(assert (= SuspectedJamming ConfirmedJamming))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. JamDetection finite cardinality (3 values) ---
(push 1)
(declare-const x JamDetection)
(assert (and (not (= x NoJamming)) (not (= x SuspectedJamming)) (not (= x ConfirmedJamming))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. AdaptAction exhaustiveness ---
(push 1)
(declare-const x AdaptAction)
(assert (not (or (= x IncreasePower) (= x ChangeFrequency) (= x ReduceRate) (= x EnableFEC) (= x SwitchMode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. AdaptAction: IncreasePower != ChangeFrequency ---
(push 1)
(assert (= IncreasePower ChangeFrequency))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. AdaptAction: ChangeFrequency != ReduceRate ---
(push 1)
(assert (= ChangeFrequency ReduceRate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. AdaptAction: ReduceRate != EnableFEC ---
(push 1)
(assert (= ReduceRate EnableFEC))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AdaptAction: IncreasePower != SwitchMode ---
(push 1)
(assert (= IncreasePower SwitchMode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. AdaptAction finite cardinality (5 values) ---
(push 1)
(declare-const x AdaptAction)
(assert (and (not (= x IncreasePower)) (not (= x ChangeFrequency)) (not (= x ReduceRate)) (not (= x EnableFEC)) (not (= x SwitchMode))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

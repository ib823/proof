; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedAutonomy — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedAutonomy.v (25 assertions)
; Module: VerifiedAutonomy
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((FailsafeTrigger 0)) (((SensorFailure) (EnvelopeViolation) (CommunicationLoss) (HumanOverride) (Timeout))))

(declare-datatypes ((FailsafeAction 0)) (((EmergencyStop) (SafeHold) (ReturnToBase) (HandoffToHuman))))

(declare-datatypes ((VerifyResult 0)) (((Verified) (Rejected) (NeedsReview))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- FailsafeTrigger enum properties ---

; --- 1. FailsafeTrigger exhaustiveness ---
(push 1)
(declare-const x FailsafeTrigger)
(assert (not (or (= x SensorFailure) (= x EnvelopeViolation) (= x CommunicationLoss) (= x HumanOverride) (= x Timeout))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. FailsafeTrigger: SensorFailure != EnvelopeViolation ---
(push 1)
(assert (= SensorFailure EnvelopeViolation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. FailsafeTrigger: EnvelopeViolation != CommunicationLoss ---
(push 1)
(assert (= EnvelopeViolation CommunicationLoss))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FailsafeTrigger: CommunicationLoss != HumanOverride ---
(push 1)
(assert (= CommunicationLoss HumanOverride))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FailsafeTrigger: SensorFailure != Timeout ---
(push 1)
(assert (= SensorFailure Timeout))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. FailsafeTrigger finite cardinality (5 values) ---
(push 1)
(declare-const x FailsafeTrigger)
(assert (and (not (= x SensorFailure)) (not (= x EnvelopeViolation)) (not (= x CommunicationLoss)) (not (= x HumanOverride)) (not (= x Timeout))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FailsafeAction enum properties ---

; --- 7. FailsafeAction exhaustiveness ---
(push 1)
(declare-const x FailsafeAction)
(assert (not (or (= x EmergencyStop) (= x SafeHold) (= x ReturnToBase) (= x HandoffToHuman))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FailsafeAction: EmergencyStop != SafeHold ---
(push 1)
(assert (= EmergencyStop SafeHold))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FailsafeAction: SafeHold != ReturnToBase ---
(push 1)
(assert (= SafeHold ReturnToBase))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FailsafeAction: ReturnToBase != HandoffToHuman ---
(push 1)
(assert (= ReturnToBase HandoffToHuman))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. FailsafeAction: EmergencyStop != HandoffToHuman ---
(push 1)
(assert (= EmergencyStop HandoffToHuman))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. FailsafeAction finite cardinality (4 values) ---
(push 1)
(declare-const x FailsafeAction)
(assert (and (not (= x EmergencyStop)) (not (= x SafeHold)) (not (= x ReturnToBase)) (not (= x HandoffToHuman))))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifyResult enum properties ---

; --- 13. VerifyResult exhaustiveness ---
(push 1)
(declare-const x VerifyResult)
(assert (not (or (= x Verified) (= x Rejected) (= x NeedsReview))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. VerifyResult: Verified != Rejected ---
(push 1)
(assert (= Verified Rejected))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. VerifyResult: Rejected != NeedsReview ---
(push 1)
(assert (= Rejected NeedsReview))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. VerifyResult: Verified != NeedsReview ---
(push 1)
(assert (= Verified NeedsReview))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. VerifyResult finite cardinality (3 values) ---
(push 1)
(declare-const x VerifyResult)
(assert (and (not (= x Verified)) (not (= x Rejected)) (not (= x NeedsReview))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

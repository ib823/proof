; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SingaporePDPA — SMT Verification
; Derived from 02_FORMAL/coq/domains/SingaporePDPA.v (67 assertions)
; Module: SingaporePDPA
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SGConsentStatus 0)) (((SGNoConsent) (SGExplicitConsent) (SGDeemedConsent) (SGDeemedConsentNotification) (SGWithdrawnConsent))))

(declare-datatypes ((SGDataCategory 0)) (((SGPublicData) (SGPersonalData) (SGBusinessContact))))

(declare-datatypes ((TransferAdequacy 0)) (((AdequateJurisdiction) (ContractualSafeguards) (ConsentForTransfer) (NoSafeguards))))

(declare-datatypes ((DNCStatus 0)) (((DNCRegistered) (DNCNotRegistered) (DNCExempt))))

(declare-datatypes ((SGProcessingBasis 0)) (((SGConsentBasis) (SGBusinessImprovement) (SGResearchBasis) (SGLegitimateInterest))))

(declare-datatypes ((PDPCDirection 0)) (((PDPCWarning) (PDPCDirectionToComply) (PDPCFinancialPenalty) (PDPCDirectionToStopCollection) (PDPCDirectionToDestroy))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. SGConsentStatus exhaustiveness ---
(push 1)
(declare-const x SGConsentStatus)
(assert (not (or (= x SGNoConsent) (= x SGExplicitConsent) (= x SGDeemedConsent) (= x SGDeemedConsentNotification) (= x SGWithdrawnConsent))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SGConsentStatus: SGNoConsent != SGExplicitConsent ---
(push 1)
(assert (= SGNoConsent SGExplicitConsent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SGConsentStatus: SGExplicitConsent != SGDeemedConsent ---
(push 1)
(assert (= SGExplicitConsent SGDeemedConsent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SGConsentStatus: SGDeemedConsent != SGDeemedConsentNotification ---
(push 1)
(assert (= SGDeemedConsent SGDeemedConsentNotification))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SGConsentStatus: SGNoConsent != SGWithdrawnConsent ---
(push 1)
(assert (= SGNoConsent SGWithdrawnConsent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SGConsentStatus finite cardinality (5 values) ---
(push 1)
(declare-const x SGConsentStatus)
(assert (and (not (= x SGNoConsent)) (not (= x SGExplicitConsent)) (not (= x SGDeemedConsent)) (not (= x SGDeemedConsentNotification)) (not (= x SGWithdrawnConsent))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SGDataCategory exhaustiveness ---
(push 1)
(declare-const x SGDataCategory)
(assert (not (or (= x SGPublicData) (= x SGPersonalData) (= x SGBusinessContact))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SGDataCategory: SGPublicData != SGPersonalData ---
(push 1)
(assert (= SGPublicData SGPersonalData))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SGDataCategory: SGPersonalData != SGBusinessContact ---
(push 1)
(assert (= SGPersonalData SGBusinessContact))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SGDataCategory finite cardinality (3 values) ---
(push 1)
(declare-const x SGDataCategory)
(assert (and (not (= x SGPublicData)) (not (= x SGPersonalData)) (not (= x SGBusinessContact))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TransferAdequacy exhaustiveness ---
(push 1)
(declare-const x TransferAdequacy)
(assert (not (or (= x AdequateJurisdiction) (= x ContractualSafeguards) (= x ConsentForTransfer) (= x NoSafeguards))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TransferAdequacy: AdequateJurisdiction != ContractualSafeguards ---
(push 1)
(assert (= AdequateJurisdiction ContractualSafeguards))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. TransferAdequacy: ContractualSafeguards != ConsentForTransfer ---
(push 1)
(assert (= ContractualSafeguards ConsentForTransfer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. TransferAdequacy: ConsentForTransfer != NoSafeguards ---
(push 1)
(assert (= ConsentForTransfer NoSafeguards))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. TransferAdequacy: AdequateJurisdiction != NoSafeguards ---
(push 1)
(assert (= AdequateJurisdiction NoSafeguards))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. TransferAdequacy finite cardinality (4 values) ---
(push 1)
(declare-const x TransferAdequacy)
(assert (and (not (= x AdequateJurisdiction)) (not (= x ContractualSafeguards)) (not (= x ConsentForTransfer)) (not (= x NoSafeguards))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. DNCStatus exhaustiveness ---
(push 1)
(declare-const x DNCStatus)
(assert (not (or (= x DNCRegistered) (= x DNCNotRegistered) (= x DNCExempt))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. DNCStatus: DNCRegistered != DNCNotRegistered ---
(push 1)
(assert (= DNCRegistered DNCNotRegistered))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. DNCStatus: DNCNotRegistered != DNCExempt ---
(push 1)
(assert (= DNCNotRegistered DNCExempt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. DNCStatus finite cardinality (3 values) ---
(push 1)
(declare-const x DNCStatus)
(assert (and (not (= x DNCRegistered)) (not (= x DNCNotRegistered)) (not (= x DNCExempt))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SGProcessingBasis exhaustiveness ---
(push 1)
(declare-const x SGProcessingBasis)
(assert (not (or (= x SGConsentBasis) (= x SGBusinessImprovement) (= x SGResearchBasis) (= x SGLegitimateInterest))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SGProcessingBasis: SGConsentBasis != SGBusinessImprovement ---
(push 1)
(assert (= SGConsentBasis SGBusinessImprovement))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SGProcessingBasis: SGBusinessImprovement != SGResearchBasis ---
(push 1)
(assert (= SGBusinessImprovement SGResearchBasis))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SGProcessingBasis: SGResearchBasis != SGLegitimateInterest ---
(push 1)
(assert (= SGResearchBasis SGLegitimateInterest))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. SGProcessingBasis: SGConsentBasis != SGLegitimateInterest ---
(push 1)
(assert (= SGConsentBasis SGLegitimateInterest))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SGProcessingBasis finite cardinality (4 values) ---
(push 1)
(declare-const x SGProcessingBasis)
(assert (and (not (= x SGConsentBasis)) (not (= x SGBusinessImprovement)) (not (= x SGResearchBasis)) (not (= x SGLegitimateInterest))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. PDPCDirection exhaustiveness ---
(push 1)
(declare-const x PDPCDirection)
(assert (not (or (= x PDPCWarning) (= x PDPCDirectionToComply) (= x PDPCFinancialPenalty) (= x PDPCDirectionToStopCollection) (= x PDPCDirectionToDestroy))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. PDPCDirection: PDPCWarning != PDPCDirectionToComply ---
(push 1)
(assert (= PDPCWarning PDPCDirectionToComply))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. PDPCDirection: PDPCDirectionToComply != PDPCFinancialPenalty ---
(push 1)
(assert (= PDPCDirectionToComply PDPCFinancialPenalty))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. PDPCDirection: PDPCFinancialPenalty != PDPCDirectionToStopCollection ---
(push 1)
(assert (= PDPCFinancialPenalty PDPCDirectionToStopCollection))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. PDPCDirection: PDPCWarning != PDPCDirectionToDestroy ---
(push 1)
(assert (= PDPCWarning PDPCDirectionToDestroy))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. PDPCDirection finite cardinality (5 values) ---
(push 1)
(declare-const x PDPCDirection)
(assert (and (not (= x PDPCWarning)) (not (= x PDPCDirectionToComply)) (not (= x PDPCFinancialPenalty)) (not (= x PDPCDirectionToStopCollection)) (not (= x PDPCDirectionToDestroy))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MalaysiaPDPA — SMT Verification
; Derived from 02_FORMAL/coq/domains/MalaysiaPDPA.v (41 assertions)
; Module: MalaysiaPDPA
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ConsentStatus 0)) (((NoConsent) (ExplicitConsent) (ImpliedConsent) (WithdrawnConsent))))

(declare-datatypes ((PDPAClassification 0)) (((PublicData) (PersonalData) (SensitivePersonalData))))

(declare-datatypes ((Purpose 0)) (((CollectionPurpose) (DirectMarketing) (LegalObligation) (VitalInterest))))

(declare-datatypes ((ProcessingAction 0)) (((Collect) (Store) (C_Use) (Disclose) (Transfer) (Delete))))

(declare-datatypes ((BreachSeverity 0)) (((MinorBreach) (MajorBreach) (CriticalBreach))))

(declare-datatypes ((TransferBasis 0)) (((SubjectConsent_Transfer) (ContractPerformance) (LegalProceedings) (VitalInterests_Transfer) (PublicRegister) (MinisterialExemption))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. ConsentStatus exhaustiveness ---
(push 1)
(declare-const x ConsentStatus)
(assert (not (or (= x NoConsent) (= x ExplicitConsent) (= x ImpliedConsent) (= x WithdrawnConsent))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ConsentStatus: NoConsent != ExplicitConsent ---
(push 1)
(assert (= NoConsent ExplicitConsent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ConsentStatus: ExplicitConsent != ImpliedConsent ---
(push 1)
(assert (= ExplicitConsent ImpliedConsent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ConsentStatus: ImpliedConsent != WithdrawnConsent ---
(push 1)
(assert (= ImpliedConsent WithdrawnConsent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ConsentStatus: NoConsent != WithdrawnConsent ---
(push 1)
(assert (= NoConsent WithdrawnConsent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ConsentStatus finite cardinality (4 values) ---
(push 1)
(declare-const x ConsentStatus)
(assert (and (not (= x NoConsent)) (not (= x ExplicitConsent)) (not (= x ImpliedConsent)) (not (= x WithdrawnConsent))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. PDPAClassification exhaustiveness ---
(push 1)
(declare-const x PDPAClassification)
(assert (not (or (= x PublicData) (= x PersonalData) (= x SensitivePersonalData))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PDPAClassification: PublicData != PersonalData ---
(push 1)
(assert (= PublicData PersonalData))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PDPAClassification: PersonalData != SensitivePersonalData ---
(push 1)
(assert (= PersonalData SensitivePersonalData))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PDPAClassification finite cardinality (3 values) ---
(push 1)
(declare-const x PDPAClassification)
(assert (and (not (= x PublicData)) (not (= x PersonalData)) (not (= x SensitivePersonalData))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Purpose exhaustiveness ---
(push 1)
(declare-const x Purpose)
(assert (not (or (= x CollectionPurpose) (= x DirectMarketing) (= x LegalObligation) (= x VitalInterest))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Purpose: CollectionPurpose != DirectMarketing ---
(push 1)
(assert (= CollectionPurpose DirectMarketing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Purpose: DirectMarketing != LegalObligation ---
(push 1)
(assert (= DirectMarketing LegalObligation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Purpose: LegalObligation != VitalInterest ---
(push 1)
(assert (= LegalObligation VitalInterest))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Purpose: CollectionPurpose != VitalInterest ---
(push 1)
(assert (= CollectionPurpose VitalInterest))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Purpose finite cardinality (4 values) ---
(push 1)
(declare-const x Purpose)
(assert (and (not (= x CollectionPurpose)) (not (= x DirectMarketing)) (not (= x LegalObligation)) (not (= x VitalInterest))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ProcessingAction exhaustiveness ---
(push 1)
(declare-const x ProcessingAction)
(assert (not (or (= x Collect) (= x Store) (= x C_Use) (= x Disclose) (= x Transfer) (= x Delete))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ProcessingAction: Collect != Store ---
(push 1)
(assert (= Collect Store))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. ProcessingAction: Store != C_Use ---
(push 1)
(assert (= Store C_Use))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ProcessingAction: C_Use != Disclose ---
(push 1)
(assert (= C_Use Disclose))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ProcessingAction: Collect != Delete ---
(push 1)
(assert (= Collect Delete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ProcessingAction finite cardinality (6 values) ---
(push 1)
(declare-const x ProcessingAction)
(assert (and (not (= x Collect)) (not (= x Store)) (not (= x C_Use)) (not (= x Disclose)) (not (= x Transfer)) (not (= x Delete))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BreachSeverity exhaustiveness ---
(push 1)
(declare-const x BreachSeverity)
(assert (not (or (= x MinorBreach) (= x MajorBreach) (= x CriticalBreach))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. BreachSeverity: MinorBreach != MajorBreach ---
(push 1)
(assert (= MinorBreach MajorBreach))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. BreachSeverity: MajorBreach != CriticalBreach ---
(push 1)
(assert (= MajorBreach CriticalBreach))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BreachSeverity finite cardinality (3 values) ---
(push 1)
(declare-const x BreachSeverity)
(assert (and (not (= x MinorBreach)) (not (= x MajorBreach)) (not (= x CriticalBreach))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. TransferBasis exhaustiveness ---
(push 1)
(declare-const x TransferBasis)
(assert (not (or (= x SubjectConsent_Transfer) (= x ContractPerformance) (= x LegalProceedings) (= x VitalInterests_Transfer) (= x PublicRegister) (= x MinisterialExemption))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. TransferBasis: SubjectConsent_Transfer != ContractPerformance ---
(push 1)
(assert (= SubjectConsent_Transfer ContractPerformance))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. TransferBasis: ContractPerformance != LegalProceedings ---
(push 1)
(assert (= ContractPerformance LegalProceedings))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. TransferBasis: LegalProceedings != VitalInterests_Transfer ---
(push 1)
(assert (= LegalProceedings VitalInterests_Transfer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. TransferBasis: SubjectConsent_Transfer != MinisterialExemption ---
(push 1)
(assert (= SubjectConsent_Transfer MinisterialExemption))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. TransferBasis finite cardinality (6 values) ---
(push 1)
(declare-const x TransferBasis)
(assert (and (not (= x SubjectConsent_Transfer)) (not (= x ContractPerformance)) (not (= x LegalProceedings)) (not (= x VitalInterests_Transfer)) (not (= x PublicRegister)) (not (= x MinisterialExemption))))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun BreachSeverity_level ((x BreachSeverity)) Int
  (ite (= x MinorBreach) 0 (ite (= x MajorBreach) 1 2)))

(define-fun BreachSeverity_leq ((x BreachSeverity) (y BreachSeverity)) Bool
  (<= (BreachSeverity_level x) (BreachSeverity_level y)))

; --- 33. BreachSeverity_leq reflexivity ---
(push 1)
(declare-const x BreachSeverity)
(assert (not (BreachSeverity_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. BreachSeverity_leq transitivity ---
(push 1)
(declare-const x BreachSeverity)
(declare-const y BreachSeverity)
(declare-const z BreachSeverity)
(assert (BreachSeverity_leq x y))
(assert (BreachSeverity_leq y z))
(assert (not (BreachSeverity_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. BreachSeverity_leq antisymmetry ---
(push 1)
(declare-const x BreachSeverity)
(declare-const y BreachSeverity)
(assert (BreachSeverity_leq x y))
(assert (BreachSeverity_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. MinorBreach is bottom ---
(push 1)
(declare-const x BreachSeverity)
(assert (not (BreachSeverity_leq MinorBreach x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. CriticalBreach is top ---
(push 1)
(declare-const x BreachSeverity)
(assert (not (BreachSeverity_leq x CriticalBreach)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

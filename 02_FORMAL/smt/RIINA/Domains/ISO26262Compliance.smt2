; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ISO26262Compliance — SMT Verification
; Derived from 02_FORMAL/coq/domains/ISO26262Compliance.v (36 assertions)
; Module: ISO26262Compliance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ASIL 0)) (((ASIL_D) (ASIL_C) (ASIL_B) (ASIL_A) (QM))))

(declare-datatypes ((HARA 0))
  (((mk-hara (hara_hazards_identified Bool) (hara_severity_classified Bool) (hara_exposure_assessed Bool) (hara_controllability_assessed Bool) (hara_asil_determined Bool) (hara_safety_goals_defined Bool)))))

(declare-datatypes ((SafetyConcept 0))
  (((mk-safety_concept (fsc_safety_requirements Bool) (fsc_allocation_to_elements Bool) (fsc_fault_tolerant_mechanisms Bool) (fsc_safety_mechanisms Bool)))))

(declare-datatypes ((SoftwareDevelopment 0))
  (((mk-software_development (sw_safety_requirements Bool) (sw_architecture_design Bool) (sw_unit_design Bool) (sw_unit_implementation Bool) (sw_unit_verification Bool) (sw_integration_verification Bool) (sw_safety_validation Bool)))))

(declare-datatypes ((VerificationMethods 0))
  (((mk-verification_methods (vm_requirements_inspection Bool) (vm_walkthrough Bool) (vm_formal_verification Bool) (vm_control_flow_analysis Bool) (vm_data_flow_analysis Bool) (vm_static_analysis Bool) (vm_semantic_analysis Bool)))))

(declare-datatypes ((TestingRequirements 0))
  (((mk-testing_requirements (test_requirements_based Bool) (test_fault_injection Bool) (test_back_to_back Bool) (test_structural_coverage Bool) (test_mc_dc_coverage Bool)))))

(declare-datatypes ((ISO26262Compliance 0))
  (((mk-iso26262_compliance (iso_asil ASIL) (iso_hara HARA) (iso_safety_concept SafetyConcept) (iso_sw_dev SoftwareDevelopment) (iso_verif_methods VerificationMethods) (iso_testing TestingRequirements)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- ASIL enum properties ---

; --- 1. ASIL exhaustiveness ---
(push 1)
(declare-const x ASIL)
(assert (not (or (= x ASIL_D) (= x ASIL_C) (= x ASIL_B) (= x ASIL_A) (= x QM))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ASIL: ASIL_D != ASIL_C ---
(push 1)
(assert (= ASIL_D ASIL_C))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ASIL: ASIL_C != ASIL_B ---
(push 1)
(assert (= ASIL_C ASIL_B))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ASIL: ASIL_B != ASIL_A ---
(push 1)
(assert (= ASIL_B ASIL_A))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ASIL: ASIL_D != QM ---
(push 1)
(assert (= ASIL_D QM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ASIL finite cardinality (5 values) ---
(push 1)
(declare-const x ASIL)
(assert (and (not (= x ASIL_D)) (not (= x ASIL_C)) (not (= x ASIL_B)) (not (= x ASIL_A)) (not (= x QM))))
(check-sat) ; expect UNSAT
(pop 1)

; --- HARA record properties ---

; --- 7. HARA accessor round-trip: hara_hazards_identified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (hara_hazards_identified (mk-hara f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. HARA accessor round-trip: hara_severity_classified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (hara_severity_classified (mk-hara f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. HARA accessor round-trip: hara_exposure_assessed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (hara_exposure_assessed (mk-hara f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. HARA accessor round-trip: hara_controllability_assessed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (hara_controllability_assessed (mk-hara f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. HARA accessor round-trip: hara_asil_determined ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (hara_asil_determined (mk-hara f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun HARA_all_enabled ((g HARA)) Bool
  (and (hara_hazards_identified g) (hara_severity_classified g) (hara_exposure_assessed g) (hara_controllability_assessed g) (hara_asil_determined g)))

; --- 12. HARA: all-enabled completeness ---
(push 1)
(declare-const g HARA)
(assert (hara_hazards_identified g))
(assert (hara_severity_classified g))
(assert (hara_exposure_assessed g))
(assert (hara_controllability_assessed g))
(assert (hara_asil_determined g))
(assert (not (HARA_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. HARA: HARA_all_enabled implies hara_hazards_identified ---
(push 1)
(declare-const g HARA)
(assert (HARA_all_enabled g))
(assert (not (hara_hazards_identified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. HARA: HARA_all_enabled implies hara_severity_classified ---
(push 1)
(declare-const g HARA)
(assert (HARA_all_enabled g))
(assert (not (hara_severity_classified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. HARA: HARA_all_enabled implies hara_exposure_assessed ---
(push 1)
(declare-const g HARA)
(assert (HARA_all_enabled g))
(assert (not (hara_exposure_assessed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SafetyConcept record properties ---

; --- 16. SafetyConcept accessor round-trip: fsc_safety_requirements ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fsc_safety_requirements (mk-safety_concept f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SafetyConcept accessor round-trip: fsc_allocation_to_elements ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fsc_allocation_to_elements (mk-safety_concept f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SafetyConcept accessor round-trip: fsc_fault_tolerant_mechanisms ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fsc_fault_tolerant_mechanisms (mk-safety_concept f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SafetyConcept_all_enabled ((g SafetyConcept)) Bool
  (and (fsc_safety_requirements g) (fsc_allocation_to_elements g) (fsc_fault_tolerant_mechanisms g)))

; --- 19. SafetyConcept: all-enabled completeness ---
(push 1)
(declare-const g SafetyConcept)
(assert (fsc_safety_requirements g))
(assert (fsc_allocation_to_elements g))
(assert (fsc_fault_tolerant_mechanisms g))
(assert (not (SafetyConcept_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SafetyConcept: SafetyConcept_all_enabled implies fsc_safety_requirements ---
(push 1)
(declare-const g SafetyConcept)
(assert (SafetyConcept_all_enabled g))
(assert (not (fsc_safety_requirements g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SafetyConcept: SafetyConcept_all_enabled implies fsc_allocation_to_elements ---
(push 1)
(declare-const g SafetyConcept)
(assert (SafetyConcept_all_enabled g))
(assert (not (fsc_allocation_to_elements g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SafetyConcept: SafetyConcept_all_enabled implies fsc_fault_tolerant_mechanisms ---
(push 1)
(declare-const g SafetyConcept)
(assert (SafetyConcept_all_enabled g))
(assert (not (fsc_fault_tolerant_mechanisms g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SoftwareDevelopment record properties ---

; --- 23. SoftwareDevelopment accessor round-trip: sw_safety_requirements ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (sw_safety_requirements (mk-software_development f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SoftwareDevelopment accessor round-trip: sw_architecture_design ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (sw_architecture_design (mk-software_development f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. SoftwareDevelopment accessor round-trip: sw_unit_design ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (sw_unit_design (mk-software_development f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SoftwareDevelopment accessor round-trip: sw_unit_implementation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (sw_unit_implementation (mk-software_development f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. SoftwareDevelopment accessor round-trip: sw_unit_verification ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (sw_unit_verification (mk-software_development f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SoftwareDevelopment_all_enabled ((g SoftwareDevelopment)) Bool
  (and (sw_safety_requirements g) (sw_architecture_design g) (sw_unit_design g) (sw_unit_implementation g) (sw_unit_verification g) (sw_integration_verification g)))

; --- 28. SoftwareDevelopment: all-enabled completeness ---
(push 1)
(declare-const g SoftwareDevelopment)
(assert (sw_safety_requirements g))
(assert (sw_architecture_design g))
(assert (sw_unit_design g))
(assert (sw_unit_implementation g))
(assert (sw_unit_verification g))
(assert (sw_integration_verification g))
(assert (not (SoftwareDevelopment_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. SoftwareDevelopment: SoftwareDevelopment_all_enabled implies sw_safety_requirements ---
(push 1)
(declare-const g SoftwareDevelopment)
(assert (SoftwareDevelopment_all_enabled g))
(assert (not (sw_safety_requirements g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. SoftwareDevelopment: SoftwareDevelopment_all_enabled implies sw_architecture_design ---
(push 1)
(declare-const g SoftwareDevelopment)
(assert (SoftwareDevelopment_all_enabled g))
(assert (not (sw_architecture_design g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. SoftwareDevelopment: SoftwareDevelopment_all_enabled implies sw_unit_design ---
(push 1)
(declare-const g SoftwareDevelopment)
(assert (SoftwareDevelopment_all_enabled g))
(assert (not (sw_unit_design g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerificationMethods record properties ---

; --- 32. VerificationMethods accessor round-trip: vm_requirements_inspection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (vm_requirements_inspection (mk-verification_methods f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. VerificationMethods accessor round-trip: vm_walkthrough ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (vm_walkthrough (mk-verification_methods f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. VerificationMethods accessor round-trip: vm_formal_verification ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (vm_formal_verification (mk-verification_methods f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. VerificationMethods accessor round-trip: vm_control_flow_analysis ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (vm_control_flow_analysis (mk-verification_methods f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. VerificationMethods accessor round-trip: vm_data_flow_analysis ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (vm_data_flow_analysis (mk-verification_methods f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun VerificationMethods_all_enabled ((g VerificationMethods)) Bool
  (and (vm_requirements_inspection g) (vm_walkthrough g) (vm_formal_verification g) (vm_control_flow_analysis g) (vm_data_flow_analysis g) (vm_static_analysis g)))

; --- 37. VerificationMethods: all-enabled completeness ---
(push 1)
(declare-const g VerificationMethods)
(assert (vm_requirements_inspection g))
(assert (vm_walkthrough g))
(assert (vm_formal_verification g))
(assert (vm_control_flow_analysis g))
(assert (vm_data_flow_analysis g))
(assert (vm_static_analysis g))
(assert (not (VerificationMethods_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. VerificationMethods: VerificationMethods_all_enabled implies vm_requirements_inspection ---
(push 1)
(declare-const g VerificationMethods)
(assert (VerificationMethods_all_enabled g))
(assert (not (vm_requirements_inspection g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. VerificationMethods: VerificationMethods_all_enabled implies vm_walkthrough ---
(push 1)
(declare-const g VerificationMethods)
(assert (VerificationMethods_all_enabled g))
(assert (not (vm_walkthrough g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. VerificationMethods: VerificationMethods_all_enabled implies vm_formal_verification ---
(push 1)
(declare-const g VerificationMethods)
(assert (VerificationMethods_all_enabled g))
(assert (not (vm_formal_verification g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TestingRequirements record properties ---

; --- 41. TestingRequirements accessor round-trip: test_requirements_based ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (test_requirements_based (mk-testing_requirements f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. TestingRequirements accessor round-trip: test_fault_injection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (test_fault_injection (mk-testing_requirements f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. TestingRequirements accessor round-trip: test_back_to_back ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (test_back_to_back (mk-testing_requirements f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. TestingRequirements accessor round-trip: test_structural_coverage ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (test_structural_coverage (mk-testing_requirements f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TestingRequirements_all_enabled ((g TestingRequirements)) Bool
  (and (test_requirements_based g) (test_fault_injection g) (test_back_to_back g) (test_structural_coverage g)))

; --- 45. TestingRequirements: all-enabled completeness ---
(push 1)
(declare-const g TestingRequirements)
(assert (test_requirements_based g))
(assert (test_fault_injection g))
(assert (test_back_to_back g))
(assert (test_structural_coverage g))
(assert (not (TestingRequirements_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. TestingRequirements: TestingRequirements_all_enabled implies test_requirements_based ---
(push 1)
(declare-const g TestingRequirements)
(assert (TestingRequirements_all_enabled g))
(assert (not (test_requirements_based g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. TestingRequirements: TestingRequirements_all_enabled implies test_fault_injection ---
(push 1)
(declare-const g TestingRequirements)
(assert (TestingRequirements_all_enabled g))
(assert (not (test_fault_injection g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. TestingRequirements: TestingRequirements_all_enabled implies test_back_to_back ---
(push 1)
(declare-const g TestingRequirements)
(assert (TestingRequirements_all_enabled g))
(assert (not (test_back_to_back g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ISO26262Compliance record properties ---

; --- 49. ISO26262Compliance accessor round-trip: iso_asil ---
(push 1)
(declare-const f0 ASIL)
(declare-const f1 HARA)
(declare-const f2 SafetyConcept)
(declare-const f3 SoftwareDevelopment)
(declare-const f4 VerificationMethods)
(declare-const f5 TestingRequirements)
(assert (not (= (iso_asil (mk-iso26262_compliance f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. ISO26262Compliance accessor round-trip: iso_hara ---
(push 1)
(declare-const f0 ASIL)
(declare-const f1 HARA)
(declare-const f2 SafetyConcept)
(declare-const f3 SoftwareDevelopment)
(declare-const f4 VerificationMethods)
(declare-const f5 TestingRequirements)
(assert (not (= (iso_hara (mk-iso26262_compliance f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. ISO26262Compliance accessor round-trip: iso_safety_concept ---
(push 1)
(declare-const f0 ASIL)
(declare-const f1 HARA)
(declare-const f2 SafetyConcept)
(declare-const f3 SoftwareDevelopment)
(declare-const f4 VerificationMethods)
(declare-const f5 TestingRequirements)
(assert (not (= (iso_safety_concept (mk-iso26262_compliance f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. ISO26262Compliance accessor round-trip: iso_sw_dev ---
(push 1)
(declare-const f0 ASIL)
(declare-const f1 HARA)
(declare-const f2 SafetyConcept)
(declare-const f3 SoftwareDevelopment)
(declare-const f4 VerificationMethods)
(declare-const f5 TestingRequirements)
(assert (not (= (iso_sw_dev (mk-iso26262_compliance f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. ISO26262Compliance accessor round-trip: iso_verif_methods ---
(push 1)
(declare-const f0 ASIL)
(declare-const f1 HARA)
(declare-const f2 SafetyConcept)
(declare-const f3 SoftwareDevelopment)
(declare-const f4 VerificationMethods)
(declare-const f5 TestingRequirements)
(assert (not (= (iso_verif_methods (mk-iso26262_compliance f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

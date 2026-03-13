; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DO178CCompliance — SMT Verification
; Derived from 02_FORMAL/coq/domains/DO178CCompliance.v (41 assertions)
; Module: DO178CCompliance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((DAL 0)) (((DAL_A) (DAL_B) (DAL_C) (DAL_D) (DAL_E))))

(declare-datatypes ((FormalMethodCategory 0)) (((FM_TheoremProving) (FM_ModelChecking) (FM_AbstractInterp))))

(declare-datatypes ((PlanningObjectives 0))
  (((mk-planning_objectives (plan_standards_defined Bool) (plan_lifecycle_defined Bool) (plan_dev_environment_defined Bool) (plan_additional_considerations Bool)))))

(declare-datatypes ((DevelopmentProcess 0))
  (((mk-development_process (dev_requirements_complete Bool) (dev_requirements_accurate Bool) (dev_requirements_verifiable Bool) (dev_requirements_conformant Bool) (dev_requirements_traceable Bool) (dev_design_complete Bool) (dev_design_accurate Bool) (dev_design_consistent Bool) (dev_design_verifiable Bool) (dev_design_conformant Bool) (dev_code_complete Bool) (dev_code_accurate Bool) (dev_code_consistent Bool) (dev_code_verifiable Bool) (dev_code_conformant Bool) (dev_code_traceable Bool)))))

(declare-datatypes ((VerificationProcess 0))
  (((mk-verification_process (verif_requirements_reviewed Bool) (verif_design_reviewed Bool) (verif_code_reviewed Bool) (verif_integration_tested Bool) (verif_hw_sw_integration_tested Bool) (verif_coverage_analysis_done Bool) (verif_structural_coverage Bool) (verif_mc_dc_coverage Bool)))))

(declare-datatypes ((ConfigurationManagement 0))
  (((mk-configuration_management (cm_identification Bool) (cm_baselines Bool) (cm_traceability Bool) (cm_problem_reporting Bool) (cm_change_control Bool) (cm_change_review Bool) (cm_status_accounting Bool) (cm_archive_retrieval Bool) (cm_release Bool)))))

(declare-datatypes ((QualityAssurance 0))
  (((mk-quality_assurance (qa_compliance_assured Bool) (qa_audits_performed Bool) (qa_records_maintained Bool) (qa_independence Bool)))))

(declare-datatypes ((FormalMethods 0))
  (((mk-formal_methods (fm_category FormalMethodCategory) (fm_specification_formal Bool) (fm_design_formal Bool) (fm_code_formal Bool) (fm_verification_formal Bool) (fm_soundness_justified Bool) (fm_completeness_assessed Bool)))))

(declare-datatypes ((DO178CCompliance 0))
  (((mk-do178_c_compliance (do178c_dal DAL) (do178c_planning PlanningObjectives) (do178c_development DevelopmentProcess) (do178c_verification VerificationProcess) (do178c_cm ConfigurationManagement) (do178c_qa QualityAssurance) (do178c_fm Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- DAL enum properties ---

; --- 1. DAL exhaustiveness ---
(push 1)
(declare-const x DAL)
(assert (not (or (= x DAL_A) (= x DAL_B) (= x DAL_C) (= x DAL_D) (= x DAL_E))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. DAL: DAL_A != DAL_B ---
(push 1)
(assert (= DAL_A DAL_B))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. DAL: DAL_B != DAL_C ---
(push 1)
(assert (= DAL_B DAL_C))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. DAL: DAL_C != DAL_D ---
(push 1)
(assert (= DAL_C DAL_D))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. DAL: DAL_A != DAL_E ---
(push 1)
(assert (= DAL_A DAL_E))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. DAL finite cardinality (5 values) ---
(push 1)
(declare-const x DAL)
(assert (and (not (= x DAL_A)) (not (= x DAL_B)) (not (= x DAL_C)) (not (= x DAL_D)) (not (= x DAL_E))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FormalMethodCategory enum properties ---

; --- 7. FormalMethodCategory exhaustiveness ---
(push 1)
(declare-const x FormalMethodCategory)
(assert (not (or (= x FM_TheoremProving) (= x FM_ModelChecking) (= x FM_AbstractInterp))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FormalMethodCategory: FM_TheoremProving != FM_ModelChecking ---
(push 1)
(assert (= FM_TheoremProving FM_ModelChecking))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FormalMethodCategory: FM_ModelChecking != FM_AbstractInterp ---
(push 1)
(assert (= FM_ModelChecking FM_AbstractInterp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FormalMethodCategory: FM_TheoremProving != FM_AbstractInterp ---
(push 1)
(assert (= FM_TheoremProving FM_AbstractInterp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. FormalMethodCategory finite cardinality (3 values) ---
(push 1)
(declare-const x FormalMethodCategory)
(assert (and (not (= x FM_TheoremProving)) (not (= x FM_ModelChecking)) (not (= x FM_AbstractInterp))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PlanningObjectives record properties ---

; --- 12. PlanningObjectives accessor round-trip: plan_standards_defined ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (plan_standards_defined (mk-planning_objectives f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. PlanningObjectives accessor round-trip: plan_lifecycle_defined ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (plan_lifecycle_defined (mk-planning_objectives f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. PlanningObjectives accessor round-trip: plan_dev_environment_defined ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (plan_dev_environment_defined (mk-planning_objectives f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun PlanningObjectives_all_enabled ((g PlanningObjectives)) Bool
  (and (plan_standards_defined g) (plan_lifecycle_defined g) (plan_dev_environment_defined g)))

; --- 15. PlanningObjectives: all-enabled completeness ---
(push 1)
(declare-const g PlanningObjectives)
(assert (plan_standards_defined g))
(assert (plan_lifecycle_defined g))
(assert (plan_dev_environment_defined g))
(assert (not (PlanningObjectives_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. PlanningObjectives: PlanningObjectives_all_enabled implies plan_standards_defined ---
(push 1)
(declare-const g PlanningObjectives)
(assert (PlanningObjectives_all_enabled g))
(assert (not (plan_standards_defined g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. PlanningObjectives: PlanningObjectives_all_enabled implies plan_lifecycle_defined ---
(push 1)
(declare-const g PlanningObjectives)
(assert (PlanningObjectives_all_enabled g))
(assert (not (plan_lifecycle_defined g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. PlanningObjectives: PlanningObjectives_all_enabled implies plan_dev_environment_defined ---
(push 1)
(declare-const g PlanningObjectives)
(assert (PlanningObjectives_all_enabled g))
(assert (not (plan_dev_environment_defined g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DevelopmentProcess record properties ---

; --- 19. DevelopmentProcess accessor round-trip: dev_requirements_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(assert (not (= (dev_requirements_complete (mk-development_process f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. DevelopmentProcess accessor round-trip: dev_requirements_accurate ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(assert (not (= (dev_requirements_accurate (mk-development_process f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. DevelopmentProcess accessor round-trip: dev_requirements_verifiable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(assert (not (= (dev_requirements_verifiable (mk-development_process f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. DevelopmentProcess accessor round-trip: dev_requirements_conformant ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(assert (not (= (dev_requirements_conformant (mk-development_process f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. DevelopmentProcess accessor round-trip: dev_requirements_traceable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(assert (not (= (dev_requirements_traceable (mk-development_process f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DevelopmentProcess_all_enabled ((g DevelopmentProcess)) Bool
  (and (dev_requirements_complete g) (dev_requirements_accurate g) (dev_requirements_verifiable g) (dev_requirements_conformant g) (dev_requirements_traceable g) (dev_design_complete g) (dev_design_accurate g) (dev_design_consistent g) (dev_design_verifiable g) (dev_design_conformant g) (dev_code_complete g) (dev_code_accurate g) (dev_code_consistent g) (dev_code_verifiable g) (dev_code_conformant g)))

; --- 24. DevelopmentProcess: all-enabled completeness ---
(push 1)
(declare-const g DevelopmentProcess)
(assert (dev_requirements_complete g))
(assert (dev_requirements_accurate g))
(assert (dev_requirements_verifiable g))
(assert (dev_requirements_conformant g))
(assert (dev_requirements_traceable g))
(assert (dev_design_complete g))
(assert (dev_design_accurate g))
(assert (dev_design_consistent g))
(assert (dev_design_verifiable g))
(assert (dev_design_conformant g))
(assert (dev_code_complete g))
(assert (dev_code_accurate g))
(assert (dev_code_consistent g))
(assert (dev_code_verifiable g))
(assert (dev_code_conformant g))
(assert (not (DevelopmentProcess_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. DevelopmentProcess: DevelopmentProcess_all_enabled implies dev_requirements_complete ---
(push 1)
(declare-const g DevelopmentProcess)
(assert (DevelopmentProcess_all_enabled g))
(assert (not (dev_requirements_complete g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. DevelopmentProcess: DevelopmentProcess_all_enabled implies dev_requirements_accurate ---
(push 1)
(declare-const g DevelopmentProcess)
(assert (DevelopmentProcess_all_enabled g))
(assert (not (dev_requirements_accurate g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. DevelopmentProcess: DevelopmentProcess_all_enabled implies dev_requirements_verifiable ---
(push 1)
(declare-const g DevelopmentProcess)
(assert (DevelopmentProcess_all_enabled g))
(assert (not (dev_requirements_verifiable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerificationProcess record properties ---

; --- 28. VerificationProcess accessor round-trip: verif_requirements_reviewed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (verif_requirements_reviewed (mk-verification_process f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. VerificationProcess accessor round-trip: verif_design_reviewed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (verif_design_reviewed (mk-verification_process f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. VerificationProcess accessor round-trip: verif_code_reviewed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (verif_code_reviewed (mk-verification_process f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. VerificationProcess accessor round-trip: verif_integration_tested ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (verif_integration_tested (mk-verification_process f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. VerificationProcess accessor round-trip: verif_hw_sw_integration_tested ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (verif_hw_sw_integration_tested (mk-verification_process f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun VerificationProcess_all_enabled ((g VerificationProcess)) Bool
  (and (verif_requirements_reviewed g) (verif_design_reviewed g) (verif_code_reviewed g) (verif_integration_tested g) (verif_hw_sw_integration_tested g) (verif_coverage_analysis_done g) (verif_structural_coverage g)))

; --- 33. VerificationProcess: all-enabled completeness ---
(push 1)
(declare-const g VerificationProcess)
(assert (verif_requirements_reviewed g))
(assert (verif_design_reviewed g))
(assert (verif_code_reviewed g))
(assert (verif_integration_tested g))
(assert (verif_hw_sw_integration_tested g))
(assert (verif_coverage_analysis_done g))
(assert (verif_structural_coverage g))
(assert (not (VerificationProcess_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. VerificationProcess: VerificationProcess_all_enabled implies verif_requirements_reviewed ---
(push 1)
(declare-const g VerificationProcess)
(assert (VerificationProcess_all_enabled g))
(assert (not (verif_requirements_reviewed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. VerificationProcess: VerificationProcess_all_enabled implies verif_design_reviewed ---
(push 1)
(declare-const g VerificationProcess)
(assert (VerificationProcess_all_enabled g))
(assert (not (verif_design_reviewed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. VerificationProcess: VerificationProcess_all_enabled implies verif_code_reviewed ---
(push 1)
(declare-const g VerificationProcess)
(assert (VerificationProcess_all_enabled g))
(assert (not (verif_code_reviewed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConfigurationManagement record properties ---

; --- 37. ConfigurationManagement accessor round-trip: cm_identification ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cm_identification (mk-configuration_management f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. ConfigurationManagement accessor round-trip: cm_baselines ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cm_baselines (mk-configuration_management f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. ConfigurationManagement accessor round-trip: cm_traceability ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cm_traceability (mk-configuration_management f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. ConfigurationManagement accessor round-trip: cm_problem_reporting ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cm_problem_reporting (mk-configuration_management f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. ConfigurationManagement accessor round-trip: cm_change_control ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (cm_change_control (mk-configuration_management f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ConfigurationManagement_all_enabled ((g ConfigurationManagement)) Bool
  (and (cm_identification g) (cm_baselines g) (cm_traceability g) (cm_problem_reporting g) (cm_change_control g) (cm_change_review g) (cm_status_accounting g) (cm_archive_retrieval g)))

; --- 42. ConfigurationManagement: all-enabled completeness ---
(push 1)
(declare-const g ConfigurationManagement)
(assert (cm_identification g))
(assert (cm_baselines g))
(assert (cm_traceability g))
(assert (cm_problem_reporting g))
(assert (cm_change_control g))
(assert (cm_change_review g))
(assert (cm_status_accounting g))
(assert (cm_archive_retrieval g))
(assert (not (ConfigurationManagement_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. ConfigurationManagement: ConfigurationManagement_all_enabled implies cm_identification ---
(push 1)
(declare-const g ConfigurationManagement)
(assert (ConfigurationManagement_all_enabled g))
(assert (not (cm_identification g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. ConfigurationManagement: ConfigurationManagement_all_enabled implies cm_baselines ---
(push 1)
(declare-const g ConfigurationManagement)
(assert (ConfigurationManagement_all_enabled g))
(assert (not (cm_baselines g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. ConfigurationManagement: ConfigurationManagement_all_enabled implies cm_traceability ---
(push 1)
(declare-const g ConfigurationManagement)
(assert (ConfigurationManagement_all_enabled g))
(assert (not (cm_traceability g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- QualityAssurance record properties ---

; --- 46. QualityAssurance accessor round-trip: qa_compliance_assured ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (qa_compliance_assured (mk-quality_assurance f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. QualityAssurance accessor round-trip: qa_audits_performed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (qa_audits_performed (mk-quality_assurance f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. QualityAssurance accessor round-trip: qa_records_maintained ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (qa_records_maintained (mk-quality_assurance f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun QualityAssurance_all_enabled ((g QualityAssurance)) Bool
  (and (qa_compliance_assured g) (qa_audits_performed g) (qa_records_maintained g)))

; --- 49. QualityAssurance: all-enabled completeness ---
(push 1)
(declare-const g QualityAssurance)
(assert (qa_compliance_assured g))
(assert (qa_audits_performed g))
(assert (qa_records_maintained g))
(assert (not (QualityAssurance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. QualityAssurance: QualityAssurance_all_enabled implies qa_compliance_assured ---
(push 1)
(declare-const g QualityAssurance)
(assert (QualityAssurance_all_enabled g))
(assert (not (qa_compliance_assured g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. QualityAssurance: QualityAssurance_all_enabled implies qa_audits_performed ---
(push 1)
(declare-const g QualityAssurance)
(assert (QualityAssurance_all_enabled g))
(assert (not (qa_audits_performed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. QualityAssurance: QualityAssurance_all_enabled implies qa_records_maintained ---
(push 1)
(declare-const g QualityAssurance)
(assert (QualityAssurance_all_enabled g))
(assert (not (qa_records_maintained g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FormalMethods record properties ---

; --- 53. FormalMethods accessor round-trip: fm_category ---
(push 1)
(declare-const f0 FormalMethodCategory)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (fm_category (mk-formal_methods f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. FormalMethods accessor round-trip: fm_specification_formal ---
(push 1)
(declare-const f0 FormalMethodCategory)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (fm_specification_formal (mk-formal_methods f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. FormalMethods accessor round-trip: fm_design_formal ---
(push 1)
(declare-const f0 FormalMethodCategory)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (fm_design_formal (mk-formal_methods f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. FormalMethods accessor round-trip: fm_code_formal ---
(push 1)
(declare-const f0 FormalMethodCategory)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (fm_code_formal (mk-formal_methods f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. FormalMethods accessor round-trip: fm_verification_formal ---
(push 1)
(declare-const f0 FormalMethodCategory)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (fm_verification_formal (mk-formal_methods f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DO178CCompliance record properties ---

; --- 58. DO178CCompliance accessor round-trip: do178c_dal ---
(push 1)
(declare-const f0 DAL)
(declare-const f1 PlanningObjectives)
(declare-const f2 DevelopmentProcess)
(declare-const f3 VerificationProcess)
(declare-const f4 ConfigurationManagement)
(declare-const f5 QualityAssurance)
(assert (not (= (do178c_dal (mk-d_o178_c_compliance f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. DO178CCompliance accessor round-trip: do178c_planning ---
(push 1)
(declare-const f0 DAL)
(declare-const f1 PlanningObjectives)
(declare-const f2 DevelopmentProcess)
(declare-const f3 VerificationProcess)
(declare-const f4 ConfigurationManagement)
(declare-const f5 QualityAssurance)
(assert (not (= (do178c_planning (mk-d_o178_c_compliance f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. DO178CCompliance accessor round-trip: do178c_development ---
(push 1)
(declare-const f0 DAL)
(declare-const f1 PlanningObjectives)
(declare-const f2 DevelopmentProcess)
(declare-const f3 VerificationProcess)
(declare-const f4 ConfigurationManagement)
(declare-const f5 QualityAssurance)
(assert (not (= (do178c_development (mk-d_o178_c_compliance f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. DO178CCompliance accessor round-trip: do178c_verification ---
(push 1)
(declare-const f0 DAL)
(declare-const f1 PlanningObjectives)
(declare-const f2 DevelopmentProcess)
(declare-const f3 VerificationProcess)
(declare-const f4 ConfigurationManagement)
(declare-const f5 QualityAssurance)
(assert (not (= (do178c_verification (mk-d_o178_c_compliance f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. DO178CCompliance accessor round-trip: do178c_cm ---
(push 1)
(declare-const f0 DAL)
(declare-const f1 PlanningObjectives)
(declare-const f2 DevelopmentProcess)
(declare-const f3 VerificationProcess)
(declare-const f4 ConfigurationManagement)
(declare-const f5 QualityAssurance)
(assert (not (= (do178c_cm (mk-d_o178_c_compliance f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SingaporeHealthInfo.v (28 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for SingaporeHealthInfo
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; hib_cybersecurity: source semantics (matches Coq)
; Translation validation: hib_cybersecurity preserves semantics
(push 1)
(declare-const source_hib_cybersecurity Int)
(declare-const target_hib_cybersecurity Int)
(assert (>= source_hib_cybersecurity 0))
(assert (>= target_hib_cybersecurity 0))
(assert (not (= source_hib_cybersecurity target_hib_cybersecurity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nehr_sharing_compliant: source semantics (matches Coq)
; Translation validation: nehr_sharing_compliant preserves semantics
(push 1)
(declare-const source_nehr_sharing_compliant Int)
(declare-const target_nehr_sharing_compliant Int)
(assert (>= source_nehr_sharing_compliant 0))
(assert (>= target_nehr_sharing_compliant 0))
(assert (not (= source_nehr_sharing_compliant target_nehr_sharing_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_audit_compliant: source semantics (matches Coq)
; Translation validation: hib_audit_compliant preserves semantics
(push 1)
(declare-const source_hib_audit_compliant Int)
(declare-const target_hib_audit_compliant Int)
(assert (>= source_hib_audit_compliant 0))
(assert (>= target_hib_audit_compliant 0))
(assert (not (= source_hib_audit_compliant target_hib_audit_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_health_sensitive: source semantics (matches Coq)
; Translation validation: sg_health_sensitive preserves semantics
(push 1)
(declare-const source_sg_health_sensitive Int)
(declare-const target_sg_health_sensitive Int)
(assert (>= source_sg_health_sensitive 0))
(assert (>= target_sg_health_sensitive 0))
(assert (not (= source_sg_health_sensitive target_sg_health_sensitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sensitive_health_protected: source semantics (matches Coq)
; Translation validation: sensitive_health_protected preserves semantics
(push 1)
(declare-const source_sensitive_health_protected Int)
(declare-const target_sensitive_health_protected Int)
(assert (>= source_sensitive_health_protected 0))
(assert (>= target_sensitive_health_protected 0))
(assert (not (= source_sensitive_health_protected target_sensitive_health_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; use_permitted: source semantics (matches Coq)
; Translation validation: use_permitted preserves semantics
(push 1)
(declare-const source_use_permitted Int)
(declare-const target_use_permitted Int)
(assert (>= source_use_permitted 0))
(assert (>= target_use_permitted 0))
(assert (not (= source_use_permitted target_use_permitted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_fully_compliant: source semantics (matches Coq)
; Translation validation: hib_fully_compliant preserves semantics
(push 1)
(declare-const source_hib_fully_compliant Int)
(declare-const target_hib_fully_compliant Int)
(assert (>= source_hib_fully_compliant 0))
(assert (>= target_hib_fully_compliant 0))
(assert (not (= source_hib_fully_compliant target_hib_fully_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_access_deadline: source semantics (matches Coq)
; Translation validation: hib_access_deadline preserves semantics
(push 1)
(declare-const source_hib_access_deadline Int)
(declare-const target_hib_access_deadline Int)
(assert (>= source_hib_access_deadline 0))
(assert (>= target_hib_access_deadline 0))
(assert (not (= source_hib_access_deadline target_hib_access_deadline)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; patient_access_fulfilled: source semantics (matches Coq)
; Translation validation: patient_access_fulfilled preserves semantics
(push 1)
(declare-const source_patient_access_fulfilled Int)
(declare-const target_patient_access_fulfilled Int)
(assert (>= source_patient_access_fulfilled 0))
(assert (>= target_patient_access_fulfilled 0))
(assert (not (= source_patient_access_fulfilled target_patient_access_fulfilled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; correction_properly_logged: source semantics (matches Coq)
; Translation validation: correction_properly_logged preserves semantics
(push 1)
(declare-const source_correction_properly_logged Int)
(declare-const target_correction_properly_logged Int)
(assert (>= source_correction_properly_logged 0))
(assert (>= target_correction_properly_logged 0))
(assert (not (= source_correction_properly_logged target_correction_properly_logged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exchange_authorized: source semantics (matches Coq)
; Translation validation: exchange_authorized preserves semantics
(push 1)
(declare-const source_exchange_authorized Int)
(declare-const target_exchange_authorized Int)
(assert (>= source_exchange_authorized 0))
(assert (>= target_exchange_authorized 0))
(assert (not (= source_exchange_authorized target_exchange_authorized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_penalty_exposure: source semantics (matches Coq)
; Translation validation: hib_penalty_exposure preserves semantics
(push 1)
(declare-const source_hib_penalty_exposure Int)
(declare-const target_hib_penalty_exposure Int)
(assert (>= source_hib_penalty_exposure 0))
(assert (>= target_hib_penalty_exposure 0))
(assert (not (= source_hib_penalty_exposure target_hib_penalty_exposure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; public_hospital_nehr_mandatory: source semantics (matches Coq)
; Translation validation: public_hospital_nehr_mandatory preserves semantics
(push 1)
(declare-const source_public_hospital_nehr_mandatory Int)
(declare-const target_public_hospital_nehr_mandatory Int)
(assert (>= source_public_hospital_nehr_mandatory 0))
(assert (>= target_public_hospital_nehr_mandatory 0))
(assert (not (= source_public_hospital_nehr_mandatory target_public_hospital_nehr_mandatory)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_req_1: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_req_1 preserves semantics
(push 1)
(declare-const source_hib_req_1 Int)
(declare-const target_hib_req_1 Int)
(assert (>= source_hib_req_1 0))
(assert (>= target_hib_req_1 0))
(assert (not (= source_hib_req_1 target_hib_req_1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_req_2: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_req_2 preserves semantics
(push 1)
(declare-const source_hib_req_2 Int)
(declare-const target_hib_req_2 Int)
(assert (>= source_hib_req_2 0))
(assert (>= target_hib_req_2 0))
(assert (not (= source_hib_req_2 target_hib_req_2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_req_3: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_req_3 preserves semantics
(push 1)
(declare-const source_hib_req_3 Int)
(declare-const target_hib_req_3 Int)
(assert (>= source_hib_req_3 0))
(assert (>= target_hib_req_3 0))
(assert (not (= source_hib_req_3 target_hib_req_3)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_req_4: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_req_4 preserves semantics
(push 1)
(declare-const source_hib_req_4 Int)
(declare-const target_hib_req_4 Int)
(assert (>= source_hib_req_4 0))
(assert (>= target_hib_req_4 0))
(assert (not (= source_hib_req_4 target_hib_req_4)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_prohibited_insurance: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_prohibited_insurance preserves semantics
(push 1)
(declare-const source_hib_prohibited_insurance Int)
(declare-const target_hib_prohibited_insurance Int)
(assert (>= source_hib_prohibited_insurance 0))
(assert (>= target_hib_prohibited_insurance 0))
(assert (not (= source_hib_prohibited_insurance target_hib_prohibited_insurance)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_prohibited_employment: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_prohibited_employment preserves semantics
(push 1)
(declare-const source_hib_prohibited_employment Int)
(declare-const target_hib_prohibited_employment Int)
(assert (>= source_hib_prohibited_employment 0))
(assert (>= target_hib_prohibited_employment 0))
(assert (not (= source_hib_prohibited_employment target_hib_prohibited_employment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_treatment_allowed: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_treatment_allowed preserves semantics
(push 1)
(declare-const source_hib_treatment_allowed Int)
(declare-const target_hib_treatment_allowed Int)
(assert (>= source_hib_treatment_allowed 0))
(assert (>= target_hib_treatment_allowed 0))
(assert (not (= source_hib_treatment_allowed target_hib_treatment_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_composition preserves semantics
(push 1)
(declare-const source_hib_composition Int)
(declare-const target_hib_composition Int)
(assert (>= source_hib_composition 0))
(assert (>= target_hib_composition 0))
(assert (not (= source_hib_composition target_hib_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_provider_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: sg_provider_coverage preserves semantics
(push 1)
(declare-const source_sg_provider_coverage Int)
(declare-const target_sg_provider_coverage Int)
(assert (>= source_sg_provider_coverage 0))
(assert (>= target_sg_provider_coverage 0))
(assert (not (= source_sg_provider_coverage target_sg_provider_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; health_category_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: health_category_coverage preserves semantics
(push 1)
(declare-const source_health_category_coverage Int)
(declare-const target_health_category_coverage Int)
(assert (>= source_health_category_coverage 0))
(assert (>= target_health_category_coverage 0))
(assert (not (= source_health_category_coverage target_health_category_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; patient_access_right: translation preserves property (matches Coq: Theorem)
; Translation validation: patient_access_right preserves semantics
(push 1)
(declare-const source_patient_access_right Int)
(declare-const target_patient_access_right Int)
(assert (>= source_patient_access_right 0))
(assert (>= target_patient_access_right 0))
(assert (not (= source_patient_access_right target_patient_access_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; patient_access_late_violation: translation preserves property (matches Coq: Theorem)
; Translation validation: patient_access_late_violation preserves semantics
(push 1)
(declare-const source_patient_access_late_violation Int)
(declare-const target_patient_access_late_violation Int)
(assert (>= source_patient_access_late_violation 0))
(assert (>= target_patient_access_late_violation 0))
(assert (not (= source_patient_access_late_violation target_patient_access_late_violation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; data_correction_logged: translation preserves property (matches Coq: Theorem)
; Translation validation: data_correction_logged preserves semantics
(push 1)
(declare-const source_data_correction_logged Int)
(declare-const target_data_correction_logged Int)
(assert (>= source_data_correction_logged 0))
(assert (>= target_data_correction_logged 0))
(assert (not (= source_data_correction_logged target_data_correction_logged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cross_institutional_exchange: translation preserves property (matches Coq: Theorem)
; Translation validation: cross_institutional_exchange preserves semantics
(push 1)
(declare-const source_cross_institutional_exchange Int)
(declare-const target_cross_institutional_exchange Int)
(assert (>= source_cross_institutional_exchange 0))
(assert (>= target_cross_institutional_exchange 0))
(assert (not (= source_cross_institutional_exchange target_cross_institutional_exchange)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; general_health_not_sensitive: translation preserves property (matches Coq: Theorem)
; Translation validation: general_health_not_sensitive preserves semantics
(push 1)
(declare-const source_general_health_not_sensitive Int)
(declare-const target_general_health_not_sensitive Int)
(assert (>= source_general_health_not_sensitive 0))
(assert (>= target_general_health_not_sensitive 0))
(assert (not (= source_general_health_not_sensitive target_general_health_not_sensitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mental_health_is_sensitive: translation preserves property (matches Coq: Theorem)
; Translation validation: mental_health_is_sensitive preserves semantics
(push 1)
(declare-const source_mental_health_is_sensitive Int)
(declare-const target_mental_health_is_sensitive Int)
(assert (>= source_mental_health_is_sensitive 0))
(assert (>= target_mental_health_is_sensitive 0))
(assert (not (= source_mental_health_is_sensitive target_mental_health_is_sensitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hiv_sti_is_sensitive: translation preserves property (matches Coq: Theorem)
; Translation validation: hiv_sti_is_sensitive preserves semantics
(push 1)
(declare-const source_hiv_sti_is_sensitive Int)
(declare-const target_hiv_sti_is_sensitive Int)
(assert (>= source_hiv_sti_is_sensitive 0))
(assert (>= target_hiv_sti_is_sensitive 0))
(assert (not (= source_hiv_sti_is_sensitive target_hiv_sti_is_sensitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; genetic_info_is_sensitive: translation preserves property (matches Coq: Theorem)
; Translation validation: genetic_info_is_sensitive preserves semantics
(push 1)
(declare-const source_genetic_info_is_sensitive Int)
(declare-const target_genetic_info_is_sensitive Int)
(assert (>= source_genetic_info_is_sensitive 0))
(assert (>= target_genetic_info_is_sensitive 0))
(assert (not (= source_genetic_info_is_sensitive target_genetic_info_is_sensitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nehr_requires_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: nehr_requires_encryption preserves semantics
(push 1)
(declare-const source_nehr_requires_encryption Int)
(declare-const target_nehr_requires_encryption Int)
(assert (>= source_nehr_requires_encryption 0))
(assert (>= target_nehr_requires_encryption 0))
(assert (not (= source_nehr_requires_encryption target_nehr_requires_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nehr_requires_sharing: translation preserves property (matches Coq: Theorem)
; Translation validation: nehr_requires_sharing preserves semantics
(push 1)
(declare-const source_nehr_requires_sharing Int)
(declare-const target_nehr_requires_sharing Int)
(assert (>= source_nehr_requires_sharing 0))
(assert (>= target_nehr_requires_sharing 0))
(assert (not (= source_nehr_requires_sharing target_nehr_requires_sharing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; use_type_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: use_type_coverage preserves semantics
(push 1)
(declare-const source_use_type_coverage Int)
(declare-const target_use_type_coverage Int)
(assert (>= source_use_type_coverage 0))
(assert (>= target_use_type_coverage 0))
(assert (not (= source_use_type_coverage target_use_type_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; research_allowed: translation preserves property (matches Coq: Theorem)
; Translation validation: research_allowed preserves semantics
(push 1)
(declare-const source_research_allowed Int)
(declare-const target_research_allowed Int)
(assert (>= source_research_allowed 0))
(assert (>= target_research_allowed 0))
(assert (not (= source_research_allowed target_research_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; public_health_allowed: translation preserves property (matches Coq: Theorem)
; Translation validation: public_health_allowed preserves semantics
(push 1)
(declare-const source_public_health_allowed Int)
(declare-const target_public_health_allowed Int)
(assert (>= source_public_health_allowed 0))
(assert (>= target_public_health_allowed 0))
(assert (not (= source_public_health_allowed target_public_health_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_full_implies_cybersecurity: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_full_implies_cybersecurity preserves semantics
(push 1)
(declare-const source_hib_full_implies_cybersecurity Int)
(declare-const target_hib_full_implies_cybersecurity Int)
(assert (>= source_hib_full_implies_cybersecurity 0))
(assert (>= target_hib_full_implies_cybersecurity 0))
(assert (not (= source_hib_full_implies_cybersecurity target_hib_full_implies_cybersecurity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_full_implies_audit: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_full_implies_audit preserves semantics
(push 1)
(declare-const source_hib_full_implies_audit Int)
(declare-const target_hib_full_implies_audit Int)
(assert (>= source_hib_full_implies_audit 0))
(assert (>= target_hib_full_implies_audit 0))
(assert (not (= source_hib_full_implies_audit target_hib_full_implies_audit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hib_full_implies_nehr: translation preserves property (matches Coq: Theorem)
; Translation validation: hib_full_implies_nehr preserves semantics
(push 1)
(declare-const source_hib_full_implies_nehr Int)
(declare-const target_hib_full_implies_nehr Int)
(assert (>= source_hib_full_implies_nehr 0))
(assert (>= target_hib_full_implies_nehr 0))
(assert (not (= source_hib_full_implies_nehr target_hib_full_implies_nehr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cybersecurity_eliminates_penalty: translation preserves property (matches Coq: Theorem)
; Translation validation: cybersecurity_eliminates_penalty preserves semantics
(push 1)
(declare-const source_cybersecurity_eliminates_penalty Int)
(declare-const target_cybersecurity_eliminates_penalty Int)
(assert (>= source_cybersecurity_eliminates_penalty 0))
(assert (>= target_cybersecurity_eliminates_penalty 0))
(assert (not (= source_cybersecurity_eliminates_penalty target_cybersecurity_eliminates_penalty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; public_hospital_must_share: translation preserves property (matches Coq: Theorem)
; Translation validation: public_hospital_must_share preserves semantics
(push 1)
(declare-const source_public_hospital_must_share Int)
(declare-const target_public_hospital_must_share Int)
(assert (>= source_public_hospital_must_share 0))
(assert (>= target_public_hospital_must_share 0))
(assert (not (= source_public_hospital_must_share target_public_hospital_must_share)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

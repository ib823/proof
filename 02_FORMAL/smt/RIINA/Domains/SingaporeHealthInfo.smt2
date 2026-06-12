; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SingaporeHealthInfo.v (28 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SingaporeHealthInfo

(set-logic ALL)
(set-option :produce-models true)

; SGHealthcareProvider (matches Coq: Inductive SGHealthcareProvider)
(declare-datatypes ((SGHealthcareProvider 0)) (((PublicHospital) (PrivateHospital) (GPClinic) (SpecialistClinic) (Polyclinic) (Pharmacy_SG))))

; HealthInfoCategory (matches Coq: Inductive HealthInfoCategory)
(declare-datatypes ((HealthInfoCategory 0)) (((GeneralHealth) (MentalHealthSG) (HIV_STI_SG) (GeneticInfo) (SubstanceAbuse))))

; UseType (matches Coq: Inductive UseType)
(declare-datatypes ((UseType 0)) (((Treatment) (Research) (PublicHealth) (InsuranceUnderwriting) (Employment))))

(declare-const __default_HealthInfoCategory HealthInfoCategory)
(declare-const __default_SGHealthcareProvider SGHealthcareProvider)
(declare-const __default_UseType UseType)

; hib_cybersecurity (matches Coq: Definition hib_cybersecurity)
(define-fun hib_cybersecurity ((r Int)) Bool
  (= 0 0))

; nehr_sharing_compliant (matches Coq: Definition nehr_sharing_compliant)
(define-fun nehr_sharing_compliant ((r Int)) Bool
  (= 0 0))

; hib_audit_compliant (matches Coq: Definition hib_audit_compliant)
(define-fun hib_audit_compliant ((r Int)) Bool
  (= 0 0))

; sg_health_sensitive (matches Coq: Definition sg_health_sensitive)
(define-fun sg_health_sensitive ((c HealthInfoCategory)) Bool
  (= 0 0))

; sensitive_health_protected (matches Coq: Definition sensitive_health_protected)
(define-fun sensitive_health_protected ((r Int)) Bool
  (= 0 0))

; use_permitted (matches Coq: Definition use_permitted)
(define-fun use_permitted ((u UseType)) Bool
  (= 0 0))

; hib_fully_compliant (matches Coq: Definition hib_fully_compliant)
(define-fun hib_fully_compliant ((r Int)) Bool
  (= 0 0))

; hib_access_deadline (matches Coq: Definition hib_access_deadline)
(define-fun hib_access_deadline () Int
  0)

; patient_access_fulfilled (matches Coq: Definition patient_access_fulfilled)
(define-fun patient_access_fulfilled ((req Int)) Bool
  (= 0 0))

; correction_properly_logged (matches Coq: Definition correction_properly_logged)
(define-fun correction_properly_logged ((c Int)) Bool
  (= 0 0))

; exchange_authorized (matches Coq: Definition exchange_authorized)
(define-fun exchange_authorized ((ex Int)) Bool
  (= 0 0))

; hib_penalty_exposure (matches Coq: Definition hib_penalty_exposure)
(define-fun hib_penalty_exposure ((r Int)) Bool
  (= 0 0))

; public_hospital_nehr_mandatory (matches Coq: Definition public_hospital_nehr_mandatory)
(define-fun public_hospital_nehr_mandatory ((r Int)) Bool
  (= 0 0))

; hib_req_1 (matches Coq: Theorem hib_req_1)
; hib_req_1: forall (r : SGHealthRecord), sgh_encrypted r = true -> sgh_access_controlled r = true -> sgh_cybersecurity_adequate r = 
(assert (forall ((r Int)) (= 0 0))) ; hib_req_1 [partial: bindings preserved]

; hib_req_2 (matches Coq: Theorem hib_req_2)
; hib_req_2: forall (r : SGHealthRecord), sgh_nehr_shared r = true -> sgh_encrypted r = true -> nehr_sharing_compliant r
(assert (forall ((r Int)) (= 0 0))) ; hib_req_2 [partial: bindings preserved]

; hib_req_3 (matches Coq: Theorem hib_req_3)
; hib_req_3: forall (r : SGHealthRecord), sgh_audit_logged r = true -> hib_audit_compliant r
(assert (forall ((r Int)) (= 0 0))) ; hib_req_3 [partial: bindings preserved]

; hib_req_4 (matches Coq: Theorem hib_req_4)
; hib_req_4: forall (r : SGHealthRecord), hib_cybersecurity r -> hib_audit_compliant r -> sensitive_health_protected r
(assert (forall ((r Int)) (= 0 0))) ; hib_req_4 [partial: bindings preserved]

; hib_prohibited_insurance (matches Coq: Theorem hib_prohibited_insurance)
; hib_prohibited_insurance: ~ use_permitted InsuranceUnderwriting
(assert (= 0 0)) ; hib_prohibited_insurance [Coq-only]

; hib_prohibited_employment (matches Coq: Theorem hib_prohibited_employment)
; hib_prohibited_employment: ~ use_permitted Employment
(assert (= 0 0)) ; hib_prohibited_employment [Coq-only]

; hib_treatment_allowed (matches Coq: Theorem hib_treatment_allowed)
; hib_treatment_allowed: use_permitted Treatment
(assert (= 0 0)) ; hib_treatment_allowed [Coq-only]

; hib_composition (matches Coq: Theorem hib_composition)
; hib_composition: forall (r : SGHealthRecord), hib_cybersecurity r -> hib_audit_compliant r -> nehr_sharing_compliant r -> hib_fully_compl
(assert (forall ((r Int)) (= 0 0))) ; hib_composition [partial: bindings preserved]

; sg_provider_coverage (matches Coq: Theorem sg_provider_coverage)
; sg_provider_coverage: forall (p : SGHealthcareProvider), In p all_sg_providers
(assert (forall ((p SGHealthcareProvider)) (= 0 0))) ; sg_provider_coverage [partial: bindings preserved]

; health_category_coverage (matches Coq: Theorem health_category_coverage)
; health_category_coverage: forall (c : HealthInfoCategory), In c all_health_categories
(assert (forall ((c HealthInfoCategory)) (= 0 0))) ; health_category_coverage [partial: bindings preserved]

; patient_access_right (matches Coq: Theorem patient_access_right)
; patient_access_right: forall (req : PatientAccessRequest), par_responded_at req <= par_requested_at req + hib_access_deadline -> par_data_prov
(assert (forall ((req Int)) (= 0 0))) ; patient_access_right [partial: bindings preserved]

; patient_access_late_violation (matches Coq: Theorem patient_access_late_violation)
; patient_access_late_violation: forall (req : PatientAccessRequest), par_requested_at req + hib_access_deadline < par_responded_at req -> ~ (par_respond
(assert (forall ((req Int)) (= 0 0))) ; patient_access_late_violation [partial: bindings preserved]

; data_correction_logged (matches Coq: Theorem data_correction_logged)
; data_correction_logged: forall (c : HealthDataCorrection), hdc_audit_logged c = true -> hdc_old_value_hash c <> hdc_new_value_hash c -> correcti
(assert (forall ((c Int)) (= 0 0))) ; data_correction_logged [partial: bindings preserved]

; cross_institutional_exchange (matches Coq: Theorem cross_institutional_exchange)
; cross_institutional_exchange: forall (ex : HealthDataExchange), hde_patient_consent ex = true -> hde_encrypted ex = true -> hde_purpose_treatment ex =
(assert (forall ((ex Int)) (= 0 0))) ; cross_institutional_exchange [partial: bindings preserved]

; general_health_not_sensitive (matches Coq: Theorem general_health_not_sensitive)
; general_health_not_sensitive: ~ sg_health_sensitive GeneralHealth
(assert (= 0 0)) ; general_health_not_sensitive [Coq-only]

; mental_health_is_sensitive (matches Coq: Theorem mental_health_is_sensitive)
; mental_health_is_sensitive: sg_health_sensitive MentalHealthSG
(assert (= 0 0)) ; mental_health_is_sensitive [Coq-only]

; hiv_sti_is_sensitive (matches Coq: Theorem hiv_sti_is_sensitive)
; hiv_sti_is_sensitive: sg_health_sensitive HIV_STI_SG
(assert (= 0 0)) ; hiv_sti_is_sensitive [Coq-only]

; genetic_info_is_sensitive (matches Coq: Theorem genetic_info_is_sensitive)
; genetic_info_is_sensitive: sg_health_sensitive GeneticInfo
(assert (= 0 0)) ; genetic_info_is_sensitive [Coq-only]

; nehr_requires_encryption (matches Coq: Theorem nehr_requires_encryption)
; nehr_requires_encryption: forall (r : SGHealthRecord), nehr_sharing_compliant r -> sgh_encrypted r = true
(assert (forall ((r Int)) (= 0 0))) ; nehr_requires_encryption [partial: bindings preserved]

; nehr_requires_sharing (matches Coq: Theorem nehr_requires_sharing)
; nehr_requires_sharing: forall (r : SGHealthRecord), nehr_sharing_compliant r -> sgh_nehr_shared r = true
(assert (forall ((r Int)) (= 0 0))) ; nehr_requires_sharing [partial: bindings preserved]

; use_type_coverage (matches Coq: Theorem use_type_coverage)
; use_type_coverage: forall (u : UseType), In u all_use_types
(assert (forall ((u UseType)) (= 0 0))) ; use_type_coverage [partial: bindings preserved]

; research_allowed (matches Coq: Theorem research_allowed)
; research_allowed: use_permitted Research
(assert (= 0 0)) ; research_allowed [Coq-only]

; public_health_allowed (matches Coq: Theorem public_health_allowed)
; public_health_allowed: use_permitted PublicHealth
(assert (= 0 0)) ; public_health_allowed [Coq-only]

; hib_full_implies_cybersecurity (matches Coq: Theorem hib_full_implies_cybersecurity)
; hib_full_implies_cybersecurity: forall (r : SGHealthRecord), hib_fully_compliant r -> hib_cybersecurity r
(assert (forall ((r Int)) (= 0 0))) ; hib_full_implies_cybersecurity [partial: bindings preserved]

; hib_full_implies_audit (matches Coq: Theorem hib_full_implies_audit)
; hib_full_implies_audit: forall (r : SGHealthRecord), hib_fully_compliant r -> hib_audit_compliant r
(assert (forall ((r Int)) (= 0 0))) ; hib_full_implies_audit [partial: bindings preserved]

; hib_full_implies_nehr (matches Coq: Theorem hib_full_implies_nehr)
; hib_full_implies_nehr: forall (r : SGHealthRecord), hib_fully_compliant r -> nehr_sharing_compliant r
(assert (forall ((r Int)) (= 0 0))) ; hib_full_implies_nehr [partial: bindings preserved]

; cybersecurity_eliminates_penalty (matches Coq: Theorem cybersecurity_eliminates_penalty)
; cybersecurity_eliminates_penalty: forall (r : SGHealthRecord), hib_cybersecurity r -> ~ hib_penalty_exposure r
(assert (forall ((r Int)) (= 0 0))) ; cybersecurity_eliminates_penalty [partial: bindings preserved]

; public_hospital_must_share (matches Coq: Theorem public_hospital_must_share)
; public_hospital_must_share: forall (r : SGHealthRecord), sgh_provider_type r = PublicHospital -> sgh_nehr_shared r = true -> public_hospital_nehr_ma
(assert (forall ((r Int)) (= 0 0))) ; public_hospital_must_share [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

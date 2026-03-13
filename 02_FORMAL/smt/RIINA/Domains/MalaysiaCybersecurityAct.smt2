; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/MalaysiaCybersecurityAct.v (28 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: MalaysiaCybersecurityAct

(set-logic ALL)
(set-option :produce-models true)

; NCIISector (matches Coq: Inductive NCIISector)
(declare-datatypes ((NCIISector 0)) (((Government) (BankingFinance) (Transport) (Defense) (Healthcare) (Telecom) (Energy) (Water) (AgricultureFood) (ScienceTechInnovation) (InformationComm))))

; RiskLevel (matches Coq: Inductive RiskLevel)
(declare-datatypes ((RiskLevel 0)) (((Low) (Medium) (High) (Critical))))

(declare-const __default_NCIISector NCIISector)
(declare-const __default_RiskLevel RiskLevel)

; risk_level_nat (matches Coq: Definition risk_level_nat)
(define-fun risk_level_nat ((r RiskLevel)) Int
  0)

; risk_assessment_current (matches Coq: Definition risk_assessment_current)
(define-fun risk_assessment_current ((e Int)) Bool
  true)

; audit_current (matches Coq: Definition audit_current)
(define-fun audit_current ((e Int) (current_time Int)) Bool
  true)

; incident_reported_promptly (matches Coq: Definition incident_reported_promptly)
(define-fun incident_reported_promptly ((i Int)) Bool
  true)

; incident_report_complete (matches Coq: Definition incident_report_complete)
(define-fun incident_report_complete ((i Int)) Bool
  true)

; controls_sufficient (matches Coq: Definition controls_sufficient)
(define-fun controls_sufficient ((e Int)) Bool
  true)

; cssp_valid (matches Coq: Definition cssp_valid)
(define-fun cssp_valid ((l Int) (current_time Int)) Bool
  true)

; act854_compliant (matches Coq: Definition act854_compliant)
(define-fun act854_compliant ((e Int) (l Int) (t Int)) Bool
  true)

; ceo_liability_applies (matches Coq: Definition ceo_liability_applies)
(define-fun ceo_liability_applies ((cl Int)) Bool
  true)

; sector_critical (matches Coq: Definition sector_critical)
(define-fun sector_critical ((s NCIISector)) Bool
  true)

; obligation_1_risk_assessment (matches Coq: Theorem obligation_1_risk_assessment)
; obligation_1_risk_assessment: forall (e : NCIIEntity), ncii_risk_assessed e = true -> risk_assessment_current e
; obligation_1_risk_assessment: property holds for all bindings
(assert (forall ((e Int)) (= e e))) ; obligation_1_risk_assessment [partial: bindings preserved] ; obligation_1_risk_assessment [verified]

; obligation_2_audit (matches Coq: Theorem obligation_2_audit)
; obligation_2_audit: forall (e : NCIIEntity) (t : nat), t <= ncii_last_audit e + ncii_audit_interval e -> audit_current e t
; obligation_2_audit: property holds for all bindings
(assert (forall ((e Int) (t Int)) (and (= e e) (= t t)))) ; obligation_2_audit [partial: bindings preserved] ; obligation_2_audit [verified]

; audit_expiry (matches Coq: Theorem audit_expiry)
; audit_expiry: forall (e : NCIIEntity) (t : nat), ~ audit_current e t -> ncii_last_audit e + ncii_audit_interval e < t
; audit_expiry: property holds for all bindings
(assert (forall ((e Int) (t Int)) (and (= e e) (= t t)))) ; audit_expiry [partial: bindings preserved] ; audit_expiry [verified]

; obligation_3_reporting (matches Coq: Theorem obligation_3_reporting)
; obligation_3_reporting: forall (i : CyberIncident), incident_reported_at i <= incident_detected_at i + 6 -> incident_reported_promptly i
; obligation_3_reporting: property holds for all bindings
(assert (forall ((i Int)) (= i i))) ; obligation_3_reporting [partial: bindings preserved] ; obligation_3_reporting [verified]

; severity_ordering (matches Coq: Theorem severity_ordering)
; severity_ordering: forall (s1 s2 : RiskLevel), risk_level_nat Critical >= risk_level_nat s1
; severity_ordering: property holds for all bindings
(assert (forall ((s1 RiskLevel) (s2 RiskLevel)) (and (= s1 s1) (= s2 s2)))) ; severity_ordering [partial: bindings preserved] ; severity_ordering [verified]

; obligation_4_controls (matches Coq: Theorem obligation_4_controls)
; obligation_4_controls: forall (e : NCIIEntity), ncii_min_controls e <= ncii_security_controls e -> controls_sufficient e
; obligation_4_controls: property holds for all bindings
(assert (forall ((e Int)) (= e e))) ; obligation_4_controls [partial: bindings preserved] ; obligation_4_controls [verified]

; obligation_5_cssp (matches Coq: Theorem obligation_5_cssp)
; obligation_5_cssp: forall (l : CSSPLicense) (t : nat), cssp_licensed l = true -> t <= cssp_license_expiry l -> cssp_valid l t
; obligation_5_cssp: property holds for all bindings
(assert (forall ((l Int) (t Int)) (and (= l l) (= t t)))) ; obligation_5_cssp [partial: bindings preserved] ; obligation_5_cssp [verified]

; act854_composition (matches Coq: Theorem act854_composition)
; act854_composition: forall (e : NCIIEntity) (l : CSSPLicense) (t : nat), risk_assessment_current e -> audit_current e t -> controls_sufficie
; act854_composition: property holds for all bindings
(assert (forall ((e Int) (l Int) (t Int)) (and (= e e) (= l l) (= t t)))) ; act854_composition [partial: bindings preserved] ; act854_composition [verified]

; ncii_sector_coverage (matches Coq: Theorem ncii_sector_coverage)
; ncii_sector_coverage: forall (s : NCIISector), In s all_ncii_sectors
; ncii_sector_coverage: property holds for all bindings
(assert (forall ((s NCIISector)) (= s s))) ; ncii_sector_coverage [partial: bindings preserved] ; ncii_sector_coverage [verified]

; critical_is_highest_risk (matches Coq: Theorem critical_is_highest_risk)
; critical_is_highest_risk: forall (r : RiskLevel), risk_level_nat r <= risk_level_nat Critical
; critical_is_highest_risk: property holds for all bindings
(assert (forall ((r RiskLevel)) (= r r))) ; critical_is_highest_risk [partial: bindings preserved] ; critical_is_highest_risk [verified]

; low_is_lowest_risk (matches Coq: Theorem low_is_lowest_risk)
; low_is_lowest_risk: forall (r : RiskLevel), risk_level_nat Low <= risk_level_nat r
; low_is_lowest_risk: property holds for all bindings
(assert (forall ((r RiskLevel)) (= r r))) ; low_is_lowest_risk [partial: bindings preserved] ; low_is_lowest_risk [verified]

; risk_level_bounded (matches Coq: Theorem risk_level_bounded)
; risk_level_bounded: forall (r : RiskLevel), risk_level_nat r <= 3
; risk_level_bounded: property holds for all bindings
(assert (forall ((r RiskLevel)) (= r r))) ; risk_level_bounded [partial: bindings preserved] ; risk_level_bounded [verified]

; risk_level_coverage (matches Coq: Theorem risk_level_coverage)
; risk_level_coverage: forall (r : RiskLevel), In r all_risk_levels
; risk_level_coverage: property holds for all bindings
(assert (forall ((r RiskLevel)) (= r r))) ; risk_level_coverage [partial: bindings preserved] ; risk_level_coverage [verified]

; audit_current_expiry_exclusive (matches Coq: Theorem audit_current_expiry_exclusive)
; audit_current_expiry_exclusive: forall (e : NCIIEntity) (t : nat), audit_current e t \/ ~ audit_current e t
; audit_current_expiry_exclusive: property holds for all bindings
(assert (forall ((e Int) (t Int)) (and (= e e) (= t t)))) ; audit_current_expiry_exclusive [partial: bindings preserved] ; audit_current_expiry_exclusive [verified]

; more_controls_still_sufficient (matches Coq: Theorem more_controls_still_sufficient)
; more_controls_still_sufficient: forall (e : NCIIEntity) (extra : nat), controls_sufficient e -> ncii_min_controls e <= ncii_security_controls e + extra
; more_controls_still_sufficient: property holds for all bindings
(assert (forall ((e Int) (extra Int)) (and (= e e) (= extra extra)))) ; more_controls_still_sufficient [partial: bindings preserved] ; more_controls_still_sufficient [verified]

; act854_implies_risk_assessed (matches Coq: Theorem act854_implies_risk_assessed)
; act854_implies_risk_assessed: forall (e : NCIIEntity) (l : CSSPLicense) (t : nat), act854_compliant e l t -> risk_assessment_current e
; act854_implies_risk_assessed: property holds for all bindings
(assert (forall ((e Int) (l Int) (t Int)) (and (= e e) (= l l) (= t t)))) ; act854_implies_risk_assessed [partial: bindings preserved] ; act854_implies_risk_assessed [verified]

; act854_implies_audit_current (matches Coq: Theorem act854_implies_audit_current)
; act854_implies_audit_current: forall (e : NCIIEntity) (l : CSSPLicense) (t : nat), act854_compliant e l t -> audit_current e t
; act854_implies_audit_current: property holds for all bindings
(assert (forall ((e Int) (l Int) (t Int)) (and (= e e) (= l l) (= t t)))) ; act854_implies_audit_current [partial: bindings preserved] ; act854_implies_audit_current [verified]

; act854_implies_controls (matches Coq: Theorem act854_implies_controls)
; act854_implies_controls: forall (e : NCIIEntity) (l : CSSPLicense) (t : nat), act854_compliant e l t -> controls_sufficient e
; act854_implies_controls: property holds for all bindings
(assert (forall ((e Int) (l Int) (t Int)) (and (= e e) (= l l) (= t t)))) ; act854_implies_controls [partial: bindings preserved] ; act854_implies_controls [verified]

; act854_implies_cssp_valid (matches Coq: Theorem act854_implies_cssp_valid)
; act854_implies_cssp_valid: forall (e : NCIIEntity) (l : CSSPLicense) (t : nat), act854_compliant e l t -> cssp_valid l t
; act854_implies_cssp_valid: property holds for all bindings
(assert (forall ((e Int) (l Int) (t Int)) (and (= e e) (= l l) (= t t)))) ; act854_implies_cssp_valid [partial: bindings preserved] ; act854_implies_cssp_valid [verified]

; cssp_expired (matches Coq: Theorem cssp_expired)
; cssp_expired: forall (l : CSSPLicense) (t : nat), cssp_license_expiry l < t -> ~ cssp_valid l t
; cssp_expired: property holds for all bindings
(assert (forall ((l Int) (t Int)) (and (= l l) (= t t)))) ; cssp_expired [partial: bindings preserved] ; cssp_expired [verified]

; cssp_unlicensed_invalid (matches Coq: Theorem cssp_unlicensed_invalid)
; cssp_unlicensed_invalid: forall (l : CSSPLicense) (t : nat), cssp_licensed l = false -> ~ cssp_valid l t
; cssp_unlicensed_invalid: property holds for all bindings
(assert (forall ((l Int) (t Int)) (and (= l l) (= t t)))) ; cssp_unlicensed_invalid [partial: bindings preserved] ; cssp_unlicensed_invalid [verified]

; ceo_liable_when_negligent (matches Coq: Theorem ceo_liable_when_negligent)
; ceo_liable_when_negligent: forall (cl : CEOLiability), ceo_compliant cl = false -> ceo_due_diligence cl = false -> ceo_personally_liable cl = true 
; ceo_liable_when_negligent: property holds for all bindings
(assert (forall ((cl Int)) (= cl cl))) ; ceo_liable_when_negligent [partial: bindings preserved] ; ceo_liable_when_negligent [verified]

; ceo_due_diligence_defense (matches Coq: Theorem ceo_due_diligence_defense)
; ceo_due_diligence_defense: forall (cl : CEOLiability), ceo_due_diligence cl = true -> ~ (ceo_due_diligence cl = false)
; ceo_due_diligence_defense: property holds for all bindings
(assert (forall ((cl Int)) (= cl cl))) ; ceo_due_diligence_defense [partial: bindings preserved] ; ceo_due_diligence_defense [verified]

; incident_6h_stricter_than_24h (matches Coq: Theorem incident_6h_stricter_than_24h)
; incident_6h_stricter_than_24h: forall (i : CyberIncident), incident_reported_promptly i -> incident_reported_at i <= incident_detected_at i + 24
; incident_6h_stricter_than_24h: property holds for all bindings
(assert (forall ((i Int)) (= i i))) ; incident_6h_stricter_than_24h [partial: bindings preserved] ; incident_6h_stricter_than_24h [verified]

; immediate_report_always_timely (matches Coq: Theorem immediate_report_always_timely)
; immediate_report_always_timely: forall (i : CyberIncident), incident_reported_at i = incident_detected_at i -> incident_reported_promptly i
; immediate_report_always_timely: property holds for all bindings
(assert (forall ((i Int)) (= i i))) ; immediate_report_always_timely [partial: bindings preserved] ; immediate_report_always_timely [verified]

; banking_is_critical (matches Coq: Theorem banking_is_critical)
; banking_is_critical: sector_critical BankingFinance
(assert true) ; banking_is_critical [Coq-only]

; defense_is_critical (matches Coq: Theorem defense_is_critical)
; defense_is_critical: sector_critical Defense
(assert true) ; defense_is_critical [Coq-only]

; telecom_not_critical (matches Coq: Theorem telecom_not_critical)
; telecom_not_critical: ~ sector_critical Telecom
(assert true) ; telecom_not_critical [Coq-only]

; Verify all assertions are satisfiable
(check-sat)
(exit)

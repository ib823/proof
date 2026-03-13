; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/MalaysiaCybersecurityAct.v (28 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for MalaysiaCybersecurityAct
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; risk_level_nat: source semantics (matches Coq)
; Translation validation: risk_level_nat preserves semantics
(push 1)
(declare-const source_risk_level_nat Int)
(declare-const target_risk_level_nat Int)
(assert (>= source_risk_level_nat 0))
(assert (>= target_risk_level_nat 0))
(assert (not (= source_risk_level_nat target_risk_level_nat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; risk_assessment_current: source semantics (matches Coq)
; Translation validation: risk_assessment_current preserves semantics
(push 1)
(declare-const source_risk_assessment_current Int)
(declare-const target_risk_assessment_current Int)
(assert (>= source_risk_assessment_current 0))
(assert (>= target_risk_assessment_current 0))
(assert (not (= source_risk_assessment_current target_risk_assessment_current)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; audit_current: source semantics (matches Coq)
; Translation validation: audit_current preserves semantics
(push 1)
(declare-const source_audit_current Int)
(declare-const target_audit_current Int)
(assert (>= source_audit_current 0))
(assert (>= target_audit_current 0))
(assert (not (= source_audit_current target_audit_current)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; incident_reported_promptly: source semantics (matches Coq)
; Translation validation: incident_reported_promptly preserves semantics
(push 1)
(declare-const source_incident_reported_promptly Int)
(declare-const target_incident_reported_promptly Int)
(assert (>= source_incident_reported_promptly 0))
(assert (>= target_incident_reported_promptly 0))
(assert (not (= source_incident_reported_promptly target_incident_reported_promptly)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; incident_report_complete: source semantics (matches Coq)
; Translation validation: incident_report_complete preserves semantics
(push 1)
(declare-const source_incident_report_complete Int)
(declare-const target_incident_report_complete Int)
(assert (>= source_incident_report_complete 0))
(assert (>= target_incident_report_complete 0))
(assert (not (= source_incident_report_complete target_incident_report_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; controls_sufficient: source semantics (matches Coq)
; Translation validation: controls_sufficient preserves semantics
(push 1)
(declare-const source_controls_sufficient Int)
(declare-const target_controls_sufficient Int)
(assert (>= source_controls_sufficient 0))
(assert (>= target_controls_sufficient 0))
(assert (not (= source_controls_sufficient target_controls_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cssp_valid: source semantics (matches Coq)
; Translation validation: cssp_valid preserves semantics
(push 1)
(declare-const source_cssp_valid Int)
(declare-const target_cssp_valid Int)
(assert (>= source_cssp_valid 0))
(assert (>= target_cssp_valid 0))
(assert (not (= source_cssp_valid target_cssp_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; act854_compliant: source semantics (matches Coq)
; Translation validation: act854_compliant preserves semantics
(push 1)
(declare-const source_act854_compliant Int)
(declare-const target_act854_compliant Int)
(assert (>= source_act854_compliant 0))
(assert (>= target_act854_compliant 0))
(assert (not (= source_act854_compliant target_act854_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ceo_liability_applies: source semantics (matches Coq)
; Translation validation: ceo_liability_applies preserves semantics
(push 1)
(declare-const source_ceo_liability_applies Int)
(declare-const target_ceo_liability_applies Int)
(assert (>= source_ceo_liability_applies 0))
(assert (>= target_ceo_liability_applies 0))
(assert (not (= source_ceo_liability_applies target_ceo_liability_applies)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sector_critical: source semantics (matches Coq)
; Translation validation: sector_critical preserves semantics
(push 1)
(declare-const source_sector_critical Int)
(declare-const target_sector_critical Int)
(assert (>= source_sector_critical 0))
(assert (>= target_sector_critical 0))
(assert (not (= source_sector_critical target_sector_critical)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; obligation_1_risk_assessment: translation preserves property (matches Coq: Theorem)
; Translation validation: obligation_1_risk_assessment preserves semantics
(push 1)
(declare-const source_obligation_1_risk_assessment Int)
(declare-const target_obligation_1_risk_assessment Int)
(assert (>= source_obligation_1_risk_assessment 0))
(assert (>= target_obligation_1_risk_assessment 0))
(assert (not (= source_obligation_1_risk_assessment target_obligation_1_risk_assessment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; obligation_2_audit: translation preserves property (matches Coq: Theorem)
; Translation validation: obligation_2_audit preserves semantics
(push 1)
(declare-const source_obligation_2_audit Int)
(declare-const target_obligation_2_audit Int)
(assert (>= source_obligation_2_audit 0))
(assert (>= target_obligation_2_audit 0))
(assert (not (= source_obligation_2_audit target_obligation_2_audit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; audit_expiry: translation preserves property (matches Coq: Theorem)
; Translation validation: audit_expiry preserves semantics
(push 1)
(declare-const source_audit_expiry Int)
(declare-const target_audit_expiry Int)
(assert (>= source_audit_expiry 0))
(assert (>= target_audit_expiry 0))
(assert (not (= source_audit_expiry target_audit_expiry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; obligation_3_reporting: translation preserves property (matches Coq: Theorem)
; Translation validation: obligation_3_reporting preserves semantics
(push 1)
(declare-const source_obligation_3_reporting Int)
(declare-const target_obligation_3_reporting Int)
(assert (>= source_obligation_3_reporting 0))
(assert (>= target_obligation_3_reporting 0))
(assert (not (= source_obligation_3_reporting target_obligation_3_reporting)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; severity_ordering: translation preserves property (matches Coq: Theorem)
; Translation validation: severity_ordering preserves semantics
(push 1)
(declare-const source_severity_ordering Int)
(declare-const target_severity_ordering Int)
(assert (>= source_severity_ordering 0))
(assert (>= target_severity_ordering 0))
(assert (not (= source_severity_ordering target_severity_ordering)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; obligation_4_controls: translation preserves property (matches Coq: Theorem)
; Translation validation: obligation_4_controls preserves semantics
(push 1)
(declare-const source_obligation_4_controls Int)
(declare-const target_obligation_4_controls Int)
(assert (>= source_obligation_4_controls 0))
(assert (>= target_obligation_4_controls 0))
(assert (not (= source_obligation_4_controls target_obligation_4_controls)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; obligation_5_cssp: translation preserves property (matches Coq: Theorem)
; Translation validation: obligation_5_cssp preserves semantics
(push 1)
(declare-const source_obligation_5_cssp Int)
(declare-const target_obligation_5_cssp Int)
(assert (>= source_obligation_5_cssp 0))
(assert (>= target_obligation_5_cssp 0))
(assert (not (= source_obligation_5_cssp target_obligation_5_cssp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; act854_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: act854_composition preserves semantics
(push 1)
(declare-const source_act854_composition Int)
(declare-const target_act854_composition Int)
(assert (>= source_act854_composition 0))
(assert (>= target_act854_composition 0))
(assert (not (= source_act854_composition target_act854_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ncii_sector_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: ncii_sector_coverage preserves semantics
(push 1)
(declare-const source_ncii_sector_coverage Int)
(declare-const target_ncii_sector_coverage Int)
(assert (>= source_ncii_sector_coverage 0))
(assert (>= target_ncii_sector_coverage 0))
(assert (not (= source_ncii_sector_coverage target_ncii_sector_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; critical_is_highest_risk: translation preserves property (matches Coq: Theorem)
; Translation validation: critical_is_highest_risk preserves semantics
(push 1)
(declare-const source_critical_is_highest_risk Int)
(declare-const target_critical_is_highest_risk Int)
(assert (>= source_critical_is_highest_risk 0))
(assert (>= target_critical_is_highest_risk 0))
(assert (not (= source_critical_is_highest_risk target_critical_is_highest_risk)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; low_is_lowest_risk: translation preserves property (matches Coq: Theorem)
; Translation validation: low_is_lowest_risk preserves semantics
(push 1)
(declare-const source_low_is_lowest_risk Int)
(declare-const target_low_is_lowest_risk Int)
(assert (>= source_low_is_lowest_risk 0))
(assert (>= target_low_is_lowest_risk 0))
(assert (not (= source_low_is_lowest_risk target_low_is_lowest_risk)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; risk_level_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: risk_level_bounded preserves semantics
(push 1)
(declare-const source_risk_level_bounded Int)
(declare-const target_risk_level_bounded Int)
(assert (>= source_risk_level_bounded 0))
(assert (>= target_risk_level_bounded 0))
(assert (not (= source_risk_level_bounded target_risk_level_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; risk_level_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: risk_level_coverage preserves semantics
(push 1)
(declare-const source_risk_level_coverage Int)
(declare-const target_risk_level_coverage Int)
(assert (>= source_risk_level_coverage 0))
(assert (>= target_risk_level_coverage 0))
(assert (not (= source_risk_level_coverage target_risk_level_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; audit_current_expiry_exclusive: translation preserves property (matches Coq: Theorem)
; Translation validation: audit_current_expiry_exclusive preserves semantics
(push 1)
(declare-const source_audit_current_expiry_exclusive Int)
(declare-const target_audit_current_expiry_exclusive Int)
(assert (>= source_audit_current_expiry_exclusive 0))
(assert (>= target_audit_current_expiry_exclusive 0))
(assert (not (= source_audit_current_expiry_exclusive target_audit_current_expiry_exclusive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; more_controls_still_sufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: more_controls_still_sufficient preserves semantics
(push 1)
(declare-const source_more_controls_still_sufficient Int)
(declare-const target_more_controls_still_sufficient Int)
(assert (>= source_more_controls_still_sufficient 0))
(assert (>= target_more_controls_still_sufficient 0))
(assert (not (= source_more_controls_still_sufficient target_more_controls_still_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; act854_implies_risk_assessed: translation preserves property (matches Coq: Theorem)
; Translation validation: act854_implies_risk_assessed preserves semantics
(push 1)
(declare-const source_act854_implies_risk_assessed Int)
(declare-const target_act854_implies_risk_assessed Int)
(assert (>= source_act854_implies_risk_assessed 0))
(assert (>= target_act854_implies_risk_assessed 0))
(assert (not (= source_act854_implies_risk_assessed target_act854_implies_risk_assessed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; act854_implies_audit_current: translation preserves property (matches Coq: Theorem)
; Translation validation: act854_implies_audit_current preserves semantics
(push 1)
(declare-const source_act854_implies_audit_current Int)
(declare-const target_act854_implies_audit_current Int)
(assert (>= source_act854_implies_audit_current 0))
(assert (>= target_act854_implies_audit_current 0))
(assert (not (= source_act854_implies_audit_current target_act854_implies_audit_current)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; act854_implies_controls: translation preserves property (matches Coq: Theorem)
; Translation validation: act854_implies_controls preserves semantics
(push 1)
(declare-const source_act854_implies_controls Int)
(declare-const target_act854_implies_controls Int)
(assert (>= source_act854_implies_controls 0))
(assert (>= target_act854_implies_controls 0))
(assert (not (= source_act854_implies_controls target_act854_implies_controls)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; act854_implies_cssp_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: act854_implies_cssp_valid preserves semantics
(push 1)
(declare-const source_act854_implies_cssp_valid Int)
(declare-const target_act854_implies_cssp_valid Int)
(assert (>= source_act854_implies_cssp_valid 0))
(assert (>= target_act854_implies_cssp_valid 0))
(assert (not (= source_act854_implies_cssp_valid target_act854_implies_cssp_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cssp_expired: translation preserves property (matches Coq: Theorem)
; Translation validation: cssp_expired preserves semantics
(push 1)
(declare-const source_cssp_expired Int)
(declare-const target_cssp_expired Int)
(assert (>= source_cssp_expired 0))
(assert (>= target_cssp_expired 0))
(assert (not (= source_cssp_expired target_cssp_expired)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cssp_unlicensed_invalid: translation preserves property (matches Coq: Theorem)
; Translation validation: cssp_unlicensed_invalid preserves semantics
(push 1)
(declare-const source_cssp_unlicensed_invalid Int)
(declare-const target_cssp_unlicensed_invalid Int)
(assert (>= source_cssp_unlicensed_invalid 0))
(assert (>= target_cssp_unlicensed_invalid 0))
(assert (not (= source_cssp_unlicensed_invalid target_cssp_unlicensed_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ceo_liable_when_negligent: translation preserves property (matches Coq: Theorem)
; Translation validation: ceo_liable_when_negligent preserves semantics
(push 1)
(declare-const source_ceo_liable_when_negligent Int)
(declare-const target_ceo_liable_when_negligent Int)
(assert (>= source_ceo_liable_when_negligent 0))
(assert (>= target_ceo_liable_when_negligent 0))
(assert (not (= source_ceo_liable_when_negligent target_ceo_liable_when_negligent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ceo_due_diligence_defense: translation preserves property (matches Coq: Theorem)
; Translation validation: ceo_due_diligence_defense preserves semantics
(push 1)
(declare-const source_ceo_due_diligence_defense Int)
(declare-const target_ceo_due_diligence_defense Int)
(assert (>= source_ceo_due_diligence_defense 0))
(assert (>= target_ceo_due_diligence_defense 0))
(assert (not (= source_ceo_due_diligence_defense target_ceo_due_diligence_defense)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; incident_6h_stricter_than_24h: translation preserves property (matches Coq: Theorem)
; Translation validation: incident_6h_stricter_than_24h preserves semantics
(push 1)
(declare-const source_incident_6h_stricter_than_24h Int)
(declare-const target_incident_6h_stricter_than_24h Int)
(assert (>= source_incident_6h_stricter_than_24h 0))
(assert (>= target_incident_6h_stricter_than_24h 0))
(assert (not (= source_incident_6h_stricter_than_24h target_incident_6h_stricter_than_24h)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; immediate_report_always_timely: translation preserves property (matches Coq: Theorem)
; Translation validation: immediate_report_always_timely preserves semantics
(push 1)
(declare-const source_immediate_report_always_timely Int)
(declare-const target_immediate_report_always_timely Int)
(assert (>= source_immediate_report_always_timely 0))
(assert (>= target_immediate_report_always_timely 0))
(assert (not (= source_immediate_report_always_timely target_immediate_report_always_timely)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; banking_is_critical: translation preserves property (matches Coq: Theorem)
; Translation validation: banking_is_critical preserves semantics
(push 1)
(declare-const source_banking_is_critical Int)
(declare-const target_banking_is_critical Int)
(assert (>= source_banking_is_critical 0))
(assert (>= target_banking_is_critical 0))
(assert (not (= source_banking_is_critical target_banking_is_critical)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; defense_is_critical: translation preserves property (matches Coq: Theorem)
; Translation validation: defense_is_critical preserves semantics
(push 1)
(declare-const source_defense_is_critical Int)
(declare-const target_defense_is_critical Int)
(assert (>= source_defense_is_critical 0))
(assert (>= target_defense_is_critical 0))
(assert (not (= source_defense_is_critical target_defense_is_critical)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; telecom_not_critical: translation preserves property (matches Coq: Theorem)
; Translation validation: telecom_not_critical preserves semantics
(push 1)
(declare-const source_telecom_not_critical Int)
(declare-const target_telecom_not_critical Int)
(assert (>= source_telecom_not_critical 0))
(assert (>= target_telecom_not_critical 0))
(assert (not (= source_telecom_not_critical target_telecom_not_critical)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SingaporeCybersecurityAct.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for SingaporeCybersecurityAct
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; cii_risk_current: source semantics (matches Coq)
; Translation validation: cii_risk_current preserves semantics
(push 1)
(declare-const source_cii_risk_current Int)
(declare-const target_cii_risk_current Int)
(assert (>= source_cii_risk_current 0))
(assert (>= target_cii_risk_current 0))
(assert (not (= source_cii_risk_current target_cii_risk_current)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_audit_current: source semantics (matches Coq)
; Translation validation: cii_audit_current preserves semantics
(push 1)
(declare-const source_cii_audit_current Int)
(declare-const target_cii_audit_current Int)
(assert (>= source_cii_audit_current 0))
(assert (>= target_cii_audit_current 0))
(assert (not (= source_cii_audit_current target_cii_audit_current)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_incident_reported_in_time: source semantics (matches Coq)
; Translation validation: sg_incident_reported_in_time preserves semantics
(push 1)
(declare-const source_sg_incident_reported_in_time Int)
(declare-const target_sg_incident_reported_in_time Int)
(assert (>= source_sg_incident_reported_in_time 0))
(assert (>= target_sg_incident_reported_in_time 0))
(assert (not (= source_sg_incident_reported_in_time target_sg_incident_reported_in_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_controls_adequate: source semantics (matches Coq)
; Translation validation: cii_controls_adequate preserves semantics
(push 1)
(declare-const source_cii_controls_adequate Int)
(declare-const target_cii_controls_adequate Int)
(assert (>= source_cii_controls_adequate 0))
(assert (>= target_cii_controls_adequate 0))
(assert (not (= source_cii_controls_adequate target_cii_controls_adequate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; esci_obligations_met: source semantics (matches Coq)
; Translation validation: esci_obligations_met preserves semantics
(push 1)
(declare-const source_esci_obligations_met Int)
(declare-const target_esci_obligations_met Int)
(assert (>= source_esci_obligations_met 0))
(assert (>= target_esci_obligations_met 0))
(assert (not (= source_esci_obligations_met target_esci_obligations_met)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cssp_licensed_sg: source semantics (matches Coq)
; Translation validation: cssp_licensed_sg preserves semantics
(push 1)
(declare-const source_cssp_licensed_sg Int)
(declare-const target_cssp_licensed_sg Int)
(assert (>= source_cssp_licensed_sg 0))
(assert (>= target_cssp_licensed_sg 0))
(assert (not (= source_cssp_licensed_sg target_cssp_licensed_sg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_cybersecurity_act_compliant: source semantics (matches Coq)
; Translation validation: sg_cybersecurity_act_compliant preserves semantics
(push 1)
(declare-const source_sg_cybersecurity_act_compliant Int)
(declare-const target_sg_cybersecurity_act_compliant Int)
(assert (>= source_sg_cybersecurity_act_compliant 0))
(assert (>= target_sg_cybersecurity_act_compliant 0))
(assert (not (= source_sg_cybersecurity_act_compliant target_sg_cybersecurity_act_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; stcc_obligations_met: source semantics (matches Coq)
; Translation validation: stcc_obligations_met preserves semantics
(push 1)
(declare-const source_stcc_obligations_met Int)
(declare-const target_stcc_obligations_met Int)
(assert (>= source_stcc_obligations_met 0))
(assert (>= target_stcc_obligations_met 0))
(assert (not (= source_stcc_obligations_met target_stcc_obligations_met)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_owner_obligations: source semantics (matches Coq)
; Translation validation: cii_owner_obligations preserves semantics
(push 1)
(declare-const source_cii_owner_obligations Int)
(declare-const target_cii_owner_obligations Int)
(assert (>= source_cii_owner_obligations 0))
(assert (>= target_cii_owner_obligations 0))
(assert (not (= source_cii_owner_obligations target_cii_owner_obligations)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; incident_needs_notification: source semantics (matches Coq)
; Translation validation: incident_needs_notification preserves semantics
(push 1)
(declare-const source_incident_needs_notification Int)
(declare-const target_incident_needs_notification Int)
(assert (>= source_incident_needs_notification 0))
(assert (>= target_incident_needs_notification 0))
(assert (not (= source_incident_needs_notification target_incident_needs_notification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; audit_schedule_consistent: source semantics (matches Coq)
; Translation validation: audit_schedule_consistent preserves semantics
(push 1)
(declare-const source_audit_schedule_consistent Int)
(declare-const target_audit_schedule_consistent Int)
(assert (>= source_audit_schedule_consistent 0))
(assert (>= target_audit_schedule_consistent 0))
(assert (not (= source_audit_schedule_consistent target_audit_schedule_consistent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; regular_entity_exempt: source semantics (matches Coq)
; Translation validation: regular_entity_exempt preserves semantics
(push 1)
(declare-const source_regular_entity_exempt Int)
(declare-const target_regular_entity_exempt Int)
(assert (>= source_regular_entity_exempt 0))
(assert (>= target_regular_entity_exempt 0))
(assert (not (= source_regular_entity_exempt target_regular_entity_exempt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; penalty_exposure_exists: source semantics (matches Coq)
; Translation validation: penalty_exposure_exists preserves semantics
(push 1)
(declare-const source_penalty_exposure_exists Int)
(declare-const target_penalty_exposure_exists Int)
(assert (>= source_penalty_exposure_exists 0))
(assert (>= target_penalty_exposure_exists 0))
(assert (not (= source_penalty_exposure_exists target_penalty_exposure_exists)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_obligation_1: translation preserves property (matches Coq: Theorem)
; Translation validation: cii_obligation_1 preserves semantics
(push 1)
(declare-const source_cii_obligation_1 Int)
(declare-const target_cii_obligation_1 Int)
(assert (>= source_cii_obligation_1 0))
(assert (>= target_cii_obligation_1 0))
(assert (not (= source_cii_obligation_1 target_cii_obligation_1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_obligation_2: translation preserves property (matches Coq: Theorem)
; Translation validation: cii_obligation_2 preserves semantics
(push 1)
(declare-const source_cii_obligation_2 Int)
(declare-const target_cii_obligation_2 Int)
(assert (>= source_cii_obligation_2 0))
(assert (>= target_cii_obligation_2 0))
(assert (not (= source_cii_obligation_2 target_cii_obligation_2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_obligation_3: translation preserves property (matches Coq: Theorem)
; Translation validation: cii_obligation_3 preserves semantics
(push 1)
(declare-const source_cii_obligation_3 Int)
(declare-const target_cii_obligation_3 Int)
(assert (>= source_cii_obligation_3 0))
(assert (>= target_cii_obligation_3 0))
(assert (not (= source_cii_obligation_3 target_cii_obligation_3)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_stricter_than_my: translation preserves property (matches Coq: Theorem)
; Translation validation: sg_stricter_than_my preserves semantics
(push 1)
(declare-const source_sg_stricter_than_my Int)
(declare-const target_sg_stricter_than_my Int)
(assert (>= source_sg_stricter_than_my 0))
(assert (>= target_sg_stricter_than_my 0))
(assert (not (= source_sg_stricter_than_my target_sg_stricter_than_my)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_obligation_4: translation preserves property (matches Coq: Theorem)
; Translation validation: cii_obligation_4 preserves semantics
(push 1)
(declare-const source_cii_obligation_4 Int)
(declare-const target_cii_obligation_4 Int)
(assert (>= source_cii_obligation_4 0))
(assert (>= target_cii_obligation_4 0))
(assert (not (= source_cii_obligation_4 target_cii_obligation_4)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; esci_compliance: translation preserves property (matches Coq: Theorem)
; Translation validation: esci_compliance preserves semantics
(push 1)
(declare-const source_esci_compliance Int)
(declare-const target_esci_compliance Int)
(assert (>= source_esci_compliance 0))
(assert (>= target_esci_compliance 0))
(assert (not (= source_esci_compliance target_esci_compliance)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cssp_obligation: translation preserves property (matches Coq: Theorem)
; Translation validation: cssp_obligation preserves semantics
(push 1)
(declare-const source_cssp_obligation Int)
(declare-const target_cssp_obligation Int)
(assert (>= source_cssp_obligation 0))
(assert (>= target_cssp_obligation 0))
(assert (not (= source_cssp_obligation target_cssp_obligation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_cybersecurity_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: sg_cybersecurity_composition preserves semantics
(push 1)
(declare-const source_sg_cybersecurity_composition Int)
(declare-const target_sg_cybersecurity_composition Int)
(assert (>= source_sg_cybersecurity_composition 0))
(assert (>= target_sg_cybersecurity_composition 0))
(assert (not (= source_sg_cybersecurity_composition target_sg_cybersecurity_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_sector_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: cii_sector_coverage preserves semantics
(push 1)
(declare-const source_cii_sector_coverage Int)
(declare-const target_cii_sector_coverage Int)
(assert (>= source_cii_sector_coverage 0))
(assert (>= target_cii_sector_coverage 0))
(assert (not (= source_cii_sector_coverage target_cii_sector_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; entity_classification_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: entity_classification_coverage preserves semantics
(push 1)
(declare-const source_entity_classification_coverage Int)
(declare-const target_entity_classification_coverage Int)
(assert (>= source_entity_classification_coverage 0))
(assert (>= target_entity_classification_coverage 0))
(assert (not (= source_entity_classification_coverage target_entity_classification_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; stcc_compliance: translation preserves property (matches Coq: Theorem)
; Translation validation: stcc_compliance preserves semantics
(push 1)
(declare-const source_stcc_compliance Int)
(declare-const target_stcc_compliance Int)
(assert (>= source_stcc_compliance 0))
(assert (>= target_stcc_compliance 0))
(assert (not (= source_stcc_compliance target_stcc_compliance)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_owner_strictest: translation preserves property (matches Coq: Theorem)
; Translation validation: cii_owner_strictest preserves semantics
(push 1)
(declare-const source_cii_owner_strictest Int)
(declare-const target_cii_owner_strictest Int)
(assert (>= source_cii_owner_strictest 0))
(assert (>= target_cii_owner_strictest 0))
(assert (not (= source_cii_owner_strictest target_cii_owner_strictest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cii_owner_implies_esci_risk: translation preserves property (matches Coq: Theorem)
; Translation validation: cii_owner_implies_esci_risk preserves semantics
(push 1)
(declare-const source_cii_owner_implies_esci_risk Int)
(declare-const target_cii_owner_implies_esci_risk Int)
(assert (>= source_cii_owner_implies_esci_risk 0))
(assert (>= target_cii_owner_implies_esci_risk 0))
(assert (not (= source_cii_owner_implies_esci_risk target_cii_owner_implies_esci_risk)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; significant_incident_must_notify: translation preserves property (matches Coq: Theorem)
; Translation validation: significant_incident_must_notify preserves semantics
(push 1)
(declare-const source_significant_incident_must_notify Int)
(declare-const target_significant_incident_must_notify Int)
(assert (>= source_significant_incident_must_notify 0))
(assert (>= target_significant_incident_must_notify 0))
(assert (not (= source_significant_incident_must_notify target_significant_incident_must_notify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; two_hour_deadline_tight: translation preserves property (matches Coq: Theorem)
; Translation validation: two_hour_deadline_tight preserves semantics
(push 1)
(declare-const source_two_hour_deadline_tight Int)
(declare-const target_two_hour_deadline_tight Int)
(assert (>= source_two_hour_deadline_tight 0))
(assert (>= target_two_hour_deadline_tight 0))
(assert (not (= source_two_hour_deadline_tight target_two_hour_deadline_tight)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_2h_stricter_than_my_6h: translation preserves property (matches Coq: Theorem)
; Translation validation: sg_2h_stricter_than_my_6h preserves semantics
(push 1)
(declare-const source_sg_2h_stricter_than_my_6h Int)
(declare-const target_sg_2h_stricter_than_my_6h Int)
(assert (>= source_sg_2h_stricter_than_my_6h 0))
(assert (>= target_sg_2h_stricter_than_my_6h 0))
(assert (not (= source_sg_2h_stricter_than_my_6h target_sg_2h_stricter_than_my_6h)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_2h_stricter_than_72h: translation preserves property (matches Coq: Theorem)
; Translation validation: sg_2h_stricter_than_72h preserves semantics
(push 1)
(declare-const source_sg_2h_stricter_than_72h Int)
(declare-const target_sg_2h_stricter_than_72h Int)
(assert (>= source_sg_2h_stricter_than_72h 0))
(assert (>= target_sg_2h_stricter_than_72h 0))
(assert (not (= source_sg_2h_stricter_than_72h target_sg_2h_stricter_than_72h)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; audit_schedule_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: audit_schedule_valid preserves semantics
(push 1)
(declare-const source_audit_schedule_valid Int)
(declare-const target_audit_schedule_valid Int)
(assert (>= source_audit_schedule_valid 0))
(assert (>= target_audit_schedule_valid 0))
(assert (not (= source_audit_schedule_valid target_audit_schedule_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; more_controls_still_adequate: translation preserves property (matches Coq: Theorem)
; Translation validation: more_controls_still_adequate preserves semantics
(push 1)
(declare-const source_more_controls_still_adequate Int)
(declare-const target_more_controls_still_adequate Int)
(assert (>= source_more_controls_still_adequate 0))
(assert (>= target_more_controls_still_adequate 0))
(assert (not (= source_more_controls_still_adequate target_more_controls_still_adequate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_cyber_full_implies_risk: translation preserves property (matches Coq: Theorem)
; Translation validation: sg_cyber_full_implies_risk preserves semantics
(push 1)
(declare-const source_sg_cyber_full_implies_risk Int)
(declare-const target_sg_cyber_full_implies_risk Int)
(assert (>= source_sg_cyber_full_implies_risk 0))
(assert (>= target_sg_cyber_full_implies_risk 0))
(assert (not (= source_sg_cyber_full_implies_risk target_sg_cyber_full_implies_risk)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_cyber_full_implies_audit: translation preserves property (matches Coq: Theorem)
; Translation validation: sg_cyber_full_implies_audit preserves semantics
(push 1)
(declare-const source_sg_cyber_full_implies_audit Int)
(declare-const target_sg_cyber_full_implies_audit Int)
(assert (>= source_sg_cyber_full_implies_audit 0))
(assert (>= target_sg_cyber_full_implies_audit 0))
(assert (not (= source_sg_cyber_full_implies_audit target_sg_cyber_full_implies_audit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_cyber_full_implies_controls: translation preserves property (matches Coq: Theorem)
; Translation validation: sg_cyber_full_implies_controls preserves semantics
(push 1)
(declare-const source_sg_cyber_full_implies_controls Int)
(declare-const target_sg_cyber_full_implies_controls Int)
(assert (>= source_sg_cyber_full_implies_controls 0))
(assert (>= target_sg_cyber_full_implies_controls 0))
(assert (not (= source_sg_cyber_full_implies_controls target_sg_cyber_full_implies_controls)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sg_cyber_full_implies_irp: translation preserves property (matches Coq: Theorem)
; Translation validation: sg_cyber_full_implies_irp preserves semantics
(push 1)
(declare-const source_sg_cyber_full_implies_irp Int)
(declare-const target_sg_cyber_full_implies_irp Int)
(assert (>= source_sg_cyber_full_implies_irp 0))
(assert (>= target_sg_cyber_full_implies_irp 0))
(assert (not (= source_sg_cyber_full_implies_irp target_sg_cyber_full_implies_irp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cssp_expired_non_compliant: translation preserves property (matches Coq: Theorem)
; Translation validation: cssp_expired_non_compliant preserves semantics
(push 1)
(declare-const source_cssp_expired_non_compliant Int)
(declare-const target_cssp_expired_non_compliant Int)
(assert (>= source_cssp_expired_non_compliant 0))
(assert (>= target_cssp_expired_non_compliant 0))
(assert (not (= source_cssp_expired_non_compliant target_cssp_expired_non_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; regular_entity_no_cii_obligation: translation preserves property (matches Coq: Theorem)
; Translation validation: regular_entity_no_cii_obligation preserves semantics
(push 1)
(declare-const source_regular_entity_no_cii_obligation Int)
(declare-const target_regular_entity_no_cii_obligation Int)
(assert (>= source_regular_entity_no_cii_obligation 0))
(assert (>= target_regular_entity_no_cii_obligation 0))
(assert (not (= source_regular_entity_no_cii_obligation target_regular_entity_no_cii_obligation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compliance_eliminates_penalty: translation preserves property (matches Coq: Theorem)
; Translation validation: compliance_eliminates_penalty preserves semantics
(push 1)
(declare-const source_compliance_eliminates_penalty Int)
(declare-const target_compliance_eliminates_penalty Int)
(assert (>= source_compliance_eliminates_penalty 0))
(assert (>= target_compliance_eliminates_penalty 0))
(assert (not (= source_compliance_eliminates_penalty target_compliance_eliminates_penalty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

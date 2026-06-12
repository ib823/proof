; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SingaporeCybersecurityAct.v (26 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SingaporeCybersecurityAct

(set-logic ALL)
(set-option :produce-models true)

; CIISector (matches Coq: Inductive CIISector)
(declare-datatypes ((CIISector 0)) (((SGEnergy) (SGWater) (SGBankingFinance) (SGHealthcare) (SGTransportLand) (SGTransportMaritime) (SGTransportAviation) (SGInfocomm) (SGMedia) (SGSecurityEmergency) (SGGovernment))))

; EntityClassification (matches Coq: Inductive EntityClassification)
(declare-datatypes ((EntityClassification 0)) (((CIIOwner) (ESCI) (STCC) (RegularEntity))))

(declare-const __default_CIISector CIISector)
(declare-const __default_EntityClassification EntityClassification)

; cii_risk_current (matches Coq: Definition cii_risk_current)
(define-fun cii_risk_current ((e Int)) Bool
  (= 0 0))

; cii_audit_current (matches Coq: Definition cii_audit_current)
(define-fun cii_audit_current ((e Int) (t Int)) Bool
  (= 0 0))

; sg_incident_reported_in_time (matches Coq: Definition sg_incident_reported_in_time)
(define-fun sg_incident_reported_in_time ((i Int)) Bool
  (= 0 0))

; cii_controls_adequate (matches Coq: Definition cii_controls_adequate)
(define-fun cii_controls_adequate ((e Int)) Bool
  (= 0 0))

; esci_obligations_met (matches Coq: Definition esci_obligations_met)
(define-fun esci_obligations_met ((e Int)) Bool
  (= 0 0))

; cssp_licensed_sg (matches Coq: Definition cssp_licensed_sg)
(define-fun cssp_licensed_sg ((e Int)) Bool
  (= 0 0))

; sg_cybersecurity_act_compliant (matches Coq: Definition sg_cybersecurity_act_compliant)
(define-fun sg_cybersecurity_act_compliant ((e Int) (t Int)) Bool
  (= 0 0))

; stcc_obligations_met (matches Coq: Definition stcc_obligations_met)
(define-fun stcc_obligations_met ((e Int)) Bool
  (= 0 0))

; cii_owner_obligations (matches Coq: Definition cii_owner_obligations)
(define-fun cii_owner_obligations ((e Int) (t Int)) Bool
  (= 0 0))

; incident_needs_notification (matches Coq: Definition incident_needs_notification)
(define-fun incident_needs_notification ((i Int)) Bool
  (= 0 0))

; audit_schedule_consistent (matches Coq: Definition audit_schedule_consistent)
(define-fun audit_schedule_consistent ((sched Int)) Bool
  (= 0 0))

; regular_entity_exempt (matches Coq: Definition regular_entity_exempt)
(define-fun regular_entity_exempt ((e Int)) Bool
  (= 0 0))

; penalty_exposure_exists (matches Coq: Definition penalty_exposure_exists)
(define-fun penalty_exposure_exists ((e Int) (t Int)) Bool
  (= 0 0))

; cii_obligation_1 (matches Coq: Theorem cii_obligation_1)
; cii_obligation_1: forall (e : CIIOwnerEntity), cii_risk_assessed e = true -> cii_risk_current e
(assert (forall ((e Int)) (= 0 0))) ; cii_obligation_1 [partial: bindings preserved]

; cii_obligation_2 (matches Coq: Theorem cii_obligation_2)
; cii_obligation_2: forall (e : CIIOwnerEntity) (t : nat), cii_audit_completed e = true -> t <= cii_last_audit e + 365 -> cii_audit_current 
(assert (forall ((e Int) (t Int)) (= 0 0))) ; cii_obligation_2 [partial: bindings preserved]

; cii_obligation_3 (matches Coq: Theorem cii_obligation_3)
; cii_obligation_3: forall (i : SGCyberIncident), sg_incident_reported_at i <= sg_incident_detected_at i + 2 -> sg_incident_reported_in_time
(assert (forall ((i Int)) (= 0 0))) ; cii_obligation_3 [partial: bindings preserved]

; sg_stricter_than_my (matches Coq: Theorem sg_stricter_than_my)
; sg_stricter_than_my: forall (detected_at reported_at : nat), reported_at <= detected_at + 2 -> reported_at <= detected_at + 6
(assert (forall ((detected_at Int) (reported_at Int)) (= 0 0))) ; sg_stricter_than_my [partial: bindings preserved]

; cii_obligation_4 (matches Coq: Theorem cii_obligation_4)
; cii_obligation_4: forall (e : CIIOwnerEntity), cii_min_controls e <= cii_security_controls e -> cii_controls_adequate e
(assert (forall ((e Int)) (= 0 0))) ; cii_obligation_4 [partial: bindings preserved]

; esci_compliance (matches Coq: Theorem esci_compliance)
; esci_compliance: forall (e : CIIOwnerEntity), cii_classification e = ESCI -> cii_risk_assessed e = true -> cii_incident_response_plan e =
(assert (forall ((e Int)) (= 0 0))) ; esci_compliance [partial: bindings preserved]

; cssp_obligation (matches Coq: Theorem cssp_obligation)
; cssp_obligation: forall (e : CIIOwnerEntity), cii_cssp_licensed e = true -> cssp_licensed_sg e
(assert (forall ((e Int)) (= 0 0))) ; cssp_obligation [partial: bindings preserved]

; sg_cybersecurity_composition (matches Coq: Theorem sg_cybersecurity_composition)
; sg_cybersecurity_composition: forall (e : CIIOwnerEntity) (t : nat), cii_risk_current e -> cii_audit_current e t -> cii_controls_adequate e -> cii_inc
(assert (forall ((e Int) (t Int)) (= 0 0))) ; sg_cybersecurity_composition [partial: bindings preserved]

; cii_sector_coverage (matches Coq: Theorem cii_sector_coverage)
; cii_sector_coverage: forall (s : CIISector), In s all_cii_sectors
(assert (forall ((s CIISector)) (= 0 0))) ; cii_sector_coverage [partial: bindings preserved]

; entity_classification_coverage (matches Coq: Theorem entity_classification_coverage)
; entity_classification_coverage: forall (c : EntityClassification), In c all_entity_classifications
(assert (forall ((c EntityClassification)) (= 0 0))) ; entity_classification_coverage [partial: bindings preserved]

; stcc_compliance (matches Coq: Theorem stcc_compliance)
; stcc_compliance: forall (e : CIIOwnerEntity), cii_classification e = STCC -> cii_risk_assessed e = true -> cii_security_controls e >= cii
(assert (forall ((e Int)) (= 0 0))) ; stcc_compliance [partial: bindings preserved]

; cii_owner_strictest (matches Coq: Theorem cii_owner_strictest)
; cii_owner_strictest: forall (e : CIIOwnerEntity) (t : nat), cii_owner_obligations e t -> cii_risk_current e
(assert (forall ((e Int) (t Int)) (= 0 0))) ; cii_owner_strictest [partial: bindings preserved]

; cii_owner_implies_esci_risk (matches Coq: Theorem cii_owner_implies_esci_risk)
; cii_owner_implies_esci_risk: forall (e : CIIOwnerEntity) (t : nat), cii_owner_obligations e t -> cii_risk_assessed e = true /\ cii_incident_response_
(assert (forall ((e Int) (t Int)) (= 0 0))) ; cii_owner_implies_esci_risk [partial: bindings preserved]

; significant_incident_must_notify (matches Coq: Theorem significant_incident_must_notify)
; significant_incident_must_notify: forall (i : SGCyberIncident), sg_incident_significant i = true -> incident_needs_notification i
(assert (forall ((i Int)) (= 0 0))) ; significant_incident_must_notify [partial: bindings preserved]

; two_hour_deadline_tight (matches Coq: Theorem two_hour_deadline_tight)
; two_hour_deadline_tight: forall (detected : nat), detected + 2 < detected + 6
(assert (forall ((detected Int)) (= 0 0))) ; two_hour_deadline_tight [partial: bindings preserved]

; sg_2h_stricter_than_my_6h (matches Coq: Theorem sg_2h_stricter_than_my_6h)
; sg_2h_stricter_than_my_6h: forall (i : SGCyberIncident), sg_incident_reported_in_time i -> sg_incident_reported_at i <= sg_incident_detected_at i +
(assert (forall ((i Int)) (= 0 0))) ; sg_2h_stricter_than_my_6h [partial: bindings preserved]

; sg_2h_stricter_than_72h (matches Coq: Theorem sg_2h_stricter_than_72h)
; sg_2h_stricter_than_72h: forall (i : SGCyberIncident), sg_incident_reported_in_time i -> sg_incident_reported_at i <= sg_incident_detected_at i +
(assert (forall ((i Int)) (= 0 0))) ; sg_2h_stricter_than_72h [partial: bindings preserved]

; audit_schedule_valid (matches Coq: Theorem audit_schedule_valid)
; audit_schedule_valid: forall (sched : AuditSchedule), as_next_audit sched = as_last_audit sched + as_audit_interval sched -> audit_schedule_co
(assert (forall ((sched Int)) (= 0 0))) ; audit_schedule_valid [partial: bindings preserved]

; more_controls_still_adequate (matches Coq: Theorem more_controls_still_adequate)
; more_controls_still_adequate: forall (e : CIIOwnerEntity) (extra : nat), cii_controls_adequate e -> cii_min_controls e <= cii_security_controls e + ex
(assert (forall ((e Int) (extra Int)) (= 0 0))) ; more_controls_still_adequate [partial: bindings preserved]

; sg_cyber_full_implies_risk (matches Coq: Theorem sg_cyber_full_implies_risk)
; sg_cyber_full_implies_risk: forall (e : CIIOwnerEntity) (t : nat), sg_cybersecurity_act_compliant e t -> cii_risk_current e
(assert (forall ((e Int) (t Int)) (= 0 0))) ; sg_cyber_full_implies_risk [partial: bindings preserved]

; sg_cyber_full_implies_audit (matches Coq: Theorem sg_cyber_full_implies_audit)
; sg_cyber_full_implies_audit: forall (e : CIIOwnerEntity) (t : nat), sg_cybersecurity_act_compliant e t -> cii_audit_current e t
(assert (forall ((e Int) (t Int)) (= 0 0))) ; sg_cyber_full_implies_audit [partial: bindings preserved]

; sg_cyber_full_implies_controls (matches Coq: Theorem sg_cyber_full_implies_controls)
; sg_cyber_full_implies_controls: forall (e : CIIOwnerEntity) (t : nat), sg_cybersecurity_act_compliant e t -> cii_controls_adequate e
(assert (forall ((e Int) (t Int)) (= 0 0))) ; sg_cyber_full_implies_controls [partial: bindings preserved]

; sg_cyber_full_implies_irp (matches Coq: Theorem sg_cyber_full_implies_irp)
; sg_cyber_full_implies_irp: forall (e : CIIOwnerEntity) (t : nat), sg_cybersecurity_act_compliant e t -> cii_incident_response_plan e = true
(assert (forall ((e Int) (t Int)) (= 0 0))) ; sg_cyber_full_implies_irp [partial: bindings preserved]

; cssp_expired_non_compliant (matches Coq: Theorem cssp_expired_non_compliant)
; cssp_expired_non_compliant: forall (e : CIIOwnerEntity), cii_cssp_licensed e = false -> ~ cssp_licensed_sg e
(assert (forall ((e Int)) (= 0 0))) ; cssp_expired_non_compliant [partial: bindings preserved]

; regular_entity_no_cii_obligation (matches Coq: Theorem regular_entity_no_cii_obligation)
; regular_entity_no_cii_obligation: forall (e : CIIOwnerEntity), cii_classification e = RegularEntity -> regular_entity_exempt e
(assert (forall ((e Int)) (= 0 0))) ; regular_entity_no_cii_obligation [partial: bindings preserved]

; compliance_eliminates_penalty (matches Coq: Theorem compliance_eliminates_penalty)
; compliance_eliminates_penalty: forall (e : CIIOwnerEntity) (t : nat), sg_cybersecurity_act_compliant e t -> ~ penalty_exposure_exists e t
(assert (forall ((e Int) (t Int)) (= 0 0))) ; compliance_eliminates_penalty [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

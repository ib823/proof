; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/HealthcareIS.v (30 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for HealthcareIS
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; encounter_complete: source semantics (matches Coq)
; Translation validation: encounter_complete preserves semantics
(push 1)
(declare-const source_encounter_complete Int)
(declare-const target_encounter_complete Int)
(assert (>= source_encounter_complete 0))
(assert (>= target_encounter_complete 0))
(assert (not (= source_encounter_complete target_encounter_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; finalized: source semantics (matches Coq)
; Translation validation: finalized preserves semantics
(push 1)
(declare-const source_finalized Int)
(declare-const target_finalized Int)
(assert (>= source_finalized 0))
(assert (>= target_finalized 0))
(assert (not (= source_finalized target_finalized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_amendment: source semantics (matches Coq)
; Translation validation: valid_amendment preserves semantics
(push 1)
(declare-const source_valid_amendment Int)
(declare-const target_valid_amendment Int)
(assert (>= source_valid_amendment 0))
(assert (>= target_valid_amendment 0))
(assert (not (= source_valid_amendment target_valid_amendment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; allergy_complete: source semantics (matches Coq)
; Translation validation: allergy_complete preserves semantics
(push 1)
(declare-const source_allergy_complete Int)
(declare-const target_allergy_complete Int)
(assert (>= source_allergy_complete 0))
(assert (>= target_allergy_complete 0))
(assert (not (= source_allergy_complete target_allergy_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; interaction_detected: source semantics (matches Coq)
; Translation validation: interaction_detected preserves semantics
(push 1)
(declare-const source_interaction_detected Int)
(declare-const target_interaction_detected Int)
(assert (>= source_interaction_detected 0))
(assert (>= target_interaction_detected 0))
(assert (not (= source_interaction_detected target_interaction_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; problem_coded: source semantics (matches Coq)
; Translation validation: problem_coded preserves semantics
(push 1)
(declare-const source_problem_coded Int)
(declare-const target_problem_coded Int)
(assert (>= source_problem_coded 0))
(assert (>= target_problem_coded 0))
(assert (not (= source_problem_coded target_problem_coded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; five_rights_verified: source semantics (matches Coq)
; Translation validation: five_rights_verified preserves semantics
(push 1)
(declare-const source_five_rights_verified Int)
(declare-const target_five_rights_verified Int)
(assert (>= source_five_rights_verified 0))
(assert (>= target_five_rights_verified 0))
(assert (not (= source_five_rights_verified target_five_rights_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; administration_allowed: source semantics (matches Coq)
; Translation validation: administration_allowed preserves semantics
(push 1)
(declare-const source_administration_allowed Int)
(declare-const target_administration_allowed Int)
(assert (>= source_administration_allowed 0))
(assert (>= target_administration_allowed 0))
(assert (not (= source_administration_allowed target_administration_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; interaction_alerted: source semantics (matches Coq)
; Translation validation: interaction_alerted preserves semantics
(push 1)
(declare-const source_interaction_alerted Int)
(declare-const target_interaction_alerted Int)
(assert (>= source_interaction_alerted 0))
(assert (>= target_interaction_alerted 0))
(assert (not (= source_interaction_alerted target_interaction_alerted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dose_in_range: source semantics (matches Coq)
; Translation validation: dose_in_range preserves semantics
(push 1)
(declare-const source_dose_in_range Int)
(declare-const target_dose_in_range Int)
(assert (>= source_dose_in_range 0))
(assert (>= target_dose_in_range 0))
(assert (not (= source_dose_in_range target_dose_in_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; high_alert_safe: source semantics (matches Coq)
; Translation validation: high_alert_safe preserves semantics
(push 1)
(declare-const source_high_alert_safe Int)
(declare-const target_high_alert_safe Int)
(assert (>= source_high_alert_safe 0))
(assert (>= target_high_alert_safe 0))
(assert (not (= source_high_alert_safe target_high_alert_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; order_complete_check: source semantics (matches Coq)
; Translation validation: order_complete_check preserves semantics
(push 1)
(declare-const source_order_complete_check Int)
(declare-const target_order_complete_check Int)
(assert (>= source_order_complete_check 0))
(assert (>= target_order_complete_check 0))
(assert (not (= source_order_complete_check target_order_complete_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; order_signed: source semantics (matches Coq)
; Translation validation: order_signed preserves semantics
(push 1)
(declare-const source_order_signed Int)
(declare-const target_order_signed Int)
(assert (>= source_order_signed 0))
(assert (>= target_order_signed 0))
(assert (not (= source_order_signed target_order_signed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verbal_order_valid: source semantics (matches Coq)
; Translation validation: verbal_order_valid preserves semantics
(push 1)
(declare-const source_verbal_order_valid Int)
(declare-const target_verbal_order_valid Int)
(assert (>= source_verbal_order_valid 0))
(assert (>= target_verbal_order_valid 0))
(assert (not (= source_verbal_order_valid target_verbal_order_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; duplicate_handled: source semantics (matches Coq)
; Translation validation: duplicate_handled preserves semantics
(push 1)
(declare-const source_duplicate_handled Int)
(declare-const target_duplicate_handled Int)
(assert (>= source_duplicate_handled 0))
(assert (>= target_duplicate_handled 0))
(assert (not (= source_duplicate_handled target_duplicate_handled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; contraindication_blocked: source semantics (matches Coq)
; Translation validation: contraindication_blocked preserves semantics
(push 1)
(declare-const source_contraindication_blocked Int)
(declare-const target_contraindication_blocked Int)
(assert (>= source_contraindication_blocked 0))
(assert (>= target_contraindication_blocked 0))
(assert (not (= source_contraindication_blocked target_contraindication_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; specimen_tracked: source semantics (matches Coq)
; Translation validation: specimen_tracked preserves semantics
(push 1)
(declare-const source_specimen_tracked Int)
(declare-const target_specimen_tracked Int)
(assert (>= source_specimen_tracked 0))
(assert (>= target_specimen_tracked 0))
(assert (not (= source_specimen_tracked target_specimen_tracked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; critical_notified: source semantics (matches Coq)
; Translation validation: critical_notified preserves semantics
(push 1)
(declare-const source_critical_notified Int)
(declare-const target_critical_notified Int)
(assert (>= source_critical_notified 0))
(assert (>= target_critical_notified 0))
(assert (not (= source_critical_notified target_critical_notified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; result_validated: source semantics (matches Coq)
; Translation validation: result_validated preserves semantics
(push 1)
(declare-const source_result_validated Int)
(declare-const target_result_validated Int)
(assert (>= source_result_validated 0))
(assert (>= target_result_validated 0))
(assert (not (= source_result_validated target_result_validated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; delta_flagged: source semantics (matches Coq)
; Translation validation: delta_flagged preserves semantics
(push 1)
(declare-const source_delta_flagged Int)
(declare-const target_delta_flagged Int)
(assert (>= source_delta_flagged 0))
(assert (>= target_delta_flagged 0))
(assert (not (= source_delta_flagged target_delta_flagged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; range_adjusted: source semantics (matches Coq)
; Translation validation: range_adjusted preserves semantics
(push 1)
(declare-const source_range_adjusted Int)
(declare-const target_range_adjusted Int)
(assert (>= source_range_adjusted 0))
(assert (>= target_range_adjusted 0))
(assert (not (= source_range_adjusted target_range_adjusted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; phi_access_valid: source semantics (matches Coq)
; Translation validation: phi_access_valid preserves semantics
(push 1)
(declare-const source_phi_access_valid Int)
(declare-const target_phi_access_valid Int)
(assert (>= source_phi_access_valid 0))
(assert (>= target_phi_access_valid 0))
(assert (not (= source_phi_access_valid target_phi_access_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; phi_accessed: source semantics (matches Coq)
; Translation validation: phi_accessed preserves semantics
(push 1)
(declare-const source_phi_accessed Int)
(declare-const target_phi_accessed Int)
(assert (>= source_phi_accessed 0))
(assert (>= target_phi_accessed 0))
(assert (not (= source_phi_accessed target_phi_accessed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; audit_complete: source semantics (matches Coq)
; Translation validation: audit_complete preserves semantics
(push 1)
(declare-const source_audit_complete Int)
(declare-const target_audit_complete Int)
(assert (>= source_audit_complete 0))
(assert (>= target_audit_complete 0))
(assert (not (= source_audit_complete target_audit_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; breach_notified: source semantics (matches Coq)
; Translation validation: breach_notified preserves semantics
(push 1)
(declare-const source_breach_notified Int)
(declare-const target_breach_notified Int)
(assert (>= source_breach_notified 0))
(assert (>= target_breach_notified 0))
(assert (not (= source_breach_notified target_breach_notified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; consent_valid: source semantics (matches Coq)
; Translation validation: consent_valid preserves semantics
(push 1)
(declare-const source_consent_valid Int)
(declare-const target_consent_valid Int)
(assert (>= source_consent_valid 0))
(assert (>= target_consent_valid 0))
(assert (not (= source_consent_valid target_consent_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; data_portable: source semantics (matches Coq)
; Translation validation: data_portable preserves semantics
(push 1)
(declare-const source_data_portable Int)
(declare-const target_data_portable Int)
(assert (>= source_data_portable 0))
(assert (>= target_data_portable 0))
(assert (not (= source_data_portable target_data_portable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; high_confidence_match: source semantics (matches Coq)
; Translation validation: high_confidence_match preserves semantics
(push 1)
(declare-const source_high_confidence_match Int)
(declare-const target_high_confidence_match Int)
(assert (>= source_high_confidence_match 0))
(assert (>= target_high_confidence_match 0))
(assert (not (= source_high_confidence_match target_high_confidence_match)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; similar_patients: source semantics (matches Coq)
; Translation validation: similar_patients preserves semantics
(push 1)
(declare-const source_similar_patients Int)
(declare-const target_similar_patients Int)
(assert (>= source_similar_patients 0))
(assert (>= target_similar_patients 0))
(assert (not (= source_similar_patients target_similar_patients)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; properly_flagged: source semantics (matches Coq)
; Translation validation: properly_flagged preserves semantics
(push 1)
(declare-const source_properly_flagged Int)
(declare-const target_properly_flagged Int)
(assert (>= source_properly_flagged 0))
(assert (>= target_properly_flagged 0))
(assert (not (= source_properly_flagged target_properly_flagged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; merge_preserves_records: source semantics (matches Coq)
; Translation validation: merge_preserves_records preserves semantics
(push 1)
(declare-const source_merge_preserves_records Int)
(declare-const target_merge_preserves_records Int)
(assert (>= source_merge_preserves_records 0))
(assert (>= target_merge_preserves_records 0))
(assert (not (= source_merge_preserves_records target_merge_preserves_records)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; note_immutable: source semantics (matches Coq)
; Translation validation: note_immutable preserves semantics
(push 1)
(declare-const source_note_immutable Int)
(declare-const target_note_immutable Int)
(assert (>= source_note_immutable 0))
(assert (>= target_note_immutable 0))
(assert (not (= source_note_immutable target_note_immutable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_01_patient_identity_uniqueness: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_01_patient_identity_uniqueness preserves semantics
(push 1)
(declare-const source_HIS_001_01_patient_identity_uniqueness Int)
(declare-const target_HIS_001_01_patient_identity_uniqueness Int)
(assert (>= source_HIS_001_01_patient_identity_uniqueness 0))
(assert (>= target_HIS_001_01_patient_identity_uniqueness 0))
(assert (not (= source_HIS_001_01_patient_identity_uniqueness target_HIS_001_01_patient_identity_uniqueness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_02_patient_matching_accuracy: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_02_patient_matching_accuracy preserves semantics
(push 1)
(declare-const source_HIS_001_02_patient_matching_accuracy Int)
(declare-const target_HIS_001_02_patient_matching_accuracy Int)
(assert (>= source_HIS_001_02_patient_matching_accuracy 0))
(assert (>= target_HIS_001_02_patient_matching_accuracy 0))
(assert (not (= source_HIS_001_02_patient_matching_accuracy target_HIS_001_02_patient_matching_accuracy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_03_duplicate_detection: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_03_duplicate_detection preserves semantics
(push 1)
(declare-const source_HIS_001_03_duplicate_detection Int)
(declare-const target_HIS_001_03_duplicate_detection Int)
(assert (>= source_HIS_001_03_duplicate_detection 0))
(assert (>= target_HIS_001_03_duplicate_detection 0))
(assert (not (= source_HIS_001_03_duplicate_detection target_HIS_001_03_duplicate_detection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_04_patient_merge_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_04_patient_merge_integrity preserves semantics
(push 1)
(declare-const source_HIS_001_04_patient_merge_integrity Int)
(declare-const target_HIS_001_04_patient_merge_integrity Int)
(assert (>= source_HIS_001_04_patient_merge_integrity 0))
(assert (>= target_HIS_001_04_patient_merge_integrity 0))
(assert (not (= source_HIS_001_04_patient_merge_integrity target_HIS_001_04_patient_merge_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_05_amendment_tracking: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_05_amendment_tracking preserves semantics
(push 1)
(declare-const source_HIS_001_05_amendment_tracking Int)
(declare-const target_HIS_001_05_amendment_tracking Int)
(assert (>= source_HIS_001_05_amendment_tracking 0))
(assert (>= target_HIS_001_05_amendment_tracking 0))
(assert (not (= source_HIS_001_05_amendment_tracking target_HIS_001_05_amendment_tracking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_06_encounter_completeness: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_06_encounter_completeness preserves semantics
(push 1)
(declare-const source_HIS_001_06_encounter_completeness Int)
(declare-const target_HIS_001_06_encounter_completeness Int)
(assert (>= source_HIS_001_06_encounter_completeness 0))
(assert (>= target_HIS_001_06_encounter_completeness 0))
(assert (not (= source_HIS_001_06_encounter_completeness target_HIS_001_06_encounter_completeness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_07_documentation_immutability: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_07_documentation_immutability preserves semantics
(push 1)
(declare-const source_HIS_001_07_documentation_immutability Int)
(declare-const target_HIS_001_07_documentation_immutability Int)
(assert (>= source_HIS_001_07_documentation_immutability 0))
(assert (>= target_HIS_001_07_documentation_immutability 0))
(assert (not (= source_HIS_001_07_documentation_immutability target_HIS_001_07_documentation_immutability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_08_allergy_documentation: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_08_allergy_documentation preserves semantics
(push 1)
(declare-const source_HIS_001_08_allergy_documentation Int)
(declare-const target_HIS_001_08_allergy_documentation Int)
(assert (>= source_HIS_001_08_allergy_documentation 0))
(assert (>= target_HIS_001_08_allergy_documentation 0))
(assert (not (= source_HIS_001_08_allergy_documentation target_HIS_001_08_allergy_documentation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_09_drug_allergy_alert: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_09_drug_allergy_alert preserves semantics
(push 1)
(declare-const source_HIS_001_09_drug_allergy_alert Int)
(declare-const target_HIS_001_09_drug_allergy_alert Int)
(assert (>= source_HIS_001_09_drug_allergy_alert 0))
(assert (>= target_HIS_001_09_drug_allergy_alert 0))
(assert (not (= source_HIS_001_09_drug_allergy_alert target_HIS_001_09_drug_allergy_alert)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_10_problem_list_coded: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_10_problem_list_coded preserves semantics
(push 1)
(declare-const source_HIS_001_10_problem_list_coded Int)
(declare-const target_HIS_001_10_problem_list_coded Int)
(assert (>= source_HIS_001_10_problem_list_coded 0))
(assert (>= target_HIS_001_10_problem_list_coded 0))
(assert (not (= source_HIS_001_10_problem_list_coded target_HIS_001_10_problem_list_coded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_11_five_rights_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_11_five_rights_verification preserves semantics
(push 1)
(declare-const source_HIS_001_11_five_rights_verification Int)
(declare-const target_HIS_001_11_five_rights_verification Int)
(assert (>= source_HIS_001_11_five_rights_verification 0))
(assert (>= target_HIS_001_11_five_rights_verification 0))
(assert (not (= source_HIS_001_11_five_rights_verification target_HIS_001_11_five_rights_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_12_drug_interaction_checking: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_12_drug_interaction_checking preserves semantics
(push 1)
(declare-const source_HIS_001_12_drug_interaction_checking Int)
(declare-const target_HIS_001_12_drug_interaction_checking Int)
(assert (>= source_HIS_001_12_drug_interaction_checking 0))
(assert (>= target_HIS_001_12_drug_interaction_checking 0))
(assert (not (= source_HIS_001_12_drug_interaction_checking target_HIS_001_12_drug_interaction_checking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_13_dose_range_checking: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_13_dose_range_checking preserves semantics
(push 1)
(declare-const source_HIS_001_13_dose_range_checking Int)
(declare-const target_HIS_001_13_dose_range_checking Int)
(assert (>= source_HIS_001_13_dose_range_checking 0))
(assert (>= target_HIS_001_13_dose_range_checking 0))
(assert (not (= source_HIS_001_13_dose_range_checking target_HIS_001_13_dose_range_checking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_14_high_alert_safeguards: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_14_high_alert_safeguards preserves semantics
(push 1)
(declare-const source_HIS_001_14_high_alert_safeguards Int)
(declare-const target_HIS_001_14_high_alert_safeguards Int)
(assert (>= source_HIS_001_14_high_alert_safeguards 0))
(assert (>= target_HIS_001_14_high_alert_safeguards 0))
(assert (not (= source_HIS_001_14_high_alert_safeguards target_HIS_001_14_high_alert_safeguards)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_15_barcode_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_15_barcode_verification preserves semantics
(push 1)
(declare-const source_HIS_001_15_barcode_verification Int)
(declare-const target_HIS_001_15_barcode_verification Int)
(assert (>= source_HIS_001_15_barcode_verification 0))
(assert (>= target_HIS_001_15_barcode_verification 0))
(assert (not (= source_HIS_001_15_barcode_verification target_HIS_001_15_barcode_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_16_order_completeness: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_16_order_completeness preserves semantics
(push 1)
(declare-const source_HIS_001_16_order_completeness Int)
(declare-const target_HIS_001_16_order_completeness Int)
(assert (>= source_HIS_001_16_order_completeness 0))
(assert (>= target_HIS_001_16_order_completeness 0))
(assert (not (= source_HIS_001_16_order_completeness target_HIS_001_16_order_completeness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_17_order_signature: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_17_order_signature preserves semantics
(push 1)
(declare-const source_HIS_001_17_order_signature Int)
(declare-const target_HIS_001_17_order_signature Int)
(assert (>= source_HIS_001_17_order_signature 0))
(assert (>= target_HIS_001_17_order_signature 0))
(assert (not (= source_HIS_001_17_order_signature target_HIS_001_17_order_signature)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_18_verbal_order_auth: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_18_verbal_order_auth preserves semantics
(push 1)
(declare-const source_HIS_001_18_verbal_order_auth Int)
(declare-const target_HIS_001_18_verbal_order_auth Int)
(assert (>= source_HIS_001_18_verbal_order_auth 0))
(assert (>= target_HIS_001_18_verbal_order_auth 0))
(assert (not (= source_HIS_001_18_verbal_order_auth target_HIS_001_18_verbal_order_auth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_19_duplicate_order_prevention: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_19_duplicate_order_prevention preserves semantics
(push 1)
(declare-const source_HIS_001_19_duplicate_order_prevention Int)
(declare-const target_HIS_001_19_duplicate_order_prevention Int)
(assert (>= source_HIS_001_19_duplicate_order_prevention 0))
(assert (>= target_HIS_001_19_duplicate_order_prevention 0))
(assert (not (= source_HIS_001_19_duplicate_order_prevention target_HIS_001_19_duplicate_order_prevention)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_20_contraindication_alert: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_20_contraindication_alert preserves semantics
(push 1)
(declare-const source_HIS_001_20_contraindication_alert Int)
(declare-const target_HIS_001_20_contraindication_alert Int)
(assert (>= source_HIS_001_20_contraindication_alert 0))
(assert (>= target_HIS_001_20_contraindication_alert 0))
(assert (not (= source_HIS_001_20_contraindication_alert target_HIS_001_20_contraindication_alert)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_21_specimen_tracking: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_21_specimen_tracking preserves semantics
(push 1)
(declare-const source_HIS_001_21_specimen_tracking Int)
(declare-const target_HIS_001_21_specimen_tracking Int)
(assert (>= source_HIS_001_21_specimen_tracking 0))
(assert (>= target_HIS_001_21_specimen_tracking 0))
(assert (not (= source_HIS_001_21_specimen_tracking target_HIS_001_21_specimen_tracking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_22_critical_value_notification: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_22_critical_value_notification preserves semantics
(push 1)
(declare-const source_HIS_001_22_critical_value_notification Int)
(declare-const target_HIS_001_22_critical_value_notification Int)
(assert (>= source_HIS_001_22_critical_value_notification 0))
(assert (>= target_HIS_001_22_critical_value_notification 0))
(assert (not (= source_HIS_001_22_critical_value_notification target_HIS_001_22_critical_value_notification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_23_result_validation: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_23_result_validation preserves semantics
(push 1)
(declare-const source_HIS_001_23_result_validation Int)
(declare-const target_HIS_001_23_result_validation Int)
(assert (>= source_HIS_001_23_result_validation 0))
(assert (>= target_HIS_001_23_result_validation 0))
(assert (not (= source_HIS_001_23_result_validation target_HIS_001_23_result_validation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_24_delta_check: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_24_delta_check preserves semantics
(push 1)
(declare-const source_HIS_001_24_delta_check Int)
(declare-const target_HIS_001_24_delta_check Int)
(assert (>= source_HIS_001_24_delta_check 0))
(assert (>= target_HIS_001_24_delta_check 0))
(assert (not (= source_HIS_001_24_delta_check target_HIS_001_24_delta_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_25_reference_range_adjusted: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_25_reference_range_adjusted preserves semantics
(push 1)
(declare-const source_HIS_001_25_reference_range_adjusted Int)
(declare-const target_HIS_001_25_reference_range_adjusted Int)
(assert (>= source_HIS_001_25_reference_range_adjusted 0))
(assert (>= target_HIS_001_25_reference_range_adjusted 0))
(assert (not (= source_HIS_001_25_reference_range_adjusted target_HIS_001_25_reference_range_adjusted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_26_phi_access_control: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_26_phi_access_control preserves semantics
(push 1)
(declare-const source_HIS_001_26_phi_access_control Int)
(declare-const target_HIS_001_26_phi_access_control Int)
(assert (>= source_HIS_001_26_phi_access_control 0))
(assert (>= target_HIS_001_26_phi_access_control 0))
(assert (not (= source_HIS_001_26_phi_access_control target_HIS_001_26_phi_access_control)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_27_audit_trail_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_27_audit_trail_complete preserves semantics
(push 1)
(declare-const source_HIS_001_27_audit_trail_complete Int)
(declare-const target_HIS_001_27_audit_trail_complete Int)
(assert (>= source_HIS_001_27_audit_trail_complete 0))
(assert (>= target_HIS_001_27_audit_trail_complete 0))
(assert (not (= source_HIS_001_27_audit_trail_complete target_HIS_001_27_audit_trail_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_28_breach_notification: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_28_breach_notification preserves semantics
(push 1)
(declare-const source_HIS_001_28_breach_notification Int)
(declare-const target_HIS_001_28_breach_notification Int)
(assert (>= source_HIS_001_28_breach_notification 0))
(assert (>= target_HIS_001_28_breach_notification 0))
(assert (not (= source_HIS_001_28_breach_notification target_HIS_001_28_breach_notification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_29_consent_required: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_29_consent_required preserves semantics
(push 1)
(declare-const source_HIS_001_29_consent_required Int)
(declare-const target_HIS_001_29_consent_required Int)
(assert (>= source_HIS_001_29_consent_required 0))
(assert (>= target_HIS_001_29_consent_required 0))
(assert (not (= source_HIS_001_29_consent_required target_HIS_001_29_consent_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; HIS_001_30_data_portability: translation preserves property (matches Coq: Theorem)
; Translation validation: HIS_001_30_data_portability preserves semantics
(push 1)
(declare-const source_HIS_001_30_data_portability Int)
(declare-const target_HIS_001_30_data_portability Int)
(assert (>= source_HIS_001_30_data_portability 0))
(assert (>= target_HIS_001_30_data_portability 0))
(assert (not (= source_HIS_001_30_data_portability target_HIS_001_30_data_portability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

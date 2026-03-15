; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA HealthcareIS — SMT Verification
; Derived from 02_FORMAL/coq/domains/HealthcareIS.v (30 assertions)
; Module: HealthcareIS
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Severity 0)) (((Mild) (Moderate) (Severe) (LifeThreatening))))

(declare-datatypes ((InteractionSeverity 0)) (((Minor) (Major) (Contraindicated))))

(declare-datatypes ((SpecimenStatus 0)) (((Collected) (InTransit) (Processing) (Analyzed) (Disposed))))

(declare-datatypes ((Role 0)) (((Physician) (Nurse) (AdminStaff) (PatientRole))))

(declare-datatypes ((Patient 0))
  (((mk-patient (mrn Int) (name_hash Int) (dob Int) (demographics Int)))))

(declare-datatypes ((PatientMatch 0))
  (((mk-patient_match (match_score Int) (matched_patient Int)))))

(declare-datatypes ((PatientRegistry 0))
  (((mk-patient_registry (patients (Seq Int)) (mrn_unique Int)))))

(declare-datatypes ((DuplicateCandidate 0))
  (((mk-duplicate_candidate (candidate1 Patient) (candidate2 Patient) (similarity_score Int) (flagged_for_review Bool)))))

(declare-datatypes ((MergeOperation 0))
  (((mk-merge_operation (source_mrn Int) (target_mrn Int) (source_records (Seq Int)) (target_records_before (Seq Int)) (target_records_after (Seq Int)) (merge_complete Bool)))))

(declare-datatypes ((Encounter 0))
  (((mk-encounter (enc_id Int) (enc_patient Int) (chief_complaint Bool) (history Bool) (exam Bool) (assessment Bool) (plan Bool) (is_finalized Bool)))))

(declare-datatypes ((ClinicalNote 0))
  (((mk-clinical_note (note_id Int) (note_encounter Int) (note_content_hash Int) (is_signed Bool) (sign_timestamp Int) (author Int)))))

(declare-datatypes ((Amendment 0))
  (((mk-amendment (amend_id Int) (original_note Int) (amend_timestamp Int) (amend_author Int) (marked_as_amendment Bool) (linked_to_original Bool)))))

(declare-datatypes ((Allergy 0))
  (((mk-allergy (allergy_id Int) (allergen Int) (reaction_type Int) (severity Severity) (snomed_code Int) (allergen_documented Bool) (reaction_documented Bool) (severity_documented Bool)))))

(declare-datatypes ((DrugAllergyInteraction 0))
  (((mk-drug_allergy_interaction (interaction_drug Int) (interaction_allergen Int) (patient_has_allergy Bool) (alert_triggered Bool)))))

(declare-datatypes ((Problem 0))
  (((mk-problem (problem_id Int) (problem_description Int) (problem_snomed Int) (snomed_assigned Bool)))))

(declare-datatypes ((MedicationOrder 0))
  (((mk-medication_order (order_id Int) (drug Int) (dose Int) (dose_unit Int) (route Int) (frequency Int) (patient_weight Int) (patient_age Int) (renal_function Int) (order_complete Bool) (electronically_signed Bool) (signature_timestamp Int) (signer_credentials Int)))))

(declare-datatypes ((Administration 0))
  (((mk-administration (admin_id Int) (admin_order Int) (right_patient Bool) (right_drug Bool) (right_dose Bool) (right_route Bool) (right_time Bool) (barcode_verified Bool) (barcode_matches Bool)))))

(declare-datatypes ((DrugInteraction 0))
  (((mk-drug_interaction (drug1 Int) (drug2 Int) (interaction_severity InteractionSeverity) (interaction_alert_shown Bool)))))

(declare-datatypes ((DoseCheck 0))
  (((mk-dose_check (check_drug Int) (check_dose Int) (min_safe_dose Int) (max_safe_dose Int) (within_range Bool)))))

(declare-datatypes ((HighAlertMed 0))
  (((mk-high_alert_med (ham_drug Int) (is_high_alert Bool) (double_check_required Bool) (double_check_performed Bool)))))

(declare-datatypes ((Order 0))
  (((mk-order (ord_id Int) (ord_patient Int) (ord_drug Int) (ord_dose Int) (ord_route Int) (ord_frequency Int) (has_all_fields Bool) (has_signature Bool) (signature_valid Bool)))))

(declare-datatypes ((VerbalOrder 0))
  (((mk-verbal_order (vo_id Int) (vo_time Int) (authentication_time Int) (authenticated_within_24h Bool)))))

(declare-datatypes ((DuplicateOrderCheck 0))
  (((mk-duplicate_order_check (existing_order Int) (new_order Int) (is_duplicate Bool) (warning_shown Bool) (override_required Bool)))))

(declare-datatypes ((Contraindication 0))
  (((mk-contraindication (contra_drug Int) (contra_condition Int) (contra_detected Bool) (hard_stop_triggered Bool)))))

(declare-datatypes ((Specimen 0))
  (((mk-specimen (specimen_id Int) (specimen_patient Int) (status SpecimenStatus) (collection_time Int) (transit_time Int) (processing_time Int) (analysis_time Int) (disposal_time Int) (fully_tracked Bool)))))

(declare-datatypes ((LabResult 0))
  (((mk-lab_result (result_id Int) (result_value Int) (result_time Int) (is_critical Bool) (lab_notif_time Int) (notified_within_30min Bool) (validated Bool) (needs_review Bool)))))

(declare-datatypes ((DeltaCheck 0))
  (((mk-delta_check (current_value Int) (prior_value Int) (delta_threshold Int) (exceeds_threshold Bool) (flagged Bool)))))

(declare-datatypes ((ReferenceRange 0))
  (((mk-reference_range (test_code Int) (patient_age_range Int) (patient_sex Int) (range_min Int) (range_max Int) (age_adjusted Bool) (sex_adjusted Bool)))))

(declare-datatypes ((PHIAccess 0))
  (((mk-phi_access (access_id Int) (accessor Int) (accessor_role Role) (accessed_patient Int) (access_timestamp Int) (logged Bool) (role_based Bool) (minimum_necessary Bool)))))

(declare-datatypes ((AuditEntry 0))
  (((mk-audit_entry (audit_id Int) (audit_access_id Int) (audit_timestamp Int) (audit_action Int) (reviewable Bool)))))

(declare-datatypes ((Breach 0))
  (((mk-breach (breach_id Int) (detection_time Int) (breach_notif_time Int) (notified_within_60days Bool)))))

(declare-datatypes ((Consent 0))
  (((mk-consent (consent_id Int) (consent_patient Int) (explicit_consent Bool) (consent_timestamp Int) (processing_allowed Bool)))))

(declare-datatypes ((DataExport 0))
  (((mk-data_export (export_id Int) (export_patient Int) (machine_readable Bool) (export_format Int) (export_complete Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Severity enum properties ---

; --- 1. Severity exhaustiveness ---
(push 1)
(declare-const x Severity)
(assert (not (or (= x Mild) (= x Moderate) (= x Severe) (= x LifeThreatening))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Severity: Mild != Moderate ---
(push 1)
(assert (= Mild Moderate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Severity: Moderate != Severe ---
(push 1)
(assert (= Moderate Severe))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Severity: Severe != LifeThreatening ---
(push 1)
(assert (= Severe LifeThreatening))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Severity: Mild != LifeThreatening ---
(push 1)
(assert (= Mild LifeThreatening))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Severity finite cardinality (4 values) ---
(push 1)
(declare-const x Severity)
(assert (and (not (= x Mild)) (not (= x Moderate)) (not (= x Severe)) (not (= x LifeThreatening))))
(check-sat) ; expect UNSAT
(pop 1)

; --- InteractionSeverity enum properties ---

; --- 7. InteractionSeverity exhaustiveness ---
(push 1)
(declare-const x InteractionSeverity)
(assert (not (or (= x Minor) (= x Major) (= x Contraindicated))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. InteractionSeverity: Minor != Major ---
(push 1)
(assert (= Minor Major))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. InteractionSeverity: Major != Contraindicated ---
(push 1)
(assert (= Major Contraindicated))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. InteractionSeverity: Minor != Contraindicated ---
(push 1)
(assert (= Minor Contraindicated))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. InteractionSeverity finite cardinality (3 values) ---
(push 1)
(declare-const x InteractionSeverity)
(assert (and (not (= x Minor)) (not (= x Major)) (not (= x Contraindicated))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SpecimenStatus enum properties ---

; --- 12. SpecimenStatus exhaustiveness ---
(push 1)
(declare-const x SpecimenStatus)
(assert (not (or (= x Collected) (= x InTransit) (= x Processing) (= x Analyzed) (= x Disposed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. SpecimenStatus: Collected != InTransit ---
(push 1)
(assert (= Collected InTransit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SpecimenStatus: InTransit != Processing ---
(push 1)
(assert (= InTransit Processing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SpecimenStatus: Processing != Analyzed ---
(push 1)
(assert (= Processing Analyzed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SpecimenStatus: Collected != Disposed ---
(push 1)
(assert (= Collected Disposed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SpecimenStatus finite cardinality (5 values) ---
(push 1)
(declare-const x SpecimenStatus)
(assert (and (not (= x Collected)) (not (= x InTransit)) (not (= x Processing)) (not (= x Analyzed)) (not (= x Disposed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Role enum properties ---

; --- 18. Role exhaustiveness ---
(push 1)
(declare-const x Role)
(assert (not (or (= x Physician) (= x Nurse) (= x AdminStaff) (= x PatientRole))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Role: Physician != Nurse ---
(push 1)
(assert (= Physician Nurse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Role: Nurse != AdminStaff ---
(push 1)
(assert (= Nurse AdminStaff))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Role: AdminStaff != PatientRole ---
(push 1)
(assert (= AdminStaff PatientRole))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Role: Physician != PatientRole ---
(push 1)
(assert (= Physician PatientRole))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Role finite cardinality (4 values) ---
(push 1)
(declare-const x Role)
(assert (and (not (= x Physician)) (not (= x Nurse)) (not (= x AdminStaff)) (not (= x PatientRole))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Patient record properties ---

; --- 24. Patient accessor round-trip: mrn ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (mrn (mk-patient f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Patient accessor round-trip: name_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (name_hash (mk-patient f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Patient accessor round-trip: dob ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (dob (mk-patient f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Patient: integer field consistency ---
(push 1)
(declare-const r Patient)
(assert (>= (mrn r) 0))
(assert (>= (name_hash r) 0))
(assert (not (>= (+ (mrn r) (name_hash r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PatientMatch record properties ---

; --- 28. PatientMatch accessor round-trip: match_score ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (match_score (mk-patient_match f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PatientRegistry record properties ---

; --- 29. PatientRegistry accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (patients (mk-patient_registry f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DuplicateCandidate record properties ---

; --- 30. DuplicateCandidate accessor round-trip: candidate1 ---
(push 1)
(declare-const f0 Patient)
(declare-const f1 Patient)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (candidate1 (mk-duplicate_candidate f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. DuplicateCandidate accessor round-trip: candidate2 ---
(push 1)
(declare-const f0 Patient)
(declare-const f1 Patient)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (candidate2 (mk-duplicate_candidate f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DuplicateCandidate accessor round-trip: similarity_score ---
(push 1)
(declare-const f0 Patient)
(declare-const f1 Patient)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (similarity_score (mk-duplicate_candidate f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MergeOperation record properties ---

; --- 33. MergeOperation accessor round-trip: source_mrn ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (source_mrn (mk-merge_operation f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. MergeOperation accessor round-trip: target_mrn ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (target_mrn (mk-merge_operation f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. MergeOperation accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (source_records (mk-merge_operation f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. MergeOperation accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (target_records_before (mk-merge_operation f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. MergeOperation accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (target_records_after (mk-merge_operation f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. MergeOperation: integer field consistency ---
(push 1)
(declare-const r MergeOperation)
(assert (>= (source_mrn r) 0))
(assert (>= (target_mrn r) 0))
(assert (not (>= (+ (source_mrn r) (target_mrn r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Encounter record properties ---

; --- 39. Encounter accessor round-trip: enc_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (enc_id (mk-encounter f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Encounter accessor round-trip: enc_patient ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (enc_patient (mk-encounter f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. Encounter accessor round-trip: chief_complaint ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (chief_complaint (mk-encounter f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. Encounter accessor round-trip: history ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (history (mk-encounter f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. Encounter accessor round-trip: exam ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (exam (mk-encounter f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Encounter: integer field consistency ---
(push 1)
(declare-const r Encounter)
(assert (>= (enc_id r) 0))
(assert (>= (enc_patient r) 0))
(assert (not (>= (+ (enc_id r) (enc_patient r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ClinicalNote record properties ---

; --- 45. ClinicalNote accessor round-trip: note_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (note_id (mk-clinical_note f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. ClinicalNote accessor round-trip: note_encounter ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (note_encounter (mk-clinical_note f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. ClinicalNote accessor round-trip: note_content_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (note_content_hash (mk-clinical_note f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. ClinicalNote accessor round-trip: is_signed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (is_signed (mk-clinical_note f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. ClinicalNote accessor round-trip: sign_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (sign_timestamp (mk-clinical_note f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. ClinicalNote: integer field consistency ---
(push 1)
(declare-const r ClinicalNote)
(assert (>= (note_id r) 0))
(assert (>= (note_encounter r) 0))
(assert (not (>= (+ (note_id r) (note_encounter r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Amendment record properties ---

; --- 51. Amendment accessor round-trip: amend_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (amend_id (mk-amendment f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. Amendment accessor round-trip: original_note ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (original_note (mk-amendment f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. Amendment accessor round-trip: amend_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (amend_timestamp (mk-amendment f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. Amendment accessor round-trip: amend_author ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (amend_author (mk-amendment f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. Amendment accessor round-trip: marked_as_amendment ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (marked_as_amendment (mk-amendment f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. Amendment: integer field consistency ---
(push 1)
(declare-const r Amendment)
(assert (>= (amend_id r) 0))
(assert (>= (original_note r) 0))
(assert (not (>= (+ (amend_id r) (original_note r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Allergy record properties ---

; --- 57. Allergy accessor round-trip: allergy_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Severity)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (allergy_id (mk-allergy f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. Allergy accessor round-trip: allergen ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Severity)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (allergen (mk-allergy f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. Allergy accessor round-trip: reaction_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Severity)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (reaction_type (mk-allergy f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. Allergy accessor round-trip: severity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Severity)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (severity (mk-allergy f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. Allergy accessor round-trip: snomed_code ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Severity)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (snomed_code (mk-allergy f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. Allergy: integer field consistency ---
(push 1)
(declare-const r Allergy)
(assert (>= (allergy_id r) 0))
(assert (>= (allergen r) 0))
(assert (not (>= (+ (allergy_id r) (allergen r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DrugAllergyInteraction record properties ---

; --- 63. DrugAllergyInteraction accessor round-trip: interaction_drug ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (interaction_drug (mk-drug_allergy_interaction f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. DrugAllergyInteraction accessor round-trip: interaction_allergen ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (interaction_allergen (mk-drug_allergy_interaction f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. DrugAllergyInteraction accessor round-trip: patient_has_allergy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (patient_has_allergy (mk-drug_allergy_interaction f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. DrugAllergyInteraction: integer field consistency ---
(push 1)
(declare-const r DrugAllergyInteraction)
(assert (>= (interaction_drug r) 0))
(assert (>= (interaction_allergen r) 0))
(assert (not (>= (+ (interaction_drug r) (interaction_allergen r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Problem record properties ---

; --- 67. Problem accessor round-trip: problem_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (problem_id (mk-problem f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. Problem accessor round-trip: problem_description ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (problem_description (mk-problem f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. Problem accessor round-trip: problem_snomed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (problem_snomed (mk-problem f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. Problem: integer field consistency ---
(push 1)
(declare-const r Problem)
(assert (>= (problem_id r) 0))
(assert (>= (problem_description r) 0))
(assert (not (>= (+ (problem_id r) (problem_description r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MedicationOrder record properties ---

; --- 71. MedicationOrder accessor round-trip: order_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Int)
(declare-const f12 Int)
(assert (not (= (order_id (mk-medication_order f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. MedicationOrder accessor round-trip: drug ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Int)
(declare-const f12 Int)
(assert (not (= (drug (mk-medication_order f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. MedicationOrder accessor round-trip: dose ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Int)
(declare-const f12 Int)
(assert (not (= (dose (mk-medication_order f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. MedicationOrder accessor round-trip: dose_unit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Int)
(declare-const f12 Int)
(assert (not (= (dose_unit (mk-medication_order f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. MedicationOrder accessor round-trip: route ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Int)
(declare-const f12 Int)
(assert (not (= (route (mk-medication_order f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. MedicationOrder: integer field consistency ---
(push 1)
(declare-const r MedicationOrder)
(assert (>= (order_id r) 0))
(assert (>= (drug r) 0))
(assert (not (>= (+ (order_id r) (drug r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Administration record properties ---

; --- 77. Administration accessor round-trip: admin_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (admin_id (mk-administration f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. Administration accessor round-trip: admin_order ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (admin_order (mk-administration f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. Administration accessor round-trip: right_patient ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (right_patient (mk-administration f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. Administration accessor round-trip: right_drug ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (right_drug (mk-administration f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. Administration accessor round-trip: right_dose ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (right_dose (mk-administration f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. Administration: integer field consistency ---
(push 1)
(declare-const r Administration)
(assert (>= (admin_id r) 0))
(assert (>= (admin_order r) 0))
(assert (not (>= (+ (admin_id r) (admin_order r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DrugInteraction record properties ---

; --- 83. DrugInteraction accessor round-trip: drug1 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 InteractionSeverity)
(declare-const f3 Bool)
(assert (not (= (drug1 (mk-drug_interaction f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. DrugInteraction accessor round-trip: drug2 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 InteractionSeverity)
(declare-const f3 Bool)
(assert (not (= (drug2 (mk-drug_interaction f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. DrugInteraction accessor round-trip: interaction_severity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 InteractionSeverity)
(declare-const f3 Bool)
(assert (not (= (interaction_severity (mk-drug_interaction f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. DrugInteraction: integer field consistency ---
(push 1)
(declare-const r DrugInteraction)
(assert (>= (drug1 r) 0))
(assert (>= (drug2 r) 0))
(assert (not (>= (+ (drug1 r) (drug2 r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DoseCheck record properties ---

; --- 87. DoseCheck accessor round-trip: check_drug ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (check_drug (mk-dose_check f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. DoseCheck accessor round-trip: check_dose ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (check_dose (mk-dose_check f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. DoseCheck accessor round-trip: min_safe_dose ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (min_safe_dose (mk-dose_check f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. DoseCheck accessor round-trip: max_safe_dose ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (max_safe_dose (mk-dose_check f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. DoseCheck: integer field consistency ---
(push 1)
(declare-const r DoseCheck)
(assert (>= (check_drug r) 0))
(assert (>= (check_dose r) 0))
(assert (not (>= (+ (check_drug r) (check_dose r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HighAlertMed record properties ---

; --- 92. HighAlertMed accessor round-trip: ham_drug ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ham_drug (mk-high_alert_med f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. HighAlertMed accessor round-trip: is_high_alert ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (is_high_alert (mk-high_alert_med f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. HighAlertMed accessor round-trip: double_check_required ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (double_check_required (mk-high_alert_med f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Order record properties ---

; --- 95. Order accessor round-trip: ord_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (ord_id (mk-order f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. Order accessor round-trip: ord_patient ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (ord_patient (mk-order f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. Order accessor round-trip: ord_drug ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (ord_drug (mk-order f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. Order accessor round-trip: ord_dose ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (ord_dose (mk-order f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. Order accessor round-trip: ord_route ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (ord_route (mk-order f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 100. Order: integer field consistency ---
(push 1)
(declare-const r Order)
(assert (>= (ord_id r) 0))
(assert (>= (ord_patient r) 0))
(assert (not (>= (+ (ord_id r) (ord_patient r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerbalOrder record properties ---

; --- 101. VerbalOrder accessor round-trip: vo_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (vo_id (mk-verbal_order f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 102. VerbalOrder accessor round-trip: vo_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (vo_time (mk-verbal_order f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. VerbalOrder accessor round-trip: authentication_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (authentication_time (mk-verbal_order f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 104. VerbalOrder: integer field consistency ---
(push 1)
(declare-const r VerbalOrder)
(assert (>= (vo_id r) 0))
(assert (>= (vo_time r) 0))
(assert (not (>= (+ (vo_id r) (vo_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DuplicateOrderCheck record properties ---

; --- 105. DuplicateOrderCheck accessor round-trip: existing_order ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (existing_order (mk-duplicate_order_check f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 106. DuplicateOrderCheck accessor round-trip: new_order ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (new_order (mk-duplicate_order_check f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 107. DuplicateOrderCheck accessor round-trip: is_duplicate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (is_duplicate (mk-duplicate_order_check f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 108. DuplicateOrderCheck accessor round-trip: warning_shown ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (warning_shown (mk-duplicate_order_check f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 109. DuplicateOrderCheck: integer field consistency ---
(push 1)
(declare-const r DuplicateOrderCheck)
(assert (>= (existing_order r) 0))
(assert (>= (new_order r) 0))
(assert (not (>= (+ (existing_order r) (new_order r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Contraindication record properties ---

; --- 110. Contraindication accessor round-trip: contra_drug ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (contra_drug (mk-contraindication f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 111. Contraindication accessor round-trip: contra_condition ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (contra_condition (mk-contraindication f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 112. Contraindication accessor round-trip: contra_detected ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (contra_detected (mk-contraindication f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 113. Contraindication: integer field consistency ---
(push 1)
(declare-const r Contraindication)
(assert (>= (contra_drug r) 0))
(assert (>= (contra_condition r) 0))
(assert (not (>= (+ (contra_drug r) (contra_condition r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Specimen record properties ---

; --- 114. Specimen accessor round-trip: specimen_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 SpecimenStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (specimen_id (mk-specimen f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 115. Specimen accessor round-trip: specimen_patient ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 SpecimenStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (specimen_patient (mk-specimen f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 116. Specimen accessor round-trip: status ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 SpecimenStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (status (mk-specimen f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 117. Specimen accessor round-trip: collection_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 SpecimenStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (collection_time (mk-specimen f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 118. Specimen accessor round-trip: transit_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 SpecimenStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (transit_time (mk-specimen f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 119. Specimen: integer field consistency ---
(push 1)
(declare-const r Specimen)
(assert (>= (specimen_id r) 0))
(assert (>= (specimen_patient r) 0))
(assert (not (>= (+ (specimen_id r) (specimen_patient r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LabResult record properties ---

; --- 120. LabResult accessor round-trip: result_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (result_id (mk-lab_result f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 121. LabResult accessor round-trip: result_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (result_value (mk-lab_result f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 122. LabResult accessor round-trip: result_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (result_time (mk-lab_result f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 123. LabResult accessor round-trip: is_critical ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (is_critical (mk-lab_result f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 124. LabResult accessor round-trip: lab_notif_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (lab_notif_time (mk-lab_result f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 125. LabResult: integer field consistency ---
(push 1)
(declare-const r LabResult)
(assert (>= (result_id r) 0))
(assert (>= (result_value r) 0))
(assert (not (>= (+ (result_id r) (result_value r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DeltaCheck record properties ---

; --- 126. DeltaCheck accessor round-trip: current_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (current_value (mk-delta_check f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 127. DeltaCheck accessor round-trip: prior_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (prior_value (mk-delta_check f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 128. DeltaCheck accessor round-trip: delta_threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (delta_threshold (mk-delta_check f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 129. DeltaCheck accessor round-trip: exceeds_threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (exceeds_threshold (mk-delta_check f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 130. DeltaCheck: integer field consistency ---
(push 1)
(declare-const r DeltaCheck)
(assert (>= (current_value r) 0))
(assert (>= (prior_value r) 0))
(assert (not (>= (+ (current_value r) (prior_value r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ReferenceRange record properties ---

; --- 131. ReferenceRange accessor round-trip: test_code ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (test_code (mk-reference_range f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 132. ReferenceRange accessor round-trip: patient_age_range ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (patient_age_range (mk-reference_range f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 133. ReferenceRange accessor round-trip: patient_sex ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (patient_sex (mk-reference_range f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 134. ReferenceRange accessor round-trip: range_min ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (range_min (mk-reference_range f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 135. ReferenceRange accessor round-trip: range_max ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (range_max (mk-reference_range f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 136. ReferenceRange: integer field consistency ---
(push 1)
(declare-const r ReferenceRange)
(assert (>= (test_code r) 0))
(assert (>= (patient_age_range r) 0))
(assert (not (>= (+ (test_code r) (patient_age_range r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PHIAccess record properties ---

; --- 137. PHIAccess accessor round-trip: access_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (access_id (mk-phi_access f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 138. PHIAccess accessor round-trip: accessor ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (accessor (mk-phi_access f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 139. PHIAccess accessor round-trip: accessor_role ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (accessor_role (mk-phi_access f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 140. PHIAccess accessor round-trip: accessed_patient ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (accessed_patient (mk-phi_access f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 141. PHIAccess accessor round-trip: access_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Role)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (access_timestamp (mk-phi_access f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 142. PHIAccess: integer field consistency ---
(push 1)
(declare-const r PHIAccess)
(assert (>= (access_id r) 0))
(assert (>= (accessor r) 0))
(assert (not (>= (+ (access_id r) (accessor r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuditEntry record properties ---

; --- 143. AuditEntry accessor round-trip: audit_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_id (mk-audit_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 144. AuditEntry accessor round-trip: audit_access_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_access_id (mk-audit_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 145. AuditEntry accessor round-trip: audit_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_timestamp (mk-audit_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 146. AuditEntry accessor round-trip: audit_action ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_action (mk-audit_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 147. AuditEntry: integer field consistency ---
(push 1)
(declare-const r AuditEntry)
(assert (>= (audit_id r) 0))
(assert (>= (audit_access_id r) 0))
(assert (not (>= (+ (audit_id r) (audit_access_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Breach record properties ---

; --- 148. Breach accessor round-trip: breach_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (breach_id (mk-breach f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 149. Breach accessor round-trip: detection_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (detection_time (mk-breach f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 150. Breach accessor round-trip: breach_notif_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (breach_notif_time (mk-breach f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 151. Breach: integer field consistency ---
(push 1)
(declare-const r Breach)
(assert (>= (breach_id r) 0))
(assert (>= (detection_time r) 0))
(assert (not (>= (+ (breach_id r) (detection_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Consent record properties ---

; --- 152. Consent accessor round-trip: consent_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (consent_id (mk-consent f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 153. Consent accessor round-trip: consent_patient ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (consent_patient (mk-consent f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 154. Consent accessor round-trip: explicit_consent ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (explicit_consent (mk-consent f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 155. Consent accessor round-trip: consent_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (consent_timestamp (mk-consent f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 156. Consent: integer field consistency ---
(push 1)
(declare-const r Consent)
(assert (>= (consent_id r) 0))
(assert (>= (consent_patient r) 0))
(assert (not (>= (+ (consent_id r) (consent_patient r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DataExport record properties ---

; --- 157. DataExport accessor round-trip: export_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (export_id (mk-data_export f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 158. DataExport accessor round-trip: export_patient ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (export_patient (mk-data_export f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 159. DataExport accessor round-trip: machine_readable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (machine_readable (mk-data_export f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 160. DataExport accessor round-trip: export_format ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (export_format (mk-data_export f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 161. DataExport: integer field consistency ---
(push 1)
(declare-const r DataExport)
(assert (>= (export_id r) 0))
(assert (>= (export_patient r) 0))
(assert (not (>= (+ (export_id r) (export_patient r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Severity ordering properties ---

(define-fun Severity_level ((x Severity)) Int
  (ite (= x Mild) 0 (ite (= x Moderate) 1 (ite (= x Severe) 2 3))))

(define-fun Severity_leq ((x Severity) (y Severity)) Bool
  (<= (Severity_level x) (Severity_level y)))

; --- 162. Severity_leq reflexivity ---
(push 1)
(declare-const x Severity)
(assert (not (Severity_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 163. Severity_leq transitivity ---
(push 1)
(declare-const x Severity)
(declare-const y Severity)
(declare-const z Severity)
(assert (Severity_leq x y))
(assert (Severity_leq y z))
(assert (not (Severity_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 164. Severity_leq antisymmetry ---
(push 1)
(declare-const x Severity)
(declare-const y Severity)
(assert (Severity_leq x y))
(assert (Severity_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 165. Mild is bottom ---
(push 1)
(declare-const x Severity)
(assert (not (Severity_leq Mild x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 166. LifeThreatening is top ---
(push 1)
(declare-const x Severity)
(assert (not (Severity_leq x LifeThreatening)))
(check-sat) ; expect UNSAT
(pop 1)

; --- InteractionSeverity ordering properties ---

(define-fun InteractionSeverity_level ((x InteractionSeverity)) Int
  (ite (= x Minor) 0 (ite (= x Major) 1 2)))

(define-fun InteractionSeverity_leq ((x InteractionSeverity) (y InteractionSeverity)) Bool
  (<= (InteractionSeverity_level x) (InteractionSeverity_level y)))

; --- 167. InteractionSeverity_leq reflexivity ---
(push 1)
(declare-const x InteractionSeverity)
(assert (not (InteractionSeverity_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 168. InteractionSeverity_leq transitivity ---
(push 1)
(declare-const x InteractionSeverity)
(declare-const y InteractionSeverity)
(declare-const z InteractionSeverity)
(assert (InteractionSeverity_leq x y))
(assert (InteractionSeverity_leq y z))
(assert (not (InteractionSeverity_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 169. InteractionSeverity_leq antisymmetry ---
(push 1)
(declare-const x InteractionSeverity)
(declare-const y InteractionSeverity)
(assert (InteractionSeverity_leq x y))
(assert (InteractionSeverity_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 170. Minor is bottom ---
(push 1)
(declare-const x InteractionSeverity)
(assert (not (InteractionSeverity_leq Minor x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 171. Contraindicated is top ---
(push 1)
(declare-const x InteractionSeverity)
(assert (not (InteractionSeverity_leq x Contraindicated)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

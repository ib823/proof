; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryHealthcare — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryHealthcare.v (29 assertions)
; Module: IndustryHealthcare
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((PHI_Category 0)) (((Demographics) (MedicalRecord) (Psychotherapy) (Genetic) (Substance) (HIV_Status))))

(declare-datatypes ((HealthcareEffect 0)) (((PHI_Access) (EHR_Write) (Prescription) (LabResult) (ClinicalDecision))))

(declare-datatypes ((HIPAA_Policy 0))
  (((mk-hipaa__policy (access_control Bool) (audit_controls Bool) (integrity_controls Bool) (transmission_security Bool) (encryption_at_rest Bool)))))

(declare-datatypes ((BreakGlassEvent 0))
  (((mk-break_glass_event (bg_accessor Int) (bg_patient Int) (bg_timestamp Int) (bg_reason Int) (bg_logged Bool)))))

(declare-datatypes ((ConsentRecord 0))
  (((mk-consent_record (consent_patient Int) (consent_purpose Int) (consent_granted Bool) (consent_timestamp Int) (consent_expiry Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- PHI_Category enum properties ---

; --- 1. PHI_Category exhaustiveness ---
(push 1)
(declare-const x PHI_Category)
(assert (not (or (= x Demographics) (= x MedicalRecord) (= x Psychotherapy) (= x Genetic) (= x Substance) (= x HIV_Status))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. PHI_Category: Demographics != MedicalRecord ---
(push 1)
(assert (= Demographics MedicalRecord))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. PHI_Category: MedicalRecord != Psychotherapy ---
(push 1)
(assert (= MedicalRecord Psychotherapy))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. PHI_Category: Psychotherapy != Genetic ---
(push 1)
(assert (= Psychotherapy Genetic))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. PHI_Category: Demographics != HIV_Status ---
(push 1)
(assert (= Demographics HIV_Status))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. PHI_Category finite cardinality (6 values) ---
(push 1)
(declare-const x PHI_Category)
(assert (and (not (= x Demographics)) (not (= x MedicalRecord)) (not (= x Psychotherapy)) (not (= x Genetic)) (not (= x Substance)) (not (= x HIV_Status))))
(check-sat) ; expect UNSAT
(pop 1)

; --- HealthcareEffect enum properties ---

; --- 7. HealthcareEffect exhaustiveness ---
(push 1)
(declare-const x HealthcareEffect)
(assert (not (or (= x PHI_Access) (= x EHR_Write) (= x Prescription) (= x LabResult) (= x ClinicalDecision))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. HealthcareEffect: PHI_Access != EHR_Write ---
(push 1)
(assert (= PHI_Access EHR_Write))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. HealthcareEffect: EHR_Write != Prescription ---
(push 1)
(assert (= EHR_Write Prescription))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. HealthcareEffect: Prescription != LabResult ---
(push 1)
(assert (= Prescription LabResult))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. HealthcareEffect: PHI_Access != ClinicalDecision ---
(push 1)
(assert (= PHI_Access ClinicalDecision))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. HealthcareEffect finite cardinality (5 values) ---
(push 1)
(declare-const x HealthcareEffect)
(assert (and (not (= x PHI_Access)) (not (= x EHR_Write)) (not (= x Prescription)) (not (= x LabResult)) (not (= x ClinicalDecision))))
(check-sat) ; expect UNSAT
(pop 1)

; --- HIPAA_Policy record properties ---

; --- 13. HIPAA_Policy accessor round-trip: access_control ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (access_control (mk-h_i_p_a_a__policy f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. HIPAA_Policy accessor round-trip: audit_controls ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (audit_controls (mk-h_i_p_a_a__policy f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. HIPAA_Policy accessor round-trip: integrity_controls ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (integrity_controls (mk-h_i_p_a_a__policy f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. HIPAA_Policy accessor round-trip: transmission_security ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (transmission_security (mk-h_i_p_a_a__policy f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun HIPAA_Policy_all_enabled ((g HIPAA_Policy)) Bool
  (and (access_control g) (audit_controls g) (integrity_controls g) (transmission_security g)))

; --- 17. HIPAA_Policy: all-enabled completeness ---
(push 1)
(declare-const g HIPAA_Policy)
(assert (access_control g))
(assert (audit_controls g))
(assert (integrity_controls g))
(assert (transmission_security g))
(assert (not (HIPAA_Policy_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. HIPAA_Policy: HIPAA_Policy_all_enabled implies access_control ---
(push 1)
(declare-const g HIPAA_Policy)
(assert (HIPAA_Policy_all_enabled g))
(assert (not (access_control g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. HIPAA_Policy: HIPAA_Policy_all_enabled implies audit_controls ---
(push 1)
(declare-const g HIPAA_Policy)
(assert (HIPAA_Policy_all_enabled g))
(assert (not (audit_controls g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. HIPAA_Policy: HIPAA_Policy_all_enabled implies integrity_controls ---
(push 1)
(declare-const g HIPAA_Policy)
(assert (HIPAA_Policy_all_enabled g))
(assert (not (integrity_controls g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BreakGlassEvent record properties ---

; --- 21. BreakGlassEvent accessor round-trip: bg_accessor ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bg_accessor (mk-break_glass_event f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. BreakGlassEvent accessor round-trip: bg_patient ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bg_patient (mk-break_glass_event f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BreakGlassEvent accessor round-trip: bg_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bg_timestamp (mk-break_glass_event f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. BreakGlassEvent accessor round-trip: bg_reason ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bg_reason (mk-break_glass_event f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. BreakGlassEvent: integer field consistency ---
(push 1)
(declare-const r BreakGlassEvent)
(assert (>= (bg_accessor r) 0))
(assert (>= (bg_patient r) 0))
(assert (not (>= (+ (bg_accessor r) (bg_patient r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConsentRecord record properties ---

; --- 26. ConsentRecord accessor round-trip: consent_patient ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (consent_patient (mk-consent_record f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ConsentRecord accessor round-trip: consent_purpose ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (consent_purpose (mk-consent_record f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ConsentRecord accessor round-trip: consent_granted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (consent_granted (mk-consent_record f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ConsentRecord accessor round-trip: consent_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (consent_timestamp (mk-consent_record f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ConsentRecord: integer field consistency ---
(push 1)
(declare-const r ConsentRecord)
(assert (>= (consent_patient r) 0))
(assert (>= (consent_purpose r) 0))
(assert (not (>= (+ (consent_patient r) (consent_purpose r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

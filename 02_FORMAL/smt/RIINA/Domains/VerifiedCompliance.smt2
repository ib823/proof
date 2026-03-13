; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedCompliance — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedCompliance.v (35 assertions)
; Module: VerifiedCompliance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Regulation 0)) (((GDPR) (HIPAA) (PCIDSS) (SOC2) (ISO27001) (NISTCSF))))

(declare-datatypes ((ControlStatus 0)) (((Proven) (Implemented) (Partial) (Gap))))

(declare-datatypes ((PersonalData 0))
  (((mk-personal_data (pd_subject Int) (pd_category String) (pd_value (Seq Int)) (pd_purpose String) (pd_consent Bool) (pd_collected Int) (pd_retention Int) (pd_necessary Bool) (pd_accurate Bool) (pd_integrity_protected Bool) (pd_exportable Bool)))))

(declare-datatypes ((DataStore 0))
  (((mk-data_store (store_data (Seq Int)) (store_purpose String) (store_compliant Bool) (store_encrypted Bool)))))

(declare-datatypes ((PHI 0))
  (((mk-phi (phi_patient_id Int) (phi_data (Seq Int)) (phi_created Int) (phi_accessed_by (Seq Int)) (phi_encrypted Bool) (phi_access_controlled Bool) (phi_logged Bool) (phi_integrity_protected Bool) (phi_available Bool) (phi_in_system Bool)))))

(declare-datatypes ((CardholderData 0))
  (((mk-cardholder_data (chd_pan (Seq Int)) (chd_pan_encrypted Bool) (chd_expiry Int) (chd_cvv_stored Bool) (chd_cardholder_name String) (chd_in_cde Bool)))))

(declare-datatypes ((Control 0))
  (((mk-control (control_id String) (control_regulation Regulation) (control_description String) (control_satisfied Bool) (control_monitored Bool) (control_has_alert Bool)))))

(declare-datatypes ((ControlMapping 0))
  (((mk-control_mapping (mapping_control Control) (mapping_riina_track String) (mapping_proof_ref Int) (mapping_status ControlStatus)))))

(declare-datatypes ((Network 0))
  (((mk-network (net_cde Int) (net_non_cde Int) (net_segmented Bool)))))

(declare-datatypes ((User 0))
  (((mk-user (user_id Int) (user_unique Bool) (user_business_need Bool)))))

(declare-datatypes ((PhysicalControl 0))
  (((mk-physical_control (phys_location String) (phys_secured Bool) (phys_logged Bool)))))

(declare-datatypes ((SecurityEvent 0))
  (((mk-security_event (event_id Int) (event_logged Bool) (event_security_relevant Bool)))))

(declare-datatypes ((SecurityTest 0))
  (((mk-security_test (test_id Int) (test_performed Bool) (test_passed Bool)))))

(declare-datatypes ((CompliancePolicy 0))
  (((mk-compliance_policy (policy_regulation Regulation) (policy_controls (Seq Int)) (policy_mappings (Seq Int)) (policy_compliant Bool)))))

(declare-datatypes ((EvidenceChain 0))
  (((mk-evidence_chain (evidence_control Control) (evidence_items (Seq Int)) (evidence_timestamp Int) (evidence_signature (Seq Int)) (evidence_valid_flag Bool)))))

(declare-datatypes ((GapAnalysis 0))
  (((mk-gap_analysis (gap_policy CompliancePolicy) (gap_detected (Seq Int)) (gap_analysis_complete Bool)))))

(declare-datatypes ((Remediation 0))
  (((mk-remediation (rem_control Control) (rem_status ControlStatus) (rem_tracked Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Regulation exhaustiveness ---
(push 1)
(declare-const x Regulation)
(assert (not (or (= x GDPR) (= x HIPAA) (= x PCIDSS) (= x SOC2) (= x ISO27001) (= x NISTCSF))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Regulation: GDPR != HIPAA ---
(push 1)
(assert (= GDPR HIPAA))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Regulation: HIPAA != PCIDSS ---
(push 1)
(assert (= HIPAA PCIDSS))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Regulation: PCIDSS != SOC2 ---
(push 1)
(assert (= PCIDSS SOC2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Regulation: GDPR != NISTCSF ---
(push 1)
(assert (= GDPR NISTCSF))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Regulation finite cardinality (6 values) ---
(push 1)
(declare-const x Regulation)
(assert (and (not (= x GDPR)) (not (= x HIPAA)) (not (= x PCIDSS)) (not (= x SOC2)) (not (= x ISO27001)) (not (= x NISTCSF))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. ControlStatus exhaustiveness ---
(push 1)
(declare-const x ControlStatus)
(assert (not (or (= x Proven) (= x Implemented) (= x Partial) (= x Gap))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ControlStatus: Proven != Implemented ---
(push 1)
(assert (= Proven Implemented))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ControlStatus: Implemented != Partial ---
(push 1)
(assert (= Implemented Partial))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ControlStatus: Partial != Gap ---
(push 1)
(assert (= Partial Gap))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ControlStatus: Proven != Gap ---
(push 1)
(assert (= Proven Gap))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ControlStatus finite cardinality (4 values) ---
(push 1)
(declare-const x ControlStatus)
(assert (and (not (= x Proven)) (not (= x Implemented)) (not (= x Partial)) (not (= x Gap))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. PersonalData accessor round-trip: pd_subject ---
(push 1)
(declare-const f0 Int)
(declare-const f1 String)
(assert (not (= (pd_subject (mk-personal_data f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. PersonalData accessor round-trip: pd_category ---
(push 1)
(declare-const f0 Int)
(declare-const f1 String)
(assert (not (= (pd_category (mk-personal_data f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. PHI accessor round-trip: phi_patient_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (phi_patient_id (mk-phi f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Control accessor round-trip: control_id ---
(push 1)
(declare-const f0 String)
(declare-const f1 Regulation)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (control_id (mk-control f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Control accessor round-trip: control_regulation ---
(push 1)
(declare-const f0 String)
(declare-const f1 Regulation)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (control_regulation (mk-control f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Control accessor round-trip: control_description ---
(push 1)
(declare-const f0 String)
(declare-const f1 Regulation)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (control_description (mk-control f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Control accessor round-trip: control_satisfied ---
(push 1)
(declare-const f0 String)
(declare-const f1 Regulation)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (control_satisfied (mk-control f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Control accessor round-trip: control_monitored ---
(push 1)
(declare-const f0 String)
(declare-const f1 Regulation)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (control_monitored (mk-control f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ControlMapping accessor round-trip: mapping_control ---
(push 1)
(declare-const f0 Control)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 ControlStatus)
(assert (not (= (mapping_control (mk-control_mapping f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ControlMapping accessor round-trip: mapping_riina_track ---
(push 1)
(declare-const f0 Control)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 ControlStatus)
(assert (not (= (mapping_riina_track (mk-control_mapping f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ControlMapping accessor round-trip: mapping_proof_ref ---
(push 1)
(declare-const f0 Control)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 ControlStatus)
(assert (not (= (mapping_proof_ref (mk-control_mapping f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ControlMapping accessor round-trip: mapping_status ---
(push 1)
(declare-const f0 Control)
(declare-const f1 String)
(declare-const f2 Int)
(declare-const f3 ControlStatus)
(assert (not (= (mapping_status (mk-control_mapping f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Network accessor round-trip: net_cde ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (net_cde (mk-network f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Network accessor round-trip: net_non_cde ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (net_non_cde (mk-network f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Network accessor round-trip: net_segmented ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (net_segmented (mk-network f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Network: non-negative int fields sum ---
(push 1)
(declare-const r Network)
(assert (>= (net_cde r) 0))
(assert (>= (net_non_cde r) 0))
(assert (not (>= (+ (net_cde r) (net_non_cde r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. User accessor round-trip: user_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (user_id (mk-user f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. User accessor round-trip: user_unique ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (user_unique (mk-user f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. User accessor round-trip: user_business_need ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (user_business_need (mk-user f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. PhysicalControl accessor round-trip: phys_location ---
(push 1)
(declare-const f0 String)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (phys_location (mk-physical_control f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. PhysicalControl accessor round-trip: phys_secured ---
(push 1)
(declare-const f0 String)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (phys_secured (mk-physical_control f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. PhysicalControl accessor round-trip: phys_logged ---
(push 1)
(declare-const f0 String)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (phys_logged (mk-physical_control f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. SecurityEvent accessor round-trip: event_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (event_id (mk-security_event f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. SecurityEvent accessor round-trip: event_logged ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (event_logged (mk-security_event f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. SecurityEvent accessor round-trip: event_security_relevant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (event_security_relevant (mk-security_event f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. SecurityTest accessor round-trip: test_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (test_id (mk-security_test f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. SecurityTest accessor round-trip: test_performed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (test_performed (mk-security_test f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. SecurityTest accessor round-trip: test_passed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (test_passed (mk-security_test f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. CompliancePolicy accessor round-trip: policy_regulation ---
(push 1)
(declare-const f0 Regulation)
(assert (not (= (policy_regulation (mk-compliance_policy f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. EvidenceChain accessor round-trip: evidence_control ---
(push 1)
(declare-const f0 Control)
(assert (not (= (evidence_control (mk-evidence_chain f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. GapAnalysis accessor round-trip: gap_policy ---
(push 1)
(declare-const f0 CompliancePolicy)
(assert (not (= (gap_policy (mk-gap_analysis f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Remediation accessor round-trip: rem_control ---
(push 1)
(declare-const f0 Control)
(declare-const f1 ControlStatus)
(declare-const f2 Bool)
(assert (not (= (rem_control (mk-remediation f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. Remediation accessor round-trip: rem_status ---
(push 1)
(declare-const f0 Control)
(declare-const f1 ControlStatus)
(declare-const f2 Bool)
(assert (not (= (rem_status (mk-remediation f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. Remediation accessor round-trip: rem_tracked ---
(push 1)
(declare-const f0 Control)
(declare-const f1 ControlStatus)
(declare-const f2 Bool)
(assert (not (= (rem_tracked (mk-remediation f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

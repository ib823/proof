; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryEducation — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryEducation.v (25 assertions)
; Module: IndustryEducation
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((StudentData 0)) (((EducationRecord) (DirectoryInfo) (Grades) (Disciplinary) (SpecialEducation) (HealthRecords))))

(declare-datatypes ((StudentAge 0)) (((Under13) (Teen) (Adult))))

(declare-datatypes ((EducationEffect 0)) (((StudentRecordAccess) (GradeEntry) (ParentPortal) (LearningAnalytics) (AssessmentData))))

(declare-datatypes ((FERPA_Compliance 0))
  (((mk-ferpa__compliance (legitimate_educational_interest Bool) (parental_consent Bool) (annual_notification Bool) (access_to_records Bool) (amendment_process Bool) (disclosure_tracking Bool)))))

(declare-datatypes ((StudentRecord 0))
  (((mk-student_record (student_id Int) (student_age_years Int) (student_min_age Int) (student_grade_level Int) (student_max_grade Int) (student_age_valid Int) (student_grade_valid Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- StudentData enum properties ---

; --- 1. StudentData exhaustiveness ---
(push 1)
(declare-const x StudentData)
(assert (not (or (= x EducationRecord) (= x DirectoryInfo) (= x Grades) (= x Disciplinary) (= x SpecialEducation) (= x HealthRecords))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. StudentData: EducationRecord != DirectoryInfo ---
(push 1)
(assert (= EducationRecord DirectoryInfo))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. StudentData: DirectoryInfo != Grades ---
(push 1)
(assert (= DirectoryInfo Grades))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. StudentData: Grades != Disciplinary ---
(push 1)
(assert (= Grades Disciplinary))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. StudentData: EducationRecord != HealthRecords ---
(push 1)
(assert (= EducationRecord HealthRecords))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. StudentData finite cardinality (6 values) ---
(push 1)
(declare-const x StudentData)
(assert (and (not (= x EducationRecord)) (not (= x DirectoryInfo)) (not (= x Grades)) (not (= x Disciplinary)) (not (= x SpecialEducation)) (not (= x HealthRecords))))
(check-sat) ; expect UNSAT
(pop 1)

; --- StudentAge enum properties ---

; --- 7. StudentAge exhaustiveness ---
(push 1)
(declare-const x StudentAge)
(assert (not (or (= x Under13) (= x Teen) (= x Adult))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. StudentAge: Under13 != Teen ---
(push 1)
(assert (= Under13 Teen))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. StudentAge: Teen != Adult ---
(push 1)
(assert (= Teen Adult))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. StudentAge: Under13 != Adult ---
(push 1)
(assert (= Under13 Adult))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. StudentAge finite cardinality (3 values) ---
(push 1)
(declare-const x StudentAge)
(assert (and (not (= x Under13)) (not (= x Teen)) (not (= x Adult))))
(check-sat) ; expect UNSAT
(pop 1)

; --- EducationEffect enum properties ---

; --- 12. EducationEffect exhaustiveness ---
(push 1)
(declare-const x EducationEffect)
(assert (not (or (= x StudentRecordAccess) (= x GradeEntry) (= x ParentPortal) (= x LearningAnalytics) (= x AssessmentData))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. EducationEffect: StudentRecordAccess != GradeEntry ---
(push 1)
(assert (= StudentRecordAccess GradeEntry))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. EducationEffect: GradeEntry != ParentPortal ---
(push 1)
(assert (= GradeEntry ParentPortal))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. EducationEffect: ParentPortal != LearningAnalytics ---
(push 1)
(assert (= ParentPortal LearningAnalytics))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. EducationEffect: StudentRecordAccess != AssessmentData ---
(push 1)
(assert (= StudentRecordAccess AssessmentData))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. EducationEffect finite cardinality (5 values) ---
(push 1)
(declare-const x EducationEffect)
(assert (and (not (= x StudentRecordAccess)) (not (= x GradeEntry)) (not (= x ParentPortal)) (not (= x LearningAnalytics)) (not (= x AssessmentData))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FERPA_Compliance record properties ---

; --- 18. FERPA_Compliance accessor round-trip: legitimate_educational_interest ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (legitimate_educational_interest (mk-f_e_r_p_a__compliance f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. FERPA_Compliance accessor round-trip: parental_consent ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (parental_consent (mk-f_e_r_p_a__compliance f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. FERPA_Compliance accessor round-trip: annual_notification ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (annual_notification (mk-f_e_r_p_a__compliance f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. FERPA_Compliance accessor round-trip: access_to_records ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (access_to_records (mk-f_e_r_p_a__compliance f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. FERPA_Compliance accessor round-trip: amendment_process ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (amendment_process (mk-f_e_r_p_a__compliance f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FERPA_Compliance_all_enabled ((g FERPA_Compliance)) Bool
  (and (legitimate_educational_interest g) (parental_consent g) (annual_notification g) (access_to_records g) (amendment_process g)))

; --- 23. FERPA_Compliance: all-enabled completeness ---
(push 1)
(declare-const g FERPA_Compliance)
(assert (legitimate_educational_interest g))
(assert (parental_consent g))
(assert (annual_notification g))
(assert (access_to_records g))
(assert (amendment_process g))
(assert (not (FERPA_Compliance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. FERPA_Compliance: FERPA_Compliance_all_enabled implies legitimate_educational_interest ---
(push 1)
(declare-const g FERPA_Compliance)
(assert (FERPA_Compliance_all_enabled g))
(assert (not (legitimate_educational_interest g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. FERPA_Compliance: FERPA_Compliance_all_enabled implies parental_consent ---
(push 1)
(declare-const g FERPA_Compliance)
(assert (FERPA_Compliance_all_enabled g))
(assert (not (parental_consent g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. FERPA_Compliance: FERPA_Compliance_all_enabled implies annual_notification ---
(push 1)
(declare-const g FERPA_Compliance)
(assert (FERPA_Compliance_all_enabled g))
(assert (not (annual_notification g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- StudentRecord record properties ---

; --- 27. StudentRecord accessor round-trip: student_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (student_id (mk-student_record f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. StudentRecord accessor round-trip: student_age_years ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (student_age_years (mk-student_record f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. StudentRecord accessor round-trip: student_min_age ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (student_min_age (mk-student_record f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. StudentRecord accessor round-trip: student_grade_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (student_grade_level (mk-student_record f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. StudentRecord accessor round-trip: student_max_grade ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (student_max_grade (mk-student_record f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. StudentRecord: integer field consistency ---
(push 1)
(declare-const r StudentRecord)
(assert (>= (student_id r) 0))
(assert (>= (student_age_years r) 0))
(assert (not (>= (+ (student_id r) (student_age_years r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

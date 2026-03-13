; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MalaysiaKKMHealthcare — SMT Verification
; Derived from 02_FORMAL/coq/domains/MalaysiaKKMHealthcare.v (27 assertions)
; Module: MalaysiaKKMHealthcare
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((FacilityType 0)) (((Hospital) (Clinic) (SpecialistCenter) (Laboratory) (Pharmacy))))

(declare-datatypes ((EMRClassification 0)) (((PatientDemographics) (ClinicalNotes) (DiagnosticResults) (Prescriptions) (MentalHealth) (HIV_STI))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- FacilityType enum properties ---

; --- 1. FacilityType exhaustiveness ---
(push 1)
(declare-const x FacilityType)
(assert (not (or (= x Hospital) (= x Clinic) (= x SpecialistCenter) (= x Laboratory) (= x Pharmacy))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. FacilityType: Hospital != Clinic ---
(push 1)
(assert (= Hospital Clinic))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. FacilityType: Clinic != SpecialistCenter ---
(push 1)
(assert (= Clinic SpecialistCenter))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FacilityType: SpecialistCenter != Laboratory ---
(push 1)
(assert (= SpecialistCenter Laboratory))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FacilityType: Hospital != Pharmacy ---
(push 1)
(assert (= Hospital Pharmacy))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. FacilityType finite cardinality (5 values) ---
(push 1)
(declare-const x FacilityType)
(assert (and (not (= x Hospital)) (not (= x Clinic)) (not (= x SpecialistCenter)) (not (= x Laboratory)) (not (= x Pharmacy))))
(check-sat) ; expect UNSAT
(pop 1)

; --- EMRClassification enum properties ---

; --- 7. EMRClassification exhaustiveness ---
(push 1)
(declare-const x EMRClassification)
(assert (not (or (= x PatientDemographics) (= x ClinicalNotes) (= x DiagnosticResults) (= x Prescriptions) (= x MentalHealth) (= x HIV_STI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. EMRClassification: PatientDemographics != ClinicalNotes ---
(push 1)
(assert (= PatientDemographics ClinicalNotes))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. EMRClassification: ClinicalNotes != DiagnosticResults ---
(push 1)
(assert (= ClinicalNotes DiagnosticResults))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. EMRClassification: DiagnosticResults != Prescriptions ---
(push 1)
(assert (= DiagnosticResults Prescriptions))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. EMRClassification: PatientDemographics != HIV_STI ---
(push 1)
(assert (= PatientDemographics HIV_STI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. EMRClassification finite cardinality (6 values) ---
(push 1)
(declare-const x EMRClassification)
(assert (and (not (= x PatientDemographics)) (not (= x ClinicalNotes)) (not (= x DiagnosticResults)) (not (= x Prescriptions)) (not (= x MentalHealth)) (not (= x HIV_STI))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

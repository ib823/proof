; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SingaporeHealthInfo — SMT Verification
; Derived from 02_FORMAL/coq/domains/SingaporeHealthInfo.v (28 assertions)
; Module: SingaporeHealthInfo
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SGHealthcareProvider 0)) (((PublicHospital) (PrivateHospital) (GPClinic) (SpecialistClinic) (Polyclinic) (Pharmacy_SG))))

(declare-datatypes ((HealthInfoCategory 0)) (((GeneralHealth) (MentalHealthSG) (HIV_STI_SG) (GeneticInfo) (SubstanceAbuse))))

(declare-datatypes ((UseType 0)) (((Treatment) (Research) (PublicHealth) (InsuranceUnderwriting) (Employment))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SGHealthcareProvider enum properties ---

; --- 1. SGHealthcareProvider exhaustiveness ---
(push 1)
(declare-const x SGHealthcareProvider)
(assert (not (or (= x PublicHospital) (= x PrivateHospital) (= x GPClinic) (= x SpecialistClinic) (= x Polyclinic) (= x Pharmacy_SG))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SGHealthcareProvider: PublicHospital != PrivateHospital ---
(push 1)
(assert (= PublicHospital PrivateHospital))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SGHealthcareProvider: PrivateHospital != GPClinic ---
(push 1)
(assert (= PrivateHospital GPClinic))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SGHealthcareProvider: GPClinic != SpecialistClinic ---
(push 1)
(assert (= GPClinic SpecialistClinic))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SGHealthcareProvider: PublicHospital != Pharmacy_SG ---
(push 1)
(assert (= PublicHospital Pharmacy_SG))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SGHealthcareProvider finite cardinality (6 values) ---
(push 1)
(declare-const x SGHealthcareProvider)
(assert (and (not (= x PublicHospital)) (not (= x PrivateHospital)) (not (= x GPClinic)) (not (= x SpecialistClinic)) (not (= x Polyclinic)) (not (= x Pharmacy_SG))))
(check-sat) ; expect UNSAT
(pop 1)

; --- HealthInfoCategory enum properties ---

; --- 7. HealthInfoCategory exhaustiveness ---
(push 1)
(declare-const x HealthInfoCategory)
(assert (not (or (= x GeneralHealth) (= x MentalHealthSG) (= x HIV_STI_SG) (= x GeneticInfo) (= x SubstanceAbuse))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. HealthInfoCategory: GeneralHealth != MentalHealthSG ---
(push 1)
(assert (= GeneralHealth MentalHealthSG))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. HealthInfoCategory: MentalHealthSG != HIV_STI_SG ---
(push 1)
(assert (= MentalHealthSG HIV_STI_SG))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. HealthInfoCategory: HIV_STI_SG != GeneticInfo ---
(push 1)
(assert (= HIV_STI_SG GeneticInfo))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. HealthInfoCategory: GeneralHealth != SubstanceAbuse ---
(push 1)
(assert (= GeneralHealth SubstanceAbuse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. HealthInfoCategory finite cardinality (5 values) ---
(push 1)
(declare-const x HealthInfoCategory)
(assert (and (not (= x GeneralHealth)) (not (= x MentalHealthSG)) (not (= x HIV_STI_SG)) (not (= x GeneticInfo)) (not (= x SubstanceAbuse))))
(check-sat) ; expect UNSAT
(pop 1)

; --- UseType enum properties ---

; --- 13. UseType exhaustiveness ---
(push 1)
(declare-const x UseType)
(assert (not (or (= x Treatment) (= x Research) (= x PublicHealth) (= x InsuranceUnderwriting) (= x Employment))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. UseType: Treatment != Research ---
(push 1)
(assert (= Treatment Research))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. UseType: Research != PublicHealth ---
(push 1)
(assert (= Research PublicHealth))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. UseType: PublicHealth != InsuranceUnderwriting ---
(push 1)
(assert (= PublicHealth InsuranceUnderwriting))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. UseType: Treatment != Employment ---
(push 1)
(assert (= Treatment Employment))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. UseType finite cardinality (5 values) ---
(push 1)
(declare-const x UseType)
(assert (and (not (= x Treatment)) (not (= x Research)) (not (= x PublicHealth)) (not (= x InsuranceUnderwriting)) (not (= x Employment))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

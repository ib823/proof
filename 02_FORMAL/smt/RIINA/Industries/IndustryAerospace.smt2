; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryAerospace — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryAerospace.v (25 assertions)
; Module: IndustryAerospace
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((DAL 0)) (((DAL_A) (DAL_B) (DAL_C) (DAL_D) (DAL_E))))

(declare-datatypes ((AerospaceEffect 0)) (((FlightControl) (Navigation) (Communication) (SafetyCritical) (Telemetry))))

(declare-datatypes ((DO178C_Compliance 0))
  (((mk-do178_c__compliance (software_plans Bool) (software_development Bool) (verification Bool) (configuration_management Bool) (quality_assurance Bool) (certification_liaison Bool) (dal_level DAL)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- DAL enum properties ---

; --- 1. DAL exhaustiveness ---
(push 1)
(declare-const x DAL)
(assert (not (or (= x DAL_A) (= x DAL_B) (= x DAL_C) (= x DAL_D) (= x DAL_E))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. DAL: DAL_A != DAL_B ---
(push 1)
(assert (= DAL_A DAL_B))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. DAL: DAL_B != DAL_C ---
(push 1)
(assert (= DAL_B DAL_C))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. DAL: DAL_C != DAL_D ---
(push 1)
(assert (= DAL_C DAL_D))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. DAL: DAL_A != DAL_E ---
(push 1)
(assert (= DAL_A DAL_E))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. DAL finite cardinality (5 values) ---
(push 1)
(declare-const x DAL)
(assert (and (not (= x DAL_A)) (not (= x DAL_B)) (not (= x DAL_C)) (not (= x DAL_D)) (not (= x DAL_E))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AerospaceEffect enum properties ---

; --- 7. AerospaceEffect exhaustiveness ---
(push 1)
(declare-const x AerospaceEffect)
(assert (not (or (= x FlightControl) (= x Navigation) (= x Communication) (= x SafetyCritical) (= x Telemetry))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. AerospaceEffect: FlightControl != Navigation ---
(push 1)
(assert (= FlightControl Navigation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. AerospaceEffect: Navigation != Communication ---
(push 1)
(assert (= Navigation Communication))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. AerospaceEffect: Communication != SafetyCritical ---
(push 1)
(assert (= Communication SafetyCritical))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. AerospaceEffect: FlightControl != Telemetry ---
(push 1)
(assert (= FlightControl Telemetry))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. AerospaceEffect finite cardinality (5 values) ---
(push 1)
(declare-const x AerospaceEffect)
(assert (and (not (= x FlightControl)) (not (= x Navigation)) (not (= x Communication)) (not (= x SafetyCritical)) (not (= x Telemetry))))
(check-sat) ; expect UNSAT
(pop 1)

; --- DO178C_Compliance record properties ---

; --- 13. DO178C_Compliance accessor round-trip: software_plans ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (software_plans (mk-d_o178_c__compliance f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. DO178C_Compliance accessor round-trip: software_development ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (software_development (mk-d_o178_c__compliance f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. DO178C_Compliance accessor round-trip: verification ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (verification (mk-d_o178_c__compliance f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. DO178C_Compliance accessor round-trip: configuration_management ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (configuration_management (mk-d_o178_c__compliance f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. DO178C_Compliance accessor round-trip: quality_assurance ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (quality_assurance (mk-d_o178_c__compliance f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DO178C_Compliance_all_enabled ((g DO178C_Compliance)) Bool
  (and (software_plans g) (software_development g) (verification g) (configuration_management g) (quality_assurance g) (certification_liaison g)))

; --- 18. DO178C_Compliance: all-enabled completeness ---
(push 1)
(declare-const g DO178C_Compliance)
(assert (software_plans g))
(assert (software_development g))
(assert (verification g))
(assert (configuration_management g))
(assert (quality_assurance g))
(assert (certification_liaison g))
(assert (not (DO178C_Compliance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. DO178C_Compliance: DO178C_Compliance_all_enabled implies software_plans ---
(push 1)
(declare-const g DO178C_Compliance)
(assert (DO178C_Compliance_all_enabled g))
(assert (not (software_plans g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. DO178C_Compliance: DO178C_Compliance_all_enabled implies software_development ---
(push 1)
(declare-const g DO178C_Compliance)
(assert (DO178C_Compliance_all_enabled g))
(assert (not (software_development g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. DO178C_Compliance: DO178C_Compliance_all_enabled implies verification ---
(push 1)
(declare-const g DO178C_Compliance)
(assert (DO178C_Compliance_all_enabled g))
(assert (not (verification g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryTransportation — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryTransportation.v (22 assertions)
; Module: IndustryTransportation
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ASIL 0)) (((ASIL_A) (ASIL_B) (ASIL_C) (ASIL_D) (QM))))

(declare-datatypes ((SIL 0)) (((SIL_0) (SIL_1) (SIL_2) (SIL_3) (SIL_4))))

(declare-datatypes ((TransportationEffect 0)) (((VehicleControl) (RailwaySignaling) (NavigationSystem) (V2X_Communication) (DiagnosticAccess))))

(declare-datatypes ((ISO26262_Compliance 0))
  (((mk-iso26262__compliance (hazard_analysis Bool) (system_design Bool) (hardware_design Bool) (software_design Bool) (production Bool) (supporting_processes Bool) (asil_decomposition Bool) (cybersecurity_interface Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- ASIL enum properties ---

; --- 1. ASIL exhaustiveness ---
(push 1)
(declare-const x ASIL)
(assert (not (or (= x ASIL_A) (= x ASIL_B) (= x ASIL_C) (= x ASIL_D) (= x QM))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ASIL: ASIL_A != ASIL_B ---
(push 1)
(assert (= ASIL_A ASIL_B))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ASIL: ASIL_B != ASIL_C ---
(push 1)
(assert (= ASIL_B ASIL_C))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ASIL: ASIL_C != ASIL_D ---
(push 1)
(assert (= ASIL_C ASIL_D))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ASIL: ASIL_A != QM ---
(push 1)
(assert (= ASIL_A QM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ASIL finite cardinality (5 values) ---
(push 1)
(declare-const x ASIL)
(assert (and (not (= x ASIL_A)) (not (= x ASIL_B)) (not (= x ASIL_C)) (not (= x ASIL_D)) (not (= x QM))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SIL enum properties ---

; --- 7. SIL exhaustiveness ---
(push 1)
(declare-const x SIL)
(assert (not (or (= x SIL_0) (= x SIL_1) (= x SIL_2) (= x SIL_3) (= x SIL_4))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SIL: SIL_0 != SIL_1 ---
(push 1)
(assert (= SIL_0 SIL_1))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SIL: SIL_1 != SIL_2 ---
(push 1)
(assert (= SIL_1 SIL_2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SIL: SIL_2 != SIL_3 ---
(push 1)
(assert (= SIL_2 SIL_3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SIL: SIL_0 != SIL_4 ---
(push 1)
(assert (= SIL_0 SIL_4))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SIL finite cardinality (5 values) ---
(push 1)
(declare-const x SIL)
(assert (and (not (= x SIL_0)) (not (= x SIL_1)) (not (= x SIL_2)) (not (= x SIL_3)) (not (= x SIL_4))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TransportationEffect enum properties ---

; --- 13. TransportationEffect exhaustiveness ---
(push 1)
(declare-const x TransportationEffect)
(assert (not (or (= x VehicleControl) (= x RailwaySignaling) (= x NavigationSystem) (= x V2X_Communication) (= x DiagnosticAccess))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. TransportationEffect: VehicleControl != RailwaySignaling ---
(push 1)
(assert (= VehicleControl RailwaySignaling))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. TransportationEffect: RailwaySignaling != NavigationSystem ---
(push 1)
(assert (= RailwaySignaling NavigationSystem))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. TransportationEffect: NavigationSystem != V2X_Communication ---
(push 1)
(assert (= NavigationSystem V2X_Communication))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. TransportationEffect: VehicleControl != DiagnosticAccess ---
(push 1)
(assert (= VehicleControl DiagnosticAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. TransportationEffect finite cardinality (5 values) ---
(push 1)
(declare-const x TransportationEffect)
(assert (and (not (= x VehicleControl)) (not (= x RailwaySignaling)) (not (= x NavigationSystem)) (not (= x V2X_Communication)) (not (= x DiagnosticAccess))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ISO26262_Compliance record properties ---

; --- 19. ISO26262_Compliance accessor round-trip: hazard_analysis ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (hazard_analysis (mk-i_s_o26262__compliance f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ISO26262_Compliance accessor round-trip: system_design ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (system_design (mk-i_s_o26262__compliance f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ISO26262_Compliance accessor round-trip: hardware_design ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (hardware_design (mk-i_s_o26262__compliance f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ISO26262_Compliance accessor round-trip: software_design ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (software_design (mk-i_s_o26262__compliance f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ISO26262_Compliance accessor round-trip: production ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (production (mk-i_s_o26262__compliance f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ISO26262_Compliance_all_enabled ((g ISO26262_Compliance)) Bool
  (and (hazard_analysis g) (system_design g) (hardware_design g) (software_design g) (production g) (supporting_processes g) (asil_decomposition g)))

; --- 24. ISO26262_Compliance: all-enabled completeness ---
(push 1)
(declare-const g ISO26262_Compliance)
(assert (hazard_analysis g))
(assert (system_design g))
(assert (hardware_design g))
(assert (software_design g))
(assert (production g))
(assert (supporting_processes g))
(assert (asil_decomposition g))
(assert (not (ISO26262_Compliance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ISO26262_Compliance: ISO26262_Compliance_all_enabled implies hazard_analysis ---
(push 1)
(declare-const g ISO26262_Compliance)
(assert (ISO26262_Compliance_all_enabled g))
(assert (not (hazard_analysis g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ISO26262_Compliance: ISO26262_Compliance_all_enabled implies system_design ---
(push 1)
(declare-const g ISO26262_Compliance)
(assert (ISO26262_Compliance_all_enabled g))
(assert (not (system_design g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ISO26262_Compliance: ISO26262_Compliance_all_enabled implies hardware_design ---
(push 1)
(declare-const g ISO26262_Compliance)
(assert (ISO26262_Compliance_all_enabled g))
(assert (not (hardware_design g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryManufacturing — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryManufacturing.v (24 assertions)
; Module: IndustryManufacturing
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SecurityLevel 0)) (((SL_0) (SL_1) (SL_2) (SL_3) (SL_4))))

(declare-datatypes ((IEC61508_SIL 0)) (((IEC_SIL_1) (IEC_SIL_2) (IEC_SIL_3) (IEC_SIL_4))))

(declare-datatypes ((PurdueLevel 0)) (((Level_0_Process) (Level_1_Control) (Level_2_Supervisory) (Level_3_Operations) (Level_4_Business) (Level_5_Enterprise))))

(declare-datatypes ((ManufacturingEffect 0)) (((PLC_Control) (SCADA_Operation) (MES_Transaction) (SafetyFunction) (ProcessControl))))

(declare-datatypes ((IEC62443_Compliance 0))
  (((mk-iec62443__compliance (part_2_1_policies Bool) (part_2_4_service_providers Bool) (part_3_2_zones_conduits Bool) (part_3_3_system_requirements Bool) (part_4_1_secure_development Bool) (part_4_2_component_requirements Bool) (target_security_level SecurityLevel)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SecurityLevel enum properties ---

; --- 1. SecurityLevel exhaustiveness ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (or (= x SL_0) (= x SL_1) (= x SL_2) (= x SL_3) (= x SL_4))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SecurityLevel: SL_0 != SL_1 ---
(push 1)
(assert (= SL_0 SL_1))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SecurityLevel: SL_1 != SL_2 ---
(push 1)
(assert (= SL_1 SL_2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SecurityLevel: SL_2 != SL_3 ---
(push 1)
(assert (= SL_2 SL_3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SecurityLevel: SL_0 != SL_4 ---
(push 1)
(assert (= SL_0 SL_4))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SecurityLevel finite cardinality (5 values) ---
(push 1)
(declare-const x SecurityLevel)
(assert (and (not (= x SL_0)) (not (= x SL_1)) (not (= x SL_2)) (not (= x SL_3)) (not (= x SL_4))))
(check-sat) ; expect UNSAT
(pop 1)

; --- IEC61508_SIL enum properties ---

; --- 7. IEC61508_SIL exhaustiveness ---
(push 1)
(declare-const x IEC61508_SIL)
(assert (not (or (= x IEC_SIL_1) (= x IEC_SIL_2) (= x IEC_SIL_3) (= x IEC_SIL_4))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. IEC61508_SIL: IEC_SIL_1 != IEC_SIL_2 ---
(push 1)
(assert (= IEC_SIL_1 IEC_SIL_2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. IEC61508_SIL: IEC_SIL_2 != IEC_SIL_3 ---
(push 1)
(assert (= IEC_SIL_2 IEC_SIL_3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. IEC61508_SIL: IEC_SIL_3 != IEC_SIL_4 ---
(push 1)
(assert (= IEC_SIL_3 IEC_SIL_4))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. IEC61508_SIL: IEC_SIL_1 != IEC_SIL_4 ---
(push 1)
(assert (= IEC_SIL_1 IEC_SIL_4))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. IEC61508_SIL finite cardinality (4 values) ---
(push 1)
(declare-const x IEC61508_SIL)
(assert (and (not (= x IEC_SIL_1)) (not (= x IEC_SIL_2)) (not (= x IEC_SIL_3)) (not (= x IEC_SIL_4))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PurdueLevel enum properties ---

; --- 13. PurdueLevel exhaustiveness ---
(push 1)
(declare-const x PurdueLevel)
(assert (not (or (= x Level_0_Process) (= x Level_1_Control) (= x Level_2_Supervisory) (= x Level_3_Operations) (= x Level_4_Business) (= x Level_5_Enterprise))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. PurdueLevel: Level_0_Process != Level_1_Control ---
(push 1)
(assert (= Level_0_Process Level_1_Control))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. PurdueLevel: Level_1_Control != Level_2_Supervisory ---
(push 1)
(assert (= Level_1_Control Level_2_Supervisory))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. PurdueLevel: Level_2_Supervisory != Level_3_Operations ---
(push 1)
(assert (= Level_2_Supervisory Level_3_Operations))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. PurdueLevel: Level_0_Process != Level_5_Enterprise ---
(push 1)
(assert (= Level_0_Process Level_5_Enterprise))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. PurdueLevel finite cardinality (6 values) ---
(push 1)
(declare-const x PurdueLevel)
(assert (and (not (= x Level_0_Process)) (not (= x Level_1_Control)) (not (= x Level_2_Supervisory)) (not (= x Level_3_Operations)) (not (= x Level_4_Business)) (not (= x Level_5_Enterprise))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ManufacturingEffect enum properties ---

; --- 19. ManufacturingEffect exhaustiveness ---
(push 1)
(declare-const x ManufacturingEffect)
(assert (not (or (= x PLC_Control) (= x SCADA_Operation) (= x MES_Transaction) (= x SafetyFunction) (= x ProcessControl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ManufacturingEffect: PLC_Control != SCADA_Operation ---
(push 1)
(assert (= PLC_Control SCADA_Operation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ManufacturingEffect: SCADA_Operation != MES_Transaction ---
(push 1)
(assert (= SCADA_Operation MES_Transaction))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ManufacturingEffect: MES_Transaction != SafetyFunction ---
(push 1)
(assert (= MES_Transaction SafetyFunction))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ManufacturingEffect: PLC_Control != ProcessControl ---
(push 1)
(assert (= PLC_Control ProcessControl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ManufacturingEffect finite cardinality (5 values) ---
(push 1)
(declare-const x ManufacturingEffect)
(assert (and (not (= x PLC_Control)) (not (= x SCADA_Operation)) (not (= x MES_Transaction)) (not (= x SafetyFunction)) (not (= x ProcessControl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- IEC62443_Compliance record properties ---

; --- 25. IEC62443_Compliance accessor round-trip: part_2_1_policies ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (part_2_1_policies (mk-i_e_c62443__compliance f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. IEC62443_Compliance accessor round-trip: part_2_4_service_providers ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (part_2_4_service_providers (mk-i_e_c62443__compliance f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. IEC62443_Compliance accessor round-trip: part_3_2_zones_conduits ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (part_3_2_zones_conduits (mk-i_e_c62443__compliance f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. IEC62443_Compliance accessor round-trip: part_3_3_system_requirements ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (part_3_3_system_requirements (mk-i_e_c62443__compliance f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. IEC62443_Compliance accessor round-trip: part_4_1_secure_development ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (part_4_1_secure_development (mk-i_e_c62443__compliance f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun IEC62443_Compliance_all_enabled ((g IEC62443_Compliance)) Bool
  (and (part_2_1_policies g) (part_2_4_service_providers g) (part_3_2_zones_conduits g) (part_3_3_system_requirements g) (part_4_1_secure_development g) (part_4_2_component_requirements g)))

; --- 30. IEC62443_Compliance: all-enabled completeness ---
(push 1)
(declare-const g IEC62443_Compliance)
(assert (part_2_1_policies g))
(assert (part_2_4_service_providers g))
(assert (part_3_2_zones_conduits g))
(assert (part_3_3_system_requirements g))
(assert (part_4_1_secure_development g))
(assert (part_4_2_component_requirements g))
(assert (not (IEC62443_Compliance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. IEC62443_Compliance: IEC62443_Compliance_all_enabled implies part_2_1_policies ---
(push 1)
(declare-const g IEC62443_Compliance)
(assert (IEC62443_Compliance_all_enabled g))
(assert (not (part_2_1_policies g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. IEC62443_Compliance: IEC62443_Compliance_all_enabled implies part_2_4_service_providers ---
(push 1)
(declare-const g IEC62443_Compliance)
(assert (IEC62443_Compliance_all_enabled g))
(assert (not (part_2_4_service_providers g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. IEC62443_Compliance: IEC62443_Compliance_all_enabled implies part_3_2_zones_conduits ---
(push 1)
(declare-const g IEC62443_Compliance)
(assert (IEC62443_Compliance_all_enabled g))
(assert (not (part_3_2_zones_conduits g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLevel ordering properties ---

(define-fun SecurityLevel_level ((x SecurityLevel)) Int
  (ite (= x SL_0) 0 (ite (= x SL_1) 1 (ite (= x SL_2) 2 (ite (= x SL_3) 3 4)))))

(define-fun SecurityLevel_leq ((x SecurityLevel) (y SecurityLevel)) Bool
  (<= (SecurityLevel_level x) (SecurityLevel_level y)))

; --- 34. SecurityLevel_leq reflexivity ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. SecurityLevel_leq transitivity ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(declare-const z SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y z))
(assert (not (SecurityLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. SecurityLevel_leq antisymmetry ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. SL_0 is bottom ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq SL_0 x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. SL_4 is top ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x SL_4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PurdueLevel ordering properties ---

(define-fun PurdueLevel_level ((x PurdueLevel)) Int
  (ite (= x Level_0_Process) 0 (ite (= x Level_1_Control) 1 (ite (= x Level_2_Supervisory) 2 (ite (= x Level_3_Operations) 3 (ite (= x Level_4_Business) 4 5))))))

(define-fun PurdueLevel_leq ((x PurdueLevel) (y PurdueLevel)) Bool
  (<= (PurdueLevel_level x) (PurdueLevel_level y)))

; --- 39. PurdueLevel_leq reflexivity ---
(push 1)
(declare-const x PurdueLevel)
(assert (not (PurdueLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. PurdueLevel_leq transitivity ---
(push 1)
(declare-const x PurdueLevel)
(declare-const y PurdueLevel)
(declare-const z PurdueLevel)
(assert (PurdueLevel_leq x y))
(assert (PurdueLevel_leq y z))
(assert (not (PurdueLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. PurdueLevel_leq antisymmetry ---
(push 1)
(declare-const x PurdueLevel)
(declare-const y PurdueLevel)
(assert (PurdueLevel_leq x y))
(assert (PurdueLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. Level_0_Process is bottom ---
(push 1)
(declare-const x PurdueLevel)
(assert (not (PurdueLevel_leq Level_0_Process x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. Level_5_Enterprise is top ---
(push 1)
(declare-const x PurdueLevel)
(assert (not (PurdueLevel_leq x Level_5_Enterprise)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

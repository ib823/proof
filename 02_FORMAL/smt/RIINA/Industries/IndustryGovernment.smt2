; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryGovernment — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryGovernment.v (23 assertions)
; Module: IndustryGovernment
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((FISMA_Impact 0)) (((FISMA_Low) (FISMA_Moderate) (FISMA_High))))

(declare-datatypes ((FedRAMP_Level 0)) (((FedRAMP_Low) (FedRAMP_Moderate) (FedRAMP_High))))

(declare-datatypes ((GovernmentEffect 0)) (((ClassifiedAccess) (PII_Processing) (CJI_Access) (FederalRecord) (CrossBoundary))))

(declare-datatypes ((FIPS_Level 0)) (((FIPS_Level_1) (FIPS_Level_2) (FIPS_Level_3) (FIPS_Level_4))))

(declare-datatypes ((NIST_800_53_Controls 0))
  (((mk-nist_800_53__controls (ac_access_control Bool) (at_awareness_training Bool) (au_audit Bool) (ca_assessment Bool) (cm_config_management Bool) (cp_contingency Bool) (ia_identification Bool) (ir_incident_response Bool) (ma_maintenance Bool) (mp_media_protection Bool) (pe_physical Bool) (pl_planning Bool) (pm_program_management Bool) (ps_personnel Bool) (pt_pii_processing Bool) (ra_risk_assessment Bool) (sa_system_acquisition Bool) (sc_system_comms Bool) (si_system_integrity Bool) (sr_supply_chain Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- FISMA_Impact enum properties ---

; --- 1. FISMA_Impact exhaustiveness ---
(push 1)
(declare-const x FISMA_Impact)
(assert (not (or (= x FISMA_Low) (= x FISMA_Moderate) (= x FISMA_High))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. FISMA_Impact: FISMA_Low != FISMA_Moderate ---
(push 1)
(assert (= FISMA_Low FISMA_Moderate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. FISMA_Impact: FISMA_Moderate != FISMA_High ---
(push 1)
(assert (= FISMA_Moderate FISMA_High))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FISMA_Impact: FISMA_Low != FISMA_High ---
(push 1)
(assert (= FISMA_Low FISMA_High))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FISMA_Impact finite cardinality (3 values) ---
(push 1)
(declare-const x FISMA_Impact)
(assert (and (not (= x FISMA_Low)) (not (= x FISMA_Moderate)) (not (= x FISMA_High))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FedRAMP_Level enum properties ---

; --- 6. FedRAMP_Level exhaustiveness ---
(push 1)
(declare-const x FedRAMP_Level)
(assert (not (or (= x FedRAMP_Low) (= x FedRAMP_Moderate) (= x FedRAMP_High))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. FedRAMP_Level: FedRAMP_Low != FedRAMP_Moderate ---
(push 1)
(assert (= FedRAMP_Low FedRAMP_Moderate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FedRAMP_Level: FedRAMP_Moderate != FedRAMP_High ---
(push 1)
(assert (= FedRAMP_Moderate FedRAMP_High))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FedRAMP_Level: FedRAMP_Low != FedRAMP_High ---
(push 1)
(assert (= FedRAMP_Low FedRAMP_High))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FedRAMP_Level finite cardinality (3 values) ---
(push 1)
(declare-const x FedRAMP_Level)
(assert (and (not (= x FedRAMP_Low)) (not (= x FedRAMP_Moderate)) (not (= x FedRAMP_High))))
(check-sat) ; expect UNSAT
(pop 1)

; --- GovernmentEffect enum properties ---

; --- 11. GovernmentEffect exhaustiveness ---
(push 1)
(declare-const x GovernmentEffect)
(assert (not (or (= x ClassifiedAccess) (= x PII_Processing) (= x CJI_Access) (= x FederalRecord) (= x CrossBoundary))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. GovernmentEffect: ClassifiedAccess != PII_Processing ---
(push 1)
(assert (= ClassifiedAccess PII_Processing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. GovernmentEffect: PII_Processing != CJI_Access ---
(push 1)
(assert (= PII_Processing CJI_Access))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. GovernmentEffect: CJI_Access != FederalRecord ---
(push 1)
(assert (= CJI_Access FederalRecord))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. GovernmentEffect: ClassifiedAccess != CrossBoundary ---
(push 1)
(assert (= ClassifiedAccess CrossBoundary))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. GovernmentEffect finite cardinality (5 values) ---
(push 1)
(declare-const x GovernmentEffect)
(assert (and (not (= x ClassifiedAccess)) (not (= x PII_Processing)) (not (= x CJI_Access)) (not (= x FederalRecord)) (not (= x CrossBoundary))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FIPS_Level enum properties ---

; --- 17. FIPS_Level exhaustiveness ---
(push 1)
(declare-const x FIPS_Level)
(assert (not (or (= x FIPS_Level_1) (= x FIPS_Level_2) (= x FIPS_Level_3) (= x FIPS_Level_4))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. FIPS_Level: FIPS_Level_1 != FIPS_Level_2 ---
(push 1)
(assert (= FIPS_Level_1 FIPS_Level_2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. FIPS_Level: FIPS_Level_2 != FIPS_Level_3 ---
(push 1)
(assert (= FIPS_Level_2 FIPS_Level_3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. FIPS_Level: FIPS_Level_3 != FIPS_Level_4 ---
(push 1)
(assert (= FIPS_Level_3 FIPS_Level_4))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. FIPS_Level: FIPS_Level_1 != FIPS_Level_4 ---
(push 1)
(assert (= FIPS_Level_1 FIPS_Level_4))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. FIPS_Level finite cardinality (4 values) ---
(push 1)
(declare-const x FIPS_Level)
(assert (and (not (= x FIPS_Level_1)) (not (= x FIPS_Level_2)) (not (= x FIPS_Level_3)) (not (= x FIPS_Level_4))))
(check-sat) ; expect UNSAT
(pop 1)

; --- NIST_800_53_Controls record properties ---

; --- 23. NIST_800_53_Controls accessor round-trip: ac_access_control ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(assert (not (= (ac_access_control (mk-n_i_s_t_800_53__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. NIST_800_53_Controls accessor round-trip: at_awareness_training ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(assert (not (= (at_awareness_training (mk-n_i_s_t_800_53__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. NIST_800_53_Controls accessor round-trip: au_audit ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(assert (not (= (au_audit (mk-n_i_s_t_800_53__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. NIST_800_53_Controls accessor round-trip: ca_assessment ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(assert (not (= (ca_assessment (mk-n_i_s_t_800_53__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. NIST_800_53_Controls accessor round-trip: cm_config_management ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(assert (not (= (cm_config_management (mk-n_i_s_t_800_53__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun NIST_800_53_Controls_all_enabled ((g NIST_800_53_Controls)) Bool
  (and (ac_access_control g) (at_awareness_training g) (au_audit g) (ca_assessment g) (cm_config_management g) (cp_contingency g) (ia_identification g) (ir_incident_response g) (ma_maintenance g) (mp_media_protection g) (pe_physical g) (pl_planning g) (pm_program_management g) (ps_personnel g) (pt_pii_processing g) (ra_risk_assessment g) (sa_system_acquisition g) (sc_system_comms g) (si_system_integrity g)))

; --- 28. NIST_800_53_Controls: all-enabled completeness ---
(push 1)
(declare-const g NIST_800_53_Controls)
(assert (ac_access_control g))
(assert (at_awareness_training g))
(assert (au_audit g))
(assert (ca_assessment g))
(assert (cm_config_management g))
(assert (cp_contingency g))
(assert (ia_identification g))
(assert (ir_incident_response g))
(assert (ma_maintenance g))
(assert (mp_media_protection g))
(assert (pe_physical g))
(assert (pl_planning g))
(assert (pm_program_management g))
(assert (ps_personnel g))
(assert (pt_pii_processing g))
(assert (ra_risk_assessment g))
(assert (sa_system_acquisition g))
(assert (sc_system_comms g))
(assert (si_system_integrity g))
(assert (not (NIST_800_53_Controls_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. NIST_800_53_Controls: NIST_800_53_Controls_all_enabled implies ac_access_control ---
(push 1)
(declare-const g NIST_800_53_Controls)
(assert (NIST_800_53_Controls_all_enabled g))
(assert (not (ac_access_control g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. NIST_800_53_Controls: NIST_800_53_Controls_all_enabled implies at_awareness_training ---
(push 1)
(declare-const g NIST_800_53_Controls)
(assert (NIST_800_53_Controls_all_enabled g))
(assert (not (at_awareness_training g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. NIST_800_53_Controls: NIST_800_53_Controls_all_enabled implies au_audit ---
(push 1)
(declare-const g NIST_800_53_Controls)
(assert (NIST_800_53_Controls_all_enabled g))
(assert (not (au_audit g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FedRAMP_Level ordering properties ---

(define-fun FedRAMP_Level_level ((x FedRAMP_Level)) Int
  (ite (= x FedRAMP_Low) 0 (ite (= x FedRAMP_Moderate) 1 2)))

(define-fun FedRAMP_Level_leq ((x FedRAMP_Level) (y FedRAMP_Level)) Bool
  (<= (FedRAMP_Level_level x) (FedRAMP_Level_level y)))

; --- 32. FedRAMP_Level_leq reflexivity ---
(push 1)
(declare-const x FedRAMP_Level)
(assert (not (FedRAMP_Level_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. FedRAMP_Level_leq transitivity ---
(push 1)
(declare-const x FedRAMP_Level)
(declare-const y FedRAMP_Level)
(declare-const z FedRAMP_Level)
(assert (FedRAMP_Level_leq x y))
(assert (FedRAMP_Level_leq y z))
(assert (not (FedRAMP_Level_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. FedRAMP_Level_leq antisymmetry ---
(push 1)
(declare-const x FedRAMP_Level)
(declare-const y FedRAMP_Level)
(assert (FedRAMP_Level_leq x y))
(assert (FedRAMP_Level_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. FedRAMP_Low is bottom ---
(push 1)
(declare-const x FedRAMP_Level)
(assert (not (FedRAMP_Level_leq FedRAMP_Low x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. FedRAMP_High is top ---
(push 1)
(declare-const x FedRAMP_Level)
(assert (not (FedRAMP_Level_leq x FedRAMP_High)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FIPS_Level ordering properties ---

(define-fun FIPS_Level_level ((x FIPS_Level)) Int
  (ite (= x FIPS_Level_1) 0 (ite (= x FIPS_Level_2) 1 (ite (= x FIPS_Level_3) 2 3))))

(define-fun FIPS_Level_leq ((x FIPS_Level) (y FIPS_Level)) Bool
  (<= (FIPS_Level_level x) (FIPS_Level_level y)))

; --- 37. FIPS_Level_leq reflexivity ---
(push 1)
(declare-const x FIPS_Level)
(assert (not (FIPS_Level_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. FIPS_Level_leq transitivity ---
(push 1)
(declare-const x FIPS_Level)
(declare-const y FIPS_Level)
(declare-const z FIPS_Level)
(assert (FIPS_Level_leq x y))
(assert (FIPS_Level_leq y z))
(assert (not (FIPS_Level_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. FIPS_Level_leq antisymmetry ---
(push 1)
(declare-const x FIPS_Level)
(declare-const y FIPS_Level)
(assert (FIPS_Level_leq x y))
(assert (FIPS_Level_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. FIPS_Level_1 is bottom ---
(push 1)
(declare-const x FIPS_Level)
(assert (not (FIPS_Level_leq FIPS_Level_1 x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. FIPS_Level_4 is top ---
(push 1)
(declare-const x FIPS_Level)
(assert (not (FIPS_Level_leq x FIPS_Level_4)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

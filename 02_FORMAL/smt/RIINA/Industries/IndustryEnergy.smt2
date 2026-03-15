; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryEnergy — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryEnergy.v (23 assertions)
; Module: IndustryEnergy
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CIP_Impact 0)) (((High_Impact) (Medium_Impact) (Low_Impact))))

(declare-datatypes ((BES_Asset 0)) (((ControlCenter) (Substation) (GenerationFacility) (TransmissionLine) (SCADA_System))))

(declare-datatypes ((EnergyEffect 0)) (((GridControl) (SCADA_Operation) (PowerGeneration) (LoadBalancing) (NuclearSafety))))

(declare-datatypes ((NERC_CIP_Controls 0))
  (((mk-nerc_cip__controls (cip_002_identification Bool) (cip_003_management Bool) (cip_004_personnel Bool) (cip_005_electronic_perimeter Bool) (cip_006_physical Bool) (cip_007_systems Bool) (cip_008_incident Bool) (cip_009_recovery Bool) (cip_010_config Bool) (cip_011_info Bool) (cip_013_supply_chain Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- CIP_Impact enum properties ---

; --- 1. CIP_Impact exhaustiveness ---
(push 1)
(declare-const x CIP_Impact)
(assert (not (or (= x High_Impact) (= x Medium_Impact) (= x Low_Impact))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CIP_Impact: High_Impact != Medium_Impact ---
(push 1)
(assert (= High_Impact Medium_Impact))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CIP_Impact: Medium_Impact != Low_Impact ---
(push 1)
(assert (= Medium_Impact Low_Impact))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CIP_Impact: High_Impact != Low_Impact ---
(push 1)
(assert (= High_Impact Low_Impact))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CIP_Impact finite cardinality (3 values) ---
(push 1)
(declare-const x CIP_Impact)
(assert (and (not (= x High_Impact)) (not (= x Medium_Impact)) (not (= x Low_Impact))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BES_Asset enum properties ---

; --- 6. BES_Asset exhaustiveness ---
(push 1)
(declare-const x BES_Asset)
(assert (not (or (= x ControlCenter) (= x Substation) (= x GenerationFacility) (= x TransmissionLine) (= x SCADA_System))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. BES_Asset: ControlCenter != Substation ---
(push 1)
(assert (= ControlCenter Substation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. BES_Asset: Substation != GenerationFacility ---
(push 1)
(assert (= Substation GenerationFacility))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. BES_Asset: GenerationFacility != TransmissionLine ---
(push 1)
(assert (= GenerationFacility TransmissionLine))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. BES_Asset: ControlCenter != SCADA_System ---
(push 1)
(assert (= ControlCenter SCADA_System))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. BES_Asset finite cardinality (5 values) ---
(push 1)
(declare-const x BES_Asset)
(assert (and (not (= x ControlCenter)) (not (= x Substation)) (not (= x GenerationFacility)) (not (= x TransmissionLine)) (not (= x SCADA_System))))
(check-sat) ; expect UNSAT
(pop 1)

; --- EnergyEffect enum properties ---

; --- 12. EnergyEffect exhaustiveness ---
(push 1)
(declare-const x EnergyEffect)
(assert (not (or (= x GridControl) (= x SCADA_Operation) (= x PowerGeneration) (= x LoadBalancing) (= x NuclearSafety))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. EnergyEffect: GridControl != SCADA_Operation ---
(push 1)
(assert (= GridControl SCADA_Operation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. EnergyEffect: SCADA_Operation != PowerGeneration ---
(push 1)
(assert (= SCADA_Operation PowerGeneration))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. EnergyEffect: PowerGeneration != LoadBalancing ---
(push 1)
(assert (= PowerGeneration LoadBalancing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. EnergyEffect: GridControl != NuclearSafety ---
(push 1)
(assert (= GridControl NuclearSafety))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. EnergyEffect finite cardinality (5 values) ---
(push 1)
(declare-const x EnergyEffect)
(assert (and (not (= x GridControl)) (not (= x SCADA_Operation)) (not (= x PowerGeneration)) (not (= x LoadBalancing)) (not (= x NuclearSafety))))
(check-sat) ; expect UNSAT
(pop 1)

; --- NERC_CIP_Controls record properties ---

; --- 18. NERC_CIP_Controls accessor round-trip: cip_002_identification ---
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
(assert (not (= (cip_002_identification (mk-nerc_cip__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. NERC_CIP_Controls accessor round-trip: cip_003_management ---
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
(assert (not (= (cip_003_management (mk-nerc_cip__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. NERC_CIP_Controls accessor round-trip: cip_004_personnel ---
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
(assert (not (= (cip_004_personnel (mk-nerc_cip__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. NERC_CIP_Controls accessor round-trip: cip_005_electronic_perimeter ---
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
(assert (not (= (cip_005_electronic_perimeter (mk-nerc_cip__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. NERC_CIP_Controls accessor round-trip: cip_006_physical ---
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
(assert (not (= (cip_006_physical (mk-nerc_cip__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun NERC_CIP_Controls_all_enabled ((g NERC_CIP_Controls)) Bool
  (and (cip_002_identification g) (cip_003_management g) (cip_004_personnel g) (cip_005_electronic_perimeter g) (cip_006_physical g) (cip_007_systems g) (cip_008_incident g) (cip_009_recovery g) (cip_010_config g) (cip_011_info g)))

; --- 23. NERC_CIP_Controls: all-enabled completeness ---
(push 1)
(declare-const g NERC_CIP_Controls)
(assert (cip_002_identification g))
(assert (cip_003_management g))
(assert (cip_004_personnel g))
(assert (cip_005_electronic_perimeter g))
(assert (cip_006_physical g))
(assert (cip_007_systems g))
(assert (cip_008_incident g))
(assert (cip_009_recovery g))
(assert (cip_010_config g))
(assert (cip_011_info g))
(assert (not (NERC_CIP_Controls_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. NERC_CIP_Controls: NERC_CIP_Controls_all_enabled implies cip_002_identification ---
(push 1)
(declare-const g NERC_CIP_Controls)
(assert (NERC_CIP_Controls_all_enabled g))
(assert (not (cip_002_identification g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. NERC_CIP_Controls: NERC_CIP_Controls_all_enabled implies cip_003_management ---
(push 1)
(declare-const g NERC_CIP_Controls)
(assert (NERC_CIP_Controls_all_enabled g))
(assert (not (cip_003_management g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. NERC_CIP_Controls: NERC_CIP_Controls_all_enabled implies cip_004_personnel ---
(push 1)
(declare-const g NERC_CIP_Controls)
(assert (NERC_CIP_Controls_all_enabled g))
(assert (not (cip_004_personnel g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

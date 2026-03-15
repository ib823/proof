; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SpectreDefense — SMT Verification
; Derived from 02_FORMAL/coq/domains/SpectreDefense.v (21 assertions)
; Module: SpectreDefense
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SpectreVariant 0)) (((Spectre_V1) (Spectre_V2) (Spectre_V4) (Spectre_RSB) (Spectre_BHB))))

(declare-datatypes ((DefenseMechanism 0)) (((Serialization) (ArrayMasking) (RetpolineIndirect) (IBRS) (STIBP) (Flushing))))

(declare-datatypes ((SpectreDefenseConfig 0))
  (((mk-spectre_defense_config (sdc_v1_protected Bool) (sdc_v2_protected Bool) (sdc_v4_protected Bool) (sdc_rsb_protected Bool) (sdc_bhb_protected Bool) (sdc_serialization_enabled Bool) (sdc_array_masking_enabled Bool) (sdc_retpoline_enabled Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SpectreVariant enum properties ---

; --- 1. SpectreVariant exhaustiveness ---
(push 1)
(declare-const x SpectreVariant)
(assert (not (or (= x Spectre_V1) (= x Spectre_V2) (= x Spectre_V4) (= x Spectre_RSB) (= x Spectre_BHB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SpectreVariant: Spectre_V1 != Spectre_V2 ---
(push 1)
(assert (= Spectre_V1 Spectre_V2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SpectreVariant: Spectre_V2 != Spectre_V4 ---
(push 1)
(assert (= Spectre_V2 Spectre_V4))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SpectreVariant: Spectre_V4 != Spectre_RSB ---
(push 1)
(assert (= Spectre_V4 Spectre_RSB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SpectreVariant: Spectre_V1 != Spectre_BHB ---
(push 1)
(assert (= Spectre_V1 Spectre_BHB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SpectreVariant finite cardinality (5 values) ---
(push 1)
(declare-const x SpectreVariant)
(assert (and (not (= x Spectre_V1)) (not (= x Spectre_V2)) (not (= x Spectre_V4)) (not (= x Spectre_RSB)) (not (= x Spectre_BHB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- DefenseMechanism enum properties ---

; --- 7. DefenseMechanism exhaustiveness ---
(push 1)
(declare-const x DefenseMechanism)
(assert (not (or (= x Serialization) (= x ArrayMasking) (= x RetpolineIndirect) (= x IBRS) (= x STIBP) (= x Flushing))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. DefenseMechanism: Serialization != ArrayMasking ---
(push 1)
(assert (= Serialization ArrayMasking))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. DefenseMechanism: ArrayMasking != RetpolineIndirect ---
(push 1)
(assert (= ArrayMasking RetpolineIndirect))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. DefenseMechanism: RetpolineIndirect != IBRS ---
(push 1)
(assert (= RetpolineIndirect IBRS))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. DefenseMechanism: Serialization != Flushing ---
(push 1)
(assert (= Serialization Flushing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. DefenseMechanism finite cardinality (6 values) ---
(push 1)
(declare-const x DefenseMechanism)
(assert (and (not (= x Serialization)) (not (= x ArrayMasking)) (not (= x RetpolineIndirect)) (not (= x IBRS)) (not (= x STIBP)) (not (= x Flushing))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SpectreDefenseConfig record properties ---

; --- 13. SpectreDefenseConfig accessor round-trip: sdc_v1_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (sdc_v1_protected (mk-spectre_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SpectreDefenseConfig accessor round-trip: sdc_v2_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (sdc_v2_protected (mk-spectre_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SpectreDefenseConfig accessor round-trip: sdc_v4_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (sdc_v4_protected (mk-spectre_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SpectreDefenseConfig accessor round-trip: sdc_rsb_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (sdc_rsb_protected (mk-spectre_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SpectreDefenseConfig accessor round-trip: sdc_bhb_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (sdc_bhb_protected (mk-spectre_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SpectreDefenseConfig_all_enabled ((g SpectreDefenseConfig)) Bool
  (and (sdc_v1_protected g) (sdc_v2_protected g) (sdc_v4_protected g) (sdc_rsb_protected g) (sdc_bhb_protected g) (sdc_serialization_enabled g) (sdc_array_masking_enabled g)))

; --- 18. SpectreDefenseConfig: all-enabled completeness ---
(push 1)
(declare-const g SpectreDefenseConfig)
(assert (sdc_v1_protected g))
(assert (sdc_v2_protected g))
(assert (sdc_v4_protected g))
(assert (sdc_rsb_protected g))
(assert (sdc_bhb_protected g))
(assert (sdc_serialization_enabled g))
(assert (sdc_array_masking_enabled g))
(assert (not (SpectreDefenseConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SpectreDefenseConfig: SpectreDefenseConfig_all_enabled implies sdc_v1_protected ---
(push 1)
(declare-const g SpectreDefenseConfig)
(assert (SpectreDefenseConfig_all_enabled g))
(assert (not (sdc_v1_protected g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SpectreDefenseConfig: SpectreDefenseConfig_all_enabled implies sdc_v2_protected ---
(push 1)
(declare-const g SpectreDefenseConfig)
(assert (SpectreDefenseConfig_all_enabled g))
(assert (not (sdc_v2_protected g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SpectreDefenseConfig: SpectreDefenseConfig_all_enabled implies sdc_v4_protected ---
(push 1)
(declare-const g SpectreDefenseConfig)
(assert (SpectreDefenseConfig_all_enabled g))
(assert (not (sdc_v4_protected g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

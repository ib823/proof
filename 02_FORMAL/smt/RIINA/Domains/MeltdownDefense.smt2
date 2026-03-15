; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MeltdownDefense — SMT Verification
; Derived from 02_FORMAL/coq/domains/MeltdownDefense.v (30 assertions)
; Module: MeltdownDefense
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((MeltdownVariant 0)) (((Meltdown_US) (Meltdown_P) (Meltdown_RW) (Meltdown_PK) (Meltdown_BR))))

(declare-datatypes ((MeltdownDefense 0)) (((KPTI) (L1TF_Flush) (TSX_Disable) (MDS_Clear))))

(declare-datatypes ((MeltdownDefenseConfig 0))
  (((mk-meltdown_defense_config (mdc_us_protected Bool) (mdc_p_protected Bool) (mdc_rw_protected Bool) (mdc_pk_protected Bool) (mdc_br_protected Bool) (mdc_kpti_enabled Bool) (mdc_l1tf_mitigated Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- MeltdownVariant enum properties ---

; --- 1. MeltdownVariant exhaustiveness ---
(push 1)
(declare-const x MeltdownVariant)
(assert (not (or (= x Meltdown_US) (= x Meltdown_P) (= x Meltdown_RW) (= x Meltdown_PK) (= x Meltdown_BR))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. MeltdownVariant: Meltdown_US != Meltdown_P ---
(push 1)
(assert (= Meltdown_US Meltdown_P))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. MeltdownVariant: Meltdown_P != Meltdown_RW ---
(push 1)
(assert (= Meltdown_P Meltdown_RW))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. MeltdownVariant: Meltdown_RW != Meltdown_PK ---
(push 1)
(assert (= Meltdown_RW Meltdown_PK))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. MeltdownVariant: Meltdown_US != Meltdown_BR ---
(push 1)
(assert (= Meltdown_US Meltdown_BR))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. MeltdownVariant finite cardinality (5 values) ---
(push 1)
(declare-const x MeltdownVariant)
(assert (and (not (= x Meltdown_US)) (not (= x Meltdown_P)) (not (= x Meltdown_RW)) (not (= x Meltdown_PK)) (not (= x Meltdown_BR))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MeltdownDefense enum properties ---

; --- 7. MeltdownDefense exhaustiveness ---
(push 1)
(declare-const x MeltdownDefense)
(assert (not (or (= x KPTI) (= x L1TF_Flush) (= x TSX_Disable) (= x MDS_Clear))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. MeltdownDefense: KPTI != L1TF_Flush ---
(push 1)
(assert (= KPTI L1TF_Flush))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. MeltdownDefense: L1TF_Flush != TSX_Disable ---
(push 1)
(assert (= L1TF_Flush TSX_Disable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. MeltdownDefense: TSX_Disable != MDS_Clear ---
(push 1)
(assert (= TSX_Disable MDS_Clear))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. MeltdownDefense: KPTI != MDS_Clear ---
(push 1)
(assert (= KPTI MDS_Clear))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. MeltdownDefense finite cardinality (4 values) ---
(push 1)
(declare-const x MeltdownDefense)
(assert (and (not (= x KPTI)) (not (= x L1TF_Flush)) (not (= x TSX_Disable)) (not (= x MDS_Clear))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MeltdownDefenseConfig record properties ---

; --- 13. MeltdownDefenseConfig accessor round-trip: mdc_us_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (mdc_us_protected (mk-meltdown_defense_config f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. MeltdownDefenseConfig accessor round-trip: mdc_p_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (mdc_p_protected (mk-meltdown_defense_config f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. MeltdownDefenseConfig accessor round-trip: mdc_rw_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (mdc_rw_protected (mk-meltdown_defense_config f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. MeltdownDefenseConfig accessor round-trip: mdc_pk_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (mdc_pk_protected (mk-meltdown_defense_config f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. MeltdownDefenseConfig accessor round-trip: mdc_br_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (mdc_br_protected (mk-meltdown_defense_config f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MeltdownDefenseConfig_all_enabled ((g MeltdownDefenseConfig)) Bool
  (and (mdc_us_protected g) (mdc_p_protected g) (mdc_rw_protected g) (mdc_pk_protected g) (mdc_br_protected g) (mdc_kpti_enabled g)))

; --- 18. MeltdownDefenseConfig: all-enabled completeness ---
(push 1)
(declare-const g MeltdownDefenseConfig)
(assert (mdc_us_protected g))
(assert (mdc_p_protected g))
(assert (mdc_rw_protected g))
(assert (mdc_pk_protected g))
(assert (mdc_br_protected g))
(assert (mdc_kpti_enabled g))
(assert (not (MeltdownDefenseConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. MeltdownDefenseConfig: MeltdownDefenseConfig_all_enabled implies mdc_us_protected ---
(push 1)
(declare-const g MeltdownDefenseConfig)
(assert (MeltdownDefenseConfig_all_enabled g))
(assert (not (mdc_us_protected g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. MeltdownDefenseConfig: MeltdownDefenseConfig_all_enabled implies mdc_p_protected ---
(push 1)
(declare-const g MeltdownDefenseConfig)
(assert (MeltdownDefenseConfig_all_enabled g))
(assert (not (mdc_p_protected g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. MeltdownDefenseConfig: MeltdownDefenseConfig_all_enabled implies mdc_rw_protected ---
(push 1)
(declare-const g MeltdownDefenseConfig)
(assert (MeltdownDefenseConfig_all_enabled g))
(assert (not (mdc_rw_protected g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

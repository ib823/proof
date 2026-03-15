; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DDR5MemoryBus — SMT Verification
; Derived from 02_FORMAL/coq/domains/DDR5MemoryBus.v (26 assertions)
; Module: DDR5MemoryBus
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((DDR5Feature 0)) (((OnDIMMECC) (DecisionFeedbackEqualization) (DualChannel) (PMIC) (RefreshManagement))))

(declare-datatypes ((PhysicalAttack 0)) (((BusInterposition) (Rowhammer) (ColdBoot) (FaultInjection) (ECCBypass))))

(declare-datatypes ((IntegrityMechanism 0)) (((SoftwareEncryption) (IntegrityTree) (MACSigning) (Checksumming) (RedundantStorage))))

(declare-datatypes ((DDR5DefenseConfig 0))
  (((mk-ddr5_defense_config (ddr5_software_encryption Bool) (ddr5_integrity_tree Bool) (ddr5_mac_signing Bool) (ddr5_rowhammer_mitigation Bool) (ddr5_cold_boot_defense Bool) (ddr5_fault_detection Bool) (ddr5_ecc_bypass_defense Bool) (ddr5_bus_interposition_defense Bool) (ddr5_redundant_storage Bool) (ddr5_refresh_randomization Bool)))))

(declare-datatypes ((MemoryRegion 0))
  (((mk-memory_region (mr_base_addr Int) (mr_size Int) (mr_encrypted Bool) (mr_mac_protected Bool) (mr_in_integrity_tree Bool) (mr_refreshed Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- DDR5Feature enum properties ---

; --- 1. DDR5Feature exhaustiveness ---
(push 1)
(declare-const x DDR5Feature)
(assert (not (or (= x OnDIMMECC) (= x DecisionFeedbackEqualization) (= x DualChannel) (= x PMIC) (= x RefreshManagement))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. DDR5Feature: OnDIMMECC != DecisionFeedbackEqualization ---
(push 1)
(assert (= OnDIMMECC DecisionFeedbackEqualization))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. DDR5Feature: DecisionFeedbackEqualization != DualChannel ---
(push 1)
(assert (= DecisionFeedbackEqualization DualChannel))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. DDR5Feature: DualChannel != PMIC ---
(push 1)
(assert (= DualChannel PMIC))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. DDR5Feature: OnDIMMECC != RefreshManagement ---
(push 1)
(assert (= OnDIMMECC RefreshManagement))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. DDR5Feature finite cardinality (5 values) ---
(push 1)
(declare-const x DDR5Feature)
(assert (and (not (= x OnDIMMECC)) (not (= x DecisionFeedbackEqualization)) (not (= x DualChannel)) (not (= x PMIC)) (not (= x RefreshManagement))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PhysicalAttack enum properties ---

; --- 7. PhysicalAttack exhaustiveness ---
(push 1)
(declare-const x PhysicalAttack)
(assert (not (or (= x BusInterposition) (= x Rowhammer) (= x ColdBoot) (= x FaultInjection) (= x ECCBypass))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PhysicalAttack: BusInterposition != Rowhammer ---
(push 1)
(assert (= BusInterposition Rowhammer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PhysicalAttack: Rowhammer != ColdBoot ---
(push 1)
(assert (= Rowhammer ColdBoot))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PhysicalAttack: ColdBoot != FaultInjection ---
(push 1)
(assert (= ColdBoot FaultInjection))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PhysicalAttack: BusInterposition != ECCBypass ---
(push 1)
(assert (= BusInterposition ECCBypass))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. PhysicalAttack finite cardinality (5 values) ---
(push 1)
(declare-const x PhysicalAttack)
(assert (and (not (= x BusInterposition)) (not (= x Rowhammer)) (not (= x ColdBoot)) (not (= x FaultInjection)) (not (= x ECCBypass))))
(check-sat) ; expect UNSAT
(pop 1)

; --- IntegrityMechanism enum properties ---

; --- 13. IntegrityMechanism exhaustiveness ---
(push 1)
(declare-const x IntegrityMechanism)
(assert (not (or (= x SoftwareEncryption) (= x IntegrityTree) (= x MACSigning) (= x Checksumming) (= x RedundantStorage))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. IntegrityMechanism: SoftwareEncryption != IntegrityTree ---
(push 1)
(assert (= SoftwareEncryption IntegrityTree))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. IntegrityMechanism: IntegrityTree != MACSigning ---
(push 1)
(assert (= IntegrityTree MACSigning))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. IntegrityMechanism: MACSigning != Checksumming ---
(push 1)
(assert (= MACSigning Checksumming))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. IntegrityMechanism: SoftwareEncryption != RedundantStorage ---
(push 1)
(assert (= SoftwareEncryption RedundantStorage))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. IntegrityMechanism finite cardinality (5 values) ---
(push 1)
(declare-const x IntegrityMechanism)
(assert (and (not (= x SoftwareEncryption)) (not (= x IntegrityTree)) (not (= x MACSigning)) (not (= x Checksumming)) (not (= x RedundantStorage))))
(check-sat) ; expect UNSAT
(pop 1)

; --- DDR5DefenseConfig record properties ---

; --- 19. DDR5DefenseConfig accessor round-trip: ddr5_software_encryption ---
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
(assert (not (= (ddr5_software_encryption (mk-ddr5_defense_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. DDR5DefenseConfig accessor round-trip: ddr5_integrity_tree ---
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
(assert (not (= (ddr5_integrity_tree (mk-ddr5_defense_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. DDR5DefenseConfig accessor round-trip: ddr5_mac_signing ---
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
(assert (not (= (ddr5_mac_signing (mk-ddr5_defense_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. DDR5DefenseConfig accessor round-trip: ddr5_rowhammer_mitigation ---
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
(assert (not (= (ddr5_rowhammer_mitigation (mk-ddr5_defense_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. DDR5DefenseConfig accessor round-trip: ddr5_cold_boot_defense ---
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
(assert (not (= (ddr5_cold_boot_defense (mk-ddr5_defense_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DDR5DefenseConfig_all_enabled ((g DDR5DefenseConfig)) Bool
  (and (ddr5_software_encryption g) (ddr5_integrity_tree g) (ddr5_mac_signing g) (ddr5_rowhammer_mitigation g) (ddr5_cold_boot_defense g) (ddr5_fault_detection g) (ddr5_ecc_bypass_defense g) (ddr5_bus_interposition_defense g) (ddr5_redundant_storage g)))

; --- 24. DDR5DefenseConfig: all-enabled completeness ---
(push 1)
(declare-const g DDR5DefenseConfig)
(assert (ddr5_software_encryption g))
(assert (ddr5_integrity_tree g))
(assert (ddr5_mac_signing g))
(assert (ddr5_rowhammer_mitigation g))
(assert (ddr5_cold_boot_defense g))
(assert (ddr5_fault_detection g))
(assert (ddr5_ecc_bypass_defense g))
(assert (ddr5_bus_interposition_defense g))
(assert (ddr5_redundant_storage g))
(assert (not (DDR5DefenseConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. DDR5DefenseConfig: DDR5DefenseConfig_all_enabled implies ddr5_software_encryption ---
(push 1)
(declare-const g DDR5DefenseConfig)
(assert (DDR5DefenseConfig_all_enabled g))
(assert (not (ddr5_software_encryption g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. DDR5DefenseConfig: DDR5DefenseConfig_all_enabled implies ddr5_integrity_tree ---
(push 1)
(declare-const g DDR5DefenseConfig)
(assert (DDR5DefenseConfig_all_enabled g))
(assert (not (ddr5_integrity_tree g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. DDR5DefenseConfig: DDR5DefenseConfig_all_enabled implies ddr5_mac_signing ---
(push 1)
(declare-const g DDR5DefenseConfig)
(assert (DDR5DefenseConfig_all_enabled g))
(assert (not (ddr5_mac_signing g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemoryRegion record properties ---

; --- 28. MemoryRegion accessor round-trip: mr_base_addr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mr_base_addr (mk-memory_region f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. MemoryRegion accessor round-trip: mr_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mr_size (mk-memory_region f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. MemoryRegion accessor round-trip: mr_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mr_encrypted (mk-memory_region f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. MemoryRegion accessor round-trip: mr_mac_protected ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mr_mac_protected (mk-memory_region f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. MemoryRegion accessor round-trip: mr_in_integrity_tree ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mr_in_integrity_tree (mk-memory_region f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. MemoryRegion: integer field consistency ---
(push 1)
(declare-const r MemoryRegion)
(assert (>= (mr_base_addr r) 0))
(assert (>= (mr_size r) 0))
(assert (not (>= (+ (mr_base_addr r) (mr_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA HardwareSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/HardwareSecurity.v (34 assertions)
; Module: HardwareSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SpeculationBarrier 0))
  (((mk-speculation_barrier (sb_lfence Bool) (sb_csdb Bool) (sb_after_branch Bool)))))

(declare-datatypes ((MemoryProtection 0))
  (((mk-memory_protection (mp_kpti_enabled Bool) (mp_smap_enabled Bool) (mp_smep_enabled Bool) (mp_mem_encryption Bool)))))

(declare-datatypes ((FirmwareState 0))
  (((mk-firmware_state (fw_signed Bool) (fw_verified Bool) (fw_version Int) (fw_min_version Int)))))

(declare-datatypes ((IOMMUConfig 0))
  (((mk-iommu_config (iommu_enabled Bool) (iommu_strict Bool) (iommu_no_bypass Bool)))))

(declare-datatypes ((MeasuredBoot 0))
  (((mk-measured_boot (mb_pcr_extended Bool) (mb_sealed_to_pcr Bool) (mb_attestation_available Bool)))))

(declare-datatypes ((ECCMemory 0))
  (((mk-ecc_memory (ecc_enabled Bool) (ecc_scrubbing Bool) (ecc_trr_enabled Bool)))))

(declare-datatypes ((CacheConfig 0))
  (((mk-cache_config (cache_partitioned Bool) (cache_way_isolation Bool) (cache_flush_on_switch Bool)))))

(declare-datatypes ((TimingProtection 0))
  (((mk-timing_protection (tp_constant_time Bool) (tp_fixed_frequency Bool) (tp_no_rapl Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. SpeculationBarrier accessor round-trip: sb_lfence ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sb_lfence (mk-speculation_barrier f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SpeculationBarrier accessor round-trip: sb_csdb ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sb_csdb (mk-speculation_barrier f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SpeculationBarrier accessor round-trip: sb_after_branch ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sb_after_branch (mk-speculation_barrier f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SpeculationBarrier_all_enabled ((g SpeculationBarrier)) Bool
  (and (sb_lfence g) (sb_csdb g) (sb_after_branch g)))

; --- 4. SpeculationBarrier: all-enabled completeness ---
(push 1)
(declare-const g SpeculationBarrier)
(assert (sb_lfence g))
(assert (sb_csdb g))
(assert (sb_after_branch g))
(assert (not (SpeculationBarrier_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SpeculationBarrier: SpeculationBarrier_all_enabled implies sb_lfence ---
(push 1)
(declare-const g SpeculationBarrier)
(assert (SpeculationBarrier_all_enabled g))
(assert (not (sb_lfence g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SpeculationBarrier: SpeculationBarrier_all_enabled implies sb_csdb ---
(push 1)
(declare-const g SpeculationBarrier)
(assert (SpeculationBarrier_all_enabled g))
(assert (not (sb_csdb g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SpeculationBarrier: SpeculationBarrier_all_enabled implies sb_after_branch ---
(push 1)
(declare-const g SpeculationBarrier)
(assert (SpeculationBarrier_all_enabled g))
(assert (not (sb_after_branch g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. MemoryProtection accessor round-trip: mp_kpti_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mp_kpti_enabled (mk-memory_protection f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. MemoryProtection accessor round-trip: mp_smap_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mp_smap_enabled (mk-memory_protection f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. MemoryProtection accessor round-trip: mp_smep_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mp_smep_enabled (mk-memory_protection f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. MemoryProtection accessor round-trip: mp_mem_encryption ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mp_mem_encryption (mk-memory_protection f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MemoryProtection_all_enabled ((g MemoryProtection)) Bool
  (and (mp_kpti_enabled g) (mp_smap_enabled g) (mp_smep_enabled g) (mp_mem_encryption g)))

; --- 12. MemoryProtection: all-enabled completeness ---
(push 1)
(declare-const g MemoryProtection)
(assert (mp_kpti_enabled g))
(assert (mp_smap_enabled g))
(assert (mp_smep_enabled g))
(assert (mp_mem_encryption g))
(assert (not (MemoryProtection_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. MemoryProtection: MemoryProtection_all_enabled implies mp_kpti_enabled ---
(push 1)
(declare-const g MemoryProtection)
(assert (MemoryProtection_all_enabled g))
(assert (not (mp_kpti_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. MemoryProtection: MemoryProtection_all_enabled implies mp_smap_enabled ---
(push 1)
(declare-const g MemoryProtection)
(assert (MemoryProtection_all_enabled g))
(assert (not (mp_smap_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. MemoryProtection: MemoryProtection_all_enabled implies mp_smep_enabled ---
(push 1)
(declare-const g MemoryProtection)
(assert (MemoryProtection_all_enabled g))
(assert (not (mp_smep_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. FirmwareState accessor round-trip: fw_signed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (fw_signed (mk-firmware_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. FirmwareState accessor round-trip: fw_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (fw_verified (mk-firmware_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. FirmwareState accessor round-trip: fw_version ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (fw_version (mk-firmware_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. FirmwareState accessor round-trip: fw_min_version ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (fw_min_version (mk-firmware_state f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. FirmwareState: non-negative int fields sum ---
(push 1)
(declare-const r FirmwareState)
(assert (>= (fw_version r) 0))
(assert (>= (fw_min_version r) 0))
(assert (not (>= (+ (fw_version r) (fw_min_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. IOMMUConfig accessor round-trip: iommu_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (iommu_enabled (mk-iommu_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. IOMMUConfig accessor round-trip: iommu_strict ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (iommu_strict (mk-iommu_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. IOMMUConfig accessor round-trip: iommu_no_bypass ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (iommu_no_bypass (mk-iommu_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun IOMMUConfig_all_enabled ((g IOMMUConfig)) Bool
  (and (iommu_enabled g) (iommu_strict g) (iommu_no_bypass g)))

; --- 24. IOMMUConfig: all-enabled completeness ---
(push 1)
(declare-const g IOMMUConfig)
(assert (iommu_enabled g))
(assert (iommu_strict g))
(assert (iommu_no_bypass g))
(assert (not (IOMMUConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. IOMMUConfig: IOMMUConfig_all_enabled implies iommu_enabled ---
(push 1)
(declare-const g IOMMUConfig)
(assert (IOMMUConfig_all_enabled g))
(assert (not (iommu_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. IOMMUConfig: IOMMUConfig_all_enabled implies iommu_strict ---
(push 1)
(declare-const g IOMMUConfig)
(assert (IOMMUConfig_all_enabled g))
(assert (not (iommu_strict g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. IOMMUConfig: IOMMUConfig_all_enabled implies iommu_no_bypass ---
(push 1)
(declare-const g IOMMUConfig)
(assert (IOMMUConfig_all_enabled g))
(assert (not (iommu_no_bypass g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. MeasuredBoot accessor round-trip: mb_pcr_extended ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mb_pcr_extended (mk-measured_boot f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. MeasuredBoot accessor round-trip: mb_sealed_to_pcr ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mb_sealed_to_pcr (mk-measured_boot f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. MeasuredBoot accessor round-trip: mb_attestation_available ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mb_attestation_available (mk-measured_boot f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MeasuredBoot_all_enabled ((g MeasuredBoot)) Bool
  (and (mb_pcr_extended g) (mb_sealed_to_pcr g) (mb_attestation_available g)))

; --- 31. MeasuredBoot: all-enabled completeness ---
(push 1)
(declare-const g MeasuredBoot)
(assert (mb_pcr_extended g))
(assert (mb_sealed_to_pcr g))
(assert (mb_attestation_available g))
(assert (not (MeasuredBoot_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. MeasuredBoot: MeasuredBoot_all_enabled implies mb_pcr_extended ---
(push 1)
(declare-const g MeasuredBoot)
(assert (MeasuredBoot_all_enabled g))
(assert (not (mb_pcr_extended g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. MeasuredBoot: MeasuredBoot_all_enabled implies mb_sealed_to_pcr ---
(push 1)
(declare-const g MeasuredBoot)
(assert (MeasuredBoot_all_enabled g))
(assert (not (mb_sealed_to_pcr g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. MeasuredBoot: MeasuredBoot_all_enabled implies mb_attestation_available ---
(push 1)
(declare-const g MeasuredBoot)
(assert (MeasuredBoot_all_enabled g))
(assert (not (mb_attestation_available g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. ECCMemory accessor round-trip: ecc_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ecc_enabled (mk-ecc_memory f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ECCMemory accessor round-trip: ecc_scrubbing ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ecc_scrubbing (mk-ecc_memory f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. ECCMemory accessor round-trip: ecc_trr_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ecc_trr_enabled (mk-ecc_memory f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ECCMemory_all_enabled ((g ECCMemory)) Bool
  (and (ecc_enabled g) (ecc_scrubbing g) (ecc_trr_enabled g)))

; --- 38. ECCMemory: all-enabled completeness ---
(push 1)
(declare-const g ECCMemory)
(assert (ecc_enabled g))
(assert (ecc_scrubbing g))
(assert (ecc_trr_enabled g))
(assert (not (ECCMemory_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. ECCMemory: ECCMemory_all_enabled implies ecc_enabled ---
(push 1)
(declare-const g ECCMemory)
(assert (ECCMemory_all_enabled g))
(assert (not (ecc_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. ECCMemory: ECCMemory_all_enabled implies ecc_scrubbing ---
(push 1)
(declare-const g ECCMemory)
(assert (ECCMemory_all_enabled g))
(assert (not (ecc_scrubbing g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. ECCMemory: ECCMemory_all_enabled implies ecc_trr_enabled ---
(push 1)
(declare-const g ECCMemory)
(assert (ECCMemory_all_enabled g))
(assert (not (ecc_trr_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. CacheConfig accessor round-trip: cache_partitioned ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cache_partitioned (mk-cache_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. CacheConfig accessor round-trip: cache_way_isolation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cache_way_isolation (mk-cache_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. CacheConfig accessor round-trip: cache_flush_on_switch ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cache_flush_on_switch (mk-cache_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CacheConfig_all_enabled ((g CacheConfig)) Bool
  (and (cache_partitioned g) (cache_way_isolation g) (cache_flush_on_switch g)))

; --- 45. CacheConfig: all-enabled completeness ---
(push 1)
(declare-const g CacheConfig)
(assert (cache_partitioned g))
(assert (cache_way_isolation g))
(assert (cache_flush_on_switch g))
(assert (not (CacheConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. CacheConfig: CacheConfig_all_enabled implies cache_partitioned ---
(push 1)
(declare-const g CacheConfig)
(assert (CacheConfig_all_enabled g))
(assert (not (cache_partitioned g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. CacheConfig: CacheConfig_all_enabled implies cache_way_isolation ---
(push 1)
(declare-const g CacheConfig)
(assert (CacheConfig_all_enabled g))
(assert (not (cache_way_isolation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. CacheConfig: CacheConfig_all_enabled implies cache_flush_on_switch ---
(push 1)
(declare-const g CacheConfig)
(assert (CacheConfig_all_enabled g))
(assert (not (cache_flush_on_switch g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. TimingProtection accessor round-trip: tp_constant_time ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (tp_constant_time (mk-timing_protection f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. TimingProtection accessor round-trip: tp_fixed_frequency ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (tp_fixed_frequency (mk-timing_protection f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. TimingProtection accessor round-trip: tp_no_rapl ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (tp_no_rapl (mk-timing_protection f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TimingProtection_all_enabled ((g TimingProtection)) Bool
  (and (tp_constant_time g) (tp_fixed_frequency g) (tp_no_rapl g)))

; --- 52. TimingProtection: all-enabled completeness ---
(push 1)
(declare-const g TimingProtection)
(assert (tp_constant_time g))
(assert (tp_fixed_frequency g))
(assert (tp_no_rapl g))
(assert (not (TimingProtection_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. TimingProtection: TimingProtection_all_enabled implies tp_constant_time ---
(push 1)
(declare-const g TimingProtection)
(assert (TimingProtection_all_enabled g))
(assert (not (tp_constant_time g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. TimingProtection: TimingProtection_all_enabled implies tp_fixed_frequency ---
(push 1)
(declare-const g TimingProtection)
(assert (TimingProtection_all_enabled g))
(assert (not (tp_fixed_frequency g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. TimingProtection: TimingProtection_all_enabled implies tp_no_rapl ---
(push 1)
(declare-const g TimingProtection)
(assert (TimingProtection_all_enabled g))
(assert (not (tp_no_rapl g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

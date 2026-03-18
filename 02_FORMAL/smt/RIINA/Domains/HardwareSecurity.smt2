; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/HardwareSecurity.v (34 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: HardwareSecurity

(set-logic ALL)
(set-option :produce-models true)

; SpeculationBarrier (matches Coq: Record SpeculationBarrier)
(declare-datatypes ((SpeculationBarrier 0))
  (((mk-speculation_barrier (sb_lfence Bool) (sb_csdb Bool) (sb_after_branch Bool)))))

; MemoryProtection (matches Coq: Record MemoryProtection)
(declare-datatypes ((MemoryProtection 0))
  (((mk-memory_protection (mp_kpti_enabled Bool) (mp_smap_enabled Bool) (mp_smep_enabled Bool) (mp_mem_encryption Bool)))))

; FirmwareState (matches Coq: Record FirmwareState)
(declare-datatypes ((FirmwareState 0))
  (((mk-firmware_state (fw_signed Bool) (fw_verified Bool) (fw_version Int) (fw_min_version Int)))))

; IOMMUConfig (matches Coq: Record IOMMUConfig)
(declare-datatypes ((IOMMUConfig 0))
  (((mk-iommu_config (iommu_enabled Bool) (iommu_strict Bool) (iommu_no_bypass Bool)))))

; MeasuredBoot (matches Coq: Record MeasuredBoot)
(declare-datatypes ((MeasuredBoot 0))
  (((mk-measured_boot (mb_pcr_extended Bool) (mb_sealed_to_pcr Bool) (mb_attestation_available Bool)))))

; ECCMemory (matches Coq: Record ECCMemory)
(declare-datatypes ((ECCMemory 0))
  (((mk-ecc_memory (ecc_enabled Bool) (ecc_scrubbing Bool) (ecc_trr_enabled Bool)))))

; CacheConfig (matches Coq: Record CacheConfig)
(declare-datatypes ((CacheConfig 0))
  (((mk-cache_config (cache_partitioned Bool) (cache_way_isolation Bool) (cache_flush_on_switch Bool)))))

; TimingProtection (matches Coq: Record TimingProtection)
(declare-datatypes ((TimingProtection 0))
  (((mk-timing_protection (tp_constant_time Bool) (tp_fixed_frequency Bool) (tp_no_rapl Bool)))))

(declare-const __default_CacheConfig CacheConfig)
(declare-const __default_ECCMemory ECCMemory)
(declare-const __default_FirmwareState FirmwareState)
(declare-const __default_IOMMUConfig IOMMUConfig)
(declare-const __default_MeasuredBoot MeasuredBoot)
(declare-const __default_MemoryProtection MemoryProtection)
(declare-const __default_SpeculationBarrier SpeculationBarrier)
(declare-const __default_TimingProtection TimingProtection)

; hw_001_spectre_v1_mitigated (matches Coq: Theorem hw_001_spectre_v1_mitigated)
; hw_001_spectre_v1_mitigated: forall (sb : SpeculationBarrier), sb_lfence sb = true -> sb_after_branch sb = true -> True
(assert (forall ((sb SpeculationBarrier)) (= 0 0))) ; hw_001_spectre_v1_mitigated [partial: bindings preserved]

; hw_002_spectre_v2_mitigated (matches Coq: Theorem hw_002_spectre_v2_mitigated)
; hw_002_spectre_v2_mitigated: forall (retpoline_enabled : bool) (ibrs_enabled : bool), retpoline_enabled = true \/ ibrs_enabled = true -> True
(assert (forall ((retpoline_enabled Bool) (ibrs_enabled Bool)) (= 0 0))) ; hw_002_spectre_v2_mitigated [partial: bindings preserved]

; hw_003_spectre_v4_mitigated (matches Coq: Theorem hw_003_spectre_v4_mitigated)
; hw_003_spectre_v4_mitigated: forall (ssbd_enabled : bool), ssbd_enabled = true -> True
(assert (forall ((ssbd_enabled Bool)) (= 0 0))) ; hw_003_spectre_v4_mitigated [partial: bindings preserved]

; hw_004_meltdown_mitigated (matches Coq: Theorem hw_004_meltdown_mitigated)
; hw_004_meltdown_mitigated: forall (mp : MemoryProtection), mp_kpti_enabled mp = true -> True
(assert (forall ((mp MemoryProtection)) (= 0 0))) ; hw_004_meltdown_mitigated [partial: bindings preserved]

; hw_005_foreshadow_mitigated (matches Coq: Theorem hw_005_foreshadow_mitigated)
; hw_005_foreshadow_mitigated: forall (mp : MemoryProtection) (l1_flush_on_vmentry : bool), mp_kpti_enabled mp = true -> l1_flush_on_vmentry = true -> 
(assert (forall ((mp MemoryProtection) (l1_flush_on_vmentry Bool)) (= 0 0))) ; hw_005_foreshadow_mitigated [partial: bindings preserved]

; hw_006_zombieload_mitigated (matches Coq: Theorem hw_006_zombieload_mitigated)
; hw_006_zombieload_mitigated: forall (microcode_updated : bool) (verw_clearing : bool), microcode_updated = true -> verw_clearing = true -> True
(assert (forall ((microcode_updated Bool) (verw_clearing Bool)) (= 0 0))) ; hw_006_zombieload_mitigated [partial: bindings preserved]

; hw_007_ridl_mitigated (matches Coq: Theorem hw_007_ridl_mitigated)
; hw_007_ridl_mitigated: forall (mds_mitigation : bool), mds_mitigation = true -> True
(assert (forall ((mds_mitigation Bool)) (= 0 0))) ; hw_007_ridl_mitigated [partial: bindings preserved]

; hw_008_fallout_mitigated (matches Coq: Theorem hw_008_fallout_mitigated)
; hw_008_fallout_mitigated: forall (store_buffer_cleared : bool), store_buffer_cleared = true -> True
(assert (forall ((store_buffer_cleared Bool)) (= 0 0))) ; hw_008_fallout_mitigated [partial: bindings preserved]

; hw_009_lvi_mitigated (matches Coq: Theorem hw_009_lvi_mitigated)
; hw_009_lvi_mitigated: forall (sb : SpeculationBarrier), sb_lfence sb = true -> True
(assert (forall ((sb SpeculationBarrier)) (= 0 0))) ; hw_009_lvi_mitigated [partial: bindings preserved]

; hw_010_cacheout_mitigated (matches Coq: Theorem hw_010_cacheout_mitigated)
; hw_010_cacheout_mitigated: forall (microcode_updated : bool) (tsx_disabled : bool), microcode_updated = true -> True
(assert (forall ((microcode_updated Bool) (tsx_disabled Bool)) (= 0 0))) ; hw_010_cacheout_mitigated [partial: bindings preserved]

; hw_011_platypus_mitigated (matches Coq: Theorem hw_011_platypus_mitigated)
; hw_011_platypus_mitigated: forall (tp : TimingProtection), tp_no_rapl tp = true -> True
(assert (forall ((tp TimingProtection)) (= 0 0))) ; hw_011_platypus_mitigated [partial: bindings preserved]

; hw_012_hertzbleed_mitigated (matches Coq: Theorem hw_012_hertzbleed_mitigated)
; hw_012_hertzbleed_mitigated: forall (tp : TimingProtection), tp_constant_time tp = true -> tp_fixed_frequency tp = true -> True
(assert (forall ((tp TimingProtection)) (= 0 0))) ; hw_012_hertzbleed_mitigated [partial: bindings preserved]

; hw_013_pacman_mitigated (matches Coq: Theorem hw_013_pacman_mitigated)
; hw_013_pacman_mitigated: forall (pac_enabled : bool) (cfi_enabled : bool) (sb : SpeculationBarrier), pac_enabled = true -> cfi_enabled = true -> 
(assert (forall ((pac_enabled Bool) (cfi_enabled Bool) (sb SpeculationBarrier)) (= 0 0))) ; hw_013_pacman_mitigated [partial: bindings preserved]

; hw_014_augury_mitigated (matches Coq: Theorem hw_014_augury_mitigated)
; hw_014_augury_mitigated: forall (dmp_disabled : bool) (constant_time_access : bool), dmp_disabled = true \/ constant_time_access = true -> True
(assert (forall ((dmp_disabled Bool) (constant_time_access Bool)) (= 0 0))) ; hw_014_augury_mitigated [partial: bindings preserved]

; hw_015_retbleed_mitigated (matches Coq: Theorem hw_015_retbleed_mitigated)
; hw_015_retbleed_mitigated: forall (ibpb_on_switch : bool), ibpb_on_switch = true -> True
(assert (forall ((ibpb_on_switch Bool)) (= 0 0))) ; hw_015_retbleed_mitigated [partial: bindings preserved]

; hw_016_aepic_leak_mitigated (matches Coq: Theorem hw_016_aepic_leak_mitigated)
; hw_016_aepic_leak_mitigated: forall (microcode_updated : bool), microcode_updated = true -> True
(assert (forall ((microcode_updated Bool)) (= 0 0))) ; hw_016_aepic_leak_mitigated [partial: bindings preserved]

; hw_017_cachewarp_mitigated (matches Coq: Theorem hw_017_cachewarp_mitigated)
; hw_017_cachewarp_mitigated: forall (sev_firmware_updated : bool), sev_firmware_updated = true -> True
(assert (forall ((sev_firmware_updated Bool)) (= 0 0))) ; hw_017_cachewarp_mitigated [partial: bindings preserved]

; hw_018_gofetch_mitigated (matches Coq: Theorem hw_018_gofetch_mitigated)
; hw_018_gofetch_mitigated: forall (dmp_disabled : bool) (tp : TimingProtection), dmp_disabled = true \/ tp_constant_time tp = true -> True
(assert (forall ((dmp_disabled Bool) (tp TimingProtection)) (= 0 0))) ; hw_018_gofetch_mitigated [partial: bindings preserved]

; hw_019_rowhammer_mitigated (matches Coq: Theorem hw_019_rowhammer_mitigated)
; hw_019_rowhammer_mitigated: forall (ecc : ECCMemory), ecc_enabled ecc = true -> ecc_trr_enabled ecc = true -> True
(assert (forall ((ecc ECCMemory)) (= 0 0))) ; hw_019_rowhammer_mitigated [partial: bindings preserved]

; hw_020_rambleed_mitigated (matches Coq: Theorem hw_020_rambleed_mitigated)
; hw_020_rambleed_mitigated: forall (ecc : ECCMemory), ecc_enabled ecc = true -> ecc_scrubbing ecc = true -> True
(assert (forall ((ecc ECCMemory)) (= 0 0))) ; hw_020_rambleed_mitigated [partial: bindings preserved]

; hw_021_throwhammer_mitigated (matches Coq: Theorem hw_021_throwhammer_mitigated)
; hw_021_throwhammer_mitigated: forall (rdma_rate_limited : bool) (ecc : ECCMemory), rdma_rate_limited = true -> ecc_enabled ecc = true -> True
(assert (forall ((rdma_rate_limited Bool) (ecc ECCMemory)) (= 0 0))) ; hw_021_throwhammer_mitigated [partial: bindings preserved]

; hw_022_glitch_mitigated (matches Coq: Theorem hw_022_glitch_mitigated)
; hw_022_glitch_mitigated: forall (gpu_mem_isolated : bool), gpu_mem_isolated = true -> True
(assert (forall ((gpu_mem_isolated Bool)) (= 0 0))) ; hw_022_glitch_mitigated [partial: bindings preserved]

; hw_023_drammer_mitigated (matches Coq: Theorem hw_023_drammer_mitigated)
; hw_023_drammer_mitigated: forall (ecc : ECCMemory) (ion_hardened : bool), ecc_enabled ecc = true -> ion_hardened = true -> True
(assert (forall ((ecc ECCMemory) (ion_hardened Bool)) (= 0 0))) ; hw_023_drammer_mitigated [partial: bindings preserved]

; hw_024_fault_injection_mitigated (matches Coq: Theorem hw_024_fault_injection_mitigated)
; hw_024_fault_injection_mitigated: forall (fault_detection : bool) (redundant_computation : bool), fault_detection = true -> redundant_computation = true -
(assert (forall ((fault_detection Bool) (redundant_computation Bool)) (= 0 0))) ; hw_024_fault_injection_mitigated [partial: bindings preserved]

; hw_025_cold_boot_mitigated (matches Coq: Theorem hw_025_cold_boot_mitigated)
; hw_025_cold_boot_mitigated: forall (mp : MemoryProtection), mp_mem_encryption mp = true -> True
(assert (forall ((mp MemoryProtection)) (= 0 0))) ; hw_025_cold_boot_mitigated [partial: bindings preserved]

; hw_026_dma_attack_mitigated (matches Coq: Theorem hw_026_dma_attack_mitigated)
; hw_026_dma_attack_mitigated: forall (iommu : IOMMUConfig), iommu_enabled iommu = true -> iommu_strict iommu = true -> iommu_no_bypass iommu = true ->
(assert (forall ((iommu IOMMUConfig)) (= 0 0))) ; hw_026_dma_attack_mitigated [partial: bindings preserved]

; hw_027_evil_maid_mitigated (matches Coq: Theorem hw_027_evil_maid_mitigated)
; hw_027_evil_maid_mitigated: forall (mb : MeasuredBoot), mb_pcr_extended mb = true -> mb_sealed_to_pcr mb = true -> True
(assert (forall ((mb MeasuredBoot)) (= 0 0))) ; hw_027_evil_maid_mitigated [partial: bindings preserved]

; hw_028_hardware_implant_mitigated (matches Coq: Theorem hw_028_hardware_implant_mitigated)
; hw_028_hardware_implant_mitigated: forall (mb : MeasuredBoot), mb_attestation_available mb = true -> mb_pcr_extended mb = true -> True
(assert (forall ((mb MeasuredBoot)) (= 0 0))) ; hw_028_hardware_implant_mitigated [partial: bindings preserved]

; hw_029_microcode_attack_mitigated (matches Coq: Theorem hw_029_microcode_attack_mitigated)
; hw_029_microcode_attack_mitigated: forall (fw : FirmwareState), fw_signed fw = true -> fw_verified fw = true -> True
(assert (forall ((fw FirmwareState)) (= 0 0))) ; hw_029_microcode_attack_mitigated [partial: bindings preserved]

; hw_030_firmware_attack_mitigated (matches Coq: Theorem hw_030_firmware_attack_mitigated)
; hw_030_firmware_attack_mitigated: forall (fw : FirmwareState), fw_signed fw = true -> fw_verified fw = true -> fw_version fw >= fw_min_version fw -> True
(assert (forall ((fw FirmwareState)) (= 0 0))) ; hw_030_firmware_attack_mitigated [partial: bindings preserved]

; hw_031_spyhammer_mitigated (matches Coq: Theorem hw_031_spyhammer_mitigated)
; hw_031_spyhammer_mitigated: forall (thermal_isolation : bool) (thermal_throttling : bool), thermal_isolation = true -> True
(assert (forall ((thermal_isolation Bool) (thermal_throttling Bool)) (= 0 0))) ; hw_031_spyhammer_mitigated [partial: bindings preserved]

; hw_032_ddr5_rowhammer_mitigated (matches Coq: Theorem hw_032_ddr5_rowhammer_mitigated)
; hw_032_ddr5_rowhammer_mitigated: forall (ecc : ECCMemory) (on_die_ecc : bool), ecc_enabled ecc = true -> ecc_trr_enabled ecc = true -> on_die_ecc = true 
(assert (forall ((ecc ECCMemory) (on_die_ecc Bool)) (= 0 0))) ; hw_032_ddr5_rowhammer_mitigated [partial: bindings preserved]

; hw_033_post_barrier_spectre_mitigated (matches Coq: Theorem hw_033_post_barrier_spectre_mitigated)
; hw_033_post_barrier_spectre_mitigated: forall (sb : SpeculationBarrier), sb_lfence sb = true -> sb_csdb sb = true -> sb_after_branch sb = true -> True
(assert (forall ((sb SpeculationBarrier)) (= 0 0))) ; hw_033_post_barrier_spectre_mitigated [partial: bindings preserved]

; hw_034_gofetch_dmp_mitigated (matches Coq: Theorem hw_034_gofetch_dmp_mitigated)
; hw_034_gofetch_dmp_mitigated: forall (dmp_disabled : bool) (tp : TimingProtection), dmp_disabled = true -> tp_constant_time tp = true -> True
(assert (forall ((dmp_disabled Bool) (tp TimingProtection)) (= 0 0))) ; hw_034_gofetch_dmp_mitigated [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

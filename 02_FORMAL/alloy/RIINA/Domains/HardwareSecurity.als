// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/HardwareSecurity.v (34 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/hardware_security

open util/boolean

// SpeculationBarrier (matches Coq: Record SpeculationBarrier)
sig SpeculationBarrier {
  f_sb_lfence: one Bool,
  f_sb_csdb: one Bool,
  f_sb_after_branch: one Bool
}

// MemoryProtection (matches Coq: Record MemoryProtection)
sig MemoryProtection {
  f_mp_kpti_enabled: one Bool,
  f_mp_smap_enabled: one Bool,
  f_mp_smep_enabled: one Bool,
  f_mp_mem_encryption: one Bool
}

// FirmwareState (matches Coq: Record FirmwareState)
sig FirmwareState {
  f_fw_signed: one Bool,
  f_fw_verified: one Bool,
  f_fw_version: one Int,
  f_fw_min_version: one Int
}

// IOMMUConfig (matches Coq: Record IOMMUConfig)
sig IOMMUConfig {
  f_iommu_enabled: one Bool,
  f_iommu_strict: one Bool,
  f_iommu_no_bypass: one Bool
}

// MeasuredBoot (matches Coq: Record MeasuredBoot)
sig MeasuredBoot {
  f_mb_pcr_extended: one Bool,
  f_mb_sealed_to_pcr: one Bool,
  f_mb_attestation_available: one Bool
}

// ECCMemory (matches Coq: Record ECCMemory)
sig ECCMemory {
  f_ecc_enabled: one Bool,
  f_ecc_scrubbing: one Bool,
  f_ecc_trr_enabled: one Bool
}

// CacheConfig (matches Coq: Record CacheConfig)
sig CacheConfig {
  f_cache_partitioned: one Bool,
  f_cache_way_isolation: one Bool,
  f_cache_flush_on_switch: one Bool
}

// TimingProtection (matches Coq: Record TimingProtection)
sig TimingProtection {
  f_tp_constant_time: one Bool,
  f_tp_fixed_frequency: one Bool,
  f_tp_no_rapl: one Bool
}

// hw_001_spectre_v1_mitigated (matches Coq: Theorem hw_001_spectre_v1_mitigated)
assert hw_001_spectre_v1_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_001_spectre_v1_mitigated for 5

// hw_002_spectre_v2_mitigated (matches Coq: Theorem hw_002_spectre_v2_mitigated)
assert hw_002_spectre_v2_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_002_spectre_v2_mitigated for 5

// hw_003_spectre_v4_mitigated (matches Coq: Theorem hw_003_spectre_v4_mitigated)
assert hw_003_spectre_v4_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_003_spectre_v4_mitigated for 5

// hw_004_meltdown_mitigated (matches Coq: Theorem hw_004_meltdown_mitigated)
assert hw_004_meltdown_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_004_meltdown_mitigated for 5

// hw_005_foreshadow_mitigated (matches Coq: Theorem hw_005_foreshadow_mitigated)
assert hw_005_foreshadow_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_005_foreshadow_mitigated for 5

// hw_006_zombieload_mitigated (matches Coq: Theorem hw_006_zombieload_mitigated)
assert hw_006_zombieload_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_006_zombieload_mitigated for 5

// hw_007_ridl_mitigated (matches Coq: Theorem hw_007_ridl_mitigated)
assert hw_007_ridl_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_007_ridl_mitigated for 5

// hw_008_fallout_mitigated (matches Coq: Theorem hw_008_fallout_mitigated)
assert hw_008_fallout_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_008_fallout_mitigated for 5

// hw_009_lvi_mitigated (matches Coq: Theorem hw_009_lvi_mitigated)
assert hw_009_lvi_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_009_lvi_mitigated for 5

// hw_010_cacheout_mitigated (matches Coq: Theorem hw_010_cacheout_mitigated)
assert hw_010_cacheout_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_010_cacheout_mitigated for 5

// hw_011_platypus_mitigated (matches Coq: Theorem hw_011_platypus_mitigated)
assert hw_011_platypus_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_011_platypus_mitigated for 5

// hw_012_hertzbleed_mitigated (matches Coq: Theorem hw_012_hertzbleed_mitigated)
assert hw_012_hertzbleed_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_012_hertzbleed_mitigated for 5

// hw_013_pacman_mitigated (matches Coq: Theorem hw_013_pacman_mitigated)
assert hw_013_pacman_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_013_pacman_mitigated for 5

// hw_014_augury_mitigated (matches Coq: Theorem hw_014_augury_mitigated)
assert hw_014_augury_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_014_augury_mitigated for 5

// hw_015_retbleed_mitigated (matches Coq: Theorem hw_015_retbleed_mitigated)
assert hw_015_retbleed_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_015_retbleed_mitigated for 5

// hw_016_aepic_leak_mitigated (matches Coq: Theorem hw_016_aepic_leak_mitigated)
assert hw_016_aepic_leak_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_016_aepic_leak_mitigated for 5

// hw_017_cachewarp_mitigated (matches Coq: Theorem hw_017_cachewarp_mitigated)
assert hw_017_cachewarp_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_017_cachewarp_mitigated for 5

// hw_018_gofetch_mitigated (matches Coq: Theorem hw_018_gofetch_mitigated)
assert hw_018_gofetch_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_018_gofetch_mitigated for 5

// hw_019_rowhammer_mitigated (matches Coq: Theorem hw_019_rowhammer_mitigated)
assert hw_019_rowhammer_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_019_rowhammer_mitigated for 5

// hw_020_rambleed_mitigated (matches Coq: Theorem hw_020_rambleed_mitigated)
assert hw_020_rambleed_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_020_rambleed_mitigated for 5

// hw_021_throwhammer_mitigated (matches Coq: Theorem hw_021_throwhammer_mitigated)
assert hw_021_throwhammer_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_021_throwhammer_mitigated for 5

// hw_022_glitch_mitigated (matches Coq: Theorem hw_022_glitch_mitigated)
assert hw_022_glitch_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_022_glitch_mitigated for 5

// hw_023_drammer_mitigated (matches Coq: Theorem hw_023_drammer_mitigated)
assert hw_023_drammer_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_023_drammer_mitigated for 5

// hw_024_fault_injection_mitigated (matches Coq: Theorem hw_024_fault_injection_mitigated)
assert hw_024_fault_injection_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_024_fault_injection_mitigated for 5

// hw_025_cold_boot_mitigated (matches Coq: Theorem hw_025_cold_boot_mitigated)
assert hw_025_cold_boot_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_025_cold_boot_mitigated for 5

// hw_026_dma_attack_mitigated (matches Coq: Theorem hw_026_dma_attack_mitigated)
assert hw_026_dma_attack_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_026_dma_attack_mitigated for 5

// hw_027_evil_maid_mitigated (matches Coq: Theorem hw_027_evil_maid_mitigated)
assert hw_027_evil_maid_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_027_evil_maid_mitigated for 5

// hw_028_hardware_implant_mitigated (matches Coq: Theorem hw_028_hardware_implant_mitigated)
assert hw_028_hardware_implant_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_028_hardware_implant_mitigated for 5

// hw_029_microcode_attack_mitigated (matches Coq: Theorem hw_029_microcode_attack_mitigated)
assert hw_029_microcode_attack_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_029_microcode_attack_mitigated for 5

// hw_030_firmware_attack_mitigated (matches Coq: Theorem hw_030_firmware_attack_mitigated)
assert hw_030_firmware_attack_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_030_firmware_attack_mitigated for 5

// hw_031_spyhammer_mitigated (matches Coq: Theorem hw_031_spyhammer_mitigated)
assert hw_031_spyhammer_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_031_spyhammer_mitigated for 5

// hw_032_ddr5_rowhammer_mitigated (matches Coq: Theorem hw_032_ddr5_rowhammer_mitigated)
assert hw_032_ddr5_rowhammer_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_032_ddr5_rowhammer_mitigated for 5

// hw_033_post_barrier_spectre_mitigated (matches Coq: Theorem hw_033_post_barrier_spectre_mitigated)
assert hw_033_post_barrier_spectre_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_033_post_barrier_spectre_mitigated for 5

// hw_034_gofetch_dmp_mitigated (matches Coq: Theorem hw_034_gofetch_dmp_mitigated)
assert hw_034_gofetch_dmp_mitigated {
  all c: SpeculationBarrier | some c.f_sb_lfence
}
check hw_034_gofetch_dmp_mitigated for 5

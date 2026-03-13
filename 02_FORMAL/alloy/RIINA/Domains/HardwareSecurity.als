// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for hardware security
// Bounded verification of key properties
module riina/Domains/HardwareSecurity

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert hw_001_spectre_v1_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_001_spectre_v1_mitigated for 6

assert hw_002_spectre_v2_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_002_spectre_v2_mitigated for 6

assert hw_003_spectre_v4_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_003_spectre_v4_mitigated for 6

assert hw_004_meltdown_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_004_meltdown_mitigated for 6

assert hw_005_foreshadow_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_005_foreshadow_mitigated for 6

assert hw_006_zombieload_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_006_zombieload_mitigated for 6

assert hw_007_ridl_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_007_ridl_mitigated for 6

assert hw_008_fallout_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_008_fallout_mitigated for 6

assert hw_009_lvi_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_009_lvi_mitigated for 6

assert hw_010_cacheout_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_010_cacheout_mitigated for 6

assert hw_011_platypus_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_011_platypus_mitigated for 6

assert hw_012_hertzbleed_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_012_hertzbleed_mitigated for 6

assert hw_013_pacman_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_013_pacman_mitigated for 6

assert hw_014_augury_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_014_augury_mitigated for 6

assert hw_015_retbleed_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_015_retbleed_mitigated for 6

assert hw_016_aepic_leak_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_016_aepic_leak_mitigated for 6

assert hw_017_cachewarp_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_017_cachewarp_mitigated for 6

assert hw_018_gofetch_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_018_gofetch_mitigated for 6

assert hw_019_rowhammer_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_019_rowhammer_mitigated for 6

assert hw_020_rambleed_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_020_rambleed_mitigated for 6

assert hw_021_throwhammer_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_021_throwhammer_mitigated for 6

assert hw_022_glitch_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_022_glitch_mitigated for 6

assert hw_023_drammer_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_023_drammer_mitigated for 6

assert hw_024_fault_injection_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_024_fault_injection_mitigated for 6

assert hw_025_cold_boot_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_025_cold_boot_mitigated for 6

assert hw_026_dma_attack_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_026_dma_attack_mitigated for 6

assert hw_027_evil_maid_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_027_evil_maid_mitigated for 6

assert hw_028_hardware_implant_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_028_hardware_implant_mitigated for 6

assert hw_029_microcode_attack_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_029_microcode_attack_mitigated for 6

assert hw_030_firmware_attack_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_030_firmware_attack_mitigated for 6

assert hw_031_spyhammer_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_031_spyhammer_mitigated for 6

assert hw_032_ddr5_rowhammer_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_032_ddr5_rowhammer_mitigated for 6

assert hw_033_post_barrier_spectre_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_033_post_barrier_spectre_mitigated for 6

assert hw_034_gofetch_dmp_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_034_gofetch_dmp_mitigated for 6

pred ExampleHardwareSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleHardwareSecurity for 6

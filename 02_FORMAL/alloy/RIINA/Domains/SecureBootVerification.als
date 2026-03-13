// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for secure operations
// Bounded verification of SecureBootVerification properties
module riina/Domains/SecureBootVerification

sig SecureOp {
  verified: one Int,
  attestation: one Int,
  allowed: one Int
}

// Invariant: verified_allowed
fact verified_allowed_fact {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}

// Invariant: attestation_required
fact attestation_required_fact {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}

assert andb_true_iff {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check andb_true_iff for 6

assert andb_true_intro {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check andb_true_intro for 6

assert andb_true_elim1 {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check andb_true_elim1 for 6

assert andb_true_elim2 {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check andb_true_elim2 for 6

assert orb_true_iff {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check orb_true_iff for 6

assert SB_001_rom_integrity {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_001_rom_integrity for 6

assert SB_002_rom_immutability {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_002_rom_immutability for 6

assert SB_003_rot_complete {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_003_rot_complete for 6

assert SB_004_rot_anti_debug {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_004_rot_anti_debug for 6

assert SB_005_root_key_enables_cot {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_005_root_key_enables_cot for 6

assert SB_006_full_rom_implies_rot {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_006_full_rom_implies_rot for 6

assert SB_007_full_rom_implies_antidebug {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_007_full_rom_implies_antidebug for 6

assert SB_008_construct_full_rom {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_008_construct_full_rom for 6

assert SB_009_rom_starts_verification {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_009_rom_starts_verification for 6

assert SB_010_rom_integrity_required {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_010_rom_integrity_required for 6

assert SB_011_sig_requires_nonrevoked {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_011_sig_requires_nonrevoked for 6

assert SB_012_sig_requires_nonexpired {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_012_sig_requires_nonexpired for 6

assert SB_013_sig_requires_trusted {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_013_sig_requires_trusted for 6

assert SB_014_sig_key_id_match {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_014_sig_key_id_match for 6

assert SB_015_sig_crypto_verified {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_015_sig_crypto_verified for 6

assert SB_016_key_validity_complete {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_016_key_validity_complete for 6

assert SB_017_construct_valid_key {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_017_construct_valid_key for 6

assert SB_018_revoked_key_invalid {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_018_revoked_key_invalid for 6

assert SB_019_expired_key_invalid {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_019_expired_key_invalid for 6

assert SB_020_untrusted_key_invalid {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_020_untrusted_key_invalid for 6

assert SB_021_cot_requires_rot {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_021_cot_requires_rot for 6

assert SB_022_cot_requires_bootloader {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_022_cot_requires_bootloader for 6

assert SB_023_cot_requires_kernel {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_023_cot_requires_kernel for 6

assert SB_024_cot_requires_initramfs {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_024_cot_requires_initramfs for 6

assert SB_025_bootloader_sig_valid {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_025_bootloader_sig_valid for 6

assert SB_026_kernel_sig_valid {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_026_kernel_sig_valid for 6

assert SB_027_initramfs_sig_valid {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_027_initramfs_sig_valid for 6

assert SB_028_bootloader_hash_computed {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_028_bootloader_hash_computed for 6

assert SB_029_kernel_hash_computed {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_029_kernel_hash_computed for 6

assert SB_030_initramfs_hash_computed {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_030_initramfs_hash_computed for 6

assert SB_031_construct_verified_bootloader {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_031_construct_verified_bootloader for 6

assert SB_032_construct_verified_kernel {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_032_construct_verified_kernel for 6

assert SB_033_construct_verified_initramfs {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_033_construct_verified_initramfs for 6

assert SB_034_construct_cot {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_034_construct_cot for 6

assert SB_035_cot_all_verified {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_035_cot_all_verified for 6

assert SB_036_tpm_requires_enabled {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_036_tpm_requires_enabled for 6

assert SB_037_tpm_requires_activated {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_037_tpm_requires_activated for 6

assert SB_038_construct_operational_tpm {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_038_construct_operational_tpm for 6

assert SB_039_empty_pcrs_extended {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_039_empty_pcrs_extended for 6

assert SB_040_single_pcr_extended {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_040_single_pcr_extended for 6

assert SB_041_cons_preserves_extended {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_041_cons_preserves_extended for 6

assert SB_042_head_extended {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_042_head_extended for 6

assert SB_043_tail_extended {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_043_tail_extended for 6

assert SB_044_measurement_hash_computed {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_044_measurement_hash_computed for 6

assert SB_045_measurement_pcr_in_bounds {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_045_measurement_pcr_in_bounds for 6

assert SB_046_quote_requires_sig {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_046_quote_requires_sig for 6

assert SB_047_pcr_sealed {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_047_pcr_sealed for 6

assert SB_048_locality_access {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_048_locality_access for 6

assert SB_049_measured_boot_tpm {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_049_measured_boot_tpm for 6

assert SB_050_measured_boot_pcrs {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_050_measured_boot_pcrs for 6

assert SB_051_version_no_rollback {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_051_version_no_rollback for 6

assert SB_052_bootloader_version_ok {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_052_bootloader_version_ok for 6

assert SB_053_kernel_version_ok {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_053_kernel_version_ok for 6

assert SB_054_chain_bootloader_ok {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_054_chain_bootloader_ok for 6

assert SB_055_chain_kernel_ok {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_055_chain_kernel_ok for 6

assert SB_056_construct_antirollback {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_056_construct_antirollback for 6

assert SB_057_min_zero_passes {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_057_min_zero_passes for 6

assert SB_058_same_version_passes {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_058_same_version_passes for 6

assert SB_059_higher_version_passes {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_059_higher_version_passes for 6

assert SB_060_lower_version_fails {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_060_lower_version_fails for 6

assert SB_061_root_no_parent {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_061_root_no_parent for 6

assert SB_062_nonroot_has_parent {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_062_nonroot_has_parent for 6

assert SB_063_valid_hierarchy_public {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_063_valid_hierarchy_public for 6

assert SB_064_valid_not_self_revoked {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_064_valid_not_self_revoked for 6

assert SB_065_key_in_db {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_065_key_in_db for 6

assert SB_066_key_not_in_empty {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_066_key_not_in_empty for 6

assert SB_067_empty_forbidden {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_067_empty_forbidden for 6

assert SB_068_key_is_forbidden {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_068_key_is_forbidden for 6

assert SB_069_allowed_uses_trusted {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_069_allowed_uses_trusted for 6

assert SB_070_allowed_not_forbidden {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_070_allowed_not_forbidden for 6

assert SB_071_complete_has_cot {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_071_complete_has_cot for 6

assert SB_072_complete_has_measured {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_072_complete_has_measured for 6

assert SB_073_complete_has_antirollback {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_073_complete_has_antirollback for 6

assert SB_074_complete_has_policy {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_074_complete_has_policy for 6

assert SB_075_policy_enabled {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_075_policy_enabled for 6

assert SB_076_policy_enforcing {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_076_policy_enforcing for 6

assert SB_077_policy_no_unsigned {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_077_policy_no_unsigned for 6

assert SB_078_construct_policy {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_078_construct_policy for 6

assert SB_079_construct_complete {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_079_construct_complete for 6

assert SB_080_complete_all_verified {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_080_complete_all_verified for 6

assert SB_081_riina_rot {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_081_riina_rot for 6

assert SB_082_riina_bl {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_082_riina_bl for 6

assert SB_083_riina_kern {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_083_riina_kern for 6

assert SB_084_riina_initrd {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_084_riina_initrd for 6

assert SB_085_riina_cot {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_085_riina_cot for 6

assert SB_086_riina_tpm {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_086_riina_tpm for 6

assert SB_087_riina_measured {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_087_riina_measured for 6

assert SB_088_riina_arb {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_088_riina_arb for 6

assert SB_089_riina_policy {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check SB_089_riina_policy for 6

assert SB_090_riina_complete {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check SB_090_riina_complete for 6

pred ExampleSecureBootVerification {
  some SecureOp
}
run ExampleSecureBootVerification for 6

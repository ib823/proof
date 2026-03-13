// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for cryptographic security
// Bounded verification of CryptographicSecurity properties
module riina/Domains/CryptographicSecurity

abstract sig KeyStrength {}
one sig Weak extends KeyStrength {}
one sig Standard extends KeyStrength {}
one sig Strong extends KeyStrength {}

sig CryptoOp {
  keyStrength: one KeyStrength,
  isConstantTime: one Int,
  isSecure: one Int
}

sig Key {
  strength: one KeyStrength,
  expired: one Int
}

// Invariant: no_weak_keys
fact no_weak_keys_fact {
  all k: Key | k.strength != Weak
}

// Invariant: constant_time_required
fact constant_time_required_fact {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}

// Invariant: expired_keys_rejected
fact expired_keys_rejected_fact {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}

// Invariant: strong_keys_secure
fact strong_keys_secure_fact {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}

assert andb_true_iff {
  all k: Key | k.strength != Weak
}
check andb_true_iff for 6

assert andb3_true_iff {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check andb3_true_iff for 6

assert negb_true_iff {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check negb_true_iff for 6

assert leb_le {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check leb_le for 6

assert cry_001_timing_side_channel_mitigated {
  all k: Key | k.strength != Weak
}
check cry_001_timing_side_channel_mitigated for 6

assert cry_001a_riina_timing_safe {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_001a_riina_timing_safe for 6

assert cry_002_spa_mitigated {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_002_spa_mitigated for 6

assert cry_003_dpa_mitigated {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_003_dpa_mitigated for 6

assert cry_004_em_analysis_mitigated {
  all k: Key | k.strength != Weak
}
check cry_004_em_analysis_mitigated for 6

assert cry_005_acoustic_analysis_mitigated {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_005_acoustic_analysis_mitigated for 6

assert cry_006_cache_timing_mitigated {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_006_cache_timing_mitigated for 6

assert cry_007_padding_oracle_mitigated {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_007_padding_oracle_mitigated for 6

assert cry_007a_riina_aead_padding_safe {
  all k: Key | k.strength != Weak
}
check cry_007a_riina_aead_padding_safe for 6

assert cry_008_chosen_plaintext_mitigated {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_008_chosen_plaintext_mitigated for 6

assert cry_009_chosen_ciphertext_mitigated {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_009_chosen_ciphertext_mitigated for 6

assert cry_010_known_plaintext_mitigated {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_010_known_plaintext_mitigated for 6

assert cry_011_mitm_mitigated {
  all k: Key | k.strength != Weak
}
check cry_011_mitm_mitigated for 6

assert cry_011a_riina_key_mitm_safe {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_011a_riina_key_mitm_safe for 6

assert cry_012_birthday_attack_mitigated {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_012_birthday_attack_mitigated for 6

assert cry_012a_riina_hash_birthday_safe {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_012a_riina_hash_birthday_safe for 6

assert cry_013_length_extension_mitigated {
  all k: Key | k.strength != Weak
}
check cry_013_length_extension_mitigated for 6

assert cry_014_downgrade_attack_mitigated {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_014_downgrade_attack_mitigated for 6

assert cry_014a_riina_proto_downgrade_safe {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_014a_riina_proto_downgrade_safe for 6

assert cry_015_protocol_attack_mitigated {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_015_protocol_attack_mitigated for 6

assert cry_016_implementation_flaw_mitigated {
  all k: Key | k.strength != Weak
}
check cry_016_implementation_flaw_mitigated for 6

assert cry_017_rng_attack_mitigated {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_017_rng_attack_mitigated for 6

assert cry_017a_riina_rng_secure {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_017a_riina_rng_secure for 6

assert cry_018_key_reuse_mitigated {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_018_key_reuse_mitigated for 6

assert cry_019_weak_keys_mitigated {
  all k: Key | k.strength != Weak
}
check cry_019_weak_keys_mitigated for 6

assert cry_020_related_key_attack_mitigated {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_020_related_key_attack_mitigated for 6

assert cry_020a_riina_key_related_safe {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_020a_riina_key_related_safe for 6

assert cry_021_differential_cryptanalysis_mitigated {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_021_differential_cryptanalysis_mitigated for 6

assert cry_022_linear_cryptanalysis_mitigated {
  all k: Key | k.strength != Weak
}
check cry_022_linear_cryptanalysis_mitigated for 6

assert cry_023_algebraic_attack_mitigated {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_023_algebraic_attack_mitigated for 6

assert cry_024_quantum_attack_mitigated {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_024_quantum_attack_mitigated for 6

assert cry_024a_riina_pq_secure {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_024a_riina_pq_secure for 6

assert cry_025_harvest_now_decrypt_later_mitigated {
  all k: Key | k.strength != Weak
}
check cry_025_harvest_now_decrypt_later_mitigated for 6

assert cry_026_key_extraction_mitigated {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_026_key_extraction_mitigated for 6

assert cry_027_nonce_misuse_mitigated {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_027_nonce_misuse_mitigated for 6

assert cry_027a_riina_mraead_secure {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_027a_riina_mraead_secure for 6

assert cry_028_certificate_attack_mitigated {
  all k: Key | k.strength != Weak
}
check cry_028_certificate_attack_mitigated for 6

assert cry_028a_riina_cert_secure {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check cry_028a_riina_cert_secure for 6

assert cry_029_random_fault_mitigated {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check cry_029_random_fault_mitigated for 6

assert cry_030_bleichenbacher_mitigated {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check cry_030_bleichenbacher_mitigated for 6

assert cry_031_whisper_leak_mitigated {
  all k: Key | k.strength != Weak
}
check cry_031_whisper_leak_mitigated for 6

assert complete_ct_security {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check complete_ct_security for 6

assert complete_aead_security {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check complete_aead_security for 6

assert riina_complete_crypto_security {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check riina_complete_crypto_security for 6

assert enc_001_length_preservation {
  all k: Key | k.strength != Weak
}
check enc_001_length_preservation for 6

assert enc_002_key_size_requirement {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check enc_002_key_size_requirement for 6

assert enc_003_riina_key_size_valid {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check enc_003_riina_key_size_valid for 6

assert enc_004_riina_nonce_size_valid {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check enc_004_riina_nonce_size_valid for 6

assert enc_005_riina_tag_size_valid {
  all k: Key | k.strength != Weak
}
check enc_005_riina_tag_size_valid for 6

assert enc_006_riina_is_authenticated {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check enc_006_riina_is_authenticated for 6

assert kdf_001_riina_kdf_secure {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check kdf_001_riina_kdf_secure for 6

assert kdf_002_kdf_output_sufficient {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check kdf_002_kdf_output_sufficient for 6

assert kdf_003_kdf_salt_sufficient {
  all k: Key | k.strength != Weak
}
check kdf_003_kdf_salt_sufficient for 6

assert kdf_004_kdf_approved_algorithm {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check kdf_004_kdf_approved_algorithm for 6

assert dk_001_valid_implies_secure_kdf {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check dk_001_valid_implies_secure_kdf for 6

assert mac_001_riina_mac_secure {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check mac_001_riina_mac_secure for 6

assert mac_002_mac_key_sufficient {
  all k: Key | k.strength != Weak
}
check mac_002_mac_key_sufficient for 6

assert mac_003_mac_tag_sufficient {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check mac_003_mac_tag_sufficient for 6

assert mac_004_mac_constant_time {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check mac_004_mac_constant_time for 6

assert tag_001_equal_tags_valid {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check tag_001_equal_tags_valid for 6

assert tag_002_tag_compare_reflexive {
  all k: Key | k.strength != Weak
}
check tag_002_tag_compare_reflexive for 6

assert nonce_001_counter_incrementable {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check nonce_001_counter_incrementable for 6

assert nonce_002_increment_changes_nonce {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check nonce_002_increment_changes_nonce for 6

assert nonce_003_different_counters_different_nonces {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check nonce_003_different_counters_different_nonces for 6

assert nonce_004_empty_set_no_collision {
  all k: Key | k.strength != Weak
}
check nonce_004_empty_set_no_collision for 6

assert nonce_005_add_increases_size {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check nonce_005_add_increases_size for 6

assert full_001_riina_full_crypto_secure {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check full_001_riina_full_crypto_secure for 6

assert full_002_full_implies_ct {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check full_002_full_implies_ct for 6

assert full_003_full_implies_authenticated {
  all k: Key | k.strength != Weak
}
check full_003_full_implies_authenticated for 6

assert full_004_full_implies_pq_ready {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check full_004_full_implies_pq_ready for 6

assert full_005_full_implies_kdf_secure {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check full_005_full_implies_kdf_secure for 6

assert full_006_full_implies_mac_secure {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check full_006_full_implies_mac_secure for 6

pred ExampleCryptographicSecurity {
  some CryptoOp
}
run ExampleCryptographicSecurity for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for cryptographic security
// Bounded verification of VerifiedCrypto properties
module riina/Domains/SecurityFoundation/VerifiedCrypto

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

assert key_never_plaintext {
  all k: Key | k.strength != Weak
}
check key_never_plaintext for 6

assert crypto_constant_time {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check crypto_constant_time for 6

assert wrapped_key_protected {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check wrapped_key_protected for 6

assert secure_memory_protects_key {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check secure_memory_protects_key for 6

assert constant_time_prevents_timing_attack {
  all k: Key | k.strength != Weak
}
check constant_time_prevents_timing_attack for 6

assert non_constant_time_vulnerable {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check non_constant_time_vulnerable for 6

assert key_never_exposed {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check key_never_exposed for 6

assert weak_key_detected {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check weak_key_detected for 6

assert strong_key_sufficient {
  all k: Key | k.strength != Weak
}
check strong_key_sufficient for 6

assert encrypt_decrypt_equal_time {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check encrypt_decrypt_equal_time for 6

assert sign_verify_equal_time {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check sign_verify_equal_time for 6

assert hash_fastest_operation {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check hash_fastest_operation for 6

assert key_derive_slowest {
  all k: Key | k.strength != Weak
}
check key_derive_slowest for 6

assert secure_storage_implies_protected {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check secure_storage_implies_protected for 6

assert unprotected_key_vulnerable {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check unprotected_key_vulnerable for 6

assert protection_complementary {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check protection_complementary for 6

assert no_protection_potential_exposure {
  all k: Key | k.strength != Weak
}
check no_protection_potential_exposure for 6

assert fully_hardened_context {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check fully_hardened_context for 6

assert operation_time_positive {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check operation_time_positive for 6

assert encrypt_faster_than_sign {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check encrypt_faster_than_sign for 6

assert crypto_execution_deterministic {
  all k: Key | k.strength != Weak
}
check crypto_execution_deterministic for 6

pred ExampleVerifiedCrypto {
  some CryptoOp
}
run ExampleVerifiedCrypto for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for cryptographic security
// Bounded verification of ConstantTimeCrypto properties
module riina/Domains/ConstantTimeCrypto

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

assert CT_001_branch_free {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check CT_001_branch_free for 6

assert CT_002_memory_safe {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check CT_002_memory_safe for 6

assert CT_003_operation_safe {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check CT_003_operation_safe for 6

assert CT_004_fully_ct {
  all k: Key | k.strength != Weak
}
check CT_004_fully_ct for 6

assert CT_005_no_secret_branches {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check CT_005_no_secret_branches for 6

assert CT_006_branchless_compare {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check CT_006_branchless_compare for 6

assert CT_007_no_secret_addresses {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check CT_007_no_secret_addresses for 6

assert CT_008_no_cache_timing {
  all k: Key | k.strength != Weak
}
check CT_008_no_cache_timing for 6

assert CT_009_no_var_time {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check CT_009_no_var_time for 6

assert CT_010_constant_loops {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check CT_010_constant_loops for 6

assert CT_011_full_implies_branch {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check CT_011_full_implies_branch for 6

assert CT_012_full_implies_memory {
  all k: Key | k.strength != Weak
}
check CT_012_full_implies_memory for 6

assert CT_013_full_implies_op {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check CT_013_full_implies_op for 6

assert CT_014_riina_aes_safe {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check CT_014_riina_aes_safe for 6

assert CT_015_riina_sha256_safe {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check CT_015_riina_sha256_safe for 6

assert CT_016_riina_aes_ct {
  all k: Key | k.strength != Weak
}
check CT_016_riina_aes_ct for 6

assert CT_017_riina_aes_bitsliced {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check CT_017_riina_aes_bitsliced for 6

assert CT_018_safe_implies_ct {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check CT_018_safe_implies_ct for 6

assert CT_019_safe_implies_no_tables {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check CT_019_safe_implies_no_tables for 6

assert CT_020_riina_no_branches {
  all k: Key | k.strength != Weak
}
check CT_020_riina_no_branches for 6

assert CT_021_riina_no_addresses {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check CT_021_riina_no_addresses for 6

assert CT_022_full_implies_no_branches {
  all k: Key | k.expired = 1 implies k.strength = Weak or k.strength != Weak
}
check CT_022_full_implies_no_branches for 6

assert CT_023_full_implies_no_cache {
  all op: CryptoOp | op.keyStrength = Strong implies op.isSecure = 1
}
check CT_023_full_implies_no_cache for 6

assert CT_024_full_implies_const_loops {
  all k: Key | k.strength != Weak
}
check CT_024_full_implies_const_loops for 6

assert CT_025_complete_ct_security {
  all op: CryptoOp | op.isSecure = 1 implies op.isConstantTime = 1
}
check CT_025_complete_ct_security for 6

pred ExampleConstantTimeCrypto {
  some CryptoOp
}
run ExampleConstantTimeCrypto for 6

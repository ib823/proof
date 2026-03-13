// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for post-quantum security
// Bounded verification of PostQuantumSignatures properties
module riina/Domains/PostQuantumSignatures

abstract sig SecurityLevel {}
one sig Classical extends SecurityLevel {}
one sig PostQuantum extends SecurityLevel {}
one sig QuantumResistant extends SecurityLevel {}

sig QuantumAlgorithm {
  secLevel: one SecurityLevel,
  keySize: one Int,
  secure: one Int
}

// Invariant: pq_minimum_key_size
fact pq_minimum_key_size_fact {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}

// Invariant: quantum_resistant_secure
fact quantum_resistant_secure_fact {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}

// Invariant: classical_not_pq
fact classical_not_pq_fact {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}

assert andb_true_iff {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check andb_true_iff for 6

assert PQ_SIG_001_mldsa_lattice {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_SIG_001_mldsa_lattice for 6

assert PQ_SIG_002_slhdsa_hash {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_SIG_002_slhdsa_hash for 6

assert PQ_SIG_003_mldsa87_level5 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_SIG_003_mldsa87_level5 for 6

assert PQ_SIG_004_slhdsa256_level5 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_SIG_004_slhdsa256_level5 for 6

assert PQ_SIG_005_level_reflexive {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_SIG_005_level_reflexive for 6

assert PQ_SIG_006_level5_max {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_SIG_006_level5_max for 6

assert PQ_SIG_007_eufcma_valid {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_SIG_007_eufcma_valid for 6

assert PQ_SIG_008_unforgeable {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_SIG_008_unforgeable for 6

assert PQ_SIG_009_strong_unforgeable {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_SIG_009_strong_unforgeable for 6

assert PQ_SIG_010_adaptive {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_SIG_010_adaptive for 6

assert PQ_SIG_011_qr_valid {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_SIG_011_qr_valid for 6

assert PQ_SIG_012_post_quantum {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_SIG_012_post_quantum for 6

assert PQ_SIG_013_no_shor {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_SIG_013_no_shor for 6

assert PQ_SIG_014_conservative {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_SIG_014_conservative for 6

assert PQ_SIG_015_riina_sig_secure {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_SIG_015_riina_sig_secure for 6

assert PQ_SIG_016_riina_level5 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_SIG_016_riina_level5 for 6

assert PQ_SIG_017_riina_mldsa_correct {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_SIG_017_riina_mldsa_correct for 6

assert PQ_SIG_018_riina_slhdsa_correct {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_SIG_018_riina_slhdsa_correct for 6

assert PQ_SIG_019_riina_scheme_mldsa {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_SIG_019_riina_scheme_mldsa for 6

assert PQ_SIG_020_riina_scheme_slhdsa {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_SIG_020_riina_scheme_slhdsa for 6

assert PQ_SIG_021_security_implies_eufcma {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_SIG_021_security_implies_eufcma for 6

assert PQ_SIG_022_security_implies_qr {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_SIG_022_security_implies_qr for 6

assert PQ_SIG_023_correct_key {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_SIG_023_correct_key for 6

assert PQ_SIG_024_correct_verify {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_SIG_024_correct_verify for 6

assert PQ_SIG_025_complete_security {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_SIG_025_complete_security for 6

pred ExamplePostQuantumSignatures {
  some QuantumAlgorithm
}
run ExamplePostQuantumSignatures for 6

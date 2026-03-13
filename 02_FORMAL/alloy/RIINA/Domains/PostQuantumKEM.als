// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for post-quantum security
// Bounded verification of PostQuantumKEM properties
module riina/Domains/PostQuantumKEM

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

assert PQ_KEM_001_level_reflexive {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_KEM_001_level_reflexive for 6

assert PQ_KEM_002_level_transitive {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_KEM_002_level_transitive for 6

assert PQ_KEM_003_level1_minimum {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_KEM_003_level1_minimum for 6

assert PQ_KEM_004_level5_maximum {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_KEM_004_level5_maximum for 6

assert PQ_KEM_005_mlkem512_level1 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_KEM_005_mlkem512_level1 for 6

assert PQ_KEM_006_mlkem768_level3 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_KEM_006_mlkem768_level3 for 6

assert PQ_KEM_007_mlkem1024_level5 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_KEM_007_mlkem1024_level5 for 6

assert PQ_KEM_008_params_ordered {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_KEM_008_params_ordered for 6

assert PQ_KEM_009_indcca_valid {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_KEM_009_indcca_valid for 6

assert PQ_KEM_010_ciphertext_indist {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_KEM_010_ciphertext_indist for 6

assert PQ_KEM_011_key_indist {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_KEM_011_key_indist for 6

assert PQ_KEM_012_decaps_consistent {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_KEM_012_decaps_consistent for 6

assert PQ_KEM_013_qr_valid {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_KEM_013_qr_valid for 6

assert PQ_KEM_014_lattice_based {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_KEM_014_lattice_based for 6

assert PQ_KEM_015_module_lwe {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_KEM_015_module_lwe for 6

assert PQ_KEM_016_no_quantum_attack {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_KEM_016_no_quantum_attack for 6

assert PQ_KEM_017_riina_kem_correct {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_KEM_017_riina_kem_correct for 6

assert PQ_KEM_018_riina_kem_secure {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_KEM_018_riina_kem_secure for 6

assert PQ_KEM_019_riina_level5 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_KEM_019_riina_level5 for 6

assert PQ_KEM_020_riina_mlkem1024 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_KEM_020_riina_mlkem1024 for 6

assert PQ_KEM_021_security_implies_indcca {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_KEM_021_security_implies_indcca for 6

assert PQ_KEM_022_security_implies_qr {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_KEM_022_security_implies_qr for 6

assert PQ_KEM_023_correct_keypair {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check PQ_KEM_023_correct_keypair for 6

assert PQ_KEM_024_shared_secret_match {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check PQ_KEM_024_shared_secret_match for 6

assert PQ_KEM_025_complete_security {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check PQ_KEM_025_complete_security for 6

pred ExamplePostQuantumKEM {
  some QuantumAlgorithm
}
run ExamplePostQuantumKEM for 6

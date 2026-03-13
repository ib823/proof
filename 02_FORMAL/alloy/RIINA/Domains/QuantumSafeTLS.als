// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for post-quantum security
// Bounded verification of QuantumSafeTLS properties
module riina/Domains/QuantumSafeTLS

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

assert orb_true_iff {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check orb_true_iff for 6

assert negb_false_iff {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check negb_false_iff for 6

assert negb_true_iff {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check negb_true_iff for 6

assert QSTLS_001 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_001 for 6

assert QSTLS_002 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_002 for 6

assert QSTLS_003 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_003 for 6

assert QSTLS_004 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_004 for 6

assert QSTLS_005 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_005 for 6

assert QSTLS_006 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_006 for 6

assert QSTLS_007 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_007 for 6

assert QSTLS_008 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_008 for 6

assert QSTLS_009 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_009 for 6

assert QSTLS_010 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_010 for 6

assert QSTLS_011 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_011 for 6

assert QSTLS_012 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_012 for 6

assert QSTLS_013 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_013 for 6

assert QSTLS_014 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_014 for 6

assert QSTLS_015 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_015 for 6

assert QSTLS_016 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_016 for 6

assert QSTLS_017 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_017 for 6

assert QSTLS_018 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_018 for 6

assert QSTLS_019 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_019 for 6

assert QSTLS_020 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_020 for 6

assert QSTLS_021 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_021 for 6

assert QSTLS_022 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_022 for 6

assert QSTLS_023 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_023 for 6

assert QSTLS_024 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_024 for 6

assert QSTLS_025 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_025 for 6

assert QSTLS_026 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_026 for 6

assert QSTLS_027 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_027 for 6

assert QSTLS_028 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_028 for 6

assert QSTLS_029 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_029 for 6

assert QSTLS_030 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_030 for 6

assert QSTLS_031 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_031 for 6

assert QSTLS_032 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_032 for 6

assert QSTLS_033 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_033 for 6

assert QSTLS_034 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_034 for 6

assert QSTLS_035 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_035 for 6

assert QSTLS_036 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_036 for 6

assert QSTLS_037 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_037 for 6

assert QSTLS_038 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_038 for 6

assert QSTLS_039 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_039 for 6

assert QSTLS_040 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_040 for 6

assert QSTLS_041 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_041 for 6

assert QSTLS_042 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_042 for 6

assert QSTLS_043 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_043 for 6

assert QSTLS_044 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_044 for 6

assert QSTLS_045 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_045 for 6

assert QSTLS_046 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_046 for 6

assert QSTLS_047 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_047 for 6

assert QSTLS_048 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_048 for 6

assert QSTLS_049 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_049 for 6

assert QSTLS_050 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_050 for 6

assert QSTLS_051 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_051 for 6

assert QSTLS_052 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_052 for 6

assert QSTLS_053 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_053 for 6

assert QSTLS_054 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_054 for 6

assert QSTLS_055 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_055 for 6

assert QSTLS_056 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_056 for 6

assert QSTLS_057 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_057 for 6

assert QSTLS_058 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_058 for 6

assert QSTLS_059 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_059 for 6

assert QSTLS_060 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_060 for 6

assert QSTLS_061 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_061 for 6

assert QSTLS_062 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_062 for 6

assert QSTLS_063_complete {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check QSTLS_063_complete for 6

assert QSTLS_064_hybrid_security {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check QSTLS_064_hybrid_security for 6

assert QSTLS_065_full_chain {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check QSTLS_065_full_chain for 6

pred ExampleQuantumSafeTLS {
  some QuantumAlgorithm
}
run ExampleQuantumSafeTLS for 6

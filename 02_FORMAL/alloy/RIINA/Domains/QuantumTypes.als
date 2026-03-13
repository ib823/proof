// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for post-quantum security
// Bounded verification of QuantumTypes properties
module riina/Domains/QuantumTypes

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

assert mem_true_In {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check mem_true_In for 6

assert In_mem_true {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check In_mem_true for 6

assert mem_false_not_In {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check mem_false_not_In for 6

assert remove_length {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check remove_length for 6

assert remove_not_first {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check remove_not_first for 6

assert count_remove_helper {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check count_remove_helper for 6

assert 1 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check 1 for 6

assert 2 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check 2 for 6

assert 3 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check 3 for 6

assert 4 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check 4 for 6

assert 5 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check 5 for 6

assert 6 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check 6 for 6

assert 7 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check 7 for 6

assert 8 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check 8 for 6

assert measure_decreases_resources {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check measure_decreases_resources for 6

assert create_measure_consumed {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check create_measure_consumed for 6

assert create_gate_measure_consumed {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check create_gate_measure_consumed for 6

assert 12 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check 12 for 6

assert 13 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check 13 for 6

assert 14 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check 14 for 6

assert 15 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check 15 for 6

assert 16 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check 16 for 6

assert 17 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check 17 for 6

assert 18 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check 18 for 6

assert 19 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check 19 for 6

assert 20 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check 20 for 6

assert 21 {
  all a: QuantumAlgorithm | a.secLevel = Classical implies a.secLevel != PostQuantum
}
check 21 for 6

assert 22 {
  all a: QuantumAlgorithm | a.secLevel = PostQuantum implies a.keySize >= 3
}
check 22 for 6

assert 23 {
  all a: QuantumAlgorithm | a.secLevel = QuantumResistant implies a.secure = 1
}
check 23 for 6

pred ExampleQuantumTypes {
  some QuantumAlgorithm
}
run ExampleQuantumTypes for 6

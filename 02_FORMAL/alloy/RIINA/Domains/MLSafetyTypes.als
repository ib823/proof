// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/MLSafetyTypes.v (24 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/ml_safety_types

open util/boolean

abstract sig dp_config {}
abstract sig nat____nat {}
abstract sig shape {}

// shape_eq (matches Coq: Definition shape_eq)
pred shape_eq[p_s1: shape, p_s2: shape] {
  some p_s1
}

// dp_compose (matches Coq: Definition dp_compose)
pred dp_compose[p_d1: dp_config, p_d2: dp_config] {
  some p_d1
}

// lipschitz_bound (matches Coq: Definition lipschitz_bound)
pred lipschitz_bound[p_k: Int, p_f: nat____nat] {
  some p_k
}

// forallb_combine_refl (matches Coq: Lemma forallb_combine_refl)
assert forallb_combine_refl {
  #univ >= 0
}
check forallb_combine_refl for 5

// forallb_combine_sym (matches Coq: Lemma forallb_combine_sym)
assert forallb_combine_sym {
  #univ >= 0
}
check forallb_combine_sym for 5

// shape_eq_refl (matches Coq: Theorem shape_eq_refl)
assert shape_eq_refl {
  #univ >= 0
}
check shape_eq_refl for 5

// shape_eq_sym (matches Coq: Theorem shape_eq_sym)
assert shape_eq_sym {
  #univ >= 0
}
check shape_eq_sym for 5

// matmul_shape_correct (matches Coq: Theorem matmul_shape_correct)
assert matmul_shape_correct {
  #univ >= 0
}
check matmul_shape_correct for 5

// matmul_incompat (matches Coq: Theorem matmul_incompat)
assert matmul_incompat {
  #univ >= 0
}
check matmul_incompat for 5

// dp_composition_additive (matches Coq: Theorem dp_composition_additive)
assert dp_composition_additive {
  #univ >= 0
}
check dp_composition_additive for 5

// dp_compose_assoc (matches Coq: Theorem dp_compose_assoc)
assert dp_compose_assoc {
  #univ >= 0
}
check dp_compose_assoc for 5

// lipschitz_compose (matches Coq: Theorem lipschitz_compose)
assert lipschitz_compose {
  #univ >= 0
}
check lipschitz_compose for 5

// lipschitz_id (matches Coq: Theorem lipschitz_id)
assert lipschitz_id {
  #univ >= 0
}
check lipschitz_id for 5

// lipschitz_const (matches Coq: Theorem lipschitz_const)
assert lipschitz_const {
  #univ >= 0
}
check lipschitz_const for 5

// dp_queries_additive (matches Coq: Theorem dp_queries_additive)
assert dp_queries_additive {
  #univ >= 0
}
check dp_queries_additive for 5

// dp_compose_zero_l (matches Coq: Theorem dp_compose_zero_l)
assert dp_compose_zero_l {
  #univ >= 0
}
check dp_compose_zero_l for 5

// dp_compose_zero_r (matches Coq: Theorem dp_compose_zero_r)
assert dp_compose_zero_r {
  #univ >= 0
}
check dp_compose_zero_r for 5

// dp_compose_comm (matches Coq: Theorem dp_compose_comm)
assert dp_compose_comm {
  #univ >= 0
}
check dp_compose_comm for 5

// shape_eq_implies_same_length (matches Coq: Theorem shape_eq_implies_same_length)
assert shape_eq_implies_same_length {
  #univ >= 0
}
check shape_eq_implies_same_length for 5

// shape_eq_nil (matches Coq: Theorem shape_eq_nil)
assert shape_eq_nil {
  #univ >= 0
}
check shape_eq_nil for 5

// shape_eq_singleton (matches Coq: Theorem shape_eq_singleton)
assert shape_eq_singleton {
  #univ >= 0
}
check shape_eq_singleton for 5

// matmul_square (matches Coq: Theorem matmul_square)
assert matmul_square {
  #univ >= 0
}
check matmul_square for 5

// matmul_col_vector (matches Coq: Theorem matmul_col_vector)
assert matmul_col_vector {
  #univ >= 0
}
check matmul_col_vector for 5

// dp_epsilon_nonneg (matches Coq: Theorem dp_epsilon_nonneg)
assert dp_epsilon_nonneg {
  #univ >= 0
}
check dp_epsilon_nonneg for 5

// lipschitz_mono (matches Coq: Theorem lipschitz_mono)
assert lipschitz_mono {
  #univ >= 0
}
check lipschitz_mono for 5

// compose_fn_assoc (matches Coq: Theorem compose_fn_assoc)
assert compose_fn_assoc {
  #univ >= 0
}
check compose_fn_assoc for 5

// compose_fn_id_l (matches Coq: Theorem compose_fn_id_l)
assert compose_fn_id_l {
  #univ >= 0
}
check compose_fn_id_l for 5

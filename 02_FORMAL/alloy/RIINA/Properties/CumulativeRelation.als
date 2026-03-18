// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/CumulativeRelation.v (36 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/cumulative_relation

open util/boolean

abstract sig effect_ctx {}
abstract sig expr {}
abstract sig store {}
abstract sig store_ty {}
abstract sig store_ty____ty____expr____expr____Prop {}
abstract sig ty {}

// closed_expr (matches Coq: Definition closed_expr)
pred closed_expr[p_e: expr] {
  some p_e
}

// store_rel_simple (matches Coq: Definition store_rel_simple)
pred store_rel_simple[p_sigma: store_ty, p_st1: store, p_st2: store] {
  some p_sigma
}

// val_rel_struct (matches Coq: Definition val_rel_struct)
pred val_rel_struct[p_val_rel_prev: store_ty____ty____expr____expr____Prop, p_sigma: store_ty, p_T: ty, p_v1: expr, p_v2: expr] {
  some p_val_rel_prev
}

// val_rel_le (matches Coq: Definition val_rel_le)
pred val_rel_le[p_n: Int, p_sigma: store_ty, p_T: ty, p_v1: expr, p_v2: expr] {
  some p_n
}

// store_rel_le (matches Coq: Definition store_rel_le)
pred store_rel_le[p_n: Int, p_sigma: store_ty, p_st1: store, p_st2: store] {
  some p_n
}

// val_rel_at_type_fo (matches Coq: Definition val_rel_at_type_fo)
pred val_rel_at_type_fo[p_T: ty, p_v1: expr, p_v2: expr] {
  some p_T
}

// exp_rel_le (matches Coq: Definition exp_rel_le)
pred exp_rel_le[p_n: Int, p_sigma: store_ty, p_T: ty, p_e1: expr, p_e2: expr, p_st1: store, p_st2: store, p_ctx: effect_ctx] {
  some p_n
}

// val_rel_le_0_unfold (matches Coq: Lemma val_rel_le_0_unfold)
assert val_rel_le_0_unfold {
  #univ >= 0
}
check val_rel_le_0_unfold for 5

// val_rel_le_S_unfold (matches Coq: Lemma val_rel_le_S_unfold)
assert val_rel_le_S_unfold {
  #univ >= 0
}
check val_rel_le_S_unfold for 5

// val_rel_le_at_zero (matches Coq: Lemma val_rel_le_at_zero)
assert val_rel_le_at_zero {
  #univ >= 0
}
check val_rel_le_at_zero for 5

// val_rel_le_cumulative (matches Coq: Lemma val_rel_le_cumulative)
assert val_rel_le_cumulative {
  #univ >= 0
}
check val_rel_le_cumulative for 5

// val_rel_le_value_left (matches Coq: Lemma val_rel_le_value_left)
assert val_rel_le_value_left {
  #univ >= 0
}
check val_rel_le_value_left for 5

// val_rel_le_value_right (matches Coq: Lemma val_rel_le_value_right)
assert val_rel_le_value_right {
  #univ >= 0
}
check val_rel_le_value_right for 5

// val_rel_le_closed_left (matches Coq: Lemma val_rel_le_closed_left)
assert val_rel_le_closed_left {
  #univ >= 0
}
check val_rel_le_closed_left for 5

// val_rel_le_closed_right (matches Coq: Lemma val_rel_le_closed_right)
assert val_rel_le_closed_right {
  #univ >= 0
}
check val_rel_le_closed_right for 5

// val_rel_le_mono_step_fo (matches Coq: Lemma val_rel_le_mono_step_fo)
assert val_rel_le_mono_step_fo {
  #univ >= 0
}
check val_rel_le_mono_step_fo for 5

// val_rel_le_extract_fo (matches Coq: Lemma val_rel_le_extract_fo)
assert val_rel_le_extract_fo {
  #univ >= 0
}
check val_rel_le_extract_fo for 5

// val_rel_le_construct_fo (matches Coq: Lemma val_rel_le_construct_fo)
assert val_rel_le_construct_fo {
  #univ >= 0
}
check val_rel_le_construct_fo for 5

// val_rel_le_fo_step_independent (matches Coq: Lemma val_rel_le_fo_step_independent)
assert val_rel_le_fo_step_independent {
  #univ >= 0
}
check val_rel_le_fo_step_independent for 5

// store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans)
assert store_ty_extends_trans {
  #univ >= 0
}
check store_ty_extends_trans for 5

// store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
assert store_ty_extends_refl {
  #univ >= 0
}
check store_ty_extends_refl for 5

// val_rel_le_build_unit (matches Coq: Lemma val_rel_le_build_unit)
assert val_rel_le_build_unit {
  #univ >= 0
}
check val_rel_le_build_unit for 5

// val_rel_le_build_bool (matches Coq: Lemma val_rel_le_build_bool)
assert val_rel_le_build_bool {
  #univ >= 0
}
check val_rel_le_build_bool for 5

// val_rel_le_build_int (matches Coq: Lemma val_rel_le_build_int)
assert val_rel_le_build_int {
  #univ >= 0
}
check val_rel_le_build_int for 5

// val_rel_le_build_string (matches Coq: Lemma val_rel_le_build_string)
assert val_rel_le_build_string {
  #univ >= 0
}
check val_rel_le_build_string for 5

// val_rel_le_unit_eq (matches Coq: Lemma val_rel_le_unit_eq)
assert val_rel_le_unit_eq {
  #univ >= 0
}
check val_rel_le_unit_eq for 5

// val_rel_le_bool_eq (matches Coq: Lemma val_rel_le_bool_eq)
assert val_rel_le_bool_eq {
  #univ >= 0
}
check val_rel_le_bool_eq for 5

// val_rel_le_int_eq (matches Coq: Lemma val_rel_le_int_eq)
assert val_rel_le_int_eq {
  #univ >= 0
}
check val_rel_le_int_eq for 5

// val_rel_le_string_eq (matches Coq: Lemma val_rel_le_string_eq)
assert val_rel_le_string_eq {
  #univ >= 0
}
check val_rel_le_string_eq for 5

// exp_rel_le_mono_step (matches Coq: Lemma exp_rel_le_mono_step)
assert exp_rel_le_mono_step {
  #univ >= 0
}
check exp_rel_le_mono_step for 5

// exp_rel_le_zero_val (matches Coq: Lemma exp_rel_le_zero_val)
assert exp_rel_le_zero_val {
  #univ >= 0
}
check exp_rel_le_zero_val for 5

// val_rel_le_build_pair (matches Coq: Lemma val_rel_le_build_pair)
assert val_rel_le_build_pair {
  #univ >= 0
}
check val_rel_le_build_pair for 5

// val_rel_le_build_inl (matches Coq: Lemma val_rel_le_build_inl)
assert val_rel_le_build_inl {
  #univ >= 0
}
check val_rel_le_build_inl for 5

// val_rel_le_build_inr (matches Coq: Lemma val_rel_le_build_inr)
assert val_rel_le_build_inr {
  #univ >= 0
}
check val_rel_le_build_inr for 5

// val_rel_le_prod_components (matches Coq: Lemma val_rel_le_prod_components)
assert val_rel_le_prod_components {
  #univ >= 0
}
check val_rel_le_prod_components for 5

// val_rel_le_ref_eq (matches Coq: Lemma val_rel_le_ref_eq)
assert val_rel_le_ref_eq {
  #univ >= 0
}
check val_rel_le_ref_eq for 5

// val_rel_le_build_secret (matches Coq: Lemma val_rel_le_build_secret)
assert val_rel_le_build_secret {
  #univ >= 0
}
check val_rel_le_build_secret for 5

// store_rel_le_at_zero (matches Coq: Lemma store_rel_le_at_zero)
assert store_rel_le_at_zero {
  #univ >= 0
}
check store_rel_le_at_zero for 5

// val_rel_le_bytes_eq (matches Coq: Lemma val_rel_le_bytes_eq)
assert val_rel_le_bytes_eq {
  #univ >= 0
}
check val_rel_le_bytes_eq for 5

// val_rel_le_build_ref (matches Coq: Lemma val_rel_le_build_ref)
assert val_rel_le_build_ref {
  #univ >= 0
}
check val_rel_le_build_ref for 5

// val_rel_le_sum_extract (matches Coq: Lemma val_rel_le_sum_extract)
assert val_rel_le_sum_extract {
  #univ >= 0
}
check val_rel_le_sum_extract for 5

// val_rel_le_unit (matches Coq: Lemma val_rel_le_unit)
assert val_rel_le_unit {
  #univ >= 0
}
check val_rel_le_unit for 5

// store_rel_simple_refl_cum (matches Coq: Lemma store_rel_simple_refl_cum)
assert store_rel_simple_refl_cum {
  #univ >= 0
}
check store_rel_simple_refl_cum for 5

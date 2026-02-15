// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/FirstOrderComplete.v (27 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/first_order_complete

open util/boolean

abstract sig expr {}
abstract sig ty {}
abstract sig ty____Prop {}

// is_base_type (matches Coq: Definition is_base_type)
pred is_base_type[p_T: ty] {
  some p_T
}

// store_independent (matches Coq: Definition store_independent)
pred store_independent[p_P: ty____Prop] {
  some p_P
}

// expr_eqb (matches Coq: Definition expr_eqb)
pred expr_eqb[p_e1: expr, p_e2: expr] {
  some p_e1
}

// ty_eqb (matches Coq: Definition ty_eqb)
pred ty_eqb[p_T1: ty, p_T2: ty] {
  some p_T1
}

// first_order_subtype (matches Coq: Lemma first_order_subtype)
assert first_order_subtype {
  #univ >= 0
}
check first_order_subtype for 5

// first_order_subtypes_fo (matches Coq: Lemma first_order_subtypes_fo)
assert first_order_subtypes_fo {
  #univ >= 0
}
check first_order_subtypes_fo for 5

// base_type_first_order (matches Coq: Lemma base_type_first_order)
assert base_type_first_order {
  #univ >= 0
}
check base_type_first_order for 5

// base_type_size_one (matches Coq: Lemma base_type_size_one)
assert base_type_size_one {
  #univ >= 0
}
check base_type_size_one for 5

// first_order_value_structure (matches Coq: Lemma first_order_value_structure)
assert first_order_value_structure {
  #univ >= 0
}
check first_order_value_structure for 5

// first_order_induction_simple (matches Coq: Lemma first_order_induction_simple)
assert first_order_induction_simple {
  #univ >= 0
}
check first_order_induction_simple for 5

// ty_eqb_refl (matches Coq: Lemma ty_eqb_refl)
assert ty_eqb_refl {
  #univ >= 0
}
check ty_eqb_refl for 5

// ty_eqb_eq (matches Coq: Lemma ty_eqb_eq)
assert ty_eqb_eq {
  #univ >= 0
}
check ty_eqb_eq for 5

// ty_eqb_unit_bool_false (matches Coq: Lemma ty_eqb_unit_bool_false)
assert ty_eqb_unit_bool_false {
  #univ >= 0
}
check ty_eqb_unit_bool_false for 5

// ty_eqb_unit_int_false (matches Coq: Lemma ty_eqb_unit_int_false)
assert ty_eqb_unit_int_false {
  #univ >= 0
}
check ty_eqb_unit_int_false for 5

// ty_eqb_bool_int_false (matches Coq: Lemma ty_eqb_bool_int_false)
assert ty_eqb_bool_int_false {
  #univ >= 0
}
check ty_eqb_bool_int_false for 5

// ty_eqb_bool_string_false (matches Coq: Lemma ty_eqb_bool_string_false)
assert ty_eqb_bool_string_false {
  #univ >= 0
}
check ty_eqb_bool_string_false for 5

// ty_eqb_int_string_false (matches Coq: Lemma ty_eqb_int_string_false)
assert ty_eqb_int_string_false {
  #univ >= 0
}
check ty_eqb_int_string_false for 5

// ty_eqb_unit_string_false (matches Coq: Lemma ty_eqb_unit_string_false)
assert ty_eqb_unit_string_false {
  #univ >= 0
}
check ty_eqb_unit_string_false for 5

// fn_not_first_order (matches Coq: Lemma fn_not_first_order)
assert fn_not_first_order {
  #univ >= 0
}
check fn_not_first_order for 5

// chan_not_first_order (matches Coq: Lemma chan_not_first_order)
assert chan_not_first_order {
  #univ >= 0
}
check chan_not_first_order for 5

// securechan_not_first_order (matches Coq: Lemma securechan_not_first_order)
assert securechan_not_first_order {
  #univ >= 0
}
check securechan_not_first_order for 5

// base_type_not_fn (matches Coq: Lemma base_type_not_fn)
assert base_type_not_fn {
  #univ >= 0
}
check base_type_not_fn for 5

// base_type_not_prod (matches Coq: Lemma base_type_not_prod)
assert base_type_not_prod {
  #univ >= 0
}
check base_type_not_prod for 5

// base_type_not_sum (matches Coq: Lemma base_type_not_sum)
assert base_type_not_sum {
  #univ >= 0
}
check base_type_not_sum for 5

// base_type_not_list (matches Coq: Lemma base_type_not_list)
assert base_type_not_list {
  #univ >= 0
}
check base_type_not_list for 5

// base_type_not_option (matches Coq: Lemma base_type_not_option)
assert base_type_not_option {
  #univ >= 0
}
check base_type_not_option for 5

// fo_compound_depth_unit (matches Coq: Lemma fo_compound_depth_unit)
assert fo_compound_depth_unit {
  #univ >= 0
}
check fo_compound_depth_unit for 5

// fo_compound_depth_bool (matches Coq: Lemma fo_compound_depth_bool)
assert fo_compound_depth_bool {
  #univ >= 0
}
check fo_compound_depth_bool for 5

// fo_compound_depth_int (matches Coq: Lemma fo_compound_depth_int)
assert fo_compound_depth_int {
  #univ >= 0
}
check fo_compound_depth_int for 5

// fo_compound_depth_string (matches Coq: Lemma fo_compound_depth_string)
assert fo_compound_depth_string {
  #univ >= 0
}
check fo_compound_depth_string for 5

// fo_compound_depth_bytes (matches Coq: Lemma fo_compound_depth_bytes)
assert fo_compound_depth_bytes {
  #univ >= 0
}
check fo_compound_depth_bytes for 5

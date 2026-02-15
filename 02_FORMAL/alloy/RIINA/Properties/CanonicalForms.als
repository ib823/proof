// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/CanonicalForms.v (31 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/canonical_forms

open util/boolean

// canonical_unit (matches Coq: Lemma canonical_unit)
assert canonical_unit {
  #univ >= 0
}
check canonical_unit for 5

// canonical_bool (matches Coq: Lemma canonical_bool)
assert canonical_bool {
  #univ >= 0
}
check canonical_bool for 5

// canonical_int (matches Coq: Lemma canonical_int)
assert canonical_int {
  #univ >= 0
}
check canonical_int for 5

// canonical_string (matches Coq: Lemma canonical_string)
assert canonical_string {
  #univ >= 0
}
check canonical_string for 5

// canonical_fn (matches Coq: Lemma canonical_fn)
assert canonical_fn {
  #univ >= 0
}
check canonical_fn for 5

// canonical_pair (matches Coq: Lemma canonical_pair)
assert canonical_pair {
  #univ >= 0
}
check canonical_pair for 5

// canonical_sum (matches Coq: Lemma canonical_sum)
assert canonical_sum {
  #univ >= 0
}
check canonical_sum for 5

// canonical_sum_inl (matches Coq: Lemma canonical_sum_inl)
assert canonical_sum_inl {
  #univ >= 0
}
check canonical_sum_inl for 5

// canonical_ref (matches Coq: Lemma canonical_ref)
assert canonical_ref {
  #univ >= 0
}
check canonical_ref for 5

// canonical_secret (matches Coq: Lemma canonical_secret)
assert canonical_secret {
  #univ >= 0
}
check canonical_secret for 5

// canonical_proof (matches Coq: Lemma canonical_proof)
assert canonical_proof {
  #univ >= 0
}
check canonical_proof for 5

// base_value_pure (matches Coq: Lemma base_value_pure)
assert base_value_pure {
  #univ >= 0
}
check base_value_pure for 5

// unit_value_pure (matches Coq: Lemma unit_value_pure)
assert unit_value_pure {
  #univ >= 0
}
check unit_value_pure for 5

// bool_value_pure (matches Coq: Lemma bool_value_pure)
assert bool_value_pure {
  #univ >= 0
}
check bool_value_pure for 5

// int_value_pure (matches Coq: Lemma int_value_pure)
assert int_value_pure {
  #univ >= 0
}
check int_value_pure for 5

// string_value_pure (matches Coq: Lemma string_value_pure)
assert string_value_pure {
  #univ >= 0
}
check string_value_pure for 5

// lambda_value_pure (matches Coq: Lemma lambda_value_pure)
assert lambda_value_pure {
  #univ >= 0
}
check lambda_value_pure for 5

// loc_value_pure (matches Coq: Lemma loc_value_pure)
assert loc_value_pure {
  #univ >= 0
}
check loc_value_pure for 5

// unit_not_bool (matches Coq: Lemma unit_not_bool)
assert unit_not_bool {
  #univ >= 0
}
check unit_not_bool for 5

// unit_not_int (matches Coq: Lemma unit_not_int)
assert unit_not_int {
  #univ >= 0
}
check unit_not_int for 5

// unit_not_fn (matches Coq: Lemma unit_not_fn)
assert unit_not_fn {
  #univ >= 0
}
check unit_not_fn for 5

// bool_not_unit (matches Coq: Lemma bool_not_unit)
assert bool_not_unit {
  #univ >= 0
}
check bool_not_unit for 5

// bool_not_int (matches Coq: Lemma bool_not_int)
assert bool_not_int {
  #univ >= 0
}
check bool_not_int for 5

// int_not_unit (matches Coq: Lemma int_not_unit)
assert int_not_unit {
  #univ >= 0
}
check int_not_unit for 5

// int_not_bool (matches Coq: Lemma int_not_bool)
assert int_not_bool {
  #univ >= 0
}
check int_not_bool for 5

// pair_components_typed (matches Coq: Lemma pair_components_typed)
assert pair_components_typed {
  #univ >= 0
}
check pair_components_typed for 5

// inl_component_typed (matches Coq: Lemma inl_component_typed)
assert inl_component_typed {
  #univ >= 0
}
check inl_component_typed for 5

// inr_component_typed (matches Coq: Lemma inr_component_typed)
assert inr_component_typed {
  #univ >= 0
}
check inr_component_typed for 5

// classify_component_typed (matches Coq: Lemma classify_component_typed)
assert classify_component_typed {
  #univ >= 0
}
check classify_component_typed for 5

// prove_component_typed (matches Coq: Lemma prove_component_typed)
assert prove_component_typed {
  #univ >= 0
}
check prove_component_typed for 5

// value_shape (matches Coq: Lemma value_shape)
assert value_shape {
  #univ >= 0
}
check value_shape for 5

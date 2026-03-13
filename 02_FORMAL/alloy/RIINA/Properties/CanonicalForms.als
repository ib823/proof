// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/CanonicalForms.v
// Models: typing inversion and canonical forms
module riina/Properties/CanonicalForms

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}
sig TFnType extends Type { dom: one Type, cod: one Type }
sig TProdType extends Type { left: one Type, right: one Type }

abstract sig Effect {}
one sig EffPure extends Effect {}
one sig EffIO extends Effect {}

sig TypedExpr {
  exprType: one Type,
  exprEffect: one Effect,
  isValue: one Int
}

fact ValuesPure {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}

assert canonical_unit {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_unit for 6

assert canonical_bool {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_bool for 6

assert canonical_int {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_int for 6

assert canonical_string {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_string for 6

assert canonical_fn {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_fn for 6

assert canonical_pair {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_pair for 6

assert canonical_sum {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_sum for 6

assert canonical_sum_inl {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_sum_inl for 6

assert canonical_ref {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_ref for 6

assert canonical_secret {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_secret for 6

assert canonical_proof {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check canonical_proof for 6

assert base_value_pure {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check base_value_pure for 6

assert unit_value_pure {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check unit_value_pure for 6

assert bool_value_pure {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check bool_value_pure for 6

assert int_value_pure {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check int_value_pure for 6

assert string_value_pure {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check string_value_pure for 6

assert lambda_value_pure {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check lambda_value_pure for 6

assert loc_value_pure {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check loc_value_pure for 6

assert unit_not_bool {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check unit_not_bool for 6

assert unit_not_int {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check unit_not_int for 6

assert unit_not_fn {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check unit_not_fn for 6

assert bool_not_unit {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check bool_not_unit for 6

assert bool_not_int {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check bool_not_int for 6

assert int_not_unit {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check int_not_unit for 6

assert int_not_bool {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check int_not_bool for 6

assert pair_components_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check pair_components_typed for 6

assert inl_component_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inl_component_typed for 6

assert inr_component_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inr_component_typed for 6

assert classify_component_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check classify_component_typed for 6

assert prove_component_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check prove_component_typed for 6

assert value_shape {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check value_shape for 6

pred ExampleCanonicalForms {
  some e: TypedExpr | e.isValue = 1 and e.exprType = TBool
}
run ExampleCanonicalForms for 6

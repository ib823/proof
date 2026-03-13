// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/TypingInversion.v
// Models: typing inversion and canonical forms
module riina/Properties/TypingInversion

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

assert inversion_app {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_app for 6

assert inversion_lam {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_lam for 6

assert inversion_pair {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_pair for 6

assert inversion_fst {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_fst for 6

assert inversion_snd {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_snd for 6

assert inversion_inl {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_inl for 6

assert inversion_inr {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_inr for 6

assert inversion_case {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_case for 6

assert inversion_if {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_if for 6

assert inversion_let {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_let for 6

assert inversion_ref {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_ref for 6

assert inversion_deref {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_deref for 6

assert inversion_assign {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_assign for 6

assert inversion_perform {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_perform for 6

assert inversion_handle {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_handle for 6

assert inversion_classify {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_classify for 6

assert inversion_declassify {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_declassify for 6

assert inversion_prove {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_prove for 6

assert inversion_require {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_require for 6

assert inversion_grant {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_grant for 6

assert inversion_var {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_var for 6

assert inversion_loc {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check inversion_loc for 6

assert value_typed_pure {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check value_typed_pure for 6

assert value_pure_typing {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check value_pure_typing for 6

assert lookup_cons_neq {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check lookup_cons_neq for 6

assert lookup_cons_eq {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check lookup_cons_eq for 6

assert lookup_weaken {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check lookup_weaken for 6

assert app_well_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check app_well_typed for 6

assert let_well_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check let_well_typed for 6

assert if_well_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check if_well_typed for 6

assert pair_well_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check pair_well_typed for 6

assert fst_well_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check fst_well_typed for 6

assert snd_well_typed {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check snd_well_typed for 6

assert fn_not_prod {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check fn_not_prod for 6

assert fn_not_sum {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check fn_not_sum for 6

assert fn_not_ref {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check fn_not_ref for 6

assert fn_not_bool {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check fn_not_bool for 6

assert fn_not_int {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check fn_not_int for 6

assert fn_not_unit {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check fn_not_unit for 6

assert prod_not_sum {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check prod_not_sum for 6

assert secret_not_fn {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check secret_not_fn for 6

assert secret_not_prod {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check secret_not_prod for 6

assert secret_not_bool {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check secret_not_bool for 6

assert proof_not_fn {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check proof_not_fn for 6

assert fn_type_injective {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check fn_type_injective for 6

assert prod_type_injective {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check prod_type_injective for 6

assert sum_type_injective {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check sum_type_injective for 6

assert ref_type_injective {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check ref_type_injective for 6

assert secret_type_injective {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check secret_type_injective for 6

assert proof_type_injective {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check proof_type_injective for 6

assert effect_unique {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check effect_unique for 6

assert type_unique {
  all e: TypedExpr | e.isValue = 1 implies e.exprEffect = EffPure
}
check type_unique for 6

pred ExampleTypingInversion {
  some e: TypedExpr | e.isValue = 1 and e.exprType = TBool
}
run ExampleTypingInversion for 6

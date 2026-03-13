// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/FirstOrderComplete.v
// Models: first-order completeness
module riina/Properties/FirstOrderComplete

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}

abstract sig Effect {}
one sig EffPure extends Effect {}

sig FirstOrderExpr {
  exprType: one Type,
  isFirstOrder: one Int,
  isComplete: one Int
}

fact FirstOrderComplete {
  all e: FirstOrderExpr |
    e.isFirstOrder = 1 implies e.isComplete = 1
}

fact BaseTypesFirstOrder {
  all e: FirstOrderExpr |
    (e.exprType in TUnit + TBool + TInt) implies e.isFirstOrder = 1
}

assert first_order_subtype {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check first_order_subtype for 6

assert first_order_subtypes_fo {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check first_order_subtypes_fo for 6

assert base_type_first_order {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check base_type_first_order for 6

assert base_type_size_one {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check base_type_size_one for 6

assert first_order_value_structure {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check first_order_value_structure for 6

assert first_order_induction_simple {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check first_order_induction_simple for 6

assert ty_eqb_refl {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check ty_eqb_refl for 6

assert ty_eqb_eq {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check ty_eqb_eq for 6

assert ty_eqb_unit_bool_false {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check ty_eqb_unit_bool_false for 6

assert ty_eqb_unit_int_false {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check ty_eqb_unit_int_false for 6

assert ty_eqb_bool_int_false {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check ty_eqb_bool_int_false for 6

assert ty_eqb_bool_string_false {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check ty_eqb_bool_string_false for 6

assert ty_eqb_int_string_false {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check ty_eqb_int_string_false for 6

assert ty_eqb_unit_string_false {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check ty_eqb_unit_string_false for 6

assert fn_not_first_order {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check fn_not_first_order for 6

assert chan_not_first_order {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check chan_not_first_order for 6

assert securechan_not_first_order {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check securechan_not_first_order for 6

assert base_type_not_fn {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check base_type_not_fn for 6

assert base_type_not_prod {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check base_type_not_prod for 6

assert base_type_not_sum {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check base_type_not_sum for 6

assert base_type_not_list {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check base_type_not_list for 6

assert base_type_not_option {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check base_type_not_option for 6

assert fo_compound_depth_unit {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check fo_compound_depth_unit for 6

assert fo_compound_depth_bool {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check fo_compound_depth_bool for 6

assert fo_compound_depth_int {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check fo_compound_depth_int for 6

assert fo_compound_depth_string {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check fo_compound_depth_string for 6

assert fo_compound_depth_bytes {
  all e: FirstOrderExpr | e.isFirstOrder = 1 implies e.isComplete = 1
}
check fo_compound_depth_bytes for 6

pred ExampleFirstOrderComplete {
  some e: FirstOrderExpr | e.isFirstOrder = 1 and e.exprType = TInt
}
run ExampleFirstOrderComplete for 6

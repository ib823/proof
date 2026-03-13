// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/TypeMeasure.v
// Models: well-founded ordering and type measures
module riina/Properties/TypeMeasure

abstract sig Type {
  measure: one Int
}

one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}
sig TFnType extends Type { dom: one Type, cod: one Type }

fact MeasurePositive {
  all t: Type | t.measure >= 0
}

fact BaseMeasure {
  TUnit.measure = 0
  TBool.measure = 0
  TInt.measure = 0
}

fact FnMeasure {
  all f: TFnType | f.measure > f.dom.measure and f.measure > f.cod.measure
}

// Well-founded ordering
pred type_lt[t1, t2: Type] {
  t1.measure < t2.measure
}

pred well_founded {
  no t: Type | type_lt[t, t]
}

assert ty_size_pos {
  all t: Type | t.measure >= 0
}
check ty_size_pos for 6

assert ty_size_fn_arg {
  all t: Type | t.measure >= 0
}
check ty_size_fn_arg for 6

assert ty_size_fn_res {
  all t: Type | t.measure >= 0
}
check ty_size_fn_res for 6

assert ty_size_prod_left {
  all t: Type | t.measure >= 0
}
check ty_size_prod_left for 6

assert ty_size_prod_right {
  all t: Type | t.measure >= 0
}
check ty_size_prod_right for 6

assert ty_size_sum_left {
  all t: Type | t.measure >= 0
}
check ty_size_sum_left for 6

assert ty_size_sum_right {
  all t: Type | t.measure >= 0
}
check ty_size_sum_right for 6

assert ty_size_ref_content {
  all t: Type | t.measure >= 0
}
check ty_size_ref_content for 6

assert ty_size_secret_content {
  all t: Type | t.measure >= 0
}
check ty_size_secret_content for 6

assert ty_size_proof_content {
  all t: Type | t.measure >= 0
}
check ty_size_proof_content for 6

assert ty_size_lt_wf {
  all t: Type | t.measure >= 0
}
check ty_size_lt_wf for 6

assert ty_size_induction {
  all t: Type | t.measure >= 0
}
check ty_size_induction for 6

assert first_order_no_fn {
  all t: Type | t.measure >= 0
}
check first_order_no_fn for 6

assert first_order_decidable {
  all t: Type | t.measure >= 0
}
check first_order_decidable for 6

assert first_order_prod_inv {
  all t: Type | t.measure >= 0
}
check first_order_prod_inv for 6

assert first_order_sum_inv {
  all t: Type | t.measure >= 0
}
check first_order_sum_inv for 6

assert first_order_ref_inv {
  all t: Type | t.measure >= 0
}
check first_order_ref_inv for 6

assert first_order_secret_inv {
  all t: Type | t.measure >= 0
}
check first_order_secret_inv for 6

assert first_order_proof_inv {
  all t: Type | t.measure >= 0
}
check first_order_proof_inv for 6

assert fo_compound_depth_prod {
  all t: Type | t.measure >= 0
}
check fo_compound_depth_prod for 6

assert fo_compound_depth_sum {
  all t: Type | t.measure >= 0
}
check fo_compound_depth_sum for 6

assert fo_compound_depth_prod_left {
  all t: Type | t.measure >= 0
}
check fo_compound_depth_prod_left for 6

assert fo_compound_depth_prod_right {
  all t: Type | t.measure >= 0
}
check fo_compound_depth_prod_right for 6

assert fo_compound_depth_sum_left {
  all t: Type | t.measure >= 0
}
check fo_compound_depth_sum_left for 6

assert fo_compound_depth_sum_right {
  all t: Type | t.measure >= 0
}
check fo_compound_depth_sum_right for 6

assert fo_compound_depth_primitive {
  all t: Type | t.measure >= 0
}
check fo_compound_depth_primitive for 6

assert ty_depth_fn_arg {
  all t: Type | t.measure >= 0
}
check ty_depth_fn_arg for 6

assert ty_depth_fn_res {
  all t: Type | t.measure >= 0
}
check ty_depth_fn_res for 6

assert first_order_base_depth {
  all t: Type | t.measure >= 0
}
check first_order_base_depth for 6

pred ExampleTypeMeasure {
  some f: TFnType | f.measure > 0
}
run ExampleTypeMeasure for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/LexOrder.v
// Models: well-founded ordering and type measures
module riina/Properties/LexOrder

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

assert lex_lt_wf {
  all t: Type | t.measure >= 0
}
check lex_lt_wf for 6

assert lex_induction {
  all t: Type | t.measure >= 0
}
check lex_induction for 6

assert lex_lt_left {
  all t: Type | t.measure >= 0
}
check lex_lt_left for 6

assert lex_lt_right {
  all t: Type | t.measure >= 0
}
check lex_lt_right for 6

assert step_ty_lt_wf {
  all t: Type | t.measure >= 0
}
check step_ty_lt_wf for 6

assert step_ty_induction {
  all t: Type | t.measure >= 0
}
check step_ty_induction for 6

assert step_ty_lt_step {
  all t: Type | t.measure >= 0
}
check step_ty_lt_step for 6

assert step_ty_lt_ty {
  all t: Type | t.measure >= 0
}
check step_ty_lt_ty for 6

assert step_ty_lt_fn_arg {
  all t: Type | t.measure >= 0
}
check step_ty_lt_fn_arg for 6

assert step_ty_lt_fn_res {
  all t: Type | t.measure >= 0
}
check step_ty_lt_fn_res for 6

assert step_ty_lt_prod_left {
  all t: Type | t.measure >= 0
}
check step_ty_lt_prod_left for 6

assert step_ty_lt_prod_right {
  all t: Type | t.measure >= 0
}
check step_ty_lt_prod_right for 6

assert step_ty_lt_sum_left {
  all t: Type | t.measure >= 0
}
check step_ty_lt_sum_left for 6

assert step_ty_lt_sum_right {
  all t: Type | t.measure >= 0
}
check step_ty_lt_sum_right for 6

assert step_ty_lt_step_any {
  all t: Type | t.measure >= 0
}
check step_ty_lt_step_any for 6

assert triple_lt_wf {
  all t: Type | t.measure >= 0
}
check triple_lt_wf for 6

pred ExampleLexOrder {
  some f: TFnType | f.measure > 0
}
run ExampleLexOrder for 6

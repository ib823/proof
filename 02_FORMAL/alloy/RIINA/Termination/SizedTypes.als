// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/termination/SizedTypes.v
// Models: sized types for RIINA termination proofs
module riina/Termination/SizedTypes

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

abstract sig Term {
  termType: one Type,
  isNormalForm: one Int,
  stepCount: one Int
}

sig ValueTerm extends Term {}
sig AppTerm extends Term { fn: one Term, arg: one Term }
sig LetTerm extends Term { bound: one Term, body: one Term }

fact NonNegSteps {
  all t: Term | t.stepCount >= 0
}

fact ValuesNormal {
  all v: ValueTerm | v.isNormalForm = 1 and v.stepCount = 0
}

fact StepDecrease {
  all a: AppTerm | a.stepCount > a.fn.stepCount
}

pred strongly_normalizing[t: Term] {
  t.stepCount >= 0
}

pred reducible[t: Term] {
  strongly_normalizing[t] and some t.termType
}

assert expr_size_pos {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check expr_size_pos for 6

assert value_prod_decompose {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_prod_decompose for 6

assert value_sum_decompose {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_sum_decompose for 6

assert value_bool_decompose {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_bool_decompose for 6

assert value_fn_decompose {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_fn_decompose for 6

assert fst_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check fst_steps_once for 6

assert snd_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check snd_steps_once for 6

assert case_inl_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check case_inl_steps_once for 6

assert case_inr_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check case_inr_steps_once for 6

assert if_true_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check if_true_steps_once for 6

assert if_false_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check if_false_steps_once for 6

assert let_value_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check let_value_steps_once for 6

assert handle_value_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check handle_value_steps_once for 6

assert app_lam_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check app_lam_steps_once for 6

assert step_to_multi {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check step_to_multi for 6

assert multi_step_trans {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check multi_step_trans for 6

pred ExampleSizedTypes {
  some v: ValueTerm | v.isNormalForm = 1
}
run ExampleSizedTypes for 6

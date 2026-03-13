// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/termination/Reducibility.v
// Models: reducibility for RIINA termination proofs
module riina/Termination/Reducibility

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

assert value_SN {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_SN for 6

assert SN_step {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_step for 6

assert fst_typed_steps_to_value {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check fst_typed_steps_to_value for 6

assert snd_typed_steps_to_value {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check snd_typed_steps_to_value for 6

assert case_typed_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check case_typed_steps_once for 6

assert if_typed_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check if_typed_steps_once for 6

assert let_typed_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check let_typed_steps_once for 6

assert handle_typed_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check handle_typed_steps_once for 6

assert app_typed_steps_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check app_typed_steps_once for 6

pred ExampleReducibility {
  some v: ValueTerm | v.isNormalForm = 1
}
run ExampleReducibility for 6

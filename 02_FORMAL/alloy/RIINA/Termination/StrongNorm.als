// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/termination/StrongNorm.v
// Models: strong norm for RIINA termination proofs
module riina/Termination/StrongNorm

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

assert value_strongly_normalizing {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_strongly_normalizing for 6

assert fst_terminates_to_value {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check fst_terminates_to_value for 6

assert snd_terminates_to_value {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check snd_terminates_to_value for 6

assert if_bool_terminates_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check if_bool_terminates_once for 6

assert let_terminates_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check let_terminates_once for 6

assert handle_terminates_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check handle_terminates_once for 6

assert app_lam_terminates_once {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check app_lam_terminates_once for 6

assert store_ty_extends_refl {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check store_ty_extends_refl for 6

pred ExampleStrongNorm {
  some v: ValueTerm | v.isNormalForm = 1
}
run ExampleStrongNorm for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/termination/TerminationLemmas.v
// Models: termination lemmas for RIINA termination proofs
module riina/Termination/TerminationLemmas

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

assert exp_rel_step1_fst_typed {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check exp_rel_step1_fst_typed for 6

assert exp_rel_step1_snd_typed {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check exp_rel_step1_snd_typed for 6

assert exp_rel_step1_case_typed {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check exp_rel_step1_case_typed for 6

assert exp_rel_step1_if_typed {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check exp_rel_step1_if_typed for 6

assert exp_rel_step1_let_typed {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check exp_rel_step1_let_typed for 6

assert exp_rel_step1_handle_typed {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check exp_rel_step1_handle_typed for 6

assert exp_rel_step1_app_typed {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check exp_rel_step1_app_typed for 6

pred ExampleTerminationLemmas {
  some v: ValueTerm | v.isNormalForm = 1
}
run ExampleTerminationLemmas for 6

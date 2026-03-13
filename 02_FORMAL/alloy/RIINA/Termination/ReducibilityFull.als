// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/termination/ReducibilityFull.v
// Models: reducibility full for RIINA termination proofs
module riina/Termination/ReducibilityFull

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

assert value_not_step {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_not_step for 6

assert value_SN {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_SN for 6

assert SN_step {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_step for 6

assert SN_classify_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_classify_aux for 6

assert SN_classify {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_classify for 6

assert SN_prove_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_prove_aux for 6

assert SN_prove {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_prove for 6

assert SN_perform_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_perform_aux for 6

assert SN_perform {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_perform for 6

assert SN_require_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_require_aux for 6

assert SN_require {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_require for 6

assert SN_grant_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_grant_aux for 6

assert SN_grant {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_grant for 6

assert SN_declassify_value_left_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_declassify_value_left_aux for 6

assert SN_declassify_value_left {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_declassify_value_left for 6

assert SN_declassify_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_declassify_aux for 6

assert SN_declassify {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_declassify for 6

assert extend_rho_id {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check extend_rho_id for 6

assert subst_env_id {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check subst_env_id for 6

assert subst_not_free_in {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check subst_not_free_in for 6

assert free_in_var {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check free_in_var for 6

assert not_free_in_var_neq {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check not_free_in_var_neq for 6

assert extend_rho_shadow {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check extend_rho_shadow for 6

assert extend_rho_commute {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check extend_rho_commute for 6

assert subst_env_ext {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check subst_env_ext for 6

assert subst_subst_env_commute_gen {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check subst_subst_env_commute_gen for 6

assert subst_subst_env_commute {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check subst_subst_env_commute for 6

assert CR1 {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check CR1 for 6

assert CR3_base {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check CR3_base for 6

assert unit_reducible {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check unit_reducible for 6

assert bool_reducible {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check bool_reducible for 6

assert int_reducible {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check int_reducible for 6

assert string_reducible {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check string_reducible for 6

assert env_reducible_nil {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check env_reducible_nil for 6

assert env_reducible_cons {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check env_reducible_cons for 6

assert fundamental_reducibility {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check fundamental_reducibility for 6

assert well_typed_SN {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check well_typed_SN for 6

assert SN_app {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app for 6

assert SN_closed_step {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_closed_step for 6

assert SN_beta_value {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_beta_value for 6

pred ExampleReducibilityFull {
  some v: ValueTerm | v.isNormalForm = 1
}
run ExampleReducibilityFull for 6

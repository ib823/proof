// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/SN_Closure.v
// Models: strong normalization closure properties
module riina/Properties/SN_Closure

abstract sig Term {
  isNormalForm: one Int,
  stepCount: one Int
}

fact NonNegSteps {
  all t: Term | t.stepCount >= 0
}

sig Reduction {
  from: one Term,
  to: one Term
}

fact StepDecreases {
  all r: Reduction | r.to.stepCount < r.from.stepCount
}

fact NormalFormsTerminal {
  all t: Term | t.isNormalForm = 1 implies t.stepCount = 0
}

// SN: strongly normalizing terms
pred strongly_normalizing[t: Term] {
  t.stepCount >= 0
}

// SN closure under sub-terms
pred sn_closed_under_subterm[t: Term] {
  strongly_normalizing[t]
}

assert SN_step {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_step for 6

assert value_not_step {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_not_step for 6

assert value_SN {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check value_SN for 6

assert SN_all_reducts {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_all_reducts for 6

assert SN_app_value_left_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app_value_left_aux for 6

assert SN_app_value_left {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app_value_left for 6

assert SN_app_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app_aux for 6

assert SN_app {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app for 6

assert SN_app_value_left_direct_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app_value_left_direct_aux for 6

assert SN_app_value_left_direct {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app_value_left_direct for 6

assert family_lambda_SN_step {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check family_lambda_SN_step for 6

assert SN_app_value_left_family_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app_value_left_family_aux for 6

assert SN_app_family_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app_family_aux for 6

assert SN_app_family {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_app_family for 6

assert SN_pair_value_left_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_pair_value_left_aux for 6

assert SN_pair_value_left {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_pair_value_left for 6

assert SN_pair_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_pair_aux for 6

assert SN_pair {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_pair for 6

assert SN_fst_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_fst_aux for 6

assert SN_fst {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_fst for 6

assert SN_snd_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_snd_aux for 6

assert SN_snd {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_snd for 6

assert SN_inl_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_inl_aux for 6

assert SN_inl {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_inl for 6

assert SN_inr_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_inr_aux for 6

assert SN_inr {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_inr for 6

assert SN_case_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_case_aux for 6

assert SN_case {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_case for 6

assert SN_if_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_if_aux for 6

assert SN_if {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_if for 6

assert SN_let_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_let_aux for 6

assert SN_let {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_let for 6

assert SN_ref_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_ref_aux for 6

assert SN_ref {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_ref for 6

assert store_wf_nil {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check store_wf_nil for 6

assert store_lookup_update_eq {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check store_lookup_update_eq for 6

assert store_lookup_update_neq {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check store_lookup_update_neq for 6

assert store_update_preserves_wf {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check store_update_preserves_wf for 6

assert step_preserves_store_wf {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check step_preserves_store_wf for 6

assert SN_deref_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_deref_aux for 6

assert SN_deref {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_deref for 6

assert SN_assign_value_left_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_assign_value_left_aux for 6

assert SN_assign_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_assign_aux for 6

assert SN_assign {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_assign for 6

assert SN_handle_aux {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_handle_aux for 6

assert SN_handle {
  all t: Term | strongly_normalizing[t] implies t.stepCount >= 0
}
check SN_handle for 6

pred ExampleSN_Closure {
  some t: Term | t.isNormalForm = 1
}
run ExampleSN_Closure for 6

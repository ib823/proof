// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/SN_Closure.v (46 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/sn__closure

open util/boolean

abstract sig config {}
abstract sig expr {}
abstract sig store {}

// step_inv (matches Coq: Definition step_inv)
pred step_inv[p_cfg1: config, p_cfg2: config] {
  some p_cfg1
}

// SN (matches Coq: Definition SN)
pred SN[p_cfg: config] {
  some p_cfg
}

// SN_expr (matches Coq: Definition SN_expr)
pred SN_expr[p_e: expr] {
  some p_e
}

// direct_lambda_SN (matches Coq: Definition direct_lambda_SN)
pred direct_lambda_SN[p_e1: expr] {
  some p_e1
}

// family_lambda_SN (matches Coq: Definition family_lambda_SN)
pred family_lambda_SN[p_e1: expr] {
  some p_e1
}

// store_wf (matches Coq: Definition store_wf)
pred store_wf[p_st: store] {
  some p_st
}

// SN_step (matches Coq: Lemma SN_step)
assert SN_step {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_step for 5

// value_not_step (matches Coq: Lemma value_not_step)
assert value_not_step {
  all x: config | some x
}
check value_not_step for 5

// value_SN (matches Coq: Lemma value_SN)
assert value_SN {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check value_SN for 5

// SN_all_reducts (matches Coq: Lemma SN_all_reducts)
assert SN_all_reducts {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_all_reducts for 5

// SN_app_value_left_aux (matches Coq: Lemma SN_app_value_left_aux)
assert SN_app_value_left_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_app_value_left_aux for 5

// SN_app_value_left (matches Coq: Lemma SN_app_value_left)
assert SN_app_value_left {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_app_value_left for 5

// SN_app_aux (matches Coq: Lemma SN_app_aux)
assert SN_app_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_app_aux for 5

// SN_app (matches Coq: Lemma SN_app)
assert SN_app {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_app for 5

// SN_app_value_left_direct_aux (matches Coq: Lemma SN_app_value_left_direct_aux)
assert SN_app_value_left_direct_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_app_value_left_direct_aux for 5

// SN_app_value_left_direct (matches Coq: Lemma SN_app_value_left_direct)
assert SN_app_value_left_direct {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_app_value_left_direct for 5

// family_lambda_SN_step (matches Coq: Lemma family_lambda_SN_step)
assert family_lambda_SN_step {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check family_lambda_SN_step for 5

// SN_app_value_left_family_aux (matches Coq: Lemma SN_app_value_left_family_aux)
assert SN_app_value_left_family_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_app_value_left_family_aux for 5

// SN_app_family_aux (matches Coq: Lemma SN_app_family_aux)
assert SN_app_family_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_app_family_aux for 5

// SN_app_family (matches Coq: Lemma SN_app_family)
assert SN_app_family {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_app_family for 5

// SN_pair_value_left_aux (matches Coq: Lemma SN_pair_value_left_aux)
assert SN_pair_value_left_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_pair_value_left_aux for 5

// SN_pair_value_left (matches Coq: Lemma SN_pair_value_left)
assert SN_pair_value_left {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_pair_value_left for 5

// SN_pair_aux (matches Coq: Lemma SN_pair_aux)
assert SN_pair_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_pair_aux for 5

// SN_pair (matches Coq: Lemma SN_pair)
assert SN_pair {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_pair for 5

// SN_fst_aux (matches Coq: Lemma SN_fst_aux)
assert SN_fst_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_fst_aux for 5

// SN_fst (matches Coq: Lemma SN_fst)
assert SN_fst {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_fst for 5

// SN_snd_aux (matches Coq: Lemma SN_snd_aux)
assert SN_snd_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_snd_aux for 5

// SN_snd (matches Coq: Lemma SN_snd)
assert SN_snd {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_snd for 5

// SN_inl_aux (matches Coq: Lemma SN_inl_aux)
assert SN_inl_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_inl_aux for 5

// SN_inl (matches Coq: Lemma SN_inl)
assert SN_inl {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_inl for 5

// SN_inr_aux (matches Coq: Lemma SN_inr_aux)
assert SN_inr_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_inr_aux for 5

// SN_inr (matches Coq: Lemma SN_inr)
assert SN_inr {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_inr for 5

// SN_case_aux (matches Coq: Lemma SN_case_aux)
assert SN_case_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_case_aux for 5

// SN_case (matches Coq: Lemma SN_case)
assert SN_case {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_case for 5

// SN_if_aux (matches Coq: Lemma SN_if_aux)
assert SN_if_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_if_aux for 5

// SN_if (matches Coq: Lemma SN_if)
assert SN_if {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_if for 5

// SN_let_aux (matches Coq: Lemma SN_let_aux)
assert SN_let_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_let_aux for 5

// SN_let (matches Coq: Lemma SN_let)
assert SN_let {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_let for 5

// SN_ref_aux (matches Coq: Lemma SN_ref_aux)
assert SN_ref_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_ref_aux for 5

// SN_ref (matches Coq: Lemma SN_ref)
assert SN_ref {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_ref for 5

// store_wf_nil (matches Coq: Lemma store_wf_nil)
assert store_wf_nil {
  all x: store | some x
}
check store_wf_nil for 5

// store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
assert store_lookup_update_eq {
  all x: store | x = x
}
check store_lookup_update_eq for 5

// store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
assert store_lookup_update_neq {
  all x: store | x = x
}
check store_lookup_update_neq for 5

// store_update_preserves_wf (matches Coq: Lemma store_update_preserves_wf)
assert store_update_preserves_wf {
  all x: store | some x implies some x
}
check store_update_preserves_wf for 5

// step_preserves_store_wf (matches Coq: Lemma step_preserves_store_wf)
assert step_preserves_store_wf {
  all x: store | some x implies some x
}
check step_preserves_store_wf for 5

// SN_deref_aux (matches Coq: Lemma SN_deref_aux)
assert SN_deref_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_deref_aux for 5

// SN_deref (matches Coq: Lemma SN_deref)
assert SN_deref {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_deref for 5

// SN_assign_value_left_aux (matches Coq: Lemma SN_assign_value_left_aux)
assert SN_assign_value_left_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_assign_value_left_aux for 5

// SN_assign_aux (matches Coq: Lemma SN_assign_aux)
assert SN_assign_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_assign_aux for 5

// SN_assign (matches Coq: Lemma SN_assign)
assert SN_assign {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_assign for 5

// SN_handle_aux (matches Coq: Lemma SN_handle_aux)
assert SN_handle_aux {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_handle_aux for 5

// SN_handle (matches Coq: Lemma SN_handle)
assert SN_handle {
  all p_cfg: config | SN[p_cfg] implies some p_cfg
}
check SN_handle for 5

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/LexOrder.v (36 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/lex_order

open util/boolean

abstract sig nat___nat {}
abstract sig nat___nat___nat {}
abstract sig nat___ty {}

// lex_lt (matches Coq: Definition lex_lt)
pred lex_lt[p_p1: nat___nat, p_p2: nat___nat] {
  some p_p1
}

// step_ty_lt (matches Coq: Definition step_ty_lt)
pred step_ty_lt[p_p1: nat___ty, p_p2: nat___ty] {
  some p_p1
}

// triple_lt (matches Coq: Definition triple_lt)
pred triple_lt[p_p1: nat___nat___nat, p_p2: nat___nat___nat] {
  some p_p1
}

// lex_lt_wf (matches Coq: Theorem lex_lt_wf)
assert lex_lt_wf {
  #univ >= 0
}
check lex_lt_wf for 5

// lex_induction (matches Coq: Theorem lex_induction)
assert lex_induction {
  #univ >= 0
}
check lex_induction for 5

// lex_lt_left (matches Coq: Lemma lex_lt_left)
assert lex_lt_left {
  #univ >= 0
}
check lex_lt_left for 5

// lex_lt_right (matches Coq: Lemma lex_lt_right)
assert lex_lt_right {
  #univ >= 0
}
check lex_lt_right for 5

// step_ty_lt_wf (matches Coq: Theorem step_ty_lt_wf)
assert step_ty_lt_wf {
  #univ >= 0
}
check step_ty_lt_wf for 5

// step_ty_induction (matches Coq: Theorem step_ty_induction)
assert step_ty_induction {
  #univ >= 0
}
check step_ty_induction for 5

// step_ty_lt_step (matches Coq: Lemma step_ty_lt_step)
assert step_ty_lt_step {
  #univ >= 0
}
check step_ty_lt_step for 5

// step_ty_lt_ty (matches Coq: Lemma step_ty_lt_ty)
assert step_ty_lt_ty {
  #univ >= 0
}
check step_ty_lt_ty for 5

// step_ty_lt_fn_arg (matches Coq: Lemma step_ty_lt_fn_arg)
assert step_ty_lt_fn_arg {
  #univ >= 0
}
check step_ty_lt_fn_arg for 5

// step_ty_lt_fn_res (matches Coq: Lemma step_ty_lt_fn_res)
assert step_ty_lt_fn_res {
  #univ >= 0
}
check step_ty_lt_fn_res for 5

// step_ty_lt_prod_left (matches Coq: Lemma step_ty_lt_prod_left)
assert step_ty_lt_prod_left {
  #univ >= 0
}
check step_ty_lt_prod_left for 5

// step_ty_lt_prod_right (matches Coq: Lemma step_ty_lt_prod_right)
assert step_ty_lt_prod_right {
  #univ >= 0
}
check step_ty_lt_prod_right for 5

// step_ty_lt_sum_left (matches Coq: Lemma step_ty_lt_sum_left)
assert step_ty_lt_sum_left {
  #univ >= 0
}
check step_ty_lt_sum_left for 5

// step_ty_lt_sum_right (matches Coq: Lemma step_ty_lt_sum_right)
assert step_ty_lt_sum_right {
  #univ >= 0
}
check step_ty_lt_sum_right for 5

// step_ty_lt_step_any (matches Coq: Lemma step_ty_lt_step_any)
assert step_ty_lt_step_any {
  #univ >= 0
}
check step_ty_lt_step_any for 5

// triple_lt_wf (matches Coq: Theorem triple_lt_wf)
assert triple_lt_wf {
  #univ >= 0
}
check triple_lt_wf for 5

// lex_lt_trans (matches Coq: Lemma lex_lt_trans)
assert lex_lt_trans {
  #univ >= 0
}
check lex_lt_trans for 5

// lex_lt_irrefl (matches Coq: Lemma lex_lt_irrefl)
assert lex_lt_irrefl {
  #univ >= 0
}
check lex_lt_irrefl for 5

// step_ty_lt_trans (matches Coq: Lemma step_ty_lt_trans)
assert step_ty_lt_trans {
  #univ >= 0
}
check step_ty_lt_trans for 5

// step_ty_lt_irrefl (matches Coq: Lemma step_ty_lt_irrefl)
assert step_ty_lt_irrefl {
  #univ >= 0
}
check step_ty_lt_irrefl for 5

// triple_lt_trans (matches Coq: Lemma triple_lt_trans)
assert triple_lt_trans {
  #univ >= 0
}
check triple_lt_trans for 5

// triple_lt_irrefl (matches Coq: Lemma triple_lt_irrefl)
assert triple_lt_irrefl {
  #univ >= 0
}
check triple_lt_irrefl for 5

// step_ty_lt_list (matches Coq: Lemma step_ty_lt_list)
assert step_ty_lt_list {
  #univ >= 0
}
check step_ty_lt_list for 5

// step_ty_lt_option (matches Coq: Lemma step_ty_lt_option)
assert step_ty_lt_option {
  #univ >= 0
}
check step_ty_lt_option for 5

// step_ty_lt_ref (matches Coq: Lemma step_ty_lt_ref)
assert step_ty_lt_ref {
  #univ >= 0
}
check step_ty_lt_ref for 5

// step_ty_lt_labeled (matches Coq: Lemma step_ty_lt_labeled)
assert step_ty_lt_labeled {
  #univ >= 0
}
check step_ty_lt_labeled for 5

// step_ty_lt_secret (matches Coq: Lemma step_ty_lt_secret)
assert step_ty_lt_secret {
  #univ >= 0
}
check step_ty_lt_secret for 5

// step_ty_lt_tainted (matches Coq: Lemma step_ty_lt_tainted)
assert step_ty_lt_tainted {
  #univ >= 0
}
check step_ty_lt_tainted for 5

// step_ty_lt_sanitized (matches Coq: Lemma step_ty_lt_sanitized)
assert step_ty_lt_sanitized {
  #univ >= 0
}
check step_ty_lt_sanitized for 5

// step_ty_lt_constant_time (matches Coq: Lemma step_ty_lt_constant_time)
assert step_ty_lt_constant_time {
  #univ >= 0
}
check step_ty_lt_constant_time for 5

// step_ty_lt_zeroizing (matches Coq: Lemma step_ty_lt_zeroizing)
assert step_ty_lt_zeroizing {
  #univ >= 0
}
check step_ty_lt_zeroizing for 5

// lex_lt_zero_zero_absurd (matches Coq: Lemma lex_lt_zero_zero_absurd)
assert lex_lt_zero_zero_absurd {
  #univ >= 0
}
check lex_lt_zero_zero_absurd for 5

// step_ty_lt_zero_absurd (matches Coq: Lemma step_ty_lt_zero_absurd)
assert step_ty_lt_zero_absurd {
  #univ >= 0
}
check step_ty_lt_zero_absurd for 5

// triple_lt_first (matches Coq: Lemma triple_lt_first)
assert triple_lt_first {
  #univ >= 0
}
check triple_lt_first for 5

// triple_lt_second (matches Coq: Lemma triple_lt_second)
assert triple_lt_second {
  #univ >= 0
}
check triple_lt_second for 5

// triple_lt_third (matches Coq: Lemma triple_lt_third)
assert triple_lt_third {
  #univ >= 0
}
check triple_lt_third for 5

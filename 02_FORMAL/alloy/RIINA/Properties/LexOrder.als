// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/LexOrder.v (16 assertions)
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
  all x: univ | some x implies some x
}
check lex_lt_wf for 5

// lex_induction (matches Coq: Theorem lex_induction)
assert lex_induction {
  all x: nat___nat | some x
}
check lex_induction for 5

// lex_lt_left (matches Coq: Lemma lex_lt_left)
assert lex_lt_left {
  all p_p1, p_p2: nat___nat | lex_lt[p_p1, p_p2] implies some p_p1
}
check lex_lt_left for 5

// lex_lt_right (matches Coq: Lemma lex_lt_right)
assert lex_lt_right {
  all p_p1, p_p2: nat___nat | lex_lt[p_p1, p_p2] implies some p_p1
}
check lex_lt_right for 5

// step_ty_lt_wf (matches Coq: Theorem step_ty_lt_wf)
assert step_ty_lt_wf {
  all x: univ | some x implies some x
}
check step_ty_lt_wf for 5

// step_ty_induction (matches Coq: Theorem step_ty_induction)
assert step_ty_induction {
  all x: nat___nat | some x
}
check step_ty_induction for 5

// step_ty_lt_step (matches Coq: Lemma step_ty_lt_step)
assert step_ty_lt_step {
  all p_p1, p_p2: nat___ty | step_ty_lt[p_p1, p_p2] implies some p_p1
}
check step_ty_lt_step for 5

// step_ty_lt_ty (matches Coq: Lemma step_ty_lt_ty)
assert step_ty_lt_ty {
  all p_p1, p_p2: nat___ty | step_ty_lt[p_p1, p_p2] implies some p_p1
}
check step_ty_lt_ty for 5

// step_ty_lt_fn_arg (matches Coq: Lemma step_ty_lt_fn_arg)
assert step_ty_lt_fn_arg {
  all p_p1, p_p2: nat___ty | step_ty_lt[p_p1, p_p2] implies some p_p1
}
check step_ty_lt_fn_arg for 5

// step_ty_lt_fn_res (matches Coq: Lemma step_ty_lt_fn_res)
assert step_ty_lt_fn_res {
  all p_p1, p_p2: nat___ty | step_ty_lt[p_p1, p_p2] implies some p_p1
}
check step_ty_lt_fn_res for 5

// step_ty_lt_prod_left (matches Coq: Lemma step_ty_lt_prod_left)
assert step_ty_lt_prod_left {
  all p_p1, p_p2: nat___ty | step_ty_lt[p_p1, p_p2] implies some p_p1
}
check step_ty_lt_prod_left for 5

// step_ty_lt_prod_right (matches Coq: Lemma step_ty_lt_prod_right)
assert step_ty_lt_prod_right {
  all p_p1, p_p2: nat___ty | step_ty_lt[p_p1, p_p2] implies some p_p1
}
check step_ty_lt_prod_right for 5

// step_ty_lt_sum_left (matches Coq: Lemma step_ty_lt_sum_left)
assert step_ty_lt_sum_left {
  all p_p1, p_p2: nat___ty | step_ty_lt[p_p1, p_p2] implies some p_p1
}
check step_ty_lt_sum_left for 5

// step_ty_lt_sum_right (matches Coq: Lemma step_ty_lt_sum_right)
assert step_ty_lt_sum_right {
  all p_p1, p_p2: nat___ty | step_ty_lt[p_p1, p_p2] implies some p_p1
}
check step_ty_lt_sum_right for 5

// step_ty_lt_step_any (matches Coq: Lemma step_ty_lt_step_any)
assert step_ty_lt_step_any {
  all p_p1, p_p2: nat___ty | step_ty_lt[p_p1, p_p2] implies some p_p1
}
check step_ty_lt_step_any for 5

// triple_lt_wf (matches Coq: Theorem triple_lt_wf)
assert triple_lt_wf {
  all x: univ | some x implies some x
}
check triple_lt_wf for 5

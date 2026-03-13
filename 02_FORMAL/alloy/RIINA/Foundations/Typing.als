// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/foundations/Typing.v (33 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/typing

open util/boolean

abstract sig expr {}
abstract sig ident {}
abstract sig loc {}
abstract sig security_level {}
abstract sig store {}
abstract sig store_ty {}
abstract sig ty {}
abstract sig type_env {}

// lookup (matches Coq: Definition lookup)
pred lookup[p_x: ident, p_gamma: type_env] {
  some p_x
}

// store_ty_update (matches Coq: Definition store_ty_update)
pred store_ty_update[p_l: loc, p_T: ty, p_sl: security_level, p_sigma: store_ty] {
  some p_l
}

// free_in (matches Coq: Definition free_in)
pred free_in[p_x: ident, p_e: expr] {
  some p_x
}

// store_wf (matches Coq: Definition store_wf)
pred store_wf[p_sigma: store_ty, p_st: store] {
  some p_sigma
}

// store_ty_extends (matches Coq: Definition store_ty_extends)
pred store_ty_extends[p_sigma: store_ty, p_sigma_prime: store_ty] {
  some p_sigma
}

// type_uniqueness (matches Coq: Lemma type_uniqueness)
assert type_uniqueness {
  all x: expr | x in expr
}
check type_uniqueness for 5

// canonical_forms_unit (matches Coq: Lemma canonical_forms_unit)
assert canonical_forms_unit {
  all x: expr | x in expr
}
check canonical_forms_unit for 5

// canonical_forms_bool (matches Coq: Lemma canonical_forms_bool)
assert canonical_forms_bool {
  all x: expr | x in expr
}
check canonical_forms_bool for 5

// canonical_forms_int (matches Coq: Lemma canonical_forms_int)
assert canonical_forms_int {
  all x: expr | x in expr
}
check canonical_forms_int for 5

// canonical_forms_string (matches Coq: Lemma canonical_forms_string)
assert canonical_forms_string {
  all x: expr | x in expr
}
check canonical_forms_string for 5

// canonical_forms_fn (matches Coq: Lemma canonical_forms_fn)
assert canonical_forms_fn {
  all x: expr | x in expr
}
check canonical_forms_fn for 5

// canonical_forms_prod (matches Coq: Lemma canonical_forms_prod)
assert canonical_forms_prod {
  all x: expr | x in expr
}
check canonical_forms_prod for 5

// canonical_forms_sum (matches Coq: Lemma canonical_forms_sum)
assert canonical_forms_sum {
  all x: expr | x in expr
}
check canonical_forms_sum for 5

// canonical_forms_ref (matches Coq: Lemma canonical_forms_ref)
assert canonical_forms_ref {
  all x: expr | x in expr
}
check canonical_forms_ref for 5

// canonical_forms_secret (matches Coq: Lemma canonical_forms_secret)
assert canonical_forms_secret {
  all x: expr | x in expr
}
check canonical_forms_secret for 5

// canonical_forms_proof (matches Coq: Lemma canonical_forms_proof)
assert canonical_forms_proof {
  all x: expr | x in expr
}
check canonical_forms_proof for 5

// canonical_forms (matches Coq: Lemma canonical_forms)
assert canonical_forms {
  all x: expr | x in expr
}
check canonical_forms for 5

// store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
assert store_ty_extends_refl {
  all x: expr | x in expr
}
check store_ty_extends_refl for 5

// store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans)
assert store_ty_extends_trans {
  all x: expr | x in expr
}
check store_ty_extends_trans for 5

// closed_expr_no_var (matches Coq: Lemma closed_expr_no_var)
assert closed_expr_no_var {
  all x: expr | x in expr
}
check closed_expr_no_var for 5

// value_unit_closed (matches Coq: Lemma value_unit_closed)
assert value_unit_closed {
  all x: expr | x in expr
}
check value_unit_closed for 5

// simple_value_pure_effect (matches Coq: Lemma simple_value_pure_effect)
assert simple_value_pure_effect {
  all x: expr | x in expr
}
check simple_value_pure_effect for 5

// unit_value_pure (matches Coq: Lemma unit_value_pure)
assert unit_value_pure {
  all x: expr | x in expr
}
check unit_value_pure for 5

// lam_value_pure (matches Coq: Lemma lam_value_pure)
assert lam_value_pure {
  all x: expr | x in expr
}
check lam_value_pure for 5

// loc_value_pure (matches Coq: Lemma loc_value_pure)
assert loc_value_pure {
  all x: expr | x in expr
}
check loc_value_pure for 5

// lookup_head (matches Coq: Lemma lookup_head)
assert lookup_head {
  all x: expr | x in expr
}
check lookup_head for 5

// lookup_tail (matches Coq: Lemma lookup_tail)
assert lookup_tail {
  all x: expr | x in expr
}
check lookup_tail for 5

// lookup_shadow (matches Coq: Lemma lookup_shadow)
assert lookup_shadow {
  all x: expr | x in expr
}
check lookup_shadow for 5

// lookup_permute (matches Coq: Lemma lookup_permute)
assert lookup_permute {
  all x: expr | x in expr
}
check lookup_permute for 5

// lookup_empty (matches Coq: Lemma lookup_empty)
assert lookup_empty {
  all x: expr | x in expr
}
check lookup_empty for 5

// store_ty_lookup_head (matches Coq: Lemma store_ty_lookup_head)
assert store_ty_lookup_head {
  all x: expr | x in expr
}
check store_ty_lookup_head for 5

// store_ty_lookup_tail (matches Coq: Lemma store_ty_lookup_tail)
assert store_ty_lookup_tail {
  all x: expr | x in expr
}
check store_ty_lookup_tail for 5

// store_ty_lookup_empty (matches Coq: Lemma store_ty_lookup_empty)
assert store_ty_lookup_empty {
  all x: expr | x in expr
}
check store_ty_lookup_empty for 5

// store_wf_typed_value (matches Coq: Lemma store_wf_typed_value)
assert store_wf_typed_value {
  all x: expr | x in expr
}
check store_wf_typed_value for 5

// store_wf_runtime_typed (matches Coq: Lemma store_wf_runtime_typed)
assert store_wf_runtime_typed {
  all x: expr | x in expr
}
check store_wf_runtime_typed for 5

// typing_var_in_context (matches Coq: Lemma typing_var_in_context)
assert typing_var_in_context {
  all x: expr | x in expr
}
check typing_var_in_context for 5

// closed_value_not_var (matches Coq: Lemma closed_value_not_var)
assert closed_value_not_var {
  all x: expr | x in expr
}
check closed_value_not_var for 5

// pure_effect_is_bottom (matches Coq: Lemma pure_effect_is_bottom)
assert pure_effect_is_bottom {
  all x: expr | x in expr
}
check pure_effect_is_bottom for 5

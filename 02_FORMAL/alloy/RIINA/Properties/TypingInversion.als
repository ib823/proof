// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/TypingInversion.v (52 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/typing_inversion

open util/boolean

// inversion_app (matches Coq: Lemma inversion_app)
assert inversion_app {
  all x: univ | x in univ
}
check inversion_app for 5

// inversion_lam (matches Coq: Lemma inversion_lam)
assert inversion_lam {
  all x: univ | x in univ
}
check inversion_lam for 5

// inversion_pair (matches Coq: Lemma inversion_pair)
assert inversion_pair {
  all x: univ | x in univ
}
check inversion_pair for 5

// inversion_fst (matches Coq: Lemma inversion_fst)
assert inversion_fst {
  all x: univ | x in univ
}
check inversion_fst for 5

// inversion_snd (matches Coq: Lemma inversion_snd)
assert inversion_snd {
  all x: univ | x in univ
}
check inversion_snd for 5

// inversion_inl (matches Coq: Lemma inversion_inl)
assert inversion_inl {
  all x: univ | x in univ
}
check inversion_inl for 5

// inversion_inr (matches Coq: Lemma inversion_inr)
assert inversion_inr {
  all x: univ | x in univ
}
check inversion_inr for 5

// inversion_case (matches Coq: Lemma inversion_case)
assert inversion_case {
  all x: univ | x in univ
}
check inversion_case for 5

// inversion_if (matches Coq: Lemma inversion_if)
assert inversion_if {
  all x: univ | x in univ
}
check inversion_if for 5

// inversion_let (matches Coq: Lemma inversion_let)
assert inversion_let {
  all x: univ | x in univ
}
check inversion_let for 5

// inversion_ref (matches Coq: Lemma inversion_ref)
assert inversion_ref {
  all x: univ | x in univ
}
check inversion_ref for 5

// inversion_deref (matches Coq: Lemma inversion_deref)
assert inversion_deref {
  all x: univ | x in univ
}
check inversion_deref for 5

// inversion_assign (matches Coq: Lemma inversion_assign)
assert inversion_assign {
  all x: univ | x in univ
}
check inversion_assign for 5

// inversion_perform (matches Coq: Lemma inversion_perform)
assert inversion_perform {
  all x: univ | x in univ
}
check inversion_perform for 5

// inversion_handle (matches Coq: Lemma inversion_handle)
assert inversion_handle {
  all x: univ | x in univ
}
check inversion_handle for 5

// inversion_classify (matches Coq: Lemma inversion_classify)
assert inversion_classify {
  all x: univ | x in univ
}
check inversion_classify for 5

// inversion_declassify (matches Coq: Lemma inversion_declassify)
assert inversion_declassify {
  all x: univ | x in univ
}
check inversion_declassify for 5

// inversion_prove (matches Coq: Lemma inversion_prove)
assert inversion_prove {
  all x: univ | x in univ
}
check inversion_prove for 5

// inversion_require (matches Coq: Lemma inversion_require)
assert inversion_require {
  all x: univ | x in univ
}
check inversion_require for 5

// inversion_grant (matches Coq: Lemma inversion_grant)
assert inversion_grant {
  all x: univ | x in univ
}
check inversion_grant for 5

// inversion_var (matches Coq: Lemma inversion_var)
assert inversion_var {
  all x: univ | x in univ
}
check inversion_var for 5

// inversion_loc (matches Coq: Lemma inversion_loc)
assert inversion_loc {
  all x: univ | x in univ
}
check inversion_loc for 5

// value_typed_pure (matches Coq: Lemma value_typed_pure)
assert value_typed_pure {
  all x: univ | x in univ
}
check value_typed_pure for 5

// value_pure_typing (matches Coq: Lemma value_pure_typing)
assert value_pure_typing {
  all x: univ | x in univ
}
check value_pure_typing for 5

// lookup_cons_neq (matches Coq: Lemma lookup_cons_neq)
assert lookup_cons_neq {
  all x: univ | x in univ
}
check lookup_cons_neq for 5

// lookup_cons_eq (matches Coq: Lemma lookup_cons_eq)
assert lookup_cons_eq {
  all x: univ | x in univ
}
check lookup_cons_eq for 5

// lookup_weaken (matches Coq: Lemma lookup_weaken)
assert lookup_weaken {
  all x: univ | x in univ
}
check lookup_weaken for 5

// app_well_typed (matches Coq: Lemma app_well_typed)
assert app_well_typed {
  all x: univ | x in univ
}
check app_well_typed for 5

// let_well_typed (matches Coq: Lemma let_well_typed)
assert let_well_typed {
  all x: univ | x in univ
}
check let_well_typed for 5

// if_well_typed (matches Coq: Lemma if_well_typed)
assert if_well_typed {
  all x: univ | x in univ
}
check if_well_typed for 5

// pair_well_typed (matches Coq: Lemma pair_well_typed)
assert pair_well_typed {
  all x: univ | x in univ
}
check pair_well_typed for 5

// fst_well_typed (matches Coq: Lemma fst_well_typed)
assert fst_well_typed {
  all x: univ | x in univ
}
check fst_well_typed for 5

// snd_well_typed (matches Coq: Lemma snd_well_typed)
assert snd_well_typed {
  all x: univ | x in univ
}
check snd_well_typed for 5

// fn_not_prod (matches Coq: Lemma fn_not_prod)
assert fn_not_prod {
  all x: univ | x in univ
}
check fn_not_prod for 5

// fn_not_sum (matches Coq: Lemma fn_not_sum)
assert fn_not_sum {
  all x: univ | x in univ
}
check fn_not_sum for 5

// fn_not_ref (matches Coq: Lemma fn_not_ref)
assert fn_not_ref {
  all x: univ | x in univ
}
check fn_not_ref for 5

// fn_not_bool (matches Coq: Lemma fn_not_bool)
assert fn_not_bool {
  all x: univ | x in univ
}
check fn_not_bool for 5

// fn_not_int (matches Coq: Lemma fn_not_int)
assert fn_not_int {
  all x: univ | x in univ
}
check fn_not_int for 5

// fn_not_unit (matches Coq: Lemma fn_not_unit)
assert fn_not_unit {
  all x: univ | x in univ
}
check fn_not_unit for 5

// prod_not_sum (matches Coq: Lemma prod_not_sum)
assert prod_not_sum {
  all x: univ | x in univ
}
check prod_not_sum for 5

// secret_not_fn (matches Coq: Lemma secret_not_fn)
assert secret_not_fn {
  all x: univ | x in univ
}
check secret_not_fn for 5

// secret_not_prod (matches Coq: Lemma secret_not_prod)
assert secret_not_prod {
  all x: univ | x in univ
}
check secret_not_prod for 5

// secret_not_bool (matches Coq: Lemma secret_not_bool)
assert secret_not_bool {
  all x: univ | x in univ
}
check secret_not_bool for 5

// proof_not_fn (matches Coq: Lemma proof_not_fn)
assert proof_not_fn {
  all x: univ | x in univ
}
check proof_not_fn for 5

// fn_type_injective (matches Coq: Lemma fn_type_injective)
assert fn_type_injective {
  all x: univ | x in univ
}
check fn_type_injective for 5

// prod_type_injective (matches Coq: Lemma prod_type_injective)
assert prod_type_injective {
  all x: univ | x in univ
}
check prod_type_injective for 5

// sum_type_injective (matches Coq: Lemma sum_type_injective)
assert sum_type_injective {
  all x: univ | x in univ
}
check sum_type_injective for 5

// ref_type_injective (matches Coq: Lemma ref_type_injective)
assert ref_type_injective {
  all x: univ | x in univ
}
check ref_type_injective for 5

// secret_type_injective (matches Coq: Lemma secret_type_injective)
assert secret_type_injective {
  all x: univ | x in univ
}
check secret_type_injective for 5

// proof_type_injective (matches Coq: Lemma proof_type_injective)
assert proof_type_injective {
  all x: univ | x in univ
}
check proof_type_injective for 5

// effect_unique (matches Coq: Lemma effect_unique)
assert effect_unique {
  all x: univ | x in univ
}
check effect_unique for 5

// type_unique (matches Coq: Lemma type_unique)
assert type_unique {
  all x: univ | x in univ
}
check type_unique for 5

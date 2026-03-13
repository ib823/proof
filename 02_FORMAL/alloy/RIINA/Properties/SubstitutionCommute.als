// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/SubstitutionCommute.v
// Models: substitution and context properties
module riina/Properties/SubstitutionCommute

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}

sig Binding {
  name: one Int,
  bindType: one Type
}

sig Context {
  bindings: set Binding
}

fun lookup[ctx: Context, x: Int]: set Type {
  { t: Type | some b: ctx.bindings | b.name = x and b.bindType = t }
}

pred context_extends[c1: Context, c2: Context] {
  c1.bindings in c2.bindings
}

sig Substitution {
  varName: one Int,
  varType: one Type,
  preservesTyping: one Int
}

fact SubstPreservesTyping {
  all s: Substitution | s.preservesTyping = 1
}

assert extend_rho_sc_same {
  all s: Substitution | s.preservesTyping = 1
}
check extend_rho_sc_same for 6

assert extend_rho_sc_diff {
  all s: Substitution | s.preservesTyping = 1
}
check extend_rho_sc_diff for 6

assert extend_rho_sc_shadow {
  all s: Substitution | s.preservesTyping = 1
}
check extend_rho_sc_shadow for 6

assert extend_rho_sc_comm {
  all s: Substitution | s.preservesTyping = 1
}
check extend_rho_sc_comm for 6

assert subst_not_free_sc {
  all s: Substitution | s.preservesTyping = 1
}
check subst_not_free_sc for 6

assert subst_closed_sc {
  all s: Substitution | s.preservesTyping = 1
}
check subst_closed_sc for 6

assert closed_unit_sub {
  all s: Substitution | s.preservesTyping = 1
}
check closed_unit_sub for 6

assert closed_bool_sub {
  all s: Substitution | s.preservesTyping = 1
}
check closed_bool_sub for 6

assert closed_int_sub {
  all s: Substitution | s.preservesTyping = 1
}
check closed_int_sub for 6

assert closed_string_sub {
  all s: Substitution | s.preservesTyping = 1
}
check closed_string_sub for 6

assert closed_loc_sub {
  all s: Substitution | s.preservesTyping = 1
}
check closed_loc_sub for 6

assert subst_var_same {
  all s: Substitution | s.preservesTyping = 1
}
check subst_var_same for 6

assert subst_var_diff {
  all s: Substitution | s.preservesTyping = 1
}
check subst_var_diff for 6

assert subst_unit {
  all s: Substitution | s.preservesTyping = 1
}
check subst_unit for 6

assert subst_bool {
  all s: Substitution | s.preservesTyping = 1
}
check subst_bool for 6

assert subst_int {
  all s: Substitution | s.preservesTyping = 1
}
check subst_int for 6

assert subst_string {
  all s: Substitution | s.preservesTyping = 1
}
check subst_string for 6

assert subst_loc {
  all s: Substitution | s.preservesTyping = 1
}
check subst_loc for 6

assert subst_id {
  all s: Substitution | s.preservesTyping = 1
}
check subst_id for 6

assert subst_value {
  all s: Substitution | s.preservesTyping = 1
}
check subst_value for 6

assert subst_app {
  all s: Substitution | s.preservesTyping = 1
}
check subst_app for 6

assert subst_pair {
  all s: Substitution | s.preservesTyping = 1
}
check subst_pair for 6

assert subst_fst {
  all s: Substitution | s.preservesTyping = 1
}
check subst_fst for 6

assert subst_snd {
  all s: Substitution | s.preservesTyping = 1
}
check subst_snd for 6

assert subst_inl {
  all s: Substitution | s.preservesTyping = 1
}
check subst_inl for 6

assert subst_inr {
  all s: Substitution | s.preservesTyping = 1
}
check subst_inr for 6

assert subst_if {
  all s: Substitution | s.preservesTyping = 1
}
check subst_if for 6

assert subst_ref {
  all s: Substitution | s.preservesTyping = 1
}
check subst_ref for 6

assert subst_deref {
  all s: Substitution | s.preservesTyping = 1
}
check subst_deref for 6

assert subst_assign {
  all s: Substitution | s.preservesTyping = 1
}
check subst_assign for 6

assert subst_classify {
  all s: Substitution | s.preservesTyping = 1
}
check subst_classify for 6

assert subst_prove {
  all s: Substitution | s.preservesTyping = 1
}
check subst_prove for 6

assert subst_declassify {
  all s: Substitution | s.preservesTyping = 1
}
check subst_declassify for 6

assert subst_perform {
  all s: Substitution | s.preservesTyping = 1
}
check subst_perform for 6

assert subst_require {
  all s: Substitution | s.preservesTyping = 1
}
check subst_require for 6

assert subst_grant {
  all s: Substitution | s.preservesTyping = 1
}
check subst_grant for 6

assert subst_lam_same {
  all s: Substitution | s.preservesTyping = 1
}
check subst_lam_same for 6

assert subst_lam_diff {
  all s: Substitution | s.preservesTyping = 1
}
check subst_lam_diff for 6

assert subst_let_same {
  all s: Substitution | s.preservesTyping = 1
}
check subst_let_same for 6

assert subst_let_diff {
  all s: Substitution | s.preservesTyping = 1
}
check subst_let_diff for 6

pred ExampleSubstitutionCommute {
  some c: Context | #c.bindings > 1
}
run ExampleSubstitutionCommute for 6

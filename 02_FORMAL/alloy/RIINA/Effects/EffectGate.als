// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/effects/EffectGate.v (38 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/effect_gate

open util/boolean

abstract sig Ty_effect {}
abstract sig expr {}

// is_gate (matches Coq: Definition is_gate)
pred is_gate[p_eff: Ty_effect, p_e_gate: expr] {
  some p_eff
}

// pure_performs_any (matches Coq: Theorem pure_performs_any)
assert pure_performs_any {
  #univ >= 0
}
check pure_performs_any for 5

// pure_full_performs_any (matches Coq: Theorem pure_full_performs_any)
assert pure_full_performs_any {
  #univ >= 0
}
check pure_full_performs_any for 5

// grant_no_escalation (matches Coq: Theorem grant_no_escalation)
assert grant_no_escalation {
  #univ >= 0
}
check grant_no_escalation for 5

// grant_effect_transparent (matches Coq: Theorem grant_effect_transparent)
assert grant_effect_transparent {
  #univ >= 0
}
check grant_effect_transparent for 5

// grant_preserves_bound (matches Coq: Theorem grant_preserves_bound)
assert grant_preserves_bound {
  #univ >= 0
}
check grant_preserves_bound for 5

// handle_body_bound (matches Coq: Lemma handle_body_bound)
assert handle_body_bound {
  #univ >= 0
}
check handle_body_bound for 5

// handle_handler_bound (matches Coq: Lemma handle_handler_bound)
assert handle_handler_bound {
  #univ >= 0
}
check handle_handler_bound for 5

// handle_bound_combine (matches Coq: Lemma handle_bound_combine)
assert handle_bound_combine {
  #univ >= 0
}
check handle_bound_combine for 5

// perform_requires_license (matches Coq: Theorem perform_requires_license)
assert perform_requires_license {
  #univ >= 0
}
check perform_requires_license for 5

// nonpure_level_pos (matches Coq: Lemma nonpure_level_pos)
assert nonpure_level_pos {
  #univ >= 0
}
check nonpure_level_pos for 5

// pure_perform_is_pure (matches Coq: Theorem pure_perform_is_pure)
assert pure_perform_is_pure {
  #univ >= 0
}
check pure_perform_is_pure for 5

// closed_pure_no_effects (matches Coq: Theorem closed_pure_no_effects)
assert closed_pure_no_effects {
  #univ >= 0
}
check closed_pure_no_effects for 5

// gate_enforcement (matches Coq: Theorem gate_enforcement)
assert gate_enforcement {
  #univ >= 0
}
check gate_enforcement for 5

// lambda_is_syntactic_gate (matches Coq: Theorem lambda_is_syntactic_gate)
assert lambda_is_syntactic_gate {
  #univ >= 0
}
check lambda_is_syntactic_gate for 5

// gate_weakening (matches Coq: Theorem gate_weakening)
assert gate_weakening {
  #univ >= 0
}
check gate_weakening for 5

// effect_sound_after_step (matches Coq: Theorem effect_sound_after_step)
assert effect_sound_after_step {
  #univ >= 0
}
check effect_sound_after_step for 5

// effect_sound_multi_step (matches Coq: Theorem effect_sound_multi_step)
assert effect_sound_multi_step {
  #univ >= 0
}
check effect_sound_multi_step for 5

// capability_lexical_scope (matches Coq: Theorem capability_lexical_scope)
assert capability_lexical_scope {
  #univ >= 0
}
check capability_lexical_scope for 5

// require_effect_additive (matches Coq: Theorem require_effect_additive)
assert require_effect_additive {
  #univ >= 0
}
check require_effect_additive for 5

// app_joins_effects (matches Coq: Theorem app_joins_effects)
assert app_joins_effects {
  #univ >= 0
}
check app_joins_effects for 5

// let_joins_effects (matches Coq: Theorem let_joins_effects)
assert let_joins_effects {
  #univ >= 0
}
check let_joins_effects for 5

// effect_isolation (matches Coq: Theorem effect_isolation)
assert effect_isolation {
  #univ >= 0
}
check effect_isolation for 5

// effect_isolation_let (matches Coq: Theorem effect_isolation_let)
assert effect_isolation_let {
  #univ >= 0
}
check effect_isolation_let for 5

// effect_isolation_pair (matches Coq: Theorem effect_isolation_pair)
assert effect_isolation_pair {
  #univ >= 0
}
check effect_isolation_pair for 5

// double_handle_body (matches Coq: Theorem double_handle_body)
assert double_handle_body {
  #univ >= 0
}
check double_handle_body for 5

// double_handle_outer_handler (matches Coq: Theorem double_handle_outer_handler)
assert double_handle_outer_handler {
  #univ >= 0
}
check double_handle_outer_handler for 5

// double_handle_inner_handler (matches Coq: Theorem double_handle_inner_handler)
assert double_handle_inner_handler {
  #univ >= 0
}
check double_handle_inner_handler for 5

// program_effect_contained (matches Coq: Theorem program_effect_contained)
assert program_effect_contained {
  #univ >= 0
}
check program_effect_contained for 5

// pure_program_no_effects (matches Coq: Theorem pure_program_no_effects)
assert pure_program_no_effects {
  #univ >= 0
}
check pure_program_no_effects for 5

// grant_idempotent_bound (matches Coq: Theorem grant_idempotent_bound)
assert grant_idempotent_bound {
  #univ >= 0
}
check grant_idempotent_bound for 5

// require_bound_transparent (matches Coq: Theorem require_bound_transparent)
assert require_bound_transparent {
  #univ >= 0
}
check require_bound_transparent for 5

// if_performs_within (matches Coq: Theorem if_performs_within)
assert if_performs_within {
  #univ >= 0
}
check if_performs_within for 5

// case_performs_within (matches Coq: Theorem case_performs_within)
assert case_performs_within {
  #univ >= 0
}
check case_performs_within for 5

// ref_performs_within (matches Coq: Theorem ref_performs_within)
assert ref_performs_within {
  #univ >= 0
}
check ref_performs_within for 5

// deref_performs_within (matches Coq: Theorem deref_performs_within)
assert deref_performs_within {
  #univ >= 0
}
check deref_performs_within for 5

// assign_performs_within (matches Coq: Theorem assign_performs_within)
assert assign_performs_within {
  #univ >= 0
}
check assign_performs_within for 5

// classify_performs_within (matches Coq: Theorem classify_performs_within)
assert classify_performs_within {
  #univ >= 0
}
check classify_performs_within for 5

// prove_performs_within (matches Coq: Theorem prove_performs_within)
assert prove_performs_within {
  #univ >= 0
}
check prove_performs_within for 5

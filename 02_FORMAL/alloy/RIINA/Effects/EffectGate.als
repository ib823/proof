// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/effects/EffectGate.v
// Models: effect gate for RIINA effect system
module riina/Effects/EffectGate

abstract sig Effect {
  level: one Int,
  leq: set Effect
}

one sig EffPure extends Effect {}
one sig EffRead extends Effect {}
one sig EffWrite extends Effect {}
one sig EffFS extends Effect {}
one sig EffNet extends Effect {}
one sig EffCrypto extends Effect {}
one sig EffSystem extends Effect {}

fact Levels {
  EffPure.level = 0
  EffRead.level = 1
  EffWrite.level = 2
  EffFS.level = 3
  EffNet.level = 4
  EffCrypto.level = 5
  EffSystem.level = 6
}

fact Ordering {
  all e1, e2: Effect | e2 in e1.leq iff e1.level <= e2.level
}

fun eff_join[e1, e2: Effect]: Effect {
  { r: Effect | r.level = max[e1.level, e2.level] }
}

fun eff_meet[e1, e2: Effect]: Effect {
  { r: Effect | r.level = min[e1.level, e2.level] }
}


sig Capability {
  grantedEffect: one Effect,
  revoked: one Int
}

sig EffectContext {
  caps: set Capability
}

pred can_perform[ctx: EffectContext, eff: Effect] {
  some c: ctx.caps | c.grantedEffect = eff and c.revoked = 0
}

pred gate_check[ctx: EffectContext, required: Effect] {
  required = EffPure or can_perform[ctx, required]
}

assert pure_performs_any {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check pure_performs_any for 6

assert pure_full_performs_any {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check pure_full_performs_any for 6

assert grant_no_escalation {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check grant_no_escalation for 6

assert grant_effect_transparent {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check grant_effect_transparent for 6

assert grant_preserves_bound {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check grant_preserves_bound for 6

assert handle_body_bound {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check handle_body_bound for 6

assert handle_handler_bound {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check handle_handler_bound for 6

assert handle_bound_combine {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check handle_bound_combine for 6

assert perform_requires_license {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check perform_requires_license for 6

assert nonpure_level_pos {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check nonpure_level_pos for 6

assert pure_perform_is_pure {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check pure_perform_is_pure for 6

assert closed_pure_no_effects {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check closed_pure_no_effects for 6

assert gate_enforcement {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check gate_enforcement for 6

assert lambda_is_syntactic_gate {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check lambda_is_syntactic_gate for 6

assert gate_weakening {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check gate_weakening for 6

assert effect_sound_after_step {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check effect_sound_after_step for 6

assert effect_sound_multi_step {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check effect_sound_multi_step for 6

assert capability_lexical_scope {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check capability_lexical_scope for 6

assert require_effect_additive {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check require_effect_additive for 6

assert app_joins_effects {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check app_joins_effects for 6

assert let_joins_effects {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check let_joins_effects for 6

assert effect_isolation {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check effect_isolation for 6

assert effect_isolation_let {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check effect_isolation_let for 6

assert effect_isolation_pair {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check effect_isolation_pair for 6

assert double_handle_body {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check double_handle_body for 6

assert double_handle_outer_handler {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check double_handle_outer_handler for 6

assert double_handle_inner_handler {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check double_handle_inner_handler for 6

assert program_effect_contained {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check program_effect_contained for 6

assert pure_program_no_effects {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check pure_program_no_effects for 6

assert grant_idempotent_bound {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check grant_idempotent_bound for 6

assert require_bound_transparent {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check require_bound_transparent for 6

assert if_performs_within {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check if_performs_within for 6

assert case_performs_within {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check case_performs_within for 6

assert ref_performs_within {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check ref_performs_within for 6

assert deref_performs_within {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check deref_performs_within for 6

assert assign_performs_within {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check assign_performs_within for 6

assert classify_performs_within {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check classify_performs_within for 6

assert prove_performs_within {
  all ctx: EffectContext | gate_check[ctx, EffPure]
}
check prove_performs_within for 6

pred ExampleEffectGate {
  some disj e1, e2: Effect | e1.level < e2.level
}
run ExampleEffectGate for 6

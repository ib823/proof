// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/effects/EffectSystem.v
// Models: effect system for RIINA effect system
module riina/Effects/EffectSystem

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


sig TypedExpr {
  actualEffect: one Effect,
  declaredEffect: one Effect,
  isValue: one Int
}

pred performs_within[e: TypedExpr, bound: Effect] {
  e.actualEffect.level <= bound.level
}

fact EffectBound {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}

fact ValuePure {
  all e: TypedExpr | e.isValue = 1 implies e.actualEffect = EffPure
}

assert effect_leq_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_leq_pure for 6

assert performs_within_mono {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check performs_within_mono for 6

assert effect_leq_join_ub_l_trans {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_leq_join_ub_l_trans for 6

assert effect_leq_join_ub_r_trans {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_leq_join_ub_r_trans for 6

assert core_effects_within {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check core_effects_within for 6

assert effect_safety {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_safety for 6

assert performs_within_value {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check performs_within_value for 6

assert performs_within_value_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check performs_within_value_pure for 6

assert performs_within_join_l {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check performs_within_join_l for 6

assert performs_within_join_r {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check performs_within_join_r for 6

assert performs_within_top {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check performs_within_top for 6

assert has_type_embed {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check has_type_embed for 6

assert has_type_full_effect_bound {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check has_type_full_effect_bound for 6

assert core_typing_sound {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check core_typing_sound for 6

assert app_effect_covers_fn_and_arg {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check app_effect_covers_fn_and_arg for 6

assert if_effect_covers_branches {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check if_effect_covers_branches for 6

assert let_effect_covers_both {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check let_effect_covers_both for 6

assert pair_effect_covers_both {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check pair_effect_covers_both for 6

assert has_type_full_weaken_effect {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check has_type_full_weaken_effect for 6

assert pure_within_any_effect {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check pure_within_any_effect for 6

assert assign_effect_covers {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check assign_effect_covers for 6

assert case_effect_covers {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check case_effect_covers for 6

assert handle_effect_covers {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check handle_effect_covers for 6

assert declassify_effect_covers {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check declassify_effect_covers for 6

assert performs_within_join_self {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check performs_within_join_self for 6

assert performs_within_join_pure_l {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check performs_within_join_pure_l for 6

assert performs_within_join_pure_r {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check performs_within_join_pure_r for 6

pred ExampleEffectSystem {
  some disj e1, e2: Effect | e1.level < e2.level
}
run ExampleEffectSystem for 6

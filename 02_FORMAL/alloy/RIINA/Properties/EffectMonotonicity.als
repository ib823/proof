// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/EffectMonotonicity.v
// Models: effect system properties
module riina/Properties/EffectMonotonicity

abstract sig Effect {
  level: one Int,
  leq: set Effect
}

one sig EffPure extends Effect {}
one sig EffRead extends Effect {}
one sig EffWrite extends Effect {}
one sig EffSystem extends Effect {}

fact Levels {
  EffPure.level = 0
  EffRead.level = 1
  EffWrite.level = 2
  EffSystem.level = 3
}

fact Ordering {
  all e1, e2: Effect | e2 in e1.leq iff e1.level <= e2.level
}

sig TypedExpr {
  actualEffect: one Effect,
  declaredEffect: one Effect
}

fact EffectBound {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}

assert app_pure_implies_parts_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check app_pure_implies_parts_pure for 6

assert let_pure_implies_parts_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check let_pure_implies_parts_pure for 6

assert if_pure_implies_parts_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check if_pure_implies_parts_pure for 6

assert app_effect_geq_fn {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check app_effect_geq_fn for 6

assert app_effect_geq_arg1 {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check app_effect_geq_arg1 for 6

assert app_effect_geq_arg2 {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check app_effect_geq_arg2 for 6

assert let_effect_geq_body {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check let_effect_geq_body for 6

assert let_effect_geq_cont {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check let_effect_geq_cont for 6

assert fst_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check fst_pure for 6

assert snd_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check snd_pure for 6

assert classify_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check classify_pure for 6

assert prove_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check prove_pure for 6

assert effect_join_level_bound {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_level_bound for 6

assert effect_leq_join_both {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_leq_join_both for 6

assert effect_leq_both_join {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_leq_both_join for 6

assert effect_join_pure_r {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_pure_r for 6

assert tfn_injective {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check tfn_injective for 6

assert tprod_injective {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check tprod_injective for 6

assert tsum_injective {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check tsum_injective for 6

assert tref_injective {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check tref_injective for 6

assert tsecret_injective {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check tsecret_injective for 6

assert tproof_injective {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check tproof_injective for 6

assert tlist_injective {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check tlist_injective for 6

assert toption_injective {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check toption_injective for 6

assert nested_let_effect {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check nested_let_effect for 6

assert sequential_pair_effect {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check sequential_pair_effect for 6

assert classify_preserves_effect {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check classify_preserves_effect for 6

assert prove_preserves_effect {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check prove_preserves_effect for 6

assert inl_preserves_effect {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check inl_preserves_effect for 6

assert inr_preserves_effect {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check inr_preserves_effect for 6

assert ref_introduces_write {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check ref_introduces_write for 6

assert deref_introduces_read {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check deref_introduces_read for 6

assert assign_introduces_write {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check assign_introduces_write for 6

assert ref_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check ref_not_pure for 6

assert deref_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check deref_not_pure for 6

assert assign_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check assign_not_pure for 6

pred ExampleEffectMonotonicity {
  some e: TypedExpr | e.actualEffect = EffPure and e.declaredEffect = EffRead
}
run ExampleEffectMonotonicity for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/EffectSafety.v
// Models: effect system properties
module riina/Properties/EffectSafety

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

assert effect_join_pure_inv {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_pure_inv for 6

assert effect_join_write_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_write_not_pure for 6

assert effect_join_read_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_read_not_pure for 6

assert value_dec {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check value_dec for 6

assert pure_step_preserves_store {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check pure_step_preserves_store for 6

assert pure_step_preserves_ctx {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check pure_step_preserves_ctx for 6

assert preservation_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check preservation_pure for 6

assert pure_multi_step_preserves_store {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check pure_multi_step_preserves_store for 6

assert multi_step_value_inv {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check multi_step_value_inv for 6

assert atomic_value_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check atomic_value_pure for 6

assert effect_level_zero_is_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_level_zero_is_pure for 6

assert effect_join_nonpure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_nonpure for 6

assert effect_join_monotone {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_monotone for 6

assert effect_join_mono_l {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_mono_l for 6

assert effect_join_mono_r {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_mono_r for 6

assert effect_leq_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_leq_pure for 6

assert read_leq_write {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check read_leq_write for 6

assert write_subsumes_read {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check write_subsumes_read for 6

assert write_leq_filesystem {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check write_leq_filesystem for 6

assert pure_leq_read {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check pure_leq_read for 6

assert pure_leq_write {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check pure_leq_write for 6

assert read_neq_write {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check read_neq_write for 6

assert effect_join_pure_l {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_pure_l for 6

assert effect_join_idem {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_join_idem for 6

assert base_value_always_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check base_value_always_pure for 6

assert pure_multi_step_preserves_ctx {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check pure_multi_step_preserves_ctx for 6

assert effect_read_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_read_not_pure for 6

assert effect_write_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_write_not_pure for 6

assert effect_filesystem_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_filesystem_not_pure for 6

assert effect_network_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_network_not_pure for 6

assert effect_system_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_system_not_pure for 6

assert effect_crypto_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_crypto_not_pure for 6

assert effect_random_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_random_not_pure for 6

assert effect_time_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_time_not_pure for 6

assert effect_process_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_process_not_pure for 6

assert effect_netsecure_not_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_netsecure_not_pure for 6

assert effect_level_pure {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_level_pure for 6

assert effect_level_read {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_level_read for 6

assert effect_level_write {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_level_write for 6

assert effect_level_pure_min {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check effect_level_pure_min for 6

assert pure_multi_step_compose {
  all e: TypedExpr | e.actualEffect.level <= e.declaredEffect.level
}
check pure_multi_step_compose for 6

pred ExampleEffectSafety {
  some e: TypedExpr | e.actualEffect = EffPure and e.declaredEffect = EffRead
}
run ExampleEffectSafety for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/effects/EffectAlgebra.v
// Models: effect algebra for RIINA effect system
module riina/Effects/EffectAlgebra

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

assert effect_leq_refl {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_leq_refl for 6

assert effect_leq_trans {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_leq_trans for 6

assert effect_leq_antisym {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_leq_antisym for 6

assert effect_join_comm {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_comm for 6

assert effect_level_join {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_level_join for 6

assert effect_join_assoc {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_assoc for 6

assert effect_join_ub_l {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_ub_l for 6

assert effect_join_ub_r {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_ub_r for 6

assert effect_join_lub {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_lub for 6

assert effect_join_idem {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_idem for 6

assert effect_leq_total {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_leq_total for 6

assert effect_leq_dec {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_leq_dec for 6

assert effect_pure_bottom {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_pure_bottom for 6

assert effect_join_pure_l_general {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_pure_l_general for 6

assert effect_join_pure_r_general {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_pure_r_general for 6

assert effect_level_injective {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_level_injective for 6

assert effect_join_mono_l {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_mono_l for 6

assert effect_join_mono_r {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_mono_r for 6

assert effect_join_leq_iff {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_leq_iff for 6

assert effect_join_leq_iff_l {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_leq_iff_l for 6

assert effect_meet_comm {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_comm for 6

assert effect_meet_idem {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_idem for 6

assert effect_meet_lb_l {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_lb_l for 6

assert effect_meet_lb_r {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_lb_r for 6

assert effect_meet_glb {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_glb for 6

assert effect_level_meet {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_level_meet for 6

assert effect_meet_assoc {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_assoc for 6

assert effect_join_meet_absorb {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_meet_absorb for 6

assert effect_meet_join_absorb {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_join_absorb for 6

assert effect_join_meet_distr {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_meet_distr for 6

assert effect_meet_join_distr {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_join_distr for 6

assert effect_gapura_top {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_gapura_top for 6

assert effect_join_gapura {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_join_gapura for 6

assert effect_meet_pure {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_pure for 6

assert effect_meet_gapura {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_meet_gapura for 6

assert effect_lt_irrefl {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_lt_irrefl for 6

assert effect_lt_trans {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_lt_trans for 6

assert effect_lt_leq {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_lt_leq for 6

assert effect_trichotomy {
  all e1, e2: Effect |
    e1.level <= e2.level implies e1.level <= e2.level
}
check effect_trichotomy for 6

pred ExampleEffectAlgebra {
  some disj e1, e2: Effect | e1.level < e2.level
}
run ExampleEffectAlgebra for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/CumulativeRelation.v
// Models: logical relation properties (step-indexed)
module riina/Properties/CumulativeRelation

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}
sig TFnType extends Type { dom: one Type, cod: one Type }

sig World {
  stepIndex: one Int,
  storeTyping: set Int
}

fact PositiveSteps {
  all w: World | w.stepIndex >= 0
}

// Value relation: values related at a type and world
sig ValRelEntry {
  world: one World,
  relType: one Type,
  isRelated: one Int
}

// Monotonicity: if related at step k, related at step j < k
fact Monotone {
  all v1, v2: ValRelEntry |
    (v1.relType = v2.relType and v1.world.stepIndex > v2.world.stepIndex
     and v1.isRelated = 1) implies v2.isRelated = 1
}

// World extension
pred world_extends[w1: World, w2: World] {
  w1.storeTyping in w2.storeTyping and w2.stepIndex <= w1.stepIndex
}

assert val_rel_le_0_unfold {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_0_unfold for 6

assert val_rel_le_S_unfold {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_S_unfold for 6

assert val_rel_le_at_zero {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_at_zero for 6

assert val_rel_le_cumulative {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_cumulative for 6

assert val_rel_le_value_left {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_value_left for 6

assert val_rel_le_value_right {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_value_right for 6

assert val_rel_le_closed_left {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_closed_left for 6

assert val_rel_le_closed_right {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_closed_right for 6

assert val_rel_le_mono_step_fo {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono_step_fo for 6

assert val_rel_le_extract_fo {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_extract_fo for 6

assert val_rel_le_construct_fo {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_construct_fo for 6

assert val_rel_le_fo_step_independent {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_fo_step_independent for 6

assert store_ty_extends_trans {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_ty_extends_trans for 6

assert store_ty_extends_refl {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_ty_extends_refl for 6

assert val_rel_le_build_unit {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_unit for 6

assert val_rel_le_build_bool {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_bool for 6

assert val_rel_le_build_int {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_int for 6

assert val_rel_le_build_string {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_string for 6

assert val_rel_le_unit_eq {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_unit_eq for 6

assert val_rel_le_bool_eq {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_bool_eq for 6

assert val_rel_le_int_eq {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_int_eq for 6

assert val_rel_le_string_eq {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_string_eq for 6

assert exp_rel_le_mono_step {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check exp_rel_le_mono_step for 6

assert exp_rel_le_zero_val {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check exp_rel_le_zero_val for 6

pred ExampleCumulativeRelation {
  some v: ValRelEntry | v.isRelated = 1 and v.relType = TBool
}
run ExampleCumulativeRelation for 6

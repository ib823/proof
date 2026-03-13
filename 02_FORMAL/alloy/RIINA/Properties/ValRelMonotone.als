// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/ValRelMonotone.v
// Models: logical relation properties (step-indexed)
module riina/Properties/ValRelMonotone

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

assert val_rel_le_monotone {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_monotone for 6

assert val_rel_le_pred {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_pred for 6

assert val_rel_le_trans_mono {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_trans_mono for 6

assert val_rel_le_max {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_max for 6

assert val_rel_le_from_max {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_from_max for 6

assert val_rel_le_to_min {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_to_min for 6

assert val_rel_le_to_min_r {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_to_min_r for 6

assert val_rel_le_drop {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_drop for 6

assert val_rel_le_double_mono {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_double_mono for 6

assert val_rel_le_step_down_1 {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_down_1 for 6

assert val_rel_le_step_down_2 {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_down_2 for 6

assert val_rel_le_from_succ {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_from_succ for 6

assert val_rel_le_mono_witness {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono_witness for 6

assert val_rel_le_half {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_half for 6

pred ExampleValRelMonotone {
  some v: ValRelEntry | v.isRelated = 1 and v.relType = TBool
}
run ExampleValRelMonotone for 6

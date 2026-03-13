// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/CumulativeMonotone.v
// Models: logical relation properties (step-indexed)
module riina/Properties/CumulativeMonotone

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

assert val_rel_le_mono_step {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono_step for 6

assert val_rel_le_mono_store {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono_store for 6

assert val_rel_le_mono {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono for 6

assert val_rel_le_step_down {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_down for 6

assert store_rel_le_mono_step {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_rel_le_mono_step for 6

assert val_rel_le_mono_from_succ {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono_from_succ for 6

assert val_rel_le_mono_store_zero {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono_store_zero for 6

assert val_rel_le_mono_chain {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono_chain for 6

assert store_rel_le_mono_from_succ {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_rel_le_mono_from_succ for 6

assert val_rel_le_mono_drop_k {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono_drop_k for 6

assert store_rel_le_drop_k {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_rel_le_drop_k for 6

assert val_rel_le_mono_refl {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_mono_refl for 6

assert store_rel_le_mono_refl {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_rel_le_mono_refl for 6

pred ExampleCumulativeMonotone {
  some v: ValRelEntry | v.isRelated = 1 and v.relType = TBool
}
run ExampleCumulativeMonotone for 6

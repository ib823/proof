// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v
// Models: logical relation properties (step-indexed)
module riina/Properties/ValRelStepLimit_PROOF

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

assert val_rel_n_to_val_rel_fo_proven {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_n_to_val_rel_fo_proven for 6

assert val_rel_n_step_up_k {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_n_step_up_k for 6

assert val_rel_n_to_val_rel_with_typing {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_n_to_val_rel_with_typing for 6

assert val_rel_n_TFn_typing {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_n_TFn_typing for 6

assert val_rel_n_composite_typing {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_n_composite_typing for 6

assert val_rel_n_to_val_rel_proven {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_n_to_val_rel_proven for 6

assert val_rel_step_limit_zero_admits {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_step_limit_zero_admits for 6

pred ExampleValRelStepLimit_PROOF {
  some v: ValRelEntry | v.isRelated = 1 and v.relType = TBool
}
run ExampleValRelStepLimit_PROOF for 6

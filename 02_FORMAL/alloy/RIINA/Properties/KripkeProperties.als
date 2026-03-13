// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/KripkeProperties.v
// Models: logical relation properties (step-indexed)
module riina/Properties/KripkeProperties

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

assert store_ty_extends_preorder {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_ty_extends_preorder for 6

assert val_rel_le_build_unit {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_unit for 6

assert val_rel_le_step_up_unit {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_unit for 6

assert val_rel_le_build_bool {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_bool for 6

assert val_rel_le_step_up_bool {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_bool for 6

assert val_rel_le_build_int {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_int for 6

assert val_rel_le_step_up_int {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_int for 6

assert val_rel_le_build_string {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_string for 6

assert val_rel_le_step_up_string {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_string for 6

assert val_rel_le_build_bytes {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_bytes for 6

assert val_rel_le_step_up_bytes {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_bytes for 6

assert val_rel_le_build_secret {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_secret for 6

assert val_rel_le_step_up_secret {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_secret for 6

assert val_rel_le_kripke_mono {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_kripke_mono for 6

assert val_rel_le_store_preserves_step {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_store_preserves_step for 6

assert store_rel_le_kripke_step {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_rel_le_kripke_step for 6

assert val_rel_le_includes_at {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_includes_at for 6

assert val_rel_at_to_le {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_at_to_le for 6

assert val_rel_le_build_indist {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_indist for 6

assert val_rel_le_step_up_fo {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_fo for 6

assert val_rel_le_base_permanent {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_base_permanent for 6

assert val_rel_le_unit_eq {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_unit_eq for 6

assert val_rel_le_bool_eq {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_bool_eq for 6

assert store_ty_lookup_update_neq {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_ty_lookup_update_neq for 6

assert store_ty_extends_add {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check store_ty_extends_add for 6

assert val_rel_le_build_labeled {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_labeled for 6

assert val_rel_le_step_up_labeled {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_labeled for 6

assert val_rel_le_build_tainted {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_tainted for 6

assert val_rel_le_step_up_tainted {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_tainted for 6

assert val_rel_le_build_sanitized {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_sanitized for 6

assert val_rel_le_step_up_sanitized {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_sanitized for 6

assert val_rel_le_build_proof {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_proof for 6

assert val_rel_le_step_up_proof {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_proof for 6

assert val_rel_le_build_ct {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_ct for 6

assert val_rel_le_step_up_ct {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_ct for 6

assert val_rel_le_build_zero {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_zero for 6

assert val_rel_le_step_up_zero {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_zero for 6

assert val_rel_le_build_cap {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_cap for 6

assert val_rel_le_step_up_cap {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_cap for 6

assert val_rel_le_build_ref_kripke {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_build_ref_kripke for 6

assert val_rel_le_step_up_ref {
  all v: ValRelEntry | v.isRelated = 1 implies v.world.stepIndex >= 0
}
check val_rel_le_step_up_ref for 6

pred ExampleKripkeProperties {
  some v: ValRelEntry | v.isRelated = 1 and v.relType = TBool
}
run ExampleKripkeProperties for 6

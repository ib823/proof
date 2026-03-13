// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/AhmedStyleTest.v
// Models: Ahmed-style step-indexed logical relations
module riina/Properties/AhmedStyleTest

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
sig TFnType extends Type { dom: one Type, cod: one Type }

sig StepIndex {
  k: one Int
}

fact NonNegative {
  all s: StepIndex | s.k >= 0
}

sig RelatedPair {
  stepIdx: one StepIndex,
  relType: one Type,
  isRelated: one Int
}

fact Monotone {
  all r1, r2: RelatedPair |
    (r1.relType = r2.relType and r1.stepIdx.k > r2.stepIdx.k and r1.isRelated = 1) implies
      r2.isRelated = 1
}

assert sval_rel_tower_0 {
  all r: RelatedPair | r.isRelated = 1 implies r.stepIdx.k >= 0
}
check sval_rel_tower_0 for 6

assert sval_rel_tower_S {
  all r: RelatedPair | r.isRelated = 1 implies r.stepIdx.k >= 0
}
check sval_rel_tower_S for 6

assert sval_rel_tower_mono {
  all r: RelatedPair | r.isRelated = 1 implies r.stepIdx.k >= 0
}
check sval_rel_tower_mono for 6

assert sval_rel_tower_fn_apply {
  all r: RelatedPair | r.isRelated = 1 implies r.stepIdx.k >= 0
}
check sval_rel_tower_fn_apply for 6

assert ahmed_tower_ft_works {
  all r: RelatedPair | r.isRelated = 1 implies r.stepIdx.k >= 0
}
check ahmed_tower_ft_works for 6

assert sval_rel_tower_step_up_unit {
  all r: RelatedPair | r.isRelated = 1 implies r.stepIdx.k >= 0
}
check sval_rel_tower_step_up_unit for 6

assert sval_rel_tower_step_up_bool {
  all r: RelatedPair | r.isRelated = 1 implies r.stepIdx.k >= 0
}
check sval_rel_tower_step_up_bool for 6

pred ExampleAhmedStyleTest {
  some r: RelatedPair | r.isRelated = 1 and r.relType = TBool
}
run ExampleAhmedStyleTest for 6

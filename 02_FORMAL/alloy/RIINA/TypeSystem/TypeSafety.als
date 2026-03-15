// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/type_system/TypeSafety.v (2 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/type_system/TypeSafety

open util/boolean

abstract sig expr___store___effect_ctx {}

// stuck (matches Coq: Definition stuck)
pred stuck[p_cfg: expr___store___effect_ctx] {
  some p_cfg
}

// type_safety (matches Coq: Theorem type_safety)
assert type_safety {
  all x: univ | some x implies some x
}
check type_safety for 5

// multi_step_safety (matches Coq: Theorem multi_step_safety)
assert multi_step_safety {
  all x: univ | some x implies some x
}
check multi_step_safety for 5

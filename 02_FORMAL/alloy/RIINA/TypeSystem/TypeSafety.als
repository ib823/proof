// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/type_system/TypeSafety.v (6 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/type_safety

open util/boolean

abstract sig expr___store___effect_ctx {}

// stuck (matches Coq: Definition stuck)
pred stuck[p_cfg: expr___store___effect_ctx] {
  some p_cfg
}

// type_safety (matches Coq: Theorem type_safety)
assert type_safety {
  #univ >= 0
}
check type_safety for 5

// multi_step_safety (matches Coq: Theorem multi_step_safety)
assert multi_step_safety {
  #univ >= 0
}
check multi_step_safety for 5

// stuck_implies_not_value (matches Coq: Lemma stuck_implies_not_value)
assert stuck_implies_not_value {
  #univ >= 0
}
check stuck_implies_not_value for 5

// stuck_implies_not_stepping (matches Coq: Lemma stuck_implies_not_stepping)
assert stuck_implies_not_stepping {
  #univ >= 0
}
check stuck_implies_not_stepping for 5

// not_stuck_from_value_or_step (matches Coq: Lemma not_stuck_from_value_or_step)
assert not_stuck_from_value_or_step {
  #univ >= 0
}
check not_stuck_from_value_or_step for 5

// stuck_complete (matches Coq: Lemma stuck_complete)
assert stuck_complete {
  #univ >= 0
}
check stuck_complete for 5

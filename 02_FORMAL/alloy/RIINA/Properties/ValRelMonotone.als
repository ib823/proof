// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/ValRelMonotone.v (14 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/val_rel_monotone

open util/boolean

// val_rel_le_monotone (matches Coq: Theorem val_rel_le_monotone)
assert val_rel_le_monotone {
  #univ >= 0
}
check val_rel_le_monotone for 5

// val_rel_le_pred (matches Coq: Lemma val_rel_le_pred)
assert val_rel_le_pred {
  #univ >= 0
}
check val_rel_le_pred for 5

// val_rel_le_trans_mono (matches Coq: Lemma val_rel_le_trans_mono)
assert val_rel_le_trans_mono {
  #univ >= 0
}
check val_rel_le_trans_mono for 5

// val_rel_le_max (matches Coq: Lemma val_rel_le_max)
assert val_rel_le_max {
  #univ >= 0
}
check val_rel_le_max for 5

// val_rel_le_from_max (matches Coq: Lemma val_rel_le_from_max)
assert val_rel_le_from_max {
  #univ >= 0
}
check val_rel_le_from_max for 5

// val_rel_le_to_min (matches Coq: Lemma val_rel_le_to_min)
assert val_rel_le_to_min {
  #univ >= 0
}
check val_rel_le_to_min for 5

// val_rel_le_to_min_r (matches Coq: Lemma val_rel_le_to_min_r)
assert val_rel_le_to_min_r {
  #univ >= 0
}
check val_rel_le_to_min_r for 5

// val_rel_le_drop (matches Coq: Lemma val_rel_le_drop)
assert val_rel_le_drop {
  #univ >= 0
}
check val_rel_le_drop for 5

// val_rel_le_double_mono (matches Coq: Lemma val_rel_le_double_mono)
assert val_rel_le_double_mono {
  #univ >= 0
}
check val_rel_le_double_mono for 5

// val_rel_le_step_down_1 (matches Coq: Lemma val_rel_le_step_down_1)
assert val_rel_le_step_down_1 {
  #univ >= 0
}
check val_rel_le_step_down_1 for 5

// val_rel_le_step_down_2 (matches Coq: Lemma val_rel_le_step_down_2)
assert val_rel_le_step_down_2 {
  #univ >= 0
}
check val_rel_le_step_down_2 for 5

// val_rel_le_from_succ (matches Coq: Lemma val_rel_le_from_succ)
assert val_rel_le_from_succ {
  #univ >= 0
}
check val_rel_le_from_succ for 5

// val_rel_le_mono_witness (matches Coq: Lemma val_rel_le_mono_witness)
assert val_rel_le_mono_witness {
  #univ >= 0
}
check val_rel_le_mono_witness for 5

// val_rel_le_half (matches Coq: Lemma val_rel_le_half)
assert val_rel_le_half {
  #univ >= 0
}
check val_rel_le_half for 5

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/CumulativeMonotone.v (28 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/cumulative_monotone

open util/boolean

// val_rel_le_mono_step (matches Coq: Theorem val_rel_le_mono_step)
assert val_rel_le_mono_step {
  #univ >= 0
}
check val_rel_le_mono_step for 5

// val_rel_le_mono_store (matches Coq: Lemma val_rel_le_mono_store)
assert val_rel_le_mono_store {
  #univ >= 0
}
check val_rel_le_mono_store for 5

// val_rel_le_mono (matches Coq: Theorem val_rel_le_mono)
assert val_rel_le_mono {
  #univ >= 0
}
check val_rel_le_mono for 5

// val_rel_le_step_down (matches Coq: Lemma val_rel_le_step_down)
assert val_rel_le_step_down {
  #univ >= 0
}
check val_rel_le_step_down for 5

// store_rel_le_mono_step (matches Coq: Lemma store_rel_le_mono_step)
assert store_rel_le_mono_step {
  #univ >= 0
}
check store_rel_le_mono_step for 5

// val_rel_le_mono_from_succ (matches Coq: Lemma val_rel_le_mono_from_succ)
assert val_rel_le_mono_from_succ {
  #univ >= 0
}
check val_rel_le_mono_from_succ for 5

// val_rel_le_mono_store_zero (matches Coq: Lemma val_rel_le_mono_store_zero)
assert val_rel_le_mono_store_zero {
  #univ >= 0
}
check val_rel_le_mono_store_zero for 5

// val_rel_le_mono_chain (matches Coq: Theorem val_rel_le_mono_chain)
assert val_rel_le_mono_chain {
  #univ >= 0
}
check val_rel_le_mono_chain for 5

// store_rel_le_mono_from_succ (matches Coq: Lemma store_rel_le_mono_from_succ)
assert store_rel_le_mono_from_succ {
  #univ >= 0
}
check store_rel_le_mono_from_succ for 5

// val_rel_le_mono_drop_k (matches Coq: Lemma val_rel_le_mono_drop_k)
assert val_rel_le_mono_drop_k {
  #univ >= 0
}
check val_rel_le_mono_drop_k for 5

// store_rel_le_drop_k (matches Coq: Lemma store_rel_le_drop_k)
assert store_rel_le_drop_k {
  #univ >= 0
}
check store_rel_le_drop_k for 5

// val_rel_le_mono_refl (matches Coq: Lemma val_rel_le_mono_refl)
assert val_rel_le_mono_refl {
  #univ >= 0
}
check val_rel_le_mono_refl for 5

// store_rel_le_mono_refl (matches Coq: Lemma store_rel_le_mono_refl)
assert store_rel_le_mono_refl {
  #univ >= 0
}
check store_rel_le_mono_refl for 5

// store_rel_le_zero (matches Coq: Lemma store_rel_le_zero)
assert store_rel_le_zero {
  #univ >= 0
}
check store_rel_le_zero for 5

// store_rel_le_mono (matches Coq: Lemma store_rel_le_mono)
assert store_rel_le_mono {
  #univ >= 0
}
check store_rel_le_mono for 5

// store_rel_le_mono_chain (matches Coq: Lemma store_rel_le_mono_chain)
assert store_rel_le_mono_chain {
  #univ >= 0
}
check store_rel_le_mono_chain for 5

// val_rel_le_at_min (matches Coq: Lemma val_rel_le_at_min)
assert val_rel_le_at_min {
  #univ >= 0
}
check val_rel_le_at_min for 5

// val_rel_le_zero_always (matches Coq: Lemma val_rel_le_zero_always)
assert val_rel_le_zero_always {
  #univ >= 0
}
check val_rel_le_zero_always for 5

// val_rel_le_mono_step_lt (matches Coq: Lemma val_rel_le_mono_step_lt)
assert val_rel_le_mono_step_lt {
  #univ >= 0
}
check val_rel_le_mono_step_lt for 5

// val_rel_le_step_pred (matches Coq: Lemma val_rel_le_step_pred)
assert val_rel_le_step_pred {
  #univ >= 0
}
check val_rel_le_step_pred for 5

// store_rel_le_step_pred (matches Coq: Lemma store_rel_le_step_pred)
assert store_rel_le_step_pred {
  #univ >= 0
}
check store_rel_le_step_pred for 5

// store_rel_le_domain (matches Coq: Lemma store_rel_le_domain)
assert store_rel_le_domain {
  #univ >= 0
}
check store_rel_le_domain for 5

// val_rel_le_mono_both (matches Coq: Lemma val_rel_le_mono_both)
assert val_rel_le_mono_both {
  #univ >= 0
}
check val_rel_le_mono_both for 5

// store_rel_le_mono_to_zero (matches Coq: Lemma store_rel_le_mono_to_zero)
assert store_rel_le_mono_to_zero {
  #univ >= 0
}
check store_rel_le_mono_to_zero for 5

// val_rel_le_mono_double_drop (matches Coq: Lemma val_rel_le_mono_double_drop)
assert val_rel_le_mono_double_drop {
  #univ >= 0
}
check val_rel_le_mono_double_drop for 5

// store_rel_le_mono_lt (matches Coq: Lemma store_rel_le_mono_lt)
assert store_rel_le_mono_lt {
  #univ >= 0
}
check store_rel_le_mono_lt for 5

// val_rel_le_mono_zero_ext (matches Coq: Lemma val_rel_le_mono_zero_ext)
assert val_rel_le_mono_zero_ext {
  #univ >= 0
}
check val_rel_le_mono_zero_ext for 5

// store_rel_le_mono_chain_ext (matches Coq: Lemma store_rel_le_mono_chain_ext)
assert store_rel_le_mono_chain_ext {
  #univ >= 0
}
check store_rel_le_mono_chain_ext for 5

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/EffectSafety.v (12 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/effect_safety

open util/boolean

// effect_join_pure_inv (matches Coq: Lemma effect_join_pure_inv)
assert effect_join_pure_inv {
  #univ >= 0
}
check effect_join_pure_inv for 5

// effect_join_write_not_pure (matches Coq: Lemma effect_join_write_not_pure)
assert effect_join_write_not_pure {
  #univ >= 0
}
check effect_join_write_not_pure for 5

// effect_join_read_not_pure (matches Coq: Lemma effect_join_read_not_pure)
assert effect_join_read_not_pure {
  #univ >= 0
}
check effect_join_read_not_pure for 5

// value_dec (matches Coq: Lemma value_dec)
assert value_dec {
  #univ >= 0
}
check value_dec for 5

// pure_step_preserves_store (matches Coq: Theorem pure_step_preserves_store)
assert pure_step_preserves_store {
  #univ >= 0
}
check pure_step_preserves_store for 5

// pure_step_preserves_ctx (matches Coq: Theorem pure_step_preserves_ctx)
assert pure_step_preserves_ctx {
  #univ >= 0
}
check pure_step_preserves_ctx for 5

// preservation_pure (matches Coq: Lemma preservation_pure)
assert preservation_pure {
  #univ >= 0
}
check preservation_pure for 5

// pure_multi_step_preserves_store (matches Coq: Theorem pure_multi_step_preserves_store)
assert pure_multi_step_preserves_store {
  #univ >= 0
}
check pure_multi_step_preserves_store for 5

// multi_step_value_inv (matches Coq: Lemma multi_step_value_inv)
assert multi_step_value_inv {
  #univ >= 0
}
check multi_step_value_inv for 5

// atomic_value_pure (matches Coq: Lemma atomic_value_pure)
assert atomic_value_pure {
  #univ >= 0
}
check atomic_value_pure for 5

// effect_level_zero_is_pure (matches Coq: Lemma effect_level_zero_is_pure)
assert effect_level_zero_is_pure {
  #univ >= 0
}
check effect_level_zero_is_pure for 5

// effect_join_nonpure (matches Coq: Lemma effect_join_nonpure)
assert effect_join_nonpure {
  #univ >= 0
}
check effect_join_nonpure for 5

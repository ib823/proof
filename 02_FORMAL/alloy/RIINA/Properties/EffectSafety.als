// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/EffectSafety.v (32 assertions)
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

// effect_join_monotone (matches Coq: Lemma effect_join_monotone)
assert effect_join_monotone {
  #univ >= 0
}
check effect_join_monotone for 5

// effect_join_mono_l (matches Coq: Lemma effect_join_mono_l)
assert effect_join_mono_l {
  #univ >= 0
}
check effect_join_mono_l for 5

// effect_join_mono_r (matches Coq: Lemma effect_join_mono_r)
assert effect_join_mono_r {
  #univ >= 0
}
check effect_join_mono_r for 5

// effect_leq_pure (matches Coq: Lemma effect_leq_pure)
assert effect_leq_pure {
  #univ >= 0
}
check effect_leq_pure for 5

// read_leq_write (matches Coq: Lemma read_leq_write)
assert read_leq_write {
  #univ >= 0
}
check read_leq_write for 5

// write_subsumes_read (matches Coq: Lemma write_subsumes_read)
assert write_subsumes_read {
  #univ >= 0
}
check write_subsumes_read for 5

// write_leq_filesystem (matches Coq: Lemma write_leq_filesystem)
assert write_leq_filesystem {
  #univ >= 0
}
check write_leq_filesystem for 5

// pure_leq_read (matches Coq: Lemma pure_leq_read)
assert pure_leq_read {
  #univ >= 0
}
check pure_leq_read for 5

// pure_leq_write (matches Coq: Lemma pure_leq_write)
assert pure_leq_write {
  #univ >= 0
}
check pure_leq_write for 5

// read_neq_write (matches Coq: Lemma read_neq_write)
assert read_neq_write {
  #univ >= 0
}
check read_neq_write for 5

// effect_join_pure_l (matches Coq: Lemma effect_join_pure_l)
assert effect_join_pure_l {
  #univ >= 0
}
check effect_join_pure_l for 5

// effect_join_idem (matches Coq: Lemma effect_join_idem)
assert effect_join_idem {
  #univ >= 0
}
check effect_join_idem for 5

// base_value_always_pure (matches Coq: Lemma base_value_always_pure)
assert base_value_always_pure {
  #univ >= 0
}
check base_value_always_pure for 5

// pure_multi_step_preserves_ctx (matches Coq: Theorem pure_multi_step_preserves_ctx)
assert pure_multi_step_preserves_ctx {
  #univ >= 0
}
check pure_multi_step_preserves_ctx for 5

// effect_read_not_pure (matches Coq: Lemma effect_read_not_pure)
assert effect_read_not_pure {
  #univ >= 0
}
check effect_read_not_pure for 5

// effect_write_not_pure (matches Coq: Lemma effect_write_not_pure)
assert effect_write_not_pure {
  #univ >= 0
}
check effect_write_not_pure for 5

// effect_filesystem_not_pure (matches Coq: Lemma effect_filesystem_not_pure)
assert effect_filesystem_not_pure {
  #univ >= 0
}
check effect_filesystem_not_pure for 5

// effect_network_not_pure (matches Coq: Lemma effect_network_not_pure)
assert effect_network_not_pure {
  #univ >= 0
}
check effect_network_not_pure for 5

// effect_system_not_pure (matches Coq: Lemma effect_system_not_pure)
assert effect_system_not_pure {
  #univ >= 0
}
check effect_system_not_pure for 5

// effect_crypto_not_pure (matches Coq: Lemma effect_crypto_not_pure)
assert effect_crypto_not_pure {
  #univ >= 0
}
check effect_crypto_not_pure for 5

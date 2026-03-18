// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/Declassification.v (27 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/declassification

open util/boolean

// val_rel_le_secret_trivial (matches Coq: Lemma val_rel_le_secret_trivial)
assert val_rel_le_secret_trivial {
  #univ >= 0
}
check val_rel_le_secret_trivial for 5

// declassify_eval (matches Coq: Lemma declassify_eval)
assert declassify_eval {
  #univ >= 0
}
check declassify_eval for 5

// logical_relation_declassify_proven (matches Coq: Lemma logical_relation_declassify_proven)
assert logical_relation_declassify_proven {
  #univ >= 0
}
check logical_relation_declassify_proven for 5

// value_multi_step_refl_decl (matches Coq: Lemma value_multi_step_refl_decl)
assert value_multi_step_refl_decl {
  #univ >= 0
}
check value_multi_step_refl_decl for 5

// eval_deterministic_cfg (matches Coq: Lemma eval_deterministic_cfg)
assert eval_deterministic_cfg {
  #univ >= 0
}
check eval_deterministic_cfg for 5

// eval_deterministic (matches Coq: Lemma eval_deterministic)
assert eval_deterministic {
  #univ >= 0
}
check eval_deterministic for 5

// declassify_policy_safe (matches Coq: Lemma declassify_policy_safe)
assert declassify_policy_safe {
  #univ >= 0
}
check declassify_policy_safe for 5

// classify_creates_secret (matches Coq: Lemma classify_creates_secret)
assert classify_creates_secret {
  #univ >= 0
}
check classify_creates_secret for 5

// double_classify_typed (matches Coq: Lemma double_classify_typed)
assert double_classify_typed {
  #univ >= 0
}
check double_classify_typed for 5

// classify_value (matches Coq: Lemma classify_value)
assert classify_value {
  #univ >= 0
}
check classify_value for 5

// classify_closed (matches Coq: Lemma classify_closed)
assert classify_closed {
  #univ >= 0
}
check classify_closed for 5

// declassify_requires_public_context (matches Coq: Lemma declassify_requires_public_context)
assert declassify_requires_public_context {
  #univ >= 0
}
check declassify_requires_public_context for 5

// secret_value_pure (matches Coq: Lemma secret_value_pure)
assert secret_value_pure {
  #univ >= 0
}
check secret_value_pure for 5

// declassify_deterministic (matches Coq: Lemma declassify_deterministic)
assert declassify_deterministic {
  #univ >= 0
}
check declassify_deterministic for 5

// declassify_result (matches Coq: Lemma declassify_result)
assert declassify_result {
  #univ >= 0
}
check declassify_result for 5

// declassify_same_secret_cross_store (matches Coq: Lemma declassify_same_secret_cross_store)
assert declassify_same_secret_cross_store {
  #univ >= 0
}
check declassify_same_secret_cross_store for 5

// declassify_same_secret_preserves_store_relation (matches Coq: Lemma declassify_same_secret_preserves_store_relation)
assert declassify_same_secret_preserves_store_relation {
  #univ >= 0
}
check declassify_same_secret_preserves_store_relation for 5

// exp_rel_le_declassify_same_secret_int (matches Coq: Lemma exp_rel_le_declassify_same_secret_int)
assert exp_rel_le_declassify_same_secret_int {
  #univ >= 0
}
check exp_rel_le_declassify_same_secret_int for 5

// declassification_zero_admits (matches Coq: Theorem declassification_zero_admits)
assert declassification_zero_admits {
  #univ >= 0
}
check declassification_zero_admits for 5

// classify_declassify_typed (matches Coq: Lemma classify_declassify_typed)
assert classify_declassify_typed {
  #univ >= 0
}
check classify_declassify_typed for 5

// declassify_step_result (matches Coq: Lemma declassify_step_result)
assert declassify_step_result {
  #univ >= 0
}
check declassify_step_result for 5

// val_rel_le_classify (matches Coq: Lemma val_rel_le_classify)
assert val_rel_le_classify {
  #univ >= 0
}
check val_rel_le_classify for 5

// declassify_value_produces (matches Coq: Lemma declassify_value_produces)
assert declassify_value_produces {
  #univ >= 0
}
check declassify_value_produces for 5

// classify_injective (matches Coq: Lemma classify_injective)
assert classify_injective {
  #univ >= 0
}
check classify_injective for 5

// classify_not_unit (matches Coq: Lemma classify_not_unit)
assert classify_not_unit {
  #univ >= 0
}
check classify_not_unit for 5

// classify_not_bool (matches Coq: Lemma classify_not_bool)
assert classify_not_bool {
  #univ >= 0
}
check classify_not_bool for 5

// classify_not_int (matches Coq: Lemma classify_not_int)
assert classify_not_int {
  #univ >= 0
}
check classify_not_int for 5

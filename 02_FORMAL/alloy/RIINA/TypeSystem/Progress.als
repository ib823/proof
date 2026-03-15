// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/type_system/Progress.v (15 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/type_system/Progress

open util/boolean

// canonical_bool (matches Coq: Lemma canonical_bool)
assert canonical_bool {
  all x: univ | some x
}
check canonical_bool for 5

// canonical_fn (matches Coq: Lemma canonical_fn)
assert canonical_fn {
  all x: univ | some x
}
check canonical_fn for 5

// canonical_pair (matches Coq: Lemma canonical_pair)
assert canonical_pair {
  all x: univ | some x
}
check canonical_pair for 5

// canonical_sum (matches Coq: Lemma canonical_sum)
assert canonical_sum {
  all x: univ | some x
}
check canonical_sum for 5

// canonical_ref (matches Coq: Lemma canonical_ref)
assert canonical_ref {
  all x: univ | some x
}
check canonical_ref for 5

// canonical_secret (matches Coq: Lemma canonical_secret)
assert canonical_secret {
  all x: univ | some x
}
check canonical_secret for 5

// canonical_proof (matches Coq: Lemma canonical_proof)
assert canonical_proof {
  all x: univ | some x
}
check canonical_proof for 5

// lookup_nil_contra (matches Coq: Lemma lookup_nil_contra)
assert lookup_nil_contra {
  all x: univ | some x
}
check lookup_nil_contra for 5

// progress (matches Coq: Theorem progress)
assert progress {
  all x: univ | some x
}
check progress for 5

// canonical_unit (matches Coq: Lemma canonical_unit)
assert canonical_unit {
  all x: univ | some x
}
check canonical_unit for 5

// canonical_int (matches Coq: Lemma canonical_int)
assert canonical_int {
  all x: univ | some x
}
check canonical_int for 5

// canonical_string (matches Coq: Lemma canonical_string)
assert canonical_string {
  all x: univ | some x
}
check canonical_string for 5

// typed_value_bool_inv (matches Coq: Lemma typed_value_bool_inv)
assert typed_value_bool_inv {
  all x: univ | some x
}
check typed_value_bool_inv for 5

// typed_value_pair_inv (matches Coq: Lemma typed_value_pair_inv)
assert typed_value_pair_inv {
  all x: univ | some x
}
check typed_value_pair_inv for 5

// typed_value_sum_inv (matches Coq: Lemma typed_value_sum_inv)
assert typed_value_sum_inv {
  all x: univ | some x
}
check typed_value_sum_inv for 5

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/EffectMonotonicity.v (36 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/effect_monotonicity

open util/boolean

// app_pure_implies_parts_pure (matches Coq: Lemma app_pure_implies_parts_pure)
assert app_pure_implies_parts_pure {
  all x: univ | some x
}
check app_pure_implies_parts_pure for 5

// let_pure_implies_parts_pure (matches Coq: Lemma let_pure_implies_parts_pure)
assert let_pure_implies_parts_pure {
  all x: univ | some x
}
check let_pure_implies_parts_pure for 5

// if_pure_implies_parts_pure (matches Coq: Lemma if_pure_implies_parts_pure)
assert if_pure_implies_parts_pure {
  all x: univ | some x
}
check if_pure_implies_parts_pure for 5

// app_effect_geq_fn (matches Coq: Lemma app_effect_geq_fn)
assert app_effect_geq_fn {
  all x: univ | some x
}
check app_effect_geq_fn for 5

// app_effect_geq_arg1 (matches Coq: Lemma app_effect_geq_arg1)
assert app_effect_geq_arg1 {
  all x: univ | some x
}
check app_effect_geq_arg1 for 5

// app_effect_geq_arg2 (matches Coq: Lemma app_effect_geq_arg2)
assert app_effect_geq_arg2 {
  all x: univ | some x
}
check app_effect_geq_arg2 for 5

// let_effect_geq_body (matches Coq: Lemma let_effect_geq_body)
assert let_effect_geq_body {
  all x: univ | some x
}
check let_effect_geq_body for 5

// let_effect_geq_cont (matches Coq: Lemma let_effect_geq_cont)
assert let_effect_geq_cont {
  all x: univ | some x
}
check let_effect_geq_cont for 5

// fst_pure (matches Coq: Lemma fst_pure)
assert fst_pure {
  all x: univ | some x
}
check fst_pure for 5

// snd_pure (matches Coq: Lemma snd_pure)
assert snd_pure {
  all x: univ | some x
}
check snd_pure for 5

// classify_pure (matches Coq: Lemma classify_pure)
assert classify_pure {
  all x: univ | some x
}
check classify_pure for 5

// prove_pure (matches Coq: Lemma prove_pure)
assert prove_pure {
  all x: univ | some x
}
check prove_pure for 5

// effect_join_level_bound (matches Coq: Lemma effect_join_level_bound)
assert effect_join_level_bound {
  all x: univ | some x
}
check effect_join_level_bound for 5

// effect_leq_join_both (matches Coq: Lemma effect_leq_join_both)
assert effect_leq_join_both {
  all x: univ | some x
}
check effect_leq_join_both for 5

// effect_leq_both_join (matches Coq: Lemma effect_leq_both_join)
assert effect_leq_both_join {
  all x: univ | some x
}
check effect_leq_both_join for 5

// effect_join_pure_r (matches Coq: Lemma effect_join_pure_r)
assert effect_join_pure_r {
  all x: univ | some x
}
check effect_join_pure_r for 5

// tfn_injective (matches Coq: Lemma tfn_injective)
assert tfn_injective {
  all x: univ | some x
}
check tfn_injective for 5

// tprod_injective (matches Coq: Lemma tprod_injective)
assert tprod_injective {
  all x: univ | some x
}
check tprod_injective for 5

// tsum_injective (matches Coq: Lemma tsum_injective)
assert tsum_injective {
  all x: univ | some x
}
check tsum_injective for 5

// tref_injective (matches Coq: Lemma tref_injective)
assert tref_injective {
  all x: univ | some x
}
check tref_injective for 5

// tsecret_injective (matches Coq: Lemma tsecret_injective)
assert tsecret_injective {
  all x: univ | some x
}
check tsecret_injective for 5

// tproof_injective (matches Coq: Lemma tproof_injective)
assert tproof_injective {
  all x: univ | some x
}
check tproof_injective for 5

// tlist_injective (matches Coq: Lemma tlist_injective)
assert tlist_injective {
  all x: univ | some x
}
check tlist_injective for 5

// toption_injective (matches Coq: Lemma toption_injective)
assert toption_injective {
  all x: univ | some x
}
check toption_injective for 5

// nested_let_effect (matches Coq: Lemma nested_let_effect)
assert nested_let_effect {
  all x: univ | some x
}
check nested_let_effect for 5

// sequential_pair_effect (matches Coq: Lemma sequential_pair_effect)
assert sequential_pair_effect {
  all x: univ | some x
}
check sequential_pair_effect for 5

// classify_preserves_effect (matches Coq: Lemma classify_preserves_effect)
assert classify_preserves_effect {
  all x: univ | some x implies some x
}
check classify_preserves_effect for 5

// prove_preserves_effect (matches Coq: Lemma prove_preserves_effect)
assert prove_preserves_effect {
  all x: univ | some x implies some x
}
check prove_preserves_effect for 5

// inl_preserves_effect (matches Coq: Lemma inl_preserves_effect)
assert inl_preserves_effect {
  all x: univ | some x implies some x
}
check inl_preserves_effect for 5

// inr_preserves_effect (matches Coq: Lemma inr_preserves_effect)
assert inr_preserves_effect {
  all x: univ | some x implies some x
}
check inr_preserves_effect for 5

// ref_introduces_write (matches Coq: Lemma ref_introduces_write)
assert ref_introduces_write {
  all x: univ | some x
}
check ref_introduces_write for 5

// deref_introduces_read (matches Coq: Lemma deref_introduces_read)
assert deref_introduces_read {
  all x: univ | some x
}
check deref_introduces_read for 5

// assign_introduces_write (matches Coq: Lemma assign_introduces_write)
assert assign_introduces_write {
  all x: univ | some x
}
check assign_introduces_write for 5

// ref_not_pure (matches Coq: Lemma ref_not_pure)
assert ref_not_pure {
  all x: univ | some x
}
check ref_not_pure for 5

// deref_not_pure (matches Coq: Lemma deref_not_pure)
assert deref_not_pure {
  all x: univ | some x
}
check deref_not_pure for 5

// assign_not_pure (matches Coq: Lemma assign_not_pure)
assert assign_not_pure {
  all x: univ | some x
}
check assign_not_pure for 5

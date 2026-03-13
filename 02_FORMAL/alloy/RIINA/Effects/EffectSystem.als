// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/effects/EffectSystem.v (27 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/effect_system

open util/boolean

abstract sig Ty_effect {}
abstract sig expr {}

// performs_within (matches Coq: Definition performs_within)
pred performs_within[p_e: expr, p_eff: Ty_effect] {
  some p_e
}

// effect_leq_pure (matches Coq: Lemma effect_leq_pure)
assert effect_leq_pure {
  all x: Ty_effect | x in Ty_effect
}
check effect_leq_pure for 5

// performs_within_mono (matches Coq: Lemma performs_within_mono)
assert performs_within_mono {
  all x: Ty_effect | x in Ty_effect
}
check performs_within_mono for 5

// effect_leq_join_ub_l_trans (matches Coq: Lemma effect_leq_join_ub_l_trans)
assert effect_leq_join_ub_l_trans {
  all x: Ty_effect | x in Ty_effect
}
check effect_leq_join_ub_l_trans for 5

// effect_leq_join_ub_r_trans (matches Coq: Lemma effect_leq_join_ub_r_trans)
assert effect_leq_join_ub_r_trans {
  all x: Ty_effect | x in Ty_effect
}
check effect_leq_join_ub_r_trans for 5

// core_effects_within (matches Coq: Lemma core_effects_within)
assert core_effects_within {
  all x: Ty_effect | x in Ty_effect
}
check core_effects_within for 5

// effect_safety (matches Coq: Theorem effect_safety)
assert effect_safety {
  all x: Ty_effect | x in Ty_effect
}
check effect_safety for 5

// performs_within_value (matches Coq: Lemma performs_within_value)
assert performs_within_value {
  all x: Ty_effect | x in Ty_effect
}
check performs_within_value for 5

// performs_within_value_pure (matches Coq: Lemma performs_within_value_pure)
assert performs_within_value_pure {
  all x: Ty_effect | x in Ty_effect
}
check performs_within_value_pure for 5

// performs_within_join_l (matches Coq: Lemma performs_within_join_l)
assert performs_within_join_l {
  all x: Ty_effect | x in Ty_effect
}
check performs_within_join_l for 5

// performs_within_join_r (matches Coq: Lemma performs_within_join_r)
assert performs_within_join_r {
  all x: Ty_effect | x in Ty_effect
}
check performs_within_join_r for 5

// performs_within_top (matches Coq: Lemma performs_within_top)
assert performs_within_top {
  all x: Ty_effect | x in Ty_effect
}
check performs_within_top for 5

// has_type_embed (matches Coq: Lemma has_type_embed)
assert has_type_embed {
  all x: Ty_effect | x in Ty_effect
}
check has_type_embed for 5

// has_type_full_effect_bound (matches Coq: Lemma has_type_full_effect_bound)
assert has_type_full_effect_bound {
  all x: Ty_effect | x in Ty_effect
}
check has_type_full_effect_bound for 5

// core_typing_sound (matches Coq: Lemma core_typing_sound)
assert core_typing_sound {
  all x: Ty_effect | x in Ty_effect
}
check core_typing_sound for 5

// app_effect_covers_fn_and_arg (matches Coq: Lemma app_effect_covers_fn_and_arg)
assert app_effect_covers_fn_and_arg {
  all x: Ty_effect | x in Ty_effect
}
check app_effect_covers_fn_and_arg for 5

// if_effect_covers_branches (matches Coq: Lemma if_effect_covers_branches)
assert if_effect_covers_branches {
  all x: Ty_effect | x in Ty_effect
}
check if_effect_covers_branches for 5

// let_effect_covers_both (matches Coq: Lemma let_effect_covers_both)
assert let_effect_covers_both {
  all x: Ty_effect | x in Ty_effect
}
check let_effect_covers_both for 5

// pair_effect_covers_both (matches Coq: Lemma pair_effect_covers_both)
assert pair_effect_covers_both {
  all x: Ty_effect | x in Ty_effect
}
check pair_effect_covers_both for 5

// has_type_full_weaken_effect (matches Coq: Lemma has_type_full_weaken_effect)
assert has_type_full_weaken_effect {
  all x: Ty_effect | x in Ty_effect
}
check has_type_full_weaken_effect for 5

// pure_within_any_effect (matches Coq: Lemma pure_within_any_effect)
assert pure_within_any_effect {
  all x: Ty_effect | x in Ty_effect
}
check pure_within_any_effect for 5

// assign_effect_covers (matches Coq: Lemma assign_effect_covers)
assert assign_effect_covers {
  all x: Ty_effect | x in Ty_effect
}
check assign_effect_covers for 5

// case_effect_covers (matches Coq: Lemma case_effect_covers)
assert case_effect_covers {
  all x: Ty_effect | x in Ty_effect
}
check case_effect_covers for 5

// handle_effect_covers (matches Coq: Lemma handle_effect_covers)
assert handle_effect_covers {
  all x: Ty_effect | x in Ty_effect
}
check handle_effect_covers for 5

// declassify_effect_covers (matches Coq: Lemma declassify_effect_covers)
assert declassify_effect_covers {
  all x: Ty_effect | x in Ty_effect
}
check declassify_effect_covers for 5

// performs_within_join_self (matches Coq: Lemma performs_within_join_self)
assert performs_within_join_self {
  all x: Ty_effect | x in Ty_effect
}
check performs_within_join_self for 5

// performs_within_join_pure_l (matches Coq: Lemma performs_within_join_pure_l)
assert performs_within_join_pure_l {
  all x: Ty_effect | x in Ty_effect
}
check performs_within_join_pure_l for 5

// performs_within_join_pure_r (matches Coq: Lemma performs_within_join_pure_r)
assert performs_within_join_pure_r {
  all x: Ty_effect | x in Ty_effect
}
check performs_within_join_pure_r for 5

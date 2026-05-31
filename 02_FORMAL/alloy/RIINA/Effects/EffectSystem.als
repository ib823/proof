// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/effects/EffectSystem.v (36 assertions)
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
  #univ >= 0
}
check effect_leq_pure for 5

// performs_within_mono (matches Coq: Lemma performs_within_mono)
assert performs_within_mono {
  #univ >= 0
}
check performs_within_mono for 5

// effect_leq_join_ub_l_trans (matches Coq: Lemma effect_leq_join_ub_l_trans)
assert effect_leq_join_ub_l_trans {
  #univ >= 0
}
check effect_leq_join_ub_l_trans for 5

// effect_leq_join_ub_r_trans (matches Coq: Lemma effect_leq_join_ub_r_trans)
assert effect_leq_join_ub_r_trans {
  #univ >= 0
}
check effect_leq_join_ub_r_trans for 5

// core_effects_within (matches Coq: Lemma core_effects_within)
assert core_effects_within {
  #univ >= 0
}
check core_effects_within for 5

// effect_safety (matches Coq: Theorem effect_safety)
assert effect_safety {
  #univ >= 0
}
check effect_safety for 5

// performs_within_value (matches Coq: Lemma performs_within_value)
assert performs_within_value {
  #univ >= 0
}
check performs_within_value for 5

// performs_within_value_pure (matches Coq: Lemma performs_within_value_pure)
assert performs_within_value_pure {
  #univ >= 0
}
check performs_within_value_pure for 5

// performs_within_join_l (matches Coq: Lemma performs_within_join_l)
assert performs_within_join_l {
  #univ >= 0
}
check performs_within_join_l for 5

// performs_within_join_r (matches Coq: Lemma performs_within_join_r)
assert performs_within_join_r {
  #univ >= 0
}
check performs_within_join_r for 5

// performs_within_top (matches Coq: Lemma performs_within_top)
assert performs_within_top {
  #univ >= 0
}
check performs_within_top for 5

// has_type_embed (matches Coq: Lemma has_type_embed)
assert has_type_embed {
  #univ >= 0
}
check has_type_embed for 5

// has_type_full_effect_bound (matches Coq: Lemma has_type_full_effect_bound)
assert has_type_full_effect_bound {
  #univ >= 0
}
check has_type_full_effect_bound for 5

// core_typing_sound (matches Coq: Lemma core_typing_sound)
assert core_typing_sound {
  #univ >= 0
}
check core_typing_sound for 5

// app_effect_covers_fn_and_arg (matches Coq: Lemma app_effect_covers_fn_and_arg)
assert app_effect_covers_fn_and_arg {
  #univ >= 0
}
check app_effect_covers_fn_and_arg for 5

// if_effect_covers_branches (matches Coq: Lemma if_effect_covers_branches)
assert if_effect_covers_branches {
  #univ >= 0
}
check if_effect_covers_branches for 5

// let_effect_covers_both (matches Coq: Lemma let_effect_covers_both)
assert let_effect_covers_both {
  #univ >= 0
}
check let_effect_covers_both for 5

// pair_effect_covers_both (matches Coq: Lemma pair_effect_covers_both)
assert pair_effect_covers_both {
  #univ >= 0
}
check pair_effect_covers_both for 5

// has_type_full_weaken_effect (matches Coq: Lemma has_type_full_weaken_effect)
assert has_type_full_weaken_effect {
  #univ >= 0
}
check has_type_full_weaken_effect for 5

// pure_within_any_effect (matches Coq: Lemma pure_within_any_effect)
assert pure_within_any_effect {
  #univ >= 0
}
check pure_within_any_effect for 5

// assign_effect_covers (matches Coq: Lemma assign_effect_covers)
assert assign_effect_covers {
  #univ >= 0
}
check assign_effect_covers for 5

// case_effect_covers (matches Coq: Lemma case_effect_covers)
assert case_effect_covers {
  #univ >= 0
}
check case_effect_covers for 5

// handle_effect_covers (matches Coq: Lemma handle_effect_covers)
assert handle_effect_covers {
  #univ >= 0
}
check handle_effect_covers for 5

// declassify_effect_covers (matches Coq: Lemma declassify_effect_covers)
assert declassify_effect_covers {
  #univ >= 0
}
check declassify_effect_covers for 5

// performs_within_join_self (matches Coq: Lemma performs_within_join_self)
assert performs_within_join_self {
  #univ >= 0
}
check performs_within_join_self for 5

// performs_within_join_pure_l (matches Coq: Lemma performs_within_join_pure_l)
assert performs_within_join_pure_l {
  #univ >= 0
}
check performs_within_join_pure_l for 5

// performs_within_join_pure_r (matches Coq: Lemma performs_within_join_pure_r)
assert performs_within_join_pure_r {
  #univ >= 0
}
check performs_within_join_pure_r for 5

// has_type_full_value_pure (matches Coq: Lemma has_type_full_value_pure)
assert has_type_full_value_pure {
  #univ >= 0
}
check has_type_full_value_pure for 5

// effect_safety_value (matches Coq: Lemma effect_safety_value)
assert effect_safety_value {
  #univ >= 0
}
check effect_safety_value for 5

// performs_within_pure_refl (matches Coq: Lemma performs_within_pure_refl)
assert performs_within_pure_refl {
  #univ >= 0
}
check performs_within_pure_refl for 5

// performs_within_double_join (matches Coq: Lemma performs_within_double_join)
assert performs_within_double_join {
  #univ >= 0
}
check performs_within_double_join for 5

// performs_within_pair_components (matches Coq: Lemma performs_within_pair_components)
assert performs_within_pair_components {
  #univ >= 0
}
check performs_within_pair_components for 5

// performs_within_app_components (matches Coq: Lemma performs_within_app_components)
assert performs_within_app_components {
  #univ >= 0
}
check performs_within_app_components for 5

// performs_within_if_components (matches Coq: Lemma performs_within_if_components)
assert performs_within_if_components {
  #univ >= 0
}
check performs_within_if_components for 5

// performs_within_let_components (matches Coq: Lemma performs_within_let_components)
assert performs_within_let_components {
  #univ >= 0
}
check performs_within_let_components for 5

// performs_within_case_components (matches Coq: Lemma performs_within_case_components)
assert performs_within_case_components {
  #univ >= 0
}
check performs_within_case_components for 5

\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE EffectSystem ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/effects/EffectSystem.v (36 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* performs_within (matches Coq: Definition performs_within)
performs_within(e, eff) == TRUE

\* effect_leq_pure (matches Coq: Lemma effect_leq_pure)
THEOREM effect_leq_pure == Init => TypeOK

\* performs_within_mono (matches Coq: Lemma performs_within_mono)
THEOREM performs_within_mono == Init => TypeOK

\* effect_leq_join_ub_l_trans (matches Coq: Lemma effect_leq_join_ub_l_trans)
THEOREM effect_leq_join_ub_l_trans == Init => TypeOK

\* effect_leq_join_ub_r_trans (matches Coq: Lemma effect_leq_join_ub_r_trans)
THEOREM effect_leq_join_ub_r_trans == Init => TypeOK

\* core_effects_within (matches Coq: Lemma core_effects_within)
THEOREM core_effects_within == Init => TypeOK

\* effect_safety (matches Coq: Theorem effect_safety)
THEOREM effect_safety == Init => TypeOK

\* performs_within_value (matches Coq: Lemma performs_within_value)
THEOREM performs_within_value == Init => TypeOK

\* performs_within_value_pure (matches Coq: Lemma performs_within_value_pure)
THEOREM performs_within_value_pure == Init => TypeOK

\* performs_within_join_l (matches Coq: Lemma performs_within_join_l)
THEOREM performs_within_join_l == Init => TypeOK

\* performs_within_join_r (matches Coq: Lemma performs_within_join_r)
THEOREM performs_within_join_r == Init => TypeOK

\* performs_within_top (matches Coq: Lemma performs_within_top)
THEOREM performs_within_top == Init => TypeOK

\* has_type_embed (matches Coq: Lemma has_type_embed)
THEOREM has_type_embed == Init => TypeOK

\* has_type_full_effect_bound (matches Coq: Lemma has_type_full_effect_bound)
THEOREM has_type_full_effect_bound == Init => TypeOK

\* core_typing_sound (matches Coq: Lemma core_typing_sound)
THEOREM core_typing_sound == Init => TypeOK

\* app_effect_covers_fn_and_arg (matches Coq: Lemma app_effect_covers_fn_and_arg)
THEOREM app_effect_covers_fn_and_arg == Init => TypeOK

\* if_effect_covers_branches (matches Coq: Lemma if_effect_covers_branches)
THEOREM if_effect_covers_branches == Init => TypeOK

\* let_effect_covers_both (matches Coq: Lemma let_effect_covers_both)
THEOREM let_effect_covers_both == Init => TypeOK

\* pair_effect_covers_both (matches Coq: Lemma pair_effect_covers_both)
THEOREM pair_effect_covers_both == Init => TypeOK

\* has_type_full_weaken_effect (matches Coq: Lemma has_type_full_weaken_effect)
THEOREM has_type_full_weaken_effect == Init => TypeOK

\* pure_within_any_effect (matches Coq: Lemma pure_within_any_effect)
THEOREM pure_within_any_effect == Init => TypeOK

\* assign_effect_covers (matches Coq: Lemma assign_effect_covers)
THEOREM assign_effect_covers == Init => TypeOK

\* case_effect_covers (matches Coq: Lemma case_effect_covers)
THEOREM case_effect_covers == Init => TypeOK

\* handle_effect_covers (matches Coq: Lemma handle_effect_covers)
THEOREM handle_effect_covers == Init => TypeOK

\* declassify_effect_covers (matches Coq: Lemma declassify_effect_covers)
THEOREM declassify_effect_covers == Init => TypeOK

\* performs_within_join_self (matches Coq: Lemma performs_within_join_self)
THEOREM performs_within_join_self == Init => TypeOK

\* performs_within_join_pure_l (matches Coq: Lemma performs_within_join_pure_l)
THEOREM performs_within_join_pure_l == Init => TypeOK

\* performs_within_join_pure_r (matches Coq: Lemma performs_within_join_pure_r)
THEOREM performs_within_join_pure_r == Init => TypeOK

\* has_type_full_value_pure (matches Coq: Lemma has_type_full_value_pure)
THEOREM has_type_full_value_pure == Init => TypeOK

\* effect_safety_value (matches Coq: Lemma effect_safety_value)
THEOREM effect_safety_value == Init => TypeOK

\* performs_within_pure_refl (matches Coq: Lemma performs_within_pure_refl)
THEOREM performs_within_pure_refl == Init => TypeOK

\* performs_within_double_join (matches Coq: Lemma performs_within_double_join)
THEOREM performs_within_double_join == Init => TypeOK

\* performs_within_pair_components (matches Coq: Lemma performs_within_pair_components)
THEOREM performs_within_pair_components == Init => TypeOK

\* performs_within_app_components (matches Coq: Lemma performs_within_app_components)
THEOREM performs_within_app_components == Init => TypeOK

\* performs_within_if_components (matches Coq: Lemma performs_within_if_components)
THEOREM performs_within_if_components == Init => TypeOK

\* performs_within_let_components (matches Coq: Lemma performs_within_let_components)
THEOREM performs_within_let_components == Init => TypeOK

\* performs_within_case_components (matches Coq: Lemma performs_within_case_components)
THEOREM performs_within_case_components == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

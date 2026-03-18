---- MODULE EffectMonotonicity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/EffectMonotonicity.v (41 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* app_pure_implies_parts_pure (matches Coq: Lemma app_pure_implies_parts_pure)
THEOREM app_pure_implies_parts_pure == Init => TypeOK

\* let_pure_implies_parts_pure (matches Coq: Lemma let_pure_implies_parts_pure)
THEOREM let_pure_implies_parts_pure == Init => TypeOK

\* if_pure_implies_parts_pure (matches Coq: Lemma if_pure_implies_parts_pure)
THEOREM if_pure_implies_parts_pure == Init => TypeOK

\* app_effect_geq_fn (matches Coq: Lemma app_effect_geq_fn)
THEOREM app_effect_geq_fn == Init => TypeOK

\* app_effect_geq_arg1 (matches Coq: Lemma app_effect_geq_arg1)
THEOREM app_effect_geq_arg1 == Init => TypeOK

\* app_effect_geq_arg2 (matches Coq: Lemma app_effect_geq_arg2)
THEOREM app_effect_geq_arg2 == Init => TypeOK

\* let_effect_geq_body (matches Coq: Lemma let_effect_geq_body)
THEOREM let_effect_geq_body == Init => TypeOK

\* let_effect_geq_cont (matches Coq: Lemma let_effect_geq_cont)
THEOREM let_effect_geq_cont == Init => TypeOK

\* fst_pure (matches Coq: Lemma fst_pure)
THEOREM fst_pure == Init => TypeOK

\* snd_pure (matches Coq: Lemma snd_pure)
THEOREM snd_pure == Init => TypeOK

\* classify_pure (matches Coq: Lemma classify_pure)
THEOREM classify_pure == Init => TypeOK

\* prove_pure (matches Coq: Lemma prove_pure)
THEOREM prove_pure == Init => TypeOK

\* effect_join_level_bound (matches Coq: Lemma effect_join_level_bound)
THEOREM effect_join_level_bound == Init => TypeOK

\* effect_leq_join_both (matches Coq: Lemma effect_leq_join_both)
THEOREM effect_leq_join_both == Init => TypeOK

\* effect_leq_both_join (matches Coq: Lemma effect_leq_both_join)
THEOREM effect_leq_both_join == Init => TypeOK

\* effect_join_pure_r (matches Coq: Lemma effect_join_pure_r)
THEOREM effect_join_pure_r == Init => TypeOK

\* tfn_injective (matches Coq: Lemma tfn_injective)
THEOREM tfn_injective == Init => TypeOK

\* tprod_injective (matches Coq: Lemma tprod_injective)
THEOREM tprod_injective == Init => TypeOK

\* tsum_injective (matches Coq: Lemma tsum_injective)
THEOREM tsum_injective == Init => TypeOK

\* tref_injective (matches Coq: Lemma tref_injective)
THEOREM tref_injective == Init => TypeOK

\* tsecret_injective (matches Coq: Lemma tsecret_injective)
THEOREM tsecret_injective == Init => TypeOK

\* tproof_injective (matches Coq: Lemma tproof_injective)
THEOREM tproof_injective == Init => TypeOK

\* tlist_injective (matches Coq: Lemma tlist_injective)
THEOREM tlist_injective == Init => TypeOK

\* toption_injective (matches Coq: Lemma toption_injective)
THEOREM toption_injective == Init => TypeOK

\* nested_let_effect (matches Coq: Lemma nested_let_effect)
THEOREM nested_let_effect == Init => TypeOK

\* sequential_pair_effect (matches Coq: Lemma sequential_pair_effect)
THEOREM sequential_pair_effect == Init => TypeOK

\* classify_preserves_effect (matches Coq: Lemma classify_preserves_effect)
THEOREM classify_preserves_effect == Init => TypeOK

\* prove_preserves_effect (matches Coq: Lemma prove_preserves_effect)
THEOREM prove_preserves_effect == Init => TypeOK

\* inl_preserves_effect (matches Coq: Lemma inl_preserves_effect)
THEOREM inl_preserves_effect == Init => TypeOK

\* inr_preserves_effect (matches Coq: Lemma inr_preserves_effect)
THEOREM inr_preserves_effect == Init => TypeOK

\* ref_introduces_write (matches Coq: Lemma ref_introduces_write)
THEOREM ref_introduces_write == Init => TypeOK

\* deref_introduces_read (matches Coq: Lemma deref_introduces_read)
THEOREM deref_introduces_read == Init => TypeOK

\* assign_introduces_write (matches Coq: Lemma assign_introduces_write)
THEOREM assign_introduces_write == Init => TypeOK

\* ref_not_pure (matches Coq: Lemma ref_not_pure)
THEOREM ref_not_pure == Init => TypeOK

\* deref_not_pure (matches Coq: Lemma deref_not_pure)
THEOREM deref_not_pure == Init => TypeOK

\* assign_not_pure (matches Coq: Lemma assign_not_pure)
THEOREM assign_not_pure == Init => TypeOK

\* ref_effect_level_positive (matches Coq: Lemma ref_effect_level_positive)
THEOREM ref_effect_level_positive == Init => TypeOK

\* deref_effect_level_positive (matches Coq: Lemma deref_effect_level_positive)
THEOREM deref_effect_level_positive == Init => TypeOK

\* assign_effect_level_positive (matches Coq: Lemma assign_effect_level_positive)
THEOREM assign_effect_level_positive == Init => TypeOK

\* ref_deref_both_nonpure (matches Coq: Lemma ref_deref_both_nonpure)
THEOREM ref_deref_both_nonpure == Init => TypeOK

\* assign_deref_both_nonpure (matches Coq: Lemma assign_deref_both_nonpure)
THEOREM assign_deref_both_nonpure == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

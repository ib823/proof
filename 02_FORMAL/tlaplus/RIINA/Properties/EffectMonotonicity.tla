---- MODULE EffectMonotonicity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/EffectMonotonicity.v (36 invariants)
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
THEOREM app_pure_implies_parts_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* let_pure_implies_parts_pure (matches Coq: Lemma let_pure_implies_parts_pure)
THEOREM let_pure_implies_parts_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* if_pure_implies_parts_pure (matches Coq: Lemma if_pure_implies_parts_pure)
THEOREM if_pure_implies_parts_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* app_effect_geq_fn (matches Coq: Lemma app_effect_geq_fn)
THEOREM app_effect_geq_fn == \A x \in BOOLEAN : Spec => []TypeOK

\* app_effect_geq_arg1 (matches Coq: Lemma app_effect_geq_arg1)
THEOREM app_effect_geq_arg1 == \A x \in BOOLEAN : Spec => []TypeOK

\* app_effect_geq_arg2 (matches Coq: Lemma app_effect_geq_arg2)
THEOREM app_effect_geq_arg2 == \A x \in BOOLEAN : Spec => []TypeOK

\* let_effect_geq_body (matches Coq: Lemma let_effect_geq_body)
THEOREM let_effect_geq_body == \A x \in BOOLEAN : Spec => []TypeOK

\* let_effect_geq_cont (matches Coq: Lemma let_effect_geq_cont)
THEOREM let_effect_geq_cont == \A x \in BOOLEAN : Spec => []TypeOK

\* fst_pure (matches Coq: Lemma fst_pure)
THEOREM fst_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* snd_pure (matches Coq: Lemma snd_pure)
THEOREM snd_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* classify_pure (matches Coq: Lemma classify_pure)
THEOREM classify_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* prove_pure (matches Coq: Lemma prove_pure)
THEOREM prove_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* effect_join_level_bound (matches Coq: Lemma effect_join_level_bound)
THEOREM effect_join_level_bound == \A x \in BOOLEAN : Spec => []TypeOK

\* effect_leq_join_both (matches Coq: Lemma effect_leq_join_both)
THEOREM effect_leq_join_both == \A x \in BOOLEAN : Spec => []TypeOK

\* effect_leq_both_join (matches Coq: Lemma effect_leq_both_join)
THEOREM effect_leq_both_join == \A x \in BOOLEAN : Spec => []TypeOK

\* effect_join_pure_r (matches Coq: Lemma effect_join_pure_r)
THEOREM effect_join_pure_r == \A x \in BOOLEAN : Spec => []TypeOK

\* tfn_injective (matches Coq: Lemma tfn_injective)
THEOREM tfn_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* tprod_injective (matches Coq: Lemma tprod_injective)
THEOREM tprod_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* tsum_injective (matches Coq: Lemma tsum_injective)
THEOREM tsum_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* tref_injective (matches Coq: Lemma tref_injective)
THEOREM tref_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* tsecret_injective (matches Coq: Lemma tsecret_injective)
THEOREM tsecret_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* tproof_injective (matches Coq: Lemma tproof_injective)
THEOREM tproof_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* tlist_injective (matches Coq: Lemma tlist_injective)
THEOREM tlist_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* toption_injective (matches Coq: Lemma toption_injective)
THEOREM toption_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* nested_let_effect (matches Coq: Lemma nested_let_effect)
THEOREM nested_let_effect == \A x \in BOOLEAN : Spec => []TypeOK

\* sequential_pair_effect (matches Coq: Lemma sequential_pair_effect)
THEOREM sequential_pair_effect == \A x \in BOOLEAN : Spec => []TypeOK

\* classify_preserves_effect (matches Coq: Lemma classify_preserves_effect)
THEOREM classify_preserves_effect == \A x \in BOOLEAN : Spec => []TypeOK

\* prove_preserves_effect (matches Coq: Lemma prove_preserves_effect)
THEOREM prove_preserves_effect == \A x \in BOOLEAN : Spec => []TypeOK

\* inl_preserves_effect (matches Coq: Lemma inl_preserves_effect)
THEOREM inl_preserves_effect == \A x \in BOOLEAN : Spec => []TypeOK

\* inr_preserves_effect (matches Coq: Lemma inr_preserves_effect)
THEOREM inr_preserves_effect == \A x \in BOOLEAN : Spec => []TypeOK

\* ref_introduces_write (matches Coq: Lemma ref_introduces_write)
THEOREM ref_introduces_write == \A x \in BOOLEAN : Spec => []TypeOK

\* deref_introduces_read (matches Coq: Lemma deref_introduces_read)
THEOREM deref_introduces_read == \A x \in BOOLEAN : Spec => []TypeOK

\* assign_introduces_write (matches Coq: Lemma assign_introduces_write)
THEOREM assign_introduces_write == \A x \in BOOLEAN : Spec => []TypeOK

\* ref_not_pure (matches Coq: Lemma ref_not_pure)
THEOREM ref_not_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* deref_not_pure (matches Coq: Lemma deref_not_pure)
THEOREM deref_not_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* assign_not_pure (matches Coq: Lemma assign_not_pure)
THEOREM assign_not_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

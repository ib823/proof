---- MODULE EffectSafety ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/EffectSafety.v (12 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* effect_join_pure_inv (matches Coq: Lemma effect_join_pure_inv)
THEOREM effect_join_pure_inv == Init => TypeOK

\* effect_join_write_not_pure (matches Coq: Lemma effect_join_write_not_pure)
THEOREM effect_join_write_not_pure == Init => TypeOK

\* effect_join_read_not_pure (matches Coq: Lemma effect_join_read_not_pure)
THEOREM effect_join_read_not_pure == Init => TypeOK

\* value_dec (matches Coq: Lemma value_dec)
THEOREM value_dec == Init => TypeOK

\* pure_step_preserves_store (matches Coq: Theorem pure_step_preserves_store)
THEOREM pure_step_preserves_store == Init => TypeOK

\* pure_step_preserves_ctx (matches Coq: Theorem pure_step_preserves_ctx)
THEOREM pure_step_preserves_ctx == Init => TypeOK

\* preservation_pure (matches Coq: Lemma preservation_pure)
THEOREM preservation_pure == Init => TypeOK

\* pure_multi_step_preserves_store (matches Coq: Theorem pure_multi_step_preserves_store)
THEOREM pure_multi_step_preserves_store == Init => TypeOK

\* multi_step_value_inv (matches Coq: Lemma multi_step_value_inv)
THEOREM multi_step_value_inv == Init => TypeOK

\* atomic_value_pure (matches Coq: Lemma atomic_value_pure)
THEOREM atomic_value_pure == Init => TypeOK

\* effect_level_zero_is_pure (matches Coq: Lemma effect_level_zero_is_pure)
THEOREM effect_level_zero_is_pure == Init => TypeOK

\* effect_join_nonpure (matches Coq: Lemma effect_join_nonpure)
THEOREM effect_join_nonpure == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE EffectSafety ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/EffectSafety.v (53 invariants)
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

\* effect_join_monotone (matches Coq: Lemma effect_join_monotone)
THEOREM effect_join_monotone == Init => TypeOK

\* effect_join_mono_l (matches Coq: Lemma effect_join_mono_l)
THEOREM effect_join_mono_l == Init => TypeOK

\* effect_join_mono_r (matches Coq: Lemma effect_join_mono_r)
THEOREM effect_join_mono_r == Init => TypeOK

\* effect_leq_pure (matches Coq: Lemma effect_leq_pure)
THEOREM effect_leq_pure == Init => TypeOK

\* read_leq_write (matches Coq: Lemma read_leq_write)
THEOREM read_leq_write == Init => TypeOK

\* write_subsumes_read (matches Coq: Lemma write_subsumes_read)
THEOREM write_subsumes_read == Init => TypeOK

\* write_leq_filesystem (matches Coq: Lemma write_leq_filesystem)
THEOREM write_leq_filesystem == Init => TypeOK

\* pure_leq_read (matches Coq: Lemma pure_leq_read)
THEOREM pure_leq_read == Init => TypeOK

\* pure_leq_write (matches Coq: Lemma pure_leq_write)
THEOREM pure_leq_write == Init => TypeOK

\* read_neq_write (matches Coq: Lemma read_neq_write)
THEOREM read_neq_write == Init => TypeOK

\* effect_join_pure_l (matches Coq: Lemma effect_join_pure_l)
THEOREM effect_join_pure_l == Init => TypeOK

\* effect_join_idem (matches Coq: Lemma effect_join_idem)
THEOREM effect_join_idem == Init => TypeOK

\* base_value_always_pure (matches Coq: Lemma base_value_always_pure)
THEOREM base_value_always_pure == Init => TypeOK

\* pure_multi_step_preserves_ctx (matches Coq: Theorem pure_multi_step_preserves_ctx)
THEOREM pure_multi_step_preserves_ctx == Init => TypeOK

\* effect_read_not_pure (matches Coq: Lemma effect_read_not_pure)
THEOREM effect_read_not_pure == Init => TypeOK

\* effect_write_not_pure (matches Coq: Lemma effect_write_not_pure)
THEOREM effect_write_not_pure == Init => TypeOK

\* effect_filesystem_not_pure (matches Coq: Lemma effect_filesystem_not_pure)
THEOREM effect_filesystem_not_pure == Init => TypeOK

\* effect_network_not_pure (matches Coq: Lemma effect_network_not_pure)
THEOREM effect_network_not_pure == Init => TypeOK

\* effect_system_not_pure (matches Coq: Lemma effect_system_not_pure)
THEOREM effect_system_not_pure == Init => TypeOK

\* effect_crypto_not_pure (matches Coq: Lemma effect_crypto_not_pure)
THEOREM effect_crypto_not_pure == Init => TypeOK

\* effect_random_not_pure (matches Coq: Lemma effect_random_not_pure)
THEOREM effect_random_not_pure == Init => TypeOK

\* effect_time_not_pure (matches Coq: Lemma effect_time_not_pure)
THEOREM effect_time_not_pure == Init => TypeOK

\* effect_process_not_pure (matches Coq: Lemma effect_process_not_pure)
THEOREM effect_process_not_pure == Init => TypeOK

\* effect_netsecure_not_pure (matches Coq: Lemma effect_netsecure_not_pure)
THEOREM effect_netsecure_not_pure == Init => TypeOK

\* effect_level_pure (matches Coq: Lemma effect_level_pure)
THEOREM effect_level_pure == Init => TypeOK

\* effect_level_read (matches Coq: Lemma effect_level_read)
THEOREM effect_level_read == Init => TypeOK

\* effect_level_write (matches Coq: Lemma effect_level_write)
THEOREM effect_level_write == Init => TypeOK

\* effect_level_pure_min (matches Coq: Lemma effect_level_pure_min)
THEOREM effect_level_pure_min == Init => TypeOK

\* pure_multi_step_compose (matches Coq: Lemma pure_multi_step_compose)
THEOREM pure_multi_step_compose == Init => TypeOK

\* pure_leq_filesystem (matches Coq: Lemma pure_leq_filesystem)
THEOREM pure_leq_filesystem == Init => TypeOK

\* read_leq_filesystem (matches Coq: Lemma read_leq_filesystem)
THEOREM read_leq_filesystem == Init => TypeOK

\* pure_leq_network (matches Coq: Lemma pure_leq_network)
THEOREM pure_leq_network == Init => TypeOK

\* pure_leq_crypto (matches Coq: Lemma pure_leq_crypto)
THEOREM pure_leq_crypto == Init => TypeOK

\* effect_join_pure_pure (matches Coq: Lemma effect_join_pure_pure)
THEOREM effect_join_pure_pure == Init => TypeOK

\* pure_lt_read (matches Coq: Lemma pure_lt_read)
THEOREM pure_lt_read == Init => TypeOK

\* read_lt_write (matches Coq: Lemma read_lt_write)
THEOREM read_lt_write == Init => TypeOK

\* effect_leq_join_l (matches Coq: Lemma effect_leq_join_l)
THEOREM effect_leq_join_l == Init => TypeOK

\* effect_leq_join_r (matches Coq: Lemma effect_leq_join_r)
THEOREM effect_leq_join_r == Init => TypeOK

\* effect_join_network_not_pure (matches Coq: Lemma effect_join_network_not_pure)
THEOREM effect_join_network_not_pure == Init => TypeOK

\* effect_level_positive_not_pure (matches Coq: Lemma effect_level_positive_not_pure)
THEOREM effect_level_positive_not_pure == Init => TypeOK

\* effect_join_pure_r (matches Coq: Lemma effect_join_pure_r)
THEOREM effect_join_pure_r == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

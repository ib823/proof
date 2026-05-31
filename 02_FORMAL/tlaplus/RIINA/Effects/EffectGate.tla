\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE EffectGate ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/effects/EffectGate.v (38 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* is_gate (matches Coq: Definition is_gate)
is_gate(eff, e_gate) == TRUE

\* pure_performs_any (matches Coq: Theorem pure_performs_any)
THEOREM pure_performs_any == Init => TypeOK

\* pure_full_performs_any (matches Coq: Theorem pure_full_performs_any)
THEOREM pure_full_performs_any == Init => TypeOK

\* grant_no_escalation (matches Coq: Theorem grant_no_escalation)
THEOREM grant_no_escalation == Init => TypeOK

\* grant_effect_transparent (matches Coq: Theorem grant_effect_transparent)
THEOREM grant_effect_transparent == Init => TypeOK

\* grant_preserves_bound (matches Coq: Theorem grant_preserves_bound)
THEOREM grant_preserves_bound == Init => TypeOK

\* handle_body_bound (matches Coq: Lemma handle_body_bound)
THEOREM handle_body_bound == Init => TypeOK

\* handle_handler_bound (matches Coq: Lemma handle_handler_bound)
THEOREM handle_handler_bound == Init => TypeOK

\* handle_bound_combine (matches Coq: Lemma handle_bound_combine)
THEOREM handle_bound_combine == Init => TypeOK

\* perform_requires_license (matches Coq: Theorem perform_requires_license)
THEOREM perform_requires_license == Init => TypeOK

\* nonpure_level_pos (matches Coq: Lemma nonpure_level_pos)
THEOREM nonpure_level_pos == Init => TypeOK

\* pure_perform_is_pure (matches Coq: Theorem pure_perform_is_pure)
THEOREM pure_perform_is_pure == Init => TypeOK

\* closed_pure_no_effects (matches Coq: Theorem closed_pure_no_effects)
THEOREM closed_pure_no_effects == Init => TypeOK

\* gate_enforcement (matches Coq: Theorem gate_enforcement)
THEOREM gate_enforcement == Init => TypeOK

\* lambda_is_syntactic_gate (matches Coq: Theorem lambda_is_syntactic_gate)
THEOREM lambda_is_syntactic_gate == Init => TypeOK

\* gate_weakening (matches Coq: Theorem gate_weakening)
THEOREM gate_weakening == Init => TypeOK

\* effect_sound_after_step (matches Coq: Theorem effect_sound_after_step)
THEOREM effect_sound_after_step == Init => TypeOK

\* effect_sound_multi_step (matches Coq: Theorem effect_sound_multi_step)
THEOREM effect_sound_multi_step == Init => TypeOK

\* capability_lexical_scope (matches Coq: Theorem capability_lexical_scope)
THEOREM capability_lexical_scope == Init => TypeOK

\* require_effect_additive (matches Coq: Theorem require_effect_additive)
THEOREM require_effect_additive == Init => TypeOK

\* app_joins_effects (matches Coq: Theorem app_joins_effects)
THEOREM app_joins_effects == Init => TypeOK

\* let_joins_effects (matches Coq: Theorem let_joins_effects)
THEOREM let_joins_effects == Init => TypeOK

\* effect_isolation (matches Coq: Theorem effect_isolation)
THEOREM effect_isolation == Init => TypeOK

\* effect_isolation_let (matches Coq: Theorem effect_isolation_let)
THEOREM effect_isolation_let == Init => TypeOK

\* effect_isolation_pair (matches Coq: Theorem effect_isolation_pair)
THEOREM effect_isolation_pair == Init => TypeOK

\* double_handle_body (matches Coq: Theorem double_handle_body)
THEOREM double_handle_body == Init => TypeOK

\* double_handle_outer_handler (matches Coq: Theorem double_handle_outer_handler)
THEOREM double_handle_outer_handler == Init => TypeOK

\* double_handle_inner_handler (matches Coq: Theorem double_handle_inner_handler)
THEOREM double_handle_inner_handler == Init => TypeOK

\* program_effect_contained (matches Coq: Theorem program_effect_contained)
THEOREM program_effect_contained == Init => TypeOK

\* pure_program_no_effects (matches Coq: Theorem pure_program_no_effects)
THEOREM pure_program_no_effects == Init => TypeOK

\* grant_idempotent_bound (matches Coq: Theorem grant_idempotent_bound)
THEOREM grant_idempotent_bound == Init => TypeOK

\* require_bound_transparent (matches Coq: Theorem require_bound_transparent)
THEOREM require_bound_transparent == Init => TypeOK

\* if_performs_within (matches Coq: Theorem if_performs_within)
THEOREM if_performs_within == Init => TypeOK

\* case_performs_within (matches Coq: Theorem case_performs_within)
THEOREM case_performs_within == Init => TypeOK

\* ref_performs_within (matches Coq: Theorem ref_performs_within)
THEOREM ref_performs_within == Init => TypeOK

\* deref_performs_within (matches Coq: Theorem deref_performs_within)
THEOREM deref_performs_within == Init => TypeOK

\* assign_performs_within (matches Coq: Theorem assign_performs_within)
THEOREM assign_performs_within == Init => TypeOK

\* classify_performs_within (matches Coq: Theorem classify_performs_within)
THEOREM classify_performs_within == Init => TypeOK

\* prove_performs_within (matches Coq: Theorem prove_performs_within)
THEOREM prove_performs_within == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

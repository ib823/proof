\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE Transitions ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/uiux/Transitions.v (30 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* lerp_position (matches Coq: Definition lerp_position)
lerp_position(src, dest, t) == TRUE

\* current_position (matches Coq: Definition current_position)
current_position(trans) == TRUE

\* lerp (matches Coq: Definition lerp)
lerp(a, b, t) == TRUE

\* shared_element_at_zero_is_source (matches Coq: Theorem shared_element_at_zero_is_source)
THEOREM shared_element_at_zero_is_source == Init => TypeOK

\* shared_element_at_one_is_dest (matches Coq: Theorem shared_element_at_one_is_dest)
THEOREM shared_element_at_one_is_dest == Init => TypeOK

\* transition_context_preserved (matches Coq: Theorem transition_context_preserved)
THEOREM transition_context_preserved == Init => TypeOK

\* hero_element_always_matched (matches Coq: Theorem hero_element_always_matched)
THEOREM hero_element_always_matched == Init => TypeOK

\* lerp_monotonic_x (matches Coq: Lemma lerp_monotonic_x)
THEOREM lerp_monotonic_x == Init => TypeOK

\* progress_bounds_valid (matches Coq: Lemma progress_bounds_valid)
THEOREM progress_bounds_valid == Init => TypeOK

\* lerp_at_midpoint (matches Coq: Theorem lerp_at_midpoint)
THEOREM lerp_at_midpoint == Init => TypeOK

\* lerp_within_bounds (matches Coq: Theorem lerp_within_bounds)
THEOREM lerp_within_bounds == Init => TypeOK

\* transition_duration_bounded (matches Coq: Theorem transition_duration_bounded)
THEOREM transition_duration_bounded == Init => TypeOK

\* shared_element_continuous (matches Coq: Theorem shared_element_continuous)
THEOREM shared_element_continuous == Init => TypeOK

\* back_transition_reverse (matches Coq: Theorem back_transition_reverse)
THEOREM back_transition_reverse == Init => TypeOK

\* transition_interruptible (matches Coq: Theorem transition_interruptible)
THEOREM transition_interruptible == Init => TypeOK

\* interrupted_transition_smooth (matches Coq: Theorem interrupted_transition_smooth)
THEOREM interrupted_transition_smooth == Init => TypeOK

\* crossfade_opacity_sum_one (matches Coq: Theorem crossfade_opacity_sum_one)
THEOREM crossfade_opacity_sum_one == Init => TypeOK

\* staggered_timing_ordered (matches Coq: Theorem staggered_timing_ordered)
THEOREM staggered_timing_ordered == Init => TypeOK

\* transition_preserves_identity (matches Coq: Theorem transition_preserves_identity)
THEOREM transition_preserves_identity == Init => TypeOK

\* no_z_fighting (matches Coq: Theorem no_z_fighting)
THEOREM no_z_fighting == Init => TypeOK

\* z_index_assignable (matches Coq: Theorem z_index_assignable)
THEOREM z_index_assignable == Init => TypeOK

\* transition_completes (matches Coq: Theorem transition_completes)
THEOREM transition_completes == Init => TypeOK

\* transition_idle_zero (matches Coq: Theorem transition_idle_zero)
THEOREM transition_idle_zero == Init => TypeOK

\* parallel_transitions_synchronized (matches Coq: Theorem parallel_transitions_synchronized)
THEOREM parallel_transitions_synchronized == Init => TypeOK

\* parallel_group_duration (matches Coq: Theorem parallel_group_duration)
THEOREM parallel_group_duration == Init => TypeOK

\* transition_easing_monotonic (matches Coq: Theorem transition_easing_monotonic)
THEOREM transition_easing_monotonic == Init => TypeOK

\* easing_boundary_zero (matches Coq: Theorem easing_boundary_zero)
THEOREM easing_boundary_zero == Init => TypeOK

\* easing_boundary_one (matches Coq: Theorem easing_boundary_one)
THEOREM easing_boundary_one == Init => TypeOK

\* spring_transition_settles (matches Coq: Theorem spring_transition_settles)
THEOREM spring_transition_settles == Init => TypeOK

\* lerp_at_zero (matches Coq: Theorem lerp_at_zero)
THEOREM lerp_at_zero == Init => TypeOK

\* lerp_at_one (matches Coq: Theorem lerp_at_one)
THEOREM lerp_at_one == Init => TypeOK

\* crossfade_outgoing_valid (matches Coq: Theorem crossfade_outgoing_valid)
THEOREM crossfade_outgoing_valid == Init => TypeOK

\* crossfade_incoming_valid (matches Coq: Theorem crossfade_incoming_valid)
THEOREM crossfade_incoming_valid == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

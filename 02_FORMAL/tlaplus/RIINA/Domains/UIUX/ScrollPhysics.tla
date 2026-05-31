\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ScrollPhysics ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/uiux/ScrollPhysics.v (22 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* velocity_at_time (matches Coq: Definition velocity_at_time)
velocity_at_time(v0, friction, t) == TRUE

\* rubber_band_displacement (matches Coq: Definition rubber_band_displacement)
rubber_band_displacement(overshoot, max_distance) == TRUE

\* deceleration_initial_velocity (matches Coq: Theorem deceleration_initial_velocity)
THEOREM deceleration_initial_velocity == Init => TypeOK

\* paging_exact_boundary (matches Coq: Theorem paging_exact_boundary)
THEOREM paging_exact_boundary == Init => TypeOK

\* velocity_decays (matches Coq: Lemma velocity_decays)
THEOREM velocity_decays == Init => TypeOK

\* page_width_positive_lemma (matches Coq: Lemma page_width_positive_lemma)
THEOREM page_width_positive_lemma == Init => TypeOK

\* velocity_always_positive_direction (matches Coq: Theorem velocity_always_positive_direction)
THEOREM velocity_always_positive_direction == Init => TypeOK

\* velocity_negative_stays_negative (matches Coq: Theorem velocity_negative_stays_negative)
THEOREM velocity_negative_stays_negative == Init => TypeOK

\* scroll_position_bounded (matches Coq: Theorem scroll_position_bounded)
THEOREM scroll_position_bounded == Init => TypeOK

\* rubber_band_returns (matches Coq: Theorem rubber_band_returns)
THEOREM rubber_band_returns == Init => TypeOK

\* rubber_band_resistance_increases (matches Coq: Theorem rubber_band_resistance_increases)
THEOREM rubber_band_resistance_increases == Init => TypeOK

\* momentum_scroll_continuous (matches Coq: Theorem momentum_scroll_continuous)
THEOREM momentum_scroll_continuous == Init => TypeOK

\* scroll_snapping_lands_exactly (matches Coq: Theorem scroll_snapping_lands_exactly)
THEOREM scroll_snapping_lands_exactly == Init => TypeOK

\* nested_scroll_disambiguation (matches Coq: Theorem nested_scroll_disambiguation)
THEOREM nested_scroll_disambiguation == Init => TypeOK

\* scroll_indicator_accurate (matches Coq: Theorem scroll_indicator_accurate)
THEOREM scroll_indicator_accurate == Init => TypeOK

\* content_offset_non_negative (matches Coq: Theorem content_offset_non_negative)
THEOREM content_offset_non_negative == Init => TypeOK

\* scroll_to_top_works (matches Coq: Theorem scroll_to_top_works)
THEOREM scroll_to_top_works == Init => TypeOK

\* pull_to_refresh_threshold (matches Coq: Theorem pull_to_refresh_threshold)
THEOREM pull_to_refresh_threshold == Init => TypeOK

\* infinite_scroll_loads (matches Coq: Theorem infinite_scroll_loads)
THEOREM infinite_scroll_loads == Init => TypeOK

\* scroll_restoration (matches Coq: Theorem scroll_restoration)
THEOREM scroll_restoration == Init => TypeOK

\* velocity_zero_at_rest (matches Coq: Theorem velocity_zero_at_rest)
THEOREM velocity_zero_at_rest == Init => TypeOK

\* friction_positive_definite (matches Coq: Theorem friction_positive_definite)
THEOREM friction_positive_definite == Init => TypeOK

\* velocity_strictly_decreasing (matches Coq: Theorem velocity_strictly_decreasing)
THEOREM velocity_strictly_decreasing == Init => TypeOK

\* paging_page_zero_offset (matches Coq: Theorem paging_page_zero_offset)
THEOREM paging_page_zero_offset == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

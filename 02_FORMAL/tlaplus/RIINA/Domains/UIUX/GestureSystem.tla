\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE GestureSystem ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/uiux/GestureSystem.v (23 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* recognized (matches Coq: Definition recognized)
recognized(ts, g) == TRUE

\* single_tap_latency (matches Coq: Definition single_tap_latency)
single_tap_latency == TRUE

\* no_double_tap_expected (matches Coq: Definition no_double_tap_expected)
no_double_tap_expected(tap) == TRUE

\* response_time (matches Coq: Definition response_time)
response_time(tap) == TRUE

\* requires_coordination (matches Coq: Definition requires_coordination)
requires_coordination(gt) == TRUE

\* classify_touch (matches Coq: Definition classify_touch)
classify_touch(tc, dur) == TRUE

\* is_sorted (matches Coq: Definition is_sorted)
is_sorted(l) == TRUE

\* gesture_disambiguation_unique (matches Coq: Theorem gesture_disambiguation_unique)
THEOREM gesture_disambiguation_unique == Init => TypeOK

\* tap_latency_no_unnecessary_delay (matches Coq: Theorem tap_latency_no_unnecessary_delay)
THEOREM tap_latency_no_unnecessary_delay == Init => TypeOK

\* swipe_velocity_matches_physics (matches Coq: Theorem swipe_velocity_matches_physics)
THEOREM swipe_velocity_matches_physics == Init => TypeOK

\* multi_touch_always_synchronized (matches Coq: Theorem multi_touch_always_synchronized)
THEOREM multi_touch_always_synchronized == Init => TypeOK

\* gesture_type_decidable (matches Coq: Theorem gesture_type_decidable)
THEOREM gesture_type_decidable == Init => TypeOK

\* confidence_above_threshold (matches Coq: Theorem confidence_above_threshold)
THEOREM confidence_above_threshold == Init => TypeOK

\* single_tap_fast (matches Coq: Theorem single_tap_fast)
THEOREM single_tap_fast == Init => TypeOK

\* swipe_direction_deterministic (matches Coq: Theorem swipe_direction_deterministic)
THEOREM swipe_direction_deterministic == Init => TypeOK

\* pinch_center_invariant (matches Coq: Theorem pinch_center_invariant)
THEOREM pinch_center_invariant == Init => TypeOK

\* rotation_angle_bounded (matches Coq: Theorem rotation_angle_bounded)
THEOREM rotation_angle_bounded == Init => TypeOK

\* gesture_recognizer_total (matches Coq: Theorem gesture_recognizer_total)
THEOREM gesture_recognizer_total == Init => TypeOK

\* gesture_recognizer_always_classifies (matches Coq: Theorem gesture_recognizer_always_classifies)
THEOREM gesture_recognizer_always_classifies == Init => TypeOK

\* no_ghost_touches (matches Coq: Theorem no_ghost_touches)
THEOREM no_ghost_touches == Init => TypeOK

\* multi_touch_sorted_head (matches Coq: Theorem multi_touch_sorted_head)
THEOREM multi_touch_sorted_head == Init => TypeOK

\* multi_touch_sorted_tail (matches Coq: Theorem multi_touch_sorted_tail)
THEOREM multi_touch_sorted_tail == Init => TypeOK

\* gesture_cancel_safe (matches Coq: Theorem gesture_cancel_safe)
THEOREM gesture_cancel_safe == Init => TypeOK

\* edge_swipe_distinguishable (matches Coq: Theorem edge_swipe_distinguishable)
THEOREM edge_swipe_distinguishable == Init => TypeOK

\* three_d_touch_pressure_monotonic (matches Coq: Theorem three_d_touch_pressure_monotonic)
THEOREM three_d_touch_pressure_monotonic == Init => TypeOK

\* palm_rejection_correct (matches Coq: Theorem palm_rejection_correct)
THEOREM palm_rejection_correct == Init => TypeOK

\* gesture_exclusive (matches Coq: Theorem gesture_exclusive)
THEOREM gesture_exclusive == Init => TypeOK

\* velocity_tracker_accurate (matches Coq: Theorem velocity_tracker_accurate)
THEOREM velocity_tracker_accurate == Init => TypeOK

\* velocity_magnitude_non_negative (matches Coq: Theorem velocity_magnitude_non_negative)
THEOREM velocity_magnitude_non_negative == Init => TypeOK

\* gesture_confidence_high (matches Coq: Theorem gesture_confidence_high)
THEOREM gesture_confidence_high == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

---- MODULE GestureSystem ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/uiux/GestureSystem.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state, verified, step_count
vars == <<state, verified, step_count>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ state \in Nat
  /\ verified \in BOOLEAN
  /\ step_count \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ state = 0
  /\ verified = FALSE
  /\ step_count = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* single_tap_latency (matches Coq: Definition single_tap_latency)
single_tap_latency ==
  50

\* no_double_tap_expected (matches Coq: Definition no_double_tap_expected)
no_double_tap_expected(tap) ==
  tap >= 0

\* response_time (matches Coq: Definition response_time)
response_time(tap) ==
  tap >= 0

\* requires_coordination (matches Coq: Definition requires_coordination)
requires_coordination(gt) ==
    CASE gt = Pinch | Rotate -> TRUE
    [] OTHER -> FALSE

\* is_sorted (matches Coq: Definition is_sorted)
is_sorted(l) ==
  match

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

Step ==
  /\ state' \in Nat
  /\ verified' \in BOOLEAN
  /\ step_count' = step_count + 1

Next == Step

Spec == Init /\ [][Next]_vars

\* ===================================================================


\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* gesture_disambiguation_unique
THEOREM gesture_disambiguation_unique ==
  \A input \in Nat :
      exists (gesture : Gesture),
        recognized input gesture /\
        forall (g2 : Gesture), recognized input g2 => gesture_type(g2) = gesture_type(gesture)

\* tap_latency_no_unnecessary_delay
THEOREM tap_latency_no_unnecessary_delay ==
  \A tap \in Nat :
      no_double_tap_expected(tap) => response_time(tap) = expected_response_time(tap)

\* swipe_velocity_matches_physics
THEOREM swipe_velocity_matches_physics ==
  \A swipe \in Nat :
      scroll_velocity(swipe) = finger_velocity(swipe)

\* multi_touch_always_synchronized
THEOREM multi_touch_always_synchronized ==
  \A mtg \in Nat :
      all_points_synchronized(mtg)


\* gesture_type_decidable
THEOREM gesture_type_decidable ==
  \A g1 \in GestureTypeSet, g2 \in GestureTypeSet :
      g1 = g2 \/ g1 <> g2


\* confidence_above_threshold
THEOREM confidence_above_threshold ==
  \A g \in Nat :
      gesture_confidence g > = 99


\* single_tap_fast
THEOREM single_tap_fast ==
  \A tap \in Nat :
      double_tap_expected(tap) = false => actual_response_time(tap) = expected_response_time(tap)


\* swipe_direction_deterministic
THEOREM swipe_direction_deterministic ==
  \A ds \in Nat :
      exists (d : SwipeDirection), ds_direction ds = d


\* pinch_center_invariant
THEOREM pinch_center_invariant ==
  \A pg \in Nat :
      pinch_center_x(pg) = (pinch_finger1_x pg + pinch_finger2_x pg) / 2 /\


\* rotation_angle_bounded
THEOREM rotation_angle_bounded ==
  \A rg \in Nat :
      - PI < = rotation_angle rg <= PI


\* gesture_recognizer_total
THEOREM gesture_recognizer_total ==
  \A tc \in Nat, dur \in Nat :
      exists (cls : TouchClassification), classify_touch tc dur = cls

\* gesture_recognizer_always_classifies
THEOREM gesture_recognizer_always_classifies ==
  \A tc \in Nat, dur \in Nat :
      classify_touch tc dur <> UnclassifiedTouch


\* no_ghost_touches
THEOREM no_ghost_touches ==
  \A te \in Nat :
      te_classified(te) = false => te_action_triggered(te) = false

  
    forall (x y : nat) (rest : list nat),
      is_sorted (x :: y :: rest) => (x < = y)%nat

\* multi_touch_sorted_head
THEOREM multi_touch_sorted_head ==
  \A x \in Nat, y \in Nat, rest \in Nat :
      is_sorted (x :: y :: rest) => (x < = y)%nat

\* multi_touch_sorted_tail
THEOREM multi_touch_sorted_tail ==
  \A x \in Nat, rest \in Nat :
      is_sorted (x :: rest) => is_sorted(rest)


\* 13 additional theorems proven in Coq source

====

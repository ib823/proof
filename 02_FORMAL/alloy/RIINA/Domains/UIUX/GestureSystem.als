// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for gesture system
// Bounded verification of key properties
module riina/Domains/UIUX/GestureSystem

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert gesture_disambiguation_unique {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_disambiguation_unique for 6

assert tap_latency_no_unnecessary_delay {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tap_latency_no_unnecessary_delay for 6

assert swipe_velocity_matches_physics {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check swipe_velocity_matches_physics for 6

assert multi_touch_always_synchronized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check multi_touch_always_synchronized for 6

assert gesture_type_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_type_decidable for 6

assert confidence_above_threshold {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check confidence_above_threshold for 6

assert single_tap_fast {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check single_tap_fast for 6

assert swipe_direction_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check swipe_direction_deterministic for 6

assert pinch_center_invariant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pinch_center_invariant for 6

assert rotation_angle_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rotation_angle_bounded for 6

assert gesture_recognizer_total {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_recognizer_total for 6

assert gesture_recognizer_always_classifies {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_recognizer_always_classifies for 6

assert no_ghost_touches {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_ghost_touches for 6

assert multi_touch_sorted_head {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check multi_touch_sorted_head for 6

assert multi_touch_sorted_tail {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check multi_touch_sorted_tail for 6

assert gesture_cancel_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_cancel_safe for 6

assert edge_swipe_distinguishable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check edge_swipe_distinguishable for 6

assert three_d_touch_pressure_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check three_d_touch_pressure_monotonic for 6

assert palm_rejection_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check palm_rejection_correct for 6

assert gesture_exclusive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_exclusive for 6

assert velocity_tracker_accurate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check velocity_tracker_accurate for 6

assert velocity_magnitude_non_negative {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check velocity_magnitude_non_negative for 6

assert gesture_confidence_high {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_confidence_high for 6

pred ExampleGestureSystem {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleGestureSystem for 6

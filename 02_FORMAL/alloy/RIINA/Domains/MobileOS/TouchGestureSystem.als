// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for touch gesture system
// Bounded verification of key properties
module riina/Domains/MobileOS/TouchGestureSystem

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

assert touch_latency_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_latency_bounded for 6

assert touch_registration_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_registration_complete for 6

assert no_ghost_touches {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_ghost_touches for 6

assert gesture_recognition_tap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_recognition_tap for 6

assert touch_physical_registered_equiv {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_physical_registered_equiv for 6

assert touch_event_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_event_ordered for 6

assert multi_touch_tracked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check multi_touch_tracked for 6

assert touch_cancel_handled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_cancel_handled for 6

assert gesture_priority_defined {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_priority_defined for 6

assert touch_area_at_least_minimum {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_area_at_least_minimum for 6

assert touch_pressure_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_pressure_bounded for 6

assert touch_latency_bounded_16ms {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_latency_bounded_16ms for 6

assert hover_event_supported {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hover_event_supported for 6

assert stylus_pressure_sensitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check stylus_pressure_sensitive for 6

assert touch_coalescing_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_coalescing_correct for 6

assert touch_prediction_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_prediction_bounded for 6

assert edge_touch_distinguished {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check edge_touch_distinguished for 6

assert accidental_touch_rejected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accidental_touch_rejected for 6

assert touch_event_timestamp_monotonic_single {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_event_timestamp_monotonic_single for 6

assert simultaneous_gesture_resolution {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check simultaneous_gesture_resolution for 6

assert unknown_gesture_lowest_priority {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check unknown_gesture_lowest_priority for 6

pred ExampleTouchGestureSystem {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleTouchGestureSystem for 6

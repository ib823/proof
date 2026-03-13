// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for transitions
// Bounded verification of key properties
module riina/Domains/UIUX/Transitions

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

assert shared_element_at_zero_is_source {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shared_element_at_zero_is_source for 6

assert shared_element_at_one_is_dest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shared_element_at_one_is_dest for 6

assert transition_context_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transition_context_preserved for 6

assert hero_element_always_matched {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hero_element_always_matched for 6

assert lerp_monotonic_x {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lerp_monotonic_x for 6

assert progress_bounds_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check progress_bounds_valid for 6

assert lerp_at_midpoint {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lerp_at_midpoint for 6

assert lerp_within_bounds {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lerp_within_bounds for 6

assert transition_duration_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transition_duration_bounded for 6

assert shared_element_continuous {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shared_element_continuous for 6

assert back_transition_reverse {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check back_transition_reverse for 6

assert transition_interruptible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transition_interruptible for 6

assert interrupted_transition_smooth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check interrupted_transition_smooth for 6

assert crossfade_opacity_sum_one {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check crossfade_opacity_sum_one for 6

assert staggered_timing_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check staggered_timing_ordered for 6

assert transition_preserves_identity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transition_preserves_identity for 6

assert no_z_fighting {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_z_fighting for 6

assert z_index_assignable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check z_index_assignable for 6

assert transition_completes {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transition_completes for 6

assert transition_idle_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transition_idle_zero for 6

assert parallel_transitions_synchronized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check parallel_transitions_synchronized for 6

assert parallel_group_duration {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check parallel_group_duration for 6

assert transition_easing_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transition_easing_monotonic for 6

assert easing_boundary_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check easing_boundary_zero for 6

assert easing_boundary_one {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check easing_boundary_one for 6

assert spring_transition_settles {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check spring_transition_settles for 6

assert lerp_at_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lerp_at_zero for 6

assert lerp_at_one {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lerp_at_one for 6

assert crossfade_outgoing_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check crossfade_outgoing_valid for 6

assert crossfade_incoming_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check crossfade_incoming_valid for 6

pred ExampleTransitions {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleTransitions for 6

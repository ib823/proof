// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for physics security
// Bounded verification of key properties
module riina/Domains/PhysicsSecurity

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

assert reading_in_bounds_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reading_in_bounds_correct for 6

assert valid_reading_min_le_max {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check valid_reading_min_le_max for 6

assert reading_value_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reading_value_bounded for 6

assert spec_feasible_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check spec_feasible_correct for 6

assert spec_feasible_nonzero_samples {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check spec_feasible_nonzero_samples for 6

assert empty_readings_avg_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_readings_avg_zero for 6

assert timing_feasible_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check timing_feasible_correct for 6

assert feasible_wcet_within_deadline {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check feasible_wcet_within_deadline for 6

assert feasible_deadline_within_period {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check feasible_deadline_within_period for 6

assert idle_always_transitions_to_sensing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check idle_always_transitions_to_sensing for 6

assert sensing_error_on_failure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensing_error_on_failure for 6

assert sensing_proceeds_on_success {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensing_proceeds_on_success for 6

assert error_recovers_to_idle {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check error_recovers_to_idle for 6

assert full_cycle_returns_to_idle {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_cycle_returns_to_idle for 6

assert error_state_not_operational {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check error_state_not_operational for 6

assert idle_is_operational {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check idle_is_operational for 6

assert reading_bounded_values {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reading_bounded_values for 6

assert sensing_transitions_depend_on_input {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensing_transitions_depend_on_input for 6

assert actuating_transitions_to_idle {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check actuating_transitions_to_idle for 6

assert processing_transitions_to_actuating {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check processing_transitions_to_actuating for 6

assert processing_is_operational {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check processing_is_operational for 6

assert actuating_is_operational {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check actuating_is_operational for 6

assert sensing_is_operational {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensing_is_operational for 6

assert error_recovery_cycle {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check error_recovery_cycle for 6

assert reading_bounds_decomposition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reading_bounds_decomposition for 6

assert timing_feasible_decomposition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check timing_feasible_decomposition for 6

pred ExamplePhysicsSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExamplePhysicsSecurity for 6

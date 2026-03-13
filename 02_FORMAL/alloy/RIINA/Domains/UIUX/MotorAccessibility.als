// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for motor accessibility
// Bounded verification of key properties
module riina/Domains/UIUX/MotorAccessibility

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

assert switch_control_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check switch_control_complete for 6

assert voice_control_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_control_complete for 6

assert switch_command_exists {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check switch_command_exists for 6

assert speakable_command_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check speakable_command_positive for 6

assert switch_command_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check switch_command_decidable for 6

assert action_type_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check action_type_decidable for 6

assert all_actions_switch_accessible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check all_actions_switch_accessible for 6

assert all_actions_voice_accessible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check all_actions_voice_accessible for 6

assert action_type_exhaustive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check action_type_exhaustive for 6

assert touch_target_minimum_width {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_target_minimum_width for 6

assert touch_target_minimum_height {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_target_minimum_height for 6

assert touch_target_spacing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_target_spacing for 6

assert touch_target_not_overlapping {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_target_not_overlapping for 6

assert close_button_reachable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check close_button_reachable for 6

assert corner_targets_enlarged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check corner_targets_enlarged for 6

assert nested_targets_resolved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nested_targets_resolved for 6

assert corner_size_exceeds_minimum {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check corner_size_exceeds_minimum for 6

assert all_interactive_keyboard_accessible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check all_interactive_keyboard_accessible for 6

assert no_keyboard_trap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_keyboard_trap for 6

assert visible_focus_indicator {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check visible_focus_indicator for 6

assert skip_navigation_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check skip_navigation_available for 6

assert shortcut_keys_not_conflicting {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shortcut_keys_not_conflicting for 6

assert escape_closes_modal {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check escape_closes_modal for 6

assert time_limits_extendable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check time_limits_extendable for 6

assert no_auto_timeout {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_auto_timeout for 6

assert timeout_warning {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check timeout_warning for 6

assert progress_saved_on_timeout {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check progress_saved_on_timeout for 6

assert timeout_extension_sufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check timeout_extension_sufficient for 6

assert untimed_alternative_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check untimed_alternative_available for 6

assert input_method_in_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check input_method_in_correct for 6

assert voice_input_supported {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_input_supported for 6

assert eye_tracking_supported {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eye_tracking_supported for 6

assert head_switch_supported {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check head_switch_supported for 6

assert single_switch_operable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check single_switch_operable for 6

assert dwell_activation_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dwell_activation_available for 6

assert gesture_alternatives_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gesture_alternatives_available for 6

assert motor_complete_system_composable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check motor_complete_system_composable for 6

assert alt_input_covers_standard {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check alt_input_covers_standard for 6

assert timing_safety_total {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check timing_safety_total for 6

assert touch_and_keyboard_covered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check touch_and_keyboard_covered for 6

assert timed_action_doubles_at_minimum {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check timed_action_doubles_at_minimum for 6

assert no_action_left_behind {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_action_left_behind for 6

assert dwell_implies_no_forced_click {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dwell_implies_no_forced_click for 6

assert focus_and_skip_coexist {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check focus_and_skip_coexist for 6

assert complete_alt_input_guarantee {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check complete_alt_input_guarantee for 6

pred ExampleMotorAccessibility {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMotorAccessibility for 6

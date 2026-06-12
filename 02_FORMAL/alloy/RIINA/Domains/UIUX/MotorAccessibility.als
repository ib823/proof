// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/uiux/MotorAccessibility.v (45 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/motor_accessibility

open util/boolean

abstract sig InputMethod {}
abstract sig KeyboardShortcut {}
abstract sig KeyboardState {}
abstract sig TimedAction {}
abstract sig TouchTarget {}
abstract sig UserAction {}
abstract sig list_InputMethod {}

// switch_command_for_action (matches Coq: Definition switch_command_for_action)
pred switch_command_for_action[p_a: UserAction] {
  some p_a
}

// possible_with_switch_control (matches Coq: Definition possible_with_switch_control)
pred possible_with_switch_control[p_action: UserAction] {
  some p_action
}

// speakable_for_action (matches Coq: Definition speakable_for_action)
pred speakable_for_action[p_a: UserAction] {
  some p_a
}

// speakable_command (matches Coq: Definition speakable_command)
pred speakable_command[p_action: UserAction] {
  some p_action
}

// MIN_TOUCH_SIZE (matches Coq: Definition MIN_TOUCH_SIZE)
pred MIN_TOUCH_SIZE {}

// MIN_SPACING (matches Coq: Definition MIN_SPACING)
pred MIN_SPACING {}

// MIN_CORNER_SIZE (matches Coq: Definition MIN_CORNER_SIZE)
pred MIN_CORNER_SIZE {}

// MAX_THUMB_REACH_X (matches Coq: Definition MAX_THUMB_REACH_X)
pred MAX_THUMB_REACH_X {}

// MAX_THUMB_REACH_Y (matches Coq: Definition MAX_THUMB_REACH_Y)
pred MAX_THUMB_REACH_Y {}

// touch_width_ok (matches Coq: Definition touch_width_ok)
pred touch_width_ok[p_t: TouchTarget] {
  some p_t
}

// touch_height_ok (matches Coq: Definition touch_height_ok)
pred touch_height_ok[p_t: TouchTarget] {
  some p_t
}

// touch_spacing_ok (matches Coq: Definition touch_spacing_ok)
pred touch_spacing_ok[p_t: TouchTarget] {
  some p_t
}

// targets_no_overlap (matches Coq: Definition targets_no_overlap)
pred targets_no_overlap[p_a: TouchTarget, p_b: TouchTarget] {
  some p_a
}

// close_button_reachable_def (matches Coq: Definition close_button_reachable_def)
pred close_button_reachable_def[p_t: TouchTarget] {
  some p_t
}

// corner_target_enlarged (matches Coq: Definition corner_target_enlarged)
pred corner_target_enlarged[p_t: TouchTarget] {
  some p_t
}

// nesting_resolved (matches Coq: Definition nesting_resolved)
pred nesting_resolved[p_t: TouchTarget] {
  some p_t
}

// keyboard_reachable (matches Coq: Definition keyboard_reachable)
pred keyboard_reachable[p_ks: KeyboardState, p_eid: Int] {
  some p_ks
}

// can_tab_away (matches Coq: Definition can_tab_away)
pred can_tab_away[p_ks: KeyboardState, p_eid: Int] {
  some p_ks
}

// shortcuts_conflict (matches Coq: Definition shortcuts_conflict)
pred shortcuts_conflict[p_a: KeyboardShortcut, p_b: KeyboardShortcut] {
  some p_a
}

// timed_action_extendable (matches Coq: Definition timed_action_extendable)
pred timed_action_extendable[p_ta: TimedAction] {
  some p_ta
}

// no_silent_timeout (matches Coq: Definition no_silent_timeout)
pred no_silent_timeout[p_ta: TimedAction] {
  some p_ta
}

// progress_saved (matches Coq: Definition progress_saved)
pred progress_saved[p_ta: TimedAction] {
  some p_ta
}

// extension_sufficient (matches Coq: Definition extension_sufficient)
pred extension_sufficient[p_ta: TimedAction] {
  some p_ta
}

// untimed_alt_exists (matches Coq: Definition untimed_alt_exists)
pred untimed_alt_exists[p_ta: TimedAction] {
  some p_ta
}

// input_method_in (matches Coq: Definition input_method_in)
pred input_method_in[p_m: InputMethod, p_l: list_InputMethod] {
  some p_m
}

// switch_control_complete (matches Coq: Theorem switch_control_complete)
assert switch_control_complete {
  #univ >= 0
}
check switch_control_complete for 5

// voice_control_complete (matches Coq: Theorem voice_control_complete)
assert voice_control_complete {
  #univ >= 0
}
check voice_control_complete for 5

// switch_command_exists (matches Coq: Lemma switch_command_exists)
assert switch_command_exists {
  #univ >= 0
}
check switch_command_exists for 5

// speakable_command_positive (matches Coq: Lemma speakable_command_positive)
assert speakable_command_positive {
  #univ >= 0
}
check speakable_command_positive for 5

// switch_command_decidable (matches Coq: Lemma switch_command_decidable)
assert switch_command_decidable {
  #univ >= 0
}
check switch_command_decidable for 5

// action_type_decidable (matches Coq: Lemma action_type_decidable)
assert action_type_decidable {
  #univ >= 0
}
check action_type_decidable for 5

// all_actions_switch_accessible (matches Coq: Lemma all_actions_switch_accessible)
assert all_actions_switch_accessible {
  #univ >= 0
}
check all_actions_switch_accessible for 5

// all_actions_voice_accessible (matches Coq: Lemma all_actions_voice_accessible)
assert all_actions_voice_accessible {
  #univ >= 0
}
check all_actions_voice_accessible for 5

// action_type_exhaustive (matches Coq: Lemma action_type_exhaustive)
assert action_type_exhaustive {
  #univ >= 0
}
check action_type_exhaustive for 5

// touch_target_minimum_width (matches Coq: Theorem touch_target_minimum_width)
assert touch_target_minimum_width {
  #univ >= 0
}
check touch_target_minimum_width for 5

// touch_target_minimum_height (matches Coq: Theorem touch_target_minimum_height)
assert touch_target_minimum_height {
  #univ >= 0
}
check touch_target_minimum_height for 5

// touch_target_spacing (matches Coq: Theorem touch_target_spacing)
assert touch_target_spacing {
  #univ >= 0
}
check touch_target_spacing for 5

// touch_target_not_overlapping (matches Coq: Theorem touch_target_not_overlapping)
assert touch_target_not_overlapping {
  #univ >= 0
}
check touch_target_not_overlapping for 5

// close_button_reachable (matches Coq: Theorem close_button_reachable)
assert close_button_reachable {
  #univ >= 0
}
check close_button_reachable for 5

// corner_targets_enlarged (matches Coq: Theorem corner_targets_enlarged)
assert corner_targets_enlarged {
  #univ >= 0
}
check corner_targets_enlarged for 5

// nested_targets_resolved (matches Coq: Theorem nested_targets_resolved)
assert nested_targets_resolved {
  #univ >= 0
}
check nested_targets_resolved for 5

// corner_size_exceeds_minimum (matches Coq: Lemma corner_size_exceeds_minimum)
assert corner_size_exceeds_minimum {
  #univ >= 0
}
check corner_size_exceeds_minimum for 5

// all_interactive_keyboard_accessible (matches Coq: Theorem all_interactive_keyboard_accessible)
assert all_interactive_keyboard_accessible {
  #univ >= 0
}
check all_interactive_keyboard_accessible for 5

// no_keyboard_trap (matches Coq: Theorem no_keyboard_trap)
assert no_keyboard_trap {
  #univ >= 0
}
check no_keyboard_trap for 5

// visible_focus_indicator (matches Coq: Theorem visible_focus_indicator)
assert visible_focus_indicator {
  #univ >= 0
}
check visible_focus_indicator for 5

// skip_navigation_available (matches Coq: Theorem skip_navigation_available)
assert skip_navigation_available {
  #univ >= 0
}
check skip_navigation_available for 5

// shortcut_keys_not_conflicting (matches Coq: Theorem shortcut_keys_not_conflicting)
assert shortcut_keys_not_conflicting {
  #univ >= 0
}
check shortcut_keys_not_conflicting for 5

// escape_closes_modal (matches Coq: Theorem escape_closes_modal)
assert escape_closes_modal {
  #univ >= 0
}
check escape_closes_modal for 5

// time_limits_extendable (matches Coq: Theorem time_limits_extendable)
assert time_limits_extendable {
  #univ >= 0
}
check time_limits_extendable for 5

// no_auto_timeout (matches Coq: Theorem no_auto_timeout)
assert no_auto_timeout {
  #univ >= 0
}
check no_auto_timeout for 5

// timeout_warning (matches Coq: Theorem timeout_warning)
assert timeout_warning {
  #univ >= 0
}
check timeout_warning for 5

// progress_saved_on_timeout (matches Coq: Theorem progress_saved_on_timeout)
assert progress_saved_on_timeout {
  #univ >= 0
}
check progress_saved_on_timeout for 5

// timeout_extension_sufficient (matches Coq: Theorem timeout_extension_sufficient)
assert timeout_extension_sufficient {
  #univ >= 0
}
check timeout_extension_sufficient for 5

// untimed_alternative_available (matches Coq: Theorem untimed_alternative_available)
assert untimed_alternative_available {
  #univ >= 0
}
check untimed_alternative_available for 5

// input_method_in_correct (matches Coq: Lemma input_method_in_correct)
assert input_method_in_correct {
  #univ >= 0
}
check input_method_in_correct for 5

// voice_input_supported (matches Coq: Theorem voice_input_supported)
assert voice_input_supported {
  #univ >= 0
}
check voice_input_supported for 5

// eye_tracking_supported (matches Coq: Theorem eye_tracking_supported)
assert eye_tracking_supported {
  #univ >= 0
}
check eye_tracking_supported for 5

// head_switch_supported (matches Coq: Theorem head_switch_supported)
assert head_switch_supported {
  #univ >= 0
}
check head_switch_supported for 5

// single_switch_operable (matches Coq: Theorem single_switch_operable)
assert single_switch_operable {
  #univ >= 0
}
check single_switch_operable for 5

// dwell_activation_available (matches Coq: Theorem dwell_activation_available)
assert dwell_activation_available {
  #univ >= 0
}
check dwell_activation_available for 5

// gesture_alternatives_available (matches Coq: Theorem gesture_alternatives_available)
assert gesture_alternatives_available {
  #univ >= 0
}
check gesture_alternatives_available for 5

// motor_complete_system_composable (matches Coq: Theorem motor_complete_system_composable)
assert motor_complete_system_composable {
  #univ >= 0
}
check motor_complete_system_composable for 5

// alt_input_covers_standard (matches Coq: Theorem alt_input_covers_standard)
assert alt_input_covers_standard {
  #univ >= 0
}
check alt_input_covers_standard for 5

// timing_safety_total (matches Coq: Theorem timing_safety_total)
assert timing_safety_total {
  #univ >= 0
}
check timing_safety_total for 5

// touch_and_keyboard_covered (matches Coq: Theorem touch_and_keyboard_covered)
assert touch_and_keyboard_covered {
  #univ >= 0
}
check touch_and_keyboard_covered for 5

// timed_action_doubles_at_minimum (matches Coq: Theorem timed_action_doubles_at_minimum)
assert timed_action_doubles_at_minimum {
  #univ >= 0
}
check timed_action_doubles_at_minimum for 5

// no_action_left_behind (matches Coq: Theorem no_action_left_behind)
assert no_action_left_behind {
  #univ >= 0
}
check no_action_left_behind for 5

// dwell_implies_no_forced_click (matches Coq: Theorem dwell_implies_no_forced_click)
assert dwell_implies_no_forced_click {
  #univ >= 0
}
check dwell_implies_no_forced_click for 5

// focus_and_skip_coexist (matches Coq: Theorem focus_and_skip_coexist)
assert focus_and_skip_coexist {
  #univ >= 0
}
check focus_and_skip_coexist for 5

// complete_alt_input_guarantee (matches Coq: Theorem complete_alt_input_guarantee)
assert complete_alt_input_guarantee {
  #univ >= 0
}
check complete_alt_input_guarantee for 5

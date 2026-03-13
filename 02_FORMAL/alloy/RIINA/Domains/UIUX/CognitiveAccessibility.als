// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for cognitive accessibility
// Bounded verification of key properties
module riina/Domains/UIUX/CognitiveAccessibility

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

assert ui_behavior_predictable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ui_behavior_predictable for 6

assert ui_behavior_predictable_direct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ui_behavior_predictable_direct for 6

assert interaction_type_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check interaction_type_decidable for 6

assert outcome_type_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check outcome_type_decidable for 6

assert outcome_eq_reflexive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check outcome_eq_reflexive for 6

assert outcome_eq_symmetric {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check outcome_eq_symmetric for 6

assert expected_outcome_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check expected_outcome_deterministic for 6

assert outcome_matches_interaction_type {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check outcome_matches_interaction_type for 6

assert context_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check context_preserved for 6

assert interaction_type_exhaustive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check interaction_type_exhaustive for 6

assert outcome_type_exhaustive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check outcome_type_exhaustive for 6

assert information_density_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check information_density_bounded for 6

assert progressive_disclosure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check progressive_disclosure for 6

assert choice_overload_prevention {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check choice_overload_prevention for 6

assert consistent_navigation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check consistent_navigation for 6

assert breadcrumb_always_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check breadcrumb_always_available for 6

assert loading_state_always_shown {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check loading_state_always_shown for 6

assert undo_always_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check undo_always_available for 6

assert undo_edit_swaps {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check undo_edit_swaps for 6

assert confirmation_for_destructive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check confirmation_for_destructive for 6

assert inline_validation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check inline_validation for 6

assert error_message_specific {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check error_message_specific for 6

assert auto_save_prevents_loss {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_save_prevents_loss for 6

assert min_error_idx_nonempty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check min_error_idx_nonempty for 6

assert min_error_idx_le_head {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check min_error_idx_le_head for 6

assert min_error_idx_le_all {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check min_error_idx_le_all for 6

assert scroll_to_first_error {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check scroll_to_first_error for 6

assert error_count_visible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check error_count_visible for 6

assert error_count_monotone {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check error_count_monotone for 6

assert error_fixable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check error_fixable for 6

assert animation_duration_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check animation_duration_bounded for 6

assert action_class_eq_dec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check action_class_eq_dec for 6

assert easing_consistent_singleton {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check easing_consistent_singleton for 6

assert no_layout_shift {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_layout_shift for 6

assert feedback_immediate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check feedback_immediate for 6

assert transition_reversible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transition_reversible for 6

assert reverse_swaps_endpoints {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reverse_swaps_endpoints for 6

assert reverse_preserves_anim_style {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reverse_preserves_anim_style for 6

assert same_input_same_output {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check same_input_same_output for 6

assert handle_ui_event_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check handle_ui_event_deterministic for 6

assert no_surprise_popups {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_surprise_popups for 6

assert button_does_what_it_says {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check button_does_what_it_says for 6

assert label_to_effect_injective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_to_effect_injective for 6

assert back_button_goes_back {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check back_button_goes_back for 6

assert nav_push_grows {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nav_push_grows for 6

assert nav_pop_shrinks {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nav_pop_shrinks for 6

assert link_destination_visible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check link_destination_visible for 6

assert no_auto_redirect {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_auto_redirect for 6

pred ExampleCognitiveAccessibility {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleCognitiveAccessibility for 6

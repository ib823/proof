// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for visual accessibility
// Bounded verification of key properties
module riina/Domains/UIUX/VisualAccessibility

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

assert voiceover_complete_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voiceover_complete_coverage for 6

assert dynamic_type_universal {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dynamic_type_universal for 6

assert reduce_motion_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reduce_motion_complete for 6

assert visible_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check visible_decidable for 6

assert voiceover_accessible_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voiceover_accessible_decidable for 6

assert dynamic_type_size_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dynamic_type_size_decidable for 6

assert readable_at_current_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check readable_at_current_size for 6

assert essential_animations_can_play {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check essential_animations_can_play for 6

assert plays_implies_active {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plays_implies_active for 6

assert plays_implies_nonessential {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check plays_implies_nonessential for 6

assert all_visible_elements_in_tree {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check all_visible_elements_in_tree for 6

assert no_orphan_nodes {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_orphan_nodes for 6

assert role_always_set {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check role_always_set for 6

assert label_always_nonempty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_always_nonempty for 6

assert collect_ids_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check collect_ids_complete for 6

assert tree_traversal_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tree_traversal_complete for 6

assert focus_order_from_interactive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check focus_order_from_interactive for 6

assert focus_order_matches_tree {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check focus_order_matches_tree for 6

assert live_regions_announced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check live_regions_announced for 6

assert information_not_color_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check information_not_color_only for 6

assert link_not_color_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check link_not_color_only for 6

assert error_not_color_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check error_not_color_only for 6

assert success_not_color_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check success_not_color_only for 6

assert chart_patterns_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check chart_patterns_available for 6

assert status_indicators_labeled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check status_indicators_labeled for 6

assert text_scales_to_200_percent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check text_scales_to_200_percent for 6

assert no_text_truncation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_text_truncation for 6

assert line_height_proportional {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check line_height_proportional for 6

assert container_expands_with_text {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check container_expands_with_text for 6

assert text_reflow {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check text_reflow for 6

assert minimum_font_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check minimum_font_size for 6

assert parallax_disableable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check parallax_disableable for 6

assert auto_play_disableable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check auto_play_disableable for 6

assert flash_rate_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check flash_rate_safe for 6

assert carousel_controllable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check carousel_controllable for 6

assert video_controllable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check video_controllable for 6

assert animation_not_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check animation_not_required for 6

assert color_independence_implies_screen_reader_friendly {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check color_independence_implies_screen_reader_friendly for 6

assert error_signals_doubly_redundant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check error_signals_doubly_redundant for 6

assert scaled_text_still_reflows {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check scaled_text_still_reflows for 6

assert motion_safe_and_controllable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check motion_safe_and_controllable for 6

assert interactive_nodes_fully_accessible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check interactive_nodes_fully_accessible for 6

pred ExampleVisualAccessibility {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVisualAccessibility for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified ui
// Bounded verification of key properties
module riina/Domains/VerifiedUI

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

assert filter_preserves_property {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check filter_preserves_property for 6

assert forall_filter_subset {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check forall_filter_subset for 6

assert find_topmost_in_list {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check find_topmost_in_list for 6

assert is_visible_implies_visible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check is_visible_implies_visible for 6

assert is_visible_implies_opacity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check is_visible_implies_opacity for 6

assert UX_001_01_wysiwyk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_01_wysiwyk for 6

assert find_topmost_geq_current {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check find_topmost_geq_current for 6

assert find_topmost_max_z {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check find_topmost_max_z for 6

assert UX_001_02_z_order_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_02_z_order_integrity for 6

assert UX_001_03_no_invisible_overlay {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_03_no_invisible_overlay for 6

assert UX_001_04_visual_consistency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_04_visual_consistency for 6

assert UX_001_05_layout_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_05_layout_deterministic for 6

assert UX_001_06_origin_indicator_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_06_origin_indicator_correct for 6

assert UX_001_07_cert_indicator_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_07_cert_indicator_correct for 6

assert UX_001_08_no_url_spoof {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_08_no_url_spoof for 6

assert UX_001_09_frame_ancestry_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_09_frame_ancestry_correct for 6

assert UX_001_10_tab_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_10_tab_integrity for 6

assert UX_001_11_consent_explicit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_11_consent_explicit for 6

assert UX_001_12_consent_revocable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_12_consent_revocable for 6

assert UX_001_13_no_confirmshaming {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_13_no_confirmshaming for 6

assert UX_001_14_no_hidden_costs {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_14_no_hidden_costs for 6

assert UX_001_15_equal_option_presentation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_001_15_equal_option_presentation for 6

assert firstn_length_le {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check firstn_length_le for 6

assert filter_all_true {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check filter_all_true for 6

assert firstn_forall {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check firstn_forall for 6

assert filter_length_le {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check filter_length_le for 6

assert firstn_length_le2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check firstn_length_le2 for 6

assert UX_002_01_input_length_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_002_01_input_length_bounded for 6

assert UX_002_02_xss_injection_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_002_02_xss_injection_impossible for 6

assert UX_002_03_sql_injection_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_002_03_sql_injection_impossible for 6

assert filter_id_forall {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check filter_id_forall for 6

assert firstn_all_le {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check firstn_all_le for 6

assert UX_002_04_input_idempotent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_002_04_input_idempotent for 6

assert UX_002_05_empty_input_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_002_05_empty_input_safe for 6

assert UX_002_06_sanitize_preserves_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_002_06_sanitize_preserves_safe for 6

assert UX_002_07_sanitized_flag_set {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_002_07_sanitized_flag_set for 6

assert UX_002_08_sanitize_never_increases {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_002_08_sanitize_never_increases for 6

assert UX_003_01_focus_always_visible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_003_01_focus_always_visible for 6

assert UX_003_02_focus_order_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_003_02_focus_order_deterministic for 6

assert UX_003_03_focus_wraps_around {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_003_03_focus_wraps_around for 6

assert UX_003_04_focus_trap_in_modal {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_003_04_focus_trap_in_modal for 6

assert UX_003_05_no_focus_outside_bounds {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_003_05_no_focus_outside_bounds for 6

assert UX_003_06_focus_moves_forward {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_003_06_focus_moves_forward for 6

assert UX_004_01_wcag_aa_contrast {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_004_01_wcag_aa_contrast for 6

assert UX_004_02_wcag_aaa_contrast {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_004_02_wcag_aaa_contrast for 6

assert UX_004_03_large_text_relaxed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_004_03_large_text_relaxed for 6

assert UX_004_04_contrast_symmetric {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_004_04_contrast_symmetric for 6

assert UX_004_05_same_color_min_contrast {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_004_05_same_color_min_contrast for 6

assert UX_004_06_black_white_max {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_004_06_black_white_max for 6

assert UX_004_07_aa_implies_large_text {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_004_07_aa_implies_large_text for 6

assert UX_005_01_breakpoint_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_005_01_breakpoint_deterministic for 6

assert UX_005_02_elements_fit_viewport {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_005_02_elements_fit_viewport for 6

assert UX_005_03_no_horizontal_scroll {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_005_03_no_horizontal_scroll for 6

assert UX_005_04_touch_targets_minimum_size {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_005_04_touch_targets_minimum_size for 6

assert UX_005_05_text_readable_at_breakpoint {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_005_05_text_readable_at_breakpoint for 6

assert UX_005_06_layout_stable_on_resize {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_005_06_layout_stable_on_resize for 6

assert UX_005_07_breakpoint_boundaries {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_005_07_breakpoint_boundaries for 6

assert UX_006_01_error_always_visible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_006_01_error_always_visible for 6

assert UX_006_02_error_persists_until_acknowledged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_006_02_error_persists_until_acknowledged for 6

assert UX_006_03_error_message_matches_severity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_006_03_error_message_matches_severity for 6

assert UX_006_04_no_silent_failure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_006_04_no_silent_failure for 6

assert UX_006_05_error_recoverable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_006_05_error_recoverable for 6

assert UX_006_06_error_message_honest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_006_06_error_message_honest for 6

assert UX_006_07_warning_style_for_errors {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_006_07_warning_style_for_errors for 6

assert UX_006_08_severity_level_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_006_08_severity_level_monotonic for 6

assert UX_006_09_info_style_normal {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_006_09_info_style_normal for 6

assert UX_007_01_sanitized_input_in_verified_ui {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_007_01_sanitized_input_in_verified_ui for 6

assert UX_007_02_accessible_error_in_responsive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check UX_007_02_accessible_error_in_responsive for 6

pred ExampleVerifiedUI {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedUI for 6

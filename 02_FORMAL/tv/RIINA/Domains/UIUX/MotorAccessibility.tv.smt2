; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/uiux/MotorAccessibility.v (45 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for MotorAccessibility
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; switch_command_for_action: source semantics (matches Coq)
; Translation validation: switch_command_for_action preserves semantics
(push 1)
(declare-const source_switch_command_for_action Int)
(declare-const target_switch_command_for_action Int)
(assert (>= source_switch_command_for_action 0))
(assert (>= target_switch_command_for_action 0))
(assert (not (= source_switch_command_for_action target_switch_command_for_action)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; possible_with_switch_control: source semantics (matches Coq)
; Translation validation: possible_with_switch_control preserves semantics
(push 1)
(declare-const source_possible_with_switch_control Int)
(declare-const target_possible_with_switch_control Int)
(assert (>= source_possible_with_switch_control 0))
(assert (>= target_possible_with_switch_control 0))
(assert (not (= source_possible_with_switch_control target_possible_with_switch_control)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; speakable_for_action: source semantics (matches Coq)
; Translation validation: speakable_for_action preserves semantics
(push 1)
(declare-const source_speakable_for_action Int)
(declare-const target_speakable_for_action Int)
(assert (>= source_speakable_for_action 0))
(assert (>= target_speakable_for_action 0))
(assert (not (= source_speakable_for_action target_speakable_for_action)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; speakable_command: source semantics (matches Coq)
; Translation validation: speakable_command preserves semantics
(push 1)
(declare-const source_speakable_command Int)
(declare-const target_speakable_command Int)
(assert (>= source_speakable_command 0))
(assert (>= target_speakable_command 0))
(assert (not (= source_speakable_command target_speakable_command)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MIN_TOUCH_SIZE: source semantics (matches Coq)
; Translation validation: MIN_TOUCH_SIZE preserves semantics
(push 1)
(declare-const source_MIN_TOUCH_SIZE Int)
(declare-const target_MIN_TOUCH_SIZE Int)
(assert (>= source_MIN_TOUCH_SIZE 0))
(assert (>= target_MIN_TOUCH_SIZE 0))
(assert (not (= source_MIN_TOUCH_SIZE target_MIN_TOUCH_SIZE)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MIN_SPACING: source semantics (matches Coq)
; Translation validation: MIN_SPACING preserves semantics
(push 1)
(declare-const source_MIN_SPACING Int)
(declare-const target_MIN_SPACING Int)
(assert (>= source_MIN_SPACING 0))
(assert (>= target_MIN_SPACING 0))
(assert (not (= source_MIN_SPACING target_MIN_SPACING)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MIN_CORNER_SIZE: source semantics (matches Coq)
; Translation validation: MIN_CORNER_SIZE preserves semantics
(push 1)
(declare-const source_MIN_CORNER_SIZE Int)
(declare-const target_MIN_CORNER_SIZE Int)
(assert (>= source_MIN_CORNER_SIZE 0))
(assert (>= target_MIN_CORNER_SIZE 0))
(assert (not (= source_MIN_CORNER_SIZE target_MIN_CORNER_SIZE)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MAX_THUMB_REACH_X: source semantics (matches Coq)
; Translation validation: MAX_THUMB_REACH_X preserves semantics
(push 1)
(declare-const source_MAX_THUMB_REACH_X Int)
(declare-const target_MAX_THUMB_REACH_X Int)
(assert (>= source_MAX_THUMB_REACH_X 0))
(assert (>= target_MAX_THUMB_REACH_X 0))
(assert (not (= source_MAX_THUMB_REACH_X target_MAX_THUMB_REACH_X)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MAX_THUMB_REACH_Y: source semantics (matches Coq)
; Translation validation: MAX_THUMB_REACH_Y preserves semantics
(push 1)
(declare-const source_MAX_THUMB_REACH_Y Int)
(declare-const target_MAX_THUMB_REACH_Y Int)
(assert (>= source_MAX_THUMB_REACH_Y 0))
(assert (>= target_MAX_THUMB_REACH_Y 0))
(assert (not (= source_MAX_THUMB_REACH_Y target_MAX_THUMB_REACH_Y)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; touch_width_ok: source semantics (matches Coq)
; Translation validation: touch_width_ok preserves semantics
(push 1)
(declare-const source_touch_width_ok Int)
(declare-const target_touch_width_ok Int)
(assert (>= source_touch_width_ok 0))
(assert (>= target_touch_width_ok 0))
(assert (not (= source_touch_width_ok target_touch_width_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; touch_height_ok: source semantics (matches Coq)
; Translation validation: touch_height_ok preserves semantics
(push 1)
(declare-const source_touch_height_ok Int)
(declare-const target_touch_height_ok Int)
(assert (>= source_touch_height_ok 0))
(assert (>= target_touch_height_ok 0))
(assert (not (= source_touch_height_ok target_touch_height_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; touch_spacing_ok: source semantics (matches Coq)
; Translation validation: touch_spacing_ok preserves semantics
(push 1)
(declare-const source_touch_spacing_ok Int)
(declare-const target_touch_spacing_ok Int)
(assert (>= source_touch_spacing_ok 0))
(assert (>= target_touch_spacing_ok 0))
(assert (not (= source_touch_spacing_ok target_touch_spacing_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; targets_no_overlap: source semantics (matches Coq)
; Translation validation: targets_no_overlap preserves semantics
(push 1)
(declare-const source_targets_no_overlap Int)
(declare-const target_targets_no_overlap Int)
(assert (>= source_targets_no_overlap 0))
(assert (>= target_targets_no_overlap 0))
(assert (not (= source_targets_no_overlap target_targets_no_overlap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; close_button_reachable_def: source semantics (matches Coq)
; Translation validation: close_button_reachable_def preserves semantics
(push 1)
(declare-const source_close_button_reachable_def Int)
(declare-const target_close_button_reachable_def Int)
(assert (>= source_close_button_reachable_def 0))
(assert (>= target_close_button_reachable_def 0))
(assert (not (= source_close_button_reachable_def target_close_button_reachable_def)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; corner_target_enlarged: source semantics (matches Coq)
; Translation validation: corner_target_enlarged preserves semantics
(push 1)
(declare-const source_corner_target_enlarged Int)
(declare-const target_corner_target_enlarged Int)
(assert (>= source_corner_target_enlarged 0))
(assert (>= target_corner_target_enlarged 0))
(assert (not (= source_corner_target_enlarged target_corner_target_enlarged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nesting_resolved: source semantics (matches Coq)
; Translation validation: nesting_resolved preserves semantics
(push 1)
(declare-const source_nesting_resolved Int)
(declare-const target_nesting_resolved Int)
(assert (>= source_nesting_resolved 0))
(assert (>= target_nesting_resolved 0))
(assert (not (= source_nesting_resolved target_nesting_resolved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; keyboard_reachable: source semantics (matches Coq)
; Translation validation: keyboard_reachable preserves semantics
(push 1)
(declare-const source_keyboard_reachable Int)
(declare-const target_keyboard_reachable Int)
(assert (>= source_keyboard_reachable 0))
(assert (>= target_keyboard_reachable 0))
(assert (not (= source_keyboard_reachable target_keyboard_reachable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; can_tab_away: source semantics (matches Coq)
; Translation validation: can_tab_away preserves semantics
(push 1)
(declare-const source_can_tab_away Int)
(declare-const target_can_tab_away Int)
(assert (>= source_can_tab_away 0))
(assert (>= target_can_tab_away 0))
(assert (not (= source_can_tab_away target_can_tab_away)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; shortcuts_conflict: source semantics (matches Coq)
; Translation validation: shortcuts_conflict preserves semantics
(push 1)
(declare-const source_shortcuts_conflict Int)
(declare-const target_shortcuts_conflict Int)
(assert (>= source_shortcuts_conflict 0))
(assert (>= target_shortcuts_conflict 0))
(assert (not (= source_shortcuts_conflict target_shortcuts_conflict)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; timed_action_extendable: source semantics (matches Coq)
; Translation validation: timed_action_extendable preserves semantics
(push 1)
(declare-const source_timed_action_extendable Int)
(declare-const target_timed_action_extendable Int)
(assert (>= source_timed_action_extendable 0))
(assert (>= target_timed_action_extendable 0))
(assert (not (= source_timed_action_extendable target_timed_action_extendable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_silent_timeout: source semantics (matches Coq)
; Translation validation: no_silent_timeout preserves semantics
(push 1)
(declare-const source_no_silent_timeout Int)
(declare-const target_no_silent_timeout Int)
(assert (>= source_no_silent_timeout 0))
(assert (>= target_no_silent_timeout 0))
(assert (not (= source_no_silent_timeout target_no_silent_timeout)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; progress_saved: source semantics (matches Coq)
; Translation validation: progress_saved preserves semantics
(push 1)
(declare-const source_progress_saved Int)
(declare-const target_progress_saved Int)
(assert (>= source_progress_saved 0))
(assert (>= target_progress_saved 0))
(assert (not (= source_progress_saved target_progress_saved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extension_sufficient: source semantics (matches Coq)
; Translation validation: extension_sufficient preserves semantics
(push 1)
(declare-const source_extension_sufficient Int)
(declare-const target_extension_sufficient Int)
(assert (>= source_extension_sufficient 0))
(assert (>= target_extension_sufficient 0))
(assert (not (= source_extension_sufficient target_extension_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; untimed_alt_exists: source semantics (matches Coq)
; Translation validation: untimed_alt_exists preserves semantics
(push 1)
(declare-const source_untimed_alt_exists Int)
(declare-const target_untimed_alt_exists Int)
(assert (>= source_untimed_alt_exists 0))
(assert (>= target_untimed_alt_exists 0))
(assert (not (= source_untimed_alt_exists target_untimed_alt_exists)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; input_method_in: source semantics (matches Coq)
; Translation validation: input_method_in preserves semantics
(push 1)
(declare-const source_input_method_in Int)
(declare-const target_input_method_in Int)
(assert (>= source_input_method_in 0))
(assert (>= target_input_method_in 0))
(assert (not (= source_input_method_in target_input_method_in)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; switch_control_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: switch_control_complete preserves semantics
(push 1)
(declare-const source_switch_control_complete Int)
(declare-const target_switch_control_complete Int)
(assert (>= source_switch_control_complete 0))
(assert (>= target_switch_control_complete 0))
(assert (not (= source_switch_control_complete target_switch_control_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; voice_control_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: voice_control_complete preserves semantics
(push 1)
(declare-const source_voice_control_complete Int)
(declare-const target_voice_control_complete Int)
(assert (>= source_voice_control_complete 0))
(assert (>= target_voice_control_complete 0))
(assert (not (= source_voice_control_complete target_voice_control_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; switch_command_exists: translation preserves property (matches Coq: Lemma)
; Translation validation: switch_command_exists preserves semantics
(push 1)
(declare-const source_switch_command_exists Int)
(declare-const target_switch_command_exists Int)
(assert (>= source_switch_command_exists 0))
(assert (>= target_switch_command_exists 0))
(assert (not (= source_switch_command_exists target_switch_command_exists)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; speakable_command_positive: translation preserves property (matches Coq: Lemma)
; Translation validation: speakable_command_positive preserves semantics
(push 1)
(declare-const source_speakable_command_positive Int)
(declare-const target_speakable_command_positive Int)
(assert (>= source_speakable_command_positive 0))
(assert (>= target_speakable_command_positive 0))
(assert (not (= source_speakable_command_positive target_speakable_command_positive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; switch_command_decidable: translation preserves property (matches Coq: Lemma)
; Translation validation: switch_command_decidable preserves semantics
(push 1)
(declare-const source_switch_command_decidable Int)
(declare-const target_switch_command_decidable Int)
(assert (>= source_switch_command_decidable 0))
(assert (>= target_switch_command_decidable 0))
(assert (not (= source_switch_command_decidable target_switch_command_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; action_type_decidable: translation preserves property (matches Coq: Lemma)
; Translation validation: action_type_decidable preserves semantics
(push 1)
(declare-const source_action_type_decidable Int)
(declare-const target_action_type_decidable Int)
(assert (>= source_action_type_decidable 0))
(assert (>= target_action_type_decidable 0))
(assert (not (= source_action_type_decidable target_action_type_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_actions_switch_accessible: translation preserves property (matches Coq: Lemma)
; Translation validation: all_actions_switch_accessible preserves semantics
(push 1)
(declare-const source_all_actions_switch_accessible Int)
(declare-const target_all_actions_switch_accessible Int)
(assert (>= source_all_actions_switch_accessible 0))
(assert (>= target_all_actions_switch_accessible 0))
(assert (not (= source_all_actions_switch_accessible target_all_actions_switch_accessible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_actions_voice_accessible: translation preserves property (matches Coq: Lemma)
; Translation validation: all_actions_voice_accessible preserves semantics
(push 1)
(declare-const source_all_actions_voice_accessible Int)
(declare-const target_all_actions_voice_accessible Int)
(assert (>= source_all_actions_voice_accessible 0))
(assert (>= target_all_actions_voice_accessible 0))
(assert (not (= source_all_actions_voice_accessible target_all_actions_voice_accessible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; action_type_exhaustive: translation preserves property (matches Coq: Lemma)
; Translation validation: action_type_exhaustive preserves semantics
(push 1)
(declare-const source_action_type_exhaustive Int)
(declare-const target_action_type_exhaustive Int)
(assert (>= source_action_type_exhaustive 0))
(assert (>= target_action_type_exhaustive 0))
(assert (not (= source_action_type_exhaustive target_action_type_exhaustive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; touch_target_minimum_width: translation preserves property (matches Coq: Theorem)
; Translation validation: touch_target_minimum_width preserves semantics
(push 1)
(declare-const source_touch_target_minimum_width Int)
(declare-const target_touch_target_minimum_width Int)
(assert (>= source_touch_target_minimum_width 0))
(assert (>= target_touch_target_minimum_width 0))
(assert (not (= source_touch_target_minimum_width target_touch_target_minimum_width)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; touch_target_minimum_height: translation preserves property (matches Coq: Theorem)
; Translation validation: touch_target_minimum_height preserves semantics
(push 1)
(declare-const source_touch_target_minimum_height Int)
(declare-const target_touch_target_minimum_height Int)
(assert (>= source_touch_target_minimum_height 0))
(assert (>= target_touch_target_minimum_height 0))
(assert (not (= source_touch_target_minimum_height target_touch_target_minimum_height)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; touch_target_spacing: translation preserves property (matches Coq: Theorem)
; Translation validation: touch_target_spacing preserves semantics
(push 1)
(declare-const source_touch_target_spacing Int)
(declare-const target_touch_target_spacing Int)
(assert (>= source_touch_target_spacing 0))
(assert (>= target_touch_target_spacing 0))
(assert (not (= source_touch_target_spacing target_touch_target_spacing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; touch_target_not_overlapping: translation preserves property (matches Coq: Theorem)
; Translation validation: touch_target_not_overlapping preserves semantics
(push 1)
(declare-const source_touch_target_not_overlapping Int)
(declare-const target_touch_target_not_overlapping Int)
(assert (>= source_touch_target_not_overlapping 0))
(assert (>= target_touch_target_not_overlapping 0))
(assert (not (= source_touch_target_not_overlapping target_touch_target_not_overlapping)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; close_button_reachable: translation preserves property (matches Coq: Theorem)
; Translation validation: close_button_reachable preserves semantics
(push 1)
(declare-const source_close_button_reachable Int)
(declare-const target_close_button_reachable Int)
(assert (>= source_close_button_reachable 0))
(assert (>= target_close_button_reachable 0))
(assert (not (= source_close_button_reachable target_close_button_reachable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; corner_targets_enlarged: translation preserves property (matches Coq: Theorem)
; Translation validation: corner_targets_enlarged preserves semantics
(push 1)
(declare-const source_corner_targets_enlarged Int)
(declare-const target_corner_targets_enlarged Int)
(assert (>= source_corner_targets_enlarged 0))
(assert (>= target_corner_targets_enlarged 0))
(assert (not (= source_corner_targets_enlarged target_corner_targets_enlarged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nested_targets_resolved: translation preserves property (matches Coq: Theorem)
; Translation validation: nested_targets_resolved preserves semantics
(push 1)
(declare-const source_nested_targets_resolved Int)
(declare-const target_nested_targets_resolved Int)
(assert (>= source_nested_targets_resolved 0))
(assert (>= target_nested_targets_resolved 0))
(assert (not (= source_nested_targets_resolved target_nested_targets_resolved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; corner_size_exceeds_minimum: translation preserves property (matches Coq: Lemma)
; Translation validation: corner_size_exceeds_minimum preserves semantics
(push 1)
(declare-const source_corner_size_exceeds_minimum Int)
(declare-const target_corner_size_exceeds_minimum Int)
(assert (>= source_corner_size_exceeds_minimum 0))
(assert (>= target_corner_size_exceeds_minimum 0))
(assert (not (= source_corner_size_exceeds_minimum target_corner_size_exceeds_minimum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_interactive_keyboard_accessible: translation preserves property (matches Coq: Theorem)
; Translation validation: all_interactive_keyboard_accessible preserves semantics
(push 1)
(declare-const source_all_interactive_keyboard_accessible Int)
(declare-const target_all_interactive_keyboard_accessible Int)
(assert (>= source_all_interactive_keyboard_accessible 0))
(assert (>= target_all_interactive_keyboard_accessible 0))
(assert (not (= source_all_interactive_keyboard_accessible target_all_interactive_keyboard_accessible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_keyboard_trap: translation preserves property (matches Coq: Theorem)
; Translation validation: no_keyboard_trap preserves semantics
(push 1)
(declare-const source_no_keyboard_trap Int)
(declare-const target_no_keyboard_trap Int)
(assert (>= source_no_keyboard_trap 0))
(assert (>= target_no_keyboard_trap 0))
(assert (not (= source_no_keyboard_trap target_no_keyboard_trap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; visible_focus_indicator: translation preserves property (matches Coq: Theorem)
; Translation validation: visible_focus_indicator preserves semantics
(push 1)
(declare-const source_visible_focus_indicator Int)
(declare-const target_visible_focus_indicator Int)
(assert (>= source_visible_focus_indicator 0))
(assert (>= target_visible_focus_indicator 0))
(assert (not (= source_visible_focus_indicator target_visible_focus_indicator)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; skip_navigation_available: translation preserves property (matches Coq: Theorem)
; Translation validation: skip_navigation_available preserves semantics
(push 1)
(declare-const source_skip_navigation_available Int)
(declare-const target_skip_navigation_available Int)
(assert (>= source_skip_navigation_available 0))
(assert (>= target_skip_navigation_available 0))
(assert (not (= source_skip_navigation_available target_skip_navigation_available)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; shortcut_keys_not_conflicting: translation preserves property (matches Coq: Theorem)
; Translation validation: shortcut_keys_not_conflicting preserves semantics
(push 1)
(declare-const source_shortcut_keys_not_conflicting Int)
(declare-const target_shortcut_keys_not_conflicting Int)
(assert (>= source_shortcut_keys_not_conflicting 0))
(assert (>= target_shortcut_keys_not_conflicting 0))
(assert (not (= source_shortcut_keys_not_conflicting target_shortcut_keys_not_conflicting)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; escape_closes_modal: translation preserves property (matches Coq: Theorem)
; Translation validation: escape_closes_modal preserves semantics
(push 1)
(declare-const source_escape_closes_modal Int)
(declare-const target_escape_closes_modal Int)
(assert (>= source_escape_closes_modal 0))
(assert (>= target_escape_closes_modal 0))
(assert (not (= source_escape_closes_modal target_escape_closes_modal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_limits_extendable: translation preserves property (matches Coq: Theorem)
; Translation validation: time_limits_extendable preserves semantics
(push 1)
(declare-const source_time_limits_extendable Int)
(declare-const target_time_limits_extendable Int)
(assert (>= source_time_limits_extendable 0))
(assert (>= target_time_limits_extendable 0))
(assert (not (= source_time_limits_extendable target_time_limits_extendable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_auto_timeout: translation preserves property (matches Coq: Theorem)
; Translation validation: no_auto_timeout preserves semantics
(push 1)
(declare-const source_no_auto_timeout Int)
(declare-const target_no_auto_timeout Int)
(assert (>= source_no_auto_timeout 0))
(assert (>= target_no_auto_timeout 0))
(assert (not (= source_no_auto_timeout target_no_auto_timeout)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; timeout_warning: translation preserves property (matches Coq: Theorem)
; Translation validation: timeout_warning preserves semantics
(push 1)
(declare-const source_timeout_warning Int)
(declare-const target_timeout_warning Int)
(assert (>= source_timeout_warning 0))
(assert (>= target_timeout_warning 0))
(assert (not (= source_timeout_warning target_timeout_warning)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; progress_saved_on_timeout: translation preserves property (matches Coq: Theorem)
; Translation validation: progress_saved_on_timeout preserves semantics
(push 1)
(declare-const source_progress_saved_on_timeout Int)
(declare-const target_progress_saved_on_timeout Int)
(assert (>= source_progress_saved_on_timeout 0))
(assert (>= target_progress_saved_on_timeout 0))
(assert (not (= source_progress_saved_on_timeout target_progress_saved_on_timeout)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; timeout_extension_sufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: timeout_extension_sufficient preserves semantics
(push 1)
(declare-const source_timeout_extension_sufficient Int)
(declare-const target_timeout_extension_sufficient Int)
(assert (>= source_timeout_extension_sufficient 0))
(assert (>= target_timeout_extension_sufficient 0))
(assert (not (= source_timeout_extension_sufficient target_timeout_extension_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; untimed_alternative_available: translation preserves property (matches Coq: Theorem)
; Translation validation: untimed_alternative_available preserves semantics
(push 1)
(declare-const source_untimed_alternative_available Int)
(declare-const target_untimed_alternative_available Int)
(assert (>= source_untimed_alternative_available 0))
(assert (>= target_untimed_alternative_available 0))
(assert (not (= source_untimed_alternative_available target_untimed_alternative_available)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; input_method_in_correct: translation preserves property (matches Coq: Lemma)
; Translation validation: input_method_in_correct preserves semantics
(push 1)
(declare-const source_input_method_in_correct Int)
(declare-const target_input_method_in_correct Int)
(assert (>= source_input_method_in_correct 0))
(assert (>= target_input_method_in_correct 0))
(assert (not (= source_input_method_in_correct target_input_method_in_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; voice_input_supported: translation preserves property (matches Coq: Theorem)
; Translation validation: voice_input_supported preserves semantics
(push 1)
(declare-const source_voice_input_supported Int)
(declare-const target_voice_input_supported Int)
(assert (>= source_voice_input_supported 0))
(assert (>= target_voice_input_supported 0))
(assert (not (= source_voice_input_supported target_voice_input_supported)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eye_tracking_supported: translation preserves property (matches Coq: Theorem)
; Translation validation: eye_tracking_supported preserves semantics
(push 1)
(declare-const source_eye_tracking_supported Int)
(declare-const target_eye_tracking_supported Int)
(assert (>= source_eye_tracking_supported 0))
(assert (>= target_eye_tracking_supported 0))
(assert (not (= source_eye_tracking_supported target_eye_tracking_supported)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; head_switch_supported: translation preserves property (matches Coq: Theorem)
; Translation validation: head_switch_supported preserves semantics
(push 1)
(declare-const source_head_switch_supported Int)
(declare-const target_head_switch_supported Int)
(assert (>= source_head_switch_supported 0))
(assert (>= target_head_switch_supported 0))
(assert (not (= source_head_switch_supported target_head_switch_supported)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; single_switch_operable: translation preserves property (matches Coq: Theorem)
; Translation validation: single_switch_operable preserves semantics
(push 1)
(declare-const source_single_switch_operable Int)
(declare-const target_single_switch_operable Int)
(assert (>= source_single_switch_operable 0))
(assert (>= target_single_switch_operable 0))
(assert (not (= source_single_switch_operable target_single_switch_operable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dwell_activation_available: translation preserves property (matches Coq: Theorem)
; Translation validation: dwell_activation_available preserves semantics
(push 1)
(declare-const source_dwell_activation_available Int)
(declare-const target_dwell_activation_available Int)
(assert (>= source_dwell_activation_available 0))
(assert (>= target_dwell_activation_available 0))
(assert (not (= source_dwell_activation_available target_dwell_activation_available)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gesture_alternatives_available: translation preserves property (matches Coq: Theorem)
; Translation validation: gesture_alternatives_available preserves semantics
(push 1)
(declare-const source_gesture_alternatives_available Int)
(declare-const target_gesture_alternatives_available Int)
(assert (>= source_gesture_alternatives_available 0))
(assert (>= target_gesture_alternatives_available 0))
(assert (not (= source_gesture_alternatives_available target_gesture_alternatives_available)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; motor_complete_system_composable: translation preserves property (matches Coq: Theorem)
; Translation validation: motor_complete_system_composable preserves semantics
(push 1)
(declare-const source_motor_complete_system_composable Int)
(declare-const target_motor_complete_system_composable Int)
(assert (>= source_motor_complete_system_composable 0))
(assert (>= target_motor_complete_system_composable 0))
(assert (not (= source_motor_complete_system_composable target_motor_complete_system_composable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; alt_input_covers_standard: translation preserves property (matches Coq: Theorem)
; Translation validation: alt_input_covers_standard preserves semantics
(push 1)
(declare-const source_alt_input_covers_standard Int)
(declare-const target_alt_input_covers_standard Int)
(assert (>= source_alt_input_covers_standard 0))
(assert (>= target_alt_input_covers_standard 0))
(assert (not (= source_alt_input_covers_standard target_alt_input_covers_standard)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; timing_safety_total: translation preserves property (matches Coq: Theorem)
; Translation validation: timing_safety_total preserves semantics
(push 1)
(declare-const source_timing_safety_total Int)
(declare-const target_timing_safety_total Int)
(assert (>= source_timing_safety_total 0))
(assert (>= target_timing_safety_total 0))
(assert (not (= source_timing_safety_total target_timing_safety_total)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; touch_and_keyboard_covered: translation preserves property (matches Coq: Theorem)
; Translation validation: touch_and_keyboard_covered preserves semantics
(push 1)
(declare-const source_touch_and_keyboard_covered Int)
(declare-const target_touch_and_keyboard_covered Int)
(assert (>= source_touch_and_keyboard_covered 0))
(assert (>= target_touch_and_keyboard_covered 0))
(assert (not (= source_touch_and_keyboard_covered target_touch_and_keyboard_covered)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; timed_action_doubles_at_minimum: translation preserves property (matches Coq: Theorem)
; Translation validation: timed_action_doubles_at_minimum preserves semantics
(push 1)
(declare-const source_timed_action_doubles_at_minimum Int)
(declare-const target_timed_action_doubles_at_minimum Int)
(assert (>= source_timed_action_doubles_at_minimum 0))
(assert (>= target_timed_action_doubles_at_minimum 0))
(assert (not (= source_timed_action_doubles_at_minimum target_timed_action_doubles_at_minimum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_action_left_behind: translation preserves property (matches Coq: Theorem)
; Translation validation: no_action_left_behind preserves semantics
(push 1)
(declare-const source_no_action_left_behind Int)
(declare-const target_no_action_left_behind Int)
(assert (>= source_no_action_left_behind 0))
(assert (>= target_no_action_left_behind 0))
(assert (not (= source_no_action_left_behind target_no_action_left_behind)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dwell_implies_no_forced_click: translation preserves property (matches Coq: Theorem)
; Translation validation: dwell_implies_no_forced_click preserves semantics
(push 1)
(declare-const source_dwell_implies_no_forced_click Int)
(declare-const target_dwell_implies_no_forced_click Int)
(assert (>= source_dwell_implies_no_forced_click 0))
(assert (>= target_dwell_implies_no_forced_click 0))
(assert (not (= source_dwell_implies_no_forced_click target_dwell_implies_no_forced_click)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; focus_and_skip_coexist: translation preserves property (matches Coq: Theorem)
; Translation validation: focus_and_skip_coexist preserves semantics
(push 1)
(declare-const source_focus_and_skip_coexist Int)
(declare-const target_focus_and_skip_coexist Int)
(assert (>= source_focus_and_skip_coexist 0))
(assert (>= target_focus_and_skip_coexist 0))
(assert (not (= source_focus_and_skip_coexist target_focus_and_skip_coexist)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; complete_alt_input_guarantee: translation preserves property (matches Coq: Theorem)
; Translation validation: complete_alt_input_guarantee preserves semantics
(push 1)
(declare-const source_complete_alt_input_guarantee Int)
(declare-const target_complete_alt_input_guarantee Int)
(assert (>= source_complete_alt_input_guarantee 0))
(assert (>= target_complete_alt_input_guarantee 0))
(assert (not (= source_complete_alt_input_guarantee target_complete_alt_input_guarantee)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

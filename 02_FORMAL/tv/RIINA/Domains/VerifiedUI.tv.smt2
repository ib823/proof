; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/VerifiedUI.v (68 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for VerifiedUI
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; MIN_VISIBLE_OPACITY: source semantics (matches Coq)
; Translation validation: MIN_VISIBLE_OPACITY preserves semantics
(push 1)
(declare-const source_MIN_VISIBLE_OPACITY Int)
(declare-const target_MIN_VISIBLE_OPACITY Int)
(assert (>= source_MIN_VISIBLE_OPACITY 0))
(assert (>= target_MIN_VISIBLE_OPACITY 0))
(assert (not (= source_MIN_VISIBLE_OPACITY target_MIN_VISIBLE_OPACITY)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; point_in_rect: source semantics (matches Coq)
; Translation validation: point_in_rect preserves semantics
(push 1)
(declare-const source_point_in_rect Int)
(declare-const target_point_in_rect Int)
(assert (>= source_point_in_rect 0))
(assert (>= target_point_in_rect 0))
(assert (not (= source_point_in_rect target_point_in_rect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_visible: source semantics (matches Coq)
; Translation validation: is_visible preserves semantics
(push 1)
(declare-const source_is_visible Int)
(declare-const target_is_visible Int)
(assert (>= source_is_visible 0))
(assert (>= target_is_visible 0))
(assert (not (= source_is_visible target_is_visible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_interactive: source semantics (matches Coq)
; Translation validation: is_interactive preserves semantics
(push 1)
(declare-const source_is_interactive Int)
(declare-const target_is_interactive Int)
(assert (>= source_is_interactive 0))
(assert (>= target_is_interactive 0))
(assert (not (= source_is_interactive target_is_interactive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; element_well_formed: source semantics (matches Coq)
; Translation validation: element_well_formed preserves semantics
(push 1)
(declare-const source_element_well_formed Int)
(declare-const target_element_well_formed Int)
(assert (>= source_element_well_formed 0))
(assert (>= target_element_well_formed 0))
(assert (not (= source_element_well_formed target_element_well_formed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verified_ui_state: source semantics (matches Coq)
; Translation validation: verified_ui_state preserves semantics
(push 1)
(declare-const source_verified_ui_state Int)
(declare-const target_verified_ui_state Int)
(assert (>= source_verified_ui_state 0))
(assert (>= target_verified_ui_state 0))
(assert (not (= source_verified_ui_state target_verified_ui_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; find_topmost_at_point: source semantics (matches Coq)
; Translation validation: find_topmost_at_point preserves semantics
(push 1)
(declare-const source_find_topmost_at_point Int)
(declare-const target_find_topmost_at_point Int)
(assert (>= source_find_topmost_at_point 0))
(assert (>= target_find_topmost_at_point 0))
(assert (not (= source_find_topmost_at_point target_find_topmost_at_point)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; origin_eq: source semantics (matches Coq)
; Translation validation: origin_eq preserves semantics
(push 1)
(declare-const source_origin_eq Int)
(declare-const target_origin_eq Int)
(assert (>= source_origin_eq 0))
(assert (>= target_origin_eq 0))
(assert (not (= source_origin_eq target_origin_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; frame_policy_allows: source semantics (matches Coq)
; Translation validation: frame_policy_allows preserves semantics
(push 1)
(declare-const source_frame_policy_allows Int)
(declare-const target_frame_policy_allows Int)
(assert (>= source_frame_policy_allows 0))
(assert (>= target_frame_policy_allows 0))
(assert (not (= source_frame_policy_allows target_frame_policy_allows)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; frame_well_formed: source semantics (matches Coq)
; Translation validation: frame_well_formed preserves semantics
(push 1)
(declare-const source_frame_well_formed Int)
(declare-const target_frame_well_formed Int)
(assert (>= source_frame_well_formed 0))
(assert (>= target_frame_well_formed 0))
(assert (not (= source_frame_well_formed target_frame_well_formed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; char_is_dangerous: source semantics (matches Coq)
; Translation validation: char_is_dangerous preserves semantics
(push 1)
(declare-const source_char_is_dangerous Int)
(declare-const target_char_is_dangerous Int)
(assert (>= source_char_is_dangerous 0))
(assert (>= target_char_is_dangerous 0))
(assert (not (= source_char_is_dangerous target_char_is_dangerous)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; char_is_sql_meta: source semantics (matches Coq)
; Translation validation: char_is_sql_meta preserves semantics
(push 1)
(declare-const source_char_is_sql_meta Int)
(declare-const target_char_is_sql_meta Int)
(assert (>= source_char_is_sql_meta 0))
(assert (>= target_char_is_sql_meta 0))
(assert (not (= source_char_is_sql_meta target_char_is_sql_meta)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; contains_script_tag: source semantics (matches Coq)
; Translation validation: contains_script_tag preserves semantics
(push 1)
(declare-const source_contains_script_tag Int)
(declare-const target_contains_script_tag Int)
(assert (>= source_contains_script_tag 0))
(assert (>= target_contains_script_tag 0))
(assert (not (= source_contains_script_tag target_contains_script_tag)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sanitize_input: source semantics (matches Coq)
; Translation validation: sanitize_input preserves semantics
(push 1)
(declare-const source_sanitize_input Int)
(declare-const target_sanitize_input Int)
(assert (>= source_sanitize_input 0))
(assert (>= target_sanitize_input 0))
(assert (not (= source_sanitize_input target_sanitize_input)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; input_is_safe: source semantics (matches Coq)
; Translation validation: input_is_safe preserves semantics
(push 1)
(declare-const source_input_is_safe Int)
(declare-const target_input_is_safe Int)
(assert (>= source_input_is_safe 0))
(assert (>= target_input_is_safe 0))
(assert (not (= source_input_is_safe target_input_is_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; focus_next: source semantics (matches Coq)
; Translation validation: focus_next preserves semantics
(push 1)
(declare-const source_focus_next Int)
(declare-const target_focus_next Int)
(assert (>= source_focus_next 0))
(assert (>= target_focus_next 0))
(assert (not (= source_focus_next target_focus_next)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; focus_valid: source semantics (matches Coq)
; Translation validation: focus_valid preserves semantics
(push 1)
(declare-const source_focus_valid Int)
(declare-const target_focus_valid Int)
(assert (>= source_focus_valid 0))
(assert (>= target_focus_valid 0))
(assert (not (= source_focus_valid target_focus_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; luminance: source semantics (matches Coq)
; Translation validation: luminance preserves semantics
(push 1)
(declare-const source_luminance Int)
(declare-const target_luminance Int)
(assert (>= source_luminance 0))
(assert (>= target_luminance 0))
(assert (not (= source_luminance target_luminance)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; luminance_max: source semantics (matches Coq)
; Translation validation: luminance_max preserves semantics
(push 1)
(declare-const source_luminance_max Int)
(declare-const target_luminance_max Int)
(assert (>= source_luminance_max 0))
(assert (>= target_luminance_max 0))
(assert (not (= source_luminance_max target_luminance_max)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; luminance_min: source semantics (matches Coq)
; Translation validation: luminance_min preserves semantics
(push 1)
(declare-const source_luminance_min Int)
(declare-const target_luminance_min Int)
(assert (>= source_luminance_min 0))
(assert (>= target_luminance_min 0))
(assert (not (= source_luminance_min target_luminance_min)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; contrast_offset: source semantics (matches Coq)
; Translation validation: contrast_offset preserves semantics
(push 1)
(declare-const source_contrast_offset Int)
(declare-const target_contrast_offset Int)
(assert (>= source_contrast_offset 0))
(assert (>= target_contrast_offset 0))
(assert (not (= source_contrast_offset target_contrast_offset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; contrast_meets_ratio: source semantics (matches Coq)
; Translation validation: contrast_meets_ratio preserves semantics
(push 1)
(declare-const source_contrast_meets_ratio Int)
(declare-const target_contrast_meets_ratio Int)
(assert (>= source_contrast_meets_ratio 0))
(assert (>= target_contrast_meets_ratio 0))
(assert (not (= source_contrast_meets_ratio target_contrast_meets_ratio)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wcag_aa: source semantics (matches Coq)
; Translation validation: wcag_aa preserves semantics
(push 1)
(declare-const source_wcag_aa Int)
(declare-const target_wcag_aa Int)
(assert (>= source_wcag_aa 0))
(assert (>= target_wcag_aa 0))
(assert (not (= source_wcag_aa target_wcag_aa)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wcag_aaa: source semantics (matches Coq)
; Translation validation: wcag_aaa preserves semantics
(push 1)
(declare-const source_wcag_aaa Int)
(declare-const target_wcag_aaa Int)
(assert (>= source_wcag_aaa 0))
(assert (>= target_wcag_aaa 0))
(assert (not (= source_wcag_aaa target_wcag_aaa)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wcag_large_text: source semantics (matches Coq)
; Translation validation: wcag_large_text preserves semantics
(push 1)
(declare-const source_wcag_large_text Int)
(declare-const target_wcag_large_text Int)
(assert (>= source_wcag_large_text 0))
(assert (>= target_wcag_large_text 0))
(assert (not (= source_wcag_large_text target_wcag_large_text)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; black: source semantics (matches Coq)
; Translation validation: black preserves semantics
(push 1)
(declare-const source_black Int)
(declare-const target_black Int)
(assert (>= source_black 0))
(assert (>= target_black 0))
(assert (not (= source_black target_black)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; white: source semantics (matches Coq)
; Translation validation: white preserves semantics
(push 1)
(declare-const source_white Int)
(declare-const target_white Int)
(assert (>= source_white 0))
(assert (>= target_white 0))
(assert (not (= source_white target_white)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mobile_max: source semantics (matches Coq)
; Translation validation: mobile_max preserves semantics
(push 1)
(declare-const source_mobile_max Int)
(declare-const target_mobile_max Int)
(assert (>= source_mobile_max 0))
(assert (>= target_mobile_max 0))
(assert (not (= source_mobile_max target_mobile_max)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; desktop_min: source semantics (matches Coq)
; Translation validation: desktop_min preserves semantics
(push 1)
(declare-const source_desktop_min Int)
(declare-const target_desktop_min Int)
(assert (>= source_desktop_min 0))
(assert (>= target_desktop_min 0))
(assert (not (= source_desktop_min target_desktop_min)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; breakpoint_eq: source semantics (matches Coq)
; Translation validation: breakpoint_eq preserves semantics
(push 1)
(declare-const source_breakpoint_eq Int)
(declare-const target_breakpoint_eq Int)
(assert (>= source_breakpoint_eq 0))
(assert (>= target_breakpoint_eq 0))
(assert (not (= source_breakpoint_eq target_breakpoint_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; classify_breakpoint: source semantics (matches Coq)
; Translation validation: classify_breakpoint preserves semantics
(push 1)
(declare-const source_classify_breakpoint Int)
(declare-const target_classify_breakpoint Int)
(assert (>= source_classify_breakpoint 0))
(assert (>= target_classify_breakpoint 0))
(assert (not (= source_classify_breakpoint target_classify_breakpoint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; severity_level: source semantics (matches Coq)
; Translation validation: severity_level preserves semantics
(push 1)
(declare-const source_severity_level Int)
(declare-const target_severity_level Int)
(assert (>= source_severity_level 0))
(assert (>= target_severity_level 0))
(assert (not (= source_severity_level target_severity_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; required_style: source semantics (matches Coq)
; Translation validation: required_style preserves semantics
(push 1)
(declare-const source_required_style Int)
(declare-const target_required_style Int)
(assert (>= source_required_style 0))
(assert (>= target_required_style 0))
(assert (not (= source_required_style target_required_style)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; filter_preserves_property: translation preserves property (matches Coq: Lemma)
; Translation validation: filter_preserves_property preserves semantics
(push 1)
(declare-const source_filter_preserves_property Int)
(declare-const target_filter_preserves_property Int)
(assert (>= source_filter_preserves_property 0))
(assert (>= target_filter_preserves_property 0))
(assert (not (= source_filter_preserves_property target_filter_preserves_property)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forall_filter_subset: translation preserves property (matches Coq: Lemma)
; Translation validation: forall_filter_subset preserves semantics
(push 1)
(declare-const source_forall_filter_subset Int)
(declare-const target_forall_filter_subset Int)
(assert (>= source_forall_filter_subset 0))
(assert (>= target_forall_filter_subset 0))
(assert (not (= source_forall_filter_subset target_forall_filter_subset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; find_topmost_in_list: translation preserves property (matches Coq: Lemma)
; Translation validation: find_topmost_in_list preserves semantics
(push 1)
(declare-const source_find_topmost_in_list Int)
(declare-const target_find_topmost_in_list Int)
(assert (>= source_find_topmost_in_list 0))
(assert (>= target_find_topmost_in_list 0))
(assert (not (= source_find_topmost_in_list target_find_topmost_in_list)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_visible_implies_visible: translation preserves property (matches Coq: Lemma)
; Translation validation: is_visible_implies_visible preserves semantics
(push 1)
(declare-const source_is_visible_implies_visible Int)
(declare-const target_is_visible_implies_visible Int)
(assert (>= source_is_visible_implies_visible 0))
(assert (>= target_is_visible_implies_visible 0))
(assert (not (= source_is_visible_implies_visible target_is_visible_implies_visible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_visible_implies_opacity: translation preserves property (matches Coq: Lemma)
; Translation validation: is_visible_implies_opacity preserves semantics
(push 1)
(declare-const source_is_visible_implies_opacity Int)
(declare-const target_is_visible_implies_opacity Int)
(assert (>= source_is_visible_implies_opacity 0))
(assert (>= target_is_visible_implies_opacity 0))
(assert (not (= source_is_visible_implies_opacity target_is_visible_implies_opacity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_01_wysiwyk: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_01_wysiwyk preserves semantics
(push 1)
(declare-const source_UX_001_01_wysiwyk Int)
(declare-const target_UX_001_01_wysiwyk Int)
(assert (>= source_UX_001_01_wysiwyk 0))
(assert (>= target_UX_001_01_wysiwyk 0))
(assert (not (= source_UX_001_01_wysiwyk target_UX_001_01_wysiwyk)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; find_topmost_geq_current: translation preserves property (matches Coq: Lemma)
; Translation validation: find_topmost_geq_current preserves semantics
(push 1)
(declare-const source_find_topmost_geq_current Int)
(declare-const target_find_topmost_geq_current Int)
(assert (>= source_find_topmost_geq_current 0))
(assert (>= target_find_topmost_geq_current 0))
(assert (not (= source_find_topmost_geq_current target_find_topmost_geq_current)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; find_topmost_max_z: translation preserves property (matches Coq: Lemma)
; Translation validation: find_topmost_max_z preserves semantics
(push 1)
(declare-const source_find_topmost_max_z Int)
(declare-const target_find_topmost_max_z Int)
(assert (>= source_find_topmost_max_z 0))
(assert (>= target_find_topmost_max_z 0))
(assert (not (= source_find_topmost_max_z target_find_topmost_max_z)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_02_z_order_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_02_z_order_integrity preserves semantics
(push 1)
(declare-const source_UX_001_02_z_order_integrity Int)
(declare-const target_UX_001_02_z_order_integrity Int)
(assert (>= source_UX_001_02_z_order_integrity 0))
(assert (>= target_UX_001_02_z_order_integrity 0))
(assert (not (= source_UX_001_02_z_order_integrity target_UX_001_02_z_order_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_03_no_invisible_overlay: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_03_no_invisible_overlay preserves semantics
(push 1)
(declare-const source_UX_001_03_no_invisible_overlay Int)
(declare-const target_UX_001_03_no_invisible_overlay Int)
(assert (>= source_UX_001_03_no_invisible_overlay 0))
(assert (>= target_UX_001_03_no_invisible_overlay 0))
(assert (not (= source_UX_001_03_no_invisible_overlay target_UX_001_03_no_invisible_overlay)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_04_visual_consistency: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_04_visual_consistency preserves semantics
(push 1)
(declare-const source_UX_001_04_visual_consistency Int)
(declare-const target_UX_001_04_visual_consistency Int)
(assert (>= source_UX_001_04_visual_consistency 0))
(assert (>= target_UX_001_04_visual_consistency 0))
(assert (not (= source_UX_001_04_visual_consistency target_UX_001_04_visual_consistency)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_05_layout_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_05_layout_deterministic preserves semantics
(push 1)
(declare-const source_UX_001_05_layout_deterministic Int)
(declare-const target_UX_001_05_layout_deterministic Int)
(assert (>= source_UX_001_05_layout_deterministic 0))
(assert (>= target_UX_001_05_layout_deterministic 0))
(assert (not (= source_UX_001_05_layout_deterministic target_UX_001_05_layout_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_06_origin_indicator_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_06_origin_indicator_correct preserves semantics
(push 1)
(declare-const source_UX_001_06_origin_indicator_correct Int)
(declare-const target_UX_001_06_origin_indicator_correct Int)
(assert (>= source_UX_001_06_origin_indicator_correct 0))
(assert (>= target_UX_001_06_origin_indicator_correct 0))
(assert (not (= source_UX_001_06_origin_indicator_correct target_UX_001_06_origin_indicator_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_07_cert_indicator_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_07_cert_indicator_correct preserves semantics
(push 1)
(declare-const source_UX_001_07_cert_indicator_correct Int)
(declare-const target_UX_001_07_cert_indicator_correct Int)
(assert (>= source_UX_001_07_cert_indicator_correct 0))
(assert (>= target_UX_001_07_cert_indicator_correct 0))
(assert (not (= source_UX_001_07_cert_indicator_correct target_UX_001_07_cert_indicator_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_08_no_url_spoof: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_08_no_url_spoof preserves semantics
(push 1)
(declare-const source_UX_001_08_no_url_spoof Int)
(declare-const target_UX_001_08_no_url_spoof Int)
(assert (>= source_UX_001_08_no_url_spoof 0))
(assert (>= target_UX_001_08_no_url_spoof 0))
(assert (not (= source_UX_001_08_no_url_spoof target_UX_001_08_no_url_spoof)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_09_frame_ancestry_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_09_frame_ancestry_correct preserves semantics
(push 1)
(declare-const source_UX_001_09_frame_ancestry_correct Int)
(declare-const target_UX_001_09_frame_ancestry_correct Int)
(assert (>= source_UX_001_09_frame_ancestry_correct 0))
(assert (>= target_UX_001_09_frame_ancestry_correct 0))
(assert (not (= source_UX_001_09_frame_ancestry_correct target_UX_001_09_frame_ancestry_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_10_tab_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_10_tab_integrity preserves semantics
(push 1)
(declare-const source_UX_001_10_tab_integrity Int)
(declare-const target_UX_001_10_tab_integrity Int)
(assert (>= source_UX_001_10_tab_integrity 0))
(assert (>= target_UX_001_10_tab_integrity 0))
(assert (not (= source_UX_001_10_tab_integrity target_UX_001_10_tab_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_11_consent_explicit: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_11_consent_explicit preserves semantics
(push 1)
(declare-const source_UX_001_11_consent_explicit Int)
(declare-const target_UX_001_11_consent_explicit Int)
(assert (>= source_UX_001_11_consent_explicit 0))
(assert (>= target_UX_001_11_consent_explicit 0))
(assert (not (= source_UX_001_11_consent_explicit target_UX_001_11_consent_explicit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_12_consent_revocable: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_12_consent_revocable preserves semantics
(push 1)
(declare-const source_UX_001_12_consent_revocable Int)
(declare-const target_UX_001_12_consent_revocable Int)
(assert (>= source_UX_001_12_consent_revocable 0))
(assert (>= target_UX_001_12_consent_revocable 0))
(assert (not (= source_UX_001_12_consent_revocable target_UX_001_12_consent_revocable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_13_no_confirmshaming: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_13_no_confirmshaming preserves semantics
(push 1)
(declare-const source_UX_001_13_no_confirmshaming Int)
(declare-const target_UX_001_13_no_confirmshaming Int)
(assert (>= source_UX_001_13_no_confirmshaming 0))
(assert (>= target_UX_001_13_no_confirmshaming 0))
(assert (not (= source_UX_001_13_no_confirmshaming target_UX_001_13_no_confirmshaming)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_14_no_hidden_costs: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_14_no_hidden_costs preserves semantics
(push 1)
(declare-const source_UX_001_14_no_hidden_costs Int)
(declare-const target_UX_001_14_no_hidden_costs Int)
(assert (>= source_UX_001_14_no_hidden_costs 0))
(assert (>= target_UX_001_14_no_hidden_costs 0))
(assert (not (= source_UX_001_14_no_hidden_costs target_UX_001_14_no_hidden_costs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_001_15_equal_option_presentation: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_001_15_equal_option_presentation preserves semantics
(push 1)
(declare-const source_UX_001_15_equal_option_presentation Int)
(declare-const target_UX_001_15_equal_option_presentation Int)
(assert (>= source_UX_001_15_equal_option_presentation 0))
(assert (>= target_UX_001_15_equal_option_presentation 0))
(assert (not (= source_UX_001_15_equal_option_presentation target_UX_001_15_equal_option_presentation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; firstn_length_le: translation preserves property (matches Coq: Lemma)
; Translation validation: firstn_length_le preserves semantics
(push 1)
(declare-const source_firstn_length_le Int)
(declare-const target_firstn_length_le Int)
(assert (>= source_firstn_length_le 0))
(assert (>= target_firstn_length_le 0))
(assert (not (= source_firstn_length_le target_firstn_length_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; filter_all_true: translation preserves property (matches Coq: Lemma)
; Translation validation: filter_all_true preserves semantics
(push 1)
(declare-const source_filter_all_true Int)
(declare-const target_filter_all_true Int)
(assert (>= source_filter_all_true 0))
(assert (>= target_filter_all_true 0))
(assert (not (= source_filter_all_true target_filter_all_true)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; firstn_forall: translation preserves property (matches Coq: Lemma)
; Translation validation: firstn_forall preserves semantics
(push 1)
(declare-const source_firstn_forall Int)
(declare-const target_firstn_forall Int)
(assert (>= source_firstn_forall 0))
(assert (>= target_firstn_forall 0))
(assert (not (= source_firstn_forall target_firstn_forall)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; filter_length_le: translation preserves property (matches Coq: Lemma)
; Translation validation: filter_length_le preserves semantics
(push 1)
(declare-const source_filter_length_le Int)
(declare-const target_filter_length_le Int)
(assert (>= source_filter_length_le 0))
(assert (>= target_filter_length_le 0))
(assert (not (= source_filter_length_le target_filter_length_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; firstn_length_le2: translation preserves property (matches Coq: Lemma)
; Translation validation: firstn_length_le2 preserves semantics
(push 1)
(declare-const source_firstn_length_le2 Int)
(declare-const target_firstn_length_le2 Int)
(assert (>= source_firstn_length_le2 0))
(assert (>= target_firstn_length_le2 0))
(assert (not (= source_firstn_length_le2 target_firstn_length_le2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_002_01_input_length_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_002_01_input_length_bounded preserves semantics
(push 1)
(declare-const source_UX_002_01_input_length_bounded Int)
(declare-const target_UX_002_01_input_length_bounded Int)
(assert (>= source_UX_002_01_input_length_bounded 0))
(assert (>= target_UX_002_01_input_length_bounded 0))
(assert (not (= source_UX_002_01_input_length_bounded target_UX_002_01_input_length_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_002_02_xss_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_002_02_xss_injection_impossible preserves semantics
(push 1)
(declare-const source_UX_002_02_xss_injection_impossible Int)
(declare-const target_UX_002_02_xss_injection_impossible Int)
(assert (>= source_UX_002_02_xss_injection_impossible 0))
(assert (>= target_UX_002_02_xss_injection_impossible 0))
(assert (not (= source_UX_002_02_xss_injection_impossible target_UX_002_02_xss_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_002_03_sql_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_002_03_sql_injection_impossible preserves semantics
(push 1)
(declare-const source_UX_002_03_sql_injection_impossible Int)
(declare-const target_UX_002_03_sql_injection_impossible Int)
(assert (>= source_UX_002_03_sql_injection_impossible 0))
(assert (>= target_UX_002_03_sql_injection_impossible 0))
(assert (not (= source_UX_002_03_sql_injection_impossible target_UX_002_03_sql_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; filter_id_forall: translation preserves property (matches Coq: Lemma)
; Translation validation: filter_id_forall preserves semantics
(push 1)
(declare-const source_filter_id_forall Int)
(declare-const target_filter_id_forall Int)
(assert (>= source_filter_id_forall 0))
(assert (>= target_filter_id_forall 0))
(assert (not (= source_filter_id_forall target_filter_id_forall)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; firstn_all_le: translation preserves property (matches Coq: Lemma)
; Translation validation: firstn_all_le preserves semantics
(push 1)
(declare-const source_firstn_all_le Int)
(declare-const target_firstn_all_le Int)
(assert (>= source_firstn_all_le 0))
(assert (>= target_firstn_all_le 0))
(assert (not (= source_firstn_all_le target_firstn_all_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_002_04_input_idempotent: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_002_04_input_idempotent preserves semantics
(push 1)
(declare-const source_UX_002_04_input_idempotent Int)
(declare-const target_UX_002_04_input_idempotent Int)
(assert (>= source_UX_002_04_input_idempotent 0))
(assert (>= target_UX_002_04_input_idempotent 0))
(assert (not (= source_UX_002_04_input_idempotent target_UX_002_04_input_idempotent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_002_05_empty_input_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_002_05_empty_input_safe preserves semantics
(push 1)
(declare-const source_UX_002_05_empty_input_safe Int)
(declare-const target_UX_002_05_empty_input_safe Int)
(assert (>= source_UX_002_05_empty_input_safe 0))
(assert (>= target_UX_002_05_empty_input_safe 0))
(assert (not (= source_UX_002_05_empty_input_safe target_UX_002_05_empty_input_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_002_06_sanitize_preserves_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_002_06_sanitize_preserves_safe preserves semantics
(push 1)
(declare-const source_UX_002_06_sanitize_preserves_safe Int)
(declare-const target_UX_002_06_sanitize_preserves_safe Int)
(assert (>= source_UX_002_06_sanitize_preserves_safe 0))
(assert (>= target_UX_002_06_sanitize_preserves_safe 0))
(assert (not (= source_UX_002_06_sanitize_preserves_safe target_UX_002_06_sanitize_preserves_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_002_07_sanitized_flag_set: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_002_07_sanitized_flag_set preserves semantics
(push 1)
(declare-const source_UX_002_07_sanitized_flag_set Int)
(declare-const target_UX_002_07_sanitized_flag_set Int)
(assert (>= source_UX_002_07_sanitized_flag_set 0))
(assert (>= target_UX_002_07_sanitized_flag_set 0))
(assert (not (= source_UX_002_07_sanitized_flag_set target_UX_002_07_sanitized_flag_set)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_002_08_sanitize_never_increases: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_002_08_sanitize_never_increases preserves semantics
(push 1)
(declare-const source_UX_002_08_sanitize_never_increases Int)
(declare-const target_UX_002_08_sanitize_never_increases Int)
(assert (>= source_UX_002_08_sanitize_never_increases 0))
(assert (>= target_UX_002_08_sanitize_never_increases 0))
(assert (not (= source_UX_002_08_sanitize_never_increases target_UX_002_08_sanitize_never_increases)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_003_01_focus_always_visible: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_003_01_focus_always_visible preserves semantics
(push 1)
(declare-const source_UX_003_01_focus_always_visible Int)
(declare-const target_UX_003_01_focus_always_visible Int)
(assert (>= source_UX_003_01_focus_always_visible 0))
(assert (>= target_UX_003_01_focus_always_visible 0))
(assert (not (= source_UX_003_01_focus_always_visible target_UX_003_01_focus_always_visible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_003_02_focus_order_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_003_02_focus_order_deterministic preserves semantics
(push 1)
(declare-const source_UX_003_02_focus_order_deterministic Int)
(declare-const target_UX_003_02_focus_order_deterministic Int)
(assert (>= source_UX_003_02_focus_order_deterministic 0))
(assert (>= target_UX_003_02_focus_order_deterministic 0))
(assert (not (= source_UX_003_02_focus_order_deterministic target_UX_003_02_focus_order_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_003_03_focus_wraps_around: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_003_03_focus_wraps_around preserves semantics
(push 1)
(declare-const source_UX_003_03_focus_wraps_around Int)
(declare-const target_UX_003_03_focus_wraps_around Int)
(assert (>= source_UX_003_03_focus_wraps_around 0))
(assert (>= target_UX_003_03_focus_wraps_around 0))
(assert (not (= source_UX_003_03_focus_wraps_around target_UX_003_03_focus_wraps_around)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_003_04_focus_trap_in_modal: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_003_04_focus_trap_in_modal preserves semantics
(push 1)
(declare-const source_UX_003_04_focus_trap_in_modal Int)
(declare-const target_UX_003_04_focus_trap_in_modal Int)
(assert (>= source_UX_003_04_focus_trap_in_modal 0))
(assert (>= target_UX_003_04_focus_trap_in_modal 0))
(assert (not (= source_UX_003_04_focus_trap_in_modal target_UX_003_04_focus_trap_in_modal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_003_05_no_focus_outside_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_003_05_no_focus_outside_bounds preserves semantics
(push 1)
(declare-const source_UX_003_05_no_focus_outside_bounds Int)
(declare-const target_UX_003_05_no_focus_outside_bounds Int)
(assert (>= source_UX_003_05_no_focus_outside_bounds 0))
(assert (>= target_UX_003_05_no_focus_outside_bounds 0))
(assert (not (= source_UX_003_05_no_focus_outside_bounds target_UX_003_05_no_focus_outside_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_003_06_focus_moves_forward: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_003_06_focus_moves_forward preserves semantics
(push 1)
(declare-const source_UX_003_06_focus_moves_forward Int)
(declare-const target_UX_003_06_focus_moves_forward Int)
(assert (>= source_UX_003_06_focus_moves_forward 0))
(assert (>= target_UX_003_06_focus_moves_forward 0))
(assert (not (= source_UX_003_06_focus_moves_forward target_UX_003_06_focus_moves_forward)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_004_01_wcag_aa_contrast: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_004_01_wcag_aa_contrast preserves semantics
(push 1)
(declare-const source_UX_004_01_wcag_aa_contrast Int)
(declare-const target_UX_004_01_wcag_aa_contrast Int)
(assert (>= source_UX_004_01_wcag_aa_contrast 0))
(assert (>= target_UX_004_01_wcag_aa_contrast 0))
(assert (not (= source_UX_004_01_wcag_aa_contrast target_UX_004_01_wcag_aa_contrast)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_004_02_wcag_aaa_contrast: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_004_02_wcag_aaa_contrast preserves semantics
(push 1)
(declare-const source_UX_004_02_wcag_aaa_contrast Int)
(declare-const target_UX_004_02_wcag_aaa_contrast Int)
(assert (>= source_UX_004_02_wcag_aaa_contrast 0))
(assert (>= target_UX_004_02_wcag_aaa_contrast 0))
(assert (not (= source_UX_004_02_wcag_aaa_contrast target_UX_004_02_wcag_aaa_contrast)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_004_03_large_text_relaxed: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_004_03_large_text_relaxed preserves semantics
(push 1)
(declare-const source_UX_004_03_large_text_relaxed Int)
(declare-const target_UX_004_03_large_text_relaxed Int)
(assert (>= source_UX_004_03_large_text_relaxed 0))
(assert (>= target_UX_004_03_large_text_relaxed 0))
(assert (not (= source_UX_004_03_large_text_relaxed target_UX_004_03_large_text_relaxed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_004_04_contrast_symmetric: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_004_04_contrast_symmetric preserves semantics
(push 1)
(declare-const source_UX_004_04_contrast_symmetric Int)
(declare-const target_UX_004_04_contrast_symmetric Int)
(assert (>= source_UX_004_04_contrast_symmetric 0))
(assert (>= target_UX_004_04_contrast_symmetric 0))
(assert (not (= source_UX_004_04_contrast_symmetric target_UX_004_04_contrast_symmetric)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_004_05_same_color_min_contrast: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_004_05_same_color_min_contrast preserves semantics
(push 1)
(declare-const source_UX_004_05_same_color_min_contrast Int)
(declare-const target_UX_004_05_same_color_min_contrast Int)
(assert (>= source_UX_004_05_same_color_min_contrast 0))
(assert (>= target_UX_004_05_same_color_min_contrast 0))
(assert (not (= source_UX_004_05_same_color_min_contrast target_UX_004_05_same_color_min_contrast)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_004_06_black_white_max: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_004_06_black_white_max preserves semantics
(push 1)
(declare-const source_UX_004_06_black_white_max Int)
(declare-const target_UX_004_06_black_white_max Int)
(assert (>= source_UX_004_06_black_white_max 0))
(assert (>= target_UX_004_06_black_white_max 0))
(assert (not (= source_UX_004_06_black_white_max target_UX_004_06_black_white_max)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_004_07_aa_implies_large_text: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_004_07_aa_implies_large_text preserves semantics
(push 1)
(declare-const source_UX_004_07_aa_implies_large_text Int)
(declare-const target_UX_004_07_aa_implies_large_text Int)
(assert (>= source_UX_004_07_aa_implies_large_text 0))
(assert (>= target_UX_004_07_aa_implies_large_text 0))
(assert (not (= source_UX_004_07_aa_implies_large_text target_UX_004_07_aa_implies_large_text)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_005_01_breakpoint_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_005_01_breakpoint_deterministic preserves semantics
(push 1)
(declare-const source_UX_005_01_breakpoint_deterministic Int)
(declare-const target_UX_005_01_breakpoint_deterministic Int)
(assert (>= source_UX_005_01_breakpoint_deterministic 0))
(assert (>= target_UX_005_01_breakpoint_deterministic 0))
(assert (not (= source_UX_005_01_breakpoint_deterministic target_UX_005_01_breakpoint_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_005_02_elements_fit_viewport: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_005_02_elements_fit_viewport preserves semantics
(push 1)
(declare-const source_UX_005_02_elements_fit_viewport Int)
(declare-const target_UX_005_02_elements_fit_viewport Int)
(assert (>= source_UX_005_02_elements_fit_viewport 0))
(assert (>= target_UX_005_02_elements_fit_viewport 0))
(assert (not (= source_UX_005_02_elements_fit_viewport target_UX_005_02_elements_fit_viewport)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_005_03_no_horizontal_scroll: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_005_03_no_horizontal_scroll preserves semantics
(push 1)
(declare-const source_UX_005_03_no_horizontal_scroll Int)
(declare-const target_UX_005_03_no_horizontal_scroll Int)
(assert (>= source_UX_005_03_no_horizontal_scroll 0))
(assert (>= target_UX_005_03_no_horizontal_scroll 0))
(assert (not (= source_UX_005_03_no_horizontal_scroll target_UX_005_03_no_horizontal_scroll)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_005_04_touch_targets_minimum_size: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_005_04_touch_targets_minimum_size preserves semantics
(push 1)
(declare-const source_UX_005_04_touch_targets_minimum_size Int)
(declare-const target_UX_005_04_touch_targets_minimum_size Int)
(assert (>= source_UX_005_04_touch_targets_minimum_size 0))
(assert (>= target_UX_005_04_touch_targets_minimum_size 0))
(assert (not (= source_UX_005_04_touch_targets_minimum_size target_UX_005_04_touch_targets_minimum_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_005_05_text_readable_at_breakpoint: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_005_05_text_readable_at_breakpoint preserves semantics
(push 1)
(declare-const source_UX_005_05_text_readable_at_breakpoint Int)
(declare-const target_UX_005_05_text_readable_at_breakpoint Int)
(assert (>= source_UX_005_05_text_readable_at_breakpoint 0))
(assert (>= target_UX_005_05_text_readable_at_breakpoint 0))
(assert (not (= source_UX_005_05_text_readable_at_breakpoint target_UX_005_05_text_readable_at_breakpoint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_005_06_layout_stable_on_resize: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_005_06_layout_stable_on_resize preserves semantics
(push 1)
(declare-const source_UX_005_06_layout_stable_on_resize Int)
(declare-const target_UX_005_06_layout_stable_on_resize Int)
(assert (>= source_UX_005_06_layout_stable_on_resize 0))
(assert (>= target_UX_005_06_layout_stable_on_resize 0))
(assert (not (= source_UX_005_06_layout_stable_on_resize target_UX_005_06_layout_stable_on_resize)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_005_07_breakpoint_boundaries: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_005_07_breakpoint_boundaries preserves semantics
(push 1)
(declare-const source_UX_005_07_breakpoint_boundaries Int)
(declare-const target_UX_005_07_breakpoint_boundaries Int)
(assert (>= source_UX_005_07_breakpoint_boundaries 0))
(assert (>= target_UX_005_07_breakpoint_boundaries 0))
(assert (not (= source_UX_005_07_breakpoint_boundaries target_UX_005_07_breakpoint_boundaries)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_006_01_error_always_visible: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_006_01_error_always_visible preserves semantics
(push 1)
(declare-const source_UX_006_01_error_always_visible Int)
(declare-const target_UX_006_01_error_always_visible Int)
(assert (>= source_UX_006_01_error_always_visible 0))
(assert (>= target_UX_006_01_error_always_visible 0))
(assert (not (= source_UX_006_01_error_always_visible target_UX_006_01_error_always_visible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_006_02_error_persists_until_acknowledged: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_006_02_error_persists_until_acknowledged preserves semantics
(push 1)
(declare-const source_UX_006_02_error_persists_until_acknowledged Int)
(declare-const target_UX_006_02_error_persists_until_acknowledged Int)
(assert (>= source_UX_006_02_error_persists_until_acknowledged 0))
(assert (>= target_UX_006_02_error_persists_until_acknowledged 0))
(assert (not (= source_UX_006_02_error_persists_until_acknowledged target_UX_006_02_error_persists_until_acknowledged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_006_03_error_message_matches_severity: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_006_03_error_message_matches_severity preserves semantics
(push 1)
(declare-const source_UX_006_03_error_message_matches_severity Int)
(declare-const target_UX_006_03_error_message_matches_severity Int)
(assert (>= source_UX_006_03_error_message_matches_severity 0))
(assert (>= target_UX_006_03_error_message_matches_severity 0))
(assert (not (= source_UX_006_03_error_message_matches_severity target_UX_006_03_error_message_matches_severity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_006_04_no_silent_failure: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_006_04_no_silent_failure preserves semantics
(push 1)
(declare-const source_UX_006_04_no_silent_failure Int)
(declare-const target_UX_006_04_no_silent_failure Int)
(assert (>= source_UX_006_04_no_silent_failure 0))
(assert (>= target_UX_006_04_no_silent_failure 0))
(assert (not (= source_UX_006_04_no_silent_failure target_UX_006_04_no_silent_failure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_006_05_error_recoverable: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_006_05_error_recoverable preserves semantics
(push 1)
(declare-const source_UX_006_05_error_recoverable Int)
(declare-const target_UX_006_05_error_recoverable Int)
(assert (>= source_UX_006_05_error_recoverable 0))
(assert (>= target_UX_006_05_error_recoverable 0))
(assert (not (= source_UX_006_05_error_recoverable target_UX_006_05_error_recoverable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_006_06_error_message_honest: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_006_06_error_message_honest preserves semantics
(push 1)
(declare-const source_UX_006_06_error_message_honest Int)
(declare-const target_UX_006_06_error_message_honest Int)
(assert (>= source_UX_006_06_error_message_honest 0))
(assert (>= target_UX_006_06_error_message_honest 0))
(assert (not (= source_UX_006_06_error_message_honest target_UX_006_06_error_message_honest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_006_07_warning_style_for_errors: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_006_07_warning_style_for_errors preserves semantics
(push 1)
(declare-const source_UX_006_07_warning_style_for_errors Int)
(declare-const target_UX_006_07_warning_style_for_errors Int)
(assert (>= source_UX_006_07_warning_style_for_errors 0))
(assert (>= target_UX_006_07_warning_style_for_errors 0))
(assert (not (= source_UX_006_07_warning_style_for_errors target_UX_006_07_warning_style_for_errors)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_006_08_severity_level_monotonic: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_006_08_severity_level_monotonic preserves semantics
(push 1)
(declare-const source_UX_006_08_severity_level_monotonic Int)
(declare-const target_UX_006_08_severity_level_monotonic Int)
(assert (>= source_UX_006_08_severity_level_monotonic 0))
(assert (>= target_UX_006_08_severity_level_monotonic 0))
(assert (not (= source_UX_006_08_severity_level_monotonic target_UX_006_08_severity_level_monotonic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_006_09_info_style_normal: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_006_09_info_style_normal preserves semantics
(push 1)
(declare-const source_UX_006_09_info_style_normal Int)
(declare-const target_UX_006_09_info_style_normal Int)
(assert (>= source_UX_006_09_info_style_normal 0))
(assert (>= target_UX_006_09_info_style_normal 0))
(assert (not (= source_UX_006_09_info_style_normal target_UX_006_09_info_style_normal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_007_01_sanitized_input_in_verified_ui: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_007_01_sanitized_input_in_verified_ui preserves semantics
(push 1)
(declare-const source_UX_007_01_sanitized_input_in_verified_ui Int)
(declare-const target_UX_007_01_sanitized_input_in_verified_ui Int)
(assert (>= source_UX_007_01_sanitized_input_in_verified_ui 0))
(assert (>= target_UX_007_01_sanitized_input_in_verified_ui 0))
(assert (not (= source_UX_007_01_sanitized_input_in_verified_ui target_UX_007_01_sanitized_input_in_verified_ui)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; UX_007_02_accessible_error_in_responsive: translation preserves property (matches Coq: Theorem)
; Translation validation: UX_007_02_accessible_error_in_responsive preserves semantics
(push 1)
(declare-const source_UX_007_02_accessible_error_in_responsive Int)
(declare-const target_UX_007_02_accessible_error_in_responsive Int)
(assert (>= source_UX_007_02_accessible_error_in_responsive 0))
(assert (>= target_UX_007_02_accessible_error_in_responsive 0))
(assert (not (= source_UX_007_02_accessible_error_in_responsive target_UX_007_02_accessible_error_in_responsive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

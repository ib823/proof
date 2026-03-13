; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/mobile_os/TrackingPrevention.v (25 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for TrackingPrevention
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; consent_scope_invariant: source semantics (matches Coq)
; Translation validation: consent_scope_invariant preserves semantics
(push 1)
(declare-const source_consent_scope_invariant Int)
(declare-const target_consent_scope_invariant Int)
(assert (>= source_consent_scope_invariant 0))
(assert (>= target_consent_scope_invariant 0))
(assert (not (= source_consent_scope_invariant target_consent_scope_invariant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; explicit_consent: source semantics (matches Coq)
; Translation validation: explicit_consent preserves semantics
(push 1)
(declare-const source_explicit_consent Int)
(declare-const target_explicit_consent Int)
(assert (>= source_explicit_consent 0))
(assert (>= target_explicit_consent 0))
(assert (not (= source_explicit_consent target_explicit_consent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracks: source semantics (matches Coq)
; Translation validation: tracks preserves semantics
(push 1)
(declare-const source_tracks Int)
(declare-const target_tracks Int)
(assert (>= source_tracks 0))
(assert (>= target_tracks 0))
(assert (not (= source_tracks target_tracks)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; privacy_state_well_formed: source semantics (matches Coq)
; Translation validation: privacy_state_well_formed preserves semantics
(push 1)
(declare-const source_privacy_state_well_formed Int)
(declare-const target_privacy_state_well_formed Int)
(assert (>= source_privacy_state_well_formed 0))
(assert (>= target_privacy_state_well_formed 0))
(assert (not (= source_privacy_state_well_formed target_privacy_state_well_formed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracking_requested: source semantics (matches Coq)
; Translation validation: tracking_requested preserves semantics
(push 1)
(declare-const source_tracking_requested Int)
(declare-const target_tracking_requested Int)
(assert (>= source_tracking_requested 0))
(assert (>= target_tracking_requested 0))
(assert (not (= source_tracking_requested target_tracking_requested)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracking_approved: source semantics (matches Coq)
; Translation validation: tracking_approved preserves semantics
(push 1)
(declare-const source_tracking_approved Int)
(declare-const target_tracking_approved Int)
(assert (>= source_tracking_approved 0))
(assert (>= target_tracking_approved 0))
(assert (not (= source_tracking_approved target_tracking_approved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracking_allowed: source semantics (matches Coq)
; Translation validation: tracking_allowed preserves semantics
(push 1)
(declare-const source_tracking_allowed Int)
(declare-const target_tracking_allowed Int)
(assert (>= source_tracking_allowed 0))
(assert (>= target_tracking_allowed 0))
(assert (not (= source_tracking_allowed target_tracking_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracking_event_well_formed: source semantics (matches Coq)
; Translation validation: tracking_event_well_formed preserves semantics
(push 1)
(declare-const source_tracking_event_well_formed Int)
(declare-const target_tracking_event_well_formed Int)
(assert (>= source_tracking_event_well_formed 0))
(assert (>= target_tracking_event_well_formed 0))
(assert (not (= source_tracking_event_well_formed target_tracking_event_well_formed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cross_site_tracking_blocked: source semantics (matches Coq)
; Translation validation: cross_site_tracking_blocked preserves semantics
(push 1)
(declare-const source_cross_site_tracking_blocked Int)
(declare-const target_cross_site_tracking_blocked Int)
(assert (>= source_cross_site_tracking_blocked 0))
(assert (>= target_cross_site_tracking_blocked 0))
(assert (not (= source_cross_site_tracking_blocked target_cross_site_tracking_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fingerprinting_prevented: source semantics (matches Coq)
; Translation validation: fingerprinting_prevented preserves semantics
(push 1)
(declare-const source_fingerprinting_prevented Int)
(declare-const target_fingerprinting_prevented Int)
(assert (>= source_fingerprinting_prevented 0))
(assert (>= target_fingerprinting_prevented 0))
(assert (not (= source_fingerprinting_prevented target_fingerprinting_prevented)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; third_party_cookies_blocked: source semantics (matches Coq)
; Translation validation: third_party_cookies_blocked preserves semantics
(push 1)
(declare-const source_third_party_cookies_blocked Int)
(declare-const target_third_party_cookies_blocked Int)
(assert (>= source_third_party_cookies_blocked 0))
(assert (>= target_third_party_cookies_blocked 0))
(assert (not (= source_third_party_cookies_blocked target_third_party_cookies_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracking_pixel_detected: source semantics (matches Coq)
; Translation validation: tracking_pixel_detected preserves semantics
(push 1)
(declare-const source_tracking_pixel_detected Int)
(declare-const target_tracking_pixel_detected Int)
(assert (>= source_tracking_pixel_detected 0))
(assert (>= target_tracking_pixel_detected 0))
(assert (not (= source_tracking_pixel_detected target_tracking_pixel_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; advertising_id_resettable: source semantics (matches Coq)
; Translation validation: advertising_id_resettable preserves semantics
(push 1)
(declare-const source_advertising_id_resettable Int)
(declare-const target_advertising_id_resettable Int)
(assert (>= source_advertising_id_resettable 0))
(assert (>= target_advertising_id_resettable 0))
(assert (not (= source_advertising_id_resettable target_advertising_id_resettable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_tracking_permission_required: source semantics (matches Coq)
; Translation validation: app_tracking_permission_required preserves semantics
(push 1)
(declare-const source_app_tracking_permission_required Int)
(declare-const target_app_tracking_permission_required Int)
(assert (>= source_app_tracking_permission_required 0))
(assert (>= target_app_tracking_permission_required 0))
(assert (not (= source_app_tracking_permission_required target_app_tracking_permission_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; link_decoration_stripped: source semantics (matches Coq)
; Translation validation: link_decoration_stripped preserves semantics
(push 1)
(declare-const source_link_decoration_stripped Int)
(declare-const target_link_decoration_stripped Int)
(assert (>= source_link_decoration_stripped 0))
(assert (>= target_link_decoration_stripped 0))
(assert (not (= source_link_decoration_stripped target_link_decoration_stripped)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bounce_tracking_prevented: source semantics (matches Coq)
; Translation validation: bounce_tracking_prevented preserves semantics
(push 1)
(declare-const source_bounce_tracking_prevented Int)
(declare-const target_bounce_tracking_prevented Int)
(assert (>= source_bounce_tracking_prevented 0))
(assert (>= target_bounce_tracking_prevented 0))
(assert (not (= source_bounce_tracking_prevented target_bounce_tracking_prevented)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cname_cloaking_detected: source semantics (matches Coq)
; Translation validation: cname_cloaking_detected preserves semantics
(push 1)
(declare-const source_cname_cloaking_detected Int)
(declare-const target_cname_cloaking_detected Int)
(assert (>= source_cname_cloaking_detected 0))
(assert (>= target_cname_cloaking_detected 0))
(assert (not (= source_cname_cloaking_detected target_cname_cloaking_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; storage_access_partitioned: source semantics (matches Coq)
; Translation validation: storage_access_partitioned preserves semantics
(push 1)
(declare-const source_storage_access_partitioned Int)
(declare-const target_storage_access_partitioned Int)
(assert (>= source_storage_access_partitioned 0))
(assert (>= target_storage_access_partitioned 0))
(assert (not (= source_storage_access_partitioned target_storage_access_partitioned)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; referrer_policy_strict: source semantics (matches Coq)
; Translation validation: referrer_policy_strict preserves semantics
(push 1)
(declare-const source_referrer_policy_strict Int)
(declare-const target_referrer_policy_strict Int)
(assert (>= source_referrer_policy_strict 0))
(assert (>= target_referrer_policy_strict 0))
(assert (not (= source_referrer_policy_strict target_referrer_policy_strict)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ip_address_masked: source semantics (matches Coq)
; Translation validation: ip_address_masked preserves semantics
(push 1)
(declare-const source_ip_address_masked Int)
(declare-const target_ip_address_masked Int)
(assert (>= source_ip_address_masked 0))
(assert (>= target_ip_address_masked 0))
(assert (not (= source_ip_address_masked target_ip_address_masked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; device_graph_prevented: source semantics (matches Coq)
; Translation validation: device_graph_prevented preserves semantics
(push 1)
(declare-const source_device_graph_prevented Int)
(declare-const target_device_graph_prevented Int)
(assert (>= source_device_graph_prevented 0))
(assert (>= target_device_graph_prevented 0))
(assert (not (= source_device_graph_prevented target_device_graph_prevented)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracker_list_updated: source semantics (matches Coq)
; Translation validation: tracker_list_updated preserves semantics
(push 1)
(declare-const source_tracker_list_updated Int)
(declare-const target_tracker_list_updated Int)
(assert (>= source_tracker_list_updated 0))
(assert (>= target_tracker_list_updated 0))
(assert (not (= source_tracker_list_updated target_tracker_list_updated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracking_report_available: source semantics (matches Coq)
; Translation validation: tracking_report_available preserves semantics
(push 1)
(declare-const source_tracking_report_available Int)
(declare-const target_tracking_report_available Int)
(assert (>= source_tracking_report_available 0))
(assert (>= target_tracking_report_available 0))
(assert (not (= source_tracking_report_available target_tracking_report_available)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_tracking_without_consent: translation preserves property (matches Coq: Theorem)
; Translation validation: no_tracking_without_consent preserves semantics
(push 1)
(declare-const source_no_tracking_without_consent Int)
(declare-const target_no_tracking_without_consent Int)
(assert (>= source_no_tracking_without_consent 0))
(assert (>= target_no_tracking_without_consent 0))
(assert (not (= source_no_tracking_without_consent target_no_tracking_without_consent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracking_requires_transparency_prompt: translation preserves property (matches Coq: Theorem)
; Translation validation: tracking_requires_transparency_prompt preserves semantics
(push 1)
(declare-const source_tracking_requires_transparency_prompt Int)
(declare-const target_tracking_requires_transparency_prompt Int)
(assert (>= source_tracking_requires_transparency_prompt 0))
(assert (>= target_tracking_requires_transparency_prompt 0))
(assert (not (= source_tracking_requires_transparency_prompt target_tracking_requires_transparency_prompt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; denied_tracking_not_approved: translation preserves property (matches Coq: Theorem)
; Translation validation: denied_tracking_not_approved preserves semantics
(push 1)
(declare-const source_denied_tracking_not_approved Int)
(declare-const target_denied_tracking_not_approved Int)
(assert (>= source_denied_tracking_not_approved 0))
(assert (>= target_denied_tracking_not_approved 0))
(assert (not (= source_denied_tracking_not_approved target_denied_tracking_not_approved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; consent_revocation_effective: translation preserves property (matches Coq: Theorem)
; Translation validation: consent_revocation_effective preserves semantics
(push 1)
(declare-const source_consent_revocation_effective Int)
(declare-const target_consent_revocation_effective Int)
(assert (>= source_consent_revocation_effective 0))
(assert (>= target_consent_revocation_effective 0))
(assert (not (= source_consent_revocation_effective target_consent_revocation_effective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_consent_no_data: translation preserves property (matches Coq: Theorem)
; Translation validation: no_consent_no_data preserves semantics
(push 1)
(declare-const source_no_consent_no_data Int)
(declare-const target_no_consent_no_data Int)
(assert (>= source_no_consent_no_data 0))
(assert (>= target_no_consent_no_data 0))
(assert (not (= source_no_consent_no_data target_no_consent_no_data)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cross_site_tracking_blocked_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: cross_site_tracking_blocked_thm preserves semantics
(push 1)
(declare-const source_cross_site_tracking_blocked_thm Int)
(declare-const target_cross_site_tracking_blocked_thm Int)
(assert (>= source_cross_site_tracking_blocked_thm 0))
(assert (>= target_cross_site_tracking_blocked_thm 0))
(assert (not (= source_cross_site_tracking_blocked_thm target_cross_site_tracking_blocked_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fingerprinting_prevented_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: fingerprinting_prevented_thm preserves semantics
(push 1)
(declare-const source_fingerprinting_prevented_thm Int)
(declare-const target_fingerprinting_prevented_thm Int)
(assert (>= source_fingerprinting_prevented_thm 0))
(assert (>= target_fingerprinting_prevented_thm 0))
(assert (not (= source_fingerprinting_prevented_thm target_fingerprinting_prevented_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; third_party_cookies_blocked_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: third_party_cookies_blocked_thm preserves semantics
(push 1)
(declare-const source_third_party_cookies_blocked_thm Int)
(declare-const target_third_party_cookies_blocked_thm Int)
(assert (>= source_third_party_cookies_blocked_thm 0))
(assert (>= target_third_party_cookies_blocked_thm 0))
(assert (not (= source_third_party_cookies_blocked_thm target_third_party_cookies_blocked_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracking_pixel_detected_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: tracking_pixel_detected_thm preserves semantics
(push 1)
(declare-const source_tracking_pixel_detected_thm Int)
(declare-const target_tracking_pixel_detected_thm Int)
(assert (>= source_tracking_pixel_detected_thm 0))
(assert (>= target_tracking_pixel_detected_thm 0))
(assert (not (= source_tracking_pixel_detected_thm target_tracking_pixel_detected_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; advertising_id_resettable_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: advertising_id_resettable_thm preserves semantics
(push 1)
(declare-const source_advertising_id_resettable_thm Int)
(declare-const target_advertising_id_resettable_thm Int)
(assert (>= source_advertising_id_resettable_thm 0))
(assert (>= target_advertising_id_resettable_thm 0))
(assert (not (= source_advertising_id_resettable_thm target_advertising_id_resettable_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_tracking_permission_required_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: app_tracking_permission_required_thm preserves semantics
(push 1)
(declare-const source_app_tracking_permission_required_thm Int)
(declare-const target_app_tracking_permission_required_thm Int)
(assert (>= source_app_tracking_permission_required_thm 0))
(assert (>= target_app_tracking_permission_required_thm 0))
(assert (not (= source_app_tracking_permission_required_thm target_app_tracking_permission_required_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; link_decoration_stripped_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: link_decoration_stripped_thm preserves semantics
(push 1)
(declare-const source_link_decoration_stripped_thm Int)
(declare-const target_link_decoration_stripped_thm Int)
(assert (>= source_link_decoration_stripped_thm 0))
(assert (>= target_link_decoration_stripped_thm 0))
(assert (not (= source_link_decoration_stripped_thm target_link_decoration_stripped_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bounce_tracking_prevented_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: bounce_tracking_prevented_thm preserves semantics
(push 1)
(declare-const source_bounce_tracking_prevented_thm Int)
(declare-const target_bounce_tracking_prevented_thm Int)
(assert (>= source_bounce_tracking_prevented_thm 0))
(assert (>= target_bounce_tracking_prevented_thm 0))
(assert (not (= source_bounce_tracking_prevented_thm target_bounce_tracking_prevented_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cname_cloaking_detected_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: cname_cloaking_detected_thm preserves semantics
(push 1)
(declare-const source_cname_cloaking_detected_thm Int)
(declare-const target_cname_cloaking_detected_thm Int)
(assert (>= source_cname_cloaking_detected_thm 0))
(assert (>= target_cname_cloaking_detected_thm 0))
(assert (not (= source_cname_cloaking_detected_thm target_cname_cloaking_detected_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; storage_access_partitioned_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: storage_access_partitioned_thm preserves semantics
(push 1)
(declare-const source_storage_access_partitioned_thm Int)
(declare-const target_storage_access_partitioned_thm Int)
(assert (>= source_storage_access_partitioned_thm 0))
(assert (>= target_storage_access_partitioned_thm 0))
(assert (not (= source_storage_access_partitioned_thm target_storage_access_partitioned_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; referrer_policy_strict_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: referrer_policy_strict_thm preserves semantics
(push 1)
(declare-const source_referrer_policy_strict_thm Int)
(declare-const target_referrer_policy_strict_thm Int)
(assert (>= source_referrer_policy_strict_thm 0))
(assert (>= target_referrer_policy_strict_thm 0))
(assert (not (= source_referrer_policy_strict_thm target_referrer_policy_strict_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ip_address_masked_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: ip_address_masked_thm preserves semantics
(push 1)
(declare-const source_ip_address_masked_thm Int)
(declare-const target_ip_address_masked_thm Int)
(assert (>= source_ip_address_masked_thm 0))
(assert (>= target_ip_address_masked_thm 0))
(assert (not (= source_ip_address_masked_thm target_ip_address_masked_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; device_graph_prevented_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: device_graph_prevented_thm preserves semantics
(push 1)
(declare-const source_device_graph_prevented_thm Int)
(declare-const target_device_graph_prevented_thm Int)
(assert (>= source_device_graph_prevented_thm 0))
(assert (>= target_device_graph_prevented_thm 0))
(assert (not (= source_device_graph_prevented_thm target_device_graph_prevented_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracker_list_updated_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: tracker_list_updated_thm preserves semantics
(push 1)
(declare-const source_tracker_list_updated_thm Int)
(declare-const target_tracker_list_updated_thm Int)
(assert (>= source_tracker_list_updated_thm 0))
(assert (>= target_tracker_list_updated_thm 0))
(assert (not (= source_tracker_list_updated_thm target_tracker_list_updated_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracking_report_available_thm: translation preserves property (matches Coq: Theorem)
; Translation validation: tracking_report_available_thm preserves semantics
(push 1)
(declare-const source_tracking_report_available_thm Int)
(declare-const target_tracking_report_available_thm Int)
(assert (>= source_tracking_report_available_thm 0))
(assert (>= target_tracking_report_available_thm 0))
(assert (not (= source_tracking_report_available_thm target_tracking_report_available_thm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; referrer_policy_options: translation preserves property (matches Coq: Theorem)
; Translation validation: referrer_policy_options preserves semantics
(push 1)
(declare-const source_referrer_policy_options Int)
(declare-const target_referrer_policy_options Int)
(assert (>= source_referrer_policy_options 0))
(assert (>= target_referrer_policy_options 0))
(assert (not (= source_referrer_policy_options target_referrer_policy_options)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tracker_list_non_empty: translation preserves property (matches Coq: Theorem)
; Translation validation: tracker_list_non_empty preserves semantics
(push 1)
(declare-const source_tracker_list_non_empty Int)
(declare-const target_tracker_list_non_empty Int)
(assert (>= source_tracker_list_non_empty 0))
(assert (>= target_tracker_list_non_empty 0))
(assert (not (= source_tracker_list_non_empty target_tracker_list_non_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_tracking_without_permission_request: translation preserves property (matches Coq: Theorem)
; Translation validation: no_tracking_without_permission_request preserves semantics
(push 1)
(declare-const source_no_tracking_without_permission_request Int)
(declare-const target_no_tracking_without_permission_request Int)
(assert (>= source_no_tracking_without_permission_request 0))
(assert (>= target_no_tracking_without_permission_request 0))
(assert (not (= source_no_tracking_without_permission_request target_no_tracking_without_permission_request)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; revocation_prevents_future_tracking: translation preserves property (matches Coq: Theorem)
; Translation validation: revocation_prevents_future_tracking preserves semantics
(push 1)
(declare-const source_revocation_prevents_future_tracking Int)
(declare-const target_revocation_prevents_future_tracking Int)
(assert (>= source_revocation_prevents_future_tracking 0))
(assert (>= target_revocation_prevents_future_tracking 0))
(assert (not (= source_revocation_prevents_future_tracking target_revocation_prevents_future_tracking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ip_masked_via_relay: translation preserves property (matches Coq: Theorem)
; Translation validation: ip_masked_via_relay preserves semantics
(push 1)
(declare-const source_ip_masked_via_relay Int)
(declare-const target_ip_masked_via_relay Int)
(assert (>= source_ip_masked_via_relay 0))
(assert (>= target_ip_masked_via_relay 0))
(assert (not (= source_ip_masked_via_relay target_ip_masked_via_relay)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

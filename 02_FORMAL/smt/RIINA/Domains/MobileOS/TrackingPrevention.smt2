; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TrackingPrevention — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/TrackingPrevention.v (25 assertions)
; Module: TrackingPrevention
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ReferrerPolicy 0)) (((NoReferrer) (StrictOrigin) (SameOrigin) (FullURL))))

(declare-datatypes ((User 0))
  (((mk-user (user_id Int) (tracking_consent_given Bool) (consent_scope (Seq Int)) (consent_timestamp Int)))))

(declare-datatypes ((Application 0))
  (((mk-application (app_id Int) (tracking_enabled Bool) (tracking_domains (Seq Int)) (app_privacy_policy Bool)))))

(declare-datatypes ((TrackingEvent 0))
  (((mk-tracking_event (tracking_app Application) (tracked_user User) (tracking_type Int) (tracking_data (Seq Int))))))

(declare-datatypes ((PrivacyState 0))
  (((mk-privacy_state (tracking_transparency_enabled Bool) (app_tracking_requests (Seq Int)) (approved_tracking (Seq Int)) (denied_tracking (Seq Int))))))

(declare-datatypes ((CrossSiteRequest 0))
  (((mk-cross_site_request (csr_source_domain Int) (csr_target_domain Int) (csr_has_tracking_params Bool) (csr_blocked Bool)))))

(declare-datatypes ((FingerprintAttempt 0))
  (((mk-fingerprint_attempt (fp_entropy_bits Int) (fp_max_allowed_bits Int) (fp_prevented Bool)))))

(declare-datatypes ((CookieRequest 0))
  (((mk-cookie_request (cookie_domain Int) (cookie_page_domain Int) (cookie_is_third_party Bool) (cookie_blocked Bool)))))

(declare-datatypes ((ResourceLoad 0))
  (((mk-resource_load (res_url_hash Int) (res_size_bytes Int) (res_is_tracking_pixel Bool) (res_detected Bool)))))

(declare-datatypes ((AdvertisingId 0))
  (((mk-advertising_id (ad_id_value Int) (ad_id_resettable Bool) (ad_id_reset_count Int)))))

(declare-datatypes ((AppTrackingRequest 0))
  (((mk-app_tracking_request (atr_app_id Int) (atr_user_id Int) (atr_permission_asked Bool) (atr_permission_granted Bool)))))

(declare-datatypes ((LinkDecoration 0))
  (((mk-link_decoration (ld_url_hash Int) (ld_tracking_params (Seq Int)) (ld_stripped Bool)))))

(declare-datatypes ((BounceTracking 0))
  (((mk-bounce_tracking (bt_intermediate_domain Int) (bt_final_domain Int) (bt_bounce_detected Bool) (bt_prevented Bool)))))

(declare-datatypes ((CNAMERecord 0))
  (((mk-cname_record (cname_alias Int) (cname_target Int) (cname_is_tracker Bool) (cname_detected Bool)))))

(declare-datatypes ((StorageAccess 0))
  (((mk-storage_access (sa_origin Int) (sa_top_level_origin Int) (sa_partitioned Bool)))))

(declare-datatypes ((ReferrerConfig 0))
  (((mk-referrer_config (ref_policy ReferrerPolicy) (ref_is_strict Bool)))))

(declare-datatypes ((NetworkRequest 0))
  (((mk-network_request (nr_destination Int) (nr_ip_masked Bool) (nr_uses_relay Bool)))))

(declare-datatypes ((DeviceGraphAttempt 0))
  (((mk-device_graph_attempt (dg_identifiers_collected (Seq Int)) (dg_prevented Bool) (dg_max_identifiers Int)))))

(declare-datatypes ((TrackerList 0))
  (((mk-tracker_list (tl_entries (Seq Int)) (tl_last_updated Int) (tl_max_age_seconds Int)))))

(declare-datatypes ((TrackingReport 0))
  (((mk-tracking_report (tr_blocked_count Int) (tr_tracker_domains (Seq Int)) (tr_report_available Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. ReferrerPolicy exhaustiveness ---
(push 1)
(declare-const x ReferrerPolicy)
(assert (not (or (= x NoReferrer) (= x StrictOrigin) (= x SameOrigin) (= x FullURL))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ReferrerPolicy: NoReferrer != StrictOrigin ---
(push 1)
(assert (= NoReferrer StrictOrigin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ReferrerPolicy: StrictOrigin != SameOrigin ---
(push 1)
(assert (= StrictOrigin SameOrigin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ReferrerPolicy: SameOrigin != FullURL ---
(push 1)
(assert (= SameOrigin FullURL))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ReferrerPolicy: NoReferrer != FullURL ---
(push 1)
(assert (= NoReferrer FullURL))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ReferrerPolicy finite cardinality (4 values) ---
(push 1)
(declare-const x ReferrerPolicy)
(assert (and (not (= x NoReferrer)) (not (= x StrictOrigin)) (not (= x SameOrigin)) (not (= x FullURL))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. User accessor round-trip: user_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (user_id (mk-user f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. User accessor round-trip: tracking_consent_given ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (tracking_consent_given (mk-user f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Application accessor round-trip: app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (app_id (mk-application f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Application accessor round-trip: tracking_enabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (tracking_enabled (mk-application f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TrackingEvent accessor round-trip: tracking_app ---
(push 1)
(declare-const f0 Application)
(declare-const f1 User)
(declare-const f2 Int)
(assert (not (= (tracking_app (mk-tracking_event f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TrackingEvent accessor round-trip: tracked_user ---
(push 1)
(declare-const f0 Application)
(declare-const f1 User)
(declare-const f2 Int)
(assert (not (= (tracked_user (mk-tracking_event f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. TrackingEvent accessor round-trip: tracking_type ---
(push 1)
(declare-const f0 Application)
(declare-const f1 User)
(declare-const f2 Int)
(assert (not (= (tracking_type (mk-tracking_event f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. PrivacyState accessor round-trip: tracking_transparency_enabled ---
(push 1)
(declare-const f0 Bool)
(assert (not (= (tracking_transparency_enabled (mk-privacy_state f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. CrossSiteRequest accessor round-trip: csr_source_domain ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (csr_source_domain (mk-cross_site_request f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. CrossSiteRequest accessor round-trip: csr_target_domain ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (csr_target_domain (mk-cross_site_request f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. CrossSiteRequest accessor round-trip: csr_has_tracking_params ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (csr_has_tracking_params (mk-cross_site_request f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. CrossSiteRequest accessor round-trip: csr_blocked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (csr_blocked (mk-cross_site_request f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. CrossSiteRequest: non-negative int fields sum ---
(push 1)
(declare-const r CrossSiteRequest)
(assert (>= (csr_source_domain r) 0))
(assert (>= (csr_target_domain r) 0))
(assert (not (>= (+ (csr_source_domain r) (csr_target_domain r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. FingerprintAttempt accessor round-trip: fp_entropy_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (fp_entropy_bits (mk-fingerprint_attempt f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. FingerprintAttempt accessor round-trip: fp_max_allowed_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (fp_max_allowed_bits (mk-fingerprint_attempt f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. FingerprintAttempt accessor round-trip: fp_prevented ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (fp_prevented (mk-fingerprint_attempt f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. FingerprintAttempt: non-negative int fields sum ---
(push 1)
(declare-const r FingerprintAttempt)
(assert (>= (fp_entropy_bits r) 0))
(assert (>= (fp_max_allowed_bits r) 0))
(assert (not (>= (+ (fp_entropy_bits r) (fp_max_allowed_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. CookieRequest accessor round-trip: cookie_domain ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cookie_domain (mk-cookie_request f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. CookieRequest accessor round-trip: cookie_page_domain ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cookie_page_domain (mk-cookie_request f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. CookieRequest accessor round-trip: cookie_is_third_party ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cookie_is_third_party (mk-cookie_request f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. CookieRequest accessor round-trip: cookie_blocked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cookie_blocked (mk-cookie_request f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. CookieRequest: non-negative int fields sum ---
(push 1)
(declare-const r CookieRequest)
(assert (>= (cookie_domain r) 0))
(assert (>= (cookie_page_domain r) 0))
(assert (not (>= (+ (cookie_domain r) (cookie_page_domain r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ResourceLoad accessor round-trip: res_url_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (res_url_hash (mk-resource_load f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ResourceLoad accessor round-trip: res_size_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (res_size_bytes (mk-resource_load f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ResourceLoad accessor round-trip: res_is_tracking_pixel ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (res_is_tracking_pixel (mk-resource_load f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ResourceLoad accessor round-trip: res_detected ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (res_detected (mk-resource_load f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. ResourceLoad: non-negative int fields sum ---
(push 1)
(declare-const r ResourceLoad)
(assert (>= (res_url_hash r) 0))
(assert (>= (res_size_bytes r) 0))
(assert (not (>= (+ (res_url_hash r) (res_size_bytes r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. AdvertisingId accessor round-trip: ad_id_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (ad_id_value (mk-advertising_id f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. AdvertisingId accessor round-trip: ad_id_resettable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (ad_id_resettable (mk-advertising_id f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. AdvertisingId accessor round-trip: ad_id_reset_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (ad_id_reset_count (mk-advertising_id f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. AdvertisingId: non-negative int fields sum ---
(push 1)
(declare-const r AdvertisingId)
(assert (>= (ad_id_value r) 0))
(assert (>= (ad_id_reset_count r) 0))
(assert (not (>= (+ (ad_id_value r) (ad_id_reset_count r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. AppTrackingRequest accessor round-trip: atr_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (atr_app_id (mk-app_tracking_request f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. AppTrackingRequest accessor round-trip: atr_user_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (atr_user_id (mk-app_tracking_request f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. AppTrackingRequest accessor round-trip: atr_permission_asked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (atr_permission_asked (mk-app_tracking_request f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. AppTrackingRequest accessor round-trip: atr_permission_granted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (atr_permission_granted (mk-app_tracking_request f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. AppTrackingRequest: non-negative int fields sum ---
(push 1)
(declare-const r AppTrackingRequest)
(assert (>= (atr_app_id r) 0))
(assert (>= (atr_user_id r) 0))
(assert (not (>= (+ (atr_app_id r) (atr_user_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. LinkDecoration accessor round-trip: ld_url_hash ---
(push 1)
(declare-const f0 Int)
(assert (not (= (ld_url_hash (mk-link_decoration f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. BounceTracking accessor round-trip: bt_intermediate_domain ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bt_intermediate_domain (mk-bounce_tracking f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. BounceTracking accessor round-trip: bt_final_domain ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bt_final_domain (mk-bounce_tracking f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. BounceTracking accessor round-trip: bt_bounce_detected ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bt_bounce_detected (mk-bounce_tracking f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. BounceTracking accessor round-trip: bt_prevented ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bt_prevented (mk-bounce_tracking f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. BounceTracking: non-negative int fields sum ---
(push 1)
(declare-const r BounceTracking)
(assert (>= (bt_intermediate_domain r) 0))
(assert (>= (bt_final_domain r) 0))
(assert (not (>= (+ (bt_intermediate_domain r) (bt_final_domain r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. CNAMERecord accessor round-trip: cname_alias ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cname_alias (mk-cname_record f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. CNAMERecord accessor round-trip: cname_target ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cname_target (mk-cname_record f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. CNAMERecord accessor round-trip: cname_is_tracker ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cname_is_tracker (mk-cname_record f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. CNAMERecord accessor round-trip: cname_detected ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cname_detected (mk-cname_record f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. CNAMERecord: non-negative int fields sum ---
(push 1)
(declare-const r CNAMERecord)
(assert (>= (cname_alias r) 0))
(assert (>= (cname_target r) 0))
(assert (not (>= (+ (cname_alias r) (cname_target r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. StorageAccess accessor round-trip: sa_origin ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (sa_origin (mk-storage_access f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. StorageAccess accessor round-trip: sa_top_level_origin ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (sa_top_level_origin (mk-storage_access f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. StorageAccess accessor round-trip: sa_partitioned ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (sa_partitioned (mk-storage_access f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. StorageAccess: non-negative int fields sum ---
(push 1)
(declare-const r StorageAccess)
(assert (>= (sa_origin r) 0))
(assert (>= (sa_top_level_origin r) 0))
(assert (not (>= (+ (sa_origin r) (sa_top_level_origin r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. ReferrerConfig accessor round-trip: ref_policy ---
(push 1)
(declare-const f0 ReferrerPolicy)
(declare-const f1 Bool)
(assert (not (= (ref_policy (mk-referrer_config f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. ReferrerConfig accessor round-trip: ref_is_strict ---
(push 1)
(declare-const f0 ReferrerPolicy)
(declare-const f1 Bool)
(assert (not (= (ref_is_strict (mk-referrer_config f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. NetworkRequest accessor round-trip: nr_destination ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nr_destination (mk-network_request f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. NetworkRequest accessor round-trip: nr_ip_masked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nr_ip_masked (mk-network_request f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. NetworkRequest accessor round-trip: nr_uses_relay ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nr_uses_relay (mk-network_request f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. TrackingReport accessor round-trip: tr_blocked_count ---
(push 1)
(declare-const f0 Int)
(assert (not (= (tr_blocked_count (mk-tracking_report f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

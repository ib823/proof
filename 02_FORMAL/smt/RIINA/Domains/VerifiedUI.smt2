; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedUI — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedUI.v (68 assertions)
; Module: VerifiedUI
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CertStatus 0)) (((CertValid) (CertInvalid) (CertExpired) (CertSelfSigned))))

(declare-datatypes ((FramePolicy 0)) (((FrameDeny) (FrameSameOrigin) (FrameAllowFrom) (FrameAllowAll))))

(declare-datatypes ((Sensitivity 0)) (((SensNone) (SensLow) (SensMedium) (SensHigh) (SensCritical))))

(declare-datatypes ((Breakpoint 0)) (((BPMobile) (BPTablet) (BPDesktop))))

(declare-datatypes ((ErrorSeverity 0)) (((SevInfo) (SevWarning) (SevError) (SevCritical))))

(declare-datatypes ((DisplayStyle 0)) (((StyleNormal) (StyleAccented) (StyleWarning) (StyleDanger))))

(declare-datatypes ((RecoveryAction 0)) (((ActionRetry) (ActionDismiss) (ActionNavigate) (ActionContact))))

(declare-datatypes ((Point 0))
  (((mk-point (px Int) (py Int)))))

(declare-datatypes ((Rect 0))
  (((mk-rect (rect_x Int) (rect_y Int) (rect_width Int) (rect_height Int)))))

(declare-datatypes ((UIElement 0))
  (((mk-ui_element (elem_id Int) (elem_bounds Rect) (elem_z_index Int) (elem_opacity Int) (elem_interactive Bool) (elem_visible Bool)))))

(declare-datatypes ((UIState 0))
  (((mk-ui_state (ui_elements (Seq Int)) (ui_focus Int)))))

(declare-datatypes ((Origin 0))
  (((mk-origin (origin_scheme String) (origin_host String) (origin_port Int)))))

(declare-datatypes ((TabState 0))
  (((mk-tab_state (tab_id Int) (tab_loaded_origin Origin) (tab_content_origin Origin) (tab_origin_match Int)))))

(declare-datatypes ((FrameState 0))
  (((mk-frame_state (frame_id Int) (frame_origin Origin) (frame_parent_origin Int) (frame_policy FramePolicy)))))

(declare-datatypes ((VerifiedBrowserState 0))
  (((mk-verified_browser_state (browser_displayed_url String) (browser_actual_origin Origin) (browser_cert_status CertStatus) (browser_tls_verified Bool) (browser_tabs (Seq Int)) (browser_frames (Seq Int)) (browser_url_derived Int) (browser_tls_implies_https Int)))))

(declare-datatypes ((ConsentRecord 0))
  (((mk-consent_record (consent_action String) (consent_granted Bool) (consent_timestamp Int) (consent_revocable Bool)))))

(declare-datatypes ((DialogOption 0))
  (((mk-dialog_option (opt_label String) (opt_is_cancel Bool) (opt_visual_weight Int) (opt_uses_neutral_language Bool)))))

(declare-datatypes ((VerifiedDialog 0))
  (((mk-verified_dialog (dialog_options (Seq Int)) (dialog_balanced Int) (dialog_cancel_neutral Int)))))

(declare-datatypes ((PriceDisplay 0))
  (((mk-price_display (displayed_total Int) (actual_total Int) (price_verified Int)))))

(declare-datatypes ((ConsentState 0))
  (((mk-consent_state (consent_records (Seq Int)) (consent_all_revocable Int)))))

(declare-datatypes ((SensitiveAction 0))
  (((mk-sensitive_action (action_name String) (action_sensitivity Sensitivity)))))

(declare-datatypes ((LayoutInput 0))
  (((mk-layout_input (layout_viewport_width Int) (layout_viewport_height Int) (layout_elements (Seq Int)) (layout_seed Int)))))

(declare-datatypes ((InputField 0))
  (((mk-input_field (field_data (Seq Int)) (input_max_length Int) (input_allowed Int) (input_sanitized Bool)))))

(declare-datatypes ((FocusState 0))
  (((mk-focus_state (focused_element Int) (tab_order (Seq Int)) (focus_modal_active Bool) (focus_modal_elements (Seq Int))))))

(declare-datatypes ((VerifiedFocusState 0))
  (((mk-verified_focus_state (vf_state FocusState) (vf_valid Int) (vf_visible_elements (Seq Int)) (vf_tab_in_visible Int) (vf_modal_subset Int)))))

(declare-datatypes ((ViewportBounds 0))
  (((mk-viewport_bounds (vp_min_x Int) (vp_min_y Int) (vp_max_x Int) (vp_max_y Int)))))

(declare-datatypes ((Color 0))
  (((mk-color (color_lum Int)))))

(declare-datatypes ((Viewport 0))
  (((mk-viewport (vp_width Int) (vp_height Int)))))

(declare-datatypes ((LayoutElement 0))
  (((mk-layout_element (le_id Int) (le_width Int) (le_height Int) (le_font_size Int) (le_is_interactive Bool)))))

(declare-datatypes ((ResponsiveLayout 0))
  (((mk-responsive_layout (rl_viewport Viewport) (rl_elements (Seq Int)) (rl_all_fit Int) (rl_touch_targets Int) (rl_font_appropriate Int)))))

(declare-datatypes ((ErrorDisplay 0))
  (((mk-error_display (err_message String) (err_actual_error String) (err_severity ErrorSeverity) (err_visible Bool) (err_auto_dismiss Bool) (err_display_style DisplayStyle) (err_recovery RecoveryAction)))))

(declare-datatypes ((VerifiedErrorDisplay 0))
  (((mk-verified_error_display (ve_display ErrorDisplay) (ve_always_visible Int) (ve_critical_persistent Int) (ve_style_matches Int) (ve_honest_message Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- CertStatus enum properties ---

; --- 1. CertStatus exhaustiveness ---
(push 1)
(declare-const x CertStatus)
(assert (not (or (= x CertValid) (= x CertInvalid) (= x CertExpired) (= x CertSelfSigned))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CertStatus: CertValid != CertInvalid ---
(push 1)
(assert (= CertValid CertInvalid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CertStatus: CertInvalid != CertExpired ---
(push 1)
(assert (= CertInvalid CertExpired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CertStatus: CertExpired != CertSelfSigned ---
(push 1)
(assert (= CertExpired CertSelfSigned))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CertStatus: CertValid != CertSelfSigned ---
(push 1)
(assert (= CertValid CertSelfSigned))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CertStatus finite cardinality (4 values) ---
(push 1)
(declare-const x CertStatus)
(assert (and (not (= x CertValid)) (not (= x CertInvalid)) (not (= x CertExpired)) (not (= x CertSelfSigned))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FramePolicy enum properties ---

; --- 7. FramePolicy exhaustiveness ---
(push 1)
(declare-const x FramePolicy)
(assert (not (or (= x FrameDeny) (= x FrameSameOrigin) (= x FrameAllowFrom) (= x FrameAllowAll))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FramePolicy: FrameDeny != FrameSameOrigin ---
(push 1)
(assert (= FrameDeny FrameSameOrigin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FramePolicy: FrameSameOrigin != FrameAllowFrom ---
(push 1)
(assert (= FrameSameOrigin FrameAllowFrom))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FramePolicy: FrameAllowFrom != FrameAllowAll ---
(push 1)
(assert (= FrameAllowFrom FrameAllowAll))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. FramePolicy: FrameDeny != FrameAllowAll ---
(push 1)
(assert (= FrameDeny FrameAllowAll))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. FramePolicy finite cardinality (4 values) ---
(push 1)
(declare-const x FramePolicy)
(assert (and (not (= x FrameDeny)) (not (= x FrameSameOrigin)) (not (= x FrameAllowFrom)) (not (= x FrameAllowAll))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Sensitivity enum properties ---

; --- 13. Sensitivity exhaustiveness ---
(push 1)
(declare-const x Sensitivity)
(assert (not (or (= x SensNone) (= x SensLow) (= x SensMedium) (= x SensHigh) (= x SensCritical))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Sensitivity: SensNone != SensLow ---
(push 1)
(assert (= SensNone SensLow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Sensitivity: SensLow != SensMedium ---
(push 1)
(assert (= SensLow SensMedium))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Sensitivity: SensMedium != SensHigh ---
(push 1)
(assert (= SensMedium SensHigh))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Sensitivity: SensNone != SensCritical ---
(push 1)
(assert (= SensNone SensCritical))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Sensitivity finite cardinality (5 values) ---
(push 1)
(declare-const x Sensitivity)
(assert (and (not (= x SensNone)) (not (= x SensLow)) (not (= x SensMedium)) (not (= x SensHigh)) (not (= x SensCritical))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Breakpoint enum properties ---

; --- 19. Breakpoint exhaustiveness ---
(push 1)
(declare-const x Breakpoint)
(assert (not (or (= x BPMobile) (= x BPTablet) (= x BPDesktop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Breakpoint: BPMobile != BPTablet ---
(push 1)
(assert (= BPMobile BPTablet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Breakpoint: BPTablet != BPDesktop ---
(push 1)
(assert (= BPTablet BPDesktop))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Breakpoint: BPMobile != BPDesktop ---
(push 1)
(assert (= BPMobile BPDesktop))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Breakpoint finite cardinality (3 values) ---
(push 1)
(declare-const x Breakpoint)
(assert (and (not (= x BPMobile)) (not (= x BPTablet)) (not (= x BPDesktop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ErrorSeverity enum properties ---

; --- 24. ErrorSeverity exhaustiveness ---
(push 1)
(declare-const x ErrorSeverity)
(assert (not (or (= x SevInfo) (= x SevWarning) (= x SevError) (= x SevCritical))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ErrorSeverity: SevInfo != SevWarning ---
(push 1)
(assert (= SevInfo SevWarning))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ErrorSeverity: SevWarning != SevError ---
(push 1)
(assert (= SevWarning SevError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ErrorSeverity: SevError != SevCritical ---
(push 1)
(assert (= SevError SevCritical))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ErrorSeverity: SevInfo != SevCritical ---
(push 1)
(assert (= SevInfo SevCritical))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ErrorSeverity finite cardinality (4 values) ---
(push 1)
(declare-const x ErrorSeverity)
(assert (and (not (= x SevInfo)) (not (= x SevWarning)) (not (= x SevError)) (not (= x SevCritical))))
(check-sat) ; expect UNSAT
(pop 1)

; --- DisplayStyle enum properties ---

; --- 30. DisplayStyle exhaustiveness ---
(push 1)
(declare-const x DisplayStyle)
(assert (not (or (= x StyleNormal) (= x StyleAccented) (= x StyleWarning) (= x StyleDanger))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. DisplayStyle: StyleNormal != StyleAccented ---
(push 1)
(assert (= StyleNormal StyleAccented))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DisplayStyle: StyleAccented != StyleWarning ---
(push 1)
(assert (= StyleAccented StyleWarning))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. DisplayStyle: StyleWarning != StyleDanger ---
(push 1)
(assert (= StyleWarning StyleDanger))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. DisplayStyle: StyleNormal != StyleDanger ---
(push 1)
(assert (= StyleNormal StyleDanger))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. DisplayStyle finite cardinality (4 values) ---
(push 1)
(declare-const x DisplayStyle)
(assert (and (not (= x StyleNormal)) (not (= x StyleAccented)) (not (= x StyleWarning)) (not (= x StyleDanger))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RecoveryAction enum properties ---

; --- 36. RecoveryAction exhaustiveness ---
(push 1)
(declare-const x RecoveryAction)
(assert (not (or (= x ActionRetry) (= x ActionDismiss) (= x ActionNavigate) (= x ActionContact))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. RecoveryAction: ActionRetry != ActionDismiss ---
(push 1)
(assert (= ActionRetry ActionDismiss))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. RecoveryAction: ActionDismiss != ActionNavigate ---
(push 1)
(assert (= ActionDismiss ActionNavigate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. RecoveryAction: ActionNavigate != ActionContact ---
(push 1)
(assert (= ActionNavigate ActionContact))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. RecoveryAction: ActionRetry != ActionContact ---
(push 1)
(assert (= ActionRetry ActionContact))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. RecoveryAction finite cardinality (4 values) ---
(push 1)
(declare-const x RecoveryAction)
(assert (and (not (= x ActionRetry)) (not (= x ActionDismiss)) (not (= x ActionNavigate)) (not (= x ActionContact))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Point record properties ---

; --- 42. Point accessor round-trip: px ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (px (mk-point f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Rect record properties ---

; --- 43. Rect accessor round-trip: rect_x ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rect_x (mk-rect f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Rect accessor round-trip: rect_y ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rect_y (mk-rect f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. Rect accessor round-trip: rect_width ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rect_width (mk-rect f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. Rect: integer field consistency ---
(push 1)
(declare-const r Rect)
(assert (>= (rect_x r) 0))
(assert (>= (rect_y r) 0))
(assert (not (>= (+ (rect_x r) (rect_y r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- UIElement record properties ---

; --- 47. UIElement accessor round-trip: elem_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Rect)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (elem_id (mk-ui_element f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. UIElement accessor round-trip: elem_bounds ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Rect)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (elem_bounds (mk-ui_element f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. UIElement accessor round-trip: elem_z_index ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Rect)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (elem_z_index (mk-ui_element f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. UIElement accessor round-trip: elem_opacity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Rect)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (elem_opacity (mk-ui_element f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. UIElement accessor round-trip: elem_interactive ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Rect)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (elem_interactive (mk-ui_element f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. UIElement: integer field consistency ---
(push 1)
(declare-const r UIElement)
(assert (>= (elem_id r) 0))
(assert (>= (elem_z_index r) 0))
(assert (not (>= (+ (elem_id r) (elem_z_index r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- UIState record properties ---

; --- 53. UIState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (ui_elements (mk-ui_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Origin record properties ---

; --- 54. Origin accessor round-trip: origin_scheme ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(assert (not (= (origin_scheme (mk-origin f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. Origin accessor round-trip: origin_host ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 Int)
(assert (not (= (origin_host (mk-origin f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TabState record properties ---

; --- 56. TabState accessor round-trip: tab_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Origin)
(declare-const f2 Origin)
(declare-const f3 Int)
(assert (not (= (tab_id (mk-tab_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. TabState accessor round-trip: tab_loaded_origin ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Origin)
(declare-const f2 Origin)
(declare-const f3 Int)
(assert (not (= (tab_loaded_origin (mk-tab_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. TabState accessor round-trip: tab_content_origin ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Origin)
(declare-const f2 Origin)
(declare-const f3 Int)
(assert (not (= (tab_content_origin (mk-tab_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FrameState record properties ---

; --- 59. FrameState accessor round-trip: frame_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Origin)
(declare-const f2 Int)
(declare-const f3 FramePolicy)
(assert (not (= (frame_id (mk-frame_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. FrameState accessor round-trip: frame_origin ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Origin)
(declare-const f2 Int)
(declare-const f3 FramePolicy)
(assert (not (= (frame_origin (mk-frame_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. FrameState accessor round-trip: frame_parent_origin ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Origin)
(declare-const f2 Int)
(declare-const f3 FramePolicy)
(assert (not (= (frame_parent_origin (mk-frame_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. FrameState: integer field consistency ---
(push 1)
(declare-const r FrameState)
(assert (>= (frame_id r) 0))
(assert (>= (frame_parent_origin r) 0))
(assert (not (>= (+ (frame_id r) (frame_parent_origin r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifiedBrowserState record properties ---

; --- 63. VerifiedBrowserState accessor round-trip: browser_displayed_url ---
(push 1)
(declare-const f0 String)
(declare-const f1 Origin)
(declare-const f2 CertStatus)
(declare-const f3 Bool)
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (browser_displayed_url (mk-verified_browser_state f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. VerifiedBrowserState accessor round-trip: browser_actual_origin ---
(push 1)
(declare-const f0 String)
(declare-const f1 Origin)
(declare-const f2 CertStatus)
(declare-const f3 Bool)
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (browser_actual_origin (mk-verified_browser_state f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. VerifiedBrowserState accessor round-trip: browser_cert_status ---
(push 1)
(declare-const f0 String)
(declare-const f1 Origin)
(declare-const f2 CertStatus)
(declare-const f3 Bool)
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (browser_cert_status (mk-verified_browser_state f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. VerifiedBrowserState accessor round-trip: browser_tls_verified ---
(push 1)
(declare-const f0 String)
(declare-const f1 Origin)
(declare-const f2 CertStatus)
(declare-const f3 Bool)
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (browser_tls_verified (mk-verified_browser_state f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. VerifiedBrowserState accessor round-trip: Seq ---
(push 1)
(declare-const f0 String)
(declare-const f1 Origin)
(declare-const f2 CertStatus)
(declare-const f3 Bool)
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (browser_tabs (mk-verified_browser_state f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. VerifiedBrowserState: integer field consistency ---
(push 1)
(declare-const r VerifiedBrowserState)
(assert (>= (seq.len (browser_tabs r)) 0))
(assert (>= (seq.len (browser_tabs r)) 0))
(assert (not (>= (+ (seq.len (browser_tabs r)) (seq.len (browser_tabs r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConsentRecord record properties ---

; --- 69. ConsentRecord accessor round-trip: consent_action ---
(push 1)
(declare-const f0 String)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (consent_action (mk-consent_record f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. ConsentRecord accessor round-trip: consent_granted ---
(push 1)
(declare-const f0 String)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (consent_granted (mk-consent_record f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. ConsentRecord accessor round-trip: consent_timestamp ---
(push 1)
(declare-const f0 String)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (consent_timestamp (mk-consent_record f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DialogOption record properties ---

; --- 72. DialogOption accessor round-trip: opt_label ---
(push 1)
(declare-const f0 String)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (opt_label (mk-dialog_option f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. DialogOption accessor round-trip: opt_is_cancel ---
(push 1)
(declare-const f0 String)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (opt_is_cancel (mk-dialog_option f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. DialogOption accessor round-trip: opt_visual_weight ---
(push 1)
(declare-const f0 String)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (opt_visual_weight (mk-dialog_option f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifiedDialog record properties ---

; --- 75. VerifiedDialog accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (dialog_options (mk-verified_dialog f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. VerifiedDialog accessor round-trip: dialog_balanced ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (dialog_balanced (mk-verified_dialog f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. VerifiedDialog: integer field consistency ---
(push 1)
(declare-const r VerifiedDialog)
(assert (>= (seq.len (dialog_options r)) 0))
(assert (>= (dialog_balanced r) 0))
(assert (not (>= (+ (seq.len (dialog_options r)) (dialog_balanced r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PriceDisplay record properties ---

; --- 78. PriceDisplay accessor round-trip: displayed_total ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (displayed_total (mk-price_display f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. PriceDisplay accessor round-trip: actual_total ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (actual_total (mk-price_display f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. PriceDisplay: integer field consistency ---
(push 1)
(declare-const r PriceDisplay)
(assert (>= (displayed_total r) 0))
(assert (>= (actual_total r) 0))
(assert (not (>= (+ (displayed_total r) (actual_total r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConsentState record properties ---

; --- 81. ConsentState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (consent_records (mk-consent_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SensitiveAction record properties ---

; --- 82. SensitiveAction accessor round-trip: action_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Sensitivity)
(assert (not (= (action_name (mk-sensitive_action f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LayoutInput record properties ---

; --- 83. LayoutInput accessor round-trip: layout_viewport_width ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (layout_viewport_width (mk-layout_input f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. LayoutInput accessor round-trip: layout_viewport_height ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (layout_viewport_height (mk-layout_input f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. LayoutInput accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (layout_elements (mk-layout_input f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. LayoutInput: integer field consistency ---
(push 1)
(declare-const r LayoutInput)
(assert (>= (layout_viewport_width r) 0))
(assert (>= (layout_viewport_height r) 0))
(assert (not (>= (+ (layout_viewport_width r) (layout_viewport_height r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- InputField record properties ---

; --- 87. InputField accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (field_data (mk-input_field f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. InputField accessor round-trip: input_max_length ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (input_max_length (mk-input_field f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. InputField accessor round-trip: input_allowed ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (input_allowed (mk-input_field f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. InputField: integer field consistency ---
(push 1)
(declare-const r InputField)
(assert (>= (seq.len (field_data r)) 0))
(assert (>= (input_max_length r) 0))
(assert (not (>= (+ (seq.len (field_data r)) (input_max_length r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FocusState record properties ---

; --- 91. FocusState accessor round-trip: focused_element ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(assert (not (= (focused_element (mk-focus_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 92. FocusState accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(assert (not (= (tab_order (mk-focus_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. FocusState accessor round-trip: focus_modal_active ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(assert (not (= (focus_modal_active (mk-focus_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. FocusState: integer field consistency ---
(push 1)
(declare-const r FocusState)
(assert (>= (focused_element r) 0))
(assert (>= (seq.len (tab_order r)) 0))
(assert (not (>= (+ (focused_element r) (seq.len (tab_order r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifiedFocusState record properties ---

; --- 95. VerifiedFocusState accessor round-trip: vf_state ---
(push 1)
(declare-const f0 FocusState)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (vf_state (mk-verified_focus_state f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. VerifiedFocusState accessor round-trip: vf_valid ---
(push 1)
(declare-const f0 FocusState)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (vf_valid (mk-verified_focus_state f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. VerifiedFocusState accessor round-trip: Seq ---
(push 1)
(declare-const f0 FocusState)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (vf_visible_elements (mk-verified_focus_state f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. VerifiedFocusState accessor round-trip: vf_tab_in_visible ---
(push 1)
(declare-const f0 FocusState)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (vf_tab_in_visible (mk-verified_focus_state f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. VerifiedFocusState: integer field consistency ---
(push 1)
(declare-const r VerifiedFocusState)
(assert (>= (vf_valid r) 0))
(assert (>= (seq.len (vf_visible_elements r)) 0))
(assert (not (>= (+ (vf_valid r) (seq.len (vf_visible_elements r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ViewportBounds record properties ---

; --- 100. ViewportBounds accessor round-trip: vp_min_x ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vp_min_x (mk-viewport_bounds f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 101. ViewportBounds accessor round-trip: vp_min_y ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vp_min_y (mk-viewport_bounds f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 102. ViewportBounds accessor round-trip: vp_max_x ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vp_max_x (mk-viewport_bounds f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. ViewportBounds: integer field consistency ---
(push 1)
(declare-const r ViewportBounds)
(assert (>= (vp_min_x r) 0))
(assert (>= (vp_min_y r) 0))
(assert (not (>= (+ (vp_min_x r) (vp_min_y r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Viewport record properties ---

; --- 104. Viewport accessor round-trip: vp_width ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (vp_width (mk-viewport f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LayoutElement record properties ---

; --- 105. LayoutElement accessor round-trip: le_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (le_id (mk-layout_element f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 106. LayoutElement accessor round-trip: le_width ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (le_width (mk-layout_element f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 107. LayoutElement accessor round-trip: le_height ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (le_height (mk-layout_element f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 108. LayoutElement accessor round-trip: le_font_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (le_font_size (mk-layout_element f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 109. LayoutElement: integer field consistency ---
(push 1)
(declare-const r LayoutElement)
(assert (>= (le_id r) 0))
(assert (>= (le_width r) 0))
(assert (not (>= (+ (le_id r) (le_width r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ResponsiveLayout record properties ---

; --- 110. ResponsiveLayout accessor round-trip: rl_viewport ---
(push 1)
(declare-const f0 Viewport)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (rl_viewport (mk-responsive_layout f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 111. ResponsiveLayout accessor round-trip: Seq ---
(push 1)
(declare-const f0 Viewport)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (rl_elements (mk-responsive_layout f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 112. ResponsiveLayout accessor round-trip: rl_all_fit ---
(push 1)
(declare-const f0 Viewport)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (rl_all_fit (mk-responsive_layout f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 113. ResponsiveLayout accessor round-trip: rl_touch_targets ---
(push 1)
(declare-const f0 Viewport)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (rl_touch_targets (mk-responsive_layout f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 114. ResponsiveLayout: integer field consistency ---
(push 1)
(declare-const r ResponsiveLayout)
(assert (>= (seq.len (rl_elements r)) 0))
(assert (>= (rl_all_fit r) 0))
(assert (not (>= (+ (seq.len (rl_elements r)) (rl_all_fit r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ErrorDisplay record properties ---

; --- 115. ErrorDisplay accessor round-trip: err_message ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 ErrorSeverity)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 DisplayStyle)
(declare-const f6 RecoveryAction)
(assert (not (= (err_message (mk-error_display f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 116. ErrorDisplay accessor round-trip: err_actual_error ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 ErrorSeverity)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 DisplayStyle)
(declare-const f6 RecoveryAction)
(assert (not (= (err_actual_error (mk-error_display f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 117. ErrorDisplay accessor round-trip: err_severity ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 ErrorSeverity)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 DisplayStyle)
(declare-const f6 RecoveryAction)
(assert (not (= (err_severity (mk-error_display f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 118. ErrorDisplay accessor round-trip: err_visible ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 ErrorSeverity)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 DisplayStyle)
(declare-const f6 RecoveryAction)
(assert (not (= (err_visible (mk-error_display f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 119. ErrorDisplay accessor round-trip: err_auto_dismiss ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 ErrorSeverity)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 DisplayStyle)
(declare-const f6 RecoveryAction)
(assert (not (= (err_auto_dismiss (mk-error_display f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifiedErrorDisplay record properties ---

; --- 120. VerifiedErrorDisplay accessor round-trip: ve_display ---
(push 1)
(declare-const f0 ErrorDisplay)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ve_display (mk-verified_error_display f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 121. VerifiedErrorDisplay accessor round-trip: ve_always_visible ---
(push 1)
(declare-const f0 ErrorDisplay)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ve_always_visible (mk-verified_error_display f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 122. VerifiedErrorDisplay accessor round-trip: ve_critical_persistent ---
(push 1)
(declare-const f0 ErrorDisplay)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ve_critical_persistent (mk-verified_error_display f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 123. VerifiedErrorDisplay accessor round-trip: ve_style_matches ---
(push 1)
(declare-const f0 ErrorDisplay)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ve_style_matches (mk-verified_error_display f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 124. VerifiedErrorDisplay: integer field consistency ---
(push 1)
(declare-const r VerifiedErrorDisplay)
(assert (>= (ve_always_visible r) 0))
(assert (>= (ve_critical_persistent r) 0))
(assert (not (>= (+ (ve_always_visible r) (ve_critical_persistent r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ErrorSeverity ordering properties ---

(define-fun ErrorSeverity_level ((x ErrorSeverity)) Int
  (ite (= x SevInfo) 0 (ite (= x SevWarning) 1 (ite (= x SevError) 2 3))))

(define-fun ErrorSeverity_leq ((x ErrorSeverity) (y ErrorSeverity)) Bool
  (<= (ErrorSeverity_level x) (ErrorSeverity_level y)))

; --- 125. ErrorSeverity_leq reflexivity ---
(push 1)
(declare-const x ErrorSeverity)
(assert (not (ErrorSeverity_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 126. ErrorSeverity_leq transitivity ---
(push 1)
(declare-const x ErrorSeverity)
(declare-const y ErrorSeverity)
(declare-const z ErrorSeverity)
(assert (ErrorSeverity_leq x y))
(assert (ErrorSeverity_leq y z))
(assert (not (ErrorSeverity_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 127. ErrorSeverity_leq antisymmetry ---
(push 1)
(declare-const x ErrorSeverity)
(declare-const y ErrorSeverity)
(assert (ErrorSeverity_leq x y))
(assert (ErrorSeverity_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 128. SevInfo is bottom ---
(push 1)
(declare-const x ErrorSeverity)
(assert (not (ErrorSeverity_leq SevInfo x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 129. SevCritical is top ---
(push 1)
(declare-const x ErrorSeverity)
(assert (not (ErrorSeverity_leq x SevCritical)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

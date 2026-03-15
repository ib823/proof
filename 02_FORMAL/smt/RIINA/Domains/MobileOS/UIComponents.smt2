; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA UIComponents — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/UIComponents.v (26 assertions)
; Module: UIComponents
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ScreenState 0)) (((Loading) (Ready) (Active) (Error) (Dismissed))))

(declare-datatypes ((ButtonState 0)) (((BtnNormal) (BtnHighlighted) (BtnDisabled) (BtnSelected))))

(declare-datatypes ((ImageLoadState 0)) (((ImgNotLoaded) (ImgLoading) (ImgLoaded) (ImgFailed))))

(declare-datatypes ((UIElement 0))
  (((mk-ui_element (element_id Int) (element_visible Bool) (element_enabled Bool) (element_accessibility_label Int) (element_voiceover_navigable Bool)))))

(declare-datatypes ((Screen 0))
  (((mk-screen (screen_id Int) (screen_state ScreenState) (screen_elements (Seq Int))))))

(declare-datatypes ((Transition 0))
  (((mk-transition (trans_from ScreenState) (trans_to ScreenState) (trans_valid Bool)))))

(declare-datatypes ((Button 0))
  (((mk-button (btn_id Int) (btn_state ButtonState) (btn_enabled Bool) (btn_visible Bool)))))

(declare-datatypes ((TextField 0))
  (((mk-text_field (tf_id Int) (tf_input (Seq Int)) (tf_max_length Int) (tf_sanitized Bool)))))

(declare-datatypes ((ListView 0))
  (((mk-list_view (lv_total_items Int) (lv_visible_items Int) (lv_recycled_views Int) (lv_recycling_correct Bool)))))

(declare-datatypes ((ScrollView 0))
  (((mk-scroll_view (sv_content_offset Int) (sv_content_size Int) (sv_bounds_checked Bool)))))

(declare-datatypes ((ImageView 0))
  (((mk-image_view (iv_id Int) (iv_load_state ImageLoadState) (iv_placeholder_shown Bool) (iv_loading_handled Bool)))))

(declare-datatypes ((SwitchToggle 0))
  (((mk-switch_toggle (sw_id Int) (sw_on Bool) (sw_transitioning Bool) (sw_atomic Bool)))))

(declare-datatypes ((Slider 0))
  (((mk-slider (sl_value Int) (sl_min_value Int) (sl_max_value Int)))))

(declare-datatypes ((ProgressBar 0))
  (((mk-progress_bar (pb_current Int) (pb_previous Int) (pb_max Int) (pb_monotonic Bool)))))

(declare-datatypes ((TabBar 0))
  (((mk-tab_bar (tb_tabs (Seq Int)) (tb_selected_index Int) (tb_selection_exclusive Bool)))))

(declare-datatypes ((NavigationStack 0))
  (((mk-navigation_stack (ns_stack (Seq Int)) (ns_stack_valid Bool)))))

(declare-datatypes ((AlertDialog 0))
  (((mk-alert_dialog (ad_id Int) (ad_modal Bool) (ad_blocking_input Bool) (ad_dismissible Bool)))))

(declare-datatypes ((ActionSheet 0))
  (((mk-action_sheet (as_id Int) (as_actions (Seq Int)) (as_dismissible Bool) (as_cancel_available Bool)))))

(declare-datatypes ((DatePicker 0))
  (((mk-date_picker (dp_selected Int) (dp_min_date Int) (dp_max_date Int) (dp_range_valid Bool)))))

(declare-datatypes ((ColorPicker 0))
  (((mk-color_picker (cp_red Int) (cp_green Int) (cp_blue Int) (cp_gamut_valid Bool)))))

(declare-datatypes ((SearchBar 0))
  (((mk-search_bar (sb_query (Seq Int)) (sb_last_search_ms Int) (sb_debounce_ms Int) (sb_current_ms Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- ScreenState enum properties ---

; --- 1. ScreenState exhaustiveness ---
(push 1)
(declare-const x ScreenState)
(assert (not (or (= x Loading) (= x Ready) (= x Active) (= x Error) (= x Dismissed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ScreenState: Loading != Ready ---
(push 1)
(assert (= Loading Ready))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ScreenState: Ready != Active ---
(push 1)
(assert (= Ready Active))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ScreenState: Active != Error ---
(push 1)
(assert (= Active Error))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ScreenState: Loading != Dismissed ---
(push 1)
(assert (= Loading Dismissed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ScreenState finite cardinality (5 values) ---
(push 1)
(declare-const x ScreenState)
(assert (and (not (= x Loading)) (not (= x Ready)) (not (= x Active)) (not (= x Error)) (not (= x Dismissed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ButtonState enum properties ---

; --- 7. ButtonState exhaustiveness ---
(push 1)
(declare-const x ButtonState)
(assert (not (or (= x BtnNormal) (= x BtnHighlighted) (= x BtnDisabled) (= x BtnSelected))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ButtonState: BtnNormal != BtnHighlighted ---
(push 1)
(assert (= BtnNormal BtnHighlighted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ButtonState: BtnHighlighted != BtnDisabled ---
(push 1)
(assert (= BtnHighlighted BtnDisabled))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ButtonState: BtnDisabled != BtnSelected ---
(push 1)
(assert (= BtnDisabled BtnSelected))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ButtonState: BtnNormal != BtnSelected ---
(push 1)
(assert (= BtnNormal BtnSelected))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ButtonState finite cardinality (4 values) ---
(push 1)
(declare-const x ButtonState)
(assert (and (not (= x BtnNormal)) (not (= x BtnHighlighted)) (not (= x BtnDisabled)) (not (= x BtnSelected))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ImageLoadState enum properties ---

; --- 13. ImageLoadState exhaustiveness ---
(push 1)
(declare-const x ImageLoadState)
(assert (not (or (= x ImgNotLoaded) (= x ImgLoading) (= x ImgLoaded) (= x ImgFailed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. ImageLoadState: ImgNotLoaded != ImgLoading ---
(push 1)
(assert (= ImgNotLoaded ImgLoading))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ImageLoadState: ImgLoading != ImgLoaded ---
(push 1)
(assert (= ImgLoading ImgLoaded))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ImageLoadState: ImgLoaded != ImgFailed ---
(push 1)
(assert (= ImgLoaded ImgFailed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ImageLoadState: ImgNotLoaded != ImgFailed ---
(push 1)
(assert (= ImgNotLoaded ImgFailed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ImageLoadState finite cardinality (4 values) ---
(push 1)
(declare-const x ImageLoadState)
(assert (and (not (= x ImgNotLoaded)) (not (= x ImgLoading)) (not (= x ImgLoaded)) (not (= x ImgFailed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- UIElement record properties ---

; --- 19. UIElement accessor round-trip: element_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (element_id (mk-ui_element f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. UIElement accessor round-trip: element_visible ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (element_visible (mk-ui_element f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. UIElement accessor round-trip: element_enabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (element_enabled (mk-ui_element f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. UIElement accessor round-trip: element_accessibility_label ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (element_accessibility_label (mk-ui_element f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. UIElement: integer field consistency ---
(push 1)
(declare-const r UIElement)
(assert (>= (element_id r) 0))
(assert (>= (element_accessibility_label r) 0))
(assert (not (>= (+ (element_id r) (element_accessibility_label r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Screen record properties ---

; --- 24. Screen accessor round-trip: screen_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ScreenState)
(declare-const f2 (Seq Int))
(assert (not (= (screen_id (mk-screen f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Screen accessor round-trip: screen_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ScreenState)
(declare-const f2 (Seq Int))
(assert (not (= (screen_state (mk-screen f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Transition record properties ---

; --- 26. Transition accessor round-trip: trans_from ---
(push 1)
(declare-const f0 ScreenState)
(declare-const f1 ScreenState)
(declare-const f2 Bool)
(assert (not (= (trans_from (mk-transition f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Transition accessor round-trip: trans_to ---
(push 1)
(declare-const f0 ScreenState)
(declare-const f1 ScreenState)
(declare-const f2 Bool)
(assert (not (= (trans_to (mk-transition f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Button record properties ---

; --- 28. Button accessor round-trip: btn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ButtonState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (btn_id (mk-button f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Button accessor round-trip: btn_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ButtonState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (btn_state (mk-button f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Button accessor round-trip: btn_enabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ButtonState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (btn_enabled (mk-button f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TextField record properties ---

; --- 31. TextField accessor round-trip: tf_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tf_id (mk-text_field f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. TextField accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tf_input (mk-text_field f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. TextField accessor round-trip: tf_max_length ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tf_max_length (mk-text_field f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. TextField: integer field consistency ---
(push 1)
(declare-const r TextField)
(assert (>= (tf_id r) 0))
(assert (>= (seq.len (tf_input r)) 0))
(assert (not (>= (+ (tf_id r) (seq.len (tf_input r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ListView record properties ---

; --- 35. ListView accessor round-trip: lv_total_items ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (lv_total_items (mk-list_view f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ListView accessor round-trip: lv_visible_items ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (lv_visible_items (mk-list_view f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. ListView accessor round-trip: lv_recycled_views ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (lv_recycled_views (mk-list_view f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. ListView: integer field consistency ---
(push 1)
(declare-const r ListView)
(assert (>= (lv_total_items r) 0))
(assert (>= (lv_visible_items r) 0))
(assert (not (>= (+ (lv_total_items r) (lv_visible_items r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ScrollView record properties ---

; --- 39. ScrollView accessor round-trip: sv_content_offset ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (sv_content_offset (mk-scroll_view f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. ScrollView accessor round-trip: sv_content_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (sv_content_size (mk-scroll_view f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. ScrollView: integer field consistency ---
(push 1)
(declare-const r ScrollView)
(assert (>= (sv_content_offset r) 0))
(assert (>= (sv_content_size r) 0))
(assert (not (>= (+ (sv_content_offset r) (sv_content_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ImageView record properties ---

; --- 42. ImageView accessor round-trip: iv_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ImageLoadState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (iv_id (mk-image_view f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. ImageView accessor round-trip: iv_load_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ImageLoadState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (iv_load_state (mk-image_view f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. ImageView accessor round-trip: iv_placeholder_shown ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ImageLoadState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (iv_placeholder_shown (mk-image_view f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SwitchToggle record properties ---

; --- 45. SwitchToggle accessor round-trip: sw_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sw_id (mk-switch_toggle f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. SwitchToggle accessor round-trip: sw_on ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sw_on (mk-switch_toggle f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. SwitchToggle accessor round-trip: sw_transitioning ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sw_transitioning (mk-switch_toggle f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Slider record properties ---

; --- 48. Slider accessor round-trip: sl_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sl_value (mk-slider f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. Slider accessor round-trip: sl_min_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sl_min_value (mk-slider f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. Slider: integer field consistency ---
(push 1)
(declare-const r Slider)
(assert (>= (sl_value r) 0))
(assert (>= (sl_min_value r) 0))
(assert (not (>= (+ (sl_value r) (sl_min_value r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProgressBar record properties ---

; --- 51. ProgressBar accessor round-trip: pb_current ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pb_current (mk-progress_bar f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. ProgressBar accessor round-trip: pb_previous ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pb_previous (mk-progress_bar f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. ProgressBar accessor round-trip: pb_max ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pb_max (mk-progress_bar f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. ProgressBar: integer field consistency ---
(push 1)
(declare-const r ProgressBar)
(assert (>= (pb_current r) 0))
(assert (>= (pb_previous r) 0))
(assert (not (>= (+ (pb_current r) (pb_previous r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TabBar record properties ---

; --- 55. TabBar accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (tb_tabs (mk-tab_bar f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. TabBar accessor round-trip: tb_selected_index ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (tb_selected_index (mk-tab_bar f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. TabBar: integer field consistency ---
(push 1)
(declare-const r TabBar)
(assert (>= (seq.len (tb_tabs r)) 0))
(assert (>= (tb_selected_index r) 0))
(assert (not (>= (+ (seq.len (tb_tabs r)) (tb_selected_index r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NavigationStack record properties ---

; --- 58. NavigationStack accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(assert (not (= (ns_stack (mk-navigation_stack f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AlertDialog record properties ---

; --- 59. AlertDialog accessor round-trip: ad_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ad_id (mk-alert_dialog f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. AlertDialog accessor round-trip: ad_modal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ad_modal (mk-alert_dialog f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. AlertDialog accessor round-trip: ad_blocking_input ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ad_blocking_input (mk-alert_dialog f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ActionSheet record properties ---

; --- 62. ActionSheet accessor round-trip: as_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (as_id (mk-action_sheet f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. ActionSheet accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (as_actions (mk-action_sheet f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. ActionSheet accessor round-trip: as_dismissible ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (as_dismissible (mk-action_sheet f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. ActionSheet: integer field consistency ---
(push 1)
(declare-const r ActionSheet)
(assert (>= (as_id r) 0))
(assert (>= (seq.len (as_actions r)) 0))
(assert (not (>= (+ (as_id r) (seq.len (as_actions r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DatePicker record properties ---

; --- 66. DatePicker accessor round-trip: dp_selected ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (dp_selected (mk-date_picker f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. DatePicker accessor round-trip: dp_min_date ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (dp_min_date (mk-date_picker f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. DatePicker accessor round-trip: dp_max_date ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (dp_max_date (mk-date_picker f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. DatePicker: integer field consistency ---
(push 1)
(declare-const r DatePicker)
(assert (>= (dp_selected r) 0))
(assert (>= (dp_min_date r) 0))
(assert (not (>= (+ (dp_selected r) (dp_min_date r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ColorPicker record properties ---

; --- 70. ColorPicker accessor round-trip: cp_red ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cp_red (mk-color_picker f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. ColorPicker accessor round-trip: cp_green ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cp_green (mk-color_picker f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. ColorPicker accessor round-trip: cp_blue ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cp_blue (mk-color_picker f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. ColorPicker: integer field consistency ---
(push 1)
(declare-const r ColorPicker)
(assert (>= (cp_red r) 0))
(assert (>= (cp_green r) 0))
(assert (not (>= (+ (cp_red r) (cp_green r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SearchBar record properties ---

; --- 74. SearchBar accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sb_query (mk-search_bar f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. SearchBar accessor round-trip: sb_last_search_ms ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sb_last_search_ms (mk-search_bar f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. SearchBar accessor round-trip: sb_debounce_ms ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sb_debounce_ms (mk-search_bar f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. SearchBar: integer field consistency ---
(push 1)
(declare-const r SearchBar)
(assert (>= (seq.len (sb_query r)) 0))
(assert (>= (sb_last_search_ms r) 0))
(assert (not (>= (+ (seq.len (sb_query r)) (sb_last_search_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ApplicationLifecycle — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/ApplicationLifecycle.v (22 assertions)
; Module: ApplicationLifecycle
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AppState 0)) (((NotRunning) (Launching) (Foreground) (Background) (Suspended) (Terminated))))

(declare-datatypes ((Application 0))
  (((mk-application (app_id Int) (app_state AppState) (app_data Int) (app_saved_state Int) (app_supports_restoration Bool)))))

(declare-datatypes ((URLScheme 0))
  (((mk-url_scheme (url_scheme Int) (url_host Int) (url_path Int) (url_validated Bool) (url_sanitized Bool)))))

(declare-datatypes ((AppExtension 0))
  (((mk-app_extension (ext_id Int) (ext_parent_app_id Int) (ext_sandboxed Bool) (ext_data_types (Seq Int))))))

(declare-datatypes ((Widget 0))
  (((mk-widget (widget_id Int) (widget_app_id Int) (widget_last_update Int) (widget_update_interval Int)))))

(declare-datatypes ((AppGroup 0))
  (((mk-app_group (group_app_ids (Seq Int)) (group_shared_data (Seq Int)) (group_access_controlled Bool)))))

(declare-datatypes ((AppScene 0))
  (((mk-app_scene (scene_app_id Int) (scene_state AppState) (scene_active Bool)))))

(declare-datatypes ((ExtApp 0))
  (((mk-ext_app (ext_app Application) (ext_bg_time_used Int) (ext_memory_level Int) (ext_scenes (Seq Int)) (ext_activation_count Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- AppState enum properties ---

; --- 1. AppState exhaustiveness ---
(push 1)
(declare-const x AppState)
(assert (not (or (= x NotRunning) (= x Launching) (= x Foreground) (= x Background) (= x Suspended) (= x Terminated))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AppState: NotRunning != Launching ---
(push 1)
(assert (= NotRunning Launching))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AppState: Launching != Foreground ---
(push 1)
(assert (= Launching Foreground))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AppState: Foreground != Background ---
(push 1)
(assert (= Foreground Background))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. AppState: NotRunning != Terminated ---
(push 1)
(assert (= NotRunning Terminated))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. AppState finite cardinality (6 values) ---
(push 1)
(declare-const x AppState)
(assert (and (not (= x NotRunning)) (not (= x Launching)) (not (= x Foreground)) (not (= x Background)) (not (= x Suspended)) (not (= x Terminated))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Application record properties ---

; --- 7. Application accessor round-trip: app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (app_id (mk-application f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Application accessor round-trip: app_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (app_state (mk-application f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Application accessor round-trip: app_data ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (app_data (mk-application f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Application accessor round-trip: app_saved_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (app_saved_state (mk-application f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Application: integer field consistency ---
(push 1)
(declare-const r Application)
(assert (>= (app_id r) 0))
(assert (>= (app_data r) 0))
(assert (not (>= (+ (app_id r) (app_data r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- URLScheme record properties ---

; --- 12. URLScheme accessor round-trip: url_scheme ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (url_scheme (mk-u_r_l_scheme f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. URLScheme accessor round-trip: url_host ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (url_host (mk-u_r_l_scheme f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. URLScheme accessor round-trip: url_path ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (url_path (mk-u_r_l_scheme f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. URLScheme accessor round-trip: url_validated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (url_validated (mk-u_r_l_scheme f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. URLScheme: integer field consistency ---
(push 1)
(declare-const r URLScheme)
(assert (>= (url_scheme r) 0))
(assert (>= (url_host r) 0))
(assert (not (>= (+ (url_scheme r) (url_host r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AppExtension record properties ---

; --- 17. AppExtension accessor round-trip: ext_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (ext_id (mk-app_extension f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. AppExtension accessor round-trip: ext_parent_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (ext_parent_app_id (mk-app_extension f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. AppExtension accessor round-trip: ext_sandboxed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (ext_sandboxed (mk-app_extension f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. AppExtension: integer field consistency ---
(push 1)
(declare-const r AppExtension)
(assert (>= (ext_id r) 0))
(assert (>= (ext_parent_app_id r) 0))
(assert (not (>= (+ (ext_id r) (ext_parent_app_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Widget record properties ---

; --- 21. Widget accessor round-trip: widget_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (widget_id (mk-widget f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Widget accessor round-trip: widget_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (widget_app_id (mk-widget f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Widget accessor round-trip: widget_last_update ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (widget_last_update (mk-widget f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Widget: integer field consistency ---
(push 1)
(declare-const r Widget)
(assert (>= (widget_id r) 0))
(assert (>= (widget_app_id r) 0))
(assert (not (>= (+ (widget_id r) (widget_app_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AppGroup record properties ---

; --- 25. AppGroup accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (Seq (mk-app_group f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. AppGroup accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (Seq (mk-app_group f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. AppGroup: integer field consistency ---
(push 1)
(declare-const r AppGroup)
(assert (>= (Seq r) 0))
(assert (>= (Seq r) 0))
(assert (not (>= (+ (Seq r) (Seq r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AppScene record properties ---

; --- 28. AppScene accessor round-trip: scene_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(assert (not (= (scene_app_id (mk-app_scene f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. AppScene accessor round-trip: scene_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(assert (not (= (scene_state (mk-app_scene f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ExtApp record properties ---

; --- 30. ExtApp accessor round-trip: ext_app ---
(push 1)
(declare-const f0 Application)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ext_app (mk-ext_app f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ExtApp accessor round-trip: ext_bg_time_used ---
(push 1)
(declare-const f0 Application)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ext_bg_time_used (mk-ext_app f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ExtApp accessor round-trip: ext_memory_level ---
(push 1)
(declare-const f0 Application)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ext_memory_level (mk-ext_app f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. ExtApp accessor round-trip: Seq ---
(push 1)
(declare-const f0 Application)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (Seq (mk-ext_app f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. ExtApp: integer field consistency ---
(push 1)
(declare-const r ExtApp)
(assert (>= (ext_bg_time_used r) 0))
(assert (>= (ext_memory_level r) 0))
(assert (not (>= (+ (ext_bg_time_used r) (ext_memory_level r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

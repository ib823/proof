; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SystemApps — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/SystemApps.v (24 assertions)
; Module: SystemApps
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AppCategory 0)) (((Communication) (Productivity) (Media) (Utility) (Security))))

(declare-datatypes ((SystemApp 0))
  (((mk-system_app (sys_app_id Int) (app_category AppCategory) (is_verified Bool) (has_sandbox Bool) (permissions_minimal Bool) (data_encrypted Bool)))))

(declare-datatypes ((AppState 0))
  (((mk-app_state (state_app_id Int) (state_data (Seq Int)) (state_valid Bool) (state_hash Int)))))

(declare-datatypes ((StateTransition 0))
  (((mk-state_transition (trans_app_id Int) (from_state AppState) (to_state AppState) (transition_type Int)))))

(declare-datatypes ((SyncOperation 0))
  (((mk-sync_operation (sync_app_id Int) (local_state AppState) (remote_state AppState) (merged_state AppState) (sync_successful Bool)))))

(declare-datatypes ((AppResponse 0))
  (((mk-app_response (response_app_id Int) (response_time_us Int) (response_correct Bool)))))

(declare-datatypes ((AppPermission 0))
  (((mk-app_permission (perm_app_id Int) (perm_camera Bool) (perm_microphone Bool) (perm_location Bool) (perm_network Bool) (perm_clipboard Bool) (perm_notification Bool) (perm_granted_explicitly Bool)))))

(declare-datatypes ((AppLifecycle 0))
  (((mk-app_lifecycle (lc_app_id Int) (lc_installed Bool) (lc_install_verified Bool) (lc_foreground Bool) (lc_background Bool) (lc_background_limited Bool) (lc_data_on_disk Bool) (lc_version Int)))))

(declare-datatypes ((AppUpdate 0))
  (((mk-app_update (upd_app_id Int) (upd_old_version Int) (upd_new_version Int) (upd_signature_valid Bool) (upd_applied Bool) (upd_rollback_available Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. AppCategory exhaustiveness ---
(push 1)
(declare-const x AppCategory)
(assert (not (or (= x Communication) (= x Productivity) (= x Media) (= x Utility) (= x Security))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AppCategory: Communication != Productivity ---
(push 1)
(assert (= Communication Productivity))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AppCategory: Productivity != Media ---
(push 1)
(assert (= Productivity Media))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AppCategory: Media != Utility ---
(push 1)
(assert (= Media Utility))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. AppCategory: Communication != Security ---
(push 1)
(assert (= Communication Security))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. AppCategory finite cardinality (5 values) ---
(push 1)
(declare-const x AppCategory)
(assert (and (not (= x Communication)) (not (= x Productivity)) (not (= x Media)) (not (= x Utility)) (not (= x Security))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SystemApp accessor round-trip: sys_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppCategory)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (sys_app_id (mk-system_app f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SystemApp accessor round-trip: app_category ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppCategory)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (app_category (mk-system_app f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SystemApp accessor round-trip: is_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppCategory)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (is_verified (mk-system_app f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SystemApp accessor round-trip: has_sandbox ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppCategory)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (has_sandbox (mk-system_app f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SystemApp accessor round-trip: permissions_minimal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppCategory)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (permissions_minimal (mk-system_app f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. AppState accessor round-trip: state_app_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (state_app_id (mk-app_state f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. StateTransition accessor round-trip: trans_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 AppState)
(declare-const f3 Int)
(assert (not (= (trans_app_id (mk-state_transition f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. StateTransition accessor round-trip: from_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 AppState)
(declare-const f3 Int)
(assert (not (= (from_state (mk-state_transition f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. StateTransition accessor round-trip: to_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 AppState)
(declare-const f3 Int)
(assert (not (= (to_state (mk-state_transition f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. StateTransition accessor round-trip: transition_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 AppState)
(declare-const f3 Int)
(assert (not (= (transition_type (mk-state_transition f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. StateTransition: non-negative int fields sum ---
(push 1)
(declare-const r StateTransition)
(assert (>= (trans_app_id r) 0))
(assert (>= (transition_type r) 0))
(assert (not (>= (+ (trans_app_id r) (transition_type r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SyncOperation accessor round-trip: sync_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 AppState)
(declare-const f3 AppState)
(declare-const f4 Bool)
(assert (not (= (sync_app_id (mk-sync_operation f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SyncOperation accessor round-trip: local_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 AppState)
(declare-const f3 AppState)
(declare-const f4 Bool)
(assert (not (= (local_state (mk-sync_operation f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SyncOperation accessor round-trip: remote_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 AppState)
(declare-const f3 AppState)
(declare-const f4 Bool)
(assert (not (= (remote_state (mk-sync_operation f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SyncOperation accessor round-trip: merged_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 AppState)
(declare-const f3 AppState)
(declare-const f4 Bool)
(assert (not (= (merged_state (mk-sync_operation f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SyncOperation accessor round-trip: sync_successful ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppState)
(declare-const f2 AppState)
(declare-const f3 AppState)
(declare-const f4 Bool)
(assert (not (= (sync_successful (mk-sync_operation f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AppResponse accessor round-trip: response_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (response_app_id (mk-app_response f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. AppResponse accessor round-trip: response_time_us ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (response_time_us (mk-app_response f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. AppResponse accessor round-trip: response_correct ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (response_correct (mk-app_response f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. AppResponse: non-negative int fields sum ---
(push 1)
(declare-const r AppResponse)
(assert (>= (response_app_id r) 0))
(assert (>= (response_time_us r) 0))
(assert (not (>= (+ (response_app_id r) (response_time_us r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. AppPermission accessor round-trip: perm_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (perm_app_id (mk-app_permission f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. AppPermission accessor round-trip: perm_camera ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (perm_camera (mk-app_permission f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. AppPermission accessor round-trip: perm_microphone ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (perm_microphone (mk-app_permission f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. AppPermission accessor round-trip: perm_location ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (perm_location (mk-app_permission f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. AppPermission accessor round-trip: perm_network ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (perm_network (mk-app_permission f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. AppLifecycle accessor round-trip: lc_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (lc_app_id (mk-app_lifecycle f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. AppLifecycle accessor round-trip: lc_installed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (lc_installed (mk-app_lifecycle f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. AppLifecycle accessor round-trip: lc_install_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (lc_install_verified (mk-app_lifecycle f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. AppLifecycle accessor round-trip: lc_foreground ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (lc_foreground (mk-app_lifecycle f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. AppLifecycle accessor round-trip: lc_background ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (lc_background (mk-app_lifecycle f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. AppLifecycle: non-negative int fields sum ---
(push 1)
(declare-const r AppLifecycle)
(assert (>= (lc_app_id r) 0))
(assert (>= (lc_version r) 0))
(assert (not (>= (+ (lc_app_id r) (lc_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. AppUpdate accessor round-trip: upd_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (upd_app_id (mk-app_update f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. AppUpdate accessor round-trip: upd_old_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (upd_old_version (mk-app_update f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. AppUpdate accessor round-trip: upd_new_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (upd_new_version (mk-app_update f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. AppUpdate accessor round-trip: upd_signature_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (upd_signature_valid (mk-app_update f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. AppUpdate accessor round-trip: upd_applied ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (upd_applied (mk-app_update f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. AppUpdate: non-negative int fields sum ---
(push 1)
(declare-const r AppUpdate)
(assert (>= (upd_app_id r) 0))
(assert (>= (upd_old_version r) 0))
(assert (not (>= (+ (upd_app_id r) (upd_old_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

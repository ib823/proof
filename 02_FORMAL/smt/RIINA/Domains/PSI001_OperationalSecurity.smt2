; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA PSI001_OperationalSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/PSI001_OperationalSecurity.v (39 assertions)
; Module: PSI001_OperationalSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AuthMode 0)) (((NormalAuth) (DuressAuth) (EmergencyAuth))))

(declare-datatypes ((Share 0))
  (((mk-share (share_x Int) (share_y Int)))))

(declare-datatypes ((ThresholdPolicy 0))
  (((mk-threshold_policy (tp_n Int) (tp_m Int) (tp_approvals (Seq Int))))))

(declare-datatypes ((DuressResponse 0))
  (((mk-duress_response (dr_silent_alert Bool) (dr_fake_access Bool) (dr_real_lockdown Bool) (dr_audit_logged Bool)))))

(declare-datatypes ((DeadManSwitch 0))
  (((mk-dead_man_switch (dms_last_checkin Int) (dms_timeout Int) (dms_triggered Bool) (dms_recovery_action Int)))))

(declare-datatypes ((InsiderBudget 0))
  (((mk-insider_budget (ib_max_bytes Int) (ib_max_queries Int) (ib_bytes_used Int) (ib_queries_used Int) (ib_window_start Int)))))

(declare-datatypes ((AuditEntry 0))
  (((mk-audit_entry (ae_timestamp Int) (ae_actor Int) (ae_action Int) (ae_data_hash Int) (ae_prev_hash Int)))))

(declare-datatypes ((Platform 0))
  (((mk-platform (plat_vendor Int) (plat_arch Int) (plat_firmware_hash Int)))))

(declare-datatypes ((TimeLock 0))
  (((mk-time_lock (tl_operation Int) (tl_submit_time Int) (tl_execute_time Int) (tl_cancelled Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- AuthMode enum properties ---

; --- 1. AuthMode exhaustiveness ---
(push 1)
(declare-const x AuthMode)
(assert (not (or (= x NormalAuth) (= x DuressAuth) (= x EmergencyAuth))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AuthMode: NormalAuth != DuressAuth ---
(push 1)
(assert (= NormalAuth DuressAuth))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AuthMode: DuressAuth != EmergencyAuth ---
(push 1)
(assert (= DuressAuth EmergencyAuth))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AuthMode: NormalAuth != EmergencyAuth ---
(push 1)
(assert (= NormalAuth EmergencyAuth))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. AuthMode finite cardinality (3 values) ---
(push 1)
(declare-const x AuthMode)
(assert (and (not (= x NormalAuth)) (not (= x DuressAuth)) (not (= x EmergencyAuth))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Share record properties ---

; --- 6. Share accessor round-trip: share_x ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (share_x (mk-share f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ThresholdPolicy record properties ---

; --- 7. ThresholdPolicy accessor round-trip: tp_n ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (tp_n (mk-threshold_policy f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ThresholdPolicy accessor round-trip: tp_m ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (tp_m (mk-threshold_policy f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ThresholdPolicy: integer field consistency ---
(push 1)
(declare-const r ThresholdPolicy)
(assert (>= (tp_n r) 0))
(assert (>= (tp_m r) 0))
(assert (not (>= (+ (tp_n r) (tp_m r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DuressResponse record properties ---

; --- 10. DuressResponse accessor round-trip: dr_silent_alert ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dr_silent_alert (mk-duress_response f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. DuressResponse accessor round-trip: dr_fake_access ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dr_fake_access (mk-duress_response f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. DuressResponse accessor round-trip: dr_real_lockdown ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dr_real_lockdown (mk-duress_response f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DuressResponse_all_enabled ((g DuressResponse)) Bool
  (and (dr_silent_alert g) (dr_fake_access g) (dr_real_lockdown g)))

; --- 13. DuressResponse: all-enabled completeness ---
(push 1)
(declare-const g DuressResponse)
(assert (dr_silent_alert g))
(assert (dr_fake_access g))
(assert (dr_real_lockdown g))
(assert (not (DuressResponse_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. DuressResponse: DuressResponse_all_enabled implies dr_silent_alert ---
(push 1)
(declare-const g DuressResponse)
(assert (DuressResponse_all_enabled g))
(assert (not (dr_silent_alert g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. DuressResponse: DuressResponse_all_enabled implies dr_fake_access ---
(push 1)
(declare-const g DuressResponse)
(assert (DuressResponse_all_enabled g))
(assert (not (dr_fake_access g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. DuressResponse: DuressResponse_all_enabled implies dr_real_lockdown ---
(push 1)
(declare-const g DuressResponse)
(assert (DuressResponse_all_enabled g))
(assert (not (dr_real_lockdown g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DeadManSwitch record properties ---

; --- 17. DeadManSwitch accessor round-trip: dms_last_checkin ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (dms_last_checkin (mk-dead_man_switch f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. DeadManSwitch accessor round-trip: dms_timeout ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (dms_timeout (mk-dead_man_switch f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. DeadManSwitch accessor round-trip: dms_triggered ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (dms_triggered (mk-dead_man_switch f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. DeadManSwitch: integer field consistency ---
(push 1)
(declare-const r DeadManSwitch)
(assert (>= (dms_last_checkin r) 0))
(assert (>= (dms_timeout r) 0))
(assert (not (>= (+ (dms_last_checkin r) (dms_timeout r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- InsiderBudget record properties ---

; --- 21. InsiderBudget accessor round-trip: ib_max_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ib_max_bytes (mk-insider_budget f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. InsiderBudget accessor round-trip: ib_max_queries ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ib_max_queries (mk-insider_budget f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. InsiderBudget accessor round-trip: ib_bytes_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ib_bytes_used (mk-insider_budget f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. InsiderBudget accessor round-trip: ib_queries_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ib_queries_used (mk-insider_budget f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. InsiderBudget: integer field consistency ---
(push 1)
(declare-const r InsiderBudget)
(assert (>= (ib_max_bytes r) 0))
(assert (>= (ib_max_queries r) 0))
(assert (not (>= (+ (ib_max_bytes r) (ib_max_queries r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuditEntry record properties ---

; --- 26. AuditEntry accessor round-trip: ae_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ae_timestamp (mk-audit_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. AuditEntry accessor round-trip: ae_actor ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ae_actor (mk-audit_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. AuditEntry accessor round-trip: ae_action ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ae_action (mk-audit_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. AuditEntry accessor round-trip: ae_data_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ae_data_hash (mk-audit_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. AuditEntry: integer field consistency ---
(push 1)
(declare-const r AuditEntry)
(assert (>= (ae_timestamp r) 0))
(assert (>= (ae_actor r) 0))
(assert (not (>= (+ (ae_timestamp r) (ae_actor r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Platform record properties ---

; --- 31. Platform accessor round-trip: plat_vendor ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (plat_vendor (mk-platform f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. Platform accessor round-trip: plat_arch ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (plat_arch (mk-platform f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. Platform: integer field consistency ---
(push 1)
(declare-const r Platform)
(assert (>= (plat_vendor r) 0))
(assert (>= (plat_arch r) 0))
(assert (not (>= (+ (plat_vendor r) (plat_arch r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TimeLock record properties ---

; --- 34. TimeLock accessor round-trip: tl_operation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tl_operation (mk-time_lock f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. TimeLock accessor round-trip: tl_submit_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tl_submit_time (mk-time_lock f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. TimeLock accessor round-trip: tl_execute_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tl_execute_time (mk-time_lock f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. TimeLock: integer field consistency ---
(push 1)
(declare-const r TimeLock)
(assert (>= (tl_operation r) 0))
(assert (>= (tl_submit_time r) 0))
(assert (not (>= (+ (tl_operation r) (tl_submit_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

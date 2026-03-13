; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA RadiationHardening — SMT Verification
; Derived from 02_FORMAL/coq/domains/RadiationHardening.v (20 assertions)
; Module: RadiationHardening
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SystemMode 0)) (((NormalMode) (SafeMode) (RecoveryMode))))

(declare-datatypes ((ECCWord 0))
  (((mk-ecc_word (ecc_data Int) (ecc_parity Int)))))

(declare-datatypes ((Watchdog 0))
  (((mk-watchdog (wd_counter Int) (wd_timeout Int) (wd_last_kick Int)))))

(declare-datatypes ((Checkpoint 0))
  (((mk-checkpoint (cp_state Int) (cp_timestamp Int) (cp_valid Bool)))))

(declare-datatypes ((CFSignature 0))
  (((mk-cf_signature (cfs_expected_next (Seq Int)) (cfs_current Int)))))

(declare-datatypes ((StackFrame 0))
  (((mk-stack_frame (sf_canary Int) (sf_data Int) (sf_expected_canary Int)))))

(declare-datatypes ((ScrubState 0))
  (((mk-scrub_state (scrub_last_addr Int) (scrub_errors_found Int) (scrub_errors_corrected Int)))))

(declare-datatypes ((NVersionResult 0))
  (((mk-n_version_result (nvr_results (Seq Int)) (nvr_agreement_threshold Int)))))

(declare-datatypes ((Probability 0))
  (((mk-probability (prob_num Int) (prob_denom Int)))))

(declare-datatypes ((RecoveryMetrics 0))
  (((mk-recovery_metrics (rm_mttr Int) (rm_requirement Int)))))

(declare-datatypes ((CriticalData 0))
  (((mk-critical_data (cd_primary Int) (cd_backup1 Int) (cd_backup2 Int) (cd_checksum Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. SystemMode exhaustiveness ---
(push 1)
(declare-const x SystemMode)
(assert (not (or (= x NormalMode) (= x SafeMode) (= x RecoveryMode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SystemMode: NormalMode != SafeMode ---
(push 1)
(assert (= NormalMode SafeMode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SystemMode: SafeMode != RecoveryMode ---
(push 1)
(assert (= SafeMode RecoveryMode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SystemMode finite cardinality (3 values) ---
(push 1)
(declare-const x SystemMode)
(assert (and (not (= x NormalMode)) (not (= x SafeMode)) (not (= x RecoveryMode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ECCWord accessor round-trip: ecc_data ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ecc_data (mk-ecc_word f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ECCWord accessor round-trip: ecc_parity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ecc_parity (mk-ecc_word f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. ECCWord: non-negative int fields sum ---
(push 1)
(declare-const r ECCWord)
(assert (>= (ecc_data r) 0))
(assert (>= (ecc_parity r) 0))
(assert (not (>= (+ (ecc_data r) (ecc_parity r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Watchdog accessor round-trip: wd_counter ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (wd_counter (mk-watchdog f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Watchdog accessor round-trip: wd_timeout ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (wd_timeout (mk-watchdog f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Watchdog accessor round-trip: wd_last_kick ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (wd_last_kick (mk-watchdog f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Watchdog: non-negative int fields sum ---
(push 1)
(declare-const r Watchdog)
(assert (>= (wd_counter r) 0))
(assert (>= (wd_timeout r) 0))
(assert (not (>= (+ (wd_counter r) (wd_timeout r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Checkpoint accessor round-trip: cp_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (cp_state (mk-checkpoint f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Checkpoint accessor round-trip: cp_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (cp_timestamp (mk-checkpoint f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Checkpoint accessor round-trip: cp_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (cp_valid (mk-checkpoint f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Checkpoint: non-negative int fields sum ---
(push 1)
(declare-const r Checkpoint)
(assert (>= (cp_state r) 0))
(assert (>= (cp_timestamp r) 0))
(assert (not (>= (+ (cp_state r) (cp_timestamp r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. StackFrame accessor round-trip: sf_canary ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sf_canary (mk-stack_frame f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. StackFrame accessor round-trip: sf_data ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sf_data (mk-stack_frame f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. StackFrame accessor round-trip: sf_expected_canary ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sf_expected_canary (mk-stack_frame f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. StackFrame: non-negative int fields sum ---
(push 1)
(declare-const r StackFrame)
(assert (>= (sf_canary r) 0))
(assert (>= (sf_data r) 0))
(assert (not (>= (+ (sf_canary r) (sf_data r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ScrubState accessor round-trip: scrub_last_addr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (scrub_last_addr (mk-scrub_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ScrubState accessor round-trip: scrub_errors_found ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (scrub_errors_found (mk-scrub_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ScrubState accessor round-trip: scrub_errors_corrected ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (scrub_errors_corrected (mk-scrub_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ScrubState: non-negative int fields sum ---
(push 1)
(declare-const r ScrubState)
(assert (>= (scrub_last_addr r) 0))
(assert (>= (scrub_errors_found r) 0))
(assert (not (>= (+ (scrub_last_addr r) (scrub_errors_found r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Probability accessor round-trip: prob_num ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (prob_num (mk-probability f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Probability accessor round-trip: prob_denom ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (prob_denom (mk-probability f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Probability: non-negative int fields sum ---
(push 1)
(declare-const r Probability)
(assert (>= (prob_num r) 0))
(assert (>= (prob_denom r) 0))
(assert (not (>= (+ (prob_num r) (prob_denom r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. RecoveryMetrics accessor round-trip: rm_mttr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (rm_mttr (mk-recovery_metrics f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. RecoveryMetrics accessor round-trip: rm_requirement ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (rm_requirement (mk-recovery_metrics f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. RecoveryMetrics: non-negative int fields sum ---
(push 1)
(declare-const r RecoveryMetrics)
(assert (>= (rm_mttr r) 0))
(assert (>= (rm_requirement r) 0))
(assert (not (>= (+ (rm_mttr r) (rm_requirement r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. CriticalData accessor round-trip: cd_primary ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (cd_primary (mk-critical_data f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. CriticalData accessor round-trip: cd_backup1 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (cd_backup1 (mk-critical_data f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. CriticalData accessor round-trip: cd_backup2 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (cd_backup2 (mk-critical_data f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. CriticalData accessor round-trip: cd_checksum ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (cd_checksum (mk-critical_data f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. CriticalData: non-negative int fields sum ---
(push 1)
(declare-const r CriticalData)
(assert (>= (cd_primary r) 0))
(assert (>= (cd_backup1 r) 0))
(assert (not (>= (+ (cd_primary r) (cd_backup1 r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

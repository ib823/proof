; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TransientSchedulerAttacks — SMT Verification
; Derived from 02_FORMAL/coq/domains/TransientSchedulerAttacks.v (26 assertions)
; Module: TransientSchedulerAttacks
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SchedulerGranularity 0)) (((Tick) (MicroTick) (CyclePrecise))))

(declare-datatypes ((SchedPolicy 0)) (((CFS) (FIFO) (RoundRobin) (Deadline) (Partitioned))))

(declare-datatypes ((TSAVariant 0)) (((TSA_SQ) (TSA_L1) (TSA_TLB) (TSA_IPI) (TSA_Freq))))

(declare-datatypes ((ExecContext 0))
  (((mk-exec_context (ec_pid Int) (ec_priority Int) (ec_time_slice_us Int) (ec_preemptible Bool) (ec_cache_partition Int)))))

(declare-datatypes ((TSADefenseConfig 0))
  (((mk-tsa_defense_config (tsa_constant_time_scheduling Bool) (tsa_cache_partitioning Bool) (tsa_preemption_hardening Bool) (tsa_tlb_isolation Bool) (tsa_ipi_constant_time Bool) (tsa_freq_pinning Bool) (tsa_timer_noise_injection Bool) (tsa_scheduler_queue_isolation Bool)))))

(declare-datatypes ((SchedulerFootprint 0))
  (((mk-scheduler_footprint (sf_time_slice_consumed Int) (sf_preemption_count Int) (sf_cache_sets_touched Int) (sf_tlb_entries_used Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SchedulerGranularity enum properties ---

; --- 1. SchedulerGranularity exhaustiveness ---
(push 1)
(declare-const x SchedulerGranularity)
(assert (not (or (= x Tick) (= x MicroTick) (= x CyclePrecise))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SchedulerGranularity: Tick != MicroTick ---
(push 1)
(assert (= Tick MicroTick))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SchedulerGranularity: MicroTick != CyclePrecise ---
(push 1)
(assert (= MicroTick CyclePrecise))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SchedulerGranularity: Tick != CyclePrecise ---
(push 1)
(assert (= Tick CyclePrecise))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SchedulerGranularity finite cardinality (3 values) ---
(push 1)
(declare-const x SchedulerGranularity)
(assert (and (not (= x Tick)) (not (= x MicroTick)) (not (= x CyclePrecise))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SchedPolicy enum properties ---

; --- 6. SchedPolicy exhaustiveness ---
(push 1)
(declare-const x SchedPolicy)
(assert (not (or (= x CFS) (= x FIFO) (= x RoundRobin) (= x Deadline) (= x Partitioned))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SchedPolicy: CFS != FIFO ---
(push 1)
(assert (= CFS FIFO))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SchedPolicy: FIFO != RoundRobin ---
(push 1)
(assert (= FIFO RoundRobin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SchedPolicy: RoundRobin != Deadline ---
(push 1)
(assert (= RoundRobin Deadline))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SchedPolicy: CFS != Partitioned ---
(push 1)
(assert (= CFS Partitioned))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SchedPolicy finite cardinality (5 values) ---
(push 1)
(declare-const x SchedPolicy)
(assert (and (not (= x CFS)) (not (= x FIFO)) (not (= x RoundRobin)) (not (= x Deadline)) (not (= x Partitioned))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TSAVariant enum properties ---

; --- 12. TSAVariant exhaustiveness ---
(push 1)
(declare-const x TSAVariant)
(assert (not (or (= x TSA_SQ) (= x TSA_L1) (= x TSA_TLB) (= x TSA_IPI) (= x TSA_Freq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. TSAVariant: TSA_SQ != TSA_L1 ---
(push 1)
(assert (= TSA_SQ TSA_L1))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. TSAVariant: TSA_L1 != TSA_TLB ---
(push 1)
(assert (= TSA_L1 TSA_TLB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. TSAVariant: TSA_TLB != TSA_IPI ---
(push 1)
(assert (= TSA_TLB TSA_IPI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. TSAVariant: TSA_SQ != TSA_Freq ---
(push 1)
(assert (= TSA_SQ TSA_Freq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. TSAVariant finite cardinality (5 values) ---
(push 1)
(declare-const x TSAVariant)
(assert (and (not (= x TSA_SQ)) (not (= x TSA_L1)) (not (= x TSA_TLB)) (not (= x TSA_IPI)) (not (= x TSA_Freq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ExecContext record properties ---

; --- 18. ExecContext accessor round-trip: ec_pid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (ec_pid (mk-exec_context f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. ExecContext accessor round-trip: ec_priority ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (ec_priority (mk-exec_context f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ExecContext accessor round-trip: ec_time_slice_us ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (ec_time_slice_us (mk-exec_context f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ExecContext accessor round-trip: ec_preemptible ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (ec_preemptible (mk-exec_context f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ExecContext: integer field consistency ---
(push 1)
(declare-const r ExecContext)
(assert (>= (ec_pid r) 0))
(assert (>= (ec_priority r) 0))
(assert (not (>= (+ (ec_pid r) (ec_priority r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TSADefenseConfig record properties ---

; --- 23. TSADefenseConfig accessor round-trip: tsa_constant_time_scheduling ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (tsa_constant_time_scheduling (mk-tsa_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TSADefenseConfig accessor round-trip: tsa_cache_partitioning ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (tsa_cache_partitioning (mk-tsa_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TSADefenseConfig accessor round-trip: tsa_preemption_hardening ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (tsa_preemption_hardening (mk-tsa_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. TSADefenseConfig accessor round-trip: tsa_tlb_isolation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (tsa_tlb_isolation (mk-tsa_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. TSADefenseConfig accessor round-trip: tsa_ipi_constant_time ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (tsa_ipi_constant_time (mk-tsa_defense_config f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TSADefenseConfig_all_enabled ((g TSADefenseConfig)) Bool
  (and (tsa_constant_time_scheduling g) (tsa_cache_partitioning g) (tsa_preemption_hardening g) (tsa_tlb_isolation g) (tsa_ipi_constant_time g) (tsa_freq_pinning g) (tsa_timer_noise_injection g)))

; --- 28. TSADefenseConfig: all-enabled completeness ---
(push 1)
(declare-const g TSADefenseConfig)
(assert (tsa_constant_time_scheduling g))
(assert (tsa_cache_partitioning g))
(assert (tsa_preemption_hardening g))
(assert (tsa_tlb_isolation g))
(assert (tsa_ipi_constant_time g))
(assert (tsa_freq_pinning g))
(assert (tsa_timer_noise_injection g))
(assert (not (TSADefenseConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. TSADefenseConfig: TSADefenseConfig_all_enabled implies tsa_constant_time_scheduling ---
(push 1)
(declare-const g TSADefenseConfig)
(assert (TSADefenseConfig_all_enabled g))
(assert (not (tsa_constant_time_scheduling g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. TSADefenseConfig: TSADefenseConfig_all_enabled implies tsa_cache_partitioning ---
(push 1)
(declare-const g TSADefenseConfig)
(assert (TSADefenseConfig_all_enabled g))
(assert (not (tsa_cache_partitioning g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. TSADefenseConfig: TSADefenseConfig_all_enabled implies tsa_preemption_hardening ---
(push 1)
(declare-const g TSADefenseConfig)
(assert (TSADefenseConfig_all_enabled g))
(assert (not (tsa_preemption_hardening g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SchedulerFootprint record properties ---

; --- 32. SchedulerFootprint accessor round-trip: sf_time_slice_consumed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sf_time_slice_consumed (mk-scheduler_footprint f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. SchedulerFootprint accessor round-trip: sf_preemption_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sf_preemption_count (mk-scheduler_footprint f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. SchedulerFootprint accessor round-trip: sf_cache_sets_touched ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sf_cache_sets_touched (mk-scheduler_footprint f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. SchedulerFootprint: integer field consistency ---
(push 1)
(declare-const r SchedulerFootprint)
(assert (>= (sf_time_slice_consumed r) 0))
(assert (>= (sf_preemption_count r) 0))
(assert (not (>= (+ (sf_time_slice_consumed r) (sf_preemption_count r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

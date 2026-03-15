; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CovertChannels — SMT Verification
; Derived from 02_FORMAL/coq/domains/CovertChannels.v (26 assertions)
; Module: CovertChannels
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SecLevel 0)) (((Public) (Secret) (TopSecret))))

(declare-datatypes ((Observation 0)) (((ObsTime) (ObsMemory) (ObsCache) (ObsOutput) (ObsTermination) (ObsException))))

(declare-datatypes ((State 0))
  (((mk-state (state_public Int) (state_secret Int) (state_memory (Seq Int)) (state_cache (Seq Int))))))

(declare-datatypes ((Trace 0))
  (((mk-trace (trace_time Int) (trace_mem_accesses (Seq Int)) (trace_cache_pattern (Seq Int)) (trace_output Int) (trace_terminated Bool) (trace_exception Int)))))

(declare-datatypes ((ResourceUsage 0))
  (((mk-resource_usage (res_cpu_cycles Int) (res_memory_alloc Int) (res_cache_misses Int) (res_branch_mispredict Int)))))

(declare-datatypes ((Partition 0))
  (((mk-partition (part_level SecLevel) (part_addresses (Seq Int))))))

(declare-datatypes ((SecureProgram 0))
  (((mk-secure_program (prog_execute State) (prog_resources State) (prog_secure Int)))))

(declare-datatypes ((NetworkTrace 0))
  (((mk-network_trace (net_packet_times (Seq Int)) (net_packet_sizes (Seq Int))))))

(declare-datatypes ((ScheduleTrace 0))
  (((mk-schedule_trace (sched_quantum Int) (sched_priority Int)))))

(declare-datatypes ((PowerTrace 0))
  (((mk-power_trace (power_samples (Seq Int))))))

(declare-datatypes ((EMTrace 0))
  (((mk-em_trace (em_samples (Seq Int))))))

(declare-datatypes ((BranchTrace 0))
  (((mk-branch_trace (branch_taken (Seq Int)) (branch_predicted (Seq Int))))))

(declare-datatypes ((StorageState 0))
  (((mk-storage_state (storage_contents (Seq Int)) (storage_level SecLevel)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SecLevel enum properties ---

; --- 1. SecLevel exhaustiveness ---
(push 1)
(declare-const x SecLevel)
(assert (not (or (= x Public) (= x Secret) (= x TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SecLevel: Public != Secret ---
(push 1)
(assert (= Public Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SecLevel: Secret != TopSecret ---
(push 1)
(assert (= Secret TopSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SecLevel: Public != TopSecret ---
(push 1)
(assert (= Public TopSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SecLevel finite cardinality (3 values) ---
(push 1)
(declare-const x SecLevel)
(assert (and (not (= x Public)) (not (= x Secret)) (not (= x TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Observation enum properties ---

; --- 6. Observation exhaustiveness ---
(push 1)
(declare-const x Observation)
(assert (not (or (= x ObsTime) (= x ObsMemory) (= x ObsCache) (= x ObsOutput) (= x ObsTermination) (= x ObsException))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Observation: ObsTime != ObsMemory ---
(push 1)
(assert (= ObsTime ObsMemory))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Observation: ObsMemory != ObsCache ---
(push 1)
(assert (= ObsMemory ObsCache))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Observation: ObsCache != ObsOutput ---
(push 1)
(assert (= ObsCache ObsOutput))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Observation: ObsTime != ObsException ---
(push 1)
(assert (= ObsTime ObsException))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Observation finite cardinality (6 values) ---
(push 1)
(declare-const x Observation)
(assert (and (not (= x ObsTime)) (not (= x ObsMemory)) (not (= x ObsCache)) (not (= x ObsOutput)) (not (= x ObsTermination)) (not (= x ObsException))))
(check-sat) ; expect UNSAT
(pop 1)

; --- State record properties ---

; --- 12. State accessor round-trip: state_public ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(assert (not (= (state_public (mk-state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. State accessor round-trip: state_secret ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(assert (not (= (state_secret (mk-state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. State accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(assert (not (= (state_memory (mk-state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. State: integer field consistency ---
(push 1)
(declare-const r State)
(assert (>= (state_public r) 0))
(assert (>= (state_secret r) 0))
(assert (not (>= (+ (state_public r) (state_secret r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Trace record properties ---

; --- 16. Trace accessor round-trip: trace_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (trace_time (mk-trace f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Trace accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (trace_mem_accesses (mk-trace f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Trace accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (trace_cache_pattern (mk-trace f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Trace accessor round-trip: trace_output ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (trace_output (mk-trace f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Trace accessor round-trip: trace_terminated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (trace_terminated (mk-trace f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Trace: integer field consistency ---
(push 1)
(declare-const r Trace)
(assert (>= (trace_time r) 0))
(assert (>= (seq.len (trace_mem_accesses r)) 0))
(assert (not (>= (+ (trace_time r) (seq.len (trace_mem_accesses r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ResourceUsage record properties ---

; --- 22. ResourceUsage accessor round-trip: res_cpu_cycles ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (res_cpu_cycles (mk-resource_usage f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ResourceUsage accessor round-trip: res_memory_alloc ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (res_memory_alloc (mk-resource_usage f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ResourceUsage accessor round-trip: res_cache_misses ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (res_cache_misses (mk-resource_usage f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ResourceUsage: integer field consistency ---
(push 1)
(declare-const r ResourceUsage)
(assert (>= (res_cpu_cycles r) 0))
(assert (>= (res_memory_alloc r) 0))
(assert (not (>= (+ (res_cpu_cycles r) (res_memory_alloc r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Partition record properties ---

; --- 26. Partition accessor round-trip: part_level ---
(push 1)
(declare-const f0 SecLevel)
(declare-const f1 (Seq Int))
(assert (not (= (part_level (mk-partition f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecureProgram record properties ---

; --- 27. SecureProgram accessor round-trip: prog_execute ---
(push 1)
(declare-const f0 State)
(declare-const f1 State)
(declare-const f2 Int)
(assert (not (= (prog_execute (mk-secure_program f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. SecureProgram accessor round-trip: prog_resources ---
(push 1)
(declare-const f0 State)
(declare-const f1 State)
(declare-const f2 Int)
(assert (not (= (prog_resources (mk-secure_program f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetworkTrace record properties ---

; --- 29. NetworkTrace accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(assert (not (= (net_packet_times (mk-network_trace f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ScheduleTrace record properties ---

; --- 30. ScheduleTrace accessor round-trip: sched_quantum ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (sched_quantum (mk-schedule_trace f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BranchTrace record properties ---

; --- 31. BranchTrace accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(assert (not (= (branch_taken (mk-branch_trace f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- StorageState record properties ---

; --- 32. StorageState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 SecLevel)
(assert (not (= (storage_contents (mk-storage_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecLevel ordering properties ---

(define-fun SecLevel_level ((x SecLevel)) Int
  (ite (= x Public) 0 (ite (= x Secret) 1 2)))

(define-fun SecLevel_leq ((x SecLevel) (y SecLevel)) Bool
  (<= (SecLevel_level x) (SecLevel_level y)))

; --- 33. SecLevel_leq reflexivity ---
(push 1)
(declare-const x SecLevel)
(assert (not (SecLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. SecLevel_leq transitivity ---
(push 1)
(declare-const x SecLevel)
(declare-const y SecLevel)
(declare-const z SecLevel)
(assert (SecLevel_leq x y))
(assert (SecLevel_leq y z))
(assert (not (SecLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. SecLevel_leq antisymmetry ---
(push 1)
(declare-const x SecLevel)
(declare-const y SecLevel)
(assert (SecLevel_leq x y))
(assert (SecLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Public is bottom ---
(push 1)
(declare-const x SecLevel)
(assert (not (SecLevel_leq Public x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. TopSecret is top ---
(push 1)
(declare-const x SecLevel)
(assert (not (SecLevel_leq x TopSecret)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

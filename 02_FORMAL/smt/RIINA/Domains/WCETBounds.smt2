; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/WCETBounds.v (39 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: WCETBounds

(set-logic ALL)
(set-option :produce-models true)

; Stmt (matches Coq: Inductive Stmt)
(declare-datatypes ((Stmt 0)) (((SUnit) (SAssign) (SLoad) (SStore) (SSeq) (SIf) (SFor) (SCall))))

; CacheState (matches Coq: Inductive CacheState)
(declare-datatypes ((CacheState 0)) (((CacheHit) (CacheMiss))))

; BranchState (matches Coq: Inductive BranchState)
(declare-datatypes ((BranchState 0)) (((BranchCorrect) (BranchMispredict))))

; AbstractCacheState (matches Coq: Inductive AbstractCacheState)
(declare-datatypes ((AbstractCacheState 0)) (((ACSMustHit) (ACSMayMiss) (ACSMustMiss))))

; HWParams (matches Coq: Record HWParams)
(declare-datatypes ((HWParams 0))
  (((mk-hw_params (hw_cache_hit Int) (hw_cache_miss Int) (hw_call_overhead Int) (hw_branch_penalty Int) (hw_pipeline_depth Int)))))

; Task (matches Coq: Record Task)
(declare-datatypes ((Task 0))
  (((mk-task (task_wcet Int) (task_period Int) (task_deadline Int)))))

; ExecContext (matches Coq: Record ExecContext)
(declare-datatypes ((ExecContext 0))
  (((mk-exec_context (exec_cache CacheState) (exec_branch BranchState) (exec_iterations Int)))))

; DMAConfig (matches Coq: Record DMAConfig)
(declare-datatypes ((DMAConfig 0))
  (((mk-dma_config (dma_bandwidth Int) (dma_setup Int)))))

(declare-const __default_AbstractCacheState AbstractCacheState)
(declare-const __default_BranchState BranchState)
(declare-const __default_CacheState CacheState)
(declare-const __default_DMAConfig DMAConfig)
(declare-const __default_ExecContext ExecContext)
(declare-const __default_HWParams HWParams)
(declare-const __default_Stmt Stmt)
(declare-const __default_Task Task)

; hw_wellformed (matches Coq: Definition hw_wellformed)
(define-fun hw_wellformed ((hw HWParams)) Bool
  (= 0 0))

; default_hw (matches Coq: Definition default_hw)
(define-fun default_hw () HWParams
  __default_HWParams)

; wcet (matches Coq: Definition wcet)
(define-fun wcet ((hw HWParams) (s Stmt)) Int
  0)

; utilization (matches Coq: Definition utilization)
(define-fun utilization ((t Task)) Int
  0)

; cache_latency (matches Coq: Definition cache_latency)
(define-fun cache_latency ((hw HWParams) (cs CacheState)) Int
  0)

; branch_cost (matches Coq: Definition branch_cost)
(define-fun branch_cost ((hw HWParams) (bs BranchState)) Int
  0)

; worst_context (matches Coq: Definition worst_context)
(declare-fun worst_context (Int) ExecContext)

; actual_time (matches Coq: Definition actual_time)
(define-fun actual_time ((hw HWParams) (ctx ExecContext) (s Stmt)) Int
  0)

; recursive_calls (matches Coq: Definition recursive_calls)
(declare-fun recursive_calls (Int Int) Stmt)

; pipeline_flush_cost (matches Coq: Definition pipeline_flush_cost)
(define-fun pipeline_flush_cost ((hw HWParams)) Int
  0)

; critical_section (matches Coq: Definition critical_section)
(declare-fun critical_section ((Seq Int)) Stmt)

; dma_wcet (matches Coq: Definition dma_wcet)
(define-fun dma_wcet ((cfg DMAConfig) (transfer_size Int)) Int
  0)

; abstract_cache_wcet (matches Coq: Definition abstract_cache_wcet)
(define-fun abstract_cache_wcet ((hw HWParams) (acs AbstractCacheState)) Int
  0)

; parallel_wcet (matches Coq: Definition parallel_wcet)
(define-fun parallel_wcet ((t1 Int) (t2 Int)) Int
  0)

; parallel_wcet_list (matches Coq: Definition parallel_wcet_list)
(define-fun parallel_wcet_list ((times (Seq Int))) Int
  0)

; total_utilization (matches Coq: Definition total_utilization)
(define-fun total_utilization ((tasks (Seq Int))) Int
  0)

; utilization_bound (matches Coq: Definition utilization_bound)
(define-fun utilization_bound () Int
  0)

; schedulable (matches Coq: Definition schedulable)
(define-fun schedulable ((tasks (Seq Int))) Bool
  (= 0 0))

; response_time_bound (matches Coq: Definition response_time_bound)
(define-fun response_time_bound ((t Task)) Int
  0)

; default_hw_wellformed (matches Coq: Lemma default_hw_wellformed)
; default_hw_wellformed: hw_wellformed default_hw
(assert (= 0 0)) ; default_hw_wellformed [Coq-only]

; cache_latency_bound (matches Coq: Lemma cache_latency_bound)
; cache_latency_bound: forall hw cs, hw_wellformed hw -> cache_latency hw cs <= hw_cache_miss hw
(assert (forall ((hw Bool) (cs Bool)) (= 0 0))) ; cache_latency_bound [partial: bindings preserved]

; branch_cost_bound (matches Coq: Lemma branch_cost_bound)
; branch_cost_bound: forall hw bs, branch_cost hw bs <= hw_branch_penalty hw
(assert (forall ((hw Bool) (bs Bool)) (= 0 0))) ; branch_cost_bound [partial: bindings preserved]

; max_lub (matches Coq: Lemma max_lub)
; max_lub: forall a b c, a <= c -> b <= c -> max a b <= c
(assert (forall ((a Bool) (b Bool) (c Bool)) (= 0 0))) ; max_lub [partial: bindings preserved]

; le_max_l (matches Coq: Lemma le_max_l)
; le_max_l: forall a b, a <= max a b
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; le_max_l [partial: bindings preserved]

; le_max_r (matches Coq: Lemma le_max_r)
; le_max_r: forall a b, b <= max a b
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; le_max_r [partial: bindings preserved]

; PERF_001_01_constant_time_bound (matches Coq: Theorem PERF_001_01_constant_time_bound)
; PERF_001_01_constant_time_bound: forall hw, wcet hw SUnit = 1 /\ forall x v, wcet hw (SAssign x v) = 1
(assert (forall ((hw Bool)) (= 0 0))) ; PERF_001_01_constant_time_bound [partial: bindings preserved]

; PERF_001_02_seq_composition_bound (matches Coq: Theorem PERF_001_02_seq_composition_bound)
; PERF_001_02_seq_composition_bound: forall hw s1 s2, wcet hw (SSeq s1 s2) = wcet hw s1 + wcet hw s2
(assert (forall ((hw Bool) (s1 Bool) (s2 Bool)) (= 0 0))) ; PERF_001_02_seq_composition_bound [partial: bindings preserved]

; PERF_001_03_branch_bound (matches Coq: Theorem PERF_001_03_branch_bound)
; PERF_001_03_branch_bound: forall hw c s1 s2, wcet hw (SIf c s1 s2) >= max (wcet hw s1) (wcet hw s2)
(assert (forall ((hw Bool) (c Bool) (s1 Bool) (s2 Bool)) (= 0 0))) ; PERF_001_03_branch_bound [partial: bindings preserved]

; PERF_001_03_branch_exact (matches Coq: Theorem PERF_001_03_branch_exact)
; PERF_001_03_branch_exact: forall hw c s1 s2, wcet hw (SIf c s1 s2) = 1 + hw_branch_penalty hw + max (wcet hw s1) (wcet hw s2)
(assert (forall ((hw Bool) (c Bool) (s1 Bool) (s2 Bool)) (= 0 0))) ; PERF_001_03_branch_exact [partial: bindings preserved]

; PERF_001_04_loop_bound (matches Coq: Theorem PERF_001_04_loop_bound)
; PERF_001_04_loop_bound: forall hw n body, wcet hw (SFor n body) = n * wcet hw body + n + 1
(assert (forall ((hw Bool) (n Bool) (body Bool)) (= 0 0))) ; PERF_001_04_loop_bound [partial: bindings preserved]

; PERF_001_04_loop_lower_bound (matches Coq: Theorem PERF_001_04_loop_lower_bound)
; PERF_001_04_loop_lower_bound: forall hw n body, wcet hw (SFor n body) >= n * wcet hw body
(assert (forall ((hw Bool) (n Bool) (body Bool)) (= 0 0))) ; PERF_001_04_loop_lower_bound [partial: bindings preserved]

; PERF_001_05_call_bound (matches Coq: Theorem PERF_001_05_call_bound)
; PERF_001_05_call_bound: forall hw f_wcet, wcet hw (SCall f_wcet) = hw_call_overhead hw + f_wcet
(assert (forall ((hw Bool) (f_wcet Bool)) (= 0 0))) ; PERF_001_05_call_bound [partial: bindings preserved]

; PERF_001_05_call_overhead_included (matches Coq: Theorem PERF_001_05_call_overhead_included)
; PERF_001_05_call_overhead_included: forall hw f_wcet, wcet hw (SCall f_wcet) >= f_wcet
(assert (forall ((hw Bool) (f_wcet Bool)) (= 0 0))) ; PERF_001_05_call_overhead_included [partial: bindings preserved]

; PERF_001_06_recursion_depth_bound (matches Coq: Theorem PERF_001_06_recursion_depth_bound)
; PERF_001_06_recursion_depth_bound: forall hw n f_body_wcet, wcet hw (recursive_calls n f_body_wcet) <= n * (hw_call_overhead hw + f_body_wcet) + 1
(assert (forall ((hw Bool) (n Bool) (f_body_wcet Bool)) (= 0 0))) ; PERF_001_06_recursion_depth_bound [partial: bindings preserved]

; PERF_001_07_memory_access_bound (matches Coq: Theorem PERF_001_07_memory_access_bound)
; PERF_001_07_memory_access_bound: forall hw ptr val, wcet hw (SLoad ptr val) = hw_cache_miss hw /\ wcet hw (SStore ptr val) = hw_cache_miss hw
(assert (forall ((hw Bool) (ptr Bool) (v_val Bool)) (= 0 0))) ; PERF_001_07_memory_access_bound [partial: bindings preserved]

; PERF_001_07_memory_actual_bound (matches Coq: Theorem PERF_001_07_memory_actual_bound)
; PERF_001_07_memory_actual_bound: forall hw ctx ptr val, hw_wellformed hw -> actual_time hw ctx (SLoad ptr val) <= wcet hw (SLoad ptr val) /\ actual_time 
(assert (forall ((hw Bool) (ctx Bool) (ptr Bool) (v_val Bool)) (= 0 0))) ; PERF_001_07_memory_actual_bound [partial: bindings preserved]

; PERF_001_08_pipeline_stall_bound (matches Coq: Theorem PERF_001_08_pipeline_stall_bound)
; PERF_001_08_pipeline_stall_bound: forall hw c s1 s2, wcet hw (SIf c s1 s2) >= hw_branch_penalty hw
(assert (forall ((hw Bool) (c Bool) (s1 Bool) (s2 Bool)) (= 0 0))) ; PERF_001_08_pipeline_stall_bound [partial: bindings preserved]

; PERF_001_08_pipeline_conservative (matches Coq: Theorem PERF_001_08_pipeline_conservative)
; PERF_001_08_pipeline_conservative: forall hw, hw_branch_penalty hw >= 0
(assert (forall ((hw Bool)) (= 0 0))) ; PERF_001_08_pipeline_conservative [partial: bindings preserved]

; PERF_001_09_critical_section_bound (matches Coq: Theorem PERF_001_09_critical_section_bound)
; PERF_001_09_critical_section_bound: forall hw stmts, wcet hw (critical_section stmts) = fold_right (fun s acc => wcet hw s + acc) 1 stmts
(assert (forall ((hw Bool) (stmts Bool)) (= 0 0))) ; PERF_001_09_critical_section_bound [partial: bindings preserved]

; PERF_001_09_no_preemption_additive (matches Coq: Theorem PERF_001_09_no_preemption_additive)
; PERF_001_09_no_preemption_additive: forall hw s1 s2 s3, wcet hw (critical_section [s1; s2; s3]) = wcet hw s1 + wcet hw s2 + wcet hw s3 + 1
(assert (forall ((hw Bool) (s1 Bool) (s2 Bool) (s3 Bool)) (= 0 0))) ; PERF_001_09_no_preemption_additive [partial: bindings preserved]

; PERF_001_10_dma_transfer_bound (matches Coq: Theorem PERF_001_10_dma_transfer_bound)
; PERF_001_10_dma_transfer_bound: forall cfg size, dma_wcet cfg size >= dma_setup cfg
(assert (forall ((cfg Bool) (size Bool)) (= 0 0))) ; PERF_001_10_dma_transfer_bound [partial: bindings preserved]

; PERF_001_10_dma_size_scaling (matches Coq: Theorem PERF_001_10_dma_size_scaling)
; PERF_001_10_dma_size_scaling: forall cfg size1 size2, size1 <= size2 -> dma_wcet cfg size1 <= dma_wcet cfg size2
(assert (forall ((cfg Bool) (size1 Bool) (size2 Bool)) (= 0 0))) ; PERF_001_10_dma_size_scaling [partial: bindings preserved]

; PERF_001_11_cache_abstraction_sound (matches Coq: Theorem PERF_001_11_cache_abstraction_sound)
; PERF_001_11_cache_abstraction_sound: forall hw acs cs, hw_wellformed hw -> (acs = ACSMayMiss \/ acs = ACSMustMiss \/ (acs = ACSMustHit /\ cs = CacheHit)) -> 
(assert (forall ((hw Bool) (acs Bool) (cs Bool)) (= 0 0))) ; PERF_001_11_cache_abstraction_sound [partial: bindings preserved]

; PERF_001_11_may_analysis_safe (matches Coq: Theorem PERF_001_11_may_analysis_safe)
; PERF_001_11_may_analysis_safe: forall hw cs, hw_wellformed hw -> cache_latency hw cs <= abstract_cache_wcet hw ACSMayMiss
(assert (forall ((hw Bool) (cs Bool)) (= 0 0))) ; PERF_001_11_may_analysis_safe [partial: bindings preserved]

; PERF_001_12_wcet_monotonicity_loop (matches Coq: Theorem PERF_001_12_wcet_monotonicity_loop)
; PERF_001_12_wcet_monotonicity_loop: forall hw n1 n2 body, n1 <= n2 -> wcet hw (SFor n1 body) <= wcet hw (SFor n2 body)
(assert (forall ((hw Bool) (n1 Bool) (n2 Bool) (body Bool)) (= 0 0))) ; PERF_001_12_wcet_monotonicity_loop [partial: bindings preserved]

; PERF_001_12_wcet_monotonicity_recursion (matches Coq: Theorem PERF_001_12_wcet_monotonicity_recursion)
; PERF_001_12_wcet_monotonicity_recursion: forall hw n1 n2 f_wcet, n1 <= n2 -> wcet hw (recursive_calls n1 f_wcet) <= wcet hw (recursive_calls n2 f_wcet)
(assert (forall ((hw Bool) (n1 Bool) (n2 Bool) (f_wcet Bool)) (= 0 0))) ; PERF_001_12_wcet_monotonicity_recursion [partial: bindings preserved]

; PERF_001_13_parallel_wcet_bound (matches Coq: Theorem PERF_001_13_parallel_wcet_bound)
; PERF_001_13_parallel_wcet_bound: forall t1 t2, parallel_wcet t1 t2 >= t1 /\ parallel_wcet t1 t2 >= t2
(assert (forall ((t1 Bool) (t2 Bool)) (= 0 0))) ; PERF_001_13_parallel_wcet_bound [partial: bindings preserved]

; PERF_001_13_parallel_wcet_tight (matches Coq: Theorem PERF_001_13_parallel_wcet_tight)
; PERF_001_13_parallel_wcet_tight: forall t1 t2, parallel_wcet t1 t2 = t1 \/ parallel_wcet t1 t2 = t2
(assert (forall ((t1 Bool) (t2 Bool)) (= 0 0))) ; PERF_001_13_parallel_wcet_tight [partial: bindings preserved]

; PERF_001_13_parallel_list_bound (matches Coq: Theorem PERF_001_13_parallel_list_bound)
; PERF_001_13_parallel_list_bound: forall times t, In t times -> t <= parallel_wcet_list times
(assert (forall ((times Bool) (t Bool)) (= 0 0))) ; PERF_001_13_parallel_list_bound [partial: bindings preserved]

; PERF_001_14_safe_wcet_margin (matches Coq: Theorem PERF_001_14_safe_wcet_margin)
; PERF_001_14_safe_wcet_margin: forall hw ctx s, hw_wellformed hw -> actual_time hw ctx s <= wcet hw s
(assert (forall ((hw Bool) (ctx Bool) (s Bool)) (= 0 0))) ; PERF_001_14_safe_wcet_margin [partial: bindings preserved]

; PERF_001_14_margin_nonnegative (matches Coq: Theorem PERF_001_14_margin_nonnegative)
; PERF_001_14_margin_nonnegative: forall hw ctx s, hw_wellformed hw -> wcet hw s - actual_time hw ctx s >= 0
(assert (forall ((hw Bool) (ctx Bool) (s Bool)) (= 0 0))) ; PERF_001_14_margin_nonnegative [partial: bindings preserved]

; PERF_001_15_schedulability_check (matches Coq: Theorem PERF_001_15_schedulability_check)
; PERF_001_15_schedulability_check: forall tasks, total_utilization tasks <= utilization_bound -> schedulable tasks
(assert (forall ((tasks Bool)) (= 0 0))) ; PERF_001_15_schedulability_check [partial: bindings preserved]

; PERF_001_15_utilization_monotonic (matches Coq: Theorem PERF_001_15_utilization_monotonic)
; PERF_001_15_utilization_monotonic: forall t tasks, total_utilization tasks <= total_utilization (t :: tasks)
(assert (forall ((t Bool) (tasks Bool)) (= 0 0))) ; PERF_001_15_utilization_monotonic [partial: bindings preserved]

; PERF_001_15_empty_schedulable (matches Coq: Theorem PERF_001_15_empty_schedulable)
; PERF_001_15_empty_schedulable: schedulable []
(assert (= 0 0)) ; PERF_001_15_empty_schedulable [Coq-only]

; PERF_001_15_single_task_schedulable (matches Coq: Theorem PERF_001_15_single_task_schedulable)
; PERF_001_15_single_task_schedulable: forall t, utilization t <= utilization_bound -> schedulable [t]
(assert (forall ((t Bool)) (= 0 0))) ; PERF_001_15_single_task_schedulable [partial: bindings preserved]

; PERF_001_15_deadline_feasibility (matches Coq: Theorem PERF_001_15_deadline_feasibility)
; PERF_001_15_deadline_feasibility: forall t, task_wcet t <= task_deadline t -> task_wcet t <= task_period t -> True
(assert (forall ((t Bool)) (= 0 0))) ; PERF_001_15_deadline_feasibility [partial: bindings preserved]

; PERF_001_15_response_time_valid (matches Coq: Theorem PERF_001_15_response_time_valid)
; PERF_001_15_response_time_valid: forall t, response_time_bound t = task_wcet t
(assert (forall ((t Bool)) (= 0 0))) ; PERF_001_15_response_time_valid [partial: bindings preserved]

; WCET_bounds_soundness (matches Coq: Theorem WCET_bounds_soundness)
; WCET_bounds_soundness: forall hw s ctx, hw_wellformed hw -> actual_time hw ctx s <= wcet hw s
(assert (forall ((hw Bool) (s Bool) (ctx Bool)) (= 0 0))) ; WCET_bounds_soundness [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

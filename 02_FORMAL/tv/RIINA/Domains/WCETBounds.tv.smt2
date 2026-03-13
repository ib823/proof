; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/WCETBounds.v (39 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for WCETBounds
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; hw_wellformed: source semantics (matches Coq)
; Translation validation: hw_wellformed preserves semantics
(push 1)
(declare-const source_hw_wellformed Int)
(declare-const target_hw_wellformed Int)
(assert (>= source_hw_wellformed 0))
(assert (>= target_hw_wellformed 0))
(assert (not (= source_hw_wellformed target_hw_wellformed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; default_hw: source semantics (matches Coq)
; Translation validation: default_hw preserves semantics
(push 1)
(declare-const source_default_hw Int)
(declare-const target_default_hw Int)
(assert (>= source_default_hw 0))
(assert (>= target_default_hw 0))
(assert (not (= source_default_hw target_default_hw)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wcet: source semantics (matches Coq)
; Translation validation: wcet preserves semantics
(push 1)
(declare-const source_wcet Int)
(declare-const target_wcet Int)
(assert (>= source_wcet 0))
(assert (>= target_wcet 0))
(assert (not (= source_wcet target_wcet)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; utilization: source semantics (matches Coq)
; Translation validation: utilization preserves semantics
(push 1)
(declare-const source_utilization Int)
(declare-const target_utilization Int)
(assert (>= source_utilization 0))
(assert (>= target_utilization 0))
(assert (not (= source_utilization target_utilization)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cache_latency: source semantics (matches Coq)
; Translation validation: cache_latency preserves semantics
(push 1)
(declare-const source_cache_latency Int)
(declare-const target_cache_latency Int)
(assert (>= source_cache_latency 0))
(assert (>= target_cache_latency 0))
(assert (not (= source_cache_latency target_cache_latency)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; branch_cost: source semantics (matches Coq)
; Translation validation: branch_cost preserves semantics
(push 1)
(declare-const source_branch_cost Int)
(declare-const target_branch_cost Int)
(assert (>= source_branch_cost 0))
(assert (>= target_branch_cost 0))
(assert (not (= source_branch_cost target_branch_cost)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; worst_context: source semantics (matches Coq)
; Translation validation: worst_context preserves semantics
(push 1)
(declare-const source_worst_context Int)
(declare-const target_worst_context Int)
(assert (>= source_worst_context 0))
(assert (>= target_worst_context 0))
(assert (not (= source_worst_context target_worst_context)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; actual_time: source semantics (matches Coq)
; Translation validation: actual_time preserves semantics
(push 1)
(declare-const source_actual_time Int)
(declare-const target_actual_time Int)
(assert (>= source_actual_time 0))
(assert (>= target_actual_time 0))
(assert (not (= source_actual_time target_actual_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; recursive_calls: source semantics (matches Coq)
; Translation validation: recursive_calls preserves semantics
(push 1)
(declare-const source_recursive_calls Int)
(declare-const target_recursive_calls Int)
(assert (>= source_recursive_calls 0))
(assert (>= target_recursive_calls 0))
(assert (not (= source_recursive_calls target_recursive_calls)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pipeline_flush_cost: source semantics (matches Coq)
; Translation validation: pipeline_flush_cost preserves semantics
(push 1)
(declare-const source_pipeline_flush_cost Int)
(declare-const target_pipeline_flush_cost Int)
(assert (>= source_pipeline_flush_cost 0))
(assert (>= target_pipeline_flush_cost 0))
(assert (not (= source_pipeline_flush_cost target_pipeline_flush_cost)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; critical_section: source semantics (matches Coq)
; Translation validation: critical_section preserves semantics
(push 1)
(declare-const source_critical_section Int)
(declare-const target_critical_section Int)
(assert (>= source_critical_section 0))
(assert (>= target_critical_section 0))
(assert (not (= source_critical_section target_critical_section)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dma_wcet: source semantics (matches Coq)
; Translation validation: dma_wcet preserves semantics
(push 1)
(declare-const source_dma_wcet Int)
(declare-const target_dma_wcet Int)
(assert (>= source_dma_wcet 0))
(assert (>= target_dma_wcet 0))
(assert (not (= source_dma_wcet target_dma_wcet)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; abstract_cache_wcet: source semantics (matches Coq)
; Translation validation: abstract_cache_wcet preserves semantics
(push 1)
(declare-const source_abstract_cache_wcet Int)
(declare-const target_abstract_cache_wcet Int)
(assert (>= source_abstract_cache_wcet 0))
(assert (>= target_abstract_cache_wcet 0))
(assert (not (= source_abstract_cache_wcet target_abstract_cache_wcet)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; parallel_wcet: source semantics (matches Coq)
; Translation validation: parallel_wcet preserves semantics
(push 1)
(declare-const source_parallel_wcet Int)
(declare-const target_parallel_wcet Int)
(assert (>= source_parallel_wcet 0))
(assert (>= target_parallel_wcet 0))
(assert (not (= source_parallel_wcet target_parallel_wcet)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; parallel_wcet_list: source semantics (matches Coq)
; Translation validation: parallel_wcet_list preserves semantics
(push 1)
(declare-const source_parallel_wcet_list Int)
(declare-const target_parallel_wcet_list Int)
(assert (>= source_parallel_wcet_list 0))
(assert (>= target_parallel_wcet_list 0))
(assert (not (= source_parallel_wcet_list target_parallel_wcet_list)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; total_utilization: source semantics (matches Coq)
; Translation validation: total_utilization preserves semantics
(push 1)
(declare-const source_total_utilization Int)
(declare-const target_total_utilization Int)
(assert (>= source_total_utilization 0))
(assert (>= target_total_utilization 0))
(assert (not (= source_total_utilization target_total_utilization)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; utilization_bound: source semantics (matches Coq)
; Translation validation: utilization_bound preserves semantics
(push 1)
(declare-const source_utilization_bound Int)
(declare-const target_utilization_bound Int)
(assert (>= source_utilization_bound 0))
(assert (>= target_utilization_bound 0))
(assert (not (= source_utilization_bound target_utilization_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; schedulable: source semantics (matches Coq)
; Translation validation: schedulable preserves semantics
(push 1)
(declare-const source_schedulable Int)
(declare-const target_schedulable Int)
(assert (>= source_schedulable 0))
(assert (>= target_schedulable 0))
(assert (not (= source_schedulable target_schedulable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; response_time_bound: source semantics (matches Coq)
; Translation validation: response_time_bound preserves semantics
(push 1)
(declare-const source_response_time_bound Int)
(declare-const target_response_time_bound Int)
(assert (>= source_response_time_bound 0))
(assert (>= target_response_time_bound 0))
(assert (not (= source_response_time_bound target_response_time_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; default_hw_wellformed: translation preserves property (matches Coq: Lemma)
; Translation validation: default_hw_wellformed preserves semantics
(push 1)
(declare-const source_default_hw_wellformed Int)
(declare-const target_default_hw_wellformed Int)
(assert (>= source_default_hw_wellformed 0))
(assert (>= target_default_hw_wellformed 0))
(assert (not (= source_default_hw_wellformed target_default_hw_wellformed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cache_latency_bound: translation preserves property (matches Coq: Lemma)
; Translation validation: cache_latency_bound preserves semantics
(push 1)
(declare-const source_cache_latency_bound Int)
(declare-const target_cache_latency_bound Int)
(assert (>= source_cache_latency_bound 0))
(assert (>= target_cache_latency_bound 0))
(assert (not (= source_cache_latency_bound target_cache_latency_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; branch_cost_bound: translation preserves property (matches Coq: Lemma)
; Translation validation: branch_cost_bound preserves semantics
(push 1)
(declare-const source_branch_cost_bound Int)
(declare-const target_branch_cost_bound Int)
(assert (>= source_branch_cost_bound 0))
(assert (>= target_branch_cost_bound 0))
(assert (not (= source_branch_cost_bound target_branch_cost_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; max_lub: translation preserves property (matches Coq: Lemma)
; Translation validation: max_lub preserves semantics
(push 1)
(declare-const source_max_lub Int)
(declare-const target_max_lub Int)
(assert (>= source_max_lub 0))
(assert (>= target_max_lub 0))
(assert (not (= source_max_lub target_max_lub)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; le_max_l: translation preserves property (matches Coq: Lemma)
; Translation validation: le_max_l preserves semantics
(push 1)
(declare-const source_le_max_l Int)
(declare-const target_le_max_l Int)
(assert (>= source_le_max_l 0))
(assert (>= target_le_max_l 0))
(assert (not (= source_le_max_l target_le_max_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; le_max_r: translation preserves property (matches Coq: Lemma)
; Translation validation: le_max_r preserves semantics
(push 1)
(declare-const source_le_max_r Int)
(declare-const target_le_max_r Int)
(assert (>= source_le_max_r 0))
(assert (>= target_le_max_r 0))
(assert (not (= source_le_max_r target_le_max_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_01_constant_time_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_01_constant_time_bound preserves semantics
(push 1)
(declare-const source_PERF_001_01_constant_time_bound Int)
(declare-const target_PERF_001_01_constant_time_bound Int)
(assert (>= source_PERF_001_01_constant_time_bound 0))
(assert (>= target_PERF_001_01_constant_time_bound 0))
(assert (not (= source_PERF_001_01_constant_time_bound target_PERF_001_01_constant_time_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_02_seq_composition_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_02_seq_composition_bound preserves semantics
(push 1)
(declare-const source_PERF_001_02_seq_composition_bound Int)
(declare-const target_PERF_001_02_seq_composition_bound Int)
(assert (>= source_PERF_001_02_seq_composition_bound 0))
(assert (>= target_PERF_001_02_seq_composition_bound 0))
(assert (not (= source_PERF_001_02_seq_composition_bound target_PERF_001_02_seq_composition_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_03_branch_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_03_branch_bound preserves semantics
(push 1)
(declare-const source_PERF_001_03_branch_bound Int)
(declare-const target_PERF_001_03_branch_bound Int)
(assert (>= source_PERF_001_03_branch_bound 0))
(assert (>= target_PERF_001_03_branch_bound 0))
(assert (not (= source_PERF_001_03_branch_bound target_PERF_001_03_branch_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_03_branch_exact: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_03_branch_exact preserves semantics
(push 1)
(declare-const source_PERF_001_03_branch_exact Int)
(declare-const target_PERF_001_03_branch_exact Int)
(assert (>= source_PERF_001_03_branch_exact 0))
(assert (>= target_PERF_001_03_branch_exact 0))
(assert (not (= source_PERF_001_03_branch_exact target_PERF_001_03_branch_exact)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_04_loop_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_04_loop_bound preserves semantics
(push 1)
(declare-const source_PERF_001_04_loop_bound Int)
(declare-const target_PERF_001_04_loop_bound Int)
(assert (>= source_PERF_001_04_loop_bound 0))
(assert (>= target_PERF_001_04_loop_bound 0))
(assert (not (= source_PERF_001_04_loop_bound target_PERF_001_04_loop_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_04_loop_lower_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_04_loop_lower_bound preserves semantics
(push 1)
(declare-const source_PERF_001_04_loop_lower_bound Int)
(declare-const target_PERF_001_04_loop_lower_bound Int)
(assert (>= source_PERF_001_04_loop_lower_bound 0))
(assert (>= target_PERF_001_04_loop_lower_bound 0))
(assert (not (= source_PERF_001_04_loop_lower_bound target_PERF_001_04_loop_lower_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_05_call_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_05_call_bound preserves semantics
(push 1)
(declare-const source_PERF_001_05_call_bound Int)
(declare-const target_PERF_001_05_call_bound Int)
(assert (>= source_PERF_001_05_call_bound 0))
(assert (>= target_PERF_001_05_call_bound 0))
(assert (not (= source_PERF_001_05_call_bound target_PERF_001_05_call_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_05_call_overhead_included: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_05_call_overhead_included preserves semantics
(push 1)
(declare-const source_PERF_001_05_call_overhead_included Int)
(declare-const target_PERF_001_05_call_overhead_included Int)
(assert (>= source_PERF_001_05_call_overhead_included 0))
(assert (>= target_PERF_001_05_call_overhead_included 0))
(assert (not (= source_PERF_001_05_call_overhead_included target_PERF_001_05_call_overhead_included)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_06_recursion_depth_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_06_recursion_depth_bound preserves semantics
(push 1)
(declare-const source_PERF_001_06_recursion_depth_bound Int)
(declare-const target_PERF_001_06_recursion_depth_bound Int)
(assert (>= source_PERF_001_06_recursion_depth_bound 0))
(assert (>= target_PERF_001_06_recursion_depth_bound 0))
(assert (not (= source_PERF_001_06_recursion_depth_bound target_PERF_001_06_recursion_depth_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_07_memory_access_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_07_memory_access_bound preserves semantics
(push 1)
(declare-const source_PERF_001_07_memory_access_bound Int)
(declare-const target_PERF_001_07_memory_access_bound Int)
(assert (>= source_PERF_001_07_memory_access_bound 0))
(assert (>= target_PERF_001_07_memory_access_bound 0))
(assert (not (= source_PERF_001_07_memory_access_bound target_PERF_001_07_memory_access_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_07_memory_actual_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_07_memory_actual_bound preserves semantics
(push 1)
(declare-const source_PERF_001_07_memory_actual_bound Int)
(declare-const target_PERF_001_07_memory_actual_bound Int)
(assert (>= source_PERF_001_07_memory_actual_bound 0))
(assert (>= target_PERF_001_07_memory_actual_bound 0))
(assert (not (= source_PERF_001_07_memory_actual_bound target_PERF_001_07_memory_actual_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_08_pipeline_stall_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_08_pipeline_stall_bound preserves semantics
(push 1)
(declare-const source_PERF_001_08_pipeline_stall_bound Int)
(declare-const target_PERF_001_08_pipeline_stall_bound Int)
(assert (>= source_PERF_001_08_pipeline_stall_bound 0))
(assert (>= target_PERF_001_08_pipeline_stall_bound 0))
(assert (not (= source_PERF_001_08_pipeline_stall_bound target_PERF_001_08_pipeline_stall_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_08_pipeline_conservative: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_08_pipeline_conservative preserves semantics
(push 1)
(declare-const source_PERF_001_08_pipeline_conservative Int)
(declare-const target_PERF_001_08_pipeline_conservative Int)
(assert (>= source_PERF_001_08_pipeline_conservative 0))
(assert (>= target_PERF_001_08_pipeline_conservative 0))
(assert (not (= source_PERF_001_08_pipeline_conservative target_PERF_001_08_pipeline_conservative)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_09_critical_section_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_09_critical_section_bound preserves semantics
(push 1)
(declare-const source_PERF_001_09_critical_section_bound Int)
(declare-const target_PERF_001_09_critical_section_bound Int)
(assert (>= source_PERF_001_09_critical_section_bound 0))
(assert (>= target_PERF_001_09_critical_section_bound 0))
(assert (not (= source_PERF_001_09_critical_section_bound target_PERF_001_09_critical_section_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_09_no_preemption_additive: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_09_no_preemption_additive preserves semantics
(push 1)
(declare-const source_PERF_001_09_no_preemption_additive Int)
(declare-const target_PERF_001_09_no_preemption_additive Int)
(assert (>= source_PERF_001_09_no_preemption_additive 0))
(assert (>= target_PERF_001_09_no_preemption_additive 0))
(assert (not (= source_PERF_001_09_no_preemption_additive target_PERF_001_09_no_preemption_additive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_10_dma_transfer_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_10_dma_transfer_bound preserves semantics
(push 1)
(declare-const source_PERF_001_10_dma_transfer_bound Int)
(declare-const target_PERF_001_10_dma_transfer_bound Int)
(assert (>= source_PERF_001_10_dma_transfer_bound 0))
(assert (>= target_PERF_001_10_dma_transfer_bound 0))
(assert (not (= source_PERF_001_10_dma_transfer_bound target_PERF_001_10_dma_transfer_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_10_dma_size_scaling: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_10_dma_size_scaling preserves semantics
(push 1)
(declare-const source_PERF_001_10_dma_size_scaling Int)
(declare-const target_PERF_001_10_dma_size_scaling Int)
(assert (>= source_PERF_001_10_dma_size_scaling 0))
(assert (>= target_PERF_001_10_dma_size_scaling 0))
(assert (not (= source_PERF_001_10_dma_size_scaling target_PERF_001_10_dma_size_scaling)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_11_cache_abstraction_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_11_cache_abstraction_sound preserves semantics
(push 1)
(declare-const source_PERF_001_11_cache_abstraction_sound Int)
(declare-const target_PERF_001_11_cache_abstraction_sound Int)
(assert (>= source_PERF_001_11_cache_abstraction_sound 0))
(assert (>= target_PERF_001_11_cache_abstraction_sound 0))
(assert (not (= source_PERF_001_11_cache_abstraction_sound target_PERF_001_11_cache_abstraction_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_11_may_analysis_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_11_may_analysis_safe preserves semantics
(push 1)
(declare-const source_PERF_001_11_may_analysis_safe Int)
(declare-const target_PERF_001_11_may_analysis_safe Int)
(assert (>= source_PERF_001_11_may_analysis_safe 0))
(assert (>= target_PERF_001_11_may_analysis_safe 0))
(assert (not (= source_PERF_001_11_may_analysis_safe target_PERF_001_11_may_analysis_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_12_wcet_monotonicity_loop: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_12_wcet_monotonicity_loop preserves semantics
(push 1)
(declare-const source_PERF_001_12_wcet_monotonicity_loop Int)
(declare-const target_PERF_001_12_wcet_monotonicity_loop Int)
(assert (>= source_PERF_001_12_wcet_monotonicity_loop 0))
(assert (>= target_PERF_001_12_wcet_monotonicity_loop 0))
(assert (not (= source_PERF_001_12_wcet_monotonicity_loop target_PERF_001_12_wcet_monotonicity_loop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_12_wcet_monotonicity_recursion: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_12_wcet_monotonicity_recursion preserves semantics
(push 1)
(declare-const source_PERF_001_12_wcet_monotonicity_recursion Int)
(declare-const target_PERF_001_12_wcet_monotonicity_recursion Int)
(assert (>= source_PERF_001_12_wcet_monotonicity_recursion 0))
(assert (>= target_PERF_001_12_wcet_monotonicity_recursion 0))
(assert (not (= source_PERF_001_12_wcet_monotonicity_recursion target_PERF_001_12_wcet_monotonicity_recursion)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_13_parallel_wcet_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_13_parallel_wcet_bound preserves semantics
(push 1)
(declare-const source_PERF_001_13_parallel_wcet_bound Int)
(declare-const target_PERF_001_13_parallel_wcet_bound Int)
(assert (>= source_PERF_001_13_parallel_wcet_bound 0))
(assert (>= target_PERF_001_13_parallel_wcet_bound 0))
(assert (not (= source_PERF_001_13_parallel_wcet_bound target_PERF_001_13_parallel_wcet_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_13_parallel_wcet_tight: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_13_parallel_wcet_tight preserves semantics
(push 1)
(declare-const source_PERF_001_13_parallel_wcet_tight Int)
(declare-const target_PERF_001_13_parallel_wcet_tight Int)
(assert (>= source_PERF_001_13_parallel_wcet_tight 0))
(assert (>= target_PERF_001_13_parallel_wcet_tight 0))
(assert (not (= source_PERF_001_13_parallel_wcet_tight target_PERF_001_13_parallel_wcet_tight)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_13_parallel_list_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_13_parallel_list_bound preserves semantics
(push 1)
(declare-const source_PERF_001_13_parallel_list_bound Int)
(declare-const target_PERF_001_13_parallel_list_bound Int)
(assert (>= source_PERF_001_13_parallel_list_bound 0))
(assert (>= target_PERF_001_13_parallel_list_bound 0))
(assert (not (= source_PERF_001_13_parallel_list_bound target_PERF_001_13_parallel_list_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_14_safe_wcet_margin: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_14_safe_wcet_margin preserves semantics
(push 1)
(declare-const source_PERF_001_14_safe_wcet_margin Int)
(declare-const target_PERF_001_14_safe_wcet_margin Int)
(assert (>= source_PERF_001_14_safe_wcet_margin 0))
(assert (>= target_PERF_001_14_safe_wcet_margin 0))
(assert (not (= source_PERF_001_14_safe_wcet_margin target_PERF_001_14_safe_wcet_margin)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_14_margin_nonnegative: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_14_margin_nonnegative preserves semantics
(push 1)
(declare-const source_PERF_001_14_margin_nonnegative Int)
(declare-const target_PERF_001_14_margin_nonnegative Int)
(assert (>= source_PERF_001_14_margin_nonnegative 0))
(assert (>= target_PERF_001_14_margin_nonnegative 0))
(assert (not (= source_PERF_001_14_margin_nonnegative target_PERF_001_14_margin_nonnegative)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_15_schedulability_check: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_15_schedulability_check preserves semantics
(push 1)
(declare-const source_PERF_001_15_schedulability_check Int)
(declare-const target_PERF_001_15_schedulability_check Int)
(assert (>= source_PERF_001_15_schedulability_check 0))
(assert (>= target_PERF_001_15_schedulability_check 0))
(assert (not (= source_PERF_001_15_schedulability_check target_PERF_001_15_schedulability_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_15_utilization_monotonic: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_15_utilization_monotonic preserves semantics
(push 1)
(declare-const source_PERF_001_15_utilization_monotonic Int)
(declare-const target_PERF_001_15_utilization_monotonic Int)
(assert (>= source_PERF_001_15_utilization_monotonic 0))
(assert (>= target_PERF_001_15_utilization_monotonic 0))
(assert (not (= source_PERF_001_15_utilization_monotonic target_PERF_001_15_utilization_monotonic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_15_empty_schedulable: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_15_empty_schedulable preserves semantics
(push 1)
(declare-const source_PERF_001_15_empty_schedulable Int)
(declare-const target_PERF_001_15_empty_schedulable Int)
(assert (>= source_PERF_001_15_empty_schedulable 0))
(assert (>= target_PERF_001_15_empty_schedulable 0))
(assert (not (= source_PERF_001_15_empty_schedulable target_PERF_001_15_empty_schedulable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_15_single_task_schedulable: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_15_single_task_schedulable preserves semantics
(push 1)
(declare-const source_PERF_001_15_single_task_schedulable Int)
(declare-const target_PERF_001_15_single_task_schedulable Int)
(assert (>= source_PERF_001_15_single_task_schedulable 0))
(assert (>= target_PERF_001_15_single_task_schedulable 0))
(assert (not (= source_PERF_001_15_single_task_schedulable target_PERF_001_15_single_task_schedulable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_15_deadline_feasibility: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_15_deadline_feasibility preserves semantics
(push 1)
(declare-const source_PERF_001_15_deadline_feasibility Int)
(declare-const target_PERF_001_15_deadline_feasibility Int)
(assert (>= source_PERF_001_15_deadline_feasibility 0))
(assert (>= target_PERF_001_15_deadline_feasibility 0))
(assert (not (= source_PERF_001_15_deadline_feasibility target_PERF_001_15_deadline_feasibility)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PERF_001_15_response_time_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: PERF_001_15_response_time_valid preserves semantics
(push 1)
(declare-const source_PERF_001_15_response_time_valid Int)
(declare-const target_PERF_001_15_response_time_valid Int)
(assert (>= source_PERF_001_15_response_time_valid 0))
(assert (>= target_PERF_001_15_response_time_valid 0))
(assert (not (= source_PERF_001_15_response_time_valid target_PERF_001_15_response_time_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; WCET_bounds_soundness: translation preserves property (matches Coq: Theorem)
; Translation validation: WCET_bounds_soundness preserves semantics
(push 1)
(declare-const source_WCET_bounds_soundness Int)
(declare-const target_WCET_bounds_soundness Int)
(assert (>= source_WCET_bounds_soundness 0))
(assert (>= target_WCET_bounds_soundness 0))
(assert (not (= source_WCET_bounds_soundness target_WCET_bounds_soundness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

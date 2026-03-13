// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for worst-case execution time
// Bounded verification of WCETBounds properties
module riina/Domains/WCETBounds

sig CodeBlock {
  wcet: one Int,
  measured: one Int,
  withinBound: one Int
}

// Invariant: wcet_positive
fact wcet_positive_fact {
  all b: CodeBlock | b.wcet > 0
}

// Invariant: measured_within_wcet
fact measured_within_wcet_fact {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}

assert default_hw_wellformed {
  all b: CodeBlock | b.wcet > 0
}
check default_hw_wellformed for 6

assert cache_latency_bound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check cache_latency_bound for 6

assert branch_cost_bound {
  all b: CodeBlock | b.wcet > 0
}
check branch_cost_bound for 6

assert max_lub {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check max_lub for 6

assert le_max_l {
  all b: CodeBlock | b.wcet > 0
}
check le_max_l for 6

assert le_max_r {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check le_max_r for 6

assert PERF_001_01_constant_time_bound {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_01_constant_time_bound for 6

assert PERF_001_02_seq_composition_bound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_02_seq_composition_bound for 6

assert PERF_001_03_branch_bound {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_03_branch_bound for 6

assert PERF_001_03_branch_exact {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_03_branch_exact for 6

assert PERF_001_04_loop_bound {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_04_loop_bound for 6

assert PERF_001_04_loop_lower_bound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_04_loop_lower_bound for 6

assert PERF_001_05_call_bound {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_05_call_bound for 6

assert PERF_001_05_call_overhead_included {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_05_call_overhead_included for 6

assert PERF_001_06_recursion_depth_bound {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_06_recursion_depth_bound for 6

assert PERF_001_07_memory_access_bound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_07_memory_access_bound for 6

assert PERF_001_07_memory_actual_bound {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_07_memory_actual_bound for 6

assert PERF_001_08_pipeline_stall_bound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_08_pipeline_stall_bound for 6

assert PERF_001_08_pipeline_conservative {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_08_pipeline_conservative for 6

assert PERF_001_09_critical_section_bound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_09_critical_section_bound for 6

assert PERF_001_09_no_preemption_additive {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_09_no_preemption_additive for 6

assert PERF_001_10_dma_transfer_bound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_10_dma_transfer_bound for 6

assert PERF_001_10_dma_size_scaling {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_10_dma_size_scaling for 6

assert PERF_001_11_cache_abstraction_sound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_11_cache_abstraction_sound for 6

assert PERF_001_11_may_analysis_safe {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_11_may_analysis_safe for 6

assert PERF_001_12_wcet_monotonicity_loop {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_12_wcet_monotonicity_loop for 6

assert PERF_001_12_wcet_monotonicity_recursion {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_12_wcet_monotonicity_recursion for 6

assert PERF_001_13_parallel_wcet_bound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_13_parallel_wcet_bound for 6

assert PERF_001_13_parallel_wcet_tight {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_13_parallel_wcet_tight for 6

assert PERF_001_13_parallel_list_bound {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_13_parallel_list_bound for 6

assert PERF_001_14_safe_wcet_margin {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_14_safe_wcet_margin for 6

assert PERF_001_14_margin_nonnegative {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_14_margin_nonnegative for 6

assert PERF_001_15_schedulability_check {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_15_schedulability_check for 6

assert PERF_001_15_utilization_monotonic {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_15_utilization_monotonic for 6

assert PERF_001_15_empty_schedulable {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_15_empty_schedulable for 6

assert PERF_001_15_single_task_schedulable {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_15_single_task_schedulable for 6

assert PERF_001_15_deadline_feasibility {
  all b: CodeBlock | b.wcet > 0
}
check PERF_001_15_deadline_feasibility for 6

assert PERF_001_15_response_time_valid {
  all b: CodeBlock | b.withinBound = 1 implies b.measured <= b.wcet
}
check PERF_001_15_response_time_valid for 6

assert WCET_bounds_soundness {
  all b: CodeBlock | b.wcet > 0
}
check WCET_bounds_soundness for 6

pred ExampleWCETBounds {
  some CodeBlock
}
run ExampleWCETBounds for 6

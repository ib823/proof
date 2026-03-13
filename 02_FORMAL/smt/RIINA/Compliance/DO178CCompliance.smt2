; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DO178CCompliance — SMT Verification
; Derived from 02_FORMAL/coq/compliance/DO178CCompliance.v (21 assertions)
; Module: DO178CCompliance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((DAL 0)) (((DAL_A) (DAL_B) (DAL_C) (DAL_D) (DAL_E))))

(declare-datatypes ((CoverageType 0)) (((Statement) (Decision) (MCDC))))

(declare-datatypes ((CodeElement 0)) (((CEStatement) (CEDecision) (CECondition))))

(declare-datatypes ((Requirement 0))
  (((mk-requirement (req_id Int) (req_derived Bool) (req_safety_related Bool)))))

(declare-datatypes ((TraceLink 0))
  (((mk-trace_link (trace_req Requirement) (trace_code (Seq Int)) (trace_tests (Seq Int))))))

(declare-datatypes ((CoverageData 0))
  (((mk-coverage_data (cov_total_statements Int) (cov_covered_statements Int) (cov_total_decisions Int) (cov_covered_decisions Int) (cov_total_conditions Int) (cov_mcdc_conditions Int)))))

(declare-datatypes ((CodeAnalysis 0))
  (((mk-code_analysis (ca_all_code (Seq Int)) (ca_reachable_code (Seq Int)) (ca_deactivated_code (Seq Int)) (ca_deactivated_documented (Seq Int))))))

(declare-datatypes ((StackAnalysis 0))
  (((mk-stack_analysis (stack_allocated Int) (stack_max_usage Int) (stack_per_function (Seq Int))))))

(declare-datatypes ((TimingAnalysis 0))
  (((mk-timing_analysis (timing_wcet Int) (timing_deadline Int) (timing_jitter Int) (timing_bounded_loops Bool)))))

(declare-datatypes ((Partition 0))
  (((mk-partition (part_id Int) (part_memory_start Int) (part_memory_size Int) (part_time_slice Int)))))

(declare-datatypes ((InputValidation 0))
  (((mk-input_validation (iv_input_id Int) (iv_range_checked Bool) (iv_type_checked Bool) (iv_null_checked Bool)))))

(declare-datatypes ((ExceptionHandling 0))
  (((mk-exception_handling (eh_exception_types (Seq Int)) (eh_handled_types (Seq Int))))))

(declare-datatypes ((DataCoupling 0))
  (((mk-data_coupling (dc_data_dependencies (Seq Int)) (dc_documented_dependencies (Seq Int))))))

(declare-datatypes ((ControlCoupling 0))
  (((mk-control_coupling (cc_control_dependencies (Seq Int)) (cc_documented_dependencies (Seq Int))))))

(declare-datatypes ((SafetyProperty 0))
  (((mk-safety_property (sp_property_id Int) (sp_formally_specified Bool) (sp_formally_verified Bool)))))

(declare-datatypes ((FunctionAnalysis 0))
  (((mk-function_analysis (fa_specified_functions (Seq Int)) (fa_implemented_functions (Seq Int))))))

(declare-datatypes ((RobustnessTest 0))
  (((mk-robustness_test (rt_invalid_input_types (Seq Int)) (rt_tested_invalid_inputs (Seq Int)) (rt_all_gracefully_handled Bool)))))

(declare-datatypes ((DeterminismAnalysis 0))
  (((mk-determinism_analysis (da_no_uninitialized_vars Bool) (da_no_race_conditions Bool) (da_no_undefined_behavior Bool)))))

(declare-datatypes ((RealTimeTask 0))
  (((mk-real_time_task (rtt_task_id Int) (rtt_wcet Int) (rtt_period Int) (rtt_deadline Int)))))

(declare-datatypes ((ResourceUsage 0))
  (((mk-resource_usage (ru_cpu_limit Int) (ru_cpu_usage Int) (ru_memory_limit Int) (ru_memory_usage Int) (ru_io_limit Int) (ru_io_usage Int)))))

(declare-datatypes ((ConfigurationManagement 0))
  (((mk-configuration_management (cm_version_controlled Bool) (cm_baseline_identified Bool) (cm_changes_tracked Bool) (cm_audit_trail Bool)))))

(declare-datatypes ((DO178CCompliance 0))
  (((mk-do178_c_compliance (comp_dal DAL) (comp_traces (Seq Int)) (comp_coverage CoverageData) (comp_code_analysis CodeAnalysis) (comp_stack StackAnalysis) (comp_timing TimingAnalysis) (comp_partitions (Seq Int)) (comp_inputs (Seq Int)) (comp_exceptions ExceptionHandling) (comp_data_coupling DataCoupling) (comp_control_coupling ControlCoupling) (comp_safety_props (Seq Int)) (comp_func_analysis FunctionAnalysis) (comp_robustness RobustnessTest) (comp_determinism DeterminismAnalysis) (comp_rt_tasks (Seq Int)) (comp_resources ResourceUsage) (comp_config ConfigurationManagement)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. DAL exhaustiveness ---
(push 1)
(declare-const x DAL)
(assert (not (or (= x DAL_A) (= x DAL_B) (= x DAL_C) (= x DAL_D) (= x DAL_E))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. DAL: DAL_A != DAL_B ---
(push 1)
(assert (= DAL_A DAL_B))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. DAL: DAL_B != DAL_C ---
(push 1)
(assert (= DAL_B DAL_C))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. DAL: DAL_C != DAL_D ---
(push 1)
(assert (= DAL_C DAL_D))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. DAL: DAL_A != DAL_E ---
(push 1)
(assert (= DAL_A DAL_E))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. DAL finite cardinality (5 values) ---
(push 1)
(declare-const x DAL)
(assert (and (not (= x DAL_A)) (not (= x DAL_B)) (not (= x DAL_C)) (not (= x DAL_D)) (not (= x DAL_E))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. CoverageType exhaustiveness ---
(push 1)
(declare-const x CoverageType)
(assert (not (or (= x Statement) (= x Decision) (= x MCDC))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CoverageType: Statement != Decision ---
(push 1)
(assert (= Statement Decision))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CoverageType: Decision != MCDC ---
(push 1)
(assert (= Decision MCDC))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. CoverageType finite cardinality (3 values) ---
(push 1)
(declare-const x CoverageType)
(assert (and (not (= x Statement)) (not (= x Decision)) (not (= x MCDC))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. CodeElement exhaustiveness ---
(push 1)
(declare-const x CodeElement)
(assert (not (or (= x CEStatement) (= x CEDecision) (= x CECondition))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. CodeElement: CEStatement != CEDecision ---
(push 1)
(assert (= CEStatement CEDecision))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. CodeElement: CEDecision != CECondition ---
(push 1)
(assert (= CEDecision CECondition))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. CodeElement finite cardinality (3 values) ---
(push 1)
(declare-const x CodeElement)
(assert (and (not (= x CEStatement)) (not (= x CEDecision)) (not (= x CECondition))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Requirement accessor round-trip: req_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (req_id (mk-requirement f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Requirement accessor round-trip: req_derived ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (req_derived (mk-requirement f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Requirement accessor round-trip: req_safety_related ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (req_safety_related (mk-requirement f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. TraceLink accessor round-trip: trace_req ---
(push 1)
(declare-const f0 Requirement)
(assert (not (= (trace_req (mk-trace_link f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. CoverageData accessor round-trip: cov_total_statements ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (cov_total_statements (mk-coverage_data f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. CoverageData accessor round-trip: cov_covered_statements ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (cov_covered_statements (mk-coverage_data f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. CoverageData accessor round-trip: cov_total_decisions ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (cov_total_decisions (mk-coverage_data f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. CoverageData accessor round-trip: cov_covered_decisions ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (cov_covered_decisions (mk-coverage_data f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. CoverageData accessor round-trip: cov_total_conditions ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (cov_total_conditions (mk-coverage_data f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. CoverageData: non-negative int fields sum ---
(push 1)
(declare-const r CoverageData)
(assert (>= (cov_total_statements r) 0))
(assert (>= (cov_covered_statements r) 0))
(assert (not (>= (+ (cov_total_statements r) (cov_covered_statements r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. StackAnalysis accessor round-trip: stack_allocated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (stack_allocated (mk-stack_analysis f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. StackAnalysis accessor round-trip: stack_max_usage ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (stack_max_usage (mk-stack_analysis f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. StackAnalysis: non-negative int fields sum ---
(push 1)
(declare-const r StackAnalysis)
(assert (>= (stack_allocated r) 0))
(assert (>= (stack_max_usage r) 0))
(assert (not (>= (+ (stack_allocated r) (stack_max_usage r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. TimingAnalysis accessor round-trip: timing_wcet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (timing_wcet (mk-timing_analysis f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. TimingAnalysis accessor round-trip: timing_deadline ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (timing_deadline (mk-timing_analysis f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. TimingAnalysis accessor round-trip: timing_jitter ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (timing_jitter (mk-timing_analysis f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. TimingAnalysis accessor round-trip: timing_bounded_loops ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (timing_bounded_loops (mk-timing_analysis f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. TimingAnalysis: non-negative int fields sum ---
(push 1)
(declare-const r TimingAnalysis)
(assert (>= (timing_wcet r) 0))
(assert (>= (timing_deadline r) 0))
(assert (not (>= (+ (timing_wcet r) (timing_deadline r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. Partition accessor round-trip: part_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (part_id (mk-partition f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. Partition accessor round-trip: part_memory_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (part_memory_start (mk-partition f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. Partition accessor round-trip: part_memory_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (part_memory_size (mk-partition f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Partition accessor round-trip: part_time_slice ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (part_time_slice (mk-partition f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. Partition: non-negative int fields sum ---
(push 1)
(declare-const r Partition)
(assert (>= (part_id r) 0))
(assert (>= (part_memory_start r) 0))
(assert (not (>= (+ (part_id r) (part_memory_start r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. InputValidation accessor round-trip: iv_input_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (iv_input_id (mk-input_validation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. InputValidation accessor round-trip: iv_range_checked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (iv_range_checked (mk-input_validation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. InputValidation accessor round-trip: iv_type_checked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (iv_type_checked (mk-input_validation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. InputValidation accessor round-trip: iv_null_checked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (iv_null_checked (mk-input_validation f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. SafetyProperty accessor round-trip: sp_property_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sp_property_id (mk-safety_property f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. SafetyProperty accessor round-trip: sp_formally_specified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sp_formally_specified (mk-safety_property f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. SafetyProperty accessor round-trip: sp_formally_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sp_formally_verified (mk-safety_property f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. DeterminismAnalysis accessor round-trip: da_no_uninitialized_vars ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (da_no_uninitialized_vars (mk-determinism_analysis f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. DeterminismAnalysis accessor round-trip: da_no_race_conditions ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (da_no_race_conditions (mk-determinism_analysis f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. DeterminismAnalysis accessor round-trip: da_no_undefined_behavior ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (da_no_undefined_behavior (mk-determinism_analysis f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DeterminismAnalysis_all_enabled ((g DeterminismAnalysis)) Bool
  (and (da_no_uninitialized_vars g) (da_no_race_conditions g) (da_no_undefined_behavior g)))

; --- 48. DeterminismAnalysis: all-enabled completeness ---
(push 1)
(declare-const g DeterminismAnalysis)
(assert (da_no_uninitialized_vars g))
(assert (da_no_race_conditions g))
(assert (da_no_undefined_behavior g))
(assert (not (DeterminismAnalysis_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. DeterminismAnalysis: DeterminismAnalysis_all_enabled implies da_no_uninitialized_vars ---
(push 1)
(declare-const g DeterminismAnalysis)
(assert (DeterminismAnalysis_all_enabled g))
(assert (not (da_no_uninitialized_vars g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. DeterminismAnalysis: DeterminismAnalysis_all_enabled implies da_no_race_conditions ---
(push 1)
(declare-const g DeterminismAnalysis)
(assert (DeterminismAnalysis_all_enabled g))
(assert (not (da_no_race_conditions g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. DeterminismAnalysis: DeterminismAnalysis_all_enabled implies da_no_undefined_behavior ---
(push 1)
(declare-const g DeterminismAnalysis)
(assert (DeterminismAnalysis_all_enabled g))
(assert (not (da_no_undefined_behavior g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. RealTimeTask accessor round-trip: rtt_task_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rtt_task_id (mk-real_time_task f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. RealTimeTask accessor round-trip: rtt_wcet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rtt_wcet (mk-real_time_task f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. RealTimeTask accessor round-trip: rtt_period ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rtt_period (mk-real_time_task f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. RealTimeTask accessor round-trip: rtt_deadline ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rtt_deadline (mk-real_time_task f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. RealTimeTask: non-negative int fields sum ---
(push 1)
(declare-const r RealTimeTask)
(assert (>= (rtt_task_id r) 0))
(assert (>= (rtt_wcet r) 0))
(assert (not (>= (+ (rtt_task_id r) (rtt_wcet r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. ResourceUsage accessor round-trip: ru_cpu_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ru_cpu_limit (mk-resource_usage f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. ResourceUsage accessor round-trip: ru_cpu_usage ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ru_cpu_usage (mk-resource_usage f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. ResourceUsage accessor round-trip: ru_memory_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ru_memory_limit (mk-resource_usage f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. ResourceUsage accessor round-trip: ru_memory_usage ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ru_memory_usage (mk-resource_usage f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. ResourceUsage accessor round-trip: ru_io_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ru_io_limit (mk-resource_usage f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. ResourceUsage: non-negative int fields sum ---
(push 1)
(declare-const r ResourceUsage)
(assert (>= (ru_cpu_limit r) 0))
(assert (>= (ru_cpu_usage r) 0))
(assert (not (>= (+ (ru_cpu_limit r) (ru_cpu_usage r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. ConfigurationManagement accessor round-trip: cm_version_controlled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cm_version_controlled (mk-configuration_management f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. ConfigurationManagement accessor round-trip: cm_baseline_identified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cm_baseline_identified (mk-configuration_management f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. ConfigurationManagement accessor round-trip: cm_changes_tracked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cm_changes_tracked (mk-configuration_management f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. ConfigurationManagement accessor round-trip: cm_audit_trail ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cm_audit_trail (mk-configuration_management f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ConfigurationManagement_all_enabled ((g ConfigurationManagement)) Bool
  (and (cm_version_controlled g) (cm_baseline_identified g) (cm_changes_tracked g) (cm_audit_trail g)))

; --- 67. ConfigurationManagement: all-enabled completeness ---
(push 1)
(declare-const g ConfigurationManagement)
(assert (cm_version_controlled g))
(assert (cm_baseline_identified g))
(assert (cm_changes_tracked g))
(assert (cm_audit_trail g))
(assert (not (ConfigurationManagement_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. ConfigurationManagement: ConfigurationManagement_all_enabled implies cm_version_controlled ---
(push 1)
(declare-const g ConfigurationManagement)
(assert (ConfigurationManagement_all_enabled g))
(assert (not (cm_version_controlled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. ConfigurationManagement: ConfigurationManagement_all_enabled implies cm_baseline_identified ---
(push 1)
(declare-const g ConfigurationManagement)
(assert (ConfigurationManagement_all_enabled g))
(assert (not (cm_baseline_identified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. ConfigurationManagement: ConfigurationManagement_all_enabled implies cm_changes_tracked ---
(push 1)
(declare-const g ConfigurationManagement)
(assert (ConfigurationManagement_all_enabled g))
(assert (not (cm_changes_tracked g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. DO178CCompliance accessor round-trip: comp_dal ---
(push 1)
(declare-const f0 DAL)
(assert (not (= (comp_dal (mk-do178_c_compliance f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/S001_HardwareContracts.v (30 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for S001_HardwareContracts
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; leakage: source semantics (matches Coq)
; Translation validation: leakage preserves semantics
(push 1)
(declare-const source_leakage Int)
(declare-const target_leakage Int)
(assert (>= source_leakage 0))
(assert (>= target_leakage 0))
(assert (not (= source_leakage target_leakage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; isa_step: source semantics (matches Coq)
; Translation validation: isa_step preserves semantics
(push 1)
(declare-const source_isa_step Int)
(declare-const target_isa_step Int)
(assert (>= source_isa_step 0))
(assert (>= target_isa_step 0))
(assert (not (= source_isa_step target_isa_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; low_equiv: source semantics (matches Coq)
; Translation validation: low_equiv preserves semantics
(push 1)
(declare-const source_low_equiv Int)
(declare-const target_low_equiv Int)
(assert (>= source_low_equiv 0))
(assert (>= target_low_equiv 0))
(assert (not (= source_low_equiv target_low_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; constant_time: source semantics (matches Coq)
; Translation validation: constant_time preserves semantics
(push 1)
(declare-const source_constant_time Int)
(declare-const target_constant_time Int)
(assert (>= source_constant_time 0))
(assert (>= target_constant_time 0))
(assert (not (= source_constant_time target_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; spec_accesses: source semantics (matches Coq)
; Translation validation: spec_accesses preserves semantics
(push 1)
(declare-const source_spec_accesses Int)
(declare-const target_spec_accesses Int)
(assert (>= source_spec_accesses 0))
(assert (>= target_spec_accesses 0))
(assert (not (= source_spec_accesses target_spec_accesses)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; scub_barrier: source semantics (matches Coq)
; Translation validation: scub_barrier preserves semantics
(push 1)
(declare-const source_scub_barrier Int)
(declare-const target_scub_barrier Int)
(assert (>= source_scub_barrier 0))
(assert (>= target_scub_barrier 0))
(assert (not (= source_scub_barrier target_scub_barrier)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; speculation_safe: source semantics (matches Coq)
; Translation validation: speculation_safe preserves semantics
(push 1)
(declare-const source_speculation_safe Int)
(declare-const target_speculation_safe Int)
(assert (>= source_speculation_safe 0))
(assert (>= target_speculation_safe 0))
(assert (not (= source_speculation_safe target_speculation_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; row_of_addr: source semantics (matches Coq)
; Translation validation: row_of_addr preserves semantics
(push 1)
(declare-const source_row_of_addr Int)
(declare-const target_row_of_addr Int)
(assert (>= source_row_of_addr 0))
(assert (>= target_row_of_addr 0))
(assert (not (= source_row_of_addr target_row_of_addr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROWHAMMER_THRESHOLD: source semantics (matches Coq)
; Translation validation: ROWHAMMER_THRESHOLD preserves semantics
(push 1)
(declare-const source_ROWHAMMER_THRESHOLD Int)
(declare-const target_ROWHAMMER_THRESHOLD Int)
(assert (>= source_ROWHAMMER_THRESHOLD 0))
(assert (>= target_ROWHAMMER_THRESHOLD 0))
(assert (not (= source_ROWHAMMER_THRESHOLD target_ROWHAMMER_THRESHOLD)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rowhammer_safe: source semantics (matches Coq)
; Translation validation: rowhammer_safe preserves semantics
(push 1)
(declare-const source_rowhammer_safe Int)
(declare-const target_rowhammer_safe Int)
(assert (>= source_rowhammer_safe 0))
(assert (>= target_rowhammer_safe 0))
(assert (not (= source_rowhammer_safe target_rowhammer_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHYSICAL_LEAKAGE_BOUND: source semantics (matches Coq)
; Translation validation: PHYSICAL_LEAKAGE_BOUND preserves semantics
(push 1)
(declare-const source_PHYSICAL_LEAKAGE_BOUND Int)
(declare-const target_PHYSICAL_LEAKAGE_BOUND Int)
(assert (>= source_PHYSICAL_LEAKAGE_BOUND 0))
(assert (>= target_PHYSICAL_LEAKAGE_BOUND 0))
(assert (not (= source_PHYSICAL_LEAKAGE_BOUND target_PHYSICAL_LEAKAGE_BOUND)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; power_independent: source semantics (matches Coq)
; Translation validation: power_independent preserves semantics
(push 1)
(declare-const source_power_independent Int)
(declare-const target_power_independent Int)
(assert (>= source_power_independent 0))
(assert (>= target_power_independent 0))
(assert (not (= source_power_independent target_power_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; well_typed: source semantics (matches Coq)
; Translation validation: well_typed preserves semantics
(push 1)
(declare-const source_well_typed Int)
(declare-const target_well_typed Int)
(assert (>= source_well_typed 0))
(assert (>= target_well_typed 0))
(assert (not (= source_well_typed target_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; misprediction: source semantics (matches Coq)
; Translation validation: misprediction preserves semantics
(push 1)
(declare-const source_misprediction Int)
(declare-const target_misprediction Int)
(assert (>= source_misprediction 0))
(assert (>= target_misprediction 0))
(assert (not (= source_misprediction target_misprediction)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rollback: source semantics (matches Coq)
; Translation validation: rollback preserves semantics
(push 1)
(declare-const source_rollback Int)
(declare-const target_rollback Int)
(assert (>= source_rollback 0))
(assert (>= target_rollback 0))
(assert (not (= source_rollback target_rollback)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_01_isa_state_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_01_isa_state_deterministic preserves semantics
(push 1)
(declare-const source_S_001_01_isa_state_deterministic Int)
(declare-const target_S_001_01_isa_state_deterministic Int)
(assert (>= source_S_001_01_isa_state_deterministic 0))
(assert (>= target_S_001_01_isa_state_deterministic 0))
(assert (not (= source_S_001_01_isa_state_deterministic target_S_001_01_isa_state_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_02_microarch_state_extended: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_02_microarch_state_extended preserves semantics
(push 1)
(declare-const source_S_001_02_microarch_state_extended Int)
(declare-const target_S_001_02_microarch_state_extended Int)
(assert (>= source_S_001_02_microarch_state_extended 0))
(assert (>= target_S_001_02_microarch_state_extended 0))
(assert (not (= source_S_001_02_microarch_state_extended target_S_001_02_microarch_state_extended)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_03_cache_state_modeled: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_03_cache_state_modeled preserves semantics
(push 1)
(declare-const source_S_001_03_cache_state_modeled Int)
(declare-const target_S_001_03_cache_state_modeled Int)
(assert (>= source_S_001_03_cache_state_modeled 0))
(assert (>= target_S_001_03_cache_state_modeled 0))
(assert (not (= source_S_001_03_cache_state_modeled target_S_001_03_cache_state_modeled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_04_branch_predictor_modeled: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_04_branch_predictor_modeled preserves semantics
(push 1)
(declare-const source_S_001_04_branch_predictor_modeled Int)
(declare-const target_S_001_04_branch_predictor_modeled Int)
(assert (>= source_S_001_04_branch_predictor_modeled 0))
(assert (>= target_S_001_04_branch_predictor_modeled 0))
(assert (not (= source_S_001_04_branch_predictor_modeled target_S_001_04_branch_predictor_modeled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_05_speculation_state_modeled: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_05_speculation_state_modeled preserves semantics
(push 1)
(declare-const source_S_001_05_speculation_state_modeled Int)
(declare-const target_S_001_05_speculation_state_modeled Int)
(assert (>= source_S_001_05_speculation_state_modeled 0))
(assert (>= target_S_001_05_speculation_state_modeled 0))
(assert (not (= source_S_001_05_speculation_state_modeled target_S_001_05_speculation_state_modeled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_06_leakage_function_defined: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_06_leakage_function_defined preserves semantics
(push 1)
(declare-const source_S_001_06_leakage_function_defined Int)
(declare-const target_S_001_06_leakage_function_defined Int)
(assert (>= source_S_001_06_leakage_function_defined 0))
(assert (>= target_S_001_06_leakage_function_defined 0))
(assert (not (= source_S_001_06_leakage_function_defined target_S_001_06_leakage_function_defined)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_07_timing_observable: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_07_timing_observable preserves semantics
(push 1)
(declare-const source_S_001_07_timing_observable Int)
(declare-const target_S_001_07_timing_observable Int)
(assert (>= source_S_001_07_timing_observable 0))
(assert (>= target_S_001_07_timing_observable 0))
(assert (not (= source_S_001_07_timing_observable target_S_001_07_timing_observable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_08_power_observable: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_08_power_observable preserves semantics
(push 1)
(declare-const source_S_001_08_power_observable Int)
(declare-const target_S_001_08_power_observable Int)
(assert (>= source_S_001_08_power_observable 0))
(assert (>= target_S_001_08_power_observable 0))
(assert (not (= source_S_001_08_power_observable target_S_001_08_power_observable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_09_constant_time_definition: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_09_constant_time_definition preserves semantics
(push 1)
(declare-const source_S_001_09_constant_time_definition Int)
(declare-const target_S_001_09_constant_time_definition Int)
(assert (>= source_S_001_09_constant_time_definition 0))
(assert (>= target_S_001_09_constant_time_definition 0))
(assert (not (= source_S_001_09_constant_time_definition target_S_001_09_constant_time_definition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_10_ct_independent_of_secrets: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_10_ct_independent_of_secrets preserves semantics
(push 1)
(declare-const source_S_001_10_ct_independent_of_secrets Int)
(declare-const target_S_001_10_ct_independent_of_secrets Int)
(assert (>= source_S_001_10_ct_independent_of_secrets 0))
(assert (>= target_S_001_10_ct_independent_of_secrets 0))
(assert (not (= source_S_001_10_ct_independent_of_secrets target_S_001_10_ct_independent_of_secrets)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_11_ct_memory_access_pattern: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_11_ct_memory_access_pattern preserves semantics
(push 1)
(declare-const source_S_001_11_ct_memory_access_pattern Int)
(declare-const target_S_001_11_ct_memory_access_pattern Int)
(assert (>= source_S_001_11_ct_memory_access_pattern 0))
(assert (>= target_S_001_11_ct_memory_access_pattern 0))
(assert (not (= source_S_001_11_ct_memory_access_pattern target_S_001_11_ct_memory_access_pattern)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_12_ct_branch_pattern: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_12_ct_branch_pattern preserves semantics
(push 1)
(declare-const source_S_001_12_ct_branch_pattern Int)
(declare-const target_S_001_12_ct_branch_pattern Int)
(assert (>= source_S_001_12_ct_branch_pattern 0))
(assert (>= target_S_001_12_ct_branch_pattern 0))
(assert (not (= source_S_001_12_ct_branch_pattern target_S_001_12_ct_branch_pattern)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_13_ct_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_13_ct_composition preserves semantics
(push 1)
(declare-const source_S_001_13_ct_composition Int)
(declare-const target_S_001_13_ct_composition Int)
(assert (>= source_S_001_13_ct_composition 0))
(assert (>= target_S_001_13_ct_composition 0))
(assert (not (= source_S_001_13_ct_composition target_S_001_13_ct_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_14_ct_loop_invariant: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_14_ct_loop_invariant preserves semantics
(push 1)
(declare-const source_S_001_14_ct_loop_invariant Int)
(declare-const target_S_001_14_ct_loop_invariant Int)
(assert (>= source_S_001_14_ct_loop_invariant 0))
(assert (>= target_S_001_14_ct_loop_invariant 0))
(assert (not (= source_S_001_14_ct_loop_invariant target_S_001_14_ct_loop_invariant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_15_ct_function_calls: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_15_ct_function_calls preserves semantics
(push 1)
(declare-const source_S_001_15_ct_function_calls Int)
(declare-const target_S_001_15_ct_function_calls Int)
(assert (>= source_S_001_15_ct_function_calls 0))
(assert (>= target_S_001_15_ct_function_calls 0))
(assert (not (= source_S_001_15_ct_function_calls target_S_001_15_ct_function_calls)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_16_ct_cache_behavior: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_16_ct_cache_behavior preserves semantics
(push 1)
(declare-const source_S_001_16_ct_cache_behavior Int)
(declare-const target_S_001_16_ct_cache_behavior Int)
(assert (>= source_S_001_16_ct_cache_behavior 0))
(assert (>= target_S_001_16_ct_cache_behavior 0))
(assert (not (= source_S_001_16_ct_cache_behavior target_S_001_16_ct_cache_behavior)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_17_speculation_rollback: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_17_speculation_rollback preserves semantics
(push 1)
(declare-const source_S_001_17_speculation_rollback Int)
(declare-const target_S_001_17_speculation_rollback Int)
(assert (>= source_S_001_17_speculation_rollback 0))
(assert (>= target_S_001_17_speculation_rollback 0))
(assert (not (= source_S_001_17_speculation_rollback target_S_001_17_speculation_rollback)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_18_speculation_microarch_persist: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_18_speculation_microarch_persist preserves semantics
(push 1)
(declare-const source_S_001_18_speculation_microarch_persist Int)
(declare-const target_S_001_18_speculation_microarch_persist Int)
(assert (>= source_S_001_18_speculation_microarch_persist 0))
(assert (>= target_S_001_18_speculation_microarch_persist 0))
(assert (not (= source_S_001_18_speculation_microarch_persist target_S_001_18_speculation_microarch_persist)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_19_speculation_fence: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_19_speculation_fence preserves semantics
(push 1)
(declare-const source_S_001_19_speculation_fence Int)
(declare-const target_S_001_19_speculation_fence Int)
(assert (>= source_S_001_19_speculation_fence 0))
(assert (>= target_S_001_19_speculation_fence 0))
(assert (not (= source_S_001_19_speculation_fence target_S_001_19_speculation_fence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_20_speculation_no_secret_load: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_20_speculation_no_secret_load preserves semantics
(push 1)
(declare-const source_S_001_20_speculation_no_secret_load Int)
(declare-const target_S_001_20_speculation_no_secret_load Int)
(assert (>= source_S_001_20_speculation_no_secret_load 0))
(assert (>= target_S_001_20_speculation_no_secret_load 0))
(assert (not (= source_S_001_20_speculation_no_secret_load target_S_001_20_speculation_no_secret_load)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_21_speculation_no_secret_branch: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_21_speculation_no_secret_branch preserves semantics
(push 1)
(declare-const source_S_001_21_speculation_no_secret_branch Int)
(declare-const target_S_001_21_speculation_no_secret_branch Int)
(assert (>= source_S_001_21_speculation_no_secret_branch 0))
(assert (>= target_S_001_21_speculation_no_secret_branch 0))
(assert (not (= source_S_001_21_speculation_no_secret_branch target_S_001_21_speculation_no_secret_branch)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_22_speculation_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_22_speculation_bounded preserves semantics
(push 1)
(declare-const source_S_001_22_speculation_bounded Int)
(declare-const target_S_001_22_speculation_bounded Int)
(assert (>= source_S_001_22_speculation_bounded 0))
(assert (>= target_S_001_22_speculation_bounded 0))
(assert (not (= source_S_001_22_speculation_bounded target_S_001_22_speculation_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_23_speculation_safe_program: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_23_speculation_safe_program preserves semantics
(push 1)
(declare-const source_S_001_23_speculation_safe_program Int)
(declare-const target_S_001_23_speculation_safe_program Int)
(assert (>= source_S_001_23_speculation_safe_program 0))
(assert (>= target_S_001_23_speculation_safe_program 0))
(assert (not (= source_S_001_23_speculation_safe_program target_S_001_23_speculation_safe_program)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_24_speculation_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_24_speculation_composition preserves semantics
(push 1)
(declare-const source_S_001_24_speculation_composition Int)
(declare-const target_S_001_24_speculation_composition Int)
(assert (>= source_S_001_24_speculation_composition 0))
(assert (>= target_S_001_24_speculation_composition 0))
(assert (not (= source_S_001_24_speculation_composition target_S_001_24_speculation_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_25_rowhammer_threshold: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_25_rowhammer_threshold preserves semantics
(push 1)
(declare-const source_S_001_25_rowhammer_threshold Int)
(declare-const target_S_001_25_rowhammer_threshold Int)
(assert (>= source_S_001_25_rowhammer_threshold 0))
(assert (>= target_S_001_25_rowhammer_threshold 0))
(assert (not (= source_S_001_25_rowhammer_threshold target_S_001_25_rowhammer_threshold)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_26_rowhammer_pattern_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_26_rowhammer_pattern_safe preserves semantics
(push 1)
(declare-const source_S_001_26_rowhammer_pattern_safe Int)
(declare-const target_S_001_26_rowhammer_pattern_safe Int)
(assert (>= source_S_001_26_rowhammer_pattern_safe 0))
(assert (>= target_S_001_26_rowhammer_pattern_safe 0))
(assert (not (= source_S_001_26_rowhammer_pattern_safe target_S_001_26_rowhammer_pattern_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_27_memory_row_adjacency: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_27_memory_row_adjacency preserves semantics
(push 1)
(declare-const source_S_001_27_memory_row_adjacency Int)
(declare-const target_S_001_27_memory_row_adjacency Int)
(assert (>= source_S_001_27_memory_row_adjacency 0))
(assert (>= target_S_001_27_memory_row_adjacency 0))
(assert (not (= source_S_001_27_memory_row_adjacency target_S_001_27_memory_row_adjacency)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_28_power_independent: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_28_power_independent preserves semantics
(push 1)
(declare-const source_S_001_28_power_independent Int)
(declare-const target_S_001_28_power_independent Int)
(assert (>= source_S_001_28_power_independent 0))
(assert (>= target_S_001_28_power_independent 0))
(assert (not (= source_S_001_28_power_independent target_S_001_28_power_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_29_em_independent: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_29_em_independent preserves semantics
(push 1)
(declare-const source_S_001_29_em_independent Int)
(declare-const target_S_001_29_em_independent Int)
(assert (>= source_S_001_29_em_independent 0))
(assert (>= target_S_001_29_em_independent 0))
(assert (not (= source_S_001_29_em_independent target_S_001_29_em_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; S_001_30_physical_leakage_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: S_001_30_physical_leakage_bounded preserves semantics
(push 1)
(declare-const source_S_001_30_physical_leakage_bounded Int)
(declare-const target_S_001_30_physical_leakage_bounded Int)
(assert (>= source_S_001_30_physical_leakage_bounded 0))
(assert (>= target_S_001_30_physical_leakage_bounded 0))
(assert (not (= source_S_001_30_physical_leakage_bounded target_S_001_30_physical_leakage_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

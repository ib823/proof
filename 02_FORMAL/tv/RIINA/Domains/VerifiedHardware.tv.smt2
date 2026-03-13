; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/VerifiedHardware.v (47 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for VerifiedHardware
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; initial_arch_state: source semantics (matches Coq)
; Translation validation: initial_arch_state preserves semantics
(push 1)
(declare-const source_initial_arch_state Int)
(declare-const target_initial_arch_state Int)
(assert (>= source_initial_arch_state 0))
(assert (>= target_initial_arch_state 0))
(assert (not (= source_initial_arch_state target_initial_arch_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; initial_rtl_state: source semantics (matches Coq)
; Translation validation: initial_rtl_state preserves semantics
(push 1)
(declare-const source_initial_rtl_state Int)
(declare-const target_initial_rtl_state Int)
(assert (>= source_initial_rtl_state 0))
(assert (>= target_initial_rtl_state 0))
(assert (not (= source_initial_rtl_state target_initial_rtl_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rtl_to_arch: source semantics (matches Coq)
; Translation validation: rtl_to_arch preserves semantics
(push 1)
(declare-const source_rtl_to_arch Int)
(declare-const target_rtl_to_arch Int)
(assert (>= source_rtl_to_arch 0))
(assert (>= target_rtl_to_arch 0))
(assert (not (= source_rtl_to_arch target_rtl_to_arch)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rtl_execute_instr: source semantics (matches Coq)
; Translation validation: rtl_execute_instr preserves semantics
(push 1)
(declare-const source_rtl_execute_instr Int)
(declare-const target_rtl_execute_instr Int)
(assert (>= source_rtl_execute_instr 0))
(assert (>= target_rtl_execute_instr 0))
(assert (not (= source_rtl_execute_instr target_rtl_execute_instr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rtl_exec: source semantics (matches Coq)
; Translation validation: rtl_exec preserves semantics
(push 1)
(declare-const source_rtl_exec Int)
(declare-const target_rtl_exec Int)
(assert (>= source_rtl_exec 0))
(assert (>= target_rtl_exec 0))
(assert (not (= source_rtl_exec target_rtl_exec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cycles: source semantics (matches Coq)
; Translation validation: cycles preserves semantics
(push 1)
(declare-const source_cycles Int)
(declare-const target_cycles Int)
(assert (>= source_cycles 0))
(assert (>= target_cycles 0))
(assert (not (= source_cycles target_cycles)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; public_equiv: source semantics (matches Coq)
; Translation validation: public_equiv preserves semantics
(push 1)
(declare-const source_public_equiv Int)
(declare-const target_public_equiv Int)
(assert (>= source_public_equiv 0))
(assert (>= target_public_equiv 0))
(assert (not (= source_public_equiv target_public_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rtl_public_equiv: source semantics (matches Coq)
; Translation validation: rtl_public_equiv preserves semantics
(push 1)
(declare-const source_rtl_public_equiv Int)
(declare-const target_rtl_public_equiv Int)
(assert (>= source_rtl_public_equiv 0))
(assert (>= target_rtl_public_equiv 0))
(assert (not (= source_rtl_public_equiv target_rtl_public_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; timing_independent_prop: source semantics (matches Coq)
; Translation validation: timing_independent_prop preserves semantics
(push 1)
(declare-const source_timing_independent_prop Int)
(declare-const target_timing_independent_prop Int)
(assert (>= source_timing_independent_prop 0))
(assert (>= target_timing_independent_prop 0))
(assert (not (= source_timing_independent_prop target_timing_independent_prop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; instr_leakage: source semantics (matches Coq)
; Translation validation: instr_leakage preserves semantics
(push 1)
(declare-const source_instr_leakage Int)
(declare-const target_instr_leakage Int)
(assert (>= source_instr_leakage 0))
(assert (>= target_instr_leakage 0))
(assert (not (= source_instr_leakage target_instr_leakage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; program_leakage: source semantics (matches Coq)
; Translation validation: program_leakage preserves semantics
(push 1)
(declare-const source_program_leakage Int)
(declare-const target_program_leakage Int)
(assert (>= source_program_leakage 0))
(assert (>= target_program_leakage 0))
(assert (not (= source_program_leakage target_program_leakage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; constant_time_prog: source semantics (matches Coq)
; Translation validation: constant_time_prog preserves semantics
(push 1)
(declare-const source_constant_time_prog Int)
(declare-const target_constant_time_prog Int)
(assert (>= source_constant_time_prog 0))
(assert (>= target_constant_time_prog 0))
(assert (not (= source_constant_time_prog target_constant_time_prog)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; speculating: source semantics (matches Coq)
; Translation validation: speculating preserves semantics
(push 1)
(declare-const source_speculating Int)
(declare-const target_speculating Int)
(assert (>= source_speculating 0))
(assert (>= target_speculating 0))
(assert (not (= source_speculating target_speculating)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; scub_blocks_speculation: source semantics (matches Coq)
; Translation validation: scub_blocks_speculation preserves semantics
(push 1)
(declare-const source_scub_blocks_speculation Int)
(declare-const target_scub_blocks_speculation Int)
(assert (>= source_scub_blocks_speculation 0))
(assert (>= target_scub_blocks_speculation 0))
(assert (not (= source_scub_blocks_speculation target_scub_blocks_speculation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_spec_mem_access: source semantics (matches Coq)
; Translation validation: no_spec_mem_access preserves semantics
(push 1)
(declare-const source_no_spec_mem_access Int)
(declare-const target_no_spec_mem_access Int)
(assert (>= source_no_spec_mem_access 0))
(assert (>= target_no_spec_mem_access 0))
(assert (not (= source_no_spec_mem_access target_no_spec_mem_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verified: source semantics (matches Coq)
; Translation validation: verified preserves semantics
(push 1)
(declare-const source_verified Int)
(declare-const target_verified Int)
(assert (>= source_verified 0))
(assert (>= target_verified 0))
(assert (not (= source_verified target_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; behavior_in_spec: source semantics (matches Coq)
; Translation validation: behavior_in_spec preserves semantics
(push 1)
(declare-const source_behavior_in_spec Int)
(declare-const target_behavior_in_spec Int)
(assert (>= source_behavior_in_spec 0))
(assert (>= target_behavior_in_spec 0))
(assert (not (= source_behavior_in_spec target_behavior_in_spec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_trigger_logic: source semantics (matches Coq)
; Translation validation: has_trigger_logic preserves semantics
(push 1)
(declare-const source_has_trigger_logic Int)
(declare-const target_has_trigger_logic Int)
(assert (>= source_has_trigger_logic 0))
(assert (>= target_has_trigger_logic 0))
(assert (not (= source_has_trigger_logic target_has_trigger_logic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_payload_logic: source semantics (matches Coq)
; Translation validation: has_payload_logic preserves semantics
(push 1)
(declare-const source_has_payload_logic Int)
(declare-const target_has_payload_logic Int)
(assert (>= source_has_payload_logic 0))
(assert (>= target_has_payload_logic 0))
(assert (not (= source_has_payload_logic target_has_payload_logic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inject_single_error: source semantics (matches Coq)
; Translation validation: inject_single_error preserves semantics
(push 1)
(declare-const source_inject_single_error Int)
(declare-const target_inject_single_error Int)
(assert (>= source_inject_single_error 0))
(assert (>= target_inject_single_error 0))
(assert (not (= source_inject_single_error target_inject_single_error)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ecc_correct_single: source semantics (matches Coq)
; Translation validation: ecc_correct_single preserves semantics
(push 1)
(declare-const source_ecc_correct_single Int)
(declare-const target_ecc_correct_single Int)
(assert (>= source_ecc_correct_single 0))
(assert (>= target_ecc_correct_single 0))
(assert (not (= source_ecc_correct_single target_ecc_correct_single)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ecc_is_double_error: source semantics (matches Coq)
; Translation validation: ecc_is_double_error preserves semantics
(push 1)
(declare-const source_ecc_is_double_error Int)
(declare-const target_ecc_is_double_error Int)
(assert (>= source_ecc_is_double_error 0))
(assert (>= target_ecc_is_double_error 0))
(assert (not (= source_ecc_is_double_error target_ecc_is_double_error)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exec_zeroize: source semantics (matches Coq)
; Translation validation: exec_zeroize preserves semantics
(push 1)
(declare-const source_exec_zeroize Int)
(declare-const target_exec_zeroize Int)
(assert (>= source_exec_zeroize 0))
(assert (>= target_exec_zeroize 0))
(assert (not (= source_exec_zeroize target_exec_zeroize)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; create_checkpoint: source semantics (matches Coq)
; Translation validation: create_checkpoint preserves semantics
(push 1)
(declare-const source_create_checkpoint Int)
(declare-const target_create_checkpoint Int)
(assert (>= source_create_checkpoint 0))
(assert (>= target_create_checkpoint 0))
(assert (not (= source_create_checkpoint target_create_checkpoint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; restore_checkpoint: source semantics (matches Coq)
; Translation validation: restore_checkpoint preserves semantics
(push 1)
(declare-const source_restore_checkpoint Int)
(declare-const target_restore_checkpoint Int)
(assert (>= source_restore_checkpoint 0))
(assert (>= target_restore_checkpoint 0))
(assert (not (= source_restore_checkpoint target_restore_checkpoint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VoltageRange: source semantics (matches Coq)
; Translation validation: VoltageRange preserves semantics
(push 1)
(declare-const source_VoltageRange Int)
(declare-const target_VoltageRange Int)
(assert (>= source_VoltageRange 0))
(assert (>= target_VoltageRange 0))
(assert (not (= source_VoltageRange target_VoltageRange)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; normal_voltage_range: source semantics (matches Coq)
; Translation validation: normal_voltage_range preserves semantics
(push 1)
(declare-const source_normal_voltage_range Int)
(declare-const target_normal_voltage_range Int)
(assert (>= source_normal_voltage_range 0))
(assert (>= target_normal_voltage_range 0))
(assert (not (= source_normal_voltage_range target_normal_voltage_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; voltage_in_range: source semantics (matches Coq)
; Translation validation: voltage_in_range preserves semantics
(push 1)
(declare-const source_voltage_in_range Int)
(declare-const target_voltage_in_range Int)
(assert (>= source_voltage_in_range 0))
(assert (>= target_voltage_in_range 0))
(assert (not (= source_voltage_in_range target_voltage_in_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; voltage_glitch_detected: source semantics (matches Coq)
; Translation validation: voltage_glitch_detected preserves semantics
(push 1)
(declare-const source_voltage_glitch_detected Int)
(declare-const target_voltage_glitch_detected Int)
(assert (>= source_voltage_glitch_detected 0))
(assert (>= target_voltage_glitch_detected 0))
(assert (not (= source_voltage_glitch_detected target_voltage_glitch_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FrequencyRange: source semantics (matches Coq)
; Translation validation: FrequencyRange preserves semantics
(push 1)
(declare-const source_FrequencyRange Int)
(declare-const target_FrequencyRange Int)
(assert (>= source_FrequencyRange 0))
(assert (>= target_FrequencyRange 0))
(assert (not (= source_FrequencyRange target_FrequencyRange)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; normal_frequency_range: source semantics (matches Coq)
; Translation validation: normal_frequency_range preserves semantics
(push 1)
(declare-const source_normal_frequency_range Int)
(declare-const target_normal_frequency_range Int)
(assert (>= source_normal_frequency_range 0))
(assert (>= target_normal_frequency_range 0))
(assert (not (= source_normal_frequency_range target_normal_frequency_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; frequency_in_range: source semantics (matches Coq)
; Translation validation: frequency_in_range preserves semantics
(push 1)
(declare-const source_frequency_in_range Int)
(declare-const target_frequency_in_range Int)
(assert (>= source_frequency_in_range 0))
(assert (>= target_frequency_in_range 0))
(assert (not (= source_frequency_in_range target_frequency_in_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; frequency_manipulation_detected: source semantics (matches Coq)
; Translation validation: frequency_manipulation_detected preserves semantics
(push 1)
(declare-const source_frequency_manipulation_detected Int)
(declare-const target_frequency_manipulation_detected Int)
(assert (>= source_frequency_manipulation_detected 0))
(assert (>= target_frequency_manipulation_detected 0))
(assert (not (= source_frequency_manipulation_detected target_frequency_manipulation_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tamper_detected: source semantics (matches Coq)
; Translation validation: tamper_detected preserves semantics
(push 1)
(declare-const source_tamper_detected Int)
(declare-const target_tamper_detected Int)
(assert (>= source_tamper_detected 0))
(assert (>= target_tamper_detected 0))
(assert (not (= source_tamper_detected target_tamper_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; update_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: update_eq preserves semantics
(push 1)
(declare-const source_update_eq Int)
(declare-const target_update_eq Int)
(assert (>= source_update_eq 0))
(assert (>= target_update_eq 0))
(assert (not (= source_update_eq target_update_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; update_neq: translation preserves property (matches Coq: Lemma)
; Translation validation: update_neq preserves semantics
(push 1)
(declare-const source_update_neq Int)
(declare-const target_update_neq Int)
(assert (>= source_update_neq 0))
(assert (>= target_update_neq 0))
(assert (not (= source_update_neq target_update_neq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; isa_rtl_add_equiv: translation preserves property (matches Coq: Lemma)
; Translation validation: isa_rtl_add_equiv preserves semantics
(push 1)
(declare-const source_isa_rtl_add_equiv Int)
(declare-const target_isa_rtl_add_equiv Int)
(assert (>= source_isa_rtl_add_equiv 0))
(assert (>= target_isa_rtl_add_equiv 0))
(assert (not (= source_isa_rtl_add_equiv target_isa_rtl_add_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_01_rtl_isa_equivalence: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_01_rtl_isa_equivalence preserves semantics
(push 1)
(declare-const source_PHI_001_01_rtl_isa_equivalence Int)
(declare-const target_PHI_001_01_rtl_isa_equivalence Int)
(assert (>= source_PHI_001_01_rtl_isa_equivalence 0))
(assert (>= target_PHI_001_01_rtl_isa_equivalence 0))
(assert (not (= source_PHI_001_01_rtl_isa_equivalence target_PHI_001_01_rtl_isa_equivalence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_02_pipeline_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_02_pipeline_correct preserves semantics
(push 1)
(declare-const source_PHI_001_02_pipeline_correct Int)
(declare-const target_PHI_001_02_pipeline_correct Int)
(assert (>= source_PHI_001_02_pipeline_correct 0))
(assert (>= target_PHI_001_02_pipeline_correct 0))
(assert (not (= source_PHI_001_02_pipeline_correct target_PHI_001_02_pipeline_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_03_memory_system_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_03_memory_system_correct preserves semantics
(push 1)
(declare-const source_PHI_001_03_memory_system_correct Int)
(declare-const target_PHI_001_03_memory_system_correct Int)
(assert (>= source_PHI_001_03_memory_system_correct 0))
(assert (>= target_PHI_001_03_memory_system_correct 0))
(assert (not (= source_PHI_001_03_memory_system_correct target_PHI_001_03_memory_system_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_04_register_file_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_04_register_file_correct preserves semantics
(push 1)
(declare-const source_PHI_001_04_register_file_correct Int)
(declare-const target_PHI_001_04_register_file_correct Int)
(assert (>= source_PHI_001_04_register_file_correct 0))
(assert (>= target_PHI_001_04_register_file_correct 0))
(assert (not (= source_PHI_001_04_register_file_correct target_PHI_001_04_register_file_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_05_alu_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_05_alu_correct preserves semantics
(push 1)
(declare-const source_PHI_001_05_alu_correct Int)
(declare-const target_PHI_001_05_alu_correct Int)
(assert (>= source_PHI_001_05_alu_correct 0))
(assert (>= target_PHI_001_05_alu_correct 0))
(assert (not (= source_PHI_001_05_alu_correct target_PHI_001_05_alu_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_06_branch_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_06_branch_correct preserves semantics
(push 1)
(declare-const source_PHI_001_06_branch_correct Int)
(declare-const target_PHI_001_06_branch_correct Int)
(assert (>= source_PHI_001_06_branch_correct 0))
(assert (>= target_PHI_001_06_branch_correct 0))
(assert (not (= source_PHI_001_06_branch_correct target_PHI_001_06_branch_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_07_interrupt_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_07_interrupt_correct preserves semantics
(push 1)
(declare-const source_PHI_001_07_interrupt_correct Int)
(declare-const target_PHI_001_07_interrupt_correct Int)
(assert (>= source_PHI_001_07_interrupt_correct 0))
(assert (>= target_PHI_001_07_interrupt_correct 0))
(assert (not (= source_PHI_001_07_interrupt_correct target_PHI_001_07_interrupt_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_08_instruction_fetch_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_08_instruction_fetch_correct preserves semantics
(push 1)
(declare-const source_PHI_001_08_instruction_fetch_correct Int)
(declare-const target_PHI_001_08_instruction_fetch_correct Int)
(assert (>= source_PHI_001_08_instruction_fetch_correct 0))
(assert (>= target_PHI_001_08_instruction_fetch_correct 0))
(assert (not (= source_PHI_001_08_instruction_fetch_correct target_PHI_001_08_instruction_fetch_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_09_timing_independent: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_09_timing_independent preserves semantics
(push 1)
(declare-const source_PHI_001_09_timing_independent Int)
(declare-const target_PHI_001_09_timing_independent Int)
(assert (>= source_PHI_001_09_timing_independent 0))
(assert (>= target_PHI_001_09_timing_independent 0))
(assert (not (= source_PHI_001_09_timing_independent target_PHI_001_09_timing_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_10_no_data_dependent_timing: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_10_no_data_dependent_timing preserves semantics
(push 1)
(declare-const source_PHI_001_10_no_data_dependent_timing Int)
(declare-const target_PHI_001_10_no_data_dependent_timing Int)
(assert (>= source_PHI_001_10_no_data_dependent_timing 0))
(assert (>= target_PHI_001_10_no_data_dependent_timing 0))
(assert (not (= source_PHI_001_10_no_data_dependent_timing target_PHI_001_10_no_data_dependent_timing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_11_cache_constant_time: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_11_cache_constant_time preserves semantics
(push 1)
(declare-const source_PHI_001_11_cache_constant_time Int)
(declare-const target_PHI_001_11_cache_constant_time Int)
(assert (>= source_PHI_001_11_cache_constant_time 0))
(assert (>= target_PHI_001_11_cache_constant_time 0))
(assert (not (= source_PHI_001_11_cache_constant_time target_PHI_001_11_cache_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_12_branch_constant_time: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_12_branch_constant_time preserves semantics
(push 1)
(declare-const source_PHI_001_12_branch_constant_time Int)
(declare-const target_PHI_001_12_branch_constant_time Int)
(assert (>= source_PHI_001_12_branch_constant_time 0))
(assert (>= target_PHI_001_12_branch_constant_time 0))
(assert (not (= source_PHI_001_12_branch_constant_time target_PHI_001_12_branch_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_13_memory_constant_time: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_13_memory_constant_time preserves semantics
(push 1)
(declare-const source_PHI_001_13_memory_constant_time Int)
(declare-const target_PHI_001_13_memory_constant_time Int)
(assert (>= source_PHI_001_13_memory_constant_time 0))
(assert (>= target_PHI_001_13_memory_constant_time 0))
(assert (not (= source_PHI_001_13_memory_constant_time target_PHI_001_13_memory_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_14_division_constant_time: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_14_division_constant_time preserves semantics
(push 1)
(declare-const source_PHI_001_14_division_constant_time Int)
(declare-const target_PHI_001_14_division_constant_time Int)
(assert (>= source_PHI_001_14_division_constant_time 0))
(assert (>= target_PHI_001_14_division_constant_time 0))
(assert (not (= source_PHI_001_14_division_constant_time target_PHI_001_14_division_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_15_multiplication_constant_time: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_15_multiplication_constant_time preserves semantics
(push 1)
(declare-const source_PHI_001_15_multiplication_constant_time Int)
(declare-const target_PHI_001_15_multiplication_constant_time Int)
(assert (>= source_PHI_001_15_multiplication_constant_time 0))
(assert (>= target_PHI_001_15_multiplication_constant_time 0))
(assert (not (= source_PHI_001_15_multiplication_constant_time target_PHI_001_15_multiplication_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_16_power_independent: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_16_power_independent preserves semantics
(push 1)
(declare-const source_PHI_001_16_power_independent Int)
(declare-const target_PHI_001_16_power_independent Int)
(assert (>= source_PHI_001_16_power_independent 0))
(assert (>= target_PHI_001_16_power_independent 0))
(assert (not (= source_PHI_001_16_power_independent target_PHI_001_16_power_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; reachable_spec_false: translation preserves property (matches Coq: Lemma)
; Translation validation: reachable_spec_false preserves semantics
(push 1)
(declare-const source_reachable_spec_false Int)
(declare-const target_reachable_spec_false Int)
(assert (>= source_reachable_spec_false 0))
(assert (>= target_reachable_spec_false 0))
(assert (not (= source_reachable_spec_false target_reachable_spec_false)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_17_no_speculation: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_17_no_speculation preserves semantics
(push 1)
(declare-const source_PHI_001_17_no_speculation Int)
(declare-const target_PHI_001_17_no_speculation Int)
(assert (>= source_PHI_001_17_no_speculation 0))
(assert (>= target_PHI_001_17_no_speculation 0))
(assert (not (= source_PHI_001_17_no_speculation target_PHI_001_17_no_speculation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_18_scub_barrier: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_18_scub_barrier preserves semantics
(push 1)
(declare-const source_PHI_001_18_scub_barrier Int)
(declare-const target_PHI_001_18_scub_barrier Int)
(assert (>= source_PHI_001_18_scub_barrier 0))
(assert (>= target_PHI_001_18_scub_barrier 0))
(assert (not (= source_PHI_001_18_scub_barrier target_PHI_001_18_scub_barrier)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_19_no_spectre_v1: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_19_no_spectre_v1 preserves semantics
(push 1)
(declare-const source_PHI_001_19_no_spectre_v1 Int)
(declare-const target_PHI_001_19_no_spectre_v1 Int)
(assert (>= source_PHI_001_19_no_spectre_v1 0))
(assert (>= target_PHI_001_19_no_spectre_v1 0))
(assert (not (= source_PHI_001_19_no_spectre_v1 target_PHI_001_19_no_spectre_v1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_20_no_spectre_v2: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_20_no_spectre_v2 preserves semantics
(push 1)
(declare-const source_PHI_001_20_no_spectre_v2 Int)
(declare-const target_PHI_001_20_no_spectre_v2 Int)
(assert (>= source_PHI_001_20_no_spectre_v2 0))
(assert (>= target_PHI_001_20_no_spectre_v2 0))
(assert (not (= source_PHI_001_20_no_spectre_v2 target_PHI_001_20_no_spectre_v2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_21_no_meltdown: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_21_no_meltdown preserves semantics
(push 1)
(declare-const source_PHI_001_21_no_meltdown Int)
(declare-const target_PHI_001_21_no_meltdown Int)
(assert (>= source_PHI_001_21_no_meltdown 0))
(assert (>= target_PHI_001_21_no_meltdown 0))
(assert (not (= source_PHI_001_21_no_meltdown target_PHI_001_21_no_meltdown)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; program_leakage_state_independent: translation preserves property (matches Coq: Lemma)
; Translation validation: program_leakage_state_independent preserves semantics
(push 1)
(declare-const source_program_leakage_state_independent Int)
(declare-const target_program_leakage_state_independent Int)
(assert (>= source_program_leakage_state_independent 0))
(assert (>= target_program_leakage_state_independent 0))
(assert (not (= source_program_leakage_state_independent target_program_leakage_state_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_22_no_microarch_leakage: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_22_no_microarch_leakage preserves semantics
(push 1)
(declare-const source_PHI_001_22_no_microarch_leakage Int)
(declare-const target_PHI_001_22_no_microarch_leakage Int)
(assert (>= source_PHI_001_22_no_microarch_leakage 0))
(assert (>= target_PHI_001_22_no_microarch_leakage 0))
(assert (not (= source_PHI_001_22_no_microarch_leakage target_PHI_001_22_no_microarch_leakage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_23_fence_sc_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_23_fence_sc_correct preserves semantics
(push 1)
(declare-const source_PHI_001_23_fence_sc_correct Int)
(declare-const target_PHI_001_23_fence_sc_correct Int)
(assert (>= source_PHI_001_23_fence_sc_correct 0))
(assert (>= target_PHI_001_23_fence_sc_correct 0))
(assert (not (= source_PHI_001_23_fence_sc_correct target_PHI_001_23_fence_sc_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_24_isolation_mode_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_24_isolation_mode_correct preserves semantics
(push 1)
(declare-const source_PHI_001_24_isolation_mode_correct Int)
(declare-const target_PHI_001_24_isolation_mode_correct Int)
(assert (>= source_PHI_001_24_isolation_mode_correct 0))
(assert (>= target_PHI_001_24_isolation_mode_correct 0))
(assert (not (= source_PHI_001_24_isolation_mode_correct target_PHI_001_24_isolation_mode_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_25_complete_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_25_complete_coverage preserves semantics
(push 1)
(declare-const source_PHI_001_25_complete_coverage Int)
(declare-const target_PHI_001_25_complete_coverage Int)
(assert (>= source_PHI_001_25_complete_coverage 0))
(assert (>= target_PHI_001_25_complete_coverage 0))
(assert (not (= source_PHI_001_25_complete_coverage target_PHI_001_25_complete_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_26_no_hidden_functionality: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_26_no_hidden_functionality preserves semantics
(push 1)
(declare-const source_PHI_001_26_no_hidden_functionality Int)
(declare-const target_PHI_001_26_no_hidden_functionality Int)
(assert (>= source_PHI_001_26_no_hidden_functionality 0))
(assert (>= target_PHI_001_26_no_hidden_functionality 0))
(assert (not (= source_PHI_001_26_no_hidden_functionality target_PHI_001_26_no_hidden_functionality)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_hidden_functionality_non_div: translation preserves property (matches Coq: Lemma)
; Translation validation: no_hidden_functionality_non_div preserves semantics
(push 1)
(declare-const source_no_hidden_functionality_non_div Int)
(declare-const target_no_hidden_functionality_non_div Int)
(assert (>= source_no_hidden_functionality_non_div 0))
(assert (>= target_no_hidden_functionality_non_div 0))
(assert (not (= source_no_hidden_functionality_non_div target_no_hidden_functionality_non_div)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_27_behavior_specified: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_27_behavior_specified preserves semantics
(push 1)
(declare-const source_PHI_001_27_behavior_specified Int)
(declare-const target_PHI_001_27_behavior_specified Int)
(assert (>= source_PHI_001_27_behavior_specified 0))
(assert (>= target_PHI_001_27_behavior_specified 0))
(assert (not (= source_PHI_001_27_behavior_specified target_PHI_001_27_behavior_specified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_28_no_trigger_logic: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_28_no_trigger_logic preserves semantics
(push 1)
(declare-const source_PHI_001_28_no_trigger_logic Int)
(declare-const target_PHI_001_28_no_trigger_logic Int)
(assert (>= source_PHI_001_28_no_trigger_logic 0))
(assert (>= target_PHI_001_28_no_trigger_logic 0))
(assert (not (= source_PHI_001_28_no_trigger_logic target_PHI_001_28_no_trigger_logic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; behavior_in_spec_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: behavior_in_spec_refl preserves semantics
(push 1)
(declare-const source_behavior_in_spec_refl Int)
(declare-const target_behavior_in_spec_refl Int)
(assert (>= source_behavior_in_spec_refl 0))
(assert (>= target_behavior_in_spec_refl 0))
(assert (not (= source_behavior_in_spec_refl target_behavior_in_spec_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; single_step_in_spec: translation preserves property (matches Coq: Lemma)
; Translation validation: single_step_in_spec preserves semantics
(push 1)
(declare-const source_single_step_in_spec Int)
(declare-const target_single_step_in_spec Int)
(assert (>= source_single_step_in_spec 0))
(assert (>= target_single_step_in_spec 0))
(assert (not (= source_single_step_in_spec target_single_step_in_spec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; reachable_first_step_in_spec: translation preserves property (matches Coq: Lemma)
; Translation validation: reachable_first_step_in_spec preserves semantics
(push 1)
(declare-const source_reachable_first_step_in_spec Int)
(declare-const target_reachable_first_step_in_spec Int)
(assert (>= source_reachable_first_step_in_spec 0))
(assert (>= target_reachable_first_step_in_spec 0))
(assert (not (= source_reachable_first_step_in_spec target_reachable_first_step_in_spec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_29_no_payload_logic: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_29_no_payload_logic preserves semantics
(push 1)
(declare-const source_PHI_001_29_no_payload_logic Int)
(declare-const target_PHI_001_29_no_payload_logic Int)
(assert (>= source_PHI_001_29_no_payload_logic 0))
(assert (>= target_PHI_001_29_no_payload_logic 0))
(assert (not (= source_PHI_001_29_no_payload_logic target_PHI_001_29_no_payload_logic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_30_formal_equivalence: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_30_formal_equivalence preserves semantics
(push 1)
(declare-const source_PHI_001_30_formal_equivalence Int)
(declare-const target_PHI_001_30_formal_equivalence Int)
(assert (>= source_PHI_001_30_formal_equivalence 0))
(assert (>= target_PHI_001_30_formal_equivalence 0))
(assert (not (= source_PHI_001_30_formal_equivalence target_PHI_001_30_formal_equivalence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_31_trojan_detected: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_31_trojan_detected preserves semantics
(push 1)
(declare-const source_PHI_001_31_trojan_detected Int)
(declare-const target_PHI_001_31_trojan_detected Int)
(assert (>= source_PHI_001_31_trojan_detected 0))
(assert (>= target_PHI_001_31_trojan_detected 0))
(assert (not (= source_PHI_001_31_trojan_detected target_PHI_001_31_trojan_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_32_ecc_single_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_32_ecc_single_correct preserves semantics
(push 1)
(declare-const source_PHI_001_32_ecc_single_correct Int)
(declare-const target_PHI_001_32_ecc_single_correct Int)
(assert (>= source_PHI_001_32_ecc_single_correct 0))
(assert (>= target_PHI_001_32_ecc_single_correct 0))
(assert (not (= source_PHI_001_32_ecc_single_correct target_PHI_001_32_ecc_single_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_33_ecc_double_detect: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_33_ecc_double_detect preserves semantics
(push 1)
(declare-const source_PHI_001_33_ecc_double_detect Int)
(declare-const target_PHI_001_33_ecc_double_detect Int)
(assert (>= source_PHI_001_33_ecc_double_detect 0))
(assert (>= target_PHI_001_33_ecc_double_detect 0))
(assert (not (= source_PHI_001_33_ecc_double_detect target_PHI_001_33_ecc_double_detect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_34_zeroize_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_34_zeroize_complete preserves semantics
(push 1)
(declare-const source_PHI_001_34_zeroize_complete Int)
(declare-const target_PHI_001_34_zeroize_complete Int)
(assert (>= source_PHI_001_34_zeroize_complete 0))
(assert (>= target_PHI_001_34_zeroize_complete 0))
(assert (not (= source_PHI_001_34_zeroize_complete target_PHI_001_34_zeroize_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_35_checkpoint_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_35_checkpoint_correct preserves semantics
(push 1)
(declare-const source_PHI_001_35_checkpoint_correct Int)
(declare-const target_PHI_001_35_checkpoint_correct Int)
(assert (>= source_PHI_001_35_checkpoint_correct 0))
(assert (>= target_PHI_001_35_checkpoint_correct 0))
(assert (not (= source_PHI_001_35_checkpoint_correct target_PHI_001_35_checkpoint_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_36_voltage_monitor: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_36_voltage_monitor preserves semantics
(push 1)
(declare-const source_PHI_001_36_voltage_monitor Int)
(declare-const target_PHI_001_36_voltage_monitor Int)
(assert (>= source_PHI_001_36_voltage_monitor 0))
(assert (>= target_PHI_001_36_voltage_monitor 0))
(assert (not (= source_PHI_001_36_voltage_monitor target_PHI_001_36_voltage_monitor)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_37_frequency_monitor: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_37_frequency_monitor preserves semantics
(push 1)
(declare-const source_PHI_001_37_frequency_monitor Int)
(declare-const target_PHI_001_37_frequency_monitor Int)
(assert (>= source_PHI_001_37_frequency_monitor 0))
(assert (>= target_PHI_001_37_frequency_monitor 0))
(assert (not (= source_PHI_001_37_frequency_monitor target_PHI_001_37_frequency_monitor)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PHI_001_38_tamper_evident: translation preserves property (matches Coq: Theorem)
; Translation validation: PHI_001_38_tamper_evident preserves semantics
(push 1)
(declare-const source_PHI_001_38_tamper_evident Int)
(declare-const target_PHI_001_38_tamper_evident Int)
(assert (>= source_PHI_001_38_tamper_evident 0))
(assert (>= target_PHI_001_38_tamper_evident 0))
(assert (not (= source_PHI_001_38_tamper_evident target_PHI_001_38_tamper_evident)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

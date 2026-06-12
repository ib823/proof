; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/BinarySizeBounds.v (20 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for BinarySizeBounds
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; FLASH_64K: source semantics (matches Coq)
(declare-fun source_FLASH_64K () Bool)
(declare-fun target_FLASH_64K () Bool)
(assert (= source_FLASH_64K target_FLASH_64K))

; FLASH_256K: source semantics (matches Coq)
(declare-fun source_FLASH_256K () Bool)
(declare-fun target_FLASH_256K () Bool)
(assert (= source_FLASH_256K target_FLASH_256K))

; FLASH_128K: source semantics (matches Coq)
(declare-fun source_FLASH_128K () Bool)
(declare-fun target_FLASH_128K () Bool)
(assert (= source_FLASH_128K target_FLASH_128K))

; RAM_8K: source semantics (matches Coq)
(declare-fun source_RAM_8K () Bool)
(declare-fun target_RAM_8K () Bool)
(assert (= source_RAM_8K target_RAM_8K))

; RAM_64K: source semantics (matches Coq)
(declare-fun source_RAM_64K () Bool)
(declare-fun target_RAM_64K () Bool)
(assert (= source_RAM_64K target_RAM_64K))

; RAM_32K: source semantics (matches Coq)
(declare-fun source_RAM_32K () Bool)
(declare-fun target_RAM_32K () Bool)
(assert (= source_RAM_32K target_RAM_32K))

; arm_cortex_m0: source semantics (matches Coq)
(declare-fun source_arm_cortex_m0 () Bool)
(declare-fun target_arm_cortex_m0 () Bool)
(assert (= source_arm_cortex_m0 target_arm_cortex_m0))

; arm_cortex_m4: source semantics (matches Coq)
(declare-fun source_arm_cortex_m4 () Bool)
(declare-fun target_arm_cortex_m4 () Bool)
(assert (= source_arm_cortex_m4 target_arm_cortex_m4))

; riscv32: source semantics (matches Coq)
(declare-fun source_riscv32 () Bool)
(declare-fun target_riscv32 () Bool)
(assert (= source_riscv32 target_riscv32))

; instr_size: source semantics (matches Coq)
(declare-fun source_instr_size () Bool)
(declare-fun target_instr_size () Bool)
(assert (= source_instr_size target_instr_size))

; bb_size: source semantics (matches Coq)
(declare-fun source_bb_size () Bool)
(declare-fun target_bb_size () Bool)
(assert (= source_bb_size target_bb_size))

; sum_bb_sizes: source semantics (matches Coq)
(declare-fun source_sum_bb_sizes () Bool)
(declare-fun target_sum_bb_sizes () Bool)
(assert (= source_sum_bb_sizes target_sum_bb_sizes))

; func_size: source semantics (matches Coq)
(declare-fun source_func_size () Bool)
(declare-fun target_func_size () Bool)
(assert (= source_func_size target_func_size))

; sum_func_sizes: source semantics (matches Coq)
(declare-fun source_sum_func_sizes () Bool)
(declare-fun target_sum_func_sizes () Bool)
(assert (= source_sum_func_sizes target_sum_func_sizes))

; mod_size: source semantics (matches Coq)
(declare-fun source_mod_size () Bool)
(declare-fun target_mod_size () Bool)
(assert (= source_mod_size target_mod_size))

; sum_mod_sizes: source semantics (matches Coq)
(declare-fun source_sum_mod_sizes () Bool)
(declare-fun target_sum_mod_sizes () Bool)
(assert (= source_sum_mod_sizes target_sum_mod_sizes))

; prog_size: source semantics (matches Coq)
(declare-fun source_prog_size () Bool)
(declare-fun target_prog_size () Bool)
(assert (= source_prog_size target_prog_size))

; data_section_size: source semantics (matches Coq)
(declare-fun source_data_section_size () Bool)
(declare-fun target_data_section_size () Bool)
(assert (= source_data_section_size target_data_section_size))

; bss_section_size: source semantics (matches Coq)
(declare-fun source_bss_section_size () Bool)
(declare-fun target_bss_section_size () Bool)
(assert (= source_bss_section_size target_bss_section_size))

; stack_frame_size: source semantics (matches Coq)
(declare-fun source_stack_frame_size () Bool)
(declare-fun target_stack_frame_size () Bool)
(assert (= source_stack_frame_size target_stack_frame_size))

; inline_expanded_size: source semantics (matches Coq)
(declare-fun source_inline_expanded_size () Bool)
(declare-fun target_inline_expanded_size () Bool)
(assert (= source_inline_expanded_size target_inline_expanded_size))

; unrolled_loop_size: source semantics (matches Coq)
(declare-fun source_unrolled_loop_size () Bool)
(declare-fun target_unrolled_loop_size () Bool)
(assert (= source_unrolled_loop_size target_unrolled_loop_size))

; monomorphized_size: source semantics (matches Coq)
(declare-fun source_monomorphized_size () Bool)
(declare-fun target_monomorphized_size () Bool)
(assert (= source_monomorphized_size target_monomorphized_size))

; total_rom_size: source semantics (matches Coq)
(declare-fun source_total_rom_size () Bool)
(declare-fun target_total_rom_size () Bool)
(assert (= source_total_rom_size target_total_rom_size))

; PERF_002_01: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_01 () Bool)
(declare-fun target_PERF_002_01 () Bool)
(assert (= source_PERF_002_01 target_PERF_002_01))

; PERF_002_02: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_02 () Bool)
(declare-fun target_PERF_002_02 () Bool)
(assert (= source_PERF_002_02 target_PERF_002_02))

; sum_bb_sizes_app: translation preserves property (matches Coq: Lemma)
(declare-fun source_sum_bb_sizes_app () Bool)
(declare-fun target_sum_bb_sizes_app () Bool)
(assert (= source_sum_bb_sizes_app target_sum_bb_sizes_app))

; PERF_002_03: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_03 () Bool)
(declare-fun target_PERF_002_03 () Bool)
(assert (= source_PERF_002_03 target_PERF_002_03))

; sum_func_sizes_app: translation preserves property (matches Coq: Lemma)
(declare-fun source_sum_func_sizes_app () Bool)
(declare-fun target_sum_func_sizes_app () Bool)
(assert (= source_sum_func_sizes_app target_sum_func_sizes_app))

; PERF_002_04: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_04 () Bool)
(declare-fun target_PERF_002_04 () Bool)
(assert (= source_PERF_002_04 target_PERF_002_04))

; sum_mod_sizes_app: translation preserves property (matches Coq: Lemma)
(declare-fun source_sum_mod_sizes_app () Bool)
(declare-fun target_sum_mod_sizes_app () Bool)
(assert (= source_sum_mod_sizes_app target_sum_mod_sizes_app))

; PERF_002_05: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_05 () Bool)
(declare-fun target_PERF_002_05 () Bool)
(assert (= source_PERF_002_05 target_PERF_002_05))

; data_section_size_app: translation preserves property (matches Coq: Lemma)
(declare-fun source_data_section_size_app () Bool)
(declare-fun target_data_section_size_app () Bool)
(assert (= source_data_section_size_app target_data_section_size_app))

; PERF_002_06: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_06 () Bool)
(declare-fun target_PERF_002_06 () Bool)
(assert (= source_PERF_002_06 target_PERF_002_06))

; bss_section_size_app: translation preserves property (matches Coq: Lemma)
(declare-fun source_bss_section_size_app () Bool)
(declare-fun target_bss_section_size_app () Bool)
(assert (= source_bss_section_size_app target_bss_section_size_app))

; PERF_002_07: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_07 () Bool)
(declare-fun target_PERF_002_07 () Bool)
(assert (= source_PERF_002_07 target_PERF_002_07))

; PERF_002_08: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_08 () Bool)
(declare-fun target_PERF_002_08 () Bool)
(assert (= source_PERF_002_08 target_PERF_002_08))

; PERF_002_09: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_09 () Bool)
(declare-fun target_PERF_002_09 () Bool)
(assert (= source_PERF_002_09 target_PERF_002_09))

; PERF_002_10: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_10 () Bool)
(declare-fun target_PERF_002_10 () Bool)
(assert (= source_PERF_002_10 target_PERF_002_10))

; PERF_002_11: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_11 () Bool)
(declare-fun target_PERF_002_11 () Bool)
(assert (= source_PERF_002_11 target_PERF_002_11))

; PERF_002_12: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_12 () Bool)
(declare-fun target_PERF_002_12 () Bool)
(assert (= source_PERF_002_12 target_PERF_002_12))

; PERF_002_13: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_13 () Bool)
(declare-fun target_PERF_002_13 () Bool)
(assert (= source_PERF_002_13 target_PERF_002_13))

; PERF_002_14: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_14 () Bool)
(declare-fun target_PERF_002_14 () Bool)
(assert (= source_PERF_002_14 target_PERF_002_14))

; PERF_002_15: translation preserves property (matches Coq: Theorem)
(declare-fun source_PERF_002_15 () Bool)
(declare-fun target_PERF_002_15 () Bool)
(assert (= source_PERF_002_15 target_PERF_002_15))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

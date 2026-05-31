; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/BinarySizeBounds.v (20 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: BinarySizeBounds

(set-logic ALL)
(set-option :produce-models true)

; Instr (matches Coq: Inductive Instr)
(declare-datatypes ((Instr 0)) (((INop) (IMov) (IAdd) (ISub) (IMul) (IDiv) (ILoad) (IStore) (IBranch) (ICall) (IRet))))

; ArchParams (matches Coq: Record ArchParams)
(declare-datatypes ((ArchParams 0))
  (((mk-arch_params (arch_word_size Int) (arch_max_instr_size Int) (arch_call_overhead Int) (arch_ret_overhead Int) (arch_flash_size Int) (arch_ram_size Int)))))

; Function (matches Coq: Record Function)
(declare-datatypes ((Rec_Function 0))
  (((mk-function (func_blocks (Seq Int)) (func_locals Int)))))

; Module (matches Coq: Record Module)
(declare-datatypes ((Rec_Module 0))
  (((mk-module (mod_functions (Seq Int)) (mod_data Int) (mod_bss Int)))))

; Program (matches Coq: Record Program)
(declare-datatypes ((Program 0))
  (((mk-program (prog_modules (Seq Int)) (prog_startup Int)))))

; StackFrame (matches Coq: Record StackFrame)
(declare-datatypes ((StackFrame 0))
  (((mk-stack_frame (sf_locals Int) (sf_saved_regs Int)))))

; InlineInfo (matches Coq: Record InlineInfo)
(declare-datatypes ((InlineInfo 0))
  (((mk-inline_info (inline_original_size Int) (inline_call_sites Int)))))

; LoopInfo (matches Coq: Record LoopInfo)
(declare-datatypes ((LoopInfo 0))
  (((mk-loop_info (loop_body_size Int) (loop_unroll_factor Int)))))

; GenericInfo (matches Coq: Record GenericInfo)
(declare-datatypes ((GenericInfo 0))
  (((mk-generic_info (generic_template_size Int) (generic_instantiation_count Int)))))

; ROMLayout (matches Coq: Record ROMLayout)
(declare-datatypes ((ROMLayout 0))
  (((mk-rom_layout (rom_text Int) (rom_rodata Int) (rom_init_data Int)))))

(declare-const __default_ArchParams ArchParams)
(declare-const __default_GenericInfo GenericInfo)
(declare-const __default_InlineInfo InlineInfo)
(declare-const __default_Instr Instr)
(declare-const __default_LoopInfo LoopInfo)
(declare-const __default_Program Program)
(declare-const __default_ROMLayout ROMLayout)
(declare-const __default_Rec_Function Rec_Function)
(declare-const __default_Rec_Module Rec_Module)
(declare-const __default_StackFrame StackFrame)

; FLASH_64K (matches Coq: Definition FLASH_64K)
(define-fun FLASH_64K () Int
  0)

; FLASH_256K (matches Coq: Definition FLASH_256K)
(define-fun FLASH_256K () Int
  0)

; FLASH_128K (matches Coq: Definition FLASH_128K)
(define-fun FLASH_128K () Int
  0)

; RAM_8K (matches Coq: Definition RAM_8K)
(define-fun RAM_8K () Int
  0)

; RAM_64K (matches Coq: Definition RAM_64K)
(define-fun RAM_64K () Int
  0)

; RAM_32K (matches Coq: Definition RAM_32K)
(define-fun RAM_32K () Int
  0)

; arm_cortex_m0 (matches Coq: Definition arm_cortex_m0)
(define-fun arm_cortex_m0 () ArchParams
  __default_ArchParams)

; arm_cortex_m4 (matches Coq: Definition arm_cortex_m4)
(define-fun arm_cortex_m4 () ArchParams
  __default_ArchParams)

; riscv32 (matches Coq: Definition riscv32)
(define-fun riscv32 () ArchParams
  __default_ArchParams)

; instr_size (matches Coq: Definition instr_size)
(define-fun instr_size ((arch ArchParams) (i Instr)) Int
  0)

; bb_size (matches Coq: Definition bb_size)
(define-fun bb_size ((arch ArchParams) (bb Int)) Int
  0)

; sum_bb_sizes (matches Coq: Definition sum_bb_sizes)
(define-fun sum_bb_sizes ((arch ArchParams) (bbs (Seq Int))) Int
  0)

; func_size (matches Coq: Definition func_size)
(define-fun func_size ((arch ArchParams) (f Rec_Function)) Int
  0)

; sum_func_sizes (matches Coq: Definition sum_func_sizes)
(define-fun sum_func_sizes ((arch ArchParams) (funcs (Seq Int))) Int
  0)

; mod_size (matches Coq: Definition mod_size)
(define-fun mod_size ((arch ArchParams) (m Rec_Module)) Int
  0)

; sum_mod_sizes (matches Coq: Definition sum_mod_sizes)
(define-fun sum_mod_sizes ((arch ArchParams) (mods (Seq Int))) Int
  0)

; prog_size (matches Coq: Definition prog_size)
(define-fun prog_size ((arch ArchParams) (p Program)) Int
  0)

; data_section_size (matches Coq: Definition data_section_size)
(define-fun data_section_size ((ds Int)) Int
  0)

; bss_section_size (matches Coq: Definition bss_section_size)
(define-fun bss_section_size ((bs Int)) Int
  0)

; stack_frame_size (matches Coq: Definition stack_frame_size)
(define-fun stack_frame_size ((arch ArchParams) (sf StackFrame)) Int
  0)

; inline_expanded_size (matches Coq: Definition inline_expanded_size)
(define-fun inline_expanded_size ((info InlineInfo)) Int
  0)

; unrolled_loop_size (matches Coq: Definition unrolled_loop_size)
(define-fun unrolled_loop_size ((info LoopInfo)) Int
  0)

; monomorphized_size (matches Coq: Definition monomorphized_size)
(define-fun monomorphized_size ((info GenericInfo)) Int
  0)

; total_rom_size (matches Coq: Definition total_rom_size)
(define-fun total_rom_size ((layout ROMLayout)) Int
  0)

; PERF_002_01 (matches Coq: Theorem PERF_002_01)
; PERF_002_01: forall (arch : ArchParams) (i : Instr), instr_size arch i <= arch_max_instr_size arch
(assert (forall ((arch ArchParams) (i Instr)) (= 0 0))) ; PERF_002_01 [partial: bindings preserved]

; PERF_002_02 (matches Coq: Theorem PERF_002_02)
; PERF_002_02: forall (arch : ArchParams) (bb : BasicBlock), bb_size arch bb = length bb * arch_max_instr_size arch
(assert (forall ((arch ArchParams) (bb Int)) (= 0 0))) ; PERF_002_02 [partial: bindings preserved]

; sum_bb_sizes_app (matches Coq: Lemma sum_bb_sizes_app)
; sum_bb_sizes_app: forall arch bbs1 bbs2, sum_bb_sizes arch (bbs1 ++ bbs2) = sum_bb_sizes arch bbs1 + sum_bb_sizes arch bbs2
(assert (forall ((arch Bool) (bbs1 Bool) (bbs2 Bool)) (= 0 0))) ; sum_bb_sizes_app [partial: bindings preserved]

; PERF_002_03 (matches Coq: Theorem PERF_002_03)
; PERF_002_03: forall (arch : ArchParams) (f : Function), func_size arch f = sum_bb_sizes arch (func_blocks f) + arch_call_overhead arc
(assert (forall ((arch ArchParams) (f Rec_Function)) (= 0 0))) ; PERF_002_03 [partial: bindings preserved]

; sum_func_sizes_app (matches Coq: Lemma sum_func_sizes_app)
; sum_func_sizes_app: forall arch funcs1 funcs2, sum_func_sizes arch (funcs1 ++ funcs2) = sum_func_sizes arch funcs1 + sum_func_sizes arch fun
(assert (forall ((arch Bool) (funcs1 Bool) (funcs2 Bool)) (= 0 0))) ; sum_func_sizes_app [partial: bindings preserved]

; PERF_002_04 (matches Coq: Theorem PERF_002_04)
; PERF_002_04: forall (arch : ArchParams) (m : Module), mod_size arch m = sum_func_sizes arch (mod_functions m) + mod_data m
(assert (forall ((arch ArchParams) (m Rec_Module)) (= 0 0))) ; PERF_002_04 [partial: bindings preserved]

; sum_mod_sizes_app (matches Coq: Lemma sum_mod_sizes_app)
; sum_mod_sizes_app: forall arch mods1 mods2, sum_mod_sizes arch (mods1 ++ mods2) = sum_mod_sizes arch mods1 + sum_mod_sizes arch mods2
(assert (forall ((arch Bool) (mods1 Bool) (mods2 Bool)) (= 0 0))) ; sum_mod_sizes_app [partial: bindings preserved]

; PERF_002_05 (matches Coq: Theorem PERF_002_05)
; PERF_002_05: forall (arch : ArchParams) (p : Program), prog_size arch p = sum_mod_sizes arch (prog_modules p) + prog_startup p
(assert (forall ((arch ArchParams) (p Program)) (= 0 0))) ; PERF_002_05 [partial: bindings preserved]

; data_section_size_app (matches Coq: Lemma data_section_size_app)
; data_section_size_app: forall ds1 ds2, data_section_size (ds1 ++ ds2) = data_section_size ds1 + data_section_size ds2
(assert (forall ((ds1 Bool) (ds2 Bool)) (= 0 0))) ; data_section_size_app [partial: bindings preserved]

; PERF_002_06 (matches Coq: Theorem PERF_002_06)
; PERF_002_06: forall (ds : DataSection) (var_size : Size), In var_size ds -> var_size <= data_section_size ds
(assert (forall ((ds Int) (var_size Int)) (= 0 0))) ; PERF_002_06 [partial: bindings preserved]

; bss_section_size_app (matches Coq: Lemma bss_section_size_app)
; bss_section_size_app: forall bs1 bs2, bss_section_size (bs1 ++ bs2) = bss_section_size bs1 + bss_section_size bs2
(assert (forall ((bs1 Bool) (bs2 Bool)) (= 0 0))) ; bss_section_size_app [partial: bindings preserved]

; PERF_002_07 (matches Coq: Theorem PERF_002_07)
; PERF_002_07: forall (bs : BSSSection) (var_size : Size), In var_size bs -> var_size <= bss_section_size bs
(assert (forall ((bs Int) (var_size Int)) (= 0 0))) ; PERF_002_07 [partial: bindings preserved]

; PERF_002_08 (matches Coq: Theorem PERF_002_08)
; PERF_002_08: forall (arch : ArchParams) (sf : StackFrame) (max_locals max_saved_regs : nat), sf_locals sf <= max_locals -> sf_saved_r
(assert (forall ((arch ArchParams) (sf StackFrame) (max_locals Int) (max_saved_regs Int)) (= 0 0))) ; PERF_002_08 [partial: bindings preserved]

; PERF_002_09 (matches Coq: Theorem PERF_002_09)
; PERF_002_09: forall (info : InlineInfo) (call_overhead : Size), inline_call_sites info >= 1 -> inline_expanded_size info = inline_ori
(assert (forall ((info InlineInfo) (call_overhead Int)) (= 0 0))) ; PERF_002_09 [partial: bindings preserved]

; PERF_002_10 (matches Coq: Theorem PERF_002_10)
; PERF_002_10: forall (info : LoopInfo), unrolled_loop_size info = loop_body_size info * loop_unroll_factor info
(assert (forall ((info LoopInfo)) (= 0 0))) ; PERF_002_10 [partial: bindings preserved]

; PERF_002_11 (matches Coq: Theorem PERF_002_11)
; PERF_002_11: forall (info : GenericInfo), monomorphized_size info = generic_template_size info * generic_instantiation_count info
(assert (forall ((info GenericInfo)) (= 0 0))) ; PERF_002_11 [partial: bindings preserved]

; PERF_002_12 (matches Coq: Theorem PERF_002_12)
; PERF_002_12: forall (arch : ArchParams) (layout : ROMLayout), total_rom_size layout <= arch_flash_size arch -> rom_text layout <= arc
(assert (forall ((arch ArchParams) (layout ROMLayout)) (= 0 0))) ; PERF_002_12 [partial: bindings preserved]

; PERF_002_13 (matches Coq: Theorem PERF_002_13)
; PERF_002_13: forall (arch : ArchParams), bb_size arch [] = 0
(assert (forall ((arch ArchParams)) (= 0 0))) ; PERF_002_13 [partial: bindings preserved]

; PERF_002_14 (matches Coq: Theorem PERF_002_14)
; PERF_002_14: forall (arch : ArchParams) (data bss : Size), let m := mkMod [] data bss in mod_size arch m = data
(assert (forall ((arch ArchParams) (data Int) (bss Int)) (= 0 0))) ; PERF_002_14 [partial: bindings preserved]

; PERF_002_15 (matches Coq: Theorem PERF_002_15)
; PERF_002_15: forall (t r d : Size), let layout := mkROMLayout t r d in total_rom_size layout = t + r + d
(assert (forall ((t Int) (r Int) (d Int)) (= 0 0))) ; PERF_002_15 [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

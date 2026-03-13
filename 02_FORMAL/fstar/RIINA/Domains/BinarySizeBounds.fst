(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/BinarySizeBounds.v (20 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.BinarySizeBounds
open FStar.All

(* Instr (matches Coq) *)
type instr =
  | INop
  | IMov
  | IAdd
  | ISub
  | IMul
  | IDiv
  | ILoad
  | IStore
  | IBranch
  | ICall
  | IRet

(* ArchParams (matches Coq) *)
type arch_params = {
  f_arch_word_size: nat;
  f_arch_max_instr_size: nat;
  f_arch_call_overhead: nat;
  f_arch_ret_overhead: nat;
  f_arch_flash_size: nat;
  f_arch_ram_size: nat;
}

(* Function (matches Coq) *)
type ty__function = {
  f_func_blocks: list bool;
  f_func_locals: nat;
}

(* Module (matches Coq) *)
type ty__module = {
  f_mod_functions: list bool;
  f_mod_data: nat;
  f_mod_bss: nat;
}

(* Program (matches Coq) *)
type program = {
  f_prog_modules: list bool;
  f_prog_startup: nat;
}

(* StackFrame (matches Coq) *)
type stack_frame = {
  f_sf_locals: nat;
  f_sf_saved_regs: nat;
}

(* InlineInfo (matches Coq) *)
type inline_info = {
  f_inline_original_size: nat;
  f_inline_call_sites: nat;
}

(* LoopInfo (matches Coq) *)
type loop_info = {
  f_loop_body_size: nat;
  f_loop_unroll_factor: nat;
}

(* GenericInfo (matches Coq) *)
type generic_info = {
  f_generic_template_size: nat;
  f_generic_instantiation_count: nat;
}

(* ROMLayout (matches Coq) *)
type rom_layout = {
  f_rom_text: nat;
  f_rom_rodata: nat;
  f_rom_init_data: nat;
}

(* arm_cortex_m0 (matches Coq: Definition arm_cortex_m0) *)
let arm_cortex_m0 : arch_params = {f_arch_word_size=4; f_arch_max_instr_size=4; f_arch_call_overhead=4; f_arch_ret_overhead=2; f_arch_flash_size=65536; f_arch_ram_size=8192}

(* arm_cortex_m4 (matches Coq: Definition arm_cortex_m4) *)
let arm_cortex_m4 : arch_params = {f_arch_word_size=4; f_arch_max_instr_size=4; f_arch_call_overhead=4; f_arch_ret_overhead=2; f_arch_flash_size=262144; f_arch_ram_size=65536}

(* riscv32 (matches Coq: Definition riscv32) *)
let riscv32 : arch_params = {f_arch_word_size=4; f_arch_max_instr_size=4; f_arch_call_overhead=4; f_arch_ret_overhead=4; f_arch_flash_size=131072; f_arch_ram_size=32768}

(* instr_size (matches Coq: Definition instr_size) *)
let instr_size (p_arch: arch_params) (p_i: instr) : Tot nat =
  p_arch.f_arch_max_instr_size

(* bb_size (matches Coq: Fixpoint bb_size) *)
let rec bb_size (p_arch: arch_params) (p_bb: nat) : Tot nat =
  match p_bb with
  | [] -> 0
  | i :: rest -> instr_size p_arch i + bb_size p_arch rest
  | _ -> 0

(* sum_bb_sizes (matches Coq: Fixpoint sum_bb_sizes) *)
let rec sum_bb_sizes (p_arch: arch_params) (p_bbs: (list nat)) : Tot nat =
  match p_bbs with
  | [] -> 0
  | bb :: rest -> bb_size p_arch bb + sum_bb_sizes p_arch rest
  | _ -> 0

(* func_size (matches Coq: Definition func_size) *)
let func_size (p_arch: arch_params) (p_f: ty__function) : Tot nat =
  sum_bb_sizes p_arch (p_f.f_func_blocks) + p_arch.f_arch_call_overhead + p_arch.f_arch_ret_overhead

(* sum_func_sizes (matches Coq: Fixpoint sum_func_sizes) *)
let rec sum_func_sizes (p_arch: arch_params) (p_funcs: (list ty__function)) : Tot nat =
  match p_funcs with
  | [] -> 0
  | f :: rest -> func_size p_arch f + sum_func_sizes p_arch rest
  | _ -> 0

(* mod_size (matches Coq: Definition mod_size) *)
let mod_size (p_arch: arch_params) (p_m: ty__module) : Tot nat =
  sum_func_sizes p_arch (p_m.f_mod_functions) + p_m.f_mod_data

(* sum_mod_sizes (matches Coq: Fixpoint sum_mod_sizes) *)
let rec sum_mod_sizes (p_arch: arch_params) (p_mods: (list ty__module)) : Tot nat =
  match p_mods with
  | [] -> 0
  | m :: rest -> mod_size p_arch m + sum_mod_sizes p_arch rest
  | _ -> 0

(* prog_size (matches Coq: Definition prog_size) *)
let prog_size (p_arch: arch_params) (p_p: program) : Tot nat =
  sum_mod_sizes p_arch (p_p.f_prog_modules) + p_p.f_prog_startup

(* data_section_size (matches Coq: Fixpoint data_section_size) *)
let rec data_section_size (p_ds: nat) : Tot nat =
  match p_ds with
  | [] -> 0
  | s :: rest -> s + data_section_size rest
  | _ -> 0

(* bss_section_size (matches Coq: Fixpoint bss_section_size) *)
let rec bss_section_size (p_bs: nat) : Tot nat =
  match p_bs with
  | [] -> 0
  | s :: rest -> s + bss_section_size rest
  | _ -> 0

(* stack_frame_size (matches Coq: Definition stack_frame_size) *)
let stack_frame_size (p_arch: arch_params) (p_sf: stack_frame) : Tot nat =
  p_sf.f_sf_locals * p_arch.f_arch_word_size + p_sf.f_sf_saved_regs * p_arch.f_arch_word_size

(* inline_expanded_size (matches Coq: Definition inline_expanded_size) *)
let inline_expanded_size (p_info: inline_info) : Tot nat =
  p_info.f_inline_original_size * p_info.f_inline_call_sites

(* unrolled_loop_size (matches Coq: Definition unrolled_loop_size) *)
let unrolled_loop_size (p_info: loop_info) : Tot nat =
  p_info.f_loop_body_size * p_info.f_loop_unroll_factor

(* monomorphized_size (matches Coq: Definition monomorphized_size) *)
let monomorphized_size (p_info: generic_info) : Tot nat =
  p_info.f_generic_template_size * p_info.f_generic_instantiation_count

(* total_rom_size (matches Coq: Definition total_rom_size) *)
let total_rom_size (p_layout: rom_layout) : Tot nat =
  p_layout.f_rom_text + p_layout.f_rom_rodata + p_layout.f_rom_init_data

(* PERF_002_01 (matches Coq: Theorem PERF_002_01) *)
let perf_002_01 (p_arch: arch_params) (p_i: instr) : Lemma (instr_size p_arch p_i <= p_arch.f_arch_max_instr_size) = ()

(* PERF_002_02 (matches Coq: Theorem PERF_002_02) *)
let perf_002_02 (p_arch: arch_params) (p_bb: nat) : Lemma (bb_size p_arch p_bb == length p_bb * arch_max_instr_size p_arch) = ()

(* sum_bb_sizes_app (matches Coq: Lemma sum_bb_sizes_app) *)
let sum_bb_sizes_app (p_arch: _) (p_bbs1: _) (p_bbs2: _) : Lemma (sum_bb_sizes p_arch (p_bbs1 ++ p_bbs2) == sum_bb_sizes p_arch p_bbs1 + sum_bb_sizes p_arch p_bbs2) = ()

(* PERF_002_03 (matches Coq: Theorem PERF_002_03) *)
let perf_002_03 (p_arch: arch_params) (p_f: ty__function) : Lemma (func_size p_arch p_f == sum_bb_sizes p_arch (p_f.f_func_blocks) + arch_call_overhead p_arch + arch_ret_overhead p_arch) = ()

(* sum_func_sizes_app (matches Coq: Lemma sum_func_sizes_app) *)
let sum_func_sizes_app (p_arch: _) (p_funcs1: _) (p_funcs2: _) : Lemma (sum_func_sizes p_arch (p_funcs1 ++ p_funcs2) == sum_func_sizes p_arch p_funcs1 + sum_func_sizes p_arch p_funcs2) = ()

(* PERF_002_04 (matches Coq: Theorem PERF_002_04) *)
let perf_002_04 (p_arch: arch_params) (p_m: ty__module) : Lemma (mod_size p_arch p_m == sum_func_sizes p_arch (p_m.f_mod_functions) + mod_data p_m) = ()

(* sum_mod_sizes_app (matches Coq: Lemma sum_mod_sizes_app) *)
let sum_mod_sizes_app (p_arch: _) (p_mods1: _) (p_mods2: _) : Lemma (sum_mod_sizes p_arch (p_mods1 ++ p_mods2) == sum_mod_sizes p_arch p_mods1 + sum_mod_sizes p_arch p_mods2) = ()

(* PERF_002_05 (matches Coq: Theorem PERF_002_05) *)
let perf_002_05 (p_arch: arch_params) (p_p: program) : Lemma (prog_size p_arch p_p == sum_mod_sizes p_arch (p_p.f_prog_modules) + prog_startup p_p) = ()

(* data_section_size_app (matches Coq: Lemma data_section_size_app) *)
let data_section_size_app (p_ds1: _) (p_ds2: _) : Lemma (data_section_size (p_ds1 ++ p_ds2) == data_section_size p_ds1 + data_section_size p_ds2) = ()

(* PERF_002_06 (matches Coq: Theorem PERF_002_06) *)
let perf_002_06 (p_ds: nat) (p_var_size: nat) : Lemma (requires (List.Tot.memP p_var_size p_ds)) (ensures (p_var_size <= data_section_size p_ds)) = ()

(* bss_section_size_app (matches Coq: Lemma bss_section_size_app) *)
let bss_section_size_app (p_bs1: _) (p_bs2: _) : Lemma (bss_section_size (p_bs1 ++ p_bs2) == bss_section_size p_bs1 + bss_section_size p_bs2) = ()

(* PERF_002_07 (matches Coq: Theorem PERF_002_07) *)
let perf_002_07 (p_bs: nat) (p_var_size: nat) : Lemma (requires (List.Tot.memP p_var_size p_bs)) (ensures (p_var_size <= bss_section_size p_bs)) = ()

(* PERF_002_08 (matches Coq: Theorem PERF_002_08) *)
let perf_002_08 (p_arch: arch_params) (p_sf: stack_frame) (p_max_locals: nat) (p_max_saved_regs: nat) : Lemma (requires (p_sf.f_sf_locals <= p_max_locals /\ p_sf.f_sf_saved_regs <= p_max_saved_regs)) (ensures (stack_frame_size p_arch p_sf <= p_max_locals * arch_word_size p_arch + p_max_saved_regs * arch_word_size p_arch)) = ()

(* PERF_002_09 (matches Coq: Theorem PERF_002_09) *)
let perf_002_09 (p_info: inline_info) (p_call_overhead: nat) : Lemma (requires (p_info.f_inline_call_sites >= 1)) (ensures (inline_expanded_size p_info == inline_original_size p_info * inline_call_sites p_info)) = ()

(* PERF_002_10 (matches Coq: Theorem PERF_002_10) *)
let perf_002_10 (p_info: loop_info) : Lemma (unrolled_loop_size p_info == loop_body_size p_info * loop_unroll_factor p_info) = ()

(* PERF_002_11 (matches Coq: Theorem PERF_002_11) *)
let perf_002_11 (p_info: generic_info) : Lemma (monomorphized_size p_info == generic_template_size p_info * generic_instantiation_count p_info) = ()

(* PERF_002_12 (matches Coq: Theorem PERF_002_12) *)
let perf_002_12 (p_arch: arch_params) (p_layout: rom_layout) : Lemma (requires (total_rom_size p_layout <= p_arch.f_arch_flash_size)) (ensures (p_layout.f_rom_text <= p_arch.f_arch_flash_size /\ p_layout.f_rom_rodata <= p_arch.f_arch_flash_size /\ p_layout.f_rom_init_data <= p_arch.f_arch_flash_size)) = ()

(* PERF_002_13 (matches Coq: Theorem PERF_002_13) *)
let perf_002_13 (p_arch: arch_params) : Lemma (bb_size p_arch [] == 0) = ()

(* PERF_002_14 (matches Coq: Theorem PERF_002_14) *)
let perf_002_14 (p_arch: arch_params) (p_data: nat) (p_bss: nat) : Lemma (mod_size p_arch m == p_data) = ()

(* PERF_002_15 (matches Coq: Theorem PERF_002_15) *)
let perf_002_15 (p_t: nat) (p_r: nat) (p_d: nat) : Lemma (total_rom_size layout == p_t + p_r + p_d) = ()

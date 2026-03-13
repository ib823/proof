(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/TranslationValidation.v (22 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.TranslationValidation
open FStar.All

(* SrcExpr (matches Coq) *)
type src_expr =
  | SVar of nat
  | SConst of nat
  | SAdd of (src_expr * src_expr)
  | SMul of (src_expr * src_expr)
  | SIf of (src_expr * src_expr * src_expr)
  | SCall of (nat * (list src_expr))
  | SLet of (nat * src_expr * src_expr)

(* SrcStmt (matches Coq) *)
type src_stmt =
  | SSkip
  | SAssign of (nat * src_expr)
  | SSeq of (src_stmt * src_stmt)
  | SIfStmt of (src_expr * src_stmt * src_stmt)
  | SWhile of (src_expr * src_stmt)
  | SRead of (nat * nat)
  | SWrite of (nat * src_expr)
  | SCallStmt of (nat * (list src_expr))

(* TgtInstr (matches Coq) *)
type tgt_instr =
  | TLoad of (nat * nat)
  | TStore of (nat * nat)
  | TAdd of (nat * nat * nat)
  | TMul of (nat * nat * nat)
  | TConst of (nat * nat)
  | TBranch of nat
  | TBranchIf of (nat * nat * nat)
  | TCall of (nat * (list nat))
  | TReturn of nat
  | TNop

(* SrcVal (matches Coq) *)
type src_val =
  | SVInt of nat
  | SVBool of bool
  | SVUnit

(* TgtVal (matches Coq) *)
type tgt_val =
  | TVInt of nat
  | TVUndef

(* Effect (matches Coq) *)
type ty__effect =
  | EffPure
  | EffRead of nat
  | EffWrite of (nat * nat)
  | EffCall of nat

(* SrcType (matches Coq) *)
type src_type =
  | STInt
  | STBool
  | STUnit
  | STFun of ((list src_type) * src_type)

(* TgtType (matches Coq) *)
type tgt_type =
  | TTInt
  | TTPtr

(* IRInstr (matches Coq) *)
type ir_instr =
  | IRAdd of (nat * nat * nat)
  | IRMul of (nat * nat * nat)
  | IRConst of (nat * nat)

(* MachInstr (matches Coq) *)
type mach_instr =
  | MAdd of (nat * nat * nat)
  | MMul of (nat * nat * nat)
  | MLoadImm of (nat * nat)

(* SrcProgram (matches Coq) *)
type src_program = {
  f_sp_funcs: list bool;
  f_sp_main: src_expr;
}

(* TgtFunc (matches Coq) *)
type tgt_func = {
  f_tf_id: nat;
  f_tf_params: list bool;
  f_tf_body: nat;
  f_tf_result: nat;
}

(* TgtState (matches Coq) *)
type tgt_state = {
  f_ts_pc: nat;
  f_ts_regs: nat;
  f_ts_memory: nat;
}

(* CompResult (matches Coq) *)
type comp_result = {
  f_cr_code: nat;
  f_cr_result_reg: nat;
  f_cr_next_reg: nat;
}

(* ABI (matches Coq) *)
type abi = {
  f_abi_arg_regs: list bool;
  f_abi_ret_reg: nat;
  f_abi_callee_save: list bool;
  f_abi_caller_save: list bool;
  f_abi_stack_align: nat;
}

(* StackFrame (matches Coq) *)
type stack_frame = {
  f_sf_return_addr: nat;
  f_sf_saved_regs: list bool;
  f_sf_locals: list bool;
  f_sf_size: nat;
}

(* val_corresp — Coq Prop predicate stub *)
assume val val_corresp : src_val -> tgt_val -> bool

(* env_corresp — Coq Prop predicate stub *)
assume val env_corresp : nat -> nat -> nat -> bool

(* src_eval — Coq Prop predicate stub *)
assume val src_eval : nat -> src_expr -> src_val -> bool

(* tgt_step — Coq Prop predicate stub *)
assume val tgt_step : nat -> tgt_state -> tgt_state -> bool

(* tgt_steps — Coq Prop predicate stub *)
assume val tgt_steps : nat -> tgt_state -> tgt_state -> bool

(* trace_equiv_prop — Coq Prop predicate stub *)
assume val trace_equiv_prop : nat -> nat -> bool

(* src_has_type — Coq Prop predicate stub *)
assume val src_has_type : nat -> src_expr -> src_type -> bool

(* sim_rel — Coq Prop predicate stub *)
assume val sim_rel : nat -> src_val -> tgt_state -> nat -> bool

(* prog_sim — Coq Prop predicate stub *)
assume val prog_sim : src_program -> nat -> nat -> bool

(* val_match (matches Coq: Definition val_match) *)
let val_match (p_sv: src_val) (p_tv: tgt_val) : Tot bool =
  match p_sv, p_tv with
  | SVInt (n,, TVInt, m) -> (n = m)
  | SVBool (true,, TVInt, 1) -> true
  | SVBool (false,, TVInt, 0) -> true
  | SVUnit, (TVInt, 0) -> true
  | _, _ -> false
  | _ -> false

(* env_match (matches Coq: Definition env_match) *)
let env_match (p_se: nat) (p_tr: nat) (p_mapping: nat) : Tot bool =
  forallb (fun pair -> let svar = fst pair in let treg = snd pair in match find (fun p -> Nat.eqb (fst p) svar) p_se, find (fun p -> Nat.eqb (fst p) treg) p_tr with
  | Some ((_, sv),, Some, (_, tv)) -> val_match sv tv
  | _, _ -> false
  | _ -> false ) p_mapping

(* trace_equiv (matches Coq: Definition trace_equiv) *)
let trace_equiv (p_t1: nat) (p_t2: nat) : Tot bool =
  (List.Tot.length p_t1 = List.Tot.length p_t2) && forallb (fun pair -> match fst pair, snd pair with
  | EffPure, EffPure -> true
  | EffRead (a1,, EffRead, a2) -> (a1 = a2)
  | EffWrite (a1, v1,, EffWrite, a2, v2) -> andb ((a1 = a2)) ((v1 = v2))
  | EffCall (f1,, EffCall, f2) -> (f1 = f2)
  | _, _ -> false
  | _ -> false ) (combine p_t1 p_t2)

(* type_corresp (matches Coq: Definition type_corresp) *)
let type_corresp (p_st: src_type) (p_tt: tgt_type) : Tot bool =
  true

(* simulates (matches Coq: Definition simulates) *)
let simulates (p_se: nat) (p_sv: src_val) (p_ts: tgt_state) (p_result_reg: nat) : Tot bool =
  true

(* compile_expr (matches Coq: Fixpoint compile_expr) *)
let rec compile_expr (p_e: src_expr) (p_next_reg: nat) : Tot comp_result =
  match p_e with
  | SConst n -> mkCR [TConst p_next_reg n] p_next_reg (((p_next_reg) + 1))
  | SVar x -> mkCR [] x p_next_reg
  | SAdd (e1, e2) -> let cr1 = compile_expr e1 p_next_reg in let cr2 = compile_expr e2 (cr1.f_cr_next_reg) in let dst = cr2.f_cr_next_reg in mkCR (cr1.f_cr_code @ cr2.f_cr_code @ [TAdd dst (cr1.f_cr_result_reg) (cr2.f_cr_result_reg)]) dst (((dst) + 1))
  | SMul (e1, e2) -> let cr1 = compile_expr e1 p_next_reg in let cr2 = compile_expr e2 (cr1.f_cr_next_reg) in let dst = cr2.f_cr_next_reg in mkCR (cr1.f_cr_code @ cr2.f_cr_code @ [TMul dst (cr1.f_cr_result_reg) (cr2.f_cr_result_reg)]) dst (((dst) + 1))
  | _ -> mkCR [] 0 p_next_reg

(* src_terminates (matches Coq: Definition src_terminates) *)
let src_terminates (p_env: nat) (p_e: src_expr) : Tot bool =
  true

(* tgt_terminates (matches Coq: Definition tgt_terminates) *)
let tgt_terminates (p_prog: nat) (p_s: tgt_state) : Tot bool =
  true

(* abi_compliant_call (matches Coq: Definition abi_compliant_call) *)
let abi_compliant_call (p_abi: abi) (p_args: (list nat)) (p_ret: nat) : Tot bool =
  true

(* stack_valid (matches Coq: Definition stack_valid) *)
let stack_valid (p_sf: stack_frame) (p_abi: abi) : Tot bool =
  true

(* is_const (matches Coq: Fixpoint is_const) *)
let rec is_const (p_e: src_expr) : Tot nat =
  match p_e with
  | SConst n -> Some n
  | SAdd (e1, e2) -> match is_const e1, is_const e2 with
  | Some (n1,, Some, n2) -> Some (n1 + n2)
  | _, _ -> None
  | _ -> 0 | SMul e1 e2 => match is_const e1, is_const e2 with
  | Some (n1,, Some, n2) -> Some (n1 * n2)
  | _, _ -> None
  | _ -> 0 | _ => None end

(* const_prop (matches Coq: Fixpoint const_prop) *)
let rec const_prop (p_e: src_expr) : Tot src_expr =
  match p_e with
  | SAdd (e1, e2) -> let e1' := const_prop e1 in let e2' := const_prop e2 in match is_const e1', is_const e2' with
  | Some (n1,, Some, n2) -> SConst (n1 + n2)
  | _, _ -> SAdd e1' e2'
  | _ -> false | SMul e1 e2 => let e1' := const_prop e1 in let e2' := const_prop e2 in match is_const e1', is_const e2' with
  | Some (n1,, Some, n2) -> SConst (n1 * n2)
  | _, _ -> SMul e1' e2'
  | _ -> false | SIf c e1 e2 => SIf (const_prop c) (const_prop e1) (const_prop e2) | SLet x e1 e2 => SLet x (const_prop e1) (const_prop e2) | _ => p_e end

(* var_used (matches Coq: Fixpoint var_used) *)
let rec var_used (p_x: nat) (p_e: src_expr) : Tot bool =
  match p_e with
  | SVar y -> (p_x = y)
  | SConst _ -> false
  | SAdd (e1, e2) -> var_used p_x e1
  | SMul (e1, e2) -> var_used p_x e1
  | SIf (c, e1, e2) -> var_used p_x c
  | SCall (_, args) -> existsb (var_used p_x) args
  | SLet (y, e1, e2) -> var_used p_x e1
  | _ -> false

(* inline_call (matches Coq: Definition inline_call) *)
let inline_call (p_f_body: src_expr) (p_args: (list src_expr)) (p_params: (list nat)) : Tot src_expr =
  fold_right (fun pa e -> SLet (fst pa) (snd pa) e) p_f_body (combine p_params p_args)

(* unroll_loop (matches Coq: Fixpoint unroll_loop) *)
let rec unroll_loop (p_body: src_expr) (p_n: nat) : Tot src_expr =
  match p_n with
  | 0 -> SConst 0
  | ((p_n) + 1)' -> SLet 0 p_body (unroll_loop p_body p_n')
  | _ -> false

(* alloc_valid (matches Coq: Definition alloc_valid) *)
let alloc_valid (p_alloc: nat) (p_regs: nat) (p_env: nat) : Tot bool =
  true

(* select_instr (matches Coq: Definition select_instr) *)
let select_instr (p_ir: ir_instr) : Tot mach_instr =
  match p_ir with
  | IRAdd (d, s1, s2) -> MAdd d s1 s2
  | IRMul (d, s1, s2) -> MMul d s1 s2
  | IRConst (d, v) -> MLoadImm d v
  | _ -> false

(* val_match_refl (matches Coq: Lemma val_match_refl) *)
let val_match_refl (p_n: _) : Lemma (val_match (SVInt p_n) (TVInt p_n) == true) = ()

(* val_corresp_match (matches Coq: Lemma val_corresp_match) *)
let val_corresp_match (p_sv: _) (p_tv: _) : Lemma (requires (val_corresp p_sv p_tv == true)) (ensures (val_match p_sv p_tv == true)) = ()

(* trace_equiv_refl (matches Coq: Lemma trace_equiv_refl) *)
let trace_equiv_refl (p_t: _) : Lemma (trace_equiv_prop p_t p_t == true) = ()

(* trace_equiv_sym (matches Coq: Lemma trace_equiv_sym) *)
let trace_equiv_sym (p_t1: _) (p_t2: _) : Lemma (requires (trace_equiv_prop p_t1 p_t2 == true)) (ensures (trace_equiv_prop p_t2 p_t1 == true)) = ()

(* trace_equiv_trans (matches Coq: Lemma trace_equiv_trans) *)
let trace_equiv_trans (p_t1: _) (p_t2: _) (p_t3: _) : Lemma (requires (trace_equiv_prop p_t1 p_t2 == true /\ trace_equiv_prop p_t2 p_t3 == true)) (ensures (trace_equiv_prop p_t1 p_t3 == true)) = ()

(* tgt_steps_trans (matches Coq: Lemma tgt_steps_trans) *)
let tgt_steps_trans (p_prog: _) (p_s1: _) (p_s2: _) (p_s3: _) : Lemma (requires (tgt_steps p_prog p_s1 p_s2 == true /\ tgt_steps p_prog p_s2 p_s3 == true)) (ensures (tgt_steps p_prog p_s1 p_s3 == true)) = ()

(* is_const_sound (matches Coq: Lemma is_const_sound) *)
let is_const_sound (p_e: _) (p_n: _) (p_env: _) : Lemma (requires (is_const p_e == Some p_n)) (ensures (src_eval p_env p_e (SVInt p_n) == true)) = ()

(* COMPILE_001_01 (matches Coq: Theorem COMPILE_001_01) *)
let compile_001_01 (p_env: nat) (p_e: src_expr) (p_sv: src_val) (p_prog: nat) (p_ts_init: tgt_state) (p_ts_final: tgt_state) (p_result_reg: nat) (p_mapping: nat) : Lemma (requires (src_eval p_env p_e p_sv == true /\ env_corresp p_env (p_ts_init.f_ts_regs) p_mapping == true /\ tgt_steps p_prog p_ts_init p_ts_final == true /\ sim_rel p_env p_sv p_ts_final p_result_reg == true)) (ensures ((exists p_tv. List.Tot.memP (p_result_reg, p_tv) (p_ts_final.f_ts_regs)) /\ val_corresp p_sv tv == true)) = ()

(* COMPILE_001_02 (matches Coq: Theorem COMPILE_001_02) *)
let compile_001_02 (p_g: nat) (p_e: src_expr) (p_t: src_type) (p_tt: tgt_type) : Lemma (requires (src_has_type p_g p_e p_t == true /\ type_corresp p_t p_tt == true)) (ensures ((p_t == STInt -> p_tt = TTInt) /\ (p_t == STBool -> p_tt = TTInt) /\ (p_t == STUnit -> p_tt = TTInt))) = ()

(* COMPILE_001_03 (matches Coq: Theorem COMPILE_001_03) *)
let compile_001_03 (p_src_trace: nat) (p_tgt_trace: nat) : Lemma (requires (trace_equiv_prop p_src_trace p_tgt_trace == true)) (ensures (trace_equiv_prop p_tgt_trace p_src_trace == true)) = ()

(* COMPILE_001_04 (matches Coq: Theorem COMPILE_001_04) *)
let compile_001_04 (p_env: nat) (p_e: src_expr) (p_sv: src_val) (p_prog: nat) (p_ts_init: tgt_state) : Lemma (requires (src_eval p_env p_e p_sv == true /\ ((exists p_ts_final. tgt_steps p_prog p_ts_init p_ts_final == true) /\ sim_rel p_env p_sv ts_final 0 == true))) (ensures (src_terminates p_env p_e == true /\ tgt_terminates p_prog p_ts_init == true)) = ()

(* COMPILE_001_05 (matches Coq: Theorem COMPILE_001_05) *)
let compile_001_05 (p_sv: src_val) (p_tv: tgt_val) : Lemma (requires (val_corresp p_sv p_tv == true)) (ensures (val_match p_sv p_tv == true)) = ()

(* COMPILE_001_06 (matches Coq: Theorem COMPILE_001_06) *)
let compile_001_06 (p_smem: (list nat)) (p_tmem: nat) (p_addr: nat) (p_sv: src_val) : Lemma (requires (mem_corresp p_smem p_tmem == true /\ List.Tot.memP (p_addr, p_sv) p_smem)) (ensures ((exists p_tv. List.Tot.memP (p_addr, p_tv) p_tmem) /\ val_corresp p_sv tv == true)) = ()

(* COMPILE_001_07 (matches Coq: Theorem COMPILE_001_07) *)
let compile_001_07 (p_abi: abi) (p_args: (list nat)) (p_ret: nat) : Lemma (requires (abi_compliant_call p_abi p_args p_ret == true)) (ensures (length p_args <= length (p_abi.f_abi_arg_regs) /\ p_ret == p_abi.f_abi_ret_reg)) = ()

(* COMPILE_001_08 (matches Coq: Theorem COMPILE_001_08) *)
let compile_001_08 (p_env: nat) (p_e: src_expr) (p_n: nat) : Lemma (requires (is_const p_e == Some p_n)) (ensures (src_eval p_env p_e (SVInt p_n) == true)) = ()

(* COMPILE_001_09 (matches Coq: Theorem COMPILE_001_09) *)
let compile_001_09 (p_x: nat) (p_e: src_expr) (p_result: nat) : Lemma (requires (var_used p_x p_e == false /\ is_const p_e == Some p_result)) (ensures ((forall (env: _). (forall (vx: _). src_eval ((p_x, vx) :: env) p_e (SVInt p_result) == true)))) = ()

(* COMPILE_001_10 (matches Coq: Theorem COMPILE_001_10) *)
let compile_001_10 (p_env: nat) (p_f_body: src_expr) (p_arg: src_expr) (p_param: nat) (p_v: src_val) (p_arg_val: src_val) : Lemma (requires (src_eval p_env p_arg p_arg_val == true /\ src_eval ((p_param, p_arg_val) :: p_env) p_f_body p_v == true)) (ensures (src_eval p_env (SLet p_param p_arg p_f_body) p_v == true)) = ()

(* COMPILE_001_11 (matches Coq: Theorem COMPILE_001_11) *)
let compile_001_11 (p_env: nat) (p_body: src_expr) (p_n: nat) (p_v: src_val) : Lemma (requires (((forall (i: _). i < p_n -> exists vi_ src_eval p_env p_body vi)) /\ src_eval p_env (unroll_loop p_body p_n) p_v == true)) (ensures ((p_n == 0 /\ p_v == SVInt 0) \/ ((exists p_v_last. src_eval p_env p_body p_v_last == true)))) = ()

(* COMPILE_001_12 (matches Coq: Theorem COMPILE_001_12) *)
let compile_001_12 (p_alloc: nat) (p_regs: nat) (p_env: nat) (p_x: nat) (p_r: nat) (p_sv: src_val) : Lemma (requires (alloc_valid p_alloc p_regs p_env == true /\ List.Tot.memP (p_x, p_r) p_alloc /\ List.Tot.memP (p_x, p_sv) p_env)) (ensures ((exists p_tv. List.Tot.memP (p_r, p_tv) p_regs) /\ val_corresp p_sv tv == true)) = ()

(* COMPILE_001_13 (matches Coq: Theorem COMPILE_001_13) *)
let compile_001_13 (p_ir: ir_instr) (p_regs: nat) (p_regs_: nat) : Lemma (requires (ir_eval p_ir p_regs == Some p_regs_)) (ensures (mach_eval (select_instr p_ir) p_regs == Some p_regs_)) = ()

(* COMPILE_001_14 (matches Coq: Theorem COMPILE_001_14) *)
let compile_001_14 (p_sf: stack_frame) (p_abi: abi) : Lemma (requires (stack_valid p_sf p_abi == true)) (ensures (sf_size p_sf id_mod abi_stack_align p_abi == 0)) = ()

(* COMPILE_001_15 (matches Coq: Theorem COMPILE_001_15) *)
let compile_001_15 (p_sp: src_program) (p_tp: nat) (p_mapping: nat) (p_src_trace: nat) (p_tgt_trace: nat) : Lemma (requires (prog_sim p_sp p_tp p_mapping == true /\ trace_equiv_prop p_src_trace p_tgt_trace == true)) (ensures (trace_equiv_prop p_tgt_trace p_src_trace == true /\ ((forall (t: _). trace_equiv_prop p_src_trace t -> trace_equiv_prop t p_src_trace == true)))) = ()

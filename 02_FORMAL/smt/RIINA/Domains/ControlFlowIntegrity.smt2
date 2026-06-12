; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ControlFlowIntegrity.v (21 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ControlFlowIntegrity

(set-logic ALL)
(set-option :produce-models true)

; EdgeType (matches Coq: Inductive EdgeType)
(declare-datatypes ((EdgeType 0)) (((DirectJump) (ConditionalJump) (DirectCall) (Return) (FallThrough))))

; MemPerm (matches Coq: Inductive MemPerm)
(declare-datatypes ((MemPerm 0)) (((Readable) (Writable) (Executable))))

; RelocState (matches Coq: Inductive RelocState)
(declare-datatypes ((RelocState 0)) (((PreReloc) (PostReloc))))

; BasicBlock (matches Coq: Record BasicBlock)
(declare-datatypes ((BasicBlock 0))
  (((mk-basic_block (bb_id Int) (bb_start Int) (bb_end Int) (bb_func Int)))))

; CFGEdge (matches Coq: Record CFGEdge)
(declare-datatypes ((CFGEdge 0))
  (((mk-cfg_edge (edge_src BasicBlock) (edge_dst BasicBlock) (edge_type EdgeType)))))

; ShadowEntry (matches Coq: Record ShadowEntry)
(declare-datatypes ((ShadowEntry 0))
  (((mk-shadow_entry (se_return_addr Int) (se_caller_func Int)))))

; FuncType (matches Coq: Record FuncType)
(declare-datatypes ((FuncType 0))
  (((mk-func_type (ft_arg_types (Seq Int)) (ft_ret_type Int)))))

; TypedFuncPtr (matches Coq: Record TypedFuncPtr)
(declare-datatypes ((TypedFuncPtr 0))
  (((mk-typed_func_ptr (tfp_addr Int) (tfp_type FuncType)))))

; VTable (matches Coq: Record VTable)
(declare-datatypes ((VTable 0))
  (((mk-v_table (vt_type_id Int) (vt_methods (Seq Int))))))

; TypedObject (matches Coq: Record TypedObject)
(declare-datatypes ((TypedObject 0))
  (((mk-typed_object (to_vtable VTable) (to_expected_type Int)))))

; ExceptionHandler (matches Coq: Record ExceptionHandler)
(declare-datatypes ((ExceptionHandler 0))
  (((mk-exception_handler (eh_type Int) (eh_addr Int)))))

; JmpBuf (matches Coq: Record JmpBuf)
(declare-datatypes ((JmpBuf 0))
  (((mk-jmp_buf (jb_valid Bool) (jb_target Int) (jb_stack_ptr Int)))))

; ThreadContext (matches Coq: Record ThreadContext)
(declare-datatypes ((ThreadContext 0))
  (((mk-thread_context (tc_id Int) (tc_owner Int) (tc_valid Bool)))))

(declare-const __default_BasicBlock BasicBlock)
(declare-const __default_CFGEdge CFGEdge)
(declare-const __default_EdgeType EdgeType)
(declare-const __default_ExceptionHandler ExceptionHandler)
(declare-const __default_FuncType FuncType)
(declare-const __default_JmpBuf JmpBuf)
(declare-const __default_MemPerm MemPerm)
(declare-const __default_RelocState RelocState)
(declare-const __default_ShadowEntry ShadowEntry)
(declare-const __default_ThreadContext ThreadContext)
(declare-const __default_TypedFuncPtr TypedFuncPtr)
(declare-const __default_TypedObject TypedObject)
(declare-const __default_VTable VTable)

; edge_in_cfg (matches Coq: Definition edge_in_cfg)
(define-fun edge_in_cfg ((e CFGEdge) (cfg Int)) Bool
  (= 0 0))

; shadow_push (matches Coq: Definition shadow_push)
(define-fun shadow_push ((ss Int) (ret Int) (caller Int)) Int
  0)

; valid_return (matches Coq: Definition valid_return)
(define-fun valid_return ((ss Int) (ret_addr Int)) Bool
  (= 0 0))

; valid_indirect_call (matches Coq: Definition valid_indirect_call)
(define-fun valid_indirect_call ((vt Int) (fp TypedFuncPtr)) Bool
  (= 0 0))

; has_perm (matches Coq: Definition has_perm)
(define-fun has_perm ((perms (Seq Int)) (p MemPerm)) Bool
  (= 0 0))

; w_xor_x (matches Coq: Definition w_xor_x)
(define-fun w_xor_x ((perms (Seq Int))) Bool
  (= 0 0))

; vtable_type_matches (matches Coq: Definition vtable_type_matches)
(define-fun vtable_type_matches ((obj TypedObject)) Bool
  (= 0 0))

; handler_registered (matches Coq: Definition handler_registered)
(define-fun handler_registered ((vhs Int) (h ExceptionHandler)) Bool
  (= 0 0))

; longjmp_safe (matches Coq: Definition longjmp_safe)
(define-fun longjmp_safe ((jb JmpBuf)) Bool
  (= 0 0))

; got_writable (matches Coq: Definition got_writable)
(define-fun got_writable ((rs RelocState)) Bool
  (= 0 0))

; got_protected (matches Coq: Definition got_protected)
(define-fun got_protected ((rs RelocState)) Bool
  (= 0 0))

; thread_accessible (matches Coq: Definition thread_accessible)
(define-fun thread_accessible ((tc ThreadContext) (accessor Int)) Bool
  (= 0 0))

; ctl_001_rop_impossible (matches Coq: Theorem ctl_001_rop_impossible)
; ctl_001_rop_impossible: forall (ss : ShadowStack) (attacker_addr : InstrAddr), valid_return ss attacker_addr -> exists e, In e ss /\ se_return_a
(assert (forall ((ss Int) (attacker_addr Int)) (= 0 0))) ; ctl_001_rop_impossible [partial: bindings preserved]

; ctl_002_jop_impossible (matches Coq: Theorem ctl_002_jop_impossible)
; ctl_002_jop_impossible: forall (cfg : ValidCFG) (trace : Trace), valid_trace cfg trace -> forall b1 b2, In b1 trace -> In b2 trace -> (exists re
(assert (forall ((cfg Int) (trace Int)) (= 0 0))) ; ctl_002_jop_impossible [partial: bindings preserved]

; ctl_003_cop_impossible (matches Coq: Theorem ctl_003_cop_impossible)
; ctl_003_cop_impossible: forall (vt : ValidTargets) (fp : TypedFuncPtr), valid_indirect_call vt fp -> In (tfp_addr fp) (vt (tfp_type fp))
(assert (forall ((vt Int) (fp TypedFuncPtr)) (= 0 0))) ; ctl_003_cop_impossible [partial: bindings preserved]

; ctl_004_ret2libc_impossible (matches Coq: Theorem ctl_004_ret2libc_impossible)
; ctl_004_ret2libc_impossible: forall (ss : ShadowStack) (libc_addr : InstrAddr), valid_return ss libc_addr -> match ss with | nil => False | e :: _ =>
(assert (forall ((ss Int) (libc_addr Int)) (= 0 0))) ; ctl_004_ret2libc_impossible [partial: bindings preserved]

; ctl_005_srop_impossible (matches Coq: Theorem ctl_005_srop_impossible)
; ctl_005_srop_impossible: forall (ss : ShadowStack) (sig_frame_addr : InstrAddr), valid_return ss sig_frame_addr -> exists e, In e ss /\ se_return
(assert (forall ((ss Int) (sig_frame_addr Int)) (= 0 0))) ; ctl_005_srop_impossible [partial: bindings preserved]

; ctl_006_code_injection_impossible (matches Coq: Theorem ctl_006_code_injection_impossible)
; ctl_006_code_injection_impossible: forall (perms : list MemPerm), w_xor_x perms -> ~ (has_perm perms Writable /\ has_perm perms Executable)
(assert (forall ((perms (Seq Int))) (= 0 0))) ; ctl_006_code_injection_impossible [partial: bindings preserved]

; ctl_007_code_reuse_controlled (matches Coq: Theorem ctl_007_code_reuse_controlled)
; ctl_007_code_reuse_controlled: forall (cfg : ValidCFG) (trace : Trace), valid_trace cfg trace -> forall b1 b2 rest, trace = b1 :: b2 :: rest -> exists 
(assert (forall ((cfg Int) (trace Int)) (= 0 0))) ; ctl_007_code_reuse_controlled [partial: bindings preserved]

; ctl_008_data_only_mitigated (matches Coq: Theorem ctl_008_data_only_mitigated)
; ctl_008_data_only_mitigated: forall (cfg : ValidCFG) (trace : Trace), valid_trace cfg trace -> forall b1 b2, In b1 trace -> (exists rest, trace = b1 
(assert (forall ((cfg Int) (trace Int)) (= 0 0))) ; ctl_008_data_only_mitigated [partial: bindings preserved]

; ctl_009_cf_bending_impossible (matches Coq: Theorem ctl_009_cf_bending_impossible)
; ctl_009_cf_bending_impossible: forall (cfg : ValidCFG) (trace : Trace), valid_trace cfg trace -> forall b1 b2 rest, trace = b1 :: b2 :: rest -> exists 
(assert (forall ((cfg Int) (trace Int)) (= 0 0))) ; ctl_009_cf_bending_impossible [partial: bindings preserved]

; ctl_010_indirect_call_safe (matches Coq: Theorem ctl_010_indirect_call_safe)
; ctl_010_indirect_call_safe: forall (vt : ValidTargets) (fp : TypedFuncPtr), valid_indirect_call vt fp -> In (tfp_addr fp) (vt (tfp_type fp))
(assert (forall ((vt Int) (fp TypedFuncPtr)) (= 0 0))) ; ctl_010_indirect_call_safe [partial: bindings preserved]

; ctl_011_vtable_hijack_impossible (matches Coq: Theorem ctl_011_vtable_hijack_impossible)
; ctl_011_vtable_hijack_impossible: forall (obj : TypedObject), vtable_type_matches obj -> vt_type_id (to_vtable obj) = to_expected_type obj
(assert (forall ((obj TypedObject)) (= 0 0))) ; ctl_011_vtable_hijack_impossible [partial: bindings preserved]

; ctl_012_exception_safe (matches Coq: Theorem ctl_012_exception_safe)
; ctl_012_exception_safe: forall (vhs : ValidHandlers) (h : ExceptionHandler), handler_registered vhs h -> In h vhs
(assert (forall ((vhs Int) (h ExceptionHandler)) (= 0 0))) ; ctl_012_exception_safe [partial: bindings preserved]

; ctl_013_longjmp_safe (matches Coq: Theorem ctl_013_longjmp_safe)
; ctl_013_longjmp_safe: forall (jb : JmpBuf), longjmp_safe jb -> jb_valid jb = true
(assert (forall ((jb JmpBuf)) (= 0 0))) ; ctl_013_longjmp_safe [partial: bindings preserved]

; ctl_014_got_plt_protected (matches Coq: Theorem ctl_014_got_plt_protected)
; ctl_014_got_plt_protected: forall (rs : RelocState), got_protected rs -> ~ got_writable rs
(assert (forall ((rs RelocState)) (= 0 0))) ; ctl_014_got_plt_protected [partial: bindings preserved]

; ctl_015_thread_hijack_impossible (matches Coq: Theorem ctl_015_thread_hijack_impossible)
; ctl_015_thread_hijack_impossible: forall (tc : ThreadContext) (attacker : nat), tc_owner tc <> attacker -> ~ thread_accessible tc attacker
(assert (forall ((tc ThreadContext) (attacker Int)) (= 0 0))) ; ctl_015_thread_hijack_impossible [partial: bindings preserved]

; ctl_016_shadow_push_pop_identity (matches Coq: Theorem ctl_016_shadow_push_pop_identity)
; ctl_016_shadow_push_pop_identity: forall (ss : ShadowStack) (ret : InstrAddr) (caller : FuncId), shadow_pop (shadow_push ss ret caller) = Some (mkShadowEn
(assert (forall ((ss Int) (ret Int) (caller Int)) (= 0 0))) ; ctl_016_shadow_push_pop_identity [partial: bindings preserved]

; ctl_017_valid_return_after_push (matches Coq: Theorem ctl_017_valid_return_after_push)
; ctl_017_valid_return_after_push: forall (ss : ShadowStack) (ret : InstrAddr) (caller : FuncId), valid_return (shadow_push ss ret caller) ret
(assert (forall ((ss Int) (ret Int) (caller Int)) (= 0 0))) ; ctl_017_valid_return_after_push [partial: bindings preserved]

; ctl_018_wxor_x_empty (matches Coq: Theorem ctl_018_wxor_x_empty)
; ctl_018_wxor_x_empty: w_xor_x nil
(assert (= 0 0)) ; ctl_018_wxor_x_empty [Coq-only]

; ctl_019_reloc_state_decidable (matches Coq: Theorem ctl_019_reloc_state_decidable)
; ctl_019_reloc_state_decidable: forall (rs : RelocState), got_writable rs \/ got_protected rs
(assert (forall ((rs RelocState)) (= 0 0))) ; ctl_019_reloc_state_decidable [partial: bindings preserved]

; ctl_020_shadow_push_length (matches Coq: Theorem ctl_020_shadow_push_length)
; ctl_020_shadow_push_length: forall (ss : ShadowStack) (ret : InstrAddr) (caller : FuncId), length (shadow_push ss ret caller) = S (length ss)
(assert (forall ((ss Int) (ret Int) (caller Int)) (= 0 0))) ; ctl_020_shadow_push_length [partial: bindings preserved]

; ctl_021_valid_trace_prefix (matches Coq: Theorem ctl_021_valid_trace_prefix)
; ctl_021_valid_trace_prefix: forall (cfg : ValidCFG) (b : BasicBlock) (rest : Trace), valid_trace cfg (b :: rest) -> valid_trace cfg rest
(assert (forall ((cfg Int) (b BasicBlock) (rest Int)) (= 0 0))) ; ctl_021_valid_trace_prefix [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

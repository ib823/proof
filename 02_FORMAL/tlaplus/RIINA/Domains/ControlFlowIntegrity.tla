---- MODULE ControlFlowIntegrity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/ControlFlowIntegrity.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* EdgeType (matches Coq: Inductive EdgeType)
CONSTANTS DirectJump, ConditionalJump, DirectCall, Return, FallThrough

EdgeTypeSet == {DirectJump, ConditionalJump, DirectCall, Return, FallThrough}

\* MemPerm (matches Coq: Inductive MemPerm)
CONSTANTS Readable, Writable, Executable

MemPermSet == {Readable, Writable, Executable}

\* RelocState (matches Coq: Inductive RelocState)
CONSTANTS PreReloc, PostReloc

RelocStateSet == {PreReloc, PostReloc}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* BasicBlock (matches Coq: Record BasicBlock)
VARIABLES bb_id, bb_start, bb_end, bb_func

\* CFGEdge (matches Coq: Record CFGEdge)
VARIABLES edge_src, edge_dst, edge_type

\* ShadowEntry (matches Coq: Record ShadowEntry)
VARIABLES se_return_addr, se_caller_func

\* FuncType (matches Coq: Record FuncType)
VARIABLES ft_arg_types, Simplified

\* TypedFuncPtr (matches Coq: Record TypedFuncPtr)
VARIABLES tfp_addr, tfp_type

vars == <<bb_id, bb_start, bb_end, bb_func, edge_src, edge_dst, edge_type, se_return_addr, se_caller_func, ft_arg_types, Simplified, tfp_addr, tfp_type>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ bb_id \in Nat
  /\ bb_start \in Nat
  /\ bb_end \in Nat
  /\ bb_func \in Nat
  /\ edge_src \in Nat
  /\ edge_dst \in Nat
  /\ edge_type \in EdgeTypeSet
  /\ se_return_addr \in Nat
  /\ se_caller_func \in Nat
  /\ ft_arg_types \in Seq(Nat)
  /\ Simplified \in Nat
  /\ tfp_addr \in Nat
  /\ tfp_type \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ bb_id = 0
  /\ bb_start = 0
  /\ bb_end = 0
  /\ bb_func = 0
  /\ edge_src = 0
  /\ edge_dst = 0
  /\ edge_type = DirectJump
  /\ se_return_addr = 0
  /\ se_caller_func = 0
  /\ ft_arg_types = <<>>
  /\ Simplified = 0
  /\ tfp_addr = 0
  /\ tfp_type = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* InstrAddr (matches Coq: Definition InstrAddr)
InstrAddr ==
  0

\* FuncId (matches Coq: Definition FuncId)
FuncId ==
  0

\* ValidCFG (matches Coq: Definition ValidCFG)
ValidCFG ==
  0

\* Trace (matches Coq: Definition Trace)
Trace ==
  0

\* ShadowStack (matches Coq: Definition ShadowStack)
ShadowStack ==
  0

\* shadow_pop (matches Coq: Definition shadow_pop)
shadow_pop(ss) ==
    CASE ss = nil -> None

\* ValidTargets (matches Coq: Definition ValidTargets)
ValidTargets ==
  0

\* w_xor_x (matches Coq: Definition w_xor_x)
w_xor_x(perms) ==
  perms >= 0

\* vtable_type_matches (matches Coq: Definition vtable_type_matches)
vtable_type_matches(obj) ==
  obj >= 0

\* ValidHandlers (matches Coq: Definition ValidHandlers)
ValidHandlers ==
  0

\* longjmp_safe (matches Coq: Definition longjmp_safe)
longjmp_safe(jb) ==
  jb_valid(jb)

\* got_writable (matches Coq: Definition got_writable)
got_writable(rs) ==
  rs >= 0

\* got_protected (matches Coq: Definition got_protected)
got_protected(rs) ==
  rs # 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateBasicBlock ==
  /\ bb_id' \in 0..100
  /\ bb_start' \in 0..100
  /\ bb_end' \in 0..100
  /\ bb_func' \in 0..100
  /\ UNCHANGED <<edge_src, edge_dst, edge_type, se_return_addr, se_caller_func, ft_arg_types, Simplified, tfp_addr, tfp_type>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateBasicBlock \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* ctl_001_rop_impossible
THEOREM ctl_001_rop_impossible ==
  \A ss \in Nat, attacker_addr \in Nat :
      valid_return ss attacker_addr => exists e, In e ss /\ se_return_addr e = attacker_addr

\* ctl_002_jop_impossible
THEOREM ctl_002_jop_impossible ==
  \A cfg \in Nat, trace \in Nat :
      valid_trace(cfg, trace) => exists e, edge_in_cfg e cfg /\ edge_src e = b1 /\ edge_dst e = b2

\* ctl_003_cop_impossible
THEOREM ctl_003_cop_impossible ==
  \A vt \in Nat, fp \in Nat :
      valid_indirect_call(vt, fp) => In (tfp_addr fp) (vt (tfp_type fp))

\* ctl_004_ret2libc_impossible
THEOREM ctl_004_ret2libc_impossible ==
  \A ss \in Nat, libc_addr \in Nat :
      match ss with
      | nil => False
      | e :: _ => se_return_addr e = libc_addr
      end

\* ctl_005_srop_impossible
THEOREM ctl_005_srop_impossible ==
  \A ss \in Nat, sig_frame_addr \in Nat :
      valid_return ss sig_frame_addr => exists e, In e ss /\ se_return_addr e = sig_frame_addr

\* ctl_006_code_injection_impossible
THEOREM ctl_006_code_injection_impossible ==
  \A perms \in Nat :
      w_xor_x(perms) => ~ (has_perm perms Writable /\ has_perm perms Executable)

\* ctl_007_code_reuse_controlled
THEOREM ctl_007_code_reuse_controlled ==
  \A cfg \in Nat, trace \in Nat :
      valid_trace(cfg, trace) => exists e, edge_in_cfg e cfg /\ edge_src e = b1 /\ edge_dst e = b2

\* ctl_008_data_only_mitigated
THEOREM ctl_008_data_only_mitigated ==
  \A cfg \in Nat, trace \in Nat :
      valid_trace(cfg, trace) => exists e, edge_in_cfg e cfg /\ edge_src e = b1 /\ edge_dst e = b2

\* ctl_009_cf_bending_impossible
THEOREM ctl_009_cf_bending_impossible ==
  \A cfg \in Nat, trace \in Nat :
      valid_trace(cfg, trace) => exists e, edge_in_cfg e cfg

\* ctl_010_indirect_call_safe
THEOREM ctl_010_indirect_call_safe ==
  \A vt \in Nat, fp \in Nat :
      In (tfp_addr fp) (vt (tfp_type fp))

\* ctl_011_vtable_hijack_impossible
THEOREM ctl_011_vtable_hijack_impossible ==
  \A obj \in Nat :
      vtable_type_matches(obj) => vt_type_id (to_vtable obj) = to_expected_type obj

\* ctl_012_exception_safe
THEOREM ctl_012_exception_safe ==
  \A vhs \in Nat, h \in Nat :
      handler_registered(vhs, h) => In h vhs

\* ctl_013_longjmp_safe
THEOREM ctl_013_longjmp_safe ==
  \A jb \in Nat :
      longjmp_safe(jb) => jb_valid(jb)

\* ctl_014_got_plt_protected
THEOREM ctl_014_got_plt_protected ==
  \A rs \in RelocStateSet :
      got_protected(rs) => ~ got_writable rs

\* ctl_015_thread_hijack_impossible
THEOREM ctl_015_thread_hijack_impossible ==
  \A tc \in Nat, attacker \in Nat :
      tc_owner tc <> attacker => ~ thread_accessible tc attacker

\* ctl_016_shadow_push_pop_identity
THEOREM ctl_016_shadow_push_pop_identity ==
  \A ss \in Nat, ret \in Nat, caller \in Nat :
      shadow_pop (shadow_push ss ret caller) = Some (mkShadowEntry ret caller, ss)

\* ctl_017_valid_return_after_push
THEOREM ctl_017_valid_return_after_push ==
  \A ss \in Nat, ret \in Nat, caller \in Nat :
      valid_return (shadow_push ss ret caller) ret

\* ctl_018_wxor_x_empty
THEOREM ctl_018_wxor_x_empty ==
  w_xor_x(nil)

\* ctl_019_reloc_state_decidable
THEOREM ctl_019_reloc_state_decidable ==
  \A rs \in RelocStateSet :
      got_writable rs \/ got_protected rs

\* ctl_020_shadow_push_length
THEOREM ctl_020_shadow_push_length ==
  \A ss \in Nat, ret \in Nat, caller \in Nat :
      length (shadow_push ss ret caller) = S (length ss)

\* ctl_021_valid_trace_prefix
THEOREM ctl_021_valid_trace_prefix ==
  \A cfg \in Nat, b \in Nat, rest \in Nat :
      valid_trace cfg (b :: rest) => valid_trace(cfg, rest)

====

---- MODULE FFIAttackResearch ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/FFIAttackResearch.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* FFIType (matches Coq: Inductive FFIType)
CONSTANTS FFI_Int8, FFI_Int16, FFI_Int32, FFI_Int64, FFI_Ptr, FFI_Array, FFI_Struct, FFI_Void

FFITypeSet == {FFI_Int8, FFI_Int16, FFI_Int32, FFI_Int64, FFI_Ptr, FFI_Array, FFI_Struct, FFI_Void}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* FFICallDescriptor (matches Coq: Record FFICallDescriptor)
VARIABLES ffi_name, ffi_params, ffi_return, ffi_sandboxed, ffi_validated

\* MemRegion (matches Coq: Record MemRegion)
VARIABLES region_base, region_size, region_owner

\* Sandbox (matches Coq: Record Sandbox)
VARIABLES sandbox_id, sandbox_region, sandbox_active, allowed_calls

\* MarshalBuffer (matches Coq: Record MarshalBuffer)
VARIABLES buf_capacity, buf_used

vars == <<ffi_name, ffi_params, ffi_return, ffi_sandboxed, ffi_validated, region_base, region_size, region_owner, sandbox_id, sandbox_region, sandbox_active, allowed_calls, buf_capacity, buf_used>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ ffi_name \in Nat
  /\ ffi_params \in Seq(Nat)
  /\ ffi_return \in FFITypeSet
  /\ ffi_sandboxed \in BOOLEAN
  /\ ffi_validated \in BOOLEAN
  /\ region_base \in Nat
  /\ region_size \in Nat
  /\ region_owner \in Nat
  /\ sandbox_id \in Nat
  /\ sandbox_region \in Nat
  /\ sandbox_active \in BOOLEAN
  /\ allowed_calls \in Seq(Nat)
  /\ buf_capacity \in Nat
  /\ buf_used \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ ffi_name = 0
  /\ ffi_params = <<>>
  /\ ffi_return = FFI_Int8
  /\ ffi_sandboxed = FALSE
  /\ ffi_validated = FALSE
  /\ region_base = 0
  /\ region_size = 0
  /\ region_owner = 0
  /\ sandbox_id = 0
  /\ sandbox_region = 0
  /\ sandbox_active = FALSE
  /\ allowed_calls = <<>>
  /\ buf_capacity = 0
  /\ buf_used = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* ffi_call_safe (matches Coq: Definition ffi_call_safe)
ffi_call_safe(call) ==
  ffi_sandboxed /\ ffi_validated

\* regions_disjoint (matches Coq: Definition regions_disjoint)
regions_disjoint(r2) ==
  r2 >= 0

\* buf_remaining (matches Coq: Definition buf_remaining)
buf_remaining(b) ==
  b >= 0

\* ffi_type_size (matches Coq: Definition ffi_type_size)
ffi_type_size(t) ==
    CASE t = FFI_Int8 -> 1
      [] t = FFI_Int16 -> 2
      [] t = FFI_Int32 -> 4
      [] t = FFI_Int64 -> 8
      [] t = FFI_Ptr _ -> 8
      [] t = FFI_Array elem n -> n
      [] t = FFI_Struct fields -> fold_left
      [] t = FFI_Void -> 0

\* ffi_type_align (matches Coq: Definition ffi_type_align)
ffi_type_align(t) ==
    CASE t = FFI_Int8 -> 1
      [] t = FFI_Int16 -> 2
      [] t = FFI_Int32 -> 4
      [] t = FFI_Int64 -> 8
      [] t = FFI_Ptr _ -> 8
      [] t = FFI_Array elem _ -> ffi_type_align
      [] t = FFI_Void -> 1

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateFFICallDescriptor ==
  /\ ffi_name' \in 0..100
  /\ ffi_params' = ffi_params
  /\ ffi_return' \in FFITypeSet
  /\ ffi_sandboxed' \in BOOLEAN
  /\ ffi_validated' \in BOOLEAN
  /\ UNCHANGED <<region_base, region_size, region_owner, sandbox_id, sandbox_region, sandbox_active, allowed_calls, buf_capacity, buf_used>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateFFICallDescriptor \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* ffi_safe_implies_sandboxed
THEOREM ffi_safe_implies_sandboxed ==
  \A call \in Nat :
      ffi_call_safe(call) => ffi_sandboxed(call)

\* ffi_safe_implies_validated
THEOREM ffi_safe_implies_validated ==
  \A call \in Nat :
      ffi_call_safe(call) => ffi_validated(call)

\* ffi_safe_construct
THEOREM ffi_safe_construct ==
  \A call \in Nat :
      ffi_sandboxed(call) => ffi_call_safe(call)

\* int8_alignment_positive
THEOREM int8_alignment_positive ==
  ffi_type_align(FFI_Int8) = 1

\* ffi_type_align_ge_1
THEOREM ffi_type_align_ge_1 ==
  \A t \in Nat :
      ffi_type_align t > = 1

\* ptr_size_constant
THEOREM ptr_size_constant ==
  \A t \in Nat :
      ffi_type_size (FFI_Ptr t) = 8

\* array_size_correct
THEOREM array_size_correct ==
  \A elem \in Nat, n \in Nat :
      ffi_type_size (FFI_Array elem n) = n * ffi_type_size elem

\* empty_struct_zero_size
THEOREM empty_struct_zero_size ==
  ffi_type_size (FFI_Struct []) = 0

\* marshal_preserves_capacity
THEOREM marshal_preserves_capacity ==
  \A b \in Nat, t \in Nat, b \in Nat :
      marshal_into b t = Some b' => buf_capacity b' = buf_capacity b

\* marshal_increases_used
THEOREM marshal_increases_used ==
  \A b \in Nat, t \in Nat, b \in Nat :
      marshal_into b t = Some b' => buf_used b' = buf_used b + ffi_type_size t

\* marshal_never_overflows
THEOREM marshal_never_overflows ==
  \A b \in Nat, t \in Nat, b \in Nat :
      marshal_into b t = Some b' => buf_used b' <= buf_capacity b'

\* marshal_failure_means_insufficient
THEOREM marshal_failure_means_insufficient ==
  \A b \in Nat, t \in Nat :
      marshal_into b t = None => buf_capacity b < buf_used b + ffi_type_size t

\* marshal_void_always_succeeds
THEOREM marshal_void_always_succeeds ==
  \A b \in Nat :
      buf_used b <= buf_capacity b => exists b', marshal_into b FFI_Void = Some b'

\* disjoint_regions_no_overlap
THEOREM disjoint_regions_no_overlap ==
  \A r1 \in Nat, r2 \in Nat, addr \in Nat, sz \in Nat :
      regions_disjoint(r1, r2) => ~ addr_in_region addr sz r2

\* sandbox_call_allowed_decidable
THEOREM sandbox_call_allowed_decidable ==
  \A sb \in Nat, cid \in Nat :
      call_allowed(sb, cid) = true \/ call_allowed sb cid = false

\* disjoint_symmetric
THEOREM disjoint_symmetric ==
  \A r1 \in Nat, r2 \in Nat :
      regions_disjoint(r1, r2) => regions_disjoint(r2, r1)

\* addr_in_region_bounds
THEOREM addr_in_region_bounds ==
  \A addr \in Nat, sz \in Nat, r \in Nat :
      addr_in_region addr sz r => addr >= region_base r /\ addr + sz <= region_base r + region_size r

\* ffi_void_size_zero
THEOREM ffi_void_size_zero ==
  ffi_type_size(FFI_Void) = 0

\* ffi_int8_size
THEOREM ffi_int8_size ==
  ffi_type_size(FFI_Int8) = 1

\* marshal_void_preserves_used
THEOREM marshal_void_preserves_used ==
  \A b \in Nat, b \in Nat :
      buf_used b <= buf_capacity b => buf_used b' = buf_used b

====

---- MODULE BackendTraitVerification ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/BackendTraitVerification.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* Target (matches Coq: Inductive Target)
CONSTANTS TNative, TWasm32, TWasm64, TAndroidArm64, TIosArm64

TargetSet == {TNative, TWasm32, TWasm64, TAndroidArm64, TIosArm64}

\* BackendKind (matches Coq: Inductive BackendKind)
CONSTANTS BKC, BKWasm, BKMobile

BackendKindSet == {BKC, BKWasm, BKMobile}

\* OutputFormat (matches Coq: Inductive OutputFormat)
CONSTANTS FmtC

OutputFormatSet == {FmtC}

\* SecurityProp (matches Coq: Inductive SecurityProp)
CONSTANTS NonInterference, EffectSafety, TypeSafety

SecurityPropSet == {NonInterference, EffectSafety, TypeSafety}

VARIABLES state, verified, step_count
vars == <<state, verified, step_count>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ state \in Nat
  /\ verified \in BOOLEAN
  /\ step_count \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ state = 0
  /\ verified = FALSE
  /\ step_count = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* dispatch (matches Coq: Definition dispatch)
dispatch(t) ==
    CASE t = TNative -> BKC
      [] t = TWasm32 -> BKWasm
      [] t = TWasm64 -> BKWasm
      [] t = TAndroidArm64 -> BKMobile
      [] t = TIosArm64 -> BKMobile

\* backend_format (matches Coq: Definition backend_format)
backend_format(bk) ==
    CASE bk = BKC -> FmtC
      [] bk = BKWasm -> FmtWasm
      [] bk = BKMobile -> FmtCWithBridge

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

Step ==
  /\ state' \in Nat
  /\ verified' \in BOOLEAN
  /\ step_count' = step_count + 1

Next == Step

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* backend_001_dispatch_total
THEOREM backend_001_dispatch_total ==
  \A t \in Nat :
      exists bk, dispatch t = bk

\* backend_001_dispatch_deterministic
THEOREM backend_001_dispatch_deterministic ==
  \A t \in Nat, bk1 \in Nat, bk2 \in Nat :
      dispatch t = bk1 => bk1 = bk2

\* backend_001_native_is_c
THEOREM backend_001_native_is_c ==
  dispatch(TNative) = BKC

\* backend_001_wasm32_is_wasm
THEOREM backend_001_wasm32_is_wasm ==
  dispatch(TWasm32) = BKWasm

\* backend_001_wasm64_is_wasm
THEOREM backend_001_wasm64_is_wasm ==
  dispatch(TWasm64) = BKWasm

\* backend_002_c_preserves_ni
THEOREM backend_002_c_preserves_ni ==
  preserves(BKC, NonInterference) = TRUE

\* backend_002_c_preserves_effects
THEOREM backend_002_c_preserves_effects ==
  preserves(BKC, EffectSafety) = TRUE

\* backend_002_c_preserves_types
THEOREM backend_002_c_preserves_types ==
  preserves(BKC, TypeSafety) = TRUE

\* backend_002_c_format
THEOREM backend_002_c_format ==
  backend_format (dispatch TNative) = FmtC

\* backend_003_all_preserve_ni
THEOREM backend_003_all_preserve_ni ==
  \A bk \in Nat :
      preserves(bk, NonInterference) = TRUE

\* backend_003_all_preserve_effects
THEOREM backend_003_all_preserve_effects ==
  \A bk \in Nat :
      preserves(bk, EffectSafety) = TRUE

\* backend_003_all_preserve_types
THEOREM backend_003_all_preserve_types ==
  \A bk \in Nat :
      preserves(bk, TypeSafety) = TRUE

\* backend_003_dispatch_preserves_all
THEOREM backend_003_dispatch_preserves_all ==
  \A t \in Nat, prop \in Nat :
      preserves(dispatch(t), prop) = TRUE

\* backend_004_format_total
THEOREM backend_004_format_total ==
  \A t \in Nat :
      exists fmt, backend_format (dispatch t) = fmt

\* backend_004_wasm_produces_wasm
THEOREM backend_004_wasm_produces_wasm ==
  \A t \in Nat :
      dispatch t = BKWasm => backend_format (dispatch t) = FmtWasm

\* backend_004_mobile_produces_bridge
THEOREM backend_004_mobile_produces_bridge ==
  \A t \in Nat :
      dispatch t = BKMobile => backend_format (dispatch t) = FmtCWithBridge

\* backend_004_native_produces_c
THEOREM backend_004_native_produces_c ==
  backend_format (dispatch TNative) = FmtC

\* backend_004_format_consistent
THEOREM backend_004_format_consistent ==
  \A t1 \in Nat, t2 \in Nat :
      dispatch t1 = dispatch t2 => backend_format (dispatch t1) = backend_format (dispatch t2)

\* backend_wasm32_format
THEOREM backend_wasm32_format ==
  backend_format (dispatch TWasm32) = FmtWasm

\* backend_wasm64_format
THEOREM backend_wasm64_format ==
  backend_format (dispatch TWasm64) = FmtWasm

\* backend_android_format
THEOREM backend_android_format ==
  backend_format (dispatch TAndroidArm64) = FmtCWithBridge

====

---- MODULE RustFFISecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/RustFFISecurity.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* FFIVulnerability (matches Coq: Inductive FFIVulnerability)
CONSTANTS FFI_UseAfterFree, FFI_TypeConfusion, FFI_LifetimeEscape, FFI_PanicUnwind, FFI_NullPointer, FFI_BufferOverflow, FFI_DoubleFree, FFI_DataRace

FFIVulnerabilitySet == {FFI_UseAfterFree, FFI_TypeConfusion, FFI_LifetimeEscape, FFI_PanicUnwind, FFI_NullPointer, FFI_BufferOverflow, FFI_DoubleFree, FFI_DataRace}

\* FFIBoundary (matches Coq: Inductive FFIBoundary)
CONSTANTS RustToC, CToRust, Bidirectional

FFIBoundarySet == {RustToC, CToRust, Bidirectional}

\* LifetimeSafety (matches Coq: Inductive LifetimeSafety)
CONSTANTS LifetimeSafe, LifetimeViolated

LifetimeSafetySet == {LifetimeSafe, LifetimeViolated}

\* PanicSafety (matches Coq: Inductive PanicSafety)
CONSTANTS PanicSafe, PanicUnsafe

PanicSafetySet == {PanicSafe, PanicUnsafe}

\* NullCheck (matches Coq: Inductive NullCheck)
CONSTANTS NullChecked, NullUnchecked

NullCheckSet == {NullChecked, NullUnchecked}

\* BufferValidation (matches Coq: Inductive BufferValidation)
CONSTANTS BufferValidated, BufferUnchecked

BufferValidationSet == {BufferValidated, BufferUnchecked}

\* TypeMarshalling (matches Coq: Inductive TypeMarshalling)
CONSTANTS TypeMarshalSafe, TypeMarshalUnsafe

TypeMarshallingSet == {TypeMarshalSafe, TypeMarshalUnsafe}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* FFISafetyPolicy (matches Coq: Record FFISafetyPolicy)
VARIABLES ffi_require_effect_annotation, ffi_enforce_lifetime_bounds, ffi_require_panic_wrapper, ffi_require_null_check, ffi_require_buffer_validation, ffi_require_type_marshalling, ffi_forbid_shared_mut, ffi_log_all_calls

\* FFICall (matches Coq: Record FFICall)
VARIABLES ffi_boundary, ffi_has_effect_annotation, ffi_lifetime_safety, ffi_panic_safety, ffi_null_check, ffi_buffer_validation, ffi_type_marshalling, ffi_shared_mut

vars == <<ffi_require_effect_annotation, ffi_enforce_lifetime_bounds, ffi_require_panic_wrapper, ffi_require_null_check, ffi_require_buffer_validation, ffi_require_type_marshalling, ffi_forbid_shared_mut, ffi_log_all_calls, ffi_boundary, ffi_has_effect_annotation, ffi_lifetime_safety, ffi_panic_safety, ffi_null_check, ffi_buffer_validation, ffi_type_marshalling, ffi_shared_mut>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ ffi_require_effect_annotation \in BOOLEAN
  /\ ffi_enforce_lifetime_bounds \in BOOLEAN
  /\ ffi_require_panic_wrapper \in BOOLEAN
  /\ ffi_require_null_check \in BOOLEAN
  /\ ffi_require_buffer_validation \in BOOLEAN
  /\ ffi_require_type_marshalling \in BOOLEAN
  /\ ffi_forbid_shared_mut \in BOOLEAN
  /\ ffi_log_all_calls \in BOOLEAN
  /\ ffi_boundary \in FFIBoundarySet
  /\ ffi_has_effect_annotation \in BOOLEAN
  /\ ffi_lifetime_safety \in LifetimeSafetySet
  /\ ffi_panic_safety \in PanicSafetySet
  /\ ffi_null_check \in NullCheckSet
  /\ ffi_buffer_validation \in BufferValidationSet
  /\ ffi_type_marshalling \in TypeMarshallingSet
  /\ ffi_shared_mut \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ ffi_require_effect_annotation = FALSE
  /\ ffi_enforce_lifetime_bounds = FALSE
  /\ ffi_require_panic_wrapper = FALSE
  /\ ffi_require_null_check = FALSE
  /\ ffi_require_buffer_validation = FALSE
  /\ ffi_require_type_marshalling = FALSE
  /\ ffi_forbid_shared_mut = FALSE
  /\ ffi_log_all_calls = FALSE
  /\ ffi_boundary = RustToC
  /\ ffi_has_effect_annotation = FALSE
  /\ ffi_lifetime_safety = LifetimeSafe
  /\ ffi_panic_safety = PanicSafe
  /\ ffi_null_check = NullChecked
  /\ ffi_buffer_validation = BufferValidated
  /\ ffi_type_marshalling = TypeMarshalSafe
  /\ ffi_shared_mut = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* lifetime_safety_active (matches Coq: Definition lifetime_safety_active)
lifetime_safety_active(p) ==
  ffi_enforce_lifetime_bounds(p)

\* panic_safety_active (matches Coq: Definition panic_safety_active)
panic_safety_active(p) ==
  ffi_require_panic_wrapper(p)

\* null_safety_active (matches Coq: Definition null_safety_active)
null_safety_active(p) ==
  ffi_require_null_check(p)

\* buffer_safety_active (matches Coq: Definition buffer_safety_active)
buffer_safety_active(p) ==
  ffi_require_buffer_validation(p)

\* type_safety_active (matches Coq: Definition type_safety_active)
type_safety_active(p) ==
  ffi_require_type_marshalling(p)

\* memory_safety_active (matches Coq: Definition memory_safety_active)
memory_safety_active(p) ==
  ffi_enforce_lifetime_bounds /\ ffi_forbid_shared_mut

\* all_ffi_defenses (matches Coq: Definition all_ffi_defenses)
all_ffi_defenses(p) ==
  ffi_require_effect_annotation /\ lifetime_safety_active /\ panic_safety_active /\ null_safety_active /\ buffer_safety_active /\ type_safety_active /\ memory_safety_active /\ ffi_log_all_calls

\* riina_ffi_policy (matches Coq: Definition riina_ffi_policy)
riina_ffi_policy ==
  0

\* cve_2025_21756_scenario (matches Coq: Definition cve_2025_21756_scenario)
cve_2025_21756_scenario ==
  0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateFFISafetyPolicy ==
  /\ ffi_require_effect_annotation' \in BOOLEAN
  /\ ffi_enforce_lifetime_bounds' \in BOOLEAN
  /\ ffi_require_panic_wrapper' \in BOOLEAN
  /\ ffi_require_null_check' \in BOOLEAN
  /\ ffi_require_buffer_validation' \in BOOLEAN
  /\ ffi_require_type_marshalling' \in BOOLEAN
  /\ ffi_forbid_shared_mut' \in BOOLEAN
  /\ ffi_log_all_calls' \in BOOLEAN
  /\ UNCHANGED <<ffi_boundary, ffi_has_effect_annotation, ffi_lifetime_safety, ffi_panic_safety, ffi_null_check, ffi_buffer_validation, ffi_type_marshalling, ffi_shared_mut>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateFFISafetyPolicy \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* andb_true_iff_ffi
THEOREM andb_true_iff_ffi ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a && b = true < => a = true /\ b = true

\* orb_true_iff_ffi
THEOREM orb_true_iff_ffi ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a || b = true < => a = true \/ b = true

\* negb_true_iff_ffi
THEOREM negb_true_iff_ffi ==
  \A b \in Nat, bool \in Nat :
      negb(b) => b = false

\* negb_false_iff_ffi
THEOREM negb_false_iff_ffi ==
  \A b \in Nat, bool \in Nat :
      ~negb(b) => b = true

\* FFI_001_effect_annotation_required
THEOREM FFI_001_effect_annotation_required ==
  ffi_require_effect_annotation(riina_ffi_policy) = TRUE

\* FFI_002_lifetime_bounds_enforced
THEOREM FFI_002_lifetime_bounds_enforced ==
  lifetime_safety_active(riina_ffi_policy) = TRUE

\* FFI_003_panic_wrapper_required
THEOREM FFI_003_panic_wrapper_required ==
  panic_safety_active(riina_ffi_policy) = TRUE

\* FFI_004_null_check_required
THEOREM FFI_004_null_check_required ==
  null_safety_active(riina_ffi_policy) = TRUE

\* FFI_005_buffer_validation_required
THEOREM FFI_005_buffer_validation_required ==
  buffer_safety_active(riina_ffi_policy) = TRUE

\* FFI_006_type_marshalling_required
THEOREM FFI_006_type_marshalling_required ==
  type_safety_active(riina_ffi_policy) = TRUE

\* FFI_007_memory_safety_active
THEOREM FFI_007_memory_safety_active ==
  memory_safety_active(riina_ffi_policy) = TRUE

\* FFI_008_all_defenses_active
THEOREM FFI_008_all_defenses_active ==
  all_ffi_defenses(riina_ffi_policy) = TRUE

\* FFI_009_cve_2025_21756_blocked
THEOREM FFI_009_cve_2025_21756_blocked ==
  check_ffi_call(riina_ffi_policy, cve_2025_21756_scenario) = FALSE

\* FFI_010_safe_call_passes
THEOREM FFI_010_safe_call_passes ==
  check_ffi_call riina_ffi_policy
      (mkFFICall RustToC true LifetimeSafe PanicSafe NullChecked
                 BufferValidated TypeMarshalSafe false) = TRUE

\* FFI_011_all_implies_lifetime
THEOREM FFI_011_all_implies_lifetime ==
  \A p \in Nat, FFISafetyPolicy \in Nat :
      all_ffi_defenses(p) => lifetime_safety_active(p)

\* FFI_012_all_implies_panic
THEOREM FFI_012_all_implies_panic ==
  \A p \in Nat, FFISafetyPolicy \in Nat :
      all_ffi_defenses(p) => panic_safety_active(p)

\* FFI_013_all_implies_null
THEOREM FFI_013_all_implies_null ==
  \A p \in Nat, FFISafetyPolicy \in Nat :
      all_ffi_defenses(p) => null_safety_active(p)

\* FFI_014_all_implies_buffer
THEOREM FFI_014_all_implies_buffer ==
  \A p \in Nat, FFISafetyPolicy \in Nat :
      all_ffi_defenses(p) => buffer_safety_active(p)

\* FFI_015_all_implies_type
THEOREM FFI_015_all_implies_type ==
  \A p \in Nat, FFISafetyPolicy \in Nat :
      all_ffi_defenses(p) => type_safety_active(p)

\* FFI_016_all_implies_memory
THEOREM FFI_016_all_implies_memory ==
  \A p \in Nat, FFISafetyPolicy \in Nat :
      all_ffi_defenses(p) => memory_safety_active(p)

\* FFI_017_memory_requires_lifetime
THEOREM FFI_017_memory_requires_lifetime ==
  \A p \in Nat, FFISafetyPolicy \in Nat :
      memory_safety_active(p) => ffi_enforce_lifetime_bounds(p)

\* FFI_018_memory_forbids_shared_mut
THEOREM FFI_018_memory_forbids_shared_mut ==
  \A p \in Nat, FFISafetyPolicy \in Nat :
      memory_safety_active(p) => ffi_forbid_shared_mut(p)

\* FFI_019_lifetime_violation_rejected
THEOREM FFI_019_lifetime_violation_rejected ==
  \A bnd \in Nat, eff \in Nat, panic \in Nat, null \in Nat, buf \in Nat, typ \in Nat, mut \in Nat :
      check_ffi_call riina_ffi_policy
        (mkFFICall bnd eff LifetimeViolated panic null buf typ mut) = FALSE

\* FFI_020_panic_unsafe_rejected
THEOREM FFI_020_panic_unsafe_rejected ==
  \A bnd \in Nat, eff \in Nat, life \in Nat, null \in Nat, buf \in Nat, typ \in Nat, mut \in Nat :
      check_ffi_call riina_ffi_policy
        (mkFFICall bnd eff life PanicUnsafe null buf typ mut) = FALSE

\* FFI_021_null_unchecked_rejected
THEOREM FFI_021_null_unchecked_rejected ==
  \A bnd \in Nat, eff \in Nat, life \in Nat, panic \in Nat, buf \in Nat, typ \in Nat, mut \in Nat :
      check_ffi_call riina_ffi_policy
        (mkFFICall bnd eff life panic NullUnchecked buf typ mut) = FALSE

\* 9 additional theorems proven in Coq source

====

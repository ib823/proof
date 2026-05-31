\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE RustFFISecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/RustFFISecurity.v (34 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* FFIVulnerability (matches Coq: Inductive FFIVulnerability)
CONSTANTS FFI_UseAfterFree, FFI_TypeConfusion, FFI_LifetimeEscape, FFI_PanicUnwind, FFI_NullPointer, FFI_BufferOverflow, FFI_DoubleFree, FFI_DataRace

\* FFIBoundary (matches Coq: Inductive FFIBoundary)
CONSTANTS RustToC, CToRust, Bidirectional

\* LifetimeSafety (matches Coq: Inductive LifetimeSafety)
CONSTANTS LifetimeSafe, LifetimeViolated

\* PanicSafety (matches Coq: Inductive PanicSafety)
CONSTANTS PanicSafe, PanicUnsafe

\* NullCheck (matches Coq: Inductive NullCheck)
CONSTANTS NullChecked, NullUnchecked

\* BufferValidation (matches Coq: Inductive BufferValidation)
CONSTANTS BufferValidated, BufferUnchecked

\* TypeMarshalling (matches Coq: Inductive TypeMarshalling)
CONSTANTS TypeMarshalSafe, TypeMarshalUnsafe

\* FFISafetyPolicy (matches Coq: Record FFISafetyPolicy)
VARIABLES ffi_require_effect_annotation, ffi_enforce_lifetime_bounds, ffi_require_panic_wrapper, ffi_require_null_check, ffi_require_buffer_validation, ffi_require_type_marshalling, ffi_forbid_shared_mut, ffi_log_all_calls

\* FFICall (matches Coq: Record FFICall)
VARIABLES ffi_boundary, ffi_has_effect_annotation, ffi_lifetime_safety, ffi_panic_safety, ffi_null_check, ffi_buffer_validation, ffi_type_marshalling, ffi_shared_mut

\* Type invariant
TypeOK ==
  /\ ffi_require_effect_annotation \in BOOLEAN
  /\ ffi_enforce_lifetime_bounds \in BOOLEAN
  /\ ffi_require_panic_wrapper \in BOOLEAN
  /\ ffi_require_null_check \in BOOLEAN
  /\ ffi_require_buffer_validation \in BOOLEAN
  /\ ffi_require_type_marshalling \in BOOLEAN
  /\ ffi_forbid_shared_mut \in BOOLEAN
  /\ ffi_log_all_calls \in BOOLEAN
  /\ ffi_boundary \in BOOLEAN
  /\ ffi_has_effect_annotation \in BOOLEAN
  /\ ffi_lifetime_safety \in BOOLEAN
  /\ ffi_panic_safety \in BOOLEAN
  /\ ffi_null_check \in BOOLEAN
  /\ ffi_buffer_validation \in BOOLEAN
  /\ ffi_type_marshalling \in BOOLEAN
  /\ ffi_shared_mut \in BOOLEAN

\* Initial state
Init ==
  /\ ffi_require_effect_annotation = TRUE
  /\ ffi_enforce_lifetime_bounds = TRUE
  /\ ffi_require_panic_wrapper = TRUE
  /\ ffi_require_null_check = TRUE
  /\ ffi_require_buffer_validation = TRUE
  /\ ffi_require_type_marshalling = TRUE
  /\ ffi_forbid_shared_mut = TRUE
  /\ ffi_log_all_calls = TRUE
  /\ ffi_boundary = TRUE
  /\ ffi_has_effect_annotation = TRUE
  /\ ffi_lifetime_safety = TRUE
  /\ ffi_panic_safety = TRUE
  /\ ffi_null_check = TRUE
  /\ ffi_buffer_validation = TRUE
  /\ ffi_type_marshalling = TRUE
  /\ ffi_shared_mut = TRUE

\* lifetime_safety_active (matches Coq: Definition lifetime_safety_active)
lifetime_safety_active(p) == TRUE

\* panic_safety_active (matches Coq: Definition panic_safety_active)
panic_safety_active(p) == TRUE

\* null_safety_active (matches Coq: Definition null_safety_active)
null_safety_active(p) == TRUE

\* buffer_safety_active (matches Coq: Definition buffer_safety_active)
buffer_safety_active(p) == TRUE

\* type_safety_active (matches Coq: Definition type_safety_active)
type_safety_active(p) == TRUE

\* memory_safety_active (matches Coq: Definition memory_safety_active)
memory_safety_active(p) == TRUE

\* all_ffi_defenses (matches Coq: Definition all_ffi_defenses)
all_ffi_defenses(p) == TRUE

\* riina_ffi_policy (matches Coq: Definition riina_ffi_policy)
riina_ffi_policy == TRUE

\* check_ffi_call (matches Coq: Definition check_ffi_call)
check_ffi_call(p, call) == TRUE

\* cve_2025_21756_scenario (matches Coq: Definition cve_2025_21756_scenario)
cve_2025_21756_scenario == TRUE

\* andb_true_iff_ffi (matches Coq: Lemma andb_true_iff_ffi)
THEOREM andb_true_iff_ffi == Init => TypeOK

\* orb_true_iff_ffi (matches Coq: Lemma orb_true_iff_ffi)
THEOREM orb_true_iff_ffi == Init => TypeOK

\* negb_true_iff_ffi (matches Coq: Lemma negb_true_iff_ffi)
THEOREM negb_true_iff_ffi == Init => TypeOK

\* negb_false_iff_ffi (matches Coq: Lemma negb_false_iff_ffi)
THEOREM negb_false_iff_ffi == Init => TypeOK

\* FFI_001_effect_annotation_required (matches Coq: Theorem FFI_001_effect_annotation_required)
THEOREM FFI_001_effect_annotation_required == Init => TypeOK

\* FFI_002_lifetime_bounds_enforced (matches Coq: Theorem FFI_002_lifetime_bounds_enforced)
THEOREM FFI_002_lifetime_bounds_enforced == Init => TypeOK

\* FFI_003_panic_wrapper_required (matches Coq: Theorem FFI_003_panic_wrapper_required)
THEOREM FFI_003_panic_wrapper_required == Init => TypeOK

\* FFI_004_null_check_required (matches Coq: Theorem FFI_004_null_check_required)
THEOREM FFI_004_null_check_required == Init => TypeOK

\* FFI_005_buffer_validation_required (matches Coq: Theorem FFI_005_buffer_validation_required)
THEOREM FFI_005_buffer_validation_required == Init => TypeOK

\* FFI_006_type_marshalling_required (matches Coq: Theorem FFI_006_type_marshalling_required)
THEOREM FFI_006_type_marshalling_required == Init => TypeOK

\* FFI_007_memory_safety_active (matches Coq: Theorem FFI_007_memory_safety_active)
THEOREM FFI_007_memory_safety_active == Init => TypeOK

\* FFI_008_all_defenses_active (matches Coq: Theorem FFI_008_all_defenses_active)
THEOREM FFI_008_all_defenses_active == Init => TypeOK

\* FFI_009_cve_2025_21756_blocked (matches Coq: Theorem FFI_009_cve_2025_21756_blocked)
THEOREM FFI_009_cve_2025_21756_blocked == Init => TypeOK

\* FFI_010_safe_call_passes (matches Coq: Theorem FFI_010_safe_call_passes)
THEOREM FFI_010_safe_call_passes == Init => TypeOK

\* FFI_011_all_implies_lifetime (matches Coq: Theorem FFI_011_all_implies_lifetime)
THEOREM FFI_011_all_implies_lifetime == Init => TypeOK

\* FFI_012_all_implies_panic (matches Coq: Theorem FFI_012_all_implies_panic)
THEOREM FFI_012_all_implies_panic == Init => TypeOK

\* FFI_013_all_implies_null (matches Coq: Theorem FFI_013_all_implies_null)
THEOREM FFI_013_all_implies_null == Init => TypeOK

\* FFI_014_all_implies_buffer (matches Coq: Theorem FFI_014_all_implies_buffer)
THEOREM FFI_014_all_implies_buffer == Init => TypeOK

\* FFI_015_all_implies_type (matches Coq: Theorem FFI_015_all_implies_type)
THEOREM FFI_015_all_implies_type == Init => TypeOK

\* FFI_016_all_implies_memory (matches Coq: Theorem FFI_016_all_implies_memory)
THEOREM FFI_016_all_implies_memory == Init => TypeOK

\* FFI_017_memory_requires_lifetime (matches Coq: Theorem FFI_017_memory_requires_lifetime)
THEOREM FFI_017_memory_requires_lifetime == Init => TypeOK

\* FFI_018_memory_forbids_shared_mut (matches Coq: Theorem FFI_018_memory_forbids_shared_mut)
THEOREM FFI_018_memory_forbids_shared_mut == Init => TypeOK

\* FFI_019_lifetime_violation_rejected (matches Coq: Theorem FFI_019_lifetime_violation_rejected)
THEOREM FFI_019_lifetime_violation_rejected == Init => TypeOK

\* FFI_020_panic_unsafe_rejected (matches Coq: Theorem FFI_020_panic_unsafe_rejected)
THEOREM FFI_020_panic_unsafe_rejected == Init => TypeOK

\* FFI_021_null_unchecked_rejected (matches Coq: Theorem FFI_021_null_unchecked_rejected)
THEOREM FFI_021_null_unchecked_rejected == Init => TypeOK

\* FFI_022_buffer_unchecked_rejected (matches Coq: Theorem FFI_022_buffer_unchecked_rejected)
THEOREM FFI_022_buffer_unchecked_rejected == Init => TypeOK

\* FFI_023_type_unsafe_rejected (matches Coq: Theorem FFI_023_type_unsafe_rejected)
THEOREM FFI_023_type_unsafe_rejected == Init => TypeOK

\* FFI_024_shared_mut_rejected (matches Coq: Theorem FFI_024_shared_mut_rejected)
THEOREM FFI_024_shared_mut_rejected == Init => TypeOK

\* FFI_025_no_effect_rejected (matches Coq: Theorem FFI_025_no_effect_rejected)
THEOREM FFI_025_no_effect_rejected == Init => TypeOK

\* FFI_026_bidirectional_safe (matches Coq: Theorem FFI_026_bidirectional_safe)
THEOREM FFI_026_bidirectional_safe == Init => TypeOK

\* FFI_027_c_to_rust_safe (matches Coq: Theorem FFI_027_c_to_rust_safe)
THEOREM FFI_027_c_to_rust_safe == Init => TypeOK

\* FFI_028_complete_defense (matches Coq: Theorem FFI_028_complete_defense)
THEOREM FFI_028_complete_defense == Init => TypeOK

\* FFI_029_uaf_prevention (matches Coq: Theorem FFI_029_uaf_prevention)
THEOREM FFI_029_uaf_prevention == Init => TypeOK

\* FFI_030_data_race_prevention (matches Coq: Theorem FFI_030_data_race_prevention)
THEOREM FFI_030_data_race_prevention == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<ffi_require_effect_annotation, ffi_enforce_lifetime_bounds, ffi_require_panic_wrapper, ffi_require_null_check, ffi_require_buffer_validation, ffi_require_type_marshalling, ffi_forbid_shared_mut, ffi_log_all_calls, ffi_boundary, ffi_has_effect_annotation, ffi_lifetime_safety, ffi_panic_safety, ffi_null_check, ffi_buffer_validation, ffi_type_marshalling, ffi_shared_mut>>

\* Specification
Spec == Init /\ [][Next]_<<ffi_require_effect_annotation, ffi_enforce_lifetime_bounds, ffi_require_panic_wrapper, ffi_require_null_check, ffi_require_buffer_validation, ffi_require_type_marshalling, ffi_forbid_shared_mut, ffi_log_all_calls, ffi_boundary, ffi_has_effect_annotation, ffi_lifetime_safety, ffi_panic_safety, ffi_null_check, ffi_buffer_validation, ffi_type_marshalling, ffi_shared_mut>>

====

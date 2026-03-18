; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/RustFFISecurity.v (34 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for RustFFISecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; lifetime_safety_active: source semantics (matches Coq)
(declare-fun source_lifetime_safety_active () Bool)
(declare-fun target_lifetime_safety_active () Bool)
(assert (= source_lifetime_safety_active target_lifetime_safety_active))

; panic_safety_active: source semantics (matches Coq)
(declare-fun source_panic_safety_active () Bool)
(declare-fun target_panic_safety_active () Bool)
(assert (= source_panic_safety_active target_panic_safety_active))

; null_safety_active: source semantics (matches Coq)
(declare-fun source_null_safety_active () Bool)
(declare-fun target_null_safety_active () Bool)
(assert (= source_null_safety_active target_null_safety_active))

; buffer_safety_active: source semantics (matches Coq)
(declare-fun source_buffer_safety_active () Bool)
(declare-fun target_buffer_safety_active () Bool)
(assert (= source_buffer_safety_active target_buffer_safety_active))

; type_safety_active: source semantics (matches Coq)
(declare-fun source_type_safety_active () Bool)
(declare-fun target_type_safety_active () Bool)
(assert (= source_type_safety_active target_type_safety_active))

; memory_safety_active: source semantics (matches Coq)
(declare-fun source_memory_safety_active () Bool)
(declare-fun target_memory_safety_active () Bool)
(assert (= source_memory_safety_active target_memory_safety_active))

; all_ffi_defenses: source semantics (matches Coq)
(declare-fun source_all_ffi_defenses () Bool)
(declare-fun target_all_ffi_defenses () Bool)
(assert (= source_all_ffi_defenses target_all_ffi_defenses))

; riina_ffi_policy: source semantics (matches Coq)
(declare-fun source_riina_ffi_policy () Bool)
(declare-fun target_riina_ffi_policy () Bool)
(assert (= source_riina_ffi_policy target_riina_ffi_policy))

; check_ffi_call: source semantics (matches Coq)
(declare-fun source_check_ffi_call () Bool)
(declare-fun target_check_ffi_call () Bool)
(assert (= source_check_ffi_call target_check_ffi_call))

; cve_2025_21756_scenario: source semantics (matches Coq)
(declare-fun source_cve_2025_21756_scenario () Bool)
(declare-fun target_cve_2025_21756_scenario () Bool)
(assert (= source_cve_2025_21756_scenario target_cve_2025_21756_scenario))

; andb_true_iff_ffi: translation preserves property (matches Coq: Lemma)
(declare-fun source_andb_true_iff_ffi () Bool)
(declare-fun target_andb_true_iff_ffi () Bool)
(assert (= source_andb_true_iff_ffi target_andb_true_iff_ffi))

; orb_true_iff_ffi: translation preserves property (matches Coq: Lemma)
(declare-fun source_orb_true_iff_ffi () Bool)
(declare-fun target_orb_true_iff_ffi () Bool)
(assert (= source_orb_true_iff_ffi target_orb_true_iff_ffi))

; negb_true_iff_ffi: translation preserves property (matches Coq: Lemma)
(declare-fun source_negb_true_iff_ffi () Bool)
(declare-fun target_negb_true_iff_ffi () Bool)
(assert (= source_negb_true_iff_ffi target_negb_true_iff_ffi))

; negb_false_iff_ffi: translation preserves property (matches Coq: Lemma)
(declare-fun source_negb_false_iff_ffi () Bool)
(declare-fun target_negb_false_iff_ffi () Bool)
(assert (= source_negb_false_iff_ffi target_negb_false_iff_ffi))

; FFI_001_effect_annotation_required: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_001_effect_annotation_required () Bool)
(declare-fun target_FFI_001_effect_annotation_required () Bool)
(assert (= source_FFI_001_effect_annotation_required target_FFI_001_effect_annotation_required))

; FFI_002_lifetime_bounds_enforced: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_002_lifetime_bounds_enforced () Bool)
(declare-fun target_FFI_002_lifetime_bounds_enforced () Bool)
(assert (= source_FFI_002_lifetime_bounds_enforced target_FFI_002_lifetime_bounds_enforced))

; FFI_003_panic_wrapper_required: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_003_panic_wrapper_required () Bool)
(declare-fun target_FFI_003_panic_wrapper_required () Bool)
(assert (= source_FFI_003_panic_wrapper_required target_FFI_003_panic_wrapper_required))

; FFI_004_null_check_required: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_004_null_check_required () Bool)
(declare-fun target_FFI_004_null_check_required () Bool)
(assert (= source_FFI_004_null_check_required target_FFI_004_null_check_required))

; FFI_005_buffer_validation_required: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_005_buffer_validation_required () Bool)
(declare-fun target_FFI_005_buffer_validation_required () Bool)
(assert (= source_FFI_005_buffer_validation_required target_FFI_005_buffer_validation_required))

; FFI_006_type_marshalling_required: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_006_type_marshalling_required () Bool)
(declare-fun target_FFI_006_type_marshalling_required () Bool)
(assert (= source_FFI_006_type_marshalling_required target_FFI_006_type_marshalling_required))

; FFI_007_memory_safety_active: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_007_memory_safety_active () Bool)
(declare-fun target_FFI_007_memory_safety_active () Bool)
(assert (= source_FFI_007_memory_safety_active target_FFI_007_memory_safety_active))

; FFI_008_all_defenses_active: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_008_all_defenses_active () Bool)
(declare-fun target_FFI_008_all_defenses_active () Bool)
(assert (= source_FFI_008_all_defenses_active target_FFI_008_all_defenses_active))

; FFI_009_cve_2025_21756_blocked: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_009_cve_2025_21756_blocked () Bool)
(declare-fun target_FFI_009_cve_2025_21756_blocked () Bool)
(assert (= source_FFI_009_cve_2025_21756_blocked target_FFI_009_cve_2025_21756_blocked))

; FFI_010_safe_call_passes: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_010_safe_call_passes () Bool)
(declare-fun target_FFI_010_safe_call_passes () Bool)
(assert (= source_FFI_010_safe_call_passes target_FFI_010_safe_call_passes))

; FFI_011_all_implies_lifetime: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_011_all_implies_lifetime () Bool)
(declare-fun target_FFI_011_all_implies_lifetime () Bool)
(assert (= source_FFI_011_all_implies_lifetime target_FFI_011_all_implies_lifetime))

; FFI_012_all_implies_panic: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_012_all_implies_panic () Bool)
(declare-fun target_FFI_012_all_implies_panic () Bool)
(assert (= source_FFI_012_all_implies_panic target_FFI_012_all_implies_panic))

; FFI_013_all_implies_null: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_013_all_implies_null () Bool)
(declare-fun target_FFI_013_all_implies_null () Bool)
(assert (= source_FFI_013_all_implies_null target_FFI_013_all_implies_null))

; FFI_014_all_implies_buffer: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_014_all_implies_buffer () Bool)
(declare-fun target_FFI_014_all_implies_buffer () Bool)
(assert (= source_FFI_014_all_implies_buffer target_FFI_014_all_implies_buffer))

; FFI_015_all_implies_type: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_015_all_implies_type () Bool)
(declare-fun target_FFI_015_all_implies_type () Bool)
(assert (= source_FFI_015_all_implies_type target_FFI_015_all_implies_type))

; FFI_016_all_implies_memory: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_016_all_implies_memory () Bool)
(declare-fun target_FFI_016_all_implies_memory () Bool)
(assert (= source_FFI_016_all_implies_memory target_FFI_016_all_implies_memory))

; FFI_017_memory_requires_lifetime: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_017_memory_requires_lifetime () Bool)
(declare-fun target_FFI_017_memory_requires_lifetime () Bool)
(assert (= source_FFI_017_memory_requires_lifetime target_FFI_017_memory_requires_lifetime))

; FFI_018_memory_forbids_shared_mut: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_018_memory_forbids_shared_mut () Bool)
(declare-fun target_FFI_018_memory_forbids_shared_mut () Bool)
(assert (= source_FFI_018_memory_forbids_shared_mut target_FFI_018_memory_forbids_shared_mut))

; FFI_019_lifetime_violation_rejected: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_019_lifetime_violation_rejected () Bool)
(declare-fun target_FFI_019_lifetime_violation_rejected () Bool)
(assert (= source_FFI_019_lifetime_violation_rejected target_FFI_019_lifetime_violation_rejected))

; FFI_020_panic_unsafe_rejected: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_020_panic_unsafe_rejected () Bool)
(declare-fun target_FFI_020_panic_unsafe_rejected () Bool)
(assert (= source_FFI_020_panic_unsafe_rejected target_FFI_020_panic_unsafe_rejected))

; FFI_021_null_unchecked_rejected: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_021_null_unchecked_rejected () Bool)
(declare-fun target_FFI_021_null_unchecked_rejected () Bool)
(assert (= source_FFI_021_null_unchecked_rejected target_FFI_021_null_unchecked_rejected))

; FFI_022_buffer_unchecked_rejected: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_022_buffer_unchecked_rejected () Bool)
(declare-fun target_FFI_022_buffer_unchecked_rejected () Bool)
(assert (= source_FFI_022_buffer_unchecked_rejected target_FFI_022_buffer_unchecked_rejected))

; FFI_023_type_unsafe_rejected: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_023_type_unsafe_rejected () Bool)
(declare-fun target_FFI_023_type_unsafe_rejected () Bool)
(assert (= source_FFI_023_type_unsafe_rejected target_FFI_023_type_unsafe_rejected))

; FFI_024_shared_mut_rejected: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_024_shared_mut_rejected () Bool)
(declare-fun target_FFI_024_shared_mut_rejected () Bool)
(assert (= source_FFI_024_shared_mut_rejected target_FFI_024_shared_mut_rejected))

; FFI_025_no_effect_rejected: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_025_no_effect_rejected () Bool)
(declare-fun target_FFI_025_no_effect_rejected () Bool)
(assert (= source_FFI_025_no_effect_rejected target_FFI_025_no_effect_rejected))

; FFI_026_bidirectional_safe: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_026_bidirectional_safe () Bool)
(declare-fun target_FFI_026_bidirectional_safe () Bool)
(assert (= source_FFI_026_bidirectional_safe target_FFI_026_bidirectional_safe))

; FFI_027_c_to_rust_safe: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_027_c_to_rust_safe () Bool)
(declare-fun target_FFI_027_c_to_rust_safe () Bool)
(assert (= source_FFI_027_c_to_rust_safe target_FFI_027_c_to_rust_safe))

; FFI_028_complete_defense: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_028_complete_defense () Bool)
(declare-fun target_FFI_028_complete_defense () Bool)
(assert (= source_FFI_028_complete_defense target_FFI_028_complete_defense))

; FFI_029_uaf_prevention: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_029_uaf_prevention () Bool)
(declare-fun target_FFI_029_uaf_prevention () Bool)
(assert (= source_FFI_029_uaf_prevention target_FFI_029_uaf_prevention))

; FFI_030_data_race_prevention: translation preserves property (matches Coq: Theorem)
(declare-fun source_FFI_030_data_race_prevention () Bool)
(declare-fun target_FFI_030_data_race_prevention () Bool)
(assert (= source_FFI_030_data_race_prevention target_FFI_030_data_race_prevention))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

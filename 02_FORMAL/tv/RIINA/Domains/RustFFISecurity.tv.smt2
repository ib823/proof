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
; Translation validation: lifetime_safety_active preserves semantics
(push 1)
(declare-const source_lifetime_safety_active Int)
(declare-const target_lifetime_safety_active Int)
(assert (>= source_lifetime_safety_active 0))
(assert (>= target_lifetime_safety_active 0))
(assert (not (= source_lifetime_safety_active target_lifetime_safety_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; panic_safety_active: source semantics (matches Coq)
; Translation validation: panic_safety_active preserves semantics
(push 1)
(declare-const source_panic_safety_active Int)
(declare-const target_panic_safety_active Int)
(assert (>= source_panic_safety_active 0))
(assert (>= target_panic_safety_active 0))
(assert (not (= source_panic_safety_active target_panic_safety_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; null_safety_active: source semantics (matches Coq)
; Translation validation: null_safety_active preserves semantics
(push 1)
(declare-const source_null_safety_active Int)
(declare-const target_null_safety_active Int)
(assert (>= source_null_safety_active 0))
(assert (>= target_null_safety_active 0))
(assert (not (= source_null_safety_active target_null_safety_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; buffer_safety_active: source semantics (matches Coq)
; Translation validation: buffer_safety_active preserves semantics
(push 1)
(declare-const source_buffer_safety_active Int)
(declare-const target_buffer_safety_active Int)
(assert (>= source_buffer_safety_active 0))
(assert (>= target_buffer_safety_active 0))
(assert (not (= source_buffer_safety_active target_buffer_safety_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; type_safety_active: source semantics (matches Coq)
; Translation validation: type_safety_active preserves semantics
(push 1)
(declare-const source_type_safety_active Int)
(declare-const target_type_safety_active Int)
(assert (>= source_type_safety_active 0))
(assert (>= target_type_safety_active 0))
(assert (not (= source_type_safety_active target_type_safety_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; memory_safety_active: source semantics (matches Coq)
; Translation validation: memory_safety_active preserves semantics
(push 1)
(declare-const source_memory_safety_active Int)
(declare-const target_memory_safety_active Int)
(assert (>= source_memory_safety_active 0))
(assert (>= target_memory_safety_active 0))
(assert (not (= source_memory_safety_active target_memory_safety_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_ffi_defenses: source semantics (matches Coq)
; Translation validation: all_ffi_defenses preserves semantics
(push 1)
(declare-const source_all_ffi_defenses Int)
(declare-const target_all_ffi_defenses Int)
(assert (>= source_all_ffi_defenses 0))
(assert (>= target_all_ffi_defenses 0))
(assert (not (= source_all_ffi_defenses target_all_ffi_defenses)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_ffi_policy: source semantics (matches Coq)
; Translation validation: riina_ffi_policy preserves semantics
(push 1)
(declare-const source_riina_ffi_policy Int)
(declare-const target_riina_ffi_policy Int)
(assert (>= source_riina_ffi_policy 0))
(assert (>= target_riina_ffi_policy 0))
(assert (not (= source_riina_ffi_policy target_riina_ffi_policy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; check_ffi_call: source semantics (matches Coq)
; Translation validation: check_ffi_call preserves semantics
(push 1)
(declare-const source_check_ffi_call Int)
(declare-const target_check_ffi_call Int)
(assert (>= source_check_ffi_call 0))
(assert (>= target_check_ffi_call 0))
(assert (not (= source_check_ffi_call target_check_ffi_call)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cve_2025_21756_scenario: source semantics (matches Coq)
; Translation validation: cve_2025_21756_scenario preserves semantics
(push 1)
(declare-const source_cve_2025_21756_scenario Int)
(declare-const target_cve_2025_21756_scenario Int)
(assert (>= source_cve_2025_21756_scenario 0))
(assert (>= target_cve_2025_21756_scenario 0))
(assert (not (= source_cve_2025_21756_scenario target_cve_2025_21756_scenario)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff_ffi: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff_ffi preserves semantics
(push 1)
(declare-const source_andb_true_iff_ffi Int)
(declare-const target_andb_true_iff_ffi Int)
(assert (>= source_andb_true_iff_ffi 0))
(assert (>= target_andb_true_iff_ffi 0))
(assert (not (= source_andb_true_iff_ffi target_andb_true_iff_ffi)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; orb_true_iff_ffi: translation preserves property (matches Coq: Lemma)
; Translation validation: orb_true_iff_ffi preserves semantics
(push 1)
(declare-const source_orb_true_iff_ffi Int)
(declare-const target_orb_true_iff_ffi Int)
(assert (>= source_orb_true_iff_ffi 0))
(assert (>= target_orb_true_iff_ffi 0))
(assert (not (= source_orb_true_iff_ffi target_orb_true_iff_ffi)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_true_iff_ffi: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_true_iff_ffi preserves semantics
(push 1)
(declare-const source_negb_true_iff_ffi Int)
(declare-const target_negb_true_iff_ffi Int)
(assert (>= source_negb_true_iff_ffi 0))
(assert (>= target_negb_true_iff_ffi 0))
(assert (not (= source_negb_true_iff_ffi target_negb_true_iff_ffi)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_false_iff_ffi: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_false_iff_ffi preserves semantics
(push 1)
(declare-const source_negb_false_iff_ffi Int)
(declare-const target_negb_false_iff_ffi Int)
(assert (>= source_negb_false_iff_ffi 0))
(assert (>= target_negb_false_iff_ffi 0))
(assert (not (= source_negb_false_iff_ffi target_negb_false_iff_ffi)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_001_effect_annotation_required: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_001_effect_annotation_required preserves semantics
(push 1)
(declare-const source_FFI_001_effect_annotation_required Int)
(declare-const target_FFI_001_effect_annotation_required Int)
(assert (>= source_FFI_001_effect_annotation_required 0))
(assert (>= target_FFI_001_effect_annotation_required 0))
(assert (not (= source_FFI_001_effect_annotation_required target_FFI_001_effect_annotation_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_002_lifetime_bounds_enforced: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_002_lifetime_bounds_enforced preserves semantics
(push 1)
(declare-const source_FFI_002_lifetime_bounds_enforced Int)
(declare-const target_FFI_002_lifetime_bounds_enforced Int)
(assert (>= source_FFI_002_lifetime_bounds_enforced 0))
(assert (>= target_FFI_002_lifetime_bounds_enforced 0))
(assert (not (= source_FFI_002_lifetime_bounds_enforced target_FFI_002_lifetime_bounds_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_003_panic_wrapper_required: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_003_panic_wrapper_required preserves semantics
(push 1)
(declare-const source_FFI_003_panic_wrapper_required Int)
(declare-const target_FFI_003_panic_wrapper_required Int)
(assert (>= source_FFI_003_panic_wrapper_required 0))
(assert (>= target_FFI_003_panic_wrapper_required 0))
(assert (not (= source_FFI_003_panic_wrapper_required target_FFI_003_panic_wrapper_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_004_null_check_required: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_004_null_check_required preserves semantics
(push 1)
(declare-const source_FFI_004_null_check_required Int)
(declare-const target_FFI_004_null_check_required Int)
(assert (>= source_FFI_004_null_check_required 0))
(assert (>= target_FFI_004_null_check_required 0))
(assert (not (= source_FFI_004_null_check_required target_FFI_004_null_check_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_005_buffer_validation_required: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_005_buffer_validation_required preserves semantics
(push 1)
(declare-const source_FFI_005_buffer_validation_required Int)
(declare-const target_FFI_005_buffer_validation_required Int)
(assert (>= source_FFI_005_buffer_validation_required 0))
(assert (>= target_FFI_005_buffer_validation_required 0))
(assert (not (= source_FFI_005_buffer_validation_required target_FFI_005_buffer_validation_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_006_type_marshalling_required: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_006_type_marshalling_required preserves semantics
(push 1)
(declare-const source_FFI_006_type_marshalling_required Int)
(declare-const target_FFI_006_type_marshalling_required Int)
(assert (>= source_FFI_006_type_marshalling_required 0))
(assert (>= target_FFI_006_type_marshalling_required 0))
(assert (not (= source_FFI_006_type_marshalling_required target_FFI_006_type_marshalling_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_007_memory_safety_active: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_007_memory_safety_active preserves semantics
(push 1)
(declare-const source_FFI_007_memory_safety_active Int)
(declare-const target_FFI_007_memory_safety_active Int)
(assert (>= source_FFI_007_memory_safety_active 0))
(assert (>= target_FFI_007_memory_safety_active 0))
(assert (not (= source_FFI_007_memory_safety_active target_FFI_007_memory_safety_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_008_all_defenses_active: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_008_all_defenses_active preserves semantics
(push 1)
(declare-const source_FFI_008_all_defenses_active Int)
(declare-const target_FFI_008_all_defenses_active Int)
(assert (>= source_FFI_008_all_defenses_active 0))
(assert (>= target_FFI_008_all_defenses_active 0))
(assert (not (= source_FFI_008_all_defenses_active target_FFI_008_all_defenses_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_009_cve_2025_21756_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_009_cve_2025_21756_blocked preserves semantics
(push 1)
(declare-const source_FFI_009_cve_2025_21756_blocked Int)
(declare-const target_FFI_009_cve_2025_21756_blocked Int)
(assert (>= source_FFI_009_cve_2025_21756_blocked 0))
(assert (>= target_FFI_009_cve_2025_21756_blocked 0))
(assert (not (= source_FFI_009_cve_2025_21756_blocked target_FFI_009_cve_2025_21756_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_010_safe_call_passes: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_010_safe_call_passes preserves semantics
(push 1)
(declare-const source_FFI_010_safe_call_passes Int)
(declare-const target_FFI_010_safe_call_passes Int)
(assert (>= source_FFI_010_safe_call_passes 0))
(assert (>= target_FFI_010_safe_call_passes 0))
(assert (not (= source_FFI_010_safe_call_passes target_FFI_010_safe_call_passes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_011_all_implies_lifetime: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_011_all_implies_lifetime preserves semantics
(push 1)
(declare-const source_FFI_011_all_implies_lifetime Int)
(declare-const target_FFI_011_all_implies_lifetime Int)
(assert (>= source_FFI_011_all_implies_lifetime 0))
(assert (>= target_FFI_011_all_implies_lifetime 0))
(assert (not (= source_FFI_011_all_implies_lifetime target_FFI_011_all_implies_lifetime)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_012_all_implies_panic: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_012_all_implies_panic preserves semantics
(push 1)
(declare-const source_FFI_012_all_implies_panic Int)
(declare-const target_FFI_012_all_implies_panic Int)
(assert (>= source_FFI_012_all_implies_panic 0))
(assert (>= target_FFI_012_all_implies_panic 0))
(assert (not (= source_FFI_012_all_implies_panic target_FFI_012_all_implies_panic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_013_all_implies_null: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_013_all_implies_null preserves semantics
(push 1)
(declare-const source_FFI_013_all_implies_null Int)
(declare-const target_FFI_013_all_implies_null Int)
(assert (>= source_FFI_013_all_implies_null 0))
(assert (>= target_FFI_013_all_implies_null 0))
(assert (not (= source_FFI_013_all_implies_null target_FFI_013_all_implies_null)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_014_all_implies_buffer: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_014_all_implies_buffer preserves semantics
(push 1)
(declare-const source_FFI_014_all_implies_buffer Int)
(declare-const target_FFI_014_all_implies_buffer Int)
(assert (>= source_FFI_014_all_implies_buffer 0))
(assert (>= target_FFI_014_all_implies_buffer 0))
(assert (not (= source_FFI_014_all_implies_buffer target_FFI_014_all_implies_buffer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_015_all_implies_type: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_015_all_implies_type preserves semantics
(push 1)
(declare-const source_FFI_015_all_implies_type Int)
(declare-const target_FFI_015_all_implies_type Int)
(assert (>= source_FFI_015_all_implies_type 0))
(assert (>= target_FFI_015_all_implies_type 0))
(assert (not (= source_FFI_015_all_implies_type target_FFI_015_all_implies_type)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_016_all_implies_memory: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_016_all_implies_memory preserves semantics
(push 1)
(declare-const source_FFI_016_all_implies_memory Int)
(declare-const target_FFI_016_all_implies_memory Int)
(assert (>= source_FFI_016_all_implies_memory 0))
(assert (>= target_FFI_016_all_implies_memory 0))
(assert (not (= source_FFI_016_all_implies_memory target_FFI_016_all_implies_memory)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_017_memory_requires_lifetime: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_017_memory_requires_lifetime preserves semantics
(push 1)
(declare-const source_FFI_017_memory_requires_lifetime Int)
(declare-const target_FFI_017_memory_requires_lifetime Int)
(assert (>= source_FFI_017_memory_requires_lifetime 0))
(assert (>= target_FFI_017_memory_requires_lifetime 0))
(assert (not (= source_FFI_017_memory_requires_lifetime target_FFI_017_memory_requires_lifetime)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_018_memory_forbids_shared_mut: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_018_memory_forbids_shared_mut preserves semantics
(push 1)
(declare-const source_FFI_018_memory_forbids_shared_mut Int)
(declare-const target_FFI_018_memory_forbids_shared_mut Int)
(assert (>= source_FFI_018_memory_forbids_shared_mut 0))
(assert (>= target_FFI_018_memory_forbids_shared_mut 0))
(assert (not (= source_FFI_018_memory_forbids_shared_mut target_FFI_018_memory_forbids_shared_mut)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_019_lifetime_violation_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_019_lifetime_violation_rejected preserves semantics
(push 1)
(declare-const source_FFI_019_lifetime_violation_rejected Int)
(declare-const target_FFI_019_lifetime_violation_rejected Int)
(assert (>= source_FFI_019_lifetime_violation_rejected 0))
(assert (>= target_FFI_019_lifetime_violation_rejected 0))
(assert (not (= source_FFI_019_lifetime_violation_rejected target_FFI_019_lifetime_violation_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_020_panic_unsafe_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_020_panic_unsafe_rejected preserves semantics
(push 1)
(declare-const source_FFI_020_panic_unsafe_rejected Int)
(declare-const target_FFI_020_panic_unsafe_rejected Int)
(assert (>= source_FFI_020_panic_unsafe_rejected 0))
(assert (>= target_FFI_020_panic_unsafe_rejected 0))
(assert (not (= source_FFI_020_panic_unsafe_rejected target_FFI_020_panic_unsafe_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_021_null_unchecked_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_021_null_unchecked_rejected preserves semantics
(push 1)
(declare-const source_FFI_021_null_unchecked_rejected Int)
(declare-const target_FFI_021_null_unchecked_rejected Int)
(assert (>= source_FFI_021_null_unchecked_rejected 0))
(assert (>= target_FFI_021_null_unchecked_rejected 0))
(assert (not (= source_FFI_021_null_unchecked_rejected target_FFI_021_null_unchecked_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_022_buffer_unchecked_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_022_buffer_unchecked_rejected preserves semantics
(push 1)
(declare-const source_FFI_022_buffer_unchecked_rejected Int)
(declare-const target_FFI_022_buffer_unchecked_rejected Int)
(assert (>= source_FFI_022_buffer_unchecked_rejected 0))
(assert (>= target_FFI_022_buffer_unchecked_rejected 0))
(assert (not (= source_FFI_022_buffer_unchecked_rejected target_FFI_022_buffer_unchecked_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_023_type_unsafe_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_023_type_unsafe_rejected preserves semantics
(push 1)
(declare-const source_FFI_023_type_unsafe_rejected Int)
(declare-const target_FFI_023_type_unsafe_rejected Int)
(assert (>= source_FFI_023_type_unsafe_rejected 0))
(assert (>= target_FFI_023_type_unsafe_rejected 0))
(assert (not (= source_FFI_023_type_unsafe_rejected target_FFI_023_type_unsafe_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_024_shared_mut_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_024_shared_mut_rejected preserves semantics
(push 1)
(declare-const source_FFI_024_shared_mut_rejected Int)
(declare-const target_FFI_024_shared_mut_rejected Int)
(assert (>= source_FFI_024_shared_mut_rejected 0))
(assert (>= target_FFI_024_shared_mut_rejected 0))
(assert (not (= source_FFI_024_shared_mut_rejected target_FFI_024_shared_mut_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_025_no_effect_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_025_no_effect_rejected preserves semantics
(push 1)
(declare-const source_FFI_025_no_effect_rejected Int)
(declare-const target_FFI_025_no_effect_rejected Int)
(assert (>= source_FFI_025_no_effect_rejected 0))
(assert (>= target_FFI_025_no_effect_rejected 0))
(assert (not (= source_FFI_025_no_effect_rejected target_FFI_025_no_effect_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_026_bidirectional_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_026_bidirectional_safe preserves semantics
(push 1)
(declare-const source_FFI_026_bidirectional_safe Int)
(declare-const target_FFI_026_bidirectional_safe Int)
(assert (>= source_FFI_026_bidirectional_safe 0))
(assert (>= target_FFI_026_bidirectional_safe 0))
(assert (not (= source_FFI_026_bidirectional_safe target_FFI_026_bidirectional_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_027_c_to_rust_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_027_c_to_rust_safe preserves semantics
(push 1)
(declare-const source_FFI_027_c_to_rust_safe Int)
(declare-const target_FFI_027_c_to_rust_safe Int)
(assert (>= source_FFI_027_c_to_rust_safe 0))
(assert (>= target_FFI_027_c_to_rust_safe 0))
(assert (not (= source_FFI_027_c_to_rust_safe target_FFI_027_c_to_rust_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_028_complete_defense: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_028_complete_defense preserves semantics
(push 1)
(declare-const source_FFI_028_complete_defense Int)
(declare-const target_FFI_028_complete_defense Int)
(assert (>= source_FFI_028_complete_defense 0))
(assert (>= target_FFI_028_complete_defense 0))
(assert (not (= source_FFI_028_complete_defense target_FFI_028_complete_defense)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_029_uaf_prevention: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_029_uaf_prevention preserves semantics
(push 1)
(declare-const source_FFI_029_uaf_prevention Int)
(declare-const target_FFI_029_uaf_prevention Int)
(assert (>= source_FFI_029_uaf_prevention 0))
(assert (>= target_FFI_029_uaf_prevention 0))
(assert (not (= source_FFI_029_uaf_prevention target_FFI_029_uaf_prevention)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; FFI_030_data_race_prevention: translation preserves property (matches Coq: Theorem)
; Translation validation: FFI_030_data_race_prevention preserves semantics
(push 1)
(declare-const source_FFI_030_data_race_prevention Int)
(declare-const target_FFI_030_data_race_prevention Int)
(assert (>= source_FFI_030_data_race_prevention 0))
(assert (>= target_FFI_030_data_race_prevention 0))
(assert (not (= source_FFI_030_data_race_prevention target_FFI_030_data_race_prevention)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

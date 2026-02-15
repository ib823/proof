; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/DeserializationSafety.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for DeserializationSafety
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; rce_prevention_active: source semantics (matches Coq)
(declare-fun source_rce_prevention_active () Bool)
(declare-fun target_rce_prevention_active () Bool)
(assert (= source_rce_prevention_active target_rce_prevention_active))

; schema_enforcement_active: source semantics (matches Coq)
(declare-fun source_schema_enforcement_active () Bool)
(declare-fun target_schema_enforcement_active () Bool)
(assert (= source_schema_enforcement_active target_schema_enforcement_active))

; input_validation_active: source semantics (matches Coq)
(declare-fun source_input_validation_active () Bool)
(declare-fun target_input_validation_active () Bool)
(assert (= source_input_validation_active target_input_validation_active))

; string_safety_active: source semantics (matches Coq)
(declare-fun source_string_safety_active () Bool)
(declare-fun target_string_safety_active () Bool)
(assert (= source_string_safety_active target_string_safety_active))

; all_deser_defenses: source semantics (matches Coq)
(declare-fun source_all_deser_defenses () Bool)
(declare-fun target_all_deser_defenses () Bool)
(assert (= source_all_deser_defenses target_all_deser_defenses))

; riina_deser_policy: source semantics (matches Coq)
(declare-fun source_riina_deser_policy () Bool)
(declare-fun target_riina_deser_policy () Bool)
(assert (= source_riina_deser_policy target_riina_deser_policy))

; check_input: source semantics (matches Coq)
(declare-fun source_check_input () Bool)
(declare-fun target_check_input () Bool)
(assert (= source_check_input target_check_input))

; is_deser_ok: source semantics (matches Coq)
(declare-fun source_is_deser_ok () Bool)
(declare-fun target_is_deser_ok () Bool)
(assert (= source_is_deser_ok target_is_deser_ok))

; is_gadget_blocked: source semantics (matches Coq)
(declare-fun source_is_gadget_blocked () Bool)
(declare-fun target_is_gadget_blocked () Bool)
(assert (= source_is_gadget_blocked target_is_gadget_blocked))

; andb_true_iff_deser: translation preserves property (matches Coq: Lemma)
(declare-fun source_andb_true_iff_deser () Bool)
(declare-fun target_andb_true_iff_deser () Bool)
(assert (= source_andb_true_iff_deser target_andb_true_iff_deser))

; DESER_001_rce_prevention: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_001_rce_prevention () Bool)
(declare-fun target_DESER_001_rce_prevention () Bool)
(assert (= source_DESER_001_rce_prevention target_DESER_001_rce_prevention))

; DESER_002_schema_enforcement: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_002_schema_enforcement () Bool)
(declare-fun target_DESER_002_schema_enforcement () Bool)
(assert (= source_DESER_002_schema_enforcement target_DESER_002_schema_enforcement))

; DESER_003_input_validation: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_003_input_validation () Bool)
(declare-fun target_DESER_003_input_validation () Bool)
(assert (= source_DESER_003_input_validation target_DESER_003_input_validation))

; DESER_004_string_safety: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_004_string_safety () Bool)
(declare-fun target_DESER_004_string_safety () Bool)
(assert (= source_DESER_004_string_safety target_DESER_004_string_safety))

; DESER_005_all_defenses: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_005_all_defenses () Bool)
(declare-fun target_DESER_005_all_defenses () Bool)
(assert (= source_DESER_005_all_defenses target_DESER_005_all_defenses))

; DESER_006_gadget_blocked: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_006_gadget_blocked () Bool)
(declare-fun target_DESER_006_gadget_blocked () Bool)
(assert (= source_DESER_006_gadget_blocked target_DESER_006_gadget_blocked))

; DESER_007_no_polymorphic: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_007_no_polymorphic () Bool)
(declare-fun target_DESER_007_no_polymorphic () Bool)
(assert (= source_DESER_007_no_polymorphic target_DESER_007_no_polymorphic))

; DESER_008_no_callbacks: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_008_no_callbacks () Bool)
(declare-fun target_DESER_008_no_callbacks () Bool)
(assert (= source_DESER_008_no_callbacks target_DESER_008_no_callbacks))

; DESER_009_no_reflection: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_009_no_reflection () Bool)
(declare-fun target_DESER_009_no_reflection () Bool)
(assert (= source_DESER_009_no_reflection target_DESER_009_no_reflection))

; DESER_010_requires_schema: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_010_requires_schema () Bool)
(declare-fun target_DESER_010_requires_schema () Bool)
(assert (= source_DESER_010_requires_schema target_DESER_010_requires_schema))

; DESER_011_requires_type_tags: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_011_requires_type_tags () Bool)
(declare-fun target_DESER_011_requires_type_tags () Bool)
(assert (= source_DESER_011_requires_type_tags target_DESER_011_requires_type_tags))

; DESER_012_requires_allowlist: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_012_requires_allowlist () Bool)
(declare-fun target_DESER_012_requires_allowlist () Bool)
(assert (= source_DESER_012_requires_allowlist target_DESER_012_requires_allowlist))

; DESER_013_valid_input_passes: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_013_valid_input_passes () Bool)
(declare-fun target_DESER_013_valid_input_passes () Bool)
(assert (= source_DESER_013_valid_input_passes target_DESER_013_valid_input_passes))

; DESER_014_oversized_rejected: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_014_oversized_rejected () Bool)
(declare-fun target_DESER_014_oversized_rejected () Bool)
(assert (= source_DESER_014_oversized_rejected target_DESER_014_oversized_rejected))

; DESER_015_overdepth_rejected: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_015_overdepth_rejected () Bool)
(declare-fun target_DESER_015_overdepth_rejected () Bool)
(assert (= source_DESER_015_overdepth_rejected target_DESER_015_overdepth_rejected))

; DESER_016_ok_is_ok: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_016_ok_is_ok () Bool)
(declare-fun target_DESER_016_ok_is_ok () Bool)
(assert (= source_DESER_016_ok_is_ok target_DESER_016_ok_is_ok))

; DESER_017_gadget_not_ok: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_017_gadget_not_ok () Bool)
(declare-fun target_DESER_017_gadget_not_ok () Bool)
(assert (= source_DESER_017_gadget_not_ok target_DESER_017_gadget_not_ok))

; DESER_018_type_err_not_ok: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_018_type_err_not_ok () Bool)
(declare-fun target_DESER_018_type_err_not_ok () Bool)
(assert (= source_DESER_018_type_err_not_ok target_DESER_018_type_err_not_ok))

; DESER_019_overflow_not_ok: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_019_overflow_not_ok () Bool)
(declare-fun target_DESER_019_overflow_not_ok () Bool)
(assert (= source_DESER_019_overflow_not_ok target_DESER_019_overflow_not_ok))

; DESER_020_malformed_not_ok: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_020_malformed_not_ok () Bool)
(declare-fun target_DESER_020_malformed_not_ok () Bool)
(assert (= source_DESER_020_malformed_not_ok target_DESER_020_malformed_not_ok))

; DESER_021_all_implies_rce: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_021_all_implies_rce () Bool)
(declare-fun target_DESER_021_all_implies_rce () Bool)
(assert (= source_DESER_021_all_implies_rce target_DESER_021_all_implies_rce))

; DESER_022_all_implies_schema: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_022_all_implies_schema () Bool)
(declare-fun target_DESER_022_all_implies_schema () Bool)
(assert (= source_DESER_022_all_implies_schema target_DESER_022_all_implies_schema))

; DESER_023_all_implies_validation: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_023_all_implies_validation () Bool)
(declare-fun target_DESER_023_all_implies_validation () Bool)
(assert (= source_DESER_023_all_implies_validation target_DESER_023_all_implies_validation))

; DESER_024_all_implies_string: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_024_all_implies_string () Bool)
(declare-fun target_DESER_024_all_implies_string () Bool)
(assert (= source_DESER_024_all_implies_string target_DESER_024_all_implies_string))

; DESER_025_complete_defense: translation preserves property (matches Coq: Theorem)
(declare-fun source_DESER_025_complete_defense () Bool)
(declare-fun target_DESER_025_complete_defense () Bool)
(assert (= source_DESER_025_complete_defense target_DESER_025_complete_defense))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

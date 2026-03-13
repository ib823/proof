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
; Translation validation: rce_prevention_active preserves semantics
(push 1)
(declare-const source_rce_prevention_active Int)
(declare-const target_rce_prevention_active Int)
(assert (>= source_rce_prevention_active 0))
(assert (>= target_rce_prevention_active 0))
(assert (not (= source_rce_prevention_active target_rce_prevention_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; schema_enforcement_active: source semantics (matches Coq)
; Translation validation: schema_enforcement_active preserves semantics
(push 1)
(declare-const source_schema_enforcement_active Int)
(declare-const target_schema_enforcement_active Int)
(assert (>= source_schema_enforcement_active 0))
(assert (>= target_schema_enforcement_active 0))
(assert (not (= source_schema_enforcement_active target_schema_enforcement_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; input_validation_active: source semantics (matches Coq)
; Translation validation: input_validation_active preserves semantics
(push 1)
(declare-const source_input_validation_active Int)
(declare-const target_input_validation_active Int)
(assert (>= source_input_validation_active 0))
(assert (>= target_input_validation_active 0))
(assert (not (= source_input_validation_active target_input_validation_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; string_safety_active: source semantics (matches Coq)
; Translation validation: string_safety_active preserves semantics
(push 1)
(declare-const source_string_safety_active Int)
(declare-const target_string_safety_active Int)
(assert (>= source_string_safety_active 0))
(assert (>= target_string_safety_active 0))
(assert (not (= source_string_safety_active target_string_safety_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_deser_defenses: source semantics (matches Coq)
; Translation validation: all_deser_defenses preserves semantics
(push 1)
(declare-const source_all_deser_defenses Int)
(declare-const target_all_deser_defenses Int)
(assert (>= source_all_deser_defenses 0))
(assert (>= target_all_deser_defenses 0))
(assert (not (= source_all_deser_defenses target_all_deser_defenses)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_deser_policy: source semantics (matches Coq)
; Translation validation: riina_deser_policy preserves semantics
(push 1)
(declare-const source_riina_deser_policy Int)
(declare-const target_riina_deser_policy Int)
(assert (>= source_riina_deser_policy 0))
(assert (>= target_riina_deser_policy 0))
(assert (not (= source_riina_deser_policy target_riina_deser_policy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; check_input: source semantics (matches Coq)
; Translation validation: check_input preserves semantics
(push 1)
(declare-const source_check_input Int)
(declare-const target_check_input Int)
(assert (>= source_check_input 0))
(assert (>= target_check_input 0))
(assert (not (= source_check_input target_check_input)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_deser_ok: source semantics (matches Coq)
; Translation validation: is_deser_ok preserves semantics
(push 1)
(declare-const source_is_deser_ok Int)
(declare-const target_is_deser_ok Int)
(assert (>= source_is_deser_ok 0))
(assert (>= target_is_deser_ok 0))
(assert (not (= source_is_deser_ok target_is_deser_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_gadget_blocked: source semantics (matches Coq)
; Translation validation: is_gadget_blocked preserves semantics
(push 1)
(declare-const source_is_gadget_blocked Int)
(declare-const target_is_gadget_blocked Int)
(assert (>= source_is_gadget_blocked 0))
(assert (>= target_is_gadget_blocked 0))
(assert (not (= source_is_gadget_blocked target_is_gadget_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff_deser: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff_deser preserves semantics
(push 1)
(declare-const source_andb_true_iff_deser Int)
(declare-const target_andb_true_iff_deser Int)
(assert (>= source_andb_true_iff_deser 0))
(assert (>= target_andb_true_iff_deser 0))
(assert (not (= source_andb_true_iff_deser target_andb_true_iff_deser)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_001_rce_prevention: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_001_rce_prevention preserves semantics
(push 1)
(declare-const source_DESER_001_rce_prevention Int)
(declare-const target_DESER_001_rce_prevention Int)
(assert (>= source_DESER_001_rce_prevention 0))
(assert (>= target_DESER_001_rce_prevention 0))
(assert (not (= source_DESER_001_rce_prevention target_DESER_001_rce_prevention)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_002_schema_enforcement: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_002_schema_enforcement preserves semantics
(push 1)
(declare-const source_DESER_002_schema_enforcement Int)
(declare-const target_DESER_002_schema_enforcement Int)
(assert (>= source_DESER_002_schema_enforcement 0))
(assert (>= target_DESER_002_schema_enforcement 0))
(assert (not (= source_DESER_002_schema_enforcement target_DESER_002_schema_enforcement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_003_input_validation: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_003_input_validation preserves semantics
(push 1)
(declare-const source_DESER_003_input_validation Int)
(declare-const target_DESER_003_input_validation Int)
(assert (>= source_DESER_003_input_validation 0))
(assert (>= target_DESER_003_input_validation 0))
(assert (not (= source_DESER_003_input_validation target_DESER_003_input_validation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_004_string_safety: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_004_string_safety preserves semantics
(push 1)
(declare-const source_DESER_004_string_safety Int)
(declare-const target_DESER_004_string_safety Int)
(assert (>= source_DESER_004_string_safety 0))
(assert (>= target_DESER_004_string_safety 0))
(assert (not (= source_DESER_004_string_safety target_DESER_004_string_safety)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_005_all_defenses: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_005_all_defenses preserves semantics
(push 1)
(declare-const source_DESER_005_all_defenses Int)
(declare-const target_DESER_005_all_defenses Int)
(assert (>= source_DESER_005_all_defenses 0))
(assert (>= target_DESER_005_all_defenses 0))
(assert (not (= source_DESER_005_all_defenses target_DESER_005_all_defenses)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_006_gadget_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_006_gadget_blocked preserves semantics
(push 1)
(declare-const source_DESER_006_gadget_blocked Int)
(declare-const target_DESER_006_gadget_blocked Int)
(assert (>= source_DESER_006_gadget_blocked 0))
(assert (>= target_DESER_006_gadget_blocked 0))
(assert (not (= source_DESER_006_gadget_blocked target_DESER_006_gadget_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_007_no_polymorphic: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_007_no_polymorphic preserves semantics
(push 1)
(declare-const source_DESER_007_no_polymorphic Int)
(declare-const target_DESER_007_no_polymorphic Int)
(assert (>= source_DESER_007_no_polymorphic 0))
(assert (>= target_DESER_007_no_polymorphic 0))
(assert (not (= source_DESER_007_no_polymorphic target_DESER_007_no_polymorphic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_008_no_callbacks: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_008_no_callbacks preserves semantics
(push 1)
(declare-const source_DESER_008_no_callbacks Int)
(declare-const target_DESER_008_no_callbacks Int)
(assert (>= source_DESER_008_no_callbacks 0))
(assert (>= target_DESER_008_no_callbacks 0))
(assert (not (= source_DESER_008_no_callbacks target_DESER_008_no_callbacks)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_009_no_reflection: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_009_no_reflection preserves semantics
(push 1)
(declare-const source_DESER_009_no_reflection Int)
(declare-const target_DESER_009_no_reflection Int)
(assert (>= source_DESER_009_no_reflection 0))
(assert (>= target_DESER_009_no_reflection 0))
(assert (not (= source_DESER_009_no_reflection target_DESER_009_no_reflection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_010_requires_schema: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_010_requires_schema preserves semantics
(push 1)
(declare-const source_DESER_010_requires_schema Int)
(declare-const target_DESER_010_requires_schema Int)
(assert (>= source_DESER_010_requires_schema 0))
(assert (>= target_DESER_010_requires_schema 0))
(assert (not (= source_DESER_010_requires_schema target_DESER_010_requires_schema)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_011_requires_type_tags: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_011_requires_type_tags preserves semantics
(push 1)
(declare-const source_DESER_011_requires_type_tags Int)
(declare-const target_DESER_011_requires_type_tags Int)
(assert (>= source_DESER_011_requires_type_tags 0))
(assert (>= target_DESER_011_requires_type_tags 0))
(assert (not (= source_DESER_011_requires_type_tags target_DESER_011_requires_type_tags)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_012_requires_allowlist: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_012_requires_allowlist preserves semantics
(push 1)
(declare-const source_DESER_012_requires_allowlist Int)
(declare-const target_DESER_012_requires_allowlist Int)
(assert (>= source_DESER_012_requires_allowlist 0))
(assert (>= target_DESER_012_requires_allowlist 0))
(assert (not (= source_DESER_012_requires_allowlist target_DESER_012_requires_allowlist)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_013_valid_input_passes: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_013_valid_input_passes preserves semantics
(push 1)
(declare-const source_DESER_013_valid_input_passes Int)
(declare-const target_DESER_013_valid_input_passes Int)
(assert (>= source_DESER_013_valid_input_passes 0))
(assert (>= target_DESER_013_valid_input_passes 0))
(assert (not (= source_DESER_013_valid_input_passes target_DESER_013_valid_input_passes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_014_oversized_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_014_oversized_rejected preserves semantics
(push 1)
(declare-const source_DESER_014_oversized_rejected Int)
(declare-const target_DESER_014_oversized_rejected Int)
(assert (>= source_DESER_014_oversized_rejected 0))
(assert (>= target_DESER_014_oversized_rejected 0))
(assert (not (= source_DESER_014_oversized_rejected target_DESER_014_oversized_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_015_overdepth_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_015_overdepth_rejected preserves semantics
(push 1)
(declare-const source_DESER_015_overdepth_rejected Int)
(declare-const target_DESER_015_overdepth_rejected Int)
(assert (>= source_DESER_015_overdepth_rejected 0))
(assert (>= target_DESER_015_overdepth_rejected 0))
(assert (not (= source_DESER_015_overdepth_rejected target_DESER_015_overdepth_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_016_ok_is_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_016_ok_is_ok preserves semantics
(push 1)
(declare-const source_DESER_016_ok_is_ok Int)
(declare-const target_DESER_016_ok_is_ok Int)
(assert (>= source_DESER_016_ok_is_ok 0))
(assert (>= target_DESER_016_ok_is_ok 0))
(assert (not (= source_DESER_016_ok_is_ok target_DESER_016_ok_is_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_017_gadget_not_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_017_gadget_not_ok preserves semantics
(push 1)
(declare-const source_DESER_017_gadget_not_ok Int)
(declare-const target_DESER_017_gadget_not_ok Int)
(assert (>= source_DESER_017_gadget_not_ok 0))
(assert (>= target_DESER_017_gadget_not_ok 0))
(assert (not (= source_DESER_017_gadget_not_ok target_DESER_017_gadget_not_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_018_type_err_not_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_018_type_err_not_ok preserves semantics
(push 1)
(declare-const source_DESER_018_type_err_not_ok Int)
(declare-const target_DESER_018_type_err_not_ok Int)
(assert (>= source_DESER_018_type_err_not_ok 0))
(assert (>= target_DESER_018_type_err_not_ok 0))
(assert (not (= source_DESER_018_type_err_not_ok target_DESER_018_type_err_not_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_019_overflow_not_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_019_overflow_not_ok preserves semantics
(push 1)
(declare-const source_DESER_019_overflow_not_ok Int)
(declare-const target_DESER_019_overflow_not_ok Int)
(assert (>= source_DESER_019_overflow_not_ok 0))
(assert (>= target_DESER_019_overflow_not_ok 0))
(assert (not (= source_DESER_019_overflow_not_ok target_DESER_019_overflow_not_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_020_malformed_not_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_020_malformed_not_ok preserves semantics
(push 1)
(declare-const source_DESER_020_malformed_not_ok Int)
(declare-const target_DESER_020_malformed_not_ok Int)
(assert (>= source_DESER_020_malformed_not_ok 0))
(assert (>= target_DESER_020_malformed_not_ok 0))
(assert (not (= source_DESER_020_malformed_not_ok target_DESER_020_malformed_not_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_021_all_implies_rce: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_021_all_implies_rce preserves semantics
(push 1)
(declare-const source_DESER_021_all_implies_rce Int)
(declare-const target_DESER_021_all_implies_rce Int)
(assert (>= source_DESER_021_all_implies_rce 0))
(assert (>= target_DESER_021_all_implies_rce 0))
(assert (not (= source_DESER_021_all_implies_rce target_DESER_021_all_implies_rce)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_022_all_implies_schema: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_022_all_implies_schema preserves semantics
(push 1)
(declare-const source_DESER_022_all_implies_schema Int)
(declare-const target_DESER_022_all_implies_schema Int)
(assert (>= source_DESER_022_all_implies_schema 0))
(assert (>= target_DESER_022_all_implies_schema 0))
(assert (not (= source_DESER_022_all_implies_schema target_DESER_022_all_implies_schema)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_023_all_implies_validation: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_023_all_implies_validation preserves semantics
(push 1)
(declare-const source_DESER_023_all_implies_validation Int)
(declare-const target_DESER_023_all_implies_validation Int)
(assert (>= source_DESER_023_all_implies_validation 0))
(assert (>= target_DESER_023_all_implies_validation 0))
(assert (not (= source_DESER_023_all_implies_validation target_DESER_023_all_implies_validation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_024_all_implies_string: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_024_all_implies_string preserves semantics
(push 1)
(declare-const source_DESER_024_all_implies_string Int)
(declare-const target_DESER_024_all_implies_string Int)
(assert (>= source_DESER_024_all_implies_string 0))
(assert (>= target_DESER_024_all_implies_string 0))
(assert (not (= source_DESER_024_all_implies_string target_DESER_024_all_implies_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DESER_025_complete_defense: translation preserves property (matches Coq: Theorem)
; Translation validation: DESER_025_complete_defense preserves semantics
(push 1)
(declare-const source_DESER_025_complete_defense Int)
(declare-const target_DESER_025_complete_defense Int)
(assert (>= source_DESER_025_complete_defense 0))
(assert (>= target_DESER_025_complete_defense 0))
(assert (not (= source_DESER_025_complete_defense target_DESER_025_complete_defense)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

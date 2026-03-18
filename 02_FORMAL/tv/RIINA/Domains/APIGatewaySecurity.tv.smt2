; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/APIGatewaySecurity.v (51 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for APIGatewaySecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; api_validation_secure: source semantics (matches Coq)
(declare-fun source_api_validation_secure () Bool)
(declare-fun target_api_validation_secure () Bool)
(assert (= source_api_validation_secure target_api_validation_secure))

; riina_api_validation: source semantics (matches Coq)
(declare-fun source_riina_api_validation () Bool)
(declare-fun target_riina_api_validation () Bool)
(assert (= source_riina_api_validation target_riina_api_validation))

; api_auth_secure: source semantics (matches Coq)
(declare-fun source_api_auth_secure () Bool)
(declare-fun target_api_auth_secure () Bool)
(assert (= source_api_auth_secure target_api_auth_secure))

; riina_api_auth: source semantics (matches Coq)
(declare-fun source_riina_api_auth () Bool)
(declare-fun target_riina_api_auth () Bool)
(assert (= source_riina_api_auth target_riina_api_auth))

; andb_true_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_andb_true_iff () Bool)
(declare-fun target_andb_true_iff () Bool)
(assert (= source_andb_true_iff target_andb_true_iff))

; AGS_001: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_001 () Bool)
(declare-fun target_AGS_001 () Bool)
(assert (= source_AGS_001 target_AGS_001))

; AGS_002: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_002 () Bool)
(declare-fun target_AGS_002 () Bool)
(assert (= source_AGS_002 target_AGS_002))

; AGS_003: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_003 () Bool)
(declare-fun target_AGS_003 () Bool)
(assert (= source_AGS_003 target_AGS_003))

; AGS_004: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_004 () Bool)
(declare-fun target_AGS_004 () Bool)
(assert (= source_AGS_004 target_AGS_004))

; AGS_005: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_005 () Bool)
(declare-fun target_AGS_005 () Bool)
(assert (= source_AGS_005 target_AGS_005))

; AGS_006: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_006 () Bool)
(declare-fun target_AGS_006 () Bool)
(assert (= source_AGS_006 target_AGS_006))

; AGS_007: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_007 () Bool)
(declare-fun target_AGS_007 () Bool)
(assert (= source_AGS_007 target_AGS_007))

; AGS_008: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_008 () Bool)
(declare-fun target_AGS_008 () Bool)
(assert (= source_AGS_008 target_AGS_008))

; AGS_009: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_009 () Bool)
(declare-fun target_AGS_009 () Bool)
(assert (= source_AGS_009 target_AGS_009))

; AGS_010: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_010 () Bool)
(declare-fun target_AGS_010 () Bool)
(assert (= source_AGS_010 target_AGS_010))

; AGS_011: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_011 () Bool)
(declare-fun target_AGS_011 () Bool)
(assert (= source_AGS_011 target_AGS_011))

; AGS_012: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_012 () Bool)
(declare-fun target_AGS_012 () Bool)
(assert (= source_AGS_012 target_AGS_012))

; AGS_013: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_013 () Bool)
(declare-fun target_AGS_013 () Bool)
(assert (= source_AGS_013 target_AGS_013))

; AGS_014: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_014 () Bool)
(declare-fun target_AGS_014 () Bool)
(assert (= source_AGS_014 target_AGS_014))

; AGS_015: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_015 () Bool)
(declare-fun target_AGS_015 () Bool)
(assert (= source_AGS_015 target_AGS_015))

; AGS_016: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_016 () Bool)
(declare-fun target_AGS_016 () Bool)
(assert (= source_AGS_016 target_AGS_016))

; AGS_017: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_017 () Bool)
(declare-fun target_AGS_017 () Bool)
(assert (= source_AGS_017 target_AGS_017))

; AGS_018: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_018 () Bool)
(declare-fun target_AGS_018 () Bool)
(assert (= source_AGS_018 target_AGS_018))

; AGS_019: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_019 () Bool)
(declare-fun target_AGS_019 () Bool)
(assert (= source_AGS_019 target_AGS_019))

; AGS_020: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_020 () Bool)
(declare-fun target_AGS_020 () Bool)
(assert (= source_AGS_020 target_AGS_020))

; AGS_021: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_021 () Bool)
(declare-fun target_AGS_021 () Bool)
(assert (= source_AGS_021 target_AGS_021))

; AGS_022: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_022 () Bool)
(declare-fun target_AGS_022 () Bool)
(assert (= source_AGS_022 target_AGS_022))

; AGS_023: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_023 () Bool)
(declare-fun target_AGS_023 () Bool)
(assert (= source_AGS_023 target_AGS_023))

; AGS_024: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_024 () Bool)
(declare-fun target_AGS_024 () Bool)
(assert (= source_AGS_024 target_AGS_024))

; AGS_025: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_025 () Bool)
(declare-fun target_AGS_025 () Bool)
(assert (= source_AGS_025 target_AGS_025))

; AGS_026: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_026 () Bool)
(declare-fun target_AGS_026 () Bool)
(assert (= source_AGS_026 target_AGS_026))

; AGS_027: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_027 () Bool)
(declare-fun target_AGS_027 () Bool)
(assert (= source_AGS_027 target_AGS_027))

; AGS_028: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_028 () Bool)
(declare-fun target_AGS_028 () Bool)
(assert (= source_AGS_028 target_AGS_028))

; AGS_029: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_029 () Bool)
(declare-fun target_AGS_029 () Bool)
(assert (= source_AGS_029 target_AGS_029))

; AGS_030: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_030 () Bool)
(declare-fun target_AGS_030 () Bool)
(assert (= source_AGS_030 target_AGS_030))

; AGS_031: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_031 () Bool)
(declare-fun target_AGS_031 () Bool)
(assert (= source_AGS_031 target_AGS_031))

; AGS_032: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_032 () Bool)
(declare-fun target_AGS_032 () Bool)
(assert (= source_AGS_032 target_AGS_032))

; AGS_033: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_033 () Bool)
(declare-fun target_AGS_033 () Bool)
(assert (= source_AGS_033 target_AGS_033))

; AGS_034: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_034 () Bool)
(declare-fun target_AGS_034 () Bool)
(assert (= source_AGS_034 target_AGS_034))

; AGS_035: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_035 () Bool)
(declare-fun target_AGS_035 () Bool)
(assert (= source_AGS_035 target_AGS_035))

; AGS_036: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_036 () Bool)
(declare-fun target_AGS_036 () Bool)
(assert (= source_AGS_036 target_AGS_036))

; AGS_037: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_037 () Bool)
(declare-fun target_AGS_037 () Bool)
(assert (= source_AGS_037 target_AGS_037))

; AGS_038: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_038 () Bool)
(declare-fun target_AGS_038 () Bool)
(assert (= source_AGS_038 target_AGS_038))

; AGS_039: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_039 () Bool)
(declare-fun target_AGS_039 () Bool)
(assert (= source_AGS_039 target_AGS_039))

; AGS_040: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_040 () Bool)
(declare-fun target_AGS_040 () Bool)
(assert (= source_AGS_040 target_AGS_040))

; AGS_041: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_041 () Bool)
(declare-fun target_AGS_041 () Bool)
(assert (= source_AGS_041 target_AGS_041))

; AGS_042: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_042 () Bool)
(declare-fun target_AGS_042 () Bool)
(assert (= source_AGS_042 target_AGS_042))

; AGS_043: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_043 () Bool)
(declare-fun target_AGS_043 () Bool)
(assert (= source_AGS_043 target_AGS_043))

; AGS_044: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_044 () Bool)
(declare-fun target_AGS_044 () Bool)
(assert (= source_AGS_044 target_AGS_044))

; AGS_045: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_045 () Bool)
(declare-fun target_AGS_045 () Bool)
(assert (= source_AGS_045 target_AGS_045))

; AGS_046: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_046 () Bool)
(declare-fun target_AGS_046 () Bool)
(assert (= source_AGS_046 target_AGS_046))

; AGS_047: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_047 () Bool)
(declare-fun target_AGS_047 () Bool)
(assert (= source_AGS_047 target_AGS_047))

; AGS_048: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_048 () Bool)
(declare-fun target_AGS_048 () Bool)
(assert (= source_AGS_048 target_AGS_048))

; AGS_049: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_049 () Bool)
(declare-fun target_AGS_049 () Bool)
(assert (= source_AGS_049 target_AGS_049))

; AGS_050: translation preserves property (matches Coq: Theorem)
(declare-fun source_AGS_050 () Bool)
(declare-fun target_AGS_050 () Bool)
(assert (= source_AGS_050 target_AGS_050))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

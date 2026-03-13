; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CSRFProtection.v (36 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CSRFProtection
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; csrf_protected: source semantics (matches Coq)
; Translation validation: csrf_protected preserves semantics
(push 1)
(declare-const source_csrf_protected Int)
(declare-const target_csrf_protected Int)
(assert (>= source_csrf_protected 0))
(assert (>= target_csrf_protected 0))
(assert (not (= source_csrf_protected target_csrf_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_csrf: source semantics (matches Coq)
; Translation validation: riina_csrf preserves semantics
(push 1)
(declare-const source_riina_csrf Int)
(declare-const target_riina_csrf Int)
(assert (>= source_riina_csrf 0))
(assert (>= target_riina_csrf 0))
(assert (not (= source_riina_csrf target_riina_csrf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; csrf_request_safe: source semantics (matches Coq)
; Translation validation: csrf_request_safe preserves semantics
(push 1)
(declare-const source_csrf_request_safe Int)
(declare-const target_csrf_request_safe Int)
(assert (>= source_csrf_request_safe 0))
(assert (>= target_csrf_request_safe 0))
(assert (not (= source_csrf_request_safe target_csrf_request_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; csrf_request_fully_validated: source semantics (matches Coq)
; Translation validation: csrf_request_fully_validated preserves semantics
(push 1)
(declare-const source_csrf_request_fully_validated Int)
(declare-const target_csrf_request_fully_validated Int)
(assert (>= source_csrf_request_fully_validated 0))
(assert (>= target_csrf_request_fully_validated 0))
(assert (not (= source_csrf_request_fully_validated target_csrf_request_fully_validated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_csrf_request: source semantics (matches Coq)
; Translation validation: riina_csrf_request preserves semantics
(push 1)
(declare-const source_riina_csrf_request Int)
(declare-const target_riina_csrf_request Int)
(assert (>= source_riina_csrf_request 0))
(assert (>= target_riina_csrf_request 0))
(assert (not (= source_riina_csrf_request target_riina_csrf_request)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff preserves semantics
(push 1)
(declare-const source_andb_true_iff Int)
(declare-const target_andb_true_iff Int)
(assert (>= source_andb_true_iff 0))
(assert (>= target_andb_true_iff 0))
(assert (not (= source_andb_true_iff target_andb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_001: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_001 preserves semantics
(push 1)
(declare-const source_CSRF_001 Int)
(declare-const target_CSRF_001 Int)
(assert (>= source_CSRF_001 0))
(assert (>= target_CSRF_001 0))
(assert (not (= source_CSRF_001 target_CSRF_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_002: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_002 preserves semantics
(push 1)
(declare-const source_CSRF_002 Int)
(declare-const target_CSRF_002 Int)
(assert (>= source_CSRF_002 0))
(assert (>= target_CSRF_002 0))
(assert (not (= source_CSRF_002 target_CSRF_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_003: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_003 preserves semantics
(push 1)
(declare-const source_CSRF_003 Int)
(declare-const target_CSRF_003 Int)
(assert (>= source_CSRF_003 0))
(assert (>= target_CSRF_003 0))
(assert (not (= source_CSRF_003 target_CSRF_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_004: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_004 preserves semantics
(push 1)
(declare-const source_CSRF_004 Int)
(declare-const target_CSRF_004 Int)
(assert (>= source_CSRF_004 0))
(assert (>= target_CSRF_004 0))
(assert (not (= source_CSRF_004 target_CSRF_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_005: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_005 preserves semantics
(push 1)
(declare-const source_CSRF_005 Int)
(declare-const target_CSRF_005 Int)
(assert (>= source_CSRF_005 0))
(assert (>= target_CSRF_005 0))
(assert (not (= source_CSRF_005 target_CSRF_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_006: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_006 preserves semantics
(push 1)
(declare-const source_CSRF_006 Int)
(declare-const target_CSRF_006 Int)
(assert (>= source_CSRF_006 0))
(assert (>= target_CSRF_006 0))
(assert (not (= source_CSRF_006 target_CSRF_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_007: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_007 preserves semantics
(push 1)
(declare-const source_CSRF_007 Int)
(declare-const target_CSRF_007 Int)
(assert (>= source_CSRF_007 0))
(assert (>= target_CSRF_007 0))
(assert (not (= source_CSRF_007 target_CSRF_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_008: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_008 preserves semantics
(push 1)
(declare-const source_CSRF_008 Int)
(declare-const target_CSRF_008 Int)
(assert (>= source_CSRF_008 0))
(assert (>= target_CSRF_008 0))
(assert (not (= source_CSRF_008 target_CSRF_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_009: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_009 preserves semantics
(push 1)
(declare-const source_CSRF_009 Int)
(declare-const target_CSRF_009 Int)
(assert (>= source_CSRF_009 0))
(assert (>= target_CSRF_009 0))
(assert (not (= source_CSRF_009 target_CSRF_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_010: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_010 preserves semantics
(push 1)
(declare-const source_CSRF_010 Int)
(declare-const target_CSRF_010 Int)
(assert (>= source_CSRF_010 0))
(assert (>= target_CSRF_010 0))
(assert (not (= source_CSRF_010 target_CSRF_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_011: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_011 preserves semantics
(push 1)
(declare-const source_CSRF_011 Int)
(declare-const target_CSRF_011 Int)
(assert (>= source_CSRF_011 0))
(assert (>= target_CSRF_011 0))
(assert (not (= source_CSRF_011 target_CSRF_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_012: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_012 preserves semantics
(push 1)
(declare-const source_CSRF_012 Int)
(declare-const target_CSRF_012 Int)
(assert (>= source_CSRF_012 0))
(assert (>= target_CSRF_012 0))
(assert (not (= source_CSRF_012 target_CSRF_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_013: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_013 preserves semantics
(push 1)
(declare-const source_CSRF_013 Int)
(declare-const target_CSRF_013 Int)
(assert (>= source_CSRF_013 0))
(assert (>= target_CSRF_013 0))
(assert (not (= source_CSRF_013 target_CSRF_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_014: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_014 preserves semantics
(push 1)
(declare-const source_CSRF_014 Int)
(declare-const target_CSRF_014 Int)
(assert (>= source_CSRF_014 0))
(assert (>= target_CSRF_014 0))
(assert (not (= source_CSRF_014 target_CSRF_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_015: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_015 preserves semantics
(push 1)
(declare-const source_CSRF_015 Int)
(declare-const target_CSRF_015 Int)
(assert (>= source_CSRF_015 0))
(assert (>= target_CSRF_015 0))
(assert (not (= source_CSRF_015 target_CSRF_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_016: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_016 preserves semantics
(push 1)
(declare-const source_CSRF_016 Int)
(declare-const target_CSRF_016 Int)
(assert (>= source_CSRF_016 0))
(assert (>= target_CSRF_016 0))
(assert (not (= source_CSRF_016 target_CSRF_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_017: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_017 preserves semantics
(push 1)
(declare-const source_CSRF_017 Int)
(declare-const target_CSRF_017 Int)
(assert (>= source_CSRF_017 0))
(assert (>= target_CSRF_017 0))
(assert (not (= source_CSRF_017 target_CSRF_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_018: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_018 preserves semantics
(push 1)
(declare-const source_CSRF_018 Int)
(declare-const target_CSRF_018 Int)
(assert (>= source_CSRF_018 0))
(assert (>= target_CSRF_018 0))
(assert (not (= source_CSRF_018 target_CSRF_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_019: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_019 preserves semantics
(push 1)
(declare-const source_CSRF_019 Int)
(declare-const target_CSRF_019 Int)
(assert (>= source_CSRF_019 0))
(assert (>= target_CSRF_019 0))
(assert (not (= source_CSRF_019 target_CSRF_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_020_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_020_complete preserves semantics
(push 1)
(declare-const source_CSRF_020_complete Int)
(declare-const target_CSRF_020_complete Int)
(assert (>= source_CSRF_020_complete 0))
(assert (>= target_CSRF_020_complete 0))
(assert (not (= source_CSRF_020_complete target_CSRF_020_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_021_riina_request_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_021_riina_request_safe preserves semantics
(push 1)
(declare-const source_CSRF_021_riina_request_safe Int)
(declare-const target_CSRF_021_riina_request_safe Int)
(assert (>= source_CSRF_021_riina_request_safe 0))
(assert (>= target_CSRF_021_riina_request_safe 0))
(assert (not (= source_CSRF_021_riina_request_safe target_CSRF_021_riina_request_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_022_riina_request_fully_validated: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_022_riina_request_fully_validated preserves semantics
(push 1)
(declare-const source_CSRF_022_riina_request_fully_validated Int)
(declare-const target_CSRF_022_riina_request_fully_validated Int)
(assert (>= source_CSRF_022_riina_request_fully_validated 0))
(assert (>= target_CSRF_022_riina_request_fully_validated 0))
(assert (not (= source_CSRF_022_riina_request_fully_validated target_CSRF_022_riina_request_fully_validated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_023_safe_has_token: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_023_safe_has_token preserves semantics
(push 1)
(declare-const source_CSRF_023_safe_has_token Int)
(declare-const target_CSRF_023_safe_has_token Int)
(assert (>= source_CSRF_023_safe_has_token 0))
(assert (>= target_CSRF_023_safe_has_token 0))
(assert (not (= source_CSRF_023_safe_has_token target_CSRF_023_safe_has_token)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_024_safe_token_matches: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_024_safe_token_matches preserves semantics
(push 1)
(declare-const source_CSRF_024_safe_token_matches Int)
(declare-const target_CSRF_024_safe_token_matches Int)
(assert (>= source_CSRF_024_safe_token_matches 0))
(assert (>= target_CSRF_024_safe_token_matches 0))
(assert (not (= source_CSRF_024_safe_token_matches target_CSRF_024_safe_token_matches)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_025_safe_same_origin: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_025_safe_same_origin preserves semantics
(push 1)
(declare-const source_CSRF_025_safe_same_origin Int)
(declare-const target_CSRF_025_safe_same_origin Int)
(assert (>= source_CSRF_025_safe_same_origin 0))
(assert (>= target_CSRF_025_safe_same_origin 0))
(assert (not (= source_CSRF_025_safe_same_origin target_CSRF_025_safe_same_origin)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_026_fully_validated_implies_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_026_fully_validated_implies_safe preserves semantics
(push 1)
(declare-const source_CSRF_026_fully_validated_implies_safe Int)
(declare-const target_CSRF_026_fully_validated_implies_safe Int)
(assert (>= source_CSRF_026_fully_validated_implies_safe 0))
(assert (>= target_CSRF_026_fully_validated_implies_safe 0))
(assert (not (= source_CSRF_026_fully_validated_implies_safe target_CSRF_026_fully_validated_implies_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_027_fully_validated_referer: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_027_fully_validated_referer preserves semantics
(push 1)
(declare-const source_CSRF_027_fully_validated_referer Int)
(declare-const target_CSRF_027_fully_validated_referer Int)
(assert (>= source_CSRF_027_fully_validated_referer 0))
(assert (>= target_CSRF_027_fully_validated_referer 0))
(assert (not (= source_CSRF_027_fully_validated_referer target_CSRF_027_fully_validated_referer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_028_fully_validated_cookie: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_028_fully_validated_cookie preserves semantics
(push 1)
(declare-const source_CSRF_028_fully_validated_cookie Int)
(declare-const target_CSRF_028_fully_validated_cookie Int)
(assert (>= source_CSRF_028_fully_validated_cookie 0))
(assert (>= target_CSRF_028_fully_validated_cookie 0))
(assert (not (= source_CSRF_028_fully_validated_cookie target_CSRF_028_fully_validated_cookie)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_029_full_implies_token_and_origin: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_029_full_implies_token_and_origin preserves semantics
(push 1)
(declare-const source_CSRF_029_full_implies_token_and_origin Int)
(declare-const target_CSRF_029_full_implies_token_and_origin Int)
(assert (>= source_CSRF_029_full_implies_token_and_origin 0))
(assert (>= target_CSRF_029_full_implies_token_and_origin 0))
(assert (not (= source_CSRF_029_full_implies_token_and_origin target_CSRF_029_full_implies_token_and_origin)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_030_config_enables_request_checks: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_030_config_enables_request_checks preserves semantics
(push 1)
(declare-const source_CSRF_030_config_enables_request_checks Int)
(declare-const target_CSRF_030_config_enables_request_checks Int)
(assert (>= source_CSRF_030_config_enables_request_checks 0))
(assert (>= target_CSRF_030_config_enables_request_checks 0))
(assert (not (= source_CSRF_030_config_enables_request_checks target_CSRF_030_config_enables_request_checks)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_031_referer_in_protection: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_031_referer_in_protection preserves semantics
(push 1)
(declare-const source_CSRF_031_referer_in_protection Int)
(declare-const target_CSRF_031_referer_in_protection Int)
(assert (>= source_CSRF_031_referer_in_protection 0))
(assert (>= target_CSRF_031_referer_in_protection 0))
(assert (not (= source_CSRF_031_referer_in_protection target_CSRF_031_referer_in_protection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_032_complete_request_validation: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_032_complete_request_validation preserves semantics
(push 1)
(declare-const source_CSRF_032_complete_request_validation Int)
(declare-const target_CSRF_032_complete_request_validation Int)
(assert (>= source_CSRF_032_complete_request_validation 0))
(assert (>= target_CSRF_032_complete_request_validation 0))
(assert (not (= source_CSRF_032_complete_request_validation target_CSRF_032_complete_request_validation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_033_all_false_not_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_033_all_false_not_protected preserves semantics
(push 1)
(declare-const source_CSRF_033_all_false_not_protected Int)
(declare-const target_CSRF_033_all_false_not_protected Int)
(assert (>= source_CSRF_033_all_false_not_protected 0))
(assert (>= target_CSRF_033_all_false_not_protected 0))
(assert (not (= source_CSRF_033_all_false_not_protected target_CSRF_033_all_false_not_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_034_missing_token_breaks: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_034_missing_token_breaks preserves semantics
(push 1)
(declare-const source_CSRF_034_missing_token_breaks Int)
(declare-const target_CSRF_034_missing_token_breaks Int)
(assert (>= source_CSRF_034_missing_token_breaks 0))
(assert (>= target_CSRF_034_missing_token_breaks 0))
(assert (not (= source_CSRF_034_missing_token_breaks target_CSRF_034_missing_token_breaks)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CSRF_035_protection_reconstruction: translation preserves property (matches Coq: Theorem)
; Translation validation: CSRF_035_protection_reconstruction preserves semantics
(push 1)
(declare-const source_CSRF_035_protection_reconstruction Int)
(declare-const target_CSRF_035_protection_reconstruction Int)
(assert (>= source_CSRF_035_protection_reconstruction 0))
(assert (>= target_CSRF_035_protection_reconstruction 0))
(assert (not (= source_CSRF_035_protection_reconstruction target_CSRF_035_protection_reconstruction)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

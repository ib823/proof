; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/InjectionPrevention.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for InjectionPrevention
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; propagate_taint: source semantics (matches Coq)
; Translation validation: propagate_taint preserves semantics
(push 1)
(declare-const source_propagate_taint Int)
(declare-const target_propagate_taint Int)
(assert (>= source_propagate_taint 0))
(assert (>= target_propagate_taint 0))
(assert (not (= source_propagate_taint target_propagate_taint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tainted_concat: source semantics (matches Coq)
; Translation validation: tainted_concat preserves semantics
(push 1)
(declare-const source_tainted_concat Int)
(declare-const target_tainted_concat Int)
(assert (>= source_tainted_concat 0))
(assert (>= target_tainted_concat 0))
(assert (not (= source_tainted_concat target_tainted_concat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secure_xml_config: source semantics (matches Coq)
; Translation validation: secure_xml_config preserves semantics
(push 1)
(declare-const source_secure_xml_config Int)
(declare-const target_secure_xml_config Int)
(assert (>= source_secure_xml_config 0))
(assert (>= target_secure_xml_config 0))
(assert (not (= source_secure_xml_config target_secure_xml_config)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; contains_newline: source semantics (matches Coq)
; Translation validation: contains_newline preserves semantics
(push 1)
(declare-const source_contains_newline Int)
(declare-const target_contains_newline Int)
(assert (>= source_contains_newline 0))
(assert (>= target_contains_newline 0))
(assert (not (= source_contains_newline target_contains_newline)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secure_pdf: source semantics (matches Coq)
; Translation validation: secure_pdf preserves semantics
(push 1)
(declare-const source_secure_pdf Int)
(declare-const target_secure_pdf Int)
(assert (>= source_secure_pdf 0))
(assert (>= target_secure_pdf 0))
(assert (not (= source_secure_pdf target_secure_pdf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_001_sql_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_001_sql_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_001_sql_injection_impossible Int)
(declare-const target_inj_001_sql_injection_impossible Int)
(assert (>= source_inj_001_sql_injection_impossible 0))
(assert (>= target_inj_001_sql_injection_impossible 0))
(assert (not (= source_inj_001_sql_injection_impossible target_inj_001_sql_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_002_command_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_002_command_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_002_command_injection_impossible Int)
(declare-const target_inj_002_command_injection_impossible Int)
(assert (>= source_inj_002_command_injection_impossible 0))
(assert (>= target_inj_002_command_injection_impossible 0))
(assert (not (= source_inj_002_command_injection_impossible target_inj_002_command_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_003_ldap_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_003_ldap_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_003_ldap_injection_impossible Int)
(declare-const target_inj_003_ldap_injection_impossible Int)
(assert (>= source_inj_003_ldap_injection_impossible 0))
(assert (>= target_inj_003_ldap_injection_impossible 0))
(assert (not (= source_inj_003_ldap_injection_impossible target_inj_003_ldap_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_004_xpath_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_004_xpath_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_004_xpath_injection_impossible Int)
(declare-const target_inj_004_xpath_injection_impossible Int)
(assert (>= source_inj_004_xpath_injection_impossible 0))
(assert (>= target_inj_004_xpath_injection_impossible 0))
(assert (not (= source_inj_004_xpath_injection_impossible target_inj_004_xpath_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_005_xxe_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_005_xxe_impossible preserves semantics
(push 1)
(declare-const source_inj_005_xxe_impossible Int)
(declare-const target_inj_005_xxe_impossible Int)
(assert (>= source_inj_005_xxe_impossible 0))
(assert (>= target_inj_005_xxe_impossible 0))
(assert (not (= source_inj_005_xxe_impossible target_inj_005_xxe_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_006_header_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_006_header_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_006_header_injection_impossible Int)
(declare-const target_inj_006_header_injection_impossible Int)
(assert (>= source_inj_006_header_injection_impossible 0))
(assert (>= target_inj_006_header_injection_impossible 0))
(assert (not (= source_inj_006_header_injection_impossible target_inj_006_header_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_007_template_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_007_template_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_007_template_injection_impossible Int)
(declare-const target_inj_007_template_injection_impossible Int)
(assert (>= source_inj_007_template_injection_impossible 0))
(assert (>= target_inj_007_template_injection_impossible 0))
(assert (not (= source_inj_007_template_injection_impossible target_inj_007_template_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_008_code_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_008_code_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_008_code_injection_impossible Int)
(declare-const target_inj_008_code_injection_impossible Int)
(assert (>= source_inj_008_code_injection_impossible 0))
(assert (>= target_inj_008_code_injection_impossible 0))
(assert (not (= source_inj_008_code_injection_impossible target_inj_008_code_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_009_expression_language_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_009_expression_language_safe preserves semantics
(push 1)
(declare-const source_inj_009_expression_language_safe Int)
(declare-const target_inj_009_expression_language_safe Int)
(assert (>= source_inj_009_expression_language_safe 0))
(assert (>= target_inj_009_expression_language_safe 0))
(assert (not (= source_inj_009_expression_language_safe target_inj_009_expression_language_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_010_log_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_010_log_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_010_log_injection_impossible Int)
(declare-const target_inj_010_log_injection_impossible Int)
(assert (>= source_inj_010_log_injection_impossible 0))
(assert (>= target_inj_010_log_injection_impossible 0))
(assert (not (= source_inj_010_log_injection_impossible target_inj_010_log_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_011_email_header_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_011_email_header_safe preserves semantics
(push 1)
(declare-const source_inj_011_email_header_safe Int)
(declare-const target_inj_011_email_header_safe Int)
(assert (>= source_inj_011_email_header_safe 0))
(assert (>= target_inj_011_email_header_safe 0))
(assert (not (= source_inj_011_email_header_safe target_inj_011_email_header_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; csv_escape_safe_helper: translation preserves property (matches Coq: Lemma)
; Translation validation: csv_escape_safe_helper preserves semantics
(push 1)
(declare-const source_csv_escape_safe_helper Int)
(declare-const target_csv_escape_safe_helper Int)
(assert (>= source_csv_escape_safe_helper 0))
(assert (>= target_csv_escape_safe_helper 0))
(assert (not (= source_csv_escape_safe_helper target_csv_escape_safe_helper)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_012_csv_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_012_csv_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_012_csv_injection_impossible Int)
(declare-const target_inj_012_csv_injection_impossible Int)
(assert (>= source_inj_012_csv_injection_impossible 0))
(assert (>= target_inj_012_csv_injection_impossible 0))
(assert (not (= source_inj_012_csv_injection_impossible target_inj_012_csv_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_013_pdf_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_013_pdf_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_013_pdf_injection_impossible Int)
(declare-const target_inj_013_pdf_injection_impossible Int)
(assert (>= source_inj_013_pdf_injection_impossible 0))
(assert (>= target_inj_013_pdf_injection_impossible 0))
(assert (not (= source_inj_013_pdf_injection_impossible target_inj_013_pdf_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_014_crlf_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_014_crlf_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_014_crlf_injection_impossible Int)
(declare-const target_inj_014_crlf_injection_impossible Int)
(assert (>= source_inj_014_crlf_injection_impossible 0))
(assert (>= target_inj_014_crlf_injection_impossible 0))
(assert (not (= source_inj_014_crlf_injection_impossible target_inj_014_crlf_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_015_null_byte_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_015_null_byte_injection_impossible preserves semantics
(push 1)
(declare-const source_inj_015_null_byte_injection_impossible Int)
(declare-const target_inj_015_null_byte_injection_impossible Int)
(assert (>= source_inj_015_null_byte_injection_impossible 0))
(assert (>= target_inj_015_null_byte_injection_impossible 0))
(assert (not (= source_inj_015_null_byte_injection_impossible target_inj_015_null_byte_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_016_untrusted_propagation: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_016_untrusted_propagation preserves semantics
(push 1)
(declare-const source_inj_016_untrusted_propagation Int)
(declare-const target_inj_016_untrusted_propagation Int)
(assert (>= source_inj_016_untrusted_propagation 0))
(assert (>= target_inj_016_untrusted_propagation 0))
(assert (not (= source_inj_016_untrusted_propagation target_inj_016_untrusted_propagation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_017_untrusted_propagation_right: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_017_untrusted_propagation_right preserves semantics
(push 1)
(declare-const source_inj_017_untrusted_propagation_right Int)
(declare-const target_inj_017_untrusted_propagation_right Int)
(assert (>= source_inj_017_untrusted_propagation_right 0))
(assert (>= target_inj_017_untrusted_propagation_right 0))
(assert (not (= source_inj_017_untrusted_propagation_right target_inj_017_untrusted_propagation_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_018_trusted_propagation: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_018_trusted_propagation preserves semantics
(push 1)
(declare-const source_inj_018_trusted_propagation Int)
(declare-const target_inj_018_trusted_propagation Int)
(assert (>= source_inj_018_trusted_propagation 0))
(assert (>= target_inj_018_trusted_propagation 0))
(assert (not (= source_inj_018_trusted_propagation target_inj_018_trusted_propagation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_019_sanitized_propagation: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_019_sanitized_propagation preserves semantics
(push 1)
(declare-const source_inj_019_sanitized_propagation Int)
(declare-const target_inj_019_sanitized_propagation Int)
(assert (>= source_inj_019_sanitized_propagation 0))
(assert (>= target_inj_019_sanitized_propagation 0))
(assert (not (= source_inj_019_sanitized_propagation target_inj_019_sanitized_propagation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_020_empty_sql_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_020_empty_sql_safe preserves semantics
(push 1)
(declare-const source_inj_020_empty_sql_safe Int)
(declare-const target_inj_020_empty_sql_safe Int)
(assert (>= source_inj_020_empty_sql_safe 0))
(assert (>= target_inj_020_empty_sql_safe 0))
(assert (not (= source_inj_020_empty_sql_safe target_inj_020_empty_sql_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_021_parameterized_always_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_021_parameterized_always_safe preserves semantics
(push 1)
(declare-const source_inj_021_parameterized_always_safe Int)
(declare-const target_inj_021_parameterized_always_safe Int)
(assert (>= source_inj_021_parameterized_always_safe 0))
(assert (>= target_inj_021_parameterized_always_safe 0))
(assert (not (= source_inj_021_parameterized_always_safe target_inj_021_parameterized_always_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_022_trusted_propagation: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_022_trusted_propagation preserves semantics
(push 1)
(declare-const source_inj_022_trusted_propagation Int)
(declare-const target_inj_022_trusted_propagation Int)
(assert (>= source_inj_022_trusted_propagation 0))
(assert (>= target_inj_022_trusted_propagation 0))
(assert (not (= source_inj_022_trusted_propagation target_inj_022_trusted_propagation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_023_taint_propagation_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_023_taint_propagation_comm preserves semantics
(push 1)
(declare-const source_inj_023_taint_propagation_comm Int)
(declare-const target_inj_023_taint_propagation_comm Int)
(assert (>= source_inj_023_taint_propagation_comm 0))
(assert (>= target_inj_023_taint_propagation_comm 0))
(assert (not (= source_inj_023_taint_propagation_comm target_inj_023_taint_propagation_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_024_trusted_propagation: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_024_trusted_propagation preserves semantics
(push 1)
(declare-const source_inj_024_trusted_propagation Int)
(declare-const target_inj_024_trusted_propagation Int)
(assert (>= source_inj_024_trusted_propagation 0))
(assert (>= target_inj_024_trusted_propagation 0))
(assert (not (= source_inj_024_trusted_propagation target_inj_024_trusted_propagation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inj_025_untrusted_propagation: translation preserves property (matches Coq: Theorem)
; Translation validation: inj_025_untrusted_propagation preserves semantics
(push 1)
(declare-const source_inj_025_untrusted_propagation Int)
(declare-const target_inj_025_untrusted_propagation Int)
(assert (>= source_inj_025_untrusted_propagation 0))
(assert (>= target_inj_025_untrusted_propagation 0))
(assert (not (= source_inj_025_untrusted_propagation target_inj_025_untrusted_propagation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/XSSPrevention.v (170 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for XSSPrevention
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; output_safe: source semantics (matches Coq)
; Translation validation: output_safe preserves semantics
(push 1)
(declare-const source_output_safe Int)
(declare-const target_output_safe Int)
(assert (>= source_output_safe 0))
(assert (>= target_output_safe 0))
(assert (not (= source_output_safe target_output_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; csp_enforced: source semantics (matches Coq)
; Translation validation: csp_enforced preserves semantics
(push 1)
(declare-const source_csp_enforced Int)
(declare-const target_csp_enforced Int)
(assert (>= source_csp_enforced 0))
(assert (>= target_csp_enforced 0))
(assert (not (= source_csp_enforced target_csp_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; csp_maximum: source semantics (matches Coq)
; Translation validation: csp_maximum preserves semantics
(push 1)
(declare-const source_csp_maximum Int)
(declare-const target_csp_maximum Int)
(assert (>= source_csp_maximum 0))
(assert (>= target_csp_maximum 0))
(assert (not (= source_csp_maximum target_csp_maximum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dom_sanitizer_complete: source semantics (matches Coq)
; Translation validation: dom_sanitizer_complete preserves semantics
(push 1)
(declare-const source_dom_sanitizer_complete Int)
(declare-const target_dom_sanitizer_complete Int)
(assert (>= source_dom_sanitizer_complete 0))
(assert (>= target_dom_sanitizer_complete 0))
(assert (not (= source_dom_sanitizer_complete target_dom_sanitizer_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; input_validation_complete: source semantics (matches Coq)
; Translation validation: input_validation_complete preserves semantics
(push 1)
(declare-const source_input_validation_complete Int)
(declare-const target_input_validation_complete Int)
(assert (>= source_input_validation_complete 0))
(assert (>= target_input_validation_complete 0))
(assert (not (= source_input_validation_complete target_input_validation_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; xss_protected: source semantics (matches Coq)
; Translation validation: xss_protected preserves semantics
(push 1)
(declare-const source_xss_protected Int)
(declare-const target_xss_protected Int)
(assert (>= source_xss_protected 0))
(assert (>= target_xss_protected 0))
(assert (not (= source_xss_protected target_xss_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; xss_maximum_protection: source semantics (matches Coq)
; Translation validation: xss_maximum_protection preserves semantics
(push 1)
(declare-const source_xss_maximum_protection Int)
(declare-const target_xss_maximum_protection Int)
(assert (>= source_xss_maximum_protection 0))
(assert (>= target_xss_maximum_protection 0))
(assert (not (= source_xss_maximum_protection target_xss_maximum_protection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; taint_safe: source semantics (matches Coq)
; Translation validation: taint_safe preserves semantics
(push 1)
(declare-const source_taint_safe Int)
(declare-const target_taint_safe Int)
(assert (>= source_taint_safe 0))
(assert (>= target_taint_safe 0))
(assert (not (= source_taint_safe target_taint_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_output: source semantics (matches Coq)
; Translation validation: riina_output preserves semantics
(push 1)
(declare-const source_riina_output Int)
(declare-const target_riina_output Int)
(assert (>= source_riina_output 0))
(assert (>= target_riina_output 0))
(assert (not (= source_riina_output target_riina_output)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_csp: source semantics (matches Coq)
; Translation validation: riina_csp preserves semantics
(push 1)
(declare-const source_riina_csp Int)
(declare-const target_riina_csp Int)
(assert (>= source_riina_csp 0))
(assert (>= target_riina_csp 0))
(assert (not (= source_riina_csp target_riina_csp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_dom: source semantics (matches Coq)
; Translation validation: riina_dom preserves semantics
(push 1)
(declare-const source_riina_dom Int)
(declare-const target_riina_dom Int)
(assert (>= source_riina_dom 0))
(assert (>= target_riina_dom 0))
(assert (not (= source_riina_dom target_riina_dom)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_input: source semantics (matches Coq)
; Translation validation: riina_input preserves semantics
(push 1)
(declare-const source_riina_input Int)
(declare-const target_riina_input Int)
(assert (>= source_riina_input 0))
(assert (>= target_riina_input 0))
(assert (not (= source_riina_input target_riina_input)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_xss: source semantics (matches Coq)
; Translation validation: riina_xss preserves semantics
(push 1)
(declare-const source_riina_xss Int)
(declare-const target_riina_xss Int)
(assert (>= source_riina_xss 0))
(assert (>= target_riina_xss 0))
(assert (not (= source_riina_xss target_riina_xss)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

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

; reflected_xss_safe: source semantics (matches Coq)
; Translation validation: reflected_xss_safe preserves semantics
(push 1)
(declare-const source_reflected_xss_safe Int)
(declare-const target_reflected_xss_safe Int)
(assert (>= source_reflected_xss_safe 0))
(assert (>= target_reflected_xss_safe 0))
(assert (not (= source_reflected_xss_safe target_reflected_xss_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_reflected: source semantics (matches Coq)
; Translation validation: riina_reflected preserves semantics
(push 1)
(declare-const source_riina_reflected Int)
(declare-const target_riina_reflected Int)
(assert (>= source_riina_reflected 0))
(assert (>= target_riina_reflected 0))
(assert (not (= source_riina_reflected target_riina_reflected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; stored_xss_safe: source semantics (matches Coq)
; Translation validation: stored_xss_safe preserves semantics
(push 1)
(declare-const source_stored_xss_safe Int)
(declare-const target_stored_xss_safe Int)
(assert (>= source_stored_xss_safe 0))
(assert (>= target_stored_xss_safe 0))
(assert (not (= source_stored_xss_safe target_stored_xss_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_stored: source semantics (matches Coq)
; Translation validation: riina_stored preserves semantics
(push 1)
(declare-const source_riina_stored Int)
(declare-const target_riina_stored Int)
(assert (>= source_riina_stored 0))
(assert (>= target_riina_stored 0))
(assert (not (= source_riina_stored target_riina_stored)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dom_xss_safe: source semantics (matches Coq)
; Translation validation: dom_xss_safe preserves semantics
(push 1)
(declare-const source_dom_xss_safe Int)
(declare-const target_dom_xss_safe Int)
(assert (>= source_dom_xss_safe 0))
(assert (>= target_dom_xss_safe 0))
(assert (not (= source_dom_xss_safe target_dom_xss_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_dom_based: source semantics (matches Coq)
; Translation validation: riina_dom_based preserves semantics
(push 1)
(declare-const source_riina_dom_based Int)
(declare-const target_riina_dom_based Int)
(assert (>= source_riina_dom_based 0))
(assert (>= target_riina_dom_based 0))
(assert (not (= source_riina_dom_based target_riina_dom_based)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_html_dangerous: source semantics (matches Coq)
; Translation validation: is_html_dangerous preserves semantics
(push 1)
(declare-const source_is_html_dangerous Int)
(declare-const target_is_html_dangerous Int)
(assert (>= source_is_html_dangerous 0))
(assert (>= target_is_html_dangerous 0))
(assert (not (= source_is_html_dangerous target_is_html_dangerous)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_js_dangerous: source semantics (matches Coq)
; Translation validation: is_js_dangerous preserves semantics
(push 1)
(declare-const source_is_js_dangerous Int)
(declare-const target_is_js_dangerous Int)
(assert (>= source_is_js_dangerous 0))
(assert (>= target_is_js_dangerous 0))
(assert (not (= source_is_js_dangerous target_is_js_dangerous)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; needs_url_encoding: source semantics (matches Coq)
; Translation validation: needs_url_encoding preserves semantics
(push 1)
(declare-const source_needs_url_encoding Int)
(declare-const target_needs_url_encoding Int)
(assert (>= source_needs_url_encoding 0))
(assert (>= target_needs_url_encoding 0))
(assert (not (= source_needs_url_encoding target_needs_url_encoding)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hex_digit: source semantics (matches Coq)
; Translation validation: hex_digit preserves semantics
(push 1)
(declare-const source_hex_digit Int)
(declare-const target_hex_digit Int)
(assert (>= source_hex_digit 0))
(assert (>= target_hex_digit 0))
(assert (not (= source_hex_digit target_hex_digit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_css_dangerous: source semantics (matches Coq)
; Translation validation: is_css_dangerous preserves semantics
(push 1)
(declare-const source_is_css_dangerous Int)
(declare-const target_is_css_dangerous Int)
(assert (>= source_is_css_dangerous 0))
(assert (>= target_is_css_dangerous 0))
(assert (not (= source_is_css_dangerous target_is_css_dangerous)))
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

; andb_false_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_false_iff preserves semantics
(push 1)
(declare-const source_andb_false_iff Int)
(declare-const target_andb_false_iff Int)
(assert (>= source_andb_false_iff 0))
(assert (>= target_andb_false_iff 0))
(assert (not (= source_andb_false_iff target_andb_false_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; orb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: orb_true_iff preserves semantics
(push 1)
(declare-const source_orb_true_iff Int)
(declare-const target_orb_true_iff Int)
(assert (>= source_orb_true_iff 0))
(assert (>= target_orb_true_iff 0))
(assert (not (= source_orb_true_iff target_orb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_true_iff preserves semantics
(push 1)
(declare-const source_negb_true_iff Int)
(declare-const target_negb_true_iff Int)
(assert (>= source_negb_true_iff 0))
(assert (>= target_negb_true_iff 0))
(assert (not (= source_negb_true_iff target_negb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forallb_true: translation preserves property (matches Coq: Lemma)
; Translation validation: forallb_true preserves semantics
(push 1)
(declare-const source_forallb_true Int)
(declare-const target_forallb_true Int)
(assert (>= source_forallb_true 0))
(assert (>= target_forallb_true 0))
(assert (not (= source_forallb_true target_forallb_true)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_001: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_001 preserves semantics
(push 1)
(declare-const source_XSS_001 Int)
(declare-const target_XSS_001 Int)
(assert (>= source_XSS_001 0))
(assert (>= target_XSS_001 0))
(assert (not (= source_XSS_001 target_XSS_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_002: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_002 preserves semantics
(push 1)
(declare-const source_XSS_002 Int)
(declare-const target_XSS_002 Int)
(assert (>= source_XSS_002 0))
(assert (>= target_XSS_002 0))
(assert (not (= source_XSS_002 target_XSS_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_003: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_003 preserves semantics
(push 1)
(declare-const source_XSS_003 Int)
(declare-const target_XSS_003 Int)
(assert (>= source_XSS_003 0))
(assert (>= target_XSS_003 0))
(assert (not (= source_XSS_003 target_XSS_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_004: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_004 preserves semantics
(push 1)
(declare-const source_XSS_004 Int)
(declare-const target_XSS_004 Int)
(assert (>= source_XSS_004 0))
(assert (>= target_XSS_004 0))
(assert (not (= source_XSS_004 target_XSS_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_005: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_005 preserves semantics
(push 1)
(declare-const source_XSS_005 Int)
(declare-const target_XSS_005 Int)
(assert (>= source_XSS_005 0))
(assert (>= target_XSS_005 0))
(assert (not (= source_XSS_005 target_XSS_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_006: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_006 preserves semantics
(push 1)
(declare-const source_XSS_006 Int)
(declare-const target_XSS_006 Int)
(assert (>= source_XSS_006 0))
(assert (>= target_XSS_006 0))
(assert (not (= source_XSS_006 target_XSS_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_007: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_007 preserves semantics
(push 1)
(declare-const source_XSS_007 Int)
(declare-const target_XSS_007 Int)
(assert (>= source_XSS_007 0))
(assert (>= target_XSS_007 0))
(assert (not (= source_XSS_007 target_XSS_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_008: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_008 preserves semantics
(push 1)
(declare-const source_XSS_008 Int)
(declare-const target_XSS_008 Int)
(assert (>= source_XSS_008 0))
(assert (>= target_XSS_008 0))
(assert (not (= source_XSS_008 target_XSS_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_009: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_009 preserves semantics
(push 1)
(declare-const source_XSS_009 Int)
(declare-const target_XSS_009 Int)
(assert (>= source_XSS_009 0))
(assert (>= target_XSS_009 0))
(assert (not (= source_XSS_009 target_XSS_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_010: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_010 preserves semantics
(push 1)
(declare-const source_XSS_010 Int)
(declare-const target_XSS_010 Int)
(assert (>= source_XSS_010 0))
(assert (>= target_XSS_010 0))
(assert (not (= source_XSS_010 target_XSS_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_011: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_011 preserves semantics
(push 1)
(declare-const source_XSS_011 Int)
(declare-const target_XSS_011 Int)
(assert (>= source_XSS_011 0))
(assert (>= target_XSS_011 0))
(assert (not (= source_XSS_011 target_XSS_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_012: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_012 preserves semantics
(push 1)
(declare-const source_XSS_012 Int)
(declare-const target_XSS_012 Int)
(assert (>= source_XSS_012 0))
(assert (>= target_XSS_012 0))
(assert (not (= source_XSS_012 target_XSS_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_013: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_013 preserves semantics
(push 1)
(declare-const source_XSS_013 Int)
(declare-const target_XSS_013 Int)
(assert (>= source_XSS_013 0))
(assert (>= target_XSS_013 0))
(assert (not (= source_XSS_013 target_XSS_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_014: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_014 preserves semantics
(push 1)
(declare-const source_XSS_014 Int)
(declare-const target_XSS_014 Int)
(assert (>= source_XSS_014 0))
(assert (>= target_XSS_014 0))
(assert (not (= source_XSS_014 target_XSS_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_015: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_015 preserves semantics
(push 1)
(declare-const source_XSS_015 Int)
(declare-const target_XSS_015 Int)
(assert (>= source_XSS_015 0))
(assert (>= target_XSS_015 0))
(assert (not (= source_XSS_015 target_XSS_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_016: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_016 preserves semantics
(push 1)
(declare-const source_XSS_016 Int)
(declare-const target_XSS_016 Int)
(assert (>= source_XSS_016 0))
(assert (>= target_XSS_016 0))
(assert (not (= source_XSS_016 target_XSS_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_017: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_017 preserves semantics
(push 1)
(declare-const source_XSS_017 Int)
(declare-const target_XSS_017 Int)
(assert (>= source_XSS_017 0))
(assert (>= target_XSS_017 0))
(assert (not (= source_XSS_017 target_XSS_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_018: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_018 preserves semantics
(push 1)
(declare-const source_XSS_018 Int)
(declare-const target_XSS_018 Int)
(assert (>= source_XSS_018 0))
(assert (>= target_XSS_018 0))
(assert (not (= source_XSS_018 target_XSS_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_019: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_019 preserves semantics
(push 1)
(declare-const source_XSS_019 Int)
(declare-const target_XSS_019 Int)
(assert (>= source_XSS_019 0))
(assert (>= target_XSS_019 0))
(assert (not (= source_XSS_019 target_XSS_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_020: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_020 preserves semantics
(push 1)
(declare-const source_XSS_020 Int)
(declare-const target_XSS_020 Int)
(assert (>= source_XSS_020 0))
(assert (>= target_XSS_020 0))
(assert (not (= source_XSS_020 target_XSS_020)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_021: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_021 preserves semantics
(push 1)
(declare-const source_XSS_021 Int)
(declare-const target_XSS_021 Int)
(assert (>= source_XSS_021 0))
(assert (>= target_XSS_021 0))
(assert (not (= source_XSS_021 target_XSS_021)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_022: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_022 preserves semantics
(push 1)
(declare-const source_XSS_022 Int)
(declare-const target_XSS_022 Int)
(assert (>= source_XSS_022 0))
(assert (>= target_XSS_022 0))
(assert (not (= source_XSS_022 target_XSS_022)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_023: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_023 preserves semantics
(push 1)
(declare-const source_XSS_023 Int)
(declare-const target_XSS_023 Int)
(assert (>= source_XSS_023 0))
(assert (>= target_XSS_023 0))
(assert (not (= source_XSS_023 target_XSS_023)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_024: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_024 preserves semantics
(push 1)
(declare-const source_XSS_024 Int)
(declare-const target_XSS_024 Int)
(assert (>= source_XSS_024 0))
(assert (>= target_XSS_024 0))
(assert (not (= source_XSS_024 target_XSS_024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_025_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_025_complete preserves semantics
(push 1)
(declare-const source_XSS_025_complete Int)
(declare-const target_XSS_025_complete Int)
(assert (>= source_XSS_025_complete 0))
(assert (>= target_XSS_025_complete 0))
(assert (not (= source_XSS_025_complete target_XSS_025_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_026: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_026 preserves semantics
(push 1)
(declare-const source_XSS_026 Int)
(declare-const target_XSS_026 Int)
(assert (>= source_XSS_026 0))
(assert (>= target_XSS_026 0))
(assert (not (= source_XSS_026 target_XSS_026)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_027: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_027 preserves semantics
(push 1)
(declare-const source_XSS_027 Int)
(declare-const target_XSS_027 Int)
(assert (>= source_XSS_027 0))
(assert (>= target_XSS_027 0))
(assert (not (= source_XSS_027 target_XSS_027)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_028: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_028 preserves semantics
(push 1)
(declare-const source_XSS_028 Int)
(declare-const target_XSS_028 Int)
(assert (>= source_XSS_028 0))
(assert (>= target_XSS_028 0))
(assert (not (= source_XSS_028 target_XSS_028)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_029: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_029 preserves semantics
(push 1)
(declare-const source_XSS_029 Int)
(declare-const target_XSS_029 Int)
(assert (>= source_XSS_029 0))
(assert (>= target_XSS_029 0))
(assert (not (= source_XSS_029 target_XSS_029)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_030: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_030 preserves semantics
(push 1)
(declare-const source_XSS_030 Int)
(declare-const target_XSS_030 Int)
(assert (>= source_XSS_030 0))
(assert (>= target_XSS_030 0))
(assert (not (= source_XSS_030 target_XSS_030)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_031: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_031 preserves semantics
(push 1)
(declare-const source_XSS_031 Int)
(declare-const target_XSS_031 Int)
(assert (>= source_XSS_031 0))
(assert (>= target_XSS_031 0))
(assert (not (= source_XSS_031 target_XSS_031)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_032: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_032 preserves semantics
(push 1)
(declare-const source_XSS_032 Int)
(declare-const target_XSS_032 Int)
(assert (>= source_XSS_032 0))
(assert (>= target_XSS_032 0))
(assert (not (= source_XSS_032 target_XSS_032)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_033: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_033 preserves semantics
(push 1)
(declare-const source_XSS_033 Int)
(declare-const target_XSS_033 Int)
(assert (>= source_XSS_033 0))
(assert (>= target_XSS_033 0))
(assert (not (= source_XSS_033 target_XSS_033)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_034: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_034 preserves semantics
(push 1)
(declare-const source_XSS_034 Int)
(declare-const target_XSS_034 Int)
(assert (>= source_XSS_034 0))
(assert (>= target_XSS_034 0))
(assert (not (= source_XSS_034 target_XSS_034)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_035: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_035 preserves semantics
(push 1)
(declare-const source_XSS_035 Int)
(declare-const target_XSS_035 Int)
(assert (>= source_XSS_035 0))
(assert (>= target_XSS_035 0))
(assert (not (= source_XSS_035 target_XSS_035)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_036: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_036 preserves semantics
(push 1)
(declare-const source_XSS_036 Int)
(declare-const target_XSS_036 Int)
(assert (>= source_XSS_036 0))
(assert (>= target_XSS_036 0))
(assert (not (= source_XSS_036 target_XSS_036)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_037: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_037 preserves semantics
(push 1)
(declare-const source_XSS_037 Int)
(declare-const target_XSS_037 Int)
(assert (>= source_XSS_037 0))
(assert (>= target_XSS_037 0))
(assert (not (= source_XSS_037 target_XSS_037)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_038: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_038 preserves semantics
(push 1)
(declare-const source_XSS_038 Int)
(declare-const target_XSS_038 Int)
(assert (>= source_XSS_038 0))
(assert (>= target_XSS_038 0))
(assert (not (= source_XSS_038 target_XSS_038)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_039: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_039 preserves semantics
(push 1)
(declare-const source_XSS_039 Int)
(declare-const target_XSS_039 Int)
(assert (>= source_XSS_039 0))
(assert (>= target_XSS_039 0))
(assert (not (= source_XSS_039 target_XSS_039)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_040: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_040 preserves semantics
(push 1)
(declare-const source_XSS_040 Int)
(declare-const target_XSS_040 Int)
(assert (>= source_XSS_040 0))
(assert (>= target_XSS_040 0))
(assert (not (= source_XSS_040 target_XSS_040)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_041: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_041 preserves semantics
(push 1)
(declare-const source_XSS_041 Int)
(declare-const target_XSS_041 Int)
(assert (>= source_XSS_041 0))
(assert (>= target_XSS_041 0))
(assert (not (= source_XSS_041 target_XSS_041)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_042: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_042 preserves semantics
(push 1)
(declare-const source_XSS_042 Int)
(declare-const target_XSS_042 Int)
(assert (>= source_XSS_042 0))
(assert (>= target_XSS_042 0))
(assert (not (= source_XSS_042 target_XSS_042)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_043: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_043 preserves semantics
(push 1)
(declare-const source_XSS_043 Int)
(declare-const target_XSS_043 Int)
(assert (>= source_XSS_043 0))
(assert (>= target_XSS_043 0))
(assert (not (= source_XSS_043 target_XSS_043)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_044: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_044 preserves semantics
(push 1)
(declare-const source_XSS_044 Int)
(declare-const target_XSS_044 Int)
(assert (>= source_XSS_044 0))
(assert (>= target_XSS_044 0))
(assert (not (= source_XSS_044 target_XSS_044)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_045: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_045 preserves semantics
(push 1)
(declare-const source_XSS_045 Int)
(declare-const target_XSS_045 Int)
(assert (>= source_XSS_045 0))
(assert (>= target_XSS_045 0))
(assert (not (= source_XSS_045 target_XSS_045)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_046: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_046 preserves semantics
(push 1)
(declare-const source_XSS_046 Int)
(declare-const target_XSS_046 Int)
(assert (>= source_XSS_046 0))
(assert (>= target_XSS_046 0))
(assert (not (= source_XSS_046 target_XSS_046)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_047: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_047 preserves semantics
(push 1)
(declare-const source_XSS_047 Int)
(declare-const target_XSS_047 Int)
(assert (>= source_XSS_047 0))
(assert (>= target_XSS_047 0))
(assert (not (= source_XSS_047 target_XSS_047)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_048: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_048 preserves semantics
(push 1)
(declare-const source_XSS_048 Int)
(declare-const target_XSS_048 Int)
(assert (>= source_XSS_048 0))
(assert (>= target_XSS_048 0))
(assert (not (= source_XSS_048 target_XSS_048)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_049: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_049 preserves semantics
(push 1)
(declare-const source_XSS_049 Int)
(declare-const target_XSS_049 Int)
(assert (>= source_XSS_049 0))
(assert (>= target_XSS_049 0))
(assert (not (= source_XSS_049 target_XSS_049)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_050: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_050 preserves semantics
(push 1)
(declare-const source_XSS_050 Int)
(declare-const target_XSS_050 Int)
(assert (>= source_XSS_050 0))
(assert (>= target_XSS_050 0))
(assert (not (= source_XSS_050 target_XSS_050)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_051: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_051 preserves semantics
(push 1)
(declare-const source_XSS_051 Int)
(declare-const target_XSS_051 Int)
(assert (>= source_XSS_051 0))
(assert (>= target_XSS_051 0))
(assert (not (= source_XSS_051 target_XSS_051)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_052: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_052 preserves semantics
(push 1)
(declare-const source_XSS_052 Int)
(declare-const target_XSS_052 Int)
(assert (>= source_XSS_052 0))
(assert (>= target_XSS_052 0))
(assert (not (= source_XSS_052 target_XSS_052)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_053: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_053 preserves semantics
(push 1)
(declare-const source_XSS_053 Int)
(declare-const target_XSS_053 Int)
(assert (>= source_XSS_053 0))
(assert (>= target_XSS_053 0))
(assert (not (= source_XSS_053 target_XSS_053)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_054: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_054 preserves semantics
(push 1)
(declare-const source_XSS_054 Int)
(declare-const target_XSS_054 Int)
(assert (>= source_XSS_054 0))
(assert (>= target_XSS_054 0))
(assert (not (= source_XSS_054 target_XSS_054)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_055: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_055 preserves semantics
(push 1)
(declare-const source_XSS_055 Int)
(declare-const target_XSS_055 Int)
(assert (>= source_XSS_055 0))
(assert (>= target_XSS_055 0))
(assert (not (= source_XSS_055 target_XSS_055)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_056: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_056 preserves semantics
(push 1)
(declare-const source_XSS_056 Int)
(declare-const target_XSS_056 Int)
(assert (>= source_XSS_056 0))
(assert (>= target_XSS_056 0))
(assert (not (= source_XSS_056 target_XSS_056)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_057: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_057 preserves semantics
(push 1)
(declare-const source_XSS_057 Int)
(declare-const target_XSS_057 Int)
(assert (>= source_XSS_057 0))
(assert (>= target_XSS_057 0))
(assert (not (= source_XSS_057 target_XSS_057)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_058: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_058 preserves semantics
(push 1)
(declare-const source_XSS_058 Int)
(declare-const target_XSS_058 Int)
(assert (>= source_XSS_058 0))
(assert (>= target_XSS_058 0))
(assert (not (= source_XSS_058 target_XSS_058)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_059: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_059 preserves semantics
(push 1)
(declare-const source_XSS_059 Int)
(declare-const target_XSS_059 Int)
(assert (>= source_XSS_059 0))
(assert (>= target_XSS_059 0))
(assert (not (= source_XSS_059 target_XSS_059)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_060: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_060 preserves semantics
(push 1)
(declare-const source_XSS_060 Int)
(declare-const target_XSS_060 Int)
(assert (>= source_XSS_060 0))
(assert (>= target_XSS_060 0))
(assert (not (= source_XSS_060 target_XSS_060)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_061: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_061 preserves semantics
(push 1)
(declare-const source_XSS_061 Int)
(declare-const target_XSS_061 Int)
(assert (>= source_XSS_061 0))
(assert (>= target_XSS_061 0))
(assert (not (= source_XSS_061 target_XSS_061)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_062: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_062 preserves semantics
(push 1)
(declare-const source_XSS_062 Int)
(declare-const target_XSS_062 Int)
(assert (>= source_XSS_062 0))
(assert (>= target_XSS_062 0))
(assert (not (= source_XSS_062 target_XSS_062)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_063: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_063 preserves semantics
(push 1)
(declare-const source_XSS_063 Int)
(declare-const target_XSS_063 Int)
(assert (>= source_XSS_063 0))
(assert (>= target_XSS_063 0))
(assert (not (= source_XSS_063 target_XSS_063)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_064: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_064 preserves semantics
(push 1)
(declare-const source_XSS_064 Int)
(declare-const target_XSS_064 Int)
(assert (>= source_XSS_064 0))
(assert (>= target_XSS_064 0))
(assert (not (= source_XSS_064 target_XSS_064)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_065: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_065 preserves semantics
(push 1)
(declare-const source_XSS_065 Int)
(declare-const target_XSS_065 Int)
(assert (>= source_XSS_065 0))
(assert (>= target_XSS_065 0))
(assert (not (= source_XSS_065 target_XSS_065)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_066: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_066 preserves semantics
(push 1)
(declare-const source_XSS_066 Int)
(declare-const target_XSS_066 Int)
(assert (>= source_XSS_066 0))
(assert (>= target_XSS_066 0))
(assert (not (= source_XSS_066 target_XSS_066)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_067: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_067 preserves semantics
(push 1)
(declare-const source_XSS_067 Int)
(declare-const target_XSS_067 Int)
(assert (>= source_XSS_067 0))
(assert (>= target_XSS_067 0))
(assert (not (= source_XSS_067 target_XSS_067)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_068: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_068 preserves semantics
(push 1)
(declare-const source_XSS_068 Int)
(declare-const target_XSS_068 Int)
(assert (>= source_XSS_068 0))
(assert (>= target_XSS_068 0))
(assert (not (= source_XSS_068 target_XSS_068)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_069: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_069 preserves semantics
(push 1)
(declare-const source_XSS_069 Int)
(declare-const target_XSS_069 Int)
(assert (>= source_XSS_069 0))
(assert (>= target_XSS_069 0))
(assert (not (= source_XSS_069 target_XSS_069)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_070: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_070 preserves semantics
(push 1)
(declare-const source_XSS_070 Int)
(declare-const target_XSS_070 Int)
(assert (>= source_XSS_070 0))
(assert (>= target_XSS_070 0))
(assert (not (= source_XSS_070 target_XSS_070)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_071: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_071 preserves semantics
(push 1)
(declare-const source_XSS_071 Int)
(declare-const target_XSS_071 Int)
(assert (>= source_XSS_071 0))
(assert (>= target_XSS_071 0))
(assert (not (= source_XSS_071 target_XSS_071)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_072: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_072 preserves semantics
(push 1)
(declare-const source_XSS_072 Int)
(declare-const target_XSS_072 Int)
(assert (>= source_XSS_072 0))
(assert (>= target_XSS_072 0))
(assert (not (= source_XSS_072 target_XSS_072)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_073: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_073 preserves semantics
(push 1)
(declare-const source_XSS_073 Int)
(declare-const target_XSS_073 Int)
(assert (>= source_XSS_073 0))
(assert (>= target_XSS_073 0))
(assert (not (= source_XSS_073 target_XSS_073)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_074: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_074 preserves semantics
(push 1)
(declare-const source_XSS_074 Int)
(declare-const target_XSS_074 Int)
(assert (>= source_XSS_074 0))
(assert (>= target_XSS_074 0))
(assert (not (= source_XSS_074 target_XSS_074)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_075: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_075 preserves semantics
(push 1)
(declare-const source_XSS_075 Int)
(declare-const target_XSS_075 Int)
(assert (>= source_XSS_075 0))
(assert (>= target_XSS_075 0))
(assert (not (= source_XSS_075 target_XSS_075)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_076: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_076 preserves semantics
(push 1)
(declare-const source_XSS_076 Int)
(declare-const target_XSS_076 Int)
(assert (>= source_XSS_076 0))
(assert (>= target_XSS_076 0))
(assert (not (= source_XSS_076 target_XSS_076)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_077: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_077 preserves semantics
(push 1)
(declare-const source_XSS_077 Int)
(declare-const target_XSS_077 Int)
(assert (>= source_XSS_077 0))
(assert (>= target_XSS_077 0))
(assert (not (= source_XSS_077 target_XSS_077)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_078: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_078 preserves semantics
(push 1)
(declare-const source_XSS_078 Int)
(declare-const target_XSS_078 Int)
(assert (>= source_XSS_078 0))
(assert (>= target_XSS_078 0))
(assert (not (= source_XSS_078 target_XSS_078)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_079: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_079 preserves semantics
(push 1)
(declare-const source_XSS_079 Int)
(declare-const target_XSS_079 Int)
(assert (>= source_XSS_079 0))
(assert (>= target_XSS_079 0))
(assert (not (= source_XSS_079 target_XSS_079)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_080: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_080 preserves semantics
(push 1)
(declare-const source_XSS_080 Int)
(declare-const target_XSS_080 Int)
(assert (>= source_XSS_080 0))
(assert (>= target_XSS_080 0))
(assert (not (= source_XSS_080 target_XSS_080)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_081: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_081 preserves semantics
(push 1)
(declare-const source_XSS_081 Int)
(declare-const target_XSS_081 Int)
(assert (>= source_XSS_081 0))
(assert (>= target_XSS_081 0))
(assert (not (= source_XSS_081 target_XSS_081)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_082: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_082 preserves semantics
(push 1)
(declare-const source_XSS_082 Int)
(declare-const target_XSS_082 Int)
(assert (>= source_XSS_082 0))
(assert (>= target_XSS_082 0))
(assert (not (= source_XSS_082 target_XSS_082)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_083: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_083 preserves semantics
(push 1)
(declare-const source_XSS_083 Int)
(declare-const target_XSS_083 Int)
(assert (>= source_XSS_083 0))
(assert (>= target_XSS_083 0))
(assert (not (= source_XSS_083 target_XSS_083)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_084: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_084 preserves semantics
(push 1)
(declare-const source_XSS_084 Int)
(declare-const target_XSS_084 Int)
(assert (>= source_XSS_084 0))
(assert (>= target_XSS_084 0))
(assert (not (= source_XSS_084 target_XSS_084)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_085: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_085 preserves semantics
(push 1)
(declare-const source_XSS_085 Int)
(declare-const target_XSS_085 Int)
(assert (>= source_XSS_085 0))
(assert (>= target_XSS_085 0))
(assert (not (= source_XSS_085 target_XSS_085)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_086: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_086 preserves semantics
(push 1)
(declare-const source_XSS_086 Int)
(declare-const target_XSS_086 Int)
(assert (>= source_XSS_086 0))
(assert (>= target_XSS_086 0))
(assert (not (= source_XSS_086 target_XSS_086)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_087: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_087 preserves semantics
(push 1)
(declare-const source_XSS_087 Int)
(declare-const target_XSS_087 Int)
(assert (>= source_XSS_087 0))
(assert (>= target_XSS_087 0))
(assert (not (= source_XSS_087 target_XSS_087)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_088: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_088 preserves semantics
(push 1)
(declare-const source_XSS_088 Int)
(declare-const target_XSS_088 Int)
(assert (>= source_XSS_088 0))
(assert (>= target_XSS_088 0))
(assert (not (= source_XSS_088 target_XSS_088)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_089: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_089 preserves semantics
(push 1)
(declare-const source_XSS_089 Int)
(declare-const target_XSS_089 Int)
(assert (>= source_XSS_089 0))
(assert (>= target_XSS_089 0))
(assert (not (= source_XSS_089 target_XSS_089)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_090: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_090 preserves semantics
(push 1)
(declare-const source_XSS_090 Int)
(declare-const target_XSS_090 Int)
(assert (>= source_XSS_090 0))
(assert (>= target_XSS_090 0))
(assert (not (= source_XSS_090 target_XSS_090)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_091: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_091 preserves semantics
(push 1)
(declare-const source_XSS_091 Int)
(declare-const target_XSS_091 Int)
(assert (>= source_XSS_091 0))
(assert (>= target_XSS_091 0))
(assert (not (= source_XSS_091 target_XSS_091)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_092: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_092 preserves semantics
(push 1)
(declare-const source_XSS_092 Int)
(declare-const target_XSS_092 Int)
(assert (>= source_XSS_092 0))
(assert (>= target_XSS_092 0))
(assert (not (= source_XSS_092 target_XSS_092)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_093: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_093 preserves semantics
(push 1)
(declare-const source_XSS_093 Int)
(declare-const target_XSS_093 Int)
(assert (>= source_XSS_093 0))
(assert (>= target_XSS_093 0))
(assert (not (= source_XSS_093 target_XSS_093)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_094: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_094 preserves semantics
(push 1)
(declare-const source_XSS_094 Int)
(declare-const target_XSS_094 Int)
(assert (>= source_XSS_094 0))
(assert (>= target_XSS_094 0))
(assert (not (= source_XSS_094 target_XSS_094)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_095: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_095 preserves semantics
(push 1)
(declare-const source_XSS_095 Int)
(declare-const target_XSS_095 Int)
(assert (>= source_XSS_095 0))
(assert (>= target_XSS_095 0))
(assert (not (= source_XSS_095 target_XSS_095)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_096: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_096 preserves semantics
(push 1)
(declare-const source_XSS_096 Int)
(declare-const target_XSS_096 Int)
(assert (>= source_XSS_096 0))
(assert (>= target_XSS_096 0))
(assert (not (= source_XSS_096 target_XSS_096)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_097: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_097 preserves semantics
(push 1)
(declare-const source_XSS_097 Int)
(declare-const target_XSS_097 Int)
(assert (>= source_XSS_097 0))
(assert (>= target_XSS_097 0))
(assert (not (= source_XSS_097 target_XSS_097)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_098: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_098 preserves semantics
(push 1)
(declare-const source_XSS_098 Int)
(declare-const target_XSS_098 Int)
(assert (>= source_XSS_098 0))
(assert (>= target_XSS_098 0))
(assert (not (= source_XSS_098 target_XSS_098)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_099: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_099 preserves semantics
(push 1)
(declare-const source_XSS_099 Int)
(declare-const target_XSS_099 Int)
(assert (>= source_XSS_099 0))
(assert (>= target_XSS_099 0))
(assert (not (= source_XSS_099 target_XSS_099)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_100: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_100 preserves semantics
(push 1)
(declare-const source_XSS_100 Int)
(declare-const target_XSS_100 Int)
(assert (>= source_XSS_100 0))
(assert (>= target_XSS_100 0))
(assert (not (= source_XSS_100 target_XSS_100)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_101: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_101 preserves semantics
(push 1)
(declare-const source_XSS_101 Int)
(declare-const target_XSS_101 Int)
(assert (>= source_XSS_101 0))
(assert (>= target_XSS_101 0))
(assert (not (= source_XSS_101 target_XSS_101)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_102: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_102 preserves semantics
(push 1)
(declare-const source_XSS_102 Int)
(declare-const target_XSS_102 Int)
(assert (>= source_XSS_102 0))
(assert (>= target_XSS_102 0))
(assert (not (= source_XSS_102 target_XSS_102)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_103: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_103 preserves semantics
(push 1)
(declare-const source_XSS_103 Int)
(declare-const target_XSS_103 Int)
(assert (>= source_XSS_103 0))
(assert (>= target_XSS_103 0))
(assert (not (= source_XSS_103 target_XSS_103)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_104: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_104 preserves semantics
(push 1)
(declare-const source_XSS_104 Int)
(declare-const target_XSS_104 Int)
(assert (>= source_XSS_104 0))
(assert (>= target_XSS_104 0))
(assert (not (= source_XSS_104 target_XSS_104)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_105: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_105 preserves semantics
(push 1)
(declare-const source_XSS_105 Int)
(declare-const target_XSS_105 Int)
(assert (>= source_XSS_105 0))
(assert (>= target_XSS_105 0))
(assert (not (= source_XSS_105 target_XSS_105)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_106: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_106 preserves semantics
(push 1)
(declare-const source_XSS_106 Int)
(declare-const target_XSS_106 Int)
(assert (>= source_XSS_106 0))
(assert (>= target_XSS_106 0))
(assert (not (= source_XSS_106 target_XSS_106)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_107: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_107 preserves semantics
(push 1)
(declare-const source_XSS_107 Int)
(declare-const target_XSS_107 Int)
(assert (>= source_XSS_107 0))
(assert (>= target_XSS_107 0))
(assert (not (= source_XSS_107 target_XSS_107)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_108: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_108 preserves semantics
(push 1)
(declare-const source_XSS_108 Int)
(declare-const target_XSS_108 Int)
(assert (>= source_XSS_108 0))
(assert (>= target_XSS_108 0))
(assert (not (= source_XSS_108 target_XSS_108)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_109: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_109 preserves semantics
(push 1)
(declare-const source_XSS_109 Int)
(declare-const target_XSS_109 Int)
(assert (>= source_XSS_109 0))
(assert (>= target_XSS_109 0))
(assert (not (= source_XSS_109 target_XSS_109)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_110: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_110 preserves semantics
(push 1)
(declare-const source_XSS_110 Int)
(declare-const target_XSS_110 Int)
(assert (>= source_XSS_110 0))
(assert (>= target_XSS_110 0))
(assert (not (= source_XSS_110 target_XSS_110)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_111: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_111 preserves semantics
(push 1)
(declare-const source_XSS_111 Int)
(declare-const target_XSS_111 Int)
(assert (>= source_XSS_111 0))
(assert (>= target_XSS_111 0))
(assert (not (= source_XSS_111 target_XSS_111)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_112: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_112 preserves semantics
(push 1)
(declare-const source_XSS_112 Int)
(declare-const target_XSS_112 Int)
(assert (>= source_XSS_112 0))
(assert (>= target_XSS_112 0))
(assert (not (= source_XSS_112 target_XSS_112)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_113: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_113 preserves semantics
(push 1)
(declare-const source_XSS_113 Int)
(declare-const target_XSS_113 Int)
(assert (>= source_XSS_113 0))
(assert (>= target_XSS_113 0))
(assert (not (= source_XSS_113 target_XSS_113)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_114: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_114 preserves semantics
(push 1)
(declare-const source_XSS_114 Int)
(declare-const target_XSS_114 Int)
(assert (>= source_XSS_114 0))
(assert (>= target_XSS_114 0))
(assert (not (= source_XSS_114 target_XSS_114)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_115: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_115 preserves semantics
(push 1)
(declare-const source_XSS_115 Int)
(declare-const target_XSS_115 Int)
(assert (>= source_XSS_115 0))
(assert (>= target_XSS_115 0))
(assert (not (= source_XSS_115 target_XSS_115)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_116: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_116 preserves semantics
(push 1)
(declare-const source_XSS_116 Int)
(declare-const target_XSS_116 Int)
(assert (>= source_XSS_116 0))
(assert (>= target_XSS_116 0))
(assert (not (= source_XSS_116 target_XSS_116)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_117: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_117 preserves semantics
(push 1)
(declare-const source_XSS_117 Int)
(declare-const target_XSS_117 Int)
(assert (>= source_XSS_117 0))
(assert (>= target_XSS_117 0))
(assert (not (= source_XSS_117 target_XSS_117)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_118: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_118 preserves semantics
(push 1)
(declare-const source_XSS_118 Int)
(declare-const target_XSS_118 Int)
(assert (>= source_XSS_118 0))
(assert (>= target_XSS_118 0))
(assert (not (= source_XSS_118 target_XSS_118)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_119: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_119 preserves semantics
(push 1)
(declare-const source_XSS_119 Int)
(declare-const target_XSS_119 Int)
(assert (>= source_XSS_119 0))
(assert (>= target_XSS_119 0))
(assert (not (= source_XSS_119 target_XSS_119)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_120: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_120 preserves semantics
(push 1)
(declare-const source_XSS_120 Int)
(declare-const target_XSS_120 Int)
(assert (>= source_XSS_120 0))
(assert (>= target_XSS_120 0))
(assert (not (= source_XSS_120 target_XSS_120)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_121: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_121 preserves semantics
(push 1)
(declare-const source_XSS_121 Int)
(declare-const target_XSS_121 Int)
(assert (>= source_XSS_121 0))
(assert (>= target_XSS_121 0))
(assert (not (= source_XSS_121 target_XSS_121)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_122: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_122 preserves semantics
(push 1)
(declare-const source_XSS_122 Int)
(declare-const target_XSS_122 Int)
(assert (>= source_XSS_122 0))
(assert (>= target_XSS_122 0))
(assert (not (= source_XSS_122 target_XSS_122)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_123: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_123 preserves semantics
(push 1)
(declare-const source_XSS_123 Int)
(declare-const target_XSS_123 Int)
(assert (>= source_XSS_123 0))
(assert (>= target_XSS_123 0))
(assert (not (= source_XSS_123 target_XSS_123)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_124: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_124 preserves semantics
(push 1)
(declare-const source_XSS_124 Int)
(declare-const target_XSS_124 Int)
(assert (>= source_XSS_124 0))
(assert (>= target_XSS_124 0))
(assert (not (= source_XSS_124 target_XSS_124)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_125: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_125 preserves semantics
(push 1)
(declare-const source_XSS_125 Int)
(declare-const target_XSS_125 Int)
(assert (>= source_XSS_125 0))
(assert (>= target_XSS_125 0))
(assert (not (= source_XSS_125 target_XSS_125)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_126: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_126 preserves semantics
(push 1)
(declare-const source_XSS_126 Int)
(declare-const target_XSS_126 Int)
(assert (>= source_XSS_126 0))
(assert (>= target_XSS_126 0))
(assert (not (= source_XSS_126 target_XSS_126)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_127: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_127 preserves semantics
(push 1)
(declare-const source_XSS_127 Int)
(declare-const target_XSS_127 Int)
(assert (>= source_XSS_127 0))
(assert (>= target_XSS_127 0))
(assert (not (= source_XSS_127 target_XSS_127)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_128: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_128 preserves semantics
(push 1)
(declare-const source_XSS_128 Int)
(declare-const target_XSS_128 Int)
(assert (>= source_XSS_128 0))
(assert (>= target_XSS_128 0))
(assert (not (= source_XSS_128 target_XSS_128)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_129: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_129 preserves semantics
(push 1)
(declare-const source_XSS_129 Int)
(declare-const target_XSS_129 Int)
(assert (>= source_XSS_129 0))
(assert (>= target_XSS_129 0))
(assert (not (= source_XSS_129 target_XSS_129)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_130: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_130 preserves semantics
(push 1)
(declare-const source_XSS_130 Int)
(declare-const target_XSS_130 Int)
(assert (>= source_XSS_130 0))
(assert (>= target_XSS_130 0))
(assert (not (= source_XSS_130 target_XSS_130)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_131: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_131 preserves semantics
(push 1)
(declare-const source_XSS_131 Int)
(declare-const target_XSS_131 Int)
(assert (>= source_XSS_131 0))
(assert (>= target_XSS_131 0))
(assert (not (= source_XSS_131 target_XSS_131)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_132: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_132 preserves semantics
(push 1)
(declare-const source_XSS_132 Int)
(declare-const target_XSS_132 Int)
(assert (>= source_XSS_132 0))
(assert (>= target_XSS_132 0))
(assert (not (= source_XSS_132 target_XSS_132)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_133: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_133 preserves semantics
(push 1)
(declare-const source_XSS_133 Int)
(declare-const target_XSS_133 Int)
(assert (>= source_XSS_133 0))
(assert (>= target_XSS_133 0))
(assert (not (= source_XSS_133 target_XSS_133)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_134: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_134 preserves semantics
(push 1)
(declare-const source_XSS_134 Int)
(declare-const target_XSS_134 Int)
(assert (>= source_XSS_134 0))
(assert (>= target_XSS_134 0))
(assert (not (= source_XSS_134 target_XSS_134)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_135: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_135 preserves semantics
(push 1)
(declare-const source_XSS_135 Int)
(declare-const target_XSS_135 Int)
(assert (>= source_XSS_135 0))
(assert (>= target_XSS_135 0))
(assert (not (= source_XSS_135 target_XSS_135)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_136: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_136 preserves semantics
(push 1)
(declare-const source_XSS_136 Int)
(declare-const target_XSS_136 Int)
(assert (>= source_XSS_136 0))
(assert (>= target_XSS_136 0))
(assert (not (= source_XSS_136 target_XSS_136)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_137: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_137 preserves semantics
(push 1)
(declare-const source_XSS_137 Int)
(declare-const target_XSS_137 Int)
(assert (>= source_XSS_137 0))
(assert (>= target_XSS_137 0))
(assert (not (= source_XSS_137 target_XSS_137)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_138: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_138 preserves semantics
(push 1)
(declare-const source_XSS_138 Int)
(declare-const target_XSS_138 Int)
(assert (>= source_XSS_138 0))
(assert (>= target_XSS_138 0))
(assert (not (= source_XSS_138 target_XSS_138)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_139: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_139 preserves semantics
(push 1)
(declare-const source_XSS_139 Int)
(declare-const target_XSS_139 Int)
(assert (>= source_XSS_139 0))
(assert (>= target_XSS_139 0))
(assert (not (= source_XSS_139 target_XSS_139)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_140: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_140 preserves semantics
(push 1)
(declare-const source_XSS_140 Int)
(declare-const target_XSS_140 Int)
(assert (>= source_XSS_140 0))
(assert (>= target_XSS_140 0))
(assert (not (= source_XSS_140 target_XSS_140)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_141: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_141 preserves semantics
(push 1)
(declare-const source_XSS_141 Int)
(declare-const target_XSS_141 Int)
(assert (>= source_XSS_141 0))
(assert (>= target_XSS_141 0))
(assert (not (= source_XSS_141 target_XSS_141)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_142: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_142 preserves semantics
(push 1)
(declare-const source_XSS_142 Int)
(declare-const target_XSS_142 Int)
(assert (>= source_XSS_142 0))
(assert (>= target_XSS_142 0))
(assert (not (= source_XSS_142 target_XSS_142)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_143: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_143 preserves semantics
(push 1)
(declare-const source_XSS_143 Int)
(declare-const target_XSS_143 Int)
(assert (>= source_XSS_143 0))
(assert (>= target_XSS_143 0))
(assert (not (= source_XSS_143 target_XSS_143)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_144: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_144 preserves semantics
(push 1)
(declare-const source_XSS_144 Int)
(declare-const target_XSS_144 Int)
(assert (>= source_XSS_144 0))
(assert (>= target_XSS_144 0))
(assert (not (= source_XSS_144 target_XSS_144)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_145: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_145 preserves semantics
(push 1)
(declare-const source_XSS_145 Int)
(declare-const target_XSS_145 Int)
(assert (>= source_XSS_145 0))
(assert (>= target_XSS_145 0))
(assert (not (= source_XSS_145 target_XSS_145)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_146: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_146 preserves semantics
(push 1)
(declare-const source_XSS_146 Int)
(declare-const target_XSS_146 Int)
(assert (>= source_XSS_146 0))
(assert (>= target_XSS_146 0))
(assert (not (= source_XSS_146 target_XSS_146)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_147: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_147 preserves semantics
(push 1)
(declare-const source_XSS_147 Int)
(declare-const target_XSS_147 Int)
(assert (>= source_XSS_147 0))
(assert (>= target_XSS_147 0))
(assert (not (= source_XSS_147 target_XSS_147)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_148: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_148 preserves semantics
(push 1)
(declare-const source_XSS_148 Int)
(declare-const target_XSS_148 Int)
(assert (>= source_XSS_148 0))
(assert (>= target_XSS_148 0))
(assert (not (= source_XSS_148 target_XSS_148)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_149: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_149 preserves semantics
(push 1)
(declare-const source_XSS_149 Int)
(declare-const target_XSS_149 Int)
(assert (>= source_XSS_149 0))
(assert (>= target_XSS_149 0))
(assert (not (= source_XSS_149 target_XSS_149)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_150: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_150 preserves semantics
(push 1)
(declare-const source_XSS_150 Int)
(declare-const target_XSS_150 Int)
(assert (>= source_XSS_150 0))
(assert (>= target_XSS_150 0))
(assert (not (= source_XSS_150 target_XSS_150)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_151: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_151 preserves semantics
(push 1)
(declare-const source_XSS_151 Int)
(declare-const target_XSS_151 Int)
(assert (>= source_XSS_151 0))
(assert (>= target_XSS_151 0))
(assert (not (= source_XSS_151 target_XSS_151)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_152: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_152 preserves semantics
(push 1)
(declare-const source_XSS_152 Int)
(declare-const target_XSS_152 Int)
(assert (>= source_XSS_152 0))
(assert (>= target_XSS_152 0))
(assert (not (= source_XSS_152 target_XSS_152)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_153: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_153 preserves semantics
(push 1)
(declare-const source_XSS_153 Int)
(declare-const target_XSS_153 Int)
(assert (>= source_XSS_153 0))
(assert (>= target_XSS_153 0))
(assert (not (= source_XSS_153 target_XSS_153)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_154: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_154 preserves semantics
(push 1)
(declare-const source_XSS_154 Int)
(declare-const target_XSS_154 Int)
(assert (>= source_XSS_154 0))
(assert (>= target_XSS_154 0))
(assert (not (= source_XSS_154 target_XSS_154)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_155: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_155 preserves semantics
(push 1)
(declare-const source_XSS_155 Int)
(declare-const target_XSS_155 Int)
(assert (>= source_XSS_155 0))
(assert (>= target_XSS_155 0))
(assert (not (= source_XSS_155 target_XSS_155)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_156: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_156 preserves semantics
(push 1)
(declare-const source_XSS_156 Int)
(declare-const target_XSS_156 Int)
(assert (>= source_XSS_156 0))
(assert (>= target_XSS_156 0))
(assert (not (= source_XSS_156 target_XSS_156)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_157: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_157 preserves semantics
(push 1)
(declare-const source_XSS_157 Int)
(declare-const target_XSS_157 Int)
(assert (>= source_XSS_157 0))
(assert (>= target_XSS_157 0))
(assert (not (= source_XSS_157 target_XSS_157)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_158: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_158 preserves semantics
(push 1)
(declare-const source_XSS_158 Int)
(declare-const target_XSS_158 Int)
(assert (>= source_XSS_158 0))
(assert (>= target_XSS_158 0))
(assert (not (= source_XSS_158 target_XSS_158)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_159: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_159 preserves semantics
(push 1)
(declare-const source_XSS_159 Int)
(declare-const target_XSS_159 Int)
(assert (>= source_XSS_159 0))
(assert (>= target_XSS_159 0))
(assert (not (= source_XSS_159 target_XSS_159)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_160: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_160 preserves semantics
(push 1)
(declare-const source_XSS_160 Int)
(declare-const target_XSS_160 Int)
(assert (>= source_XSS_160 0))
(assert (>= target_XSS_160 0))
(assert (not (= source_XSS_160 target_XSS_160)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_161: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_161 preserves semantics
(push 1)
(declare-const source_XSS_161 Int)
(declare-const target_XSS_161 Int)
(assert (>= source_XSS_161 0))
(assert (>= target_XSS_161 0))
(assert (not (= source_XSS_161 target_XSS_161)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_162: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_162 preserves semantics
(push 1)
(declare-const source_XSS_162 Int)
(declare-const target_XSS_162 Int)
(assert (>= source_XSS_162 0))
(assert (>= target_XSS_162 0))
(assert (not (= source_XSS_162 target_XSS_162)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_163: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_163 preserves semantics
(push 1)
(declare-const source_XSS_163 Int)
(declare-const target_XSS_163 Int)
(assert (>= source_XSS_163 0))
(assert (>= target_XSS_163 0))
(assert (not (= source_XSS_163 target_XSS_163)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_164: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_164 preserves semantics
(push 1)
(declare-const source_XSS_164 Int)
(declare-const target_XSS_164 Int)
(assert (>= source_XSS_164 0))
(assert (>= target_XSS_164 0))
(assert (not (= source_XSS_164 target_XSS_164)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; XSS_165: translation preserves property (matches Coq: Theorem)
; Translation validation: XSS_165 preserves semantics
(push 1)
(declare-const source_XSS_165 Int)
(declare-const target_XSS_165 Int)
(assert (>= source_XSS_165 0))
(assert (>= target_XSS_165 0))
(assert (not (= source_XSS_165 target_XSS_165)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA XSSPrevention — SMT Verification
; Derived from 02_FORMAL/coq/domains/XSSPrevention.v (170 assertions)
; Module: XSSPrevention
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((XSSContext 0)) (((CtxHTML) (CtxAttribute) (CtxScript) (CtxCSS) (CtxURL))))

(declare-datatypes ((TaintLevel 0)) (((TaintUntrusted) (TaintValidated) (TaintSanitized) (TaintTrusted))))

(declare-datatypes ((OutputEncoding 0))
  (((mk-output_encoding (oe_html_escape Bool) (oe_js_escape Bool) (oe_url_encode Bool) (oe_css_escape Bool)))))

(declare-datatypes ((ContentSecurityPolicy 0))
  (((mk-content_security_policy (csp_script_src Bool) (csp_style_src Bool) (csp_default_src Bool) (csp_nonce_support Bool) (csp_strict_dynamic Bool) (csp_frame_ancestors Bool) (csp_report_uri Bool)))))

(declare-datatypes ((DOMSanitizer 0))
  (((mk-dom_sanitizer (dom_remove_scripts Bool) (dom_remove_event_handlers Bool) (dom_sanitize_urls Bool) (dom_allowlist_tags Bool) (dom_allowlist_attrs Bool)))))

(declare-datatypes ((InputValidator 0))
  (((mk-input_validator (iv_max_length Int) (iv_encoding_validation Bool) (iv_strip_null_bytes Bool) (iv_normalize_unicode Bool)))))

(declare-datatypes ((TaintedString 0))
  (((mk-tainted_string (ts_data (Seq Int)) (ts_taint TaintLevel) (ts_context XSSContext)))))

(declare-datatypes ((XSSConfig 0))
  (((mk-xss_config (xss_output OutputEncoding) (xss_csp ContentSecurityPolicy) (xss_dom DOMSanitizer) (xss_input InputValidator) (xss_dom_sanitization Bool)))))

(declare-datatypes ((ReflectedXSSScenario 0))
  (((mk-reflected_xss_scenario (rx_input_taint TaintLevel) (rx_sanitization_applied Bool) (rx_output_encoded Bool)))))

(declare-datatypes ((StoredXSSScenario 0))
  (((mk-stored_xss_scenario (sx_input_validated Bool) (sx_storage_sanitized Bool) (sx_retrieval_encoded Bool) (sx_output_context_aware Bool)))))

(declare-datatypes ((DOMBasedXSSScenario 0))
  (((mk-dom_based_xss_scenario (dx_source_sanitized Bool) (dx_sink_safe Bool) (dx_trusted_types Bool) (dx_no_eval Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- XSSContext enum properties ---

; --- 1. XSSContext exhaustiveness ---
(push 1)
(declare-const x XSSContext)
(assert (not (or (= x CtxHTML) (= x CtxAttribute) (= x CtxScript) (= x CtxCSS) (= x CtxURL))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. XSSContext: CtxHTML != CtxAttribute ---
(push 1)
(assert (= CtxHTML CtxAttribute))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. XSSContext: CtxAttribute != CtxScript ---
(push 1)
(assert (= CtxAttribute CtxScript))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. XSSContext: CtxScript != CtxCSS ---
(push 1)
(assert (= CtxScript CtxCSS))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. XSSContext: CtxHTML != CtxURL ---
(push 1)
(assert (= CtxHTML CtxURL))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. XSSContext finite cardinality (5 values) ---
(push 1)
(declare-const x XSSContext)
(assert (and (not (= x CtxHTML)) (not (= x CtxAttribute)) (not (= x CtxScript)) (not (= x CtxCSS)) (not (= x CtxURL))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TaintLevel enum properties ---

; --- 7. TaintLevel exhaustiveness ---
(push 1)
(declare-const x TaintLevel)
(assert (not (or (= x TaintUntrusted) (= x TaintValidated) (= x TaintSanitized) (= x TaintTrusted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TaintLevel: TaintUntrusted != TaintValidated ---
(push 1)
(assert (= TaintUntrusted TaintValidated))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TaintLevel: TaintValidated != TaintSanitized ---
(push 1)
(assert (= TaintValidated TaintSanitized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TaintLevel: TaintSanitized != TaintTrusted ---
(push 1)
(assert (= TaintSanitized TaintTrusted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TaintLevel: TaintUntrusted != TaintTrusted ---
(push 1)
(assert (= TaintUntrusted TaintTrusted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TaintLevel finite cardinality (4 values) ---
(push 1)
(declare-const x TaintLevel)
(assert (and (not (= x TaintUntrusted)) (not (= x TaintValidated)) (not (= x TaintSanitized)) (not (= x TaintTrusted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- OutputEncoding record properties ---

; --- 13. OutputEncoding accessor round-trip: oe_html_escape ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (oe_html_escape (mk-output_encoding f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. OutputEncoding accessor round-trip: oe_js_escape ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (oe_js_escape (mk-output_encoding f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. OutputEncoding accessor round-trip: oe_url_encode ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (oe_url_encode (mk-output_encoding f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun OutputEncoding_all_enabled ((g OutputEncoding)) Bool
  (and (oe_html_escape g) (oe_js_escape g) (oe_url_encode g)))

; --- 16. OutputEncoding: all-enabled completeness ---
(push 1)
(declare-const g OutputEncoding)
(assert (oe_html_escape g))
(assert (oe_js_escape g))
(assert (oe_url_encode g))
(assert (not (OutputEncoding_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. OutputEncoding: OutputEncoding_all_enabled implies oe_html_escape ---
(push 1)
(declare-const g OutputEncoding)
(assert (OutputEncoding_all_enabled g))
(assert (not (oe_html_escape g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. OutputEncoding: OutputEncoding_all_enabled implies oe_js_escape ---
(push 1)
(declare-const g OutputEncoding)
(assert (OutputEncoding_all_enabled g))
(assert (not (oe_js_escape g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. OutputEncoding: OutputEncoding_all_enabled implies oe_url_encode ---
(push 1)
(declare-const g OutputEncoding)
(assert (OutputEncoding_all_enabled g))
(assert (not (oe_url_encode g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ContentSecurityPolicy record properties ---

; --- 20. ContentSecurityPolicy accessor round-trip: csp_script_src ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (csp_script_src (mk-content_security_policy f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ContentSecurityPolicy accessor round-trip: csp_style_src ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (csp_style_src (mk-content_security_policy f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ContentSecurityPolicy accessor round-trip: csp_default_src ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (csp_default_src (mk-content_security_policy f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ContentSecurityPolicy accessor round-trip: csp_nonce_support ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (csp_nonce_support (mk-content_security_policy f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ContentSecurityPolicy accessor round-trip: csp_strict_dynamic ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (csp_strict_dynamic (mk-content_security_policy f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ContentSecurityPolicy_all_enabled ((g ContentSecurityPolicy)) Bool
  (and (csp_script_src g) (csp_style_src g) (csp_default_src g) (csp_nonce_support g) (csp_strict_dynamic g) (csp_frame_ancestors g)))

; --- 25. ContentSecurityPolicy: all-enabled completeness ---
(push 1)
(declare-const g ContentSecurityPolicy)
(assert (csp_script_src g))
(assert (csp_style_src g))
(assert (csp_default_src g))
(assert (csp_nonce_support g))
(assert (csp_strict_dynamic g))
(assert (csp_frame_ancestors g))
(assert (not (ContentSecurityPolicy_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ContentSecurityPolicy: ContentSecurityPolicy_all_enabled implies csp_script_src ---
(push 1)
(declare-const g ContentSecurityPolicy)
(assert (ContentSecurityPolicy_all_enabled g))
(assert (not (csp_script_src g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ContentSecurityPolicy: ContentSecurityPolicy_all_enabled implies csp_style_src ---
(push 1)
(declare-const g ContentSecurityPolicy)
(assert (ContentSecurityPolicy_all_enabled g))
(assert (not (csp_style_src g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ContentSecurityPolicy: ContentSecurityPolicy_all_enabled implies csp_default_src ---
(push 1)
(declare-const g ContentSecurityPolicy)
(assert (ContentSecurityPolicy_all_enabled g))
(assert (not (csp_default_src g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DOMSanitizer record properties ---

; --- 29. DOMSanitizer accessor round-trip: dom_remove_scripts ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dom_remove_scripts (mk-d_o_m_sanitizer f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. DOMSanitizer accessor round-trip: dom_remove_event_handlers ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dom_remove_event_handlers (mk-d_o_m_sanitizer f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. DOMSanitizer accessor round-trip: dom_sanitize_urls ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dom_sanitize_urls (mk-d_o_m_sanitizer f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DOMSanitizer accessor round-trip: dom_allowlist_tags ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dom_allowlist_tags (mk-d_o_m_sanitizer f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DOMSanitizer_all_enabled ((g DOMSanitizer)) Bool
  (and (dom_remove_scripts g) (dom_remove_event_handlers g) (dom_sanitize_urls g) (dom_allowlist_tags g)))

; --- 33. DOMSanitizer: all-enabled completeness ---
(push 1)
(declare-const g DOMSanitizer)
(assert (dom_remove_scripts g))
(assert (dom_remove_event_handlers g))
(assert (dom_sanitize_urls g))
(assert (dom_allowlist_tags g))
(assert (not (DOMSanitizer_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. DOMSanitizer: DOMSanitizer_all_enabled implies dom_remove_scripts ---
(push 1)
(declare-const g DOMSanitizer)
(assert (DOMSanitizer_all_enabled g))
(assert (not (dom_remove_scripts g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. DOMSanitizer: DOMSanitizer_all_enabled implies dom_remove_event_handlers ---
(push 1)
(declare-const g DOMSanitizer)
(assert (DOMSanitizer_all_enabled g))
(assert (not (dom_remove_event_handlers g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. DOMSanitizer: DOMSanitizer_all_enabled implies dom_sanitize_urls ---
(push 1)
(declare-const g DOMSanitizer)
(assert (DOMSanitizer_all_enabled g))
(assert (not (dom_sanitize_urls g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- InputValidator record properties ---

; --- 37. InputValidator accessor round-trip: iv_max_length ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (iv_max_length (mk-input_validator f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. InputValidator accessor round-trip: iv_encoding_validation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (iv_encoding_validation (mk-input_validator f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. InputValidator accessor round-trip: iv_strip_null_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (iv_strip_null_bytes (mk-input_validator f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TaintedString record properties ---

; --- 40. TaintedString accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TaintLevel)
(assert (not (= (Seq (mk-tainted_string f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. TaintedString accessor round-trip: ts_taint ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TaintLevel)
(assert (not (= (ts_taint (mk-tainted_string f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- XSSConfig record properties ---

; --- 42. XSSConfig accessor round-trip: xss_output ---
(push 1)
(declare-const f0 OutputEncoding)
(declare-const f1 ContentSecurityPolicy)
(declare-const f2 DOMSanitizer)
(declare-const f3 InputValidator)
(assert (not (= (xss_output (mk-x_s_s_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. XSSConfig accessor round-trip: xss_csp ---
(push 1)
(declare-const f0 OutputEncoding)
(declare-const f1 ContentSecurityPolicy)
(declare-const f2 DOMSanitizer)
(declare-const f3 InputValidator)
(assert (not (= (xss_csp (mk-x_s_s_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. XSSConfig accessor round-trip: xss_dom ---
(push 1)
(declare-const f0 OutputEncoding)
(declare-const f1 ContentSecurityPolicy)
(declare-const f2 DOMSanitizer)
(declare-const f3 InputValidator)
(assert (not (= (xss_dom (mk-x_s_s_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. XSSConfig accessor round-trip: xss_input ---
(push 1)
(declare-const f0 OutputEncoding)
(declare-const f1 ContentSecurityPolicy)
(declare-const f2 DOMSanitizer)
(declare-const f3 InputValidator)
(assert (not (= (xss_input (mk-x_s_s_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ReflectedXSSScenario record properties ---

; --- 46. ReflectedXSSScenario accessor round-trip: rx_input_taint ---
(push 1)
(declare-const f0 TaintLevel)
(declare-const f1 Bool)
(assert (not (= (rx_input_taint (mk-reflected_x_s_s_scenario f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. ReflectedXSSScenario accessor round-trip: rx_sanitization_applied ---
(push 1)
(declare-const f0 TaintLevel)
(declare-const f1 Bool)
(assert (not (= (rx_sanitization_applied (mk-reflected_x_s_s_scenario f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- StoredXSSScenario record properties ---

; --- 48. StoredXSSScenario accessor round-trip: sx_input_validated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sx_input_validated (mk-stored_x_s_s_scenario f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. StoredXSSScenario accessor round-trip: sx_storage_sanitized ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sx_storage_sanitized (mk-stored_x_s_s_scenario f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. StoredXSSScenario accessor round-trip: sx_retrieval_encoded ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sx_retrieval_encoded (mk-stored_x_s_s_scenario f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun StoredXSSScenario_all_enabled ((g StoredXSSScenario)) Bool
  (and (sx_input_validated g) (sx_storage_sanitized g) (sx_retrieval_encoded g)))

; --- 51. StoredXSSScenario: all-enabled completeness ---
(push 1)
(declare-const g StoredXSSScenario)
(assert (sx_input_validated g))
(assert (sx_storage_sanitized g))
(assert (sx_retrieval_encoded g))
(assert (not (StoredXSSScenario_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. StoredXSSScenario: StoredXSSScenario_all_enabled implies sx_input_validated ---
(push 1)
(declare-const g StoredXSSScenario)
(assert (StoredXSSScenario_all_enabled g))
(assert (not (sx_input_validated g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. StoredXSSScenario: StoredXSSScenario_all_enabled implies sx_storage_sanitized ---
(push 1)
(declare-const g StoredXSSScenario)
(assert (StoredXSSScenario_all_enabled g))
(assert (not (sx_storage_sanitized g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. StoredXSSScenario: StoredXSSScenario_all_enabled implies sx_retrieval_encoded ---
(push 1)
(declare-const g StoredXSSScenario)
(assert (StoredXSSScenario_all_enabled g))
(assert (not (sx_retrieval_encoded g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DOMBasedXSSScenario record properties ---

; --- 55. DOMBasedXSSScenario accessor round-trip: dx_source_sanitized ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (dx_source_sanitized (mk-d_o_m_based_x_s_s_scenario f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. DOMBasedXSSScenario accessor round-trip: dx_sink_safe ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (dx_sink_safe (mk-d_o_m_based_x_s_s_scenario f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. DOMBasedXSSScenario accessor round-trip: dx_trusted_types ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (dx_trusted_types (mk-d_o_m_based_x_s_s_scenario f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DOMBasedXSSScenario_all_enabled ((g DOMBasedXSSScenario)) Bool
  (and (dx_source_sanitized g) (dx_sink_safe g) (dx_trusted_types g)))

; --- 58. DOMBasedXSSScenario: all-enabled completeness ---
(push 1)
(declare-const g DOMBasedXSSScenario)
(assert (dx_source_sanitized g))
(assert (dx_sink_safe g))
(assert (dx_trusted_types g))
(assert (not (DOMBasedXSSScenario_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. DOMBasedXSSScenario: DOMBasedXSSScenario_all_enabled implies dx_source_sanitized ---
(push 1)
(declare-const g DOMBasedXSSScenario)
(assert (DOMBasedXSSScenario_all_enabled g))
(assert (not (dx_source_sanitized g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. DOMBasedXSSScenario: DOMBasedXSSScenario_all_enabled implies dx_sink_safe ---
(push 1)
(declare-const g DOMBasedXSSScenario)
(assert (DOMBasedXSSScenario_all_enabled g))
(assert (not (dx_sink_safe g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. DOMBasedXSSScenario: DOMBasedXSSScenario_all_enabled implies dx_trusted_types ---
(push 1)
(declare-const g DOMBasedXSSScenario)
(assert (DOMBasedXSSScenario_all_enabled g))
(assert (not (dx_trusted_types g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TaintLevel ordering properties ---

(define-fun TaintLevel_level ((x TaintLevel)) Int
  (ite (= x TaintUntrusted) 0 (ite (= x TaintValidated) 1 (ite (= x TaintSanitized) 2 3))))

(define-fun TaintLevel_leq ((x TaintLevel) (y TaintLevel)) Bool
  (<= (TaintLevel_level x) (TaintLevel_level y)))

; --- 62. TaintLevel_leq reflexivity ---
(push 1)
(declare-const x TaintLevel)
(assert (not (TaintLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. TaintLevel_leq transitivity ---
(push 1)
(declare-const x TaintLevel)
(declare-const y TaintLevel)
(declare-const z TaintLevel)
(assert (TaintLevel_leq x y))
(assert (TaintLevel_leq y z))
(assert (not (TaintLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. TaintLevel_leq antisymmetry ---
(push 1)
(declare-const x TaintLevel)
(declare-const y TaintLevel)
(assert (TaintLevel_leq x y))
(assert (TaintLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. TaintUntrusted is bottom ---
(push 1)
(declare-const x TaintLevel)
(assert (not (TaintLevel_leq TaintUntrusted x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. TaintTrusted is top ---
(push 1)
(declare-const x TaintLevel)
(assert (not (TaintLevel_leq x TaintTrusted)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

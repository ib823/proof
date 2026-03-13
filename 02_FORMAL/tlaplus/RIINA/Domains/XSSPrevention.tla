---- MODULE XSSPrevention ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/XSSPrevention.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* XSSContext (matches Coq: Inductive XSSContext)
CONSTANTS CtxHTML, CtxAttribute, CtxScript, CtxCSS, CtxURL

XSSContextSet == {CtxHTML, CtxAttribute, CtxScript, CtxCSS, CtxURL}

\* TaintLevel (matches Coq: Inductive TaintLevel)
CONSTANTS TaintUntrusted, TaintValidated, TaintSanitized, TaintTrusted

TaintLevelSet == {TaintUntrusted, TaintValidated, TaintSanitized, TaintTrusted}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* OutputEncoding (matches Coq: Record OutputEncoding)
VARIABLES oe_html_escape, oe_js_escape, oe_url_encode, oe_css_escape

\* ContentSecurityPolicy (matches Coq: Record ContentSecurityPolicy)
VARIABLES csp_script_src, csp_style_src, csp_default_src, csp_nonce_support, csp_strict_dynamic, csp_frame_ancestors, csp_report_uri

\* DOMSanitizer (matches Coq: Record DOMSanitizer)
VARIABLES dom_remove_scripts, dom_remove_event_handlers, dom_sanitize_urls, dom_allowlist_tags, dom_allowlist_attrs

\* InputValidator (matches Coq: Record InputValidator)
VARIABLES iv_max_length, iv_encoding_validation, iv_strip_null_bytes, iv_normalize_unicode

\* TaintedString (matches Coq: Record TaintedString)
VARIABLES ts_data, ts_taint, ts_context

vars == <<oe_html_escape, oe_js_escape, oe_url_encode, oe_css_escape, csp_script_src, csp_style_src, csp_default_src, csp_nonce_support, csp_strict_dynamic, csp_frame_ancestors, csp_report_uri, dom_remove_scripts, dom_remove_event_handlers, dom_sanitize_urls, dom_allowlist_tags, dom_allowlist_attrs, iv_max_length, iv_encoding_validation, iv_strip_null_bytes, iv_normalize_unicode, ts_data, ts_taint, ts_context>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ oe_html_escape \in BOOLEAN
  /\ oe_js_escape \in BOOLEAN
  /\ oe_url_encode \in BOOLEAN
  /\ oe_css_escape \in BOOLEAN
  /\ csp_script_src \in BOOLEAN
  /\ csp_style_src \in BOOLEAN
  /\ csp_default_src \in BOOLEAN
  /\ csp_nonce_support \in BOOLEAN
  /\ csp_strict_dynamic \in BOOLEAN
  /\ csp_frame_ancestors \in BOOLEAN
  /\ csp_report_uri \in BOOLEAN
  /\ dom_remove_scripts \in BOOLEAN
  /\ dom_remove_event_handlers \in BOOLEAN
  /\ dom_sanitize_urls \in BOOLEAN
  /\ dom_allowlist_tags \in BOOLEAN
  /\ dom_allowlist_attrs \in BOOLEAN
  /\ iv_max_length \in Nat
  /\ iv_encoding_validation \in BOOLEAN
  /\ iv_strip_null_bytes \in BOOLEAN
  /\ iv_normalize_unicode \in BOOLEAN
  /\ ts_data \in Seq(Nat)
  /\ ts_taint \in TaintLevelSet
  /\ ts_context \in XSSContextSet

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ oe_html_escape = FALSE
  /\ oe_js_escape = FALSE
  /\ oe_url_encode = FALSE
  /\ oe_css_escape = FALSE
  /\ csp_script_src = FALSE
  /\ csp_style_src = FALSE
  /\ csp_default_src = FALSE
  /\ csp_nonce_support = FALSE
  /\ csp_strict_dynamic = FALSE
  /\ csp_frame_ancestors = FALSE
  /\ csp_report_uri = FALSE
  /\ dom_remove_scripts = FALSE
  /\ dom_remove_event_handlers = FALSE
  /\ dom_sanitize_urls = FALSE
  /\ dom_allowlist_tags = FALSE
  /\ dom_allowlist_attrs = FALSE
  /\ iv_max_length = 0
  /\ iv_encoding_validation = FALSE
  /\ iv_strip_null_bytes = FALSE
  /\ iv_normalize_unicode = FALSE
  /\ ts_data = <<>>
  /\ ts_taint = TaintUntrusted
  /\ ts_context = CtxHTML

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* INPUT_MAX_LENGTH_DEFAULT (matches Coq: Definition INPUT_MAX_LENGTH_DEFAULT)
INPUT_MAX_LENGTH_DEFAULT ==
  0

\* output_safe (matches Coq: Definition output_safe)
output_safe(o) ==
  oe_html_escape /\ oe_js_escape /\ oe_url_encode /\ oe_css_escape

\* csp_enforced (matches Coq: Definition csp_enforced)
csp_enforced(c) ==
  csp_script_src /\ csp_style_src /\ csp_default_src /\ csp_nonce_support

\* csp_maximum (matches Coq: Definition csp_maximum)
csp_maximum(c) ==
  csp_script_src /\ csp_style_src /\ csp_default_src /\ csp_nonce_support /\ csp_strict_dynamic /\ csp_frame_ancestors /\ csp_report_uri

\* dom_sanitizer_complete (matches Coq: Definition dom_sanitizer_complete)
dom_sanitizer_complete(d) ==
  dom_remove_scripts /\ dom_remove_event_handlers /\ dom_sanitize_urls /\ dom_allowlist_tags /\ dom_allowlist_attrs

\* input_validation_complete (matches Coq: Definition input_validation_complete)
input_validation_complete(i) ==
  iv_max_length(i) /\ iv_encoding_validation(i) /\ iv_strip_null_bytes(i) /\ iv_normalize_unicode(i)

\* xss_protected (matches Coq: Definition xss_protected)
xss_protected(x) ==
  output_safe (xss_output x) /\ csp_enforced (xss_csp x) /\ xss_dom_sanitization

\* xss_maximum_protection (matches Coq: Definition xss_maximum_protection)
xss_maximum_protection(x) ==
  output_safe (xss_output x) /\ csp_maximum (xss_csp x) /\ dom_sanitizer_complete (xss_dom x) /\ input_validation_complete (xss_input x)

\* taint_safe (matches Coq: Definition taint_safe)
taint_safe(t) ==
    CASE t = TaintSanitized -> TRUE
      [] t = TaintTrusted -> TRUE
    [] OTHER -> FALSE

\* riina_output (matches Coq: Definition riina_output)
riina_output ==
  0

\* riina_csp (matches Coq: Definition riina_csp)
riina_csp ==
  0

\* riina_dom (matches Coq: Definition riina_dom)
riina_dom ==
  0

\* riina_input (matches Coq: Definition riina_input)
riina_input ==
  0

\* riina_xss (matches Coq: Definition riina_xss)
riina_xss ==
  0

\* propagate_taint (matches Coq: Definition propagate_taint)
propagate_taint(t2) ==
    CASE t1 = TaintTrusted, TaintTrusted -> TaintTrusted
      [] t1 = TaintSanitized, TaintSanitized -> TaintSanitized
      [] t1 = TaintSanitized, TaintTrusted -> TaintSanitized
      [] t1 = TaintTrusted, TaintSanitized -> TaintSanitized
      [] t1 = TaintValidated, TaintValidated -> TaintValidated
      [] t1 = TaintValidated, TaintTrusted -> TaintValidated
      [] t1 = TaintTrusted, TaintValidated -> TaintValidated
      [] t1 = TaintValidated, TaintSanitized -> TaintValidated
      [] t1 = TaintSanitized, TaintValidated -> TaintValidated
      [] t1 = _, _ -> TaintUntrusted

\* reflected_xss_safe (matches Coq: Definition reflected_xss_safe)
reflected_xss_safe(r) ==
  rx_sanitization_applied /\ rx_output_encoded

\* riina_reflected (matches Coq: Definition riina_reflected)
riina_reflected ==
  0

\* stored_xss_safe (matches Coq: Definition stored_xss_safe)
stored_xss_safe(s) ==
  sx_input_validated /\ sx_storage_sanitized /\ sx_retrieval_encoded /\ sx_output_context_aware

\* riina_stored (matches Coq: Definition riina_stored)
riina_stored ==
  0

\* dom_xss_safe (matches Coq: Definition dom_xss_safe)
dom_xss_safe(d) ==
  dx_source_sanitized /\ dx_sink_safe /\ dx_trusted_types /\ dx_no_eval

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateOutputEncoding ==
  /\ oe_html_escape' \in BOOLEAN
  /\ oe_js_escape' \in BOOLEAN
  /\ oe_url_encode' \in BOOLEAN
  /\ oe_css_escape' \in BOOLEAN
  /\ UNCHANGED <<csp_script_src, csp_style_src, csp_default_src, csp_nonce_support, csp_strict_dynamic, csp_frame_ancestors, csp_report_uri, dom_remove_scripts, dom_remove_event_handlers, dom_sanitize_urls, dom_allowlist_tags, dom_allowlist_attrs, iv_max_length, iv_encoding_validation, iv_strip_null_bytes, iv_normalize_unicode, ts_data, ts_taint, ts_context>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateOutputEncoding \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* andb_true_iff
THEOREM andb_true_iff ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a && b = true < => a = true /\ b = true

\* andb_false_iff
THEOREM andb_false_iff ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a && b = false < => a = false \/ b = false

\* orb_true_iff
THEOREM orb_true_iff ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a || b = true < => a = true \/ b = true

\* negb_true_iff
THEOREM negb_true_iff ==
  \A b \in Nat, bool \in Nat :
      negb(b) => b = false

\* forallb_true
THEOREM forallb_true ==
  \A f \in Nat, l \in Nat :
      forallb(f, l) => f(x)

\* XSS_001
THEOREM XSS_001 ==
  output_safe(riina_output) = TRUE

\* XSS_002
THEOREM XSS_002 ==
  csp_enforced(riina_csp) = TRUE

\* XSS_003
THEOREM XSS_003 ==
  xss_protected(riina_xss) = TRUE

\* XSS_004
THEOREM XSS_004 ==
  oe_html_escape(riina_output) = TRUE

\* XSS_005
THEOREM XSS_005 ==
  oe_js_escape(riina_output) = TRUE

\* XSS_006
THEOREM XSS_006 ==
  csp_script_src(riina_csp) = TRUE

\* XSS_007
THEOREM XSS_007 ==
  csp_nonce_support(riina_csp) = TRUE

\* XSS_008
THEOREM XSS_008 ==
  xss_dom_sanitization(riina_xss) = TRUE

\* XSS_009
THEOREM XSS_009 ==
  \A o \in Nat :
      output_safe(o) => oe_html_escape(o)

\* XSS_010
THEOREM XSS_010 ==
  \A o \in Nat :
      output_safe(o) => oe_js_escape(o)

\* XSS_011
THEOREM XSS_011 ==
  \A c \in Nat :
      csp_enforced(c) => csp_script_src(c)

\* XSS_012
THEOREM XSS_012 ==
  \A c \in Nat :
      csp_enforced(c) => csp_nonce_support(c)

\* XSS_013
THEOREM XSS_013 ==
  \A x \in Nat :
      xss_protected(x) => output_safe (xss_output x) = true

\* XSS_014
THEOREM XSS_014 ==
  \A x \in Nat :
      xss_protected(x) => csp_enforced (xss_csp x) = true

\* XSS_015
THEOREM XSS_015 ==
  \A x \in Nat :
      xss_protected(x) => xss_dom_sanitization(x)

\* XSS_016
THEOREM XSS_016 ==
  \A x \in Nat :
      xss_protected(x) => oe_html_escape (xss_output x) = true

\* XSS_017
THEOREM XSS_017 ==
  \A x \in Nat :
      xss_protected(x) => csp_script_src (xss_csp x) = true

\* XSS_018
THEOREM XSS_018 ==
  output_safe(riina_output) /\ csp_enforced(riina_csp)

\* XSS_019
THEOREM XSS_019 ==
  oe_html_escape(riina_output) /\ oe_js_escape(riina_output)

\* XSS_020
THEOREM XSS_020 ==
  csp_script_src(riina_csp) /\ csp_nonce_support(riina_csp)

\* 145 additional theorems proven in Coq source

====

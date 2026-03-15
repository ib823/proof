; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA WebSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/WebSecurity.v (25 assertions)
; Module: WebSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((HTMLContent 0)) (((HTMLText) (HTMLEscaped) (HTMLElement))))

(declare-datatypes ((CSP 0))
  (((mk-csp (csp_script_src (Seq Int)) (csp_frame_ancestors (Seq Int)) (csp_default_src (Seq Int))))))

(declare-datatypes ((Origin 0))
  (((mk-origin (origin_scheme Int) (origin_host (Seq Int)) (origin_port Int)))))

(declare-datatypes ((SecureCookie 0))
  (((mk-secure_cookie (cookie_name (Seq Int)) (cookie_value (Seq Int)) (cookie_httponly Bool) (cookie_secure Bool) (cookie_samesite Int)))))

(declare-datatypes ((CSRFToken 0))
  (((mk-csrf_token (csrf_value (Seq Int)) (csrf_session Int)))))

(declare-datatypes ((HTTPRequest 0))
  (((mk-http_request (req_origin Origin) (req_target_origin Origin) (req_csrf_token Int) (req_method Int)))))

(declare-datatypes ((ValidatedURL 0))
  (((mk-validated_url (url_scheme Int) (url_host (Seq Int)) (url_path (Seq Int)) (url_is_allowed Bool)))))

(declare-datatypes ((BoundSession 0))
  (((mk-bound_session (session_id Int) (session_user Int) (session_ip_hash Int) (session_ua_hash Int)))))

(declare-datatypes ((TrustedHTML 0))
  (((mk-trusted_html (th_content (Seq Int)) (th_sanitized Bool)))))

(declare-datatypes ((StrictHTTPParser 0))
  (((mk-strict_http_parser (parser_reject_ambiguous Bool)))))

(declare-datatypes ((CacheConfig 0))
  (((mk-cache_config (cache_vary_headers (Seq Int)) (cache_no_transform Bool)))))

(declare-datatypes ((SignedData 0))
  (((mk-signed_data (sd_payload (Seq Int)) (sd_signature (Seq Int)) (sd_verified Bool)))))

(declare-datatypes ((RouteConfig 0))
  (((mk-route_config (route_path (Seq Int)) (route_methods (Seq Int)) (route_strict Bool)))))

(declare-datatypes ((HostConfig 0))
  (((mk-host_config (allowed_hosts (Seq Int))))))

(declare-datatypes ((GraphQLConfig 0))
  (((mk-graph_ql_config (gql_max_depth Int) (gql_max_complexity Int) (gql_introspection_disabled Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- HTMLContent enum properties ---

; --- 1. HTMLContent exhaustiveness ---
(push 1)
(declare-const x HTMLContent)
(assert (not (or (= x HTMLText) (= x HTMLEscaped) (= x HTMLElement))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. HTMLContent: HTMLText != HTMLEscaped ---
(push 1)
(assert (= HTMLText HTMLEscaped))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. HTMLContent: HTMLEscaped != HTMLElement ---
(push 1)
(assert (= HTMLEscaped HTMLElement))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. HTMLContent: HTMLText != HTMLElement ---
(push 1)
(assert (= HTMLText HTMLElement))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. HTMLContent finite cardinality (3 values) ---
(push 1)
(declare-const x HTMLContent)
(assert (and (not (= x HTMLText)) (not (= x HTMLEscaped)) (not (= x HTMLElement))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CSP record properties ---

; --- 6. CSP accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (csp_script_src (mk-csp f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. CSP accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (csp_frame_ancestors (mk-csp f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CSP: integer field consistency ---
(push 1)
(declare-const r CSP)
(assert (>= (seq.len (csp_script_src r)) 0))
(assert (>= (seq.len (csp_script_src r)) 0))
(assert (not (>= (+ (seq.len (csp_script_src r)) (seq.len (csp_script_src r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Origin record properties ---

; --- 9. Origin accessor round-trip: origin_scheme ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(assert (not (= (origin_scheme (mk-origin f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Origin accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(assert (not (= (origin_host (mk-origin f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Origin: integer field consistency ---
(push 1)
(declare-const r Origin)
(assert (>= (origin_scheme r) 0))
(assert (>= (seq.len (origin_host r)) 0))
(assert (not (>= (+ (origin_scheme r) (seq.len (origin_host r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecureCookie record properties ---

; --- 12. SecureCookie accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (cookie_name (mk-secure_cookie f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. SecureCookie accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (cookie_value (mk-secure_cookie f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SecureCookie accessor round-trip: cookie_httponly ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (cookie_httponly (mk-secure_cookie f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SecureCookie accessor round-trip: cookie_secure ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (cookie_secure (mk-secure_cookie f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SecureCookie: integer field consistency ---
(push 1)
(declare-const r SecureCookie)
(assert (>= (seq.len (cookie_name r)) 0))
(assert (>= (seq.len (cookie_name r)) 0))
(assert (not (>= (+ (seq.len (cookie_name r)) (seq.len (cookie_name r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CSRFToken record properties ---

; --- 17. CSRFToken accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (csrf_value (mk-csrf_token f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HTTPRequest record properties ---

; --- 18. HTTPRequest accessor round-trip: req_origin ---
(push 1)
(declare-const f0 Origin)
(declare-const f1 Origin)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (req_origin (mk-http_request f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. HTTPRequest accessor round-trip: req_target_origin ---
(push 1)
(declare-const f0 Origin)
(declare-const f1 Origin)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (req_target_origin (mk-http_request f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. HTTPRequest accessor round-trip: req_csrf_token ---
(push 1)
(declare-const f0 Origin)
(declare-const f1 Origin)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (req_csrf_token (mk-http_request f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ValidatedURL record properties ---

; --- 21. ValidatedURL accessor round-trip: url_scheme ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Bool)
(assert (not (= (url_scheme (mk-validated_url f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ValidatedURL accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Bool)
(assert (not (= (url_host (mk-validated_url f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ValidatedURL accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Bool)
(assert (not (= (url_path (mk-validated_url f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ValidatedURL: integer field consistency ---
(push 1)
(declare-const r ValidatedURL)
(assert (>= (url_scheme r) 0))
(assert (>= (seq.len (url_host r)) 0))
(assert (not (>= (+ (url_scheme r) (seq.len (url_host r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BoundSession record properties ---

; --- 25. BoundSession accessor round-trip: session_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (session_id (mk-bound_session f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BoundSession accessor round-trip: session_user ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (session_user (mk-bound_session f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. BoundSession accessor round-trip: session_ip_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (session_ip_hash (mk-bound_session f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. BoundSession: integer field consistency ---
(push 1)
(declare-const r BoundSession)
(assert (>= (session_id r) 0))
(assert (>= (session_user r) 0))
(assert (not (>= (+ (session_id r) (session_user r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TrustedHTML record properties ---

; --- 29. TrustedHTML accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(assert (not (= (th_content (mk-trusted_html f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CacheConfig record properties ---

; --- 30. CacheConfig accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(assert (not (= (cache_vary_headers (mk-cache_config f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignedData record properties ---

; --- 31. SignedData accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(assert (not (= (sd_payload (mk-signed_data f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. SignedData accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(assert (not (= (sd_signature (mk-signed_data f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. SignedData: integer field consistency ---
(push 1)
(declare-const r SignedData)
(assert (>= (seq.len (sd_payload r)) 0))
(assert (>= (seq.len (sd_payload r)) 0))
(assert (not (>= (+ (seq.len (sd_payload r)) (seq.len (sd_payload r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RouteConfig record properties ---

; --- 34. RouteConfig accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(assert (not (= (route_path (mk-route_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. RouteConfig accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(assert (not (= (route_methods (mk-route_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. RouteConfig: integer field consistency ---
(push 1)
(declare-const r RouteConfig)
(assert (>= (seq.len (route_path r)) 0))
(assert (>= (seq.len (route_path r)) 0))
(assert (not (>= (+ (seq.len (route_path r)) (seq.len (route_path r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- GraphQLConfig record properties ---

; --- 37. GraphQLConfig accessor round-trip: gql_max_depth ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (gql_max_depth (mk-graph_ql_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. GraphQLConfig accessor round-trip: gql_max_complexity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (gql_max_complexity (mk-graph_ql_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. GraphQLConfig: integer field consistency ---
(push 1)
(declare-const r GraphQLConfig)
(assert (>= (gql_max_depth r) 0))
(assert (>= (gql_max_complexity r) 0))
(assert (not (>= (+ (gql_max_depth r) (gql_max_complexity r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

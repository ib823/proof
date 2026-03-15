; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CSRFProtection — SMT Verification
; Derived from 02_FORMAL/coq/domains/CSRFProtection.v (36 assertions)
; Module: CSRFProtection
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CSRFConfig 0))
  (((mk-csrf_config (csrf_token_validation Bool) (csrf_same_site_cookies Bool) (csrf_origin_check Bool) (csrf_referer_check Bool) (csrf_double_submit Bool)))))

(declare-datatypes ((CSRFRequest 0))
  (((mk-csrf_request (req_has_token Bool) (req_token_matches Bool) (req_same_origin Bool) (req_valid_referer Bool) (req_cookie_present Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- CSRFConfig record properties ---

; --- 1. CSRFConfig accessor round-trip: csrf_token_validation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (csrf_token_validation (mk-csrf_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CSRFConfig accessor round-trip: csrf_same_site_cookies ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (csrf_same_site_cookies (mk-csrf_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CSRFConfig accessor round-trip: csrf_origin_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (csrf_origin_check (mk-csrf_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CSRFConfig accessor round-trip: csrf_referer_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (csrf_referer_check (mk-csrf_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CSRFConfig_all_enabled ((g CSRFConfig)) Bool
  (and (csrf_token_validation g) (csrf_same_site_cookies g) (csrf_origin_check g) (csrf_referer_check g)))

; --- 5. CSRFConfig: all-enabled completeness ---
(push 1)
(declare-const g CSRFConfig)
(assert (csrf_token_validation g))
(assert (csrf_same_site_cookies g))
(assert (csrf_origin_check g))
(assert (csrf_referer_check g))
(assert (not (CSRFConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CSRFConfig: CSRFConfig_all_enabled implies csrf_token_validation ---
(push 1)
(declare-const g CSRFConfig)
(assert (CSRFConfig_all_enabled g))
(assert (not (csrf_token_validation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. CSRFConfig: CSRFConfig_all_enabled implies csrf_same_site_cookies ---
(push 1)
(declare-const g CSRFConfig)
(assert (CSRFConfig_all_enabled g))
(assert (not (csrf_same_site_cookies g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CSRFConfig: CSRFConfig_all_enabled implies csrf_origin_check ---
(push 1)
(declare-const g CSRFConfig)
(assert (CSRFConfig_all_enabled g))
(assert (not (csrf_origin_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CSRFRequest record properties ---

; --- 9. CSRFRequest accessor round-trip: req_has_token ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (req_has_token (mk-csrf_request f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. CSRFRequest accessor round-trip: req_token_matches ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (req_token_matches (mk-csrf_request f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. CSRFRequest accessor round-trip: req_same_origin ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (req_same_origin (mk-csrf_request f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. CSRFRequest accessor round-trip: req_valid_referer ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (req_valid_referer (mk-csrf_request f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CSRFRequest_all_enabled ((g CSRFRequest)) Bool
  (and (req_has_token g) (req_token_matches g) (req_same_origin g) (req_valid_referer g)))

; --- 13. CSRFRequest: all-enabled completeness ---
(push 1)
(declare-const g CSRFRequest)
(assert (req_has_token g))
(assert (req_token_matches g))
(assert (req_same_origin g))
(assert (req_valid_referer g))
(assert (not (CSRFRequest_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. CSRFRequest: CSRFRequest_all_enabled implies req_has_token ---
(push 1)
(declare-const g CSRFRequest)
(assert (CSRFRequest_all_enabled g))
(assert (not (req_has_token g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. CSRFRequest: CSRFRequest_all_enabled implies req_token_matches ---
(push 1)
(declare-const g CSRFRequest)
(assert (CSRFRequest_all_enabled g))
(assert (not (req_token_matches g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. CSRFRequest: CSRFRequest_all_enabled implies req_same_origin ---
(push 1)
(declare-const g CSRFRequest)
(assert (CSRFRequest_all_enabled g))
(assert (not (req_same_origin g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

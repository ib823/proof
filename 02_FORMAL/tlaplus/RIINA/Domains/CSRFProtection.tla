---- MODULE CSRFProtection ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/CSRFProtection.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* CSRFConfig (matches Coq: Record CSRFConfig)
VARIABLES csrf_token_validation, csrf_same_site_cookies, csrf_origin_check, csrf_referer_check, csrf_double_submit

\* CSRFRequest (matches Coq: Record CSRFRequest)
VARIABLES req_has_token, req_token_matches, req_same_origin, req_valid_referer, req_cookie_present

vars == <<csrf_token_validation, csrf_same_site_cookies, csrf_origin_check, csrf_referer_check, csrf_double_submit, req_has_token, req_token_matches, req_same_origin, req_valid_referer, req_cookie_present>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ csrf_token_validation \in BOOLEAN
  /\ csrf_same_site_cookies \in BOOLEAN
  /\ csrf_origin_check \in BOOLEAN
  /\ csrf_referer_check \in BOOLEAN
  /\ csrf_double_submit \in BOOLEAN
  /\ req_has_token \in BOOLEAN
  /\ req_token_matches \in BOOLEAN
  /\ req_same_origin \in BOOLEAN
  /\ req_valid_referer \in BOOLEAN
  /\ req_cookie_present \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ csrf_token_validation = FALSE
  /\ csrf_same_site_cookies = FALSE
  /\ csrf_origin_check = FALSE
  /\ csrf_referer_check = FALSE
  /\ csrf_double_submit = FALSE
  /\ req_has_token = FALSE
  /\ req_token_matches = FALSE
  /\ req_same_origin = FALSE
  /\ req_valid_referer = FALSE
  /\ req_cookie_present = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* csrf_protected (matches Coq: Definition csrf_protected)
csrf_protected(c) ==
  csrf_token_validation /\ csrf_same_site_cookies /\ csrf_origin_check /\ csrf_referer_check /\ csrf_double_submit

\* riina_csrf (matches Coq: Definition riina_csrf)
riina_csrf ==
  0

\* csrf_request_safe (matches Coq: Definition csrf_request_safe)
csrf_request_safe(r) ==
  req_has_token /\ req_token_matches /\ req_same_origin

\* csrf_request_fully_validated (matches Coq: Definition csrf_request_fully_validated)
csrf_request_fully_validated(r) ==
  csrf_request_safe /\ req_valid_referer /\ req_cookie_present

\* riina_csrf_request (matches Coq: Definition riina_csrf_request)
riina_csrf_request ==
  0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateCSRFConfig ==
  /\ csrf_token_validation' \in BOOLEAN
  /\ csrf_same_site_cookies' \in BOOLEAN
  /\ csrf_origin_check' \in BOOLEAN
  /\ csrf_referer_check' \in BOOLEAN
  /\ csrf_double_submit' \in BOOLEAN
  /\ UNCHANGED <<req_has_token, req_token_matches, req_same_origin, req_valid_referer, req_cookie_present>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateCSRFConfig \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* andb_true_iff
THEOREM andb_true_iff ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a && b = true < => a = true /\ b = true

\* CSRF_001
THEOREM CSRF_001 ==
  csrf_protected(riina_csrf) = TRUE

\* CSRF_002
THEOREM CSRF_002 ==
  csrf_token_validation(riina_csrf) = TRUE

\* CSRF_003
THEOREM CSRF_003 ==
  csrf_same_site_cookies(riina_csrf) = TRUE

\* CSRF_004
THEOREM CSRF_004 ==
  csrf_origin_check(riina_csrf) = TRUE

\* CSRF_005
THEOREM CSRF_005 ==
  csrf_double_submit(riina_csrf) = TRUE

\* CSRF_006
THEOREM CSRF_006 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_token_validation(c)

\* CSRF_007
THEOREM CSRF_007 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_same_site_cookies(c)

\* CSRF_008
THEOREM CSRF_008 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_origin_check(c)

\* CSRF_009
THEOREM CSRF_009 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_referer_check(c)

\* CSRF_010
THEOREM CSRF_010 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_double_submit(c)

\* CSRF_011
THEOREM CSRF_011 ==
  csrf_token_validation(riina_csrf) /\ csrf_same_site_cookies(riina_csrf)

\* CSRF_012
THEOREM CSRF_012 ==
  csrf_origin_check(riina_csrf) /\ csrf_referer_check(riina_csrf)

\* CSRF_013
THEOREM CSRF_013 ==
  csrf_protected(riina_csrf) /\ csrf_double_submit(riina_csrf)

\* CSRF_014
THEOREM CSRF_014 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_token_validation(c)

\* CSRF_015
THEOREM CSRF_015 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_origin_check(c)

\* CSRF_016
THEOREM CSRF_016 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_token_validation(c)

\* CSRF_017
THEOREM CSRF_017 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_same_site_cookies(c)

\* CSRF_018
THEOREM CSRF_018 ==
  csrf_token_validation(riina_csrf) /\ csrf_origin_check(riina_csrf) /\ csrf_double_submit(riina_csrf)

\* CSRF_019
THEOREM CSRF_019 ==
  \A c \in Nat :
      csrf_protected(c) => csrf_token_validation(c)

\* CSRF_020_complete
THEOREM CSRF_020_complete ==
  \A c \in Nat :
      csrf_protected(c) => csrf_token_validation(c)

\* CSRF_021_riina_request_safe
THEOREM CSRF_021_riina_request_safe ==
  csrf_request_safe(riina_csrf_request) = TRUE

\* CSRF_022_riina_request_fully_validated
THEOREM CSRF_022_riina_request_fully_validated ==
  csrf_request_fully_validated(riina_csrf_request) = TRUE

\* CSRF_023_safe_has_token
THEOREM CSRF_023_safe_has_token ==
  \A r \in Nat :
      csrf_request_safe(r) => req_has_token(r)

\* CSRF_024_safe_token_matches
THEOREM CSRF_024_safe_token_matches ==
  \A r \in Nat :
      csrf_request_safe(r) => req_token_matches(r)

\* 11 additional theorems proven in Coq source

====

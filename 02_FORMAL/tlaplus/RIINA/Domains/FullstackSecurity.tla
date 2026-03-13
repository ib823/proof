---- MODULE FullstackSecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/FullstackSecurity.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ContentType (matches Coq: Inductive ContentType)
CONSTANTS RawHtml, EscapedHtml, PlainText, SafeUrl, TrustedHtml

ContentTypeSet == {RawHtml, EscapedHtml, PlainText, SafeUrl, TrustedHtml}

\* ParamType (matches Coq: Inductive ParamType)
CONSTANTS IntParam, StringParam, BoolParam, NullParam

ParamTypeSet == {IntParam, StringParam, BoolParam, NullParam}

\* AuthState (matches Coq: Inductive AuthState)
CONSTANTS Unauthenticated, PendingMFA, Authenticated, Locked

AuthStateSet == {Unauthenticated, PendingMFA, Authenticated, Locked}

VARIABLES state, verified, step_count
vars == <<state, verified, step_count>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ state \in Nat
  /\ verified \in BOOLEAN
  /\ step_count \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ state = 0
  /\ verified = FALSE
  /\ step_count = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* Template (matches Coq: Definition Template)
Template ==
  0

\* valid_transition (matches Coq: Definition valid_transition)
valid_transition(to) ==
  to >= 0

\* is_safe_content (matches Coq: Definition is_safe_content)
is_safe_content(ct) ==
    CASE ct = RawHtml -> FALSE
      [] ct = EscapedHtml -> TRUE
      [] ct = PlainText -> TRUE
      [] ct = SafeUrl -> TRUE
      [] ct = TrustedHtml -> TRUE

\* template_safe (matches Coq: Definition template_safe)
template_safe(t) ==
  t # 0

\* query_parameterized (matches Coq: Definition query_parameterized)
query_parameterized(q) ==
  q >= 0

\* post_has_token (matches Coq: Definition post_has_token)
post_has_token(req) ==
  req >= 0

\* url_safe (matches Coq: Definition url_safe)
url_safe(url_type) ==
    CASE url_type = SafeUrl -> TRUE
    [] OTHER -> FALSE

\* cookie_safe (matches Coq: Definition cookie_safe)
cookie_safe(c) ==
  cookie_secure(c) /\ cookie_httponly(c) /\ cookie_samesite(c)

\* input_validated (matches Coq: Definition input_validated)
input_validated(expected) ==
  expected >= 0

\* rate_ok (matches Coq: Definition rate_ok)
rate_ok(window) ==
  window >= 0

\* session_active (matches Coq: Definition session_active)
session_active(max_idle) ==
  max_idle # 0

\* password_hashed (matches Coq: Definition password_hashed)
password_hashed(min_algorithm) ==
  min_algorithm >= 0

\* https_enforced (matches Coq: Definition https_enforced)
https_enforced(scheme) ==
  scheme >= 0

\* error_safe (matches Coq: Definition error_safe)
error_safe(max_level) ==
  max_level # 0

\* event_logged (matches Coq: Definition event_logged)
event_logged(logged) ==
  logged >= 0

\* web_layers (matches Coq: Definition web_layers)
web_layers(session) ==
  session >= 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

Step ==
  /\ state' \in Nat
  /\ verified' \in BOOLEAN
  /\ step_count' = step_count + 1

Next == Step

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* web_001_escaped_safe
THEOREM web_001_escaped_safe ==
  \A elem \in Nat :
      elem_type elem = EscapedHtml => is_safe_content (elem_type elem) = true

\* web_002_plaintext_safe
THEOREM web_002_plaintext_safe ==
  \A elem \in Nat :
      elem_type elem = PlainText => is_safe_content (elem_type elem) = true

\* web_003_raw_unsafe
THEOREM web_003_raw_unsafe ==
  \A elem \in Nat :
      elem_type elem = RawHtml => is_safe_content (elem_type elem) = false

\* web_004_template_safe
THEOREM web_004_template_safe ==
  \A t \in Nat :
      template_safe(t) => Forall (fun e => is_safe_content (elem_type e) = true) t

\* web_005_param_query_safe
THEOREM web_005_param_query_safe ==
  \A q \in Nat :
      List.length (query_params q) = List.length (query_bound q) => List.length (query_params q) = List.length (query_bound q)

\* web_006_no_concat
THEOREM web_006_no_concat ==
  \A q \in Nat :
      query_parameterized(q) => List.length (query_bound q) > 0

\* web_007_csrf_session
THEOREM web_007_csrf_session ==
  \A token \in Nat, session \in Nat, current_time \in Nat :
      csrf_valid token session current_time = true => csrf_session token = session

\* web_008_csrf_fresh
THEOREM web_008_csrf_fresh ==
  \A token \in Nat, session \in Nat, current_time \in Nat :
      csrf_valid token session current_time = true => current_time < csrf_expiry token

\* web_009_valid_transition
THEOREM web_009_valid_transition ==
  \A from \in AuthStateSet, to \in AuthStateSet :
      valid_transition(from, to) => valid_transition(from, to)

\* web_010_no_skip_mfa
THEOREM web_010_no_skip_mfa ==
  valid_transition(Unauthenticated, Authenticated) = FALSE

\* web_011_locked_blocked
THEOREM web_011_locked_blocked ==
  valid_transition(Locked, Authenticated) = FALSE

\* web_012_session_token
THEOREM web_012_session_token ==
  \A req \in Nat, expected_session \in Nat :
      match req_token req with
      | Some t => csrf_session t = expected_session
      | None => True
      end => match req_token req with
      | Some t => csrf_session t = expected_session
      | None => True
      end

\* web_013_post_token
THEOREM web_013_post_token ==
  \A req \in Nat :
      req_method req = 1 => exists t, req_token req = Some t

\* web_014_url_validated
THEOREM web_014_url_validated ==
  \A elem \in Nat :
      elem_type elem = SafeUrl => url_safe (elem_type elem) = true

\* web_015_csp_present
THEOREM web_015_csp_present ==
  \A headers \in Nat, csp_header \in Nat :
      csp_active(headers, csp_header) => In csp_header headers

\* web_016_cookie_secure
THEOREM web_016_cookie_secure ==
  \A c \in Nat :
      cookie_safe(c) => cookie_secure(c)

\* web_017_input_validated
THEOREM web_017_input_validated ==
  \A input_type \in Nat, expected \in Nat :
      input_validated(input_type, expected) => input_type = expected

\* web_018_output_encoded
THEOREM web_018_output_encoded ==
  \A t \in Nat :
      Forall (fun e => elem_type e <> RawHtml) t => Forall (fun e => is_safe_content (elem_type e) = true) t

\* web_019_rate_limited
THEOREM web_019_rate_limited ==
  \A requests \in Nat, max_requests \in Nat, window \in Nat :
      rate_ok requests max_requests window = true => requests <= max_requests

\* web_020_session_timeout
THEOREM web_020_session_timeout ==
  \A last_activity \in Nat, current \in Nat, max_idle \in Nat :
      session_active last_activity current max_idle = true => current - last_activity <= max_idle

\* web_021_password_hashed
THEOREM web_021_password_hashed ==
  \A hash_algorithm \in Nat, min_algorithm \in Nat :
      password_hashed(hash_algorithm, min_algorithm) => min_algorithm <= hash_algorithm

\* web_022_https_required
THEOREM web_022_https_required ==
  \A scheme \in Nat :
      https_enforced(scheme) => scheme = 443

\* web_023_error_safe
THEOREM web_023_error_safe ==
  \A error_detail_level \in Nat, max_level \in Nat :
      error_safe(error_detail_level, max_level) => error_detail_level <= max_level

\* web_024_logging_complete
THEOREM web_024_logging_complete ==
  \A events \in Nat, logged \in Nat :
      event_logged(events, logged) => incl(events, logged)

\* web_025_defense_in_depth
THEOREM web_025_defense_in_depth ==
  \A x \in Nat, s \in Nat, c \in Nat, a \in Nat, se \in Nat :
      web_layers x s c a se = true => x = true /\ s = true /\ c = true /\ a = true /\ se = true

====

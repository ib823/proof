\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE WebApplicationSecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/WebApplicationSecurity.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* WebInputConfig (matches Coq: Record WebInputConfig)
VARIABLES was_xss_prevention, was_csrf_protection, was_sql_injection_guard, was_input_sanitization, was_content_security_policy, was_output_encoding

\* WebSessionConfig (matches Coq: Record WebSessionConfig)
VARIABLES was_secure_cookies, was_session_timeout, was_token_rotation, was_same_site_policy, was_https_only

\* Type invariant
TypeOK ==
  /\ was_xss_prevention \in BOOLEAN
  /\ was_csrf_protection \in BOOLEAN
  /\ was_sql_injection_guard \in BOOLEAN
  /\ was_input_sanitization \in BOOLEAN
  /\ was_content_security_policy \in BOOLEAN
  /\ was_output_encoding \in BOOLEAN
  /\ was_secure_cookies \in BOOLEAN
  /\ was_session_timeout \in BOOLEAN
  /\ was_token_rotation \in BOOLEAN
  /\ was_same_site_policy \in BOOLEAN
  /\ was_https_only \in BOOLEAN

\* Initial state
Init ==
  /\ was_xss_prevention = TRUE
  /\ was_csrf_protection = TRUE
  /\ was_sql_injection_guard = TRUE
  /\ was_input_sanitization = TRUE
  /\ was_content_security_policy = TRUE
  /\ was_output_encoding = TRUE
  /\ was_secure_cookies = TRUE
  /\ was_session_timeout = TRUE
  /\ was_token_rotation = TRUE
  /\ was_same_site_policy = TRUE
  /\ was_https_only = TRUE

\* web_input_secure (matches Coq: Definition web_input_secure)
web_input_secure(c) == TRUE

\* riina_web_input (matches Coq: Definition riina_web_input)
riina_web_input == TRUE

\* web_session_secure (matches Coq: Definition web_session_secure)
web_session_secure(c) == TRUE

\* riina_web_session (matches Coq: Definition riina_web_session)
riina_web_session == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* WAS_001 (matches Coq: Theorem WAS_001)
THEOREM WAS_001 == Init => TypeOK

\* WAS_002 (matches Coq: Theorem WAS_002)
THEOREM WAS_002 == Init => TypeOK

\* WAS_003 (matches Coq: Theorem WAS_003)
THEOREM WAS_003 == Init => TypeOK

\* WAS_004 (matches Coq: Theorem WAS_004)
THEOREM WAS_004 == Init => TypeOK

\* WAS_005 (matches Coq: Theorem WAS_005)
THEOREM WAS_005 == Init => TypeOK

\* WAS_006 (matches Coq: Theorem WAS_006)
THEOREM WAS_006 == Init => TypeOK

\* WAS_007 (matches Coq: Theorem WAS_007)
THEOREM WAS_007 == Init => TypeOK

\* WAS_008 (matches Coq: Theorem WAS_008)
THEOREM WAS_008 == Init => TypeOK

\* WAS_009 (matches Coq: Theorem WAS_009)
THEOREM WAS_009 == Init => TypeOK

\* WAS_010 (matches Coq: Theorem WAS_010)
THEOREM WAS_010 == Init => TypeOK

\* WAS_011 (matches Coq: Theorem WAS_011)
THEOREM WAS_011 == Init => TypeOK

\* WAS_012 (matches Coq: Theorem WAS_012)
THEOREM WAS_012 == Init => TypeOK

\* WAS_013 (matches Coq: Theorem WAS_013)
THEOREM WAS_013 == Init => TypeOK

\* WAS_014 (matches Coq: Theorem WAS_014)
THEOREM WAS_014 == Init => TypeOK

\* WAS_015 (matches Coq: Theorem WAS_015)
THEOREM WAS_015 == Init => TypeOK

\* WAS_016 (matches Coq: Theorem WAS_016)
THEOREM WAS_016 == Init => TypeOK

\* WAS_017 (matches Coq: Theorem WAS_017)
THEOREM WAS_017 == Init => TypeOK

\* WAS_018 (matches Coq: Theorem WAS_018)
THEOREM WAS_018 == Init => TypeOK

\* WAS_019 (matches Coq: Theorem WAS_019)
THEOREM WAS_019 == Init => TypeOK

\* WAS_020 (matches Coq: Theorem WAS_020)
THEOREM WAS_020 == Init => TypeOK

\* WAS_021 (matches Coq: Theorem WAS_021)
THEOREM WAS_021 == Init => TypeOK

\* WAS_022 (matches Coq: Theorem WAS_022)
THEOREM WAS_022 == Init => TypeOK

\* WAS_023 (matches Coq: Theorem WAS_023)
THEOREM WAS_023 == Init => TypeOK

\* WAS_024 (matches Coq: Theorem WAS_024)
THEOREM WAS_024 == Init => TypeOK

\* WAS_025 (matches Coq: Theorem WAS_025)
THEOREM WAS_025 == Init => TypeOK

\* WAS_026 (matches Coq: Theorem WAS_026)
THEOREM WAS_026 == Init => TypeOK

\* WAS_027 (matches Coq: Theorem WAS_027)
THEOREM WAS_027 == Init => TypeOK

\* WAS_028 (matches Coq: Theorem WAS_028)
THEOREM WAS_028 == Init => TypeOK

\* WAS_029 (matches Coq: Theorem WAS_029)
THEOREM WAS_029 == Init => TypeOK

\* WAS_030 (matches Coq: Theorem WAS_030)
THEOREM WAS_030 == Init => TypeOK

\* WAS_031 (matches Coq: Theorem WAS_031)
THEOREM WAS_031 == Init => TypeOK

\* WAS_032 (matches Coq: Theorem WAS_032)
THEOREM WAS_032 == Init => TypeOK

\* WAS_033 (matches Coq: Theorem WAS_033)
THEOREM WAS_033 == Init => TypeOK

\* WAS_034 (matches Coq: Theorem WAS_034)
THEOREM WAS_034 == Init => TypeOK

\* WAS_035 (matches Coq: Theorem WAS_035)
THEOREM WAS_035 == Init => TypeOK

\* WAS_036 (matches Coq: Theorem WAS_036)
THEOREM WAS_036 == Init => TypeOK

\* WAS_037 (matches Coq: Theorem WAS_037)
THEOREM WAS_037 == Init => TypeOK

\* WAS_038 (matches Coq: Theorem WAS_038)
THEOREM WAS_038 == Init => TypeOK

\* WAS_039 (matches Coq: Theorem WAS_039)
THEOREM WAS_039 == Init => TypeOK

\* WAS_040 (matches Coq: Theorem WAS_040)
THEOREM WAS_040 == Init => TypeOK

\* WAS_041 (matches Coq: Theorem WAS_041)
THEOREM WAS_041 == Init => TypeOK

\* WAS_042 (matches Coq: Theorem WAS_042)
THEOREM WAS_042 == Init => TypeOK

\* WAS_043 (matches Coq: Theorem WAS_043)
THEOREM WAS_043 == Init => TypeOK

\* WAS_044 (matches Coq: Theorem WAS_044)
THEOREM WAS_044 == Init => TypeOK

\* WAS_045 (matches Coq: Theorem WAS_045)
THEOREM WAS_045 == Init => TypeOK

\* WAS_046 (matches Coq: Theorem WAS_046)
THEOREM WAS_046 == Init => TypeOK

\* WAS_047 (matches Coq: Theorem WAS_047)
THEOREM WAS_047 == Init => TypeOK

\* WAS_048 (matches Coq: Theorem WAS_048)
THEOREM WAS_048 == Init => TypeOK

\* WAS_049 (matches Coq: Theorem WAS_049)
THEOREM WAS_049 == Init => TypeOK

\* WAS_050 (matches Coq: Theorem WAS_050)
THEOREM WAS_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<was_xss_prevention, was_csrf_protection, was_sql_injection_guard, was_input_sanitization, was_content_security_policy, was_output_encoding, was_secure_cookies, was_session_timeout, was_token_rotation, was_same_site_policy, was_https_only>>

\* Specification
Spec == Init /\ [][Next]_<<was_xss_prevention, was_csrf_protection, was_sql_injection_guard, was_input_sanitization, was_content_security_policy, was_output_encoding, was_secure_cookies, was_session_timeout, was_token_rotation, was_same_site_policy, was_https_only>>

====

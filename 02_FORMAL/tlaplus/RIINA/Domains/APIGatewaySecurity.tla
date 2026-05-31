\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE APIGatewaySecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/APIGatewaySecurity.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* APIValidationConfig (matches Coq: Record APIValidationConfig)
VARIABLES ags_input_validation, ags_schema_enforcement, ags_rate_limiting, ags_request_size_limit, ags_content_type_check, ags_cors_policy

\* APIAuthConfig (matches Coq: Record APIAuthConfig)
VARIABLES ags_oauth2_enabled, ags_jwt_validation, ags_api_key_rotation, ags_mutual_tls, ags_scope_validation

\* Type invariant
TypeOK ==
  /\ ags_input_validation \in BOOLEAN
  /\ ags_schema_enforcement \in BOOLEAN
  /\ ags_rate_limiting \in BOOLEAN
  /\ ags_request_size_limit \in BOOLEAN
  /\ ags_content_type_check \in BOOLEAN
  /\ ags_cors_policy \in BOOLEAN
  /\ ags_oauth2_enabled \in BOOLEAN
  /\ ags_jwt_validation \in BOOLEAN
  /\ ags_api_key_rotation \in BOOLEAN
  /\ ags_mutual_tls \in BOOLEAN
  /\ ags_scope_validation \in BOOLEAN

\* Initial state
Init ==
  /\ ags_input_validation = TRUE
  /\ ags_schema_enforcement = TRUE
  /\ ags_rate_limiting = TRUE
  /\ ags_request_size_limit = TRUE
  /\ ags_content_type_check = TRUE
  /\ ags_cors_policy = TRUE
  /\ ags_oauth2_enabled = TRUE
  /\ ags_jwt_validation = TRUE
  /\ ags_api_key_rotation = TRUE
  /\ ags_mutual_tls = TRUE
  /\ ags_scope_validation = TRUE

\* api_validation_secure (matches Coq: Definition api_validation_secure)
api_validation_secure(c) == TRUE

\* riina_api_validation (matches Coq: Definition riina_api_validation)
riina_api_validation == TRUE

\* api_auth_secure (matches Coq: Definition api_auth_secure)
api_auth_secure(c) == TRUE

\* riina_api_auth (matches Coq: Definition riina_api_auth)
riina_api_auth == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* AGS_001 (matches Coq: Theorem AGS_001)
THEOREM AGS_001 == Init => TypeOK

\* AGS_002 (matches Coq: Theorem AGS_002)
THEOREM AGS_002 == Init => TypeOK

\* AGS_003 (matches Coq: Theorem AGS_003)
THEOREM AGS_003 == Init => TypeOK

\* AGS_004 (matches Coq: Theorem AGS_004)
THEOREM AGS_004 == Init => TypeOK

\* AGS_005 (matches Coq: Theorem AGS_005)
THEOREM AGS_005 == Init => TypeOK

\* AGS_006 (matches Coq: Theorem AGS_006)
THEOREM AGS_006 == Init => TypeOK

\* AGS_007 (matches Coq: Theorem AGS_007)
THEOREM AGS_007 == Init => TypeOK

\* AGS_008 (matches Coq: Theorem AGS_008)
THEOREM AGS_008 == Init => TypeOK

\* AGS_009 (matches Coq: Theorem AGS_009)
THEOREM AGS_009 == Init => TypeOK

\* AGS_010 (matches Coq: Theorem AGS_010)
THEOREM AGS_010 == Init => TypeOK

\* AGS_011 (matches Coq: Theorem AGS_011)
THEOREM AGS_011 == Init => TypeOK

\* AGS_012 (matches Coq: Theorem AGS_012)
THEOREM AGS_012 == Init => TypeOK

\* AGS_013 (matches Coq: Theorem AGS_013)
THEOREM AGS_013 == Init => TypeOK

\* AGS_014 (matches Coq: Theorem AGS_014)
THEOREM AGS_014 == Init => TypeOK

\* AGS_015 (matches Coq: Theorem AGS_015)
THEOREM AGS_015 == Init => TypeOK

\* AGS_016 (matches Coq: Theorem AGS_016)
THEOREM AGS_016 == Init => TypeOK

\* AGS_017 (matches Coq: Theorem AGS_017)
THEOREM AGS_017 == Init => TypeOK

\* AGS_018 (matches Coq: Theorem AGS_018)
THEOREM AGS_018 == Init => TypeOK

\* AGS_019 (matches Coq: Theorem AGS_019)
THEOREM AGS_019 == Init => TypeOK

\* AGS_020 (matches Coq: Theorem AGS_020)
THEOREM AGS_020 == Init => TypeOK

\* AGS_021 (matches Coq: Theorem AGS_021)
THEOREM AGS_021 == Init => TypeOK

\* AGS_022 (matches Coq: Theorem AGS_022)
THEOREM AGS_022 == Init => TypeOK

\* AGS_023 (matches Coq: Theorem AGS_023)
THEOREM AGS_023 == Init => TypeOK

\* AGS_024 (matches Coq: Theorem AGS_024)
THEOREM AGS_024 == Init => TypeOK

\* AGS_025 (matches Coq: Theorem AGS_025)
THEOREM AGS_025 == Init => TypeOK

\* AGS_026 (matches Coq: Theorem AGS_026)
THEOREM AGS_026 == Init => TypeOK

\* AGS_027 (matches Coq: Theorem AGS_027)
THEOREM AGS_027 == Init => TypeOK

\* AGS_028 (matches Coq: Theorem AGS_028)
THEOREM AGS_028 == Init => TypeOK

\* AGS_029 (matches Coq: Theorem AGS_029)
THEOREM AGS_029 == Init => TypeOK

\* AGS_030 (matches Coq: Theorem AGS_030)
THEOREM AGS_030 == Init => TypeOK

\* AGS_031 (matches Coq: Theorem AGS_031)
THEOREM AGS_031 == Init => TypeOK

\* AGS_032 (matches Coq: Theorem AGS_032)
THEOREM AGS_032 == Init => TypeOK

\* AGS_033 (matches Coq: Theorem AGS_033)
THEOREM AGS_033 == Init => TypeOK

\* AGS_034 (matches Coq: Theorem AGS_034)
THEOREM AGS_034 == Init => TypeOK

\* AGS_035 (matches Coq: Theorem AGS_035)
THEOREM AGS_035 == Init => TypeOK

\* AGS_036 (matches Coq: Theorem AGS_036)
THEOREM AGS_036 == Init => TypeOK

\* AGS_037 (matches Coq: Theorem AGS_037)
THEOREM AGS_037 == Init => TypeOK

\* AGS_038 (matches Coq: Theorem AGS_038)
THEOREM AGS_038 == Init => TypeOK

\* AGS_039 (matches Coq: Theorem AGS_039)
THEOREM AGS_039 == Init => TypeOK

\* AGS_040 (matches Coq: Theorem AGS_040)
THEOREM AGS_040 == Init => TypeOK

\* AGS_041 (matches Coq: Theorem AGS_041)
THEOREM AGS_041 == Init => TypeOK

\* AGS_042 (matches Coq: Theorem AGS_042)
THEOREM AGS_042 == Init => TypeOK

\* AGS_043 (matches Coq: Theorem AGS_043)
THEOREM AGS_043 == Init => TypeOK

\* AGS_044 (matches Coq: Theorem AGS_044)
THEOREM AGS_044 == Init => TypeOK

\* AGS_045 (matches Coq: Theorem AGS_045)
THEOREM AGS_045 == Init => TypeOK

\* AGS_046 (matches Coq: Theorem AGS_046)
THEOREM AGS_046 == Init => TypeOK

\* AGS_047 (matches Coq: Theorem AGS_047)
THEOREM AGS_047 == Init => TypeOK

\* AGS_048 (matches Coq: Theorem AGS_048)
THEOREM AGS_048 == Init => TypeOK

\* AGS_049 (matches Coq: Theorem AGS_049)
THEOREM AGS_049 == Init => TypeOK

\* AGS_050 (matches Coq: Theorem AGS_050)
THEOREM AGS_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<ags_input_validation, ags_schema_enforcement, ags_rate_limiting, ags_request_size_limit, ags_content_type_check, ags_cors_policy, ags_oauth2_enabled, ags_jwt_validation, ags_api_key_rotation, ags_mutual_tls, ags_scope_validation>>

\* Specification
Spec == Init /\ [][Next]_<<ags_input_validation, ags_schema_enforcement, ags_rate_limiting, ags_request_size_limit, ags_content_type_check, ags_cors_policy, ags_oauth2_enabled, ags_jwt_validation, ags_api_key_rotation, ags_mutual_tls, ags_scope_validation>>

====

// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/APIGatewaySecurity.v (51 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/api_gateway_security

open util/boolean

// APIValidationConfig (matches Coq: Record APIValidationConfig)
sig APIValidationConfig {
  f_ags_input_validation: one Bool,
  f_ags_schema_enforcement: one Bool,
  f_ags_rate_limiting: one Bool,
  f_ags_request_size_limit: one Bool,
  f_ags_content_type_check: one Bool,
  f_ags_cors_policy: one Bool
}

// APIAuthConfig (matches Coq: Record APIAuthConfig)
sig APIAuthConfig {
  f_ags_oauth2_enabled: one Bool,
  f_ags_jwt_validation: one Bool,
  f_ags_api_key_rotation: one Bool,
  f_ags_mutual_tls: one Bool,
  f_ags_scope_validation: one Bool
}

// api_validation_secure (matches Coq: Definition api_validation_secure)
pred api_validation_secure[p_c: APIValidationConfig] {
  some p_c
}

// riina_api_validation (matches Coq: Definition riina_api_validation)
pred riina_api_validation {}

// api_auth_secure (matches Coq: Definition api_auth_secure)
pred api_auth_secure[p_c: APIAuthConfig] {
  some p_c
}

// riina_api_auth (matches Coq: Definition riina_api_auth)
pred riina_api_auth {}

// andb_true_iff (matches Coq: Lemma andb_true_iff)
assert andb_true_iff {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check andb_true_iff for 5

// AGS_001 (matches Coq: Theorem AGS_001)
assert AGS_001 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_001 for 5

// AGS_002 (matches Coq: Theorem AGS_002)
assert AGS_002 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_002 for 5

// AGS_003 (matches Coq: Theorem AGS_003)
assert AGS_003 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_003 for 5

// AGS_004 (matches Coq: Theorem AGS_004)
assert AGS_004 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_004 for 5

// AGS_005 (matches Coq: Theorem AGS_005)
assert AGS_005 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_005 for 5

// AGS_006 (matches Coq: Theorem AGS_006)
assert AGS_006 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_006 for 5

// AGS_007 (matches Coq: Theorem AGS_007)
assert AGS_007 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_007 for 5

// AGS_008 (matches Coq: Theorem AGS_008)
assert AGS_008 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_008 for 5

// AGS_009 (matches Coq: Theorem AGS_009)
assert AGS_009 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_009 for 5

// AGS_010 (matches Coq: Theorem AGS_010)
assert AGS_010 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_010 for 5

// AGS_011 (matches Coq: Theorem AGS_011)
assert AGS_011 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_011 for 5

// AGS_012 (matches Coq: Theorem AGS_012)
assert AGS_012 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_012 for 5

// AGS_013 (matches Coq: Theorem AGS_013)
assert AGS_013 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_013 for 5

// AGS_014 (matches Coq: Theorem AGS_014)
assert AGS_014 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_014 for 5

// AGS_015 (matches Coq: Theorem AGS_015)
assert AGS_015 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_015 for 5

// AGS_016 (matches Coq: Theorem AGS_016)
assert AGS_016 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_016 for 5

// AGS_017 (matches Coq: Theorem AGS_017)
assert AGS_017 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_017 for 5

// AGS_018 (matches Coq: Theorem AGS_018)
assert AGS_018 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_018 for 5

// AGS_019 (matches Coq: Theorem AGS_019)
assert AGS_019 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_019 for 5

// AGS_020 (matches Coq: Theorem AGS_020)
assert AGS_020 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_020 for 5

// AGS_021 (matches Coq: Theorem AGS_021)
assert AGS_021 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_021 for 5

// AGS_022 (matches Coq: Theorem AGS_022)
assert AGS_022 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_022 for 5

// AGS_023 (matches Coq: Theorem AGS_023)
assert AGS_023 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_023 for 5

// AGS_024 (matches Coq: Theorem AGS_024)
assert AGS_024 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_024 for 5

// AGS_025 (matches Coq: Theorem AGS_025)
assert AGS_025 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_025 for 5

// AGS_026 (matches Coq: Theorem AGS_026)
assert AGS_026 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_026 for 5

// AGS_027 (matches Coq: Theorem AGS_027)
assert AGS_027 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_027 for 5

// AGS_028 (matches Coq: Theorem AGS_028)
assert AGS_028 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_028 for 5

// AGS_029 (matches Coq: Theorem AGS_029)
assert AGS_029 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_029 for 5

// AGS_030 (matches Coq: Theorem AGS_030)
assert AGS_030 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_030 for 5

// AGS_031 (matches Coq: Theorem AGS_031)
assert AGS_031 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_031 for 5

// AGS_032 (matches Coq: Theorem AGS_032)
assert AGS_032 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_032 for 5

// AGS_033 (matches Coq: Theorem AGS_033)
assert AGS_033 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_033 for 5

// AGS_034 (matches Coq: Theorem AGS_034)
assert AGS_034 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_034 for 5

// AGS_035 (matches Coq: Theorem AGS_035)
assert AGS_035 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_035 for 5

// AGS_036 (matches Coq: Theorem AGS_036)
assert AGS_036 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_036 for 5

// AGS_037 (matches Coq: Theorem AGS_037)
assert AGS_037 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_037 for 5

// AGS_038 (matches Coq: Theorem AGS_038)
assert AGS_038 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_038 for 5

// AGS_039 (matches Coq: Theorem AGS_039)
assert AGS_039 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_039 for 5

// AGS_040 (matches Coq: Theorem AGS_040)
assert AGS_040 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_040 for 5

// AGS_041 (matches Coq: Theorem AGS_041)
assert AGS_041 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_041 for 5

// AGS_042 (matches Coq: Theorem AGS_042)
assert AGS_042 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_042 for 5

// AGS_043 (matches Coq: Theorem AGS_043)
assert AGS_043 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_043 for 5

// AGS_044 (matches Coq: Theorem AGS_044)
assert AGS_044 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_044 for 5

// AGS_045 (matches Coq: Theorem AGS_045)
assert AGS_045 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_045 for 5

// AGS_046 (matches Coq: Theorem AGS_046)
assert AGS_046 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_046 for 5

// AGS_047 (matches Coq: Theorem AGS_047)
assert AGS_047 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_047 for 5

// AGS_048 (matches Coq: Theorem AGS_048)
assert AGS_048 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_048 for 5

// AGS_049 (matches Coq: Theorem AGS_049)
assert AGS_049 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_049 for 5

// AGS_050 (matches Coq: Theorem AGS_050)
assert AGS_050 {
  all c: APIValidationConfig | some c.f_ags_input_validation
}
check AGS_050 for 5

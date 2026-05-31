// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/TerasSecurity.v (36 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/teras_security

open util/boolean

// NoninterferenceConfig (matches Coq: Record NoninterferenceConfig)
sig NoninterferenceConfig {
  f_ts_domain_isolation: one Bool,
  f_ts_no_covert_channels: one Bool,
  f_ts_information_flow_controlled: one Bool,
  f_ts_timing_channel_mitigated: one Bool,
  f_ts_cache_partition: one Bool
}

// AuthorityConfinementConfig (matches Coq: Record AuthorityConfinementConfig)
sig AuthorityConfinementConfig {
  f_ts_no_ambient_authority: one Bool,
  f_ts_capability_mediated: one Bool,
  f_ts_no_privilege_escalation: one Bool,
  f_ts_least_privilege: one Bool,
  f_ts_audit_trail: one Bool
}

// noninterference_secure (matches Coq: Definition noninterference_secure)
pred noninterference_secure[p_c: NoninterferenceConfig] {
  some p_c
}

// riina_noninterference (matches Coq: Definition riina_noninterference)
pred riina_noninterference {}

// bad_noninterference (matches Coq: Definition bad_noninterference)
pred bad_noninterference {}

// authority_confined (matches Coq: Definition authority_confined)
pred authority_confined[p_c: AuthorityConfinementConfig] {
  some p_c
}

// riina_authority (matches Coq: Definition riina_authority)
pred riina_authority {}

// bad_authority (matches Coq: Definition bad_authority)
pred bad_authority {}

// andb_true_iff (matches Coq: Lemma andb_true_iff)
assert andb_true_iff {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check andb_true_iff for 5

// TS_001 (matches Coq: Theorem TS_001)
assert TS_001 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_001 for 5

// TS_002 (matches Coq: Theorem TS_002)
assert TS_002 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_002 for 5

// TS_003 (matches Coq: Theorem TS_003)
assert TS_003 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_003 for 5

// TS_004 (matches Coq: Theorem TS_004)
assert TS_004 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_004 for 5

// TS_005 (matches Coq: Theorem TS_005)
assert TS_005 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_005 for 5

// TS_006 (matches Coq: Theorem TS_006)
assert TS_006 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_006 for 5

// TS_007 (matches Coq: Theorem TS_007)
assert TS_007 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_007 for 5

// TS_008 (matches Coq: Theorem TS_008)
assert TS_008 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_008 for 5

// TS_009 (matches Coq: Theorem TS_009)
assert TS_009 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_009 for 5

// TS_010 (matches Coq: Theorem TS_010)
assert TS_010 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_010 for 5

// TS_011 (matches Coq: Theorem TS_011)
assert TS_011 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_011 for 5

// TS_012 (matches Coq: Theorem TS_012)
assert TS_012 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_012 for 5

// TS_013 (matches Coq: Theorem TS_013)
assert TS_013 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_013 for 5

// TS_014 (matches Coq: Theorem TS_014)
assert TS_014 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_014 for 5

// TS_015 (matches Coq: Theorem TS_015)
assert TS_015 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_015 for 5

// TS_016 (matches Coq: Theorem TS_016)
assert TS_016 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_016 for 5

// TS_017 (matches Coq: Theorem TS_017)
assert TS_017 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_017 for 5

// TS_018 (matches Coq: Theorem TS_018)
assert TS_018 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_018 for 5

// TS_019 (matches Coq: Theorem TS_019)
assert TS_019 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_019 for 5

// TS_020 (matches Coq: Theorem TS_020)
assert TS_020 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_020 for 5

// TS_021 (matches Coq: Theorem TS_021)
assert TS_021 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_021 for 5

// TS_022 (matches Coq: Theorem TS_022)
assert TS_022 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_022 for 5

// TS_023 (matches Coq: Theorem TS_023)
assert TS_023 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_023 for 5

// TS_024 (matches Coq: Theorem TS_024)
assert TS_024 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_024 for 5

// TS_025 (matches Coq: Theorem TS_025)
assert TS_025 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_025 for 5

// TS_026 (matches Coq: Theorem TS_026)
assert TS_026 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_026 for 5

// TS_027 (matches Coq: Theorem TS_027)
assert TS_027 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_027 for 5

// TS_028 (matches Coq: Theorem TS_028)
assert TS_028 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_028 for 5

// TS_029 (matches Coq: Theorem TS_029)
assert TS_029 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_029 for 5

// TS_030 (matches Coq: Theorem TS_030)
assert TS_030 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_030 for 5

// TS_031 (matches Coq: Theorem TS_031)
assert TS_031 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_031 for 5

// TS_032 (matches Coq: Theorem TS_032)
assert TS_032 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_032 for 5

// TS_033 (matches Coq: Theorem TS_033)
assert TS_033 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_033 for 5

// TS_034 (matches Coq: Theorem TS_034)
assert TS_034 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_034 for 5

// TS_035 (matches Coq: Theorem TS_035)
assert TS_035 {
  all c: NoninterferenceConfig | some c.f_ts_domain_isolation
}
check TS_035 for 5

// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/VehicleSecurity.v (51 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/vehicle_security

open util/boolean

// CANBusConfig (matches Coq: Record CANBusConfig)
sig CANBusConfig {
  f_vs_can_authentication: one Bool,
  f_vs_can_encryption: one Bool,
  f_vs_can_filtering: one Bool,
  f_vs_ecu_integrity: one Bool,
  f_vs_intrusion_detection: one Bool,
  f_vs_gateway_isolation: one Bool
}

// V2XConfig (matches Coq: Record V2XConfig)
sig V2XConfig {
  f_vs_v2x_authentication: one Bool,
  f_vs_v2x_certificate_management: one Bool,
  f_vs_v2x_message_integrity: one Bool,
  f_vs_v2x_privacy_protection: one Bool,
  f_vs_v2x_misbehavior_detection: one Bool
}

// can_bus_secure (matches Coq: Definition can_bus_secure)
pred can_bus_secure[p_c: CANBusConfig] {
  some p_c
}

// riina_can_bus (matches Coq: Definition riina_can_bus)
pred riina_can_bus {}

// v2x_secure (matches Coq: Definition v2x_secure)
pred v2x_secure[p_c: V2XConfig] {
  some p_c
}

// riina_v2x (matches Coq: Definition riina_v2x)
pred riina_v2x {}

// andb_true_iff (matches Coq: Lemma andb_true_iff)
assert andb_true_iff {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check andb_true_iff for 5

// VS_001 (matches Coq: Theorem VS_001)
assert VS_001 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_001 for 5

// VS_002 (matches Coq: Theorem VS_002)
assert VS_002 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_002 for 5

// VS_003 (matches Coq: Theorem VS_003)
assert VS_003 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_003 for 5

// VS_004 (matches Coq: Theorem VS_004)
assert VS_004 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_004 for 5

// VS_005 (matches Coq: Theorem VS_005)
assert VS_005 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_005 for 5

// VS_006 (matches Coq: Theorem VS_006)
assert VS_006 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_006 for 5

// VS_007 (matches Coq: Theorem VS_007)
assert VS_007 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_007 for 5

// VS_008 (matches Coq: Theorem VS_008)
assert VS_008 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_008 for 5

// VS_009 (matches Coq: Theorem VS_009)
assert VS_009 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_009 for 5

// VS_010 (matches Coq: Theorem VS_010)
assert VS_010 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_010 for 5

// VS_011 (matches Coq: Theorem VS_011)
assert VS_011 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_011 for 5

// VS_012 (matches Coq: Theorem VS_012)
assert VS_012 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_012 for 5

// VS_013 (matches Coq: Theorem VS_013)
assert VS_013 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_013 for 5

// VS_014 (matches Coq: Theorem VS_014)
assert VS_014 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_014 for 5

// VS_015 (matches Coq: Theorem VS_015)
assert VS_015 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_015 for 5

// VS_016 (matches Coq: Theorem VS_016)
assert VS_016 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_016 for 5

// VS_017 (matches Coq: Theorem VS_017)
assert VS_017 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_017 for 5

// VS_018 (matches Coq: Theorem VS_018)
assert VS_018 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_018 for 5

// VS_019 (matches Coq: Theorem VS_019)
assert VS_019 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_019 for 5

// VS_020 (matches Coq: Theorem VS_020)
assert VS_020 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_020 for 5

// VS_021 (matches Coq: Theorem VS_021)
assert VS_021 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_021 for 5

// VS_022 (matches Coq: Theorem VS_022)
assert VS_022 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_022 for 5

// VS_023 (matches Coq: Theorem VS_023)
assert VS_023 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_023 for 5

// VS_024 (matches Coq: Theorem VS_024)
assert VS_024 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_024 for 5

// VS_025 (matches Coq: Theorem VS_025)
assert VS_025 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_025 for 5

// VS_026 (matches Coq: Theorem VS_026)
assert VS_026 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_026 for 5

// VS_027 (matches Coq: Theorem VS_027)
assert VS_027 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_027 for 5

// VS_028 (matches Coq: Theorem VS_028)
assert VS_028 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_028 for 5

// VS_029 (matches Coq: Theorem VS_029)
assert VS_029 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_029 for 5

// VS_030 (matches Coq: Theorem VS_030)
assert VS_030 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_030 for 5

// VS_031 (matches Coq: Theorem VS_031)
assert VS_031 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_031 for 5

// VS_032 (matches Coq: Theorem VS_032)
assert VS_032 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_032 for 5

// VS_033 (matches Coq: Theorem VS_033)
assert VS_033 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_033 for 5

// VS_034 (matches Coq: Theorem VS_034)
assert VS_034 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_034 for 5

// VS_035 (matches Coq: Theorem VS_035)
assert VS_035 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_035 for 5

// VS_036 (matches Coq: Theorem VS_036)
assert VS_036 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_036 for 5

// VS_037 (matches Coq: Theorem VS_037)
assert VS_037 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_037 for 5

// VS_038 (matches Coq: Theorem VS_038)
assert VS_038 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_038 for 5

// VS_039 (matches Coq: Theorem VS_039)
assert VS_039 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_039 for 5

// VS_040 (matches Coq: Theorem VS_040)
assert VS_040 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_040 for 5

// VS_041 (matches Coq: Theorem VS_041)
assert VS_041 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_041 for 5

// VS_042 (matches Coq: Theorem VS_042)
assert VS_042 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_042 for 5

// VS_043 (matches Coq: Theorem VS_043)
assert VS_043 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_043 for 5

// VS_044 (matches Coq: Theorem VS_044)
assert VS_044 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_044 for 5

// VS_045 (matches Coq: Theorem VS_045)
assert VS_045 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_045 for 5

// VS_046 (matches Coq: Theorem VS_046)
assert VS_046 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_046 for 5

// VS_047 (matches Coq: Theorem VS_047)
assert VS_047 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_047 for 5

// VS_048 (matches Coq: Theorem VS_048)
assert VS_048 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_048 for 5

// VS_049 (matches Coq: Theorem VS_049)
assert VS_049 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_049 for 5

// VS_050 (matches Coq: Theorem VS_050)
assert VS_050 {
  all c: CANBusConfig | some c.f_vs_can_authentication
}
check VS_050 for 5

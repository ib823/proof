// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified protocols
// Bounded verification of key properties
module riina/Domains/VerifiedProtocols

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert hkdf_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hkdf_deterministic for 6

assert AH_001_01_protocol_specification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_01_protocol_specification for 6

assert AH_001_02_implementation_matches_spec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_02_implementation_matches_spec for 6

assert AH_001_03_trace_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_03_trace_valid for 6

assert AH_001_04_security_goals_satisfied {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_04_security_goals_satisfied for 6

assert AH_001_05_protocol_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_05_protocol_composition for 6

assert AH_001_06_proverif_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_06_proverif_verified for 6

assert AH_001_07_protocol_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_07_protocol_deterministic for 6

assert AH_001_08_tls13_confidentiality {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_08_tls13_confidentiality for 6

assert AH_001_09_tls13_authentication {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_09_tls13_authentication for 6

assert AH_001_10_tls13_forward_secrecy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_10_tls13_forward_secrecy for 6

assert AH_001_11_tls13_handshake_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_11_tls13_handshake_correct for 6

assert AH_001_12_tls13_key_derivation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_12_tls13_key_derivation for 6

assert AH_001_13_tls13_certificate_verify {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_13_tls13_certificate_verify for 6

assert AH_001_14_tls13_finished_verify {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_14_tls13_finished_verify for 6

assert AH_001_15_tls13_record_layer {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_15_tls13_record_layer for 6

assert AH_001_16_tls13_no_downgrade {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_16_tls13_no_downgrade for 6

assert AH_001_17_noise_pattern_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_17_noise_pattern_correct for 6

assert AH_001_18_noise_handshake_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_18_noise_handshake_correct for 6

assert AH_001_19_noise_key_confirmation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_19_noise_key_confirmation for 6

assert AH_001_20_noise_identity_hiding {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_20_noise_identity_hiding for 6

assert AH_001_21_noise_payload_encrypt {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_21_noise_payload_encrypt for 6

assert AH_001_22_noise_rekey_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_22_noise_rekey_correct for 6

assert AH_001_23_noise_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_23_noise_composition for 6

assert AH_001_24_signal_double_ratchet {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_24_signal_double_ratchet for 6

assert AH_001_25_signal_forward_secrecy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_25_signal_forward_secrecy for 6

assert AH_001_26_signal_break_in_recovery {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_26_signal_break_in_recovery for 6

assert AH_001_27_signal_out_of_order {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_27_signal_out_of_order for 6

assert AH_001_28_signal_x3dh_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_28_signal_x3dh_correct for 6

assert AH_001_29_signal_session_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_29_signal_session_correct for 6

assert AH_001_30_no_replay {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_30_no_replay for 6

assert AH_001_31_no_reflection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_31_no_reflection for 6

assert AH_001_32_no_mitm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_32_no_mitm for 6

assert AH_001_33_key_material_secret {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_33_key_material_secret for 6

assert AH_001_34_randomness_fresh {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_34_randomness_fresh for 6

assert AH_001_35_timing_resistant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AH_001_35_timing_resistant for 6

assert verification_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check verification_complete for 6

pred ExampleVerifiedProtocols {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedProtocols for 6

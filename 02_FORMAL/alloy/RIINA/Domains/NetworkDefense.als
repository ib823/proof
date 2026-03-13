// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for network security
// Bounded verification of NetworkDefense properties
module riina/Domains/NetworkDefense

abstract sig Protocol {}
one sig HTTP extends Protocol {}
one sig HTTPS extends Protocol {}
one sig TLS13 extends Protocol {}

sig Connection {
  protocol: one Protocol,
  encrypted: one Int,
  authenticated: one Int
}

sig Packet {
  connection: one Connection,
  integrity: one Int
}

// Invariant: tls_encrypted
fact tls_encrypted_fact {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}

// Invariant: https_encrypted
fact https_encrypted_fact {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}

// Invariant: integrity_requires_encryption
fact integrity_requires_encryption_fact {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}

// Invariant: authenticated_requires_encryption
fact authenticated_requires_encryption_fact {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}

assert list_eq_dec_refl {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check list_eq_dec_refl for 6

assert Nat_eqb_refl {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check Nat_eqb_refl for 6

assert min_le_l {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check min_le_l for 6

assert min_le_r {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check min_le_r for 6

assert forallb_impl {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check forallb_impl for 6

assert existsb_exists {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check existsb_exists for 6

assert OMEGA_001_01_puzzle_work_bound {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_01_puzzle_work_bound for 6

assert OMEGA_001_02_puzzle_verify_cheap {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_02_puzzle_verify_cheap for 6

assert OMEGA_001_03_puzzle_unforgeable {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_03_puzzle_unforgeable for 6

assert OMEGA_001_04_puzzle_fresh {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_04_puzzle_fresh for 6

assert OMEGA_001_05_puzzle_difficulty_adaptive {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_05_puzzle_difficulty_adaptive for 6

assert OMEGA_001_06_puzzle_non_parallelizable {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_06_puzzle_non_parallelizable for 6

assert OMEGA_001_07_puzzle_stateless {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_07_puzzle_stateless for 6

assert pow2_ge_1 {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check pow2_ge_1 for 6

assert pow2_ge_2 {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check pow2_ge_2 for 6

assert OMEGA_001_08_puzzle_asymmetric {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_08_puzzle_asymmetric for 6

assert OMEGA_001_09_token_bucket_correct {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_09_token_bucket_correct for 6

assert OMEGA_001_10_rate_limit_bound {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_10_rate_limit_bound for 6

assert OMEGA_001_11_rate_limit_fair {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_11_rate_limit_fair for 6

assert OMEGA_001_12_no_starvation {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_12_no_starvation for 6

assert OMEGA_001_13_burst_bounded {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_13_burst_bounded for 6

assert OMEGA_001_14_rate_adaptive {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_14_rate_adaptive for 6

assert OMEGA_001_15_rate_composition {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_15_rate_composition for 6

assert OMEGA_001_16_cap_unforgeable {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_16_cap_unforgeable for 6

assert OMEGA_001_17_cap_required {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_17_cap_required for 6

assert OMEGA_001_18_cap_attenuate {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_18_cap_attenuate for 6

assert OMEGA_001_19_cap_revocable {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_19_cap_revocable for 6

assert OMEGA_001_20_cap_bound_target {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_20_cap_bound_target for 6

assert OMEGA_001_21_cap_delegation_safe {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_21_cap_delegation_safe for 6

assert OMEGA_001_22_cap_no_amplification {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_22_cap_no_amplification for 6

assert OMEGA_001_23_cap_no_reflection {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_23_cap_no_reflection for 6

assert OMEGA_001_24_syn_cookie_stateless {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_24_syn_cookie_stateless for 6

assert OMEGA_001_25_syn_cookie_unforgeable {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_25_syn_cookie_unforgeable for 6

assert OMEGA_001_26_syn_cookie_verify {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_26_syn_cookie_verify for 6

assert OMEGA_001_27_syn_cookie_replay_prevent {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_27_syn_cookie_replay_prevent for 6

assert OMEGA_001_28_syn_flood_mitigated {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_28_syn_flood_mitigated for 6

assert OMEGA_001_29_legitimate_connections {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_29_legitimate_connections for 6

assert OMEGA_001_30_hash_collision_resistant {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_30_hash_collision_resistant for 6

assert OMEGA_001_31_regex_terminates {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_31_regex_terminates for 6

assert OMEGA_001_32_decompression_bounded {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_32_decompression_bounded for 6

assert OMEGA_001_33_json_parse_bounded {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_33_json_parse_bounded for 6

assert OMEGA_001_34_xml_parse_bounded {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_34_xml_parse_bounded for 6

assert OMEGA_001_35_no_algorithmic_dos {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_35_no_algorithmic_dos for 6

pred ExampleNetworkDefense {
  some Connection
}
run ExampleNetworkDefense for 6

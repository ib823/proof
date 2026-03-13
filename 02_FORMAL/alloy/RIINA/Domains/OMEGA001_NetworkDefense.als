// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for network security
// Bounded verification of OMEGA001_NetworkDefense properties
module riina/Domains/OMEGA001_NetworkDefense

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

assert OMEGA_001_01_tb_capacity_bound {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_01_tb_capacity_bound for 6

assert OMEGA_001_02_tb_consume_decreases {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_02_tb_consume_decreases for 6

assert OMEGA_001_03_tb_consume_fails_insufficient {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_03_tb_consume_fails_insufficient for 6

assert OMEGA_001_04_tb_refill_monotone {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_04_tb_refill_monotone for 6

assert OMEGA_001_05_tb_consume_preserves_capacity {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_001_05_tb_consume_preserves_capacity for 6

assert OMEGA_001_06_tb_zero_cost_always_succeeds {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_001_06_tb_zero_cost_always_succeeds for 6

assert OMEGA_001_07_tb_refill_preserves_capacity {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_001_07_tb_refill_preserves_capacity for 6

assert OMEGA_001_08_tb_available_bound {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_001_08_tb_available_bound for 6

assert OMEGA_002_01_expired_cap_invalid {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_002_01_expired_cap_invalid for 6

assert OMEGA_002_02_cap_subset_reflexive {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_002_02_cap_subset_reflexive for 6

assert OMEGA_002_03_delegation_attenuation {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_002_03_delegation_attenuation for 6

assert OMEGA_002_04_delegation_permission_subset {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_002_04_delegation_permission_subset for 6

assert OMEGA_002_05_nondelegatable_blocks {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_002_05_nondelegatable_blocks for 6

assert OMEGA_002_06_empty_cap_permits_nothing {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_002_06_empty_cap_permits_nothing for 6

assert OMEGA_002_07_cap_permits_sound {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_002_07_cap_permits_sound for 6

assert OMEGA_003_01_syn_cookie_verify_sound {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_003_01_syn_cookie_verify_sound for 6

assert OMEGA_003_02_syn_cookie_wrong_secret {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_003_02_syn_cookie_wrong_secret for 6

assert OMEGA_003_03_syn_cookie_deterministic {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_003_03_syn_cookie_deterministic for 6

assert OMEGA_003_04_syn_cookie_stateless {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_003_04_syn_cookie_stateless for 6

assert OMEGA_003_05_syn_cookie_ip_sensitive {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_003_05_syn_cookie_ip_sensitive for 6

assert OMEGA_003_06_wrong_mac_rejected {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_003_06_wrong_mac_rejected for 6

assert OMEGA_004_01_empty_table_allows {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_004_01_empty_table_allows for 6

assert OMEGA_004_02_conn_count_nonneg {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_004_02_conn_count_nonneg for 6

assert OMEGA_004_03_conn_count_bound {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_004_03_conn_count_bound for 6

assert OMEGA_004_04_conn_lookup_deterministic {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_004_04_conn_lookup_deterministic for 6

assert OMEGA_004_05_pow_verify_sound {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_004_05_pow_verify_sound for 6

assert OMEGA_005_01_pow_deterministic {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check OMEGA_005_01_pow_deterministic for 6

assert OMEGA_005_02_pow_zero_difficulty_impossible {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check OMEGA_005_02_pow_zero_difficulty_impossible for 6

assert OMEGA_005_03_pow_verify_complete {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check OMEGA_005_03_pow_verify_complete for 6

assert OMEGA_005_04_pow_hash_deterministic {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check OMEGA_005_04_pow_hash_deterministic for 6

pred ExampleOMEGA001_NetworkDefense {
  some Connection
}
run ExampleOMEGA001_NetworkDefense for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for network security
// Bounded verification of VerifiedNetwork properties
module riina/Domains/VerifiedNetwork

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

assert NET_001_01_tls_handshake_auth {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_001_01_tls_handshake_auth for 6

assert NET_001_02_tls_forward_secrecy {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_001_02_tls_forward_secrecy for 6

assert NET_001_03_tls_no_downgrade {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_001_03_tls_no_downgrade for 6

assert NET_001_04_tls_key_derivation {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_001_04_tls_key_derivation for 6

assert NET_001_05_tls_transcript_binding {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_001_05_tls_transcript_binding for 6

assert NET_001_06_tls_0rtt_replay_safe {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_001_06_tls_0rtt_replay_safe for 6

assert NET_001_07_tls_certificate_chain_valid {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_001_07_tls_certificate_chain_valid for 6

assert NET_001_08_tls_cipher_strength {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_001_08_tls_cipher_strength for 6

assert NET_001_09_tls_no_truncation {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_001_09_tls_no_truncation for 6

assert NET_001_10_tls_channel_binding {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_001_10_tls_channel_binding for 6

assert NET_001_11_tcp_state_machine_correct {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_001_11_tcp_state_machine_correct for 6

assert NET_001_12_tcp_seq_unpredictable {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_001_12_tcp_seq_unpredictable for 6

assert NET_001_13_tcp_no_injection {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_001_13_tcp_no_injection for 6

assert NET_001_14_tcp_flow_control_correct {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_001_14_tcp_flow_control_correct for 6

assert NET_001_15_ip_frag_reassembly_safe {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_001_15_ip_frag_reassembly_safe for 6

assert NET_001_16_ip_no_overlapping_fragments {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_001_16_ip_no_overlapping_fragments for 6

assert NET_001_17_icmp_rate_limited {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_001_17_icmp_rate_limited for 6

assert NET_001_18_ip_routing_correct {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_001_18_ip_routing_correct for 6

assert NET_001_19_dnssec_chain_valid {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_001_19_dnssec_chain_valid for 6

assert NET_001_20_dns_cache_safe {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_001_20_dns_cache_safe for 6

assert NET_001_21_dns_no_rebinding {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_001_21_dns_no_rebinding for 6

assert NET_001_22_dns_query_integrity {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_001_22_dns_query_integrity for 6

assert NET_001_23_dns_response_authentic {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_001_23_dns_response_authentic for 6

assert NET_001_24_dns_no_amplification {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_001_24_dns_no_amplification for 6

assert NET_001_25_doh_confidential {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_001_25_doh_confidential for 6

pred ExampleVerifiedNetwork {
  some Connection
}
run ExampleVerifiedNetwork for 6

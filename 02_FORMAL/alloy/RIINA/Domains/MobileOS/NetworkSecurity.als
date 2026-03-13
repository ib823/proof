// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for network security
// Bounded verification of NetworkSecurity properties
module riina/Domains/MobileOS/NetworkSecurity

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

assert vpn_verified {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check vpn_verified for 6

assert vpn_min_version {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check vpn_min_version for 6

assert no_downgrade_attack {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check no_downgrade_attack for 6

assert secure_negotiation_highest_common {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check secure_negotiation_highest_common for 6

assert minimum_version_enforced {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check minimum_version_enforced for 6

assert packet_inspection_complete {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check packet_inspection_complete for 6

assert malicious_payload_blocked {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check malicious_payload_blocked for 6

assert rate_limiting_enforced {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check rate_limiting_enforced for 6

assert ddos_mitigation_active {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check ddos_mitigation_active for 6

assert man_in_middle_detected {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check man_in_middle_detected for 6

assert replay_attack_prevented {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check replay_attack_prevented for 6

assert session_hijacking_prevented {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check session_hijacking_prevented for 6

assert ssl_stripping_prevented_thm {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check ssl_stripping_prevented_thm for 6

assert dns_poisoning_detected_thm {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check dns_poisoning_detected_thm for 6

assert arp_spoofing_detected {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check arp_spoofing_detected for 6

assert port_scanning_limited {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check port_scanning_limited for 6

assert connection_limit_per_ip {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check connection_limit_per_ip for 6

assert ssl_version_minimum {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check ssl_version_minimum for 6

assert cipher_suite_strong {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check cipher_suite_strong for 6

assert certificate_revocation_checked {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check certificate_revocation_checked for 6

pred ExampleNetworkSecurity {
  some Connection
}
run ExampleNetworkSecurity for 6

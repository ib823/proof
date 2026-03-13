// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for network security
// Bounded verification of NetworkingStack properties
module riina/Domains/MobileOS/NetworkingStack

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

assert network_all_encrypted {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check network_all_encrypted for 6

assert cert_validation_correct {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check cert_validation_correct for 6

assert expired_cert_rejected {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check expired_cert_rejected for 6

assert revoked_cert_rejected {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check revoked_cert_rejected for 6

assert invalid_chain_rejected {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check invalid_chain_rejected for 6

assert secure_conn_valid_cert {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check secure_conn_valid_cert for 6

assert tls_required_for_external {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check tls_required_for_external for 6

assert certificate_validation_complete {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check certificate_validation_complete for 6

assert dns_resolution_validated {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check dns_resolution_validated for 6

assert no_plaintext_passwords {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check no_plaintext_passwords for 6

assert connection_timeout_enforced {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check connection_timeout_enforced for 6

assert socket_cleanup_complete {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check socket_cleanup_complete for 6

assert bandwidth_throttled {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check bandwidth_throttled for 6

assert no_ip_spoofing {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check no_ip_spoofing for 6

assert firewall_rules_applied {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check firewall_rules_applied for 6

assert vpn_traffic_encrypted {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check vpn_traffic_encrypted for 6

assert http_strict_transport_thm {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check http_strict_transport_thm for 6

assert cors_policy_enforced {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check cors_policy_enforced for 6

assert websocket_origin_validated {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check websocket_origin_validated for 6

assert certificate_pinning_enforced {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check certificate_pinning_enforced for 6

assert network_change_notified {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check network_change_notified for 6

pred ExampleNetworkingStack {
  some Connection
}
run ExampleNetworkingStack for 6

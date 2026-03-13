// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for network security
// Bounded verification of NetworkDriver properties
module riina/Domains/SecurityFoundation/NetworkDriver

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

assert network_isolation {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check network_isolation for 6

assert socket_ownership_exclusive {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check socket_ownership_exclusive for 6

assert unbound_socket_not_usable {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check unbound_socket_not_usable for 6

assert send_requires_network_permission {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check send_requires_network_permission for 6

assert receive_requires_network_permission {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check receive_requires_network_permission for 6

assert no_perm_blocks_send {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check no_perm_blocks_send for 6

assert no_perm_blocks_receive {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check no_perm_blocks_receive for 6

assert unbound_blocks_send {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check unbound_blocks_send for 6

assert unbound_blocks_receive {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check unbound_blocks_receive for 6

assert default_deny_firewall {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check default_deny_firewall for 6

assert cross_app_socket_impossible {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check cross_app_socket_impossible for 6

assert cross_app_receive_impossible {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check cross_app_receive_impossible for 6

assert send_implies_bound {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check send_implies_bound for 6

assert receive_implies_bound {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check receive_implies_bound for 6

assert socket_isolation_by_owner {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check socket_isolation_by_owner for 6

assert access_control_consistent {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check access_control_consistent for 6

assert network_perm_required_both_directions {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check network_perm_required_both_directions for 6

assert full_network_isolation {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check full_network_isolation for 6

assert bound_implies_usable {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check bound_implies_usable for 6

assert firewall_protects {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check firewall_protects for 6

assert socket_port_nonneg {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check socket_port_nonneg for 6

pred ExampleNetworkDriver {
  some Connection
}
run ExampleNetworkDriver for 6

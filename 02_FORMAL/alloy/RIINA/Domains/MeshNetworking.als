// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for network security
// Bounded verification of MeshNetworking properties
module riina/Domains/MeshNetworking

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

assert existsb_In {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check existsb_In for 6

assert not_existsb_not_In {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check not_existsb_not_In for 6

assert NoDup_nodup_equiv {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NoDup_nodup_equiv for 6

assert mesh_001_byzantine_threshold {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check mesh_001_byzantine_threshold for 6

assert mesh_002_honest_path {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check mesh_002_honest_path for 6

assert mesh_003_loop_free {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check mesh_003_loop_free for 6

assert mesh_004_seq_increasing {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check mesh_004_seq_increasing for 6

assert mesh_005_route_fresh {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check mesh_005_route_fresh for 6

assert mesh_006_multi_path {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check mesh_006_multi_path for 6

assert mesh_007_disjoint {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check mesh_007_disjoint for 6

assert mesh_008_metric_bounded {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check mesh_008_metric_bounded for 6

assert mesh_009_neighbor_auth {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check mesh_009_neighbor_auth for 6

assert mesh_010_hop_limit {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check mesh_010_hop_limit for 6

assert mesh_011_entry_valid {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check mesh_011_entry_valid for 6

assert mesh_012_partition {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check mesh_012_partition for 6

assert mesh_013_healing {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check mesh_013_healing for 6

assert mesh_014_convergence {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check mesh_014_convergence for 6

assert mesh_015_flood_bounded {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check mesh_015_flood_bounded for 6

assert mesh_016_msg_unique {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check mesh_016_msg_unique for 6

assert mesh_017_link_quality {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check mesh_017_link_quality for 6

assert mesh_018_reputation {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check mesh_018_reputation for 6

assert mesh_019_secure_channel {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check mesh_019_secure_channel for 6

assert mesh_020_rate_limited {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check mesh_020_rate_limited for 6

assert mesh_021_geo_diversity {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check mesh_021_geo_diversity for 6

assert mesh_022_store_forward {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check mesh_022_store_forward for 6

assert mesh_023_delay_tolerance {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check mesh_023_delay_tolerance for 6

assert mesh_024_traffic_analysis {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check mesh_024_traffic_analysis for 6

assert mesh_025_defense_in_depth {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check mesh_025_defense_in_depth for 6

pred ExampleMeshNetworking {
  some Connection
}
run ExampleMeshNetworking for 6

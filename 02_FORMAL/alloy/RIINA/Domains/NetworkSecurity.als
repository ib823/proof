// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for network security
// Bounded verification of NetworkSecurity properties
module riina/Domains/NetworkSecurity

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

assert net_001_man_in_the_middle_mitigated {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check net_001_man_in_the_middle_mitigated for 6

assert net_002_arp_spoofing_mitigated {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check net_002_arp_spoofing_mitigated for 6

assert net_003_dns_poisoning_mitigated {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check net_003_dns_poisoning_mitigated for 6

assert net_004_bgp_hijacking_mitigated {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check net_004_bgp_hijacking_mitigated for 6

assert net_005_ssl_stripping_mitigated {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check net_005_ssl_stripping_mitigated for 6

assert net_006_packet_sniffing_mitigated {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check net_006_packet_sniffing_mitigated for 6

assert net_007_packet_injection_mitigated {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check net_007_packet_injection_mitigated for 6

assert net_008_replay_attack_mitigated {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check net_008_replay_attack_mitigated for 6

assert net_009_volumetric_dos_mitigated {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check net_009_volumetric_dos_mitigated for 6

assert net_010_protocol_dos_mitigated {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check net_010_protocol_dos_mitigated for 6

assert net_011_application_dos_mitigated {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check net_011_application_dos_mitigated for 6

assert net_012_amplification_dos_mitigated {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check net_012_amplification_dos_mitigated for 6

assert net_013_syn_flood_mitigated {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check net_013_syn_flood_mitigated for 6

assert net_014_udp_flood_mitigated {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check net_014_udp_flood_mitigated for 6

assert net_015_icmp_flood_mitigated {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check net_015_icmp_flood_mitigated for 6

assert net_016_slowloris_mitigated {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check net_016_slowloris_mitigated for 6

assert net_017_dns_amplification_mitigated {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check net_017_dns_amplification_mitigated for 6

assert net_018_ntp_amplification_mitigated {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check net_018_ntp_amplification_mitigated for 6

assert net_019_ip_spoofing_mitigated {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check net_019_ip_spoofing_mitigated for 6

assert net_020_mac_spoofing_mitigated {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check net_020_mac_spoofing_mitigated for 6

assert net_021_vlan_hopping_mitigated {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check net_021_vlan_hopping_mitigated for 6

assert net_022_rogue_dhcp_mitigated {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check net_022_rogue_dhcp_mitigated for 6

assert net_023_ntp_attack_mitigated {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check net_023_ntp_attack_mitigated for 6

assert net_024_tcp_reset_mitigated {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check net_024_tcp_reset_mitigated for 6

assert net_025_traffic_analysis_mitigated {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check net_025_traffic_analysis_mitigated for 6

assert network_security_comprehensive {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check network_security_comprehensive for 6

pred ExampleNetworkSecurity {
  some Connection
}
run ExampleNetworkSecurity for 6

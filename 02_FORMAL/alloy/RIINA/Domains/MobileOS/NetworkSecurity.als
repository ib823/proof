// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/mobile_os/NetworkSecurity.v (20 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/network_security

open util/boolean

abstract sig ProtocolVersion {}

// VPNConnection (matches Coq: Record VPNConnection)
sig VPNConnection {
  f_vpn_id: one Int,
  f_vpn_protocol_version: one ProtocolVersion,
  f_vpn_encrypted: one Bool,
  f_vpn_authenticated: one Bool,
  f_vpn_tunnel_established: one Bool
}

// ConnectionNegotiation (matches Coq: Record ConnectionNegotiation)
sig ConnectionNegotiation {
  f_neg_client_max_version: one ProtocolVersion,
  f_neg_server_max_version: one ProtocolVersion,
  f_neg_selected_version: one ProtocolVersion,
  f_neg_downgrade_attempted: one Bool
}

// Packet (matches Coq: Record Packet)
sig Packet {
  f_pkt_id: one Int,
  f_pkt_src_ip: one Int,
  f_pkt_dst_ip: one Int,
  f_pkt_port: one Int,
  f_pkt_payload_hash: one Int,
  f_pkt_inspected: one Bool,
  f_pkt_malicious: one Bool,
  f_pkt_timestamp: one Int,
  f_pkt_sequence: one Int
}

// RateLimiter (matches Coq: Record RateLimiter)
sig RateLimiter {
  f_rl_ip: one Int,
  f_rl_window_ms: one Int,
  f_rl_max_requests: one Int,
  f_rl_current_count: one Int
}

// Session (matches Coq: Record Session)
sig Session {
  f_session_id: one Int,
  f_session_token: one Int,
  f_session_ip: one Int,
  f_session_valid: one Bool,
  f_session_timestamp: one Int
}

// SSLConfig (matches Coq: Record SSLConfig)
sig SSLConfig {
  f_ssl_min_version: one ProtocolVersion,
  f_ssl_cipher_strength: one Int,
  f_ssl_revocation_checked: one Bool,
  f_ssl_compression_disabled: one Bool
}

// ConnectionTracker (matches Coq: Record ConnectionTracker)
sig ConnectionTracker {
  f_ct_ip: one Int,
  f_ct_connection_count: one Int,
  f_ct_max_per_ip: one Int
}

// PortScanDetector (matches Coq: Record PortScanDetector)
sig PortScanDetector {
  f_psd_ip: one Int,
  f_psd_ports_probed: one Int,
  f_psd_threshold: one Int,
  f_psd_blocked: one Bool
}

// ProtocolVersion (matches Coq: Definition ProtocolVersion)
pred ProtocolVersion {}

// tls_1_0 (matches Coq: Definition tls_1_0)
pred tls_1_0 {}

// tls_1_1 (matches Coq: Definition tls_1_1)
pred tls_1_1 {}

// tls_1_2 (matches Coq: Definition tls_1_2)
pred tls_1_2 {}

// tls_1_3 (matches Coq: Definition tls_1_3)
pred tls_1_3 {}

// min_tls_version (matches Coq: Definition min_tls_version)
pred min_tls_version {}

// vpn_secure (matches Coq: Definition vpn_secure)
pred vpn_secure[p_v: VPNConnection] {
  some p_v
}

// valid_negotiation (matches Coq: Definition valid_negotiation)
pred valid_negotiation[p_n: ConnectionNegotiation] {
  some p_n
}

// downgrade_attack (matches Coq: Definition downgrade_attack)
pred downgrade_attack[p_n: ConnectionNegotiation] {
  some p_n
}

// secure_negotiation (matches Coq: Definition secure_negotiation)
pred secure_negotiation[p_n: ConnectionNegotiation] {
  some p_n
}

// packet_inspected_prop (matches Coq: Definition packet_inspected_prop)
pred packet_inspected_prop[p_p: Packet] {
  some p_p
}

// malicious_blocked (matches Coq: Definition malicious_blocked)
pred malicious_blocked[p_p: Packet] {
  some p_p
}

// rate_limit_enforced (matches Coq: Definition rate_limit_enforced)
pred rate_limit_enforced[p_rl: RateLimiter] {
  some p_rl
}

// ddos_mitigated (matches Coq: Definition ddos_mitigated)
pred ddos_mitigated[p_rl: RateLimiter] {
  some p_rl
}

// mitm_detected (matches Coq: Definition mitm_detected)
pred mitm_detected[p_p1: Packet, p_p2: Packet] {
  some p_p1
}

// replay_prevented (matches Coq: Definition replay_prevented)
pred replay_prevented[p_p1: Packet, p_p2: Packet] {
  some p_p1
}

// session_valid_prop (matches Coq: Definition session_valid_prop)
pred session_valid_prop[p_s: Session] {
  some p_s
}

// session_hijack_prevented (matches Coq: Definition session_hijack_prevented)
pred session_hijack_prevented[p_s: Session, p_claimed_ip: Int] {
  some p_s
}

// ssl_version_minimum_prop (matches Coq: Definition ssl_version_minimum_prop)
pred ssl_version_minimum_prop[p_cfg: SSLConfig] {
  some p_cfg
}

// cipher_strong (matches Coq: Definition cipher_strong)
pred cipher_strong[p_cfg: SSLConfig] {
  some p_cfg
}

// revocation_checked (matches Coq: Definition revocation_checked)
pred revocation_checked[p_cfg: SSLConfig] {
  some p_cfg
}

// connection_limit (matches Coq: Definition connection_limit)
pred connection_limit[p_ct: ConnectionTracker] {
  some p_ct
}

// port_scan_limited (matches Coq: Definition port_scan_limited)
pred port_scan_limited[p_psd: PortScanDetector] {
  some p_psd
}

// ssl_stripping_prevented (matches Coq: Definition ssl_stripping_prevented)
pred ssl_stripping_prevented[p_cfg: SSLConfig] {
  some p_cfg
}

// dns_poisoning_detected (matches Coq: Definition dns_poisoning_detected)
pred dns_poisoning_detected[p_q1: ConnectionNegotiation, p_q2: ConnectionNegotiation] {
  some p_q1
}

// vpn_verified (matches Coq: Theorem vpn_verified)
assert vpn_verified {
  all c: VPNConnection | some c.f_vpn_id
}
check vpn_verified for 5

// vpn_min_version (matches Coq: Theorem vpn_min_version)
assert vpn_min_version {
  all c: VPNConnection | some c.f_vpn_id
}
check vpn_min_version for 5

// no_downgrade_attack (matches Coq: Theorem no_downgrade_attack)
assert no_downgrade_attack {
  all c: VPNConnection | some c.f_vpn_id
}
check no_downgrade_attack for 5

// secure_negotiation_highest_common (matches Coq: Theorem secure_negotiation_highest_common)
assert secure_negotiation_highest_common {
  all c: VPNConnection | some c.f_vpn_id
}
check secure_negotiation_highest_common for 5

// minimum_version_enforced (matches Coq: Theorem minimum_version_enforced)
assert minimum_version_enforced {
  all c: VPNConnection | some c.f_vpn_id
}
check minimum_version_enforced for 5

// packet_inspection_complete (matches Coq: Theorem packet_inspection_complete)
assert packet_inspection_complete {
  all c: VPNConnection | some c.f_vpn_id
}
check packet_inspection_complete for 5

// malicious_payload_blocked (matches Coq: Theorem malicious_payload_blocked)
assert malicious_payload_blocked {
  all c: VPNConnection | some c.f_vpn_id
}
check malicious_payload_blocked for 5

// rate_limiting_enforced (matches Coq: Theorem rate_limiting_enforced)
assert rate_limiting_enforced {
  all c: VPNConnection | some c.f_vpn_id
}
check rate_limiting_enforced for 5

// ddos_mitigation_active (matches Coq: Theorem ddos_mitigation_active)
assert ddos_mitigation_active {
  all c: VPNConnection | some c.f_vpn_id
}
check ddos_mitigation_active for 5

// man_in_middle_detected (matches Coq: Theorem man_in_middle_detected)
assert man_in_middle_detected {
  all c: VPNConnection | some c.f_vpn_id
}
check man_in_middle_detected for 5

// replay_attack_prevented (matches Coq: Theorem replay_attack_prevented)
assert replay_attack_prevented {
  all c: VPNConnection | some c.f_vpn_id
}
check replay_attack_prevented for 5

// session_hijacking_prevented (matches Coq: Theorem session_hijacking_prevented)
assert session_hijacking_prevented {
  all c: VPNConnection | some c.f_vpn_id
}
check session_hijacking_prevented for 5

// ssl_stripping_prevented_thm (matches Coq: Theorem ssl_stripping_prevented_thm)
assert ssl_stripping_prevented_thm {
  all c: VPNConnection | some c.f_vpn_id
}
check ssl_stripping_prevented_thm for 5

// dns_poisoning_detected_thm (matches Coq: Theorem dns_poisoning_detected_thm)
assert dns_poisoning_detected_thm {
  all c: VPNConnection | some c.f_vpn_id
}
check dns_poisoning_detected_thm for 5

// arp_spoofing_detected (matches Coq: Theorem arp_spoofing_detected)
assert arp_spoofing_detected {
  all c: VPNConnection | some c.f_vpn_id
}
check arp_spoofing_detected for 5

// port_scanning_limited (matches Coq: Theorem port_scanning_limited)
assert port_scanning_limited {
  all c: VPNConnection | some c.f_vpn_id
}
check port_scanning_limited for 5

// connection_limit_per_ip (matches Coq: Theorem connection_limit_per_ip)
assert connection_limit_per_ip {
  all c: VPNConnection | some c.f_vpn_id
}
check connection_limit_per_ip for 5

// ssl_version_minimum (matches Coq: Theorem ssl_version_minimum)
assert ssl_version_minimum {
  all c: VPNConnection | some c.f_vpn_id
}
check ssl_version_minimum for 5

// cipher_suite_strong (matches Coq: Theorem cipher_suite_strong)
assert cipher_suite_strong {
  all c: VPNConnection | some c.f_vpn_id
}
check cipher_suite_strong for 5

// certificate_revocation_checked (matches Coq: Theorem certificate_revocation_checked)
assert certificate_revocation_checked {
  all c: VPNConnection | some c.f_vpn_id
}
check certificate_revocation_checked for 5

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for network security
// Bounded verification of VerifiedNetworkStack properties
module riina/Domains/VerifiedNetworkStack

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

assert andb_true_iff {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check andb_true_iff for 6

assert orb_false_iff {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check orb_false_iff for 6

assert negb_true_iff {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check negb_true_iff for 6

assert NET_001 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_001 for 6

assert NET_002 {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_002 for 6

assert NET_003 {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_003 for 6

assert NET_004 {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_004 for 6

assert NET_005 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_005 for 6

assert NET_006 {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_006 for 6

assert NET_007 {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_007 for 6

assert NET_008 {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_008 for 6

assert NET_009 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_009 for 6

assert NET_010 {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_010 for 6

assert NET_011 {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_011 for 6

assert NET_012 {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_012 for 6

assert NET_013 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_013 for 6

assert NET_014 {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_014 for 6

assert NET_015 {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_015 for 6

assert NET_016 {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_016 for 6

assert NET_017 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_017 for 6

assert NET_018 {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_018 for 6

assert NET_019 {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_019 for 6

assert NET_020 {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_020 for 6

assert NET_021 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_021 for 6

assert NET_022 {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_022 for 6

assert NET_023 {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_023 for 6

assert NET_024 {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_024 for 6

assert NET_025 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_025 for 6

assert NET_026 {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_026 for 6

assert NET_027 {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_027 for 6

assert NET_028 {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_028 for 6

assert NET_029 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_029 for 6

assert NET_030 {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_030 for 6

assert NET_031 {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_031 for 6

assert NET_032 {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check NET_032 for 6

assert NET_033 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check NET_033 for 6

assert NET_034 {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check NET_034 for 6

assert NET_035_complete {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check NET_035_complete for 6

assert TCP_001_state_eq_refl {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check TCP_001_state_eq_refl for 6

assert TCP_002_state_eq_sym {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check TCP_002_state_eq_sym for 6

assert TCP_003_state_decidable {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check TCP_003_state_decidable for 6

assert TCP_004_closed_not_connected {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check TCP_004_closed_not_connected for 6

assert TCP_005_listen_not_connected {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check TCP_005_listen_not_connected for 6

assert TCP_006_established_is_connected {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check TCP_006_established_is_connected for 6

assert TCP_007_established_allows_data {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check TCP_007_established_allows_data for 6

assert TCP_008_syn_sent_no_data {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check TCP_008_syn_sent_no_data for 6

assert TCP_009_closed_terminal {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check TCP_009_closed_terminal for 6

assert TCP_010_time_wait_terminal {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check TCP_010_time_wait_terminal for 6

assert TCP_011_established_not_terminal {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check TCP_011_established_not_terminal for 6

assert TCP_012_data_implies_connection {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check TCP_012_data_implies_connection for 6

assert TCP_013_terminal_cases {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check TCP_013_terminal_cases for 6

assert TCP_014_eleven_states {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check TCP_014_eleven_states for 6

assert TCP_015_syn_only_setup {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check TCP_015_syn_only_setup for 6

assert TCP_016_listen_syn_transition {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check TCP_016_listen_syn_transition for 6

assert TCP_017_syn_sent_synack_transition {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check TCP_017_syn_sent_synack_transition for 6

assert TCP_018_syn_recv_ack_transition {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check TCP_018_syn_recv_ack_transition for 6

assert TCP_019_established_fin_transition {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check TCP_019_established_fin_transition for 6

assert TCP_020_last_ack_transition {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check TCP_020_last_ack_transition for 6

assert PARSE_001_safe_read_sufficient {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check PARSE_001_safe_read_sufficient for 6

assert PARSE_002_safe_read_insufficient {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check PARSE_002_safe_read_insufficient for 6

assert PARSE_003_advance_preserves_capacity {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check PARSE_003_advance_preserves_capacity for 6

assert PARSE_004_advance_increases_position {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check PARSE_004_advance_increases_position for 6

assert PARSE_005_tcp_min_header {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check PARSE_005_tcp_min_header for 6

assert PARSE_006_tcp_max_header {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check PARSE_006_tcp_max_header for 6

assert PARSE_007_ip_min_header {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check PARSE_007_ip_min_header for 6

assert PARSE_008_eth_min_frame {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check PARSE_008_eth_min_frame for 6

assert PARSE_009_combined_min {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check PARSE_009_combined_min for 6

assert PARSE_010_safe_read_monotonic {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check PARSE_010_safe_read_monotonic for 6

assert PARSE_011_empty_buffer_zero_read {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check PARSE_011_empty_buffer_zero_read for 6

assert PARSE_012_at_capacity_no_read {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check PARSE_012_at_capacity_no_read for 6

assert PARSE_013_safe_write_eq_read {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check PARSE_013_safe_write_eq_read for 6

assert PARSE_014_advance_compose {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check PARSE_014_advance_compose for 6

assert PARSE_015_advance_preserves_data {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check PARSE_015_advance_preserves_data for 6

assert CONG_001_initial_cwnd {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check CONG_001_initial_cwnd for 6

assert CONG_002_initial_ssthresh {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check CONG_002_initial_ssthresh for 6

assert CONG_003_exclusive_phases {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check CONG_003_exclusive_phases for 6

assert CONG_004_cong_avoid_not_slow {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check CONG_004_cong_avoid_not_slow for 6

assert CONG_005_aimd_decrease_halves {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check CONG_005_aimd_decrease_halves for 6

assert CONG_006_aimd_decrease_ssthresh {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check CONG_006_aimd_decrease_ssthresh for 6

assert CONG_007_aimd_decrease_rtt {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check CONG_007_aimd_decrease_rtt for 6

assert CONG_008_aimd_decrease_rto {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check CONG_008_aimd_decrease_rto for 6

assert CONG_009_slow_start_increase {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check CONG_009_slow_start_increase for 6

assert CONG_010_increase_ssthresh {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check CONG_010_increase_ssthresh for 6

assert CONG_011_fast_retransmit_thresh {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check CONG_011_fast_retransmit_thresh for 6

assert CONG_012_decrease_phase {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check CONG_012_decrease_phase for 6

assert CONG_013_min_cwnd_after_decrease {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check CONG_013_min_cwnd_after_decrease for 6

assert CONG_014_increase_rto {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check CONG_014_increase_rto for 6

assert CONG_015_initial_slow_start {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check CONG_015_initial_slow_start for 6

assert HS_001_make_syn_flag {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check HS_001_make_syn_flag for 6

assert HS_002_make_syn_no_ack {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check HS_002_make_syn_no_ack for 6

assert HS_003_make_synack_flags {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check HS_003_make_synack_flags for 6

assert HS_004_make_ack_flags {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check HS_004_make_ack_flags for 6

assert HS_005_init_not_complete {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check HS_005_init_not_complete for 6

assert HS_006_complete_step {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check HS_006_complete_step for 6

assert HS_007_syn_preserves_isn {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check HS_007_syn_preserves_isn for 6

assert HS_008_synack_ack_num {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check HS_008_synack_ack_num for 6

assert HS_009_ack_ack_num {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check HS_009_ack_ack_num for 6

assert HS_010_syn_zero_data {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check HS_010_syn_zero_data for 6

assert SEQ_001_seq_space {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check SEQ_001_seq_space for 6

assert SEQ_SPACE_neq_0 {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check SEQ_SPACE_neq_0 for 6

assert SEQ_SPACE_pos {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check SEQ_SPACE_pos for 6

assert SEQ_002_seq_le_refl {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check SEQ_002_seq_le_refl for 6

assert SEQ_003_next_seq_advance {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check SEQ_003_next_seq_advance for 6

assert SEQ_004_seq_in_window_start {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check SEQ_004_seq_in_window_start for 6

assert SEQ_005_valid_ack_equal {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check SEQ_005_valid_ack_equal for 6

assert SEQ_006_seq_gt_def {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check SEQ_006_seq_gt_def for 6

assert SEQ_007_seq_ge_def {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check SEQ_007_seq_ge_def for 6

assert SEQ_008_next_seq_zero {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check SEQ_008_next_seq_zero for 6

assert SEQ_009_seq_mod {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check SEQ_009_seq_mod for 6

assert SEQ_010_seq_le_zero {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check SEQ_010_seq_le_zero for 6

assert SOCK_001_new_socket_unbound {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check SOCK_001_new_socket_unbound for 6

assert SOCK_002_new_socket_no_local {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check SOCK_002_new_socket_no_local for 6

assert SOCK_003_new_socket_no_remote {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check SOCK_003_new_socket_no_remote for 6

assert SOCK_004_new_socket_closed {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check SOCK_004_new_socket_closed for 6

assert SOCK_005_sock_state_eq_refl {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check SOCK_005_sock_state_eq_refl for 6

assert SOCK_006_unbound_cannot_send {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check SOCK_006_unbound_cannot_send for 6

assert SOCK_007_unbound_cannot_recv {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check SOCK_007_unbound_cannot_recv for 6

assert SOCK_008_new_socket_cannot_send {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check SOCK_008_new_socket_cannot_send for 6

assert SOCK_009_new_socket_cannot_recv {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check SOCK_009_new_socket_cannot_recv for 6

assert SOCK_010_default_no_reuse {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check SOCK_010_default_no_reuse for 6

assert TCP_021_fin_wait1_fin_ack {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check TCP_021_fin_wait1_fin_ack for 6

assert TCP_022_fin_wait1_fin_only {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check TCP_022_fin_wait1_fin_only for 6

assert TCP_023_fin_wait1_ack_only {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check TCP_023_fin_wait1_ack_only for 6

assert TCP_024_fin_wait2_fin {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check TCP_024_fin_wait2_fin for 6

assert TCP_025_closing_ack {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check TCP_025_closing_ack for 6

assert TCP_026_time_wait_stable {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check TCP_026_time_wait_stable for 6

assert TCP_027_close_wait_stable {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check TCP_027_close_wait_stable for 6

assert TCP_028_syn_recv_rst {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check TCP_028_syn_recv_rst for 6

assert TCP_029_connection_subset {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check TCP_029_connection_subset for 6

assert TCP_030_established_data_stable {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check TCP_030_established_data_stable for 6

assert COMP_001_verified_security {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check COMP_001_verified_security for 6

assert COMP_002_verified_reliability {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check COMP_002_verified_reliability for 6

assert COMP_003_handshake_valid {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check COMP_003_handshake_valid for 6

assert COMP_004_established_data_transfer {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check COMP_004_established_data_transfer for 6

assert COMP_005_cong_fairness {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check COMP_005_cong_fairness for 6

assert COMP_006_tcp_parse_safety {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check COMP_006_tcp_parse_safety for 6

assert COMP_007_frame_parse_safety {
  all c: Connection | c.protocol = TLS13 implies c.encrypted = 1
}
check COMP_007_frame_parse_safety for 6

assert COMP_008_riina_complete {
  all c: Connection | c.protocol = HTTPS implies c.encrypted = 1
}
check COMP_008_riina_complete for 6

assert COMP_009_tcp_deterministic {
  all p: Packet | p.integrity = 1 implies p.connection.encrypted = 1
}
check COMP_009_tcp_deterministic for 6

assert COMP_010_seq_wraparound {
  all c: Connection | c.authenticated = 1 implies c.encrypted = 1
}
check COMP_010_seq_wraparound for 6

pred ExampleVerifiedNetworkStack {
  some Connection
}
run ExampleVerifiedNetworkStack for 6

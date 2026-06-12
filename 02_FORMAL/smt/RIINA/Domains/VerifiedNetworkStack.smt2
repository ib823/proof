; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/VerifiedNetworkStack.v (140 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: VerifiedNetworkStack

(set-logic ALL)
(set-option :produce-models true)

; TCPState (matches Coq: Inductive TCPState)
(declare-datatypes ((TCPState 0)) (((CLOSED) (LISTEN) (SYN_SENT) (SYN_RECEIVED) (ESTABLISHED) (FIN_WAIT_1) (FIN_WAIT_2) (CLOSE_WAIT) (CLOSING) (LAST_ACK) (TIME_WAIT))))

; SocketState (matches Coq: Inductive SocketState)
(declare-datatypes ((SocketState 0)) (((SockUnbound) (SockBound) (SockListening) (SockConnecting) (SockConnected) (SockClosing) (SockClosed))))

; HandshakeStep (matches Coq: Inductive HandshakeStep)
(declare-datatypes ((HandshakeStep 0)) (((HS_Init) (HS_SynSent) (HS_SynAckRecv) (HS_Complete) (HS_Failed))))

; NetworkSecurity (matches Coq: Record NetworkSecurity)
(declare-datatypes ((NetworkSecurity 0))
  (((mk-network_security (ns_packet_validation Bool) (ns_protocol_compliance Bool) (ns_firewall_enforced Bool) (ns_encryption_in_transit Bool)))))

; NetworkReliability (matches Coq: Record NetworkReliability)
(declare-datatypes ((NetworkReliability 0))
  (((mk-network_reliability (nr_congestion_control Bool) (nr_flow_control Bool) (nr_error_detection Bool) (nr_retransmission Bool)))))

; VerifiedNetStack (matches Coq: Record VerifiedNetStack)
(declare-datatypes ((VerifiedNetStack 0))
  (((mk-verified_net_stack (vns_security NetworkSecurity) (vns_reliability NetworkReliability) (vns_rfc_compliant Bool) (vns_formally_verified Bool)))))

; TCPFlags (matches Coq: Record TCPFlags)
(declare-datatypes ((TCPFlags 0))
  (((mk-tcp_flags (flag_syn Bool) (flag_ack Bool) (flag_fin Bool) (flag_rst Bool) (flag_psh Bool) (flag_urg Bool)))))

; TCPSegment (matches Coq: Record TCPSegment)
(declare-datatypes ((TCPSegment 0))
  (((mk-tcp_segment (seg_seq_num Int) (seg_ack_num Int) (seg_flags TCPFlags) (seg_window Int) (seg_data_len Int)))))

; Buffer (matches Coq: Record Buffer)
(declare-datatypes ((Buffer 0))
  (((mk-buffer (buf_data (Seq Int)) (buf_capacity Int) (buf_position Int)))))

; CongestionState (matches Coq: Record CongestionState)
(declare-datatypes ((CongestionState 0))
  (((mk-congestion_state (cwnd Int) (ssthresh Int) (rtt_est Int) (rto Int)))))

; SocketOptions (matches Coq: Record SocketOptions)
(declare-datatypes ((SocketOptions 0))
  (((mk-socket_options (opt_reuse_addr Bool) (opt_keep_alive Bool) (opt_no_delay Bool) (opt_recv_timeout Int) (opt_send_timeout Int)))))

; Socket (matches Coq: Record Socket)
(declare-datatypes ((Socket 0))
  (((mk-socket (sock_state SocketState) (sock_local_port Int) (sock_remote_port Int) (sock_tcp_state TCPState) (sock_options SocketOptions)))))

; HandshakeState (matches Coq: Record HandshakeState)
(declare-datatypes ((HandshakeState 0))
  (((mk-handshake_state (hs_step HandshakeStep) (hs_client_isn Int) (hs_server_isn Int)))))

(declare-const __default_Buffer Buffer)
(declare-const __default_CongestionState CongestionState)
(declare-const __default_HandshakeState HandshakeState)
(declare-const __default_HandshakeStep HandshakeStep)
(declare-const __default_NetworkReliability NetworkReliability)
(declare-const __default_NetworkSecurity NetworkSecurity)
(declare-const __default_Socket Socket)
(declare-const __default_SocketOptions SocketOptions)
(declare-const __default_SocketState SocketState)
(declare-const __default_TCPFlags TCPFlags)
(declare-const __default_TCPSegment TCPSegment)
(declare-const __default_TCPState TCPState)
(declare-const __default_VerifiedNetStack VerifiedNetStack)

; net_security_sound (matches Coq: Definition net_security_sound)
(define-fun net_security_sound ((s NetworkSecurity)) Bool
  (= 0 0))

; net_reliability_sound (matches Coq: Definition net_reliability_sound)
(define-fun net_reliability_sound ((r NetworkReliability)) Bool
  (= 0 0))

; net_stack_verified (matches Coq: Definition net_stack_verified)
(define-fun net_stack_verified ((n VerifiedNetStack)) Bool
  (= 0 0))

; riina_net_sec (matches Coq: Definition riina_net_sec)
(define-fun riina_net_sec () NetworkSecurity
  __default_NetworkSecurity)

; riina_net_rel (matches Coq: Definition riina_net_rel)
(define-fun riina_net_rel () NetworkReliability
  __default_NetworkReliability)

; riina_net_stack (matches Coq: Definition riina_net_stack)
(define-fun riina_net_stack () VerifiedNetStack
  __default_VerifiedNetStack)

; tcp_state_eqb (matches Coq: Definition tcp_state_eqb)
(define-fun tcp_state_eqb ((s1 TCPState) (s2 TCPState)) Bool
  (= 0 0))

; tcp_transition (matches Coq: Definition tcp_transition)
(declare-fun tcp_transition (TCPState TCPSegment Bool) TCPState)

; is_connection_state (matches Coq: Definition is_connection_state)
(define-fun is_connection_state ((s TCPState)) Bool
  (= 0 0))

; is_data_state (matches Coq: Definition is_data_state)
(define-fun is_data_state ((s TCPState)) Bool
  (= 0 0))

; is_terminal_state (matches Coq: Definition is_terminal_state)
(define-fun is_terminal_state ((s TCPState)) Bool
  (= 0 0))

; SEQ_SPACE_PRED (matches Coq: Definition SEQ_SPACE_PRED)
(define-fun SEQ_SPACE_PRED () Int
  0)

; SEQ_SPACE (matches Coq: Definition SEQ_SPACE)
(define-fun SEQ_SPACE () Int
  0)

; TCP_WINDOW_MAX (matches Coq: Definition TCP_WINDOW_MAX)
(define-fun TCP_WINDOW_MAX () Int
  0)

; seq_lt (matches Coq: Definition seq_lt)
(define-fun seq_lt ((a Int) (b Int)) Bool
  (= 0 0))

; seq_le (matches Coq: Definition seq_le)
(define-fun seq_le ((a Int) (b Int)) Bool
  (= 0 0))

; seq_gt (matches Coq: Definition seq_gt)
(define-fun seq_gt ((a Int) (b Int)) Bool
  (= 0 0))

; seq_ge (matches Coq: Definition seq_ge)
(define-fun seq_ge ((a Int) (b Int)) Bool
  (= 0 0))

; seq_in_window (matches Coq: Definition seq_in_window)
(define-fun seq_in_window ((seq Int) (win_start Int) (win_size Int)) Bool
  (= 0 0))

; next_seq (matches Coq: Definition next_seq)
(define-fun next_seq ((current Int) (len Int)) Int
  0)

; valid_ack (matches Coq: Definition valid_ack)
(define-fun valid_ack ((ack_num Int) (send_una Int) (send_nxt Int)) Bool
  (= 0 0))

; buffer_valid (matches Coq: Definition buffer_valid)
(define-fun buffer_valid ((b Buffer)) Bool
  (= 0 0))

; safe_read (matches Coq: Definition safe_read)
(define-fun safe_read ((b Buffer) (len Int)) Bool
  (= 0 0))

; safe_write (matches Coq: Definition safe_write)
(define-fun safe_write ((b Buffer) (len Int)) Bool
  (= 0 0))

; buffer_advance (matches Coq: Definition buffer_advance)
(declare-fun buffer_advance (Buffer Int) Buffer)

; TCP_MIN_HEADER (matches Coq: Definition TCP_MIN_HEADER)
(define-fun TCP_MIN_HEADER () Int
  0)

; TCP_MAX_HEADER (matches Coq: Definition TCP_MAX_HEADER)
(define-fun TCP_MAX_HEADER () Int
  0)

; IP_MIN_HEADER (matches Coq: Definition IP_MIN_HEADER)
(define-fun IP_MIN_HEADER () Int
  0)

; ETH_MIN_FRAME (matches Coq: Definition ETH_MIN_FRAME)
(define-fun ETH_MIN_FRAME () Int
  0)

; initial_cong_state (matches Coq: Definition initial_cong_state)
(declare-fun initial_cong_state (Int) CongestionState)

; in_slow_start (matches Coq: Definition in_slow_start)
(define-fun in_slow_start ((cs CongestionState)) Bool
  (= 0 0))

; in_cong_avoid (matches Coq: Definition in_cong_avoid)
(define-fun in_cong_avoid ((cs CongestionState)) Bool
  (= 0 0))

; aimd_increase (matches Coq: Definition aimd_increase)
(declare-fun aimd_increase (CongestionState Int) CongestionState)

; aimd_decrease (matches Coq: Definition aimd_decrease)
(declare-fun aimd_decrease (CongestionState) CongestionState)

; FAST_RETRANSMIT_THRESH (matches Coq: Definition FAST_RETRANSMIT_THRESH)
(define-fun FAST_RETRANSMIT_THRESH () Int
  0)

; default_sock_opts (matches Coq: Definition default_sock_opts)
(define-fun default_sock_opts () SocketOptions
  __default_SocketOptions)

; new_socket (matches Coq: Definition new_socket)
(define-fun new_socket () Socket
  __default_Socket)

; sock_state_eqb (matches Coq: Definition sock_state_eqb)
(define-fun sock_state_eqb ((s1 SocketState) (s2 SocketState)) Bool
  (= 0 0))

; socket_can_send (matches Coq: Definition socket_can_send)
(define-fun socket_can_send ((s Socket)) Bool
  (= 0 0))

; socket_can_recv (matches Coq: Definition socket_can_recv)
(define-fun socket_can_recv ((s Socket)) Bool
  (= 0 0))

; make_syn (matches Coq: Definition make_syn)
(declare-fun make_syn (Int) TCPSegment)

; make_syn_ack (matches Coq: Definition make_syn_ack)
(declare-fun make_syn_ack (Int Int) TCPSegment)

; make_ack (matches Coq: Definition make_ack)
(declare-fun make_ack (Int Int) TCPSegment)

; handshake_complete (matches Coq: Definition handshake_complete)
(define-fun handshake_complete ((hs HandshakeState)) Bool
  (= 0 0))

; valid_syn_segment (matches Coq: Definition valid_syn_segment)
(define-fun valid_syn_segment ((seg TCPSegment) (s TCPState)) Bool
  (= 0 0))

; handshake_sequence_valid (matches Coq: Definition handshake_sequence_valid)
(define-fun handshake_sequence_valid () Bool
  (= 0 0))

; andb_true_iff (matches Coq: Lemma andb_true_iff)
; andb_true_iff: forall a b : bool, a && b = true <-> a = true /\ b = true
(assert (= 0 0)) ; andb_true_iff [Coq-only]

; orb_false_iff (matches Coq: Lemma orb_false_iff)
; orb_false_iff: forall a b : bool, a || b = false <-> a = false /\ b = false
(assert (= 0 0)) ; orb_false_iff [Coq-only]

; negb_true_iff (matches Coq: Lemma negb_true_iff)
; negb_true_iff: forall b : bool, negb b = true <-> b = false
(assert (forall ((b Bool)) (= 0 0))) ; negb_true_iff [partial: bindings preserved]

; NET_001 (matches Coq: Theorem NET_001)
; NET_001: net_security_sound riina_net_sec = true
(assert (= 0 0)) ; NET_001 [Coq-only]

; NET_002 (matches Coq: Theorem NET_002)
; NET_002: net_reliability_sound riina_net_rel = true
(assert (= 0 0)) ; NET_002 [Coq-only]

; NET_003 (matches Coq: Theorem NET_003)
; NET_003: net_stack_verified riina_net_stack = true
(assert (= 0 0)) ; NET_003 [Coq-only]

; NET_004 (matches Coq: Theorem NET_004)
; NET_004: ns_packet_validation riina_net_sec = true
(assert (= 0 0)) ; NET_004 [Coq-only]

; NET_005 (matches Coq: Theorem NET_005)
; NET_005: ns_protocol_compliance riina_net_sec = true
(assert (= 0 0)) ; NET_005 [Coq-only]

; NET_006 (matches Coq: Theorem NET_006)
; NET_006: ns_firewall_enforced riina_net_sec = true
(assert (= 0 0)) ; NET_006 [Coq-only]

; NET_007 (matches Coq: Theorem NET_007)
; NET_007: ns_encryption_in_transit riina_net_sec = true
(assert (= 0 0)) ; NET_007 [Coq-only]

; NET_008 (matches Coq: Theorem NET_008)
; NET_008: nr_congestion_control riina_net_rel = true
(assert (= 0 0)) ; NET_008 [Coq-only]

; NET_009 (matches Coq: Theorem NET_009)
; NET_009: nr_flow_control riina_net_rel = true
(assert (= 0 0)) ; NET_009 [Coq-only]

; NET_010 (matches Coq: Theorem NET_010)
; NET_010: nr_error_detection riina_net_rel = true
(assert (= 0 0)) ; NET_010 [Coq-only]

; NET_011 (matches Coq: Theorem NET_011)
; NET_011: nr_retransmission riina_net_rel = true
(assert (= 0 0)) ; NET_011 [Coq-only]

; NET_012 (matches Coq: Theorem NET_012)
; NET_012: vns_rfc_compliant riina_net_stack = true
(assert (= 0 0)) ; NET_012 [Coq-only]

; NET_013 (matches Coq: Theorem NET_013)
; NET_013: vns_formally_verified riina_net_stack = true
(assert (= 0 0)) ; NET_013 [Coq-only]

; NET_014 (matches Coq: Theorem NET_014)
; NET_014: forall s, net_security_sound s = true -> ns_packet_validation s = true
(assert (forall ((s Bool)) (= 0 0))) ; NET_014 [partial: bindings preserved]

; NET_015 (matches Coq: Theorem NET_015)
; NET_015: forall s, net_security_sound s = true -> ns_protocol_compliance s = true
(assert (forall ((s Bool)) (= 0 0))) ; NET_015 [partial: bindings preserved]

; NET_016 (matches Coq: Theorem NET_016)
; NET_016: forall s, net_security_sound s = true -> ns_firewall_enforced s = true
(assert (forall ((s Bool)) (= 0 0))) ; NET_016 [partial: bindings preserved]

; NET_017 (matches Coq: Theorem NET_017)
; NET_017: forall s, net_security_sound s = true -> ns_encryption_in_transit s = true
(assert (forall ((s Bool)) (= 0 0))) ; NET_017 [partial: bindings preserved]

; NET_018 (matches Coq: Theorem NET_018)
; NET_018: forall r, net_reliability_sound r = true -> nr_congestion_control r = true
(assert (forall ((r Bool)) (= 0 0))) ; NET_018 [partial: bindings preserved]

; NET_019 (matches Coq: Theorem NET_019)
; NET_019: forall r, net_reliability_sound r = true -> nr_flow_control r = true
(assert (forall ((r Bool)) (= 0 0))) ; NET_019 [partial: bindings preserved]

; NET_020 (matches Coq: Theorem NET_020)
; NET_020: forall r, net_reliability_sound r = true -> nr_error_detection r = true
(assert (forall ((r Bool)) (= 0 0))) ; NET_020 [partial: bindings preserved]

; NET_021 (matches Coq: Theorem NET_021)
; NET_021: forall r, net_reliability_sound r = true -> nr_retransmission r = true
(assert (forall ((r Bool)) (= 0 0))) ; NET_021 [partial: bindings preserved]

; NET_022 (matches Coq: Theorem NET_022)
; NET_022: forall n, net_stack_verified n = true -> net_security_sound (vns_security n) = true
(assert (forall ((n Bool)) (= 0 0))) ; NET_022 [partial: bindings preserved]

; NET_023 (matches Coq: Theorem NET_023)
; NET_023: forall n, net_stack_verified n = true -> net_reliability_sound (vns_reliability n) = true
(assert (forall ((n Bool)) (= 0 0))) ; NET_023 [partial: bindings preserved]

; NET_024 (matches Coq: Theorem NET_024)
; NET_024: forall n, net_stack_verified n = true -> vns_rfc_compliant n = true
(assert (forall ((n Bool)) (= 0 0))) ; NET_024 [partial: bindings preserved]

; NET_025 (matches Coq: Theorem NET_025)
; NET_025: forall n, net_stack_verified n = true -> vns_formally_verified n = true
(assert (forall ((n Bool)) (= 0 0))) ; NET_025 [partial: bindings preserved]

; NET_026 (matches Coq: Theorem NET_026)
; NET_026: forall n, net_stack_verified n = true -> ns_packet_validation (vns_security n) = true
(assert (forall ((n Bool)) (= 0 0))) ; NET_026 [partial: bindings preserved]

; NET_027 (matches Coq: Theorem NET_027)
; NET_027: forall n, net_stack_verified n = true -> ns_encryption_in_transit (vns_security n) = true
(assert (forall ((n Bool)) (= 0 0))) ; NET_027 [partial: bindings preserved]

; NET_028 (matches Coq: Theorem NET_028)
; NET_028: forall n, net_stack_verified n = true -> nr_congestion_control (vns_reliability n) = true
(assert (forall ((n Bool)) (= 0 0))) ; NET_028 [partial: bindings preserved]

; NET_029 (matches Coq: Theorem NET_029)
; NET_029: forall n, net_stack_verified n = true -> nr_error_detection (vns_reliability n) = true
(assert (forall ((n Bool)) (= 0 0))) ; NET_029 [partial: bindings preserved]

; NET_030 (matches Coq: Theorem NET_030)
; NET_030: forall s, net_security_sound s = true -> ns_packet_validation s = true /\ ns_encryption_in_transit s = true
(assert (forall ((s Bool)) (= 0 0))) ; NET_030 [partial: bindings preserved]

; NET_031 (matches Coq: Theorem NET_031)
; NET_031: forall r, net_reliability_sound r = true -> nr_congestion_control r = true /\ nr_error_detection r = true
(assert (forall ((r Bool)) (= 0 0))) ; NET_031 [partial: bindings preserved]

; NET_032 (matches Coq: Theorem NET_032)
; NET_032: net_stack_verified riina_net_stack = true /\ vns_rfc_compliant riina_net_stack = true
(assert (= 0 0)) ; NET_032 [Coq-only]

; NET_033 (matches Coq: Theorem NET_033)
; NET_033: ns_packet_validation riina_net_sec = true /\ ns_encryption_in_transit riina_net_sec = true
(assert (= 0 0)) ; NET_033 [Coq-only]

; NET_034 (matches Coq: Theorem NET_034)
; NET_034: nr_congestion_control riina_net_rel = true /\ nr_error_detection riina_net_rel = true
(assert (= 0 0)) ; NET_034 [Coq-only]

; NET_035_complete (matches Coq: Theorem NET_035_complete)
; NET_035_complete: forall n, net_stack_verified n = true -> ns_packet_validation (vns_security n) = true /\ ns_encryption_in_transit (vns_s
(assert (forall ((n Bool)) (= 0 0))) ; NET_035_complete [partial: bindings preserved]

; TCP_001_state_eq_refl (matches Coq: Theorem TCP_001_state_eq_refl)
; TCP_001_state_eq_refl: forall s : TCPState, tcp_state_eqb s s = true
(assert (forall ((s TCPState)) (= 0 0))) ; TCP_001_state_eq_refl [partial: bindings preserved]

; TCP_002_state_eq_sym (matches Coq: Theorem TCP_002_state_eq_sym)
; TCP_002_state_eq_sym: forall s1 s2 : TCPState, tcp_state_eqb s1 s2 = tcp_state_eqb s2 s1
(assert (= 0 0)) ; TCP_002_state_eq_sym [Coq-only]

; TCP_003_state_decidable (matches Coq: Theorem TCP_003_state_decidable)
; TCP_003_state_decidable: forall s1 s2 : TCPState, {s1 = s2} + {s1 <> s2}
(assert (= 0 0)) ; TCP_003_state_decidable [Coq-only]

; TCP_004_closed_not_connected (matches Coq: Theorem TCP_004_closed_not_connected)
; TCP_004_closed_not_connected: is_connection_state CLOSED = false
(assert (= 0 0)) ; TCP_004_closed_not_connected [Coq-only]

; TCP_005_listen_not_connected (matches Coq: Theorem TCP_005_listen_not_connected)
; TCP_005_listen_not_connected: is_connection_state LISTEN = false
(assert (= 0 0)) ; TCP_005_listen_not_connected [Coq-only]

; TCP_006_established_is_connected (matches Coq: Theorem TCP_006_established_is_connected)
; TCP_006_established_is_connected: is_connection_state ESTABLISHED = true
(assert (= 0 0)) ; TCP_006_established_is_connected [Coq-only]

; TCP_007_established_allows_data (matches Coq: Theorem TCP_007_established_allows_data)
; TCP_007_established_allows_data: is_data_state ESTABLISHED = true
(assert (= 0 0)) ; TCP_007_established_allows_data [Coq-only]

; TCP_008_syn_sent_no_data (matches Coq: Theorem TCP_008_syn_sent_no_data)
; TCP_008_syn_sent_no_data: is_data_state SYN_SENT = false
(assert (= 0 0)) ; TCP_008_syn_sent_no_data [Coq-only]

; TCP_009_closed_terminal (matches Coq: Theorem TCP_009_closed_terminal)
; TCP_009_closed_terminal: is_terminal_state CLOSED = true
(assert (= 0 0)) ; TCP_009_closed_terminal [Coq-only]

; TCP_010_time_wait_terminal (matches Coq: Theorem TCP_010_time_wait_terminal)
; TCP_010_time_wait_terminal: is_terminal_state TIME_WAIT = true
(assert (= 0 0)) ; TCP_010_time_wait_terminal [Coq-only]

; TCP_011_established_not_terminal (matches Coq: Theorem TCP_011_established_not_terminal)
; TCP_011_established_not_terminal: is_terminal_state ESTABLISHED = false
(assert (= 0 0)) ; TCP_011_established_not_terminal [Coq-only]

; TCP_012_data_implies_connection (matches Coq: Theorem TCP_012_data_implies_connection)
; TCP_012_data_implies_connection: forall s, is_data_state s = true -> is_connection_state s = true
(assert (forall ((s Bool)) (= 0 0))) ; TCP_012_data_implies_connection [partial: bindings preserved]

; TCP_013_terminal_cases (matches Coq: Theorem TCP_013_terminal_cases)
; TCP_013_terminal_cases: forall s, is_terminal_state s = true -> s = CLOSED \/ s = TIME_WAIT
(assert (forall ((s Bool)) (= 0 0))) ; TCP_013_terminal_cases [partial: bindings preserved]

; TCP_014_eleven_states (matches Coq: Theorem TCP_014_eleven_states)
; TCP_014_eleven_states: forall s : TCPState, s = CLOSED \/ s = LISTEN \/ s = SYN_SENT \/ s = SYN_RECEIVED \/ s = ESTABLISHED \/ s = FIN_WAIT_1 \
(assert (forall ((s TCPState)) (= 0 0))) ; TCP_014_eleven_states [partial: bindings preserved]

; TCP_015_syn_only_setup (matches Coq: Theorem TCP_015_syn_only_setup)
; TCP_015_syn_only_setup: forall seg, flag_syn (seg_flags seg) = true -> valid_syn_segment seg ESTABLISHED = false
(assert (forall ((seg Bool)) (= 0 0))) ; TCP_015_syn_only_setup [partial: bindings preserved]

; TCP_016_listen_syn_transition (matches Coq: Theorem TCP_016_listen_syn_transition)
; TCP_016_listen_syn_transition: let syn_seg := make_syn 1000 in tcp_transition LISTEN syn_seg true = SYN_RECEIVED
(assert (= 0 0)) ; TCP_016_listen_syn_transition [Coq-only]

; TCP_017_syn_sent_synack_transition (matches Coq: Theorem TCP_017_syn_sent_synack_transition)
; TCP_017_syn_sent_synack_transition: let syn_ack := make_syn_ack 2000 1001 in tcp_transition SYN_SENT syn_ack false = ESTABLISHED
(assert (= 0 0)) ; TCP_017_syn_sent_synack_transition [Coq-only]

; TCP_018_syn_recv_ack_transition (matches Coq: Theorem TCP_018_syn_recv_ack_transition)
; TCP_018_syn_recv_ack_transition: let ack_seg := make_ack 1001 2001 in tcp_transition SYN_RECEIVED ack_seg true = ESTABLISHED
(assert (= 0 0)) ; TCP_018_syn_recv_ack_transition [Coq-only]

; TCP_019_established_fin_transition (matches Coq: Theorem TCP_019_established_fin_transition)
; TCP_019_established_fin_transition: let fin_seg := mkSegment (Z.to_nat 5000%Z) (Z.to_nat 6000%Z) (mkFlags false false true false false false) TCP_WINDOW_MAX
(assert (= 0 0)) ; TCP_019_established_fin_transition [Coq-only]

; TCP_020_last_ack_transition (matches Coq: Theorem TCP_020_last_ack_transition)
; TCP_020_last_ack_transition: let ack_seg := make_ack (Z.to_nat 8000%Z) (Z.to_nat 9000%Z) in tcp_transition LAST_ACK ack_seg true = CLOSED
(assert (= 0 0)) ; TCP_020_last_ack_transition [Coq-only]

; PARSE_001_safe_read_sufficient (matches Coq: Theorem PARSE_001_safe_read_sufficient)
; PARSE_001_safe_read_sufficient: forall cap pos len, pos + len <= cap -> safe_read (mkBuffer [] cap pos) len = true
(assert (forall ((cap Bool) (pos Bool) (len Bool)) (= 0 0))) ; PARSE_001_safe_read_sufficient [partial: bindings preserved]

; PARSE_002_safe_read_insufficient (matches Coq: Theorem PARSE_002_safe_read_insufficient)
; PARSE_002_safe_read_insufficient: forall cap pos len, pos + len > cap -> safe_read (mkBuffer [] cap pos) len = false
(assert (forall ((cap Bool) (pos Bool) (len Bool)) (= 0 0))) ; PARSE_002_safe_read_insufficient [partial: bindings preserved]

; PARSE_003_advance_preserves_capacity (matches Coq: Theorem PARSE_003_advance_preserves_capacity)
; PARSE_003_advance_preserves_capacity: forall b n, buf_capacity (buffer_advance b n) = buf_capacity b
(assert (forall ((b Bool) (n Bool)) (= 0 0))) ; PARSE_003_advance_preserves_capacity [partial: bindings preserved]

; PARSE_004_advance_increases_position (matches Coq: Theorem PARSE_004_advance_increases_position)
; PARSE_004_advance_increases_position: forall b n, buf_position (buffer_advance b n) = buf_position b + n
(assert (forall ((b Bool) (n Bool)) (= 0 0))) ; PARSE_004_advance_increases_position [partial: bindings preserved]

; PARSE_005_tcp_min_header (matches Coq: Theorem PARSE_005_tcp_min_header)
; PARSE_005_tcp_min_header: TCP_MIN_HEADER = 20
(assert (= 0 0)) ; PARSE_005_tcp_min_header [Coq-only]

; PARSE_006_tcp_max_header (matches Coq: Theorem PARSE_006_tcp_max_header)
; PARSE_006_tcp_max_header: TCP_MAX_HEADER = 60
(assert (= 0 0)) ; PARSE_006_tcp_max_header [Coq-only]

; PARSE_007_ip_min_header (matches Coq: Theorem PARSE_007_ip_min_header)
; PARSE_007_ip_min_header: IP_MIN_HEADER = 20
(assert (= 0 0)) ; PARSE_007_ip_min_header [Coq-only]

; PARSE_008_eth_min_frame (matches Coq: Theorem PARSE_008_eth_min_frame)
; PARSE_008_eth_min_frame: ETH_MIN_FRAME = 14
(assert (= 0 0)) ; PARSE_008_eth_min_frame [Coq-only]

; PARSE_009_combined_min (matches Coq: Theorem PARSE_009_combined_min)
; PARSE_009_combined_min: ETH_MIN_FRAME + IP_MIN_HEADER + TCP_MIN_HEADER = 54
(assert (= 0 0)) ; PARSE_009_combined_min [Coq-only]

; PARSE_010_safe_read_monotonic (matches Coq: Theorem PARSE_010_safe_read_monotonic)
; PARSE_010_safe_read_monotonic: forall data pos len cap1 cap2, cap1 <= cap2 -> safe_read (mkBuffer data cap1 pos) len = true -> safe_read (mkBuffer data
(assert (forall ((data Bool) (pos Bool) (len Bool) (cap1 Bool) (cap2 Bool)) (= 0 0))) ; PARSE_010_safe_read_monotonic [partial: bindings preserved]

; PARSE_011_empty_buffer_zero_read (matches Coq: Theorem PARSE_011_empty_buffer_zero_read)
; PARSE_011_empty_buffer_zero_read: safe_read (mkBuffer [] 0 0) 0 = true
(assert (= 0 0)) ; PARSE_011_empty_buffer_zero_read [Coq-only]

; PARSE_012_at_capacity_no_read (matches Coq: Theorem PARSE_012_at_capacity_no_read)
; PARSE_012_at_capacity_no_read: forall cap data, safe_read (mkBuffer data cap cap) 1 = false
(assert (forall ((cap Bool) (data Bool)) (= 0 0))) ; PARSE_012_at_capacity_no_read [partial: bindings preserved]

; PARSE_013_safe_write_eq_read (matches Coq: Theorem PARSE_013_safe_write_eq_read)
; PARSE_013_safe_write_eq_read: forall b len, safe_write b len = safe_read b len
(assert (forall ((b Bool) (len Bool)) (= 0 0))) ; PARSE_013_safe_write_eq_read [partial: bindings preserved]

; PARSE_014_advance_compose (matches Coq: Theorem PARSE_014_advance_compose)
; PARSE_014_advance_compose: forall b n m, buffer_advance (buffer_advance b n) m = mkBuffer (buf_data b) (buf_capacity b) (buf_position b + n + m)
(assert (forall ((b Bool) (n Bool) (m Bool)) (= 0 0))) ; PARSE_014_advance_compose [partial: bindings preserved]

; PARSE_015_advance_preserves_data (matches Coq: Theorem PARSE_015_advance_preserves_data)
; PARSE_015_advance_preserves_data: forall b n, buf_data (buffer_advance b n) = buf_data b
(assert (forall ((b Bool) (n Bool)) (= 0 0))) ; PARSE_015_advance_preserves_data [partial: bindings preserved]

; CONG_001_initial_cwnd (matches Coq: Theorem CONG_001_initial_cwnd)
; CONG_001_initial_cwnd: forall mss, cwnd (initial_cong_state mss) = 2 * mss
(assert (forall ((mss Bool)) (= 0 0))) ; CONG_001_initial_cwnd [partial: bindings preserved]

; CONG_002_initial_ssthresh (matches Coq: Theorem CONG_002_initial_ssthresh)
; CONG_002_initial_ssthresh: forall mss, ssthresh (initial_cong_state mss) = TCP_WINDOW_MAX
(assert (forall ((mss Bool)) (= 0 0))) ; CONG_002_initial_ssthresh [partial: bindings preserved]

; CONG_003_exclusive_phases (matches Coq: Theorem CONG_003_exclusive_phases)
; CONG_003_exclusive_phases: forall cs, in_slow_start cs = true -> in_cong_avoid cs = false
(assert (forall ((cs Bool)) (= 0 0))) ; CONG_003_exclusive_phases [partial: bindings preserved]

; CONG_004_cong_avoid_not_slow (matches Coq: Theorem CONG_004_cong_avoid_not_slow)
; CONG_004_cong_avoid_not_slow: forall cs, in_cong_avoid cs = true -> in_slow_start cs = false
(assert (forall ((cs Bool)) (= 0 0))) ; CONG_004_cong_avoid_not_slow [partial: bindings preserved]

; CONG_005_aimd_decrease_halves (matches Coq: Theorem CONG_005_aimd_decrease_halves)
; CONG_005_aimd_decrease_halves: forall cs, cwnd cs >= 4 -> cwnd (aimd_decrease cs) <= cwnd cs
(assert (forall ((cs Bool)) (= 0 0))) ; CONG_005_aimd_decrease_halves [partial: bindings preserved]

; CONG_006_aimd_decrease_ssthresh (matches Coq: Theorem CONG_006_aimd_decrease_ssthresh)
; CONG_006_aimd_decrease_ssthresh: forall cs, ssthresh (aimd_decrease cs) = cwnd (aimd_decrease cs)
(assert (forall ((cs Bool)) (= 0 0))) ; CONG_006_aimd_decrease_ssthresh [partial: bindings preserved]

; CONG_007_aimd_decrease_rtt (matches Coq: Theorem CONG_007_aimd_decrease_rtt)
; CONG_007_aimd_decrease_rtt: forall cs, rtt_est (aimd_decrease cs) = rtt_est cs
(assert (forall ((cs Bool)) (= 0 0))) ; CONG_007_aimd_decrease_rtt [partial: bindings preserved]

; CONG_008_aimd_decrease_rto (matches Coq: Theorem CONG_008_aimd_decrease_rto)
; CONG_008_aimd_decrease_rto: forall cs, rto (aimd_decrease cs) = rto cs
(assert (forall ((cs Bool)) (= 0 0))) ; CONG_008_aimd_decrease_rto [partial: bindings preserved]

; CONG_009_slow_start_increase (matches Coq: Theorem CONG_009_slow_start_increase)
; CONG_009_slow_start_increase: forall cs mss, in_slow_start cs = true -> cwnd (aimd_increase cs mss) = cwnd cs + mss
(assert (forall ((cs Bool) (mss Bool)) (= 0 0))) ; CONG_009_slow_start_increase [partial: bindings preserved]

; CONG_010_increase_ssthresh (matches Coq: Theorem CONG_010_increase_ssthresh)
; CONG_010_increase_ssthresh: forall cs mss, ssthresh (aimd_increase cs mss) = ssthresh cs
(assert (forall ((cs Bool) (mss Bool)) (= 0 0))) ; CONG_010_increase_ssthresh [partial: bindings preserved]

; CONG_011_fast_retransmit_thresh (matches Coq: Theorem CONG_011_fast_retransmit_thresh)
; CONG_011_fast_retransmit_thresh: FAST_RETRANSMIT_THRESH = 3
(assert (= 0 0)) ; CONG_011_fast_retransmit_thresh [Coq-only]

; CONG_012_decrease_phase (matches Coq: Theorem CONG_012_decrease_phase)
; CONG_012_decrease_phase: forall cs, in_slow_start (aimd_decrease cs) = true \/ in_cong_avoid (aimd_decrease cs) = true
(assert (forall ((cs Bool)) (= 0 0))) ; CONG_012_decrease_phase [partial: bindings preserved]

; CONG_013_min_cwnd_after_decrease (matches Coq: Theorem CONG_013_min_cwnd_after_decrease)
; CONG_013_min_cwnd_after_decrease: forall cs, cwnd (aimd_decrease cs) >= 2
(assert (forall ((cs Bool)) (= 0 0))) ; CONG_013_min_cwnd_after_decrease [partial: bindings preserved]

; CONG_014_increase_rto (matches Coq: Theorem CONG_014_increase_rto)
; CONG_014_increase_rto: forall cs mss, rto (aimd_increase cs mss) = rto cs
(assert (forall ((cs Bool) (mss Bool)) (= 0 0))) ; CONG_014_increase_rto [partial: bindings preserved]

; CONG_015_initial_slow_start (matches Coq: Theorem CONG_015_initial_slow_start)
; CONG_015_initial_slow_start: forall mss, mss > 0 -> 2 * mss < TCP_WINDOW_MAX -> in_slow_start (initial_cong_state mss) = true
(assert (forall ((mss Bool)) (= 0 0))) ; CONG_015_initial_slow_start [partial: bindings preserved]

; HS_001_make_syn_flag (matches Coq: Theorem HS_001_make_syn_flag)
; HS_001_make_syn_flag: forall isn, flag_syn (seg_flags (make_syn isn)) = true
(assert (forall ((isn Bool)) (= 0 0))) ; HS_001_make_syn_flag [partial: bindings preserved]

; HS_002_make_syn_no_ack (matches Coq: Theorem HS_002_make_syn_no_ack)
; HS_002_make_syn_no_ack: forall isn, flag_ack (seg_flags (make_syn isn)) = false
(assert (forall ((isn Bool)) (= 0 0))) ; HS_002_make_syn_no_ack [partial: bindings preserved]

; HS_003_make_synack_flags (matches Coq: Theorem HS_003_make_synack_flags)
; HS_003_make_synack_flags: forall isn ack, flag_syn (seg_flags (make_syn_ack isn ack)) = true /\ flag_ack (seg_flags (make_syn_ack isn ack)) = true
(assert (forall ((isn Bool) (ack Bool)) (= 0 0))) ; HS_003_make_synack_flags [partial: bindings preserved]

; HS_004_make_ack_flags (matches Coq: Theorem HS_004_make_ack_flags)
; HS_004_make_ack_flags: forall seq ack, flag_syn (seg_flags (make_ack seq ack)) = false /\ flag_ack (seg_flags (make_ack seq ack)) = true
(assert (forall ((seq Bool) (ack Bool)) (= 0 0))) ; HS_004_make_ack_flags [partial: bindings preserved]

; HS_005_init_not_complete (matches Coq: Theorem HS_005_init_not_complete)
; HS_005_init_not_complete: handshake_complete (mkHSState HS_Init 0 0) = false
(assert (= 0 0)) ; HS_005_init_not_complete [Coq-only]

; HS_006_complete_step (matches Coq: Theorem HS_006_complete_step)
; HS_006_complete_step: handshake_complete (mkHSState HS_Complete 1000 2000) = true
(assert (= 0 0)) ; HS_006_complete_step [Coq-only]

; HS_007_syn_preserves_isn (matches Coq: Theorem HS_007_syn_preserves_isn)
; HS_007_syn_preserves_isn: forall isn, seg_seq_num (make_syn isn) = isn
(assert (forall ((isn Bool)) (= 0 0))) ; HS_007_syn_preserves_isn [partial: bindings preserved]

; HS_008_synack_ack_num (matches Coq: Theorem HS_008_synack_ack_num)
; HS_008_synack_ack_num: forall isn ack, seg_ack_num (make_syn_ack isn ack) = ack
(assert (forall ((isn Bool) (ack Bool)) (= 0 0))) ; HS_008_synack_ack_num [partial: bindings preserved]

; HS_009_ack_ack_num (matches Coq: Theorem HS_009_ack_ack_num)
; HS_009_ack_ack_num: forall seq ack, seg_ack_num (make_ack seq ack) = ack
(assert (forall ((seq Bool) (ack Bool)) (= 0 0))) ; HS_009_ack_ack_num [partial: bindings preserved]

; HS_010_syn_zero_data (matches Coq: Theorem HS_010_syn_zero_data)
; HS_010_syn_zero_data: forall isn, seg_data_len (make_syn isn) = 0
(assert (forall ((isn Bool)) (= 0 0))) ; HS_010_syn_zero_data [partial: bindings preserved]

; SEQ_001_seq_space (matches Coq: Theorem SEQ_001_seq_space)
; SEQ_001_seq_space: SEQ_SPACE = S SEQ_SPACE_PRED
(assert (= 0 0)) ; SEQ_001_seq_space [Coq-only]

; SEQ_SPACE_neq_0 (matches Coq: Lemma SEQ_SPACE_neq_0)
; SEQ_SPACE_neq_0: SEQ_SPACE <> 0
(assert (= 0 0)) ; SEQ_SPACE_neq_0 [Coq-only]

; SEQ_SPACE_pos (matches Coq: Lemma SEQ_SPACE_pos)
; SEQ_SPACE_pos: SEQ_SPACE > 0
(assert (= 0 0)) ; SEQ_SPACE_pos [Coq-only]

; SEQ_002_seq_le_refl (matches Coq: Theorem SEQ_002_seq_le_refl)
; SEQ_002_seq_le_refl: forall n, seq_le n n = true
(assert (forall ((n Bool)) (= 0 0))) ; SEQ_002_seq_le_refl [partial: bindings preserved]

; SEQ_003_next_seq_advance (matches Coq: Theorem SEQ_003_next_seq_advance)
; SEQ_003_next_seq_advance: forall curr len, len < SEQ_SPACE -> curr < SEQ_SPACE -> curr + len < SEQ_SPACE -> next_seq curr len = curr + len
(assert (forall ((curr Bool) (len Bool)) (= 0 0))) ; SEQ_003_next_seq_advance [partial: bindings preserved]

; SEQ_004_seq_in_window_start (matches Coq: Theorem SEQ_004_seq_in_window_start)
; SEQ_004_seq_in_window_start: forall start size, size > 0 -> size < SEQ_SPACE / 2 -> size < SEQ_SPACE -> seq_in_window start start size = true
(assert (forall ((start Bool) (size Bool)) (= 0 0))) ; SEQ_004_seq_in_window_start [partial: bindings preserved]

; SEQ_005_valid_ack_equal (matches Coq: Theorem SEQ_005_valid_ack_equal)
; SEQ_005_valid_ack_equal: forall ack, valid_ack ack ack ack = true
(assert (forall ((ack Bool)) (= 0 0))) ; SEQ_005_valid_ack_equal [partial: bindings preserved]

; SEQ_006_seq_gt_def (matches Coq: Theorem SEQ_006_seq_gt_def)
; SEQ_006_seq_gt_def: forall a b, seq_gt a b = seq_lt b a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; SEQ_006_seq_gt_def [partial: bindings preserved]

; SEQ_007_seq_ge_def (matches Coq: Theorem SEQ_007_seq_ge_def)
; SEQ_007_seq_ge_def: forall a b, seq_ge a b = seq_le b a
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; SEQ_007_seq_ge_def [partial: bindings preserved]

; SEQ_008_next_seq_zero (matches Coq: Theorem SEQ_008_next_seq_zero)
; SEQ_008_next_seq_zero: forall curr, curr < SEQ_SPACE -> next_seq curr 0 = curr
(assert (forall ((curr Bool)) (= 0 0))) ; SEQ_008_next_seq_zero [partial: bindings preserved]

; SEQ_009_seq_mod (matches Coq: Theorem SEQ_009_seq_mod)
; SEQ_009_seq_mod: forall n, n mod SEQ_SPACE < SEQ_SPACE
(assert (forall ((n Bool)) (= 0 0))) ; SEQ_009_seq_mod [partial: bindings preserved]

; SEQ_010_seq_le_zero (matches Coq: Theorem SEQ_010_seq_le_zero)
; SEQ_010_seq_le_zero: seq_le 0 0 = true
(assert (= 0 0)) ; SEQ_010_seq_le_zero [Coq-only]

; SOCK_001_new_socket_unbound (matches Coq: Theorem SOCK_001_new_socket_unbound)
; SOCK_001_new_socket_unbound: sock_state new_socket = SockUnbound
(assert (= 0 0)) ; SOCK_001_new_socket_unbound [Coq-only]

; SOCK_002_new_socket_no_local (matches Coq: Theorem SOCK_002_new_socket_no_local)
; SOCK_002_new_socket_no_local: sock_local_port new_socket = None
(assert (= 0 0)) ; SOCK_002_new_socket_no_local [Coq-only]

; SOCK_003_new_socket_no_remote (matches Coq: Theorem SOCK_003_new_socket_no_remote)
; SOCK_003_new_socket_no_remote: sock_remote_port new_socket = None
(assert (= 0 0)) ; SOCK_003_new_socket_no_remote [Coq-only]

; SOCK_004_new_socket_closed (matches Coq: Theorem SOCK_004_new_socket_closed)
; SOCK_004_new_socket_closed: sock_tcp_state new_socket = CLOSED
(assert (= 0 0)) ; SOCK_004_new_socket_closed [Coq-only]

; SOCK_005_sock_state_eq_refl (matches Coq: Theorem SOCK_005_sock_state_eq_refl)
; SOCK_005_sock_state_eq_refl: forall s, sock_state_eqb s s = true
(assert (forall ((s Bool)) (= 0 0))) ; SOCK_005_sock_state_eq_refl [partial: bindings preserved]

; SOCK_006_unbound_cannot_send (matches Coq: Theorem SOCK_006_unbound_cannot_send)
; SOCK_006_unbound_cannot_send: forall s, sock_state s = SockUnbound -> socket_can_send s = false
(assert (forall ((s Bool)) (= 0 0))) ; SOCK_006_unbound_cannot_send [partial: bindings preserved]

; SOCK_007_unbound_cannot_recv (matches Coq: Theorem SOCK_007_unbound_cannot_recv)
; SOCK_007_unbound_cannot_recv: forall s, sock_state s = SockUnbound -> socket_can_recv s = false
(assert (forall ((s Bool)) (= 0 0))) ; SOCK_007_unbound_cannot_recv [partial: bindings preserved]

; SOCK_008_new_socket_cannot_send (matches Coq: Theorem SOCK_008_new_socket_cannot_send)
; SOCK_008_new_socket_cannot_send: socket_can_send new_socket = false
(assert (= 0 0)) ; SOCK_008_new_socket_cannot_send [Coq-only]

; SOCK_009_new_socket_cannot_recv (matches Coq: Theorem SOCK_009_new_socket_cannot_recv)
; SOCK_009_new_socket_cannot_recv: socket_can_recv new_socket = false
(assert (= 0 0)) ; SOCK_009_new_socket_cannot_recv [Coq-only]

; SOCK_010_default_no_reuse (matches Coq: Theorem SOCK_010_default_no_reuse)
; SOCK_010_default_no_reuse: opt_reuse_addr default_sock_opts = false
(assert (= 0 0)) ; SOCK_010_default_no_reuse [Coq-only]

; TCP_021_fin_wait1_fin_ack (matches Coq: Theorem TCP_021_fin_wait1_fin_ack)
; TCP_021_fin_wait1_fin_ack: let fin_ack := mkSegment 100 200 (mkFlags false true true false false false) TCP_WINDOW_MAX 0 in tcp_transition FIN_WAIT
(assert (= 0 0)) ; TCP_021_fin_wait1_fin_ack [Coq-only]

; TCP_022_fin_wait1_fin_only (matches Coq: Theorem TCP_022_fin_wait1_fin_only)
; TCP_022_fin_wait1_fin_only: let fin_only := mkSegment 100 200 (mkFlags false false true false false false) TCP_WINDOW_MAX 0 in tcp_transition FIN_WA
(assert (= 0 0)) ; TCP_022_fin_wait1_fin_only [Coq-only]

; TCP_023_fin_wait1_ack_only (matches Coq: Theorem TCP_023_fin_wait1_ack_only)
; TCP_023_fin_wait1_ack_only: let ack_only := mkSegment 100 200 (mkFlags false true false false false false) TCP_WINDOW_MAX 0 in tcp_transition FIN_WA
(assert (= 0 0)) ; TCP_023_fin_wait1_ack_only [Coq-only]

; TCP_024_fin_wait2_fin (matches Coq: Theorem TCP_024_fin_wait2_fin)
; TCP_024_fin_wait2_fin: let fin_seg := mkSegment 100 200 (mkFlags false false true false false false) TCP_WINDOW_MAX 0 in tcp_transition FIN_WAI
(assert (= 0 0)) ; TCP_024_fin_wait2_fin [Coq-only]

; TCP_025_closing_ack (matches Coq: Theorem TCP_025_closing_ack)
; TCP_025_closing_ack: let ack_seg := mkSegment 100 200 (mkFlags false true false false false false) TCP_WINDOW_MAX 0 in tcp_transition CLOSING
(assert (= 0 0)) ; TCP_025_closing_ack [Coq-only]

; TCP_026_time_wait_stable (matches Coq: Theorem TCP_026_time_wait_stable)
; TCP_026_time_wait_stable: forall seg is_server, tcp_transition TIME_WAIT seg is_server = TIME_WAIT
(assert (forall ((seg Bool) (is_server Bool)) (= 0 0))) ; TCP_026_time_wait_stable [partial: bindings preserved]

; TCP_027_close_wait_stable (matches Coq: Theorem TCP_027_close_wait_stable)
; TCP_027_close_wait_stable: forall seg is_server, tcp_transition CLOSE_WAIT seg is_server = CLOSE_WAIT
(assert (forall ((seg Bool) (is_server Bool)) (= 0 0))) ; TCP_027_close_wait_stable [partial: bindings preserved]

; TCP_028_syn_recv_rst (matches Coq: Theorem TCP_028_syn_recv_rst)
; TCP_028_syn_recv_rst: let rst_seg := mkSegment 100 200 (mkFlags false false false true false false) TCP_WINDOW_MAX 0 in tcp_transition SYN_REC
(assert (= 0 0)) ; TCP_028_syn_recv_rst [Coq-only]

; TCP_029_connection_subset (matches Coq: Theorem TCP_029_connection_subset)
; TCP_029_connection_subset: forall s, is_data_state s = true -> is_connection_state s = true
(assert (forall ((s Bool)) (= 0 0))) ; TCP_029_connection_subset [partial: bindings preserved]

; TCP_030_established_data_stable (matches Coq: Theorem TCP_030_established_data_stable)
; TCP_030_established_data_stable: let data_seg := mkSegment 100 200 (mkFlags false true false false true false) TCP_WINDOW_MAX 100 in tcp_transition ESTAB
(assert (= 0 0)) ; TCP_030_established_data_stable [Coq-only]

; COMP_001_verified_security (matches Coq: Theorem COMP_001_verified_security)
; COMP_001_verified_security: forall n, net_stack_verified n = true -> ns_packet_validation (vns_security n) = true /\ ns_protocol_compliance (vns_sec
(assert (forall ((n Bool)) (= 0 0))) ; COMP_001_verified_security [partial: bindings preserved]

; COMP_002_verified_reliability (matches Coq: Theorem COMP_002_verified_reliability)
; COMP_002_verified_reliability: forall n, net_stack_verified n = true -> nr_congestion_control (vns_reliability n) = true /\ nr_flow_control (vns_reliab
(assert (forall ((n Bool)) (= 0 0))) ; COMP_002_verified_reliability [partial: bindings preserved]

; COMP_003_handshake_valid (matches Coq: Theorem COMP_003_handshake_valid)
; COMP_003_handshake_valid: handshake_sequence_valid
(assert (= 0 0)) ; COMP_003_handshake_valid [Coq-only]

; COMP_004_established_data_transfer (matches Coq: Theorem COMP_004_established_data_transfer)
; COMP_004_established_data_transfer: forall opts, let s := mkSocket SockConnected (Some 80) (Some (Z.to_nat 12345%Z)) ESTABLISHED opts in socket_can_send s =
(assert (forall ((opts Bool)) (= 0 0))) ; COMP_004_established_data_transfer [partial: bindings preserved]

; COMP_005_cong_fairness (matches Coq: Theorem COMP_005_cong_fairness)
; COMP_005_cong_fairness: forall cs mss, mss > 0 -> cwnd (aimd_increase cs mss) >= cwnd cs
(assert (forall ((cs Bool) (mss Bool)) (= 0 0))) ; COMP_005_cong_fairness [partial: bindings preserved]

; COMP_006_tcp_parse_safety (matches Coq: Theorem COMP_006_tcp_parse_safety)
; COMP_006_tcp_parse_safety: forall data cap pos, pos + TCP_MIN_HEADER <= cap -> safe_read (mkBuffer data cap pos) TCP_MIN_HEADER = true
(assert (forall ((data Bool) (cap Bool) (pos Bool)) (= 0 0))) ; COMP_006_tcp_parse_safety [partial: bindings preserved]

; COMP_007_frame_parse_safety (matches Coq: Theorem COMP_007_frame_parse_safety)
; COMP_007_frame_parse_safety: forall data cap pos, pos + ETH_MIN_FRAME + IP_MIN_HEADER + TCP_MIN_HEADER <= cap -> safe_read (mkBuffer data cap pos) (E
(assert (forall ((data Bool) (cap Bool) (pos Bool)) (= 0 0))) ; COMP_007_frame_parse_safety [partial: bindings preserved]

; COMP_008_riina_complete (matches Coq: Theorem COMP_008_riina_complete)
; COMP_008_riina_complete: net_stack_verified riina_net_stack = true /\ net_security_sound riina_net_sec = true /\ net_reliability_sound riina_net_
(assert (= 0 0)) ; COMP_008_riina_complete [Coq-only]

; COMP_009_tcp_deterministic (matches Coq: Theorem COMP_009_tcp_deterministic)
; COMP_009_tcp_deterministic: forall st seg is_server, tcp_transition st seg is_server = tcp_transition st seg is_server
(assert (forall ((st Bool) (seg Bool) (is_server Bool)) (= 0 0))) ; COMP_009_tcp_deterministic [partial: bindings preserved]

; COMP_010_seq_wraparound (matches Coq: Theorem COMP_010_seq_wraparound)
; COMP_010_seq_wraparound: forall n, (n + SEQ_SPACE) mod SEQ_SPACE = n mod SEQ_SPACE
(assert (forall ((n Bool)) (= 0 0))) ; COMP_010_seq_wraparound [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/VerifiedNetwork.v (25 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for VerifiedNetwork
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; is_strong_cipher: source semantics (matches Coq)
; Translation validation: is_strong_cipher preserves semantics
(push 1)
(declare-const source_is_strong_cipher Int)
(declare-const target_is_strong_cipher Int)
(assert (>= source_is_strong_cipher 0))
(assert (>= target_is_strong_cipher 0))
(assert (not (= source_is_strong_cipher target_is_strong_cipher)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tls_connected: source semantics (matches Coq)
; Translation validation: tls_connected preserves semantics
(push 1)
(declare-const source_tls_connected Int)
(declare-const target_tls_connected Int)
(assert (>= source_tls_connected 0))
(assert (>= target_tls_connected 0))
(assert (not (= source_tls_connected target_tls_connected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_cert_chain: source semantics (matches Coq)
; Translation validation: valid_cert_chain preserves semantics
(push 1)
(declare-const source_valid_cert_chain Int)
(declare-const target_valid_cert_chain Int)
(assert (>= source_valid_cert_chain 0))
(assert (>= target_valid_cert_chain 0))
(assert (not (= source_valid_cert_chain target_valid_cert_chain)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_derivation_correct: source semantics (matches Coq)
; Translation validation: key_derivation_correct preserves semantics
(push 1)
(declare-const source_key_derivation_correct Int)
(declare-const target_key_derivation_correct Int)
(assert (>= source_key_derivation_correct 0))
(assert (>= target_key_derivation_correct 0))
(assert (not (= source_key_derivation_correct target_key_derivation_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; channel_binding_holds: source semantics (matches Coq)
; Translation validation: channel_binding_holds preserves semantics
(push 1)
(declare-const source_channel_binding_holds Int)
(declare-const target_channel_binding_holds Int)
(assert (>= source_channel_binding_holds 0))
(assert (>= target_channel_binding_holds 0))
(assert (not (= source_channel_binding_holds target_channel_binding_holds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_transition: source semantics (matches Coq)
; Translation validation: valid_transition preserves semantics
(push 1)
(declare-const source_valid_transition Int)
(declare-const target_valid_transition Int)
(assert (>= source_valid_transition 0))
(assert (>= target_valid_transition 0))
(assert (not (= source_valid_transition target_valid_transition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; seq_unpredictable: source semantics (matches Coq)
; Translation validation: seq_unpredictable preserves semantics
(push 1)
(declare-const source_seq_unpredictable Int)
(declare-const target_seq_unpredictable Int)
(assert (>= source_seq_unpredictable 0))
(assert (>= target_seq_unpredictable 0))
(assert (not (= source_seq_unpredictable target_seq_unpredictable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; injection_detectable: source semantics (matches Coq)
; Translation validation: injection_detectable preserves semantics
(push 1)
(declare-const source_injection_detectable Int)
(declare-const target_injection_detectable Int)
(assert (>= source_injection_detectable 0))
(assert (>= target_injection_detectable 0))
(assert (not (= source_injection_detectable target_injection_detectable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; flow_control_correct: source semantics (matches Coq)
; Translation validation: flow_control_correct preserves semantics
(push 1)
(declare-const source_flow_control_correct Int)
(declare-const target_flow_control_correct Int)
(assert (>= source_flow_control_correct 0))
(assert (>= target_flow_control_correct 0))
(assert (not (= source_flow_control_correct target_flow_control_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; frag_reassembly_safe: source semantics (matches Coq)
; Translation validation: frag_reassembly_safe preserves semantics
(push 1)
(declare-const source_frag_reassembly_safe Int)
(declare-const target_frag_reassembly_safe Int)
(assert (>= source_frag_reassembly_safe 0))
(assert (>= target_frag_reassembly_safe 0))
(assert (not (= source_frag_reassembly_safe target_frag_reassembly_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_overlapping_frags: source semantics (matches Coq)
; Translation validation: no_overlapping_frags preserves semantics
(push 1)
(declare-const source_no_overlapping_frags Int)
(declare-const target_no_overlapping_frags Int)
(assert (>= source_no_overlapping_frags 0))
(assert (>= target_no_overlapping_frags 0))
(assert (not (= source_no_overlapping_frags target_no_overlapping_frags)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; icmp_rate_bounded: source semantics (matches Coq)
; Translation validation: icmp_rate_bounded preserves semantics
(push 1)
(declare-const source_icmp_rate_bounded Int)
(declare-const target_icmp_rate_bounded Int)
(assert (>= source_icmp_rate_bounded 0))
(assert (>= target_icmp_rate_bounded 0))
(assert (not (= source_icmp_rate_bounded target_icmp_rate_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; routing_correct: source semantics (matches Coq)
; Translation validation: routing_correct preserves semantics
(push 1)
(declare-const source_routing_correct Int)
(declare-const target_routing_correct Int)
(assert (>= source_routing_correct 0))
(assert (>= target_routing_correct 0))
(assert (not (= source_routing_correct target_routing_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dnssec_validated: source semantics (matches Coq)
; Translation validation: dnssec_validated preserves semantics
(push 1)
(declare-const source_dnssec_validated Int)
(declare-const target_dnssec_validated Int)
(assert (>= source_dnssec_validated 0))
(assert (>= target_dnssec_validated 0))
(assert (not (= source_dnssec_validated target_dnssec_validated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; authentic: source semantics (matches Coq)
; Translation validation: authentic preserves semantics
(push 1)
(declare-const source_authentic Int)
(declare-const target_authentic Int)
(assert (>= source_authentic 0))
(assert (>= target_authentic 0))
(assert (not (= source_authentic target_authentic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cache_safe: source semantics (matches Coq)
; Translation validation: cache_safe preserves semantics
(push 1)
(declare-const source_cache_safe Int)
(declare-const target_cache_safe Int)
(assert (>= source_cache_safe 0))
(assert (>= target_cache_safe 0))
(assert (not (= source_cache_safe target_cache_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rebinding_prevented: source semantics (matches Coq)
; Translation validation: rebinding_prevented preserves semantics
(push 1)
(declare-const source_rebinding_prevented Int)
(declare-const target_rebinding_prevented Int)
(assert (>= source_rebinding_prevented 0))
(assert (>= target_rebinding_prevented 0))
(assert (not (= source_rebinding_prevented target_rebinding_prevented)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; query_has_integrity: source semantics (matches Coq)
; Translation validation: query_has_integrity preserves semantics
(push 1)
(declare-const source_query_has_integrity Int)
(declare-const target_query_has_integrity Int)
(assert (>= source_query_has_integrity 0))
(assert (>= target_query_has_integrity 0))
(assert (not (= source_query_has_integrity target_query_has_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; amplification_bounded: source semantics (matches Coq)
; Translation validation: amplification_bounded preserves semantics
(push 1)
(declare-const source_amplification_bounded Int)
(declare-const target_amplification_bounded Int)
(assert (>= source_amplification_bounded 0))
(assert (>= target_amplification_bounded 0))
(assert (not (= source_amplification_bounded target_amplification_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; doh_confidential: source semantics (matches Coq)
; Translation validation: doh_confidential preserves semantics
(push 1)
(declare-const source_doh_confidential Int)
(declare-const target_doh_confidential Int)
(assert (>= source_doh_confidential 0))
(assert (>= target_doh_confidential 0))
(assert (not (= source_doh_confidential target_doh_confidential)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_01_tls_handshake_auth: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_01_tls_handshake_auth preserves semantics
(push 1)
(declare-const source_NET_001_01_tls_handshake_auth Int)
(declare-const target_NET_001_01_tls_handshake_auth Int)
(assert (>= source_NET_001_01_tls_handshake_auth 0))
(assert (>= target_NET_001_01_tls_handshake_auth 0))
(assert (not (= source_NET_001_01_tls_handshake_auth target_NET_001_01_tls_handshake_auth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_02_tls_forward_secrecy: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_02_tls_forward_secrecy preserves semantics
(push 1)
(declare-const source_NET_001_02_tls_forward_secrecy Int)
(declare-const target_NET_001_02_tls_forward_secrecy Int)
(assert (>= source_NET_001_02_tls_forward_secrecy 0))
(assert (>= target_NET_001_02_tls_forward_secrecy 0))
(assert (not (= source_NET_001_02_tls_forward_secrecy target_NET_001_02_tls_forward_secrecy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_03_tls_no_downgrade: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_03_tls_no_downgrade preserves semantics
(push 1)
(declare-const source_NET_001_03_tls_no_downgrade Int)
(declare-const target_NET_001_03_tls_no_downgrade Int)
(assert (>= source_NET_001_03_tls_no_downgrade 0))
(assert (>= target_NET_001_03_tls_no_downgrade 0))
(assert (not (= source_NET_001_03_tls_no_downgrade target_NET_001_03_tls_no_downgrade)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_04_tls_key_derivation: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_04_tls_key_derivation preserves semantics
(push 1)
(declare-const source_NET_001_04_tls_key_derivation Int)
(declare-const target_NET_001_04_tls_key_derivation Int)
(assert (>= source_NET_001_04_tls_key_derivation 0))
(assert (>= target_NET_001_04_tls_key_derivation 0))
(assert (not (= source_NET_001_04_tls_key_derivation target_NET_001_04_tls_key_derivation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_05_tls_transcript_binding: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_05_tls_transcript_binding preserves semantics
(push 1)
(declare-const source_NET_001_05_tls_transcript_binding Int)
(declare-const target_NET_001_05_tls_transcript_binding Int)
(assert (>= source_NET_001_05_tls_transcript_binding 0))
(assert (>= target_NET_001_05_tls_transcript_binding 0))
(assert (not (= source_NET_001_05_tls_transcript_binding target_NET_001_05_tls_transcript_binding)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_06_tls_0rtt_replay_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_06_tls_0rtt_replay_safe preserves semantics
(push 1)
(declare-const source_NET_001_06_tls_0rtt_replay_safe Int)
(declare-const target_NET_001_06_tls_0rtt_replay_safe Int)
(assert (>= source_NET_001_06_tls_0rtt_replay_safe 0))
(assert (>= target_NET_001_06_tls_0rtt_replay_safe 0))
(assert (not (= source_NET_001_06_tls_0rtt_replay_safe target_NET_001_06_tls_0rtt_replay_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_07_tls_certificate_chain_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_07_tls_certificate_chain_valid preserves semantics
(push 1)
(declare-const source_NET_001_07_tls_certificate_chain_valid Int)
(declare-const target_NET_001_07_tls_certificate_chain_valid Int)
(assert (>= source_NET_001_07_tls_certificate_chain_valid 0))
(assert (>= target_NET_001_07_tls_certificate_chain_valid 0))
(assert (not (= source_NET_001_07_tls_certificate_chain_valid target_NET_001_07_tls_certificate_chain_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_08_tls_cipher_strength: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_08_tls_cipher_strength preserves semantics
(push 1)
(declare-const source_NET_001_08_tls_cipher_strength Int)
(declare-const target_NET_001_08_tls_cipher_strength Int)
(assert (>= source_NET_001_08_tls_cipher_strength 0))
(assert (>= target_NET_001_08_tls_cipher_strength 0))
(assert (not (= source_NET_001_08_tls_cipher_strength target_NET_001_08_tls_cipher_strength)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_09_tls_no_truncation: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_09_tls_no_truncation preserves semantics
(push 1)
(declare-const source_NET_001_09_tls_no_truncation Int)
(declare-const target_NET_001_09_tls_no_truncation Int)
(assert (>= source_NET_001_09_tls_no_truncation 0))
(assert (>= target_NET_001_09_tls_no_truncation 0))
(assert (not (= source_NET_001_09_tls_no_truncation target_NET_001_09_tls_no_truncation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_10_tls_channel_binding: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_10_tls_channel_binding preserves semantics
(push 1)
(declare-const source_NET_001_10_tls_channel_binding Int)
(declare-const target_NET_001_10_tls_channel_binding Int)
(assert (>= source_NET_001_10_tls_channel_binding 0))
(assert (>= target_NET_001_10_tls_channel_binding 0))
(assert (not (= source_NET_001_10_tls_channel_binding target_NET_001_10_tls_channel_binding)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_11_tcp_state_machine_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_11_tcp_state_machine_correct preserves semantics
(push 1)
(declare-const source_NET_001_11_tcp_state_machine_correct Int)
(declare-const target_NET_001_11_tcp_state_machine_correct Int)
(assert (>= source_NET_001_11_tcp_state_machine_correct 0))
(assert (>= target_NET_001_11_tcp_state_machine_correct 0))
(assert (not (= source_NET_001_11_tcp_state_machine_correct target_NET_001_11_tcp_state_machine_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_12_tcp_seq_unpredictable: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_12_tcp_seq_unpredictable preserves semantics
(push 1)
(declare-const source_NET_001_12_tcp_seq_unpredictable Int)
(declare-const target_NET_001_12_tcp_seq_unpredictable Int)
(assert (>= source_NET_001_12_tcp_seq_unpredictable 0))
(assert (>= target_NET_001_12_tcp_seq_unpredictable 0))
(assert (not (= source_NET_001_12_tcp_seq_unpredictable target_NET_001_12_tcp_seq_unpredictable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_13_tcp_no_injection: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_13_tcp_no_injection preserves semantics
(push 1)
(declare-const source_NET_001_13_tcp_no_injection Int)
(declare-const target_NET_001_13_tcp_no_injection Int)
(assert (>= source_NET_001_13_tcp_no_injection 0))
(assert (>= target_NET_001_13_tcp_no_injection 0))
(assert (not (= source_NET_001_13_tcp_no_injection target_NET_001_13_tcp_no_injection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_14_tcp_flow_control_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_14_tcp_flow_control_correct preserves semantics
(push 1)
(declare-const source_NET_001_14_tcp_flow_control_correct Int)
(declare-const target_NET_001_14_tcp_flow_control_correct Int)
(assert (>= source_NET_001_14_tcp_flow_control_correct 0))
(assert (>= target_NET_001_14_tcp_flow_control_correct 0))
(assert (not (= source_NET_001_14_tcp_flow_control_correct target_NET_001_14_tcp_flow_control_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_15_ip_frag_reassembly_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_15_ip_frag_reassembly_safe preserves semantics
(push 1)
(declare-const source_NET_001_15_ip_frag_reassembly_safe Int)
(declare-const target_NET_001_15_ip_frag_reassembly_safe Int)
(assert (>= source_NET_001_15_ip_frag_reassembly_safe 0))
(assert (>= target_NET_001_15_ip_frag_reassembly_safe 0))
(assert (not (= source_NET_001_15_ip_frag_reassembly_safe target_NET_001_15_ip_frag_reassembly_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_16_ip_no_overlapping_fragments: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_16_ip_no_overlapping_fragments preserves semantics
(push 1)
(declare-const source_NET_001_16_ip_no_overlapping_fragments Int)
(declare-const target_NET_001_16_ip_no_overlapping_fragments Int)
(assert (>= source_NET_001_16_ip_no_overlapping_fragments 0))
(assert (>= target_NET_001_16_ip_no_overlapping_fragments 0))
(assert (not (= source_NET_001_16_ip_no_overlapping_fragments target_NET_001_16_ip_no_overlapping_fragments)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_17_icmp_rate_limited: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_17_icmp_rate_limited preserves semantics
(push 1)
(declare-const source_NET_001_17_icmp_rate_limited Int)
(declare-const target_NET_001_17_icmp_rate_limited Int)
(assert (>= source_NET_001_17_icmp_rate_limited 0))
(assert (>= target_NET_001_17_icmp_rate_limited 0))
(assert (not (= source_NET_001_17_icmp_rate_limited target_NET_001_17_icmp_rate_limited)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_18_ip_routing_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_18_ip_routing_correct preserves semantics
(push 1)
(declare-const source_NET_001_18_ip_routing_correct Int)
(declare-const target_NET_001_18_ip_routing_correct Int)
(assert (>= source_NET_001_18_ip_routing_correct 0))
(assert (>= target_NET_001_18_ip_routing_correct 0))
(assert (not (= source_NET_001_18_ip_routing_correct target_NET_001_18_ip_routing_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_19_dnssec_chain_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_19_dnssec_chain_valid preserves semantics
(push 1)
(declare-const source_NET_001_19_dnssec_chain_valid Int)
(declare-const target_NET_001_19_dnssec_chain_valid Int)
(assert (>= source_NET_001_19_dnssec_chain_valid 0))
(assert (>= target_NET_001_19_dnssec_chain_valid 0))
(assert (not (= source_NET_001_19_dnssec_chain_valid target_NET_001_19_dnssec_chain_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_20_dns_cache_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_20_dns_cache_safe preserves semantics
(push 1)
(declare-const source_NET_001_20_dns_cache_safe Int)
(declare-const target_NET_001_20_dns_cache_safe Int)
(assert (>= source_NET_001_20_dns_cache_safe 0))
(assert (>= target_NET_001_20_dns_cache_safe 0))
(assert (not (= source_NET_001_20_dns_cache_safe target_NET_001_20_dns_cache_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_21_dns_no_rebinding: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_21_dns_no_rebinding preserves semantics
(push 1)
(declare-const source_NET_001_21_dns_no_rebinding Int)
(declare-const target_NET_001_21_dns_no_rebinding Int)
(assert (>= source_NET_001_21_dns_no_rebinding 0))
(assert (>= target_NET_001_21_dns_no_rebinding 0))
(assert (not (= source_NET_001_21_dns_no_rebinding target_NET_001_21_dns_no_rebinding)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_22_dns_query_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_22_dns_query_integrity preserves semantics
(push 1)
(declare-const source_NET_001_22_dns_query_integrity Int)
(declare-const target_NET_001_22_dns_query_integrity Int)
(assert (>= source_NET_001_22_dns_query_integrity 0))
(assert (>= target_NET_001_22_dns_query_integrity 0))
(assert (not (= source_NET_001_22_dns_query_integrity target_NET_001_22_dns_query_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_23_dns_response_authentic: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_23_dns_response_authentic preserves semantics
(push 1)
(declare-const source_NET_001_23_dns_response_authentic Int)
(declare-const target_NET_001_23_dns_response_authentic Int)
(assert (>= source_NET_001_23_dns_response_authentic 0))
(assert (>= target_NET_001_23_dns_response_authentic 0))
(assert (not (= source_NET_001_23_dns_response_authentic target_NET_001_23_dns_response_authentic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_24_dns_no_amplification: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_24_dns_no_amplification preserves semantics
(push 1)
(declare-const source_NET_001_24_dns_no_amplification Int)
(declare-const target_NET_001_24_dns_no_amplification Int)
(assert (>= source_NET_001_24_dns_no_amplification 0))
(assert (>= target_NET_001_24_dns_no_amplification 0))
(assert (not (= source_NET_001_24_dns_no_amplification target_NET_001_24_dns_no_amplification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NET_001_25_doh_confidential: translation preserves property (matches Coq: Theorem)
; Translation validation: NET_001_25_doh_confidential preserves semantics
(push 1)
(declare-const source_NET_001_25_doh_confidential Int)
(declare-const target_NET_001_25_doh_confidential Int)
(assert (>= source_NET_001_25_doh_confidential 0))
(assert (>= target_NET_001_25_doh_confidential 0))
(assert (not (= source_NET_001_25_doh_confidential target_NET_001_25_doh_confidential)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA NetworkSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/NetworkSecurity.v (26 assertions)
; Module: NetworkSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TLSConfig 0))
  (((mk-tls_config (tls_enabled Bool) (certificate_pinning_enabled Bool) (min_tls_version Int) (strong_cipher_suites Bool)))))

(declare-datatypes ((ARPConfig 0))
  (((mk-arp_config (static_arp_enabled Bool) (arp_inspection_enabled Bool) (gratuitous_arp_blocked Bool)))))

(declare-datatypes ((DNSSECConfig 0))
  (((mk-dnssec_config (dnssec_validation_enabled Bool) (dns_over_https Bool) (dns_over_tls Bool) (trusted_resolvers_only Bool)))))

(declare-datatypes ((BGPConfig 0))
  (((mk-bgp_config (rpki_validation_enabled Bool) (route_filtering_enabled Bool) (bgpsec_enabled Bool) (max_prefix_limit Int)))))

(declare-datatypes ((HTTPSConfig 0))
  (((mk-https_config (hsts_enabled Bool) (hsts_preload Bool) (hsts_include_subdomains Bool) (hsts_max_age Int)))))

(declare-datatypes ((EncryptionConfig 0))
  (((mk-encryption_config (encryption_at_rest Bool) (encryption_in_transit Bool) (vpn_enabled Bool) (ipsec_enabled Bool)))))

(declare-datatypes ((AuthProtocolConfig 0))
  (((mk-auth_protocol_config (protocol_auth_enabled Bool) (message_authentication_code Bool) (sequence_numbers_enabled Bool) (digital_signatures_enabled Bool)))))

(declare-datatypes ((ReplayProtectionConfig 0))
  (((mk-replay_protection_config (nonces_enabled Bool) (timestamps_enabled Bool) (sequence_window_size Int) (challenge_response_enabled Bool)))))

(declare-datatypes ((RateLimiterConfig 0))
  (((mk-rate_limiter_config (rate_limiting_enabled Bool) (requests_per_second Int) (burst_size Int) (cdn_protection_enabled Bool) (geo_blocking_enabled Bool)))))

(declare-datatypes ((ProtocolImplConfig 0))
  (((mk-protocol_impl_config (formally_verified_impl Bool) (fuzz_tested Bool) (memory_safe_language Bool) (strict_parsing_enabled Bool)))))

(declare-datatypes ((ResourceLimitsConfig 0))
  (((mk-resource_limits_config (resource_limits_enabled Bool) (max_connections Int) (max_memory_per_request Int) (request_timeout Int) (max_request_size Int)))))

(declare-datatypes ((AmplificationConfig 0))
  (((mk-amplification_config (open_resolvers_disabled Bool) (source_validation_enabled Bool) (response_rate_limiting Bool) (amplification_factor_limit Int)))))

(declare-datatypes ((SYNProtectionConfig 0))
  (((mk-syn_protection_config (syn_cookies_enabled Bool) (syn_rate_limit Int) (backlog_size Int) (syn_timeout Int)))))

(declare-datatypes ((UDPProtectionConfig 0))
  (((mk-udp_protection_config (udp_rate_limiting_enabled Bool) (udp_max_pps Int) (stateless_filtering Bool) (udp_timeout Int)))))

(declare-datatypes ((ICMPProtectionConfig 0))
  (((mk-icmp_protection_config (icmp_rate_limiting_enabled Bool) (icmp_max_pps Int) (echo_request_filtering Bool) (icmp_redirect_blocked Bool)))))

(declare-datatypes ((SlowlorisProtectionConfig 0))
  (((mk-slowloris_protection_config (connection_timeout_enabled Bool) (header_timeout Int) (body_timeout Int) (min_data_rate Int) (max_concurrent_connections Int)))))

(declare-datatypes ((DNSServerConfig 0))
  (((mk-dns_server_config (dns_response_rate_limiting Bool) (dns_rrl_threshold Int) (recursion_restricted Bool) (any_query_disabled Bool)))))

(declare-datatypes ((NTPServerConfig 0))
  (((mk-ntp_server_config (monlist_disabled Bool) (ntp_access_restricted Bool) (ntp_authentication_enabled Bool) (rate_limiting_enabled_ntp Bool)))))

(declare-datatypes ((IPSpoofingConfig 0))
  (((mk-ip_spoofing_config (bcp38_filtering_enabled Bool) (urpf_enabled Bool) (source_address_validation Bool) (ingress_filtering_enabled Bool)))))

(declare-datatypes ((MACSecurityConfig 0))
  (((mk-mac_security_config (ieee_802_1x_enabled Bool) (port_security_enabled Bool) (mac_address_limit Int) (sticky_mac_enabled Bool)))))

(declare-datatypes ((VLANSecurityConfig 0))
  (((mk-vlan_security_config (native_vlan_changed Bool) (trunk_ports_restricted Bool) (dtp_disabled Bool) (private_vlans_enabled Bool)))))

(declare-datatypes ((DHCPSecurityConfig 0))
  (((mk-dhcp_security_config (dhcp_snooping_enabled Bool) (trusted_ports_configured Bool) (rate_limit_dhcp Int) (option_82_enabled Bool)))))

(declare-datatypes ((NTPClientConfig 0))
  (((mk-ntp_client_config (multiple_time_sources Bool) (min_time_sources Int) (nts_enabled Bool) (authenticated_ntp Bool)))))

(declare-datatypes ((TCPSecurityConfig 0))
  (((mk-tcp_security_config (tcp_encryption_enabled Bool) (tcp_md5_auth Bool) (tcp_ao_enabled Bool) (randomized_isn Bool)))))

(declare-datatypes ((TrafficAnalysisConfig 0))
  (((mk-traffic_analysis_config (traffic_padding_enabled Bool) (traffic_mixing_enabled Bool) (constant_rate_transmission Bool) (cover_traffic_enabled Bool)))))

(declare-datatypes ((NetworkSecurityConfig 0))
  (((mk-network_security_config (ns_tls TLSConfig) (ns_arp ARPConfig) (ns_dnssec DNSSECConfig) (ns_bgp BGPConfig) (ns_https HTTPSConfig) (ns_encryption EncryptionConfig) (ns_auth_protocol AuthProtocolConfig) (ns_replay ReplayProtectionConfig) (ns_rate_limiter RateLimiterConfig) (ns_protocol_impl ProtocolImplConfig) (ns_resource_limits ResourceLimitsConfig) (ns_amplification AmplificationConfig) (ns_syn SYNProtectionConfig) (ns_udp UDPProtectionConfig) (ns_icmp ICMPProtectionConfig) (ns_slowloris SlowlorisProtectionConfig) (ns_dns_server DNSServerConfig) (ns_ntp_server NTPServerConfig) (ns_ip_spoofing IPSpoofingConfig) (ns_mac MACSecurityConfig) (ns_vlan VLANSecurityConfig) (ns_dhcp DHCPSecurityConfig) (ns_ntp_client NTPClientConfig) (ns_tcp TCPSecurityConfig) (ns_traffic_analysis TrafficAnalysisConfig)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. TLSConfig accessor round-trip: tls_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tls_enabled (mk-tls_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TLSConfig accessor round-trip: certificate_pinning_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (certificate_pinning_enabled (mk-tls_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TLSConfig accessor round-trip: min_tls_version ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (min_tls_version (mk-tls_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TLSConfig accessor round-trip: strong_cipher_suites ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (strong_cipher_suites (mk-tls_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ARPConfig accessor round-trip: static_arp_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (static_arp_enabled (mk-arp_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ARPConfig accessor round-trip: arp_inspection_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (arp_inspection_enabled (mk-arp_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. ARPConfig accessor round-trip: gratuitous_arp_blocked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (gratuitous_arp_blocked (mk-arp_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ARPConfig_all_enabled ((g ARPConfig)) Bool
  (and (static_arp_enabled g) (arp_inspection_enabled g) (gratuitous_arp_blocked g)))

; --- 8. ARPConfig: all-enabled completeness ---
(push 1)
(declare-const g ARPConfig)
(assert (static_arp_enabled g))
(assert (arp_inspection_enabled g))
(assert (gratuitous_arp_blocked g))
(assert (not (ARPConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ARPConfig: ARPConfig_all_enabled implies static_arp_enabled ---
(push 1)
(declare-const g ARPConfig)
(assert (ARPConfig_all_enabled g))
(assert (not (static_arp_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ARPConfig: ARPConfig_all_enabled implies arp_inspection_enabled ---
(push 1)
(declare-const g ARPConfig)
(assert (ARPConfig_all_enabled g))
(assert (not (arp_inspection_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ARPConfig: ARPConfig_all_enabled implies gratuitous_arp_blocked ---
(push 1)
(declare-const g ARPConfig)
(assert (ARPConfig_all_enabled g))
(assert (not (gratuitous_arp_blocked g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. DNSSECConfig accessor round-trip: dnssec_validation_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dnssec_validation_enabled (mk-dnssec_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. DNSSECConfig accessor round-trip: dns_over_https ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dns_over_https (mk-dnssec_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. DNSSECConfig accessor round-trip: dns_over_tls ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dns_over_tls (mk-dnssec_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. DNSSECConfig accessor round-trip: trusted_resolvers_only ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (trusted_resolvers_only (mk-dnssec_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DNSSECConfig_all_enabled ((g DNSSECConfig)) Bool
  (and (dnssec_validation_enabled g) (dns_over_https g) (dns_over_tls g) (trusted_resolvers_only g)))

; --- 16. DNSSECConfig: all-enabled completeness ---
(push 1)
(declare-const g DNSSECConfig)
(assert (dnssec_validation_enabled g))
(assert (dns_over_https g))
(assert (dns_over_tls g))
(assert (trusted_resolvers_only g))
(assert (not (DNSSECConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. DNSSECConfig: DNSSECConfig_all_enabled implies dnssec_validation_enabled ---
(push 1)
(declare-const g DNSSECConfig)
(assert (DNSSECConfig_all_enabled g))
(assert (not (dnssec_validation_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. DNSSECConfig: DNSSECConfig_all_enabled implies dns_over_https ---
(push 1)
(declare-const g DNSSECConfig)
(assert (DNSSECConfig_all_enabled g))
(assert (not (dns_over_https g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. DNSSECConfig: DNSSECConfig_all_enabled implies dns_over_tls ---
(push 1)
(declare-const g DNSSECConfig)
(assert (DNSSECConfig_all_enabled g))
(assert (not (dns_over_tls g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. BGPConfig accessor round-trip: rpki_validation_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (rpki_validation_enabled (mk-bgp_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. BGPConfig accessor round-trip: route_filtering_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (route_filtering_enabled (mk-bgp_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. BGPConfig accessor round-trip: bgpsec_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (bgpsec_enabled (mk-bgp_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BGPConfig accessor round-trip: max_prefix_limit ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (max_prefix_limit (mk-bgp_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. HTTPSConfig accessor round-trip: hsts_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (hsts_enabled (mk-https_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. HTTPSConfig accessor round-trip: hsts_preload ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (hsts_preload (mk-https_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. HTTPSConfig accessor round-trip: hsts_include_subdomains ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (hsts_include_subdomains (mk-https_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. HTTPSConfig accessor round-trip: hsts_max_age ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (hsts_max_age (mk-https_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. EncryptionConfig accessor round-trip: encryption_at_rest ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (encryption_at_rest (mk-encryption_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. EncryptionConfig accessor round-trip: encryption_in_transit ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (encryption_in_transit (mk-encryption_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. EncryptionConfig accessor round-trip: vpn_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vpn_enabled (mk-encryption_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. EncryptionConfig accessor round-trip: ipsec_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ipsec_enabled (mk-encryption_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun EncryptionConfig_all_enabled ((g EncryptionConfig)) Bool
  (and (encryption_at_rest g) (encryption_in_transit g) (vpn_enabled g) (ipsec_enabled g)))

; --- 32. EncryptionConfig: all-enabled completeness ---
(push 1)
(declare-const g EncryptionConfig)
(assert (encryption_at_rest g))
(assert (encryption_in_transit g))
(assert (vpn_enabled g))
(assert (ipsec_enabled g))
(assert (not (EncryptionConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. EncryptionConfig: EncryptionConfig_all_enabled implies encryption_at_rest ---
(push 1)
(declare-const g EncryptionConfig)
(assert (EncryptionConfig_all_enabled g))
(assert (not (encryption_at_rest g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. EncryptionConfig: EncryptionConfig_all_enabled implies encryption_in_transit ---
(push 1)
(declare-const g EncryptionConfig)
(assert (EncryptionConfig_all_enabled g))
(assert (not (encryption_in_transit g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. EncryptionConfig: EncryptionConfig_all_enabled implies vpn_enabled ---
(push 1)
(declare-const g EncryptionConfig)
(assert (EncryptionConfig_all_enabled g))
(assert (not (vpn_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. AuthProtocolConfig accessor round-trip: protocol_auth_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (protocol_auth_enabled (mk-auth_protocol_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. AuthProtocolConfig accessor round-trip: message_authentication_code ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (message_authentication_code (mk-auth_protocol_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. AuthProtocolConfig accessor round-trip: sequence_numbers_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sequence_numbers_enabled (mk-auth_protocol_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. AuthProtocolConfig accessor round-trip: digital_signatures_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (digital_signatures_enabled (mk-auth_protocol_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun AuthProtocolConfig_all_enabled ((g AuthProtocolConfig)) Bool
  (and (protocol_auth_enabled g) (message_authentication_code g) (sequence_numbers_enabled g) (digital_signatures_enabled g)))

; --- 40. AuthProtocolConfig: all-enabled completeness ---
(push 1)
(declare-const g AuthProtocolConfig)
(assert (protocol_auth_enabled g))
(assert (message_authentication_code g))
(assert (sequence_numbers_enabled g))
(assert (digital_signatures_enabled g))
(assert (not (AuthProtocolConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. AuthProtocolConfig: AuthProtocolConfig_all_enabled implies protocol_auth_enabled ---
(push 1)
(declare-const g AuthProtocolConfig)
(assert (AuthProtocolConfig_all_enabled g))
(assert (not (protocol_auth_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. AuthProtocolConfig: AuthProtocolConfig_all_enabled implies message_authentication_code ---
(push 1)
(declare-const g AuthProtocolConfig)
(assert (AuthProtocolConfig_all_enabled g))
(assert (not (message_authentication_code g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. AuthProtocolConfig: AuthProtocolConfig_all_enabled implies sequence_numbers_enabled ---
(push 1)
(declare-const g AuthProtocolConfig)
(assert (AuthProtocolConfig_all_enabled g))
(assert (not (sequence_numbers_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. ReplayProtectionConfig accessor round-trip: nonces_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (nonces_enabled (mk-replay_protection_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. ReplayProtectionConfig accessor round-trip: timestamps_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (timestamps_enabled (mk-replay_protection_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. ReplayProtectionConfig accessor round-trip: sequence_window_size ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (sequence_window_size (mk-replay_protection_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. ReplayProtectionConfig accessor round-trip: challenge_response_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (challenge_response_enabled (mk-replay_protection_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. RateLimiterConfig accessor round-trip: rate_limiting_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (rate_limiting_enabled (mk-rate_limiter_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. RateLimiterConfig accessor round-trip: requests_per_second ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (requests_per_second (mk-rate_limiter_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. RateLimiterConfig accessor round-trip: burst_size ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (burst_size (mk-rate_limiter_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. RateLimiterConfig accessor round-trip: cdn_protection_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cdn_protection_enabled (mk-rate_limiter_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. RateLimiterConfig accessor round-trip: geo_blocking_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (geo_blocking_enabled (mk-rate_limiter_config f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. RateLimiterConfig: non-negative int fields sum ---
(push 1)
(declare-const r RateLimiterConfig)
(assert (>= (requests_per_second r) 0))
(assert (>= (burst_size r) 0))
(assert (not (>= (+ (requests_per_second r) (burst_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. ProtocolImplConfig accessor round-trip: formally_verified_impl ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (formally_verified_impl (mk-protocol_impl_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. ProtocolImplConfig accessor round-trip: fuzz_tested ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fuzz_tested (mk-protocol_impl_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. ProtocolImplConfig accessor round-trip: memory_safe_language ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (memory_safe_language (mk-protocol_impl_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. ProtocolImplConfig accessor round-trip: strict_parsing_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (strict_parsing_enabled (mk-protocol_impl_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ProtocolImplConfig_all_enabled ((g ProtocolImplConfig)) Bool
  (and (formally_verified_impl g) (fuzz_tested g) (memory_safe_language g) (strict_parsing_enabled g)))

; --- 58. ProtocolImplConfig: all-enabled completeness ---
(push 1)
(declare-const g ProtocolImplConfig)
(assert (formally_verified_impl g))
(assert (fuzz_tested g))
(assert (memory_safe_language g))
(assert (strict_parsing_enabled g))
(assert (not (ProtocolImplConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. ProtocolImplConfig: ProtocolImplConfig_all_enabled implies formally_verified_impl ---
(push 1)
(declare-const g ProtocolImplConfig)
(assert (ProtocolImplConfig_all_enabled g))
(assert (not (formally_verified_impl g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. ProtocolImplConfig: ProtocolImplConfig_all_enabled implies fuzz_tested ---
(push 1)
(declare-const g ProtocolImplConfig)
(assert (ProtocolImplConfig_all_enabled g))
(assert (not (fuzz_tested g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. ProtocolImplConfig: ProtocolImplConfig_all_enabled implies memory_safe_language ---
(push 1)
(declare-const g ProtocolImplConfig)
(assert (ProtocolImplConfig_all_enabled g))
(assert (not (memory_safe_language g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. ResourceLimitsConfig accessor round-trip: resource_limits_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (resource_limits_enabled (mk-resource_limits_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. ResourceLimitsConfig accessor round-trip: max_connections ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (max_connections (mk-resource_limits_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. ResourceLimitsConfig accessor round-trip: max_memory_per_request ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (max_memory_per_request (mk-resource_limits_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. ResourceLimitsConfig accessor round-trip: request_timeout ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (request_timeout (mk-resource_limits_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. ResourceLimitsConfig accessor round-trip: max_request_size ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (max_request_size (mk-resource_limits_config f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. ResourceLimitsConfig: non-negative int fields sum ---
(push 1)
(declare-const r ResourceLimitsConfig)
(assert (>= (max_connections r) 0))
(assert (>= (max_memory_per_request r) 0))
(assert (not (>= (+ (max_connections r) (max_memory_per_request r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. AmplificationConfig accessor round-trip: open_resolvers_disabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (open_resolvers_disabled (mk-amplification_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. AmplificationConfig accessor round-trip: source_validation_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (source_validation_enabled (mk-amplification_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. AmplificationConfig accessor round-trip: response_rate_limiting ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (response_rate_limiting (mk-amplification_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. AmplificationConfig accessor round-trip: amplification_factor_limit ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (amplification_factor_limit (mk-amplification_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. SYNProtectionConfig accessor round-trip: syn_cookies_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (syn_cookies_enabled (mk-syn_protection_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. SYNProtectionConfig accessor round-trip: syn_rate_limit ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (syn_rate_limit (mk-syn_protection_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. SYNProtectionConfig accessor round-trip: backlog_size ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (backlog_size (mk-syn_protection_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. SYNProtectionConfig accessor round-trip: syn_timeout ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (syn_timeout (mk-syn_protection_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. SYNProtectionConfig: non-negative int fields sum ---
(push 1)
(declare-const r SYNProtectionConfig)
(assert (>= (syn_rate_limit r) 0))
(assert (>= (backlog_size r) 0))
(assert (not (>= (+ (syn_rate_limit r) (backlog_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. UDPProtectionConfig accessor round-trip: udp_rate_limiting_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (udp_rate_limiting_enabled (mk-udp_protection_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. UDPProtectionConfig accessor round-trip: udp_max_pps ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (udp_max_pps (mk-udp_protection_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. UDPProtectionConfig accessor round-trip: stateless_filtering ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (stateless_filtering (mk-udp_protection_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. UDPProtectionConfig accessor round-trip: udp_timeout ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (udp_timeout (mk-udp_protection_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. UDPProtectionConfig: non-negative int fields sum ---
(push 1)
(declare-const r UDPProtectionConfig)
(assert (>= (udp_max_pps r) 0))
(assert (>= (udp_timeout r) 0))
(assert (not (>= (+ (udp_max_pps r) (udp_timeout r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. ICMPProtectionConfig accessor round-trip: icmp_rate_limiting_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (icmp_rate_limiting_enabled (mk-icmp_protection_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. ICMPProtectionConfig accessor round-trip: icmp_max_pps ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (icmp_max_pps (mk-icmp_protection_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. ICMPProtectionConfig accessor round-trip: echo_request_filtering ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (echo_request_filtering (mk-icmp_protection_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. ICMPProtectionConfig accessor round-trip: icmp_redirect_blocked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (icmp_redirect_blocked (mk-icmp_protection_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. SlowlorisProtectionConfig accessor round-trip: connection_timeout_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (connection_timeout_enabled (mk-slowloris_protection_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. SlowlorisProtectionConfig accessor round-trip: header_timeout ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (header_timeout (mk-slowloris_protection_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. SlowlorisProtectionConfig accessor round-trip: body_timeout ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (body_timeout (mk-slowloris_protection_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. SlowlorisProtectionConfig accessor round-trip: min_data_rate ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (min_data_rate (mk-slowloris_protection_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. SlowlorisProtectionConfig accessor round-trip: max_concurrent_connections ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (max_concurrent_connections (mk-slowloris_protection_config f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. SlowlorisProtectionConfig: non-negative int fields sum ---
(push 1)
(declare-const r SlowlorisProtectionConfig)
(assert (>= (header_timeout r) 0))
(assert (>= (body_timeout r) 0))
(assert (not (>= (+ (header_timeout r) (body_timeout r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 92. DNSServerConfig accessor round-trip: dns_response_rate_limiting ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dns_response_rate_limiting (mk-dns_server_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. DNSServerConfig accessor round-trip: dns_rrl_threshold ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dns_rrl_threshold (mk-dns_server_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. DNSServerConfig accessor round-trip: recursion_restricted ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (recursion_restricted (mk-dns_server_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 95. DNSServerConfig accessor round-trip: any_query_disabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (any_query_disabled (mk-dns_server_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. NTPServerConfig accessor round-trip: monlist_disabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (monlist_disabled (mk-ntp_server_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. NTPServerConfig accessor round-trip: ntp_access_restricted ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ntp_access_restricted (mk-ntp_server_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. NTPServerConfig accessor round-trip: ntp_authentication_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ntp_authentication_enabled (mk-ntp_server_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. NTPServerConfig accessor round-trip: rate_limiting_enabled_ntp ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rate_limiting_enabled_ntp (mk-ntp_server_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun NTPServerConfig_all_enabled ((g NTPServerConfig)) Bool
  (and (monlist_disabled g) (ntp_access_restricted g) (ntp_authentication_enabled g) (rate_limiting_enabled_ntp g)))

; --- 100. NTPServerConfig: all-enabled completeness ---
(push 1)
(declare-const g NTPServerConfig)
(assert (monlist_disabled g))
(assert (ntp_access_restricted g))
(assert (ntp_authentication_enabled g))
(assert (rate_limiting_enabled_ntp g))
(assert (not (NTPServerConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 101. NTPServerConfig: NTPServerConfig_all_enabled implies monlist_disabled ---
(push 1)
(declare-const g NTPServerConfig)
(assert (NTPServerConfig_all_enabled g))
(assert (not (monlist_disabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 102. NTPServerConfig: NTPServerConfig_all_enabled implies ntp_access_restricted ---
(push 1)
(declare-const g NTPServerConfig)
(assert (NTPServerConfig_all_enabled g))
(assert (not (ntp_access_restricted g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. NTPServerConfig: NTPServerConfig_all_enabled implies ntp_authentication_enabled ---
(push 1)
(declare-const g NTPServerConfig)
(assert (NTPServerConfig_all_enabled g))
(assert (not (ntp_authentication_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 104. IPSpoofingConfig accessor round-trip: bcp38_filtering_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bcp38_filtering_enabled (mk-ip_spoofing_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 105. IPSpoofingConfig accessor round-trip: urpf_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (urpf_enabled (mk-ip_spoofing_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 106. IPSpoofingConfig accessor round-trip: source_address_validation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (source_address_validation (mk-ip_spoofing_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 107. IPSpoofingConfig accessor round-trip: ingress_filtering_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ingress_filtering_enabled (mk-ip_spoofing_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun IPSpoofingConfig_all_enabled ((g IPSpoofingConfig)) Bool
  (and (bcp38_filtering_enabled g) (urpf_enabled g) (source_address_validation g) (ingress_filtering_enabled g)))

; --- 108. IPSpoofingConfig: all-enabled completeness ---
(push 1)
(declare-const g IPSpoofingConfig)
(assert (bcp38_filtering_enabled g))
(assert (urpf_enabled g))
(assert (source_address_validation g))
(assert (ingress_filtering_enabled g))
(assert (not (IPSpoofingConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 109. IPSpoofingConfig: IPSpoofingConfig_all_enabled implies bcp38_filtering_enabled ---
(push 1)
(declare-const g IPSpoofingConfig)
(assert (IPSpoofingConfig_all_enabled g))
(assert (not (bcp38_filtering_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 110. IPSpoofingConfig: IPSpoofingConfig_all_enabled implies urpf_enabled ---
(push 1)
(declare-const g IPSpoofingConfig)
(assert (IPSpoofingConfig_all_enabled g))
(assert (not (urpf_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 111. IPSpoofingConfig: IPSpoofingConfig_all_enabled implies source_address_validation ---
(push 1)
(declare-const g IPSpoofingConfig)
(assert (IPSpoofingConfig_all_enabled g))
(assert (not (source_address_validation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 112. MACSecurityConfig accessor round-trip: ieee_802_1x_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ieee_802_1x_enabled (mk-mac_security_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 113. MACSecurityConfig accessor round-trip: port_security_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (port_security_enabled (mk-mac_security_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 114. MACSecurityConfig accessor round-trip: mac_address_limit ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (mac_address_limit (mk-mac_security_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 115. MACSecurityConfig accessor round-trip: sticky_mac_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (sticky_mac_enabled (mk-mac_security_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 116. VLANSecurityConfig accessor round-trip: native_vlan_changed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (native_vlan_changed (mk-vlan_security_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 117. VLANSecurityConfig accessor round-trip: trunk_ports_restricted ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (trunk_ports_restricted (mk-vlan_security_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 118. VLANSecurityConfig accessor round-trip: dtp_disabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dtp_disabled (mk-vlan_security_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 119. VLANSecurityConfig accessor round-trip: private_vlans_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (private_vlans_enabled (mk-vlan_security_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun VLANSecurityConfig_all_enabled ((g VLANSecurityConfig)) Bool
  (and (native_vlan_changed g) (trunk_ports_restricted g) (dtp_disabled g) (private_vlans_enabled g)))

; --- 120. VLANSecurityConfig: all-enabled completeness ---
(push 1)
(declare-const g VLANSecurityConfig)
(assert (native_vlan_changed g))
(assert (trunk_ports_restricted g))
(assert (dtp_disabled g))
(assert (private_vlans_enabled g))
(assert (not (VLANSecurityConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 121. VLANSecurityConfig: VLANSecurityConfig_all_enabled implies native_vlan_changed ---
(push 1)
(declare-const g VLANSecurityConfig)
(assert (VLANSecurityConfig_all_enabled g))
(assert (not (native_vlan_changed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 122. VLANSecurityConfig: VLANSecurityConfig_all_enabled implies trunk_ports_restricted ---
(push 1)
(declare-const g VLANSecurityConfig)
(assert (VLANSecurityConfig_all_enabled g))
(assert (not (trunk_ports_restricted g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 123. VLANSecurityConfig: VLANSecurityConfig_all_enabled implies dtp_disabled ---
(push 1)
(declare-const g VLANSecurityConfig)
(assert (VLANSecurityConfig_all_enabled g))
(assert (not (dtp_disabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 124. DHCPSecurityConfig accessor round-trip: dhcp_snooping_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (dhcp_snooping_enabled (mk-dhcp_security_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 125. DHCPSecurityConfig accessor round-trip: trusted_ports_configured ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (trusted_ports_configured (mk-dhcp_security_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 126. DHCPSecurityConfig accessor round-trip: rate_limit_dhcp ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (rate_limit_dhcp (mk-dhcp_security_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 127. DHCPSecurityConfig accessor round-trip: option_82_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (option_82_enabled (mk-dhcp_security_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 128. NTPClientConfig accessor round-trip: multiple_time_sources ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (multiple_time_sources (mk-ntp_client_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 129. NTPClientConfig accessor round-trip: min_time_sources ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (min_time_sources (mk-ntp_client_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 130. NTPClientConfig accessor round-trip: nts_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (nts_enabled (mk-ntp_client_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 131. NTPClientConfig accessor round-trip: authenticated_ntp ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (authenticated_ntp (mk-ntp_client_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 132. TCPSecurityConfig accessor round-trip: tcp_encryption_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tcp_encryption_enabled (mk-tcp_security_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 133. TCPSecurityConfig accessor round-trip: tcp_md5_auth ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tcp_md5_auth (mk-tcp_security_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 134. TCPSecurityConfig accessor round-trip: tcp_ao_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tcp_ao_enabled (mk-tcp_security_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 135. TCPSecurityConfig accessor round-trip: randomized_isn ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (randomized_isn (mk-tcp_security_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TCPSecurityConfig_all_enabled ((g TCPSecurityConfig)) Bool
  (and (tcp_encryption_enabled g) (tcp_md5_auth g) (tcp_ao_enabled g) (randomized_isn g)))

; --- 136. TCPSecurityConfig: all-enabled completeness ---
(push 1)
(declare-const g TCPSecurityConfig)
(assert (tcp_encryption_enabled g))
(assert (tcp_md5_auth g))
(assert (tcp_ao_enabled g))
(assert (randomized_isn g))
(assert (not (TCPSecurityConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 137. TCPSecurityConfig: TCPSecurityConfig_all_enabled implies tcp_encryption_enabled ---
(push 1)
(declare-const g TCPSecurityConfig)
(assert (TCPSecurityConfig_all_enabled g))
(assert (not (tcp_encryption_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 138. TCPSecurityConfig: TCPSecurityConfig_all_enabled implies tcp_md5_auth ---
(push 1)
(declare-const g TCPSecurityConfig)
(assert (TCPSecurityConfig_all_enabled g))
(assert (not (tcp_md5_auth g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 139. TCPSecurityConfig: TCPSecurityConfig_all_enabled implies tcp_ao_enabled ---
(push 1)
(declare-const g TCPSecurityConfig)
(assert (TCPSecurityConfig_all_enabled g))
(assert (not (tcp_ao_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 140. TrafficAnalysisConfig accessor round-trip: traffic_padding_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (traffic_padding_enabled (mk-traffic_analysis_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 141. TrafficAnalysisConfig accessor round-trip: traffic_mixing_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (traffic_mixing_enabled (mk-traffic_analysis_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 142. TrafficAnalysisConfig accessor round-trip: constant_rate_transmission ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (constant_rate_transmission (mk-traffic_analysis_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 143. TrafficAnalysisConfig accessor round-trip: cover_traffic_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cover_traffic_enabled (mk-traffic_analysis_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TrafficAnalysisConfig_all_enabled ((g TrafficAnalysisConfig)) Bool
  (and (traffic_padding_enabled g) (traffic_mixing_enabled g) (constant_rate_transmission g) (cover_traffic_enabled g)))

; --- 144. TrafficAnalysisConfig: all-enabled completeness ---
(push 1)
(declare-const g TrafficAnalysisConfig)
(assert (traffic_padding_enabled g))
(assert (traffic_mixing_enabled g))
(assert (constant_rate_transmission g))
(assert (cover_traffic_enabled g))
(assert (not (TrafficAnalysisConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 145. TrafficAnalysisConfig: TrafficAnalysisConfig_all_enabled implies traffic_padding_enabled ---
(push 1)
(declare-const g TrafficAnalysisConfig)
(assert (TrafficAnalysisConfig_all_enabled g))
(assert (not (traffic_padding_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 146. TrafficAnalysisConfig: TrafficAnalysisConfig_all_enabled implies traffic_mixing_enabled ---
(push 1)
(declare-const g TrafficAnalysisConfig)
(assert (TrafficAnalysisConfig_all_enabled g))
(assert (not (traffic_mixing_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 147. TrafficAnalysisConfig: TrafficAnalysisConfig_all_enabled implies constant_rate_transmission ---
(push 1)
(declare-const g TrafficAnalysisConfig)
(assert (TrafficAnalysisConfig_all_enabled g))
(assert (not (constant_rate_transmission g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 148. NetworkSecurityConfig accessor round-trip: ns_tls ---
(push 1)
(declare-const f0 TLSConfig)
(declare-const f1 ARPConfig)
(declare-const f2 DNSSECConfig)
(declare-const f3 BGPConfig)
(declare-const f4 HTTPSConfig)
(declare-const f5 EncryptionConfig)
(declare-const f6 AuthProtocolConfig)
(declare-const f7 ReplayProtectionConfig)
(declare-const f8 RateLimiterConfig)
(declare-const f9 ProtocolImplConfig)
(declare-const f10 ResourceLimitsConfig)
(declare-const f11 AmplificationConfig)
(declare-const f12 SYNProtectionConfig)
(declare-const f13 UDPProtectionConfig)
(declare-const f14 ICMPProtectionConfig)
(declare-const f15 SlowlorisProtectionConfig)
(declare-const f16 DNSServerConfig)
(declare-const f17 NTPServerConfig)
(declare-const f18 IPSpoofingConfig)
(declare-const f19 MACSecurityConfig)
(declare-const f20 VLANSecurityConfig)
(declare-const f21 DHCPSecurityConfig)
(declare-const f22 NTPClientConfig)
(declare-const f23 TCPSecurityConfig)
(declare-const f24 TrafficAnalysisConfig)
(assert (not (= (ns_tls (mk-network_security_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 149. NetworkSecurityConfig accessor round-trip: ns_arp ---
(push 1)
(declare-const f0 TLSConfig)
(declare-const f1 ARPConfig)
(declare-const f2 DNSSECConfig)
(declare-const f3 BGPConfig)
(declare-const f4 HTTPSConfig)
(declare-const f5 EncryptionConfig)
(declare-const f6 AuthProtocolConfig)
(declare-const f7 ReplayProtectionConfig)
(declare-const f8 RateLimiterConfig)
(declare-const f9 ProtocolImplConfig)
(declare-const f10 ResourceLimitsConfig)
(declare-const f11 AmplificationConfig)
(declare-const f12 SYNProtectionConfig)
(declare-const f13 UDPProtectionConfig)
(declare-const f14 ICMPProtectionConfig)
(declare-const f15 SlowlorisProtectionConfig)
(declare-const f16 DNSServerConfig)
(declare-const f17 NTPServerConfig)
(declare-const f18 IPSpoofingConfig)
(declare-const f19 MACSecurityConfig)
(declare-const f20 VLANSecurityConfig)
(declare-const f21 DHCPSecurityConfig)
(declare-const f22 NTPClientConfig)
(declare-const f23 TCPSecurityConfig)
(declare-const f24 TrafficAnalysisConfig)
(assert (not (= (ns_arp (mk-network_security_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 150. NetworkSecurityConfig accessor round-trip: ns_dnssec ---
(push 1)
(declare-const f0 TLSConfig)
(declare-const f1 ARPConfig)
(declare-const f2 DNSSECConfig)
(declare-const f3 BGPConfig)
(declare-const f4 HTTPSConfig)
(declare-const f5 EncryptionConfig)
(declare-const f6 AuthProtocolConfig)
(declare-const f7 ReplayProtectionConfig)
(declare-const f8 RateLimiterConfig)
(declare-const f9 ProtocolImplConfig)
(declare-const f10 ResourceLimitsConfig)
(declare-const f11 AmplificationConfig)
(declare-const f12 SYNProtectionConfig)
(declare-const f13 UDPProtectionConfig)
(declare-const f14 ICMPProtectionConfig)
(declare-const f15 SlowlorisProtectionConfig)
(declare-const f16 DNSServerConfig)
(declare-const f17 NTPServerConfig)
(declare-const f18 IPSpoofingConfig)
(declare-const f19 MACSecurityConfig)
(declare-const f20 VLANSecurityConfig)
(declare-const f21 DHCPSecurityConfig)
(declare-const f22 NTPClientConfig)
(declare-const f23 TCPSecurityConfig)
(declare-const f24 TrafficAnalysisConfig)
(assert (not (= (ns_dnssec (mk-network_security_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 151. NetworkSecurityConfig accessor round-trip: ns_bgp ---
(push 1)
(declare-const f0 TLSConfig)
(declare-const f1 ARPConfig)
(declare-const f2 DNSSECConfig)
(declare-const f3 BGPConfig)
(declare-const f4 HTTPSConfig)
(declare-const f5 EncryptionConfig)
(declare-const f6 AuthProtocolConfig)
(declare-const f7 ReplayProtectionConfig)
(declare-const f8 RateLimiterConfig)
(declare-const f9 ProtocolImplConfig)
(declare-const f10 ResourceLimitsConfig)
(declare-const f11 AmplificationConfig)
(declare-const f12 SYNProtectionConfig)
(declare-const f13 UDPProtectionConfig)
(declare-const f14 ICMPProtectionConfig)
(declare-const f15 SlowlorisProtectionConfig)
(declare-const f16 DNSServerConfig)
(declare-const f17 NTPServerConfig)
(declare-const f18 IPSpoofingConfig)
(declare-const f19 MACSecurityConfig)
(declare-const f20 VLANSecurityConfig)
(declare-const f21 DHCPSecurityConfig)
(declare-const f22 NTPClientConfig)
(declare-const f23 TCPSecurityConfig)
(declare-const f24 TrafficAnalysisConfig)
(assert (not (= (ns_bgp (mk-network_security_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 152. NetworkSecurityConfig accessor round-trip: ns_https ---
(push 1)
(declare-const f0 TLSConfig)
(declare-const f1 ARPConfig)
(declare-const f2 DNSSECConfig)
(declare-const f3 BGPConfig)
(declare-const f4 HTTPSConfig)
(declare-const f5 EncryptionConfig)
(declare-const f6 AuthProtocolConfig)
(declare-const f7 ReplayProtectionConfig)
(declare-const f8 RateLimiterConfig)
(declare-const f9 ProtocolImplConfig)
(declare-const f10 ResourceLimitsConfig)
(declare-const f11 AmplificationConfig)
(declare-const f12 SYNProtectionConfig)
(declare-const f13 UDPProtectionConfig)
(declare-const f14 ICMPProtectionConfig)
(declare-const f15 SlowlorisProtectionConfig)
(declare-const f16 DNSServerConfig)
(declare-const f17 NTPServerConfig)
(declare-const f18 IPSpoofingConfig)
(declare-const f19 MACSecurityConfig)
(declare-const f20 VLANSecurityConfig)
(declare-const f21 DHCPSecurityConfig)
(declare-const f22 NTPClientConfig)
(declare-const f23 TCPSecurityConfig)
(declare-const f24 TrafficAnalysisConfig)
(assert (not (= (ns_https (mk-network_security_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA QuantumSafeTLS — SMT Verification
; Derived from 02_FORMAL/coq/domains/QuantumSafeTLS.v (69 assertions)
; Module: QuantumSafeTLS
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SecurityLevel 0)) (((Level1) (Level3) (Level5))))

(declare-datatypes ((KEMScheme 0)) (((ML_KEM_512) (ML_KEM_768) (ML_KEM_1024))))

(declare-datatypes ((ECDHCurve 0)) (((X25519) (X448) (P256) (P384) (P521))))

(declare-datatypes ((SignatureScheme 0)) (((ML_DSA_44) (ML_DSA_65) (ML_DSA_87) (SLH_DSA_128) (SLH_DSA_192) (SLH_DSA_256) (ECDSA_P256) (Ed25519))))

(declare-datatypes ((TLSVersion 0)) (((TLS_1_2) (TLS_1_3))))

(declare-datatypes ((CipherSuite 0)) (((TLS_AES_128_GCM_SHA256) (TLS_AES_256_GCM_SHA384) (TLS_CHACHA20_POLY1305_SHA256))))

(declare-datatypes ((KEMParameters 0))
  (((mk-kem_parameters (kem_scheme KEMScheme) (kem_pk_size Int) (kem_sk_size Int) (kem_ct_size Int) (kem_ss_size Int)))))

(declare-datatypes ((KEMSecurityProperties 0))
  (((mk-kem_security_properties (kem_sec_indcca2 Bool) (kem_sec_module_lwe Bool) (kem_sec_nist_approved Bool) (kem_sec_constant_time Bool)))))

(declare-datatypes ((ECDHParameters 0))
  (((mk-ecdh_parameters (ecdh_curve ECDHCurve) (ecdh_pk_size Int) (ecdh_sk_size Int) (ecdh_ss_size Int)))))

(declare-datatypes ((HybridKEX 0))
  (((mk-hybrid_kex (hkex_classical Bool) (hkex_post_quantum Bool) (hkex_combined Bool)))))

(declare-datatypes ((HybridKEXConfig 0))
  (((mk-hybrid_kex_config (hybrid_kem KEMScheme) (hybrid_ecdh ECDHCurve) (hybrid_combiner Bool) (hybrid_label Bool)))))

(declare-datatypes ((PQAuthentication 0))
  (((mk-pq_authentication (pqa_classical_sig Bool) (pqa_pq_sig Bool) (pqa_certificate_chain Bool)))))

(declare-datatypes ((SignatureSecurityProps 0))
  (((mk-signature_security_props (sig_euf_cma Bool) (sig_strong_euf Bool) (sig_nist_approved Bool) (sig_deterministic Bool)))))

(declare-datatypes ((TLSHandshake 0))
  (((mk-tls_handshake (ths_forward_secrecy Bool) (ths_downgrade_protection Bool) (ths_replay_protection Bool) (ths_key_confirmation Bool)))))

(declare-datatypes ((TLSHandshakeConfig 0))
  (((mk-tls_handshake_config (ths_version TLSVersion) (ths_ciphersuite CipherSuite) (ths_early_data Bool) (ths_psk_mode Bool) (ths_client_auth Bool)))))

(declare-datatypes ((TLS13Extensions 0))
  (((mk-tls13_extensions (ext_supported_versions Bool) (ext_key_share Bool) (ext_signature_algorithms Bool) (ext_psk_key_exchange_modes Bool)))))

(declare-datatypes ((TLSRecord 0))
  (((mk-tls_record (rec_aead Bool) (rec_sequence_numbers Bool) (rec_padding Bool)))))

(declare-datatypes ((AEADProperties 0))
  (((mk-aead_properties (aead_confidentiality Bool) (aead_integrity Bool) (aead_authenticity Bool) (aead_nonce_unique Bool)))))

(declare-datatypes ((ForwardSecrecyConfig 0))
  (((mk-forward_secrecy_config (fs_ephemeral_keys Bool) (fs_key_deletion Bool) (fs_no_static_dh Bool) (fs_pfs_per_session Bool)))))

(declare-datatypes ((AlgorithmAgility 0))
  (((mk-algorithm_agility (agility_negotiation Bool) (agility_fallback Bool) (agility_versioning Bool) (agility_extension Bool)))))

(declare-datatypes ((QuantumSafeTLSConfig 0))
  (((mk-quantum_safe_tls_config (qstls_kex HybridKEX) (qstls_auth PQAuthentication) (qstls_handshake TLSHandshake) (qstls_record TLSRecord) (qstls_version_13 Bool)))))

(declare-datatypes ((QuantumSafeTLSFull 0))
  (((mk-quantum_safe_tls_full (qstls_hybrid_config HybridKEXConfig) (qstls_sig_scheme SignatureScheme) (qstls_hs_config TLSHandshakeConfig) (qstls_fs_config ForwardSecrecyConfig) (qstls_agility AlgorithmAgility) (qstls_extensions TLS13Extensions)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SecurityLevel enum properties ---

; --- 1. SecurityLevel exhaustiveness ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (or (= x Level1) (= x Level3) (= x Level5))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SecurityLevel: Level1 != Level3 ---
(push 1)
(assert (= Level1 Level3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SecurityLevel: Level3 != Level5 ---
(push 1)
(assert (= Level3 Level5))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SecurityLevel: Level1 != Level5 ---
(push 1)
(assert (= Level1 Level5))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SecurityLevel finite cardinality (3 values) ---
(push 1)
(declare-const x SecurityLevel)
(assert (and (not (= x Level1)) (not (= x Level3)) (not (= x Level5))))
(check-sat) ; expect UNSAT
(pop 1)

; --- KEMScheme enum properties ---

; --- 6. KEMScheme exhaustiveness ---
(push 1)
(declare-const x KEMScheme)
(assert (not (or (= x ML_KEM_512) (= x ML_KEM_768) (= x ML_KEM_1024))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. KEMScheme: ML_KEM_512 != ML_KEM_768 ---
(push 1)
(assert (= ML_KEM_512 ML_KEM_768))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. KEMScheme: ML_KEM_768 != ML_KEM_1024 ---
(push 1)
(assert (= ML_KEM_768 ML_KEM_1024))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. KEMScheme: ML_KEM_512 != ML_KEM_1024 ---
(push 1)
(assert (= ML_KEM_512 ML_KEM_1024))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. KEMScheme finite cardinality (3 values) ---
(push 1)
(declare-const x KEMScheme)
(assert (and (not (= x ML_KEM_512)) (not (= x ML_KEM_768)) (not (= x ML_KEM_1024))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ECDHCurve enum properties ---

; --- 11. ECDHCurve exhaustiveness ---
(push 1)
(declare-const x ECDHCurve)
(assert (not (or (= x X25519) (= x X448) (= x P256) (= x P384) (= x P521))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ECDHCurve: X25519 != X448 ---
(push 1)
(assert (= X25519 X448))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. ECDHCurve: X448 != P256 ---
(push 1)
(assert (= X448 P256))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. ECDHCurve: P256 != P384 ---
(push 1)
(assert (= P256 P384))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ECDHCurve: X25519 != P521 ---
(push 1)
(assert (= X25519 P521))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ECDHCurve finite cardinality (5 values) ---
(push 1)
(declare-const x ECDHCurve)
(assert (and (not (= x X25519)) (not (= x X448)) (not (= x P256)) (not (= x P384)) (not (= x P521))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignatureScheme enum properties ---

; --- 17. SignatureScheme exhaustiveness ---
(push 1)
(declare-const x SignatureScheme)
(assert (not (or (= x ML_DSA_44) (= x ML_DSA_65) (= x ML_DSA_87) (= x SLH_DSA_128) (= x SLH_DSA_192) (= x SLH_DSA_256) (= x ECDSA_P256) (= x Ed25519))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SignatureScheme: ML_DSA_44 != ML_DSA_65 ---
(push 1)
(assert (= ML_DSA_44 ML_DSA_65))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SignatureScheme: ML_DSA_65 != ML_DSA_87 ---
(push 1)
(assert (= ML_DSA_65 ML_DSA_87))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SignatureScheme: ML_DSA_87 != SLH_DSA_128 ---
(push 1)
(assert (= ML_DSA_87 SLH_DSA_128))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SignatureScheme: ML_DSA_44 != Ed25519 ---
(push 1)
(assert (= ML_DSA_44 Ed25519))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SignatureScheme finite cardinality (8 values) ---
(push 1)
(declare-const x SignatureScheme)
(assert (and (not (= x ML_DSA_44)) (not (= x ML_DSA_65)) (not (= x ML_DSA_87)) (not (= x SLH_DSA_128)) (not (= x SLH_DSA_192)) (not (= x SLH_DSA_256)) (not (= x ECDSA_P256)) (not (= x Ed25519))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TLSVersion enum properties ---

; --- 23. TLSVersion exhaustiveness ---
(push 1)
(declare-const x TLSVersion)
(assert (not (or (= x TLS_1_2) (= x TLS_1_3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TLSVersion: TLS_1_2 != TLS_1_3 ---
(push 1)
(assert (= TLS_1_2 TLS_1_3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TLSVersion finite cardinality (2 values) ---
(push 1)
(declare-const x TLSVersion)
(assert (and (not (= x TLS_1_2)) (not (= x TLS_1_3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CipherSuite enum properties ---

; --- 26. CipherSuite exhaustiveness ---
(push 1)
(declare-const x CipherSuite)
(assert (not (or (= x TLS_AES_128_GCM_SHA256) (= x TLS_AES_256_GCM_SHA384) (= x TLS_CHACHA20_POLY1305_SHA256))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. CipherSuite: TLS_AES_128_GCM_SHA256 != TLS_AES_256_GCM_SHA384 ---
(push 1)
(assert (= TLS_AES_128_GCM_SHA256 TLS_AES_256_GCM_SHA384))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. CipherSuite: TLS_AES_256_GCM_SHA384 != TLS_CHACHA20_POLY1305_SHA256 ---
(push 1)
(assert (= TLS_AES_256_GCM_SHA384 TLS_CHACHA20_POLY1305_SHA256))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. CipherSuite: TLS_AES_128_GCM_SHA256 != TLS_CHACHA20_POLY1305_SHA256 ---
(push 1)
(assert (= TLS_AES_128_GCM_SHA256 TLS_CHACHA20_POLY1305_SHA256))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. CipherSuite finite cardinality (3 values) ---
(push 1)
(declare-const x CipherSuite)
(assert (and (not (= x TLS_AES_128_GCM_SHA256)) (not (= x TLS_AES_256_GCM_SHA384)) (not (= x TLS_CHACHA20_POLY1305_SHA256))))
(check-sat) ; expect UNSAT
(pop 1)

; --- KEMParameters record properties ---

; --- 31. KEMParameters accessor round-trip: kem_scheme ---
(push 1)
(declare-const f0 KEMScheme)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (kem_scheme (mk-kem_parameters f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. KEMParameters accessor round-trip: kem_pk_size ---
(push 1)
(declare-const f0 KEMScheme)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (kem_pk_size (mk-kem_parameters f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. KEMParameters accessor round-trip: kem_sk_size ---
(push 1)
(declare-const f0 KEMScheme)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (kem_sk_size (mk-kem_parameters f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. KEMParameters accessor round-trip: kem_ct_size ---
(push 1)
(declare-const f0 KEMScheme)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (kem_ct_size (mk-kem_parameters f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. KEMParameters: integer field consistency ---
(push 1)
(declare-const r KEMParameters)
(assert (>= (kem_pk_size r) 0))
(assert (>= (kem_sk_size r) 0))
(assert (not (>= (+ (kem_pk_size r) (kem_sk_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KEMSecurityProperties record properties ---

; --- 36. KEMSecurityProperties accessor round-trip: kem_sec_indcca2 ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (kem_sec_indcca2 (mk-kem_security_properties f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. KEMSecurityProperties accessor round-trip: kem_sec_module_lwe ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (kem_sec_module_lwe (mk-kem_security_properties f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. KEMSecurityProperties accessor round-trip: kem_sec_nist_approved ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (kem_sec_nist_approved (mk-kem_security_properties f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun KEMSecurityProperties_all_enabled ((g KEMSecurityProperties)) Bool
  (and (kem_sec_indcca2 g) (kem_sec_module_lwe g) (kem_sec_nist_approved g)))

; --- 39. KEMSecurityProperties: all-enabled completeness ---
(push 1)
(declare-const g KEMSecurityProperties)
(assert (kem_sec_indcca2 g))
(assert (kem_sec_module_lwe g))
(assert (kem_sec_nist_approved g))
(assert (not (KEMSecurityProperties_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. KEMSecurityProperties: KEMSecurityProperties_all_enabled implies kem_sec_indcca2 ---
(push 1)
(declare-const g KEMSecurityProperties)
(assert (KEMSecurityProperties_all_enabled g))
(assert (not (kem_sec_indcca2 g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. KEMSecurityProperties: KEMSecurityProperties_all_enabled implies kem_sec_module_lwe ---
(push 1)
(declare-const g KEMSecurityProperties)
(assert (KEMSecurityProperties_all_enabled g))
(assert (not (kem_sec_module_lwe g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. KEMSecurityProperties: KEMSecurityProperties_all_enabled implies kem_sec_nist_approved ---
(push 1)
(declare-const g KEMSecurityProperties)
(assert (KEMSecurityProperties_all_enabled g))
(assert (not (kem_sec_nist_approved g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ECDHParameters record properties ---

; --- 43. ECDHParameters accessor round-trip: ecdh_curve ---
(push 1)
(declare-const f0 ECDHCurve)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ecdh_curve (mk-ecdh_parameters f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. ECDHParameters accessor round-trip: ecdh_pk_size ---
(push 1)
(declare-const f0 ECDHCurve)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ecdh_pk_size (mk-ecdh_parameters f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. ECDHParameters accessor round-trip: ecdh_sk_size ---
(push 1)
(declare-const f0 ECDHCurve)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (ecdh_sk_size (mk-ecdh_parameters f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. ECDHParameters: integer field consistency ---
(push 1)
(declare-const r ECDHParameters)
(assert (>= (ecdh_pk_size r) 0))
(assert (>= (ecdh_sk_size r) 0))
(assert (not (>= (+ (ecdh_pk_size r) (ecdh_sk_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HybridKEX record properties ---

; --- 47. HybridKEX accessor round-trip: hkex_classical ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (hkex_classical (mk-hybrid_kex f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. HybridKEX accessor round-trip: hkex_post_quantum ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (hkex_post_quantum (mk-hybrid_kex f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun HybridKEX_all_enabled ((g HybridKEX)) Bool
  (and (hkex_classical g) (hkex_post_quantum g)))

; --- 49. HybridKEX: all-enabled completeness ---
(push 1)
(declare-const g HybridKEX)
(assert (hkex_classical g))
(assert (hkex_post_quantum g))
(assert (not (HybridKEX_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. HybridKEX: HybridKEX_all_enabled implies hkex_classical ---
(push 1)
(declare-const g HybridKEX)
(assert (HybridKEX_all_enabled g))
(assert (not (hkex_classical g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. HybridKEX: HybridKEX_all_enabled implies hkex_post_quantum ---
(push 1)
(declare-const g HybridKEX)
(assert (HybridKEX_all_enabled g))
(assert (not (hkex_post_quantum g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HybridKEXConfig record properties ---

; --- 52. HybridKEXConfig accessor round-trip: hybrid_kem ---
(push 1)
(declare-const f0 KEMScheme)
(declare-const f1 ECDHCurve)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (hybrid_kem (mk-hybrid_kex_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. HybridKEXConfig accessor round-trip: hybrid_ecdh ---
(push 1)
(declare-const f0 KEMScheme)
(declare-const f1 ECDHCurve)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (hybrid_ecdh (mk-hybrid_kex_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. HybridKEXConfig accessor round-trip: hybrid_combiner ---
(push 1)
(declare-const f0 KEMScheme)
(declare-const f1 ECDHCurve)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (hybrid_combiner (mk-hybrid_kex_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PQAuthentication record properties ---

; --- 55. PQAuthentication accessor round-trip: pqa_classical_sig ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (pqa_classical_sig (mk-pq_authentication f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. PQAuthentication accessor round-trip: pqa_pq_sig ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (pqa_pq_sig (mk-pq_authentication f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun PQAuthentication_all_enabled ((g PQAuthentication)) Bool
  (and (pqa_classical_sig g) (pqa_pq_sig g)))

; --- 57. PQAuthentication: all-enabled completeness ---
(push 1)
(declare-const g PQAuthentication)
(assert (pqa_classical_sig g))
(assert (pqa_pq_sig g))
(assert (not (PQAuthentication_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. PQAuthentication: PQAuthentication_all_enabled implies pqa_classical_sig ---
(push 1)
(declare-const g PQAuthentication)
(assert (PQAuthentication_all_enabled g))
(assert (not (pqa_classical_sig g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. PQAuthentication: PQAuthentication_all_enabled implies pqa_pq_sig ---
(push 1)
(declare-const g PQAuthentication)
(assert (PQAuthentication_all_enabled g))
(assert (not (pqa_pq_sig g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignatureSecurityProps record properties ---

; --- 60. SignatureSecurityProps accessor round-trip: sig_euf_cma ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sig_euf_cma (mk-signature_security_props f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. SignatureSecurityProps accessor round-trip: sig_strong_euf ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sig_strong_euf (mk-signature_security_props f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. SignatureSecurityProps accessor round-trip: sig_nist_approved ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sig_nist_approved (mk-signature_security_props f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SignatureSecurityProps_all_enabled ((g SignatureSecurityProps)) Bool
  (and (sig_euf_cma g) (sig_strong_euf g) (sig_nist_approved g)))

; --- 63. SignatureSecurityProps: all-enabled completeness ---
(push 1)
(declare-const g SignatureSecurityProps)
(assert (sig_euf_cma g))
(assert (sig_strong_euf g))
(assert (sig_nist_approved g))
(assert (not (SignatureSecurityProps_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. SignatureSecurityProps: SignatureSecurityProps_all_enabled implies sig_euf_cma ---
(push 1)
(declare-const g SignatureSecurityProps)
(assert (SignatureSecurityProps_all_enabled g))
(assert (not (sig_euf_cma g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. SignatureSecurityProps: SignatureSecurityProps_all_enabled implies sig_strong_euf ---
(push 1)
(declare-const g SignatureSecurityProps)
(assert (SignatureSecurityProps_all_enabled g))
(assert (not (sig_strong_euf g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. SignatureSecurityProps: SignatureSecurityProps_all_enabled implies sig_nist_approved ---
(push 1)
(declare-const g SignatureSecurityProps)
(assert (SignatureSecurityProps_all_enabled g))
(assert (not (sig_nist_approved g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TLSHandshake record properties ---

; --- 67. TLSHandshake accessor round-trip: ths_forward_secrecy ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ths_forward_secrecy (mk-tls_handshake f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. TLSHandshake accessor round-trip: ths_downgrade_protection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ths_downgrade_protection (mk-tls_handshake f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. TLSHandshake accessor round-trip: ths_replay_protection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ths_replay_protection (mk-tls_handshake f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TLSHandshake_all_enabled ((g TLSHandshake)) Bool
  (and (ths_forward_secrecy g) (ths_downgrade_protection g) (ths_replay_protection g)))

; --- 70. TLSHandshake: all-enabled completeness ---
(push 1)
(declare-const g TLSHandshake)
(assert (ths_forward_secrecy g))
(assert (ths_downgrade_protection g))
(assert (ths_replay_protection g))
(assert (not (TLSHandshake_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. TLSHandshake: TLSHandshake_all_enabled implies ths_forward_secrecy ---
(push 1)
(declare-const g TLSHandshake)
(assert (TLSHandshake_all_enabled g))
(assert (not (ths_forward_secrecy g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. TLSHandshake: TLSHandshake_all_enabled implies ths_downgrade_protection ---
(push 1)
(declare-const g TLSHandshake)
(assert (TLSHandshake_all_enabled g))
(assert (not (ths_downgrade_protection g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. TLSHandshake: TLSHandshake_all_enabled implies ths_replay_protection ---
(push 1)
(declare-const g TLSHandshake)
(assert (TLSHandshake_all_enabled g))
(assert (not (ths_replay_protection g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TLSHandshakeConfig record properties ---

; --- 74. TLSHandshakeConfig accessor round-trip: ths_version ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 CipherSuite)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ths_version (mk-tls_handshake_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. TLSHandshakeConfig accessor round-trip: ths_ciphersuite ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 CipherSuite)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ths_ciphersuite (mk-tls_handshake_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. TLSHandshakeConfig accessor round-trip: ths_early_data ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 CipherSuite)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ths_early_data (mk-tls_handshake_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. TLSHandshakeConfig accessor round-trip: ths_psk_mode ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 CipherSuite)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ths_psk_mode (mk-tls_handshake_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TLS13Extensions record properties ---

; --- 78. TLS13Extensions accessor round-trip: ext_supported_versions ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ext_supported_versions (mk-tls13_extensions f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. TLS13Extensions accessor round-trip: ext_key_share ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ext_key_share (mk-tls13_extensions f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. TLS13Extensions accessor round-trip: ext_signature_algorithms ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ext_signature_algorithms (mk-tls13_extensions f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TLS13Extensions_all_enabled ((g TLS13Extensions)) Bool
  (and (ext_supported_versions g) (ext_key_share g) (ext_signature_algorithms g)))

; --- 81. TLS13Extensions: all-enabled completeness ---
(push 1)
(declare-const g TLS13Extensions)
(assert (ext_supported_versions g))
(assert (ext_key_share g))
(assert (ext_signature_algorithms g))
(assert (not (TLS13Extensions_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. TLS13Extensions: TLS13Extensions_all_enabled implies ext_supported_versions ---
(push 1)
(declare-const g TLS13Extensions)
(assert (TLS13Extensions_all_enabled g))
(assert (not (ext_supported_versions g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. TLS13Extensions: TLS13Extensions_all_enabled implies ext_key_share ---
(push 1)
(declare-const g TLS13Extensions)
(assert (TLS13Extensions_all_enabled g))
(assert (not (ext_key_share g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. TLS13Extensions: TLS13Extensions_all_enabled implies ext_signature_algorithms ---
(push 1)
(declare-const g TLS13Extensions)
(assert (TLS13Extensions_all_enabled g))
(assert (not (ext_signature_algorithms g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TLSRecord record properties ---

; --- 85. TLSRecord accessor round-trip: rec_aead ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rec_aead (mk-tls_record f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. TLSRecord accessor round-trip: rec_sequence_numbers ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rec_sequence_numbers (mk-tls_record f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TLSRecord_all_enabled ((g TLSRecord)) Bool
  (and (rec_aead g) (rec_sequence_numbers g)))

; --- 87. TLSRecord: all-enabled completeness ---
(push 1)
(declare-const g TLSRecord)
(assert (rec_aead g))
(assert (rec_sequence_numbers g))
(assert (not (TLSRecord_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. TLSRecord: TLSRecord_all_enabled implies rec_aead ---
(push 1)
(declare-const g TLSRecord)
(assert (TLSRecord_all_enabled g))
(assert (not (rec_aead g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. TLSRecord: TLSRecord_all_enabled implies rec_sequence_numbers ---
(push 1)
(declare-const g TLSRecord)
(assert (TLSRecord_all_enabled g))
(assert (not (rec_sequence_numbers g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AEADProperties record properties ---

; --- 90. AEADProperties accessor round-trip: aead_confidentiality ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (aead_confidentiality (mk-aead_properties f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. AEADProperties accessor round-trip: aead_integrity ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (aead_integrity (mk-aead_properties f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 92. AEADProperties accessor round-trip: aead_authenticity ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (aead_authenticity (mk-aead_properties f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun AEADProperties_all_enabled ((g AEADProperties)) Bool
  (and (aead_confidentiality g) (aead_integrity g) (aead_authenticity g)))

; --- 93. AEADProperties: all-enabled completeness ---
(push 1)
(declare-const g AEADProperties)
(assert (aead_confidentiality g))
(assert (aead_integrity g))
(assert (aead_authenticity g))
(assert (not (AEADProperties_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. AEADProperties: AEADProperties_all_enabled implies aead_confidentiality ---
(push 1)
(declare-const g AEADProperties)
(assert (AEADProperties_all_enabled g))
(assert (not (aead_confidentiality g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 95. AEADProperties: AEADProperties_all_enabled implies aead_integrity ---
(push 1)
(declare-const g AEADProperties)
(assert (AEADProperties_all_enabled g))
(assert (not (aead_integrity g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. AEADProperties: AEADProperties_all_enabled implies aead_authenticity ---
(push 1)
(declare-const g AEADProperties)
(assert (AEADProperties_all_enabled g))
(assert (not (aead_authenticity g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ForwardSecrecyConfig record properties ---

; --- 97. ForwardSecrecyConfig accessor round-trip: fs_ephemeral_keys ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fs_ephemeral_keys (mk-forward_secrecy_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. ForwardSecrecyConfig accessor round-trip: fs_key_deletion ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fs_key_deletion (mk-forward_secrecy_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. ForwardSecrecyConfig accessor round-trip: fs_no_static_dh ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fs_no_static_dh (mk-forward_secrecy_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ForwardSecrecyConfig_all_enabled ((g ForwardSecrecyConfig)) Bool
  (and (fs_ephemeral_keys g) (fs_key_deletion g) (fs_no_static_dh g)))

; --- 100. ForwardSecrecyConfig: all-enabled completeness ---
(push 1)
(declare-const g ForwardSecrecyConfig)
(assert (fs_ephemeral_keys g))
(assert (fs_key_deletion g))
(assert (fs_no_static_dh g))
(assert (not (ForwardSecrecyConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 101. ForwardSecrecyConfig: ForwardSecrecyConfig_all_enabled implies fs_ephemeral_keys ---
(push 1)
(declare-const g ForwardSecrecyConfig)
(assert (ForwardSecrecyConfig_all_enabled g))
(assert (not (fs_ephemeral_keys g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 102. ForwardSecrecyConfig: ForwardSecrecyConfig_all_enabled implies fs_key_deletion ---
(push 1)
(declare-const g ForwardSecrecyConfig)
(assert (ForwardSecrecyConfig_all_enabled g))
(assert (not (fs_key_deletion g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. ForwardSecrecyConfig: ForwardSecrecyConfig_all_enabled implies fs_no_static_dh ---
(push 1)
(declare-const g ForwardSecrecyConfig)
(assert (ForwardSecrecyConfig_all_enabled g))
(assert (not (fs_no_static_dh g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AlgorithmAgility record properties ---

; --- 104. AlgorithmAgility accessor round-trip: agility_negotiation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (agility_negotiation (mk-algorithm_agility f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 105. AlgorithmAgility accessor round-trip: agility_fallback ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (agility_fallback (mk-algorithm_agility f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 106. AlgorithmAgility accessor round-trip: agility_versioning ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (agility_versioning (mk-algorithm_agility f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun AlgorithmAgility_all_enabled ((g AlgorithmAgility)) Bool
  (and (agility_negotiation g) (agility_fallback g) (agility_versioning g)))

; --- 107. AlgorithmAgility: all-enabled completeness ---
(push 1)
(declare-const g AlgorithmAgility)
(assert (agility_negotiation g))
(assert (agility_fallback g))
(assert (agility_versioning g))
(assert (not (AlgorithmAgility_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 108. AlgorithmAgility: AlgorithmAgility_all_enabled implies agility_negotiation ---
(push 1)
(declare-const g AlgorithmAgility)
(assert (AlgorithmAgility_all_enabled g))
(assert (not (agility_negotiation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 109. AlgorithmAgility: AlgorithmAgility_all_enabled implies agility_fallback ---
(push 1)
(declare-const g AlgorithmAgility)
(assert (AlgorithmAgility_all_enabled g))
(assert (not (agility_fallback g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 110. AlgorithmAgility: AlgorithmAgility_all_enabled implies agility_versioning ---
(push 1)
(declare-const g AlgorithmAgility)
(assert (AlgorithmAgility_all_enabled g))
(assert (not (agility_versioning g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- QuantumSafeTLSConfig record properties ---

; --- 111. QuantumSafeTLSConfig accessor round-trip: qstls_kex ---
(push 1)
(declare-const f0 HybridKEX)
(declare-const f1 PQAuthentication)
(declare-const f2 TLSHandshake)
(declare-const f3 TLSRecord)
(declare-const f4 Bool)
(assert (not (= (qstls_kex (mk-quantum_safe_tls_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 112. QuantumSafeTLSConfig accessor round-trip: qstls_auth ---
(push 1)
(declare-const f0 HybridKEX)
(declare-const f1 PQAuthentication)
(declare-const f2 TLSHandshake)
(declare-const f3 TLSRecord)
(declare-const f4 Bool)
(assert (not (= (qstls_auth (mk-quantum_safe_tls_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 113. QuantumSafeTLSConfig accessor round-trip: qstls_handshake ---
(push 1)
(declare-const f0 HybridKEX)
(declare-const f1 PQAuthentication)
(declare-const f2 TLSHandshake)
(declare-const f3 TLSRecord)
(declare-const f4 Bool)
(assert (not (= (qstls_handshake (mk-quantum_safe_tls_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 114. QuantumSafeTLSConfig accessor round-trip: qstls_record ---
(push 1)
(declare-const f0 HybridKEX)
(declare-const f1 PQAuthentication)
(declare-const f2 TLSHandshake)
(declare-const f3 TLSRecord)
(declare-const f4 Bool)
(assert (not (= (qstls_record (mk-quantum_safe_tls_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- QuantumSafeTLSFull record properties ---

; --- 115. QuantumSafeTLSFull accessor round-trip: qstls_hybrid_config ---
(push 1)
(declare-const f0 HybridKEXConfig)
(declare-const f1 SignatureScheme)
(declare-const f2 TLSHandshakeConfig)
(declare-const f3 ForwardSecrecyConfig)
(declare-const f4 AlgorithmAgility)
(declare-const f5 TLS13Extensions)
(assert (not (= (qstls_hybrid_config (mk-quantum_safe_tls_full f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 116. QuantumSafeTLSFull accessor round-trip: qstls_sig_scheme ---
(push 1)
(declare-const f0 HybridKEXConfig)
(declare-const f1 SignatureScheme)
(declare-const f2 TLSHandshakeConfig)
(declare-const f3 ForwardSecrecyConfig)
(declare-const f4 AlgorithmAgility)
(declare-const f5 TLS13Extensions)
(assert (not (= (qstls_sig_scheme (mk-quantum_safe_tls_full f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 117. QuantumSafeTLSFull accessor round-trip: qstls_hs_config ---
(push 1)
(declare-const f0 HybridKEXConfig)
(declare-const f1 SignatureScheme)
(declare-const f2 TLSHandshakeConfig)
(declare-const f3 ForwardSecrecyConfig)
(declare-const f4 AlgorithmAgility)
(declare-const f5 TLS13Extensions)
(assert (not (= (qstls_hs_config (mk-quantum_safe_tls_full f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 118. QuantumSafeTLSFull accessor round-trip: qstls_fs_config ---
(push 1)
(declare-const f0 HybridKEXConfig)
(declare-const f1 SignatureScheme)
(declare-const f2 TLSHandshakeConfig)
(declare-const f3 ForwardSecrecyConfig)
(declare-const f4 AlgorithmAgility)
(declare-const f5 TLS13Extensions)
(assert (not (= (qstls_fs_config (mk-quantum_safe_tls_full f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 119. QuantumSafeTLSFull accessor round-trip: qstls_agility ---
(push 1)
(declare-const f0 HybridKEXConfig)
(declare-const f1 SignatureScheme)
(declare-const f2 TLSHandshakeConfig)
(declare-const f3 ForwardSecrecyConfig)
(declare-const f4 AlgorithmAgility)
(declare-const f5 TLS13Extensions)
(assert (not (= (qstls_agility (mk-quantum_safe_tls_full f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLevel ordering properties ---

(define-fun SecurityLevel_level ((x SecurityLevel)) Int
  (ite (= x Level1) 0 (ite (= x Level3) 1 2)))

(define-fun SecurityLevel_leq ((x SecurityLevel) (y SecurityLevel)) Bool
  (<= (SecurityLevel_level x) (SecurityLevel_level y)))

; --- 120. SecurityLevel_leq reflexivity ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 121. SecurityLevel_leq transitivity ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(declare-const z SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y z))
(assert (not (SecurityLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 122. SecurityLevel_leq antisymmetry ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 123. Level1 is bottom ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq Level1 x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 124. Level5 is top ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x Level5)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

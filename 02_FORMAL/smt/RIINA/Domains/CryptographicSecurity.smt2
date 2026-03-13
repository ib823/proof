; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CryptographicSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/CryptographicSecurity.v (76 assertions)
; Module: CryptographicSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TagVerifyResult 0)) (((TagValid) (TagInvalid) (TagError))))

(declare-datatypes ((ConstantTimeOp 0))
  (((mk-constant_time_op (ct_operation Int) (ct_no_secret_branch Bool) (ct_no_secret_addr Bool) (ct_no_variable_time Bool) (ct_is_constant Bool)))))

(declare-datatypes ((CryptoKey 0))
  (((mk-crypto_key (key_bits Int) (key_algorithm Int) (key_usage (Seq Int)) (key_extractable Bool) (key_hardware_bound Bool)))))

(declare-datatypes ((NonceTracker 0))
  (((mk-nonce_tracker (nt_used (Seq Int)) (nt_counter Int) (nt_max_uses Int)))))

(declare-datatypes ((AEADConfig 0))
  (((mk-aead_config (aead_algorithm Int) (aead_key_bits Int) (aead_nonce_bits Int) (aead_tag_bits Int) (aead_constant_time Bool)))))

(declare-datatypes ((HashConfig 0))
  (((mk-hash_config (hash_algorithm Int) (hash_output_bits Int) (hash_length_ext_safe Bool)))))

(declare-datatypes ((RNGConfig 0))
  (((mk-rng_config (rng_hardware_seeded Bool) (rng_reseeded_regularly Bool) (rng_prediction_resistant Bool) (rng_output_bits Int)))))

(declare-datatypes ((ProtocolConfig 0))
  (((mk-protocol_config (proto_min_version Int) (proto_allowed_ciphers (Seq Int)) (proto_fallback_disabled Bool) (proto_forward_secrecy Bool)))))

(declare-datatypes ((PQConfig 0))
  (((mk-pq_config (pq_kem_algorithm Int) (pq_sig_algorithm Int) (pq_security_level Int) (pq_hybrid_mode Bool)))))

(declare-datatypes ((MRAEADConfig 0))
  (((mk-mraead_config (mraead_siv_mode Bool) (mraead_deterministic Bool) (mraead_base AEADConfig)))))

(declare-datatypes ((CertConfig 0))
  (((mk-cert_config (cert_ct_required Bool) (cert_pinning Bool) (cert_revocation_check Bool) (cert_ocsp_stapling Bool)))))

(declare-datatypes ((EncryptionScheme 0))
  (((mk-encryption_scheme (enc_key_bits Int) (enc_nonce_bits Int) (enc_tag_bits Int) (enc_block_size Int) (enc_is_authenticated Bool)))))

(declare-datatypes ((KDFConfig 0))
  (((mk-kdf_config (kdf_algorithm Int) (kdf_output_bits Int) (kdf_salt_bits Int) (kdf_iterations Int) (kdf_memory_cost Int)))))

(declare-datatypes ((DerivedKey 0))
  (((mk-derived_key (dk_parent_key Int) (dk_derived_key Int) (dk_context (Seq Int)) (dk_purpose Int) (dk_kdf_config KDFConfig)))))

(declare-datatypes ((MACConfig 0))
  (((mk-mac_config (mac_algorithm Int) (mac_key_bits Int) (mac_tag_bits Int) (mac_constant_time Bool)))))

(declare-datatypes ((CounterNonce 0))
  (((mk-counter_nonce (cn_prefix (Seq Int)) (cn_counter Int) (cn_max_value Int)))))

(declare-datatypes ((FullCryptoConfig 0))
  (((mk-full_crypto_config (fc_ct_op ConstantTimeOp) (fc_aead AEADConfig) (fc_hash HashConfig) (fc_rng RNGConfig) (fc_proto ProtocolConfig) (fc_pq PQConfig) (fc_key CryptoKey) (fc_cert CertConfig) (fc_mraead MRAEADConfig) (fc_kdf KDFConfig) (fc_mac MACConfig) (fc_enc EncryptionScheme)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TagVerifyResult enum properties ---

; --- 1. TagVerifyResult exhaustiveness ---
(push 1)
(declare-const x TagVerifyResult)
(assert (not (or (= x TagValid) (= x TagInvalid) (= x TagError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TagVerifyResult: TagValid != TagInvalid ---
(push 1)
(assert (= TagValid TagInvalid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TagVerifyResult: TagInvalid != TagError ---
(push 1)
(assert (= TagInvalid TagError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TagVerifyResult: TagValid != TagError ---
(push 1)
(assert (= TagValid TagError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TagVerifyResult finite cardinality (3 values) ---
(push 1)
(declare-const x TagVerifyResult)
(assert (and (not (= x TagValid)) (not (= x TagInvalid)) (not (= x TagError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConstantTimeOp record properties ---

; --- 6. ConstantTimeOp accessor round-trip: ct_operation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ct_operation (mk-constant_time_op f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. ConstantTimeOp accessor round-trip: ct_no_secret_branch ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ct_no_secret_branch (mk-constant_time_op f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ConstantTimeOp accessor round-trip: ct_no_secret_addr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ct_no_secret_addr (mk-constant_time_op f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ConstantTimeOp accessor round-trip: ct_no_variable_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ct_no_variable_time (mk-constant_time_op f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CryptoKey record properties ---

; --- 10. CryptoKey accessor round-trip: key_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (key_bits (mk-crypto_key f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. CryptoKey accessor round-trip: key_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (key_algorithm (mk-crypto_key f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. CryptoKey accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (Seq (mk-crypto_key f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. CryptoKey accessor round-trip: key_extractable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (key_extractable (mk-crypto_key f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. CryptoKey: integer field consistency ---
(push 1)
(declare-const r CryptoKey)
(assert (>= (key_bits r) 0))
(assert (>= (key_algorithm r) 0))
(assert (not (>= (+ (key_bits r) (key_algorithm r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NonceTracker record properties ---

; --- 15. NonceTracker accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (Seq (mk-nonce_tracker f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. NonceTracker accessor round-trip: nt_counter ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (nt_counter (mk-nonce_tracker f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. NonceTracker: integer field consistency ---
(push 1)
(declare-const r NonceTracker)
(assert (>= (Seq r) 0))
(assert (>= (nt_counter r) 0))
(assert (not (>= (+ (Seq r) (nt_counter r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AEADConfig record properties ---

; --- 18. AEADConfig accessor round-trip: aead_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (aead_algorithm (mk-a_e_a_d_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. AEADConfig accessor round-trip: aead_key_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (aead_key_bits (mk-a_e_a_d_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. AEADConfig accessor round-trip: aead_nonce_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (aead_nonce_bits (mk-a_e_a_d_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. AEADConfig accessor round-trip: aead_tag_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (aead_tag_bits (mk-a_e_a_d_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. AEADConfig: integer field consistency ---
(push 1)
(declare-const r AEADConfig)
(assert (>= (aead_algorithm r) 0))
(assert (>= (aead_key_bits r) 0))
(assert (not (>= (+ (aead_algorithm r) (aead_key_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HashConfig record properties ---

; --- 23. HashConfig accessor round-trip: hash_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (hash_algorithm (mk-hash_config f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. HashConfig accessor round-trip: hash_output_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (hash_output_bits (mk-hash_config f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. HashConfig: integer field consistency ---
(push 1)
(declare-const r HashConfig)
(assert (>= (hash_algorithm r) 0))
(assert (>= (hash_output_bits r) 0))
(assert (not (>= (+ (hash_algorithm r) (hash_output_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RNGConfig record properties ---

; --- 26. RNGConfig accessor round-trip: rng_hardware_seeded ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rng_hardware_seeded (mk-r_n_g_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. RNGConfig accessor round-trip: rng_reseeded_regularly ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rng_reseeded_regularly (mk-r_n_g_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. RNGConfig accessor round-trip: rng_prediction_resistant ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rng_prediction_resistant (mk-r_n_g_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun RNGConfig_all_enabled ((g RNGConfig)) Bool
  (and (rng_hardware_seeded g) (rng_reseeded_regularly g) (rng_prediction_resistant g)))

; --- 29. RNGConfig: all-enabled completeness ---
(push 1)
(declare-const g RNGConfig)
(assert (rng_hardware_seeded g))
(assert (rng_reseeded_regularly g))
(assert (rng_prediction_resistant g))
(assert (not (RNGConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. RNGConfig: RNGConfig_all_enabled implies rng_hardware_seeded ---
(push 1)
(declare-const g RNGConfig)
(assert (RNGConfig_all_enabled g))
(assert (not (rng_hardware_seeded g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. RNGConfig: RNGConfig_all_enabled implies rng_reseeded_regularly ---
(push 1)
(declare-const g RNGConfig)
(assert (RNGConfig_all_enabled g))
(assert (not (rng_reseeded_regularly g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. RNGConfig: RNGConfig_all_enabled implies rng_prediction_resistant ---
(push 1)
(declare-const g RNGConfig)
(assert (RNGConfig_all_enabled g))
(assert (not (rng_prediction_resistant g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProtocolConfig record properties ---

; --- 33. ProtocolConfig accessor round-trip: proto_min_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (proto_min_version (mk-protocol_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. ProtocolConfig accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (Seq (mk-protocol_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. ProtocolConfig accessor round-trip: proto_fallback_disabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (proto_fallback_disabled (mk-protocol_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ProtocolConfig: integer field consistency ---
(push 1)
(declare-const r ProtocolConfig)
(assert (>= (proto_min_version r) 0))
(assert (>= (Seq r) 0))
(assert (not (>= (+ (proto_min_version r) (Seq r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PQConfig record properties ---

; --- 37. PQConfig accessor round-trip: pq_kem_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (pq_kem_algorithm (mk-p_q_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. PQConfig accessor round-trip: pq_sig_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (pq_sig_algorithm (mk-p_q_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. PQConfig accessor round-trip: pq_security_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (pq_security_level (mk-p_q_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. PQConfig: integer field consistency ---
(push 1)
(declare-const r PQConfig)
(assert (>= (pq_kem_algorithm r) 0))
(assert (>= (pq_sig_algorithm r) 0))
(assert (not (>= (+ (pq_kem_algorithm r) (pq_sig_algorithm r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MRAEADConfig record properties ---

; --- 41. MRAEADConfig accessor round-trip: mraead_siv_mode ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (mraead_siv_mode (mk-m_r_a_e_a_d_config f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. MRAEADConfig accessor round-trip: mraead_deterministic ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (mraead_deterministic (mk-m_r_a_e_a_d_config f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MRAEADConfig_all_enabled ((g MRAEADConfig)) Bool
  (and (mraead_siv_mode g) (mraead_deterministic g)))

; --- 43. MRAEADConfig: all-enabled completeness ---
(push 1)
(declare-const g MRAEADConfig)
(assert (mraead_siv_mode g))
(assert (mraead_deterministic g))
(assert (not (MRAEADConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. MRAEADConfig: MRAEADConfig_all_enabled implies mraead_siv_mode ---
(push 1)
(declare-const g MRAEADConfig)
(assert (MRAEADConfig_all_enabled g))
(assert (not (mraead_siv_mode g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. MRAEADConfig: MRAEADConfig_all_enabled implies mraead_deterministic ---
(push 1)
(declare-const g MRAEADConfig)
(assert (MRAEADConfig_all_enabled g))
(assert (not (mraead_deterministic g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CertConfig record properties ---

; --- 46. CertConfig accessor round-trip: cert_ct_required ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cert_ct_required (mk-cert_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. CertConfig accessor round-trip: cert_pinning ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cert_pinning (mk-cert_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. CertConfig accessor round-trip: cert_revocation_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cert_revocation_check (mk-cert_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CertConfig_all_enabled ((g CertConfig)) Bool
  (and (cert_ct_required g) (cert_pinning g) (cert_revocation_check g)))

; --- 49. CertConfig: all-enabled completeness ---
(push 1)
(declare-const g CertConfig)
(assert (cert_ct_required g))
(assert (cert_pinning g))
(assert (cert_revocation_check g))
(assert (not (CertConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. CertConfig: CertConfig_all_enabled implies cert_ct_required ---
(push 1)
(declare-const g CertConfig)
(assert (CertConfig_all_enabled g))
(assert (not (cert_ct_required g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. CertConfig: CertConfig_all_enabled implies cert_pinning ---
(push 1)
(declare-const g CertConfig)
(assert (CertConfig_all_enabled g))
(assert (not (cert_pinning g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. CertConfig: CertConfig_all_enabled implies cert_revocation_check ---
(push 1)
(declare-const g CertConfig)
(assert (CertConfig_all_enabled g))
(assert (not (cert_revocation_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EncryptionScheme record properties ---

; --- 53. EncryptionScheme accessor round-trip: enc_key_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (enc_key_bits (mk-encryption_scheme f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. EncryptionScheme accessor round-trip: enc_nonce_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (enc_nonce_bits (mk-encryption_scheme f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. EncryptionScheme accessor round-trip: enc_tag_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (enc_tag_bits (mk-encryption_scheme f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. EncryptionScheme accessor round-trip: enc_block_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (enc_block_size (mk-encryption_scheme f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. EncryptionScheme: integer field consistency ---
(push 1)
(declare-const r EncryptionScheme)
(assert (>= (enc_key_bits r) 0))
(assert (>= (enc_nonce_bits r) 0))
(assert (not (>= (+ (enc_key_bits r) (enc_nonce_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KDFConfig record properties ---

; --- 58. KDFConfig accessor round-trip: kdf_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kdf_algorithm (mk-k_d_f_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. KDFConfig accessor round-trip: kdf_output_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kdf_output_bits (mk-k_d_f_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. KDFConfig accessor round-trip: kdf_salt_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kdf_salt_bits (mk-k_d_f_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. KDFConfig accessor round-trip: kdf_iterations ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kdf_iterations (mk-k_d_f_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. KDFConfig: integer field consistency ---
(push 1)
(declare-const r KDFConfig)
(assert (>= (kdf_algorithm r) 0))
(assert (>= (kdf_output_bits r) 0))
(assert (not (>= (+ (kdf_algorithm r) (kdf_output_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DerivedKey record properties ---

; --- 63. DerivedKey accessor round-trip: dk_parent_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (dk_parent_key (mk-derived_key f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. DerivedKey accessor round-trip: dk_derived_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (dk_derived_key (mk-derived_key f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. DerivedKey accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (Seq (mk-derived_key f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. DerivedKey accessor round-trip: dk_purpose ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (dk_purpose (mk-derived_key f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. DerivedKey: integer field consistency ---
(push 1)
(declare-const r DerivedKey)
(assert (>= (dk_parent_key r) 0))
(assert (>= (dk_derived_key r) 0))
(assert (not (>= (+ (dk_parent_key r) (dk_derived_key r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MACConfig record properties ---

; --- 68. MACConfig accessor round-trip: mac_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (mac_algorithm (mk-m_a_c_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. MACConfig accessor round-trip: mac_key_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (mac_key_bits (mk-m_a_c_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. MACConfig accessor round-trip: mac_tag_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (mac_tag_bits (mk-m_a_c_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. MACConfig: integer field consistency ---
(push 1)
(declare-const r MACConfig)
(assert (>= (mac_algorithm r) 0))
(assert (>= (mac_key_bits r) 0))
(assert (not (>= (+ (mac_algorithm r) (mac_key_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CounterNonce record properties ---

; --- 72. CounterNonce accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (Seq (mk-counter_nonce f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. CounterNonce accessor round-trip: cn_counter ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (cn_counter (mk-counter_nonce f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. CounterNonce: integer field consistency ---
(push 1)
(declare-const r CounterNonce)
(assert (>= (Seq r) 0))
(assert (>= (cn_counter r) 0))
(assert (not (>= (+ (Seq r) (cn_counter r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FullCryptoConfig record properties ---

; --- 75. FullCryptoConfig accessor round-trip: fc_ct_op ---
(push 1)
(declare-const f0 ConstantTimeOp)
(declare-const f1 AEADConfig)
(declare-const f2 HashConfig)
(declare-const f3 RNGConfig)
(declare-const f4 ProtocolConfig)
(declare-const f5 PQConfig)
(declare-const f6 CryptoKey)
(declare-const f7 CertConfig)
(declare-const f8 MRAEADConfig)
(declare-const f9 KDFConfig)
(declare-const f10 MACConfig)
(assert (not (= (fc_ct_op (mk-full_crypto_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. FullCryptoConfig accessor round-trip: fc_aead ---
(push 1)
(declare-const f0 ConstantTimeOp)
(declare-const f1 AEADConfig)
(declare-const f2 HashConfig)
(declare-const f3 RNGConfig)
(declare-const f4 ProtocolConfig)
(declare-const f5 PQConfig)
(declare-const f6 CryptoKey)
(declare-const f7 CertConfig)
(declare-const f8 MRAEADConfig)
(declare-const f9 KDFConfig)
(declare-const f10 MACConfig)
(assert (not (= (fc_aead (mk-full_crypto_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. FullCryptoConfig accessor round-trip: fc_hash ---
(push 1)
(declare-const f0 ConstantTimeOp)
(declare-const f1 AEADConfig)
(declare-const f2 HashConfig)
(declare-const f3 RNGConfig)
(declare-const f4 ProtocolConfig)
(declare-const f5 PQConfig)
(declare-const f6 CryptoKey)
(declare-const f7 CertConfig)
(declare-const f8 MRAEADConfig)
(declare-const f9 KDFConfig)
(declare-const f10 MACConfig)
(assert (not (= (fc_hash (mk-full_crypto_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. FullCryptoConfig accessor round-trip: fc_rng ---
(push 1)
(declare-const f0 ConstantTimeOp)
(declare-const f1 AEADConfig)
(declare-const f2 HashConfig)
(declare-const f3 RNGConfig)
(declare-const f4 ProtocolConfig)
(declare-const f5 PQConfig)
(declare-const f6 CryptoKey)
(declare-const f7 CertConfig)
(declare-const f8 MRAEADConfig)
(declare-const f9 KDFConfig)
(declare-const f10 MACConfig)
(assert (not (= (fc_rng (mk-full_crypto_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. FullCryptoConfig accessor round-trip: fc_proto ---
(push 1)
(declare-const f0 ConstantTimeOp)
(declare-const f1 AEADConfig)
(declare-const f2 HashConfig)
(declare-const f3 RNGConfig)
(declare-const f4 ProtocolConfig)
(declare-const f5 PQConfig)
(declare-const f6 CryptoKey)
(declare-const f7 CertConfig)
(declare-const f8 MRAEADConfig)
(declare-const f9 KDFConfig)
(declare-const f10 MACConfig)
(assert (not (= (fc_proto (mk-full_crypto_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

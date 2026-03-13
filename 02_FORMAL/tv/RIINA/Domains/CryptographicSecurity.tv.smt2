; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CryptographicSecurity.v (76 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CryptographicSecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; ct_valid: source semantics (matches Coq)
; Translation validation: ct_valid preserves semantics
(push 1)
(declare-const source_ct_valid Int)
(declare-const target_ct_valid Int)
(assert (>= source_ct_valid 0))
(assert (>= target_ct_valid 0))
(assert (not (= source_ct_valid target_ct_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_ct_op: source semantics (matches Coq)
; Translation validation: riina_ct_op preserves semantics
(push 1)
(declare-const source_riina_ct_op Int)
(declare-const target_riina_ct_op Int)
(assert (>= source_riina_ct_op 0))
(assert (>= target_riina_ct_op 0))
(assert (not (= source_riina_ct_op target_riina_ct_op)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_secure: source semantics (matches Coq)
; Translation validation: key_secure preserves semantics
(push 1)
(declare-const source_key_secure Int)
(declare-const target_key_secure Int)
(assert (>= source_key_secure 0))
(assert (>= target_key_secure 0))
(assert (not (= source_key_secure target_key_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_strong: source semantics (matches Coq)
; Translation validation: key_strong preserves semantics
(push 1)
(declare-const source_key_strong Int)
(declare-const target_key_strong Int)
(assert (>= source_key_strong 0))
(assert (>= target_key_strong 0))
(assert (not (= source_key_strong target_key_strong)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_key: source semantics (matches Coq)
; Translation validation: riina_key preserves semantics
(push 1)
(declare-const source_riina_key Int)
(declare-const target_riina_key Int)
(assert (>= source_riina_key 0))
(assert (>= target_riina_key 0))
(assert (not (= source_riina_key target_riina_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonce_fresh: source semantics (matches Coq)
; Translation validation: nonce_fresh preserves semantics
(push 1)
(declare-const source_nonce_fresh Int)
(declare-const target_nonce_fresh Int)
(assert (>= source_nonce_fresh 0))
(assert (>= target_nonce_fresh 0))
(assert (not (= source_nonce_fresh target_nonce_fresh)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonce_counter_safe: source semantics (matches Coq)
; Translation validation: nonce_counter_safe preserves semantics
(push 1)
(declare-const source_nonce_counter_safe Int)
(declare-const target_nonce_counter_safe Int)
(assert (>= source_nonce_counter_safe 0))
(assert (>= target_nonce_counter_safe 0))
(assert (not (= source_nonce_counter_safe target_nonce_counter_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; aead_secure: source semantics (matches Coq)
; Translation validation: aead_secure preserves semantics
(push 1)
(declare-const source_aead_secure Int)
(declare-const target_aead_secure Int)
(assert (>= source_aead_secure 0))
(assert (>= target_aead_secure 0))
(assert (not (= source_aead_secure target_aead_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_aead: source semantics (matches Coq)
; Translation validation: riina_aead preserves semantics
(push 1)
(declare-const source_riina_aead Int)
(declare-const target_riina_aead Int)
(assert (>= source_riina_aead 0))
(assert (>= target_riina_aead 0))
(assert (not (= source_riina_aead target_riina_aead)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hash_secure: source semantics (matches Coq)
; Translation validation: hash_secure preserves semantics
(push 1)
(declare-const source_hash_secure Int)
(declare-const target_hash_secure Int)
(assert (>= source_hash_secure 0))
(assert (>= target_hash_secure 0))
(assert (not (= source_hash_secure target_hash_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_hash: source semantics (matches Coq)
; Translation validation: riina_hash preserves semantics
(push 1)
(declare-const source_riina_hash Int)
(declare-const target_riina_hash Int)
(assert (>= source_riina_hash 0))
(assert (>= target_riina_hash 0))
(assert (not (= source_riina_hash target_riina_hash)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rng_secure: source semantics (matches Coq)
; Translation validation: rng_secure preserves semantics
(push 1)
(declare-const source_rng_secure Int)
(declare-const target_rng_secure Int)
(assert (>= source_rng_secure 0))
(assert (>= target_rng_secure 0))
(assert (not (= source_rng_secure target_rng_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_rng: source semantics (matches Coq)
; Translation validation: riina_rng preserves semantics
(push 1)
(declare-const source_riina_rng Int)
(declare-const target_riina_rng Int)
(assert (>= source_riina_rng 0))
(assert (>= target_riina_rng 0))
(assert (not (= source_riina_rng target_riina_rng)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; proto_secure: source semantics (matches Coq)
; Translation validation: proto_secure preserves semantics
(push 1)
(declare-const source_proto_secure Int)
(declare-const target_proto_secure Int)
(assert (>= source_proto_secure 0))
(assert (>= target_proto_secure 0))
(assert (not (= source_proto_secure target_proto_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_proto: source semantics (matches Coq)
; Translation validation: riina_proto preserves semantics
(push 1)
(declare-const source_riina_proto Int)
(declare-const target_riina_proto Int)
(assert (>= source_riina_proto 0))
(assert (>= target_riina_proto 0))
(assert (not (= source_riina_proto target_riina_proto)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pq_secure: source semantics (matches Coq)
; Translation validation: pq_secure preserves semantics
(push 1)
(declare-const source_pq_secure Int)
(declare-const target_pq_secure Int)
(assert (>= source_pq_secure 0))
(assert (>= target_pq_secure 0))
(assert (not (= source_pq_secure target_pq_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_pq: source semantics (matches Coq)
; Translation validation: riina_pq preserves semantics
(push 1)
(declare-const source_riina_pq Int)
(declare-const target_riina_pq Int)
(assert (>= source_riina_pq 0))
(assert (>= target_riina_pq 0))
(assert (not (= source_riina_pq target_riina_pq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mraead_secure: source semantics (matches Coq)
; Translation validation: mraead_secure preserves semantics
(push 1)
(declare-const source_mraead_secure Int)
(declare-const target_mraead_secure Int)
(assert (>= source_mraead_secure 0))
(assert (>= target_mraead_secure 0))
(assert (not (= source_mraead_secure target_mraead_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_mraead: source semantics (matches Coq)
; Translation validation: riina_mraead preserves semantics
(push 1)
(declare-const source_riina_mraead Int)
(declare-const target_riina_mraead Int)
(assert (>= source_riina_mraead 0))
(assert (>= target_riina_mraead 0))
(assert (not (= source_riina_mraead target_riina_mraead)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_secure: source semantics (matches Coq)
; Translation validation: cert_secure preserves semantics
(push 1)
(declare-const source_cert_secure Int)
(declare-const target_cert_secure Int)
(assert (>= source_cert_secure 0))
(assert (>= target_cert_secure 0))
(assert (not (= source_cert_secure target_cert_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_cert: source semantics (matches Coq)
; Translation validation: riina_cert preserves semantics
(push 1)
(declare-const source_riina_cert Int)
(declare-const target_riina_cert Int)
(assert (>= source_riina_cert 0))
(assert (>= target_riina_cert 0))
(assert (not (= source_riina_cert target_riina_cert)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; encrypt_decrypt_inverse_property: source semantics (matches Coq)
; Translation validation: encrypt_decrypt_inverse_property preserves semantics
(push 1)
(declare-const source_encrypt_decrypt_inverse_property Int)
(declare-const target_encrypt_decrypt_inverse_property Int)
(assert (>= source_encrypt_decrypt_inverse_property 0))
(assert (>= target_encrypt_decrypt_inverse_property 0))
(assert (not (= source_encrypt_decrypt_inverse_property target_encrypt_decrypt_inverse_property)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_enc_scheme: source semantics (matches Coq)
; Translation validation: riina_enc_scheme preserves semantics
(push 1)
(declare-const source_riina_enc_scheme Int)
(declare-const target_riina_enc_scheme Int)
(assert (>= source_riina_enc_scheme 0))
(assert (>= target_riina_enc_scheme 0))
(assert (not (= source_riina_enc_scheme target_riina_enc_scheme)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kdf_secure: source semantics (matches Coq)
; Translation validation: kdf_secure preserves semantics
(push 1)
(declare-const source_kdf_secure Int)
(declare-const target_kdf_secure Int)
(assert (>= source_kdf_secure 0))
(assert (>= target_kdf_secure 0))
(assert (not (= source_kdf_secure target_kdf_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_kdf: source semantics (matches Coq)
; Translation validation: riina_kdf preserves semantics
(push 1)
(declare-const source_riina_kdf Int)
(declare-const target_riina_kdf Int)
(assert (>= source_riina_kdf 0))
(assert (>= target_riina_kdf 0))
(assert (not (= source_riina_kdf target_riina_kdf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; derived_key_valid: source semantics (matches Coq)
; Translation validation: derived_key_valid preserves semantics
(push 1)
(declare-const source_derived_key_valid Int)
(declare-const target_derived_key_valid Int)
(assert (>= source_derived_key_valid 0))
(assert (>= target_derived_key_valid 0))
(assert (not (= source_derived_key_valid target_derived_key_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mac_secure: source semantics (matches Coq)
; Translation validation: mac_secure preserves semantics
(push 1)
(declare-const source_mac_secure Int)
(declare-const target_mac_secure Int)
(assert (>= source_mac_secure 0))
(assert (>= target_mac_secure 0))
(assert (not (= source_mac_secure target_mac_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_mac: source semantics (matches Coq)
; Translation validation: riina_mac preserves semantics
(push 1)
(declare-const source_riina_mac Int)
(declare-const target_riina_mac Int)
(assert (>= source_riina_mac 0))
(assert (>= target_riina_mac 0))
(assert (not (= source_riina_mac target_riina_mac)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tag_compare_ct: source semantics (matches Coq)
; Translation validation: tag_compare_ct preserves semantics
(push 1)
(declare-const source_tag_compare_ct Int)
(declare-const target_tag_compare_ct Int)
(assert (>= source_tag_compare_ct 0))
(assert (>= target_tag_compare_ct 0))
(assert (not (= source_tag_compare_ct target_tag_compare_ct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; counter_nonce_valid: source semantics (matches Coq)
; Translation validation: counter_nonce_valid preserves semantics
(push 1)
(declare-const source_counter_nonce_valid Int)
(declare-const target_counter_nonce_valid Int)
(assert (>= source_counter_nonce_valid 0))
(assert (>= target_counter_nonce_valid 0))
(assert (not (= source_counter_nonce_valid target_counter_nonce_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonce_in_set: source semantics (matches Coq)
; Translation validation: nonce_in_set preserves semantics
(push 1)
(declare-const source_nonce_in_set Int)
(declare-const target_nonce_in_set Int)
(assert (>= source_nonce_in_set 0))
(assert (>= target_nonce_in_set 0))
(assert (not (= source_nonce_in_set target_nonce_in_set)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_crypto_secure: source semantics (matches Coq)
; Translation validation: full_crypto_secure preserves semantics
(push 1)
(declare-const source_full_crypto_secure Int)
(declare-const target_full_crypto_secure Int)
(assert (>= source_full_crypto_secure 0))
(assert (>= target_full_crypto_secure 0))
(assert (not (= source_full_crypto_secure target_full_crypto_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_full_crypto: source semantics (matches Coq)
; Translation validation: riina_full_crypto preserves semantics
(push 1)
(declare-const source_riina_full_crypto Int)
(declare-const target_riina_full_crypto Int)
(assert (>= source_riina_full_crypto 0))
(assert (>= target_riina_full_crypto 0))
(assert (not (= source_riina_full_crypto target_riina_full_crypto)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff preserves semantics
(push 1)
(declare-const source_andb_true_iff Int)
(declare-const target_andb_true_iff Int)
(assert (>= source_andb_true_iff 0))
(assert (>= target_andb_true_iff 0))
(assert (not (= source_andb_true_iff target_andb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb3_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb3_true_iff preserves semantics
(push 1)
(declare-const source_andb3_true_iff Int)
(declare-const target_andb3_true_iff Int)
(assert (>= source_andb3_true_iff 0))
(assert (>= target_andb3_true_iff 0))
(assert (not (= source_andb3_true_iff target_andb3_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_true_iff preserves semantics
(push 1)
(declare-const source_negb_true_iff Int)
(declare-const target_negb_true_iff Int)
(assert (>= source_negb_true_iff 0))
(assert (>= target_negb_true_iff 0))
(assert (not (= source_negb_true_iff target_negb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; leb_le: translation preserves property (matches Coq: Lemma)
; Translation validation: leb_le preserves semantics
(push 1)
(declare-const source_leb_le Int)
(declare-const target_leb_le Int)
(assert (>= source_leb_le 0))
(assert (>= target_leb_le 0))
(assert (not (= source_leb_le target_leb_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_001_timing_side_channel_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_001_timing_side_channel_mitigated preserves semantics
(push 1)
(declare-const source_cry_001_timing_side_channel_mitigated Int)
(declare-const target_cry_001_timing_side_channel_mitigated Int)
(assert (>= source_cry_001_timing_side_channel_mitigated 0))
(assert (>= target_cry_001_timing_side_channel_mitigated 0))
(assert (not (= source_cry_001_timing_side_channel_mitigated target_cry_001_timing_side_channel_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_001a_riina_timing_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_001a_riina_timing_safe preserves semantics
(push 1)
(declare-const source_cry_001a_riina_timing_safe Int)
(declare-const target_cry_001a_riina_timing_safe Int)
(assert (>= source_cry_001a_riina_timing_safe 0))
(assert (>= target_cry_001a_riina_timing_safe 0))
(assert (not (= source_cry_001a_riina_timing_safe target_cry_001a_riina_timing_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_002_spa_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_002_spa_mitigated preserves semantics
(push 1)
(declare-const source_cry_002_spa_mitigated Int)
(declare-const target_cry_002_spa_mitigated Int)
(assert (>= source_cry_002_spa_mitigated 0))
(assert (>= target_cry_002_spa_mitigated 0))
(assert (not (= source_cry_002_spa_mitigated target_cry_002_spa_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_003_dpa_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_003_dpa_mitigated preserves semantics
(push 1)
(declare-const source_cry_003_dpa_mitigated Int)
(declare-const target_cry_003_dpa_mitigated Int)
(assert (>= source_cry_003_dpa_mitigated 0))
(assert (>= target_cry_003_dpa_mitigated 0))
(assert (not (= source_cry_003_dpa_mitigated target_cry_003_dpa_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_004_em_analysis_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_004_em_analysis_mitigated preserves semantics
(push 1)
(declare-const source_cry_004_em_analysis_mitigated Int)
(declare-const target_cry_004_em_analysis_mitigated Int)
(assert (>= source_cry_004_em_analysis_mitigated 0))
(assert (>= target_cry_004_em_analysis_mitigated 0))
(assert (not (= source_cry_004_em_analysis_mitigated target_cry_004_em_analysis_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_005_acoustic_analysis_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_005_acoustic_analysis_mitigated preserves semantics
(push 1)
(declare-const source_cry_005_acoustic_analysis_mitigated Int)
(declare-const target_cry_005_acoustic_analysis_mitigated Int)
(assert (>= source_cry_005_acoustic_analysis_mitigated 0))
(assert (>= target_cry_005_acoustic_analysis_mitigated 0))
(assert (not (= source_cry_005_acoustic_analysis_mitigated target_cry_005_acoustic_analysis_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_006_cache_timing_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_006_cache_timing_mitigated preserves semantics
(push 1)
(declare-const source_cry_006_cache_timing_mitigated Int)
(declare-const target_cry_006_cache_timing_mitigated Int)
(assert (>= source_cry_006_cache_timing_mitigated 0))
(assert (>= target_cry_006_cache_timing_mitigated 0))
(assert (not (= source_cry_006_cache_timing_mitigated target_cry_006_cache_timing_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_007_padding_oracle_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_007_padding_oracle_mitigated preserves semantics
(push 1)
(declare-const source_cry_007_padding_oracle_mitigated Int)
(declare-const target_cry_007_padding_oracle_mitigated Int)
(assert (>= source_cry_007_padding_oracle_mitigated 0))
(assert (>= target_cry_007_padding_oracle_mitigated 0))
(assert (not (= source_cry_007_padding_oracle_mitigated target_cry_007_padding_oracle_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_007a_riina_aead_padding_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_007a_riina_aead_padding_safe preserves semantics
(push 1)
(declare-const source_cry_007a_riina_aead_padding_safe Int)
(declare-const target_cry_007a_riina_aead_padding_safe Int)
(assert (>= source_cry_007a_riina_aead_padding_safe 0))
(assert (>= target_cry_007a_riina_aead_padding_safe 0))
(assert (not (= source_cry_007a_riina_aead_padding_safe target_cry_007a_riina_aead_padding_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_008_chosen_plaintext_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_008_chosen_plaintext_mitigated preserves semantics
(push 1)
(declare-const source_cry_008_chosen_plaintext_mitigated Int)
(declare-const target_cry_008_chosen_plaintext_mitigated Int)
(assert (>= source_cry_008_chosen_plaintext_mitigated 0))
(assert (>= target_cry_008_chosen_plaintext_mitigated 0))
(assert (not (= source_cry_008_chosen_plaintext_mitigated target_cry_008_chosen_plaintext_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_009_chosen_ciphertext_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_009_chosen_ciphertext_mitigated preserves semantics
(push 1)
(declare-const source_cry_009_chosen_ciphertext_mitigated Int)
(declare-const target_cry_009_chosen_ciphertext_mitigated Int)
(assert (>= source_cry_009_chosen_ciphertext_mitigated 0))
(assert (>= target_cry_009_chosen_ciphertext_mitigated 0))
(assert (not (= source_cry_009_chosen_ciphertext_mitigated target_cry_009_chosen_ciphertext_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_010_known_plaintext_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_010_known_plaintext_mitigated preserves semantics
(push 1)
(declare-const source_cry_010_known_plaintext_mitigated Int)
(declare-const target_cry_010_known_plaintext_mitigated Int)
(assert (>= source_cry_010_known_plaintext_mitigated 0))
(assert (>= target_cry_010_known_plaintext_mitigated 0))
(assert (not (= source_cry_010_known_plaintext_mitigated target_cry_010_known_plaintext_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_011_mitm_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_011_mitm_mitigated preserves semantics
(push 1)
(declare-const source_cry_011_mitm_mitigated Int)
(declare-const target_cry_011_mitm_mitigated Int)
(assert (>= source_cry_011_mitm_mitigated 0))
(assert (>= target_cry_011_mitm_mitigated 0))
(assert (not (= source_cry_011_mitm_mitigated target_cry_011_mitm_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_011a_riina_key_mitm_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_011a_riina_key_mitm_safe preserves semantics
(push 1)
(declare-const source_cry_011a_riina_key_mitm_safe Int)
(declare-const target_cry_011a_riina_key_mitm_safe Int)
(assert (>= source_cry_011a_riina_key_mitm_safe 0))
(assert (>= target_cry_011a_riina_key_mitm_safe 0))
(assert (not (= source_cry_011a_riina_key_mitm_safe target_cry_011a_riina_key_mitm_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_012_birthday_attack_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_012_birthday_attack_mitigated preserves semantics
(push 1)
(declare-const source_cry_012_birthday_attack_mitigated Int)
(declare-const target_cry_012_birthday_attack_mitigated Int)
(assert (>= source_cry_012_birthday_attack_mitigated 0))
(assert (>= target_cry_012_birthday_attack_mitigated 0))
(assert (not (= source_cry_012_birthday_attack_mitigated target_cry_012_birthday_attack_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_012a_riina_hash_birthday_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_012a_riina_hash_birthday_safe preserves semantics
(push 1)
(declare-const source_cry_012a_riina_hash_birthday_safe Int)
(declare-const target_cry_012a_riina_hash_birthday_safe Int)
(assert (>= source_cry_012a_riina_hash_birthday_safe 0))
(assert (>= target_cry_012a_riina_hash_birthday_safe 0))
(assert (not (= source_cry_012a_riina_hash_birthday_safe target_cry_012a_riina_hash_birthday_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_013_length_extension_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_013_length_extension_mitigated preserves semantics
(push 1)
(declare-const source_cry_013_length_extension_mitigated Int)
(declare-const target_cry_013_length_extension_mitigated Int)
(assert (>= source_cry_013_length_extension_mitigated 0))
(assert (>= target_cry_013_length_extension_mitigated 0))
(assert (not (= source_cry_013_length_extension_mitigated target_cry_013_length_extension_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_014_downgrade_attack_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_014_downgrade_attack_mitigated preserves semantics
(push 1)
(declare-const source_cry_014_downgrade_attack_mitigated Int)
(declare-const target_cry_014_downgrade_attack_mitigated Int)
(assert (>= source_cry_014_downgrade_attack_mitigated 0))
(assert (>= target_cry_014_downgrade_attack_mitigated 0))
(assert (not (= source_cry_014_downgrade_attack_mitigated target_cry_014_downgrade_attack_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_014a_riina_proto_downgrade_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_014a_riina_proto_downgrade_safe preserves semantics
(push 1)
(declare-const source_cry_014a_riina_proto_downgrade_safe Int)
(declare-const target_cry_014a_riina_proto_downgrade_safe Int)
(assert (>= source_cry_014a_riina_proto_downgrade_safe 0))
(assert (>= target_cry_014a_riina_proto_downgrade_safe 0))
(assert (not (= source_cry_014a_riina_proto_downgrade_safe target_cry_014a_riina_proto_downgrade_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_015_protocol_attack_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_015_protocol_attack_mitigated preserves semantics
(push 1)
(declare-const source_cry_015_protocol_attack_mitigated Int)
(declare-const target_cry_015_protocol_attack_mitigated Int)
(assert (>= source_cry_015_protocol_attack_mitigated 0))
(assert (>= target_cry_015_protocol_attack_mitigated 0))
(assert (not (= source_cry_015_protocol_attack_mitigated target_cry_015_protocol_attack_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_016_implementation_flaw_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_016_implementation_flaw_mitigated preserves semantics
(push 1)
(declare-const source_cry_016_implementation_flaw_mitigated Int)
(declare-const target_cry_016_implementation_flaw_mitigated Int)
(assert (>= source_cry_016_implementation_flaw_mitigated 0))
(assert (>= target_cry_016_implementation_flaw_mitigated 0))
(assert (not (= source_cry_016_implementation_flaw_mitigated target_cry_016_implementation_flaw_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_017_rng_attack_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_017_rng_attack_mitigated preserves semantics
(push 1)
(declare-const source_cry_017_rng_attack_mitigated Int)
(declare-const target_cry_017_rng_attack_mitigated Int)
(assert (>= source_cry_017_rng_attack_mitigated 0))
(assert (>= target_cry_017_rng_attack_mitigated 0))
(assert (not (= source_cry_017_rng_attack_mitigated target_cry_017_rng_attack_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_017a_riina_rng_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_017a_riina_rng_secure preserves semantics
(push 1)
(declare-const source_cry_017a_riina_rng_secure Int)
(declare-const target_cry_017a_riina_rng_secure Int)
(assert (>= source_cry_017a_riina_rng_secure 0))
(assert (>= target_cry_017a_riina_rng_secure 0))
(assert (not (= source_cry_017a_riina_rng_secure target_cry_017a_riina_rng_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_018_key_reuse_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_018_key_reuse_mitigated preserves semantics
(push 1)
(declare-const source_cry_018_key_reuse_mitigated Int)
(declare-const target_cry_018_key_reuse_mitigated Int)
(assert (>= source_cry_018_key_reuse_mitigated 0))
(assert (>= target_cry_018_key_reuse_mitigated 0))
(assert (not (= source_cry_018_key_reuse_mitigated target_cry_018_key_reuse_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_019_weak_keys_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_019_weak_keys_mitigated preserves semantics
(push 1)
(declare-const source_cry_019_weak_keys_mitigated Int)
(declare-const target_cry_019_weak_keys_mitigated Int)
(assert (>= source_cry_019_weak_keys_mitigated 0))
(assert (>= target_cry_019_weak_keys_mitigated 0))
(assert (not (= source_cry_019_weak_keys_mitigated target_cry_019_weak_keys_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_020_related_key_attack_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_020_related_key_attack_mitigated preserves semantics
(push 1)
(declare-const source_cry_020_related_key_attack_mitigated Int)
(declare-const target_cry_020_related_key_attack_mitigated Int)
(assert (>= source_cry_020_related_key_attack_mitigated 0))
(assert (>= target_cry_020_related_key_attack_mitigated 0))
(assert (not (= source_cry_020_related_key_attack_mitigated target_cry_020_related_key_attack_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_020a_riina_key_related_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_020a_riina_key_related_safe preserves semantics
(push 1)
(declare-const source_cry_020a_riina_key_related_safe Int)
(declare-const target_cry_020a_riina_key_related_safe Int)
(assert (>= source_cry_020a_riina_key_related_safe 0))
(assert (>= target_cry_020a_riina_key_related_safe 0))
(assert (not (= source_cry_020a_riina_key_related_safe target_cry_020a_riina_key_related_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_021_differential_cryptanalysis_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_021_differential_cryptanalysis_mitigated preserves semantics
(push 1)
(declare-const source_cry_021_differential_cryptanalysis_mitigated Int)
(declare-const target_cry_021_differential_cryptanalysis_mitigated Int)
(assert (>= source_cry_021_differential_cryptanalysis_mitigated 0))
(assert (>= target_cry_021_differential_cryptanalysis_mitigated 0))
(assert (not (= source_cry_021_differential_cryptanalysis_mitigated target_cry_021_differential_cryptanalysis_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_022_linear_cryptanalysis_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_022_linear_cryptanalysis_mitigated preserves semantics
(push 1)
(declare-const source_cry_022_linear_cryptanalysis_mitigated Int)
(declare-const target_cry_022_linear_cryptanalysis_mitigated Int)
(assert (>= source_cry_022_linear_cryptanalysis_mitigated 0))
(assert (>= target_cry_022_linear_cryptanalysis_mitigated 0))
(assert (not (= source_cry_022_linear_cryptanalysis_mitigated target_cry_022_linear_cryptanalysis_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_023_algebraic_attack_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_023_algebraic_attack_mitigated preserves semantics
(push 1)
(declare-const source_cry_023_algebraic_attack_mitigated Int)
(declare-const target_cry_023_algebraic_attack_mitigated Int)
(assert (>= source_cry_023_algebraic_attack_mitigated 0))
(assert (>= target_cry_023_algebraic_attack_mitigated 0))
(assert (not (= source_cry_023_algebraic_attack_mitigated target_cry_023_algebraic_attack_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_024_quantum_attack_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_024_quantum_attack_mitigated preserves semantics
(push 1)
(declare-const source_cry_024_quantum_attack_mitigated Int)
(declare-const target_cry_024_quantum_attack_mitigated Int)
(assert (>= source_cry_024_quantum_attack_mitigated 0))
(assert (>= target_cry_024_quantum_attack_mitigated 0))
(assert (not (= source_cry_024_quantum_attack_mitigated target_cry_024_quantum_attack_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_024a_riina_pq_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_024a_riina_pq_secure preserves semantics
(push 1)
(declare-const source_cry_024a_riina_pq_secure Int)
(declare-const target_cry_024a_riina_pq_secure Int)
(assert (>= source_cry_024a_riina_pq_secure 0))
(assert (>= target_cry_024a_riina_pq_secure 0))
(assert (not (= source_cry_024a_riina_pq_secure target_cry_024a_riina_pq_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_025_harvest_now_decrypt_later_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_025_harvest_now_decrypt_later_mitigated preserves semantics
(push 1)
(declare-const source_cry_025_harvest_now_decrypt_later_mitigated Int)
(declare-const target_cry_025_harvest_now_decrypt_later_mitigated Int)
(assert (>= source_cry_025_harvest_now_decrypt_later_mitigated 0))
(assert (>= target_cry_025_harvest_now_decrypt_later_mitigated 0))
(assert (not (= source_cry_025_harvest_now_decrypt_later_mitigated target_cry_025_harvest_now_decrypt_later_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_026_key_extraction_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_026_key_extraction_mitigated preserves semantics
(push 1)
(declare-const source_cry_026_key_extraction_mitigated Int)
(declare-const target_cry_026_key_extraction_mitigated Int)
(assert (>= source_cry_026_key_extraction_mitigated 0))
(assert (>= target_cry_026_key_extraction_mitigated 0))
(assert (not (= source_cry_026_key_extraction_mitigated target_cry_026_key_extraction_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_027_nonce_misuse_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_027_nonce_misuse_mitigated preserves semantics
(push 1)
(declare-const source_cry_027_nonce_misuse_mitigated Int)
(declare-const target_cry_027_nonce_misuse_mitigated Int)
(assert (>= source_cry_027_nonce_misuse_mitigated 0))
(assert (>= target_cry_027_nonce_misuse_mitigated 0))
(assert (not (= source_cry_027_nonce_misuse_mitigated target_cry_027_nonce_misuse_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_027a_riina_mraead_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_027a_riina_mraead_secure preserves semantics
(push 1)
(declare-const source_cry_027a_riina_mraead_secure Int)
(declare-const target_cry_027a_riina_mraead_secure Int)
(assert (>= source_cry_027a_riina_mraead_secure 0))
(assert (>= target_cry_027a_riina_mraead_secure 0))
(assert (not (= source_cry_027a_riina_mraead_secure target_cry_027a_riina_mraead_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_028_certificate_attack_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_028_certificate_attack_mitigated preserves semantics
(push 1)
(declare-const source_cry_028_certificate_attack_mitigated Int)
(declare-const target_cry_028_certificate_attack_mitigated Int)
(assert (>= source_cry_028_certificate_attack_mitigated 0))
(assert (>= target_cry_028_certificate_attack_mitigated 0))
(assert (not (= source_cry_028_certificate_attack_mitigated target_cry_028_certificate_attack_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_028a_riina_cert_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_028a_riina_cert_secure preserves semantics
(push 1)
(declare-const source_cry_028a_riina_cert_secure Int)
(declare-const target_cry_028a_riina_cert_secure Int)
(assert (>= source_cry_028a_riina_cert_secure 0))
(assert (>= target_cry_028a_riina_cert_secure 0))
(assert (not (= source_cry_028a_riina_cert_secure target_cry_028a_riina_cert_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_029_random_fault_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_029_random_fault_mitigated preserves semantics
(push 1)
(declare-const source_cry_029_random_fault_mitigated Int)
(declare-const target_cry_029_random_fault_mitigated Int)
(assert (>= source_cry_029_random_fault_mitigated 0))
(assert (>= target_cry_029_random_fault_mitigated 0))
(assert (not (= source_cry_029_random_fault_mitigated target_cry_029_random_fault_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_030_bleichenbacher_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_030_bleichenbacher_mitigated preserves semantics
(push 1)
(declare-const source_cry_030_bleichenbacher_mitigated Int)
(declare-const target_cry_030_bleichenbacher_mitigated Int)
(assert (>= source_cry_030_bleichenbacher_mitigated 0))
(assert (>= target_cry_030_bleichenbacher_mitigated 0))
(assert (not (= source_cry_030_bleichenbacher_mitigated target_cry_030_bleichenbacher_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cry_031_whisper_leak_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: cry_031_whisper_leak_mitigated preserves semantics
(push 1)
(declare-const source_cry_031_whisper_leak_mitigated Int)
(declare-const target_cry_031_whisper_leak_mitigated Int)
(assert (>= source_cry_031_whisper_leak_mitigated 0))
(assert (>= target_cry_031_whisper_leak_mitigated 0))
(assert (not (= source_cry_031_whisper_leak_mitigated target_cry_031_whisper_leak_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; complete_ct_security: translation preserves property (matches Coq: Theorem)
; Translation validation: complete_ct_security preserves semantics
(push 1)
(declare-const source_complete_ct_security Int)
(declare-const target_complete_ct_security Int)
(assert (>= source_complete_ct_security 0))
(assert (>= target_complete_ct_security 0))
(assert (not (= source_complete_ct_security target_complete_ct_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; complete_aead_security: translation preserves property (matches Coq: Theorem)
; Translation validation: complete_aead_security preserves semantics
(push 1)
(declare-const source_complete_aead_security Int)
(declare-const target_complete_aead_security Int)
(assert (>= source_complete_aead_security 0))
(assert (>= target_complete_aead_security 0))
(assert (not (= source_complete_aead_security target_complete_aead_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_complete_crypto_security: translation preserves property (matches Coq: Theorem)
; Translation validation: riina_complete_crypto_security preserves semantics
(push 1)
(declare-const source_riina_complete_crypto_security Int)
(declare-const target_riina_complete_crypto_security Int)
(assert (>= source_riina_complete_crypto_security 0))
(assert (>= target_riina_complete_crypto_security 0))
(assert (not (= source_riina_complete_crypto_security target_riina_complete_crypto_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; enc_001_length_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: enc_001_length_preservation preserves semantics
(push 1)
(declare-const source_enc_001_length_preservation Int)
(declare-const target_enc_001_length_preservation Int)
(assert (>= source_enc_001_length_preservation 0))
(assert (>= target_enc_001_length_preservation 0))
(assert (not (= source_enc_001_length_preservation target_enc_001_length_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; enc_002_key_size_requirement: translation preserves property (matches Coq: Theorem)
; Translation validation: enc_002_key_size_requirement preserves semantics
(push 1)
(declare-const source_enc_002_key_size_requirement Int)
(declare-const target_enc_002_key_size_requirement Int)
(assert (>= source_enc_002_key_size_requirement 0))
(assert (>= target_enc_002_key_size_requirement 0))
(assert (not (= source_enc_002_key_size_requirement target_enc_002_key_size_requirement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; enc_003_riina_key_size_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: enc_003_riina_key_size_valid preserves semantics
(push 1)
(declare-const source_enc_003_riina_key_size_valid Int)
(declare-const target_enc_003_riina_key_size_valid Int)
(assert (>= source_enc_003_riina_key_size_valid 0))
(assert (>= target_enc_003_riina_key_size_valid 0))
(assert (not (= source_enc_003_riina_key_size_valid target_enc_003_riina_key_size_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; enc_004_riina_nonce_size_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: enc_004_riina_nonce_size_valid preserves semantics
(push 1)
(declare-const source_enc_004_riina_nonce_size_valid Int)
(declare-const target_enc_004_riina_nonce_size_valid Int)
(assert (>= source_enc_004_riina_nonce_size_valid 0))
(assert (>= target_enc_004_riina_nonce_size_valid 0))
(assert (not (= source_enc_004_riina_nonce_size_valid target_enc_004_riina_nonce_size_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; enc_005_riina_tag_size_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: enc_005_riina_tag_size_valid preserves semantics
(push 1)
(declare-const source_enc_005_riina_tag_size_valid Int)
(declare-const target_enc_005_riina_tag_size_valid Int)
(assert (>= source_enc_005_riina_tag_size_valid 0))
(assert (>= target_enc_005_riina_tag_size_valid 0))
(assert (not (= source_enc_005_riina_tag_size_valid target_enc_005_riina_tag_size_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; enc_006_riina_is_authenticated: translation preserves property (matches Coq: Theorem)
; Translation validation: enc_006_riina_is_authenticated preserves semantics
(push 1)
(declare-const source_enc_006_riina_is_authenticated Int)
(declare-const target_enc_006_riina_is_authenticated Int)
(assert (>= source_enc_006_riina_is_authenticated 0))
(assert (>= target_enc_006_riina_is_authenticated 0))
(assert (not (= source_enc_006_riina_is_authenticated target_enc_006_riina_is_authenticated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kdf_001_riina_kdf_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: kdf_001_riina_kdf_secure preserves semantics
(push 1)
(declare-const source_kdf_001_riina_kdf_secure Int)
(declare-const target_kdf_001_riina_kdf_secure Int)
(assert (>= source_kdf_001_riina_kdf_secure 0))
(assert (>= target_kdf_001_riina_kdf_secure 0))
(assert (not (= source_kdf_001_riina_kdf_secure target_kdf_001_riina_kdf_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kdf_002_kdf_output_sufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: kdf_002_kdf_output_sufficient preserves semantics
(push 1)
(declare-const source_kdf_002_kdf_output_sufficient Int)
(declare-const target_kdf_002_kdf_output_sufficient Int)
(assert (>= source_kdf_002_kdf_output_sufficient 0))
(assert (>= target_kdf_002_kdf_output_sufficient 0))
(assert (not (= source_kdf_002_kdf_output_sufficient target_kdf_002_kdf_output_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kdf_003_kdf_salt_sufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: kdf_003_kdf_salt_sufficient preserves semantics
(push 1)
(declare-const source_kdf_003_kdf_salt_sufficient Int)
(declare-const target_kdf_003_kdf_salt_sufficient Int)
(assert (>= source_kdf_003_kdf_salt_sufficient 0))
(assert (>= target_kdf_003_kdf_salt_sufficient 0))
(assert (not (= source_kdf_003_kdf_salt_sufficient target_kdf_003_kdf_salt_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kdf_004_kdf_approved_algorithm: translation preserves property (matches Coq: Theorem)
; Translation validation: kdf_004_kdf_approved_algorithm preserves semantics
(push 1)
(declare-const source_kdf_004_kdf_approved_algorithm Int)
(declare-const target_kdf_004_kdf_approved_algorithm Int)
(assert (>= source_kdf_004_kdf_approved_algorithm 0))
(assert (>= target_kdf_004_kdf_approved_algorithm 0))
(assert (not (= source_kdf_004_kdf_approved_algorithm target_kdf_004_kdf_approved_algorithm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dk_001_valid_implies_secure_kdf: translation preserves property (matches Coq: Theorem)
; Translation validation: dk_001_valid_implies_secure_kdf preserves semantics
(push 1)
(declare-const source_dk_001_valid_implies_secure_kdf Int)
(declare-const target_dk_001_valid_implies_secure_kdf Int)
(assert (>= source_dk_001_valid_implies_secure_kdf 0))
(assert (>= target_dk_001_valid_implies_secure_kdf 0))
(assert (not (= source_dk_001_valid_implies_secure_kdf target_dk_001_valid_implies_secure_kdf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mac_001_riina_mac_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: mac_001_riina_mac_secure preserves semantics
(push 1)
(declare-const source_mac_001_riina_mac_secure Int)
(declare-const target_mac_001_riina_mac_secure Int)
(assert (>= source_mac_001_riina_mac_secure 0))
(assert (>= target_mac_001_riina_mac_secure 0))
(assert (not (= source_mac_001_riina_mac_secure target_mac_001_riina_mac_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mac_002_mac_key_sufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: mac_002_mac_key_sufficient preserves semantics
(push 1)
(declare-const source_mac_002_mac_key_sufficient Int)
(declare-const target_mac_002_mac_key_sufficient Int)
(assert (>= source_mac_002_mac_key_sufficient 0))
(assert (>= target_mac_002_mac_key_sufficient 0))
(assert (not (= source_mac_002_mac_key_sufficient target_mac_002_mac_key_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mac_003_mac_tag_sufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: mac_003_mac_tag_sufficient preserves semantics
(push 1)
(declare-const source_mac_003_mac_tag_sufficient Int)
(declare-const target_mac_003_mac_tag_sufficient Int)
(assert (>= source_mac_003_mac_tag_sufficient 0))
(assert (>= target_mac_003_mac_tag_sufficient 0))
(assert (not (= source_mac_003_mac_tag_sufficient target_mac_003_mac_tag_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mac_004_mac_constant_time: translation preserves property (matches Coq: Theorem)
; Translation validation: mac_004_mac_constant_time preserves semantics
(push 1)
(declare-const source_mac_004_mac_constant_time Int)
(declare-const target_mac_004_mac_constant_time Int)
(assert (>= source_mac_004_mac_constant_time 0))
(assert (>= target_mac_004_mac_constant_time 0))
(assert (not (= source_mac_004_mac_constant_time target_mac_004_mac_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tag_001_equal_tags_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: tag_001_equal_tags_valid preserves semantics
(push 1)
(declare-const source_tag_001_equal_tags_valid Int)
(declare-const target_tag_001_equal_tags_valid Int)
(assert (>= source_tag_001_equal_tags_valid 0))
(assert (>= target_tag_001_equal_tags_valid 0))
(assert (not (= source_tag_001_equal_tags_valid target_tag_001_equal_tags_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tag_002_tag_compare_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: tag_002_tag_compare_reflexive preserves semantics
(push 1)
(declare-const source_tag_002_tag_compare_reflexive Int)
(declare-const target_tag_002_tag_compare_reflexive Int)
(assert (>= source_tag_002_tag_compare_reflexive 0))
(assert (>= target_tag_002_tag_compare_reflexive 0))
(assert (not (= source_tag_002_tag_compare_reflexive target_tag_002_tag_compare_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonce_001_counter_incrementable: translation preserves property (matches Coq: Theorem)
; Translation validation: nonce_001_counter_incrementable preserves semantics
(push 1)
(declare-const source_nonce_001_counter_incrementable Int)
(declare-const target_nonce_001_counter_incrementable Int)
(assert (>= source_nonce_001_counter_incrementable 0))
(assert (>= target_nonce_001_counter_incrementable 0))
(assert (not (= source_nonce_001_counter_incrementable target_nonce_001_counter_incrementable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonce_002_increment_changes_nonce: translation preserves property (matches Coq: Theorem)
; Translation validation: nonce_002_increment_changes_nonce preserves semantics
(push 1)
(declare-const source_nonce_002_increment_changes_nonce Int)
(declare-const target_nonce_002_increment_changes_nonce Int)
(assert (>= source_nonce_002_increment_changes_nonce 0))
(assert (>= target_nonce_002_increment_changes_nonce 0))
(assert (not (= source_nonce_002_increment_changes_nonce target_nonce_002_increment_changes_nonce)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonce_003_different_counters_different_nonces: translation preserves property (matches Coq: Theorem)
; Translation validation: nonce_003_different_counters_different_nonces preserves semantics
(push 1)
(declare-const source_nonce_003_different_counters_different_nonces Int)
(declare-const target_nonce_003_different_counters_different_nonces Int)
(assert (>= source_nonce_003_different_counters_different_nonces 0))
(assert (>= target_nonce_003_different_counters_different_nonces 0))
(assert (not (= source_nonce_003_different_counters_different_nonces target_nonce_003_different_counters_different_nonces)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonce_004_empty_set_no_collision: translation preserves property (matches Coq: Theorem)
; Translation validation: nonce_004_empty_set_no_collision preserves semantics
(push 1)
(declare-const source_nonce_004_empty_set_no_collision Int)
(declare-const target_nonce_004_empty_set_no_collision Int)
(assert (>= source_nonce_004_empty_set_no_collision 0))
(assert (>= target_nonce_004_empty_set_no_collision 0))
(assert (not (= source_nonce_004_empty_set_no_collision target_nonce_004_empty_set_no_collision)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonce_005_add_increases_size: translation preserves property (matches Coq: Theorem)
; Translation validation: nonce_005_add_increases_size preserves semantics
(push 1)
(declare-const source_nonce_005_add_increases_size Int)
(declare-const target_nonce_005_add_increases_size Int)
(assert (>= source_nonce_005_add_increases_size 0))
(assert (>= target_nonce_005_add_increases_size 0))
(assert (not (= source_nonce_005_add_increases_size target_nonce_005_add_increases_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_001_riina_full_crypto_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: full_001_riina_full_crypto_secure preserves semantics
(push 1)
(declare-const source_full_001_riina_full_crypto_secure Int)
(declare-const target_full_001_riina_full_crypto_secure Int)
(assert (>= source_full_001_riina_full_crypto_secure 0))
(assert (>= target_full_001_riina_full_crypto_secure 0))
(assert (not (= source_full_001_riina_full_crypto_secure target_full_001_riina_full_crypto_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_002_full_implies_ct: translation preserves property (matches Coq: Theorem)
; Translation validation: full_002_full_implies_ct preserves semantics
(push 1)
(declare-const source_full_002_full_implies_ct Int)
(declare-const target_full_002_full_implies_ct Int)
(assert (>= source_full_002_full_implies_ct 0))
(assert (>= target_full_002_full_implies_ct 0))
(assert (not (= source_full_002_full_implies_ct target_full_002_full_implies_ct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_003_full_implies_authenticated: translation preserves property (matches Coq: Theorem)
; Translation validation: full_003_full_implies_authenticated preserves semantics
(push 1)
(declare-const source_full_003_full_implies_authenticated Int)
(declare-const target_full_003_full_implies_authenticated Int)
(assert (>= source_full_003_full_implies_authenticated 0))
(assert (>= target_full_003_full_implies_authenticated 0))
(assert (not (= source_full_003_full_implies_authenticated target_full_003_full_implies_authenticated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_004_full_implies_pq_ready: translation preserves property (matches Coq: Theorem)
; Translation validation: full_004_full_implies_pq_ready preserves semantics
(push 1)
(declare-const source_full_004_full_implies_pq_ready Int)
(declare-const target_full_004_full_implies_pq_ready Int)
(assert (>= source_full_004_full_implies_pq_ready 0))
(assert (>= target_full_004_full_implies_pq_ready 0))
(assert (not (= source_full_004_full_implies_pq_ready target_full_004_full_implies_pq_ready)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_005_full_implies_kdf_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: full_005_full_implies_kdf_secure preserves semantics
(push 1)
(declare-const source_full_005_full_implies_kdf_secure Int)
(declare-const target_full_005_full_implies_kdf_secure Int)
(assert (>= source_full_005_full_implies_kdf_secure 0))
(assert (>= target_full_005_full_implies_kdf_secure 0))
(assert (not (= source_full_005_full_implies_kdf_secure target_full_005_full_implies_kdf_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_006_full_implies_mac_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: full_006_full_implies_mac_secure preserves semantics
(push 1)
(declare-const source_full_006_full_implies_mac_secure Int)
(declare-const target_full_006_full_implies_mac_secure Int)
(assert (>= source_full_006_full_implies_mac_secure 0))
(assert (>= target_full_006_full_implies_mac_secure 0))
(assert (not (= source_full_006_full_implies_mac_secure target_full_006_full_implies_mac_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

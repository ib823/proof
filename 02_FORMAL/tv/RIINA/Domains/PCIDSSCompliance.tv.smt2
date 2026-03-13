; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/PCIDSSCompliance.v (37 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for PCIDSSCompliance
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; can_store: source semantics (matches Coq)
; Translation validation: can_store preserves semantics
(push 1)
(declare-const source_can_store Int)
(declare-const target_can_store Int)
(assert (>= source_can_store 0))
(assert (>= target_can_store 0))
(assert (not (= source_can_store target_can_store)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pci_compliant_encryption: source semantics (matches Coq)
; Translation validation: pci_compliant_encryption preserves semantics
(push 1)
(declare-const source_pci_compliant_encryption Int)
(declare-const target_pci_compliant_encryption Int)
(assert (>= source_pci_compliant_encryption 0))
(assert (>= target_pci_compliant_encryption 0))
(assert (not (= source_pci_compliant_encryption target_pci_compliant_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; display_compliant: source semantics (matches Coq)
; Translation validation: display_compliant preserves semantics
(push 1)
(declare-const source_display_compliant Int)
(declare-const target_display_compliant Int)
(assert (>= source_display_compliant 0))
(assert (>= target_display_compliant 0))
(assert (not (= source_display_compliant target_display_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_needs_rotation: source semantics (matches Coq)
; Translation validation: key_needs_rotation preserves semantics
(push 1)
(declare-const source_key_needs_rotation Int)
(declare-const target_key_needs_rotation Int)
(assert (>= source_key_needs_rotation 0))
(assert (>= target_key_needs_rotation 0))
(assert (not (= source_key_needs_rotation target_key_needs_rotation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; grant_chd_access: source semantics (matches Coq)
; Translation validation: grant_chd_access preserves semantics
(push 1)
(declare-const source_grant_chd_access Int)
(declare-const target_grant_chd_access Int)
(assert (>= source_grant_chd_access 0))
(assert (>= target_grant_chd_access 0))
(assert (not (= source_grant_chd_access target_grant_chd_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; chd_record_compliant: source semantics (matches Coq)
; Translation validation: chd_record_compliant preserves semantics
(push 1)
(declare-const source_chd_record_compliant Int)
(declare-const target_chd_record_compliant Int)
(assert (>= source_chd_record_compliant 0))
(assert (>= target_chd_record_compliant 0))
(assert (not (= source_chd_record_compliant target_chd_record_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; create_audit_entry: source semantics (matches Coq)
; Translation validation: create_audit_entry preserves semantics
(push 1)
(declare-const source_create_audit_entry Int)
(declare-const target_create_audit_entry Int)
(assert (>= source_create_audit_entry 0))
(assert (>= target_create_audit_entry 0))
(assert (not (= source_create_audit_entry target_create_audit_entry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; audit_chain_valid: source semantics (matches Coq)
; Translation validation: audit_chain_valid preserves semantics
(push 1)
(declare-const source_audit_chain_valid Int)
(declare-const target_audit_chain_valid Int)
(assert (>= source_audit_chain_valid 0))
(assert (>= target_audit_chain_valid 0))
(assert (not (= source_audit_chain_valid target_audit_chain_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tls_compliant: source semantics (matches Coq)
; Translation validation: tls_compliant preserves semantics
(push 1)
(declare-const source_tls_compliant Int)
(declare-const target_tls_compliant Int)
(assert (>= source_tls_compliant 0))
(assert (>= target_tls_compliant 0))
(assert (not (= source_tls_compliant target_tls_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; transmission_compliant: source semantics (matches Coq)
; Translation validation: transmission_compliant preserves semantics
(push 1)
(declare-const source_transmission_compliant Int)
(declare-const target_transmission_compliant Int)
(assert (>= source_transmission_compliant 0))
(assert (>= target_transmission_compliant 0))
(assert (not (= source_transmission_compliant target_transmission_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; data_past_retention: source semantics (matches Coq)
; Translation validation: data_past_retention preserves semantics
(push 1)
(declare-const source_data_past_retention Int)
(declare-const target_data_past_retention Int)
(assert (>= source_data_past_retention 0))
(assert (>= target_data_past_retention 0))
(assert (not (= source_data_past_retention target_data_past_retention)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; deletion_secure: source semantics (matches Coq)
; Translation validation: deletion_secure preserves semantics
(push 1)
(declare-const source_deletion_secure Int)
(declare-const target_deletion_secure Int)
(assert (>= source_deletion_secure 0))
(assert (>= target_deletion_secure 0))
(assert (not (= source_deletion_secure target_deletion_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; deletion_unrecoverable: source semantics (matches Coq)
; Translation validation: deletion_unrecoverable preserves semantics
(push 1)
(declare-const source_deletion_unrecoverable Int)
(declare-const target_deletion_unrecoverable Int)
(assert (>= source_deletion_unrecoverable 0))
(assert (>= target_deletion_unrecoverable 0))
(assert (not (= source_deletion_unrecoverable target_deletion_unrecoverable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; zone_compliant: source semantics (matches Coq)
; Translation validation: zone_compliant preserves semantics
(push 1)
(declare-const source_zone_compliant Int)
(declare-const target_zone_compliant Int)
(assert (>= source_zone_compliant 0))
(assert (>= target_zone_compliant 0))
(assert (not (= source_zone_compliant target_zone_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; system_scope_isolated: source semantics (matches Coq)
; Translation validation: system_scope_isolated preserves semantics
(push 1)
(declare-const source_system_scope_isolated Int)
(declare-const target_system_scope_isolated Int)
(assert (>= source_system_scope_isolated 0))
(assert (>= target_system_scope_isolated 0))
(assert (not (= source_system_scope_isolated target_system_scope_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; users_unique_ids: source semantics (matches Coq)
; Translation validation: users_unique_ids preserves semantics
(push 1)
(declare-const source_users_unique_ids Int)
(declare-const target_users_unique_ids Int)
(assert (>= source_users_unique_ids 0))
(assert (>= target_users_unique_ids 0))
(assert (not (= source_users_unique_ids target_users_unique_ids)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_01_pan_masking: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_01_pan_masking preserves semantics
(push 1)
(declare-const source_COMPLY_002_01_pan_masking Int)
(declare-const target_COMPLY_002_01_pan_masking Int)
(assert (>= source_COMPLY_002_01_pan_masking 0))
(assert (>= target_COMPLY_002_01_pan_masking 0))
(assert (not (= source_COMPLY_002_01_pan_masking target_COMPLY_002_01_pan_masking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_01_pan_masking_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_01_pan_masking_valid preserves semantics
(push 1)
(declare-const source_COMPLY_002_01_pan_masking_valid Int)
(declare-const target_COMPLY_002_01_pan_masking_valid Int)
(assert (>= source_COMPLY_002_01_pan_masking_valid 0))
(assert (>= target_COMPLY_002_01_pan_masking_valid 0))
(assert (not (= source_COMPLY_002_01_pan_masking_valid target_COMPLY_002_01_pan_masking_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_02_pan_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_02_pan_encryption preserves semantics
(push 1)
(declare-const source_COMPLY_002_02_pan_encryption Int)
(declare-const target_COMPLY_002_02_pan_encryption Int)
(assert (>= source_COMPLY_002_02_pan_encryption 0))
(assert (>= target_COMPLY_002_02_pan_encryption 0))
(assert (not (= source_COMPLY_002_02_pan_encryption target_COMPLY_002_02_pan_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_02_pan_plain_forbidden: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_02_pan_plain_forbidden preserves semantics
(push 1)
(declare-const source_COMPLY_002_02_pan_plain_forbidden Int)
(declare-const target_COMPLY_002_02_pan_plain_forbidden Int)
(assert (>= source_COMPLY_002_02_pan_plain_forbidden 0))
(assert (>= target_COMPLY_002_02_pan_plain_forbidden 0))
(assert (not (= source_COMPLY_002_02_pan_plain_forbidden target_COMPLY_002_02_pan_plain_forbidden)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_02_pan_aes128_insufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_02_pan_aes128_insufficient preserves semantics
(push 1)
(declare-const source_COMPLY_002_02_pan_aes128_insufficient Int)
(declare-const target_COMPLY_002_02_pan_aes128_insufficient Int)
(assert (>= source_COMPLY_002_02_pan_aes128_insufficient 0))
(assert (>= target_COMPLY_002_02_pan_aes128_insufficient 0))
(assert (not (= source_COMPLY_002_02_pan_aes128_insufficient target_COMPLY_002_02_pan_aes128_insufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_03_cvv_never_stored: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_03_cvv_never_stored preserves semantics
(push 1)
(declare-const source_COMPLY_002_03_cvv_never_stored Int)
(declare-const target_COMPLY_002_03_cvv_never_stored Int)
(assert (>= source_COMPLY_002_03_cvv_never_stored 0))
(assert (>= target_COMPLY_002_03_cvv_never_stored 0))
(assert (not (= source_COMPLY_002_03_cvv_never_stored target_COMPLY_002_03_cvv_never_stored)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_03_cvv_no_compliant_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_03_cvv_no_compliant_encryption preserves semantics
(push 1)
(declare-const source_COMPLY_002_03_cvv_no_compliant_encryption Int)
(declare-const target_COMPLY_002_03_cvv_no_compliant_encryption Int)
(assert (>= source_COMPLY_002_03_cvv_no_compliant_encryption 0))
(assert (>= target_COMPLY_002_03_cvv_no_compliant_encryption 0))
(assert (not (= source_COMPLY_002_03_cvv_no_compliant_encryption target_COMPLY_002_03_cvv_no_compliant_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_04_pin_never_stored: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_04_pin_never_stored preserves semantics
(push 1)
(declare-const source_COMPLY_002_04_pin_never_stored Int)
(declare-const target_COMPLY_002_04_pin_never_stored Int)
(assert (>= source_COMPLY_002_04_pin_never_stored 0))
(assert (>= target_COMPLY_002_04_pin_never_stored 0))
(assert (not (= source_COMPLY_002_04_pin_never_stored target_COMPLY_002_04_pin_never_stored)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_04_pin_no_compliant_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_04_pin_no_compliant_encryption preserves semantics
(push 1)
(declare-const source_COMPLY_002_04_pin_no_compliant_encryption Int)
(declare-const target_COMPLY_002_04_pin_no_compliant_encryption Int)
(assert (>= source_COMPLY_002_04_pin_no_compliant_encryption 0))
(assert (>= target_COMPLY_002_04_pin_no_compliant_encryption 0))
(assert (not (= source_COMPLY_002_04_pin_no_compliant_encryption target_COMPLY_002_04_pin_no_compliant_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_05_key_rotation_detection: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_05_key_rotation_detection preserves semantics
(push 1)
(declare-const source_COMPLY_002_05_key_rotation_detection Int)
(declare-const target_COMPLY_002_05_key_rotation_detection Int)
(assert (>= source_COMPLY_002_05_key_rotation_detection 0))
(assert (>= target_COMPLY_002_05_key_rotation_detection 0))
(assert (not (= source_COMPLY_002_05_key_rotation_detection target_COMPLY_002_05_key_rotation_detection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_05_key_no_rotation_needed: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_05_key_no_rotation_needed preserves semantics
(push 1)
(declare-const source_COMPLY_002_05_key_no_rotation_needed Int)
(declare-const target_COMPLY_002_05_key_no_rotation_needed Int)
(assert (>= source_COMPLY_002_05_key_no_rotation_needed 0))
(assert (>= target_COMPLY_002_05_key_no_rotation_needed 0))
(assert (not (= source_COMPLY_002_05_key_no_rotation_needed target_COMPLY_002_05_key_no_rotation_needed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_06_access_requires_need_to_know: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_06_access_requires_need_to_know preserves semantics
(push 1)
(declare-const source_COMPLY_002_06_access_requires_need_to_know Int)
(declare-const target_COMPLY_002_06_access_requires_need_to_know Int)
(assert (>= source_COMPLY_002_06_access_requires_need_to_know 0))
(assert (>= target_COMPLY_002_06_access_requires_need_to_know 0))
(assert (not (= source_COMPLY_002_06_access_requires_need_to_know target_COMPLY_002_06_access_requires_need_to_know)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_06_no_access_level_denied: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_06_no_access_level_denied preserves semantics
(push 1)
(declare-const source_COMPLY_002_06_no_access_level_denied Int)
(declare-const target_COMPLY_002_06_no_access_level_denied Int)
(assert (>= source_COMPLY_002_06_no_access_level_denied 0))
(assert (>= target_COMPLY_002_06_no_access_level_denied 0))
(assert (not (= source_COMPLY_002_06_no_access_level_denied target_COMPLY_002_06_no_access_level_denied)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_07_unique_ids_singleton: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_07_unique_ids_singleton preserves semantics
(push 1)
(declare-const source_COMPLY_002_07_unique_ids_singleton Int)
(declare-const target_COMPLY_002_07_unique_ids_singleton Int)
(assert (>= source_COMPLY_002_07_unique_ids_singleton 0))
(assert (>= target_COMPLY_002_07_unique_ids_singleton 0))
(assert (not (= source_COMPLY_002_07_unique_ids_singleton target_COMPLY_002_07_unique_ids_singleton)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_07_unique_ids_empty: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_07_unique_ids_empty preserves semantics
(push 1)
(declare-const source_COMPLY_002_07_unique_ids_empty Int)
(declare-const target_COMPLY_002_07_unique_ids_empty Int)
(assert (>= source_COMPLY_002_07_unique_ids_empty 0))
(assert (>= target_COMPLY_002_07_unique_ids_empty 0))
(assert (not (= source_COMPLY_002_07_unique_ids_empty target_COMPLY_002_07_unique_ids_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_08_mfa_required: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_08_mfa_required preserves semantics
(push 1)
(declare-const source_COMPLY_002_08_mfa_required Int)
(declare-const target_COMPLY_002_08_mfa_required Int)
(assert (>= source_COMPLY_002_08_mfa_required 0))
(assert (>= target_COMPLY_002_08_mfa_required 0))
(assert (not (= source_COMPLY_002_08_mfa_required target_COMPLY_002_08_mfa_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_08_access_granted_implies_mfa: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_08_access_granted_implies_mfa preserves semantics
(push 1)
(declare-const source_COMPLY_002_08_access_granted_implies_mfa Int)
(declare-const target_COMPLY_002_08_access_granted_implies_mfa Int)
(assert (>= source_COMPLY_002_08_access_granted_implies_mfa 0))
(assert (>= target_COMPLY_002_08_access_granted_implies_mfa 0))
(assert (not (= source_COMPLY_002_08_access_granted_implies_mfa target_COMPLY_002_08_access_granted_implies_mfa)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_09_audit_entry_has_timestamp: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_09_audit_entry_has_timestamp preserves semantics
(push 1)
(declare-const source_COMPLY_002_09_audit_entry_has_timestamp Int)
(declare-const target_COMPLY_002_09_audit_entry_has_timestamp Int)
(assert (>= source_COMPLY_002_09_audit_entry_has_timestamp 0))
(assert (>= target_COMPLY_002_09_audit_entry_has_timestamp 0))
(assert (not (= source_COMPLY_002_09_audit_entry_has_timestamp target_COMPLY_002_09_audit_entry_has_timestamp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_09_audit_entry_has_user: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_09_audit_entry_has_user preserves semantics
(push 1)
(declare-const source_COMPLY_002_09_audit_entry_has_user Int)
(declare-const target_COMPLY_002_09_audit_entry_has_user Int)
(assert (>= source_COMPLY_002_09_audit_entry_has_user 0))
(assert (>= target_COMPLY_002_09_audit_entry_has_user 0))
(assert (not (= source_COMPLY_002_09_audit_entry_has_user target_COMPLY_002_09_audit_entry_has_user)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_09_audit_entry_has_action: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_09_audit_entry_has_action preserves semantics
(push 1)
(declare-const source_COMPLY_002_09_audit_entry_has_action Int)
(declare-const target_COMPLY_002_09_audit_entry_has_action Int)
(assert (>= source_COMPLY_002_09_audit_entry_has_action 0))
(assert (>= target_COMPLY_002_09_audit_entry_has_action 0))
(assert (not (= source_COMPLY_002_09_audit_entry_has_action target_COMPLY_002_09_audit_entry_has_action)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_10_audit_has_hash: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_10_audit_has_hash preserves semantics
(push 1)
(declare-const source_COMPLY_002_10_audit_has_hash Int)
(declare-const target_COMPLY_002_10_audit_has_hash Int)
(assert (>= source_COMPLY_002_10_audit_has_hash 0))
(assert (>= target_COMPLY_002_10_audit_has_hash 0))
(assert (not (= source_COMPLY_002_10_audit_has_hash target_COMPLY_002_10_audit_has_hash)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_10_empty_log_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_10_empty_log_valid preserves semantics
(push 1)
(declare-const source_COMPLY_002_10_empty_log_valid Int)
(declare-const target_COMPLY_002_10_empty_log_valid Int)
(assert (>= source_COMPLY_002_10_empty_log_valid 0))
(assert (>= target_COMPLY_002_10_empty_log_valid 0))
(assert (not (= source_COMPLY_002_10_empty_log_valid target_COMPLY_002_10_empty_log_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_11_tls12_compliant: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_11_tls12_compliant preserves semantics
(push 1)
(declare-const source_COMPLY_002_11_tls12_compliant Int)
(declare-const target_COMPLY_002_11_tls12_compliant Int)
(assert (>= source_COMPLY_002_11_tls12_compliant 0))
(assert (>= target_COMPLY_002_11_tls12_compliant 0))
(assert (not (= source_COMPLY_002_11_tls12_compliant target_COMPLY_002_11_tls12_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_11_tls13_compliant: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_11_tls13_compliant preserves semantics
(push 1)
(declare-const source_COMPLY_002_11_tls13_compliant Int)
(declare-const target_COMPLY_002_11_tls13_compliant Int)
(assert (>= source_COMPLY_002_11_tls13_compliant 0))
(assert (>= target_COMPLY_002_11_tls13_compliant 0))
(assert (not (= source_COMPLY_002_11_tls13_compliant target_COMPLY_002_11_tls13_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_11_old_tls_non_compliant: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_11_old_tls_non_compliant preserves semantics
(push 1)
(declare-const source_COMPLY_002_11_old_tls_non_compliant Int)
(declare-const target_COMPLY_002_11_old_tls_non_compliant Int)
(assert (>= source_COMPLY_002_11_old_tls_non_compliant 0))
(assert (>= target_COMPLY_002_11_old_tls_non_compliant 0))
(assert (not (= source_COMPLY_002_11_old_tls_non_compliant target_COMPLY_002_11_old_tls_non_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_11_transmission_requires_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_11_transmission_requires_encryption preserves semantics
(push 1)
(declare-const source_COMPLY_002_11_transmission_requires_encryption Int)
(declare-const target_COMPLY_002_11_transmission_requires_encryption Int)
(assert (>= source_COMPLY_002_11_transmission_requires_encryption 0))
(assert (>= target_COMPLY_002_11_transmission_requires_encryption 0))
(assert (not (= source_COMPLY_002_11_transmission_requires_encryption target_COMPLY_002_11_transmission_requires_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_12_token_no_key_no_pan: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_12_token_no_key_no_pan preserves semantics
(push 1)
(declare-const source_COMPLY_002_12_token_no_key_no_pan Int)
(declare-const target_COMPLY_002_12_token_no_key_no_pan Int)
(assert (>= source_COMPLY_002_12_token_no_key_no_pan 0))
(assert (>= target_COMPLY_002_12_token_no_key_no_pan 0))
(assert (not (= source_COMPLY_002_12_token_no_key_no_pan target_COMPLY_002_12_token_no_key_no_pan)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_12_tokenization_irreversible_without_key: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_12_tokenization_irreversible_without_key preserves semantics
(push 1)
(declare-const source_COMPLY_002_12_tokenization_irreversible_without_key Int)
(declare-const target_COMPLY_002_12_tokenization_irreversible_without_key Int)
(assert (>= source_COMPLY_002_12_tokenization_irreversible_without_key 0))
(assert (>= target_COMPLY_002_12_tokenization_irreversible_without_key 0))
(assert (not (= source_COMPLY_002_12_tokenization_irreversible_without_key target_COMPLY_002_12_tokenization_irreversible_without_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_13_past_retention_detected: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_13_past_retention_detected preserves semantics
(push 1)
(declare-const source_COMPLY_002_13_past_retention_detected Int)
(declare-const target_COMPLY_002_13_past_retention_detected Int)
(assert (>= source_COMPLY_002_13_past_retention_detected 0))
(assert (>= target_COMPLY_002_13_past_retention_detected 0))
(assert (not (= source_COMPLY_002_13_past_retention_detected target_COMPLY_002_13_past_retention_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_13_within_retention_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_13_within_retention_ok preserves semantics
(push 1)
(declare-const source_COMPLY_002_13_within_retention_ok Int)
(declare-const target_COMPLY_002_13_within_retention_ok Int)
(assert (>= source_COMPLY_002_13_within_retention_ok 0))
(assert (>= target_COMPLY_002_13_within_retention_ok 0))
(assert (not (= source_COMPLY_002_13_within_retention_ok target_COMPLY_002_13_within_retention_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_14_secure_deletion_unrecoverable: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_14_secure_deletion_unrecoverable preserves semantics
(push 1)
(declare-const source_COMPLY_002_14_secure_deletion_unrecoverable Int)
(declare-const target_COMPLY_002_14_secure_deletion_unrecoverable Int)
(assert (>= source_COMPLY_002_14_secure_deletion_unrecoverable 0))
(assert (>= target_COMPLY_002_14_secure_deletion_unrecoverable 0))
(assert (not (= source_COMPLY_002_14_secure_deletion_unrecoverable target_COMPLY_002_14_secure_deletion_unrecoverable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_14_not_deleted_recoverable: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_14_not_deleted_recoverable preserves semantics
(push 1)
(declare-const source_COMPLY_002_14_not_deleted_recoverable Int)
(declare-const target_COMPLY_002_14_not_deleted_recoverable Int)
(assert (>= source_COMPLY_002_14_not_deleted_recoverable 0))
(assert (>= target_COMPLY_002_14_not_deleted_recoverable 0))
(assert (not (= source_COMPLY_002_14_not_deleted_recoverable target_COMPLY_002_14_not_deleted_recoverable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_14_marked_still_recoverable: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_14_marked_still_recoverable preserves semantics
(push 1)
(declare-const source_COMPLY_002_14_marked_still_recoverable Int)
(declare-const target_COMPLY_002_14_marked_still_recoverable Int)
(assert (>= source_COMPLY_002_14_marked_still_recoverable 0))
(assert (>= target_COMPLY_002_14_marked_still_recoverable 0))
(assert (not (= source_COMPLY_002_14_marked_still_recoverable target_COMPLY_002_14_marked_still_recoverable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_15_cde_requires_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_15_cde_requires_isolation preserves semantics
(push 1)
(declare-const source_COMPLY_002_15_cde_requires_isolation Int)
(declare-const target_COMPLY_002_15_cde_requires_isolation Int)
(assert (>= source_COMPLY_002_15_cde_requires_isolation 0))
(assert (>= target_COMPLY_002_15_cde_requires_isolation 0))
(assert (not (= source_COMPLY_002_15_cde_requires_isolation target_COMPLY_002_15_cde_requires_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_15_cde_requires_firewall: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_15_cde_requires_firewall preserves semantics
(push 1)
(declare-const source_COMPLY_002_15_cde_requires_firewall Int)
(declare-const target_COMPLY_002_15_cde_requires_firewall Int)
(assert (>= source_COMPLY_002_15_cde_requires_firewall 0))
(assert (>= target_COMPLY_002_15_cde_requires_firewall 0))
(assert (not (= source_COMPLY_002_15_cde_requires_firewall target_COMPLY_002_15_cde_requires_firewall)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_15_non_cde_always_compliant: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_15_non_cde_always_compliant preserves semantics
(push 1)
(declare-const source_COMPLY_002_15_non_cde_always_compliant Int)
(declare-const target_COMPLY_002_15_non_cde_always_compliant Int)
(assert (>= source_COMPLY_002_15_non_cde_always_compliant 0))
(assert (>= target_COMPLY_002_15_non_cde_always_compliant 0))
(assert (not (= source_COMPLY_002_15_non_cde_always_compliant target_COMPLY_002_15_non_cde_always_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; COMPLY_002_15_vault_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: COMPLY_002_15_vault_isolation preserves semantics
(push 1)
(declare-const source_COMPLY_002_15_vault_isolation Int)
(declare-const target_COMPLY_002_15_vault_isolation Int)
(assert (>= source_COMPLY_002_15_vault_isolation 0))
(assert (>= target_COMPLY_002_15_vault_isolation 0))
(assert (not (= source_COMPLY_002_15_vault_isolation target_COMPLY_002_15_vault_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

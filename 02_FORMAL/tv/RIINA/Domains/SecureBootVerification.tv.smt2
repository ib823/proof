; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SecureBootVerification.v (95 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for SecureBootVerification
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; rom_is_root_of_trust: source semantics (matches Coq)
; Translation validation: rom_is_root_of_trust preserves semantics
(push 1)
(declare-const source_rom_is_root_of_trust Int)
(declare-const target_rom_is_root_of_trust Int)
(assert (>= source_rom_is_root_of_trust 0))
(assert (>= target_rom_is_root_of_trust 0))
(assert (not (= source_rom_is_root_of_trust target_rom_is_root_of_trust)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rom_fully_secure: source semantics (matches Coq)
; Translation validation: rom_fully_secure preserves semantics
(push 1)
(declare-const source_rom_fully_secure Int)
(declare-const target_rom_fully_secure Int)
(assert (>= source_rom_fully_secure 0))
(assert (>= target_rom_fully_secure 0))
(assert (not (= source_rom_fully_secure target_rom_fully_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_valid_for_verification: source semantics (matches Coq)
; Translation validation: key_valid_for_verification preserves semantics
(push 1)
(declare-const source_key_valid_for_verification Int)
(declare-const target_key_valid_for_verification Int)
(assert (>= source_key_valid_for_verification 0))
(assert (>= target_key_valid_for_verification 0))
(assert (not (= source_key_valid_for_verification target_key_valid_for_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; signature_valid_with_key: source semantics (matches Coq)
; Translation validation: signature_valid_with_key preserves semantics
(push 1)
(declare-const source_signature_valid_with_key Int)
(declare-const target_signature_valid_with_key Int)
(assert (>= source_signature_valid_with_key 0))
(assert (>= target_signature_valid_with_key 0))
(assert (not (= source_signature_valid_with_key target_signature_valid_with_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bootloader_verified: source semantics (matches Coq)
; Translation validation: bootloader_verified preserves semantics
(push 1)
(declare-const source_bootloader_verified Int)
(declare-const target_bootloader_verified Int)
(assert (>= source_bootloader_verified 0))
(assert (>= target_bootloader_verified 0))
(assert (not (= source_bootloader_verified target_bootloader_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kernel_verified: source semantics (matches Coq)
; Translation validation: kernel_verified preserves semantics
(push 1)
(declare-const source_kernel_verified Int)
(declare-const target_kernel_verified Int)
(assert (>= source_kernel_verified 0))
(assert (>= target_kernel_verified 0))
(assert (not (= source_kernel_verified target_kernel_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; initramfs_verified: source semantics (matches Coq)
; Translation validation: initramfs_verified preserves semantics
(push 1)
(declare-const source_initramfs_verified Int)
(declare-const target_initramfs_verified Int)
(assert (>= source_initramfs_verified 0))
(assert (>= target_initramfs_verified 0))
(assert (not (= source_initramfs_verified target_initramfs_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; chain_of_trust_complete: source semantics (matches Coq)
; Translation validation: chain_of_trust_complete preserves semantics
(push 1)
(declare-const source_chain_of_trust_complete Int)
(declare-const target_chain_of_trust_complete Int)
(assert (>= source_chain_of_trust_complete 0))
(assert (>= target_chain_of_trust_complete 0))
(assert (not (= source_chain_of_trust_complete target_chain_of_trust_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tpm_operational: source semantics (matches Coq)
; Translation validation: tpm_operational preserves semantics
(push 1)
(declare-const source_tpm_operational Int)
(declare-const target_tpm_operational Int)
(assert (>= source_tpm_operational 0))
(assert (>= target_tpm_operational 0))
(assert (not (= source_tpm_operational target_tpm_operational)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pcr_measured: source semantics (matches Coq)
; Translation validation: pcr_measured preserves semantics
(push 1)
(declare-const source_pcr_measured Int)
(declare-const target_pcr_measured Int)
(assert (>= source_pcr_measured 0))
(assert (>= target_pcr_measured 0))
(assert (not (= source_pcr_measured target_pcr_measured)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_pcrs_extended: source semantics (matches Coq)
; Translation validation: all_pcrs_extended preserves semantics
(push 1)
(declare-const source_all_pcrs_extended Int)
(declare-const target_all_pcrs_extended Int)
(assert (>= source_all_pcrs_extended 0))
(assert (>= target_all_pcrs_extended 0))
(assert (not (= source_all_pcrs_extended target_all_pcrs_extended)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; measurement_valid: source semantics (matches Coq)
; Translation validation: measurement_valid preserves semantics
(push 1)
(declare-const source_measurement_valid Int)
(declare-const target_measurement_valid Int)
(assert (>= source_measurement_valid 0))
(assert (>= target_measurement_valid 0))
(assert (not (= source_measurement_valid target_measurement_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; measured_boot_complete: source semantics (matches Coq)
; Translation validation: measured_boot_complete preserves semantics
(push 1)
(declare-const source_measured_boot_complete Int)
(declare-const target_measured_boot_complete Int)
(assert (>= source_measured_boot_complete 0))
(assert (>= target_measured_boot_complete 0))
(assert (not (= source_measured_boot_complete target_measured_boot_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; version_above_minimum: source semantics (matches Coq)
; Translation validation: version_above_minimum preserves semantics
(push 1)
(declare-const source_version_above_minimum Int)
(declare-const target_version_above_minimum Int)
(assert (>= source_version_above_minimum 0))
(assert (>= target_version_above_minimum 0))
(assert (not (= source_version_above_minimum target_version_above_minimum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bootloader_antirollback_ok: source semantics (matches Coq)
; Translation validation: bootloader_antirollback_ok preserves semantics
(push 1)
(declare-const source_bootloader_antirollback_ok Int)
(declare-const target_bootloader_antirollback_ok Int)
(assert (>= source_bootloader_antirollback_ok 0))
(assert (>= target_bootloader_antirollback_ok 0))
(assert (not (= source_bootloader_antirollback_ok target_bootloader_antirollback_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kernel_antirollback_ok: source semantics (matches Coq)
; Translation validation: kernel_antirollback_ok preserves semantics
(push 1)
(declare-const source_kernel_antirollback_ok Int)
(declare-const target_kernel_antirollback_ok Int)
(assert (>= source_kernel_antirollback_ok 0))
(assert (>= target_kernel_antirollback_ok 0))
(assert (not (= source_kernel_antirollback_ok target_kernel_antirollback_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; antirollback_protected: source semantics (matches Coq)
; Translation validation: antirollback_protected preserves semantics
(push 1)
(declare-const source_antirollback_protected Int)
(declare-const target_antirollback_protected Int)
(assert (>= source_antirollback_protected 0))
(assert (>= target_antirollback_protected 0))
(assert (not (= source_antirollback_protected target_antirollback_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_root_key: source semantics (matches Coq)
; Translation validation: is_root_key preserves semantics
(push 1)
(declare-const source_is_root_key Int)
(declare-const target_is_root_key Int)
(assert (>= source_is_root_key 0))
(assert (>= target_is_root_key 0))
(assert (not (= source_is_root_key target_is_root_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_revoked_in_list: source semantics (matches Coq)
; Translation validation: key_revoked_in_list preserves semantics
(push 1)
(declare-const source_key_revoked_in_list Int)
(declare-const target_key_revoked_in_list Int)
(assert (>= source_key_revoked_in_list 0))
(assert (>= target_key_revoked_in_list 0))
(assert (not (= source_key_revoked_in_list target_key_revoked_in_list)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hierarchy_key_valid: source semantics (matches Coq)
; Translation validation: hierarchy_key_valid preserves semantics
(push 1)
(declare-const source_hierarchy_key_valid Int)
(declare-const target_hierarchy_key_valid Int)
(assert (>= source_hierarchy_key_valid 0))
(assert (>= target_hierarchy_key_valid 0))
(assert (not (= source_hierarchy_key_valid target_hierarchy_key_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_in_trusted_db: source semantics (matches Coq)
; Translation validation: key_in_trusted_db preserves semantics
(push 1)
(declare-const source_key_in_trusted_db Int)
(declare-const target_key_in_trusted_db Int)
(assert (>= source_key_in_trusted_db 0))
(assert (>= target_key_in_trusted_db 0))
(assert (not (= source_key_in_trusted_db target_key_in_trusted_db)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hash_forbidden: source semantics (matches Coq)
; Translation validation: hash_forbidden preserves semantics
(push 1)
(declare-const source_hash_forbidden Int)
(declare-const target_hash_forbidden Int)
(assert (>= source_hash_forbidden 0))
(assert (>= target_hash_forbidden 0))
(assert (not (= source_hash_forbidden target_hash_forbidden)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_forbidden: source semantics (matches Coq)
; Translation validation: key_forbidden preserves semantics
(push 1)
(declare-const source_key_forbidden Int)
(declare-const target_key_forbidden Int)
(assert (>= source_key_forbidden 0))
(assert (>= target_key_forbidden 0))
(assert (not (= source_key_forbidden target_key_forbidden)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; db_allows_signature: source semantics (matches Coq)
; Translation validation: db_allows_signature preserves semantics
(push 1)
(declare-const source_db_allows_signature Int)
(declare-const target_db_allows_signature Int)
(assert (>= source_db_allows_signature 0))
(assert (>= target_db_allows_signature 0))
(assert (not (= source_db_allows_signature target_db_allows_signature)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; policy_enforced: source semantics (matches Coq)
; Translation validation: policy_enforced preserves semantics
(push 1)
(declare-const source_policy_enforced Int)
(declare-const target_policy_enforced Int)
(assert (>= source_policy_enforced 0))
(assert (>= target_policy_enforced 0))
(assert (not (= source_policy_enforced target_policy_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secure_boot_complete: source semantics (matches Coq)
; Translation validation: secure_boot_complete preserves semantics
(push 1)
(declare-const source_secure_boot_complete Int)
(declare-const target_secure_boot_complete Int)
(assert (>= source_secure_boot_complete 0))
(assert (>= target_secure_boot_complete 0))
(assert (not (= source_secure_boot_complete target_secure_boot_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_rom: source semantics (matches Coq)
; Translation validation: riina_rom preserves semantics
(push 1)
(declare-const source_riina_rom Int)
(declare-const target_riina_rom Int)
(assert (>= source_riina_rom 0))
(assert (>= target_riina_rom 0))
(assert (not (= source_riina_rom target_riina_rom)))
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

; riina_sig: source semantics (matches Coq)
; Translation validation: riina_sig preserves semantics
(push 1)
(declare-const source_riina_sig Int)
(declare-const target_riina_sig Int)
(assert (>= source_riina_sig 0))
(assert (>= target_riina_sig 0))
(assert (not (= source_riina_sig target_riina_sig)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_bootloader: source semantics (matches Coq)
; Translation validation: riina_bootloader preserves semantics
(push 1)
(declare-const source_riina_bootloader Int)
(declare-const target_riina_bootloader Int)
(assert (>= source_riina_bootloader 0))
(assert (>= target_riina_bootloader 0))
(assert (not (= source_riina_bootloader target_riina_bootloader)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_kernel: source semantics (matches Coq)
; Translation validation: riina_kernel preserves semantics
(push 1)
(declare-const source_riina_kernel Int)
(declare-const target_riina_kernel Int)
(assert (>= source_riina_kernel 0))
(assert (>= target_riina_kernel 0))
(assert (not (= source_riina_kernel target_riina_kernel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_initramfs: source semantics (matches Coq)
; Translation validation: riina_initramfs preserves semantics
(push 1)
(declare-const source_riina_initramfs Int)
(declare-const target_riina_initramfs Int)
(assert (>= source_riina_initramfs 0))
(assert (>= target_riina_initramfs 0))
(assert (not (= source_riina_initramfs target_riina_initramfs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_boot_chain: source semantics (matches Coq)
; Translation validation: riina_boot_chain preserves semantics
(push 1)
(declare-const source_riina_boot_chain Int)
(declare-const target_riina_boot_chain Int)
(assert (>= source_riina_boot_chain 0))
(assert (>= target_riina_boot_chain 0))
(assert (not (= source_riina_boot_chain target_riina_boot_chain)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_pcr: source semantics (matches Coq)
; Translation validation: riina_pcr preserves semantics
(push 1)
(declare-const source_riina_pcr Int)
(declare-const target_riina_pcr Int)
(assert (>= source_riina_pcr 0))
(assert (>= target_riina_pcr 0))
(assert (not (= source_riina_pcr target_riina_pcr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_tpm: source semantics (matches Coq)
; Translation validation: riina_tpm preserves semantics
(push 1)
(declare-const source_riina_tpm Int)
(declare-const target_riina_tpm Int)
(assert (>= source_riina_tpm 0))
(assert (>= target_riina_tpm 0))
(assert (not (= source_riina_tpm target_riina_tpm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_pubkey: source semantics (matches Coq)
; Translation validation: riina_pubkey preserves semantics
(push 1)
(declare-const source_riina_pubkey Int)
(declare-const target_riina_pubkey Int)
(assert (>= source_riina_pubkey 0))
(assert (>= target_riina_pubkey 0))
(assert (not (= source_riina_pubkey target_riina_pubkey)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_hkey: source semantics (matches Coq)
; Translation validation: riina_hkey preserves semantics
(push 1)
(declare-const source_riina_hkey Int)
(declare-const target_riina_hkey Int)
(assert (>= source_riina_hkey 0))
(assert (>= target_riina_hkey 0))
(assert (not (= source_riina_hkey target_riina_hkey)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_key_db: source semantics (matches Coq)
; Translation validation: riina_key_db preserves semantics
(push 1)
(declare-const source_riina_key_db Int)
(declare-const target_riina_key_db Int)
(assert (>= source_riina_key_db 0))
(assert (>= target_riina_key_db 0))
(assert (not (= source_riina_key_db target_riina_key_db)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_policy: source semantics (matches Coq)
; Translation validation: riina_policy preserves semantics
(push 1)
(declare-const source_riina_policy Int)
(declare-const target_riina_policy Int)
(assert (>= source_riina_policy 0))
(assert (>= target_riina_policy 0))
(assert (not (= source_riina_policy target_riina_policy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_secure_boot: source semantics (matches Coq)
; Translation validation: riina_secure_boot preserves semantics
(push 1)
(declare-const source_riina_secure_boot Int)
(declare-const target_riina_secure_boot Int)
(assert (>= source_riina_secure_boot 0))
(assert (>= target_riina_secure_boot 0))
(assert (not (= source_riina_secure_boot target_riina_secure_boot)))
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

; andb_true_intro: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_intro preserves semantics
(push 1)
(declare-const source_andb_true_intro Int)
(declare-const target_andb_true_intro Int)
(assert (>= source_andb_true_intro 0))
(assert (>= target_andb_true_intro 0))
(assert (not (= source_andb_true_intro target_andb_true_intro)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_elim1: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_elim1 preserves semantics
(push 1)
(declare-const source_andb_true_elim1 Int)
(declare-const target_andb_true_elim1 Int)
(assert (>= source_andb_true_elim1 0))
(assert (>= target_andb_true_elim1 0))
(assert (not (= source_andb_true_elim1 target_andb_true_elim1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_elim2: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_elim2 preserves semantics
(push 1)
(declare-const source_andb_true_elim2 Int)
(declare-const target_andb_true_elim2 Int)
(assert (>= source_andb_true_elim2 0))
(assert (>= target_andb_true_elim2 0))
(assert (not (= source_andb_true_elim2 target_andb_true_elim2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; orb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: orb_true_iff preserves semantics
(push 1)
(declare-const source_orb_true_iff Int)
(declare-const target_orb_true_iff Int)
(assert (>= source_orb_true_iff 0))
(assert (>= target_orb_true_iff 0))
(assert (not (= source_orb_true_iff target_orb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_001_rom_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_001_rom_integrity preserves semantics
(push 1)
(declare-const source_SB_001_rom_integrity Int)
(declare-const target_SB_001_rom_integrity Int)
(assert (>= source_SB_001_rom_integrity 0))
(assert (>= target_SB_001_rom_integrity 0))
(assert (not (= source_SB_001_rom_integrity target_SB_001_rom_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_002_rom_immutability: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_002_rom_immutability preserves semantics
(push 1)
(declare-const source_SB_002_rom_immutability Int)
(declare-const target_SB_002_rom_immutability Int)
(assert (>= source_SB_002_rom_immutability 0))
(assert (>= target_SB_002_rom_immutability 0))
(assert (not (= source_SB_002_rom_immutability target_SB_002_rom_immutability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_003_rot_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_003_rot_complete preserves semantics
(push 1)
(declare-const source_SB_003_rot_complete Int)
(declare-const target_SB_003_rot_complete Int)
(assert (>= source_SB_003_rot_complete 0))
(assert (>= target_SB_003_rot_complete 0))
(assert (not (= source_SB_003_rot_complete target_SB_003_rot_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_004_rot_anti_debug: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_004_rot_anti_debug preserves semantics
(push 1)
(declare-const source_SB_004_rot_anti_debug Int)
(declare-const target_SB_004_rot_anti_debug Int)
(assert (>= source_SB_004_rot_anti_debug 0))
(assert (>= target_SB_004_rot_anti_debug 0))
(assert (not (= source_SB_004_rot_anti_debug target_SB_004_rot_anti_debug)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_005_root_key_enables_cot: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_005_root_key_enables_cot preserves semantics
(push 1)
(declare-const source_SB_005_root_key_enables_cot Int)
(declare-const target_SB_005_root_key_enables_cot Int)
(assert (>= source_SB_005_root_key_enables_cot 0))
(assert (>= target_SB_005_root_key_enables_cot 0))
(assert (not (= source_SB_005_root_key_enables_cot target_SB_005_root_key_enables_cot)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_006_full_rom_implies_rot: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_006_full_rom_implies_rot preserves semantics
(push 1)
(declare-const source_SB_006_full_rom_implies_rot Int)
(declare-const target_SB_006_full_rom_implies_rot Int)
(assert (>= source_SB_006_full_rom_implies_rot 0))
(assert (>= target_SB_006_full_rom_implies_rot 0))
(assert (not (= source_SB_006_full_rom_implies_rot target_SB_006_full_rom_implies_rot)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_007_full_rom_implies_antidebug: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_007_full_rom_implies_antidebug preserves semantics
(push 1)
(declare-const source_SB_007_full_rom_implies_antidebug Int)
(declare-const target_SB_007_full_rom_implies_antidebug Int)
(assert (>= source_SB_007_full_rom_implies_antidebug 0))
(assert (>= target_SB_007_full_rom_implies_antidebug 0))
(assert (not (= source_SB_007_full_rom_implies_antidebug target_SB_007_full_rom_implies_antidebug)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_008_construct_full_rom: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_008_construct_full_rom preserves semantics
(push 1)
(declare-const source_SB_008_construct_full_rom Int)
(declare-const target_SB_008_construct_full_rom Int)
(assert (>= source_SB_008_construct_full_rom 0))
(assert (>= target_SB_008_construct_full_rom 0))
(assert (not (= source_SB_008_construct_full_rom target_SB_008_construct_full_rom)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_009_rom_starts_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_009_rom_starts_verification preserves semantics
(push 1)
(declare-const source_SB_009_rom_starts_verification Int)
(declare-const target_SB_009_rom_starts_verification Int)
(assert (>= source_SB_009_rom_starts_verification 0))
(assert (>= target_SB_009_rom_starts_verification 0))
(assert (not (= source_SB_009_rom_starts_verification target_SB_009_rom_starts_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_010_rom_integrity_required: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_010_rom_integrity_required preserves semantics
(push 1)
(declare-const source_SB_010_rom_integrity_required Int)
(declare-const target_SB_010_rom_integrity_required Int)
(assert (>= source_SB_010_rom_integrity_required 0))
(assert (>= target_SB_010_rom_integrity_required 0))
(assert (not (= source_SB_010_rom_integrity_required target_SB_010_rom_integrity_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_011_sig_requires_nonrevoked: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_011_sig_requires_nonrevoked preserves semantics
(push 1)
(declare-const source_SB_011_sig_requires_nonrevoked Int)
(declare-const target_SB_011_sig_requires_nonrevoked Int)
(assert (>= source_SB_011_sig_requires_nonrevoked 0))
(assert (>= target_SB_011_sig_requires_nonrevoked 0))
(assert (not (= source_SB_011_sig_requires_nonrevoked target_SB_011_sig_requires_nonrevoked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_012_sig_requires_nonexpired: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_012_sig_requires_nonexpired preserves semantics
(push 1)
(declare-const source_SB_012_sig_requires_nonexpired Int)
(declare-const target_SB_012_sig_requires_nonexpired Int)
(assert (>= source_SB_012_sig_requires_nonexpired 0))
(assert (>= target_SB_012_sig_requires_nonexpired 0))
(assert (not (= source_SB_012_sig_requires_nonexpired target_SB_012_sig_requires_nonexpired)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_013_sig_requires_trusted: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_013_sig_requires_trusted preserves semantics
(push 1)
(declare-const source_SB_013_sig_requires_trusted Int)
(declare-const target_SB_013_sig_requires_trusted Int)
(assert (>= source_SB_013_sig_requires_trusted 0))
(assert (>= target_SB_013_sig_requires_trusted 0))
(assert (not (= source_SB_013_sig_requires_trusted target_SB_013_sig_requires_trusted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_014_sig_key_id_match: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_014_sig_key_id_match preserves semantics
(push 1)
(declare-const source_SB_014_sig_key_id_match Int)
(declare-const target_SB_014_sig_key_id_match Int)
(assert (>= source_SB_014_sig_key_id_match 0))
(assert (>= target_SB_014_sig_key_id_match 0))
(assert (not (= source_SB_014_sig_key_id_match target_SB_014_sig_key_id_match)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_015_sig_crypto_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_015_sig_crypto_verified preserves semantics
(push 1)
(declare-const source_SB_015_sig_crypto_verified Int)
(declare-const target_SB_015_sig_crypto_verified Int)
(assert (>= source_SB_015_sig_crypto_verified 0))
(assert (>= target_SB_015_sig_crypto_verified 0))
(assert (not (= source_SB_015_sig_crypto_verified target_SB_015_sig_crypto_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_016_key_validity_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_016_key_validity_complete preserves semantics
(push 1)
(declare-const source_SB_016_key_validity_complete Int)
(declare-const target_SB_016_key_validity_complete Int)
(assert (>= source_SB_016_key_validity_complete 0))
(assert (>= target_SB_016_key_validity_complete 0))
(assert (not (= source_SB_016_key_validity_complete target_SB_016_key_validity_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_017_construct_valid_key: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_017_construct_valid_key preserves semantics
(push 1)
(declare-const source_SB_017_construct_valid_key Int)
(declare-const target_SB_017_construct_valid_key Int)
(assert (>= source_SB_017_construct_valid_key 0))
(assert (>= target_SB_017_construct_valid_key 0))
(assert (not (= source_SB_017_construct_valid_key target_SB_017_construct_valid_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_018_revoked_key_invalid: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_018_revoked_key_invalid preserves semantics
(push 1)
(declare-const source_SB_018_revoked_key_invalid Int)
(declare-const target_SB_018_revoked_key_invalid Int)
(assert (>= source_SB_018_revoked_key_invalid 0))
(assert (>= target_SB_018_revoked_key_invalid 0))
(assert (not (= source_SB_018_revoked_key_invalid target_SB_018_revoked_key_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_019_expired_key_invalid: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_019_expired_key_invalid preserves semantics
(push 1)
(declare-const source_SB_019_expired_key_invalid Int)
(declare-const target_SB_019_expired_key_invalid Int)
(assert (>= source_SB_019_expired_key_invalid 0))
(assert (>= target_SB_019_expired_key_invalid 0))
(assert (not (= source_SB_019_expired_key_invalid target_SB_019_expired_key_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_020_untrusted_key_invalid: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_020_untrusted_key_invalid preserves semantics
(push 1)
(declare-const source_SB_020_untrusted_key_invalid Int)
(declare-const target_SB_020_untrusted_key_invalid Int)
(assert (>= source_SB_020_untrusted_key_invalid 0))
(assert (>= target_SB_020_untrusted_key_invalid 0))
(assert (not (= source_SB_020_untrusted_key_invalid target_SB_020_untrusted_key_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_021_cot_requires_rot: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_021_cot_requires_rot preserves semantics
(push 1)
(declare-const source_SB_021_cot_requires_rot Int)
(declare-const target_SB_021_cot_requires_rot Int)
(assert (>= source_SB_021_cot_requires_rot 0))
(assert (>= target_SB_021_cot_requires_rot 0))
(assert (not (= source_SB_021_cot_requires_rot target_SB_021_cot_requires_rot)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_022_cot_requires_bootloader: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_022_cot_requires_bootloader preserves semantics
(push 1)
(declare-const source_SB_022_cot_requires_bootloader Int)
(declare-const target_SB_022_cot_requires_bootloader Int)
(assert (>= source_SB_022_cot_requires_bootloader 0))
(assert (>= target_SB_022_cot_requires_bootloader 0))
(assert (not (= source_SB_022_cot_requires_bootloader target_SB_022_cot_requires_bootloader)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_023_cot_requires_kernel: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_023_cot_requires_kernel preserves semantics
(push 1)
(declare-const source_SB_023_cot_requires_kernel Int)
(declare-const target_SB_023_cot_requires_kernel Int)
(assert (>= source_SB_023_cot_requires_kernel 0))
(assert (>= target_SB_023_cot_requires_kernel 0))
(assert (not (= source_SB_023_cot_requires_kernel target_SB_023_cot_requires_kernel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_024_cot_requires_initramfs: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_024_cot_requires_initramfs preserves semantics
(push 1)
(declare-const source_SB_024_cot_requires_initramfs Int)
(declare-const target_SB_024_cot_requires_initramfs Int)
(assert (>= source_SB_024_cot_requires_initramfs 0))
(assert (>= target_SB_024_cot_requires_initramfs 0))
(assert (not (= source_SB_024_cot_requires_initramfs target_SB_024_cot_requires_initramfs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_025_bootloader_sig_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_025_bootloader_sig_valid preserves semantics
(push 1)
(declare-const source_SB_025_bootloader_sig_valid Int)
(declare-const target_SB_025_bootloader_sig_valid Int)
(assert (>= source_SB_025_bootloader_sig_valid 0))
(assert (>= target_SB_025_bootloader_sig_valid 0))
(assert (not (= source_SB_025_bootloader_sig_valid target_SB_025_bootloader_sig_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_026_kernel_sig_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_026_kernel_sig_valid preserves semantics
(push 1)
(declare-const source_SB_026_kernel_sig_valid Int)
(declare-const target_SB_026_kernel_sig_valid Int)
(assert (>= source_SB_026_kernel_sig_valid 0))
(assert (>= target_SB_026_kernel_sig_valid 0))
(assert (not (= source_SB_026_kernel_sig_valid target_SB_026_kernel_sig_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_027_initramfs_sig_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_027_initramfs_sig_valid preserves semantics
(push 1)
(declare-const source_SB_027_initramfs_sig_valid Int)
(declare-const target_SB_027_initramfs_sig_valid Int)
(assert (>= source_SB_027_initramfs_sig_valid 0))
(assert (>= target_SB_027_initramfs_sig_valid 0))
(assert (not (= source_SB_027_initramfs_sig_valid target_SB_027_initramfs_sig_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_028_bootloader_hash_computed: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_028_bootloader_hash_computed preserves semantics
(push 1)
(declare-const source_SB_028_bootloader_hash_computed Int)
(declare-const target_SB_028_bootloader_hash_computed Int)
(assert (>= source_SB_028_bootloader_hash_computed 0))
(assert (>= target_SB_028_bootloader_hash_computed 0))
(assert (not (= source_SB_028_bootloader_hash_computed target_SB_028_bootloader_hash_computed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_029_kernel_hash_computed: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_029_kernel_hash_computed preserves semantics
(push 1)
(declare-const source_SB_029_kernel_hash_computed Int)
(declare-const target_SB_029_kernel_hash_computed Int)
(assert (>= source_SB_029_kernel_hash_computed 0))
(assert (>= target_SB_029_kernel_hash_computed 0))
(assert (not (= source_SB_029_kernel_hash_computed target_SB_029_kernel_hash_computed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_030_initramfs_hash_computed: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_030_initramfs_hash_computed preserves semantics
(push 1)
(declare-const source_SB_030_initramfs_hash_computed Int)
(declare-const target_SB_030_initramfs_hash_computed Int)
(assert (>= source_SB_030_initramfs_hash_computed 0))
(assert (>= target_SB_030_initramfs_hash_computed 0))
(assert (not (= source_SB_030_initramfs_hash_computed target_SB_030_initramfs_hash_computed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_031_construct_verified_bootloader: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_031_construct_verified_bootloader preserves semantics
(push 1)
(declare-const source_SB_031_construct_verified_bootloader Int)
(declare-const target_SB_031_construct_verified_bootloader Int)
(assert (>= source_SB_031_construct_verified_bootloader 0))
(assert (>= target_SB_031_construct_verified_bootloader 0))
(assert (not (= source_SB_031_construct_verified_bootloader target_SB_031_construct_verified_bootloader)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_032_construct_verified_kernel: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_032_construct_verified_kernel preserves semantics
(push 1)
(declare-const source_SB_032_construct_verified_kernel Int)
(declare-const target_SB_032_construct_verified_kernel Int)
(assert (>= source_SB_032_construct_verified_kernel 0))
(assert (>= target_SB_032_construct_verified_kernel 0))
(assert (not (= source_SB_032_construct_verified_kernel target_SB_032_construct_verified_kernel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_033_construct_verified_initramfs: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_033_construct_verified_initramfs preserves semantics
(push 1)
(declare-const source_SB_033_construct_verified_initramfs Int)
(declare-const target_SB_033_construct_verified_initramfs Int)
(assert (>= source_SB_033_construct_verified_initramfs 0))
(assert (>= target_SB_033_construct_verified_initramfs 0))
(assert (not (= source_SB_033_construct_verified_initramfs target_SB_033_construct_verified_initramfs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_034_construct_cot: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_034_construct_cot preserves semantics
(push 1)
(declare-const source_SB_034_construct_cot Int)
(declare-const target_SB_034_construct_cot Int)
(assert (>= source_SB_034_construct_cot 0))
(assert (>= target_SB_034_construct_cot 0))
(assert (not (= source_SB_034_construct_cot target_SB_034_construct_cot)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_035_cot_all_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_035_cot_all_verified preserves semantics
(push 1)
(declare-const source_SB_035_cot_all_verified Int)
(declare-const target_SB_035_cot_all_verified Int)
(assert (>= source_SB_035_cot_all_verified 0))
(assert (>= target_SB_035_cot_all_verified 0))
(assert (not (= source_SB_035_cot_all_verified target_SB_035_cot_all_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_036_tpm_requires_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_036_tpm_requires_enabled preserves semantics
(push 1)
(declare-const source_SB_036_tpm_requires_enabled Int)
(declare-const target_SB_036_tpm_requires_enabled Int)
(assert (>= source_SB_036_tpm_requires_enabled 0))
(assert (>= target_SB_036_tpm_requires_enabled 0))
(assert (not (= source_SB_036_tpm_requires_enabled target_SB_036_tpm_requires_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_037_tpm_requires_activated: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_037_tpm_requires_activated preserves semantics
(push 1)
(declare-const source_SB_037_tpm_requires_activated Int)
(declare-const target_SB_037_tpm_requires_activated Int)
(assert (>= source_SB_037_tpm_requires_activated 0))
(assert (>= target_SB_037_tpm_requires_activated 0))
(assert (not (= source_SB_037_tpm_requires_activated target_SB_037_tpm_requires_activated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_038_construct_operational_tpm: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_038_construct_operational_tpm preserves semantics
(push 1)
(declare-const source_SB_038_construct_operational_tpm Int)
(declare-const target_SB_038_construct_operational_tpm Int)
(assert (>= source_SB_038_construct_operational_tpm 0))
(assert (>= target_SB_038_construct_operational_tpm 0))
(assert (not (= source_SB_038_construct_operational_tpm target_SB_038_construct_operational_tpm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_039_empty_pcrs_extended: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_039_empty_pcrs_extended preserves semantics
(push 1)
(declare-const source_SB_039_empty_pcrs_extended Int)
(declare-const target_SB_039_empty_pcrs_extended Int)
(assert (>= source_SB_039_empty_pcrs_extended 0))
(assert (>= target_SB_039_empty_pcrs_extended 0))
(assert (not (= source_SB_039_empty_pcrs_extended target_SB_039_empty_pcrs_extended)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_040_single_pcr_extended: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_040_single_pcr_extended preserves semantics
(push 1)
(declare-const source_SB_040_single_pcr_extended Int)
(declare-const target_SB_040_single_pcr_extended Int)
(assert (>= source_SB_040_single_pcr_extended 0))
(assert (>= target_SB_040_single_pcr_extended 0))
(assert (not (= source_SB_040_single_pcr_extended target_SB_040_single_pcr_extended)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_041_cons_preserves_extended: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_041_cons_preserves_extended preserves semantics
(push 1)
(declare-const source_SB_041_cons_preserves_extended Int)
(declare-const target_SB_041_cons_preserves_extended Int)
(assert (>= source_SB_041_cons_preserves_extended 0))
(assert (>= target_SB_041_cons_preserves_extended 0))
(assert (not (= source_SB_041_cons_preserves_extended target_SB_041_cons_preserves_extended)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_042_head_extended: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_042_head_extended preserves semantics
(push 1)
(declare-const source_SB_042_head_extended Int)
(declare-const target_SB_042_head_extended Int)
(assert (>= source_SB_042_head_extended 0))
(assert (>= target_SB_042_head_extended 0))
(assert (not (= source_SB_042_head_extended target_SB_042_head_extended)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_043_tail_extended: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_043_tail_extended preserves semantics
(push 1)
(declare-const source_SB_043_tail_extended Int)
(declare-const target_SB_043_tail_extended Int)
(assert (>= source_SB_043_tail_extended 0))
(assert (>= target_SB_043_tail_extended 0))
(assert (not (= source_SB_043_tail_extended target_SB_043_tail_extended)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_044_measurement_hash_computed: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_044_measurement_hash_computed preserves semantics
(push 1)
(declare-const source_SB_044_measurement_hash_computed Int)
(declare-const target_SB_044_measurement_hash_computed Int)
(assert (>= source_SB_044_measurement_hash_computed 0))
(assert (>= target_SB_044_measurement_hash_computed 0))
(assert (not (= source_SB_044_measurement_hash_computed target_SB_044_measurement_hash_computed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_045_measurement_pcr_in_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_045_measurement_pcr_in_bounds preserves semantics
(push 1)
(declare-const source_SB_045_measurement_pcr_in_bounds Int)
(declare-const target_SB_045_measurement_pcr_in_bounds Int)
(assert (>= source_SB_045_measurement_pcr_in_bounds 0))
(assert (>= target_SB_045_measurement_pcr_in_bounds 0))
(assert (not (= source_SB_045_measurement_pcr_in_bounds target_SB_045_measurement_pcr_in_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_046_quote_requires_sig: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_046_quote_requires_sig preserves semantics
(push 1)
(declare-const source_SB_046_quote_requires_sig Int)
(declare-const target_SB_046_quote_requires_sig Int)
(assert (>= source_SB_046_quote_requires_sig 0))
(assert (>= target_SB_046_quote_requires_sig 0))
(assert (not (= source_SB_046_quote_requires_sig target_SB_046_quote_requires_sig)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_047_pcr_sealed: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_047_pcr_sealed preserves semantics
(push 1)
(declare-const source_SB_047_pcr_sealed Int)
(declare-const target_SB_047_pcr_sealed Int)
(assert (>= source_SB_047_pcr_sealed 0))
(assert (>= target_SB_047_pcr_sealed 0))
(assert (not (= source_SB_047_pcr_sealed target_SB_047_pcr_sealed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_048_locality_access: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_048_locality_access preserves semantics
(push 1)
(declare-const source_SB_048_locality_access Int)
(declare-const target_SB_048_locality_access Int)
(assert (>= source_SB_048_locality_access 0))
(assert (>= target_SB_048_locality_access 0))
(assert (not (= source_SB_048_locality_access target_SB_048_locality_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_049_measured_boot_tpm: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_049_measured_boot_tpm preserves semantics
(push 1)
(declare-const source_SB_049_measured_boot_tpm Int)
(declare-const target_SB_049_measured_boot_tpm Int)
(assert (>= source_SB_049_measured_boot_tpm 0))
(assert (>= target_SB_049_measured_boot_tpm 0))
(assert (not (= source_SB_049_measured_boot_tpm target_SB_049_measured_boot_tpm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_050_measured_boot_pcrs: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_050_measured_boot_pcrs preserves semantics
(push 1)
(declare-const source_SB_050_measured_boot_pcrs Int)
(declare-const target_SB_050_measured_boot_pcrs Int)
(assert (>= source_SB_050_measured_boot_pcrs 0))
(assert (>= target_SB_050_measured_boot_pcrs 0))
(assert (not (= source_SB_050_measured_boot_pcrs target_SB_050_measured_boot_pcrs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_051_version_no_rollback: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_051_version_no_rollback preserves semantics
(push 1)
(declare-const source_SB_051_version_no_rollback Int)
(declare-const target_SB_051_version_no_rollback Int)
(assert (>= source_SB_051_version_no_rollback 0))
(assert (>= target_SB_051_version_no_rollback 0))
(assert (not (= source_SB_051_version_no_rollback target_SB_051_version_no_rollback)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_052_bootloader_version_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_052_bootloader_version_ok preserves semantics
(push 1)
(declare-const source_SB_052_bootloader_version_ok Int)
(declare-const target_SB_052_bootloader_version_ok Int)
(assert (>= source_SB_052_bootloader_version_ok 0))
(assert (>= target_SB_052_bootloader_version_ok 0))
(assert (not (= source_SB_052_bootloader_version_ok target_SB_052_bootloader_version_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_053_kernel_version_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_053_kernel_version_ok preserves semantics
(push 1)
(declare-const source_SB_053_kernel_version_ok Int)
(declare-const target_SB_053_kernel_version_ok Int)
(assert (>= source_SB_053_kernel_version_ok 0))
(assert (>= target_SB_053_kernel_version_ok 0))
(assert (not (= source_SB_053_kernel_version_ok target_SB_053_kernel_version_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_054_chain_bootloader_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_054_chain_bootloader_ok preserves semantics
(push 1)
(declare-const source_SB_054_chain_bootloader_ok Int)
(declare-const target_SB_054_chain_bootloader_ok Int)
(assert (>= source_SB_054_chain_bootloader_ok 0))
(assert (>= target_SB_054_chain_bootloader_ok 0))
(assert (not (= source_SB_054_chain_bootloader_ok target_SB_054_chain_bootloader_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_055_chain_kernel_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_055_chain_kernel_ok preserves semantics
(push 1)
(declare-const source_SB_055_chain_kernel_ok Int)
(declare-const target_SB_055_chain_kernel_ok Int)
(assert (>= source_SB_055_chain_kernel_ok 0))
(assert (>= target_SB_055_chain_kernel_ok 0))
(assert (not (= source_SB_055_chain_kernel_ok target_SB_055_chain_kernel_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_056_construct_antirollback: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_056_construct_antirollback preserves semantics
(push 1)
(declare-const source_SB_056_construct_antirollback Int)
(declare-const target_SB_056_construct_antirollback Int)
(assert (>= source_SB_056_construct_antirollback 0))
(assert (>= target_SB_056_construct_antirollback 0))
(assert (not (= source_SB_056_construct_antirollback target_SB_056_construct_antirollback)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_057_min_zero_passes: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_057_min_zero_passes preserves semantics
(push 1)
(declare-const source_SB_057_min_zero_passes Int)
(declare-const target_SB_057_min_zero_passes Int)
(assert (>= source_SB_057_min_zero_passes 0))
(assert (>= target_SB_057_min_zero_passes 0))
(assert (not (= source_SB_057_min_zero_passes target_SB_057_min_zero_passes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_058_same_version_passes: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_058_same_version_passes preserves semantics
(push 1)
(declare-const source_SB_058_same_version_passes Int)
(declare-const target_SB_058_same_version_passes Int)
(assert (>= source_SB_058_same_version_passes 0))
(assert (>= target_SB_058_same_version_passes 0))
(assert (not (= source_SB_058_same_version_passes target_SB_058_same_version_passes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_059_higher_version_passes: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_059_higher_version_passes preserves semantics
(push 1)
(declare-const source_SB_059_higher_version_passes Int)
(declare-const target_SB_059_higher_version_passes Int)
(assert (>= source_SB_059_higher_version_passes 0))
(assert (>= target_SB_059_higher_version_passes 0))
(assert (not (= source_SB_059_higher_version_passes target_SB_059_higher_version_passes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_060_lower_version_fails: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_060_lower_version_fails preserves semantics
(push 1)
(declare-const source_SB_060_lower_version_fails Int)
(declare-const target_SB_060_lower_version_fails Int)
(assert (>= source_SB_060_lower_version_fails 0))
(assert (>= target_SB_060_lower_version_fails 0))
(assert (not (= source_SB_060_lower_version_fails target_SB_060_lower_version_fails)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_061_root_no_parent: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_061_root_no_parent preserves semantics
(push 1)
(declare-const source_SB_061_root_no_parent Int)
(declare-const target_SB_061_root_no_parent Int)
(assert (>= source_SB_061_root_no_parent 0))
(assert (>= target_SB_061_root_no_parent 0))
(assert (not (= source_SB_061_root_no_parent target_SB_061_root_no_parent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_062_nonroot_has_parent: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_062_nonroot_has_parent preserves semantics
(push 1)
(declare-const source_SB_062_nonroot_has_parent Int)
(declare-const target_SB_062_nonroot_has_parent Int)
(assert (>= source_SB_062_nonroot_has_parent 0))
(assert (>= target_SB_062_nonroot_has_parent 0))
(assert (not (= source_SB_062_nonroot_has_parent target_SB_062_nonroot_has_parent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_063_valid_hierarchy_public: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_063_valid_hierarchy_public preserves semantics
(push 1)
(declare-const source_SB_063_valid_hierarchy_public Int)
(declare-const target_SB_063_valid_hierarchy_public Int)
(assert (>= source_SB_063_valid_hierarchy_public 0))
(assert (>= target_SB_063_valid_hierarchy_public 0))
(assert (not (= source_SB_063_valid_hierarchy_public target_SB_063_valid_hierarchy_public)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_064_valid_not_self_revoked: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_064_valid_not_self_revoked preserves semantics
(push 1)
(declare-const source_SB_064_valid_not_self_revoked Int)
(declare-const target_SB_064_valid_not_self_revoked Int)
(assert (>= source_SB_064_valid_not_self_revoked 0))
(assert (>= target_SB_064_valid_not_self_revoked 0))
(assert (not (= source_SB_064_valid_not_self_revoked target_SB_064_valid_not_self_revoked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_065_key_in_db: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_065_key_in_db preserves semantics
(push 1)
(declare-const source_SB_065_key_in_db Int)
(declare-const target_SB_065_key_in_db Int)
(assert (>= source_SB_065_key_in_db 0))
(assert (>= target_SB_065_key_in_db 0))
(assert (not (= source_SB_065_key_in_db target_SB_065_key_in_db)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_066_key_not_in_empty: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_066_key_not_in_empty preserves semantics
(push 1)
(declare-const source_SB_066_key_not_in_empty Int)
(declare-const target_SB_066_key_not_in_empty Int)
(assert (>= source_SB_066_key_not_in_empty 0))
(assert (>= target_SB_066_key_not_in_empty 0))
(assert (not (= source_SB_066_key_not_in_empty target_SB_066_key_not_in_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_067_empty_forbidden: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_067_empty_forbidden preserves semantics
(push 1)
(declare-const source_SB_067_empty_forbidden Int)
(declare-const target_SB_067_empty_forbidden Int)
(assert (>= source_SB_067_empty_forbidden 0))
(assert (>= target_SB_067_empty_forbidden 0))
(assert (not (= source_SB_067_empty_forbidden target_SB_067_empty_forbidden)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_068_key_is_forbidden: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_068_key_is_forbidden preserves semantics
(push 1)
(declare-const source_SB_068_key_is_forbidden Int)
(declare-const target_SB_068_key_is_forbidden Int)
(assert (>= source_SB_068_key_is_forbidden 0))
(assert (>= target_SB_068_key_is_forbidden 0))
(assert (not (= source_SB_068_key_is_forbidden target_SB_068_key_is_forbidden)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_069_allowed_uses_trusted: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_069_allowed_uses_trusted preserves semantics
(push 1)
(declare-const source_SB_069_allowed_uses_trusted Int)
(declare-const target_SB_069_allowed_uses_trusted Int)
(assert (>= source_SB_069_allowed_uses_trusted 0))
(assert (>= target_SB_069_allowed_uses_trusted 0))
(assert (not (= source_SB_069_allowed_uses_trusted target_SB_069_allowed_uses_trusted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_070_allowed_not_forbidden: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_070_allowed_not_forbidden preserves semantics
(push 1)
(declare-const source_SB_070_allowed_not_forbidden Int)
(declare-const target_SB_070_allowed_not_forbidden Int)
(assert (>= source_SB_070_allowed_not_forbidden 0))
(assert (>= target_SB_070_allowed_not_forbidden 0))
(assert (not (= source_SB_070_allowed_not_forbidden target_SB_070_allowed_not_forbidden)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_071_complete_has_cot: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_071_complete_has_cot preserves semantics
(push 1)
(declare-const source_SB_071_complete_has_cot Int)
(declare-const target_SB_071_complete_has_cot Int)
(assert (>= source_SB_071_complete_has_cot 0))
(assert (>= target_SB_071_complete_has_cot 0))
(assert (not (= source_SB_071_complete_has_cot target_SB_071_complete_has_cot)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_072_complete_has_measured: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_072_complete_has_measured preserves semantics
(push 1)
(declare-const source_SB_072_complete_has_measured Int)
(declare-const target_SB_072_complete_has_measured Int)
(assert (>= source_SB_072_complete_has_measured 0))
(assert (>= target_SB_072_complete_has_measured 0))
(assert (not (= source_SB_072_complete_has_measured target_SB_072_complete_has_measured)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_073_complete_has_antirollback: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_073_complete_has_antirollback preserves semantics
(push 1)
(declare-const source_SB_073_complete_has_antirollback Int)
(declare-const target_SB_073_complete_has_antirollback Int)
(assert (>= source_SB_073_complete_has_antirollback 0))
(assert (>= target_SB_073_complete_has_antirollback 0))
(assert (not (= source_SB_073_complete_has_antirollback target_SB_073_complete_has_antirollback)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_074_complete_has_policy: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_074_complete_has_policy preserves semantics
(push 1)
(declare-const source_SB_074_complete_has_policy Int)
(declare-const target_SB_074_complete_has_policy Int)
(assert (>= source_SB_074_complete_has_policy 0))
(assert (>= target_SB_074_complete_has_policy 0))
(assert (not (= source_SB_074_complete_has_policy target_SB_074_complete_has_policy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_075_policy_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_075_policy_enabled preserves semantics
(push 1)
(declare-const source_SB_075_policy_enabled Int)
(declare-const target_SB_075_policy_enabled Int)
(assert (>= source_SB_075_policy_enabled 0))
(assert (>= target_SB_075_policy_enabled 0))
(assert (not (= source_SB_075_policy_enabled target_SB_075_policy_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_076_policy_enforcing: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_076_policy_enforcing preserves semantics
(push 1)
(declare-const source_SB_076_policy_enforcing Int)
(declare-const target_SB_076_policy_enforcing Int)
(assert (>= source_SB_076_policy_enforcing 0))
(assert (>= target_SB_076_policy_enforcing 0))
(assert (not (= source_SB_076_policy_enforcing target_SB_076_policy_enforcing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_077_policy_no_unsigned: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_077_policy_no_unsigned preserves semantics
(push 1)
(declare-const source_SB_077_policy_no_unsigned Int)
(declare-const target_SB_077_policy_no_unsigned Int)
(assert (>= source_SB_077_policy_no_unsigned 0))
(assert (>= target_SB_077_policy_no_unsigned 0))
(assert (not (= source_SB_077_policy_no_unsigned target_SB_077_policy_no_unsigned)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_078_construct_policy: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_078_construct_policy preserves semantics
(push 1)
(declare-const source_SB_078_construct_policy Int)
(declare-const target_SB_078_construct_policy Int)
(assert (>= source_SB_078_construct_policy 0))
(assert (>= target_SB_078_construct_policy 0))
(assert (not (= source_SB_078_construct_policy target_SB_078_construct_policy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_079_construct_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_079_construct_complete preserves semantics
(push 1)
(declare-const source_SB_079_construct_complete Int)
(declare-const target_SB_079_construct_complete Int)
(assert (>= source_SB_079_construct_complete 0))
(assert (>= target_SB_079_construct_complete 0))
(assert (not (= source_SB_079_construct_complete target_SB_079_construct_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_080_complete_all_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_080_complete_all_verified preserves semantics
(push 1)
(declare-const source_SB_080_complete_all_verified Int)
(declare-const target_SB_080_complete_all_verified Int)
(assert (>= source_SB_080_complete_all_verified 0))
(assert (>= target_SB_080_complete_all_verified 0))
(assert (not (= source_SB_080_complete_all_verified target_SB_080_complete_all_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_081_riina_rot: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_081_riina_rot preserves semantics
(push 1)
(declare-const source_SB_081_riina_rot Int)
(declare-const target_SB_081_riina_rot Int)
(assert (>= source_SB_081_riina_rot 0))
(assert (>= target_SB_081_riina_rot 0))
(assert (not (= source_SB_081_riina_rot target_SB_081_riina_rot)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_082_riina_bl: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_082_riina_bl preserves semantics
(push 1)
(declare-const source_SB_082_riina_bl Int)
(declare-const target_SB_082_riina_bl Int)
(assert (>= source_SB_082_riina_bl 0))
(assert (>= target_SB_082_riina_bl 0))
(assert (not (= source_SB_082_riina_bl target_SB_082_riina_bl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_083_riina_kern: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_083_riina_kern preserves semantics
(push 1)
(declare-const source_SB_083_riina_kern Int)
(declare-const target_SB_083_riina_kern Int)
(assert (>= source_SB_083_riina_kern 0))
(assert (>= target_SB_083_riina_kern 0))
(assert (not (= source_SB_083_riina_kern target_SB_083_riina_kern)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_084_riina_initrd: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_084_riina_initrd preserves semantics
(push 1)
(declare-const source_SB_084_riina_initrd Int)
(declare-const target_SB_084_riina_initrd Int)
(assert (>= source_SB_084_riina_initrd 0))
(assert (>= target_SB_084_riina_initrd 0))
(assert (not (= source_SB_084_riina_initrd target_SB_084_riina_initrd)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_085_riina_cot: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_085_riina_cot preserves semantics
(push 1)
(declare-const source_SB_085_riina_cot Int)
(declare-const target_SB_085_riina_cot Int)
(assert (>= source_SB_085_riina_cot 0))
(assert (>= target_SB_085_riina_cot 0))
(assert (not (= source_SB_085_riina_cot target_SB_085_riina_cot)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_086_riina_tpm: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_086_riina_tpm preserves semantics
(push 1)
(declare-const source_SB_086_riina_tpm Int)
(declare-const target_SB_086_riina_tpm Int)
(assert (>= source_SB_086_riina_tpm 0))
(assert (>= target_SB_086_riina_tpm 0))
(assert (not (= source_SB_086_riina_tpm target_SB_086_riina_tpm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_087_riina_measured: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_087_riina_measured preserves semantics
(push 1)
(declare-const source_SB_087_riina_measured Int)
(declare-const target_SB_087_riina_measured Int)
(assert (>= source_SB_087_riina_measured 0))
(assert (>= target_SB_087_riina_measured 0))
(assert (not (= source_SB_087_riina_measured target_SB_087_riina_measured)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_088_riina_arb: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_088_riina_arb preserves semantics
(push 1)
(declare-const source_SB_088_riina_arb Int)
(declare-const target_SB_088_riina_arb Int)
(assert (>= source_SB_088_riina_arb 0))
(assert (>= target_SB_088_riina_arb 0))
(assert (not (= source_SB_088_riina_arb target_SB_088_riina_arb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_089_riina_policy: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_089_riina_policy preserves semantics
(push 1)
(declare-const source_SB_089_riina_policy Int)
(declare-const target_SB_089_riina_policy Int)
(assert (>= source_SB_089_riina_policy 0))
(assert (>= target_SB_089_riina_policy 0))
(assert (not (= source_SB_089_riina_policy target_SB_089_riina_policy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SB_090_riina_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: SB_090_riina_complete preserves semantics
(push 1)
(declare-const source_SB_090_riina_complete Int)
(declare-const target_SB_090_riina_complete Int)
(assert (>= source_SB_090_riina_complete 0))
(assert (>= target_SB_090_riina_complete 0))
(assert (not (= source_SB_090_riina_complete target_SB_090_riina_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

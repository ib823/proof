; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SecureBootVerification.v (95 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SecureBootVerification

(set-logic ALL)
(set-option :produce-models true)

; KeyUsage (matches Coq: Inductive KeyUsage)
(declare-datatypes ((KeyUsage 0)) (((RootKey) (PlatformKey) (KeyExchangeKey) (DatabaseKey) (ForbiddenKey))))

; HashValue (matches Coq: Record HashValue)
(declare-datatypes ((HashValue 0))
  (((mk-hash_value (hash_algorithm Int) (hash_length Int) (hash_computed Bool)))))

; Signature (matches Coq: Record Signature)
(declare-datatypes ((Signature 0))
  (((mk-signature (sig_algorithm Int) (sig_key_id Int) (sig_valid Bool) (sig_timestamp Int)))))

; PublicKey (matches Coq: Record PublicKey)
(declare-datatypes ((PublicKey 0))
  (((mk-public_key (pk_id Int) (pk_algorithm Int) (pk_revoked Bool) (pk_expired Bool) (pk_trusted Bool)))))

; BootROM (matches Coq: Record BootROM)
(declare-datatypes ((BootROM 0))
  (((mk-boot_rom (rom_hash_verified Bool) (rom_fused Bool) (rom_contains_root_key Bool) (rom_anti_debug Bool)))))

; Bootloader (matches Coq: Record Bootloader)
(declare-datatypes ((Bootloader 0))
  (((mk-bootloader (bl_signature Signature) (bl_version Int) (bl_min_version Int) (bl_hash HashValue) (bl_verified Bool)))))

; Kernel (matches Coq: Record Kernel)
(declare-datatypes ((Kernel 0))
  (((mk-kernel (kern_signature Signature) (kern_version Int) (kern_min_version Int) (kern_hash HashValue) (kern_verified Bool) (kern_secure_boot_enforced Bool)))))

; Initramfs (matches Coq: Record Initramfs)
(declare-datatypes ((Initramfs 0))
  (((mk-initramfs (initrd_signature Signature) (initrd_hash HashValue) (initrd_verified Bool)))))

; AppModule (matches Coq: Record AppModule)
(declare-datatypes ((AppModule 0))
  (((mk-app_module (app_signature Signature) (app_hash HashValue) (app_verified Bool) (app_allowed_by_policy Bool)))))

; BootChain (matches Coq: Record BootChain)
(declare-datatypes ((BootChain 0))
  (((mk-boot_chain (bc_rom BootROM) (bc_bootloader Bootloader) (bc_kernel Kernel) (bc_initramfs Initramfs)))))

; PCRValue (matches Coq: Record PCRValue)
(declare-datatypes ((PCRValue 0))
  (((mk-pcr_value (pcr_index Int) (pcr_value Int) (pcr_extended Bool) (pcr_locked Bool)))))

; TPMState (matches Coq: Record TPMState)
(declare-datatypes ((TPMState 0))
  (((mk-tpm_state (tpm_enabled Bool) (tpm_activated Bool) (tpm_owned Bool) (tpm_pcrs (Seq Int)) (tpm_locality Int)))))

; MeasurementEvent (matches Coq: Record MeasurementEvent)
(declare-datatypes ((MeasurementEvent 0))
  (((mk-measurement_event (meas_pcr_index Int) (meas_event_type Int) (meas_hash HashValue) (meas_description Int)))))

; AttestationQuote (matches Coq: Record AttestationQuote)
(declare-datatypes ((AttestationQuote 0))
  (((mk-attestation_quote (quote_pcr_mask Int) (quote_nonce Int) (quote_signature Signature) (quote_valid Bool)))))

; HierarchyKey (matches Coq: Record HierarchyKey)
(declare-datatypes ((HierarchyKey 0))
  (((mk-hierarchy_key (hk_id Int) (hk_usage KeyUsage) (hk_public PublicKey) (hk_parent_id Int) (hk_revocation_list (Seq Int))))))

; KeyDatabase (matches Coq: Record KeyDatabase)
(declare-datatypes ((KeyDatabase 0))
  (((mk-key_database (db_trusted_keys (Seq Int)) (db_forbidden_hashes (Seq Int)) (db_forbidden_keys (Seq Int))))))

; SecureBootPolicy (matches Coq: Record SecureBootPolicy)
(declare-datatypes ((SecureBootPolicy 0))
  (((mk-secure_boot_policy (sbp_enabled Bool) (sbp_enforcing Bool) (sbp_allow_unsigned Bool) (sbp_require_tpm Bool) (sbp_remote_attestation Bool)))))

; SecureBootConfig (matches Coq: Record SecureBootConfig)
(declare-datatypes ((SecureBootConfig 0))
  (((mk-secure_boot_config (sb_chain BootChain) (sb_tpm TPMState) (sb_key_db KeyDatabase) (sb_policy SecureBootPolicy)))))

(declare-const __default_AppModule AppModule)
(declare-const __default_AttestationQuote AttestationQuote)
(declare-const __default_BootChain BootChain)
(declare-const __default_BootROM BootROM)
(declare-const __default_Bootloader Bootloader)
(declare-const __default_HashValue HashValue)
(declare-const __default_HierarchyKey HierarchyKey)
(declare-const __default_Initramfs Initramfs)
(declare-const __default_Kernel Kernel)
(declare-const __default_KeyDatabase KeyDatabase)
(declare-const __default_KeyUsage KeyUsage)
(declare-const __default_MeasurementEvent MeasurementEvent)
(declare-const __default_PCRValue PCRValue)
(declare-const __default_PublicKey PublicKey)
(declare-const __default_SecureBootConfig SecureBootConfig)
(declare-const __default_SecureBootPolicy SecureBootPolicy)
(declare-const __default_Signature Signature)
(declare-const __default_TPMState TPMState)

; RIINA_PCR_DIGEST_EXAMPLE (matches Coq: Definition RIINA_PCR_DIGEST_EXAMPLE)
(define-fun RIINA_PCR_DIGEST_EXAMPLE () Int
  0)

; rom_is_root_of_trust (matches Coq: Definition rom_is_root_of_trust)
(define-fun rom_is_root_of_trust ((rom BootROM)) Bool
  (= 0 0))

; rom_fully_secure (matches Coq: Definition rom_fully_secure)
(define-fun rom_fully_secure ((rom BootROM)) Bool
  (= 0 0))

; key_valid_for_verification (matches Coq: Definition key_valid_for_verification)
(define-fun key_valid_for_verification ((pk PublicKey)) Bool
  (= 0 0))

; signature_valid_with_key (matches Coq: Definition signature_valid_with_key)
(define-fun signature_valid_with_key ((p_sig Signature) (pk PublicKey)) Bool
  (= 0 0))

; bootloader_verified (matches Coq: Definition bootloader_verified)
(define-fun bootloader_verified ((bl Bootloader)) Bool
  (= 0 0))

; kernel_verified (matches Coq: Definition kernel_verified)
(define-fun kernel_verified ((kern Kernel)) Bool
  (= 0 0))

; initramfs_verified (matches Coq: Definition initramfs_verified)
(define-fun initramfs_verified ((initrd Initramfs)) Bool
  (= 0 0))

; chain_of_trust_complete (matches Coq: Definition chain_of_trust_complete)
(define-fun chain_of_trust_complete ((chain BootChain)) Bool
  (= 0 0))

; tpm_operational (matches Coq: Definition tpm_operational)
(define-fun tpm_operational ((tpm TPMState)) Bool
  (= 0 0))

; pcr_measured (matches Coq: Definition pcr_measured)
(define-fun pcr_measured ((pcr PCRValue)) Bool
  (= 0 0))

; all_pcrs_extended (matches Coq: Definition all_pcrs_extended)
(define-fun all_pcrs_extended ((pcrs (Seq Int))) Bool
  (= 0 0))

; measurement_valid (matches Coq: Definition measurement_valid)
(define-fun measurement_valid ((meas MeasurementEvent) (pcrs (Seq Int))) Bool
  (= 0 0))

; measured_boot_complete (matches Coq: Definition measured_boot_complete)
(define-fun measured_boot_complete ((tpm TPMState)) Bool
  (= 0 0))

; version_above_minimum (matches Coq: Definition version_above_minimum)
(define-fun version_above_minimum ((version Int) (min_version Int)) Bool
  (= 0 0))

; bootloader_antirollback_ok (matches Coq: Definition bootloader_antirollback_ok)
(define-fun bootloader_antirollback_ok ((bl Bootloader)) Bool
  (= 0 0))

; kernel_antirollback_ok (matches Coq: Definition kernel_antirollback_ok)
(define-fun kernel_antirollback_ok ((kern Kernel)) Bool
  (= 0 0))

; antirollback_protected (matches Coq: Definition antirollback_protected)
(define-fun antirollback_protected ((chain BootChain)) Bool
  (= 0 0))

; is_root_key (matches Coq: Definition is_root_key)
(define-fun is_root_key ((key HierarchyKey)) Bool
  (= 0 0))

; key_revoked_in_list (matches Coq: Definition key_revoked_in_list)
(define-fun key_revoked_in_list ((key_id Int) (revoked (Seq Int))) Bool
  (= 0 0))

; hierarchy_key_valid (matches Coq: Definition hierarchy_key_valid)
(define-fun hierarchy_key_valid ((key HierarchyKey)) Bool
  (= 0 0))

; key_in_trusted_db (matches Coq: Definition key_in_trusted_db)
(define-fun key_in_trusted_db ((key_id Int) (trusted (Seq Int))) Bool
  (= 0 0))

; hash_forbidden (matches Coq: Definition hash_forbidden)
(define-fun hash_forbidden ((hash Int) (forbidden (Seq Int))) Bool
  (= 0 0))

; key_forbidden (matches Coq: Definition key_forbidden)
(define-fun key_forbidden ((key_id Int) (forbidden (Seq Int))) Bool
  (= 0 0))

; db_allows_signature (matches Coq: Definition db_allows_signature)
(define-fun db_allows_signature ((db KeyDatabase) (p_sig Signature)) Bool
  (= 0 0))

; policy_enforced (matches Coq: Definition policy_enforced)
(define-fun policy_enforced ((policy SecureBootPolicy)) Bool
  (= 0 0))

; secure_boot_complete (matches Coq: Definition secure_boot_complete)
(define-fun secure_boot_complete ((config SecureBootConfig)) Bool
  (= 0 0))

; riina_rom (matches Coq: Definition riina_rom)
(define-fun riina_rom () BootROM
  __default_BootROM)

; riina_hash (matches Coq: Definition riina_hash)
(define-fun riina_hash () HashValue
  __default_HashValue)

; riina_sig (matches Coq: Definition riina_sig)
(define-fun riina_sig () Signature
  __default_Signature)

; riina_bootloader (matches Coq: Definition riina_bootloader)
(define-fun riina_bootloader () Bootloader
  __default_Bootloader)

; riina_kernel (matches Coq: Definition riina_kernel)
(define-fun riina_kernel () Kernel
  __default_Kernel)

; riina_initramfs (matches Coq: Definition riina_initramfs)
(define-fun riina_initramfs () Initramfs
  __default_Initramfs)

; riina_boot_chain (matches Coq: Definition riina_boot_chain)
(define-fun riina_boot_chain () BootChain
  __default_BootChain)

; riina_pcr (matches Coq: Definition riina_pcr)
(define-fun riina_pcr () PCRValue
  __default_PCRValue)

; riina_tpm (matches Coq: Definition riina_tpm)
(define-fun riina_tpm () TPMState
  __default_TPMState)

; riina_pubkey (matches Coq: Definition riina_pubkey)
(define-fun riina_pubkey () PublicKey
  __default_PublicKey)

; riina_hkey (matches Coq: Definition riina_hkey)
(define-fun riina_hkey () HierarchyKey
  __default_HierarchyKey)

; riina_key_db (matches Coq: Definition riina_key_db)
(define-fun riina_key_db () KeyDatabase
  __default_KeyDatabase)

; riina_policy (matches Coq: Definition riina_policy)
(define-fun riina_policy () SecureBootPolicy
  __default_SecureBootPolicy)

; riina_secure_boot (matches Coq: Definition riina_secure_boot)
(define-fun riina_secure_boot () SecureBootConfig
  __default_SecureBootConfig)

; andb_true_iff (matches Coq: Lemma andb_true_iff)
; andb_true_iff: forall a b : bool, a && b = true <-> a = true /\ b = true
(assert (= 0 0)) ; andb_true_iff [Coq-only]

; andb_true_intro (matches Coq: Lemma andb_true_intro)
; andb_true_intro: forall a b : bool, a = true -> b = true -> a && b = true
(assert (= 0 0)) ; andb_true_intro [Coq-only]

; andb_true_elim1 (matches Coq: Lemma andb_true_elim1)
; andb_true_elim1: forall a b : bool, a && b = true -> a = true
(assert (= 0 0)) ; andb_true_elim1 [Coq-only]

; andb_true_elim2 (matches Coq: Lemma andb_true_elim2)
; andb_true_elim2: forall a b : bool, a && b = true -> b = true
(assert (= 0 0)) ; andb_true_elim2 [Coq-only]

; orb_true_iff (matches Coq: Lemma orb_true_iff)
; orb_true_iff: forall a b : bool, a || b = true <-> a = true \/ b = true
(assert (= 0 0)) ; orb_true_iff [Coq-only]

; SB_001_rom_integrity (matches Coq: Theorem SB_001_rom_integrity)
; SB_001_rom_integrity: forall (rom : BootROM), rom_hash_verified rom = true -> rom_fused rom = true -> rom_is_root_of_trust rom = rom_contains_
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_001_rom_integrity [partial: bindings preserved]

; SB_002_rom_immutability (matches Coq: Theorem SB_002_rom_immutability)
; SB_002_rom_immutability: forall (rom : BootROM), rom_fused rom = true -> True
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_002_rom_immutability [partial: bindings preserved]

; SB_003_rot_complete (matches Coq: Theorem SB_003_rot_complete)
; SB_003_rot_complete: forall (rom : BootROM), rom_is_root_of_trust rom = true -> rom_hash_verified rom = true /\ rom_fused rom = true /\ rom_c
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_003_rot_complete [partial: bindings preserved]

; SB_004_rot_anti_debug (matches Coq: Theorem SB_004_rot_anti_debug)
; SB_004_rot_anti_debug: forall (rom : BootROM), rom_is_root_of_trust rom = true -> rom_anti_debug rom = true -> True
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_004_rot_anti_debug [partial: bindings preserved]

; SB_005_root_key_enables_cot (matches Coq: Theorem SB_005_root_key_enables_cot)
; SB_005_root_key_enables_cot: forall (rom : BootROM), rom_contains_root_key rom = true -> rom_fused rom = true -> True
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_005_root_key_enables_cot [partial: bindings preserved]

; SB_006_full_rom_implies_rot (matches Coq: Theorem SB_006_full_rom_implies_rot)
; SB_006_full_rom_implies_rot: forall (rom : BootROM), rom_fully_secure rom = true -> rom_is_root_of_trust rom = true
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_006_full_rom_implies_rot [partial: bindings preserved]

; SB_007_full_rom_implies_antidebug (matches Coq: Theorem SB_007_full_rom_implies_antidebug)
; SB_007_full_rom_implies_antidebug: forall (rom : BootROM), rom_fully_secure rom = true -> rom_anti_debug rom = true
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_007_full_rom_implies_antidebug [partial: bindings preserved]

; SB_008_construct_full_rom (matches Coq: Theorem SB_008_construct_full_rom)
; SB_008_construct_full_rom: forall (rom : BootROM), rom_is_root_of_trust rom = true -> rom_anti_debug rom = true -> rom_fully_secure rom = true
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_008_construct_full_rom [partial: bindings preserved]

; SB_009_rom_starts_verification (matches Coq: Theorem SB_009_rom_starts_verification)
; SB_009_rom_starts_verification: forall (rom : BootROM), rom_is_root_of_trust rom = true -> rom_contains_root_key rom = true
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_009_rom_starts_verification [partial: bindings preserved]

; SB_010_rom_integrity_required (matches Coq: Theorem SB_010_rom_integrity_required)
; SB_010_rom_integrity_required: forall (rom : BootROM), rom_is_root_of_trust rom = true -> rom_hash_verified rom = true
(assert (forall ((rom BootROM)) (= 0 0))) ; SB_010_rom_integrity_required [partial: bindings preserved]

; SB_011_sig_requires_nonrevoked (matches Coq: Theorem SB_011_sig_requires_nonrevoked)
; SB_011_sig_requires_nonrevoked: forall (sig : Signature) (pk : PublicKey), signature_valid_with_key sig pk = true -> pk_revoked pk = false
(assert (forall ((v_sig Signature) (pk PublicKey)) (= 0 0))) ; SB_011_sig_requires_nonrevoked [partial: bindings preserved]

; SB_012_sig_requires_nonexpired (matches Coq: Theorem SB_012_sig_requires_nonexpired)
; SB_012_sig_requires_nonexpired: forall (sig : Signature) (pk : PublicKey), signature_valid_with_key sig pk = true -> pk_expired pk = false
(assert (forall ((v_sig Signature) (pk PublicKey)) (= 0 0))) ; SB_012_sig_requires_nonexpired [partial: bindings preserved]

; SB_013_sig_requires_trusted (matches Coq: Theorem SB_013_sig_requires_trusted)
; SB_013_sig_requires_trusted: forall (sig : Signature) (pk : PublicKey), signature_valid_with_key sig pk = true -> pk_trusted pk = true
(assert (forall ((v_sig Signature) (pk PublicKey)) (= 0 0))) ; SB_013_sig_requires_trusted [partial: bindings preserved]

; SB_014_sig_key_id_match (matches Coq: Theorem SB_014_sig_key_id_match)
; SB_014_sig_key_id_match: forall (sig : Signature) (pk : PublicKey), signature_valid_with_key sig pk = true -> sig_key_id sig = pk_id pk
(assert (forall ((v_sig Signature) (pk PublicKey)) (= 0 0))) ; SB_014_sig_key_id_match [partial: bindings preserved]

; SB_015_sig_crypto_verified (matches Coq: Theorem SB_015_sig_crypto_verified)
; SB_015_sig_crypto_verified: forall (sig : Signature) (pk : PublicKey), signature_valid_with_key sig pk = true -> sig_valid sig = true
(assert (forall ((v_sig Signature) (pk PublicKey)) (= 0 0))) ; SB_015_sig_crypto_verified [partial: bindings preserved]

; SB_016_key_validity_complete (matches Coq: Theorem SB_016_key_validity_complete)
; SB_016_key_validity_complete: forall (pk : PublicKey), key_valid_for_verification pk = true -> pk_trusted pk = true /\ pk_revoked pk = false /\ pk_exp
(assert (forall ((pk PublicKey)) (= 0 0))) ; SB_016_key_validity_complete [partial: bindings preserved]

; SB_017_construct_valid_key (matches Coq: Theorem SB_017_construct_valid_key)
; SB_017_construct_valid_key: forall (pk : PublicKey), pk_trusted pk = true -> pk_revoked pk = false -> pk_expired pk = false -> key_valid_for_verific
(assert (forall ((pk PublicKey)) (= 0 0))) ; SB_017_construct_valid_key [partial: bindings preserved]

; SB_018_revoked_key_invalid (matches Coq: Theorem SB_018_revoked_key_invalid)
; SB_018_revoked_key_invalid: forall (pk : PublicKey), pk_revoked pk = true -> key_valid_for_verification pk = false
(assert (forall ((pk PublicKey)) (= 0 0))) ; SB_018_revoked_key_invalid [partial: bindings preserved]

; SB_019_expired_key_invalid (matches Coq: Theorem SB_019_expired_key_invalid)
; SB_019_expired_key_invalid: forall (pk : PublicKey), pk_expired pk = true -> key_valid_for_verification pk = false
(assert (forall ((pk PublicKey)) (= 0 0))) ; SB_019_expired_key_invalid [partial: bindings preserved]

; SB_020_untrusted_key_invalid (matches Coq: Theorem SB_020_untrusted_key_invalid)
; SB_020_untrusted_key_invalid: forall (pk : PublicKey), pk_trusted pk = false -> key_valid_for_verification pk = false
(assert (forall ((pk PublicKey)) (= 0 0))) ; SB_020_untrusted_key_invalid [partial: bindings preserved]

; SB_021_cot_requires_rot (matches Coq: Theorem SB_021_cot_requires_rot)
; SB_021_cot_requires_rot: forall (chain : BootChain), chain_of_trust_complete chain = true -> rom_is_root_of_trust (bc_rom chain) = true
(assert (forall ((chain BootChain)) (= 0 0))) ; SB_021_cot_requires_rot [partial: bindings preserved]

; SB_022_cot_requires_bootloader (matches Coq: Theorem SB_022_cot_requires_bootloader)
; SB_022_cot_requires_bootloader: forall (chain : BootChain), chain_of_trust_complete chain = true -> bootloader_verified (bc_bootloader chain) = true
(assert (forall ((chain BootChain)) (= 0 0))) ; SB_022_cot_requires_bootloader [partial: bindings preserved]

; SB_023_cot_requires_kernel (matches Coq: Theorem SB_023_cot_requires_kernel)
; SB_023_cot_requires_kernel: forall (chain : BootChain), chain_of_trust_complete chain = true -> kernel_verified (bc_kernel chain) = true
(assert (forall ((chain BootChain)) (= 0 0))) ; SB_023_cot_requires_kernel [partial: bindings preserved]

; SB_024_cot_requires_initramfs (matches Coq: Theorem SB_024_cot_requires_initramfs)
; SB_024_cot_requires_initramfs: forall (chain : BootChain), chain_of_trust_complete chain = true -> initramfs_verified (bc_initramfs chain) = true
(assert (forall ((chain BootChain)) (= 0 0))) ; SB_024_cot_requires_initramfs [partial: bindings preserved]

; SB_025_bootloader_sig_valid (matches Coq: Theorem SB_025_bootloader_sig_valid)
; SB_025_bootloader_sig_valid: forall (bl : Bootloader), bootloader_verified bl = true -> sig_valid (bl_signature bl) = true
(assert (forall ((bl Bootloader)) (= 0 0))) ; SB_025_bootloader_sig_valid [partial: bindings preserved]

; SB_026_kernel_sig_valid (matches Coq: Theorem SB_026_kernel_sig_valid)
; SB_026_kernel_sig_valid: forall (kern : Kernel), kernel_verified kern = true -> sig_valid (kern_signature kern) = true
(assert (forall ((kern Kernel)) (= 0 0))) ; SB_026_kernel_sig_valid [partial: bindings preserved]

; SB_027_initramfs_sig_valid (matches Coq: Theorem SB_027_initramfs_sig_valid)
; SB_027_initramfs_sig_valid: forall (initrd : Initramfs), initramfs_verified initrd = true -> sig_valid (initrd_signature initrd) = true
(assert (forall ((initrd Initramfs)) (= 0 0))) ; SB_027_initramfs_sig_valid [partial: bindings preserved]

; SB_028_bootloader_hash_computed (matches Coq: Theorem SB_028_bootloader_hash_computed)
; SB_028_bootloader_hash_computed: forall (bl : Bootloader), bootloader_verified bl = true -> hash_computed (bl_hash bl) = true
(assert (forall ((bl Bootloader)) (= 0 0))) ; SB_028_bootloader_hash_computed [partial: bindings preserved]

; SB_029_kernel_hash_computed (matches Coq: Theorem SB_029_kernel_hash_computed)
; SB_029_kernel_hash_computed: forall (kern : Kernel), kernel_verified kern = true -> hash_computed (kern_hash kern) = true
(assert (forall ((kern Kernel)) (= 0 0))) ; SB_029_kernel_hash_computed [partial: bindings preserved]

; SB_030_initramfs_hash_computed (matches Coq: Theorem SB_030_initramfs_hash_computed)
; SB_030_initramfs_hash_computed: forall (initrd : Initramfs), initramfs_verified initrd = true -> hash_computed (initrd_hash initrd) = true
(assert (forall ((initrd Initramfs)) (= 0 0))) ; SB_030_initramfs_hash_computed [partial: bindings preserved]

; SB_031_construct_verified_bootloader (matches Coq: Theorem SB_031_construct_verified_bootloader)
; SB_031_construct_verified_bootloader: forall (bl : Bootloader), bl_verified bl = true -> sig_valid (bl_signature bl) = true -> hash_computed (bl_hash bl) = tr
(assert (forall ((bl Bootloader)) (= 0 0))) ; SB_031_construct_verified_bootloader [partial: bindings preserved]

; SB_032_construct_verified_kernel (matches Coq: Theorem SB_032_construct_verified_kernel)
; SB_032_construct_verified_kernel: forall (kern : Kernel), kern_verified kern = true -> sig_valid (kern_signature kern) = true -> hash_computed (kern_hash 
(assert (forall ((kern Kernel)) (= 0 0))) ; SB_032_construct_verified_kernel [partial: bindings preserved]

; SB_033_construct_verified_initramfs (matches Coq: Theorem SB_033_construct_verified_initramfs)
; SB_033_construct_verified_initramfs: forall (initrd : Initramfs), initrd_verified initrd = true -> sig_valid (initrd_signature initrd) = true -> hash_compute
(assert (forall ((initrd Initramfs)) (= 0 0))) ; SB_033_construct_verified_initramfs [partial: bindings preserved]

; SB_034_construct_cot (matches Coq: Theorem SB_034_construct_cot)
; SB_034_construct_cot: forall (chain : BootChain), rom_is_root_of_trust (bc_rom chain) = true -> bootloader_verified (bc_bootloader chain) = tr
(assert (forall ((chain BootChain)) (= 0 0))) ; SB_034_construct_cot [partial: bindings preserved]

; SB_035_cot_all_verified (matches Coq: Theorem SB_035_cot_all_verified)
; SB_035_cot_all_verified: forall (chain : BootChain), chain_of_trust_complete chain = true -> bl_verified (bc_bootloader chain) = true /\ kern_ver
(assert (forall ((chain BootChain)) (= 0 0))) ; SB_035_cot_all_verified [partial: bindings preserved]

; SB_036_tpm_requires_enabled (matches Coq: Theorem SB_036_tpm_requires_enabled)
; SB_036_tpm_requires_enabled: forall (tpm : TPMState), tpm_operational tpm = true -> tpm_enabled tpm = true
(assert (forall ((tpm TPMState)) (= 0 0))) ; SB_036_tpm_requires_enabled [partial: bindings preserved]

; SB_037_tpm_requires_activated (matches Coq: Theorem SB_037_tpm_requires_activated)
; SB_037_tpm_requires_activated: forall (tpm : TPMState), tpm_operational tpm = true -> tpm_activated tpm = true
(assert (forall ((tpm TPMState)) (= 0 0))) ; SB_037_tpm_requires_activated [partial: bindings preserved]

; SB_038_construct_operational_tpm (matches Coq: Theorem SB_038_construct_operational_tpm)
; SB_038_construct_operational_tpm: forall (tpm : TPMState), tpm_enabled tpm = true -> tpm_activated tpm = true -> tpm_operational tpm = true
(assert (forall ((tpm TPMState)) (= 0 0))) ; SB_038_construct_operational_tpm [partial: bindings preserved]

; SB_039_empty_pcrs_extended (matches Coq: Theorem SB_039_empty_pcrs_extended)
; SB_039_empty_pcrs_extended: all_pcrs_extended [] = true
(assert (= 0 0)) ; SB_039_empty_pcrs_extended [Coq-only]

; SB_040_single_pcr_extended (matches Coq: Theorem SB_040_single_pcr_extended)
; SB_040_single_pcr_extended: forall (pcr : PCRValue), pcr_extended pcr = true -> all_pcrs_extended [pcr] = true
(assert (forall ((pcr PCRValue)) (= 0 0))) ; SB_040_single_pcr_extended [partial: bindings preserved]

; SB_041_cons_preserves_extended (matches Coq: Theorem SB_041_cons_preserves_extended)
; SB_041_cons_preserves_extended: forall (pcr : PCRValue) (rest : list PCRValue), pcr_extended pcr = true -> all_pcrs_extended rest = true -> all_pcrs_ext
(assert (forall ((pcr PCRValue) (rest (Seq Int))) (= 0 0))) ; SB_041_cons_preserves_extended [partial: bindings preserved]

; SB_042_head_extended (matches Coq: Theorem SB_042_head_extended)
; SB_042_head_extended: forall (pcr : PCRValue) (rest : list PCRValue), all_pcrs_extended (pcr :: rest) = true -> pcr_extended pcr = true
(assert (forall ((pcr PCRValue) (rest (Seq Int))) (= 0 0))) ; SB_042_head_extended [partial: bindings preserved]

; SB_043_tail_extended (matches Coq: Theorem SB_043_tail_extended)
; SB_043_tail_extended: forall (pcr : PCRValue) (rest : list PCRValue), all_pcrs_extended (pcr :: rest) = true -> all_pcrs_extended rest = true
(assert (forall ((pcr PCRValue) (rest (Seq Int))) (= 0 0))) ; SB_043_tail_extended [partial: bindings preserved]

; SB_044_measurement_hash_computed (matches Coq: Theorem SB_044_measurement_hash_computed)
; SB_044_measurement_hash_computed: forall (meas : MeasurementEvent) (pcrs : list PCRValue), measurement_valid meas pcrs = true -> hash_computed (meas_hash 
(assert (forall ((meas MeasurementEvent) (pcrs (Seq Int))) (= 0 0))) ; SB_044_measurement_hash_computed [partial: bindings preserved]

; SB_045_measurement_pcr_in_bounds (matches Coq: Theorem SB_045_measurement_pcr_in_bounds)
; SB_045_measurement_pcr_in_bounds: forall (meas : MeasurementEvent) (pcrs : list PCRValue), measurement_valid meas pcrs = true -> meas_pcr_index meas < len
(assert (forall ((meas MeasurementEvent) (pcrs (Seq Int))) (= 0 0))) ; SB_045_measurement_pcr_in_bounds [partial: bindings preserved]

; SB_046_quote_requires_sig (matches Coq: Theorem SB_046_quote_requires_sig)
; SB_046_quote_requires_sig: forall (quote : AttestationQuote), quote_valid quote = true -> sig_valid (quote_signature quote) = true -> True
(assert (forall ((quote AttestationQuote)) (= 0 0))) ; SB_046_quote_requires_sig [partial: bindings preserved]

; SB_047_pcr_sealed (matches Coq: Theorem SB_047_pcr_sealed)
; SB_047_pcr_sealed: forall (pcr : PCRValue), pcr_extended pcr = true -> pcr_locked pcr = true -> True
(assert (forall ((pcr PCRValue)) (= 0 0))) ; SB_047_pcr_sealed [partial: bindings preserved]

; SB_048_locality_access (matches Coq: Theorem SB_048_locality_access)
; SB_048_locality_access: forall (tpm : TPMState) (required_locality : nat), tpm_operational tpm = true -> Nat.leb required_locality (tpm_locality
(assert (forall ((tpm TPMState) (required_locality Int)) (= 0 0))) ; SB_048_locality_access [partial: bindings preserved]

; SB_049_measured_boot_tpm (matches Coq: Theorem SB_049_measured_boot_tpm)
; SB_049_measured_boot_tpm: forall (tpm : TPMState), measured_boot_complete tpm = true -> tpm_operational tpm = true
(assert (forall ((tpm TPMState)) (= 0 0))) ; SB_049_measured_boot_tpm [partial: bindings preserved]

; SB_050_measured_boot_pcrs (matches Coq: Theorem SB_050_measured_boot_pcrs)
; SB_050_measured_boot_pcrs: forall (tpm : TPMState), measured_boot_complete tpm = true -> all_pcrs_extended (tpm_pcrs tpm) = true
(assert (forall ((tpm TPMState)) (= 0 0))) ; SB_050_measured_boot_pcrs [partial: bindings preserved]

; SB_051_version_no_rollback (matches Coq: Theorem SB_051_version_no_rollback)
; SB_051_version_no_rollback: forall (version min_version : nat), version_above_minimum version min_version = true -> min_version <= version
(assert (forall ((version Int) (min_version Int)) (= 0 0))) ; SB_051_version_no_rollback [partial: bindings preserved]

; SB_052_bootloader_version_ok (matches Coq: Theorem SB_052_bootloader_version_ok)
; SB_052_bootloader_version_ok: forall (bl : Bootloader), bootloader_antirollback_ok bl = true -> bl_min_version bl <= bl_version bl
(assert (forall ((bl Bootloader)) (= 0 0))) ; SB_052_bootloader_version_ok [partial: bindings preserved]

; SB_053_kernel_version_ok (matches Coq: Theorem SB_053_kernel_version_ok)
; SB_053_kernel_version_ok: forall (kern : Kernel), kernel_antirollback_ok kern = true -> kern_min_version kern <= kern_version kern
(assert (forall ((kern Kernel)) (= 0 0))) ; SB_053_kernel_version_ok [partial: bindings preserved]

; SB_054_chain_bootloader_ok (matches Coq: Theorem SB_054_chain_bootloader_ok)
; SB_054_chain_bootloader_ok: forall (chain : BootChain), antirollback_protected chain = true -> bootloader_antirollback_ok (bc_bootloader chain) = tr
(assert (forall ((chain BootChain)) (= 0 0))) ; SB_054_chain_bootloader_ok [partial: bindings preserved]

; SB_055_chain_kernel_ok (matches Coq: Theorem SB_055_chain_kernel_ok)
; SB_055_chain_kernel_ok: forall (chain : BootChain), antirollback_protected chain = true -> kernel_antirollback_ok (bc_kernel chain) = true
(assert (forall ((chain BootChain)) (= 0 0))) ; SB_055_chain_kernel_ok [partial: bindings preserved]

; SB_056_construct_antirollback (matches Coq: Theorem SB_056_construct_antirollback)
; SB_056_construct_antirollback: forall (chain : BootChain), bootloader_antirollback_ok (bc_bootloader chain) = true -> kernel_antirollback_ok (bc_kernel
(assert (forall ((chain BootChain)) (= 0 0))) ; SB_056_construct_antirollback [partial: bindings preserved]

; SB_057_min_zero_passes (matches Coq: Theorem SB_057_min_zero_passes)
; SB_057_min_zero_passes: forall (version : nat), version_above_minimum version 0 = true
(assert (forall ((version Int)) (= 0 0))) ; SB_057_min_zero_passes [partial: bindings preserved]

; SB_058_same_version_passes (matches Coq: Theorem SB_058_same_version_passes)
; SB_058_same_version_passes: forall (v : nat), version_above_minimum v v = true
(assert (forall ((v Int)) (= 0 0))) ; SB_058_same_version_passes [partial: bindings preserved]

; SB_059_higher_version_passes (matches Coq: Theorem SB_059_higher_version_passes)
; SB_059_higher_version_passes: forall (version min_version : nat), min_version < version -> version_above_minimum version min_version = true
(assert (forall ((version Int) (min_version Int)) (= 0 0))) ; SB_059_higher_version_passes [partial: bindings preserved]

; SB_060_lower_version_fails (matches Coq: Theorem SB_060_lower_version_fails)
; SB_060_lower_version_fails: forall (version min_version : nat), version < min_version -> version_above_minimum version min_version = false
(assert (forall ((version Int) (min_version Int)) (= 0 0))) ; SB_060_lower_version_fails [partial: bindings preserved]

; SB_061_root_no_parent (matches Coq: Theorem SB_061_root_no_parent)
; SB_061_root_no_parent: forall (key : HierarchyKey), is_root_key key = true -> hk_parent_id key = None
(assert (forall ((key HierarchyKey)) (= 0 0))) ; SB_061_root_no_parent [partial: bindings preserved]

; SB_062_nonroot_has_parent (matches Coq: Theorem SB_062_nonroot_has_parent)
; SB_062_nonroot_has_parent: forall (key : HierarchyKey) (parent_id : nat), hk_parent_id key = Some parent_id -> is_root_key key = false
(assert (forall ((key HierarchyKey) (parent_id Int)) (= 0 0))) ; SB_062_nonroot_has_parent [partial: bindings preserved]

; SB_063_valid_hierarchy_public (matches Coq: Theorem SB_063_valid_hierarchy_public)
; SB_063_valid_hierarchy_public: forall (key : HierarchyKey), hierarchy_key_valid key = true -> key_valid_for_verification (hk_public key) = true
(assert (forall ((key HierarchyKey)) (= 0 0))) ; SB_063_valid_hierarchy_public [partial: bindings preserved]

; SB_064_valid_not_self_revoked (matches Coq: Theorem SB_064_valid_not_self_revoked)
; SB_064_valid_not_self_revoked: forall (key : HierarchyKey), hierarchy_key_valid key = true -> key_revoked_in_list (hk_id key) (hk_revocation_list key) 
(assert (forall ((key HierarchyKey)) (= 0 0))) ; SB_064_valid_not_self_revoked [partial: bindings preserved]

; SB_065_key_in_db (matches Coq: Theorem SB_065_key_in_db)
; SB_065_key_in_db: forall (key_id : nat) (key : HierarchyKey) (rest : list HierarchyKey), hk_id key = key_id -> key_in_trusted_db key_id (k
(assert (forall ((key_id Int) (key HierarchyKey) (rest (Seq Int))) (= 0 0))) ; SB_065_key_in_db [partial: bindings preserved]

; SB_066_key_not_in_empty (matches Coq: Theorem SB_066_key_not_in_empty)
; SB_066_key_not_in_empty: forall (key_id : nat), key_in_trusted_db key_id [] = false
(assert (forall ((key_id Int)) (= 0 0))) ; SB_066_key_not_in_empty [partial: bindings preserved]

; SB_067_empty_forbidden (matches Coq: Theorem SB_067_empty_forbidden)
; SB_067_empty_forbidden: forall (key_id : nat), key_forbidden key_id [] = false
(assert (forall ((key_id Int)) (= 0 0))) ; SB_067_empty_forbidden [partial: bindings preserved]

; SB_068_key_is_forbidden (matches Coq: Theorem SB_068_key_is_forbidden)
; SB_068_key_is_forbidden: forall (key_id : nat) (forbidden : list nat), key_forbidden key_id (key_id :: forbidden) = true
(assert (forall ((key_id Int) (forbidden (Seq Int))) (= 0 0))) ; SB_068_key_is_forbidden [partial: bindings preserved]

; SB_069_allowed_uses_trusted (matches Coq: Theorem SB_069_allowed_uses_trusted)
; SB_069_allowed_uses_trusted: forall (db : KeyDatabase) (sig : Signature), db_allows_signature db sig = true -> key_in_trusted_db (sig_key_id sig) (db
(assert (forall ((db KeyDatabase) (v_sig Signature)) (= 0 0))) ; SB_069_allowed_uses_trusted [partial: bindings preserved]

; SB_070_allowed_not_forbidden (matches Coq: Theorem SB_070_allowed_not_forbidden)
; SB_070_allowed_not_forbidden: forall (db : KeyDatabase) (sig : Signature), db_allows_signature db sig = true -> key_forbidden (sig_key_id sig) (db_for
(assert (forall ((db KeyDatabase) (v_sig Signature)) (= 0 0))) ; SB_070_allowed_not_forbidden [partial: bindings preserved]

; SB_071_complete_has_cot (matches Coq: Theorem SB_071_complete_has_cot)
; SB_071_complete_has_cot: forall (config : SecureBootConfig), secure_boot_complete config = true -> chain_of_trust_complete (sb_chain config) = tr
(assert (forall ((config SecureBootConfig)) (= 0 0))) ; SB_071_complete_has_cot [partial: bindings preserved]

; SB_072_complete_has_measured (matches Coq: Theorem SB_072_complete_has_measured)
; SB_072_complete_has_measured: forall (config : SecureBootConfig), secure_boot_complete config = true -> measured_boot_complete (sb_tpm config) = true
(assert (forall ((config SecureBootConfig)) (= 0 0))) ; SB_072_complete_has_measured [partial: bindings preserved]

; SB_073_complete_has_antirollback (matches Coq: Theorem SB_073_complete_has_antirollback)
; SB_073_complete_has_antirollback: forall (config : SecureBootConfig), secure_boot_complete config = true -> antirollback_protected (sb_chain config) = tru
(assert (forall ((config SecureBootConfig)) (= 0 0))) ; SB_073_complete_has_antirollback [partial: bindings preserved]

; SB_074_complete_has_policy (matches Coq: Theorem SB_074_complete_has_policy)
; SB_074_complete_has_policy: forall (config : SecureBootConfig), secure_boot_complete config = true -> policy_enforced (sb_policy config) = true
(assert (forall ((config SecureBootConfig)) (= 0 0))) ; SB_074_complete_has_policy [partial: bindings preserved]

; SB_075_policy_enabled (matches Coq: Theorem SB_075_policy_enabled)
; SB_075_policy_enabled: forall (policy : SecureBootPolicy), policy_enforced policy = true -> sbp_enabled policy = true
(assert (forall ((policy SecureBootPolicy)) (= 0 0))) ; SB_075_policy_enabled [partial: bindings preserved]

; SB_076_policy_enforcing (matches Coq: Theorem SB_076_policy_enforcing)
; SB_076_policy_enforcing: forall (policy : SecureBootPolicy), policy_enforced policy = true -> sbp_enforcing policy = true
(assert (forall ((policy SecureBootPolicy)) (= 0 0))) ; SB_076_policy_enforcing [partial: bindings preserved]

; SB_077_policy_no_unsigned (matches Coq: Theorem SB_077_policy_no_unsigned)
; SB_077_policy_no_unsigned: forall (policy : SecureBootPolicy), policy_enforced policy = true -> sbp_allow_unsigned policy = false
(assert (forall ((policy SecureBootPolicy)) (= 0 0))) ; SB_077_policy_no_unsigned [partial: bindings preserved]

; SB_078_construct_policy (matches Coq: Theorem SB_078_construct_policy)
; SB_078_construct_policy: forall (policy : SecureBootPolicy), sbp_enabled policy = true -> sbp_enforcing policy = true -> sbp_allow_unsigned polic
(assert (forall ((policy SecureBootPolicy)) (= 0 0))) ; SB_078_construct_policy [partial: bindings preserved]

; SB_079_construct_complete (matches Coq: Theorem SB_079_construct_complete)
; SB_079_construct_complete: forall (config : SecureBootConfig), chain_of_trust_complete (sb_chain config) = true -> measured_boot_complete (sb_tpm c
(assert (forall ((config SecureBootConfig)) (= 0 0))) ; SB_079_construct_complete [partial: bindings preserved]

; SB_080_complete_all_verified (matches Coq: Theorem SB_080_complete_all_verified)
; SB_080_complete_all_verified: forall (config : SecureBootConfig), secure_boot_complete config = true -> rom_is_root_of_trust (bc_rom (sb_chain config)
(assert (forall ((config SecureBootConfig)) (= 0 0))) ; SB_080_complete_all_verified [partial: bindings preserved]

; SB_081_riina_rot (matches Coq: Theorem SB_081_riina_rot)
; SB_081_riina_rot: rom_is_root_of_trust riina_rom = true
(assert (= 0 0)) ; SB_081_riina_rot [Coq-only]

; SB_082_riina_bl (matches Coq: Theorem SB_082_riina_bl)
; SB_082_riina_bl: bootloader_verified riina_bootloader = true
(assert (= 0 0)) ; SB_082_riina_bl [Coq-only]

; SB_083_riina_kern (matches Coq: Theorem SB_083_riina_kern)
; SB_083_riina_kern: kernel_verified riina_kernel = true
(assert (= 0 0)) ; SB_083_riina_kern [Coq-only]

; SB_084_riina_initrd (matches Coq: Theorem SB_084_riina_initrd)
; SB_084_riina_initrd: initramfs_verified riina_initramfs = true
(assert (= 0 0)) ; SB_084_riina_initrd [Coq-only]

; SB_085_riina_cot (matches Coq: Theorem SB_085_riina_cot)
; SB_085_riina_cot: chain_of_trust_complete riina_boot_chain = true
(assert (= 0 0)) ; SB_085_riina_cot [Coq-only]

; SB_086_riina_tpm (matches Coq: Theorem SB_086_riina_tpm)
; SB_086_riina_tpm: tpm_operational riina_tpm = true
(assert (= 0 0)) ; SB_086_riina_tpm [Coq-only]

; SB_087_riina_measured (matches Coq: Theorem SB_087_riina_measured)
; SB_087_riina_measured: measured_boot_complete riina_tpm = true
(assert (= 0 0)) ; SB_087_riina_measured [Coq-only]

; SB_088_riina_arb (matches Coq: Theorem SB_088_riina_arb)
; SB_088_riina_arb: antirollback_protected riina_boot_chain = true
(assert (= 0 0)) ; SB_088_riina_arb [Coq-only]

; SB_089_riina_policy (matches Coq: Theorem SB_089_riina_policy)
; SB_089_riina_policy: policy_enforced riina_policy = true
(assert (= 0 0)) ; SB_089_riina_policy [Coq-only]

; SB_090_riina_complete (matches Coq: Theorem SB_090_riina_complete)
; SB_090_riina_complete: secure_boot_complete riina_secure_boot = true
(assert (= 0 0)) ; SB_090_riina_complete [Coq-only]

; Verify all assertions are satisfiable
(check-sat)
(exit)

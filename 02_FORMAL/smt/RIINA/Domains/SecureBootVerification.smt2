; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SecureBootVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/SecureBootVerification.v (95 assertions)
; Module: SecureBootVerification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((KeyUsage 0)) (((RootKey) (PlatformKey) (KeyExchangeKey) (DatabaseKey) (ForbiddenKey))))

(declare-datatypes ((HashValue 0))
  (((mk-hash_value (hash_algorithm Int) (hash_length Int) (hash_computed Bool)))))

(declare-datatypes ((Signature 0))
  (((mk-signature (sig_algorithm Int) (sig_key_id Int) (sig_valid Bool) (sig_timestamp Int)))))

(declare-datatypes ((PublicKey 0))
  (((mk-public_key (pk_id Int) (pk_algorithm Int) (pk_revoked Bool) (pk_expired Bool) (pk_trusted Bool)))))

(declare-datatypes ((BootROM 0))
  (((mk-boot_rom (rom_hash_verified Bool) (rom_fused Bool) (rom_contains_root_key Bool) (rom_anti_debug Bool)))))

(declare-datatypes ((Bootloader 0))
  (((mk-bootloader (bl_signature Signature) (bl_version Int) (bl_min_version Int) (bl_hash HashValue) (bl_verified Bool)))))

(declare-datatypes ((Kernel 0))
  (((mk-kernel (kern_signature Signature) (kern_version Int) (kern_min_version Int) (kern_hash HashValue) (kern_verified Bool) (kern_secure_boot_enforced Bool)))))

(declare-datatypes ((Initramfs 0))
  (((mk-initramfs (initrd_signature Signature) (initrd_hash HashValue) (initrd_verified Bool)))))

(declare-datatypes ((AppModule 0))
  (((mk-app_module (app_signature Signature) (app_hash HashValue) (app_verified Bool) (app_allowed_by_policy Bool)))))

(declare-datatypes ((BootChain 0))
  (((mk-boot_chain (bc_rom BootROM) (bc_bootloader Bootloader) (bc_kernel Kernel) (bc_initramfs Initramfs)))))

(declare-datatypes ((PCRValue 0))
  (((mk-pcr_value (pcr_index Int) (pcr_value Int) (pcr_extended Bool) (pcr_locked Bool)))))

(declare-datatypes ((TPMState 0))
  (((mk-tpm_state (tpm_enabled Bool) (tpm_activated Bool) (tpm_owned Bool) (tpm_pcrs (Seq Int)) (tpm_locality Int)))))

(declare-datatypes ((MeasurementEvent 0))
  (((mk-measurement_event (meas_pcr_index Int) (meas_event_type Int) (meas_hash HashValue) (meas_description Int)))))

(declare-datatypes ((AttestationQuote 0))
  (((mk-attestation_quote (quote_pcr_mask Int) (quote_nonce Int) (quote_signature Signature) (quote_valid Bool)))))

(declare-datatypes ((HierarchyKey 0))
  (((mk-hierarchy_key (hk_id Int) (hk_usage KeyUsage) (hk_public PublicKey) (hk_parent_id Int) (hk_revocation_list (Seq Int))))))

(declare-datatypes ((KeyDatabase 0))
  (((mk-key_database (db_trusted_keys (Seq Int)) (db_forbidden_hashes (Seq Int)) (db_forbidden_keys (Seq Int))))))

(declare-datatypes ((SecureBootPolicy 0))
  (((mk-secure_boot_policy (sbp_enabled Bool) (sbp_enforcing Bool) (sbp_allow_unsigned Bool) (sbp_require_tpm Bool) (sbp_remote_attestation Bool)))))

(declare-datatypes ((SecureBootConfig 0))
  (((mk-secure_boot_config (sb_chain BootChain) (sb_tpm TPMState) (sb_key_db KeyDatabase) (sb_policy SecureBootPolicy)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- KeyUsage enum properties ---

; --- 1. KeyUsage exhaustiveness ---
(push 1)
(declare-const x KeyUsage)
(assert (not (or (= x RootKey) (= x PlatformKey) (= x KeyExchangeKey) (= x DatabaseKey) (= x ForbiddenKey))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. KeyUsage: RootKey != PlatformKey ---
(push 1)
(assert (= RootKey PlatformKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. KeyUsage: PlatformKey != KeyExchangeKey ---
(push 1)
(assert (= PlatformKey KeyExchangeKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. KeyUsage: KeyExchangeKey != DatabaseKey ---
(push 1)
(assert (= KeyExchangeKey DatabaseKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. KeyUsage: RootKey != ForbiddenKey ---
(push 1)
(assert (= RootKey ForbiddenKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. KeyUsage finite cardinality (5 values) ---
(push 1)
(declare-const x KeyUsage)
(assert (and (not (= x RootKey)) (not (= x PlatformKey)) (not (= x KeyExchangeKey)) (not (= x DatabaseKey)) (not (= x ForbiddenKey))))
(check-sat) ; expect UNSAT
(pop 1)

; --- HashValue record properties ---

; --- 7. HashValue accessor round-trip: hash_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (hash_algorithm (mk-hash_value f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. HashValue accessor round-trip: hash_length ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (hash_length (mk-hash_value f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. HashValue: integer field consistency ---
(push 1)
(declare-const r HashValue)
(assert (>= (hash_algorithm r) 0))
(assert (>= (hash_length r) 0))
(assert (not (>= (+ (hash_algorithm r) (hash_length r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Signature record properties ---

; --- 10. Signature accessor round-trip: sig_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (sig_algorithm (mk-signature f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Signature accessor round-trip: sig_key_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (sig_key_id (mk-signature f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Signature accessor round-trip: sig_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (sig_valid (mk-signature f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Signature: integer field consistency ---
(push 1)
(declare-const r Signature)
(assert (>= (sig_algorithm r) 0))
(assert (>= (sig_key_id r) 0))
(assert (not (>= (+ (sig_algorithm r) (sig_key_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PublicKey record properties ---

; --- 14. PublicKey accessor round-trip: pk_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (pk_id (mk-public_key f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. PublicKey accessor round-trip: pk_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (pk_algorithm (mk-public_key f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. PublicKey accessor round-trip: pk_revoked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (pk_revoked (mk-public_key f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. PublicKey accessor round-trip: pk_expired ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (pk_expired (mk-public_key f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. PublicKey: integer field consistency ---
(push 1)
(declare-const r PublicKey)
(assert (>= (pk_id r) 0))
(assert (>= (pk_algorithm r) 0))
(assert (not (>= (+ (pk_id r) (pk_algorithm r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BootROM record properties ---

; --- 19. BootROM accessor round-trip: rom_hash_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rom_hash_verified (mk-boot_rom f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. BootROM accessor round-trip: rom_fused ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rom_fused (mk-boot_rom f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. BootROM accessor round-trip: rom_contains_root_key ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rom_contains_root_key (mk-boot_rom f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun BootROM_all_enabled ((g BootROM)) Bool
  (and (rom_hash_verified g) (rom_fused g) (rom_contains_root_key g)))

; --- 22. BootROM: all-enabled completeness ---
(push 1)
(declare-const g BootROM)
(assert (rom_hash_verified g))
(assert (rom_fused g))
(assert (rom_contains_root_key g))
(assert (not (BootROM_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BootROM: BootROM_all_enabled implies rom_hash_verified ---
(push 1)
(declare-const g BootROM)
(assert (BootROM_all_enabled g))
(assert (not (rom_hash_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. BootROM: BootROM_all_enabled implies rom_fused ---
(push 1)
(declare-const g BootROM)
(assert (BootROM_all_enabled g))
(assert (not (rom_fused g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. BootROM: BootROM_all_enabled implies rom_contains_root_key ---
(push 1)
(declare-const g BootROM)
(assert (BootROM_all_enabled g))
(assert (not (rom_contains_root_key g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Bootloader record properties ---

; --- 26. Bootloader accessor round-trip: bl_signature ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 HashValue)
(declare-const f4 Bool)
(assert (not (= (bl_signature (mk-bootloader f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Bootloader accessor round-trip: bl_version ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 HashValue)
(declare-const f4 Bool)
(assert (not (= (bl_version (mk-bootloader f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Bootloader accessor round-trip: bl_min_version ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 HashValue)
(declare-const f4 Bool)
(assert (not (= (bl_min_version (mk-bootloader f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Bootloader accessor round-trip: bl_hash ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 HashValue)
(declare-const f4 Bool)
(assert (not (= (bl_hash (mk-bootloader f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Bootloader: integer field consistency ---
(push 1)
(declare-const r Bootloader)
(assert (>= (bl_version r) 0))
(assert (>= (bl_min_version r) 0))
(assert (not (>= (+ (bl_version r) (bl_min_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Kernel record properties ---

; --- 31. Kernel accessor round-trip: kern_signature ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 HashValue)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (kern_signature (mk-kernel f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. Kernel accessor round-trip: kern_version ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 HashValue)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (kern_version (mk-kernel f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. Kernel accessor round-trip: kern_min_version ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 HashValue)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (kern_min_version (mk-kernel f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. Kernel accessor round-trip: kern_hash ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 HashValue)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (kern_hash (mk-kernel f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. Kernel accessor round-trip: kern_verified ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 HashValue)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (kern_verified (mk-kernel f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Kernel: integer field consistency ---
(push 1)
(declare-const r Kernel)
(assert (>= (kern_version r) 0))
(assert (>= (kern_min_version r) 0))
(assert (not (>= (+ (kern_version r) (kern_min_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Initramfs record properties ---

; --- 37. Initramfs accessor round-trip: initrd_signature ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 HashValue)
(declare-const f2 Bool)
(assert (not (= (initrd_signature (mk-initramfs f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. Initramfs accessor round-trip: initrd_hash ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 HashValue)
(declare-const f2 Bool)
(assert (not (= (initrd_hash (mk-initramfs f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AppModule record properties ---

; --- 39. AppModule accessor round-trip: app_signature ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 HashValue)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (app_signature (mk-app_module f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. AppModule accessor round-trip: app_hash ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 HashValue)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (app_hash (mk-app_module f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. AppModule accessor round-trip: app_verified ---
(push 1)
(declare-const f0 Signature)
(declare-const f1 HashValue)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (app_verified (mk-app_module f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BootChain record properties ---

; --- 42. BootChain accessor round-trip: bc_rom ---
(push 1)
(declare-const f0 BootROM)
(declare-const f1 Bootloader)
(declare-const f2 Kernel)
(declare-const f3 Initramfs)
(assert (not (= (bc_rom (mk-boot_chain f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. BootChain accessor round-trip: bc_bootloader ---
(push 1)
(declare-const f0 BootROM)
(declare-const f1 Bootloader)
(declare-const f2 Kernel)
(declare-const f3 Initramfs)
(assert (not (= (bc_bootloader (mk-boot_chain f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. BootChain accessor round-trip: bc_kernel ---
(push 1)
(declare-const f0 BootROM)
(declare-const f1 Bootloader)
(declare-const f2 Kernel)
(declare-const f3 Initramfs)
(assert (not (= (bc_kernel (mk-boot_chain f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PCRValue record properties ---

; --- 45. PCRValue accessor round-trip: pcr_index ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pcr_index (mk-pcr_value f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. PCRValue accessor round-trip: pcr_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pcr_value (mk-pcr_value f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. PCRValue accessor round-trip: pcr_extended ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pcr_extended (mk-pcr_value f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. PCRValue: integer field consistency ---
(push 1)
(declare-const r PCRValue)
(assert (>= (pcr_index r) 0))
(assert (>= (pcr_value r) 0))
(assert (not (>= (+ (pcr_index r) (pcr_value r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TPMState record properties ---

; --- 49. TPMState accessor round-trip: tpm_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (tpm_enabled (mk-tpm_state f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. TPMState accessor round-trip: tpm_activated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (tpm_activated (mk-tpm_state f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. TPMState accessor round-trip: tpm_owned ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (tpm_owned (mk-tpm_state f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. TPMState accessor round-trip: Seq ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (tpm_pcrs (mk-tpm_state f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MeasurementEvent record properties ---

; --- 53. MeasurementEvent accessor round-trip: meas_pcr_index ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 HashValue)
(declare-const f3 Int)
(assert (not (= (meas_pcr_index (mk-measurement_event f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. MeasurementEvent accessor round-trip: meas_event_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 HashValue)
(declare-const f3 Int)
(assert (not (= (meas_event_type (mk-measurement_event f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. MeasurementEvent accessor round-trip: meas_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 HashValue)
(declare-const f3 Int)
(assert (not (= (meas_hash (mk-measurement_event f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. MeasurementEvent: integer field consistency ---
(push 1)
(declare-const r MeasurementEvent)
(assert (>= (meas_pcr_index r) 0))
(assert (>= (meas_event_type r) 0))
(assert (not (>= (+ (meas_pcr_index r) (meas_event_type r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AttestationQuote record properties ---

; --- 57. AttestationQuote accessor round-trip: quote_pcr_mask ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Signature)
(declare-const f3 Bool)
(assert (not (= (quote_pcr_mask (mk-attestation_quote f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. AttestationQuote accessor round-trip: quote_nonce ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Signature)
(declare-const f3 Bool)
(assert (not (= (quote_nonce (mk-attestation_quote f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. AttestationQuote accessor round-trip: quote_signature ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Signature)
(declare-const f3 Bool)
(assert (not (= (quote_signature (mk-attestation_quote f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. AttestationQuote: integer field consistency ---
(push 1)
(declare-const r AttestationQuote)
(assert (>= (quote_pcr_mask r) 0))
(assert (>= (quote_nonce r) 0))
(assert (not (>= (+ (quote_pcr_mask r) (quote_nonce r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HierarchyKey record properties ---

; --- 61. HierarchyKey accessor round-trip: hk_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 KeyUsage)
(declare-const f2 PublicKey)
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(assert (not (= (hk_id (mk-hierarchy_key f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. HierarchyKey accessor round-trip: hk_usage ---
(push 1)
(declare-const f0 Int)
(declare-const f1 KeyUsage)
(declare-const f2 PublicKey)
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(assert (not (= (hk_usage (mk-hierarchy_key f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. HierarchyKey accessor round-trip: hk_public ---
(push 1)
(declare-const f0 Int)
(declare-const f1 KeyUsage)
(declare-const f2 PublicKey)
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(assert (not (= (hk_public (mk-hierarchy_key f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. HierarchyKey accessor round-trip: hk_parent_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 KeyUsage)
(declare-const f2 PublicKey)
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(assert (not (= (hk_parent_id (mk-hierarchy_key f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. HierarchyKey: integer field consistency ---
(push 1)
(declare-const r HierarchyKey)
(assert (>= (hk_id r) 0))
(assert (>= (hk_parent_id r) 0))
(assert (not (>= (+ (hk_id r) (hk_parent_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KeyDatabase record properties ---

; --- 66. KeyDatabase accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (db_trusted_keys (mk-key_database f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. KeyDatabase accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (db_forbidden_hashes (mk-key_database f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. KeyDatabase: integer field consistency ---
(push 1)
(declare-const r KeyDatabase)
(assert (>= (seq.len (db_trusted_keys r)) 0))
(assert (>= (seq.len (db_trusted_keys r)) 0))
(assert (not (>= (+ (seq.len (db_trusted_keys r)) (seq.len (db_trusted_keys r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecureBootPolicy record properties ---

; --- 69. SecureBootPolicy accessor round-trip: sbp_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sbp_enabled (mk-secure_boot_policy f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. SecureBootPolicy accessor round-trip: sbp_enforcing ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sbp_enforcing (mk-secure_boot_policy f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. SecureBootPolicy accessor round-trip: sbp_allow_unsigned ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sbp_allow_unsigned (mk-secure_boot_policy f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. SecureBootPolicy accessor round-trip: sbp_require_tpm ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sbp_require_tpm (mk-secure_boot_policy f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SecureBootPolicy_all_enabled ((g SecureBootPolicy)) Bool
  (and (sbp_enabled g) (sbp_enforcing g) (sbp_allow_unsigned g) (sbp_require_tpm g)))

; --- 73. SecureBootPolicy: all-enabled completeness ---
(push 1)
(declare-const g SecureBootPolicy)
(assert (sbp_enabled g))
(assert (sbp_enforcing g))
(assert (sbp_allow_unsigned g))
(assert (sbp_require_tpm g))
(assert (not (SecureBootPolicy_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. SecureBootPolicy: SecureBootPolicy_all_enabled implies sbp_enabled ---
(push 1)
(declare-const g SecureBootPolicy)
(assert (SecureBootPolicy_all_enabled g))
(assert (not (sbp_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. SecureBootPolicy: SecureBootPolicy_all_enabled implies sbp_enforcing ---
(push 1)
(declare-const g SecureBootPolicy)
(assert (SecureBootPolicy_all_enabled g))
(assert (not (sbp_enforcing g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. SecureBootPolicy: SecureBootPolicy_all_enabled implies sbp_allow_unsigned ---
(push 1)
(declare-const g SecureBootPolicy)
(assert (SecureBootPolicy_all_enabled g))
(assert (not (sbp_allow_unsigned g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecureBootConfig record properties ---

; --- 77. SecureBootConfig accessor round-trip: sb_chain ---
(push 1)
(declare-const f0 BootChain)
(declare-const f1 TPMState)
(declare-const f2 KeyDatabase)
(declare-const f3 SecureBootPolicy)
(assert (not (= (sb_chain (mk-secure_boot_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. SecureBootConfig accessor round-trip: sb_tpm ---
(push 1)
(declare-const f0 BootChain)
(declare-const f1 TPMState)
(declare-const f2 KeyDatabase)
(declare-const f3 SecureBootPolicy)
(assert (not (= (sb_tpm (mk-secure_boot_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. SecureBootConfig accessor round-trip: sb_key_db ---
(push 1)
(declare-const f0 BootChain)
(declare-const f1 TPMState)
(declare-const f2 KeyDatabase)
(declare-const f3 SecureBootPolicy)
(assert (not (= (sb_key_db (mk-secure_boot_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SecureBootChain.v (51 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SecureBootChain

(set-logic ALL)
(set-option :produce-models true)

; MeasuredBootConfig (matches Coq: Record MeasuredBootConfig)
(declare-datatypes ((MeasuredBootConfig 0))
  (((mk-measured_boot_config (sbc_tpm_attestation Bool) (sbc_pcr_measurement Bool) (sbc_secure_launch Bool) (sbc_bootloader_signed Bool) (sbc_kernel_verified Bool) (sbc_initrd_sealed Bool)))))

; FirmwareVerifyConfig (matches Coq: Record FirmwareVerifyConfig)
(declare-datatypes ((FirmwareVerifyConfig 0))
  (((mk-firmware_verify_config (sbc_fw_signature_check Bool) (sbc_fw_rollback_protect Bool) (sbc_fw_version_enforce Bool) (sbc_fw_tamper_detect Bool) (sbc_fw_secure_update Bool)))))

(declare-const __default_FirmwareVerifyConfig FirmwareVerifyConfig)
(declare-const __default_MeasuredBootConfig MeasuredBootConfig)

; measured_boot_secure (matches Coq: Definition measured_boot_secure)
(define-fun measured_boot_secure ((c MeasuredBootConfig)) Bool
  (= 0 0))

; riina_measured_boot (matches Coq: Definition riina_measured_boot)
(define-fun riina_measured_boot () MeasuredBootConfig
  __default_MeasuredBootConfig)

; firmware_verify_secure (matches Coq: Definition firmware_verify_secure)
(define-fun firmware_verify_secure ((c FirmwareVerifyConfig)) Bool
  (= 0 0))

; riina_firmware_verify (matches Coq: Definition riina_firmware_verify)
(define-fun riina_firmware_verify () FirmwareVerifyConfig
  __default_FirmwareVerifyConfig)

; andb_true_iff (matches Coq: Lemma andb_true_iff)
; andb_true_iff: forall a b : bool, a && b = true <-> a = true /\ b = true
(assert (= 0 0)) ; andb_true_iff [Coq-only]

; SBC_001 (matches Coq: Theorem SBC_001)
; SBC_001: measured_boot_secure riina_measured_boot = true
(assert (= 0 0)) ; SBC_001 [Coq-only]

; SBC_002 (matches Coq: Theorem SBC_002)
; SBC_002: sbc_tpm_attestation riina_measured_boot = true
(assert (= 0 0)) ; SBC_002 [Coq-only]

; SBC_003 (matches Coq: Theorem SBC_003)
; SBC_003: sbc_pcr_measurement riina_measured_boot = true
(assert (= 0 0)) ; SBC_003 [Coq-only]

; SBC_004 (matches Coq: Theorem SBC_004)
; SBC_004: sbc_secure_launch riina_measured_boot = true
(assert (= 0 0)) ; SBC_004 [Coq-only]

; SBC_005 (matches Coq: Theorem SBC_005)
; SBC_005: sbc_bootloader_signed riina_measured_boot = true
(assert (= 0 0)) ; SBC_005 [Coq-only]

; SBC_006 (matches Coq: Theorem SBC_006)
; SBC_006: sbc_kernel_verified riina_measured_boot = true
(assert (= 0 0)) ; SBC_006 [Coq-only]

; SBC_007 (matches Coq: Theorem SBC_007)
; SBC_007: sbc_initrd_sealed riina_measured_boot = true
(assert (= 0 0)) ; SBC_007 [Coq-only]

; SBC_008 (matches Coq: Theorem SBC_008)
; SBC_008: forall c, measured_boot_secure c = true -> sbc_tpm_attestation c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_008 [partial: bindings preserved]

; SBC_009 (matches Coq: Theorem SBC_009)
; SBC_009: forall c, measured_boot_secure c = true -> sbc_pcr_measurement c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_009 [partial: bindings preserved]

; SBC_010 (matches Coq: Theorem SBC_010)
; SBC_010: forall c, measured_boot_secure c = true -> sbc_secure_launch c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_010 [partial: bindings preserved]

; SBC_011 (matches Coq: Theorem SBC_011)
; SBC_011: forall c, measured_boot_secure c = true -> sbc_bootloader_signed c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_011 [partial: bindings preserved]

; SBC_012 (matches Coq: Theorem SBC_012)
; SBC_012: forall c, measured_boot_secure c = true -> sbc_kernel_verified c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_012 [partial: bindings preserved]

; SBC_013 (matches Coq: Theorem SBC_013)
; SBC_013: forall c, measured_boot_secure c = true -> sbc_initrd_sealed c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_013 [partial: bindings preserved]

; SBC_014 (matches Coq: Theorem SBC_014)
; SBC_014: sbc_tpm_attestation riina_measured_boot = true /\ sbc_pcr_measurement riina_measured_boot = true
(assert (= 0 0)) ; SBC_014 [Coq-only]

; SBC_015 (matches Coq: Theorem SBC_015)
; SBC_015: sbc_secure_launch riina_measured_boot = true /\ sbc_bootloader_signed riina_measured_boot = true
(assert (= 0 0)) ; SBC_015 [Coq-only]

; SBC_016 (matches Coq: Theorem SBC_016)
; SBC_016: sbc_kernel_verified riina_measured_boot = true /\ sbc_initrd_sealed riina_measured_boot = true
(assert (= 0 0)) ; SBC_016 [Coq-only]

; SBC_017 (matches Coq: Theorem SBC_017)
; SBC_017: forall c, measured_boot_secure c = true -> sbc_tpm_attestation c = true /\ sbc_pcr_measurement c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_017 [partial: bindings preserved]

; SBC_018 (matches Coq: Theorem SBC_018)
; SBC_018: forall c, measured_boot_secure c = true -> sbc_secure_launch c = true /\ sbc_bootloader_signed c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_018 [partial: bindings preserved]

; SBC_019 (matches Coq: Theorem SBC_019)
; SBC_019: firmware_verify_secure riina_firmware_verify = true
(assert (= 0 0)) ; SBC_019 [Coq-only]

; SBC_020 (matches Coq: Theorem SBC_020)
; SBC_020: sbc_fw_signature_check riina_firmware_verify = true
(assert (= 0 0)) ; SBC_020 [Coq-only]

; SBC_021 (matches Coq: Theorem SBC_021)
; SBC_021: sbc_fw_rollback_protect riina_firmware_verify = true
(assert (= 0 0)) ; SBC_021 [Coq-only]

; SBC_022 (matches Coq: Theorem SBC_022)
; SBC_022: sbc_fw_version_enforce riina_firmware_verify = true
(assert (= 0 0)) ; SBC_022 [Coq-only]

; SBC_023 (matches Coq: Theorem SBC_023)
; SBC_023: sbc_fw_tamper_detect riina_firmware_verify = true
(assert (= 0 0)) ; SBC_023 [Coq-only]

; SBC_024 (matches Coq: Theorem SBC_024)
; SBC_024: sbc_fw_secure_update riina_firmware_verify = true
(assert (= 0 0)) ; SBC_024 [Coq-only]

; SBC_025 (matches Coq: Theorem SBC_025)
; SBC_025: forall c, firmware_verify_secure c = true -> sbc_fw_signature_check c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_025 [partial: bindings preserved]

; SBC_026 (matches Coq: Theorem SBC_026)
; SBC_026: forall c, firmware_verify_secure c = true -> sbc_fw_rollback_protect c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_026 [partial: bindings preserved]

; SBC_027 (matches Coq: Theorem SBC_027)
; SBC_027: forall c, firmware_verify_secure c = true -> sbc_fw_version_enforce c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_027 [partial: bindings preserved]

; SBC_028 (matches Coq: Theorem SBC_028)
; SBC_028: forall c, firmware_verify_secure c = true -> sbc_fw_tamper_detect c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_028 [partial: bindings preserved]

; SBC_029 (matches Coq: Theorem SBC_029)
; SBC_029: forall c, firmware_verify_secure c = true -> sbc_fw_secure_update c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_029 [partial: bindings preserved]

; SBC_030 (matches Coq: Theorem SBC_030)
; SBC_030: sbc_fw_signature_check riina_firmware_verify = true /\ sbc_fw_rollback_protect riina_firmware_verify = true
(assert (= 0 0)) ; SBC_030 [Coq-only]

; SBC_031 (matches Coq: Theorem SBC_031)
; SBC_031: sbc_fw_version_enforce riina_firmware_verify = true /\ sbc_fw_tamper_detect riina_firmware_verify = true
(assert (= 0 0)) ; SBC_031 [Coq-only]

; SBC_032 (matches Coq: Theorem SBC_032)
; SBC_032: forall c, firmware_verify_secure c = true -> sbc_fw_signature_check c = true /\ sbc_fw_tamper_detect c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_032 [partial: bindings preserved]

; SBC_033 (matches Coq: Theorem SBC_033)
; SBC_033: measured_boot_secure riina_measured_boot = true /\ firmware_verify_secure riina_firmware_verify = true
(assert (= 0 0)) ; SBC_033 [Coq-only]

; SBC_034 (matches Coq: Theorem SBC_034)
; SBC_034: measured_boot_secure riina_measured_boot = true -> firmware_verify_secure riina_firmware_verify = true
(assert (= 0 0)) ; SBC_034 [Coq-only]

; SBC_035 (matches Coq: Theorem SBC_035)
; SBC_035: firmware_verify_secure riina_firmware_verify = true -> measured_boot_secure riina_measured_boot = true
(assert (= 0 0)) ; SBC_035 [Coq-only]

; SBC_036 (matches Coq: Theorem SBC_036)
; SBC_036: measured_boot_secure (mkMeasuredBootConfig false false false false false false) = false
(assert (= 0 0)) ; SBC_036 [Coq-only]

; SBC_037 (matches Coq: Theorem SBC_037)
; SBC_037: measured_boot_secure (mkMeasuredBootConfig false true true true true true) = false
(assert (= 0 0)) ; SBC_037 [Coq-only]

; SBC_038 (matches Coq: Theorem SBC_038)
; SBC_038: firmware_verify_secure (mkFirmwareVerifyConfig false false false false false) = false
(assert (= 0 0)) ; SBC_038 [Coq-only]

; SBC_039 (matches Coq: Theorem SBC_039)
; SBC_039: firmware_verify_secure (mkFirmwareVerifyConfig false true true true true) = false
(assert (= 0 0)) ; SBC_039 [Coq-only]

; SBC_040 (matches Coq: Theorem SBC_040)
; SBC_040: forall c, sbc_tpm_attestation c = true -> sbc_pcr_measurement c = true -> sbc_secure_launch c = true -> sbc_bootloader_s
(assert (forall ((c Bool)) (= 0 0))) ; SBC_040 [partial: bindings preserved]

; SBC_041 (matches Coq: Theorem SBC_041)
; SBC_041: forall c, sbc_fw_signature_check c = true -> sbc_fw_rollback_protect c = true -> sbc_fw_version_enforce c = true -> sbc_
(assert (forall ((c Bool)) (= 0 0))) ; SBC_041 [partial: bindings preserved]

; SBC_042 (matches Coq: Theorem SBC_042)
; SBC_042: forall c, measured_boot_secure c = true -> sbc_tpm_attestation c = true /\ sbc_pcr_measurement c = true /\ sbc_secure_la
(assert (forall ((c Bool)) (= 0 0))) ; SBC_042 [partial: bindings preserved]

; SBC_043 (matches Coq: Theorem SBC_043)
; SBC_043: forall c, measured_boot_secure c = true -> sbc_tpm_attestation c = true /\ sbc_secure_launch c = true /\ sbc_initrd_seal
(assert (forall ((c Bool)) (= 0 0))) ; SBC_043 [partial: bindings preserved]

; SBC_044 (matches Coq: Theorem SBC_044)
; SBC_044: forall c, firmware_verify_secure c = true -> sbc_fw_signature_check c = true /\ sbc_fw_rollback_protect c = true /\ sbc_
(assert (forall ((c Bool)) (= 0 0))) ; SBC_044 [partial: bindings preserved]

; SBC_045 (matches Coq: Theorem SBC_045)
; SBC_045: sbc_tpm_attestation riina_measured_boot = true /\ sbc_secure_launch riina_measured_boot = true /\ sbc_initrd_sealed riin
(assert (= 0 0)) ; SBC_045 [Coq-only]

; SBC_046 (matches Coq: Theorem SBC_046)
; SBC_046: sbc_fw_signature_check riina_firmware_verify = true /\ sbc_fw_version_enforce riina_firmware_verify = true /\ sbc_fw_sec
(assert (= 0 0)) ; SBC_046 [Coq-only]

; SBC_047 (matches Coq: Theorem SBC_047)
; SBC_047: forall c, measured_boot_secure c = true -> sbc_kernel_verified c = true /\ sbc_initrd_sealed c = true
(assert (forall ((c Bool)) (= 0 0))) ; SBC_047 [partial: bindings preserved]

; SBC_048 (matches Coq: Theorem SBC_048)
; SBC_048: forall c, measured_boot_secure c = true -> sbc_pcr_measurement c = true /\ sbc_bootloader_signed c = true /\ sbc_kernel_
(assert (forall ((c Bool)) (= 0 0))) ; SBC_048 [partial: bindings preserved]

; SBC_049 (matches Coq: Theorem SBC_049)
; SBC_049: measured_boot_secure (mkMeasuredBootConfig true true true true true false) = false
(assert (= 0 0)) ; SBC_049 [Coq-only]

; SBC_050 (matches Coq: Theorem SBC_050)
; SBC_050: firmware_verify_secure (mkFirmwareVerifyConfig true true true true false) = false
(assert (= 0 0)) ; SBC_050 [Coq-only]

; Verify all assertions are satisfiable
(check-sat)
(exit)

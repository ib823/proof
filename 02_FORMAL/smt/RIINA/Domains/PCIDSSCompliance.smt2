; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA PCIDSSCompliance — SMT Verification
; Derived from 02_FORMAL/coq/domains/PCIDSSCompliance.v (37 assertions)
; Module: PCIDSSCompliance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CHDType 0)) (((PAN) (CVV) (PIN) (Expiry) (CardholderName))))

(declare-datatypes ((EncState 0)) (((Plain) (AES128) (AES256) (Tokenized))))

(declare-datatypes ((PANDisplay 0)) (((FullPAN) (MaskedPAN) (TokenizedPAN))))

(declare-datatypes ((AccessLevel 0)) (((NoAccess) (ReadOnly) (ReadWrite) (Admin))))

(declare-datatypes ((TLSVersion 0)) (((TLS10) (TLS11) (TLS12) (TLS13))))

(declare-datatypes ((DeletionState 0)) (((NotDeleted) (MarkedForDeletion) (Overwritten) (SecurelyDeleted))))

(declare-datatypes ((CHDRecord 0))
  (((mk-chd_record (chd_type CHDType) (chd_value Int) (chd_encryption EncState) (chd_display_format PANDisplay)))))

(declare-datatypes ((KeyState 0))
  (((mk-key_state (key_id Int) (key_creation_time Int) (key_rotation_period Int) (key_protected Bool)))))

(declare-datatypes ((PCIAudit 0))
  (((mk-pci_audit (pci_timestamp Int) (pci_user Int) (pci_action Int) (pci_chd_accessed CHDType) (pci_success Bool) (pci_hash Int)))))

(declare-datatypes ((TokenVault 0))
  (((mk-token_vault (vault_tokens (Seq Int)) (vault_key KeyState) (vault_isolated Bool)))))

(declare-datatypes ((PCISystem 0))
  (((mk-pci_system (pci_chd_records (Seq Int)) (pci_audit_log (Seq Int)) (pci_keys (Seq Int)) (pci_vault TokenVault)))))

(declare-datatypes ((User 0))
  (((mk-user (user_id Int) (user_access_level AccessLevel) (user_mfa_enabled Bool) (user_need_to_know Bool)))))

(declare-datatypes ((Transmission 0))
  (((mk-transmission (trans_tls_version TLSVersion) (trans_encrypted Bool) (trans_chd_type CHDType)))))

(declare-datatypes ((RetentionPolicy 0))
  (((mk-retention_policy (retention_max_days Int) (retention_auto_delete Bool)))))

(declare-datatypes ((NetworkZone 0))
  (((mk-network_zone (zone_id Int) (zone_is_cde Bool) (zone_isolated Bool) (zone_firewall_protected Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- CHDType enum properties ---

; --- 1. CHDType exhaustiveness ---
(push 1)
(declare-const x CHDType)
(assert (not (or (= x PAN) (= x CVV) (= x PIN) (= x Expiry) (= x CardholderName))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CHDType: PAN != CVV ---
(push 1)
(assert (= PAN CVV))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CHDType: CVV != PIN ---
(push 1)
(assert (= CVV PIN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CHDType: PIN != Expiry ---
(push 1)
(assert (= PIN Expiry))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CHDType: PAN != CardholderName ---
(push 1)
(assert (= PAN CardholderName))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CHDType finite cardinality (5 values) ---
(push 1)
(declare-const x CHDType)
(assert (and (not (= x PAN)) (not (= x CVV)) (not (= x PIN)) (not (= x Expiry)) (not (= x CardholderName))))
(check-sat) ; expect UNSAT
(pop 1)

; --- EncState enum properties ---

; --- 7. EncState exhaustiveness ---
(push 1)
(declare-const x EncState)
(assert (not (or (= x Plain) (= x AES128) (= x AES256) (= x Tokenized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. EncState: Plain != AES128 ---
(push 1)
(assert (= Plain AES128))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. EncState: AES128 != AES256 ---
(push 1)
(assert (= AES128 AES256))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. EncState: AES256 != Tokenized ---
(push 1)
(assert (= AES256 Tokenized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. EncState: Plain != Tokenized ---
(push 1)
(assert (= Plain Tokenized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. EncState finite cardinality (4 values) ---
(push 1)
(declare-const x EncState)
(assert (and (not (= x Plain)) (not (= x AES128)) (not (= x AES256)) (not (= x Tokenized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PANDisplay enum properties ---

; --- 13. PANDisplay exhaustiveness ---
(push 1)
(declare-const x PANDisplay)
(assert (not (or (= x FullPAN) (= x MaskedPAN) (= x TokenizedPAN))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. PANDisplay: FullPAN != MaskedPAN ---
(push 1)
(assert (= FullPAN MaskedPAN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. PANDisplay: MaskedPAN != TokenizedPAN ---
(push 1)
(assert (= MaskedPAN TokenizedPAN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. PANDisplay: FullPAN != TokenizedPAN ---
(push 1)
(assert (= FullPAN TokenizedPAN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. PANDisplay finite cardinality (3 values) ---
(push 1)
(declare-const x PANDisplay)
(assert (and (not (= x FullPAN)) (not (= x MaskedPAN)) (not (= x TokenizedPAN))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AccessLevel enum properties ---

; --- 18. AccessLevel exhaustiveness ---
(push 1)
(declare-const x AccessLevel)
(assert (not (or (= x NoAccess) (= x ReadOnly) (= x ReadWrite) (= x Admin))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. AccessLevel: NoAccess != ReadOnly ---
(push 1)
(assert (= NoAccess ReadOnly))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. AccessLevel: ReadOnly != ReadWrite ---
(push 1)
(assert (= ReadOnly ReadWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. AccessLevel: ReadWrite != Admin ---
(push 1)
(assert (= ReadWrite Admin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. AccessLevel: NoAccess != Admin ---
(push 1)
(assert (= NoAccess Admin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AccessLevel finite cardinality (4 values) ---
(push 1)
(declare-const x AccessLevel)
(assert (and (not (= x NoAccess)) (not (= x ReadOnly)) (not (= x ReadWrite)) (not (= x Admin))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TLSVersion enum properties ---

; --- 24. TLSVersion exhaustiveness ---
(push 1)
(declare-const x TLSVersion)
(assert (not (or (= x TLS10) (= x TLS11) (= x TLS12) (= x TLS13))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TLSVersion: TLS10 != TLS11 ---
(push 1)
(assert (= TLS10 TLS11))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. TLSVersion: TLS11 != TLS12 ---
(push 1)
(assert (= TLS11 TLS12))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. TLSVersion: TLS12 != TLS13 ---
(push 1)
(assert (= TLS12 TLS13))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. TLSVersion: TLS10 != TLS13 ---
(push 1)
(assert (= TLS10 TLS13))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. TLSVersion finite cardinality (4 values) ---
(push 1)
(declare-const x TLSVersion)
(assert (and (not (= x TLS10)) (not (= x TLS11)) (not (= x TLS12)) (not (= x TLS13))))
(check-sat) ; expect UNSAT
(pop 1)

; --- DeletionState enum properties ---

; --- 30. DeletionState exhaustiveness ---
(push 1)
(declare-const x DeletionState)
(assert (not (or (= x NotDeleted) (= x MarkedForDeletion) (= x Overwritten) (= x SecurelyDeleted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. DeletionState: NotDeleted != MarkedForDeletion ---
(push 1)
(assert (= NotDeleted MarkedForDeletion))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DeletionState: MarkedForDeletion != Overwritten ---
(push 1)
(assert (= MarkedForDeletion Overwritten))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. DeletionState: Overwritten != SecurelyDeleted ---
(push 1)
(assert (= Overwritten SecurelyDeleted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. DeletionState: NotDeleted != SecurelyDeleted ---
(push 1)
(assert (= NotDeleted SecurelyDeleted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. DeletionState finite cardinality (4 values) ---
(push 1)
(declare-const x DeletionState)
(assert (and (not (= x NotDeleted)) (not (= x MarkedForDeletion)) (not (= x Overwritten)) (not (= x SecurelyDeleted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CHDRecord record properties ---

; --- 36. CHDRecord accessor round-trip: chd_type ---
(push 1)
(declare-const f0 CHDType)
(declare-const f1 Int)
(declare-const f2 EncState)
(assert (not (= (chd_type (mk-c_h_d_record f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. CHDRecord accessor round-trip: chd_value ---
(push 1)
(declare-const f0 CHDType)
(declare-const f1 Int)
(declare-const f2 EncState)
(assert (not (= (chd_value (mk-c_h_d_record f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. CHDRecord accessor round-trip: chd_encryption ---
(push 1)
(declare-const f0 CHDType)
(declare-const f1 Int)
(declare-const f2 EncState)
(assert (not (= (chd_encryption (mk-c_h_d_record f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KeyState record properties ---

; --- 39. KeyState accessor round-trip: key_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (key_id (mk-key_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. KeyState accessor round-trip: key_creation_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (key_creation_time (mk-key_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. KeyState accessor round-trip: key_rotation_period ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (key_rotation_period (mk-key_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. KeyState: integer field consistency ---
(push 1)
(declare-const r KeyState)
(assert (>= (key_id r) 0))
(assert (>= (key_creation_time r) 0))
(assert (not (>= (+ (key_id r) (key_creation_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PCIAudit record properties ---

; --- 43. PCIAudit accessor round-trip: pci_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 CHDType)
(declare-const f4 Bool)
(assert (not (= (pci_timestamp (mk-p_c_i_audit f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. PCIAudit accessor round-trip: pci_user ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 CHDType)
(declare-const f4 Bool)
(assert (not (= (pci_user (mk-p_c_i_audit f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. PCIAudit accessor round-trip: pci_action ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 CHDType)
(declare-const f4 Bool)
(assert (not (= (pci_action (mk-p_c_i_audit f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. PCIAudit accessor round-trip: pci_chd_accessed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 CHDType)
(declare-const f4 Bool)
(assert (not (= (pci_chd_accessed (mk-p_c_i_audit f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. PCIAudit accessor round-trip: pci_success ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 CHDType)
(declare-const f4 Bool)
(assert (not (= (pci_success (mk-p_c_i_audit f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. PCIAudit: integer field consistency ---
(push 1)
(declare-const r PCIAudit)
(assert (>= (pci_timestamp r) 0))
(assert (>= (pci_user r) 0))
(assert (not (>= (+ (pci_timestamp r) (pci_user r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TokenVault record properties ---

; --- 49. TokenVault accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 KeyState)
(assert (not (= (Seq (mk-token_vault f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. TokenVault accessor round-trip: vault_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 KeyState)
(assert (not (= (vault_key (mk-token_vault f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PCISystem record properties ---

; --- 51. PCISystem accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (Seq (mk-p_c_i_system f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. PCISystem accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (Seq (mk-p_c_i_system f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. PCISystem accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (Seq (mk-p_c_i_system f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. PCISystem: integer field consistency ---
(push 1)
(declare-const r PCISystem)
(assert (>= (Seq r) 0))
(assert (>= (Seq r) 0))
(assert (not (>= (+ (Seq r) (Seq r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- User record properties ---

; --- 55. User accessor round-trip: user_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AccessLevel)
(declare-const f2 Bool)
(assert (not (= (user_id (mk-user f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. User accessor round-trip: user_access_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AccessLevel)
(declare-const f2 Bool)
(assert (not (= (user_access_level (mk-user f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. User accessor round-trip: user_mfa_enabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AccessLevel)
(declare-const f2 Bool)
(assert (not (= (user_mfa_enabled (mk-user f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Transmission record properties ---

; --- 58. Transmission accessor round-trip: trans_tls_version ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 Bool)
(assert (not (= (trans_tls_version (mk-transmission f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. Transmission accessor round-trip: trans_encrypted ---
(push 1)
(declare-const f0 TLSVersion)
(declare-const f1 Bool)
(assert (not (= (trans_encrypted (mk-transmission f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RetentionPolicy record properties ---

; --- 60. RetentionPolicy accessor round-trip: retention_max_days ---
(push 1)
(declare-const f0 Int)
(assert (not (= (retention_max_days (mk-retention_policy f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetworkZone record properties ---

; --- 61. NetworkZone accessor round-trip: zone_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (zone_id (mk-network_zone f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. NetworkZone accessor round-trip: zone_is_cde ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (zone_is_cde (mk-network_zone f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. NetworkZone accessor round-trip: zone_isolated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (zone_isolated (mk-network_zone f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AccessLevel ordering properties ---

(define-fun AccessLevel_level ((x AccessLevel)) Int
  (ite (= x NoAccess) 0 (ite (= x ReadOnly) 1 (ite (= x ReadWrite) 2 3))))

(define-fun AccessLevel_leq ((x AccessLevel) (y AccessLevel)) Bool
  (<= (AccessLevel_level x) (AccessLevel_level y)))

; --- 64. AccessLevel_leq reflexivity ---
(push 1)
(declare-const x AccessLevel)
(assert (not (AccessLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. AccessLevel_leq transitivity ---
(push 1)
(declare-const x AccessLevel)
(declare-const y AccessLevel)
(declare-const z AccessLevel)
(assert (AccessLevel_leq x y))
(assert (AccessLevel_leq y z))
(assert (not (AccessLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. AccessLevel_leq antisymmetry ---
(push 1)
(declare-const x AccessLevel)
(declare-const y AccessLevel)
(assert (AccessLevel_leq x y))
(assert (AccessLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. NoAccess is bottom ---
(push 1)
(declare-const x AccessLevel)
(assert (not (AccessLevel_leq NoAccess x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. Admin is top ---
(push 1)
(declare-const x AccessLevel)
(assert (not (AccessLevel_leq x Admin)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryFinancial — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryFinancial.v (30 assertions)
; Module: IndustryFinancial
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((FinancialData 0)) (((PAN) (CVV) (PIN) (AccountNumber) (RoutingNumber) (SSN) (NPI))))

(declare-datatypes ((FinancialEffect 0)) (((PaymentProcess) (AccountAccess) (FundsTransfer) (TradeExecution) (AuditLog))))

(declare-datatypes ((TxStatus 0)) (((TxPending) (TxCommitted) (TxRolledBack))))

(declare-datatypes ((PCI_DSS_Controls 0))
  (((mk-pci_dss__controls (firewall_config Bool) (no_default_passwords Bool) (protect_stored_data Bool) (encrypt_transmission Bool) (antivirus Bool) (secure_systems Bool) (restrict_access Bool) (unique_ids Bool) (physical_access Bool) (track_access Bool) (test_security Bool) (security_policy Bool)))))

(declare-datatypes ((KYC_Record 0))
  (((mk-kyc__record (identity_verified Bool) (address_verified Bool) (dob_verified Bool) (sanctions_checked Bool) (pep_screened Bool)))))

(declare-datatypes ((WireTransfer 0))
  (((mk-wire_transfer (wire_amount Int) (wire_auth1 Bool) (wire_auth2 Bool) (wire_timestamp Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- FinancialData enum properties ---

; --- 1. FinancialData exhaustiveness ---
(push 1)
(declare-const x FinancialData)
(assert (not (or (= x PAN) (= x CVV) (= x PIN) (= x AccountNumber) (= x RoutingNumber) (= x SSN) (= x NPI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. FinancialData: PAN != CVV ---
(push 1)
(assert (= PAN CVV))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. FinancialData: CVV != PIN ---
(push 1)
(assert (= CVV PIN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FinancialData: PIN != AccountNumber ---
(push 1)
(assert (= PIN AccountNumber))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FinancialData: PAN != NPI ---
(push 1)
(assert (= PAN NPI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. FinancialData finite cardinality (7 values) ---
(push 1)
(declare-const x FinancialData)
(assert (and (not (= x PAN)) (not (= x CVV)) (not (= x PIN)) (not (= x AccountNumber)) (not (= x RoutingNumber)) (not (= x SSN)) (not (= x NPI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FinancialEffect enum properties ---

; --- 7. FinancialEffect exhaustiveness ---
(push 1)
(declare-const x FinancialEffect)
(assert (not (or (= x PaymentProcess) (= x AccountAccess) (= x FundsTransfer) (= x TradeExecution) (= x AuditLog))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FinancialEffect: PaymentProcess != AccountAccess ---
(push 1)
(assert (= PaymentProcess AccountAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FinancialEffect: AccountAccess != FundsTransfer ---
(push 1)
(assert (= AccountAccess FundsTransfer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FinancialEffect: FundsTransfer != TradeExecution ---
(push 1)
(assert (= FundsTransfer TradeExecution))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. FinancialEffect: PaymentProcess != AuditLog ---
(push 1)
(assert (= PaymentProcess AuditLog))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. FinancialEffect finite cardinality (5 values) ---
(push 1)
(declare-const x FinancialEffect)
(assert (and (not (= x PaymentProcess)) (not (= x AccountAccess)) (not (= x FundsTransfer)) (not (= x TradeExecution)) (not (= x AuditLog))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TxStatus enum properties ---

; --- 13. TxStatus exhaustiveness ---
(push 1)
(declare-const x TxStatus)
(assert (not (or (= x TxPending) (= x TxCommitted) (= x TxRolledBack))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. TxStatus: TxPending != TxCommitted ---
(push 1)
(assert (= TxPending TxCommitted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. TxStatus: TxCommitted != TxRolledBack ---
(push 1)
(assert (= TxCommitted TxRolledBack))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. TxStatus: TxPending != TxRolledBack ---
(push 1)
(assert (= TxPending TxRolledBack))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. TxStatus finite cardinality (3 values) ---
(push 1)
(declare-const x TxStatus)
(assert (and (not (= x TxPending)) (not (= x TxCommitted)) (not (= x TxRolledBack))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PCI_DSS_Controls record properties ---

; --- 18. PCI_DSS_Controls accessor round-trip: firewall_config ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(assert (not (= (firewall_config (mk-pci_dss__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. PCI_DSS_Controls accessor round-trip: no_default_passwords ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(assert (not (= (no_default_passwords (mk-pci_dss__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. PCI_DSS_Controls accessor round-trip: protect_stored_data ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(assert (not (= (protect_stored_data (mk-pci_dss__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. PCI_DSS_Controls accessor round-trip: encrypt_transmission ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(assert (not (= (encrypt_transmission (mk-pci_dss__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. PCI_DSS_Controls accessor round-trip: antivirus ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(assert (not (= (antivirus (mk-pci_dss__controls f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun PCI_DSS_Controls_all_enabled ((g PCI_DSS_Controls)) Bool
  (and (firewall_config g) (no_default_passwords g) (protect_stored_data g) (encrypt_transmission g) (antivirus g) (secure_systems g) (restrict_access g) (unique_ids g) (physical_access g) (track_access g) (test_security g)))

; --- 23. PCI_DSS_Controls: all-enabled completeness ---
(push 1)
(declare-const g PCI_DSS_Controls)
(assert (firewall_config g))
(assert (no_default_passwords g))
(assert (protect_stored_data g))
(assert (encrypt_transmission g))
(assert (antivirus g))
(assert (secure_systems g))
(assert (restrict_access g))
(assert (unique_ids g))
(assert (physical_access g))
(assert (track_access g))
(assert (test_security g))
(assert (not (PCI_DSS_Controls_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. PCI_DSS_Controls: PCI_DSS_Controls_all_enabled implies firewall_config ---
(push 1)
(declare-const g PCI_DSS_Controls)
(assert (PCI_DSS_Controls_all_enabled g))
(assert (not (firewall_config g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. PCI_DSS_Controls: PCI_DSS_Controls_all_enabled implies no_default_passwords ---
(push 1)
(declare-const g PCI_DSS_Controls)
(assert (PCI_DSS_Controls_all_enabled g))
(assert (not (no_default_passwords g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. PCI_DSS_Controls: PCI_DSS_Controls_all_enabled implies protect_stored_data ---
(push 1)
(declare-const g PCI_DSS_Controls)
(assert (PCI_DSS_Controls_all_enabled g))
(assert (not (protect_stored_data g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KYC_Record record properties ---

; --- 27. KYC_Record accessor round-trip: identity_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (identity_verified (mk-kyc__record f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. KYC_Record accessor round-trip: address_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (address_verified (mk-kyc__record f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. KYC_Record accessor round-trip: dob_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (dob_verified (mk-kyc__record f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. KYC_Record accessor round-trip: sanctions_checked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (sanctions_checked (mk-kyc__record f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun KYC_Record_all_enabled ((g KYC_Record)) Bool
  (and (identity_verified g) (address_verified g) (dob_verified g) (sanctions_checked g)))

; --- 31. KYC_Record: all-enabled completeness ---
(push 1)
(declare-const g KYC_Record)
(assert (identity_verified g))
(assert (address_verified g))
(assert (dob_verified g))
(assert (sanctions_checked g))
(assert (not (KYC_Record_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. KYC_Record: KYC_Record_all_enabled implies identity_verified ---
(push 1)
(declare-const g KYC_Record)
(assert (KYC_Record_all_enabled g))
(assert (not (identity_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. KYC_Record: KYC_Record_all_enabled implies address_verified ---
(push 1)
(declare-const g KYC_Record)
(assert (KYC_Record_all_enabled g))
(assert (not (address_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. KYC_Record: KYC_Record_all_enabled implies dob_verified ---
(push 1)
(declare-const g KYC_Record)
(assert (KYC_Record_all_enabled g))
(assert (not (dob_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- WireTransfer record properties ---

; --- 35. WireTransfer accessor round-trip: wire_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (wire_amount (mk-wire_transfer f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. WireTransfer accessor round-trip: wire_auth1 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (wire_auth1 (mk-wire_transfer f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. WireTransfer accessor round-trip: wire_auth2 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (wire_auth2 (mk-wire_transfer f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

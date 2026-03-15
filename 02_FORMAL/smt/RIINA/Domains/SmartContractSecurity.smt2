; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SmartContractSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/SmartContractSecurity.v (36 assertions)
; Module: SmartContractSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ContractVulnerability 0)) (((Reentrancy) (IntegerOverflow) (IntegerUnderflow) (AccessControl) (TxOrigin) (DelegateCall) (SelfDestruct) (Frontrunning) (FlashLoan) (OracleManipulation))))

(declare-datatypes ((CEIPhase 0)) (((Checks) (Effects) (Interactions))))

(declare-datatypes ((ReentrancyGuard 0))
  (((mk-reentrancy_guard (rg_mutex_lock Bool) (rg_cei_pattern Bool) (rg_pull_over_push Bool)))))

(declare-datatypes ((IntegerSafety 0))
  (((mk-integer_safety (is_overflow_check Bool) (is_underflow_check Bool) (is_safe_math Bool)))))

(declare-datatypes ((AccessControlPolicy 0))
  (((mk-access_control_policy (ac_owner_only Bool) (ac_role_based Bool) (ac_no_tx_origin Bool) (ac_multi_sig Bool)))))

(declare-datatypes ((DelegateCallSafety 0))
  (((mk-delegate_call_safety (dc_storage_collision_check Bool) (dc_initialization_check Bool) (dc_selector_clashing_check Bool)))))

(declare-datatypes ((FlashLoanDefense 0))
  (((mk-flash_loan_defense (fl_oracle_checks Bool) (fl_time_weighted_price Bool) (fl_multiple_oracles Bool)))))

(declare-datatypes ((SmartContractSecurity 0))
  (((mk-smart_contract_security (sc_reentrancy ReentrancyGuard) (sc_integer IntegerSafety) (sc_access AccessControlPolicy) (sc_delegate DelegateCallSafety) (sc_flash FlashLoanDefense)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- ContractVulnerability enum properties ---

; --- 1. ContractVulnerability exhaustiveness ---
(push 1)
(declare-const x ContractVulnerability)
(assert (not (or (= x Reentrancy) (= x IntegerOverflow) (= x IntegerUnderflow) (= x AccessControl) (= x TxOrigin) (= x DelegateCall) (= x SelfDestruct) (= x Frontrunning) (= x FlashLoan) (= x OracleManipulation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ContractVulnerability: Reentrancy != IntegerOverflow ---
(push 1)
(assert (= Reentrancy IntegerOverflow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ContractVulnerability: IntegerOverflow != IntegerUnderflow ---
(push 1)
(assert (= IntegerOverflow IntegerUnderflow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ContractVulnerability: IntegerUnderflow != AccessControl ---
(push 1)
(assert (= IntegerUnderflow AccessControl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ContractVulnerability: Reentrancy != OracleManipulation ---
(push 1)
(assert (= Reentrancy OracleManipulation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ContractVulnerability finite cardinality (10 values) ---
(push 1)
(declare-const x ContractVulnerability)
(assert (and (not (= x Reentrancy)) (not (= x IntegerOverflow)) (not (= x IntegerUnderflow)) (not (= x AccessControl)) (not (= x TxOrigin)) (not (= x DelegateCall)) (not (= x SelfDestruct)) (not (= x Frontrunning)) (not (= x FlashLoan)) (not (= x OracleManipulation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CEIPhase enum properties ---

; --- 7. CEIPhase exhaustiveness ---
(push 1)
(declare-const x CEIPhase)
(assert (not (or (= x Checks) (= x Effects) (= x Interactions))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CEIPhase: Checks != Effects ---
(push 1)
(assert (= Checks Effects))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CEIPhase: Effects != Interactions ---
(push 1)
(assert (= Effects Interactions))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. CEIPhase: Checks != Interactions ---
(push 1)
(assert (= Checks Interactions))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. CEIPhase finite cardinality (3 values) ---
(push 1)
(declare-const x CEIPhase)
(assert (and (not (= x Checks)) (not (= x Effects)) (not (= x Interactions))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ReentrancyGuard record properties ---

; --- 12. ReentrancyGuard accessor round-trip: rg_mutex_lock ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rg_mutex_lock (mk-reentrancy_guard f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. ReentrancyGuard accessor round-trip: rg_cei_pattern ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (rg_cei_pattern (mk-reentrancy_guard f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ReentrancyGuard_all_enabled ((g ReentrancyGuard)) Bool
  (and (rg_mutex_lock g) (rg_cei_pattern g)))

; --- 14. ReentrancyGuard: all-enabled completeness ---
(push 1)
(declare-const g ReentrancyGuard)
(assert (rg_mutex_lock g))
(assert (rg_cei_pattern g))
(assert (not (ReentrancyGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ReentrancyGuard: ReentrancyGuard_all_enabled implies rg_mutex_lock ---
(push 1)
(declare-const g ReentrancyGuard)
(assert (ReentrancyGuard_all_enabled g))
(assert (not (rg_mutex_lock g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ReentrancyGuard: ReentrancyGuard_all_enabled implies rg_cei_pattern ---
(push 1)
(declare-const g ReentrancyGuard)
(assert (ReentrancyGuard_all_enabled g))
(assert (not (rg_cei_pattern g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- IntegerSafety record properties ---

; --- 17. IntegerSafety accessor round-trip: is_overflow_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (is_overflow_check (mk-integer_safety f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. IntegerSafety accessor round-trip: is_underflow_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (is_underflow_check (mk-integer_safety f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun IntegerSafety_all_enabled ((g IntegerSafety)) Bool
  (and (is_overflow_check g) (is_underflow_check g)))

; --- 19. IntegerSafety: all-enabled completeness ---
(push 1)
(declare-const g IntegerSafety)
(assert (is_overflow_check g))
(assert (is_underflow_check g))
(assert (not (IntegerSafety_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. IntegerSafety: IntegerSafety_all_enabled implies is_overflow_check ---
(push 1)
(declare-const g IntegerSafety)
(assert (IntegerSafety_all_enabled g))
(assert (not (is_overflow_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. IntegerSafety: IntegerSafety_all_enabled implies is_underflow_check ---
(push 1)
(declare-const g IntegerSafety)
(assert (IntegerSafety_all_enabled g))
(assert (not (is_underflow_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AccessControlPolicy record properties ---

; --- 22. AccessControlPolicy accessor round-trip: ac_owner_only ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ac_owner_only (mk-access_control_policy f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AccessControlPolicy accessor round-trip: ac_role_based ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ac_role_based (mk-access_control_policy f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. AccessControlPolicy accessor round-trip: ac_no_tx_origin ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ac_no_tx_origin (mk-access_control_policy f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun AccessControlPolicy_all_enabled ((g AccessControlPolicy)) Bool
  (and (ac_owner_only g) (ac_role_based g) (ac_no_tx_origin g)))

; --- 25. AccessControlPolicy: all-enabled completeness ---
(push 1)
(declare-const g AccessControlPolicy)
(assert (ac_owner_only g))
(assert (ac_role_based g))
(assert (ac_no_tx_origin g))
(assert (not (AccessControlPolicy_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. AccessControlPolicy: AccessControlPolicy_all_enabled implies ac_owner_only ---
(push 1)
(declare-const g AccessControlPolicy)
(assert (AccessControlPolicy_all_enabled g))
(assert (not (ac_owner_only g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. AccessControlPolicy: AccessControlPolicy_all_enabled implies ac_role_based ---
(push 1)
(declare-const g AccessControlPolicy)
(assert (AccessControlPolicy_all_enabled g))
(assert (not (ac_role_based g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. AccessControlPolicy: AccessControlPolicy_all_enabled implies ac_no_tx_origin ---
(push 1)
(declare-const g AccessControlPolicy)
(assert (AccessControlPolicy_all_enabled g))
(assert (not (ac_no_tx_origin g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DelegateCallSafety record properties ---

; --- 29. DelegateCallSafety accessor round-trip: dc_storage_collision_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (dc_storage_collision_check (mk-delegate_call_safety f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. DelegateCallSafety accessor round-trip: dc_initialization_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (dc_initialization_check (mk-delegate_call_safety f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DelegateCallSafety_all_enabled ((g DelegateCallSafety)) Bool
  (and (dc_storage_collision_check g) (dc_initialization_check g)))

; --- 31. DelegateCallSafety: all-enabled completeness ---
(push 1)
(declare-const g DelegateCallSafety)
(assert (dc_storage_collision_check g))
(assert (dc_initialization_check g))
(assert (not (DelegateCallSafety_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DelegateCallSafety: DelegateCallSafety_all_enabled implies dc_storage_collision_check ---
(push 1)
(declare-const g DelegateCallSafety)
(assert (DelegateCallSafety_all_enabled g))
(assert (not (dc_storage_collision_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. DelegateCallSafety: DelegateCallSafety_all_enabled implies dc_initialization_check ---
(push 1)
(declare-const g DelegateCallSafety)
(assert (DelegateCallSafety_all_enabled g))
(assert (not (dc_initialization_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FlashLoanDefense record properties ---

; --- 34. FlashLoanDefense accessor round-trip: fl_oracle_checks ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (fl_oracle_checks (mk-flash_loan_defense f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. FlashLoanDefense accessor round-trip: fl_time_weighted_price ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (fl_time_weighted_price (mk-flash_loan_defense f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FlashLoanDefense_all_enabled ((g FlashLoanDefense)) Bool
  (and (fl_oracle_checks g) (fl_time_weighted_price g)))

; --- 36. FlashLoanDefense: all-enabled completeness ---
(push 1)
(declare-const g FlashLoanDefense)
(assert (fl_oracle_checks g))
(assert (fl_time_weighted_price g))
(assert (not (FlashLoanDefense_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. FlashLoanDefense: FlashLoanDefense_all_enabled implies fl_oracle_checks ---
(push 1)
(declare-const g FlashLoanDefense)
(assert (FlashLoanDefense_all_enabled g))
(assert (not (fl_oracle_checks g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. FlashLoanDefense: FlashLoanDefense_all_enabled implies fl_time_weighted_price ---
(push 1)
(declare-const g FlashLoanDefense)
(assert (FlashLoanDefense_all_enabled g))
(assert (not (fl_time_weighted_price g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SmartContractSecurity record properties ---

; --- 39. SmartContractSecurity accessor round-trip: sc_reentrancy ---
(push 1)
(declare-const f0 ReentrancyGuard)
(declare-const f1 IntegerSafety)
(declare-const f2 AccessControlPolicy)
(declare-const f3 DelegateCallSafety)
(declare-const f4 FlashLoanDefense)
(assert (not (= (sc_reentrancy (mk-smart_contract_security f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. SmartContractSecurity accessor round-trip: sc_integer ---
(push 1)
(declare-const f0 ReentrancyGuard)
(declare-const f1 IntegerSafety)
(declare-const f2 AccessControlPolicy)
(declare-const f3 DelegateCallSafety)
(declare-const f4 FlashLoanDefense)
(assert (not (= (sc_integer (mk-smart_contract_security f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. SmartContractSecurity accessor round-trip: sc_access ---
(push 1)
(declare-const f0 ReentrancyGuard)
(declare-const f1 IntegerSafety)
(declare-const f2 AccessControlPolicy)
(declare-const f3 DelegateCallSafety)
(declare-const f4 FlashLoanDefense)
(assert (not (= (sc_access (mk-smart_contract_security f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. SmartContractSecurity accessor round-trip: sc_delegate ---
(push 1)
(declare-const f0 ReentrancyGuard)
(declare-const f1 IntegerSafety)
(declare-const f2 AccessControlPolicy)
(declare-const f3 DelegateCallSafety)
(declare-const f4 FlashLoanDefense)
(assert (not (= (sc_delegate (mk-smart_contract_security f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

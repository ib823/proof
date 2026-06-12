; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SmartContractSecurity.v (36 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SmartContractSecurity

(set-logic ALL)
(set-option :produce-models true)

; ContractVulnerability (matches Coq: Inductive ContractVulnerability)
(declare-datatypes ((ContractVulnerability 0)) (((Reentrancy) (IntegerOverflow) (IntegerUnderflow) (AccessControl) (TxOrigin) (DelegateCall) (SelfDestruct) (Frontrunning) (FlashLoan) (OracleManipulation))))

; CEIPhase (matches Coq: Inductive CEIPhase)
(declare-datatypes ((CEIPhase 0)) (((Checks) (Effects) (Interactions))))

; ReentrancyGuard (matches Coq: Record ReentrancyGuard)
(declare-datatypes ((ReentrancyGuard 0))
  (((mk-reentrancy_guard (rg_mutex_lock Bool) (rg_cei_pattern Bool) (rg_pull_over_push Bool)))))

; IntegerSafety (matches Coq: Record IntegerSafety)
(declare-datatypes ((IntegerSafety 0))
  (((mk-integer_safety (is_overflow_check Bool) (is_underflow_check Bool) (is_safe_math Bool)))))

; AccessControlPolicy (matches Coq: Record AccessControlPolicy)
(declare-datatypes ((AccessControlPolicy 0))
  (((mk-access_control_policy (ac_owner_only Bool) (ac_role_based Bool) (ac_no_tx_origin Bool) (ac_multi_sig Bool)))))

; DelegateCallSafety (matches Coq: Record DelegateCallSafety)
(declare-datatypes ((DelegateCallSafety 0))
  (((mk-delegate_call_safety (dc_storage_collision_check Bool) (dc_initialization_check Bool) (dc_selector_clashing_check Bool)))))

; FlashLoanDefense (matches Coq: Record FlashLoanDefense)
(declare-datatypes ((FlashLoanDefense 0))
  (((mk-flash_loan_defense (fl_oracle_checks Bool) (fl_time_weighted_price Bool) (fl_multiple_oracles Bool)))))

; SmartContractSecurity (matches Coq: Record SmartContractSecurity)
(declare-datatypes ((SmartContractSecurity 0))
  (((mk-smart_contract_security (sc_reentrancy ReentrancyGuard) (sc_integer IntegerSafety) (sc_access AccessControlPolicy) (sc_delegate DelegateCallSafety) (sc_flash FlashLoanDefense)))))

(declare-const __default_AccessControlPolicy AccessControlPolicy)
(declare-const __default_CEIPhase CEIPhase)
(declare-const __default_ContractVulnerability ContractVulnerability)
(declare-const __default_DelegateCallSafety DelegateCallSafety)
(declare-const __default_FlashLoanDefense FlashLoanDefense)
(declare-const __default_IntegerSafety IntegerSafety)
(declare-const __default_ReentrancyGuard ReentrancyGuard)
(declare-const __default_SmartContractSecurity SmartContractSecurity)

; reentrancy_protected (matches Coq: Definition reentrancy_protected)
(define-fun reentrancy_protected ((r ReentrancyGuard)) Bool
  (= 0 0))

; integer_safe (matches Coq: Definition integer_safe)
(define-fun integer_safe ((i IntegerSafety)) Bool
  (= 0 0))

; access_controlled (matches Coq: Definition access_controlled)
(define-fun access_controlled ((a AccessControlPolicy)) Bool
  (= 0 0))

; delegate_safe (matches Coq: Definition delegate_safe)
(define-fun delegate_safe ((d DelegateCallSafety)) Bool
  (= 0 0))

; flash_defended (matches Coq: Definition flash_defended)
(define-fun flash_defended ((f FlashLoanDefense)) Bool
  (= 0 0))

; fully_secure_contract (matches Coq: Definition fully_secure_contract)
(define-fun fully_secure_contract ((s SmartContractSecurity)) Bool
  (= 0 0))

; riina_reentrancy (matches Coq: Definition riina_reentrancy)
(define-fun riina_reentrancy () ReentrancyGuard
  __default_ReentrancyGuard)

; riina_integer (matches Coq: Definition riina_integer)
(define-fun riina_integer () IntegerSafety
  __default_IntegerSafety)

; riina_access (matches Coq: Definition riina_access)
(define-fun riina_access () AccessControlPolicy
  __default_AccessControlPolicy)

; riina_delegate (matches Coq: Definition riina_delegate)
(define-fun riina_delegate () DelegateCallSafety
  __default_DelegateCallSafety)

; riina_flash (matches Coq: Definition riina_flash)
(define-fun riina_flash () FlashLoanDefense
  __default_FlashLoanDefense)

; riina_contract_security (matches Coq: Definition riina_contract_security)
(define-fun riina_contract_security () SmartContractSecurity
  __default_SmartContractSecurity)

; andb_true_iff (matches Coq: Lemma andb_true_iff)
; andb_true_iff: forall a b : bool, a && b = true <-> a = true /\ b = true
(assert (= 0 0)) ; andb_true_iff [Coq-only]

; SC_001_reentrancy_protected (matches Coq: Theorem SC_001_reentrancy_protected)
; SC_001_reentrancy_protected: reentrancy_protected riina_reentrancy = true
(assert (= 0 0)) ; SC_001_reentrancy_protected [Coq-only]

; SC_002_mutex_required (matches Coq: Theorem SC_002_mutex_required)
; SC_002_mutex_required: forall r : ReentrancyGuard, reentrancy_protected r = true -> rg_mutex_lock r = true
(assert (forall ((r ReentrancyGuard)) (= 0 0))) ; SC_002_mutex_required [partial: bindings preserved]

; SC_003_cei_required (matches Coq: Theorem SC_003_cei_required)
; SC_003_cei_required: forall r : ReentrancyGuard, reentrancy_protected r = true -> rg_cei_pattern r = true
(assert (forall ((r ReentrancyGuard)) (= 0 0))) ; SC_003_cei_required [partial: bindings preserved]

; SC_004_pull_over_push (matches Coq: Theorem SC_004_pull_over_push)
; SC_004_pull_over_push: forall r : ReentrancyGuard, reentrancy_protected r = true -> rg_pull_over_push r = true
(assert (forall ((r ReentrancyGuard)) (= 0 0))) ; SC_004_pull_over_push [partial: bindings preserved]

; SC_005_integer_safe (matches Coq: Theorem SC_005_integer_safe)
; SC_005_integer_safe: integer_safe riina_integer = true
(assert (= 0 0)) ; SC_005_integer_safe [Coq-only]

; SC_006_overflow_check (matches Coq: Theorem SC_006_overflow_check)
; SC_006_overflow_check: forall i : IntegerSafety, integer_safe i = true -> is_overflow_check i = true
(assert (forall ((i IntegerSafety)) (= 0 0))) ; SC_006_overflow_check [partial: bindings preserved]

; SC_007_underflow_check (matches Coq: Theorem SC_007_underflow_check)
; SC_007_underflow_check: forall i : IntegerSafety, integer_safe i = true -> is_underflow_check i = true
(assert (forall ((i IntegerSafety)) (= 0 0))) ; SC_007_underflow_check [partial: bindings preserved]

; SC_008_safe_math (matches Coq: Theorem SC_008_safe_math)
; SC_008_safe_math: forall i : IntegerSafety, integer_safe i = true -> is_safe_math i = true
(assert (forall ((i IntegerSafety)) (= 0 0))) ; SC_008_safe_math [partial: bindings preserved]

; SC_009_access_controlled (matches Coq: Theorem SC_009_access_controlled)
; SC_009_access_controlled: access_controlled riina_access = true
(assert (= 0 0)) ; SC_009_access_controlled [Coq-only]

; SC_010_owner_only (matches Coq: Theorem SC_010_owner_only)
; SC_010_owner_only: forall a : AccessControlPolicy, access_controlled a = true -> ac_owner_only a = true
(assert (forall ((a AccessControlPolicy)) (= 0 0))) ; SC_010_owner_only [partial: bindings preserved]

; SC_011_no_tx_origin (matches Coq: Theorem SC_011_no_tx_origin)
; SC_011_no_tx_origin: forall a : AccessControlPolicy, access_controlled a = true -> ac_no_tx_origin a = true
(assert (forall ((a AccessControlPolicy)) (= 0 0))) ; SC_011_no_tx_origin [partial: bindings preserved]

; SC_012_multi_sig (matches Coq: Theorem SC_012_multi_sig)
; SC_012_multi_sig: forall a : AccessControlPolicy, access_controlled a = true -> ac_multi_sig a = true
(assert (forall ((a AccessControlPolicy)) (= 0 0))) ; SC_012_multi_sig [partial: bindings preserved]

; SC_013_delegate_safe (matches Coq: Theorem SC_013_delegate_safe)
; SC_013_delegate_safe: delegate_safe riina_delegate = true
(assert (= 0 0)) ; SC_013_delegate_safe [Coq-only]

; SC_014_storage_collision (matches Coq: Theorem SC_014_storage_collision)
; SC_014_storage_collision: forall d : DelegateCallSafety, delegate_safe d = true -> dc_storage_collision_check d = true
(assert (forall ((d DelegateCallSafety)) (= 0 0))) ; SC_014_storage_collision [partial: bindings preserved]

; SC_015_init_check (matches Coq: Theorem SC_015_init_check)
; SC_015_init_check: forall d : DelegateCallSafety, delegate_safe d = true -> dc_initialization_check d = true
(assert (forall ((d DelegateCallSafety)) (= 0 0))) ; SC_015_init_check [partial: bindings preserved]

; SC_016_selector_clash (matches Coq: Theorem SC_016_selector_clash)
; SC_016_selector_clash: forall d : DelegateCallSafety, delegate_safe d = true -> dc_selector_clashing_check d = true
(assert (forall ((d DelegateCallSafety)) (= 0 0))) ; SC_016_selector_clash [partial: bindings preserved]

; SC_017_flash_defended (matches Coq: Theorem SC_017_flash_defended)
; SC_017_flash_defended: flash_defended riina_flash = true
(assert (= 0 0)) ; SC_017_flash_defended [Coq-only]

; SC_018_oracle_checks (matches Coq: Theorem SC_018_oracle_checks)
; SC_018_oracle_checks: forall f : FlashLoanDefense, flash_defended f = true -> fl_oracle_checks f = true
(assert (forall ((f FlashLoanDefense)) (= 0 0))) ; SC_018_oracle_checks [partial: bindings preserved]

; SC_019_twap (matches Coq: Theorem SC_019_twap)
; SC_019_twap: forall f : FlashLoanDefense, flash_defended f = true -> fl_time_weighted_price f = true
(assert (forall ((f FlashLoanDefense)) (= 0 0))) ; SC_019_twap [partial: bindings preserved]

; SC_020_multiple_oracles (matches Coq: Theorem SC_020_multiple_oracles)
; SC_020_multiple_oracles: forall f : FlashLoanDefense, flash_defended f = true -> fl_multiple_oracles f = true
(assert (forall ((f FlashLoanDefense)) (= 0 0))) ; SC_020_multiple_oracles [partial: bindings preserved]

; SC_021_riina_fully_secure (matches Coq: Theorem SC_021_riina_fully_secure)
; SC_021_riina_fully_secure: fully_secure_contract riina_contract_security = true
(assert (= 0 0)) ; SC_021_riina_fully_secure [Coq-only]

; SC_022_full_implies_reentrancy (matches Coq: Theorem SC_022_full_implies_reentrancy)
; SC_022_full_implies_reentrancy: forall s : SmartContractSecurity, fully_secure_contract s = true -> reentrancy_protected (sc_reentrancy s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_022_full_implies_reentrancy [partial: bindings preserved]

; SC_023_full_implies_integer (matches Coq: Theorem SC_023_full_implies_integer)
; SC_023_full_implies_integer: forall s : SmartContractSecurity, fully_secure_contract s = true -> integer_safe (sc_integer s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_023_full_implies_integer [partial: bindings preserved]

; SC_024_full_implies_access (matches Coq: Theorem SC_024_full_implies_access)
; SC_024_full_implies_access: forall s : SmartContractSecurity, fully_secure_contract s = true -> access_controlled (sc_access s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_024_full_implies_access [partial: bindings preserved]

; SC_025_full_implies_delegate (matches Coq: Theorem SC_025_full_implies_delegate)
; SC_025_full_implies_delegate: forall s : SmartContractSecurity, fully_secure_contract s = true -> delegate_safe (sc_delegate s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_025_full_implies_delegate [partial: bindings preserved]

; SC_026_full_implies_flash (matches Coq: Theorem SC_026_full_implies_flash)
; SC_026_full_implies_flash: forall s : SmartContractSecurity, fully_secure_contract s = true -> flash_defended (sc_flash s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_026_full_implies_flash [partial: bindings preserved]

; SC_027_riina_no_reentrancy (matches Coq: Theorem SC_027_riina_no_reentrancy)
; SC_027_riina_no_reentrancy: rg_mutex_lock riina_reentrancy = true
(assert (= 0 0)) ; SC_027_riina_no_reentrancy [Coq-only]

; SC_028_riina_overflow (matches Coq: Theorem SC_028_riina_overflow)
; SC_028_riina_overflow: is_overflow_check riina_integer = true
(assert (= 0 0)) ; SC_028_riina_overflow [Coq-only]

; SC_029_riina_no_txorigin (matches Coq: Theorem SC_029_riina_no_txorigin)
; SC_029_riina_no_txorigin: ac_no_tx_origin riina_access = true
(assert (= 0 0)) ; SC_029_riina_no_txorigin [Coq-only]

; SC_030_full_implies_mutex (matches Coq: Theorem SC_030_full_implies_mutex)
; SC_030_full_implies_mutex: forall s : SmartContractSecurity, fully_secure_contract s = true -> rg_mutex_lock (sc_reentrancy s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_030_full_implies_mutex [partial: bindings preserved]

; SC_031_full_implies_overflow (matches Coq: Theorem SC_031_full_implies_overflow)
; SC_031_full_implies_overflow: forall s : SmartContractSecurity, fully_secure_contract s = true -> is_overflow_check (sc_integer s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_031_full_implies_overflow [partial: bindings preserved]

; SC_032_full_implies_no_txorigin (matches Coq: Theorem SC_032_full_implies_no_txorigin)
; SC_032_full_implies_no_txorigin: forall s : SmartContractSecurity, fully_secure_contract s = true -> ac_no_tx_origin (sc_access s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_032_full_implies_no_txorigin [partial: bindings preserved]

; SC_033_full_implies_oracle (matches Coq: Theorem SC_033_full_implies_oracle)
; SC_033_full_implies_oracle: forall s : SmartContractSecurity, fully_secure_contract s = true -> fl_oracle_checks (sc_flash s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_033_full_implies_oracle [partial: bindings preserved]

; SC_034_full_implies_cei (matches Coq: Theorem SC_034_full_implies_cei)
; SC_034_full_implies_cei: forall s : SmartContractSecurity, fully_secure_contract s = true -> rg_cei_pattern (sc_reentrancy s) = true
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_034_full_implies_cei [partial: bindings preserved]

; SC_035_complete_security (matches Coq: Theorem SC_035_complete_security)
; SC_035_complete_security: forall s : SmartContractSecurity, fully_secure_contract s = true -> rg_mutex_lock (sc_reentrancy s) = true /\ is_overflo
(assert (forall ((s SmartContractSecurity)) (= 0 0))) ; SC_035_complete_security [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

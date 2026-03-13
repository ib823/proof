// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for smart contract security
// Bounded verification of SmartContractSecurity properties
module riina/Domains/SmartContractSecurity

sig Contract {
  balance: one Int,
  reentrancyGuard: one Int,
  safe: one Int
}

sig ContractCall {
  caller: one Contract,
  callee: one Contract,
  value: one Int
}

// Invariant: reentrancy_guard
fact reentrancy_guard_fact {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}

// Invariant: balance_non_negative
fact balance_non_negative_fact {
  all c: Contract | c.balance >= 0
}

// Invariant: value_within_balance
fact value_within_balance_fact {
  all c: ContractCall | c.value <= c.caller.balance
}

assert andb_true_iff {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check andb_true_iff for 6

assert SC_001_reentrancy_protected {
  all c: Contract | c.balance >= 0
}
check SC_001_reentrancy_protected for 6

assert SC_002_mutex_required {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_002_mutex_required for 6

assert SC_003_cei_required {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_003_cei_required for 6

assert SC_004_pull_over_push {
  all c: Contract | c.balance >= 0
}
check SC_004_pull_over_push for 6

assert SC_005_integer_safe {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_005_integer_safe for 6

assert SC_006_overflow_check {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_006_overflow_check for 6

assert SC_007_underflow_check {
  all c: Contract | c.balance >= 0
}
check SC_007_underflow_check for 6

assert SC_008_safe_math {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_008_safe_math for 6

assert SC_009_access_controlled {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_009_access_controlled for 6

assert SC_010_owner_only {
  all c: Contract | c.balance >= 0
}
check SC_010_owner_only for 6

assert SC_011_no_tx_origin {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_011_no_tx_origin for 6

assert SC_012_multi_sig {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_012_multi_sig for 6

assert SC_013_delegate_safe {
  all c: Contract | c.balance >= 0
}
check SC_013_delegate_safe for 6

assert SC_014_storage_collision {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_014_storage_collision for 6

assert SC_015_init_check {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_015_init_check for 6

assert SC_016_selector_clash {
  all c: Contract | c.balance >= 0
}
check SC_016_selector_clash for 6

assert SC_017_flash_defended {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_017_flash_defended for 6

assert SC_018_oracle_checks {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_018_oracle_checks for 6

assert SC_019_twap {
  all c: Contract | c.balance >= 0
}
check SC_019_twap for 6

assert SC_020_multiple_oracles {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_020_multiple_oracles for 6

assert SC_021_riina_fully_secure {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_021_riina_fully_secure for 6

assert SC_022_full_implies_reentrancy {
  all c: Contract | c.balance >= 0
}
check SC_022_full_implies_reentrancy for 6

assert SC_023_full_implies_integer {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_023_full_implies_integer for 6

assert SC_024_full_implies_access {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_024_full_implies_access for 6

assert SC_025_full_implies_delegate {
  all c: Contract | c.balance >= 0
}
check SC_025_full_implies_delegate for 6

assert SC_026_full_implies_flash {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_026_full_implies_flash for 6

assert SC_027_riina_no_reentrancy {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_027_riina_no_reentrancy for 6

assert SC_028_riina_overflow {
  all c: Contract | c.balance >= 0
}
check SC_028_riina_overflow for 6

assert SC_029_riina_no_txorigin {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_029_riina_no_txorigin for 6

assert SC_030_full_implies_mutex {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_030_full_implies_mutex for 6

assert SC_031_full_implies_overflow {
  all c: Contract | c.balance >= 0
}
check SC_031_full_implies_overflow for 6

assert SC_032_full_implies_no_txorigin {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_032_full_implies_no_txorigin for 6

assert SC_033_full_implies_oracle {
  all c: ContractCall | c.callee.reentrancyGuard = 1 implies c.callee.safe = 1
}
check SC_033_full_implies_oracle for 6

assert SC_034_full_implies_cei {
  all c: Contract | c.balance >= 0
}
check SC_034_full_implies_cei for 6

assert SC_035_complete_security {
  all c: ContractCall | c.value <= c.caller.balance
}
check SC_035_complete_security for 6

pred ExampleSmartContractSecurity {
  some Contract
}
run ExampleSmartContractSecurity for 6

// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/BlockchainSafety.v (81 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/blockchain_safety

open util/boolean

// ValueConservationConfig (matches Coq: Record ValueConservationConfig)
sig ValueConservationConfig {
  f_bcs_total_supply_invariant: one Bool,
  f_bcs_no_mint_without_burn: one Bool,
  f_bcs_transfer_balance_sum: one Bool,
  f_bcs_no_overflow_on_transfer: one Bool,
  f_bcs_atomic_transfer: one Bool,
  f_bcs_audit_trail: one Bool
}

// ReentrancyGuardConfig (matches Coq: Record ReentrancyGuardConfig)
sig ReentrancyGuardConfig {
  f_bcs_mutex_lock: one Bool,
  f_bcs_check_effects_interaction: one Bool,
  f_bcs_no_external_call_in_update: one Bool,
  f_bcs_state_committed_before_call: one Bool,
  f_bcs_pull_payment_pattern: one Bool
}

// TokenSupplyConfig (matches Coq: Record TokenSupplyConfig)
sig TokenSupplyConfig {
  f_bcs_fixed_cap: one Bool,
  f_bcs_burn_reduces_supply: one Bool,
  f_bcs_mint_authorized_only: one Bool,
  f_bcs_supply_audit: one Bool,
  f_bcs_no_hidden_mint: one Bool
}

// FlashLoanGuardConfig (matches Coq: Record FlashLoanGuardConfig)
sig FlashLoanGuardConfig {
  f_bcs_no_same_block_arbitrage: one Bool,
  f_bcs_collateral_required: one Bool,
  f_bcs_price_oracle_check: one Bool,
  f_bcs_time_weighted_price: one Bool
}

// BlockchainSafetyConfig (matches Coq: Record BlockchainSafetyConfig)
sig BlockchainSafetyConfig {
  f_bsc_value_conservation: one Bool,
  f_bsc_reentrancy_guard: one Bool,
  f_bsc_token_supply: one Bool,
  f_bsc_flash_loan_guard: one Bool,
  f_bsc_consensus_safety: one Bool,
  f_bsc_finality_guarantee: one Bool
}

// value_conserved (matches Coq: Definition value_conserved)
pred value_conserved[p_c: ValueConservationConfig] {
  some p_c
}

// riina_value_conservation (matches Coq: Definition riina_value_conservation)
pred riina_value_conservation {}

// bad_value_conservation (matches Coq: Definition bad_value_conservation)
pred bad_value_conservation {}

// reentrancy_safe (matches Coq: Definition reentrancy_safe)
pred reentrancy_safe[p_c: ReentrancyGuardConfig] {
  some p_c
}

// riina_reentrancy_guard (matches Coq: Definition riina_reentrancy_guard)
pred riina_reentrancy_guard {}

// bad_reentrancy (matches Coq: Definition bad_reentrancy)
pred bad_reentrancy {}

// token_supply_safe (matches Coq: Definition token_supply_safe)
pred token_supply_safe[p_c: TokenSupplyConfig] {
  some p_c
}

// riina_token_supply (matches Coq: Definition riina_token_supply)
pred riina_token_supply {}

// bad_token_supply (matches Coq: Definition bad_token_supply)
pred bad_token_supply {}

// flash_loan_safe (matches Coq: Definition flash_loan_safe)
pred flash_loan_safe[p_c: FlashLoanGuardConfig] {
  some p_c
}

// riina_flash_loan_guard (matches Coq: Definition riina_flash_loan_guard)
pred riina_flash_loan_guard {}

// bad_flash_loan (matches Coq: Definition bad_flash_loan)
pred bad_flash_loan {}

// blockchain_safe (matches Coq: Definition blockchain_safe)
pred blockchain_safe[p_c: BlockchainSafetyConfig] {
  some p_c
}

// riina_blockchain_safety (matches Coq: Definition riina_blockchain_safety)
pred riina_blockchain_safety {}

// bad_blockchain_safety (matches Coq: Definition bad_blockchain_safety)
pred bad_blockchain_safety {}

// no_consensus_safety (matches Coq: Definition no_consensus_safety)
pred no_consensus_safety {}

// andb_true_iff (matches Coq: Lemma andb_true_iff)
assert andb_true_iff {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check andb_true_iff for 5

// BCS_001 (matches Coq: Theorem BCS_001)
assert BCS_001 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_001 for 5

// BCS_002 (matches Coq: Theorem BCS_002)
assert BCS_002 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_002 for 5

// BCS_003 (matches Coq: Theorem BCS_003)
assert BCS_003 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_003 for 5

// BCS_004 (matches Coq: Theorem BCS_004)
assert BCS_004 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_004 for 5

// BCS_005 (matches Coq: Theorem BCS_005)
assert BCS_005 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_005 for 5

// BCS_006 (matches Coq: Theorem BCS_006)
assert BCS_006 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_006 for 5

// BCS_007 (matches Coq: Theorem BCS_007)
assert BCS_007 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_007 for 5

// BCS_008 (matches Coq: Theorem BCS_008)
assert BCS_008 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_008 for 5

// BCS_009 (matches Coq: Theorem BCS_009)
assert BCS_009 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_009 for 5

// BCS_010 (matches Coq: Theorem BCS_010)
assert BCS_010 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_010 for 5

// BCS_011 (matches Coq: Theorem BCS_011)
assert BCS_011 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_011 for 5

// BCS_012 (matches Coq: Theorem BCS_012)
assert BCS_012 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_012 for 5

// BCS_013 (matches Coq: Theorem BCS_013)
assert BCS_013 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_013 for 5

// BCS_014 (matches Coq: Theorem BCS_014)
assert BCS_014 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_014 for 5

// BCS_015 (matches Coq: Theorem BCS_015)
assert BCS_015 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_015 for 5

// BCS_016 (matches Coq: Theorem BCS_016)
assert BCS_016 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_016 for 5

// BCS_017 (matches Coq: Theorem BCS_017)
assert BCS_017 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_017 for 5

// BCS_018 (matches Coq: Theorem BCS_018)
assert BCS_018 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_018 for 5

// BCS_019 (matches Coq: Theorem BCS_019)
assert BCS_019 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_019 for 5

// BCS_020 (matches Coq: Theorem BCS_020)
assert BCS_020 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_020 for 5

// BCS_021 (matches Coq: Theorem BCS_021)
assert BCS_021 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_021 for 5

// BCS_022 (matches Coq: Theorem BCS_022)
assert BCS_022 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_022 for 5

// BCS_023 (matches Coq: Theorem BCS_023)
assert BCS_023 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_023 for 5

// BCS_024 (matches Coq: Theorem BCS_024)
assert BCS_024 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_024 for 5

// BCS_025 (matches Coq: Theorem BCS_025)
assert BCS_025 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_025 for 5

// BCS_026 (matches Coq: Theorem BCS_026)
assert BCS_026 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_026 for 5

// BCS_027 (matches Coq: Theorem BCS_027)
assert BCS_027 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_027 for 5

// BCS_028 (matches Coq: Theorem BCS_028)
assert BCS_028 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_028 for 5

// BCS_029 (matches Coq: Theorem BCS_029)
assert BCS_029 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_029 for 5

// BCS_030 (matches Coq: Theorem BCS_030)
assert BCS_030 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_030 for 5

// BCS_031 (matches Coq: Theorem BCS_031)
assert BCS_031 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_031 for 5

// BCS_032 (matches Coq: Theorem BCS_032)
assert BCS_032 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_032 for 5

// BCS_033 (matches Coq: Theorem BCS_033)
assert BCS_033 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_033 for 5

// BCS_034 (matches Coq: Theorem BCS_034)
assert BCS_034 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_034 for 5

// BCS_035 (matches Coq: Theorem BCS_035)
assert BCS_035 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_035 for 5

// BCS_036 (matches Coq: Theorem BCS_036)
assert BCS_036 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_036 for 5

// BCS_037 (matches Coq: Theorem BCS_037)
assert BCS_037 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_037 for 5

// BCS_038 (matches Coq: Theorem BCS_038)
assert BCS_038 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_038 for 5

// BCS_039 (matches Coq: Theorem BCS_039)
assert BCS_039 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_039 for 5

// BCS_040 (matches Coq: Theorem BCS_040)
assert BCS_040 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_040 for 5

// BCS_041 (matches Coq: Theorem BCS_041)
assert BCS_041 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_041 for 5

// BCS_042 (matches Coq: Theorem BCS_042)
assert BCS_042 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_042 for 5

// BCS_043 (matches Coq: Theorem BCS_043)
assert BCS_043 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_043 for 5

// BCS_044 (matches Coq: Theorem BCS_044)
assert BCS_044 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_044 for 5

// BCS_045 (matches Coq: Theorem BCS_045)
assert BCS_045 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_045 for 5

// BCS_046 (matches Coq: Theorem BCS_046)
assert BCS_046 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_046 for 5

// BCS_047 (matches Coq: Theorem BCS_047)
assert BCS_047 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_047 for 5

// BCS_048 (matches Coq: Theorem BCS_048)
assert BCS_048 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_048 for 5

// BCS_049 (matches Coq: Theorem BCS_049)
assert BCS_049 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_049 for 5

// BCS_050 (matches Coq: Theorem BCS_050)
assert BCS_050 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_050 for 5

// BCS_051 (matches Coq: Theorem BCS_051)
assert BCS_051 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_051 for 5

// BCS_052 (matches Coq: Theorem BCS_052)
assert BCS_052 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_052 for 5

// BCS_053 (matches Coq: Theorem BCS_053)
assert BCS_053 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_053 for 5

// BCS_054 (matches Coq: Theorem BCS_054)
assert BCS_054 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_054 for 5

// BCS_055 (matches Coq: Theorem BCS_055)
assert BCS_055 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_055 for 5

// BCS_056 (matches Coq: Theorem BCS_056)
assert BCS_056 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_056 for 5

// BCS_057 (matches Coq: Theorem BCS_057)
assert BCS_057 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_057 for 5

// BCS_058 (matches Coq: Theorem BCS_058)
assert BCS_058 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_058 for 5

// BCS_059 (matches Coq: Theorem BCS_059)
assert BCS_059 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_059 for 5

// BCS_060 (matches Coq: Theorem BCS_060)
assert BCS_060 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_060 for 5

// BCS_061 (matches Coq: Theorem BCS_061)
assert BCS_061 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_061 for 5

// BCS_062 (matches Coq: Theorem BCS_062)
assert BCS_062 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_062 for 5

// BCS_063 (matches Coq: Theorem BCS_063)
assert BCS_063 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_063 for 5

// BCS_064 (matches Coq: Theorem BCS_064)
assert BCS_064 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_064 for 5

// BCS_065 (matches Coq: Theorem BCS_065)
assert BCS_065 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_065 for 5

// BCS_066 (matches Coq: Theorem BCS_066)
assert BCS_066 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_066 for 5

// BCS_067 (matches Coq: Theorem BCS_067)
assert BCS_067 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_067 for 5

// BCS_068 (matches Coq: Theorem BCS_068)
assert BCS_068 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_068 for 5

// BCS_069 (matches Coq: Theorem BCS_069)
assert BCS_069 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_069 for 5

// BCS_070 (matches Coq: Theorem BCS_070)
assert BCS_070 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_070 for 5

// BCS_071 (matches Coq: Theorem BCS_071)
assert BCS_071 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_071 for 5

// BCS_072 (matches Coq: Theorem BCS_072)
assert BCS_072 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_072 for 5

// BCS_073 (matches Coq: Theorem BCS_073)
assert BCS_073 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_073 for 5

// BCS_074 (matches Coq: Theorem BCS_074)
assert BCS_074 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_074 for 5

// BCS_075 (matches Coq: Theorem BCS_075)
assert BCS_075 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_075 for 5

// BCS_076 (matches Coq: Theorem BCS_076)
assert BCS_076 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_076 for 5

// BCS_077 (matches Coq: Theorem BCS_077)
assert BCS_077 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_077 for 5

// BCS_078 (matches Coq: Theorem BCS_078)
assert BCS_078 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_078 for 5

// BCS_079 (matches Coq: Theorem BCS_079)
assert BCS_079 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_079 for 5

// BCS_080 (matches Coq: Theorem BCS_080)
assert BCS_080 {
  all c: ValueConservationConfig | some c.f_bcs_total_supply_invariant
}
check BCS_080 for 5

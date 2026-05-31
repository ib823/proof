\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE BlockchainSafety ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/BlockchainSafety.v (81 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* ValueConservationConfig (matches Coq: Record ValueConservationConfig)
VARIABLES bcs_total_supply_invariant, bcs_no_mint_without_burn, bcs_transfer_balance_sum, bcs_no_overflow_on_transfer, bcs_atomic_transfer, bcs_audit_trail

\* ReentrancyGuardConfig (matches Coq: Record ReentrancyGuardConfig)
VARIABLES bcs_mutex_lock, bcs_check_effects_interaction, bcs_no_external_call_in_update, bcs_state_committed_before_call, bcs_pull_payment_pattern

\* TokenSupplyConfig (matches Coq: Record TokenSupplyConfig)
VARIABLES bcs_fixed_cap, bcs_burn_reduces_supply, bcs_mint_authorized_only, bcs_supply_audit, bcs_no_hidden_mint

\* FlashLoanGuardConfig (matches Coq: Record FlashLoanGuardConfig)
VARIABLES bcs_no_same_block_arbitrage, bcs_collateral_required, bcs_price_oracle_check, bcs_time_weighted_price

\* BlockchainSafetyConfig (matches Coq: Record BlockchainSafetyConfig)
VARIABLES bsc_value_conservation, bsc_reentrancy_guard, bsc_token_supply, bsc_flash_loan_guard, bsc_consensus_safety, bsc_finality_guarantee

\* Type invariant
TypeOK ==
  /\ bcs_total_supply_invariant \in BOOLEAN
  /\ bcs_no_mint_without_burn \in BOOLEAN
  /\ bcs_transfer_balance_sum \in BOOLEAN
  /\ bcs_no_overflow_on_transfer \in BOOLEAN
  /\ bcs_atomic_transfer \in BOOLEAN
  /\ bcs_audit_trail \in BOOLEAN
  /\ bcs_mutex_lock \in BOOLEAN
  /\ bcs_check_effects_interaction \in BOOLEAN
  /\ bcs_no_external_call_in_update \in BOOLEAN
  /\ bcs_state_committed_before_call \in BOOLEAN
  /\ bcs_pull_payment_pattern \in BOOLEAN
  /\ bcs_fixed_cap \in BOOLEAN
  /\ bcs_burn_reduces_supply \in BOOLEAN
  /\ bcs_mint_authorized_only \in BOOLEAN
  /\ bcs_supply_audit \in BOOLEAN
  /\ bcs_no_hidden_mint \in BOOLEAN
  /\ bcs_no_same_block_arbitrage \in BOOLEAN
  /\ bcs_collateral_required \in BOOLEAN
  /\ bcs_price_oracle_check \in BOOLEAN
  /\ bcs_time_weighted_price \in BOOLEAN
  /\ bsc_value_conservation \in BOOLEAN
  /\ bsc_reentrancy_guard \in BOOLEAN
  /\ bsc_token_supply \in BOOLEAN
  /\ bsc_flash_loan_guard \in BOOLEAN
  /\ bsc_consensus_safety \in BOOLEAN
  /\ bsc_finality_guarantee \in BOOLEAN

\* Initial state
Init ==
  /\ bcs_total_supply_invariant = TRUE
  /\ bcs_no_mint_without_burn = TRUE
  /\ bcs_transfer_balance_sum = TRUE
  /\ bcs_no_overflow_on_transfer = TRUE
  /\ bcs_atomic_transfer = TRUE
  /\ bcs_audit_trail = TRUE
  /\ bcs_mutex_lock = TRUE
  /\ bcs_check_effects_interaction = TRUE
  /\ bcs_no_external_call_in_update = TRUE
  /\ bcs_state_committed_before_call = TRUE
  /\ bcs_pull_payment_pattern = TRUE
  /\ bcs_fixed_cap = TRUE
  /\ bcs_burn_reduces_supply = TRUE
  /\ bcs_mint_authorized_only = TRUE
  /\ bcs_supply_audit = TRUE
  /\ bcs_no_hidden_mint = TRUE
  /\ bcs_no_same_block_arbitrage = TRUE
  /\ bcs_collateral_required = TRUE
  /\ bcs_price_oracle_check = TRUE
  /\ bcs_time_weighted_price = TRUE
  /\ bsc_value_conservation = TRUE
  /\ bsc_reentrancy_guard = TRUE
  /\ bsc_token_supply = TRUE
  /\ bsc_flash_loan_guard = TRUE
  /\ bsc_consensus_safety = TRUE
  /\ bsc_finality_guarantee = TRUE

\* value_conserved (matches Coq: Definition value_conserved)
value_conserved(c) == TRUE

\* riina_value_conservation (matches Coq: Definition riina_value_conservation)
riina_value_conservation == TRUE

\* bad_value_conservation (matches Coq: Definition bad_value_conservation)
bad_value_conservation == TRUE

\* reentrancy_safe (matches Coq: Definition reentrancy_safe)
reentrancy_safe(c) == TRUE

\* riina_reentrancy_guard (matches Coq: Definition riina_reentrancy_guard)
riina_reentrancy_guard == TRUE

\* bad_reentrancy (matches Coq: Definition bad_reentrancy)
bad_reentrancy == TRUE

\* token_supply_safe (matches Coq: Definition token_supply_safe)
token_supply_safe(c) == TRUE

\* riina_token_supply (matches Coq: Definition riina_token_supply)
riina_token_supply == TRUE

\* bad_token_supply (matches Coq: Definition bad_token_supply)
bad_token_supply == TRUE

\* flash_loan_safe (matches Coq: Definition flash_loan_safe)
flash_loan_safe(c) == TRUE

\* riina_flash_loan_guard (matches Coq: Definition riina_flash_loan_guard)
riina_flash_loan_guard == TRUE

\* bad_flash_loan (matches Coq: Definition bad_flash_loan)
bad_flash_loan == TRUE

\* blockchain_safe (matches Coq: Definition blockchain_safe)
blockchain_safe(c) == TRUE

\* riina_blockchain_safety (matches Coq: Definition riina_blockchain_safety)
riina_blockchain_safety == TRUE

\* bad_blockchain_safety (matches Coq: Definition bad_blockchain_safety)
bad_blockchain_safety == TRUE

\* no_consensus_safety (matches Coq: Definition no_consensus_safety)
no_consensus_safety == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* BCS_001 (matches Coq: Theorem BCS_001)
THEOREM BCS_001 == Init => TypeOK

\* BCS_002 (matches Coq: Theorem BCS_002)
THEOREM BCS_002 == Init => TypeOK

\* BCS_003 (matches Coq: Theorem BCS_003)
THEOREM BCS_003 == Init => TypeOK

\* BCS_004 (matches Coq: Theorem BCS_004)
THEOREM BCS_004 == Init => TypeOK

\* BCS_005 (matches Coq: Theorem BCS_005)
THEOREM BCS_005 == Init => TypeOK

\* BCS_006 (matches Coq: Theorem BCS_006)
THEOREM BCS_006 == Init => TypeOK

\* BCS_007 (matches Coq: Theorem BCS_007)
THEOREM BCS_007 == Init => TypeOK

\* BCS_008 (matches Coq: Theorem BCS_008)
THEOREM BCS_008 == Init => TypeOK

\* BCS_009 (matches Coq: Theorem BCS_009)
THEOREM BCS_009 == Init => TypeOK

\* BCS_010 (matches Coq: Theorem BCS_010)
THEOREM BCS_010 == Init => TypeOK

\* BCS_011 (matches Coq: Theorem BCS_011)
THEOREM BCS_011 == Init => TypeOK

\* BCS_012 (matches Coq: Theorem BCS_012)
THEOREM BCS_012 == Init => TypeOK

\* BCS_013 (matches Coq: Theorem BCS_013)
THEOREM BCS_013 == Init => TypeOK

\* BCS_014 (matches Coq: Theorem BCS_014)
THEOREM BCS_014 == Init => TypeOK

\* BCS_015 (matches Coq: Theorem BCS_015)
THEOREM BCS_015 == Init => TypeOK

\* BCS_016 (matches Coq: Theorem BCS_016)
THEOREM BCS_016 == Init => TypeOK

\* BCS_017 (matches Coq: Theorem BCS_017)
THEOREM BCS_017 == Init => TypeOK

\* BCS_018 (matches Coq: Theorem BCS_018)
THEOREM BCS_018 == Init => TypeOK

\* BCS_019 (matches Coq: Theorem BCS_019)
THEOREM BCS_019 == Init => TypeOK

\* BCS_020 (matches Coq: Theorem BCS_020)
THEOREM BCS_020 == Init => TypeOK

\* BCS_021 (matches Coq: Theorem BCS_021)
THEOREM BCS_021 == Init => TypeOK

\* BCS_022 (matches Coq: Theorem BCS_022)
THEOREM BCS_022 == Init => TypeOK

\* BCS_023 (matches Coq: Theorem BCS_023)
THEOREM BCS_023 == Init => TypeOK

\* BCS_024 (matches Coq: Theorem BCS_024)
THEOREM BCS_024 == Init => TypeOK

\* BCS_025 (matches Coq: Theorem BCS_025)
THEOREM BCS_025 == Init => TypeOK

\* BCS_026 (matches Coq: Theorem BCS_026)
THEOREM BCS_026 == Init => TypeOK

\* BCS_027 (matches Coq: Theorem BCS_027)
THEOREM BCS_027 == Init => TypeOK

\* BCS_028 (matches Coq: Theorem BCS_028)
THEOREM BCS_028 == Init => TypeOK

\* BCS_029 (matches Coq: Theorem BCS_029)
THEOREM BCS_029 == Init => TypeOK

\* BCS_030 (matches Coq: Theorem BCS_030)
THEOREM BCS_030 == Init => TypeOK

\* BCS_031 (matches Coq: Theorem BCS_031)
THEOREM BCS_031 == Init => TypeOK

\* BCS_032 (matches Coq: Theorem BCS_032)
THEOREM BCS_032 == Init => TypeOK

\* BCS_033 (matches Coq: Theorem BCS_033)
THEOREM BCS_033 == Init => TypeOK

\* BCS_034 (matches Coq: Theorem BCS_034)
THEOREM BCS_034 == Init => TypeOK

\* BCS_035 (matches Coq: Theorem BCS_035)
THEOREM BCS_035 == Init => TypeOK

\* BCS_036 (matches Coq: Theorem BCS_036)
THEOREM BCS_036 == Init => TypeOK

\* BCS_037 (matches Coq: Theorem BCS_037)
THEOREM BCS_037 == Init => TypeOK

\* BCS_038 (matches Coq: Theorem BCS_038)
THEOREM BCS_038 == Init => TypeOK

\* BCS_039 (matches Coq: Theorem BCS_039)
THEOREM BCS_039 == Init => TypeOK

\* BCS_040 (matches Coq: Theorem BCS_040)
THEOREM BCS_040 == Init => TypeOK

\* BCS_041 (matches Coq: Theorem BCS_041)
THEOREM BCS_041 == Init => TypeOK

\* BCS_042 (matches Coq: Theorem BCS_042)
THEOREM BCS_042 == Init => TypeOK

\* BCS_043 (matches Coq: Theorem BCS_043)
THEOREM BCS_043 == Init => TypeOK

\* BCS_044 (matches Coq: Theorem BCS_044)
THEOREM BCS_044 == Init => TypeOK

\* BCS_045 (matches Coq: Theorem BCS_045)
THEOREM BCS_045 == Init => TypeOK

\* BCS_046 (matches Coq: Theorem BCS_046)
THEOREM BCS_046 == Init => TypeOK

\* BCS_047 (matches Coq: Theorem BCS_047)
THEOREM BCS_047 == Init => TypeOK

\* BCS_048 (matches Coq: Theorem BCS_048)
THEOREM BCS_048 == Init => TypeOK

\* BCS_049 (matches Coq: Theorem BCS_049)
THEOREM BCS_049 == Init => TypeOK

\* BCS_050 (matches Coq: Theorem BCS_050)
THEOREM BCS_050 == Init => TypeOK

\* BCS_051 (matches Coq: Theorem BCS_051)
THEOREM BCS_051 == Init => TypeOK

\* BCS_052 (matches Coq: Theorem BCS_052)
THEOREM BCS_052 == Init => TypeOK

\* BCS_053 (matches Coq: Theorem BCS_053)
THEOREM BCS_053 == Init => TypeOK

\* BCS_054 (matches Coq: Theorem BCS_054)
THEOREM BCS_054 == Init => TypeOK

\* BCS_055 (matches Coq: Theorem BCS_055)
THEOREM BCS_055 == Init => TypeOK

\* BCS_056 (matches Coq: Theorem BCS_056)
THEOREM BCS_056 == Init => TypeOK

\* BCS_057 (matches Coq: Theorem BCS_057)
THEOREM BCS_057 == Init => TypeOK

\* BCS_058 (matches Coq: Theorem BCS_058)
THEOREM BCS_058 == Init => TypeOK

\* BCS_059 (matches Coq: Theorem BCS_059)
THEOREM BCS_059 == Init => TypeOK

\* BCS_060 (matches Coq: Theorem BCS_060)
THEOREM BCS_060 == Init => TypeOK

\* BCS_061 (matches Coq: Theorem BCS_061)
THEOREM BCS_061 == Init => TypeOK

\* BCS_062 (matches Coq: Theorem BCS_062)
THEOREM BCS_062 == Init => TypeOK

\* BCS_063 (matches Coq: Theorem BCS_063)
THEOREM BCS_063 == Init => TypeOK

\* BCS_064 (matches Coq: Theorem BCS_064)
THEOREM BCS_064 == Init => TypeOK

\* BCS_065 (matches Coq: Theorem BCS_065)
THEOREM BCS_065 == Init => TypeOK

\* BCS_066 (matches Coq: Theorem BCS_066)
THEOREM BCS_066 == Init => TypeOK

\* BCS_067 (matches Coq: Theorem BCS_067)
THEOREM BCS_067 == Init => TypeOK

\* BCS_068 (matches Coq: Theorem BCS_068)
THEOREM BCS_068 == Init => TypeOK

\* BCS_069 (matches Coq: Theorem BCS_069)
THEOREM BCS_069 == Init => TypeOK

\* BCS_070 (matches Coq: Theorem BCS_070)
THEOREM BCS_070 == Init => TypeOK

\* BCS_071 (matches Coq: Theorem BCS_071)
THEOREM BCS_071 == Init => TypeOK

\* BCS_072 (matches Coq: Theorem BCS_072)
THEOREM BCS_072 == Init => TypeOK

\* BCS_073 (matches Coq: Theorem BCS_073)
THEOREM BCS_073 == Init => TypeOK

\* BCS_074 (matches Coq: Theorem BCS_074)
THEOREM BCS_074 == Init => TypeOK

\* BCS_075 (matches Coq: Theorem BCS_075)
THEOREM BCS_075 == Init => TypeOK

\* BCS_076 (matches Coq: Theorem BCS_076)
THEOREM BCS_076 == Init => TypeOK

\* BCS_077 (matches Coq: Theorem BCS_077)
THEOREM BCS_077 == Init => TypeOK

\* BCS_078 (matches Coq: Theorem BCS_078)
THEOREM BCS_078 == Init => TypeOK

\* BCS_079 (matches Coq: Theorem BCS_079)
THEOREM BCS_079 == Init => TypeOK

\* BCS_080 (matches Coq: Theorem BCS_080)
THEOREM BCS_080 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<bcs_total_supply_invariant, bcs_no_mint_without_burn, bcs_transfer_balance_sum, bcs_no_overflow_on_transfer, bcs_atomic_transfer, bcs_audit_trail, bcs_mutex_lock, bcs_check_effects_interaction, bcs_no_external_call_in_update, bcs_state_committed_before_call, bcs_pull_payment_pattern, bcs_fixed_cap, bcs_burn_reduces_supply, bcs_mint_authorized_only, bcs_supply_audit, bcs_no_hidden_mint, bcs_no_same_block_arbitrage, bcs_collateral_required, bcs_price_oracle_check, bcs_time_weighted_price, bsc_value_conservation, bsc_reentrancy_guard, bsc_token_supply, bsc_flash_loan_guard, bsc_consensus_safety, bsc_finality_guarantee>>

\* Specification
Spec == Init /\ [][Next]_<<bcs_total_supply_invariant, bcs_no_mint_without_burn, bcs_transfer_balance_sum, bcs_no_overflow_on_transfer, bcs_atomic_transfer, bcs_audit_trail, bcs_mutex_lock, bcs_check_effects_interaction, bcs_no_external_call_in_update, bcs_state_committed_before_call, bcs_pull_payment_pattern, bcs_fixed_cap, bcs_burn_reduces_supply, bcs_mint_authorized_only, bcs_supply_audit, bcs_no_hidden_mint, bcs_no_same_block_arbitrage, bcs_collateral_required, bcs_price_oracle_check, bcs_time_weighted_price, bsc_value_conservation, bsc_reentrancy_guard, bsc_token_supply, bsc_flash_loan_guard, bsc_consensus_safety, bsc_finality_guarantee>>

====

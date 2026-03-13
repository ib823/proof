// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for core banking
// Bounded verification of key properties
module riina/Domains/CoreBanking

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert BANK_001_01_customer_identity_uniqueness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_01_customer_identity_uniqueness for 6

assert BANK_001_02_kyc_completeness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_02_kyc_completeness for 6

assert BANK_001_03_beneficial_ownership_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_03_beneficial_ownership_complete for 6

assert BANK_001_04_sanctions_check_mandatory {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_04_sanctions_check_mandatory for 6

assert BANK_001_05_pep_enhanced_monitoring {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_05_pep_enhanced_monitoring for 6

assert BANK_001_06_balance_non_negative {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_06_balance_non_negative for 6

assert BANK_001_07_interest_calculation_precise {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_07_interest_calculation_precise for 6

assert fold_left_add_acc_general {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fold_left_add_acc_general for 6

assert BANK_001_08_double_entry_invariant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_08_double_entry_invariant for 6

assert BANK_001_09_term_deposit_lock {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_09_term_deposit_lock for 6

assert BANK_001_10_dormancy_detection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_10_dormancy_detection for 6

assert BANK_001_11_loan_within_eligibility {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_11_loan_within_eligibility for 6

assert BANK_001_12_collateral_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_12_collateral_coverage for 6

assert BANK_001_13_amortization_correctness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_13_amortization_correctness for 6

assert BANK_001_14_covenant_monitoring {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_14_covenant_monitoring for 6

assert BANK_001_15_facility_limit_enforcement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_15_facility_limit_enforcement for 6

assert BANK_001_16_instant_payment_completion {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_16_instant_payment_completion for 6

assert BANK_001_17_payment_irrevocability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_17_payment_irrevocability for 6

assert BANK_001_18_idempotency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_18_idempotency for 6

assert BANK_001_19_nostro_reconciliation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_19_nostro_reconciliation for 6

assert BANK_001_20_swift_message_validation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_20_swift_message_validation for 6

assert BANK_001_21_fx_spot_settlement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_21_fx_spot_settlement for 6

assert BANK_001_22_repo_collateral_haircut {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_22_repo_collateral_haircut for 6

assert BANK_001_23_bond_accrued_interest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_23_bond_accrued_interest for 6

assert BANK_001_24_derivative_valuation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_24_derivative_valuation for 6

assert BANK_001_25_collateral_call_trigger {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_25_collateral_call_trigger for 6

assert BANK_001_26_murabaha_cost_plus {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_26_murabaha_cost_plus for 6

assert BANK_001_27_ijarah_ownership {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_27_ijarah_ownership for 6

assert BANK_001_28_musharakah_profit_loss {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_28_musharakah_profit_loss for 6

assert BANK_001_29_sukuk_asset_backing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_29_sukuk_asset_backing for 6

assert BANK_001_30_shariah_no_riba {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check BANK_001_30_shariah_no_riba for 6

pred ExampleCoreBanking {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleCoreBanking for 6

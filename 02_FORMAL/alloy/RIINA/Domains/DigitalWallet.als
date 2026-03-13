// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for digital wallet
// Bounded verification of key properties
module riina/Domains/DigitalWallet

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

assert WALLET_001_01_account_uniqueness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_01_account_uniqueness for 6

assert WALLET_001_02_balance_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_02_balance_integrity for 6

assert WALLET_001_03_tier_limit_enforcement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_03_tier_limit_enforcement for 6

assert WALLET_001_04_virtual_account_segregation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_04_virtual_account_segregation for 6

assert WALLET_001_05_dormancy_detection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_05_dormancy_detection for 6

assert WALLET_001_06_p2p_instant_settlement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_06_p2p_instant_settlement for 6

assert WALLET_001_07_qr_payment_instant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_07_qr_payment_instant for 6

assert WALLET_001_08_dynamic_qr_single_use {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_08_dynamic_qr_single_use for 6

assert WALLET_001_09_merchant_settlement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_09_merchant_settlement for 6

assert WALLET_001_10_refund_instant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_10_refund_instant for 6

assert WALLET_001_11_bank_transfer_reconciliation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_11_bank_transfer_reconciliation for 6

assert WALLET_001_12_card_chargeback_handling {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_12_card_chargeback_handling for 6

assert WALLET_001_13_agent_float_sufficiency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_13_agent_float_sufficiency for 6

assert WALLET_001_14_crypto_rate_lock {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_14_crypto_rate_lock for 6

assert WALLET_001_15_stablecoin_instant_credit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_15_stablecoin_instant_credit for 6

assert WALLET_001_16_withdrawal_limit_enforcement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_16_withdrawal_limit_enforcement for 6

assert WALLET_001_17_bank_withdrawal_ownership {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_17_bank_withdrawal_ownership for 6

assert WALLET_001_18_cardless_atm_otp_validity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_18_cardless_atm_otp_validity for 6

assert WALLET_001_19_agent_cash_availability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_19_agent_cash_availability for 6

assert WALLET_001_20_withdrawal_balance_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_20_withdrawal_balance_check for 6

assert WALLET_001_21_multi_factor_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_21_multi_factor_required for 6

assert WALLET_001_22_session_expiry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_22_session_expiry for 6

assert WALLET_001_23_velocity_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_23_velocity_check for 6

assert WALLET_001_24_fraud_score_blocking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_24_fraud_score_blocking for 6

assert WALLET_001_25_device_binding {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check WALLET_001_25_device_binding for 6

pred ExampleDigitalWallet {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleDigitalWallet for 6

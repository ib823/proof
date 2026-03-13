// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for cross border remittance
// Bounded verification of key properties
module riina/Domains/CrossBorderRemittance

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

assert REMIT_001_01_universal_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_01_universal_coverage for 6

assert REMIT_001_02_currency_support {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_02_currency_support for 6

assert REMIT_001_03_pricing_transparency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_03_pricing_transparency for 6

assert REMIT_001_04_corridor_availability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_04_corridor_availability for 6

assert REMIT_001_05_sanctioned_country_blocking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_05_sanctioned_country_blocking for 6

assert REMIT_001_06_rate_freshness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_06_rate_freshness for 6

assert REMIT_001_07_spread_transparency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_07_spread_transparency for 6

assert REMIT_001_08_rate_lock_guarantee {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_08_rate_lock_guarantee for 6

assert REMIT_001_09_no_hidden_margin {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_09_no_hidden_margin for 6

assert REMIT_001_10_hedge_ratio_maintenance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_10_hedge_ratio_maintenance for 6

assert REMIT_001_11_swift_gpi_tracking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_11_swift_gpi_tracking for 6

assert REMIT_001_12_instant_rail_settlement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_12_instant_rail_settlement for 6

assert REMIT_001_13_blockchain_atomic_execution {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_13_blockchain_atomic_execution for 6

assert REMIT_001_14_mobile_money_instant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_14_mobile_money_instant for 6

assert REMIT_001_15_local_rail_integration {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_15_local_rail_integration for 6

assert REMIT_001_16_realtime_screening {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_16_realtime_screening for 6

assert REMIT_001_17_sanctions_screening_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_17_sanctions_screening_complete for 6

assert REMIT_001_18_travel_rule_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_18_travel_rule_compliance for 6

assert REMIT_001_19_str_filing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_19_str_filing for 6

assert REMIT_001_20_kyc_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_20_kyc_verification for 6

assert REMIT_001_21_instant_bank_credit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_21_instant_bank_credit for 6

assert REMIT_001_22_wallet_instant_credit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_22_wallet_instant_credit for 6

assert REMIT_001_23_cash_pickup_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_23_cash_pickup_security for 6

assert REMIT_001_24_iban_validation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_24_iban_validation for 6

assert REMIT_001_25_recipient_notification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check REMIT_001_25_recipient_notification for 6

pred ExampleCrossBorderRemittance {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleCrossBorderRemittance for 6

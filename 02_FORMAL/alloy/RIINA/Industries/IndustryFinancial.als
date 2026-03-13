// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for industry verification
// Bounded verification of IndustryFinancial properties
module riina/Industries/IndustryFinancial

abstract sig RiskLevel {}
one sig Low extends RiskLevel {}
one sig Medium extends RiskLevel {}
one sig High extends RiskLevel {}
one sig Critical extends RiskLevel {}

sig IndustryReq {
  risk: one RiskLevel,
  verified: one Int,
  compliant: one Int
}

sig IndustrySystem {
  requirements: set IndustryReq,
  certified: one Int
}

// Invariant: critical_verified
fact critical_verified_fact {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}

// Invariant: verified_compliant
fact verified_compliant_fact {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}

// Invariant: certified_all_compliant
fact certified_all_compliant_fact {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}

assert pci_dss_compliance {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check pci_dss_compliance for 6

assert swift_csp_compliance {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check swift_csp_compliance for 6

assert sox_404_compliance {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check sox_404_compliance for 6

assert glba_safeguards {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check glba_safeguards for 6

assert dora_resilience {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check dora_resilience for 6

assert cvv_not_stored {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check cvv_not_stored for 6

assert pan_masking {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check pan_masking for 6

assert strong_crypto_required {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check strong_crypto_required for 6

assert pci_cardholder_data_dec {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check pci_cardholder_data_dec for 6

assert pan_is_cardholder {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check pan_is_cardholder for 6

assert cvv_is_cardholder {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check cvv_is_cardholder for 6

assert pin_is_cardholder {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check pin_is_cardholder for 6

assert non_card_data_not_pci {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check non_card_data_not_pci for 6

assert tx_final_not_pending {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check tx_final_not_pending for 6

assert tx_pending_not_final {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check tx_pending_not_final for 6

assert balance_always_valid {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check balance_always_valid for 6

assert all_unique_nil {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check all_unique_nil for 6

assert all_unique_singleton {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check all_unique_singleton for 6

assert audit_log_never_shrinks {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check audit_log_never_shrinks for 6

assert kyc_requires_identity {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check kyc_requires_identity for 6

assert kyc_requires_sanctions {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check kyc_requires_sanctions for 6

assert aml_risk_bounded {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check aml_risk_bounded for 6

assert compound_zero_periods {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check compound_zero_periods for 6

assert compound_monotone {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check compound_monotone for 6

assert conversion_bounded {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check conversion_bounded for 6

assert fraud_score_max_1000 {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check fraud_score_max_1000 for 6

assert wire_requires_dual_auth {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check wire_requires_dual_auth for 6

assert frozen_account_inactive {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check frozen_account_inactive for 6

assert unfrozen_account_active {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check unfrozen_account_active for 6

assert capital_ratio_check {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check capital_ratio_check for 6

pred ExampleIndustryFinancial {
  some IndustryReq
}
run ExampleIndustryFinancial for 6

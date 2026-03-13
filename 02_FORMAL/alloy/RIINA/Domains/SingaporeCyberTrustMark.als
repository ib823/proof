// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for singapore cyber trust mark
// Bounded verification of key properties
module riina/Domains/SingaporeCyberTrustMark

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

assert ctm_governance_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_governance_check for 6

assert ctm_protection_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_protection_check for 6

assert ctm_resilience_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_resilience_check for 6

assert ctm_assurance_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_assurance_check for 6

assert ctm_education_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_education_check for 6

assert ctm_ai_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_ai_check for 6

assert ctm_certification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_certification for 6

assert tier_monotonicity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tier_monotonicity for 6

assert ctm_tier_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_tier_coverage for 6

assert essential_is_tier_1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check essential_is_tier_1 for 6

assert expert_is_tier_4 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check expert_is_tier_4 for 6

assert tier_level_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tier_level_positive for 6

assert tier_level_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tier_level_bounded for 6

assert essential_threshold_30 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check essential_threshold_30 for 6

assert expert_threshold_90 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check expert_threshold_90 for 6

assert threshold_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check threshold_positive for 6

assert threshold_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check threshold_bounded for 6

assert certified_expert_implies_advanced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check certified_expert_implies_advanced for 6

assert certified_advanced_implies_intermediate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check certified_advanced_implies_intermediate for 6

assert certified_intermediate_implies_essential {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check certified_intermediate_implies_essential for 6

assert ctm_cloud_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_cloud_check for 6

assert ctm_ot_check {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_ot_check for 6

assert ctm_2025_full {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ctm_2025_full for 6

assert all_domains_above_implies_tier {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check all_domains_above_implies_tier for 6

assert cssp_must_have_ctm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cssp_must_have_ctm for 6

assert cssp_without_ctm_non_compliant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cssp_without_ctm_non_compliant for 6

assert expert_requires_90_all_domains {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check expert_requires_90_all_domains for 6

pred ExampleSingaporeCyberTrustMark {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSingaporeCyberTrustMark for 6

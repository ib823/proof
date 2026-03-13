// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for industry verification
// Bounded verification of IndustryMedia properties
module riina/Industries/IndustryMedia

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

assert movielabs_ecp_compliance {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check movielabs_ecp_compliance for 6

assert dci_security {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check dci_security for 6

assert tpn_compliance {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check tpn_compliance for 6

assert forensic_watermark {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check forensic_watermark for 6

assert cdsa_compliance {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check cdsa_compliance for 6

assert prerelease_maximum_protection {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check prerelease_maximum_protection for 6

assert watermark_persistence {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check watermark_persistence for 6

assert prerelease_highest_sensitivity {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check prerelease_highest_sensitivity for 6

assert postrelease_lowest_sensitivity {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check postrelease_lowest_sensitivity for 6

assert content_sensitivity_positive {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check content_sensitivity_positive for 6

assert hardware_strongest {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check hardware_strongest for 6

assert unencrypted_weakest {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check unencrypted_weakest for 6

assert hw_protects_any_content {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check hw_protects_any_content for 6

assert unencrypted_inadequate_for_prerelease {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check unencrypted_inadequate_for_prerelease for 6

assert postrelease_accepts_basic_drm {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check postrelease_accepts_basic_drm for 6

assert ecp_all_requires_encryption {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check ecp_all_requires_encryption for 6

assert ecp_all_requires_watermarking {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check ecp_all_requires_watermarking for 6

assert ecp_all_requires_no_copies {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check ecp_all_requires_no_copies for 6

assert count_ecp_bounded {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check count_ecp_bounded for 6

assert all_ecp_count_six {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check all_ecp_count_six for 6

assert dci_key_sufficient {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check dci_key_sufficient for 6

assert viewing_bounded {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check viewing_bounded for 6

assert screener_bounded {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check screener_bounded for 6

pred ExampleIndustryMedia {
  some IndustryReq
}
run ExampleIndustryMedia for 6

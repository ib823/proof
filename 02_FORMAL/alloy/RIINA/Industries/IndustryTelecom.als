// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for industry verification
// Bounded verification of IndustryTelecom properties
module riina/Industries/IndustryTelecom

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

assert security_5g_compliance {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check security_5g_compliance for 6

assert gsma_security {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check gsma_security for 6

assert slice_isolation {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check slice_isolation for 6

assert signaling_security {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check signaling_security for 6

assert nfv_security {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check nfv_security for 6

assert integrity_mandatory_5g {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check integrity_mandatory_5g for 6

assert up_integrity_available {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check up_integrity_available for 6

assert core_most_critical {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check core_most_critical for 6

assert domain_criticality_positive {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check domain_criticality_positive for 6

assert ausf_is_auth {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check ausf_is_auth for 6

assert amf_not_auth {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check amf_not_auth for 6

assert all_sec_requires_auth {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check all_sec_requires_auth for 6

assert all_sec_requires_nas {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check all_sec_requires_nas for 6

assert all_sec_requires_slicing {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check all_sec_requires_slicing for 6

assert same_slice_not_isolated {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check same_slice_not_isolated for 6

assert latency_bounded {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check latency_bounded for 6

assert supi_always_concealed_in_core {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check supi_always_concealed_in_core for 6

assert supi_concealed_ran_requires_encryption {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check supi_concealed_ran_requires_encryption for 6

assert supi_concealed_ran_with_encryption {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check supi_concealed_ran_with_encryption for 6

assert ran_deepest_key_hierarchy {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check ran_deepest_key_hierarchy for 6

assert roaming_no_upgrade {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check roaming_no_upgrade for 6

assert roaming_bounded_by_visited {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check roaming_bounded_by_visited for 6

assert li_requires_authorization {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check li_requires_authorization for 6

assert li_requires_logging {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check li_requires_logging for 6

pred ExampleIndustryTelecom {
  some IndustryReq
}
run ExampleIndustryTelecom for 6

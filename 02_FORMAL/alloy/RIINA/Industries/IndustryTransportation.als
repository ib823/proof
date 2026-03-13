// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for industry verification
// Bounded verification of IndustryTransportation properties
module riina/Industries/IndustryTransportation

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

assert iso_26262_compliance {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check iso_26262_compliance for 6

assert iso_21434_cybersecurity {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check iso_21434_cybersecurity for 6

assert unece_r155_compliance {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check unece_r155_compliance for 6

assert en_50128_compliance {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check en_50128_compliance for 6

assert imo_maritime_cyber {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check imo_maritime_cyber for 6

assert asil_d_highest_rigor {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check asil_d_highest_rigor for 6

assert cyber_safety_interface {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check cyber_safety_interface for 6

assert asil_le_refl {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check asil_le_refl for 6

assert asil_le_trans {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check asil_le_trans for 6

assert asil_le_antisym {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check asil_le_antisym for 6

assert sil_le_refl {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check sil_le_refl for 6

assert asil_d_full_coverage {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check asil_d_full_coverage for 6

assert asil_coverage_monotone {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check asil_coverage_monotone for 6

assert work_products_monotone {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check work_products_monotone for 6

assert asil_decomposition_valid {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check asil_decomposition_valid for 6

assert full_requires_hazard_analysis {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check full_requires_hazard_analysis for 6

assert full_requires_software_design {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check full_requires_software_design for 6

assert full_requires_cyber_interface {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check full_requires_cyber_interface for 6

assert sil4_zero_tolerable_hazard {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check sil4_zero_tolerable_hazard for 6

assert hazard_rate_decreasing {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check hazard_rate_decreasing for 6

assert safety_critical_faster_auth {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check safety_critical_faster_auth for 6

assert version_no_downgrade {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check version_no_downgrade for 6

pred ExampleIndustryTransportation {
  some IndustryReq
}
run ExampleIndustryTransportation for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for industry verification
// Bounded verification of IndustryManufacturing properties
module riina/Industries/IndustryManufacturing

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

assert iec_62443_compliance {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check iec_62443_compliance for 6

assert iec_61508_safety {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check iec_61508_safety for 6

assert zone_conduit_security {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check zone_conduit_security for 6

assert secure_development_lifecycle {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check secure_development_lifecycle for 6

assert nist_800_82_compliance {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check nist_800_82_compliance for 6

assert sl4_state_level_protection {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check sl4_state_level_protection for 6

assert zone_boundary_enforcement {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check zone_boundary_enforcement for 6

assert sl_le_refl {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check sl_le_refl for 6

assert sl_le_trans {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check sl_le_trans for 6

assert sl_le_antisym {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check sl_le_antisym for 6

assert sil_le_refl {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check sil_le_refl for 6

assert sil_positive {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check sil_positive for 6

assert purdue_le_refl {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check purdue_le_refl for 6

assert same_level_adjacent {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check same_level_adjacent for 6

assert sff_minimum_60 {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check sff_minimum_60 for 6

assert higher_sil_higher_sff {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check higher_sil_higher_sff for 6

assert full_compliance_requires_zones {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check full_compliance_requires_zones for 6

assert full_compliance_requires_secure_dev {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check full_compliance_requires_secure_dev for 6

assert sl4_full_coverage {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check sl4_full_coverage for 6

assert testing_coverage_monotone {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check testing_coverage_monotone for 6

assert process_level_isolated {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check process_level_isolated for 6

assert control_level_isolated {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check control_level_isolated for 6

assert business_level_not_ot {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check business_level_not_ot for 6

assert patch_window_decreasing {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check patch_window_decreasing for 6

pred ExampleIndustryManufacturing {
  some IndustryReq
}
run ExampleIndustryManufacturing for 6

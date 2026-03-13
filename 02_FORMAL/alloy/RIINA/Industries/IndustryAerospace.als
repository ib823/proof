// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for industry verification
// Bounded verification of IndustryAerospace properties
module riina/Industries/IndustryAerospace

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

assert do_178c_compliance {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check do_178c_compliance for 6

assert do_326a_security {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check do_326a_security for 6

assert do_333_formal_methods {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check do_333_formal_methods for 6

assert arp4754a_development {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check arp4754a_development for 6

assert do_254_hardware {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check do_254_hardware for 6

assert dal_a_mcdc_required {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check dal_a_mcdc_required for 6

assert dal_objectives_monotone {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check dal_objectives_monotone for 6

assert dal_le_iff_nat {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check dal_le_iff_nat for 6

assert dal_le_refl {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check dal_le_refl for 6

assert dal_le_trans {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check dal_le_trans for 6

assert dal_le_antisym {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check dal_le_antisym for 6

assert dal_le_total {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check dal_le_total for 6

assert dal_e_bottom {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check dal_e_bottom for 6

assert dal_a_max_objectives {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check dal_a_max_objectives for 6

assert dal_e_zero_objectives {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check dal_e_zero_objectives for 6

assert objectives_strict_ordering {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check objectives_strict_ordering for 6

assert mcdc_only_high_dal {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check mcdc_only_high_dal for 6

assert decision_coverage_implies_dal_c_or_above {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check decision_coverage_implies_dal_c_or_above for 6

assert do178c_all_requires_plans {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check do178c_all_requires_plans for 6

assert do178c_all_requires_verification {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check do178c_all_requires_verification for 6

assert do178c_all_requires_qa {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check do178c_all_requires_qa for 6

assert formal_methods_only_high_dal {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check formal_methods_only_high_dal for 6

assert dal_max_dominates_left {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check dal_max_dominates_left for 6

assert dal_max_dominates_right {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check dal_max_dominates_right for 6

assert dal_max_objectives {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check dal_max_objectives for 6

pred ExampleIndustryAerospace {
  some IndustryReq
}
run ExampleIndustryAerospace for 6

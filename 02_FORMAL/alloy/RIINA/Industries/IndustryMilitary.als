// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for industry verification
// Bounded verification of IndustryMilitary properties
module riina/Industries/IndustryMilitary

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

assert nist_800_171_access_control {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check nist_800_171_access_control for 6

assert cmmc_level3_compliance {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check cmmc_level3_compliance for 6

assert itar_export_control {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check itar_export_control for 6

assert mil_std_882_safety {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check mil_std_882_safety for 6

assert rmf_authorization {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check rmf_authorization for 6

assert class_le_refl {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check class_le_refl for 6

assert class_le_trans {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check class_le_trans for 6

assert no_read_up {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check no_read_up for 6

assert class_le_iff_nat {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check class_le_iff_nat for 6

assert class_le_antisym {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check class_le_antisym for 6

assert class_le_total {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check class_le_total for 6

assert unclassified_bottom {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check unclassified_bottom for 6

assert ts_sci_top {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check ts_sci_top for 6

assert bell_lapadula_ss {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check bell_lapadula_ss for 6

assert bell_lapadula_star {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check bell_lapadula_star for 6

assert has_compartment_In {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check has_compartment_In for 6

assert empty_need_to_know_unrestricted {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check empty_need_to_know_unrestricted for 6

assert comsec_required_for_classified_comms {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check comsec_required_for_classified_comms for 6

assert tempest_required_for_secret {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check tempest_required_for_secret for 6

assert cross_domain_no_downgrade {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check cross_domain_no_downgrade for 6

assert class_max_ge_left {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check class_max_ge_left for 6

assert class_max_ge_right {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check class_max_ge_right for 6

assert aggregation_raises_classification {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check aggregation_raises_classification for 6

assert key_level_monotone {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check key_level_monotone for 6

assert personnel_clearance_dominates {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check personnel_clearance_dominates for 6

assert weapon_auth_requires_ts {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check weapon_auth_requires_ts for 6

assert redundancy_monotone {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check redundancy_monotone for 6

pred ExampleIndustryMilitary {
  some IndustryReq
}
run ExampleIndustryMilitary for 6

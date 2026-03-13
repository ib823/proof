// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for industry verification
// Bounded verification of IndustryEnergy properties
module riina/Industries/IndustryEnergy

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

assert nerc_cip_compliance {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check nerc_cip_compliance for 6

assert iec_62351_security {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check iec_62351_security for 6

assert nrc_cyber_security {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check nrc_cyber_security for 6

assert ot_security {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check ot_security for 6

assert substation_security {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check substation_security for 6

assert high_impact_all_controls {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check high_impact_all_controls for 6

assert esp_required {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check esp_required for 6

assert cip_le_refl {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check cip_le_refl for 6

assert cip_le_trans {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check cip_le_trans for 6

assert high_impact_all_11 {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check high_impact_all_11 for 6

assert cip_requirements_monotone {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check cip_requirements_monotone for 6

assert full_cip_requires_identification {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check full_cip_requires_identification for 6

assert full_cip_requires_perimeter {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check full_cip_requires_perimeter for 6

assert full_cip_requires_supply_chain {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check full_cip_requires_supply_chain for 6

assert control_center_critical {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check control_center_critical for 6

assert scada_critical {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check scada_critical for 6

assert bes_criticality_positive {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check bes_criticality_positive for 6

assert high_impact_fastest_response {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check high_impact_fastest_response for 6

assert response_time_decreasing {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check response_time_decreasing for 6

assert rto_bounded {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check rto_bounded for 6

assert high_impact_short_rto {
  all s: IndustrySystem | s.certified = 1 implies (all r: s.requirements | r.compliant = 1)
}
check high_impact_short_rto for 6

assert assessment_more_frequent_high {
  all r: IndustryReq | r.risk = Critical implies r.verified = 1
}
check assessment_more_frequent_high for 6

assert high_medium_same_retention {
  all r: IndustryReq | r.verified = 1 implies r.compliant = 1
}
check high_medium_same_retention for 6

pred ExampleIndustryEnergy {
  some IndustryReq
}
run ExampleIndustryEnergy for 6

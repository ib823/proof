// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for regulatory compliance
// Bounded verification of ASEANCompliance properties
module riina/Domains/ASEANCompliance

abstract sig Severity {}
one sig Low extends Severity {}
one sig Medium extends Severity {}
one sig High extends Severity {}
one sig Critical extends Severity {}

sig ComplianceControl {
  severity: one Severity,
  implemented: one Int,
  verified: one Int
}

sig ComplianceReport {
  controls: set ComplianceControl,
  compliant: one Int
}

// Invariant: critical_must_implement
fact critical_must_implement_fact {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}

// Invariant: verified_implies_implemented
fact verified_implies_implemented_fact {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}

// Invariant: compliant_all_critical
fact compliant_all_critical_fact {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}

assert 1 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check 1 for 6

assert 2 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check 2 for 6

assert 3 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check 3 for 6

assert jurisdiction_leq_transitive {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check jurisdiction_leq_transitive for 6

assert jurisdiction_preorder {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check jurisdiction_preorder for 6

assert 4 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check 4 for 6

assert 5 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check 5 for 6

assert 6 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check 6 for 6

assert 7 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check 7 for 6

assert audit_trail_preservation {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check audit_trail_preservation for 6

assert 8 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check 8 for 6

assert 9 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check 9 for 6

assert 10 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check 10 for 6

assert local_only_blocks_cross_border {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check local_only_blocks_cross_border for 6

assert regional_allows_intra_asean {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check regional_allows_intra_asean for 6

assert global_allows_all {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check global_allows_all for 6

assert adequacy_list_membership {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check adequacy_list_membership for 6

assert asean_data_flow_compliant {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check asean_data_flow_compliant for 6

assert breach_notification_timeliness {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check breach_notification_timeliness for 6

assert stricter_deadline_satisfies_weaker {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check stricter_deadline_satisfies_weaker for 6

assert mcc_compliance {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check mcc_compliance for 6

assert higher_standard_subsumes {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check higher_standard_subsumes for 6

assert mutual_recognition_symmetric {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check mutual_recognition_symmetric for 6

assert classification_bounded {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check classification_bounded for 6

assert audit_trail_monotonic {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check audit_trail_monotonic for 6

assert two_transfers_logged {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check two_transfers_logged for 6

assert localization_coverage {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check localization_coverage for 6

assert dpo_appointed_when_required {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check dpo_appointed_when_required for 6

assert dpo_not_required_always_met {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check dpo_not_required_always_met for 6

pred ExampleASEANCompliance {
  some ComplianceControl
}
run ExampleASEANCompliance for 6

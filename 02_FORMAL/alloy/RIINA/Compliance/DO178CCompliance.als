// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for regulatory compliance
// Bounded verification of DO178CCompliance properties
module riina/Compliance/DO178CCompliance

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

assert COMPLY_003_01 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_003_01 for 6

assert COMPLY_003_02 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_003_02 for 6

assert COMPLY_003_03 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_003_03 for 6

assert COMPLY_003_04 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_003_04 for 6

assert COMPLY_003_05 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_003_05 for 6

assert COMPLY_003_06 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_003_06 for 6

assert COMPLY_003_07 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_003_07 for 6

assert COMPLY_003_08 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_003_08 for 6

assert COMPLY_003_09 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_003_09 for 6

assert COMPLY_003_10 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_003_10 for 6

assert COMPLY_003_11 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_003_11 for 6

assert COMPLY_003_12 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_003_12 for 6

assert COMPLY_003_13 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_003_13 for 6

assert COMPLY_003_14 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_003_14 for 6

assert COMPLY_003_15 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_003_15 for 6

assert COMPLY_003_16 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_003_16 for 6

assert COMPLY_003_17 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_003_17 for 6

assert COMPLY_003_18 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_003_18 for 6

assert COMPLY_003_19 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_003_19 for 6

assert COMPLY_003_20 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_003_20 for 6

assert DAL_A_Full_Compliance {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DAL_A_Full_Compliance for 6

pred ExampleDO178CCompliance {
  some ComplianceControl
}
run ExampleDO178CCompliance for 6

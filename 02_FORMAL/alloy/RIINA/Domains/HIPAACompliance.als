// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for regulatory compliance
// Bounded verification of HIPAACompliance properties
module riina/Domains/HIPAACompliance

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

assert COMPLY_001_01 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_001_01 for 6

assert COMPLY_001_02 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_001_02 for 6

assert COMPLY_001_03 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_001_03 for 6

assert COMPLY_001_04 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_001_04 for 6

assert COMPLY_001_05 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_001_05 for 6

assert COMPLY_001_06 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_001_06 for 6

assert COMPLY_001_07 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_001_07 for 6

assert COMPLY_001_08 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_001_08 for 6

assert COMPLY_001_09 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_001_09 for 6

assert COMPLY_001_10 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_001_10 for 6

assert COMPLY_001_11 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_001_11 for 6

assert COMPLY_001_12 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_001_12 for 6

assert COMPLY_001_13 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_001_13 for 6

assert COMPLY_001_14 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_001_14 for 6

assert COMPLY_001_15 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_001_15 for 6

assert COMPLY_001_16 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_001_16 for 6

assert COMPLY_001_17 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_001_17 for 6

assert COMPLY_001_18 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_001_18 for 6

assert COMPLY_001_19 {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_001_19 for 6

assert COMPLY_001_20 {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_001_20 for 6

assert COMPLY_001_21 {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_001_21 for 6

pred ExampleHIPAACompliance {
  some ComplianceControl
}
run ExampleHIPAACompliance for 6

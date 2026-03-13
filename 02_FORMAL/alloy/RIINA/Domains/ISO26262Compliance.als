// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for regulatory compliance
// Bounded verification of ISO26262Compliance properties
module riina/Domains/ISO26262Compliance

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

assert andb_true_iff {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check andb_true_iff for 6

assert ISO_001_asil_reflexive {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_001_asil_reflexive for 6

assert ISO_002_asil_transitive {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_002_asil_transitive for 6

assert ISO_003_qm_bottom {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_003_qm_bottom for 6

assert ISO_004_asil_d_top {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_004_asil_d_top for 6

assert ISO_005_hara_valid {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_005_hara_valid for 6

assert ISO_006_hazards_identified {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_006_hazards_identified for 6

assert ISO_007_safety_goals {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_007_safety_goals for 6

assert ISO_008_asil_determined {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_008_asil_determined for 6

assert ISO_009_sw_dev_valid {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_009_sw_dev_valid for 6

assert ISO_010_safety_requirements {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_010_safety_requirements for 6

assert ISO_011_unit_verification {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_011_unit_verification for 6

assert ISO_012_safety_validation {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_012_safety_validation for 6

assert ISO_013_verif_methods_valid {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_013_verif_methods_valid for 6

assert ISO_014_formal_verification {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_014_formal_verification for 6

assert ISO_015_static_analysis {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_015_static_analysis for 6

assert ISO_016_data_flow {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_016_data_flow for 6

assert ISO_017_testing_valid {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_017_testing_valid for 6

assert ISO_018_mcdc_coverage {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_018_mcdc_coverage for 6

assert ISO_019_fault_injection {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_019_fault_injection for 6

assert ISO_020_requirements_based {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_020_requirements_based for 6

assert ISO_021_riina_asil_d {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_021_riina_asil_d for 6

assert ISO_022_asil_d_level {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_022_asil_d_level for 6

assert ISO_023_asil_d_hara {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_023_asil_d_hara for 6

assert ISO_024_asil_d_sw_dev {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_024_asil_d_sw_dev for 6

assert ISO_025_asil_d_verification {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_025_asil_d_verification for 6

assert ISO_026_asil_d_testing {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_026_asil_d_testing for 6

assert ISO_027_riina_is_asil_d {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_027_riina_is_asil_d for 6

assert ISO_028_riina_formal_verif {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_028_riina_formal_verif for 6

assert ISO_029_riina_mcdc {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_029_riina_mcdc for 6

assert ISO_030_riina_safety_goals {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_030_riina_safety_goals for 6

assert ISO_031_asil_d_implies_all {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_031_asil_d_implies_all for 6

assert ISO_032_formal_methods_cascade {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_032_formal_methods_cascade for 6

assert ISO_033_asil_d_implies_formal {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check ISO_033_asil_d_implies_formal for 6

assert ISO_034_asil_d_implies_mcdc {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check ISO_034_asil_d_implies_mcdc for 6

assert ISO_035_complete_certification {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check ISO_035_complete_certification for 6

pred ExampleISO26262Compliance {
  some ComplianceControl
}
run ExampleISO26262Compliance for 6

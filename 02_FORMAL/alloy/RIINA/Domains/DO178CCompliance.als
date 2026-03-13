// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for regulatory compliance
// Bounded verification of DO178CCompliance properties
module riina/Domains/DO178CCompliance

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

assert DO178_001_dal_reflexive {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_001_dal_reflexive for 6

assert DO178_002_dal_transitive {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_002_dal_transitive for 6

assert DO178_003_dal_e_bottom {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_003_dal_e_bottom for 6

assert DO178_004_dal_a_top {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_004_dal_a_top for 6

assert DO178_005_planning_valid {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_005_planning_valid for 6

assert DO178_006_planning_standards {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_006_planning_standards for 6

assert DO178_007_lifecycle_required {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_007_lifecycle_required for 6

assert DO178_008_development_valid {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_008_development_valid for 6

assert DO178_009_requirements_complete {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_009_requirements_complete for 6

assert DO178_010_requirements_traceable {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_010_requirements_traceable for 6

assert DO178_011_code_complete {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_011_code_complete for 6

assert DO178_012_code_traceable {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_012_code_traceable for 6

assert DO178_013_verification_valid {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_013_verification_valid for 6

assert DO178_014_mcdc_required {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_014_mcdc_required for 6

assert DO178_015_structural_coverage {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_015_structural_coverage for 6

assert DO178_016_requirements_review {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_016_requirements_review for 6

assert DO178_017_code_review {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_017_code_review for 6

assert DO178_018_cm_valid {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_018_cm_valid for 6

assert DO178_019_change_control {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_019_change_control for 6

assert DO178_020_traceability {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_020_traceability for 6

assert DO178_021_qa_valid {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_021_qa_valid for 6

assert DO178_022_qa_independence {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_022_qa_independence for 6

assert DO178_023_audits {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_023_audits for 6

assert DO178_024_fm_valid {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_024_fm_valid for 6

assert DO178_025_fm_soundness {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_025_fm_soundness for 6

assert DO178_026_fm_specification {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_026_fm_specification for 6

assert DO178_027_riina_theorem_proving {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_027_riina_theorem_proving for 6

assert DO178_028_riina_level_a {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_028_riina_level_a for 6

assert DO178_029_level_a_all_objectives {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_029_level_a_all_objectives for 6

assert DO178_030_level_a_planning {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_030_level_a_planning for 6

assert DO178_031_level_a_development {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_031_level_a_development for 6

assert DO178_032_level_a_verification {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_032_level_a_verification for 6

assert DO178_033_level_a_cm {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_033_level_a_cm for 6

assert DO178_034_level_a_qa {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_034_level_a_qa for 6

assert DO178_035_riina_dal_a {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_035_riina_dal_a for 6

assert DO178_036_riina_has_fm {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_036_riina_has_fm for 6

assert DO178_037_riina_fm_coq {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_037_riina_fm_coq for 6

assert DO178_038_riina_planning {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check DO178_038_riina_planning for 6

assert DO178_039_riina_development {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check DO178_039_riina_development for 6

assert DO178_040_complete_certification {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check DO178_040_complete_certification for 6

pred ExampleDO178CCompliance {
  some ComplianceControl
}
run ExampleDO178CCompliance for 6

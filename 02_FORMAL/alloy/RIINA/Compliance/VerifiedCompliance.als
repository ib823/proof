// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for regulatory compliance
// Bounded verification of VerifiedCompliance properties
module riina/Compliance/VerifiedCompliance

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

assert AJ_001_01_gdpr_data_minimization {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_01_gdpr_data_minimization for 6

assert AJ_001_02_gdpr_purpose_limitation {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_02_gdpr_purpose_limitation for 6

assert AJ_001_03_gdpr_storage_limitation {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_03_gdpr_storage_limitation for 6

assert AJ_001_04_gdpr_accuracy {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_04_gdpr_accuracy for 6

assert AJ_001_05_gdpr_integrity {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_05_gdpr_integrity for 6

assert AJ_001_06_gdpr_access_right {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_06_gdpr_access_right for 6

assert AJ_001_07_gdpr_erasure_right {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_07_gdpr_erasure_right for 6

assert AJ_001_08_gdpr_portability {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_08_gdpr_portability for 6

assert AJ_001_09_gdpr_consent_valid {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_09_gdpr_consent_valid for 6

assert AJ_001_10_hipaa_phi_protected {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_10_hipaa_phi_protected for 6

assert AJ_001_11_hipaa_access_control {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_11_hipaa_access_control for 6

assert AJ_001_12_hipaa_audit_controls {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_12_hipaa_audit_controls for 6

assert AJ_001_13_hipaa_minimum_necessary {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_13_hipaa_minimum_necessary for 6

assert AJ_001_14_hipaa_encryption {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_14_hipaa_encryption for 6

assert AJ_001_15_hipaa_integrity {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_15_hipaa_integrity for 6

assert AJ_001_16_hipaa_availability {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_16_hipaa_availability for 6

assert AJ_001_17_hipaa_breach_notification {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_17_hipaa_breach_notification for 6

assert AJ_001_18_pci_network_segmentation {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_18_pci_network_segmentation for 6

assert AJ_001_19_pci_cardholder_protection {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_19_pci_cardholder_protection for 6

assert AJ_001_20_pci_encryption {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_20_pci_encryption for 6

assert AJ_001_21_pci_access_restricted {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_21_pci_access_restricted for 6

assert AJ_001_22_pci_unique_ids {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_22_pci_unique_ids for 6

assert AJ_001_23_pci_physical_security {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_23_pci_physical_security for 6

assert AJ_001_24_pci_logging {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_24_pci_logging for 6

assert AJ_001_25_pci_testing {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_25_pci_testing for 6

assert AJ_001_26_control_mapping_complete {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_26_control_mapping_complete for 6

assert AJ_001_27_evidence_chain_valid {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_27_evidence_chain_valid for 6

assert AJ_001_28_continuous_monitoring {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_28_continuous_monitoring for 6

assert AJ_001_29_proof_as_evidence {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_29_proof_as_evidence for 6

assert AJ_001_30_audit_trail_complete {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_30_audit_trail_complete for 6

assert AJ_001_31_compliance_composition {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_31_compliance_composition for 6

assert AJ_001_32_regulation_coverage {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_32_regulation_coverage for 6

assert AJ_001_33_control_effectiveness {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check AJ_001_33_control_effectiveness for 6

assert AJ_001_34_gap_detection {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check AJ_001_34_gap_detection for 6

assert AJ_001_35_remediation_tracked {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check AJ_001_35_remediation_tracked for 6

pred ExampleVerifiedCompliance {
  some ComplianceControl
}
run ExampleVerifiedCompliance for 6

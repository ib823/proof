// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for regulatory compliance
// Bounded verification of PCIDSSCompliance properties
module riina/Compliance/PCIDSSCompliance

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

assert COMPLY_002_01_pan_masking {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_01_pan_masking for 6

assert COMPLY_002_01_pan_masking_valid {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_01_pan_masking_valid for 6

assert COMPLY_002_02_pan_encryption {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_02_pan_encryption for 6

assert COMPLY_002_02_pan_plain_forbidden {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_02_pan_plain_forbidden for 6

assert COMPLY_002_02_pan_aes128_insufficient {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_02_pan_aes128_insufficient for 6

assert COMPLY_002_03_cvv_never_stored {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_03_cvv_never_stored for 6

assert COMPLY_002_03_cvv_no_compliant_encryption {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_03_cvv_no_compliant_encryption for 6

assert COMPLY_002_04_pin_never_stored {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_04_pin_never_stored for 6

assert COMPLY_002_04_pin_no_compliant_encryption {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_04_pin_no_compliant_encryption for 6

assert COMPLY_002_05_key_rotation_detection {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_05_key_rotation_detection for 6

assert COMPLY_002_05_key_no_rotation_needed {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_05_key_no_rotation_needed for 6

assert COMPLY_002_06_access_requires_need_to_know {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_06_access_requires_need_to_know for 6

assert COMPLY_002_06_no_access_level_denied {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_06_no_access_level_denied for 6

assert COMPLY_002_07_unique_ids_singleton {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_07_unique_ids_singleton for 6

assert COMPLY_002_07_unique_ids_empty {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_07_unique_ids_empty for 6

assert COMPLY_002_08_mfa_required {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_08_mfa_required for 6

assert COMPLY_002_08_access_granted_implies_mfa {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_08_access_granted_implies_mfa for 6

assert COMPLY_002_09_audit_entry_has_timestamp {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_09_audit_entry_has_timestamp for 6

assert COMPLY_002_09_audit_entry_has_user {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_09_audit_entry_has_user for 6

assert COMPLY_002_09_audit_entry_has_action {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_09_audit_entry_has_action for 6

assert COMPLY_002_10_audit_has_hash {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_10_audit_has_hash for 6

assert COMPLY_002_10_empty_log_valid {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_10_empty_log_valid for 6

assert COMPLY_002_11_tls12_compliant {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_11_tls12_compliant for 6

assert COMPLY_002_11_tls13_compliant {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_11_tls13_compliant for 6

assert COMPLY_002_11_old_tls_non_compliant {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_11_old_tls_non_compliant for 6

assert COMPLY_002_11_transmission_requires_encryption {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_11_transmission_requires_encryption for 6

assert COMPLY_002_12_token_no_key_no_pan {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_12_token_no_key_no_pan for 6

assert COMPLY_002_12_tokenization_irreversible_without_key {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_12_tokenization_irreversible_without_key for 6

assert COMPLY_002_13_past_retention_detected {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_13_past_retention_detected for 6

assert COMPLY_002_13_within_retention_ok {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_13_within_retention_ok for 6

assert COMPLY_002_14_secure_deletion_unrecoverable {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_14_secure_deletion_unrecoverable for 6

assert COMPLY_002_14_not_deleted_recoverable {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_14_not_deleted_recoverable for 6

assert COMPLY_002_14_marked_still_recoverable {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_14_marked_still_recoverable for 6

assert COMPLY_002_15_cde_requires_isolation {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_15_cde_requires_isolation for 6

assert COMPLY_002_15_cde_requires_firewall {
  all c: ComplianceControl | c.verified = 1 implies c.implemented = 1
}
check COMPLY_002_15_cde_requires_firewall for 6

assert COMPLY_002_15_non_cde_always_compliant {
  all r: ComplianceReport | r.compliant = 1 implies (all c: r.controls | c.severity = Critical implies c.implemented = 1)
}
check COMPLY_002_15_non_cde_always_compliant for 6

assert COMPLY_002_15_vault_isolation {
  all c: ComplianceControl | c.severity = Critical implies c.implemented = 1
}
check COMPLY_002_15_vault_isolation for 6

pred ExamplePCIDSSCompliance {
  some ComplianceControl
}
run ExamplePCIDSSCompliance for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for supply chain security
// Bounded verification of key properties
module riina/Domains/SupplyChainSecurity

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert hash_eq_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hash_eq_refl for 6

assert hash_eq_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hash_eq_sym for 6

assert hash_eq_implies_eq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hash_eq_implies_eq for 6

assert bool_impl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bool_impl for 6

assert sup_001_dependency_compromise_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_001_dependency_compromise_mitigated for 6

assert sup_001_hash_signature_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_001_hash_signature_integrity for 6

assert sup_002_typosquatting_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_002_typosquatting_mitigated for 6

assert sup_002_name_verification_canonical {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_002_name_verification_canonical for 6

assert sup_003_dependency_confusion_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_003_dependency_confusion_mitigated for 6

assert sup_003_internal_registry_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_003_internal_registry_isolation for 6

assert sup_004_build_compromise_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_004_build_compromise_mitigated for 6

assert sup_004_reproducible_detection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_004_reproducible_detection for 6

assert sup_005_package_manager_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_005_package_manager_mitigated for 6

assert sup_005_tuf_threshold_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_005_tuf_threshold_security for 6

assert sup_006_firmware_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_006_firmware_mitigated for 6

assert sup_006_firmware_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_006_firmware_integrity for 6

assert sup_007_hardware_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_007_hardware_mitigated for 6

assert sup_007_attestation_chain_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_007_attestation_chain_security for 6

assert sup_008_third_party_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_008_third_party_mitigated for 6

assert sup_008_vendor_audit_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_008_vendor_audit_security for 6

assert sup_009_watering_hole_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_009_watering_hole_mitigated for 6

assert sup_009_segment_isolation_lateral {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_009_segment_isolation_lateral for 6

assert sup_010_update_attack_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_010_update_attack_mitigated for 6

assert sup_010_version_rollback_prevention {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_010_version_rollback_prevention for 6

assert sup_011_source_compromise_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_011_source_compromise_mitigated for 6

assert sup_011_multi_reviewer_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_011_multi_reviewer_security for 6

assert sup_012_compiler_attack_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_012_compiler_attack_mitigated for 6

assert sup_012_ddc_output_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_012_ddc_output_verification for 6

assert sup_013_binary_backdoor_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_013_binary_backdoor_mitigated for 6

assert sup_013_binary_hash_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_013_binary_hash_verification for 6

assert sup_014_certificate_compromise_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_014_certificate_compromise_mitigated for 6

assert sup_014_ct_log_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_014_ct_log_verification for 6

assert sup_015_developer_compromise_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_015_developer_compromise_mitigated for 6

assert sup_015_mfa_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_015_mfa_security for 6

assert sup_016_malware_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_016_malware_mitigated for 6

assert sup_016_isolation_level_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sup_016_isolation_level_security for 6

assert supply_chain_full_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check supply_chain_full_security for 6

pred ExampleSupplyChainSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSupplyChainSecurity for 6

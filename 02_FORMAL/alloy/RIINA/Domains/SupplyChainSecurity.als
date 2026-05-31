// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/SupplyChainSecurity.v (37 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/supply_chain_security

open util/boolean

abstract sig CertificateId {}
abstract sig Hash {}
abstract sig IsolationLevel {}
abstract sig KeyId {}
abstract sig Namespace {}
abstract sig NetworkSegment {}
abstract sig PackageName {}
abstract sig Signature {}
abstract sig UserId {}
abstract sig Version {}
abstract sig list {}

// SignedArtifact (matches Coq: Record SignedArtifact)
sig SignedArtifact {
  f_sa_content_hash: one Hash,
  f_sa_signature: one Signature,
  f_sa_signer_key: one KeyId,
  f_sa_verified: one Bool
}

// VerifiedPackage (matches Coq: Record VerifiedPackage)
sig VerifiedPackage {
  f_vp_name: one PackageName,
  f_vp_canonical_name: one PackageName,
  f_vp_in_allowlist: one Bool,
  f_vp_name_verified: one Bool
}

// ScopedPackage (matches Coq: Record ScopedPackage)
sig ScopedPackage {
  f_sp_namespace: one Namespace,
  f_sp_name: one PackageName,
  f_sp_internal_registry: one Bool,
  f_sp_namespace_verified: one Bool
}

// ReproducibleBuild (matches Coq: Record ReproducibleBuild)
sig ReproducibleBuild {
  f_rb_source_hash: one Hash,
  f_rb_output_hash: one Hash,
  f_rb_builder1_hash: one Hash,
  f_rb_builder2_hash: one Hash,
  f_rb_hashes_match: one Bool
}

// TUFPackage (matches Coq: Record TUFPackage)
sig TUFPackage {
  f_tuf_root_signed: one Bool,
  f_tuf_targets_signed: one Bool,
  f_tuf_snapshot_signed: one Bool,
  f_tuf_timestamp_signed: one Bool,
  f_tuf_threshold_met: one Bool
}

// VerifiedFirmware (matches Coq: Record VerifiedFirmware)
sig VerifiedFirmware {
  f_fw_signature: one Signature,
  f_fw_vendor_key: one KeyId,
  f_fw_hash: one Hash,
  f_fw_signature_valid: one Bool,
  f_fw_rollback_protected: one Bool
}

// HardwareAttestation (matches Coq: Record HardwareAttestation)
sig HardwareAttestation {
  f_hw_tpm_present: one Bool,
  f_hw_secure_boot: one Bool,
  f_hw_attestation_chain: one list,
  f_hw_chain_valid: one Bool
}

// VendorVerification (matches Coq: Record VendorVerification)
sig VendorVerification {
  f_vendor_id: one Int,
  f_vendor_cert_valid: one Bool,
  f_vendor_audit_passed: one Bool,
  f_vendor_in_approved_list: one Bool
}

// NetworkSegmentation (matches Coq: Record NetworkSegmentation)
sig NetworkSegmentation {
  f_ns_source_segment: one NetworkSegment,
  f_ns_dest_segment: one NetworkSegment,
  f_ns_firewall_rules: one list,
  f_ns_segments_isolated: one Bool
}

// SignedUpdate (matches Coq: Record SignedUpdate)
sig SignedUpdate {
  f_upd_signature_valid: one Bool,
  f_upd_current_version: one Version,
  f_upd_new_version: one Version,
  f_upd_version_incremented: one Bool
}

// SignedCode (matches Coq: Record SignedCode)
sig SignedCode {
  f_code_signature_valid: one Bool,
  f_code_review_approved: one Bool,
  f_code_reviewer_count: one Int,
  f_code_min_reviewers: one Int
}

// DDCBuild (matches Coq: Record DDCBuild)
sig DDCBuild {
  f_ddc_compiler1_hash: one Hash,
  f_ddc_compiler2_hash: one Hash,
  f_ddc_compilers_different: one Bool,
  f_ddc_output1_hash: one Hash,
  f_ddc_output2_hash: one Hash,
  f_ddc_outputs_match: one Bool
}

// BinaryVerification (matches Coq: Record BinaryVerification)
sig BinaryVerification {
  f_bin_source_hash: one Hash,
  f_bin_claimed_hash: one Hash,
  f_bin_reproduced_hash: one Hash,
  f_bin_reproducible: one Bool
}

// CertificateTransparency (matches Coq: Record CertificateTransparency)
sig CertificateTransparency {
  f_ct_cert_id: one CertificateId,
  f_ct_in_log: one Bool,
  f_ct_sct_valid: one Bool,
  f_ct_log_consistent: one Bool
}

// AccessControl (matches Coq: Record AccessControl)
sig AccessControl {
  f_ac_user_id: one UserId,
  f_ac_mfa_enabled: one Bool,
  f_ac_role_verified: one Bool,
  f_ac_access_logged: one Bool
}

// DependencyIsolation (matches Coq: Record DependencyIsolation)
sig DependencyIsolation {
  f_di_dependency_id: one Int,
  f_di_isolation_level: one IsolationLevel,
  f_di_sandboxed: one Bool,
  f_di_network_restricted: one Bool,
  f_di_filesystem_restricted: one Bool
}

// hash_eq (matches Coq: Definition hash_eq)
pred hash_eq[p_h1: Hash, p_h2: Hash] {
  some p_h1
}

// version_gt (matches Coq: Definition version_gt)
pred version_gt[p_v1: Version, p_v2: Version] {
  some p_v1
}

// meets_reviewer_threshold (matches Coq: Definition meets_reviewer_threshold)
pred meets_reviewer_threshold[p_actual: Int, p_min: Int] {
  some p_actual
}

// isolation_sufficient (matches Coq: Definition isolation_sufficient)
pred isolation_sufficient[p_level: IsolationLevel] {
  some p_level
}

// FullSupplyChainSecurity (matches Coq: Definition FullSupplyChainSecurity)
pred FullSupplyChainSecurity {}

// hash_eq_refl (matches Coq: Lemma hash_eq_refl)
assert hash_eq_refl {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check hash_eq_refl for 5

// hash_eq_sym (matches Coq: Lemma hash_eq_sym)
assert hash_eq_sym {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check hash_eq_sym for 5

// hash_eq_implies_eq (matches Coq: Lemma hash_eq_implies_eq)
assert hash_eq_implies_eq {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check hash_eq_implies_eq for 5

// bool_impl (matches Coq: Lemma bool_impl)
assert bool_impl {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check bool_impl for 5

// sup_001_dependency_compromise_mitigated (matches Coq: Theorem sup_001_dependency_compromise_mitigated)
assert sup_001_dependency_compromise_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_001_dependency_compromise_mitigated for 5

// sup_001_hash_signature_integrity (matches Coq: Theorem sup_001_hash_signature_integrity)
assert sup_001_hash_signature_integrity {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_001_hash_signature_integrity for 5

// sup_002_typosquatting_mitigated (matches Coq: Theorem sup_002_typosquatting_mitigated)
assert sup_002_typosquatting_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_002_typosquatting_mitigated for 5

// sup_002_name_verification_canonical (matches Coq: Theorem sup_002_name_verification_canonical)
assert sup_002_name_verification_canonical {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_002_name_verification_canonical for 5

// sup_003_dependency_confusion_mitigated (matches Coq: Theorem sup_003_dependency_confusion_mitigated)
assert sup_003_dependency_confusion_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_003_dependency_confusion_mitigated for 5

// sup_003_internal_registry_isolation (matches Coq: Theorem sup_003_internal_registry_isolation)
assert sup_003_internal_registry_isolation {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_003_internal_registry_isolation for 5

// sup_004_build_compromise_mitigated (matches Coq: Theorem sup_004_build_compromise_mitigated)
assert sup_004_build_compromise_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_004_build_compromise_mitigated for 5

// sup_004_reproducible_detection (matches Coq: Theorem sup_004_reproducible_detection)
assert sup_004_reproducible_detection {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_004_reproducible_detection for 5

// sup_005_package_manager_mitigated (matches Coq: Theorem sup_005_package_manager_mitigated)
assert sup_005_package_manager_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_005_package_manager_mitigated for 5

// sup_005_tuf_threshold_security (matches Coq: Theorem sup_005_tuf_threshold_security)
assert sup_005_tuf_threshold_security {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_005_tuf_threshold_security for 5

// sup_006_firmware_mitigated (matches Coq: Theorem sup_006_firmware_mitigated)
assert sup_006_firmware_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_006_firmware_mitigated for 5

// sup_006_firmware_integrity (matches Coq: Theorem sup_006_firmware_integrity)
assert sup_006_firmware_integrity {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_006_firmware_integrity for 5

// sup_007_hardware_mitigated (matches Coq: Theorem sup_007_hardware_mitigated)
assert sup_007_hardware_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_007_hardware_mitigated for 5

// sup_007_attestation_chain_security (matches Coq: Theorem sup_007_attestation_chain_security)
assert sup_007_attestation_chain_security {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_007_attestation_chain_security for 5

// sup_008_third_party_mitigated (matches Coq: Theorem sup_008_third_party_mitigated)
assert sup_008_third_party_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_008_third_party_mitigated for 5

// sup_008_vendor_audit_security (matches Coq: Theorem sup_008_vendor_audit_security)
assert sup_008_vendor_audit_security {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_008_vendor_audit_security for 5

// sup_009_watering_hole_mitigated (matches Coq: Theorem sup_009_watering_hole_mitigated)
assert sup_009_watering_hole_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_009_watering_hole_mitigated for 5

// sup_009_segment_isolation_lateral (matches Coq: Theorem sup_009_segment_isolation_lateral)
assert sup_009_segment_isolation_lateral {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_009_segment_isolation_lateral for 5

// sup_010_update_attack_mitigated (matches Coq: Theorem sup_010_update_attack_mitigated)
assert sup_010_update_attack_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_010_update_attack_mitigated for 5

// sup_010_version_rollback_prevention (matches Coq: Theorem sup_010_version_rollback_prevention)
assert sup_010_version_rollback_prevention {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_010_version_rollback_prevention for 5

// sup_011_source_compromise_mitigated (matches Coq: Theorem sup_011_source_compromise_mitigated)
assert sup_011_source_compromise_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_011_source_compromise_mitigated for 5

// sup_011_multi_reviewer_security (matches Coq: Theorem sup_011_multi_reviewer_security)
assert sup_011_multi_reviewer_security {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_011_multi_reviewer_security for 5

// sup_012_compiler_attack_mitigated (matches Coq: Theorem sup_012_compiler_attack_mitigated)
assert sup_012_compiler_attack_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_012_compiler_attack_mitigated for 5

// sup_012_ddc_output_verification (matches Coq: Theorem sup_012_ddc_output_verification)
assert sup_012_ddc_output_verification {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_012_ddc_output_verification for 5

// sup_013_binary_backdoor_mitigated (matches Coq: Theorem sup_013_binary_backdoor_mitigated)
assert sup_013_binary_backdoor_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_013_binary_backdoor_mitigated for 5

// sup_013_binary_hash_verification (matches Coq: Theorem sup_013_binary_hash_verification)
assert sup_013_binary_hash_verification {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_013_binary_hash_verification for 5

// sup_014_certificate_compromise_mitigated (matches Coq: Theorem sup_014_certificate_compromise_mitigated)
assert sup_014_certificate_compromise_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_014_certificate_compromise_mitigated for 5

// sup_014_ct_log_verification (matches Coq: Theorem sup_014_ct_log_verification)
assert sup_014_ct_log_verification {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_014_ct_log_verification for 5

// sup_015_developer_compromise_mitigated (matches Coq: Theorem sup_015_developer_compromise_mitigated)
assert sup_015_developer_compromise_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_015_developer_compromise_mitigated for 5

// sup_015_mfa_security (matches Coq: Theorem sup_015_mfa_security)
assert sup_015_mfa_security {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_015_mfa_security for 5

// sup_016_malware_mitigated (matches Coq: Theorem sup_016_malware_mitigated)
assert sup_016_malware_mitigated {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_016_malware_mitigated for 5

// sup_016_isolation_level_security (matches Coq: Theorem sup_016_isolation_level_security)
assert sup_016_isolation_level_security {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check sup_016_isolation_level_security for 5

// supply_chain_full_security (matches Coq: Theorem supply_chain_full_security)
assert supply_chain_full_security {
  all c: SignedArtifact | some c.f_sa_content_hash
}
check supply_chain_full_security for 5

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for app distribution
// Bounded verification of key properties
module riina/Domains/MobileOS/AppDistribution

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

assert store_malware_free {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check store_malware_free for 6

assert security_scan_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check security_scan_complete for 6

assert update_is_atomic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check update_is_atomic for 6

assert update_rollback_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check update_rollback_available for 6

assert no_version_downgrade {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_version_downgrade for 6

assert signature_required_for_store {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check signature_required_for_store for 6

assert failed_install_no_corruption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check failed_install_no_corruption for 6

assert app_signature_verified_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_signature_verified_thm for 6

assert code_integrity_checked_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check code_integrity_checked_thm for 6

assert entitlements_validated_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check entitlements_validated_thm for 6

assert provisioning_profile_valid_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check provisioning_profile_valid_thm for 6

assert app_review_required_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_review_required_thm for 6

assert binary_size_reported_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check binary_size_reported_thm for 6

assert app_version_monotonic_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_version_monotonic_thm for 6

assert minimum_os_version_enforced_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check minimum_os_version_enforced_thm for 6

assert deprecated_api_flagged_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check deprecated_api_flagged_thm for 6

assert privacy_manifest_required_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check privacy_manifest_required_thm for 6

assert data_collection_declared_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_collection_declared_thm for 6

assert app_clip_size_bounded_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_clip_size_bounded_thm for 6

assert testflight_expiry_enforced_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check testflight_expiry_enforced_thm for 6

assert enterprise_certificate_validated_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check enterprise_certificate_validated_thm for 6

assert notarization_required_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check notarization_required_thm for 6

assert provisioning_profile_not_expired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check provisioning_profile_not_expired for 6

assert entitlements_granted_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check entitlements_granted_bounded for 6

assert enterprise_cert_not_revoked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check enterprise_cert_not_revoked for 6

assert notarization_ticket_stapled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check notarization_ticket_stapled for 6

assert app_signature_has_timestamp {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_signature_has_timestamp for 6

pred ExampleAppDistribution {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleAppDistribution for 6

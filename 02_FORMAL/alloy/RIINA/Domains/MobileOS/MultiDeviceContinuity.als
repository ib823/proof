// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for multi device continuity
// Bounded verification of key properties
module riina/Domains/MobileOS/MultiDeviceContinuity

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

assert cross_device_handoff_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_device_handoff_complete for 6

assert handoff_requires_auth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check handoff_requires_auth for 6

assert handoff_requires_pairing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check handoff_requires_pairing for 6

assert complete_handoff_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check complete_handoff_encrypted for 6

assert only_enabled_apps_handoff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check only_enabled_apps_handoff for 6

assert handoff_data_encrypted_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check handoff_data_encrypted_thm for 6

assert clipboard_sync_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check clipboard_sync_encrypted for 6

assert device_trust_verified_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check device_trust_verified_thm for 6

assert proximity_required_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check proximity_required_thm for 6

assert continuity_permission_explicit_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check continuity_permission_explicit_thm for 6

assert shared_clipboard_expiry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shared_clipboard_expiry for 6

assert universal_link_validated_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check universal_link_validated_thm for 6

assert device_pairing_authenticated_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check device_pairing_authenticated_thm for 6

assert sync_conflict_resolved_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sync_conflict_resolved_thm for 6

assert continuity_fallback_available_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check continuity_fallback_available_thm for 6

assert shared_keychain_access_controlled_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shared_keychain_access_controlled_thm for 6

assert nearby_interaction_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nearby_interaction_consent for 6

assert device_discovery_limited_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check device_discovery_limited_thm for 6

assert relay_traffic_encrypted_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check relay_traffic_encrypted_thm for 6

assert continuity_session_timeout {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check continuity_session_timeout for 6

assert device_pairing_key_exchange {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check device_pairing_key_exchange for 6

assert continuity_permission_revocable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check continuity_permission_revocable for 6

assert clipboard_expiry_within_max {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check clipboard_expiry_within_max for 6

assert shared_keychain_has_group {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shared_keychain_has_group for 6

assert handoff_data_integrity_checked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check handoff_data_integrity_checked for 6

pred ExampleMultiDeviceContinuity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMultiDeviceContinuity for 6

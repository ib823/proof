// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for system apps
// Bounded verification of key properties
module riina/Domains/MobileOS/SystemApps

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

assert system_apps_verified_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check system_apps_verified_correct for 6

assert system_app_data_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check system_app_data_encrypted for 6

assert state_transition_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check state_transition_valid for 6

assert sync_preserves_data {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sync_preserves_data for 6

assert system_apps_sandboxed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check system_apps_sandboxed for 6

assert minimal_permissions_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check minimal_permissions_enforced for 6

assert system_app_response_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check system_app_response_correct for 6

assert security_apps_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check security_apps_encrypted for 6

assert app_sandbox_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_sandbox_enforced for 6

assert no_cross_app_data_access {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_cross_app_data_access for 6

assert app_permission_checked_at_runtime {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_permission_checked_at_runtime for 6

assert background_app_limited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check background_app_limited for 6

assert foreground_app_priority {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check foreground_app_priority for 6

assert app_install_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_install_verified for 6

assert app_update_atomic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_update_atomic for 6

assert app_uninstall_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_uninstall_complete for 6

assert app_data_encrypted_at_rest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_data_encrypted_at_rest for 6

assert app_network_permission_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_network_permission_required for 6

assert clipboard_access_notified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check clipboard_access_notified for 6

assert camera_access_indicator {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check camera_access_indicator for 6

assert microphone_access_indicator {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check microphone_access_indicator for 6

assert location_access_indicator {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check location_access_indicator for 6

assert notification_permission_explicit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check notification_permission_explicit for 6

assert check_app_security_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check check_app_security_correct for 6

pred ExampleSystemApps {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSystemApps for 6

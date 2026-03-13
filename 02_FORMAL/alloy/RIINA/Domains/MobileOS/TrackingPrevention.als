// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for tracking prevention
// Bounded verification of key properties
module riina/Domains/MobileOS/TrackingPrevention

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

assert no_tracking_without_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_tracking_without_consent for 6

assert tracking_requires_transparency_prompt {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tracking_requires_transparency_prompt for 6

assert denied_tracking_not_approved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check denied_tracking_not_approved for 6

assert consent_revocation_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check consent_revocation_effective for 6

assert no_consent_no_data {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_consent_no_data for 6

assert cross_site_tracking_blocked_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_site_tracking_blocked_thm for 6

assert fingerprinting_prevented_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fingerprinting_prevented_thm for 6

assert third_party_cookies_blocked_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check third_party_cookies_blocked_thm for 6

assert tracking_pixel_detected_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tracking_pixel_detected_thm for 6

assert advertising_id_resettable_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check advertising_id_resettable_thm for 6

assert app_tracking_permission_required_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check app_tracking_permission_required_thm for 6

assert link_decoration_stripped_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check link_decoration_stripped_thm for 6

assert bounce_tracking_prevented_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bounce_tracking_prevented_thm for 6

assert cname_cloaking_detected_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cname_cloaking_detected_thm for 6

assert storage_access_partitioned_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check storage_access_partitioned_thm for 6

assert referrer_policy_strict_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check referrer_policy_strict_thm for 6

assert ip_address_masked_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ip_address_masked_thm for 6

assert device_graph_prevented_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check device_graph_prevented_thm for 6

assert tracker_list_updated_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tracker_list_updated_thm for 6

assert tracking_report_available_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tracking_report_available_thm for 6

assert referrer_policy_options {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check referrer_policy_options for 6

assert tracker_list_non_empty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tracker_list_non_empty for 6

assert no_tracking_without_permission_request {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_tracking_without_permission_request for 6

assert revocation_prevents_future_tracking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check revocation_prevents_future_tracking for 6

assert ip_masked_via_relay {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ip_masked_via_relay for 6

pred ExampleTrackingPrevention {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleTrackingPrevention for 6

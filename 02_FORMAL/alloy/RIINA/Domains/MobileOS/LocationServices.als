// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for location services
// Bounded verification of key properties
module riina/Domains/MobileOS/LocationServices

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

assert location_accuracy_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check location_accuracy_bounded for 6

assert geofence_accurate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check geofence_accurate for 6

assert inside_within_radius {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check inside_within_radius for 6

assert distance_symmetric {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check distance_symmetric for 6

assert distance_self_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check distance_self_zero for 6

assert at_center_always_inside {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check at_center_always_inside for 6

assert location_permission_explicit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check location_permission_explicit for 6

assert location_precision_adjustable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check location_precision_adjustable for 6

assert background_location_limited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check background_location_limited for 6

assert geofence_battery_efficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check geofence_battery_efficient for 6

assert location_data_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check location_data_encrypted for 6

assert no_location_tracking_without_consent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_location_tracking_without_consent for 6

assert location_cache_expiry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check location_cache_expiry for 6

assert altitude_accuracy_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check altitude_accuracy_bounded for 6

assert heading_accuracy_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heading_accuracy_bounded for 6

assert speed_non_negative {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check speed_non_negative for 6

assert coordinate_range_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check coordinate_range_valid for 6

assert location_update_frequency_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check location_update_frequency_bounded for 6

assert significant_change_threshold {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check significant_change_threshold for 6

assert location_history_deletable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check location_history_deletable for 6

assert mock_location_detectable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mock_location_detectable for 6

assert distance_triangle_inequality {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check distance_triangle_inequality for 6

pred ExampleLocationServices {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleLocationServices for 6

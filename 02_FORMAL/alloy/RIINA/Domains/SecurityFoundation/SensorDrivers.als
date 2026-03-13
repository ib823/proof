// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for sensor drivers
// Bounded verification of key properties
module riina/Domains/SecurityFoundation/SensorDrivers

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

assert sensor_access_controlled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_access_controlled for 6

assert recording_indicator_mandatory {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check recording_indicator_mandatory for 6

assert no_permission_no_sensor {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_permission_no_sensor for 6

assert camera_requires_camera_perm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check camera_requires_camera_perm for 6

assert gps_requires_location_perm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gps_requires_location_perm for 6

assert rate_limit_blocks_excess {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rate_limit_blocks_excess for 6

assert microphone_requires_mic_perm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check microphone_requires_mic_perm for 6

assert accelerometer_requires_motion_perm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accelerometer_requires_motion_perm for 6

assert gyroscope_requires_motion_perm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gyroscope_requires_motion_perm for 6

assert no_permissions_no_sensors {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_permissions_no_sensors for 6

assert indicators_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check indicators_independent for 6

assert mic_indicator_when_active {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mic_indicator_when_active for 6

assert cam_indicator_when_active {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cam_indicator_when_active for 6

assert both_sensors_both_indicators {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check both_sensors_both_indicators for 6

assert no_active_no_indicator_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_active_no_indicator_required for 6

assert sensor_perm_type_specific {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_perm_type_specific for 6

assert camera_perm_not_mic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check camera_perm_not_mic for 6

assert motion_perm_covers_both {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check motion_perm_covers_both for 6

assert sensor_reading_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sensor_reading_valid for 6

assert bounded_sensor_rate_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bounded_sensor_rate_valid for 6

assert revoke_all_blocks_all_types {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check revoke_all_blocks_all_types for 6

assert gps_independent_of_camera {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gps_independent_of_camera for 6

pred ExampleSensorDrivers {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSensorDrivers for 6

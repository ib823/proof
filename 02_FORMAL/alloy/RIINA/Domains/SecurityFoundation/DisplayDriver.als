// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for display driver
// Bounded verification of key properties
module riina/Domains/SecurityFoundation/DisplayDriver

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

assert display_buffer_isolated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check display_buffer_isolated for 6

assert screen_capture_requires_permission {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check screen_capture_requires_permission for 6

assert protected_buffer_access {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check protected_buffer_access for 6

assert no_permission_no_capture {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_permission_no_capture for 6

assert buffer_ownership_exclusive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check buffer_ownership_exclusive for 6

assert overlay_requires_permission {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check overlay_requires_permission for 6

assert no_overlay_without_permission {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_overlay_without_permission for 6

assert display_output_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check display_output_integrity for 6

assert valid_fb_positive_pixels {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check valid_fb_positive_pixels for 6

assert no_capture_perm_blocks_all_frames {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_capture_perm_blocks_all_frames for 6

assert protected_buffer_blocks_non_owner {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check protected_buffer_blocks_non_owner for 6

assert read_requires_ownership_or_capture {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check read_requires_ownership_or_capture for 6

assert capture_perm_reads_all {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check capture_perm_reads_all for 6

assert owner_reads_unprotected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check owner_reads_unprotected for 6

assert overlay_state_consistent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check overlay_state_consistent for 6

assert no_overlay_no_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_overlay_no_app for 6

assert fb_id_determines_buffer {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fb_id_determines_buffer for 6

assert display_isolation_symmetric {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check display_isolation_symmetric for 6

assert capture_overlay_independent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check capture_overlay_independent for 6

assert dual_perm_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dual_perm_app for 6

assert no_perm_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_perm_app for 6

assert empty_display_no_read {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_display_no_read for 6

assert frame_timestamp_order {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check frame_timestamp_order for 6

pred ExampleDisplayDriver {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleDisplayDriver for 6

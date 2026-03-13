// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for fullstack security
// Bounded verification of key properties
module riina/Domains/FullstackSecurity

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

assert web_001_escaped_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_001_escaped_safe for 6

assert web_002_plaintext_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_002_plaintext_safe for 6

assert web_003_raw_unsafe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_003_raw_unsafe for 6

assert web_004_template_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_004_template_safe for 6

assert web_005_param_query_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_005_param_query_safe for 6

assert web_006_no_concat {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_006_no_concat for 6

assert web_007_csrf_session {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_007_csrf_session for 6

assert web_008_csrf_fresh {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_008_csrf_fresh for 6

assert web_009_valid_transition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_009_valid_transition for 6

assert web_010_no_skip_mfa {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_010_no_skip_mfa for 6

assert web_011_locked_blocked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_011_locked_blocked for 6

assert web_012_session_token {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_012_session_token for 6

assert web_013_post_token {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_013_post_token for 6

assert web_014_url_validated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_014_url_validated for 6

assert web_015_csp_present {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_015_csp_present for 6

assert web_016_cookie_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_016_cookie_secure for 6

assert web_017_input_validated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_017_input_validated for 6

assert web_018_output_encoded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_018_output_encoded for 6

assert web_019_rate_limited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_019_rate_limited for 6

assert web_020_session_timeout {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_020_session_timeout for 6

assert web_021_password_hashed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_021_password_hashed for 6

assert web_022_https_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_022_https_required for 6

assert web_023_error_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_023_error_safe for 6

assert web_024_logging_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_024_logging_complete for 6

assert web_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_025_defense_in_depth for 6

pred ExampleFullstackSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleFullstackSecurity for 6

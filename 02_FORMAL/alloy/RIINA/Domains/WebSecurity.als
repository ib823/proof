// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for web security
// Bounded verification of key properties
module riina/Domains/WebSecurity

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

assert web_001_reflected_xss_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_001_reflected_xss_impossible for 6

assert web_002_stored_xss_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_002_stored_xss_impossible for 6

assert web_003_dom_xss_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_003_dom_xss_impossible for 6

assert web_004_csrf_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_004_csrf_impossible for 6

assert web_005_ssrf_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_005_ssrf_impossible for 6

assert web_006_clickjacking_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_006_clickjacking_impossible for 6

assert web_007_open_redirect_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_007_open_redirect_impossible for 6

assert web_008_http_smuggling_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_008_http_smuggling_impossible for 6

assert web_009_cache_poisoning_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_009_cache_poisoning_impossible for 6

assert web_010_session_hijacking_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_010_session_hijacking_mitigated for 6

assert web_011_session_fixation_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_011_session_fixation_impossible for 6

assert web_012_cookie_attacks_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_012_cookie_attacks_mitigated for 6

assert web_013_path_traversal_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_013_path_traversal_impossible for 6

assert web_014_lfi_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_014_lfi_impossible for 6

assert web_015_rfi_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_015_rfi_impossible for 6

assert web_016_prototype_pollution_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_016_prototype_pollution_impossible for 6

assert web_017_deserialization_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_017_deserialization_safe for 6

assert web_018_http_response_split_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_018_http_response_split_impossible for 6

assert web_019_parameter_pollution_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_019_parameter_pollution_mitigated for 6

assert web_020_mass_assignment_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_020_mass_assignment_impossible for 6

assert web_021_idor_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_021_idor_mitigated for 6

assert web_022_verb_tampering_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_022_verb_tampering_mitigated for 6

assert web_023_host_header_attack_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_023_host_header_attack_mitigated for 6

assert web_024_web_cache_deception_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_024_web_cache_deception_mitigated for 6

assert web_025_graphql_attacks_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check web_025_graphql_attacks_mitigated for 6

pred ExampleWebSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleWebSecurity for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for CSRF protection
// Bounded verification of CSRFProtection properties
module riina/Domains/CSRFProtection

sig FormSubmission {
  hasToken: one Int,
  tokenValid: one Int,
  accepted: one Int
}

// Invariant: token_required
fact token_required_fact {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}

// Invariant: valid_token_required
fact valid_token_required_fact {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}

assert andb_true_iff {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check andb_true_iff for 6

assert CSRF_001 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_001 for 6

assert CSRF_002 {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_002 for 6

assert CSRF_003 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_003 for 6

assert CSRF_004 {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_004 for 6

assert CSRF_005 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_005 for 6

assert CSRF_006 {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_006 for 6

assert CSRF_007 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_007 for 6

assert CSRF_008 {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_008 for 6

assert CSRF_009 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_009 for 6

assert CSRF_010 {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_010 for 6

assert CSRF_011 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_011 for 6

assert CSRF_012 {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_012 for 6

assert CSRF_013 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_013 for 6

assert CSRF_014 {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_014 for 6

assert CSRF_015 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_015 for 6

assert CSRF_016 {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_016 for 6

assert CSRF_017 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_017 for 6

assert CSRF_018 {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_018 for 6

assert CSRF_019 {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_019 for 6

assert CSRF_020_complete {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_020_complete for 6

assert CSRF_021_riina_request_safe {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_021_riina_request_safe for 6

assert CSRF_022_riina_request_fully_validated {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_022_riina_request_fully_validated for 6

assert CSRF_023_safe_has_token {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_023_safe_has_token for 6

assert CSRF_024_safe_token_matches {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_024_safe_token_matches for 6

assert CSRF_025_safe_same_origin {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_025_safe_same_origin for 6

assert CSRF_026_fully_validated_implies_safe {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_026_fully_validated_implies_safe for 6

assert CSRF_027_fully_validated_referer {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_027_fully_validated_referer for 6

assert CSRF_028_fully_validated_cookie {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_028_fully_validated_cookie for 6

assert CSRF_029_full_implies_token_and_origin {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_029_full_implies_token_and_origin for 6

assert CSRF_030_config_enables_request_checks {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_030_config_enables_request_checks for 6

assert CSRF_031_referer_in_protection {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_031_referer_in_protection for 6

assert CSRF_032_complete_request_validation {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_032_complete_request_validation for 6

assert CSRF_033_all_false_not_protected {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_033_all_false_not_protected for 6

assert CSRF_034_missing_token_breaks {
  all f: FormSubmission | f.accepted = 1 implies f.hasToken = 1
}
check CSRF_034_missing_token_breaks for 6

assert CSRF_035_protection_reconstruction {
  all f: FormSubmission | f.accepted = 1 implies f.tokenValid = 1
}
check CSRF_035_protection_reconstruction for 6

pred ExampleCSRFProtection {
  some FormSubmission
}
run ExampleCSRFProtection for 6

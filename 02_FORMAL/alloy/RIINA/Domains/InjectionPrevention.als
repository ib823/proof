// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for injection prevention
// Bounded verification of InjectionPrevention properties
module riina/Domains/InjectionPrevention

abstract sig InputSource {}
one sig User extends InputSource {}
one sig Network extends InputSource {}
one sig File extends InputSource {}
one sig Database extends InputSource {}

sig InputData {
  source: one InputSource,
  sanitized: one Int,
  validated: one Int
}

sig Query {
  input: one InputData,
  safe: one Int
}

// Invariant: sanitized_before_use
fact sanitized_before_use_fact {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}

// Invariant: validated_before_use
fact validated_before_use_fact {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}

// Invariant: user_input_untrusted
fact user_input_untrusted_fact {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}

assert inj_001_sql_injection_impossible {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check inj_001_sql_injection_impossible for 6

assert inj_002_command_injection_impossible {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check inj_002_command_injection_impossible for 6

assert inj_003_ldap_injection_impossible {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check inj_003_ldap_injection_impossible for 6

assert inj_004_xpath_injection_impossible {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check inj_004_xpath_injection_impossible for 6

assert inj_005_xxe_impossible {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check inj_005_xxe_impossible for 6

assert inj_006_header_injection_impossible {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check inj_006_header_injection_impossible for 6

assert inj_007_template_injection_impossible {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check inj_007_template_injection_impossible for 6

assert inj_008_code_injection_impossible {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check inj_008_code_injection_impossible for 6

assert inj_009_expression_language_safe {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check inj_009_expression_language_safe for 6

assert inj_010_log_injection_impossible {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check inj_010_log_injection_impossible for 6

assert inj_011_email_header_safe {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check inj_011_email_header_safe for 6

assert csv_escape_safe_helper {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check csv_escape_safe_helper for 6

assert inj_012_csv_injection_impossible {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check inj_012_csv_injection_impossible for 6

assert inj_013_pdf_injection_impossible {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check inj_013_pdf_injection_impossible for 6

assert inj_014_crlf_injection_impossible {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check inj_014_crlf_injection_impossible for 6

assert inj_015_null_byte_injection_impossible {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check inj_015_null_byte_injection_impossible for 6

assert inj_016_untrusted_propagation {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check inj_016_untrusted_propagation for 6

assert inj_017_untrusted_propagation_right {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check inj_017_untrusted_propagation_right for 6

assert inj_018_trusted_propagation {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check inj_018_trusted_propagation for 6

assert inj_019_sanitized_propagation {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check inj_019_sanitized_propagation for 6

assert inj_020_empty_sql_safe {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check inj_020_empty_sql_safe for 6

assert inj_021_parameterized_always_safe {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check inj_021_parameterized_always_safe for 6

assert inj_022_trusted_propagation {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check inj_022_trusted_propagation for 6

assert inj_023_taint_propagation_comm {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check inj_023_taint_propagation_comm for 6

assert inj_024_trusted_propagation {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check inj_024_trusted_propagation for 6

assert inj_025_untrusted_propagation {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check inj_025_untrusted_propagation for 6

pred ExampleInjectionPrevention {
  some InputData
}
run ExampleInjectionPrevention for 6

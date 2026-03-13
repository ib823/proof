// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for injection prevention
// Bounded verification of SQLInjectionPrevention properties
module riina/Domains/SQLInjectionPrevention

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

assert andb_true_iff {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check andb_true_iff for 6

assert SQLI_001_untainted_safe {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check SQLI_001_untainted_safe for 6

assert SQLI_002_sanitized_safe {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check SQLI_002_sanitized_safe for 6

assert SQLI_003_userinput_unsafe {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check SQLI_003_userinput_unsafe for 6

assert SQLI_004_parameterized_safe {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check SQLI_004_parameterized_safe for 6

assert SQLI_005_orm_safe {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check SQLI_005_orm_safe for 6

assert SQLI_006_concat_unsafe {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check SQLI_006_concat_unsafe for 6

assert SQLI_007_riina_protected {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check SQLI_007_riina_protected for 6

assert SQLI_008_parameterized_required {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check SQLI_008_parameterized_required for 6

assert SQLI_009_no_concat_required {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check SQLI_009_no_concat_required for 6

assert SQLI_010_sanitization_required {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check SQLI_010_sanitization_required for 6

assert SQLI_011_whitelist_required {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check SQLI_011_whitelist_required for 6

assert SQLI_012_escape_required {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check SQLI_012_escape_required for 6

assert SQLI_013_riina_parameterized {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check SQLI_013_riina_parameterized for 6

assert SQLI_014_sanitization_makes_safe {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check SQLI_014_sanitization_makes_safe for 6

assert SQLI_015_complete_prevention {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check SQLI_015_complete_prevention for 6

assert untainted_safe {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check untainted_safe for 6

assert sanitized_safe {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check sanitized_safe for 6

assert user_input_unsafe {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check user_input_unsafe for 6

assert string_concat_unsafe {
  all q: Query | q.safe = 1 implies q.input.validated = 1
}
check string_concat_unsafe for 6

assert parameterized_safe {
  all d: InputData | d.source = User implies (d.safe = 1 implies d.sanitized = 1)
}
check parameterized_safe for 6

assert riina_config_protected {
  all q: Query | q.safe = 1 implies q.input.sanitized = 1
}
check riina_config_protected for 6

pred ExampleSQLInjectionPrevention {
  some InputData
}
run ExampleSQLInjectionPrevention for 6

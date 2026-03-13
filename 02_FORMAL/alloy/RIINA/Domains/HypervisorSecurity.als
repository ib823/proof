// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for hypervisor security
// Bounded verification of HypervisorSecurity properties
module riina/Domains/HypervisorSecurity

sig VM {
  isolated: one Int,
  trusted: one Int
}

sig VMAccess {
  source: one VM,
  target: one VM,
  allowed: one Int
}

// Invariant: isolation_no_cross_access
fact isolation_no_cross_access_fact {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}

// Invariant: trusted_can_access
fact trusted_can_access_fact {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}

assert andb_true_iff {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check andb_true_iff for 6

assert andb_true_intro {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check andb_true_intro for 6

assert andb_true_elim_l {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check andb_true_elim_l for 6

assert andb_true_elim_r {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check andb_true_elim_r for 6

assert HV_001 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_001 for 6

assert HV_002 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_002 for 6

assert HV_003 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_003 for 6

assert HV_004 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_004 for 6

assert HV_005 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_005 for 6

assert HV_006 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_006 for 6

assert HV_007 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_007 for 6

assert HV_008 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_008 for 6

assert HV_009 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_009 for 6

assert HV_010 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_010 for 6

assert HV_011 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_011 for 6

assert HV_012 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_012 for 6

assert HV_013 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_013 for 6

assert HV_014 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_014 for 6

assert HV_015 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_015 for 6

assert HV_016 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_016 for 6

assert HV_017 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_017 for 6

assert HV_018 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_018 for 6

assert HV_019 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_019 for 6

assert HV_020 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_020 for 6

assert HV_021 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_021 for 6

assert HV_022 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_022 for 6

assert HV_023 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_023 for 6

assert HV_024 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_024 for 6

assert HV_025 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_025 for 6

assert HV_026 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_026 for 6

assert HV_027 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_027 for 6

assert HV_028 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_028 for 6

assert HV_029 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_029 for 6

assert HV_030 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_030 for 6

assert HV_031 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_031 for 6

assert HV_032 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_032 for 6

assert HV_033 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_033 for 6

assert HV_034 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_034 for 6

assert HV_035 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_035 for 6

assert HV_036 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_036 for 6

assert HV_037 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_037 for 6

assert HV_038 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_038 for 6

assert HV_039 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_039 for 6

assert HV_040 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_040 for 6

assert HV_041 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_041 for 6

assert HV_042 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_042 for 6

assert HV_043 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_043 for 6

assert HV_044 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_044 for 6

assert HV_045 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_045 for 6

assert HV_046 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_046 for 6

assert HV_047 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_047 for 6

assert HV_048 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_048 for 6

assert HV_049 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_049 for 6

assert HV_050 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_050 for 6

assert HV_051 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_051 for 6

assert HV_052 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_052 for 6

assert HV_053 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_053 for 6

assert HV_054 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_054 for 6

assert HV_055 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_055 for 6

assert HV_056 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_056 for 6

assert HV_057 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_057 for 6

assert HV_058 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_058 for 6

assert HV_059 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_059 for 6

assert HV_060 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_060 for 6

assert HV_061 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_061 for 6

assert HV_062 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_062 for 6

assert HV_063 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_063 for 6

assert HV_064 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_064 for 6

assert HV_065 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_065 for 6

assert HV_066 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_066 for 6

assert HV_067 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_067 for 6

assert HV_068 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_068 for 6

assert HV_069 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_069 for 6

assert HV_070 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_070 for 6

assert HV_071 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_071 for 6

assert HV_072 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_072 for 6

assert HV_073 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_073 for 6

assert HV_074 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_074 for 6

assert HV_075 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_075 for 6

assert HV_076 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_076 for 6

assert HV_077 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_077 for 6

assert HV_078 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_078 for 6

assert HV_079 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_079 for 6

assert HV_080 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_080 for 6

assert HV_081 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_081 for 6

assert HV_082 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_082 for 6

assert HV_083 {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_083 for 6

assert HV_084 {
  all a: VMAccess | a.source.trusted = 1 implies a.allowed = 1
}
check HV_084 for 6

assert HV_085_complete {
  all a: VMAccess | (a.source.isolated = 1 and a.target.isolated = 1 and a.source != a.target) implies a.allowed = 0
}
check HV_085_complete for 6

pred ExampleHypervisorSecurity {
  some VM
}
run ExampleHypervisorSecurity for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for speculative execution defense
// Bounded verification of SpectreDefense properties
module riina/Domains/SpectreDefense

sig SpecExec {
  fenced: one Int,
  branchMasked: one Int,
  safe: one Int
}

// Invariant: fenced_is_safe
fact fenced_is_safe_fact {
  all s: SpecExec | s.fenced = 1 implies s.safe = 1
}

// Invariant: masked_is_safe
fact masked_is_safe_fact {
  all s: SpecExec | s.branchMasked = 1 implies s.safe = 1
}

// Invariant: unfenced_unsafe
fact unfenced_unsafe_fact {
  all s: SpecExec | s.fenced = 0 and s.branchMasked = 0 implies s.safe = 0
}

assert andb_true_iff {
  all s: SpecExec | s.fenced = 1 implies s.safe = 1
}
check andb_true_iff for 6

assert SPECTRE_001_all_variants {
  all s: SpecExec | s.branchMasked = 1 implies s.safe = 1
}
check SPECTRE_001_all_variants for 6

assert SPECTRE_002_all_mechanisms {
  all s: SpecExec | s.fenced = 0 and s.branchMasked = 0 implies s.safe = 0
}
check SPECTRE_002_all_mechanisms for 6

assert SPECTRE_003_fully_protected {
  all s: SpecExec | s.fenced = 1 implies s.safe = 1
}
check SPECTRE_003_fully_protected for 6

assert SPECTRE_004_v1_required {
  all s: SpecExec | s.branchMasked = 1 implies s.safe = 1
}
check SPECTRE_004_v1_required for 6

assert SPECTRE_005_v2_required {
  all s: SpecExec | s.fenced = 0 and s.branchMasked = 0 implies s.safe = 0
}
check SPECTRE_005_v2_required for 6

assert SPECTRE_006_v4_required {
  all s: SpecExec | s.fenced = 1 implies s.safe = 1
}
check SPECTRE_006_v4_required for 6

assert SPECTRE_007_rsb_required {
  all s: SpecExec | s.branchMasked = 1 implies s.safe = 1
}
check SPECTRE_007_rsb_required for 6

assert SPECTRE_008_bhb_required {
  all s: SpecExec | s.fenced = 0 and s.branchMasked = 0 implies s.safe = 0
}
check SPECTRE_008_bhb_required for 6

assert SPECTRE_009_serialization {
  all s: SpecExec | s.fenced = 1 implies s.safe = 1
}
check SPECTRE_009_serialization for 6

assert SPECTRE_010_array_masking {
  all s: SpecExec | s.branchMasked = 1 implies s.safe = 1
}
check SPECTRE_010_array_masking for 6

assert SPECTRE_011_retpoline {
  all s: SpecExec | s.fenced = 0 and s.branchMasked = 0 implies s.safe = 0
}
check SPECTRE_011_retpoline for 6

assert SPECTRE_012_full_implies_variants {
  all s: SpecExec | s.fenced = 1 implies s.safe = 1
}
check SPECTRE_012_full_implies_variants for 6

assert SPECTRE_013_full_implies_mechanisms {
  all s: SpecExec | s.branchMasked = 1 implies s.safe = 1
}
check SPECTRE_013_full_implies_mechanisms for 6

assert SPECTRE_014_riina_v1 {
  all s: SpecExec | s.fenced = 0 and s.branchMasked = 0 implies s.safe = 0
}
check SPECTRE_014_riina_v1 for 6

assert SPECTRE_015_riina_v2 {
  all s: SpecExec | s.fenced = 1 implies s.safe = 1
}
check SPECTRE_015_riina_v2 for 6

assert SPECTRE_016_riina_serialization {
  all s: SpecExec | s.branchMasked = 1 implies s.safe = 1
}
check SPECTRE_016_riina_serialization for 6

assert SPECTRE_017_riina_retpoline {
  all s: SpecExec | s.fenced = 0 and s.branchMasked = 0 implies s.safe = 0
}
check SPECTRE_017_riina_retpoline for 6

assert SPECTRE_018_full_implies_v1 {
  all s: SpecExec | s.fenced = 1 implies s.safe = 1
}
check SPECTRE_018_full_implies_v1 for 6

assert SPECTRE_019_full_implies_serial {
  all s: SpecExec | s.branchMasked = 1 implies s.safe = 1
}
check SPECTRE_019_full_implies_serial for 6

assert SPECTRE_020_complete_defense {
  all s: SpecExec | s.fenced = 0 and s.branchMasked = 0 implies s.safe = 0
}
check SPECTRE_020_complete_defense for 6

pred ExampleSpectreDefense {
  some SpecExec
}
run ExampleSpectreDefense for 6

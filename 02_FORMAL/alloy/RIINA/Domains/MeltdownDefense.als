// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for meltdown defense
// Bounded verification of MeltdownDefense properties
module riina/Domains/MeltdownDefense

sig MemoryAccess {
  kernelSpace: one Int,
  userMode: one Int,
  blocked: one Int
}

// Invariant: kernel_blocked_in_user
fact kernel_blocked_in_user_fact {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}

// Invariant: user_allowed
fact user_allowed_fact {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}

assert andb_true_iff {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check andb_true_iff for 6

assert MELTDOWN_001_all_variants {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_001_all_variants for 6

assert MELTDOWN_002_mitigations {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_002_mitigations for 6

assert MELTDOWN_003_fully_protected {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_003_fully_protected for 6

assert MELTDOWN_004_us_required {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_004_us_required for 6

assert MELTDOWN_005_p_required {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_005_p_required for 6

assert MELTDOWN_006_kpti_required {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_006_kpti_required for 6

assert MELTDOWN_007_l1tf_required {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_007_l1tf_required for 6

assert MELTDOWN_008_full_implies_variants {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_008_full_implies_variants for 6

assert MELTDOWN_009_full_implies_mitigations {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_009_full_implies_mitigations for 6

assert MELTDOWN_010_riina_kpti {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_010_riina_kpti for 6

assert MELTDOWN_011_riina_l1tf {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_011_riina_l1tf for 6

assert MELTDOWN_012_full_implies_kpti {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_012_full_implies_kpti for 6

assert MELTDOWN_013_full_implies_us {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_013_full_implies_us for 6

assert MELTDOWN_014_riina_us {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_014_riina_us for 6

assert MELTDOWN_015_complete_defense {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_015_complete_defense for 6

assert MELTDOWN_016_rw_required {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_016_rw_required for 6

assert MELTDOWN_017_pk_required {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_017_pk_required for 6

assert MELTDOWN_018_br_required {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_018_br_required for 6

assert MELTDOWN_019_full_implies_l1tf {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_019_full_implies_l1tf for 6

assert MELTDOWN_020_full_implies_p {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_020_full_implies_p for 6

assert MELTDOWN_021_full_implies_rw {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_021_full_implies_rw for 6

assert MELTDOWN_022_full_implies_pk {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_022_full_implies_pk for 6

assert MELTDOWN_023_full_implies_br {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_023_full_implies_br for 6

assert MELTDOWN_024_riina_p {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_024_riina_p for 6

assert MELTDOWN_025_riina_rw {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_025_riina_rw for 6

assert MELTDOWN_026_riina_pk {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_026_riina_pk for 6

assert MELTDOWN_027_riina_br {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_027_riina_br for 6

assert MELTDOWN_028_variant_mitigation_composition {
  all a: MemoryAccess | (a.kernelSpace = 1 and a.userMode = 1) implies a.blocked = 1
}
check MELTDOWN_028_variant_mitigation_composition for 6

assert MELTDOWN_029_complete_decomposition {
  all a: MemoryAccess | (a.kernelSpace = 0 and a.userMode = 1) implies a.blocked = 0
}
check MELTDOWN_029_complete_decomposition for 6

pred ExampleMeltdownDefense {
  some MemoryAccess
}
run ExampleMeltdownDefense for 6

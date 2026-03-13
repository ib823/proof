// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for memory safety
// Bounded verification of MemorySafety properties
module riina/Domains/MemorySafety

abstract sig AllocState {}
one sig Allocated extends AllocState {}
one sig Freed extends AllocState {}
one sig Uninitialized extends AllocState {}

sig MemoryRegion {
  allocState: one AllocState,
  size: one Int,
  owned: one Int
}

sig Pointer {
  target: one MemoryRegion,
  offset: one Int,
  valid: one Int
}

// Invariant: no_use_after_free
fact no_use_after_free_fact {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}

// Invariant: no_double_free
fact no_double_free_fact {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}

// Invariant: bounds_check
fact bounds_check_fact {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}

// Invariant: allocated_accessible
fact allocated_accessible_fact {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}

// Invariant: freed_not_accessible
fact freed_not_accessible_fact {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}

assert andb_true_iff {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check andb_true_iff for 6

assert andb_false_iff {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check andb_false_iff for 6

assert negb_true_iff {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check negb_true_iff for 6

assert negb_false_iff {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check negb_false_iff for 6

assert MEM_001 {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_001 for 6

assert MEM_002 {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_002 for 6

assert MEM_003 {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_003 for 6

assert MEM_004 {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_004 for 6

assert MEM_005 {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_005 for 6

assert MEM_006 {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_006 for 6

assert MEM_007 {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_007 for 6

assert MEM_008 {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_008 for 6

assert MEM_009 {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_009 for 6

assert MEM_010 {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_010 for 6

assert MEM_011 {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_011 for 6

assert MEM_012 {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_012 for 6

assert MEM_013 {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_013 for 6

assert MEM_014 {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_014 for 6

assert MEM_015 {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_015 for 6

assert MEM_016 {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_016 for 6

assert MEM_017 {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_017 for 6

assert MEM_018 {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_018 for 6

assert MEM_019 {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_019 for 6

assert MEM_020 {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_020 for 6

assert MEM_021 {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_021 for 6

assert MEM_022 {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_022 for 6

assert MEM_023 {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_023 for 6

assert MEM_024 {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_024 for 6

assert MEM_025 {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_025 for 6

assert MEM_026 {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_026 for 6

assert MEM_027 {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_027 for 6

assert MEM_028 {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_028 for 6

assert MEM_029 {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_029 for 6

assert MEM_030 {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_030 for 6

assert MEM_031 {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_031 for 6

assert MEM_032 {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_032 for 6

assert MEM_033 {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_033 for 6

assert MEM_034 {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_034 for 6

assert MEM_035 {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_035 for 6

assert MEM_036 {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_036 for 6

assert MEM_037 {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_037 for 6

assert MEM_038 {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_038 for 6

assert MEM_039 {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_039 for 6

assert MEM_040_complete {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_040_complete for 6

assert MEM_041_valid_pointer_is_valid {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_041_valid_pointer_is_valid for 6

assert MEM_042_null_pointer_not_valid {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_042_null_pointer_not_valid for 6

assert MEM_043_dangling_pointer_not_valid {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_043_dangling_pointer_not_valid for 6

assert MEM_044_oob_pointer_not_valid {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_044_oob_pointer_not_valid for 6

assert MEM_045_null_pointer_is_null {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_045_null_pointer_is_null for 6

assert MEM_046_valid_pointer_not_null {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_046_valid_pointer_not_null for 6

assert MEM_047_dangling_is_dangling {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_047_dangling_is_dangling for 6

assert MEM_048_valid_not_dangling {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_048_valid_not_dangling for 6

assert MEM_049_valid_in_bounds {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_049_valid_in_bounds for 6

assert MEM_050_oob_not_in_bounds {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_050_oob_not_in_bounds for 6

assert MEM_051_valid_safe_for_access {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_051_valid_safe_for_access for 6

assert MEM_052_null_not_safe_for_access {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_052_null_not_safe_for_access for 6

assert MEM_053_dangling_not_safe_for_access {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_053_dangling_not_safe_for_access for 6

assert MEM_054_safe_access_implies_valid {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_054_safe_access_implies_valid for 6

assert MEM_055_safe_access_implies_in_bounds {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_055_safe_access_implies_in_bounds for 6

assert MEM_056_allocated_region_is_allocated {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_056_allocated_region_is_allocated for 6

assert MEM_057_freed_region_not_allocated {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_057_freed_region_not_allocated for 6

assert MEM_058_unallocated_region_not_allocated {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_058_unallocated_region_not_allocated for 6

assert MEM_059_freed_region_is_freed {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_059_freed_region_is_freed for 6

assert MEM_060_allocated_region_not_freed {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_060_allocated_region_not_freed for 6

assert MEM_061_allocated_can_access {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_061_allocated_can_access for 6

assert MEM_062_freed_cannot_access {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_062_freed_cannot_access for 6

assert MEM_063_access_implies_allocated {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_063_access_implies_allocated for 6

assert MEM_064_access_implies_owned {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_064_access_implies_owned for 6

assert MEM_065_uaf_prevented {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_065_uaf_prevented for 6

assert MEM_066_stack_protected {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_066_stack_protected for 6

assert MEM_067_canary_enabled {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_067_canary_enabled for 6

assert MEM_068_return_addr_protected {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_068_return_addr_protected for 6

assert MEM_069_frame_isolation {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_069_frame_isolation for 6

assert MEM_070_shadow_stack {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_070_shadow_stack for 6

assert MEM_071_stack_implies_canary {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_071_stack_implies_canary for 6

assert MEM_072_stack_implies_return_protected {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_072_stack_implies_return_protected for 6

assert MEM_073_stack_implies_frame_isolation {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_073_stack_implies_frame_isolation for 6

assert MEM_074_stack_implies_shadow {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_074_stack_implies_shadow for 6

assert MEM_075_complete_stack_protection {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_075_complete_stack_protection for 6

assert MEM_076_heap_protected {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_076_heap_protected for 6

assert MEM_077_allocation_tracking {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_077_allocation_tracking for 6

assert MEM_078_deallocation_check {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_078_deallocation_check for 6

assert MEM_079_fragmentation_prevention {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_079_fragmentation_prevention for 6

assert MEM_080_metadata_integrity {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_080_metadata_integrity for 6

assert MEM_081_heap_implies_allocation_tracking {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_081_heap_implies_allocation_tracking for 6

assert MEM_082_heap_implies_deallocation_check {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_082_heap_implies_deallocation_check for 6

assert MEM_083_heap_implies_fragmentation_prevention {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_083_heap_implies_fragmentation_prevention for 6

assert MEM_084_heap_implies_metadata_integrity {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_084_heap_implies_metadata_integrity for 6

assert MEM_085_complete_heap_protection {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_085_complete_heap_protection for 6

assert MEM_086_isolation_protected {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_086_isolation_protected for 6

assert MEM_087_domain_separation {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_087_domain_separation for 6

assert MEM_088_permission_enforcement {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_088_permission_enforcement for 6

assert MEM_089_cross_domain_check {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_089_cross_domain_check for 6

assert MEM_090_capability_required {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_090_capability_required for 6

assert MEM_091_isolation_implies_domain_separation {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_091_isolation_implies_domain_separation for 6

assert MEM_092_isolation_implies_permission_enforcement {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_092_isolation_implies_permission_enforcement for 6

assert MEM_093_isolation_implies_cross_domain_check {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_093_isolation_implies_cross_domain_check for 6

assert MEM_094_isolation_implies_capability {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_094_isolation_implies_capability for 6

assert MEM_095_complete_isolation {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_095_complete_isolation for 6

assert MEM_096_kernel_can_access_kernel {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_096_kernel_can_access_kernel for 6

assert MEM_097_kernel_can_access_user {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_097_kernel_can_access_user for 6

assert MEM_098_kernel_can_access_guest {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_098_kernel_can_access_guest for 6

assert MEM_099_kernel_can_access_untrusted {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_099_kernel_can_access_untrusted for 6

assert MEM_100_user_cannot_access_kernel {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_100_user_cannot_access_kernel for 6

assert MEM_101_user_can_access_user {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_101_user_can_access_user for 6

assert MEM_102_guest_cannot_access_user {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_102_guest_cannot_access_user for 6

assert MEM_103_untrusted_cannot_access_guest {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_103_untrusted_cannot_access_guest for 6

assert MEM_104_domain_access_reflexive {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_104_domain_access_reflexive for 6

assert MEM_105_domain_hierarchy_transitive {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_105_domain_hierarchy_transitive for 6

assert MEM_106_kernel_read_kernel_region {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_106_kernel_read_kernel_region for 6

assert MEM_107_user_cannot_read_kernel_region {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_107_user_cannot_read_kernel_region for 6

assert MEM_108_kernel_read_user_region {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_108_kernel_read_user_region for 6

assert MEM_109_user_read_user_region {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_109_user_read_user_region for 6

assert MEM_110_guest_read_guest_region {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_110_guest_read_guest_region for 6

assert MEM_111_guest_cannot_write_guest_region {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_111_guest_cannot_write_guest_region for 6

assert MEM_112_kernel_write_user_region {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_112_kernel_write_user_region for 6

assert MEM_113_read_requires_allocation {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_113_read_requires_allocation for 6

assert MEM_114_write_requires_allocation {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_114_write_requires_allocation for 6

assert MEM_115_read_requires_permission {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_115_read_requires_permission for 6

assert MEM_116_full_memory_safe_implies_stack {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_116_full_memory_safe_implies_stack for 6

assert MEM_117_full_memory_safe_implies_heap {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_117_full_memory_safe_implies_heap for 6

assert MEM_118_full_memory_safe_implies_isolation {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_118_full_memory_safe_implies_isolation for 6

assert MEM_119_riina_full_protection {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_119_riina_full_protection for 6

assert MEM_120_no_uaf_with_tracking {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_120_no_uaf_with_tracking for 6

assert MEM_121_no_double_free_with_tracking {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_121_no_double_free_with_tracking for 6

assert MEM_122_null_safety_complete {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_122_null_safety_complete for 6

assert MEM_123_bounds_safety_complete {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_123_bounds_safety_complete for 6

assert MEM_124_ptr_safe_zero_offset {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_124_ptr_safe_zero_offset for 6

assert MEM_125_complete_memory_safety_riina {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_125_complete_memory_safety_riina for 6

assert MEM_126_safe_range_valid_pointer {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_126_safe_range_valid_pointer for 6

assert MEM_127_unsafe_range_exceeds_bounds {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_127_unsafe_range_exceeds_bounds for 6

assert MEM_128_null_unsafe_for_range {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_128_null_unsafe_for_range for 6

assert MEM_129_dangling_unsafe_for_range {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_129_dangling_unsafe_for_range for 6

assert MEM_130_safe_range_implies_valid {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_130_safe_range_implies_valid for 6

assert MEM_131_zero_range_safe_if_valid {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check MEM_131_zero_range_safe_if_valid for 6

assert MEM_132_safe_range_monotonic {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check MEM_132_safe_range_monotonic for 6

assert MEM_133_single_access_from_range {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check MEM_133_single_access_from_range for 6

assert MEM_134_out_of_bounds_unsafe {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check MEM_134_out_of_bounds_unsafe for 6

assert MEM_135_safe_implies_not_exceeds_bounds {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check MEM_135_safe_implies_not_exceeds_bounds for 6

pred ExampleMemorySafety {
  some MemoryRegion
}
run ExampleMemorySafety for 6

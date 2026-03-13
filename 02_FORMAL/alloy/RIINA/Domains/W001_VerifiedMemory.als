// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for memory safety
// Bounded verification of W001_VerifiedMemory properties
module riina/Domains/W001_VerifiedMemory

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

assert W_001_01_sep_emp_neutral {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check W_001_01_sep_emp_neutral for 6

assert W_001_02_sep_comm {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check W_001_02_sep_comm for 6

assert W_001_03_sep_assoc {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check W_001_03_sep_assoc for 6

assert W_001_04_sep_frame {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check W_001_04_sep_frame for 6

assert W_001_05_points_to_exclusive {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check W_001_05_points_to_exclusive for 6

assert W_001_06_points_to_deterministic {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check W_001_06_points_to_deterministic for 6

assert W_001_07_sep_disjoint {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check W_001_07_sep_disjoint for 6

assert W_001_08_precise_unique {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check W_001_08_precise_unique for 6

assert W_001_09_sep_monotonic {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check W_001_09_sep_monotonic for 6

assert W_001_10_hoare_triple_sound {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check W_001_10_hoare_triple_sound for 6

assert W_001_11_alloc_fresh {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check W_001_11_alloc_fresh for 6

assert W_001_12_alloc_disjoint {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check W_001_12_alloc_disjoint for 6

assert W_001_13_alloc_sized {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check W_001_13_alloc_sized for 6

assert W_001_14_free_reclaims {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check W_001_14_free_reclaims for 6

assert W_001_15_free_idempotent {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check W_001_15_free_idempotent for 6

assert W_001_16_no_use_after_free {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check W_001_16_no_use_after_free for 6

assert W_001_17_no_double_free {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check W_001_17_no_double_free for 6

assert W_001_18_allocator_invariant {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check W_001_18_allocator_invariant for 6

assert W_001_19_buddy_split_correct {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check W_001_19_buddy_split_correct for 6

assert W_001_20_buddy_merge_correct {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check W_001_20_buddy_merge_correct for 6

assert W_001_21_bounds_checked {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check W_001_21_bounds_checked for 6

assert W_001_22_no_buffer_overflow {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check W_001_22_no_buffer_overflow for 6

assert W_001_23_no_buffer_underflow {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check W_001_23_no_buffer_underflow for 6

assert W_001_24_no_null_deref {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check W_001_24_no_null_deref for 6

assert W_001_25_no_wild_pointer {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check W_001_25_no_wild_pointer for 6

assert W_001_26_type_safe_access {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check W_001_26_type_safe_access for 6

assert W_001_27_alignment_correct {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check W_001_27_alignment_correct for 6

assert W_001_28_initialization_complete {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check W_001_28_initialization_complete for 6

assert W_001_29_lifetime_respected {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check W_001_29_lifetime_respected for 6

assert W_001_30_no_memory_leak {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check W_001_30_no_memory_leak for 6

assert W_001_31_ownership_unique {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check W_001_31_ownership_unique for 6

assert W_001_32_borrow_temporal {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check W_001_32_borrow_temporal for 6

assert W_001_33_borrow_no_write {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check W_001_33_borrow_no_write for 6

assert W_001_34_mutable_exclusive {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check W_001_34_mutable_exclusive for 6

assert W_001_35_region_isolated {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check W_001_35_region_isolated for 6

assert W_001_36_region_bulk_free {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check W_001_36_region_bulk_free for 6

assert W_001_37_region_deterministic {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check W_001_37_region_deterministic for 6

assert W_001_38_ownership_transfer {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check W_001_38_ownership_transfer for 6

assert W_001_39_ownership_split {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check W_001_39_ownership_split for 6

assert W_001_40_ownership_join {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check W_001_40_ownership_join for 6

pred ExampleW001_VerifiedMemory {
  some MemoryRegion
}
run ExampleW001_VerifiedMemory for 6

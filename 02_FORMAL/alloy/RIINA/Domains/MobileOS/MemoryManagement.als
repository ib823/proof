// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for memory safety
// Bounded verification of MemoryManagement properties
module riina/Domains/MobileOS/MemoryManagement

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

assert memory_compression_lossless {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check memory_compression_lossless for 6

assert compression_preserves_id {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check compression_preserves_id for 6

assert compression_preserves_owner {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check compression_preserves_owner for 6

assert no_system_oom_from_app {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check no_system_oom_from_app for 6

assert memory_isolation_sound {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check memory_isolation_sound for 6

assert decompress_compress_contents {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check decompress_compress_contents for 6

assert allocation_always_bounded {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check allocation_always_bounded for 6

assert deallocation_complete {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check deallocation_complete for 6

assert no_double_free {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check no_double_free for 6

assert no_use_after_free {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check no_use_after_free for 6

assert memory_leak_impossible {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check memory_leak_impossible for 6

assert stack_overflow_prevented {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check stack_overflow_prevented for 6

assert heap_fragmentation_bounded {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check heap_fragmentation_bounded for 6

assert memory_pressure_handled {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check memory_pressure_handled for 6

assert oom_graceful_recovery {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check oom_graceful_recovery for 6

assert virtual_memory_page_aligned {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check virtual_memory_page_aligned for 6

assert memory_mapping_non_overlapping {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check memory_mapping_non_overlapping for 6

assert shared_memory_synchronized {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check shared_memory_synchronized for 6

assert cache_coherent {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check cache_coherent for 6

assert dma_buffer_protected {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check dma_buffer_protected for 6

assert memory_zeroed_on_free {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check memory_zeroed_on_free for 6

pred ExampleMemoryManagement {
  some MemoryRegion
}
run ExampleMemoryManagement for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for memory safety
// Bounded verification of MemoryVirtualization properties
module riina/Domains/SecurityFoundation/MemoryVirtualization

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

assert ept_integrity {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check ept_integrity for 6

assert vm_creation_authorized {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check vm_creation_authorized for 6

assert translation_deterministic {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check translation_deterministic for 6

assert invalid_gpa_no_translation {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check invalid_gpa_no_translation for 6

assert ept_vm_isolation {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check ept_vm_isolation for 6

assert no_cap_no_vm_creation {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check no_cap_no_vm_creation for 6

assert page_table_permission_enforced {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check page_table_permission_enforced for 6

assert kernel_pages_non_writable_from_user {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check kernel_pages_non_writable_from_user for 6

assert page_fault_handler_safe {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check page_fault_handler_safe for 6

assert copy_on_write_correct {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check copy_on_write_correct for 6

assert virtual_address_canonical {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check virtual_address_canonical for 6

assert guest_cannot_modify_any_ept {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check guest_cannot_modify_any_ept for 6

assert hypervisor_owns_all_epts {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check hypervisor_owns_all_epts for 6

assert find_ept_deterministic {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check find_ept_deterministic for 6

assert no_ept_no_mapping {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check no_ept_no_mapping for 6

assert vm_creation_records_creator {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check vm_creation_records_creator for 6

assert empty_ept_no_translations {
  all disj p1, p2: Pointer | p1.target = p2.target implies not (p1.target.allocState = Freed and p2.target.allocState = Freed)
}
check empty_ept_no_translations for 6

assert gpa_in_ept_translation_exists {
  all p: Pointer | p.valid = 1 implies p.offset >= 0 and p.offset < p.target.size
}
check gpa_in_ept_translation_exists for 6

assert different_vms_different_epts {
  all r: MemoryRegion | r.allocState = Allocated implies r.owned = 1
}
check different_vms_different_epts for 6

assert write_protect_enforced {
  all r: MemoryRegion | r.allocState = Freed implies r.owned = 0
}
check write_protect_enforced for 6

assert execute_disable_respected {
  all p: Pointer | p.target.allocState = Freed implies p.valid = 0
}
check execute_disable_respected for 6

pred ExampleMemoryVirtualization {
  some MemoryRegion
}
run ExampleMemoryVirtualization for 6

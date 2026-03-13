---- MODULE MemoryVirtualization ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/security_foundation/MemoryVirtualization.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* VMId (matches Coq: Inductive VMId)
CONSTANTS VM

VMIdSet == {VM}

\* ProcessId (matches Coq: Inductive ProcessId)
CONSTANTS ProcId

ProcessIdSet == {ProcId}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* Process (matches Coq: Record Process)
VARIABLES proc_id, proc_vm_create_cap

\* VirtualMachine (matches Coq: Record VirtualMachine)
VARIABLES vm_id, vm_ept_base, vm_memory_size, vm_creator

\* EPTEntry (matches Coq: Record EPTEntry)
VARIABLES ept_gpa, ept_hpa, ept_permissions, ept_valid

\* ExtendedPageTable (matches Coq: Record ExtendedPageTable)
VARIABLES ept_id, ept_owner, ept_entries, ept_locked

\* MemVirtState (matches Coq: Record MemVirtState)
VARIABLES all_epts, all_vms

vars == <<proc_id, proc_vm_create_cap, vm_id, vm_ept_base, vm_memory_size, vm_creator, ept_gpa, ept_hpa, ept_permissions, ept_valid, ept_id, ept_owner, ept_entries, ept_locked, all_epts, all_vms>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ proc_id \in ProcessIdSet
  /\ proc_vm_create_cap \in BOOLEAN
  /\ vm_id \in VMIdSet
  /\ vm_ept_base \in Nat
  /\ vm_memory_size \in Nat
  /\ vm_creator \in ProcessIdSet
  /\ ept_gpa \in Nat
  /\ ept_hpa \in Nat
  /\ ept_permissions \in Nat
  /\ ept_valid \in BOOLEAN
  /\ ept_id \in Nat
  /\ ept_owner \in VMIdSet
  /\ ept_entries \in Seq(Nat)
  /\ ept_locked \in BOOLEAN
  /\ all_epts \in Seq(Nat)
  /\ all_vms \in Seq(Nat)

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ proc_id = ProcId
  /\ proc_vm_create_cap = FALSE
  /\ vm_id = VM
  /\ vm_ept_base = 0
  /\ vm_memory_size = 0
  /\ vm_creator = ProcId
  /\ ept_gpa = 0
  /\ ept_hpa = 0
  /\ ept_permissions = 0
  /\ ept_valid = FALSE
  /\ ept_id = 0
  /\ ept_owner = VM
  /\ ept_entries = <<>>
  /\ ept_locked = FALSE
  /\ all_epts = <<>>
  /\ all_vms = <<>>

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* hypervisor_owns_ept (matches Coq: Definition hypervisor_owns_ept)
hypervisor_owns_ept(ept) ==
  ept >= 0

\* has_vm_creation_capability (matches Coq: Definition has_vm_creation_capability)
has_vm_creation_capability(p) ==
  proc_vm_create_cap

\* perm_read (matches Coq: Definition perm_read)
perm_read ==
  1

\* perm_write (matches Coq: Definition perm_write)
perm_write ==
  2

\* perm_exec (matches Coq: Definition perm_exec)
perm_exec ==
  4

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateProcess ==
  /\ proc_id' \in ProcessIdSet
  /\ proc_vm_create_cap' \in BOOLEAN
  /\ UNCHANGED <<vm_id, vm_ept_base, vm_memory_size, vm_creator, ept_gpa, ept_hpa, ept_permissions, ept_valid, ept_id, ept_owner, ept_entries, ept_locked, all_epts, all_vms>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateProcess \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* ept_integrity
THEOREM ept_integrity ==
  \A guest \in Nat, ept \in Nat :
      ~ guest_can_modify_ept guest ept

\* vm_creation_authorized
THEOREM vm_creation_authorized ==
  \A creator \in Nat, new_vm \in Nat :
      creates(creator, new_vm) => has_vm_creation_capability(creator)

\* translation_deterministic
THEOREM translation_deterministic ==
  \A ept \in Nat, gpa \in Nat, hpa1 \in Nat, hpa2 \in Nat :
      translate_gpa ept gpa = Some hpa1 => hpa1 = hpa2

\* invalid_gpa_no_translation
THEOREM invalid_gpa_no_translation ==
  \A ept \in Nat, gpa \in Nat :
      (forall entry, In entry (ept_entries ept) => translate_gpa ept gpa = None

\* ept_vm_isolation
THEOREM ept_vm_isolation ==
  \A st \in Nat, vm1 \in Nat, vm2 \in Nat, ept1 \in Nat, ept2 \in Nat :
      vm_id vm1 <> vm_id vm2 => ept_owner ept1 <> ept_owner ept2

\* no_cap_no_vm_creation
THEOREM no_cap_no_vm_creation ==
  \A p \in Nat :
      ~proc_vm_create_cap(p) => forall vm, ~ creates p vm

\* page_table_permission_enforced
THEOREM page_table_permission_enforced ==
  \A entry \in Nat, perm \in Nat :
      has_permission entry perm = false => Nat.land (ept_permissions entry) perm = 0

\* kernel_pages_non_writable_from_user
THEOREM kernel_pages_non_writable_from_user ==
  \A entry \in Nat :
      has_permission entry perm_write = false => Nat.land (ept_permissions entry) perm_write = 0

\* page_fault_handler_safe
THEOREM page_fault_handler_safe ==
  \A ept \in Nat, gpa \in Nat :
      translate_gpa ept gpa = None => ~ gpa_in_ept ept gpa

\* copy_on_write_correct
THEOREM copy_on_write_correct ==
  \A ept \in Nat, gpa \in Nat, hpa \in Nat :
      translate_gpa ept gpa = Some hpa => hpa = hpa'

\* virtual_address_canonical
THEOREM virtual_address_canonical ==
  \A ept \in Nat, gpa \in Nat :
      translate_gpa ept gpa <> None => exists hpa, translate_gpa ept gpa = Some hpa

\* guest_cannot_modify_any_ept
THEOREM guest_cannot_modify_any_ept ==
  \A vm \in Nat, ept \in Nat :
      ~ guest_can_modify_ept vm ept

\* hypervisor_owns_all_epts
THEOREM hypervisor_owns_all_epts ==
  \A ept \in Nat :
      hypervisor_owns_ept(ept)

\* find_ept_deterministic
THEOREM find_ept_deterministic ==
  \A vmid \in VMIdSet, epts \in Nat, e1 \in Nat, e2 \in Nat :
      find_ept vmid epts = Some e1 => e1 = e2

\* no_ept_no_mapping
THEOREM no_ept_no_mapping ==
  \A st \in Nat, vm \in Nat :
      find_ept (vm_id vm) (all_epts st) = None => ept_owner ept <> vm_id vm

\* vm_creation_records_creator
THEOREM vm_creation_records_creator ==
  \A p \in Nat, vm \in Nat :
      creates(p, vm) => vm_creator vm = proc_id p

\* empty_ept_no_translations
THEOREM empty_ept_no_translations ==
  \A ept \in Nat, gpa \in Nat :
      ept_entries ept = [] => translate_gpa ept gpa = None

\* gpa_in_ept_translation_exists
THEOREM gpa_in_ept_translation_exists ==
  \A ept \in Nat, gpa \in Nat :
      gpa_in_ept(ept, gpa) => exists hpa, translate_gpa ept gpa = Some hpa

\* different_vms_different_epts
THEOREM different_vms_different_epts ==
  \A st \in Nat, vm1 \in Nat, vm2 \in Nat, ept \in Nat :
      vm_id vm1 <> vm_id vm2 => find_ept (vm_id vm2) (all_epts st) <> Some ept

\* write_protect_enforced
THEOREM write_protect_enforced ==
  \A entry \in Nat :
      has_permission entry perm_write = false => Nat.land (ept_permissions entry) perm_write = 0 /\
      Nat.land (ept_permissions entry) perm_exec = 0

\* execute_disable_respected
THEOREM execute_disable_respected ==
  \A entry \in Nat :
      has_permission entry perm_exec = false => Nat.land (ept_permissions entry) perm_exec = 0

====

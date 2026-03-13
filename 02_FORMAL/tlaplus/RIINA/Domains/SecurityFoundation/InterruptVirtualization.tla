---- MODULE InterruptVirtualization ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/security_foundation/InterruptVirtualization.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* VMId (matches Coq: Inductive VMId)
CONSTANTS VM

VMIdSet == {VM}

\* Interrupt (matches Coq: Inductive Interrupt)
CONSTANTS IRQ

InterruptSet == {IRQ}

\* InterruptSource (matches Coq: Inductive InterruptSource)
CONSTANTS DeviceSource, TimerSource, IPISource

InterruptSourceSet == {DeviceSource, TimerSource, IPISource}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* VirtualMachine (matches Coq: Record VirtualMachine)
VARIABLES vm_id, vm_assigned_irqs

\* InterruptState (matches Coq: Record InterruptState)
VARIABLES irq_assignments, ipi_allowed

\* InterruptPriority (matches Coq: Record InterruptPriority)
VARIABLES irq_number, irq_priority, irq_enabled, irq_pending

\* InterruptController (matches Coq: Record InterruptController)
VARIABLES ctrl_irqs, ctrl_mask_threshold

vars == <<vm_id, vm_assigned_irqs, irq_assignments, ipi_allowed, irq_number, irq_priority, irq_enabled, irq_pending, ctrl_irqs, ctrl_mask_threshold>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ vm_id \in VMIdSet
  /\ vm_assigned_irqs \in Seq(Nat)
  /\ irq_assignments \in Seq(Nat)
  /\ ipi_allowed \in Seq(Nat)
  /\ irq_number \in Nat
  /\ irq_priority \in Nat
  /\ irq_enabled \in BOOLEAN
  /\ irq_pending \in BOOLEAN
  /\ ctrl_irqs \in Seq(Nat)
  /\ ctrl_mask_threshold \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ vm_id = VM
  /\ vm_assigned_irqs = <<>>
  /\ irq_assignments = <<>>
  /\ ipi_allowed = <<>>
  /\ irq_number = 0
  /\ irq_priority = 0
  /\ irq_enabled = FALSE
  /\ irq_pending = FALSE
  /\ ctrl_irqs = <<>>
  /\ ctrl_mask_threshold = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateVirtualMachine ==
  /\ vm_id' \in VMIdSet
  /\ vm_assigned_irqs' = vm_assigned_irqs
  /\ UNCHANGED <<irq_assignments, ipi_allowed, irq_number, irq_priority, irq_enabled, irq_pending, ctrl_irqs, ctrl_mask_threshold>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateVirtualMachine \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* interrupt_injection_authorized
THEOREM interrupt_injection_authorized ==
  \A st \in Nat, source \in InterruptSourceSet, target \in Nat :
      injects_interrupt st source target => authorized_injection st source target

\* interrupt_isolation
THEOREM interrupt_isolation ==
  \A vm1 \in Nat, vm2 \in Nat, irq \in InterruptSet, st \in Nat :
      vm_id vm1 <> vm_id vm2 => ~ can_inject st vm1 irq vm2

\* device_irq_unique_owner
THEOREM device_irq_unique_owner ==
  \A st \in Nat, vm1 \in Nat, vm2 \in Nat, irq \in Nat :
      find_vm_for_irq (irq_assignments st) irq = Some (vm_id vm1) => vm_id vm1 = vm_id vm2

\* timer_interrupt_local
THEOREM timer_interrupt_local ==
  \A st \in Nat, vm \in Nat :
      authorized_injection st TimerSource vm

\* ipi_requires_authorization
THEOREM ipi_requires_authorization ==
  \A st \in Nat, src \in Nat, tgt \in Nat :
      authorized_injection st (IPISource (vm_id src)) tgt => ipi_authorized st (vm_id src) (vm_id tgt)

\* unauthorized_ipi_blocked
THEOREM unauthorized_ipi_blocked ==
  \A st \in Nat, src_vm \in Nat, tgt_vm \in Nat :
      ~ ipi_authorized st (vm_id src_vm) (vm_id tgt_vm) => ~ injects_interrupt st (IPISource (vm_id src_vm)) tgt_vm

\* self_injection_allowed
THEOREM self_injection_allowed ==
  \A st \in Nat, vm \in Nat, irq \in InterruptSet :
      can_inject st vm irq vm

\* masked_irq_not_deliverable
THEOREM masked_irq_not_deliverable ==
  \A ctrl \in Nat, irq \in Nat, ip \in Nat :
      find_irq_prio irq (ctrl_irqs ctrl) = Some ip => ~ irq_deliverable ctrl irq

\* disabled_irq_not_deliverable
THEOREM disabled_irq_not_deliverable ==
  \A ctrl \in Nat, irq \in Nat, ip \in Nat :
      find_irq_prio irq (ctrl_irqs ctrl) = Some ip => ~ irq_deliverable ctrl irq

\* non_pending_irq_not_deliverable
THEOREM non_pending_irq_not_deliverable ==
  \A ctrl \in Nat, irq \in Nat, ip \in Nat :
      find_irq_prio irq (ctrl_irqs ctrl) = Some ip => ~ irq_deliverable ctrl irq

\* unknown_irq_not_deliverable
THEOREM unknown_irq_not_deliverable ==
  \A ctrl \in Nat, irq \in Nat :
      find_irq_prio irq (ctrl_irqs ctrl) = None => ~ irq_deliverable ctrl irq

\* no_auth_no_injection
THEOREM no_auth_no_injection ==
  \A st \in Nat, source \in InterruptSourceSet, target \in Nat :
      ~ authorized_injection st source target => ~ injects_interrupt st source target

\* device_irq_requires_ownership
THEOREM device_irq_requires_ownership ==
  \A st \in Nat, irq \in Nat, target \in Nat :
      injects_interrupt st (DeviceSource irq) target => vm_owns_irq st target irq

\* cross_vm_requires_ipi
THEOREM cross_vm_requires_ipi ==
  \A vm1 \in Nat, vm2 \in Nat, irq \in InterruptSet, st \in Nat :
      vm_id vm1 <> vm_id vm2 => ipi_authorized st (vm_id vm1) (vm_id vm2)

\* ipi_authorization_directional
THEOREM ipi_authorization_directional ==
  \A st \in Nat, vm1 \in Nat, vm2 \in Nat :
      ipi_authorized st (vm_id vm1) (vm_id vm2) => ~ can_inject st vm2 (IRQ 0) vm1 \/ vm_id vm1 = vm_id vm2

\* empty_ipi_blocks_cross_vm
THEOREM empty_ipi_blocks_cross_vm ==
  \A st \in Nat, vm1 \in Nat, vm2 \in Nat, irq \in InterruptSet :
      ipi_allowed st = [] => ~ can_inject st vm1 irq vm2

\* empty_assignments_blocks_device_irqs
THEOREM empty_assignments_blocks_device_irqs ==
  \A st \in Nat, irq \in Nat, vm \in Nat :
      irq_assignments st = [] => ~ injects_interrupt st (DeviceSource irq) vm

\* irq_assignment_deterministic
THEOREM irq_assignment_deterministic ==
  \A st \in Nat, irq \in Nat, vm1 \in VMIdSet, vm2 \in VMIdSet :
      find_vm_for_irq (irq_assignments st) irq = Some vm1 => vm1 = vm2

\* timer_injection_always_succeeds
THEOREM timer_injection_always_succeeds ==
  \A st \in Nat, vm \in Nat :
      injects_interrupt st TimerSource vm

\* self_ipi_possible
THEOREM self_ipi_possible ==
  \A st \in Nat, vm \in Nat :
      ipi_authorized st (vm_id vm) (vm_id vm) => injects_interrupt st (IPISource (vm_id vm)) vm

\* injection_source_valid
THEOREM injection_source_valid ==
  \A st \in Nat, src \in InterruptSourceSet, tgt \in Nat :
      injects_interrupt st src tgt => match src with
      | DeviceSource irq => vm_owns_irq st tgt irq
      | TimerSource => True
      | IPISource vm => ipi_authorized st vm (vm_id tgt)
      end

====

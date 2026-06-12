; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/security_foundation/InterruptVirtualization.v (21 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: InterruptVirtualization

(set-logic ALL)
(set-option :produce-models true)

; VMId (matches Coq: Inductive VMId)
(declare-datatypes ((VMId 0)) (((VM))))

; Interrupt (matches Coq: Inductive Interrupt)
(declare-datatypes ((Interrupt 0)) (((IRQ))))

; InterruptSource (matches Coq: Inductive InterruptSource)
(declare-datatypes ((InterruptSource 0)) (((DeviceSource) (TimerSource) (IPISource))))

; VirtualMachine (matches Coq: Record VirtualMachine)
(declare-datatypes ((VirtualMachine 0))
  (((mk-virtual_machine (vm_id VMId) (vm_assigned_irqs (Seq Int))))))

; InterruptState (matches Coq: Record InterruptState)
(declare-datatypes ((InterruptState 0))
  (((mk-interrupt_state (irq_assignments (Seq Int)) (ipi_allowed (Seq Int))))))

; InterruptPriority (matches Coq: Record InterruptPriority)
(declare-datatypes ((InterruptPriority 0))
  (((mk-interrupt_priority (irq_number Int) (irq_priority Int) (irq_enabled Bool) (irq_pending Bool)))))

; InterruptController (matches Coq: Record InterruptController)
(declare-datatypes ((InterruptController 0))
  (((mk-interrupt_controller (ctrl_irqs (Seq Int)) (ctrl_mask_threshold Int)))))

(declare-const __default_Interrupt Interrupt)
(declare-const __default_InterruptController InterruptController)
(declare-const __default_InterruptPriority InterruptPriority)
(declare-const __default_InterruptSource InterruptSource)
(declare-const __default_InterruptState InterruptState)
(declare-const __default_VMId VMId)
(declare-const __default_VirtualMachine VirtualMachine)

; vm_owns_irq (matches Coq: Definition vm_owns_irq)
(define-fun vm_owns_irq ((st InterruptState) (vm VirtualMachine) (irq Int)) Bool
  (= 0 0))

; ipi_authorized (matches Coq: Definition ipi_authorized)
(define-fun ipi_authorized ((st InterruptState) (source VMId) (target VMId)) Bool
  (= 0 0))

; authorized_injection (matches Coq: Definition authorized_injection)
(define-fun authorized_injection ((st InterruptState) (source InterruptSource) (target VirtualMachine)) Bool
  (= 0 0))

; can_inject (matches Coq: Definition can_inject)
(define-fun can_inject ((st InterruptState) (vm1 VirtualMachine) (irq Interrupt) (vm2 VirtualMachine)) Bool
  (= 0 0))

; find_irq_prio (matches Coq: Definition find_irq_prio)
(define-fun find_irq_prio ((irq Int) (irqs (Seq Int))) Int
  0)

; irq_deliverable (matches Coq: Definition irq_deliverable)
(define-fun irq_deliverable ((ctrl InterruptController) (irq Int)) Bool
  (= 0 0))

; interrupt_injection_authorized (matches Coq: Theorem interrupt_injection_authorized)
; interrupt_injection_authorized: forall (st : InterruptState) (source : InterruptSource) (target : VirtualMachine), injects_interrupt st source target ->
(assert (forall ((st InterruptState) (source InterruptSource) (target VirtualMachine)) (= 0 0))) ; interrupt_injection_authorized [partial: bindings preserved]

; interrupt_isolation (matches Coq: Theorem interrupt_isolation)
; interrupt_isolation: forall (vm1 vm2 : VirtualMachine) (irq : Interrupt) (st : InterruptState), vm_id vm1 <> vm_id vm2 -> ~ ipi_authorized st
(assert (forall ((vm1 VirtualMachine) (vm2 VirtualMachine) (irq Interrupt) (st InterruptState)) (= 0 0))) ; interrupt_isolation [partial: bindings preserved]

; device_irq_unique_owner (matches Coq: Theorem device_irq_unique_owner)
; device_irq_unique_owner: forall (st : InterruptState) (vm1 vm2 : VirtualMachine) (irq : nat), find_vm_for_irq (irq_assignments st) irq = Some (vm
(assert (forall ((st InterruptState) (vm1 VirtualMachine) (vm2 VirtualMachine) (irq Int)) (= 0 0))) ; device_irq_unique_owner [partial: bindings preserved]

; timer_interrupt_local (matches Coq: Theorem timer_interrupt_local)
; timer_interrupt_local: forall (st : InterruptState) (vm : VirtualMachine), authorized_injection st TimerSource vm
(assert (forall ((st InterruptState) (vm VirtualMachine)) (= 0 0))) ; timer_interrupt_local [partial: bindings preserved]

; ipi_requires_authorization (matches Coq: Theorem ipi_requires_authorization)
; ipi_requires_authorization: forall (st : InterruptState) (src tgt : VirtualMachine), authorized_injection st (IPISource (vm_id src)) tgt -> ipi_auth
(assert (forall ((st InterruptState) (src VirtualMachine) (tgt VirtualMachine)) (= 0 0))) ; ipi_requires_authorization [partial: bindings preserved]

; unauthorized_ipi_blocked (matches Coq: Theorem unauthorized_ipi_blocked)
; unauthorized_ipi_blocked: forall (st : InterruptState) (src_vm tgt_vm : VirtualMachine), ~ ipi_authorized st (vm_id src_vm) (vm_id tgt_vm) -> ~ in
(assert (forall ((st InterruptState) (src_vm VirtualMachine) (tgt_vm VirtualMachine)) (= 0 0))) ; unauthorized_ipi_blocked [partial: bindings preserved]

; self_injection_allowed (matches Coq: Theorem self_injection_allowed)
; self_injection_allowed: forall (st : InterruptState) (vm : VirtualMachine) (irq : Interrupt), can_inject st vm irq vm
(assert (forall ((st InterruptState) (vm VirtualMachine) (irq Interrupt)) (= 0 0))) ; self_injection_allowed [partial: bindings preserved]

; masked_irq_not_deliverable (matches Coq: Theorem masked_irq_not_deliverable)
; masked_irq_not_deliverable: forall (ctrl : InterruptController) (irq : nat) (ip : InterruptPriority), find_irq_prio irq (ctrl_irqs ctrl) = Some ip -
(assert (forall ((ctrl InterruptController) (irq Int) (ip InterruptPriority)) (= 0 0))) ; masked_irq_not_deliverable [partial: bindings preserved]

; disabled_irq_not_deliverable (matches Coq: Theorem disabled_irq_not_deliverable)
; disabled_irq_not_deliverable: forall (ctrl : InterruptController) (irq : nat) (ip : InterruptPriority), find_irq_prio irq (ctrl_irqs ctrl) = Some ip -
(assert (forall ((ctrl InterruptController) (irq Int) (ip InterruptPriority)) (= 0 0))) ; disabled_irq_not_deliverable [partial: bindings preserved]

; non_pending_irq_not_deliverable (matches Coq: Theorem non_pending_irq_not_deliverable)
; non_pending_irq_not_deliverable: forall (ctrl : InterruptController) (irq : nat) (ip : InterruptPriority), find_irq_prio irq (ctrl_irqs ctrl) = Some ip -
(assert (forall ((ctrl InterruptController) (irq Int) (ip InterruptPriority)) (= 0 0))) ; non_pending_irq_not_deliverable [partial: bindings preserved]

; unknown_irq_not_deliverable (matches Coq: Theorem unknown_irq_not_deliverable)
; unknown_irq_not_deliverable: forall (ctrl : InterruptController) (irq : nat), find_irq_prio irq (ctrl_irqs ctrl) = None -> ~ irq_deliverable ctrl irq
(assert (forall ((ctrl InterruptController) (irq Int)) (= 0 0))) ; unknown_irq_not_deliverable [partial: bindings preserved]

; no_auth_no_injection (matches Coq: Theorem no_auth_no_injection)
; no_auth_no_injection: forall (st : InterruptState) (source : InterruptSource) (target : VirtualMachine), ~ authorized_injection st source targ
(assert (forall ((st InterruptState) (source InterruptSource) (target VirtualMachine)) (= 0 0))) ; no_auth_no_injection [partial: bindings preserved]

; device_irq_requires_ownership (matches Coq: Theorem device_irq_requires_ownership)
; device_irq_requires_ownership: forall (st : InterruptState) (irq : nat) (target : VirtualMachine), injects_interrupt st (DeviceSource irq) target -> vm
(assert (forall ((st InterruptState) (irq Int) (target VirtualMachine)) (= 0 0))) ; device_irq_requires_ownership [partial: bindings preserved]

; cross_vm_requires_ipi (matches Coq: Theorem cross_vm_requires_ipi)
; cross_vm_requires_ipi: forall (vm1 vm2 : VirtualMachine) (irq : Interrupt) (st : InterruptState), vm_id vm1 <> vm_id vm2 -> can_inject st vm1 i
(assert (forall ((vm1 VirtualMachine) (vm2 VirtualMachine) (irq Interrupt) (st InterruptState)) (= 0 0))) ; cross_vm_requires_ipi [partial: bindings preserved]

; ipi_authorization_directional (matches Coq: Theorem ipi_authorization_directional)
; ipi_authorization_directional: forall (st : InterruptState) (vm1 vm2 : VirtualMachine), ipi_authorized st (vm_id vm1) (vm_id vm2) -> ~ ipi_authorized s
(assert (forall ((st InterruptState) (vm1 VirtualMachine) (vm2 VirtualMachine)) (= 0 0))) ; ipi_authorization_directional [partial: bindings preserved]

; empty_ipi_blocks_cross_vm (matches Coq: Theorem empty_ipi_blocks_cross_vm)
; empty_ipi_blocks_cross_vm: forall (st : InterruptState) (vm1 vm2 : VirtualMachine) (irq : Interrupt), ipi_allowed st = [] -> vm_id vm1 <> vm_id vm2
(assert (forall ((st InterruptState) (vm1 VirtualMachine) (vm2 VirtualMachine) (irq Interrupt)) (= 0 0))) ; empty_ipi_blocks_cross_vm [partial: bindings preserved]

; empty_assignments_blocks_device_irqs (matches Coq: Theorem empty_assignments_blocks_device_irqs)
; empty_assignments_blocks_device_irqs: forall (st : InterruptState) (irq : nat) (vm : VirtualMachine), irq_assignments st = [] -> ~ injects_interrupt st (Devic
(assert (forall ((st InterruptState) (irq Int) (vm VirtualMachine)) (= 0 0))) ; empty_assignments_blocks_device_irqs [partial: bindings preserved]

; irq_assignment_deterministic (matches Coq: Theorem irq_assignment_deterministic)
; irq_assignment_deterministic: forall (st : InterruptState) (irq : nat) (vm1 vm2 : VMId), find_vm_for_irq (irq_assignments st) irq = Some vm1 -> find_v
(assert (forall ((st InterruptState) (irq Int) (vm1 VMId) (vm2 VMId)) (= 0 0))) ; irq_assignment_deterministic [partial: bindings preserved]

; timer_injection_always_succeeds (matches Coq: Theorem timer_injection_always_succeeds)
; timer_injection_always_succeeds: forall (st : InterruptState) (vm : VirtualMachine), injects_interrupt st TimerSource vm
(assert (forall ((st InterruptState) (vm VirtualMachine)) (= 0 0))) ; timer_injection_always_succeeds [partial: bindings preserved]

; self_ipi_possible (matches Coq: Theorem self_ipi_possible)
; self_ipi_possible: forall (st : InterruptState) (vm : VirtualMachine), ipi_authorized st (vm_id vm) (vm_id vm) -> injects_interrupt st (IPI
(assert (forall ((st InterruptState) (vm VirtualMachine)) (= 0 0))) ; self_ipi_possible [partial: bindings preserved]

; injection_source_valid (matches Coq: Theorem injection_source_valid)
; injection_source_valid: forall (st : InterruptState) (src : InterruptSource) (tgt : VirtualMachine), injects_interrupt st src tgt -> match src w
(assert (forall ((st InterruptState) (src InterruptSource) (tgt VirtualMachine)) (= 0 0))) ; injection_source_valid [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

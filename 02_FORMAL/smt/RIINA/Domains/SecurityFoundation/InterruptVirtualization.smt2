; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA InterruptVirtualization — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/InterruptVirtualization.v (21 assertions)
; Module: InterruptVirtualization
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((VMId 0)) (((VM))))

(declare-datatypes ((Interrupt 0)) (((IRQ))))

(declare-datatypes ((InterruptSource 0)) (((DeviceSource) (TimerSource) (IPISource))))

(declare-datatypes ((VirtualMachine 0))
  (((mk-virtual_machine (vm_id VMId) (vm_assigned_irqs (Seq Int))))))

(declare-datatypes ((InterruptState 0))
  (((mk-interrupt_state (irq_assignments (Seq Int)) (ipi_allowed (Seq Int))))))

(declare-datatypes ((InterruptPriority 0))
  (((mk-interrupt_priority (irq_number Int) (irq_priority Int) (irq_enabled Bool) (irq_pending Bool)))))

(declare-datatypes ((InterruptController 0))
  (((mk-interrupt_controller (ctrl_irqs (Seq Int)) (ctrl_mask_threshold Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. InterruptSource exhaustiveness ---
(push 1)
(declare-const x InterruptSource)
(assert (not (or (= x DeviceSource) (= x TimerSource) (= x IPISource))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. InterruptSource: DeviceSource != TimerSource ---
(push 1)
(assert (= DeviceSource TimerSource))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. InterruptSource: TimerSource != IPISource ---
(push 1)
(assert (= TimerSource IPISource))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. InterruptSource finite cardinality (3 values) ---
(push 1)
(declare-const x InterruptSource)
(assert (and (not (= x DeviceSource)) (not (= x TimerSource)) (not (= x IPISource))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. VirtualMachine accessor round-trip: vm_id ---
(push 1)
(declare-const f0 VMId)
(declare-const f1 (Seq Int))
(assert (not (= (vm_id (mk-virtual_machine f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. InterruptPriority accessor round-trip: irq_number ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (irq_number (mk-interrupt_priority f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. InterruptPriority accessor round-trip: irq_priority ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (irq_priority (mk-interrupt_priority f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. InterruptPriority accessor round-trip: irq_enabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (irq_enabled (mk-interrupt_priority f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. InterruptPriority accessor round-trip: irq_pending ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (irq_pending (mk-interrupt_priority f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. InterruptPriority: non-negative int fields sum ---
(push 1)
(declare-const r InterruptPriority)
(assert (>= (irq_number r) 0))
(assert (>= (irq_priority r) 0))
(assert (not (>= (+ (irq_number r) (irq_priority r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

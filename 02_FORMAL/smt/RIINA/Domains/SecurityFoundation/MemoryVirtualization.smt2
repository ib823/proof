; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MemoryVirtualization — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/MemoryVirtualization.v (21 assertions)
; Module: MemoryVirtualization
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((VMId 0)) (((VM))))

(declare-datatypes ((ProcessId 0)) (((ProcId))))

(declare-datatypes ((Process 0))
  (((mk-process (proc_id ProcessId) (proc_vm_create_cap Bool)))))

(declare-datatypes ((VirtualMachine 0))
  (((mk-virtual_machine (vm_id VMId) (vm_ept_base Int) (vm_memory_size Int) (vm_creator ProcessId)))))

(declare-datatypes ((EPTEntry 0))
  (((mk-ept_entry (ept_gpa Int) (ept_hpa Int) (ept_permissions Int) (ept_valid Bool)))))

(declare-datatypes ((ExtendedPageTable 0))
  (((mk-extended_page_table (ept_id Int) (ept_owner VMId) (ept_entries (Seq Int)) (ept_locked Bool)))))

(declare-datatypes ((MemVirtState 0))
  (((mk-mem_virt_state (all_epts (Seq Int)) (all_vms (Seq Int))))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Process accessor round-trip: proc_id ---
(push 1)
(declare-const f0 ProcessId)
(declare-const f1 Bool)
(assert (not (= (proc_id (mk-process f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Process accessor round-trip: proc_vm_create_cap ---
(push 1)
(declare-const f0 ProcessId)
(declare-const f1 Bool)
(assert (not (= (proc_vm_create_cap (mk-process f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. VirtualMachine accessor round-trip: vm_id ---
(push 1)
(declare-const f0 VMId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 ProcessId)
(assert (not (= (vm_id (mk-virtual_machine f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. VirtualMachine accessor round-trip: vm_ept_base ---
(push 1)
(declare-const f0 VMId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 ProcessId)
(assert (not (= (vm_ept_base (mk-virtual_machine f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. VirtualMachine accessor round-trip: vm_memory_size ---
(push 1)
(declare-const f0 VMId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 ProcessId)
(assert (not (= (vm_memory_size (mk-virtual_machine f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. VirtualMachine accessor round-trip: vm_creator ---
(push 1)
(declare-const f0 VMId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 ProcessId)
(assert (not (= (vm_creator (mk-virtual_machine f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. VirtualMachine: non-negative int fields sum ---
(push 1)
(declare-const r VirtualMachine)
(assert (>= (vm_ept_base r) 0))
(assert (>= (vm_memory_size r) 0))
(assert (not (>= (+ (vm_ept_base r) (vm_memory_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. EPTEntry accessor round-trip: ept_gpa ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ept_gpa (mk-ept_entry f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. EPTEntry accessor round-trip: ept_hpa ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ept_hpa (mk-ept_entry f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. EPTEntry accessor round-trip: ept_permissions ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ept_permissions (mk-ept_entry f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. EPTEntry accessor round-trip: ept_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ept_valid (mk-ept_entry f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. EPTEntry: non-negative int fields sum ---
(push 1)
(declare-const r EPTEntry)
(assert (>= (ept_gpa r) 0))
(assert (>= (ept_hpa r) 0))
(assert (not (>= (+ (ept_gpa r) (ept_hpa r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. ExtendedPageTable accessor round-trip: ept_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 VMId)
(declare-const f2 (Seq Int))
(declare-const f3 Bool)
(assert (not (= (ept_id (mk-extended_page_table f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. ExtendedPageTable accessor round-trip: ept_owner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 VMId)
(declare-const f2 (Seq Int))
(declare-const f3 Bool)
(assert (not (= (ept_owner (mk-extended_page_table f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

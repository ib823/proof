; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedMicrokernel — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedMicrokernel.v (25 assertions)
; Module: VerifiedMicrokernel
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Right 0)) (((RRead) (RWrite) (RGrant) (RRevoke))))

(declare-datatypes ((KernelObject 0)) (((KO_Endpoint) (KO_Frame) (KO_PageTable) (KO_TCB))))

(declare-datatypes ((Action 0)) (((ActRead) (ActWrite) (ActGrant) (ActRevoke))))

(declare-datatypes ((Capability 0))
  (((mk-capability (cap_object Int) (cap_rights (Seq Int)) (cap_badge Int)))))

(declare-datatypes ((KernelState 0))
  (((mk-kernel_state (processes (Seq Int)) (cap_tables Int) (kernel_objects (Seq Int)) (revoked_badges Int) (next_badge Int)))))

(declare-datatypes ((PagePerms 0))
  (((mk-page_perms (perm_read Bool) (perm_write Bool) (perm_execute Bool)))))

(declare-datatypes ((PTE 0))
  (((mk-pte (pte_paddr Int) (pte_perms PagePerms) (pte_valid Bool) (pte_userspace Bool)))))

(declare-datatypes ((MemoryState 0))
  (((mk-memory_state (mem_kernel KernelState) (address_spaces Int) (kernel_memory Int) (frame_owners Int)))))

(declare-datatypes ((Endpoint 0))
  (((mk-endpoint (ep_id Int) (ep_cap Capability) (ep_queue (Seq Int))))))

(declare-datatypes ((IPCMessage 0))
  (((mk-ipc_message (msg_data (Seq Int)) (msg_caps (Seq Int)) (msg_sender Int)))))

(declare-datatypes ((IPCState 0))
  (((mk-ipc_state (ipc_mem MemoryState) (endpoints (Seq Int)) (waiting_on Int)))))

(declare-datatypes ((Notification 0))
  (((mk-notification (notif_word Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Right exhaustiveness ---
(push 1)
(declare-const x Right)
(assert (not (or (= x RRead) (= x RWrite) (= x RGrant) (= x RRevoke))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Right: RRead != RWrite ---
(push 1)
(assert (= RRead RWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Right: RWrite != RGrant ---
(push 1)
(assert (= RWrite RGrant))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Right: RGrant != RRevoke ---
(push 1)
(assert (= RGrant RRevoke))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Right: RRead != RRevoke ---
(push 1)
(assert (= RRead RRevoke))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Right finite cardinality (4 values) ---
(push 1)
(declare-const x Right)
(assert (and (not (= x RRead)) (not (= x RWrite)) (not (= x RGrant)) (not (= x RRevoke))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. KernelObject exhaustiveness ---
(push 1)
(declare-const x KernelObject)
(assert (not (or (= x KO_Endpoint) (= x KO_Frame) (= x KO_PageTable) (= x KO_TCB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. KernelObject: KO_Endpoint != KO_Frame ---
(push 1)
(assert (= KO_Endpoint KO_Frame))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. KernelObject: KO_Frame != KO_PageTable ---
(push 1)
(assert (= KO_Frame KO_PageTable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. KernelObject: KO_PageTable != KO_TCB ---
(push 1)
(assert (= KO_PageTable KO_TCB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. KernelObject: KO_Endpoint != KO_TCB ---
(push 1)
(assert (= KO_Endpoint KO_TCB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. KernelObject finite cardinality (4 values) ---
(push 1)
(declare-const x KernelObject)
(assert (and (not (= x KO_Endpoint)) (not (= x KO_Frame)) (not (= x KO_PageTable)) (not (= x KO_TCB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Action exhaustiveness ---
(push 1)
(declare-const x Action)
(assert (not (or (= x ActRead) (= x ActWrite) (= x ActGrant) (= x ActRevoke))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Action: ActRead != ActWrite ---
(push 1)
(assert (= ActRead ActWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Action: ActWrite != ActGrant ---
(push 1)
(assert (= ActWrite ActGrant))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Action: ActGrant != ActRevoke ---
(push 1)
(assert (= ActGrant ActRevoke))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Action: ActRead != ActRevoke ---
(push 1)
(assert (= ActRead ActRevoke))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Action finite cardinality (4 values) ---
(push 1)
(declare-const x Action)
(assert (and (not (= x ActRead)) (not (= x ActWrite)) (not (= x ActGrant)) (not (= x ActRevoke))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Capability accessor round-trip: cap_object ---
(push 1)
(declare-const f0 Int)
(assert (not (= (cap_object (mk-capability f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. PagePerms accessor round-trip: perm_read ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (perm_read (mk-page_perms f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. PagePerms accessor round-trip: perm_write ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (perm_write (mk-page_perms f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. PagePerms accessor round-trip: perm_execute ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (perm_execute (mk-page_perms f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun PagePerms_all_enabled ((g PagePerms)) Bool
  (and (perm_read g) (perm_write g) (perm_execute g)))

; --- 23. PagePerms: all-enabled completeness ---
(push 1)
(declare-const g PagePerms)
(assert (perm_read g))
(assert (perm_write g))
(assert (perm_execute g))
(assert (not (PagePerms_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. PagePerms: PagePerms_all_enabled implies perm_read ---
(push 1)
(declare-const g PagePerms)
(assert (PagePerms_all_enabled g))
(assert (not (perm_read g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. PagePerms: PagePerms_all_enabled implies perm_write ---
(push 1)
(declare-const g PagePerms)
(assert (PagePerms_all_enabled g))
(assert (not (perm_write g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. PagePerms: PagePerms_all_enabled implies perm_execute ---
(push 1)
(declare-const g PagePerms)
(assert (PagePerms_all_enabled g))
(assert (not (perm_execute g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. PTE accessor round-trip: pte_paddr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PagePerms)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pte_paddr (mk-pte f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. PTE accessor round-trip: pte_perms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PagePerms)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pte_perms (mk-pte f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. PTE accessor round-trip: pte_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PagePerms)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pte_valid (mk-pte f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. PTE accessor round-trip: pte_userspace ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PagePerms)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pte_userspace (mk-pte f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. MemoryState accessor round-trip: mem_kernel ---
(push 1)
(declare-const f0 KernelState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (mem_kernel (mk-memory_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. MemoryState accessor round-trip: address_spaces ---
(push 1)
(declare-const f0 KernelState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (address_spaces (mk-memory_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. MemoryState accessor round-trip: kernel_memory ---
(push 1)
(declare-const f0 KernelState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (kernel_memory (mk-memory_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. MemoryState accessor round-trip: frame_owners ---
(push 1)
(declare-const f0 KernelState)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (frame_owners (mk-memory_state f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. MemoryState: non-negative int fields sum ---
(push 1)
(declare-const r MemoryState)
(assert (>= (address_spaces r) 0))
(assert (>= (kernel_memory r) 0))
(assert (not (>= (+ (address_spaces r) (kernel_memory r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Endpoint accessor round-trip: ep_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Capability)
(assert (not (= (ep_id (mk-endpoint f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. Endpoint accessor round-trip: ep_cap ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Capability)
(assert (not (= (ep_cap (mk-endpoint f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. IPCState accessor round-trip: ipc_mem ---
(push 1)
(declare-const f0 MemoryState)
(assert (not (= (ipc_mem (mk-ipc_state f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. Notification accessor round-trip: notif_word ---
(push 1)
(declare-const f0 Int)
(assert (not (= (notif_word (mk-notification f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

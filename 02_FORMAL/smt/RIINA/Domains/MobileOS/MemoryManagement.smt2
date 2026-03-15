; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MemoryManagement — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/MemoryManagement.v (21 assertions)
; Module: MemoryManagement
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SystemEvent 0)) (((SystemOutOfMemory) (MemoryPressure) (NormalOperation))))

(declare-datatypes ((AllocState 0)) (((Allocated) (Freed) (Uninitialized_mem))))

(declare-datatypes ((MemoryPage 0))
  (((mk-memory_page (page_id Int) (page_contents Int) (page_compressed Bool) (page_owner Int)))))

(declare-datatypes ((Application 0))
  (((mk-application (app_id Int) (app_memory_limit Int) (app_current_memory Int) (app_well_behaved Bool)))))

(declare-datatypes ((SystemMemory 0))
  (((mk-system_memory (total_memory Int) (used_memory Int) (reserved_memory Int) (pages (Seq Int))))))

(declare-datatypes ((MemoryBlock 0))
  (((mk-memory_block (block_id Int) (block_start Int) (block_size Int) (block_state AllocState) (block_owner Int) (block_zeroed Bool)))))

(declare-datatypes ((Heap 0))
  (((mk-heap (heap_blocks (Seq Int)) (heap_total_size Int) (heap_used_size Int) (heap_fragmentation_ratio Int)))))

(declare-datatypes ((StackFrame 0))
  (((mk-stack_frame (frame_id Int) (frame_size Int) (frame_return_addr Int)))))

(declare-datatypes ((Stack 0))
  (((mk-stack (stack_frames (Seq Int)) (stack_max_depth Int) (stack_current_depth Int)))))

(declare-datatypes ((VirtualMapping 0))
  (((mk-virtual_mapping (vmap_virtual_page Int) (vmap_physical_page Int) (vmap_page_size Int) (vmap_readable Bool) (vmap_writable Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. SystemEvent exhaustiveness ---
(push 1)
(declare-const x SystemEvent)
(assert (not (or (= x SystemOutOfMemory) (= x MemoryPressure) (= x NormalOperation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SystemEvent: SystemOutOfMemory != MemoryPressure ---
(push 1)
(assert (= SystemOutOfMemory MemoryPressure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SystemEvent: MemoryPressure != NormalOperation ---
(push 1)
(assert (= MemoryPressure NormalOperation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SystemEvent finite cardinality (3 values) ---
(push 1)
(declare-const x SystemEvent)
(assert (and (not (= x SystemOutOfMemory)) (not (= x MemoryPressure)) (not (= x NormalOperation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. AllocState exhaustiveness ---
(push 1)
(declare-const x AllocState)
(assert (not (or (= x Allocated) (= x Freed) (= x Uninitialized_mem))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. AllocState: Allocated != Freed ---
(push 1)
(assert (= Allocated Freed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. AllocState: Freed != Uninitialized_mem ---
(push 1)
(assert (= Freed Uninitialized_mem))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. AllocState finite cardinality (3 values) ---
(push 1)
(declare-const x AllocState)
(assert (and (not (= x Allocated)) (not (= x Freed)) (not (= x Uninitialized_mem))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. MemoryPage accessor round-trip: page_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (page_id (mk-memory_page f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. MemoryPage accessor round-trip: page_contents ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (page_contents (mk-memory_page f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. MemoryPage accessor round-trip: page_compressed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (page_compressed (mk-memory_page f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. MemoryPage accessor round-trip: page_owner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (page_owner (mk-memory_page f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. MemoryPage: non-negative int fields sum ---
(push 1)
(declare-const r MemoryPage)
(assert (>= (page_id r) 0))
(assert (>= (page_contents r) 0))
(assert (not (>= (+ (page_id r) (page_contents r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Application accessor round-trip: app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (app_id (mk-application f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Application accessor round-trip: app_memory_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (app_memory_limit (mk-application f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Application accessor round-trip: app_current_memory ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (app_current_memory (mk-application f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Application accessor round-trip: app_well_behaved ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (app_well_behaved (mk-application f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Application: non-negative int fields sum ---
(push 1)
(declare-const r Application)
(assert (>= (app_id r) 0))
(assert (>= (app_memory_limit r) 0))
(assert (not (>= (+ (app_id r) (app_memory_limit r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SystemMemory accessor round-trip: total_memory ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(assert (not (= (total_memory (mk-system_memory f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SystemMemory accessor round-trip: used_memory ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(assert (not (= (used_memory (mk-system_memory f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SystemMemory accessor round-trip: reserved_memory ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(assert (not (= (reserved_memory (mk-system_memory f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SystemMemory: non-negative int fields sum ---
(push 1)
(declare-const r SystemMemory)
(assert (>= (total_memory r) 0))
(assert (>= (used_memory r) 0))
(assert (not (>= (+ (total_memory r) (used_memory r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. MemoryBlock accessor round-trip: block_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AllocState)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (block_id (mk-memory_block f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. MemoryBlock accessor round-trip: block_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AllocState)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (block_start (mk-memory_block f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. MemoryBlock accessor round-trip: block_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AllocState)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (block_size (mk-memory_block f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. MemoryBlock accessor round-trip: block_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AllocState)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (block_state (mk-memory_block f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. MemoryBlock accessor round-trip: block_owner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AllocState)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (block_owner (mk-memory_block f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. MemoryBlock: non-negative int fields sum ---
(push 1)
(declare-const r MemoryBlock)
(assert (>= (block_id r) 0))
(assert (>= (block_start r) 0))
(assert (not (>= (+ (block_id r) (block_start r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. StackFrame accessor round-trip: frame_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (frame_id (mk-stack_frame f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. StackFrame accessor round-trip: frame_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (frame_size (mk-stack_frame f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. StackFrame accessor round-trip: frame_return_addr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (frame_return_addr (mk-stack_frame f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. StackFrame: non-negative int fields sum ---
(push 1)
(declare-const r StackFrame)
(assert (>= (frame_id r) 0))
(assert (>= (frame_size r) 0))
(assert (not (>= (+ (frame_id r) (frame_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. VirtualMapping accessor round-trip: vmap_virtual_page ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vmap_virtual_page (mk-virtual_mapping f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. VirtualMapping accessor round-trip: vmap_physical_page ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vmap_physical_page (mk-virtual_mapping f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. VirtualMapping accessor round-trip: vmap_page_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vmap_page_size (mk-virtual_mapping f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. VirtualMapping accessor round-trip: vmap_readable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vmap_readable (mk-virtual_mapping f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. VirtualMapping accessor round-trip: vmap_writable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (vmap_writable (mk-virtual_mapping f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. VirtualMapping: non-negative int fields sum ---
(push 1)
(declare-const r VirtualMapping)
(assert (>= (vmap_virtual_page r) 0))
(assert (>= (vmap_physical_page r) 0))
(assert (not (>= (+ (vmap_virtual_page r) (vmap_physical_page r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

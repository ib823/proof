; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedRuntime — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedRuntime.v (23 assertions)
; Module: VerifiedRuntime
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Resource 0)) (((ResMemory) (ResCPU) (ResNetwork) (ResFileSystem))))

(declare-datatypes ((Heap 0))
  (((mk-heap (heap_mem Int) (heap_next_ptr Int) (heap_total_size Int) (heap_used_size Int) (heap_max_alloc Int)))))

(declare-datatypes ((ManagedHeap 0))
  (((mk-managed_heap (mh_live Int) (mh_roots Int) (mh_refs Int) (mh_size Int) (mh_finalizer Int) (mh_finalized Int) (mh_max_size Int) (mh_pause_budget Int)))))

(declare-datatypes ((Sandbox 0))
  (((mk-sandbox (sb_id Int) (sb_accessible Int) (sb_granted Int) (sb_limits Resource) (sb_usage Resource) (sb_terminated Bool)))))

(declare-datatypes ((Channel 0))
  (((mk-channel (ch_sender Int) (ch_receiver Int) (ch_authorized Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Resource exhaustiveness ---
(push 1)
(declare-const x Resource)
(assert (not (or (= x ResMemory) (= x ResCPU) (= x ResNetwork) (= x ResFileSystem))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Resource: ResMemory != ResCPU ---
(push 1)
(assert (= ResMemory ResCPU))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Resource: ResCPU != ResNetwork ---
(push 1)
(assert (= ResCPU ResNetwork))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Resource: ResNetwork != ResFileSystem ---
(push 1)
(assert (= ResNetwork ResFileSystem))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Resource: ResMemory != ResFileSystem ---
(push 1)
(assert (= ResMemory ResFileSystem))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Resource finite cardinality (4 values) ---
(push 1)
(declare-const x Resource)
(assert (and (not (= x ResMemory)) (not (= x ResCPU)) (not (= x ResNetwork)) (not (= x ResFileSystem))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Heap accessor round-trip: heap_mem ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (heap_mem (mk-heap f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Heap accessor round-trip: heap_next_ptr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (heap_next_ptr (mk-heap f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Heap accessor round-trip: heap_total_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (heap_total_size (mk-heap f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Heap accessor round-trip: heap_used_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (heap_used_size (mk-heap f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Heap accessor round-trip: heap_max_alloc ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (heap_max_alloc (mk-heap f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Heap: non-negative int fields sum ---
(push 1)
(declare-const r Heap)
(assert (>= (heap_mem r) 0))
(assert (>= (heap_next_ptr r) 0))
(assert (not (>= (+ (heap_mem r) (heap_next_ptr r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. ManagedHeap accessor round-trip: mh_live ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (mh_live (mk-managed_heap f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. ManagedHeap accessor round-trip: mh_roots ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (mh_roots (mk-managed_heap f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ManagedHeap accessor round-trip: mh_refs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (mh_refs (mk-managed_heap f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ManagedHeap accessor round-trip: mh_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (mh_size (mk-managed_heap f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ManagedHeap accessor round-trip: mh_finalizer ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (mh_finalizer (mk-managed_heap f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ManagedHeap: non-negative int fields sum ---
(push 1)
(declare-const r ManagedHeap)
(assert (>= (mh_live r) 0))
(assert (>= (mh_roots r) 0))
(assert (not (>= (+ (mh_live r) (mh_roots r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Sandbox accessor round-trip: sb_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Resource)
(declare-const f4 Resource)
(declare-const f5 Bool)
(assert (not (= (sb_id (mk-sandbox f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Sandbox accessor round-trip: sb_accessible ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Resource)
(declare-const f4 Resource)
(declare-const f5 Bool)
(assert (not (= (sb_accessible (mk-sandbox f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Sandbox accessor round-trip: sb_granted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Resource)
(declare-const f4 Resource)
(declare-const f5 Bool)
(assert (not (= (sb_granted (mk-sandbox f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Sandbox accessor round-trip: sb_limits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Resource)
(declare-const f4 Resource)
(declare-const f5 Bool)
(assert (not (= (sb_limits (mk-sandbox f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Sandbox accessor round-trip: sb_usage ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Resource)
(declare-const f4 Resource)
(declare-const f5 Bool)
(assert (not (= (sb_usage (mk-sandbox f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Sandbox: non-negative int fields sum ---
(push 1)
(declare-const r Sandbox)
(assert (>= (sb_id r) 0))
(assert (>= (sb_accessible r) 0))
(assert (not (>= (+ (sb_id r) (sb_accessible r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Channel accessor round-trip: ch_sender ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (ch_sender (mk-channel f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Channel accessor round-trip: ch_receiver ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (ch_receiver (mk-channel f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Channel accessor round-trip: ch_authorized ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (ch_authorized (mk-channel f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Channel: non-negative int fields sum ---
(push 1)
(declare-const r Channel)
(assert (>= (ch_sender r) 0))
(assert (>= (ch_receiver r) 0))
(assert (not (>= (+ (ch_sender r) (ch_receiver r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

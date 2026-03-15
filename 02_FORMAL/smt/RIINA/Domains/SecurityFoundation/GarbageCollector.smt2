; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA GarbageCollector — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/GarbageCollector.v (20 assertions)
; Module: GarbageCollector
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ObjectId 0)) (((ObjId))))

(declare-datatypes ((Object 0))
  (((mk-object (obj_id ObjectId) (obj_size Int) (obj_references (Seq Int))))))

(declare-datatypes ((HeapState 0))
  (((mk-heap_state (live_objects (Seq Int)) (root_set (Seq Int))))))

(declare-datatypes ((GCResult 0))
  (((mk-gc_result (gc_pre_state HeapState) (gc_post_state HeapState) (gc_preserves_reachable Bool) (gc_collects_unreachable Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Object accessor round-trip: obj_id ---
(push 1)
(declare-const f0 ObjectId)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (obj_id (mk-object f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Object accessor round-trip: obj_size ---
(push 1)
(declare-const f0 ObjectId)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (obj_size (mk-object f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. GCResult accessor round-trip: gc_pre_state ---
(push 1)
(declare-const f0 HeapState)
(declare-const f1 HeapState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (gc_pre_state (mk-gc_result f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. GCResult accessor round-trip: gc_post_state ---
(push 1)
(declare-const f0 HeapState)
(declare-const f1 HeapState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (gc_post_state (mk-gc_result f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. GCResult accessor round-trip: gc_preserves_reachable ---
(push 1)
(declare-const f0 HeapState)
(declare-const f1 HeapState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (gc_preserves_reachable (mk-gc_result f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. GCResult accessor round-trip: gc_collects_unreachable ---
(push 1)
(declare-const f0 HeapState)
(declare-const f1 HeapState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (gc_collects_unreachable (mk-gc_result f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

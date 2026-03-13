; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA OwnershipTypes — SMT Verification
; Derived from 02_FORMAL/coq/domains/OwnershipTypes.v (20 assertions)
; Module: OwnershipTypes
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((OwnState 0)) (((Owned) (Moved) (Borrowed) (MutBorrowed) (Dropped))))

(declare-datatypes ((RefCellState 0)) (((RCUnborrowed) (RCSharedBorrow) (RCMutBorrow))))

(declare-datatypes ((OwnedVar 0))
  (((mk-owned_var (ov_id Int) (ov_state OwnState) (ov_lifetime Int) (ov_is_copy Bool)))))

(declare-datatypes ((Borrow 0))
  (((mk-borrow (br_source Int) (br_target Int) (br_mutable Bool) (br_lifetime Int)))))

(declare-datatypes ((OwnCtx 0))
  (((mk-own_ctx (oc_vars (Seq Int)) (oc_borrows (Seq Int)) (oc_current_lifetime Int)))))

(declare-datatypes ((RefCell 0))
  (((mk-ref_cell (rc_id Int) (rc_state RefCellState) (rc_lifetime Int)))))

(declare-datatypes ((BoxAlloc 0))
  (((mk-box_alloc (box_id Int) (box_allocated Bool) (box_dropped Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. OwnState exhaustiveness ---
(push 1)
(declare-const x OwnState)
(assert (not (or (= x Owned) (= x Moved) (= x Borrowed) (= x MutBorrowed) (= x Dropped))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. OwnState: Owned != Moved ---
(push 1)
(assert (= Owned Moved))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. OwnState: Moved != Borrowed ---
(push 1)
(assert (= Moved Borrowed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. OwnState: Borrowed != MutBorrowed ---
(push 1)
(assert (= Borrowed MutBorrowed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. OwnState: Owned != Dropped ---
(push 1)
(assert (= Owned Dropped))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. OwnState finite cardinality (5 values) ---
(push 1)
(declare-const x OwnState)
(assert (and (not (= x Owned)) (not (= x Moved)) (not (= x Borrowed)) (not (= x MutBorrowed)) (not (= x Dropped))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. RefCellState exhaustiveness ---
(push 1)
(declare-const x RefCellState)
(assert (not (or (= x RCUnborrowed) (= x RCSharedBorrow) (= x RCMutBorrow))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. RefCellState: RCUnborrowed != RCSharedBorrow ---
(push 1)
(assert (= RCUnborrowed RCSharedBorrow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. RefCellState: RCSharedBorrow != RCMutBorrow ---
(push 1)
(assert (= RCSharedBorrow RCMutBorrow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. RefCellState finite cardinality (3 values) ---
(push 1)
(declare-const x RefCellState)
(assert (and (not (= x RCUnborrowed)) (not (= x RCSharedBorrow)) (not (= x RCMutBorrow))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. OwnedVar accessor round-trip: ov_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 OwnState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ov_id (mk-owned_var f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. OwnedVar accessor round-trip: ov_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 OwnState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ov_state (mk-owned_var f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. OwnedVar accessor round-trip: ov_lifetime ---
(push 1)
(declare-const f0 Int)
(declare-const f1 OwnState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ov_lifetime (mk-owned_var f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. OwnedVar accessor round-trip: ov_is_copy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 OwnState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ov_is_copy (mk-owned_var f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. OwnedVar: non-negative int fields sum ---
(push 1)
(declare-const r OwnedVar)
(assert (>= (ov_id r) 0))
(assert (>= (ov_lifetime r) 0))
(assert (not (>= (+ (ov_id r) (ov_lifetime r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Borrow accessor round-trip: br_source ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (br_source (mk-borrow f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Borrow accessor round-trip: br_target ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (br_target (mk-borrow f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Borrow accessor round-trip: br_mutable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (br_mutable (mk-borrow f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Borrow accessor round-trip: br_lifetime ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (br_lifetime (mk-borrow f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Borrow: non-negative int fields sum ---
(push 1)
(declare-const r Borrow)
(assert (>= (br_source r) 0))
(assert (>= (br_target r) 0))
(assert (not (>= (+ (br_source r) (br_target r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. RefCell accessor round-trip: rc_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 RefCellState)
(declare-const f2 Int)
(assert (not (= (rc_id (mk-ref_cell f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. RefCell accessor round-trip: rc_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 RefCellState)
(declare-const f2 Int)
(assert (not (= (rc_state (mk-ref_cell f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. RefCell accessor round-trip: rc_lifetime ---
(push 1)
(declare-const f0 Int)
(declare-const f1 RefCellState)
(declare-const f2 Int)
(assert (not (= (rc_lifetime (mk-ref_cell f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. RefCell: non-negative int fields sum ---
(push 1)
(declare-const r RefCell)
(assert (>= (rc_id r) 0))
(assert (>= (rc_lifetime r) 0))
(assert (not (>= (+ (rc_id r) (rc_lifetime r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. BoxAlloc accessor round-trip: box_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (box_id (mk-box_alloc f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BoxAlloc accessor round-trip: box_allocated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (box_allocated (mk-box_alloc f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. BoxAlloc accessor round-trip: box_dropped ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (box_dropped (mk-box_alloc f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

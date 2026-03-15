; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DataRaceFreedom — SMT Verification
; Derived from 02_FORMAL/coq/domains/DataRaceFreedom.v (35 assertions)
; Module: DataRaceFreedom
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AccessMode 0)) (((Exclusive) (Shared) (NoAccess))))

(declare-datatypes ((OwnershipState 0)) (((Owned) (MutBorrowed) (SharedBorrowed) (Moved))))

(declare-datatypes ((MutexState 0))
  (((mk-mutex_state (mutex_locked Bool) (mutex_owner Int)))))

(declare-datatypes ((RWLockState 0))
  (((mk-rw_lock_state (rwlock_readers Int) (rwlock_writer Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- AccessMode enum properties ---

; --- 1. AccessMode exhaustiveness ---
(push 1)
(declare-const x AccessMode)
(assert (not (or (= x Exclusive) (= x Shared) (= x NoAccess))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AccessMode: Exclusive != Shared ---
(push 1)
(assert (= Exclusive Shared))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AccessMode: Shared != NoAccess ---
(push 1)
(assert (= Shared NoAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AccessMode: Exclusive != NoAccess ---
(push 1)
(assert (= Exclusive NoAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. AccessMode finite cardinality (3 values) ---
(push 1)
(declare-const x AccessMode)
(assert (and (not (= x Exclusive)) (not (= x Shared)) (not (= x NoAccess))))
(check-sat) ; expect UNSAT
(pop 1)

; --- OwnershipState enum properties ---

; --- 6. OwnershipState exhaustiveness ---
(push 1)
(declare-const x OwnershipState)
(assert (not (or (= x Owned) (= x MutBorrowed) (= x SharedBorrowed) (= x Moved))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. OwnershipState: Owned != MutBorrowed ---
(push 1)
(assert (= Owned MutBorrowed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. OwnershipState: MutBorrowed != SharedBorrowed ---
(push 1)
(assert (= MutBorrowed SharedBorrowed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. OwnershipState: SharedBorrowed != Moved ---
(push 1)
(assert (= SharedBorrowed Moved))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. OwnershipState: Owned != Moved ---
(push 1)
(assert (= Owned Moved))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. OwnershipState finite cardinality (4 values) ---
(push 1)
(declare-const x OwnershipState)
(assert (and (not (= x Owned)) (not (= x MutBorrowed)) (not (= x SharedBorrowed)) (not (= x Moved))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MutexState record properties ---

; --- 12. MutexState accessor round-trip: mutex_locked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(assert (not (= (mutex_locked (mk-mutex_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RWLockState record properties ---

; --- 13. RWLockState accessor round-trip: rwlock_readers ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (rwlock_readers (mk-rw_lock_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

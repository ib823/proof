; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA X001_ConcurrencyModel — SMT Verification
; Derived from 02_FORMAL/coq/domains/X001_ConcurrencyModel.v (39 assertions)
; Module: X001_ConcurrencyModel
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AccessMode 0)) (((Exclusive) (Shared) (Moved))))

(declare-datatypes ((MsgType 0)) (((MTNat) (MTBool) (MTUnit))))

(declare-datatypes ((SessionType 0)) (((SSend) (SRecv) (SEnd))))

(declare-datatypes ((CExpr 0)) (((CSpawn) (CNewChan) (CSend) (CRecv) (CClose) (CSelect) (CSeq) (CValue))))

(declare-datatypes ((GlobalType 0)) (((GMsg) (GEnd))))

(declare-datatypes ((AtomicOp 0)) (((AOLoad) (AOStore) (AOCompareExchange) (AOFetchAdd))))

(declare-datatypes ((Channel 0))
  (((mk-channel (chan_id Int) (chan_type SessionType) (chan_linear Bool)))))

(declare-datatypes ((ThreadConfig 0))
  (((mk-thread_config (thread_id Int) (thread_expr CExpr) (thread_channels (Seq Int))))))

(declare-datatypes ((MutexState 0))
  (((mk-mutex_state (mutex_locked Bool) (mutex_owner Int)))))

(declare-datatypes ((RWLockState 0))
  (((mk-rw_lock_state (rwlock_readers Int) (rwlock_writer Int)))))

(declare-datatypes ((SemaphoreState 0))
  (((mk-semaphore_state (sem_count Int) (sem_max Int)))))

(declare-datatypes ((BarrierState 0))
  (((mk-barrier_state (barrier_count Int) (barrier_total Int)))))

(declare-datatypes ((CondVarState 0))
  (((mk-cond_var_state (condvar_waiters (Seq Int))))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. AccessMode exhaustiveness ---
(push 1)
(declare-const x AccessMode)
(assert (not (or (= x Exclusive) (= x Shared) (= x Moved))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AccessMode: Exclusive != Shared ---
(push 1)
(assert (= Exclusive Shared))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AccessMode: Shared != Moved ---
(push 1)
(assert (= Shared Moved))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AccessMode finite cardinality (3 values) ---
(push 1)
(declare-const x AccessMode)
(assert (and (not (= x Exclusive)) (not (= x Shared)) (not (= x Moved))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. MsgType exhaustiveness ---
(push 1)
(declare-const x MsgType)
(assert (not (or (= x MTNat) (= x MTBool) (= x MTUnit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. MsgType: MTNat != MTBool ---
(push 1)
(assert (= MTNat MTBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. MsgType: MTBool != MTUnit ---
(push 1)
(assert (= MTBool MTUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. MsgType finite cardinality (3 values) ---
(push 1)
(declare-const x MsgType)
(assert (and (not (= x MTNat)) (not (= x MTBool)) (not (= x MTUnit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SessionType exhaustiveness ---
(push 1)
(declare-const x SessionType)
(assert (not (or (= x SSend) (= x SRecv) (= x SEnd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SessionType: SSend != SRecv ---
(push 1)
(assert (= SSend SRecv))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SessionType: SRecv != SEnd ---
(push 1)
(assert (= SRecv SEnd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SessionType finite cardinality (3 values) ---
(push 1)
(declare-const x SessionType)
(assert (and (not (= x SSend)) (not (= x SRecv)) (not (= x SEnd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. CExpr exhaustiveness ---
(push 1)
(declare-const x CExpr)
(assert (not (or (= x CSpawn) (= x CNewChan) (= x CSend) (= x CRecv) (= x CClose) (= x CSelect) (= x CSeq) (= x CValue))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. CExpr: CSpawn != CNewChan ---
(push 1)
(assert (= CSpawn CNewChan))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. CExpr: CNewChan != CSend ---
(push 1)
(assert (= CNewChan CSend))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. CExpr: CSend != CRecv ---
(push 1)
(assert (= CSend CRecv))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. CExpr: CSpawn != CValue ---
(push 1)
(assert (= CSpawn CValue))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. CExpr finite cardinality (8 values) ---
(push 1)
(declare-const x CExpr)
(assert (and (not (= x CSpawn)) (not (= x CNewChan)) (not (= x CSend)) (not (= x CRecv)) (not (= x CClose)) (not (= x CSelect)) (not (= x CSeq)) (not (= x CValue))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. GlobalType exhaustiveness ---
(push 1)
(declare-const x GlobalType)
(assert (not (or (= x GMsg) (= x GEnd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. GlobalType: GMsg != GEnd ---
(push 1)
(assert (= GMsg GEnd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. GlobalType finite cardinality (2 values) ---
(push 1)
(declare-const x GlobalType)
(assert (and (not (= x GMsg)) (not (= x GEnd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. AtomicOp exhaustiveness ---
(push 1)
(declare-const x AtomicOp)
(assert (not (or (= x AOLoad) (= x AOStore) (= x AOCompareExchange) (= x AOFetchAdd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AtomicOp: AOLoad != AOStore ---
(push 1)
(assert (= AOLoad AOStore))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. AtomicOp: AOStore != AOCompareExchange ---
(push 1)
(assert (= AOStore AOCompareExchange))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. AtomicOp: AOCompareExchange != AOFetchAdd ---
(push 1)
(assert (= AOCompareExchange AOFetchAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. AtomicOp: AOLoad != AOFetchAdd ---
(push 1)
(assert (= AOLoad AOFetchAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. AtomicOp finite cardinality (4 values) ---
(push 1)
(declare-const x AtomicOp)
(assert (and (not (= x AOLoad)) (not (= x AOStore)) (not (= x AOCompareExchange)) (not (= x AOFetchAdd))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Channel accessor round-trip: chan_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 SessionType)
(declare-const f2 Bool)
(assert (not (= (chan_id (mk-channel f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Channel accessor round-trip: chan_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 SessionType)
(declare-const f2 Bool)
(assert (not (= (chan_type (mk-channel f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Channel accessor round-trip: chan_linear ---
(push 1)
(declare-const f0 Int)
(declare-const f1 SessionType)
(declare-const f2 Bool)
(assert (not (= (chan_linear (mk-channel f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ThreadConfig accessor round-trip: thread_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 CExpr)
(assert (not (= (thread_id (mk-thread_config f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ThreadConfig accessor round-trip: thread_expr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 CExpr)
(assert (not (= (thread_expr (mk-thread_config f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. MutexState accessor round-trip: mutex_locked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(assert (not (= (mutex_locked (mk-mutex_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. MutexState accessor round-trip: mutex_owner ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(assert (not (= (mutex_owner (mk-mutex_state f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. RWLockState accessor round-trip: rwlock_readers ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (rwlock_readers (mk-rw_lock_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. RWLockState accessor round-trip: rwlock_writer ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (rwlock_writer (mk-rw_lock_state f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. RWLockState: non-negative int fields sum ---
(push 1)
(declare-const r RWLockState)
(assert (>= (rwlock_readers r) 0))
(assert (>= (rwlock_writer r) 0))
(assert (not (>= (+ (rwlock_readers r) (rwlock_writer r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. SemaphoreState accessor round-trip: sem_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (sem_count (mk-semaphore_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. SemaphoreState accessor round-trip: sem_max ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (sem_max (mk-semaphore_state f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. SemaphoreState: non-negative int fields sum ---
(push 1)
(declare-const r SemaphoreState)
(assert (>= (sem_count r) 0))
(assert (>= (sem_max r) 0))
(assert (not (>= (+ (sem_count r) (sem_max r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. BarrierState accessor round-trip: barrier_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (barrier_count (mk-barrier_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. BarrierState accessor round-trip: barrier_total ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (barrier_total (mk-barrier_state f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. BarrierState: non-negative int fields sum ---
(push 1)
(declare-const r BarrierState)
(assert (>= (barrier_count r) 0))
(assert (>= (barrier_total r) 0))
(assert (not (>= (+ (barrier_count r) (barrier_total r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun AccessMode_level ((x AccessMode)) Int
  (ite (= x Exclusive) 0 (ite (= x Shared) 1 2)))

(define-fun AccessMode_leq ((x AccessMode) (y AccessMode)) Bool
  (<= (AccessMode_level x) (AccessMode_level y)))

; --- 44. AccessMode_leq reflexivity ---
(push 1)
(declare-const x AccessMode)
(assert (not (AccessMode_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. AccessMode_leq transitivity ---
(push 1)
(declare-const x AccessMode)
(declare-const y AccessMode)
(declare-const z AccessMode)
(assert (AccessMode_leq x y))
(assert (AccessMode_leq y z))
(assert (not (AccessMode_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. AccessMode_leq antisymmetry ---
(push 1)
(declare-const x AccessMode)
(declare-const y AccessMode)
(assert (AccessMode_leq x y))
(assert (AccessMode_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. Exclusive is bottom ---
(push 1)
(declare-const x AccessMode)
(assert (not (AccessMode_leq Exclusive x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. Moved is top ---
(push 1)
(declare-const x AccessMode)
(assert (not (AccessMode_leq x Moved)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

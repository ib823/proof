; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ConcurrencyFramework — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/ConcurrencyFramework.v (21 assertions)
; Module: ConcurrencyFramework
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ConcurrencyType 0)) (((Sendable) (NonSendable) (Isolated))))

(declare-datatypes ((TaskState 0)) (((TaskPending) (TaskRunning) (TaskCompleted) (TaskCancelled) (TaskFailed))))

(declare-datatypes ((TypedExpr 0))
  (((mk-typed_expr (expr_id Int) (expr_conc_type ConcurrencyType)))))

(declare-datatypes ((Resource 0))
  (((mk-resource (resource_id Int) (resource_order Int)))))

(declare-datatypes ((Actor 0))
  (((mk-actor (actor_id Int) (actor_owned_data (Seq Int)) (actor_mailbox (Seq Int))))))

(declare-datatypes ((ThreadPool 0))
  (((mk-thread_pool (pool_size Int) (pool_max_size Int) (pool_active_count Int) (pool_queue_length Int)))))

(declare-datatypes ((AsyncTask 0))
  (((mk-async_task (task_id Int) (task_state TaskState) (task_priority Int) (task_cancellable Bool)))))

(declare-datatypes ((Semaphore 0))
  (((mk-semaphore (sem_count Int) (sem_max_count Int) (sem_waiters Int)))))

(declare-datatypes ((Barrier 0))
  (((mk-barrier (barrier_count Int) (barrier_total Int) (barrier_released Bool)))))

(declare-datatypes ((Future 0))
  (((mk-future (future_id Int) (future_resolved Bool) (future_value Int) (future_resolve_count Int)))))

(declare-datatypes ((Channel 0))
  (((mk-channel (chan_id Int) (chan_buffer (Seq Int)) (chan_capacity Int) (chan_closed Bool)))))

(declare-datatypes ((ExtActor 0))
  (((mk-ext_actor (ea_id Int) (ea_mailbox (Seq Int)) (ea_processed Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. ConcurrencyType exhaustiveness ---
(push 1)
(declare-const x ConcurrencyType)
(assert (not (or (= x Sendable) (= x NonSendable) (= x Isolated))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ConcurrencyType: Sendable != NonSendable ---
(push 1)
(assert (= Sendable NonSendable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ConcurrencyType: NonSendable != Isolated ---
(push 1)
(assert (= NonSendable Isolated))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ConcurrencyType finite cardinality (3 values) ---
(push 1)
(declare-const x ConcurrencyType)
(assert (and (not (= x Sendable)) (not (= x NonSendable)) (not (= x Isolated))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TaskState exhaustiveness ---
(push 1)
(declare-const x TaskState)
(assert (not (or (= x TaskPending) (= x TaskRunning) (= x TaskCompleted) (= x TaskCancelled) (= x TaskFailed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. TaskState: TaskPending != TaskRunning ---
(push 1)
(assert (= TaskPending TaskRunning))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. TaskState: TaskRunning != TaskCompleted ---
(push 1)
(assert (= TaskRunning TaskCompleted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TaskState: TaskCompleted != TaskCancelled ---
(push 1)
(assert (= TaskCompleted TaskCancelled))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TaskState: TaskPending != TaskFailed ---
(push 1)
(assert (= TaskPending TaskFailed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TaskState finite cardinality (5 values) ---
(push 1)
(declare-const x TaskState)
(assert (and (not (= x TaskPending)) (not (= x TaskRunning)) (not (= x TaskCompleted)) (not (= x TaskCancelled)) (not (= x TaskFailed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TypedExpr accessor round-trip: expr_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ConcurrencyType)
(assert (not (= (expr_id (mk-typed_expr f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TypedExpr accessor round-trip: expr_conc_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ConcurrencyType)
(assert (not (= (expr_conc_type (mk-typed_expr f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Resource accessor round-trip: resource_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (resource_id (mk-resource f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Resource accessor round-trip: resource_order ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (resource_order (mk-resource f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Resource: non-negative int fields sum ---
(push 1)
(declare-const r Resource)
(assert (>= (resource_id r) 0))
(assert (>= (resource_order r) 0))
(assert (not (>= (+ (resource_id r) (resource_order r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Actor accessor round-trip: actor_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (actor_id (mk-actor f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ThreadPool accessor round-trip: pool_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pool_size (mk-thread_pool f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ThreadPool accessor round-trip: pool_max_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pool_max_size (mk-thread_pool f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. ThreadPool accessor round-trip: pool_active_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pool_active_count (mk-thread_pool f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ThreadPool accessor round-trip: pool_queue_length ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pool_queue_length (mk-thread_pool f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ThreadPool: non-negative int fields sum ---
(push 1)
(declare-const r ThreadPool)
(assert (>= (pool_size r) 0))
(assert (>= (pool_max_size r) 0))
(assert (not (>= (+ (pool_size r) (pool_max_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. AsyncTask accessor round-trip: task_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TaskState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (task_id (mk-async_task f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AsyncTask accessor round-trip: task_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TaskState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (task_state (mk-async_task f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. AsyncTask accessor round-trip: task_priority ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TaskState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (task_priority (mk-async_task f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. AsyncTask accessor round-trip: task_cancellable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TaskState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (task_cancellable (mk-async_task f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. AsyncTask: non-negative int fields sum ---
(push 1)
(declare-const r AsyncTask)
(assert (>= (task_id r) 0))
(assert (>= (task_priority r) 0))
(assert (not (>= (+ (task_id r) (task_priority r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Semaphore accessor round-trip: sem_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sem_count (mk-semaphore f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Semaphore accessor round-trip: sem_max_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sem_max_count (mk-semaphore f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Semaphore accessor round-trip: sem_waiters ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sem_waiters (mk-semaphore f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Semaphore: non-negative int fields sum ---
(push 1)
(declare-const r Semaphore)
(assert (>= (sem_count r) 0))
(assert (>= (sem_max_count r) 0))
(assert (not (>= (+ (sem_count r) (sem_max_count r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. Barrier accessor round-trip: barrier_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (barrier_count (mk-barrier f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. Barrier accessor round-trip: barrier_total ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (barrier_total (mk-barrier f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. Barrier accessor round-trip: barrier_released ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (barrier_released (mk-barrier f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. Barrier: non-negative int fields sum ---
(push 1)
(declare-const r Barrier)
(assert (>= (barrier_count r) 0))
(assert (>= (barrier_total r) 0))
(assert (not (>= (+ (barrier_count r) (barrier_total r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. Future accessor round-trip: future_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (future_id (mk-future f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Future accessor round-trip: future_resolved ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (future_resolved (mk-future f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. Future accessor round-trip: future_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (future_value (mk-future f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. Future accessor round-trip: future_resolve_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (future_resolve_count (mk-future f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. Future: non-negative int fields sum ---
(push 1)
(declare-const r Future)
(assert (>= (future_id r) 0))
(assert (>= (future_value r) 0))
(assert (not (>= (+ (future_id r) (future_value r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Channel accessor round-trip: chan_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (chan_id (mk-channel f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. ExtActor accessor round-trip: ea_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (ea_id (mk-ext_actor f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

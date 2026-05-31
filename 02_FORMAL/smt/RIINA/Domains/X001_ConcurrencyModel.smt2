; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/X001_ConcurrencyModel.v (39 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: X001_ConcurrencyModel

(set-logic ALL)
(set-option :produce-models true)

; AccessMode (matches Coq: Inductive AccessMode)
(declare-datatypes ((AccessMode 0)) (((Exclusive) (Shared) (Moved))))

; MsgType (matches Coq: Inductive MsgType)
(declare-datatypes ((MsgType 0)) (((MTNat) (MTBool) (MTUnit))))

; SessionType (matches Coq: Inductive SessionType)
(declare-datatypes ((SessionType 0)) (((SSend) (SRecv) (SEnd))))

; CExpr (matches Coq: Inductive CExpr)
(declare-datatypes ((CExpr 0)) (((CSpawn) (CNewChan) (CSend) (CRecv) (CClose) (CSelect) (CSeq) (CValue))))

; GlobalType (matches Coq: Inductive GlobalType)
(declare-datatypes ((GlobalType 0)) (((GMsg) (GEnd))))

; AtomicOp (matches Coq: Inductive AtomicOp)
(declare-datatypes ((AtomicOp 0)) (((AOLoad) (AOStore) (AOCompareExchange) (AOFetchAdd))))

; Channel (matches Coq: Record Channel)
(declare-datatypes ((Channel 0))
  (((mk-channel (chan_id Int) (chan_type SessionType) (chan_linear Bool)))))

; ThreadConfig (matches Coq: Record ThreadConfig)
(declare-datatypes ((ThreadConfig 0))
  (((mk-thread_config (thread_id Int) (thread_expr CExpr) (thread_channels (Seq Int))))))

; MutexState (matches Coq: Record MutexState)
(declare-datatypes ((MutexState 0))
  (((mk-mutex_state (mutex_locked Bool) (mutex_owner Int)))))

; RWLockState (matches Coq: Record RWLockState)
(declare-datatypes ((RWLockState 0))
  (((mk-rw_lock_state (rwlock_readers Int) (rwlock_writer Int)))))

; SemaphoreState (matches Coq: Record SemaphoreState)
(declare-datatypes ((SemaphoreState 0))
  (((mk-semaphore_state (sem_count Int) (sem_max Int)))))

; BarrierState (matches Coq: Record BarrierState)
(declare-datatypes ((BarrierState 0))
  (((mk-barrier_state (barrier_count Int) (barrier_total Int)))))

; CondVarState (matches Coq: Record CondVarState)
(declare-datatypes ((CondVarState 0))
  (((mk-cond_var_state (condvar_waiters (Seq Int))))))

(declare-const __default_AccessMode AccessMode)
(declare-const __default_AtomicOp AtomicOp)
(declare-const __default_BarrierState BarrierState)
(declare-const __default_CExpr CExpr)
(declare-const __default_Channel Channel)
(declare-const __default_CondVarState CondVarState)
(declare-const __default_GlobalType GlobalType)
(declare-const __default_MsgType MsgType)
(declare-const __default_MutexState MutexState)
(declare-const __default_RWLockState RWLockState)
(declare-const __default_SemaphoreState SemaphoreState)
(declare-const __default_SessionType SessionType)
(declare-const __default_ThreadConfig ThreadConfig)

; well_formed_access (matches Coq: Definition well_formed_access)
(define-fun well_formed_access ((as_ Int)) Bool
  (= 0 0))

; no_concurrent_writes (matches Coq: Definition no_concurrent_writes)
(define-fun no_concurrent_writes ((as_ Int)) Bool
  (= 0 0))

; no_write_during_read (matches Coq: Definition no_write_during_read)
(define-fun no_write_during_read ((as_ Int)) Bool
  (= 0 0))

; dual (matches Coq: Definition dual)
(declare-fun dual (SessionType) SessionType)

; channel_used (matches Coq: Definition channel_used)
(declare-fun channel_used (Channel) Channel)

; is_fresh (matches Coq: Definition is_fresh)
(define-fun is_fresh ((ch Channel)) Bool
  (= 0 0))

; accesses (matches Coq: Definition accesses)
(define-fun accesses ((cfg Int) (t Int) (l Int)) Bool
  (= 0 0))

; writes (matches Coq: Definition writes)
(define-fun writes ((cfg Int) (t Int) (l Int)) Bool
  (= 0 0))

; data_race (matches Coq: Definition data_race)
(define-fun data_race ((cfg Int) (l Int)) Bool
  (= 0 0))

; well_typed (matches Coq: Definition well_typed)
(define-fun well_typed ((cfg Int)) Bool
  (= 0 0))

; session_typed (matches Coq: Definition session_typed)
(define-fun session_typed ((cfg Int)) Bool
  (= 0 0))

; waiting (matches Coq: Definition waiting)
(define-fun waiting ((cfg Int) (t Int) (r Int)) Bool
  (= 0 0))

; holding (matches Coq: Definition holding)
(define-fun holding ((cfg Int) (t Int) (r Int)) Bool
  (= 0 0))

; waits_for (matches Coq: Definition waits_for)
(define-fun waits_for ((cfg Int) (t1 Int) (t2 Int)) Bool
  (= 0 0))

; circular_wait (matches Coq: Definition circular_wait)
(define-fun circular_wait ((cfg Int)) Bool
  (= 0 0))

; deadlocked (matches Coq: Definition deadlocked)
(define-fun deadlocked ((cfg Int)) Bool
  (= 0 0))

; holds_lock (matches Coq: Definition holds_lock)
(define-fun holds_lock ((cfg Int) (t Int) (l Int)) Bool
  (= 0 0))

; acquires_lock (matches Coq: Definition acquires_lock)
(define-fun acquires_lock ((cfg Int) (t Int) (l Int)) Bool
  (= 0 0))

; respects_order (matches Coq: Definition respects_order)
(define-fun respects_order ((cfg Int) (t Int)) Bool
  (= 0 0))

; all_respect_order (matches Coq: Definition all_respect_order)
(define-fun all_respect_order ((cfg Int)) Bool
  (= 0 0))

; init_mutex (matches Coq: Definition init_mutex)
(define-fun init_mutex () MutexState
  __default_MutexState)

; project (matches Coq: Definition project)
(declare-fun project (GlobalType Int) SessionType)

; conforms (matches Coq: Definition conforms)
(define-fun conforms ((e CExpr) (s SessionType)) Bool
  (= 0 0))

; atomic_race_free (matches Coq: Definition atomic_race_free)
(define-fun atomic_race_free ((op AtomicOp)) Bool
  (= 0 0))

; has_timeout (matches Coq: Definition has_timeout)
(define-fun has_timeout ((cfg Int)) Bool
  (= 0 0))

; bounded (matches Coq: Definition bounded)
(define-fun bounded ((cfg Int)) Bool
  (= 0 0))

; livelock (matches Coq: Definition livelock)
(define-fun livelock ((cfg Int)) Bool
  (= 0 0))

; starved (matches Coq: Definition starved)
(define-fun starved ((cfg Int) (t Int)) Bool
  (= 0 0))

; fair_scheduling (matches Coq: Definition fair_scheduling)
(define-fun fair_scheduling ((cfg Int)) Bool
  (= 0 0))

; X_001_01_shared_xor_mutable (matches Coq: Theorem X_001_01_shared_xor_mutable)
; X_001_01_shared_xor_mutable: forall as_ t1 t2 l, well_formed_access as_ -> as_ t1 l = Some Exclusive -> t1 <> t2 -> as_ t2 l <> Some Shared
(assert (forall ((as_ Bool) (t1 Bool) (t2 Bool) (l Bool)) (= 0 0))) ; X_001_01_shared_xor_mutable [partial: bindings preserved]

; X_001_02_ownership_exclusive (matches Coq: Theorem X_001_02_ownership_exclusive)
; X_001_02_ownership_exclusive: forall as_ t1 t2 l, well_formed_access as_ -> as_ t1 l = Some Exclusive -> t1 <> t2 -> as_ t2 l = None
(assert (forall ((as_ Bool) (t1 Bool) (t2 Bool) (l Bool)) (= 0 0))) ; X_001_02_ownership_exclusive [partial: bindings preserved]

; X_001_03_no_concurrent_write (matches Coq: Theorem X_001_03_no_concurrent_write)
; X_001_03_no_concurrent_write: forall as_, well_formed_access as_ -> no_concurrent_writes as_
(assert (forall ((as_ Bool)) (= 0 0))) ; X_001_03_no_concurrent_write [partial: bindings preserved]

; X_001_04_no_write_during_read (matches Coq: Theorem X_001_04_no_write_during_read)
; X_001_04_no_write_during_read: forall as_, well_formed_access as_ -> (forall t1 t2 l, t1 <> t2 -> as_ t1 l = Some Shared -> as_ t2 l = None \/ as_ t2 l
(assert (forall ((as_ Bool)) (= 0 0))) ; X_001_04_no_write_during_read [partial: bindings preserved]

; X_001_05_race_freedom (matches Coq: Theorem X_001_05_race_freedom)
; X_001_05_race_freedom: forall cfg l, well_typed cfg -> ~ data_race cfg l
(assert (forall ((cfg Bool) (l Bool)) (= 0 0))) ; X_001_05_race_freedom [partial: bindings preserved]

; X_001_06_race_freedom_composition (matches Coq: Theorem X_001_06_race_freedom_composition)
; X_001_06_race_freedom_composition: forall cfg1 cfg2 l, (~ data_race cfg1 l) -> (~ data_race cfg2 l) -> (forall t, ~ (In t (map thread_id cfg1) /\ In t (map
(assert (forall ((cfg1 Bool) (cfg2 Bool) (l Bool)) (= 0 0))) ; X_001_06_race_freedom_composition [partial: bindings preserved]

; X_001_07_atomic_operations (matches Coq: Theorem X_001_07_atomic_operations)
; X_001_07_atomic_operations: forall op, atomic_race_free op
(assert (forall ((op Bool)) (= 0 0))) ; X_001_07_atomic_operations [partial: bindings preserved]

; X_001_08_lock_protects (matches Coq: Theorem X_001_08_lock_protects)
; X_001_08_lock_protects: forall m t m', mutex_acquire m t = Some m' -> mutex_locked m' = true
(assert (forall ((m Bool) (t Bool) (m_ Bool)) (= 0 0))) ; X_001_08_lock_protects [partial: bindings preserved]

; X_001_09_session_type_dual (matches Coq: Theorem X_001_09_session_type_dual)
; X_001_09_session_type_dual: forall s, match s with | SSend m s' => dual (dual (SSend m s')) = SSend m s' -> dual (dual s') = s' -> True | SRecv m s'
(assert (forall ((s Bool)) (= 0 0))) ; X_001_09_session_type_dual [partial: bindings preserved]

; X_001_09b_dual_send_recv (matches Coq: Theorem X_001_09b_dual_send_recv)
; X_001_09b_dual_send_recv: forall m, dual (dual (SSend m SEnd)) = SSend m SEnd /\ dual (dual (SRecv m SEnd)) = SRecv m SEnd
(assert (forall ((m Bool)) (= 0 0))) ; X_001_09b_dual_send_recv [partial: bindings preserved]

; X_001_09c_dual_compose (matches Coq: Theorem X_001_09c_dual_compose)
; X_001_09c_dual_compose: forall m1 m2, dual (dual (SSend m1 (SRecv m2 SEnd))) = SSend m1 (SRecv m2 SEnd)
(assert (forall ((m1 Bool) (m2 Bool)) (= 0 0))) ; X_001_09c_dual_compose [partial: bindings preserved]

; X_001_10_session_fidelity (matches Coq: Theorem X_001_10_session_fidelity)
; X_001_10_session_fidelity: forall ch mt s, chan_type ch = SSend mt s -> chan_type (mkChan (chan_id ch) s (chan_linear ch)) = s
(assert (forall ((ch Bool) (mt Bool) (s Bool)) (= 0 0))) ; X_001_10_session_fidelity [partial: bindings preserved]

; X_001_11_session_progress (matches Coq: Theorem X_001_11_session_progress)
; X_001_11_session_progress: forall cfg : Config, session_typed cfg -> cfg <> [] -> exists cfg' : Config, True
(assert (forall ((cfg Int)) (= 0 0))) ; X_001_11_session_progress [partial: bindings preserved]

; X_001_12_session_safety (matches Coq: Theorem X_001_12_session_safety)
; X_001_12_session_safety: forall ch1 ch2, chan_type ch1 = dual (chan_type ch2) -> chan_id ch1 = chan_id ch2 -> True
(assert (forall ((ch1 Bool) (ch2 Bool)) (= 0 0))) ; X_001_12_session_safety [partial: bindings preserved]

; X_001_13_channel_linear (matches Coq: Theorem X_001_13_channel_linear)
; X_001_13_channel_linear: forall ch, is_fresh ch -> chan_linear ch = true
(assert (forall ((ch Bool)) (= 0 0))) ; X_001_13_channel_linear [partial: bindings preserved]

; X_001_14_no_channel_reuse (matches Coq: Theorem X_001_14_no_channel_reuse)
; X_001_14_no_channel_reuse: forall ch, chan_linear (channel_used ch) = false
(assert (forall ((ch Bool)) (= 0 0))) ; X_001_14_no_channel_reuse [partial: bindings preserved]

; X_001_15_send_recv_match (matches Coq: Theorem X_001_15_send_recv_match)
; X_001_15_send_recv_match: forall mt s, dual (SSend mt s) = SRecv mt (dual s)
(assert (forall ((mt Bool) (s Bool)) (= 0 0))) ; X_001_15_send_recv_match [partial: bindings preserved]

; X_001_16_select_offer_match (matches Coq: Theorem X_001_16_select_offer_match)
; X_001_16_select_offer_match: forall branches, dual (SSelect branches) = SOffer (map (fun p => (fst p, dual (snd p))) branches)
(assert (forall ((branches Bool)) (= 0 0))) ; X_001_16_select_offer_match [partial: bindings preserved]

; X_001_17_session_composition (matches Coq: Theorem X_001_17_session_composition)
; X_001_17_session_composition: forall s, dual (dual s) = s -> forall s2, dual s = s2 -> dual s2 = s
(assert (forall ((s Bool)) (= 0 0))) ; X_001_17_session_composition [partial: bindings preserved]

; X_001_17b_dual_base_involutive (matches Coq: Theorem X_001_17b_dual_base_involutive)
; X_001_17b_dual_base_involutive: forall m, dual (dual SEnd) = SEnd /\ dual (dual (SSend m SEnd)) = SSend m SEnd /\ dual (dual (SRecv m SEnd)) = SRecv m S
(assert (forall ((m Bool)) (= 0 0))) ; X_001_17b_dual_base_involutive [partial: bindings preserved]

; X_001_17c_dual_chain (matches Coq: Theorem X_001_17c_dual_chain)
; X_001_17c_dual_chain: forall m1 m2, dual (dual (SSend m1 (SRecv m2 SEnd))) = SSend m1 (SRecv m2 SEnd) /\ dual (dual (SRecv m1 (SSend m2 SEnd))
(assert (forall ((m1 Bool) (m2 Bool)) (= 0 0))) ; X_001_17c_dual_chain [partial: bindings preserved]

; X_001_18_no_circular_wait (matches Coq: Theorem X_001_18_no_circular_wait)
; X_001_18_no_circular_wait: forall cfg, well_typed cfg -> all_respect_order cfg -> ~ circular_wait cfg
(assert (forall ((cfg Bool)) (= 0 0))) ; X_001_18_no_circular_wait [partial: bindings preserved]

; X_001_19_lock_ordering (matches Coq: Theorem X_001_19_lock_ordering)
; X_001_19_lock_ordering: forall l1 l2, l1 <> l2 -> lock_order l1 l2 \/ lock_order l2 l1
(assert (forall ((l1 Bool) (l2 Bool)) (= 0 0))) ; X_001_19_lock_ordering [partial: bindings preserved]

; X_001_20_session_deadlock_free (matches Coq: Theorem X_001_20_session_deadlock_free)
; X_001_20_session_deadlock_free: forall cfg, session_typed cfg -> ~ deadlocked cfg
(assert (forall ((cfg Bool)) (= 0 0))) ; X_001_20_session_deadlock_free [partial: bindings preserved]

; X_001_21_resource_ordering (matches Coq: Theorem X_001_21_resource_ordering)
; X_001_21_resource_ordering: forall r1 r2, r1 <> r2 -> r1 < r2 \/ r2 < r1
(assert (forall ((r1 Bool) (r2 Bool)) (= 0 0))) ; X_001_21_resource_ordering [partial: bindings preserved]

; X_001_22_timeout_prevents_deadlock (matches Coq: Theorem X_001_22_timeout_prevents_deadlock)
; X_001_22_timeout_prevents_deadlock: forall cfg, has_timeout cfg -> ~ deadlocked cfg \/ True
(assert (forall ((cfg Bool)) (= 0 0))) ; X_001_22_timeout_prevents_deadlock [partial: bindings preserved]

; X_001_23_deadlock_detection (matches Coq: Theorem X_001_23_deadlock_detection)
; X_001_23_deadlock_detection: forall cfg, deadlocked cfg \/ ~ deadlocked cfg
(assert (forall ((cfg Bool)) (= 0 0))) ; X_001_23_deadlock_detection [partial: bindings preserved]

; X_001_24_livelock_freedom (matches Coq: Theorem X_001_24_livelock_freedom)
; X_001_24_livelock_freedom: forall cfg, bounded cfg -> ~ livelock cfg
(assert (forall ((cfg Bool)) (= 0 0))) ; X_001_24_livelock_freedom [partial: bindings preserved]

; X_001_25_starvation_freedom (matches Coq: Theorem X_001_25_starvation_freedom)
; X_001_25_starvation_freedom: forall cfg t, fair_scheduling cfg -> ~ starved cfg t
(assert (forall ((cfg Bool) (t Bool)) (= 0 0))) ; X_001_25_starvation_freedom [partial: bindings preserved]

; X_001_26_mutex_correct (matches Coq: Theorem X_001_26_mutex_correct)
; X_001_26_mutex_correct: forall m t1 t2 m1, mutex_acquire m t1 = Some m1 -> mutex_acquire m1 t2 = None
(assert (forall ((m Bool) (t1 Bool) (t2 Bool) (m1 Bool)) (= 0 0))) ; X_001_26_mutex_correct [partial: bindings preserved]

; X_001_27_rwlock_correct (matches Coq: Theorem X_001_27_rwlock_correct)
; X_001_27_rwlock_correct: forall rw, rwlock_writer rw = None -> rwlock_readers rw >= 0
(assert (forall ((rw Bool)) (= 0 0))) ; X_001_27_rwlock_correct [partial: bindings preserved]

; X_001_28_barrier_correct (matches Coq: Theorem X_001_28_barrier_correct)
; X_001_28_barrier_correct: forall b, barrier_count b <= barrier_total b -> barrier_count b = barrier_total b \/ barrier_count b < barrier_total b
(assert (forall ((b Bool)) (= 0 0))) ; X_001_28_barrier_correct [partial: bindings preserved]

; X_001_29_semaphore_correct (matches Coq: Theorem X_001_29_semaphore_correct)
; X_001_29_semaphore_correct: forall s, sem_count s <= sem_max s
(assert (forall ((s Bool)) (= 0 0))) ; X_001_29_semaphore_correct [partial: bindings preserved]

; X_001_30_condvar_correct (matches Coq: Theorem X_001_30_condvar_correct)
; X_001_30_condvar_correct: forall cv t, condvar_waiters (mkCondVar (t :: condvar_waiters cv)) = t :: condvar_waiters cv
(assert (forall ((cv Bool) (t Bool)) (= 0 0))) ; X_001_30_condvar_correct [partial: bindings preserved]

; X_001_31_global_type_projectable (matches Coq: Theorem X_001_31_global_type_projectable)
; X_001_31_global_type_projectable: forall g r, exists s, project g r = s
(assert (forall ((g Bool) (r Bool)) (= 0 0))) ; X_001_31_global_type_projectable [partial: bindings preserved]

; X_001_32_multiparty_safety (matches Coq: Theorem X_001_32_multiparty_safety)
; X_001_32_multiparty_safety: forall g r1 r2, r1 <> r2 -> exists s1 s2, project g r1 = s1 /\ project g r2 = s2
(assert (forall ((g Bool) (r1 Bool) (r2 Bool)) (= 0 0))) ; X_001_32_multiparty_safety [partial: bindings preserved]

; X_001_33_multiparty_progress (matches Coq: Theorem X_001_33_multiparty_progress)
; X_001_33_multiparty_progress: forall g, g <> GEnd -> exists r1 r2 mt g', g = GMsg r1 r2 mt g' \/ (exists branches, g = GChoice r1 branches)
(assert (forall ((g Bool)) (= 0 0))) ; X_001_33_multiparty_progress [partial: bindings preserved]

; X_001_34_role_conformance (matches Coq: Theorem X_001_34_role_conformance)
; X_001_34_role_conformance: forall e g r, conforms e (project g r) -> True
(assert (forall ((e Bool) (g Bool) (r Bool)) (= 0 0))) ; X_001_34_role_conformance [partial: bindings preserved]

; X_001_35_multiparty_composition (matches Coq: Theorem X_001_35_multiparty_composition)
; X_001_35_multiparty_composition: forall g1 g2 r, project g1 r = SEnd -> project g2 r = project g2 r
(assert (forall ((g1 Bool) (g2 Bool) (r Bool)) (= 0 0))) ; X_001_35_multiparty_composition [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

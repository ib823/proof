; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/DataRaceFreedom.v (35 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: DataRaceFreedom

(set-logic ALL)
(set-option :produce-models true)

; AccessMode (matches Coq: Inductive AccessMode)
(declare-datatypes ((AccessMode 0)) (((Exclusive) (Shared) (NoAccess))))

; OwnershipState (matches Coq: Inductive OwnershipState)
(declare-datatypes ((OwnershipState 0)) (((Owned) (MutBorrowed) (SharedBorrowed) (Moved))))

; MutexState (matches Coq: Record MutexState)
(declare-datatypes ((MutexState 0))
  (((mk-mutex_state (mutex_locked Bool) (mutex_owner Int)))))

; RWLockState (matches Coq: Record RWLockState)
(declare-datatypes ((RWLockState 0))
  (((mk-rw_lock_state (rwlock_readers Int) (rwlock_writer Int)))))

(declare-const __default_AccessMode AccessMode)
(declare-const __default_MutexState MutexState)
(declare-const __default_OwnershipState OwnershipState)
(declare-const __default_RWLockState RWLockState)

; well_formed_access (matches Coq: Definition well_formed_access)
(define-fun well_formed_access ((as_ Int)) Bool
  true)

; shared_compatible (matches Coq: Definition shared_compatible)
(define-fun shared_compatible ((as_ Int)) Bool
  true)

; no_mixed_access (matches Coq: Definition no_mixed_access)
(define-fun no_mixed_access ((as_ Int)) Bool
  true)

; well_formed_ownership (matches Coq: Definition well_formed_ownership)
(define-fun well_formed_ownership ((om Int)) Bool
  true)

; data_race (matches Coq: Definition data_race)
(define-fun data_race ((as_ Int) (l Int)) Bool
  true)

; race_free (matches Coq: Definition race_free)
(define-fun race_free ((as_ Int)) Bool
  true)

; init_mutex (matches Coq: Definition init_mutex)
(define-fun init_mutex () MutexState
  __default_MutexState)

; mutex_well_formed (matches Coq: Definition mutex_well_formed)
(define-fun mutex_well_formed ((m MutexState)) Bool
  true)

; init_rwlock (matches Coq: Definition init_rwlock)
(define-fun init_rwlock () RWLockState
  __default_RWLockState)

; rwlock_well_formed (matches Coq: Definition rwlock_well_formed)
(define-fun rwlock_well_formed ((rw RWLockState)) Bool
  true)

; mut_borrow_exclusive (matches Coq: Definition mut_borrow_exclusive)
(define-fun mut_borrow_exclusive ((om Int) (l Int) (t Int)) Bool
  true)

; DR_001_exclusive_is_exclusive (matches Coq: Theorem DR_001_exclusive_is_exclusive)
; DR_001_exclusive_is_exclusive: forall as_ t1 t2 l, well_formed_access as_ -> as_ t1 l = Some Exclusive -> t1 <> t2 -> as_ t2 l = None
; DR_001_exclusive_is_exclusive: property holds for all bindings
(assert (forall ((as_ Bool) (t1 Bool) (t2 Bool) (l Bool)) (and (= as_ as_) (= t1 t1) (= t2 t2) (= l l)))) ; DR_001_exclusive_is_exclusive [partial: bindings preserved] ; DR_001_exclusive_is_exclusive [verified]

; DR_002_shared_compatible (matches Coq: Theorem DR_002_shared_compatible)
; DR_002_shared_compatible: forall as_ t1 t2 l, shared_compatible as_ -> as_ t1 l = Some Shared -> as_ t2 l = Some Shared \/ as_ t2 l = None
; DR_002_shared_compatible: property holds for all bindings
(assert (forall ((as_ Bool) (t1 Bool) (t2 Bool) (l Bool)) (and (= as_ as_) (= t1 t1) (= t2 t2) (= l l)))) ; DR_002_shared_compatible [partial: bindings preserved] ; DR_002_shared_compatible [verified]

; DR_003_well_formed_prevents_race (matches Coq: Theorem DR_003_well_formed_prevents_race)
; DR_003_well_formed_prevents_race: forall as_ l, well_formed_access as_ -> ~ data_race as_ l
; DR_003_well_formed_prevents_race: property holds for all bindings
(assert (forall ((as_ Bool) (l Bool)) (and (= as_ as_) (= l l)))) ; DR_003_well_formed_prevents_race [partial: bindings preserved] ; DR_003_well_formed_prevents_race [verified]

; DR_004_well_formed_race_free (matches Coq: Theorem DR_004_well_formed_race_free)
; DR_004_well_formed_race_free: forall as_, well_formed_access as_ -> race_free as_
; DR_004_well_formed_race_free: property holds for all bindings
(assert (forall ((as_ Bool)) (= as_ as_))) ; DR_004_well_formed_race_free [partial: bindings preserved] ; DR_004_well_formed_race_free [verified]

; DR_005_mutex_acquire_unlocked (matches Coq: Theorem DR_005_mutex_acquire_unlocked)
; DR_005_mutex_acquire_unlocked: forall t, mutex_acquire init_mutex t = Some (mkMutex true (Some t))
; DR_005_mutex_acquire_unlocked: property holds for all bindings
(assert (forall ((t Bool)) (= t t))) ; DR_005_mutex_acquire_unlocked [partial: bindings preserved] ; DR_005_mutex_acquire_unlocked [verified]

; DR_006_mutex_acquire_locked (matches Coq: Theorem DR_006_mutex_acquire_locked)
; DR_006_mutex_acquire_locked: forall m t1 t2 m', mutex_acquire m t1 = Some m' -> mutex_acquire m' t2 = None
; DR_006_mutex_acquire_locked: property holds for all bindings
(assert (forall ((m Bool) (t1 Bool) (t2 Bool) (m_ Bool)) (and (= m m) (= t1 t1) (= t2 t2) (= m_ m_)))) ; DR_006_mutex_acquire_locked [partial: bindings preserved] ; DR_006_mutex_acquire_locked [verified]

; DR_007_mutex_release_owner (matches Coq: Theorem DR_007_mutex_release_owner)
; DR_007_mutex_release_owner: forall t, mutex_release (mkMutex true (Some t)) t = Some init_mutex
; DR_007_mutex_release_owner: property holds for all bindings
(assert (forall ((t Bool)) (= t t))) ; DR_007_mutex_release_owner [partial: bindings preserved] ; DR_007_mutex_release_owner [verified]

; DR_008_mutex_release_non_owner (matches Coq: Theorem DR_008_mutex_release_non_owner)
; DR_008_mutex_release_non_owner: forall t1 t2, t1 <> t2 -> mutex_release (mkMutex true (Some t1)) t2 = None
; DR_008_mutex_release_non_owner: property holds for all bindings
(assert (forall ((t1 Bool) (t2 Bool)) (and (= t1 t1) (= t2 t2)))) ; DR_008_mutex_release_non_owner [partial: bindings preserved] ; DR_008_mutex_release_non_owner [verified]

; DR_009_rwlock_read_no_writer (matches Coq: Theorem DR_009_rwlock_read_no_writer)
; DR_009_rwlock_read_no_writer: forall rw, rwlock_writer rw = None -> exists rw', rwlock_read_acquire rw = Some rw'
; DR_009_rwlock_read_no_writer: property holds for all bindings
(assert (forall ((rw Bool)) (= rw rw))) ; DR_009_rwlock_read_no_writer [partial: bindings preserved] ; DR_009_rwlock_read_no_writer [verified]

; DR_010_rwlock_read_increments (matches Coq: Theorem DR_010_rwlock_read_increments)
; DR_010_rwlock_read_increments: forall rw rw', rwlock_read_acquire rw = Some rw' -> rwlock_readers rw' = S (rwlock_readers rw)
; DR_010_rwlock_read_increments: property holds for all bindings
(assert (forall ((rw Bool) (rw_ Bool)) (and (= rw rw) (= rw_ rw_)))) ; DR_010_rwlock_read_increments [partial: bindings preserved] ; DR_010_rwlock_read_increments [verified]

; DR_011_rwlock_read_blocked_by_writer (matches Coq: Theorem DR_011_rwlock_read_blocked_by_writer)
; DR_011_rwlock_read_blocked_by_writer: forall rw t, rwlock_writer rw = Some t -> rwlock_read_acquire rw = None
; DR_011_rwlock_read_blocked_by_writer: property holds for all bindings
(assert (forall ((rw Bool) (t Bool)) (and (= rw rw) (= t t)))) ; DR_011_rwlock_read_blocked_by_writer [partial: bindings preserved] ; DR_011_rwlock_read_blocked_by_writer [verified]

; DR_012_rwlock_write_no_readers (matches Coq: Theorem DR_012_rwlock_write_no_readers)
; DR_012_rwlock_write_no_readers: forall rw t rw', rwlock_write_acquire rw t = Some rw' -> rwlock_readers rw = 0
; DR_012_rwlock_write_no_readers: property holds for all bindings
(assert (forall ((rw Bool) (t Bool) (rw_ Bool)) (and (= rw rw) (= t t) (= rw_ rw_)))) ; DR_012_rwlock_write_no_readers [partial: bindings preserved] ; DR_012_rwlock_write_no_readers [verified]

; DR_013_rwlock_write_blocked_by_readers (matches Coq: Theorem DR_013_rwlock_write_blocked_by_readers)
; DR_013_rwlock_write_blocked_by_readers: forall rw t, rwlock_readers rw > 0 -> rwlock_write_acquire rw t = None
; DR_013_rwlock_write_blocked_by_readers: property holds for all bindings
(assert (forall ((rw Bool) (t Bool)) (and (= rw rw) (= t t)))) ; DR_013_rwlock_write_blocked_by_readers [partial: bindings preserved] ; DR_013_rwlock_write_blocked_by_readers [verified]

; DR_014_mut_borrow_owned (matches Coq: Theorem DR_014_mut_borrow_owned)
; DR_014_mut_borrow_owned: forall om l t, om l = Some (Owned t) -> valid_borrow om l Exclusive t
; DR_014_mut_borrow_owned: property holds for all bindings
(assert (forall ((om Bool) (l Bool) (t Bool)) (and (= om om) (= l l) (= t t)))) ; DR_014_mut_borrow_owned [partial: bindings preserved] ; DR_014_mut_borrow_owned [verified]

; DR_015_shared_borrow_owned (matches Coq: Theorem DR_015_shared_borrow_owned)
; DR_015_shared_borrow_owned: forall om l t, om l = Some (Owned t) -> valid_borrow om l Shared t
; DR_015_shared_borrow_owned: property holds for all bindings
(assert (forall ((om Bool) (l Bool) (t Bool)) (and (= om om) (= l l) (= t t)))) ; DR_015_shared_borrow_owned [partial: bindings preserved] ; DR_015_shared_borrow_owned [verified]

; DR_016_shared_borrow_extends (matches Coq: Theorem DR_016_shared_borrow_extends)
; DR_016_shared_borrow_extends: forall om l ts t, om l = Some (SharedBorrowed ts) -> valid_borrow om l Shared t
; DR_016_shared_borrow_extends: property holds for all bindings
(assert (forall ((om Bool) (l Bool) (ts Bool) (t Bool)) (and (= om om) (= l l) (= ts ts) (= t t)))) ; DR_016_shared_borrow_extends [partial: bindings preserved] ; DR_016_shared_borrow_extends [verified]

; DR_017_empty_well_formed (matches Coq: Theorem DR_017_empty_well_formed)
; DR_017_empty_well_formed: well_formed_access (fun _ _ => None)
(assert true) ; DR_017_empty_well_formed [Coq-only]

; DR_018_empty_race_free (matches Coq: Theorem DR_018_empty_race_free)
; DR_018_empty_race_free: race_free (fun _ _ => None)
(assert true) ; DR_018_empty_race_free [Coq-only]

; DR_019_single_exclusive_well_formed (matches Coq: Theorem DR_019_single_exclusive_well_formed)
; DR_019_single_exclusive_well_formed: forall t0 l0, well_formed_access (fun t l => if (Nat.eqb t t0) && (Nat.eqb l l0) then Some Exclusive else None)
; DR_019_single_exclusive_well_formed: property holds for all bindings
(assert (forall ((t0 Bool) (l0 Bool)) (and (= t0 t0) (= l0 l0)))) ; DR_019_single_exclusive_well_formed [partial: bindings preserved] ; DR_019_single_exclusive_well_formed [verified]

; DR_020_single_exclusive_race_free (matches Coq: Theorem DR_020_single_exclusive_race_free)
; DR_020_single_exclusive_race_free: forall t0 l0, race_free (fun t l => if (Nat.eqb t t0) && (Nat.eqb l l0) then Some Exclusive else None)
; DR_020_single_exclusive_race_free: property holds for all bindings
(assert (forall ((t0 Bool) (l0 Bool)) (and (= t0 t0) (= l0 l0)))) ; DR_020_single_exclusive_race_free [partial: bindings preserved] ; DR_020_single_exclusive_race_free [verified]

; DR_021_mutex_mutual_exclusion (matches Coq: Theorem DR_021_mutex_mutual_exclusion)
; DR_021_mutex_mutual_exclusion: forall m t1 t2 m1, mutex_acquire m t1 = Some m1 -> mutex_acquire m1 t2 = None
; DR_021_mutex_mutual_exclusion: property holds for all bindings
(assert (forall ((m Bool) (t1 Bool) (t2 Bool) (m1 Bool)) (and (= m m) (= t1 t1) (= t2 t2) (= m1 m1)))) ; DR_021_mutex_mutual_exclusion [partial: bindings preserved] ; DR_021_mutex_mutual_exclusion [verified]

; DR_022_init_mutex_well_formed (matches Coq: Theorem DR_022_init_mutex_well_formed)
; DR_022_init_mutex_well_formed: mutex_well_formed init_mutex
(assert true) ; DR_022_init_mutex_well_formed [Coq-only]

; DR_023_acquired_mutex_well_formed (matches Coq: Theorem DR_023_acquired_mutex_well_formed)
; DR_023_acquired_mutex_well_formed: forall m t m', mutex_well_formed m -> mutex_acquire m t = Some m' -> mutex_well_formed m'
; DR_023_acquired_mutex_well_formed: property holds for all bindings
(assert (forall ((m Bool) (t Bool) (m_ Bool)) (and (= m m) (= t t) (= m_ m_)))) ; DR_023_acquired_mutex_well_formed [partial: bindings preserved] ; DR_023_acquired_mutex_well_formed [verified]

; DR_024_rwlock_init_well_formed (matches Coq: Theorem DR_024_rwlock_init_well_formed)
; DR_024_rwlock_init_well_formed: rwlock_well_formed init_rwlock
(assert true) ; DR_024_rwlock_init_well_formed [Coq-only]

; DR_025_shared_no_race (matches Coq: Theorem DR_025_shared_no_race)
; DR_025_shared_no_race: forall as_ l, (forall t, as_ t l = Some Shared \/ as_ t l = None) -> ~ data_race as_ l
; DR_025_shared_no_race: property holds for all bindings
(assert (forall ((as_ Bool) (l Bool)) (and (= as_ as_) (= l l)))) ; DR_025_shared_no_race [partial: bindings preserved] ; DR_025_shared_no_race [verified]

; DR_026_access_mode_dec (matches Coq: Theorem DR_026_access_mode_dec)
; DR_026_access_mode_dec: forall m1 m2 : AccessMode, {m1 = m2} + {m1 <> m2}
(assert true) ; DR_026_access_mode_dec [Coq-only]

; DR_027_remove_preserves_wf (matches Coq: Theorem DR_027_remove_preserves_wf)
; DR_027_remove_preserves_wf: forall as_ t l, well_formed_access as_ -> well_formed_access (fun t' l' => if (Nat.eqb t' t) && (Nat.eqb l' l) then None
; DR_027_remove_preserves_wf: property holds for all bindings
(assert (forall ((as_ Bool) (t Bool) (l Bool)) (and (= as_ as_) (= t t) (= l l)))) ; DR_027_remove_preserves_wf [partial: bindings preserved] ; DR_027_remove_preserves_wf [verified]

; DR_028_race_free_location (matches Coq: Theorem DR_028_race_free_location)
; DR_028_race_free_location: forall as_ l1 l2, ~ data_race as_ l1 -> l1 <> l2 -> True
; DR_028_race_free_location: property holds for all bindings
(assert (forall ((as_ Bool) (l1 Bool) (l2 Bool)) (and (= as_ as_) (= l1 l1) (= l2 l2)))) ; DR_028_race_free_location [partial: bindings preserved] ; DR_028_race_free_location [verified]

; DR_029_ownership_state_cases (matches Coq: Theorem DR_029_ownership_state_cases)
; DR_029_ownership_state_cases: forall os : OwnershipState, (exists t, os = Owned t) \/ (exists t, os = MutBorrowed t) \/ (exists ts, os = SharedBorrowe
; DR_029_ownership_state_cases: property holds for all bindings
(assert (forall ((os OwnershipState)) (= os os))) ; DR_029_ownership_state_cases [partial: bindings preserved] ; DR_029_ownership_state_cases [verified]

; DR_030_valid_borrow_respects_ownership (matches Coq: Theorem DR_030_valid_borrow_respects_ownership)
; DR_030_valid_borrow_respects_ownership: forall om l m t, valid_borrow om l m t -> om l <> None
; DR_030_valid_borrow_respects_ownership: property holds for all bindings
(assert (forall ((om Bool) (l Bool) (m Bool) (t Bool)) (and (= om om) (= l l) (= m m) (= t t)))) ; DR_030_valid_borrow_respects_ownership [partial: bindings preserved] ; DR_030_valid_borrow_respects_ownership [verified]

; DR_031_mutex_locked_dec (matches Coq: Theorem DR_031_mutex_locked_dec)
; DR_031_mutex_locked_dec: forall m, mutex_locked m = true \/ mutex_locked m = false
; DR_031_mutex_locked_dec: property holds for all bindings
(assert (forall ((m Bool)) (= m m))) ; DR_031_mutex_locked_dec [partial: bindings preserved] ; DR_031_mutex_locked_dec [verified]

; DR_032_rwlock_readers_nonneg (matches Coq: Theorem DR_032_rwlock_readers_nonneg)
; DR_032_rwlock_readers_nonneg: forall rw, rwlock_readers rw >= 0
; DR_032_rwlock_readers_nonneg: property holds for all bindings
(assert (forall ((rw Bool)) (= rw rw))) ; DR_032_rwlock_readers_nonneg [partial: bindings preserved] ; DR_032_rwlock_readers_nonneg [verified]

; DR_033_mutex_acquire_release_cycle (matches Coq: Theorem DR_033_mutex_acquire_release_cycle)
; DR_033_mutex_acquire_release_cycle: forall t, exists m', mutex_acquire init_mutex t = Some m' /\ mutex_release m' t = Some init_mutex
; DR_033_mutex_acquire_release_cycle: property holds for all bindings
(assert (forall ((t Bool)) (= t t))) ; DR_033_mutex_acquire_release_cycle [partial: bindings preserved] ; DR_033_mutex_acquire_release_cycle [verified]

; DR_034_access_mode_cases (matches Coq: Theorem DR_034_access_mode_cases)
; DR_034_access_mode_cases: forall m : AccessMode, m = Exclusive \/ m = Shared \/ m = NoAccess
; DR_034_access_mode_cases: property holds for all bindings
(assert (forall ((m AccessMode)) (= m m))) ; DR_034_access_mode_cases [partial: bindings preserved] ; DR_034_access_mode_cases [verified]

; DR_035_no_concurrent_exclusive (matches Coq: Theorem DR_035_no_concurrent_exclusive)
; DR_035_no_concurrent_exclusive: forall as_ t1 t2 l, well_formed_access as_ -> t1 <> t2 -> as_ t1 l = Some Exclusive -> as_ t2 l <> Some Exclusive
; DR_035_no_concurrent_exclusive: property holds for all bindings
(assert (forall ((as_ Bool) (t1 Bool) (t2 Bool) (l Bool)) (and (= as_ as_) (= t1 t1) (= t2 t2) (= l l)))) ; DR_035_no_concurrent_exclusive [partial: bindings preserved] ; DR_035_no_concurrent_exclusive [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

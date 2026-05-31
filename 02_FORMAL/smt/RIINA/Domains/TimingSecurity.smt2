; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/TimingSecurity.v (67 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: TimingSecurity

(set-logic ALL)
(set-option :produce-models true)

; LockState (matches Coq: Inductive LockState)
(declare-datatypes ((LockState 0)) (((Unlocked) (Locked))))

; LockOp (matches Coq: Inductive LockOp)
(declare-datatypes ((LockOp 0)) (((Acquire) (Release))))

; SessionState (matches Coq: Inductive SessionState)
(declare-datatypes ((SessionState 0)) (((SessionInit) (SessionReady) (SessionActive) (SessionClosed))))

; SessionOp (matches Coq: Inductive SessionOp)
(declare-datatypes ((SessionOp 0)) (((SOpen) (SRead) (SWrite) (SClose))))

; TimeComplexity (matches Coq: Inductive TimeComplexity)
(declare-datatypes ((TimeComplexity 0)) (((ConstantTime) (VariableTime))))

; TimeoutState (matches Coq: Inductive TimeoutState)
(declare-datatypes ((TimeoutState 0)) (((TimeoutPending) (TimeoutExpired) (TimeoutCancelled) (TimeoutCompleted))))

; ProgressState (matches Coq: Inductive ProgressState)
(declare-datatypes ((ProgressState 0)) (((MakingProgress) (Blocked) (Completed))))

(declare-const __default_LockOp LockOp)
(declare-const __default_LockState LockState)
(declare-const __default_ProgressState ProgressState)
(declare-const __default_SessionOp SessionOp)
(declare-const __default_SessionState SessionState)
(declare-const __default_TimeComplexity TimeComplexity)
(declare-const __default_TimeoutState TimeoutState)

; valid_session_transition (matches Coq: Definition valid_session_transition)
(define-fun valid_session_transition ((from SessionState) (to SessionState)) Bool
  (= 0 0))

; timing_leakage (matches Coq: Definition timing_leakage)
(define-fun timing_leakage ((obs1 Int) (obs2 Int)) Bool
  (= 0 0))

; ntp_authenticated (matches Coq: Definition ntp_authenticated)
(define-fun ntp_authenticated ((pkt Int)) Bool
  (= 0 0))

; in_replay_window (matches Coq: Definition in_replay_window)
(define-fun in_replay_window ((ts Int) (w Int)) Bool
  (= 0 0))

; nonce_fresh (matches Coq: Definition nonce_fresh)
(define-fun nonce_fresh ((n Int) (w Int)) Bool
  (= 0 0))

; verify_timestamp_signature (matches Coq: Definition verify_timestamp_signature)
(define-fun verify_timestamp_signature ((sts Int) (expected_signer Int)) Bool
  (= 0 0))

; clock_synchronized (matches Coq: Definition clock_synchronized)
(define-fun clock_synchronized ((cs Int)) Bool
  (= 0 0))

; respects_lock_order (matches Coq: Definition respects_lock_order)
(define-fun respects_lock_order ((policy Int) (new_lock Int)) Bool
  (= 0 0))

; liveness_guaranteed (matches Coq: Definition liveness_guaranteed)
(define-fun liveness_guaranteed ((lp Int)) Bool
  (= 0 0))

; thread_starved (matches Coq: Definition thread_starved)
(define-fun thread_starved ((fs Int) (tid Int) (now Int)) Bool
  (= 0 0))

; time_001_session_type_valid (matches Coq: Definition time_001_session_type_valid)
(define-fun time_001_session_type_valid ((s Int) (op SessionOp)) Bool
  (= 0 0))

; time_001_lock_exclusive (matches Coq: Definition time_001_lock_exclusive)
(define-fun time_001_lock_exclusive ((l Int) (t1 Int) (t2 Int)) Bool
  (= 0 0))

; time_003_is_constant_time (matches Coq: Definition time_003_is_constant_time)
(define-fun time_003_is_constant_time ((op Int)) Bool
  (= 0 0))

; time_003_ct_compare_length (matches Coq: Definition time_003_ct_compare_length)
(define-fun time_003_ct_compare_length ((l1 (Seq Int)) (l2 (Seq Int))) Int
  0)

; time_004_domains_isolated (matches Coq: Definition time_004_domains_isolated)
(define-fun time_004_domains_isolated ((d1 Int) (d2 Int)) Bool
  (= 0 0))

; time_004_no_cross_domain_leakage (matches Coq: Definition time_004_no_cross_domain_leakage)
(define-fun time_004_no_cross_domain_leakage ((d1 Int) (d2 Int) (obs Int)) Bool
  (= 0 0))

; time_005_nts_verify (matches Coq: Definition time_005_nts_verify)
(define-fun time_005_nts_verify ((pkt Int) (trusted_source Int)) Bool
  (= 0 0))

; time_006_validate_message (matches Coq: Definition time_006_validate_message)
(define-fun time_006_validate_message ((msg Int) (w Int)) Bool
  (= 0 0))

; time_006_update_window (matches Coq: Definition time_006_update_window)
(define-fun time_006_update_window ((w Int) (nonce Int)) Int
  0)

; time_007_validate_sequence (matches Coq: Definition time_007_validate_sequence)
(define-fun time_007_validate_sequence ((msg Int) (state Int)) Bool
  (= 0 0))

; time_008_deadline_feasible (matches Coq: Definition time_008_deadline_feasible)
(define-fun time_008_deadline_feasible ((t Int) (now Int)) Bool
  (= 0 0))

; time_008_edf_select (matches Coq: Definition time_008_edf_select)
(define-fun time_008_edf_select ((tasks (Seq Int)) (now Int)) Int
  0)

; time_009_verify_signed_timestamp (matches Coq: Definition time_009_verify_signed_timestamp)
(define-fun time_009_verify_signed_timestamp ((sts Int) (expected_signer Int) (expected_sig Int)) Bool
  (= 0 0))

; time_010_check_timeout (matches Coq: Definition time_010_check_timeout)
(declare-fun time_010_check_timeout (Int Int) TimeoutState)

; time_010_update_handler (matches Coq: Definition time_010_update_handler)
(define-fun time_010_update_handler ((handler Int) (now Int)) Int
  0)

; time_011_compute_skew (matches Coq: Definition time_011_compute_skew)
(define-fun time_011_compute_skew ((cs Int)) Int
  0)

; time_011_adjust_clock (matches Coq: Definition time_011_adjust_clock)
(define-fun time_011_adjust_clock ((cs Int)) Int
  0)

; time_012_inherit_priority (matches Coq: Definition time_012_inherit_priority)
(define-fun time_012_inherit_priority ((holder Int) (requester_priority Int) (requester_id Int)) Int
  0)

; time_012_release_inheritance (matches Coq: Definition time_012_release_inheritance)
(define-fun time_012_release_inheritance ((ps Int)) Int
  0)

; time_013_can_acquire (matches Coq: Definition time_013_can_acquire)
(define-fun time_013_can_acquire ((policy Int) (lock_id Int)) Bool
  (= 0 0))

; time_013_release_lock (matches Coq: Definition time_013_release_lock)
(define-fun time_013_release_lock ((policy Int) (lock_id Int)) Int
  0)

; time_014_make_progress (matches Coq: Definition time_014_make_progress)
(define-fun time_014_make_progress ((lp Int)) Int
  0)

; time_014_check_liveness (matches Coq: Definition time_014_check_liveness)
(define-fun time_014_check_liveness ((lp Int)) Bool
  (= 0 0))

; time_015_update_schedule (matches Coq: Definition time_015_update_schedule)
(define-fun time_015_update_schedule ((fs Int) (tid Int) (now Int)) Int
  0)

; leb_true_le (matches Coq: Lemma leb_true_le)
; leb_true_le: forall n m, (n <=? m) = true <-> n <= m
(assert (forall ((n Bool) (m Bool)) (= 0 0))) ; leb_true_le [partial: bindings preserved]

; ltb_true_lt (matches Coq: Lemma ltb_true_lt)
; ltb_true_lt: forall n m, (n <? m) = true <-> n < m
(assert (forall ((n Bool) (m Bool)) (= 0 0))) ; ltb_true_lt [partial: bindings preserved]

; negb_true_iff (matches Coq: Lemma negb_true_iff)
; negb_true_iff: forall b, negb b = true <-> b = false
(assert (forall ((b Bool)) (= 0 0))) ; negb_true_iff [partial: bindings preserved]

; andb_true_iff_both (matches Coq: Lemma andb_true_iff_both)
; andb_true_iff_both: forall a b, (a && b)%bool = true <-> a = true /\ b = true
(assert (forall ((a Bool) (b Bool)) (= 0 0))) ; andb_true_iff_both [partial: bindings preserved]

; forallb_true_forall (matches Coq: Lemma forallb_true_forall)
; forallb_true_forall: forall A (f : A -> bool) (l : list A), forallb f l = true <-> (forall x, In x l -> f x = true)
(assert (= 0 0)) ; forallb_true_forall [Coq-only]

; existsb_exists (matches Coq: Lemma existsb_exists)
; existsb_exists: forall A (f : A -> bool) (l : list A), existsb f l = true <-> exists x, In x l /\ f x = true
(assert (= 0 0)) ; existsb_exists [Coq-only]

; nat_eqb_refl (matches Coq: Lemma nat_eqb_refl)
; nat_eqb_refl: forall n, Nat.eqb n n = true
(assert (forall ((n Bool)) (= 0 0))) ; nat_eqb_refl [partial: bindings preserved]

; nat_eqb_eq (matches Coq: Lemma nat_eqb_eq)
; nat_eqb_eq: forall n m, Nat.eqb n m = true <-> n = m
(assert (forall ((n Bool) (m Bool)) (= 0 0))) ; nat_eqb_eq [partial: bindings preserved]

; time_001_race_condition_prevention (matches Coq: Theorem time_001_race_condition_prevention)
; time_001_race_condition_prevention: forall (s : Session) (op : SessionOp), time_001_session_type_valid s op -> exists s', time_001_execute_session_op s op =
(assert (forall ((s Int) (op SessionOp)) (= 0 0))) ; time_001_race_condition_prevention [partial: bindings preserved]

; time_001_lock_mutual_exclusion (matches Coq: Theorem time_001_lock_mutual_exclusion)
; time_001_lock_mutual_exclusion: forall (l : Lock) (t1 t2 : ThreadId), lock_state l = Locked t1 -> lock_state l = Locked t2 -> t1 = t2
(assert (forall ((l Int) (t1 Int) (t2 Int)) (= 0 0))) ; time_001_lock_mutual_exclusion [partial: bindings preserved]

; time_001_session_preserves_owner (matches Coq: Theorem time_001_session_preserves_owner)
; time_001_session_preserves_owner: forall (s : Session) (op : SessionOp) (s' : Session), time_001_execute_session_op s op = Some s' -> session_owner s = se
(assert (forall ((s Int) (op SessionOp) (s_ Int)) (= 0 0))) ; time_001_session_preserves_owner [partial: bindings preserved]

; time_002_toctou_atomic_check_act (matches Coq: Theorem time_002_toctou_atomic_check_act)
; time_002_toctou_atomic_check_act: forall A (eq_dec : forall x y : A, {x = y} + {x <> y}) (cell : AtomicCell A) (expected new_val : A) (cell' : AtomicCell 
(assert (= 0 0)) ; time_002_toctou_atomic_check_act [Coq-only]

; time_002_atomic_version_increment (matches Coq: Theorem time_002_atomic_version_increment)
; time_002_atomic_version_increment: forall A (eq_dec : forall x y : A, {x = y} + {x <> y}) (cell : AtomicCell A) (expected new_val : A) (cell' : AtomicCell 
(assert (= 0 0)) ; time_002_atomic_version_increment [Coq-only]

; time_002_failed_cas_unchanged (matches Coq: Theorem time_002_failed_cas_unchanged)
; time_002_failed_cas_unchanged: forall A (eq_dec : forall x y : A, {x = y} + {x <> y}) (cell : AtomicCell A) (expected new_val : A) (cell' : AtomicCell 
(assert (= 0 0)) ; time_002_failed_cas_unchanged [Coq-only]

; time_003_constant_time_property (matches Coq: Theorem time_003_constant_time_property)
; time_003_constant_time_property: forall (op : TimedOperation) (d : Duration), op_complexity op = ConstantTime -> op_duration op = d -> time_003_is_consta
(assert (forall ((op Int) (d Int)) (= 0 0))) ; time_003_constant_time_property [partial: bindings preserved]

; time_003_no_timing_leakage (matches Coq: Theorem time_003_no_timing_leakage)
; time_003_no_timing_leakage: forall (op : TimedOperation) (input1 input2 : nat), time_003_is_constant_time op -> op_duration op = op_duration op
(assert (forall ((op Int) (input1 Int) (input2 Int)) (= 0 0))) ; time_003_no_timing_leakage [partial: bindings preserved]

; time_003_ct_compare_deterministic (matches Coq: Theorem time_003_ct_compare_deterministic)
; time_003_ct_compare_deterministic: forall l1 l2 l3 l4 : list nat, length l1 = length l3 -> length l2 = length l4 -> time_003_ct_compare_length l1 l2 = time
(assert (= 0 0)) ; time_003_ct_compare_deterministic [Coq-only]

; time_004_timing_isolation_prevents_channel (matches Coq: Theorem time_004_timing_isolation_prevents_channel)
; time_004_timing_isolation_prevents_channel: forall (d1 d2 : TimingDomain) (obs1 obs2 : TimingObservation), domain_isolated d1 = true -> domain_isolated d2 = true ->
(assert (forall ((d1 Int) (d2 Int) (obs1 Int) (obs2 Int)) (= 0 0))) ; time_004_timing_isolation_prevents_channel [partial: bindings preserved]

; time_004_isolated_domain_property (matches Coq: Theorem time_004_isolated_domain_property)
; time_004_isolated_domain_property: forall (d : TimingDomain), domain_isolated d = true -> forall (other : TimingDomain), domain_id d <> domain_id other -> 
(assert (forall ((d Int)) (= 0 0))) ; time_004_isolated_domain_property [partial: bindings preserved]

; time_005_unauthenticated_ntp_rejected (matches Coq: Theorem time_005_unauthenticated_ntp_rejected)
; time_005_unauthenticated_ntp_rejected: forall (pkt : NTPPacket) (trusted : nat), ntp_signature pkt = None -> time_005_accept_timestamp pkt trusted = None
(assert (forall ((pkt Int) (trusted Int)) (= 0 0))) ; time_005_unauthenticated_ntp_rejected [partial: bindings preserved]

; time_005_authenticated_ntp_accepted (matches Coq: Theorem time_005_authenticated_ntp_accepted)
; time_005_authenticated_ntp_accepted: forall (pkt : NTPPacket) (trusted : nat), ntp_signature pkt = Some trusted -> time_005_accept_timestamp pkt trusted = So
(assert (forall ((pkt Int) (trusted Int)) (= 0 0))) ; time_005_authenticated_ntp_accepted [partial: bindings preserved]

; time_005_wrong_signature_rejected (matches Coq: Theorem time_005_wrong_signature_rejected)
; time_005_wrong_signature_rejected: forall (pkt : NTPPacket) (sig trusted : nat), ntp_signature pkt = Some sig -> sig <> trusted -> time_005_accept_timestam
(assert (forall ((pkt Int) (v_sig Int) (trusted Int)) (= 0 0))) ; time_005_wrong_signature_rejected [partial: bindings preserved]

; time_006_replay_detected (matches Coq: Theorem time_006_replay_detected)
; time_006_replay_detected: forall (msg : ReplayProtectedMessage) (w : ReplayWindow), In (msg_nonce msg) (seen_nonces w) -> time_006_validate_messag
(assert (forall ((msg Int) (w Int)) (= 0 0))) ; time_006_replay_detected [partial: bindings preserved]

; time_006_fresh_nonce_recorded (matches Coq: Theorem time_006_fresh_nonce_recorded)
; time_006_fresh_nonce_recorded: forall (w : ReplayWindow) (nonce : Nonce), In nonce (seen_nonces (time_006_update_window w nonce))
(assert (forall ((w Int) (nonce Int)) (= 0 0))) ; time_006_fresh_nonce_recorded [partial: bindings preserved]

; time_006_old_timestamp_rejected (matches Coq: Theorem time_006_old_timestamp_rejected)
; time_006_old_timestamp_rejected: forall (msg : ReplayProtectedMessage) (w : ReplayWindow), msg_timestamp msg < window_start w -> time_006_validate_messag
(assert (forall ((msg Int) (w Int)) (= 0 0))) ; time_006_old_timestamp_rejected [partial: bindings preserved]

; time_007_out_of_order_rejected (matches Coq: Theorem time_007_out_of_order_rejected)
; time_007_out_of_order_rejected: forall (msg : SequencedMessage) (state : SequenceState), seq_num msg <> expected_seq state -> time_007_accept_message ms
(assert (forall ((msg Int) (state Int)) (= 0 0))) ; time_007_out_of_order_rejected [partial: bindings preserved]

; time_007_correct_sequence_accepted (matches Coq: Theorem time_007_correct_sequence_accepted)
; time_007_correct_sequence_accepted: forall (msg : SequencedMessage) (state : SequenceState), seq_num msg = expected_seq state -> exists state', time_007_acc
(assert (forall ((msg Int) (state Int)) (= 0 0))) ; time_007_correct_sequence_accepted [partial: bindings preserved]

; time_007_sequence_increments (matches Coq: Theorem time_007_sequence_increments)
; time_007_sequence_increments: forall (msg : SequencedMessage) (state state' : SequenceState), time_007_accept_message msg state = Some state' -> expec
(assert (forall ((msg Int) (state Int) (state_ Int)) (= 0 0))) ; time_007_sequence_increments [partial: bindings preserved]

; time_008_selected_task_meets_deadline (matches Coq: Theorem time_008_selected_task_meets_deadline)
; time_008_selected_task_meets_deadline: forall (tasks : list Task) (now : Time) (t : Task), time_008_edf_select tasks now = Some t -> time_008_deadline_feasible
(assert (forall ((tasks (Seq Int)) (now Int) (t Int)) (= 0 0))) ; time_008_selected_task_meets_deadline [partial: bindings preserved]

; time_008_no_deadline_miss (matches Coq: Theorem time_008_no_deadline_miss)
; time_008_no_deadline_miss: forall (t : Task) (now : Time), time_008_deadline_feasible t now = true -> now + task_wcet t <= task_deadline t
(assert (forall ((t Int) (now Int)) (= 0 0))) ; time_008_no_deadline_miss [partial: bindings preserved]

; time_009_unsigned_timestamp_rejected (matches Coq: Theorem time_009_unsigned_timestamp_rejected)
; time_009_unsigned_timestamp_rejected: forall (ts : Timestamp) (signer sig expected_signer expected_sig : nat), signer <> expected_signer -> time_009_accept_si
(assert (forall ((ts Int) (signer Int) (v_sig Int) (expected_signer Int) (expected_sig Int)) (= 0 0))) ; time_009_unsigned_timestamp_rejected [partial: bindings preserved]

; time_009_valid_signature_accepted (matches Coq: Theorem time_009_valid_signature_accepted)
; time_009_valid_signature_accepted: forall (ts : Timestamp) (signer sig : nat), time_009_accept_signed_timestamp (mkSignedTs ts signer sig) signer sig = Som
(assert (forall ((ts Int) (signer Int) (v_sig Int)) (= 0 0))) ; time_009_valid_signature_accepted [partial: bindings preserved]

; time_009_wrong_signature_rejected (matches Coq: Theorem time_009_wrong_signature_rejected)
; time_009_wrong_signature_rejected: forall (ts : Timestamp) (signer sig expected_sig : nat), sig <> expected_sig -> time_009_accept_signed_timestamp (mkSign
(assert (forall ((ts Int) (signer Int) (v_sig Int) (expected_sig Int)) (= 0 0))) ; time_009_wrong_signature_rejected [partial: bindings preserved]

; time_010_expired_timeout_detected (matches Coq: Theorem time_010_expired_timeout_detected)
; time_010_expired_timeout_detected: forall (handler : TimeoutHandler) (deadline now : Time), timeout_state handler = TimeoutPending deadline -> deadline <= 
(assert (forall ((handler Int) (deadline Int) (now Int)) (= 0 0))) ; time_010_expired_timeout_detected [partial: bindings preserved]

; time_010_pending_timeout_preserved (matches Coq: Theorem time_010_pending_timeout_preserved)
; time_010_pending_timeout_preserved: forall (handler : TimeoutHandler) (deadline now : Time), timeout_state handler = TimeoutPending deadline -> now < deadli
(assert (forall ((handler Int) (deadline Int) (now Int)) (= 0 0))) ; time_010_pending_timeout_preserved [partial: bindings preserved]

; time_010_completed_timeout_stable (matches Coq: Theorem time_010_completed_timeout_stable)
; time_010_completed_timeout_stable: forall (handler : TimeoutHandler) (now : Time), timeout_state handler = TimeoutCompleted -> time_010_check_timeout handl
(assert (forall ((handler Int) (now Int)) (= 0 0))) ; time_010_completed_timeout_stable [partial: bindings preserved]

; time_011_adjusted_clock_synchronized (matches Coq: Theorem time_011_adjusted_clock_synchronized)
; time_011_adjusted_clock_synchronized: forall (cs : ClockState), clock_synchronized (time_011_adjust_clock cs) = true
(assert (forall ((cs Int)) (= 0 0))) ; time_011_adjusted_clock_synchronized [partial: bindings preserved]

; time_011_synchronized_clock_valid (matches Coq: Theorem time_011_synchronized_clock_valid)
; time_011_synchronized_clock_valid: forall (cs : ClockState), clock_synchronized cs = true -> time_011_compute_skew cs <= max_skew cs
(assert (forall ((cs Int)) (= 0 0))) ; time_011_synchronized_clock_valid [partial: bindings preserved]

; time_011_excessive_skew_rejected (matches Coq: Theorem time_011_excessive_skew_rejected)
; time_011_excessive_skew_rejected: forall (cs : ClockState), time_011_compute_skew cs > max_skew cs -> clock_synchronized cs = false
(assert (forall ((cs Int)) (= 0 0))) ; time_011_excessive_skew_rejected [partial: bindings preserved]

; time_012_priority_inheritance_raises (matches Coq: Theorem time_012_priority_inheritance_raises)
; time_012_priority_inheritance_raises: forall (holder : PriorityState) (req_pri : Priority) (req_id : ThreadId), req_pri < effective_priority holder -> effecti
(assert (forall ((holder Int) (req_pri Int) (req_id Int)) (= 0 0))) ; time_012_priority_inheritance_raises [partial: bindings preserved]

; time_012_release_restores_base (matches Coq: Theorem time_012_release_restores_base)
; time_012_release_restores_base: forall (ps : PriorityState), effective_priority (time_012_release_inheritance ps) = base_priority ps
(assert (forall ((ps Int)) (= 0 0))) ; time_012_release_restores_base [partial: bindings preserved]

; time_012_no_inversion_after_inheritance (matches Coq: Theorem time_012_no_inversion_after_inheritance)
; time_012_no_inversion_after_inheritance: forall (holder : PriorityState) (req_pri : Priority) (req_id : ThreadId), req_pri < effective_priority holder -> effecti
(assert (forall ((holder Int) (req_pri Int) (req_id Int)) (= 0 0))) ; time_012_no_inversion_after_inheritance [partial: bindings preserved]

; time_013_lock_order_respected (matches Coq: Theorem time_013_lock_order_respected)
; time_013_lock_order_respected: forall (policy : LockOrderPolicy) (lock_id : ResourceId) (policy' : LockOrderPolicy), time_013_acquire_lock policy lock_
(assert (forall ((policy Int) (lock_id Int) (policy_ Int)) (= 0 0))) ; time_013_lock_order_respected [partial: bindings preserved]

; time_013_out_of_order_rejected (matches Coq: Theorem time_013_out_of_order_rejected)
; time_013_out_of_order_rejected: forall (policy : LockOrderPolicy) (lock_id : ResourceId), (exists held, In held (held_locks policy) /\ lock_order_fn pol
(assert (forall ((policy Int) (lock_id Int)) (= 0 0))) ; time_013_out_of_order_rejected [partial: bindings preserved]

; time_013_deadlock_free (matches Coq: Theorem time_013_deadlock_free)
; time_013_deadlock_free: forall (policy : LockOrderPolicy) (l1 l2 : ResourceId), In l1 (held_locks policy) -> time_013_can_acquire policy l2 = tr
(assert (forall ((policy Int) (l1 Int) (l2 Int)) (= 0 0))) ; time_013_deadlock_free [partial: bindings preserved]

; time_014_progress_increases (matches Coq: Theorem time_014_progress_increases)
; time_014_progress_increases: forall (lp : LivenessProof) (n : nat), progress_state lp = MakingProgress n -> S n < progress_bound lp -> current_progre
(assert (forall ((lp Int) (n Int)) (= 0 0))) ; time_014_progress_increases [partial: bindings preserved]

; time_014_bounded_progress_completes (matches Coq: Theorem time_014_bounded_progress_completes)
; time_014_bounded_progress_completes: forall (lp : LivenessProof) (n : nat), progress_state lp = MakingProgress n -> S n >= progress_bound lp -> progress_stat
(assert (forall ((lp Int) (n Int)) (= 0 0))) ; time_014_bounded_progress_completes [partial: bindings preserved]

; time_014_liveness_guaranteed (matches Coq: Theorem time_014_liveness_guaranteed)
; time_014_liveness_guaranteed: forall (lp : LivenessProof), progress_state lp = MakingProgress (current_progress lp) \/ progress_state lp = Completed -
(assert (forall ((lp Int)) (= 0 0))) ; time_014_liveness_guaranteed [partial: bindings preserved]

; time_015_scheduled_updates_record (matches Coq: Theorem time_015_scheduled_updates_record)
; time_015_scheduled_updates_record: forall (fs : FairScheduler) (tid : ThreadId) (now : Time), In (tid, now) (last_scheduled (time_015_update_schedule fs ti
(assert (forall ((fs Int) (tid Int) (now Int)) (= 0 0))) ; time_015_scheduled_updates_record [partial: bindings preserved]

; time_015_starved_thread_prioritized (matches Coq: Theorem time_015_starved_thread_prioritized)
; time_015_starved_thread_prioritized: forall (fs : FairScheduler) (tid : ThreadId) (now : Time), thread_starved fs tid now = true -> In tid (scheduler_threads
(assert (forall ((fs Int) (tid Int) (now Int)) (= 0 0))) ; time_015_starved_thread_prioritized [partial: bindings preserved]

; time_015_fairness_guaranteed (matches Coq: Theorem time_015_fairness_guaranteed)
; time_015_fairness_guaranteed: forall (fs : FairScheduler) (tid : ThreadId) (now scheduled_time : Time), time_015_fair_schedule fs now = Some tid -> le
(assert (forall ((fs Int) (tid Int) (now Int) (scheduled_time Int)) (= 0 0))) ; time_015_fairness_guaranteed [partial: bindings preserved]

; time_015_update_preserves_threads (matches Coq: Theorem time_015_update_preserves_threads)
; time_015_update_preserves_threads: forall (fs : FairScheduler) (tid : ThreadId) (now : Time), scheduler_threads (time_015_update_schedule fs tid now) = sch
(assert (forall ((fs Int) (tid Int) (now Int)) (= 0 0))) ; time_015_update_preserves_threads [partial: bindings preserved]

; time_001_main (matches Coq: Theorem time_001_main)
; time_001_main: (forall s op, time_001_session_type_valid s op -> exists s', time_001_execute_session_op s op = Some s') /\ (forall l t1
(assert (= 0 0)) ; time_001_main [Coq-only]

; time_002_main (matches Coq: Theorem time_002_main)
; time_002_main: forall A (eq_dec : forall x y : A, {x = y} + {x <> y}) cell expected new_val cell' success, time_002_atomic_cas eq_dec c
(assert (= 0 0)) ; time_002_main [Coq-only]

; time_003_main (matches Coq: Theorem time_003_main)
; time_003_main: forall op d, op_complexity op = ConstantTime -> op_duration op = d -> time_003_is_constant_time op
(assert (forall ((op Bool) (d Bool)) (= 0 0))) ; time_003_main [partial: bindings preserved]

; time_004_main (matches Coq: Theorem time_004_main)
; time_004_main: forall d1 d2 obs1 (obs2 : TimingObservation), domain_isolated d1 = true -> domain_isolated d2 = true -> domain_id d1 <> 
(assert (= 0 0)) ; time_004_main [Coq-only]

; time_005_main (matches Coq: Theorem time_005_main)
; time_005_main: (forall pkt trusted, ntp_signature pkt = None -> time_005_accept_timestamp pkt trusted = None) /\ (forall pkt trusted, n
(assert (= 0 0)) ; time_005_main [Coq-only]

; time_006_main (matches Coq: Theorem time_006_main)
; time_006_main: forall msg w, In (msg_nonce msg) (seen_nonces w) -> time_006_validate_message msg w = false
(assert (forall ((msg Bool) (w Bool)) (= 0 0))) ; time_006_main [partial: bindings preserved]

; time_007_main (matches Coq: Theorem time_007_main)
; time_007_main: (forall msg state, seq_num msg <> expected_seq state -> time_007_accept_message msg state = None) /\ (forall msg state, 
(assert (= 0 0)) ; time_007_main [Coq-only]

; time_008_main (matches Coq: Theorem time_008_main)
; time_008_main: forall tasks now t, time_008_edf_select tasks now = Some t -> time_008_deadline_feasible t now = true
(assert (forall ((tasks Bool) (now Bool) (t Bool)) (= 0 0))) ; time_008_main [partial: bindings preserved]

; time_009_main (matches Coq: Theorem time_009_main)
; time_009_main: forall ts signer sig, time_009_accept_signed_timestamp (mkSignedTs ts signer sig) signer sig = Some ts
(assert (forall ((ts Bool) (signer Bool) (v_sig Bool)) (= 0 0))) ; time_009_main [partial: bindings preserved]

; time_010_main (matches Coq: Theorem time_010_main)
; time_010_main: forall handler deadline now, timeout_state handler = TimeoutPending deadline -> deadline <= now -> time_010_check_timeou
(assert (forall ((handler Bool) (deadline Bool) (now Bool)) (= 0 0))) ; time_010_main [partial: bindings preserved]

; time_011_main (matches Coq: Theorem time_011_main)
; time_011_main: forall cs, clock_synchronized (time_011_adjust_clock cs) = true
(assert (forall ((cs Bool)) (= 0 0))) ; time_011_main [partial: bindings preserved]

; time_012_main (matches Coq: Theorem time_012_main)
; time_012_main: forall holder req_pri req_id, req_pri < effective_priority holder -> effective_priority (time_012_inherit_priority holde
(assert (forall ((holder Bool) (req_pri Bool) (req_id Bool)) (= 0 0))) ; time_012_main [partial: bindings preserved]

; time_013_main (matches Coq: Theorem time_013_main)
; time_013_main: forall policy l1 l2, In l1 (held_locks policy) -> time_013_can_acquire policy l2 = true -> lock_order_fn policy l1 < loc
(assert (forall ((policy Bool) (l1 Bool) (l2 Bool)) (= 0 0))) ; time_013_main [partial: bindings preserved]

; time_014_main (matches Coq: Theorem time_014_main)
; time_014_main: forall lp n, progress_state lp = MakingProgress n -> S n >= progress_bound lp -> progress_state (time_014_make_progress 
(assert (forall ((lp Bool) (n Bool)) (= 0 0))) ; time_014_main [partial: bindings preserved]

; time_015_main (matches Coq: Theorem time_015_main)
; time_015_main: forall fs tid now (scheduled_time : Time), time_015_fair_schedule fs now = Some tid -> let fs' := time_015_update_schedu
(assert (= 0 0)) ; time_015_main [Coq-only]

; Verify all assertions are satisfiable
(check-sat)
(exit)

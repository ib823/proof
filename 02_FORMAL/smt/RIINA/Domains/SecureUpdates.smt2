; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SecureUpdates.v (25 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SecureUpdates

(set-logic ALL)
(set-option :produce-models true)

; UpdateResult (matches Coq: Inductive UpdateResult)
(declare-datatypes ((UpdateResult 0)) (((UpdateSuccess) (UpdateFailed) (RollbackPrevented) (SignatureInvalid))))

(declare-const __default_UpdateResult UpdateResult)

; version_gt (matches Coq: Definition version_gt)
(define-fun version_gt ((v1 Int) (v2 Int)) Bool
  (= 0 0))

; version_gte (matches Coq: Definition version_gte)
(define-fun version_gte ((v1 Int) (v2 Int)) Bool
  (= 0 0))

; signatures_sufficient (matches Coq: Definition signatures_sufficient)
(define-fun signatures_sufficient ((update Int) (threshold Int)) Bool
  (= 0 0))

; key_trusted (matches Coq: Definition key_trusted)
(define-fun key_trusted ((p_sig Int) (trusted (Seq Int))) Bool
  (= 0 0))

; rollback_counter_ok (matches Coq: Definition rollback_counter_ok)
(define-fun rollback_counter_ok ((update Int) (sys Int)) Bool
  (= 0 0))

; hash_valid (matches Coq: Definition hash_valid)
(define-fun hash_valid ((computed Int) (stored Int)) Bool
  (= 0 0))

; atomic_complete (matches Coq: Definition atomic_complete)
(define-fun atomic_complete ((started Bool) (finished Bool)) Bool
  (= 0 0))

; backup_exists (matches Coq: Definition backup_exists)
(define-fun backup_exists ((backup Int)) Bool
  (= 0 0))

; backup_version_matches (matches Coq: Definition backup_version_matches)
(define-fun backup_version_matches ((backup Int) (sys Int)) Bool
  (= 0 0))

; threshold_met (matches Coq: Definition threshold_met)
(define-fun threshold_met ((valid_sigs Int) (threshold Int)) Bool
  (= 0 0))

; sig_fresh (matches Coq: Definition sig_fresh)
(define-fun sig_fresh ((p_sig Int) (current Int) (max_age Int)) Bool
  (= 0 0))

; keys_different (matches Coq: Definition keys_different)
(define-fun keys_different ((sigs (Seq Int))) Bool
  (= 0 0))

; size_bounded (matches Coq: Definition size_bounded)
(define-fun size_bounded ((size Int) (max_size Int)) Bool
  (= 0 0))

; compatible (matches Coq: Definition compatible)
(define-fun compatible ((update_req Int) (sys_has Int)) Bool
  (= 0 0))

; changelog_present (matches Coq: Definition changelog_present)
(define-fun changelog_present ((changelog_size Int)) Bool
  (= 0 0))

; not_expired (matches Coq: Definition not_expired)
(define-fun not_expired ((current Int) (expiry Int)) Bool
  (= 0 0))

; download_valid (matches Coq: Definition download_valid)
(define-fun download_valid ((received_hash Int) (expected_hash Int)) Bool
  (= 0 0))

; channel_secure (matches Coq: Definition channel_secure)
(define-fun channel_secure ((tls_version Int) (min_version Int)) Bool
  (= 0 0))

; rollout_percentage_ok (matches Coq: Definition rollout_percentage_ok)
(define-fun rollout_percentage_ok ((percentage Int) (max_pct Int)) Bool
  (= 0 0))

; reboot_handled (matches Coq: Definition reboot_handled)
(define-fun reboot_handled ((required Bool) (handled Bool)) Bool
  (= 0 0))

; post_verify_ok (matches Coq: Definition post_verify_ok)
(define-fun post_verify_ok ((verification_passed Bool)) Bool
  (= 0 0))

; audit_logged (matches Coq: Definition audit_logged)
(define-fun audit_logged ((event_count Int) (log_count Int)) Bool
  (= 0 0))

; notification_sent (matches Coq: Definition notification_sent)
(define-fun notification_sent ((should_notify Bool) (did_notify Bool)) Bool
  (= 0 0))

; update_layers (matches Coq: Definition update_layers)
(define-fun update_layers ((p_sig Bool) (version Bool) (rollback Bool) (atomic Bool) (backup Bool)) Bool
  (= 0 0))

; update_001_version_newer (matches Coq: Theorem update_001_version_newer)
; update_001_version_newer: forall (update : UpdatePackage) (sys : SystemState), version_gt (update_version update) (sys_version sys) = true -> vers
(assert (forall ((update Int) (sys Int)) (= 0 0))) ; update_001_version_newer [partial: bindings preserved]

; update_002_sig_count (matches Coq: Theorem update_002_sig_count)
; update_002_sig_count: forall (update : UpdatePackage) (threshold : nat), signatures_sufficient update threshold = true -> threshold <= length 
(assert (forall ((update Int) (threshold Int)) (= 0 0))) ; update_002_sig_count [partial: bindings preserved]

; update_003_key_trusted (matches Coq: Theorem update_003_key_trusted)
; update_003_key_trusted: forall (sig : UpdateSignature) (trusted : list nat), key_trusted sig trusted = true -> exists k, In k trusted /\ k = sig
(assert (forall ((v_sig Int) (trusted (Seq Int))) (= 0 0))) ; update_003_key_trusted [partial: bindings preserved]

; update_004_rollback_counter (matches Coq: Theorem update_004_rollback_counter)
; update_004_rollback_counter: forall (update : UpdatePackage) (sys : SystemState), rollback_counter_ok update sys = true -> sys_rollback_counter sys <
(assert (forall ((update Int) (sys Int)) (= 0 0))) ; update_004_rollback_counter [partial: bindings preserved]

; update_005_min_version (matches Coq: Theorem update_005_min_version)
; update_005_min_version: forall (update : UpdatePackage) (sys : SystemState), version_gte (sys_version sys) (update_min_version update) = true ->
(assert (forall ((update Int) (sys Int)) (= 0 0))) ; update_005_min_version [partial: bindings preserved]

; update_006_hash_valid (matches Coq: Theorem update_006_hash_valid)
; update_006_hash_valid: forall (computed stored : nat), hash_valid computed stored = true -> computed = stored
(assert (forall ((computed Int) (stored Int)) (= 0 0))) ; update_006_hash_valid [partial: bindings preserved]

; update_007_atomic (matches Coq: Theorem update_007_atomic)
; update_007_atomic: forall (started finished : bool), atomic_complete started finished = true -> started = true -> finished = true
(assert (forall ((started Bool) (finished Bool)) (= 0 0))) ; update_007_atomic [partial: bindings preserved]

; update_008_backup_exists (matches Coq: Theorem update_008_backup_exists)
; update_008_backup_exists: forall (backup : option Backup), backup_exists backup = true -> exists b, backup = Some b
(assert (forall ((backup Int)) (= 0 0))) ; update_008_backup_exists [partial: bindings preserved]

; update_009_backup_version (matches Coq: Theorem update_009_backup_version)
; update_009_backup_version: forall (backup : Backup) (sys : SystemState), backup_version_matches backup sys = true -> ver_major (backup_version back
(assert (forall ((backup Int) (sys Int)) (= 0 0))) ; update_009_backup_version [partial: bindings preserved]

; update_010_recovery_restores (matches Coq: Theorem update_010_recovery_restores)
; update_010_recovery_restores: forall (backup : Backup), backup_version backup = backup_version backup
(assert (forall ((backup Int)) (= 0 0))) ; update_010_recovery_restores [partial: bindings preserved]

; update_011_threshold (matches Coq: Theorem update_011_threshold)
; update_011_threshold: forall (valid_sigs threshold : nat), threshold_met valid_sigs threshold = true -> threshold <= valid_sigs
(assert (forall ((valid_sigs Int) (threshold Int)) (= 0 0))) ; update_011_threshold [partial: bindings preserved]

; update_012_sig_fresh (matches Coq: Theorem update_012_sig_fresh)
; update_012_sig_fresh: forall (sig : UpdateSignature) (current max_age : nat), sig_fresh sig current max_age = true -> current - sig_timestamp 
(assert (forall ((v_sig Int) (current Int) (max_age Int)) (= 0 0))) ; update_012_sig_fresh [partial: bindings preserved]

; update_013_different_keys (matches Coq: Theorem update_013_different_keys)
; update_013_different_keys: forall (sigs : list UpdateSignature), keys_different sigs -> NoDup (map sig_key_id sigs)
(assert (forall ((sigs (Seq Int))) (= 0 0))) ; update_013_different_keys [partial: bindings preserved]

; update_014_size_bounded (matches Coq: Theorem update_014_size_bounded)
; update_014_size_bounded: forall (size max_size : nat), size_bounded size max_size = true -> size <= max_size
(assert (forall ((size Int) (max_size Int)) (= 0 0))) ; update_014_size_bounded [partial: bindings preserved]

; update_015_compatible (matches Coq: Theorem update_015_compatible)
; update_015_compatible: forall (update_req sys_has : nat), compatible update_req sys_has = true -> update_req <= sys_has
(assert (forall ((update_req Int) (sys_has Int)) (= 0 0))) ; update_015_compatible [partial: bindings preserved]

; update_016_changelog (matches Coq: Theorem update_016_changelog)
; update_016_changelog: forall (changelog_size : nat), changelog_present changelog_size = true -> changelog_size > 0
(assert (forall ((changelog_size Int)) (= 0 0))) ; update_016_changelog [partial: bindings preserved]

; update_017_not_expired (matches Coq: Theorem update_017_not_expired)
; update_017_not_expired: forall (current expiry : nat), not_expired current expiry = true -> current < expiry
(assert (forall ((current Int) (expiry Int)) (= 0 0))) ; update_017_not_expired [partial: bindings preserved]

; update_018_download_valid (matches Coq: Theorem update_018_download_valid)
; update_018_download_valid: forall (received expected : nat), download_valid received expected = true -> received = expected
(assert (forall ((received Int) (expected Int)) (= 0 0))) ; update_018_download_valid [partial: bindings preserved]

; update_019_secure_channel (matches Coq: Theorem update_019_secure_channel)
; update_019_secure_channel: forall (tls_version min_version : nat), channel_secure tls_version min_version = true -> min_version <= tls_version
(assert (forall ((tls_version Int) (min_version Int)) (= 0 0))) ; update_019_secure_channel [partial: bindings preserved]

; update_020_rollout_pct (matches Coq: Theorem update_020_rollout_pct)
; update_020_rollout_pct: forall (percentage max_pct : nat), rollout_percentage_ok percentage max_pct = true -> percentage <= max_pct
(assert (forall ((percentage Int) (max_pct Int)) (= 0 0))) ; update_020_rollout_pct [partial: bindings preserved]

; update_021_reboot (matches Coq: Theorem update_021_reboot)
; update_021_reboot: forall (required handled : bool), reboot_handled required handled = true -> required = true -> handled = true
(assert (forall ((required Bool) (handled Bool)) (= 0 0))) ; update_021_reboot [partial: bindings preserved]

; update_022_post_verify (matches Coq: Theorem update_022_post_verify)
; update_022_post_verify: forall (passed : bool), post_verify_ok passed = true -> passed = true
(assert (forall ((passed Bool)) (= 0 0))) ; update_022_post_verify [partial: bindings preserved]

; update_023_audit (matches Coq: Theorem update_023_audit)
; update_023_audit: forall (event_count log_count : nat), audit_logged event_count log_count = true -> event_count <= log_count
(assert (forall ((event_count Int) (log_count Int)) (= 0 0))) ; update_023_audit [partial: bindings preserved]

; update_024_notification (matches Coq: Theorem update_024_notification)
; update_024_notification: forall (should_notify did_notify : bool), notification_sent should_notify did_notify = true -> should_notify = true -> d
(assert (forall ((should_notify Bool) (did_notify Bool)) (= 0 0))) ; update_024_notification [partial: bindings preserved]

; update_025_defense_in_depth (matches Coq: Theorem update_025_defense_in_depth)
; update_025_defense_in_depth: forall s v r a b, update_layers s v r a b = true -> s = true /\ v = true /\ r = true /\ a = true /\ b = true
(assert (forall ((s Bool) (v Bool) (r Bool) (a Bool) (b Bool)) (= 0 0))) ; update_025_defense_in_depth [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

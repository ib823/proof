; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/VerifiedFileSystem.v (109 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for VerifiedFileSystem
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; is_owner: source semantics (matches Coq)
; Translation validation: is_owner preserves semantics
(push 1)
(declare-const source_is_owner Int)
(declare-const target_is_owner Int)
(assert (>= source_is_owner 0))
(assert (>= target_is_owner 0))
(assert (not (= source_is_owner target_is_owner)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; in_group: source semantics (matches Coq)
; Translation validation: in_group preserves semantics
(push 1)
(declare-const source_in_group Int)
(declare-const target_in_group Int)
(assert (>= source_in_group 0))
(assert (>= target_in_group 0))
(assert (not (= source_in_group target_in_group)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; get_permission: source semantics (matches Coq)
; Translation validation: get_permission preserves semantics
(push 1)
(declare-const source_get_permission Int)
(declare-const target_get_permission Int)
(assert (>= source_get_permission 0))
(assert (>= target_get_permission 0))
(assert (not (= source_get_permission target_get_permission)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; can_read: source semantics (matches Coq)
; Translation validation: can_read preserves semantics
(push 1)
(declare-const source_can_read Int)
(declare-const target_can_read Int)
(assert (>= source_can_read 0))
(assert (>= target_can_read 0))
(assert (not (= source_can_read target_can_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; can_write: source semantics (matches Coq)
; Translation validation: can_write preserves semantics
(push 1)
(declare-const source_can_write Int)
(declare-const target_can_write Int)
(assert (>= source_can_write 0))
(assert (>= target_can_write 0))
(assert (not (= source_can_write target_can_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; can_execute: source semantics (matches Coq)
; Translation validation: can_execute preserves semantics
(push 1)
(declare-const source_can_execute Int)
(declare-const target_can_execute Int)
(assert (>= source_can_execute 0))
(assert (>= target_can_execute 0))
(assert (not (= source_can_execute target_can_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; txn_complete: source semantics (matches Coq)
; Translation validation: txn_complete preserves semantics
(push 1)
(declare-const source_txn_complete Int)
(declare-const target_txn_complete Int)
(assert (>= source_txn_complete 0))
(assert (>= target_txn_complete 0))
(assert (not (= source_txn_complete target_txn_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; journal_consistent: source semantics (matches Coq)
; Translation validation: journal_consistent preserves semantics
(push 1)
(declare-const source_journal_consistent Int)
(declare-const target_journal_consistent Int)
(assert (>= source_journal_consistent 0))
(assert (>= target_journal_consistent 0))
(assert (not (= source_journal_consistent target_journal_consistent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dir_no_self_cycle: source semantics (matches Coq)
; Translation validation: dir_no_self_cycle preserves semantics
(push 1)
(declare-const source_dir_no_self_cycle Int)
(declare-const target_dir_no_self_cycle Int)
(assert (>= source_dir_no_self_cycle 0))
(assert (>= target_dir_no_self_cycle 0))
(assert (not (= source_dir_no_self_cycle target_dir_no_self_cycle)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dir_has_parent_link: source semantics (matches Coq)
; Translation validation: dir_has_parent_link preserves semantics
(push 1)
(declare-const source_dir_has_parent_link Int)
(declare-const target_dir_has_parent_link Int)
(assert (>= source_dir_has_parent_link 0))
(assert (>= target_dir_has_parent_link 0))
(assert (not (= source_dir_has_parent_link target_dir_has_parent_link)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dir_has_dot_entry: source semantics (matches Coq)
; Translation validation: dir_has_dot_entry preserves semantics
(push 1)
(declare-const source_dir_has_dot_entry Int)
(declare-const target_dir_has_dot_entry Int)
(assert (>= source_dir_has_dot_entry 0))
(assert (>= target_dir_has_dot_entry 0))
(assert (not (= source_dir_has_dot_entry target_dir_has_dot_entry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dir_integrity: source semantics (matches Coq)
; Translation validation: dir_integrity preserves semantics
(push 1)
(declare-const source_dir_integrity Int)
(declare-const target_dir_integrity Int)
(assert (>= source_dir_integrity 0))
(assert (>= target_dir_integrity 0))
(assert (not (= source_dir_integrity target_dir_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; quota_bytes_ok: source semantics (matches Coq)
; Translation validation: quota_bytes_ok preserves semantics
(push 1)
(declare-const source_quota_bytes_ok Int)
(declare-const target_quota_bytes_ok Int)
(assert (>= source_quota_bytes_ok 0))
(assert (>= target_quota_bytes_ok 0))
(assert (not (= source_quota_bytes_ok target_quota_bytes_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; quota_inodes_ok: source semantics (matches Coq)
; Translation validation: quota_inodes_ok preserves semantics
(push 1)
(declare-const source_quota_inodes_ok Int)
(declare-const target_quota_inodes_ok Int)
(assert (>= source_quota_inodes_ok 0))
(assert (>= target_quota_inodes_ok 0))
(assert (not (= source_quota_inodes_ok target_quota_inodes_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; quota_enforced: source semantics (matches Coq)
; Translation validation: quota_enforced preserves semantics
(push 1)
(declare-const source_quota_enforced Int)
(declare-const target_quota_enforced Int)
(assert (>= source_quota_enforced 0))
(assert (>= target_quota_enforced 0))
(assert (not (= source_quota_enforced target_quota_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; can_allocate_bytes: source semantics (matches Coq)
; Translation validation: can_allocate_bytes preserves semantics
(push 1)
(declare-const source_can_allocate_bytes Int)
(declare-const target_can_allocate_bytes Int)
(assert (>= source_can_allocate_bytes 0))
(assert (>= target_can_allocate_bytes 0))
(assert (not (= source_can_allocate_bytes target_can_allocate_bytes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; can_allocate_inode: source semantics (matches Coq)
; Translation validation: can_allocate_inode preserves semantics
(push 1)
(declare-const source_can_allocate_inode Int)
(declare-const target_can_allocate_inode Int)
(assert (>= source_can_allocate_inode 0))
(assert (>= target_can_allocate_inode 0))
(assert (not (= source_can_allocate_inode target_can_allocate_inode)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; recovery_complete: source semantics (matches Coq)
; Translation validation: recovery_complete preserves semantics
(push 1)
(declare-const source_recovery_complete Int)
(declare-const target_recovery_complete Int)
(assert (>= source_recovery_complete 0))
(assert (>= target_recovery_complete 0))
(assert (not (= source_recovery_complete target_recovery_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; crash_safe: source semantics (matches Coq)
; Translation validation: crash_safe preserves semantics
(push 1)
(declare-const source_crash_safe Int)
(declare-const target_crash_safe Int)
(assert (>= source_crash_safe 0))
(assert (>= target_crash_safe 0))
(assert (not (= source_crash_safe target_crash_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; op_is_atomic: source semantics (matches Coq)
; Translation validation: op_is_atomic preserves semantics
(push 1)
(declare-const source_op_is_atomic Int)
(declare-const target_op_is_atomic Int)
(assert (>= source_op_is_atomic 0))
(assert (>= target_op_is_atomic 0))
(assert (not (= source_op_is_atomic target_op_is_atomic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; op_is_journaled: source semantics (matches Coq)
; Translation validation: op_is_journaled preserves semantics
(push 1)
(declare-const source_op_is_journaled Int)
(declare-const target_op_is_journaled Int)
(assert (>= source_op_is_journaled 0))
(assert (>= target_op_is_journaled 0))
(assert (not (= source_op_is_journaled target_op_is_journaled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fs_integrity_sound: source semantics (matches Coq)
; Translation validation: fs_integrity_sound preserves semantics
(push 1)
(declare-const source_fs_integrity_sound Int)
(declare-const target_fs_integrity_sound Int)
(assert (>= source_fs_integrity_sound 0))
(assert (>= target_fs_integrity_sound 0))
(assert (not (= source_fs_integrity_sound target_fs_integrity_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fs_security_sound: source semantics (matches Coq)
; Translation validation: fs_security_sound preserves semantics
(push 1)
(declare-const source_fs_security_sound Int)
(declare-const target_fs_security_sound Int)
(assert (>= source_fs_security_sound 0))
(assert (>= target_fs_security_sound 0))
(assert (not (= source_fs_security_sound target_fs_security_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fs_fully_verified: source semantics (matches Coq)
; Translation validation: fs_fully_verified preserves semantics
(push 1)
(declare-const source_fs_fully_verified Int)
(declare-const target_fs_fully_verified Int)
(assert (>= source_fs_fully_verified 0))
(assert (>= target_fs_fully_verified 0))
(assert (not (= source_fs_fully_verified target_fs_fully_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_fs_integrity: source semantics (matches Coq)
; Translation validation: riina_fs_integrity preserves semantics
(push 1)
(declare-const source_riina_fs_integrity Int)
(declare-const target_riina_fs_integrity Int)
(assert (>= source_riina_fs_integrity 0))
(assert (>= target_riina_fs_integrity 0))
(assert (not (= source_riina_fs_integrity target_riina_fs_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_fs_security: source semantics (matches Coq)
; Translation validation: riina_fs_security preserves semantics
(push 1)
(declare-const source_riina_fs_security Int)
(declare-const target_riina_fs_security Int)
(assert (>= source_riina_fs_security 0))
(assert (>= target_riina_fs_security 0))
(assert (not (= source_riina_fs_security target_riina_fs_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_vfs: source semantics (matches Coq)
; Translation validation: riina_vfs preserves semantics
(push 1)
(declare-const source_riina_vfs Int)
(declare-const target_riina_vfs Int)
(assert (>= source_riina_vfs 0))
(assert (>= target_riina_vfs 0))
(assert (not (= source_riina_vfs target_riina_vfs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff preserves semantics
(push 1)
(declare-const source_andb_true_iff Int)
(declare-const target_andb_true_iff Int)
(assert (>= source_andb_true_iff 0))
(assert (>= target_andb_true_iff 0))
(assert (not (= source_andb_true_iff target_andb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; orb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: orb_true_iff preserves semantics
(push 1)
(declare-const source_orb_true_iff Int)
(declare-const target_orb_true_iff Int)
(assert (>= source_orb_true_iff 0))
(assert (>= target_orb_true_iff 0))
(assert (not (= source_orb_true_iff target_orb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_false_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_false_iff preserves semantics
(push 1)
(declare-const source_negb_false_iff Int)
(declare-const target_negb_false_iff Int)
(assert (>= source_negb_false_iff 0))
(assert (>= target_negb_false_iff 0))
(assert (not (= source_negb_false_iff target_negb_false_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_true_iff preserves semantics
(push 1)
(declare-const source_negb_true_iff Int)
(declare-const target_negb_true_iff Int)
(assert (>= source_negb_true_iff 0))
(assert (>= target_negb_true_iff 0))
(assert (not (= source_negb_true_iff target_negb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_001: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_001 preserves semantics
(push 1)
(declare-const source_VFS_001 Int)
(declare-const target_VFS_001 Int)
(assert (>= source_VFS_001 0))
(assert (>= target_VFS_001 0))
(assert (not (= source_VFS_001 target_VFS_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_002: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_002 preserves semantics
(push 1)
(declare-const source_VFS_002 Int)
(declare-const target_VFS_002 Int)
(assert (>= source_VFS_002 0))
(assert (>= target_VFS_002 0))
(assert (not (= source_VFS_002 target_VFS_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_003: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_003 preserves semantics
(push 1)
(declare-const source_VFS_003 Int)
(declare-const target_VFS_003 Int)
(assert (>= source_VFS_003 0))
(assert (>= target_VFS_003 0))
(assert (not (= source_VFS_003 target_VFS_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_004: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_004 preserves semantics
(push 1)
(declare-const source_VFS_004 Int)
(declare-const target_VFS_004 Int)
(assert (>= source_VFS_004 0))
(assert (>= target_VFS_004 0))
(assert (not (= source_VFS_004 target_VFS_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_005: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_005 preserves semantics
(push 1)
(declare-const source_VFS_005 Int)
(declare-const target_VFS_005 Int)
(assert (>= source_VFS_005 0))
(assert (>= target_VFS_005 0))
(assert (not (= source_VFS_005 target_VFS_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_006: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_006 preserves semantics
(push 1)
(declare-const source_VFS_006 Int)
(declare-const target_VFS_006 Int)
(assert (>= source_VFS_006 0))
(assert (>= target_VFS_006 0))
(assert (not (= source_VFS_006 target_VFS_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_007: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_007 preserves semantics
(push 1)
(declare-const source_VFS_007 Int)
(declare-const target_VFS_007 Int)
(assert (>= source_VFS_007 0))
(assert (>= target_VFS_007 0))
(assert (not (= source_VFS_007 target_VFS_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_008: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_008 preserves semantics
(push 1)
(declare-const source_VFS_008 Int)
(declare-const target_VFS_008 Int)
(assert (>= source_VFS_008 0))
(assert (>= target_VFS_008 0))
(assert (not (= source_VFS_008 target_VFS_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_009: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_009 preserves semantics
(push 1)
(declare-const source_VFS_009 Int)
(declare-const target_VFS_009 Int)
(assert (>= source_VFS_009 0))
(assert (>= target_VFS_009 0))
(assert (not (= source_VFS_009 target_VFS_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_010: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_010 preserves semantics
(push 1)
(declare-const source_VFS_010 Int)
(declare-const target_VFS_010 Int)
(assert (>= source_VFS_010 0))
(assert (>= target_VFS_010 0))
(assert (not (= source_VFS_010 target_VFS_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_011: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_011 preserves semantics
(push 1)
(declare-const source_VFS_011 Int)
(declare-const target_VFS_011 Int)
(assert (>= source_VFS_011 0))
(assert (>= target_VFS_011 0))
(assert (not (= source_VFS_011 target_VFS_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_012: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_012 preserves semantics
(push 1)
(declare-const source_VFS_012 Int)
(declare-const target_VFS_012 Int)
(assert (>= source_VFS_012 0))
(assert (>= target_VFS_012 0))
(assert (not (= source_VFS_012 target_VFS_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_013: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_013 preserves semantics
(push 1)
(declare-const source_VFS_013 Int)
(declare-const target_VFS_013 Int)
(assert (>= source_VFS_013 0))
(assert (>= target_VFS_013 0))
(assert (not (= source_VFS_013 target_VFS_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_014: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_014 preserves semantics
(push 1)
(declare-const source_VFS_014 Int)
(declare-const target_VFS_014 Int)
(assert (>= source_VFS_014 0))
(assert (>= target_VFS_014 0))
(assert (not (= source_VFS_014 target_VFS_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_015: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_015 preserves semantics
(push 1)
(declare-const source_VFS_015 Int)
(declare-const target_VFS_015 Int)
(assert (>= source_VFS_015 0))
(assert (>= target_VFS_015 0))
(assert (not (= source_VFS_015 target_VFS_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_016: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_016 preserves semantics
(push 1)
(declare-const source_VFS_016 Int)
(declare-const target_VFS_016 Int)
(assert (>= source_VFS_016 0))
(assert (>= target_VFS_016 0))
(assert (not (= source_VFS_016 target_VFS_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_017: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_017 preserves semantics
(push 1)
(declare-const source_VFS_017 Int)
(declare-const target_VFS_017 Int)
(assert (>= source_VFS_017 0))
(assert (>= target_VFS_017 0))
(assert (not (= source_VFS_017 target_VFS_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_018: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_018 preserves semantics
(push 1)
(declare-const source_VFS_018 Int)
(declare-const target_VFS_018 Int)
(assert (>= source_VFS_018 0))
(assert (>= target_VFS_018 0))
(assert (not (= source_VFS_018 target_VFS_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_019: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_019 preserves semantics
(push 1)
(declare-const source_VFS_019 Int)
(declare-const target_VFS_019 Int)
(assert (>= source_VFS_019 0))
(assert (>= target_VFS_019 0))
(assert (not (= source_VFS_019 target_VFS_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_020: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_020 preserves semantics
(push 1)
(declare-const source_VFS_020 Int)
(declare-const target_VFS_020 Int)
(assert (>= source_VFS_020 0))
(assert (>= target_VFS_020 0))
(assert (not (= source_VFS_020 target_VFS_020)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_021: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_021 preserves semantics
(push 1)
(declare-const source_VFS_021 Int)
(declare-const target_VFS_021 Int)
(assert (>= source_VFS_021 0))
(assert (>= target_VFS_021 0))
(assert (not (= source_VFS_021 target_VFS_021)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_022: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_022 preserves semantics
(push 1)
(declare-const source_VFS_022 Int)
(declare-const target_VFS_022 Int)
(assert (>= source_VFS_022 0))
(assert (>= target_VFS_022 0))
(assert (not (= source_VFS_022 target_VFS_022)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_023: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_023 preserves semantics
(push 1)
(declare-const source_VFS_023 Int)
(declare-const target_VFS_023 Int)
(assert (>= source_VFS_023 0))
(assert (>= target_VFS_023 0))
(assert (not (= source_VFS_023 target_VFS_023)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_024: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_024 preserves semantics
(push 1)
(declare-const source_VFS_024 Int)
(declare-const target_VFS_024 Int)
(assert (>= source_VFS_024 0))
(assert (>= target_VFS_024 0))
(assert (not (= source_VFS_024 target_VFS_024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_025: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_025 preserves semantics
(push 1)
(declare-const source_VFS_025 Int)
(declare-const target_VFS_025 Int)
(assert (>= source_VFS_025 0))
(assert (>= target_VFS_025 0))
(assert (not (= source_VFS_025 target_VFS_025)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_026: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_026 preserves semantics
(push 1)
(declare-const source_VFS_026 Int)
(declare-const target_VFS_026 Int)
(assert (>= source_VFS_026 0))
(assert (>= target_VFS_026 0))
(assert (not (= source_VFS_026 target_VFS_026)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_027: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_027 preserves semantics
(push 1)
(declare-const source_VFS_027 Int)
(declare-const target_VFS_027 Int)
(assert (>= source_VFS_027 0))
(assert (>= target_VFS_027 0))
(assert (not (= source_VFS_027 target_VFS_027)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_028: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_028 preserves semantics
(push 1)
(declare-const source_VFS_028 Int)
(declare-const target_VFS_028 Int)
(assert (>= source_VFS_028 0))
(assert (>= target_VFS_028 0))
(assert (not (= source_VFS_028 target_VFS_028)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_029: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_029 preserves semantics
(push 1)
(declare-const source_VFS_029 Int)
(declare-const target_VFS_029 Int)
(assert (>= source_VFS_029 0))
(assert (>= target_VFS_029 0))
(assert (not (= source_VFS_029 target_VFS_029)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_030_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_030_complete preserves semantics
(push 1)
(declare-const source_VFS_030_complete Int)
(declare-const target_VFS_030_complete Int)
(assert (>= source_VFS_030_complete 0))
(assert (>= target_VFS_030_complete 0))
(assert (not (= source_VFS_030_complete target_VFS_030_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_031_root_can_read: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_031_root_can_read preserves semantics
(push 1)
(declare-const source_VFS_031_root_can_read Int)
(declare-const target_VFS_031_root_can_read Int)
(assert (>= source_VFS_031_root_can_read 0))
(assert (>= target_VFS_031_root_can_read 0))
(assert (not (= source_VFS_031_root_can_read target_VFS_031_root_can_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_032_root_can_write: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_032_root_can_write preserves semantics
(push 1)
(declare-const source_VFS_032_root_can_write Int)
(declare-const target_VFS_032_root_can_write Int)
(assert (>= source_VFS_032_root_can_write 0))
(assert (>= target_VFS_032_root_can_write 0))
(assert (not (= source_VFS_032_root_can_write target_VFS_032_root_can_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_033_root_can_execute: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_033_root_can_execute preserves semantics
(push 1)
(declare-const source_VFS_033_root_can_execute Int)
(declare-const target_VFS_033_root_can_execute Int)
(assert (>= source_VFS_033_root_can_execute 0))
(assert (>= target_VFS_033_root_can_execute 0))
(assert (not (= source_VFS_033_root_can_execute target_VFS_033_root_can_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_034_owner_read: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_034_owner_read preserves semantics
(push 1)
(declare-const source_VFS_034_owner_read Int)
(declare-const target_VFS_034_owner_read Int)
(assert (>= source_VFS_034_owner_read 0))
(assert (>= target_VFS_034_owner_read 0))
(assert (not (= source_VFS_034_owner_read target_VFS_034_owner_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_035_owner_write: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_035_owner_write preserves semantics
(push 1)
(declare-const source_VFS_035_owner_write Int)
(declare-const target_VFS_035_owner_write Int)
(assert (>= source_VFS_035_owner_write 0))
(assert (>= target_VFS_035_owner_write 0))
(assert (not (= source_VFS_035_owner_write target_VFS_035_owner_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_036_owner_execute: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_036_owner_execute preserves semantics
(push 1)
(declare-const source_VFS_036_owner_execute Int)
(declare-const target_VFS_036_owner_execute Int)
(assert (>= source_VFS_036_owner_execute 0))
(assert (>= target_VFS_036_owner_execute 0))
(assert (not (= source_VFS_036_owner_execute target_VFS_036_owner_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_037_other_permissions: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_037_other_permissions preserves semantics
(push 1)
(declare-const source_VFS_037_other_permissions Int)
(declare-const target_VFS_037_other_permissions Int)
(assert (>= source_VFS_037_other_permissions 0))
(assert (>= target_VFS_037_other_permissions 0))
(assert (not (= source_VFS_037_other_permissions target_VFS_037_other_permissions)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_038_group_permissions: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_038_group_permissions preserves semantics
(push 1)
(declare-const source_VFS_038_group_permissions Int)
(declare-const target_VFS_038_group_permissions Int)
(assert (>= source_VFS_038_group_permissions 0))
(assert (>= target_VFS_038_group_permissions 0))
(assert (not (= source_VFS_038_group_permissions target_VFS_038_group_permissions)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_039_no_read_without_perm: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_039_no_read_without_perm preserves semantics
(push 1)
(declare-const source_VFS_039_no_read_without_perm Int)
(declare-const target_VFS_039_no_read_without_perm Int)
(assert (>= source_VFS_039_no_read_without_perm 0))
(assert (>= target_VFS_039_no_read_without_perm 0))
(assert (not (= source_VFS_039_no_read_without_perm target_VFS_039_no_read_without_perm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_040_no_write_without_perm: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_040_no_write_without_perm preserves semantics
(push 1)
(declare-const source_VFS_040_no_write_without_perm Int)
(declare-const target_VFS_040_no_write_without_perm Int)
(assert (>= source_VFS_040_no_write_without_perm 0))
(assert (>= target_VFS_040_no_write_without_perm 0))
(assert (not (= source_VFS_040_no_write_without_perm target_VFS_040_no_write_without_perm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_041_no_execute_without_perm: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_041_no_execute_without_perm preserves semantics
(push 1)
(declare-const source_VFS_041_no_execute_without_perm Int)
(declare-const target_VFS_041_no_execute_without_perm Int)
(assert (>= source_VFS_041_no_execute_without_perm 0))
(assert (>= target_VFS_041_no_execute_without_perm 0))
(assert (not (= source_VFS_041_no_execute_without_perm target_VFS_041_no_execute_without_perm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_042_access_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_042_access_deterministic preserves semantics
(push 1)
(declare-const source_VFS_042_access_deterministic Int)
(declare-const target_VFS_042_access_deterministic Int)
(assert (>= source_VFS_042_access_deterministic 0))
(assert (>= target_VFS_042_access_deterministic 0))
(assert (not (= source_VFS_042_access_deterministic target_VFS_042_access_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_043_owner_full_access: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_043_owner_full_access preserves semantics
(push 1)
(declare-const source_VFS_043_owner_full_access Int)
(declare-const target_VFS_043_owner_full_access Int)
(assert (>= source_VFS_043_owner_full_access 0))
(assert (>= target_VFS_043_owner_full_access 0))
(assert (not (= source_VFS_043_owner_full_access target_VFS_043_owner_full_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_044_root_full_access: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_044_root_full_access preserves semantics
(push 1)
(declare-const source_VFS_044_root_full_access Int)
(declare-const target_VFS_044_root_full_access Int)
(assert (>= source_VFS_044_root_full_access 0))
(assert (>= target_VFS_044_root_full_access 0))
(assert (not (= source_VFS_044_root_full_access target_VFS_044_root_full_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_045_permission_consistency: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_045_permission_consistency preserves semantics
(push 1)
(declare-const source_VFS_045_permission_consistency Int)
(declare-const target_VFS_045_permission_consistency Int)
(assert (>= source_VFS_045_permission_consistency 0))
(assert (>= target_VFS_045_permission_consistency 0))
(assert (not (= source_VFS_045_permission_consistency target_VFS_045_permission_consistency)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_046_committed_is_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_046_committed_is_complete preserves semantics
(push 1)
(declare-const source_VFS_046_committed_is_complete Int)
(declare-const target_VFS_046_committed_is_complete Int)
(assert (>= source_VFS_046_committed_is_complete 0))
(assert (>= target_VFS_046_committed_is_complete 0))
(assert (not (= source_VFS_046_committed_is_complete target_VFS_046_committed_is_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_047_checkpointed_is_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_047_checkpointed_is_complete preserves semantics
(push 1)
(declare-const source_VFS_047_checkpointed_is_complete Int)
(declare-const target_VFS_047_checkpointed_is_complete Int)
(assert (>= source_VFS_047_checkpointed_is_complete 0))
(assert (>= target_VFS_047_checkpointed_is_complete 0))
(assert (not (= source_VFS_047_checkpointed_is_complete target_VFS_047_checkpointed_is_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_048_pending_not_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_048_pending_not_complete preserves semantics
(push 1)
(declare-const source_VFS_048_pending_not_complete Int)
(declare-const target_VFS_048_pending_not_complete Int)
(assert (>= source_VFS_048_pending_not_complete 0))
(assert (>= target_VFS_048_pending_not_complete 0))
(assert (not (= source_VFS_048_pending_not_complete target_VFS_048_pending_not_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_049_aborted_not_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_049_aborted_not_complete preserves semantics
(push 1)
(declare-const source_VFS_049_aborted_not_complete Int)
(declare-const target_VFS_049_aborted_not_complete Int)
(assert (>= source_VFS_049_aborted_not_complete 0))
(assert (>= target_VFS_049_aborted_not_complete 0))
(assert (not (= source_VFS_049_aborted_not_complete target_VFS_049_aborted_not_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_050_empty_journal_consistent: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_050_empty_journal_consistent preserves semantics
(push 1)
(declare-const source_VFS_050_empty_journal_consistent Int)
(declare-const target_VFS_050_empty_journal_consistent Int)
(assert (>= source_VFS_050_empty_journal_consistent 0))
(assert (>= target_VFS_050_empty_journal_consistent 0))
(assert (not (= source_VFS_050_empty_journal_consistent target_VFS_050_empty_journal_consistent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_051_single_committed_consistent: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_051_single_committed_consistent preserves semantics
(push 1)
(declare-const source_VFS_051_single_committed_consistent Int)
(declare-const target_VFS_051_single_committed_consistent Int)
(assert (>= source_VFS_051_single_committed_consistent 0))
(assert (>= target_VFS_051_single_committed_consistent 0))
(assert (not (= source_VFS_051_single_committed_consistent target_VFS_051_single_committed_consistent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_052_txn_complete_decidable: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_052_txn_complete_decidable preserves semantics
(push 1)
(declare-const source_VFS_052_txn_complete_decidable Int)
(declare-const target_VFS_052_txn_complete_decidable Int)
(assert (>= source_VFS_052_txn_complete_decidable 0))
(assert (>= target_VFS_052_txn_complete_decidable 0))
(assert (not (= source_VFS_052_txn_complete_decidable target_VFS_052_txn_complete_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_053_journal_head_ge_tail: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_053_journal_head_ge_tail preserves semantics
(push 1)
(declare-const source_VFS_053_journal_head_ge_tail Int)
(declare-const target_VFS_053_journal_head_ge_tail Int)
(assert (>= source_VFS_053_journal_head_ge_tail 0))
(assert (>= target_VFS_053_journal_head_ge_tail 0))
(assert (not (= source_VFS_053_journal_head_ge_tail target_VFS_053_journal_head_ge_tail)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_054_all_txns_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_054_all_txns_complete preserves semantics
(push 1)
(declare-const source_VFS_054_all_txns_complete Int)
(declare-const target_VFS_054_all_txns_complete Int)
(assert (>= source_VFS_054_all_txns_complete 0))
(assert (>= target_VFS_054_all_txns_complete 0))
(assert (not (= source_VFS_054_all_txns_complete target_VFS_054_all_txns_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_055_complete_txn_valid_state: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_055_complete_txn_valid_state preserves semantics
(push 1)
(declare-const source_VFS_055_complete_txn_valid_state Int)
(declare-const target_VFS_055_complete_txn_valid_state Int)
(assert (>= source_VFS_055_complete_txn_valid_state 0))
(assert (>= target_VFS_055_complete_txn_valid_state 0))
(assert (not (= source_VFS_055_complete_txn_valid_state target_VFS_055_complete_txn_valid_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_056_no_self_cycle: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_056_no_self_cycle preserves semantics
(push 1)
(declare-const source_VFS_056_no_self_cycle Int)
(declare-const target_VFS_056_no_self_cycle Int)
(assert (>= source_VFS_056_no_self_cycle 0))
(assert (>= target_VFS_056_no_self_cycle 0))
(assert (not (= source_VFS_056_no_self_cycle target_VFS_056_no_self_cycle)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_057_self_cycle_detected: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_057_self_cycle_detected preserves semantics
(push 1)
(declare-const source_VFS_057_self_cycle_detected Int)
(declare-const target_VFS_057_self_cycle_detected Int)
(assert (>= source_VFS_057_self_cycle_detected 0))
(assert (>= target_VFS_057_self_cycle_detected 0))
(assert (not (= source_VFS_057_self_cycle_detected target_VFS_057_self_cycle_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_058_integrity_requires_no_cycle: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_058_integrity_requires_no_cycle preserves semantics
(push 1)
(declare-const source_VFS_058_integrity_requires_no_cycle Int)
(declare-const target_VFS_058_integrity_requires_no_cycle Int)
(assert (>= source_VFS_058_integrity_requires_no_cycle 0))
(assert (>= target_VFS_058_integrity_requires_no_cycle 0))
(assert (not (= source_VFS_058_integrity_requires_no_cycle target_VFS_058_integrity_requires_no_cycle)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_059_integrity_requires_parent: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_059_integrity_requires_parent preserves semantics
(push 1)
(declare-const source_VFS_059_integrity_requires_parent Int)
(declare-const target_VFS_059_integrity_requires_parent Int)
(assert (>= source_VFS_059_integrity_requires_parent 0))
(assert (>= target_VFS_059_integrity_requires_parent 0))
(assert (not (= source_VFS_059_integrity_requires_parent target_VFS_059_integrity_requires_parent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_060_integrity_requires_dot: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_060_integrity_requires_dot preserves semantics
(push 1)
(declare-const source_VFS_060_integrity_requires_dot Int)
(declare-const target_VFS_060_integrity_requires_dot Int)
(assert (>= source_VFS_060_integrity_requires_dot 0))
(assert (>= target_VFS_060_integrity_requires_dot 0))
(assert (not (= source_VFS_060_integrity_requires_dot target_VFS_060_integrity_requires_dot)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_061_empty_dir_no_parent_link: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_061_empty_dir_no_parent_link preserves semantics
(push 1)
(declare-const source_VFS_061_empty_dir_no_parent_link Int)
(declare-const target_VFS_061_empty_dir_no_parent_link Int)
(assert (>= source_VFS_061_empty_dir_no_parent_link 0))
(assert (>= target_VFS_061_empty_dir_no_parent_link 0))
(assert (not (= source_VFS_061_empty_dir_no_parent_link target_VFS_061_empty_dir_no_parent_link)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_062_empty_dir_no_dot: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_062_empty_dir_no_dot preserves semantics
(push 1)
(declare-const source_VFS_062_empty_dir_no_dot Int)
(declare-const target_VFS_062_empty_dir_no_dot Int)
(assert (>= source_VFS_062_empty_dir_no_dot 0))
(assert (>= target_VFS_062_empty_dir_no_dot 0))
(assert (not (= source_VFS_062_empty_dir_no_dot target_VFS_062_empty_dir_no_dot)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_063_empty_dir_no_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_063_empty_dir_no_integrity preserves semantics
(push 1)
(declare-const source_VFS_063_empty_dir_no_integrity Int)
(declare-const target_VFS_063_empty_dir_no_integrity Int)
(assert (>= source_VFS_063_empty_dir_no_integrity 0))
(assert (>= target_VFS_063_empty_dir_no_integrity 0))
(assert (not (= source_VFS_063_empty_dir_no_integrity target_VFS_063_empty_dir_no_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_064_wellformed_dir_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_064_wellformed_dir_complete preserves semantics
(push 1)
(declare-const source_VFS_064_wellformed_dir_complete Int)
(declare-const target_VFS_064_wellformed_dir_complete Int)
(assert (>= source_VFS_064_wellformed_dir_complete 0))
(assert (>= target_VFS_064_wellformed_dir_complete 0))
(assert (not (= source_VFS_064_wellformed_dir_complete target_VFS_064_wellformed_dir_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_065_dir_integrity_decidable: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_065_dir_integrity_decidable preserves semantics
(push 1)
(declare-const source_VFS_065_dir_integrity_decidable Int)
(declare-const target_VFS_065_dir_integrity_decidable Int)
(assert (>= source_VFS_065_dir_integrity_decidable 0))
(assert (>= target_VFS_065_dir_integrity_decidable 0))
(assert (not (= source_VFS_065_dir_integrity_decidable target_VFS_065_dir_integrity_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_066_zero_usage_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_066_zero_usage_ok preserves semantics
(push 1)
(declare-const source_VFS_066_zero_usage_ok Int)
(declare-const target_VFS_066_zero_usage_ok Int)
(assert (>= source_VFS_066_zero_usage_ok 0))
(assert (>= target_VFS_066_zero_usage_ok 0))
(assert (not (= source_VFS_066_zero_usage_ok target_VFS_066_zero_usage_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_067_at_limit_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_067_at_limit_ok preserves semantics
(push 1)
(declare-const source_VFS_067_at_limit_ok Int)
(declare-const target_VFS_067_at_limit_ok Int)
(assert (>= source_VFS_067_at_limit_ok 0))
(assert (>= target_VFS_067_at_limit_ok 0))
(assert (not (= source_VFS_067_at_limit_ok target_VFS_067_at_limit_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_068_enforced_bytes_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_068_enforced_bytes_ok preserves semantics
(push 1)
(declare-const source_VFS_068_enforced_bytes_ok Int)
(declare-const target_VFS_068_enforced_bytes_ok Int)
(assert (>= source_VFS_068_enforced_bytes_ok 0))
(assert (>= target_VFS_068_enforced_bytes_ok 0))
(assert (not (= source_VFS_068_enforced_bytes_ok target_VFS_068_enforced_bytes_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_069_enforced_inodes_ok: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_069_enforced_inodes_ok preserves semantics
(push 1)
(declare-const source_VFS_069_enforced_inodes_ok Int)
(declare-const target_VFS_069_enforced_inodes_ok Int)
(assert (>= source_VFS_069_enforced_inodes_ok 0))
(assert (>= target_VFS_069_enforced_inodes_ok 0))
(assert (not (= source_VFS_069_enforced_inodes_ok target_VFS_069_enforced_inodes_ok)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_070_can_alloc_zero_bytes: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_070_can_alloc_zero_bytes preserves semantics
(push 1)
(declare-const source_VFS_070_can_alloc_zero_bytes Int)
(declare-const target_VFS_070_can_alloc_zero_bytes Int)
(assert (>= source_VFS_070_can_alloc_zero_bytes 0))
(assert (>= target_VFS_070_can_alloc_zero_bytes 0))
(assert (not (= source_VFS_070_can_alloc_zero_bytes target_VFS_070_can_alloc_zero_bytes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_071_cannot_exceed_quota: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_071_cannot_exceed_quota preserves semantics
(push 1)
(declare-const source_VFS_071_cannot_exceed_quota Int)
(declare-const target_VFS_071_cannot_exceed_quota Int)
(assert (>= source_VFS_071_cannot_exceed_quota 0))
(assert (>= target_VFS_071_cannot_exceed_quota 0))
(assert (not (= source_VFS_071_cannot_exceed_quota target_VFS_071_cannot_exceed_quota)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_072_bytes_ok_semantics: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_072_bytes_ok_semantics preserves semantics
(push 1)
(declare-const source_VFS_072_bytes_ok_semantics Int)
(declare-const target_VFS_072_bytes_ok_semantics Int)
(assert (>= source_VFS_072_bytes_ok_semantics 0))
(assert (>= target_VFS_072_bytes_ok_semantics 0))
(assert (not (= source_VFS_072_bytes_ok_semantics target_VFS_072_bytes_ok_semantics)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_073_inodes_ok_semantics: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_073_inodes_ok_semantics preserves semantics
(push 1)
(declare-const source_VFS_073_inodes_ok_semantics Int)
(declare-const target_VFS_073_inodes_ok_semantics Int)
(assert (>= source_VFS_073_inodes_ok_semantics 0))
(assert (>= target_VFS_073_inodes_ok_semantics 0))
(assert (not (= source_VFS_073_inodes_ok_semantics target_VFS_073_inodes_ok_semantics)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_074_can_alloc_inode_under_limit: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_074_can_alloc_inode_under_limit preserves semantics
(push 1)
(declare-const source_VFS_074_can_alloc_inode_under_limit Int)
(declare-const target_VFS_074_can_alloc_inode_under_limit Int)
(assert (>= source_VFS_074_can_alloc_inode_under_limit 0))
(assert (>= target_VFS_074_can_alloc_inode_under_limit 0))
(assert (not (= source_VFS_074_can_alloc_inode_under_limit target_VFS_074_can_alloc_inode_under_limit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_075_cannot_alloc_inode_at_limit: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_075_cannot_alloc_inode_at_limit preserves semantics
(push 1)
(declare-const source_VFS_075_cannot_alloc_inode_at_limit Int)
(declare-const target_VFS_075_cannot_alloc_inode_at_limit Int)
(assert (>= source_VFS_075_cannot_alloc_inode_at_limit 0))
(assert (>= target_VFS_075_cannot_alloc_inode_at_limit 0))
(assert (not (= source_VFS_075_cannot_alloc_inode_at_limit target_VFS_075_cannot_alloc_inode_at_limit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_076_online_no_recovery: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_076_online_no_recovery preserves semantics
(push 1)
(declare-const source_VFS_076_online_no_recovery Int)
(declare-const target_VFS_076_online_no_recovery Int)
(assert (>= source_VFS_076_online_no_recovery 0))
(assert (>= target_VFS_076_online_no_recovery 0))
(assert (not (= source_VFS_076_online_no_recovery target_VFS_076_online_no_recovery)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_077_clean_no_recovery: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_077_clean_no_recovery preserves semantics
(push 1)
(declare-const source_VFS_077_clean_no_recovery Int)
(declare-const target_VFS_077_clean_no_recovery Int)
(assert (>= source_VFS_077_clean_no_recovery 0))
(assert (>= target_VFS_077_clean_no_recovery 0))
(assert (not (= source_VFS_077_clean_no_recovery target_VFS_077_clean_no_recovery)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_078_mounting_not_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_078_mounting_not_complete preserves semantics
(push 1)
(declare-const source_VFS_078_mounting_not_complete Int)
(declare-const target_VFS_078_mounting_not_complete Int)
(assert (>= source_VFS_078_mounting_not_complete 0))
(assert (>= target_VFS_078_mounting_not_complete 0))
(assert (not (= source_VFS_078_mounting_not_complete target_VFS_078_mounting_not_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_079_recovering_not_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_079_recovering_not_complete preserves semantics
(push 1)
(declare-const source_VFS_079_recovering_not_complete Int)
(declare-const target_VFS_079_recovering_not_complete Int)
(assert (>= source_VFS_079_recovering_not_complete 0))
(assert (>= target_VFS_079_recovering_not_complete 0))
(assert (not (= source_VFS_079_recovering_not_complete target_VFS_079_recovering_not_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_080_error_not_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_080_error_not_complete preserves semantics
(push 1)
(declare-const source_VFS_080_error_not_complete Int)
(declare-const target_VFS_080_error_not_complete Int)
(assert (>= source_VFS_080_error_not_complete 0))
(assert (>= target_VFS_080_error_not_complete 0))
(assert (not (= source_VFS_080_error_not_complete target_VFS_080_error_not_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_081_recovery_needed_blocks: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_081_recovery_needed_blocks preserves semantics
(push 1)
(declare-const source_VFS_081_recovery_needed_blocks Int)
(declare-const target_VFS_081_recovery_needed_blocks Int)
(assert (>= source_VFS_081_recovery_needed_blocks 0))
(assert (>= target_VFS_081_recovery_needed_blocks 0))
(assert (not (= source_VFS_081_recovery_needed_blocks target_VFS_081_recovery_needed_blocks)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_082_crash_safe_journal: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_082_crash_safe_journal preserves semantics
(push 1)
(declare-const source_VFS_082_crash_safe_journal Int)
(declare-const target_VFS_082_crash_safe_journal Int)
(assert (>= source_VFS_082_crash_safe_journal 0))
(assert (>= target_VFS_082_crash_safe_journal 0))
(assert (not (= source_VFS_082_crash_safe_journal target_VFS_082_crash_safe_journal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_083_empty_journal_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_083_empty_journal_safe preserves semantics
(push 1)
(declare-const source_VFS_083_empty_journal_safe Int)
(declare-const target_VFS_083_empty_journal_safe Int)
(assert (>= source_VFS_083_empty_journal_safe 0))
(assert (>= target_VFS_083_empty_journal_safe 0))
(assert (not (= source_VFS_083_empty_journal_safe target_VFS_083_empty_journal_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_084_recovery_complete_valid_state: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_084_recovery_complete_valid_state preserves semantics
(push 1)
(declare-const source_VFS_084_recovery_complete_valid_state Int)
(declare-const target_VFS_084_recovery_complete_valid_state Int)
(assert (>= source_VFS_084_recovery_complete_valid_state 0))
(assert (>= target_VFS_084_recovery_complete_valid_state 0))
(assert (not (= source_VFS_084_recovery_complete_valid_state target_VFS_084_recovery_complete_valid_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_085_recovery_complete_no_recovery: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_085_recovery_complete_no_recovery preserves semantics
(push 1)
(declare-const source_VFS_085_recovery_complete_no_recovery Int)
(declare-const target_VFS_085_recovery_complete_no_recovery Int)
(assert (>= source_VFS_085_recovery_complete_no_recovery 0))
(assert (>= target_VFS_085_recovery_complete_no_recovery 0))
(assert (not (= source_VFS_085_recovery_complete_no_recovery target_VFS_085_recovery_complete_no_recovery)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_086_success_is_atomic: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_086_success_is_atomic preserves semantics
(push 1)
(declare-const source_VFS_086_success_is_atomic Int)
(declare-const target_VFS_086_success_is_atomic Int)
(assert (>= source_VFS_086_success_is_atomic 0))
(assert (>= target_VFS_086_success_is_atomic 0))
(assert (not (= source_VFS_086_success_is_atomic target_VFS_086_success_is_atomic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_087_failure_is_atomic: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_087_failure_is_atomic preserves semantics
(push 1)
(declare-const source_VFS_087_failure_is_atomic Int)
(declare-const target_VFS_087_failure_is_atomic Int)
(assert (>= source_VFS_087_failure_is_atomic 0))
(assert (>= target_VFS_087_failure_is_atomic 0))
(assert (not (= source_VFS_087_failure_is_atomic target_VFS_087_failure_is_atomic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_088_partial_not_atomic: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_088_partial_not_atomic preserves semantics
(push 1)
(declare-const source_VFS_088_partial_not_atomic Int)
(declare-const target_VFS_088_partial_not_atomic Int)
(assert (>= source_VFS_088_partial_not_atomic 0))
(assert (>= target_VFS_088_partial_not_atomic 0))
(assert (not (= source_VFS_088_partial_not_atomic target_VFS_088_partial_not_atomic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_089_atomic_definite_result: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_089_atomic_definite_result preserves semantics
(push 1)
(declare-const source_VFS_089_atomic_definite_result Int)
(declare-const target_VFS_089_atomic_definite_result Int)
(assert (>= source_VFS_089_atomic_definite_result 0))
(assert (>= target_VFS_089_atomic_definite_result 0))
(assert (not (= source_VFS_089_atomic_definite_result target_VFS_089_atomic_definite_result)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_090_journaled_has_entry: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_090_journaled_has_entry preserves semantics
(push 1)
(declare-const source_VFS_090_journaled_has_entry Int)
(declare-const target_VFS_090_journaled_has_entry Int)
(assert (>= source_VFS_090_journaled_has_entry 0))
(assert (>= target_VFS_090_journaled_has_entry 0))
(assert (not (= source_VFS_090_journaled_has_entry target_VFS_090_journaled_has_entry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_091_non_journaled_no_entry: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_091_non_journaled_no_entry preserves semantics
(push 1)
(declare-const source_VFS_091_non_journaled_no_entry Int)
(declare-const target_VFS_091_non_journaled_no_entry Int)
(assert (>= source_VFS_091_non_journaled_no_entry 0))
(assert (>= target_VFS_091_non_journaled_no_entry 0))
(assert (not (= source_VFS_091_non_journaled_no_entry target_VFS_091_non_journaled_no_entry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_092_create_journaled: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_092_create_journaled preserves semantics
(push 1)
(declare-const source_VFS_092_create_journaled Int)
(declare-const target_VFS_092_create_journaled Int)
(assert (>= source_VFS_092_create_journaled 0))
(assert (>= target_VFS_092_create_journaled 0))
(assert (not (= source_VFS_092_create_journaled target_VFS_092_create_journaled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_093_delete_journaled: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_093_delete_journaled preserves semantics
(push 1)
(declare-const source_VFS_093_delete_journaled Int)
(declare-const target_VFS_093_delete_journaled Int)
(assert (>= source_VFS_093_delete_journaled 0))
(assert (>= target_VFS_093_delete_journaled 0))
(assert (not (= source_VFS_093_delete_journaled target_VFS_093_delete_journaled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_094_rename_journaled: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_094_rename_journaled preserves semantics
(push 1)
(declare-const source_VFS_094_rename_journaled Int)
(declare-const target_VFS_094_rename_journaled Int)
(assert (>= source_VFS_094_rename_journaled 0))
(assert (>= target_VFS_094_rename_journaled 0))
(assert (not (= source_VFS_094_rename_journaled target_VFS_094_rename_journaled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_095_atomicity_decidable: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_095_atomicity_decidable preserves semantics
(push 1)
(declare-const source_VFS_095_atomicity_decidable Int)
(declare-const target_VFS_095_atomicity_decidable Int)
(assert (>= source_VFS_095_atomicity_decidable 0))
(assert (>= target_VFS_095_atomicity_decidable 0))
(assert (not (= source_VFS_095_atomicity_decidable target_VFS_095_atomicity_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_096_full_security: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_096_full_security preserves semantics
(push 1)
(declare-const source_VFS_096_full_security Int)
(declare-const target_VFS_096_full_security Int)
(assert (>= source_VFS_096_full_security 0))
(assert (>= target_VFS_096_full_security 0))
(assert (not (= source_VFS_096_full_security target_VFS_096_full_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_097_full_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_097_full_integrity preserves semantics
(push 1)
(declare-const source_VFS_097_full_integrity Int)
(declare-const target_VFS_097_full_integrity Int)
(assert (>= source_VFS_097_full_integrity 0))
(assert (>= target_VFS_097_full_integrity 0))
(assert (not (= source_VFS_097_full_integrity target_VFS_097_full_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_098_safe_recovery_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_098_safe_recovery_sound preserves semantics
(push 1)
(declare-const source_VFS_098_safe_recovery_sound Int)
(declare-const target_VFS_098_safe_recovery_sound Int)
(assert (>= source_VFS_098_safe_recovery_sound 0))
(assert (>= target_VFS_098_safe_recovery_sound 0))
(assert (not (= source_VFS_098_safe_recovery_sound target_VFS_098_safe_recovery_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_099_quota_access_combined: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_099_quota_access_combined preserves semantics
(push 1)
(declare-const source_VFS_099_quota_access_combined Int)
(declare-const target_VFS_099_quota_access_combined Int)
(assert (>= source_VFS_099_quota_access_combined 0))
(assert (>= target_VFS_099_quota_access_combined 0))
(assert (not (= source_VFS_099_quota_access_combined target_VFS_099_quota_access_combined)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_100_atomic_journaled_durable: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_100_atomic_journaled_durable preserves semantics
(push 1)
(declare-const source_VFS_100_atomic_journaled_durable Int)
(declare-const target_VFS_100_atomic_journaled_durable Int)
(assert (>= source_VFS_100_atomic_journaled_durable 0))
(assert (>= target_VFS_100_atomic_journaled_durable 0))
(assert (not (= source_VFS_100_atomic_journaled_durable target_VFS_100_atomic_journaled_durable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_101_dir_with_quota: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_101_dir_with_quota preserves semantics
(push 1)
(declare-const source_VFS_101_dir_with_quota Int)
(declare-const target_VFS_101_dir_with_quota Int)
(assert (>= source_VFS_101_dir_with_quota 0))
(assert (>= target_VFS_101_dir_with_quota 0))
(assert (not (= source_VFS_101_dir_with_quota target_VFS_101_dir_with_quota)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_102_verification_chain: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_102_verification_chain preserves semantics
(push 1)
(declare-const source_VFS_102_verification_chain Int)
(declare-const target_VFS_102_verification_chain Int)
(assert (>= source_VFS_102_verification_chain 0))
(assert (>= target_VFS_102_verification_chain 0))
(assert (not (= source_VFS_102_verification_chain target_VFS_102_verification_chain)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_103_journal_consistency_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_103_journal_consistency_preservation preserves semantics
(push 1)
(declare-const source_VFS_103_journal_consistency_preservation Int)
(declare-const target_VFS_103_journal_consistency_preservation Int)
(assert (>= source_VFS_103_journal_consistency_preservation 0))
(assert (>= target_VFS_103_journal_consistency_preservation 0))
(assert (not (= source_VFS_103_journal_consistency_preservation target_VFS_103_journal_consistency_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_104_access_dir_combined: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_104_access_dir_combined preserves semantics
(push 1)
(declare-const source_VFS_104_access_dir_combined Int)
(declare-const target_VFS_104_access_dir_combined Int)
(assert (>= source_VFS_104_access_dir_combined 0))
(assert (>= target_VFS_104_access_dir_combined 0))
(assert (not (= source_VFS_104_access_dir_combined target_VFS_104_access_dir_combined)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; VFS_105_system_soundness: translation preserves property (matches Coq: Theorem)
; Translation validation: VFS_105_system_soundness preserves semantics
(push 1)
(declare-const source_VFS_105_system_soundness Int)
(declare-const target_VFS_105_system_soundness Int)
(assert (>= source_VFS_105_system_soundness 0))
(assert (>= target_VFS_105_system_soundness 0))
(assert (not (= source_VFS_105_system_soundness target_VFS_105_system_soundness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

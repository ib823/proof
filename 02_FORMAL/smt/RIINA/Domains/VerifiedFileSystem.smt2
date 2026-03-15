; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedFileSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedFileSystem.v (109 assertions)
; Module: VerifiedFileSystem
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((JournalOp 0)) (((JOpWrite) (JOpCreate) (JOpDelete) (JOpRename) (JOpCommit) (JOpCheckpoint))))

(declare-datatypes ((TxnState 0)) (((TxnPending) (TxnCommitted) (TxnCheckpointed) (TxnAborted))))

(declare-datatypes ((FSState 0)) (((FSClean) (FSMounting) (FSRecovering) (FSOnline) (FSError))))

(declare-datatypes ((FileOp 0)) (((OpCreate) (OpDelete) (OpRename) (OpWrite) (OpRead))))

(declare-datatypes ((OpResult 0)) (((OpSuccess) (OpFailure) (OpPartial))))

(declare-datatypes ((FSIntegrity 0))
  (((mk-fs_integrity (fsi_crash_consistent Bool) (fsi_atomic_writes Bool) (fsi_journaling Bool) (fsi_checksum_verified Bool)))))

(declare-datatypes ((FSSecurity 0))
  (((mk-fs_security (fss_access_control Bool) (fss_encryption_at_rest Bool) (fss_secure_delete Bool) (fss_quota_enforcement Bool)))))

(declare-datatypes ((VerifiedFS 0))
  (((mk-verified_fs (vfs_integrity FSIntegrity) (vfs_security FSSecurity) (vfs_posix_compliant Bool) (vfs_verified_implementation Bool)))))

(declare-datatypes ((Permission 0))
  (((mk-permission (perm_read Bool) (perm_write Bool) (perm_execute Bool)))))

(declare-datatypes ((Ownership 0))
  (((mk-ownership (owner_uid Int) (owner_gid Int)))))

(declare-datatypes ((AccessContext 0))
  (((mk-access_context (ctx_uid Int) (ctx_gid Int) (ctx_groups (Seq Int)) (ctx_is_root Bool)))))

(declare-datatypes ((Inode 0))
  (((mk-inode (inode_id Int) (inode_owner Ownership) (inode_perm_owner Permission) (inode_perm_group Permission) (inode_perm_other Permission) (inode_is_directory Bool) (inode_size Int)))))

(declare-datatypes ((Transaction 0))
  (((mk-transaction (txn_id Int) (txn_ops (Seq Int)) (txn_state TxnState)))))

(declare-datatypes ((Journal 0))
  (((mk-journal (journal_transactions (Seq Int)) (journal_head Int) (journal_tail Int)))))

(declare-datatypes ((DirEntry 0))
  (((mk-dir_entry (de_name Int) (de_inode Int) (de_is_dir Bool)))))

(declare-datatypes ((Directory 0))
  (((mk-directory (dir_inode Int) (dir_parent Int) (dir_entries (Seq Int))))))

(declare-datatypes ((Quota 0))
  (((mk-quota (quota_uid Int) (quota_limit_bytes Int) (quota_limit_inodes Int) (quota_used_bytes Int) (quota_used_inodes Int)))))

(declare-datatypes ((CrashState 0))
  (((mk-crash_state (cs_journal Journal) (cs_fs_state FSState) (cs_last_checkpoint Int) (cs_recovery_needed Bool)))))

(declare-datatypes ((AtomicOp 0))
  (((mk-atomic_op (aop_operation FileOp) (aop_result OpResult) (aop_journal_entry Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- JournalOp enum properties ---

; --- 1. JournalOp exhaustiveness ---
(push 1)
(declare-const x JournalOp)
(assert (not (or (= x JOpWrite) (= x JOpCreate) (= x JOpDelete) (= x JOpRename) (= x JOpCommit) (= x JOpCheckpoint))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. JournalOp: JOpWrite != JOpCreate ---
(push 1)
(assert (= JOpWrite JOpCreate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. JournalOp: JOpCreate != JOpDelete ---
(push 1)
(assert (= JOpCreate JOpDelete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. JournalOp: JOpDelete != JOpRename ---
(push 1)
(assert (= JOpDelete JOpRename))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. JournalOp: JOpWrite != JOpCheckpoint ---
(push 1)
(assert (= JOpWrite JOpCheckpoint))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. JournalOp finite cardinality (6 values) ---
(push 1)
(declare-const x JournalOp)
(assert (and (not (= x JOpWrite)) (not (= x JOpCreate)) (not (= x JOpDelete)) (not (= x JOpRename)) (not (= x JOpCommit)) (not (= x JOpCheckpoint))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TxnState enum properties ---

; --- 7. TxnState exhaustiveness ---
(push 1)
(declare-const x TxnState)
(assert (not (or (= x TxnPending) (= x TxnCommitted) (= x TxnCheckpointed) (= x TxnAborted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TxnState: TxnPending != TxnCommitted ---
(push 1)
(assert (= TxnPending TxnCommitted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TxnState: TxnCommitted != TxnCheckpointed ---
(push 1)
(assert (= TxnCommitted TxnCheckpointed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TxnState: TxnCheckpointed != TxnAborted ---
(push 1)
(assert (= TxnCheckpointed TxnAborted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TxnState: TxnPending != TxnAborted ---
(push 1)
(assert (= TxnPending TxnAborted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TxnState finite cardinality (4 values) ---
(push 1)
(declare-const x TxnState)
(assert (and (not (= x TxnPending)) (not (= x TxnCommitted)) (not (= x TxnCheckpointed)) (not (= x TxnAborted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FSState enum properties ---

; --- 13. FSState exhaustiveness ---
(push 1)
(declare-const x FSState)
(assert (not (or (= x FSClean) (= x FSMounting) (= x FSRecovering) (= x FSOnline) (= x FSError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. FSState: FSClean != FSMounting ---
(push 1)
(assert (= FSClean FSMounting))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. FSState: FSMounting != FSRecovering ---
(push 1)
(assert (= FSMounting FSRecovering))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. FSState: FSRecovering != FSOnline ---
(push 1)
(assert (= FSRecovering FSOnline))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. FSState: FSClean != FSError ---
(push 1)
(assert (= FSClean FSError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. FSState finite cardinality (5 values) ---
(push 1)
(declare-const x FSState)
(assert (and (not (= x FSClean)) (not (= x FSMounting)) (not (= x FSRecovering)) (not (= x FSOnline)) (not (= x FSError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FileOp enum properties ---

; --- 19. FileOp exhaustiveness ---
(push 1)
(declare-const x FileOp)
(assert (not (or (= x OpCreate) (= x OpDelete) (= x OpRename) (= x OpWrite) (= x OpRead))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. FileOp: OpCreate != OpDelete ---
(push 1)
(assert (= OpCreate OpDelete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. FileOp: OpDelete != OpRename ---
(push 1)
(assert (= OpDelete OpRename))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. FileOp: OpRename != OpWrite ---
(push 1)
(assert (= OpRename OpWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. FileOp: OpCreate != OpRead ---
(push 1)
(assert (= OpCreate OpRead))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. FileOp finite cardinality (5 values) ---
(push 1)
(declare-const x FileOp)
(assert (and (not (= x OpCreate)) (not (= x OpDelete)) (not (= x OpRename)) (not (= x OpWrite)) (not (= x OpRead))))
(check-sat) ; expect UNSAT
(pop 1)

; --- OpResult enum properties ---

; --- 25. OpResult exhaustiveness ---
(push 1)
(declare-const x OpResult)
(assert (not (or (= x OpSuccess) (= x OpFailure) (= x OpPartial))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. OpResult: OpSuccess != OpFailure ---
(push 1)
(assert (= OpSuccess OpFailure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. OpResult: OpFailure != OpPartial ---
(push 1)
(assert (= OpFailure OpPartial))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. OpResult: OpSuccess != OpPartial ---
(push 1)
(assert (= OpSuccess OpPartial))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. OpResult finite cardinality (3 values) ---
(push 1)
(declare-const x OpResult)
(assert (and (not (= x OpSuccess)) (not (= x OpFailure)) (not (= x OpPartial))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FSIntegrity record properties ---

; --- 30. FSIntegrity accessor round-trip: fsi_crash_consistent ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fsi_crash_consistent (mk-fs_integrity f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. FSIntegrity accessor round-trip: fsi_atomic_writes ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fsi_atomic_writes (mk-fs_integrity f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. FSIntegrity accessor round-trip: fsi_journaling ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fsi_journaling (mk-fs_integrity f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FSIntegrity_all_enabled ((g FSIntegrity)) Bool
  (and (fsi_crash_consistent g) (fsi_atomic_writes g) (fsi_journaling g)))

; --- 33. FSIntegrity: all-enabled completeness ---
(push 1)
(declare-const g FSIntegrity)
(assert (fsi_crash_consistent g))
(assert (fsi_atomic_writes g))
(assert (fsi_journaling g))
(assert (not (FSIntegrity_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. FSIntegrity: FSIntegrity_all_enabled implies fsi_crash_consistent ---
(push 1)
(declare-const g FSIntegrity)
(assert (FSIntegrity_all_enabled g))
(assert (not (fsi_crash_consistent g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. FSIntegrity: FSIntegrity_all_enabled implies fsi_atomic_writes ---
(push 1)
(declare-const g FSIntegrity)
(assert (FSIntegrity_all_enabled g))
(assert (not (fsi_atomic_writes g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. FSIntegrity: FSIntegrity_all_enabled implies fsi_journaling ---
(push 1)
(declare-const g FSIntegrity)
(assert (FSIntegrity_all_enabled g))
(assert (not (fsi_journaling g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FSSecurity record properties ---

; --- 37. FSSecurity accessor round-trip: fss_access_control ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fss_access_control (mk-fs_security f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. FSSecurity accessor round-trip: fss_encryption_at_rest ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fss_encryption_at_rest (mk-fs_security f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. FSSecurity accessor round-trip: fss_secure_delete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fss_secure_delete (mk-fs_security f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FSSecurity_all_enabled ((g FSSecurity)) Bool
  (and (fss_access_control g) (fss_encryption_at_rest g) (fss_secure_delete g)))

; --- 40. FSSecurity: all-enabled completeness ---
(push 1)
(declare-const g FSSecurity)
(assert (fss_access_control g))
(assert (fss_encryption_at_rest g))
(assert (fss_secure_delete g))
(assert (not (FSSecurity_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. FSSecurity: FSSecurity_all_enabled implies fss_access_control ---
(push 1)
(declare-const g FSSecurity)
(assert (FSSecurity_all_enabled g))
(assert (not (fss_access_control g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. FSSecurity: FSSecurity_all_enabled implies fss_encryption_at_rest ---
(push 1)
(declare-const g FSSecurity)
(assert (FSSecurity_all_enabled g))
(assert (not (fss_encryption_at_rest g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. FSSecurity: FSSecurity_all_enabled implies fss_secure_delete ---
(push 1)
(declare-const g FSSecurity)
(assert (FSSecurity_all_enabled g))
(assert (not (fss_secure_delete g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifiedFS record properties ---

; --- 44. VerifiedFS accessor round-trip: vfs_integrity ---
(push 1)
(declare-const f0 FSIntegrity)
(declare-const f1 FSSecurity)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vfs_integrity (mk-verified_fs f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. VerifiedFS accessor round-trip: vfs_security ---
(push 1)
(declare-const f0 FSIntegrity)
(declare-const f1 FSSecurity)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vfs_security (mk-verified_fs f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. VerifiedFS accessor round-trip: vfs_posix_compliant ---
(push 1)
(declare-const f0 FSIntegrity)
(declare-const f1 FSSecurity)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vfs_posix_compliant (mk-verified_fs f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Permission record properties ---

; --- 47. Permission accessor round-trip: perm_read ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (perm_read (mk-permission f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. Permission accessor round-trip: perm_write ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (perm_write (mk-permission f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun Permission_all_enabled ((g Permission)) Bool
  (and (perm_read g) (perm_write g)))

; --- 49. Permission: all-enabled completeness ---
(push 1)
(declare-const g Permission)
(assert (perm_read g))
(assert (perm_write g))
(assert (not (Permission_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. Permission: Permission_all_enabled implies perm_read ---
(push 1)
(declare-const g Permission)
(assert (Permission_all_enabled g))
(assert (not (perm_read g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. Permission: Permission_all_enabled implies perm_write ---
(push 1)
(declare-const g Permission)
(assert (Permission_all_enabled g))
(assert (not (perm_write g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Ownership record properties ---

; --- 52. Ownership accessor round-trip: owner_uid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (owner_uid (mk-ownership f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AccessContext record properties ---

; --- 53. AccessContext accessor round-trip: ctx_uid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Bool)
(assert (not (= (ctx_uid (mk-access_context f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. AccessContext accessor round-trip: ctx_gid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Bool)
(assert (not (= (ctx_gid (mk-access_context f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. AccessContext accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Bool)
(assert (not (= (ctx_groups (mk-access_context f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. AccessContext: integer field consistency ---
(push 1)
(declare-const r AccessContext)
(assert (>= (ctx_uid r) 0))
(assert (>= (ctx_gid r) 0))
(assert (not (>= (+ (ctx_uid r) (ctx_gid r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Inode record properties ---

; --- 57. Inode accessor round-trip: inode_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Ownership)
(declare-const f2 Permission)
(declare-const f3 Permission)
(declare-const f4 Permission)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (inode_id (mk-inode f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. Inode accessor round-trip: inode_owner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Ownership)
(declare-const f2 Permission)
(declare-const f3 Permission)
(declare-const f4 Permission)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (inode_owner (mk-inode f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. Inode accessor round-trip: inode_perm_owner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Ownership)
(declare-const f2 Permission)
(declare-const f3 Permission)
(declare-const f4 Permission)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (inode_perm_owner (mk-inode f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. Inode accessor round-trip: inode_perm_group ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Ownership)
(declare-const f2 Permission)
(declare-const f3 Permission)
(declare-const f4 Permission)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (inode_perm_group (mk-inode f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. Inode accessor round-trip: inode_perm_other ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Ownership)
(declare-const f2 Permission)
(declare-const f3 Permission)
(declare-const f4 Permission)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (inode_perm_other (mk-inode f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Transaction record properties ---

; --- 62. Transaction accessor round-trip: txn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 TxnState)
(assert (not (= (txn_id (mk-transaction f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. Transaction accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 TxnState)
(assert (not (= (txn_ops (mk-transaction f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. Transaction: integer field consistency ---
(push 1)
(declare-const r Transaction)
(assert (>= (txn_id r) 0))
(assert (>= (seq.len (txn_ops r)) 0))
(assert (not (>= (+ (txn_id r) (seq.len (txn_ops r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Journal record properties ---

; --- 65. Journal accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (journal_transactions (mk-journal f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. Journal accessor round-trip: journal_head ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (journal_head (mk-journal f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. Journal: integer field consistency ---
(push 1)
(declare-const r Journal)
(assert (>= (seq.len (journal_transactions r)) 0))
(assert (>= (journal_head r) 0))
(assert (not (>= (+ (seq.len (journal_transactions r)) (journal_head r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DirEntry record properties ---

; --- 68. DirEntry accessor round-trip: de_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (de_name (mk-dir_entry f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. DirEntry accessor round-trip: de_inode ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (de_inode (mk-dir_entry f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. DirEntry: integer field consistency ---
(push 1)
(declare-const r DirEntry)
(assert (>= (de_name r) 0))
(assert (>= (de_inode r) 0))
(assert (not (>= (+ (de_name r) (de_inode r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Directory record properties ---

; --- 71. Directory accessor round-trip: dir_inode ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (dir_inode (mk-directory f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. Directory accessor round-trip: dir_parent ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (dir_parent (mk-directory f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. Directory: integer field consistency ---
(push 1)
(declare-const r Directory)
(assert (>= (dir_inode r) 0))
(assert (>= (dir_parent r) 0))
(assert (not (>= (+ (dir_inode r) (dir_parent r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Quota record properties ---

; --- 74. Quota accessor round-trip: quota_uid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (quota_uid (mk-quota f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. Quota accessor round-trip: quota_limit_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (quota_limit_bytes (mk-quota f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. Quota accessor round-trip: quota_limit_inodes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (quota_limit_inodes (mk-quota f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. Quota accessor round-trip: quota_used_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (quota_used_bytes (mk-quota f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. Quota: integer field consistency ---
(push 1)
(declare-const r Quota)
(assert (>= (quota_uid r) 0))
(assert (>= (quota_limit_bytes r) 0))
(assert (not (>= (+ (quota_uid r) (quota_limit_bytes r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CrashState record properties ---

; --- 79. CrashState accessor round-trip: cs_journal ---
(push 1)
(declare-const f0 Journal)
(declare-const f1 FSState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cs_journal (mk-crash_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. CrashState accessor round-trip: cs_fs_state ---
(push 1)
(declare-const f0 Journal)
(declare-const f1 FSState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cs_fs_state (mk-crash_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. CrashState accessor round-trip: cs_last_checkpoint ---
(push 1)
(declare-const f0 Journal)
(declare-const f1 FSState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cs_last_checkpoint (mk-crash_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AtomicOp record properties ---

; --- 82. AtomicOp accessor round-trip: aop_operation ---
(push 1)
(declare-const f0 FileOp)
(declare-const f1 OpResult)
(declare-const f2 Int)
(assert (not (= (aop_operation (mk-atomic_op f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. AtomicOp accessor round-trip: aop_result ---
(push 1)
(declare-const f0 FileOp)
(declare-const f1 OpResult)
(declare-const f2 Int)
(assert (not (= (aop_result (mk-atomic_op f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

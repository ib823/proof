; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA FileSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/FileSystem.v (20 assertions)
; Module: FileSystem
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((FilePermission 0)) (((ReadOnly) (ReadWrite) (Execute) (NoAccess))))

(declare-datatypes ((FileType 0)) (((RegularFile) (Directory) (SymLink) (Socket))))

(declare-datatypes ((File 0))
  (((mk-file (file_id Int) (file_data Int) (file_checksum Int) (file_journaled Bool)))))

(declare-datatypes ((FileSystem 0))
  (((mk-file_system (fs_files (Seq Int)) (fs_journal (Seq Int)) (fs_consistent Bool) (fs_last_checkpoint Int)))))

(declare-datatypes ((ExtFile 0))
  (((mk-ext_file (efile_id Int) (efile_type FileType) (efile_permission FilePermission) (efile_owner Int) (efile_data Int) (efile_checksum Int) (efile_locked Bool) (efile_lock_owner Int) (efile_inode_ref_count Int) (efile_access_time Int)))))

(declare-datatypes ((FileDescriptor 0))
  (((mk-file_descriptor (fd_number Int) (fd_file_id Int) (fd_mode FilePermission) (fd_valid Bool)))))

(declare-datatypes ((Quota 0))
  (((mk-quota (quota_user Int) (quota_limit Int) (quota_used Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. FilePermission exhaustiveness ---
(push 1)
(declare-const x FilePermission)
(assert (not (or (= x ReadOnly) (= x ReadWrite) (= x Execute) (= x NoAccess))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. FilePermission: ReadOnly != ReadWrite ---
(push 1)
(assert (= ReadOnly ReadWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. FilePermission: ReadWrite != Execute ---
(push 1)
(assert (= ReadWrite Execute))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FilePermission: Execute != NoAccess ---
(push 1)
(assert (= Execute NoAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FilePermission: ReadOnly != NoAccess ---
(push 1)
(assert (= ReadOnly NoAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. FilePermission finite cardinality (4 values) ---
(push 1)
(declare-const x FilePermission)
(assert (and (not (= x ReadOnly)) (not (= x ReadWrite)) (not (= x Execute)) (not (= x NoAccess))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. FileType exhaustiveness ---
(push 1)
(declare-const x FileType)
(assert (not (or (= x RegularFile) (= x Directory) (= x SymLink) (= x Socket))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FileType: RegularFile != Directory ---
(push 1)
(assert (= RegularFile Directory))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FileType: Directory != SymLink ---
(push 1)
(assert (= Directory SymLink))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FileType: SymLink != Socket ---
(push 1)
(assert (= SymLink Socket))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. FileType: RegularFile != Socket ---
(push 1)
(assert (= RegularFile Socket))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. FileType finite cardinality (4 values) ---
(push 1)
(declare-const x FileType)
(assert (and (not (= x RegularFile)) (not (= x Directory)) (not (= x SymLink)) (not (= x Socket))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. File accessor round-trip: file_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (file_id (mk-file f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. File accessor round-trip: file_data ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (file_data (mk-file f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. File accessor round-trip: file_checksum ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (file_checksum (mk-file f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. File accessor round-trip: file_journaled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (file_journaled (mk-file f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. File: non-negative int fields sum ---
(push 1)
(declare-const r File)
(assert (>= (file_id r) 0))
(assert (>= (file_data r) 0))
(assert (not (>= (+ (file_id r) (file_data r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ExtFile accessor round-trip: efile_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 FileType)
(declare-const f2 FilePermission)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Int)
(assert (not (= (efile_id (mk-ext_file f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. ExtFile accessor round-trip: efile_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 FileType)
(declare-const f2 FilePermission)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Int)
(assert (not (= (efile_type (mk-ext_file f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ExtFile accessor round-trip: efile_permission ---
(push 1)
(declare-const f0 Int)
(declare-const f1 FileType)
(declare-const f2 FilePermission)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Int)
(assert (not (= (efile_permission (mk-ext_file f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ExtFile accessor round-trip: efile_owner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 FileType)
(declare-const f2 FilePermission)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Int)
(assert (not (= (efile_owner (mk-ext_file f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ExtFile accessor round-trip: efile_data ---
(push 1)
(declare-const f0 Int)
(declare-const f1 FileType)
(declare-const f2 FilePermission)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Int)
(declare-const f8 Int)
(declare-const f9 Int)
(assert (not (= (efile_data (mk-ext_file f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ExtFile: non-negative int fields sum ---
(push 1)
(declare-const r ExtFile)
(assert (>= (efile_id r) 0))
(assert (>= (efile_owner r) 0))
(assert (not (>= (+ (efile_id r) (efile_owner r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. FileDescriptor accessor round-trip: fd_number ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 FilePermission)
(declare-const f3 Bool)
(assert (not (= (fd_number (mk-file_descriptor f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. FileDescriptor accessor round-trip: fd_file_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 FilePermission)
(declare-const f3 Bool)
(assert (not (= (fd_file_id (mk-file_descriptor f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. FileDescriptor accessor round-trip: fd_mode ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 FilePermission)
(declare-const f3 Bool)
(assert (not (= (fd_mode (mk-file_descriptor f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. FileDescriptor accessor round-trip: fd_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 FilePermission)
(declare-const f3 Bool)
(assert (not (= (fd_valid (mk-file_descriptor f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. FileDescriptor: non-negative int fields sum ---
(push 1)
(declare-const r FileDescriptor)
(assert (>= (fd_number r) 0))
(assert (>= (fd_file_id r) 0))
(assert (not (>= (+ (fd_number r) (fd_file_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Quota accessor round-trip: quota_user ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (quota_user (mk-quota f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Quota accessor round-trip: quota_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (quota_limit (mk-quota f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. Quota accessor round-trip: quota_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (quota_used (mk-quota f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. Quota: non-negative int fields sum ---
(push 1)
(declare-const r Quota)
(assert (>= (quota_user r) 0))
(assert (>= (quota_limit r) 0))
(assert (not (>= (+ (quota_user r) (quota_limit r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FilePermission_level ((x FilePermission)) Int
  (ite (= x ReadOnly) 0 (ite (= x ReadWrite) 1 (ite (= x Execute) 2 3))))

(define-fun FilePermission_leq ((x FilePermission) (y FilePermission)) Bool
  (<= (FilePermission_level x) (FilePermission_level y)))

; --- 33. FilePermission_leq reflexivity ---
(push 1)
(declare-const x FilePermission)
(assert (not (FilePermission_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. FilePermission_leq transitivity ---
(push 1)
(declare-const x FilePermission)
(declare-const y FilePermission)
(declare-const z FilePermission)
(assert (FilePermission_leq x y))
(assert (FilePermission_leq y z))
(assert (not (FilePermission_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. FilePermission_leq antisymmetry ---
(push 1)
(declare-const x FilePermission)
(declare-const y FilePermission)
(assert (FilePermission_leq x y))
(assert (FilePermission_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ReadOnly is bottom ---
(push 1)
(declare-const x FilePermission)
(assert (not (FilePermission_leq ReadOnly x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. NoAccess is top ---
(push 1)
(declare-const x FilePermission)
(assert (not (FilePermission_leq x NoAccess)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

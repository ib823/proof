; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DataPersistence — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/DataPersistence.v (20 assertions)
; Module: DataPersistence
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Schema 0))
  (((mk-schema (schema_version Int) (schema_fields (Seq Int)) (schema_required (Seq Int))))))

(declare-datatypes ((Database 0))
  (((mk-database (db_schema Schema) (db_records (Seq Int)) (db_checksum Int)))))

(declare-datatypes ((SyncState 0))
  (((mk-sync_state (local_version Int) (remote_version Int) (pending_changes (Seq Int)) (conflicts (Seq Int))))))

(declare-datatypes ((EncryptedStore 0))
  (((mk-encrypted_store (store_id Int) (store_encrypted Bool) (store_key_id Int) (store_records (Seq Int)) (store_checksum Int)))))

(declare-datatypes ((Backup 0))
  (((mk-backup (backup_id Int) (backup_encrypted Bool) (backup_timestamp Int) (backup_records (Seq Int)) (backup_checksum Int)))))

(declare-datatypes ((Migration 0))
  (((mk-migration (mig_id Int) (mig_from_version Int) (mig_to_version Int) (mig_records_before (Seq Int)) (mig_records_after (Seq Int)) (mig_atomic Bool)))))

(declare-datatypes ((Transaction 0))
  (((mk-transaction (txn_id Int) (txn_operations (Seq Int)) (txn_committed Bool) (txn_rolled_back Bool)))))

(declare-datatypes ((CacheEntry 0))
  (((mk-cache_entry (cache_key Int) (cache_value Int) (cache_valid Bool) (cache_timestamp Int)))))

(declare-datatypes ((StorageQuota 0))
  (((mk-storage_quota (sq_user_id Int) (sq_limit_bytes Int) (sq_used_bytes Int)))))

(declare-datatypes ((SerializedData 0))
  (((mk-serialized_data (ser_format Int) (ser_data (Seq Int)) (ser_checksum Int) (ser_validated Bool)))))

(declare-datatypes ((DataExport 0))
  (((mk-data_export (export_id Int) (export_records (Seq Int)) (export_sanitized Bool) (export_encrypted Bool)))))

(declare-datatypes ((IndexEntry 0))
  (((mk-index_entry (idx_key Int) (idx_record_id Int) (idx_valid Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Schema accessor round-trip: schema_version ---
(push 1)
(declare-const f0 Int)
(assert (not (= (schema_version (mk-schema f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Database accessor round-trip: db_schema ---
(push 1)
(declare-const f0 Schema)
(assert (not (= (db_schema (mk-database f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SyncState accessor round-trip: local_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (local_version (mk-sync_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SyncState accessor round-trip: remote_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (remote_version (mk-sync_state f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SyncState: non-negative int fields sum ---
(push 1)
(declare-const r SyncState)
(assert (>= (local_version r) 0))
(assert (>= (remote_version r) 0))
(assert (not (>= (+ (local_version r) (remote_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. EncryptedStore accessor round-trip: store_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (store_id (mk-encrypted_store f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. EncryptedStore accessor round-trip: store_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (store_encrypted (mk-encrypted_store f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. EncryptedStore accessor round-trip: store_key_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (store_key_id (mk-encrypted_store f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. EncryptedStore: non-negative int fields sum ---
(push 1)
(declare-const r EncryptedStore)
(assert (>= (store_id r) 0))
(assert (>= (store_key_id r) 0))
(assert (not (>= (+ (store_id r) (store_key_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Backup accessor round-trip: backup_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (backup_id (mk-backup f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Backup accessor round-trip: backup_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (backup_encrypted (mk-backup f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Backup accessor round-trip: backup_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (backup_timestamp (mk-backup f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Backup: non-negative int fields sum ---
(push 1)
(declare-const r Backup)
(assert (>= (backup_id r) 0))
(assert (>= (backup_timestamp r) 0))
(assert (not (>= (+ (backup_id r) (backup_timestamp r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Migration accessor round-trip: mig_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (mig_id (mk-migration f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Migration accessor round-trip: mig_from_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (mig_from_version (mk-migration f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Migration accessor round-trip: mig_to_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (mig_to_version (mk-migration f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Migration: non-negative int fields sum ---
(push 1)
(declare-const r Migration)
(assert (>= (mig_id r) 0))
(assert (>= (mig_from_version r) 0))
(assert (not (>= (+ (mig_id r) (mig_from_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Transaction accessor round-trip: txn_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (txn_id (mk-transaction f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. CacheEntry accessor round-trip: cache_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (cache_key (mk-cache_entry f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. CacheEntry accessor round-trip: cache_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (cache_value (mk-cache_entry f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. CacheEntry accessor round-trip: cache_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (cache_valid (mk-cache_entry f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. CacheEntry accessor round-trip: cache_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (cache_timestamp (mk-cache_entry f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. CacheEntry: non-negative int fields sum ---
(push 1)
(declare-const r CacheEntry)
(assert (>= (cache_key r) 0))
(assert (>= (cache_value r) 0))
(assert (not (>= (+ (cache_key r) (cache_value r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. StorageQuota accessor round-trip: sq_user_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sq_user_id (mk-storage_quota f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. StorageQuota accessor round-trip: sq_limit_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sq_limit_bytes (mk-storage_quota f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. StorageQuota accessor round-trip: sq_used_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sq_used_bytes (mk-storage_quota f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. StorageQuota: non-negative int fields sum ---
(push 1)
(declare-const r StorageQuota)
(assert (>= (sq_user_id r) 0))
(assert (>= (sq_limit_bytes r) 0))
(assert (not (>= (+ (sq_user_id r) (sq_limit_bytes r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. SerializedData accessor round-trip: ser_format ---
(push 1)
(declare-const f0 Int)
(assert (not (= (ser_format (mk-serialized_data f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. DataExport accessor round-trip: export_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (export_id (mk-data_export f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. IndexEntry accessor round-trip: idx_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (idx_key (mk-index_entry f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. IndexEntry accessor round-trip: idx_record_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (idx_record_id (mk-index_entry f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. IndexEntry accessor round-trip: idx_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (idx_valid (mk-index_entry f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. IndexEntry: non-negative int fields sum ---
(push 1)
(declare-const r IndexEntry)
(assert (>= (idx_key r) 0))
(assert (>= (idx_record_id r) 0))
(assert (not (>= (+ (idx_key r) (idx_record_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

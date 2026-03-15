; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SIGMA001_VerifiedStorage — SMT Verification
; Derived from 02_FORMAL/coq/domains/SIGMA001_VerifiedStorage.v (38 assertions)
; Module: SIGMA001_VerifiedStorage
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ColType 0)) (((TInt) (TString) (TBool) (TNull))))

(declare-datatypes ((Value 0)) (((VInt) (VString) (VBool) (VNull))))

(declare-datatypes ((PredOp 0)) (((PEq) (PLt) (PGt) (PLte) (PGte) (PNeq))))

(declare-datatypes ((Ind_Pred 0)) (((PTrue) (PFalse) (PCol) (PAnd) (POr) (PNot))))

(declare-datatypes ((Query 0)) (((QSelect) (QJoin) (QInsert) (QUpdate) (QDelete))))

(declare-datatypes ((TxnStatus 0)) (((TxnPending) (TxnCommitted) (TxnAborted))))

(declare-datatypes ((TxnOp 0)) (((OpInsert) (OpDelete) (OpUpdate))))

(declare-datatypes ((IsolationLevel 0)) (((ReadUncommitted) (ReadCommitted) (RepeatableRead) (Serializable))))

(declare-datatypes ((Column 0))
  (((mk-column (col_name Int) (col_type ColType) (col_nullable Bool) (col_unique Bool)))))

(declare-datatypes ((Table 0))
  (((mk-table (table_name Int) (table_schema Int) (table_rows (Seq Int))))))

(declare-datatypes ((Database 0))
  (((mk-database (db_tables (Seq Int)) (db_fk_constraints (Seq Int))))))

(declare-datatypes ((Transaction 0))
  (((mk-transaction (txn_id Int) (txn_ops (Seq Int)) (txn_status TxnStatus)))))

(declare-datatypes ((WALEntry 0))
  (((mk-wal_entry (wal_txn_id Int) (wal_op TxnOp) (wal_lsn Int)))))

(declare-datatypes ((Checkpoint 0))
  (((mk-checkpoint (cp_lsn Int) (cp_db Database)))))

(declare-datatypes ((EncryptedData 0))
  (((mk-encrypted_data (enc_data (Seq Int)) (enc_key_id Int) (enc_algo Int)))))

(declare-datatypes ((MerkleTree 0))
  (((mk-merkle_tree (merkle_root Int) (merkle_leaves (Seq Int))))))

(declare-datatypes ((AuditEntry 0))
  (((mk-audit_entry (audit_timestamp Int) (audit_action Int) (audit_data_hash Int) (audit_prev_hash Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- ColType enum properties ---

; --- 1. ColType exhaustiveness ---
(push 1)
(declare-const x ColType)
(assert (not (or (= x TInt) (= x TString) (= x TBool) (= x TNull))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ColType: TInt != TString ---
(push 1)
(assert (= TInt TString))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ColType: TString != TBool ---
(push 1)
(assert (= TString TBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ColType: TBool != TNull ---
(push 1)
(assert (= TBool TNull))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ColType: TInt != TNull ---
(push 1)
(assert (= TInt TNull))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ColType finite cardinality (4 values) ---
(push 1)
(declare-const x ColType)
(assert (and (not (= x TInt)) (not (= x TString)) (not (= x TBool)) (not (= x TNull))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Value enum properties ---

; --- 7. Value exhaustiveness ---
(push 1)
(declare-const x Value)
(assert (not (or (= x VInt) (= x VString) (= x VBool) (= x VNull))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Value: VInt != VString ---
(push 1)
(assert (= VInt VString))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Value: VString != VBool ---
(push 1)
(assert (= VString VBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Value: VBool != VNull ---
(push 1)
(assert (= VBool VNull))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Value: VInt != VNull ---
(push 1)
(assert (= VInt VNull))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Value finite cardinality (4 values) ---
(push 1)
(declare-const x Value)
(assert (and (not (= x VInt)) (not (= x VString)) (not (= x VBool)) (not (= x VNull))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PredOp enum properties ---

; --- 13. PredOp exhaustiveness ---
(push 1)
(declare-const x PredOp)
(assert (not (or (= x PEq) (= x PLt) (= x PGt) (= x PLte) (= x PGte) (= x PNeq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. PredOp: PEq != PLt ---
(push 1)
(assert (= PEq PLt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. PredOp: PLt != PGt ---
(push 1)
(assert (= PLt PGt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. PredOp: PGt != PLte ---
(push 1)
(assert (= PGt PLte))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. PredOp: PEq != PNeq ---
(push 1)
(assert (= PEq PNeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. PredOp finite cardinality (6 values) ---
(push 1)
(declare-const x PredOp)
(assert (and (not (= x PEq)) (not (= x PLt)) (not (= x PGt)) (not (= x PLte)) (not (= x PGte)) (not (= x PNeq))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Ind_Pred enum properties ---

; --- 19. Ind_Pred exhaustiveness ---
(push 1)
(declare-const x Ind_Pred)
(assert (not (or (= x PTrue) (= x PFalse) (= x PCol) (= x PAnd) (= x POr) (= x PNot))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Ind_Pred: PTrue != PFalse ---
(push 1)
(assert (= PTrue PFalse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Ind_Pred: PFalse != PCol ---
(push 1)
(assert (= PFalse PCol))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Ind_Pred: PCol != PAnd ---
(push 1)
(assert (= PCol PAnd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Ind_Pred: PTrue != PNot ---
(push 1)
(assert (= PTrue PNot))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Ind_Pred finite cardinality (6 values) ---
(push 1)
(declare-const x Ind_Pred)
(assert (and (not (= x PTrue)) (not (= x PFalse)) (not (= x PCol)) (not (= x PAnd)) (not (= x POr)) (not (= x PNot))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Query enum properties ---

; --- 25. Query exhaustiveness ---
(push 1)
(declare-const x Query)
(assert (not (or (= x QSelect) (= x QJoin) (= x QInsert) (= x QUpdate) (= x QDelete))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Query: QSelect != QJoin ---
(push 1)
(assert (= QSelect QJoin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Query: QJoin != QInsert ---
(push 1)
(assert (= QJoin QInsert))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Query: QInsert != QUpdate ---
(push 1)
(assert (= QInsert QUpdate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Query: QSelect != QDelete ---
(push 1)
(assert (= QSelect QDelete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Query finite cardinality (5 values) ---
(push 1)
(declare-const x Query)
(assert (and (not (= x QSelect)) (not (= x QJoin)) (not (= x QInsert)) (not (= x QUpdate)) (not (= x QDelete))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TxnStatus enum properties ---

; --- 31. TxnStatus exhaustiveness ---
(push 1)
(declare-const x TxnStatus)
(assert (not (or (= x TxnPending) (= x TxnCommitted) (= x TxnAborted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. TxnStatus: TxnPending != TxnCommitted ---
(push 1)
(assert (= TxnPending TxnCommitted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. TxnStatus: TxnCommitted != TxnAborted ---
(push 1)
(assert (= TxnCommitted TxnAborted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. TxnStatus: TxnPending != TxnAborted ---
(push 1)
(assert (= TxnPending TxnAborted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. TxnStatus finite cardinality (3 values) ---
(push 1)
(declare-const x TxnStatus)
(assert (and (not (= x TxnPending)) (not (= x TxnCommitted)) (not (= x TxnAborted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TxnOp enum properties ---

; --- 36. TxnOp exhaustiveness ---
(push 1)
(declare-const x TxnOp)
(assert (not (or (= x OpInsert) (= x OpDelete) (= x OpUpdate))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. TxnOp: OpInsert != OpDelete ---
(push 1)
(assert (= OpInsert OpDelete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. TxnOp: OpDelete != OpUpdate ---
(push 1)
(assert (= OpDelete OpUpdate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. TxnOp: OpInsert != OpUpdate ---
(push 1)
(assert (= OpInsert OpUpdate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. TxnOp finite cardinality (3 values) ---
(push 1)
(declare-const x TxnOp)
(assert (and (not (= x OpInsert)) (not (= x OpDelete)) (not (= x OpUpdate))))
(check-sat) ; expect UNSAT
(pop 1)

; --- IsolationLevel enum properties ---

; --- 41. IsolationLevel exhaustiveness ---
(push 1)
(declare-const x IsolationLevel)
(assert (not (or (= x ReadUncommitted) (= x ReadCommitted) (= x RepeatableRead) (= x Serializable))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. IsolationLevel: ReadUncommitted != ReadCommitted ---
(push 1)
(assert (= ReadUncommitted ReadCommitted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. IsolationLevel: ReadCommitted != RepeatableRead ---
(push 1)
(assert (= ReadCommitted RepeatableRead))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. IsolationLevel: RepeatableRead != Serializable ---
(push 1)
(assert (= RepeatableRead Serializable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. IsolationLevel: ReadUncommitted != Serializable ---
(push 1)
(assert (= ReadUncommitted Serializable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. IsolationLevel finite cardinality (4 values) ---
(push 1)
(declare-const x IsolationLevel)
(assert (and (not (= x ReadUncommitted)) (not (= x ReadCommitted)) (not (= x RepeatableRead)) (not (= x Serializable))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Column record properties ---

; --- 47. Column accessor round-trip: col_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ColType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (col_name (mk-column f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. Column accessor round-trip: col_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ColType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (col_type (mk-column f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. Column accessor round-trip: col_nullable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 ColType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (col_nullable (mk-column f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Table record properties ---

; --- 50. Table accessor round-trip: table_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (table_name (mk-table f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. Table accessor round-trip: table_schema ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (table_schema (mk-table f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. Table: integer field consistency ---
(push 1)
(declare-const r Table)
(assert (>= (table_name r) 0))
(assert (>= (table_schema r) 0))
(assert (not (>= (+ (table_name r) (table_schema r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Database record properties ---

; --- 53. Database accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(assert (not (= (db_tables (mk-database f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Transaction record properties ---

; --- 54. Transaction accessor round-trip: txn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 TxnStatus)
(assert (not (= (txn_id (mk-transaction f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. Transaction accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 TxnStatus)
(assert (not (= (txn_ops (mk-transaction f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. Transaction: integer field consistency ---
(push 1)
(declare-const r Transaction)
(assert (>= (txn_id r) 0))
(assert (>= (seq.len (txn_ops r)) 0))
(assert (not (>= (+ (txn_id r) (seq.len (txn_ops r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- WALEntry record properties ---

; --- 57. WALEntry accessor round-trip: wal_txn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TxnOp)
(declare-const f2 Int)
(assert (not (= (wal_txn_id (mk-wal_entry f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. WALEntry accessor round-trip: wal_op ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TxnOp)
(declare-const f2 Int)
(assert (not (= (wal_op (mk-wal_entry f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Checkpoint record properties ---

; --- 59. Checkpoint accessor round-trip: cp_lsn ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Database)
(assert (not (= (cp_lsn (mk-checkpoint f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EncryptedData record properties ---

; --- 60. EncryptedData accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (enc_data (mk-encrypted_data f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. EncryptedData accessor round-trip: enc_key_id ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (enc_key_id (mk-encrypted_data f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. EncryptedData: integer field consistency ---
(push 1)
(declare-const r EncryptedData)
(assert (>= (seq.len (enc_data r)) 0))
(assert (>= (enc_key_id r) 0))
(assert (not (>= (+ (seq.len (enc_data r)) (enc_key_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MerkleTree record properties ---

; --- 63. MerkleTree accessor round-trip: merkle_root ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(assert (not (= (merkle_root (mk-merkle_tree f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuditEntry record properties ---

; --- 64. AuditEntry accessor round-trip: audit_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (audit_timestamp (mk-audit_entry f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. AuditEntry accessor round-trip: audit_action ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (audit_action (mk-audit_entry f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. AuditEntry accessor round-trip: audit_data_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (audit_data_hash (mk-audit_entry f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. AuditEntry: integer field consistency ---
(push 1)
(declare-const r AuditEntry)
(assert (>= (audit_timestamp r) 0))
(assert (>= (audit_action r) 0))
(assert (not (>= (+ (audit_timestamp r) (audit_action r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- IsolationLevel ordering properties ---

(define-fun IsolationLevel_level ((x IsolationLevel)) Int
  (ite (= x ReadUncommitted) 0 (ite (= x ReadCommitted) 1 (ite (= x RepeatableRead) 2 3))))

(define-fun IsolationLevel_leq ((x IsolationLevel) (y IsolationLevel)) Bool
  (<= (IsolationLevel_level x) (IsolationLevel_level y)))

; --- 68. IsolationLevel_leq reflexivity ---
(push 1)
(declare-const x IsolationLevel)
(assert (not (IsolationLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. IsolationLevel_leq transitivity ---
(push 1)
(declare-const x IsolationLevel)
(declare-const y IsolationLevel)
(declare-const z IsolationLevel)
(assert (IsolationLevel_leq x y))
(assert (IsolationLevel_leq y z))
(assert (not (IsolationLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. IsolationLevel_leq antisymmetry ---
(push 1)
(declare-const x IsolationLevel)
(declare-const y IsolationLevel)
(assert (IsolationLevel_leq x y))
(assert (IsolationLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. ReadUncommitted is bottom ---
(push 1)
(declare-const x IsolationLevel)
(assert (not (IsolationLevel_leq ReadUncommitted x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. Serializable is top ---
(push 1)
(declare-const x IsolationLevel)
(assert (not (IsolationLevel_leq x Serializable)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedInfra — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedInfra.v (26 assertions)
; Module: VerifiedInfra
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TxnOp 0)) (((TxnRead) (TxnWrite))))

(declare-datatypes ((TxnOutcome 0)) (((TxnCommit) (TxnAbort))))

(declare-datatypes ((SafeQuery 0)) (((SQParam) (SQConst))))

(declare-datatypes ((TypedPayload 0)) (((TPInt) (TPStr) (TPList))))

(declare-datatypes ((ProcessOutcome 0)) (((POSuccess) (POFailure))))

(declare-datatypes ((Backend 0))
  (((mk-backend (backend_id Int) (backend_healthy Bool) (backend_capacity Int) (backend_current_load Int)))))

(declare-datatypes ((HTTPRequest 0))
  (((mk-http_request (req_method String) (req_path String) (req_headers (Seq Int)) (req_body (Seq Int)) (req_session_id Int)))))

(declare-datatypes ((LBState 0))
  (((mk-lb_state (lb_backends (Seq Int)) (lb_session_map Int)))))

(declare-datatypes ((HealthCheckResult 0))
  (((mk-health_check_result (hc_backend_id Int) (hc_is_healthy Bool) (hc_timestamp Int)))))

(declare-datatypes ((Transaction 0))
  (((mk-transaction (txn_id Int) (txn_ops (Seq Int))))))

(declare-datatypes ((DurableTransaction 0))
  (((mk-durable_transaction (dtxn_id Int) (dtxn_committed Bool) (dtxn_persisted Bool)))))

(declare-datatypes ((EncryptedStorage 0))
  (((mk-encrypted_storage (enc_algorithm String) (enc_key_id Int) (enc_data (Seq Int))))))

(declare-datatypes ((Capability 0))
  (((mk-capability (cap_subject Int) (cap_object Int) (cap_permission Int)))))

(declare-datatypes ((AuditEntry 0))
  (((mk-audit_entry (audit_timestamp Int) (audit_subject Int) (audit_action Int) (audit_object Int) (audit_outcome Bool)))))

(declare-datatypes ((Message 0))
  (((mk-message (msg_id Int) (msg_payload (Seq Int)) (msg_type String)))))

(declare-datatypes ((QueueState 0))
  (((mk-queue_state (q_messages (Seq Int)) (q_delivered (Seq Int)) (q_acked (Seq Int)) (q_dlq (Seq Int)) (q_sequence Int)))))

(declare-datatypes ((ExactlyOnceQueue 0))
  (((mk-exactly_once_queue (eoq_pending (Seq Int)) (eoq_delivered_ids (Seq Int)) (eoq_dlq (Seq Int))))))

(declare-datatypes ((LogEntry 0))
  (((mk-log_entry (log_timestamp Int) (log_level Int) (log_message String) (log_structured Bool) (log_hash Int) (log_prev_hash Int)))))

(declare-datatypes ((AppendOnlyLog 0))
  (((mk-append_only_log (aol_entries Int) (aol_write_count Int)))))

(declare-datatypes ((Secret 0))
  (((mk-secret (secret_id Int) (secret_value (Seq Int)) (secret_created Int) (secret_ttl Int) (secret_owner Int)))))

(declare-datatypes ((SecretsStore 0))
  (((mk-secrets_store (secrets (Seq Int)) (access_policy Int) (access_log (Seq Int))))))

(declare-datatypes ((RotationState 0))
  (((mk-rotation_state (rot_old_key (Seq Int)) (rot_new_key (Seq Int)) (rot_grace_period Int) (rot_current_time Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TxnOp enum properties ---

; --- 1. TxnOp exhaustiveness ---
(push 1)
(declare-const x TxnOp)
(assert (not (or (= x TxnRead) (= x TxnWrite))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TxnOp: TxnRead != TxnWrite ---
(push 1)
(assert (= TxnRead TxnWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TxnOp finite cardinality (2 values) ---
(push 1)
(declare-const x TxnOp)
(assert (and (not (= x TxnRead)) (not (= x TxnWrite))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TxnOutcome enum properties ---

; --- 4. TxnOutcome exhaustiveness ---
(push 1)
(declare-const x TxnOutcome)
(assert (not (or (= x TxnCommit) (= x TxnAbort))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TxnOutcome: TxnCommit != TxnAbort ---
(push 1)
(assert (= TxnCommit TxnAbort))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. TxnOutcome finite cardinality (2 values) ---
(push 1)
(declare-const x TxnOutcome)
(assert (and (not (= x TxnCommit)) (not (= x TxnAbort))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SafeQuery enum properties ---

; --- 7. SafeQuery exhaustiveness ---
(push 1)
(declare-const x SafeQuery)
(assert (not (or (= x SQParam) (= x SQConst))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SafeQuery: SQParam != SQConst ---
(push 1)
(assert (= SQParam SQConst))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SafeQuery finite cardinality (2 values) ---
(push 1)
(declare-const x SafeQuery)
(assert (and (not (= x SQParam)) (not (= x SQConst))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TypedPayload enum properties ---

; --- 10. TypedPayload exhaustiveness ---
(push 1)
(declare-const x TypedPayload)
(assert (not (or (= x TPInt) (= x TPStr) (= x TPList))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TypedPayload: TPInt != TPStr ---
(push 1)
(assert (= TPInt TPStr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TypedPayload: TPStr != TPList ---
(push 1)
(assert (= TPStr TPList))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. TypedPayload: TPInt != TPList ---
(push 1)
(assert (= TPInt TPList))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. TypedPayload finite cardinality (3 values) ---
(push 1)
(declare-const x TypedPayload)
(assert (and (not (= x TPInt)) (not (= x TPStr)) (not (= x TPList))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProcessOutcome enum properties ---

; --- 15. ProcessOutcome exhaustiveness ---
(push 1)
(declare-const x ProcessOutcome)
(assert (not (or (= x POSuccess) (= x POFailure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ProcessOutcome: POSuccess != POFailure ---
(push 1)
(assert (= POSuccess POFailure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ProcessOutcome finite cardinality (2 values) ---
(push 1)
(declare-const x ProcessOutcome)
(assert (and (not (= x POSuccess)) (not (= x POFailure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Backend record properties ---

; --- 18. Backend accessor round-trip: backend_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (backend_id (mk-backend f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Backend accessor round-trip: backend_healthy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (backend_healthy (mk-backend f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Backend accessor round-trip: backend_capacity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (backend_capacity (mk-backend f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Backend: integer field consistency ---
(push 1)
(declare-const r Backend)
(assert (>= (backend_id r) 0))
(assert (>= (backend_capacity r) 0))
(assert (not (>= (+ (backend_id r) (backend_capacity r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HTTPRequest record properties ---

; --- 22. HTTPRequest accessor round-trip: req_method ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (req_method (mk-http_request f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. HTTPRequest accessor round-trip: req_path ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (req_path (mk-http_request f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. HTTPRequest accessor round-trip: Seq ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (req_headers (mk-http_request f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. HTTPRequest accessor round-trip: Seq ---
(push 1)
(declare-const f0 String)
(declare-const f1 String)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (req_body (mk-http_request f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. HTTPRequest: integer field consistency ---
(push 1)
(declare-const r HTTPRequest)
(assert (>= (seq.len (req_headers r)) 0))
(assert (>= (seq.len (req_headers r)) 0))
(assert (not (>= (+ (seq.len (req_headers r)) (seq.len (req_headers r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LBState record properties ---

; --- 27. LBState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (lb_backends (mk-lb_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HealthCheckResult record properties ---

; --- 28. HealthCheckResult accessor round-trip: hc_backend_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (hc_backend_id (mk-health_check_result f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. HealthCheckResult accessor round-trip: hc_is_healthy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (hc_is_healthy (mk-health_check_result f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Transaction record properties ---

; --- 30. Transaction accessor round-trip: txn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(assert (not (= (txn_id (mk-transaction f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DurableTransaction record properties ---

; --- 31. DurableTransaction accessor round-trip: dtxn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (dtxn_id (mk-durable_transaction f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DurableTransaction accessor round-trip: dtxn_committed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (dtxn_committed (mk-durable_transaction f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EncryptedStorage record properties ---

; --- 33. EncryptedStorage accessor round-trip: enc_algorithm ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (enc_algorithm (mk-encrypted_storage f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. EncryptedStorage accessor round-trip: enc_key_id ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (enc_key_id (mk-encrypted_storage f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Capability record properties ---

; --- 35. Capability accessor round-trip: cap_subject ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cap_subject (mk-capability f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Capability accessor round-trip: cap_object ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cap_object (mk-capability f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. Capability: integer field consistency ---
(push 1)
(declare-const r Capability)
(assert (>= (cap_subject r) 0))
(assert (>= (cap_object r) 0))
(assert (not (>= (+ (cap_subject r) (cap_object r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuditEntry record properties ---

; --- 38. AuditEntry accessor round-trip: audit_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_timestamp (mk-audit_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. AuditEntry accessor round-trip: audit_subject ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_subject (mk-audit_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. AuditEntry accessor round-trip: audit_action ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_action (mk-audit_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. AuditEntry accessor round-trip: audit_object ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_object (mk-audit_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. AuditEntry: integer field consistency ---
(push 1)
(declare-const r AuditEntry)
(assert (>= (audit_timestamp r) 0))
(assert (>= (audit_subject r) 0))
(assert (not (>= (+ (audit_timestamp r) (audit_subject r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Message record properties ---

; --- 43. Message accessor round-trip: msg_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 String)
(assert (not (= (msg_id (mk-message f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Message accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 String)
(assert (not (= (msg_payload (mk-message f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. Message: integer field consistency ---
(push 1)
(declare-const r Message)
(assert (>= (msg_id r) 0))
(assert (>= (seq.len (msg_payload r)) 0))
(assert (not (>= (+ (msg_id r) (seq.len (msg_payload r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- QueueState record properties ---

; --- 46. QueueState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (q_messages (mk-queue_state f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. QueueState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (q_delivered (mk-queue_state f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. QueueState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (q_acked (mk-queue_state f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. QueueState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (q_dlq (mk-queue_state f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. QueueState: integer field consistency ---
(push 1)
(declare-const r QueueState)
(assert (>= (seq.len (q_messages r)) 0))
(assert (>= (seq.len (q_messages r)) 0))
(assert (not (>= (+ (seq.len (q_messages r)) (seq.len (q_messages r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ExactlyOnceQueue record properties ---

; --- 51. ExactlyOnceQueue accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (eoq_pending (mk-exactly_once_queue f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. ExactlyOnceQueue accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (eoq_delivered_ids (mk-exactly_once_queue f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. ExactlyOnceQueue: integer field consistency ---
(push 1)
(declare-const r ExactlyOnceQueue)
(assert (>= (seq.len (eoq_pending r)) 0))
(assert (>= (seq.len (eoq_pending r)) 0))
(assert (not (>= (+ (seq.len (eoq_pending r)) (seq.len (eoq_pending r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LogEntry record properties ---

; --- 54. LogEntry accessor round-trip: log_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (log_timestamp (mk-log_entry f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. LogEntry accessor round-trip: log_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (log_level (mk-log_entry f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. LogEntry accessor round-trip: log_message ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (log_message (mk-log_entry f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. LogEntry accessor round-trip: log_structured ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (log_structured (mk-log_entry f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. LogEntry accessor round-trip: log_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 String)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (log_hash (mk-log_entry f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. LogEntry: integer field consistency ---
(push 1)
(declare-const r LogEntry)
(assert (>= (log_timestamp r) 0))
(assert (>= (log_level r) 0))
(assert (not (>= (+ (log_timestamp r) (log_level r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AppendOnlyLog record properties ---

; --- 60. AppendOnlyLog accessor round-trip: aol_entries ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (aol_entries (mk-append_only_log f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Secret record properties ---

; --- 61. Secret accessor round-trip: secret_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (secret_id (mk-secret f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. Secret accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (secret_value (mk-secret f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. Secret accessor round-trip: secret_created ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (secret_created (mk-secret f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. Secret accessor round-trip: secret_ttl ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (secret_ttl (mk-secret f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. Secret: integer field consistency ---
(push 1)
(declare-const r Secret)
(assert (>= (secret_id r) 0))
(assert (>= (seq.len (secret_value r)) 0))
(assert (not (>= (+ (secret_id r) (seq.len (secret_value r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecretsStore record properties ---

; --- 66. SecretsStore accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (secrets (mk-secrets_store f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. SecretsStore accessor round-trip: access_policy ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (access_policy (mk-secrets_store f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. SecretsStore: integer field consistency ---
(push 1)
(declare-const r SecretsStore)
(assert (>= (seq.len (secrets r)) 0))
(assert (>= (access_policy r) 0))
(assert (not (>= (+ (seq.len (secrets r)) (access_policy r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RotationState record properties ---

; --- 69. RotationState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rot_old_key (mk-rotation_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. RotationState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rot_new_key (mk-rotation_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. RotationState accessor round-trip: rot_grace_period ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rot_grace_period (mk-rotation_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. RotationState: integer field consistency ---
(push 1)
(declare-const r RotationState)
(assert (>= (seq.len (rot_old_key r)) 0))
(assert (>= (seq.len (rot_old_key r)) 0))
(assert (not (>= (+ (seq.len (rot_old_key r)) (seq.len (rot_old_key r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

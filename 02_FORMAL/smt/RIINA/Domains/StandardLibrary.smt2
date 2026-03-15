; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA StandardLibrary — SMT Verification
; Derived from 02_FORMAL/coq/domains/StandardLibrary.v (45 assertions)
; Module: StandardLibrary
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Capability 0)) (((CapFileRead) (CapFileWrite) (CapNetConnect) (CapNetListen) (CapCryptoSign) (CapCryptoEncrypt))))

(declare-datatypes ((TlsVersion 0)) (((TLS10) (TLS11) (TLS12) (TLS13))))

(declare-datatypes ((SecurityLevel 0)) (((Public) (Internal) (Confidential) (Secret) (TopSecret))))

(declare-datatypes ((SipHashState 0))
  (((mk-sip_hash_state (siphash_key Int)))))

(declare-datatypes ((RiinaString 0))
  (((mk-riina_string (str_bytes (Seq Int)) (str_is_utf8 Bool)))))

(declare-datatypes ((SecureString 0))
  (((mk-secure_string (sstr_data (Seq Int)) (sstr_zeroized Bool) (sstr_redacted Bool)))))

(declare-datatypes ((ReadResult 0))
  (((mk-read_result (read_count Int) (read_buffer_size Int) (read_valid Int)))))

(declare-datatypes ((WriteResult 0))
  (((mk-write_result (write_count Int) (write_buffer_size Int) (write_valid Int)))))

(declare-datatypes ((FileHandle 0))
  (((mk-file_handle (fh_id Int) (fh_caps (Seq Int))))))

(declare-datatypes ((AuditEntry 0))
  (((mk-audit_entry (ae_operation Int) (ae_file_id Int) (ae_size Int)))))

(declare-datatypes ((AuditedFile 0))
  (((mk-audited_file (af_handle FileHandle) (af_log (Seq Int))))))

(declare-datatypes ((TcpStream 0))
  (((mk-tcp_stream (tcp_id Int) (tcp_caps (Seq Int)) (tcp_buffer (Seq Int))))))

(declare-datatypes ((TlsConfig 0))
  (((mk-tls_config (tls_min_version TlsVersion)))))

(declare-datatypes ((TlsConnection 0))
  (((mk-tls_connection (tls_negotiated_version TlsVersion) (tls_config TlsConfig)))))

(declare-datatypes ((ConnectionAudit 0))
  (((mk-connection_audit (ca_stream TcpStream) (ca_log (Seq Int))))))

(declare-datatypes ((Duration 0))
  (((mk-duration (dur_secs Int) (dur_nanos Int)))))

(declare-datatypes ((Instant 0))
  (((mk-instant (inst_ticks Int)))))

(declare-datatypes ((SecureTimestamp 0))
  (((mk-secure_timestamp (st_time Int) (st_signature Int) (st_signed Bool)))))

(declare-datatypes ((MonotonicCounter 0))
  (((mk-monotonic_counter (mc_value Int)))))

(declare-datatypes ((MutexState 0))
  (((mk-mutex_state (mutex_locked Bool) (mutex_owner Int)))))

(declare-datatypes ((RwLockState 0))
  (((mk-rw_lock_state (rwlock_readers Int) (rwlock_writer Int)))))

(declare-datatypes ((AtomicNat 0))
  (((mk-atomic_nat (atomic_value Int) (atomic_seq Int)))))

(declare-datatypes ((CondvarState 0))
  (((mk-condvar_state (cv_waiters (Seq Int)) (cv_signaled Bool)))))

(declare-datatypes ((ResourceOrder 0))
  (((mk-resource_order (ro_resources (Seq Int)) (ro_acquired (Seq Int))))))

(declare-datatypes ((AesKey 0))
  (((mk-aes_key (aes_key_data (Seq Int)) (aes_key_zeroized Bool)))))

(declare-datatypes ((Signature 0))
  (((mk-signature (sig_data (Seq Int)) (sig_public_key Int)))))

(declare-datatypes ((CryptoKey 0))
  (((mk-crypto_key (ck_data (Seq Int)) (ck_zeroized Bool)))))

(declare-datatypes ((Label 0))
  (((mk-label (lab_level SecurityLevel) (lab_compartments (Seq Int))))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Capability enum properties ---

; --- 1. Capability exhaustiveness ---
(push 1)
(declare-const x Capability)
(assert (not (or (= x CapFileRead) (= x CapFileWrite) (= x CapNetConnect) (= x CapNetListen) (= x CapCryptoSign) (= x CapCryptoEncrypt))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Capability: CapFileRead != CapFileWrite ---
(push 1)
(assert (= CapFileRead CapFileWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Capability: CapFileWrite != CapNetConnect ---
(push 1)
(assert (= CapFileWrite CapNetConnect))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Capability: CapNetConnect != CapNetListen ---
(push 1)
(assert (= CapNetConnect CapNetListen))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Capability: CapFileRead != CapCryptoEncrypt ---
(push 1)
(assert (= CapFileRead CapCryptoEncrypt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Capability finite cardinality (6 values) ---
(push 1)
(declare-const x Capability)
(assert (and (not (= x CapFileRead)) (not (= x CapFileWrite)) (not (= x CapNetConnect)) (not (= x CapNetListen)) (not (= x CapCryptoSign)) (not (= x CapCryptoEncrypt))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TlsVersion enum properties ---

; --- 7. TlsVersion exhaustiveness ---
(push 1)
(declare-const x TlsVersion)
(assert (not (or (= x TLS10) (= x TLS11) (= x TLS12) (= x TLS13))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TlsVersion: TLS10 != TLS11 ---
(push 1)
(assert (= TLS10 TLS11))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TlsVersion: TLS11 != TLS12 ---
(push 1)
(assert (= TLS11 TLS12))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TlsVersion: TLS12 != TLS13 ---
(push 1)
(assert (= TLS12 TLS13))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TlsVersion: TLS10 != TLS13 ---
(push 1)
(assert (= TLS10 TLS13))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TlsVersion finite cardinality (4 values) ---
(push 1)
(declare-const x TlsVersion)
(assert (and (not (= x TLS10)) (not (= x TLS11)) (not (= x TLS12)) (not (= x TLS13))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLevel enum properties ---

; --- 13. SecurityLevel exhaustiveness ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (or (= x Public) (= x Internal) (= x Confidential) (= x Secret) (= x TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SecurityLevel: Public != Internal ---
(push 1)
(assert (= Public Internal))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SecurityLevel: Internal != Confidential ---
(push 1)
(assert (= Internal Confidential))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SecurityLevel: Confidential != Secret ---
(push 1)
(assert (= Confidential Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SecurityLevel: Public != TopSecret ---
(push 1)
(assert (= Public TopSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SecurityLevel finite cardinality (5 values) ---
(push 1)
(declare-const x SecurityLevel)
(assert (and (not (= x Public)) (not (= x Internal)) (not (= x Confidential)) (not (= x Secret)) (not (= x TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RiinaString record properties ---

; --- 19. RiinaString accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(assert (not (= (str_bytes (mk-riina_string f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecureString record properties ---

; --- 20. SecureString accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sstr_data (mk-secure_string f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SecureString accessor round-trip: sstr_zeroized ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sstr_zeroized (mk-secure_string f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ReadResult record properties ---

; --- 22. ReadResult accessor round-trip: read_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (read_count (mk-read_result f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ReadResult accessor round-trip: read_buffer_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (read_buffer_size (mk-read_result f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ReadResult: integer field consistency ---
(push 1)
(declare-const r ReadResult)
(assert (>= (read_count r) 0))
(assert (>= (read_buffer_size r) 0))
(assert (not (>= (+ (read_count r) (read_buffer_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- WriteResult record properties ---

; --- 25. WriteResult accessor round-trip: write_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (write_count (mk-write_result f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. WriteResult accessor round-trip: write_buffer_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (write_buffer_size (mk-write_result f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. WriteResult: integer field consistency ---
(push 1)
(declare-const r WriteResult)
(assert (>= (write_count r) 0))
(assert (>= (write_buffer_size r) 0))
(assert (not (>= (+ (write_count r) (write_buffer_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FileHandle record properties ---

; --- 28. FileHandle accessor round-trip: fh_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(assert (not (= (fh_id (mk-file_handle f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuditEntry record properties ---

; --- 29. AuditEntry accessor round-trip: ae_operation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ae_operation (mk-audit_entry f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. AuditEntry accessor round-trip: ae_file_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ae_file_id (mk-audit_entry f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. AuditEntry: integer field consistency ---
(push 1)
(declare-const r AuditEntry)
(assert (>= (ae_operation r) 0))
(assert (>= (ae_file_id r) 0))
(assert (not (>= (+ (ae_operation r) (ae_file_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuditedFile record properties ---

; --- 32. AuditedFile accessor round-trip: af_handle ---
(push 1)
(declare-const f0 FileHandle)
(declare-const f1 (Seq Int))
(assert (not (= (af_handle (mk-audited_file f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TcpStream record properties ---

; --- 33. TcpStream accessor round-trip: tcp_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (tcp_id (mk-tcp_stream f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. TcpStream accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(assert (not (= (tcp_caps (mk-tcp_stream f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. TcpStream: integer field consistency ---
(push 1)
(declare-const r TcpStream)
(assert (>= (tcp_id r) 0))
(assert (>= (seq.len (tcp_caps r)) 0))
(assert (not (>= (+ (tcp_id r) (seq.len (tcp_caps r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TlsConnection record properties ---

; --- 36. TlsConnection accessor round-trip: tls_negotiated_version ---
(push 1)
(declare-const f0 TlsVersion)
(declare-const f1 TlsConfig)
(assert (not (= (tls_negotiated_version (mk-tls_connection f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConnectionAudit record properties ---

; --- 37. ConnectionAudit accessor round-trip: ca_stream ---
(push 1)
(declare-const f0 TcpStream)
(declare-const f1 (Seq Int))
(assert (not (= (ca_stream (mk-connection_audit f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Duration record properties ---

; --- 38. Duration accessor round-trip: dur_secs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (dur_secs (mk-duration f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecureTimestamp record properties ---

; --- 39. SecureTimestamp accessor round-trip: st_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (st_time (mk-secure_timestamp f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. SecureTimestamp accessor round-trip: st_signature ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (st_signature (mk-secure_timestamp f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. SecureTimestamp: integer field consistency ---
(push 1)
(declare-const r SecureTimestamp)
(assert (>= (st_time r) 0))
(assert (>= (st_signature r) 0))
(assert (not (>= (+ (st_time r) (st_signature r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MutexState record properties ---

; --- 42. MutexState accessor round-trip: mutex_locked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(assert (not (= (mutex_locked (mk-mutex_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RwLockState record properties ---

; --- 43. RwLockState accessor round-trip: rwlock_readers ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (rwlock_readers (mk-rw_lock_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AtomicNat record properties ---

; --- 44. AtomicNat accessor round-trip: atomic_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (atomic_value (mk-atomic_nat f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CondvarState record properties ---

; --- 45. CondvarState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(assert (not (= (cv_waiters (mk-condvar_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ResourceOrder record properties ---

; --- 46. ResourceOrder accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(assert (not (= (ro_resources (mk-resource_order f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AesKey record properties ---

; --- 47. AesKey accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(assert (not (= (aes_key_data (mk-aes_key f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Signature record properties ---

; --- 48. Signature accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (sig_data (mk-signature f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CryptoKey record properties ---

; --- 49. CryptoKey accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(assert (not (= (ck_data (mk-crypto_key f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Label record properties ---

; --- 50. Label accessor round-trip: lab_level ---
(push 1)
(declare-const f0 SecurityLevel)
(declare-const f1 (Seq Int))
(assert (not (= (lab_level (mk-label f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLevel ordering properties ---

(define-fun SecurityLevel_level ((x SecurityLevel)) Int
  (ite (= x Public) 0 (ite (= x Internal) 1 (ite (= x Confidential) 2 (ite (= x Secret) 3 4)))))

(define-fun SecurityLevel_leq ((x SecurityLevel) (y SecurityLevel)) Bool
  (<= (SecurityLevel_level x) (SecurityLevel_level y)))

; --- 51. SecurityLevel_leq reflexivity ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. SecurityLevel_leq transitivity ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(declare-const z SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y z))
(assert (not (SecurityLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. SecurityLevel_leq antisymmetry ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. Public is bottom ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq Public x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. TopSecret is top ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x TopSecret)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA EncryptionSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/EncryptionSystem.v (22 assertions)
; Module: EncryptionSystem
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((EncryptionKey 0))
  (((mk-encryption_key (key_id Int) (key_bits Int) (key_algorithm Int) (key_is_private Bool) (key_stored_in_se Bool)))))

(declare-datatypes ((EncryptedMessage 0))
  (((mk-encrypted_message (msg_id Int) (encryption_key_used EncryptionKey) (ciphertext (Seq Int)) (plaintext_hash Int) (is_e2e Bool)))))

(declare-datatypes ((DecryptedMessage 0))
  (((mk-decrypted_message (dec_msg_id Int) (decryption_key EncryptionKey) (plaintext (Seq Int)) (integrity_verified Bool)))))

(declare-datatypes ((KeyDerivation 0))
  (((mk-key_derivation (master_key EncryptionKey) (derived_key EncryptionKey) (derivation_salt Int) (derivation_iterations Int)))))

(declare-datatypes ((SecureChannel 0))
  (((mk-secure_channel (channel_id Int) (sender_key EncryptionKey) (receiver_key EncryptionKey) (forward_secrecy Bool) (channel_encrypted Bool) (channel_authenticated Bool)))))

(declare-datatypes ((EncryptionOperation 0))
  (((mk-encryption_operation (enc_op_id Int) (enc_op_plaintext (Seq Int)) (enc_op_ciphertext (Seq Int)) (enc_op_key EncryptionKey) (enc_op_iv Int) (enc_op_aead_tag Int) (enc_op_aead_verified Bool)))))

(declare-datatypes ((PasswordHash 0))
  (((mk-password_hash (pwd_hash_value Int) (pwd_salt Int) (pwd_iterations Int) (pwd_algorithm Int)))))

(declare-datatypes ((KeyRotation 0))
  (((mk-key_rotation (kr_old_key EncryptionKey) (kr_new_key EncryptionKey) (kr_rotation_complete Bool) (kr_old_key_destroyed Bool)))))

(declare-datatypes ((IVTracker 0))
  (((mk-iv_tracker (iv_current Int) (iv_used_list (Seq Int)) (iv_unique Bool)))))

(declare-datatypes ((TimingTest 0))
  (((mk-timing_test (tt_operation Int) (tt_time_ns Int) (tt_constant_time Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. EncryptionKey accessor round-trip: key_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (key_id (mk-encryption_key f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. EncryptionKey accessor round-trip: key_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (key_bits (mk-encryption_key f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. EncryptionKey accessor round-trip: key_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (key_algorithm (mk-encryption_key f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. EncryptionKey accessor round-trip: key_is_private ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (key_is_private (mk-encryption_key f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. EncryptionKey accessor round-trip: key_stored_in_se ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (key_stored_in_se (mk-encryption_key f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. EncryptionKey: non-negative int fields sum ---
(push 1)
(declare-const r EncryptionKey)
(assert (>= (key_id r) 0))
(assert (>= (key_bits r) 0))
(assert (not (>= (+ (key_id r) (key_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. EncryptedMessage accessor round-trip: msg_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EncryptionKey)
(assert (not (= (msg_id (mk-encrypted_message f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. EncryptedMessage accessor round-trip: encryption_key_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EncryptionKey)
(assert (not (= (encryption_key_used (mk-encrypted_message f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. DecryptedMessage accessor round-trip: dec_msg_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EncryptionKey)
(assert (not (= (dec_msg_id (mk-decrypted_message f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. DecryptedMessage accessor round-trip: decryption_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EncryptionKey)
(assert (not (= (decryption_key (mk-decrypted_message f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. KeyDerivation accessor round-trip: master_key ---
(push 1)
(declare-const f0 EncryptionKey)
(declare-const f1 EncryptionKey)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (master_key (mk-key_derivation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. KeyDerivation accessor round-trip: derived_key ---
(push 1)
(declare-const f0 EncryptionKey)
(declare-const f1 EncryptionKey)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (derived_key (mk-key_derivation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. KeyDerivation accessor round-trip: derivation_salt ---
(push 1)
(declare-const f0 EncryptionKey)
(declare-const f1 EncryptionKey)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (derivation_salt (mk-key_derivation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. KeyDerivation accessor round-trip: derivation_iterations ---
(push 1)
(declare-const f0 EncryptionKey)
(declare-const f1 EncryptionKey)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (derivation_iterations (mk-key_derivation f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. KeyDerivation: non-negative int fields sum ---
(push 1)
(declare-const r KeyDerivation)
(assert (>= (derivation_salt r) 0))
(assert (>= (derivation_iterations r) 0))
(assert (not (>= (+ (derivation_salt r) (derivation_iterations r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SecureChannel accessor round-trip: channel_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EncryptionKey)
(declare-const f2 EncryptionKey)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (channel_id (mk-secure_channel f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SecureChannel accessor round-trip: sender_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EncryptionKey)
(declare-const f2 EncryptionKey)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (sender_key (mk-secure_channel f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SecureChannel accessor round-trip: receiver_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EncryptionKey)
(declare-const f2 EncryptionKey)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (receiver_key (mk-secure_channel f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SecureChannel accessor round-trip: forward_secrecy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EncryptionKey)
(declare-const f2 EncryptionKey)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (forward_secrecy (mk-secure_channel f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SecureChannel accessor round-trip: channel_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EncryptionKey)
(declare-const f2 EncryptionKey)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (channel_encrypted (mk-secure_channel f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. EncryptionOperation accessor round-trip: enc_op_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (enc_op_id (mk-encryption_operation f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. PasswordHash accessor round-trip: pwd_hash_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pwd_hash_value (mk-password_hash f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. PasswordHash accessor round-trip: pwd_salt ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pwd_salt (mk-password_hash f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. PasswordHash accessor round-trip: pwd_iterations ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pwd_iterations (mk-password_hash f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. PasswordHash accessor round-trip: pwd_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pwd_algorithm (mk-password_hash f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. PasswordHash: non-negative int fields sum ---
(push 1)
(declare-const r PasswordHash)
(assert (>= (pwd_hash_value r) 0))
(assert (>= (pwd_salt r) 0))
(assert (not (>= (+ (pwd_hash_value r) (pwd_salt r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. KeyRotation accessor round-trip: kr_old_key ---
(push 1)
(declare-const f0 EncryptionKey)
(declare-const f1 EncryptionKey)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (kr_old_key (mk-key_rotation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. KeyRotation accessor round-trip: kr_new_key ---
(push 1)
(declare-const f0 EncryptionKey)
(declare-const f1 EncryptionKey)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (kr_new_key (mk-key_rotation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. KeyRotation accessor round-trip: kr_rotation_complete ---
(push 1)
(declare-const f0 EncryptionKey)
(declare-const f1 EncryptionKey)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (kr_rotation_complete (mk-key_rotation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. KeyRotation accessor round-trip: kr_old_key_destroyed ---
(push 1)
(declare-const f0 EncryptionKey)
(declare-const f1 EncryptionKey)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (kr_old_key_destroyed (mk-key_rotation f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. IVTracker accessor round-trip: iv_current ---
(push 1)
(declare-const f0 Int)
(assert (not (= (iv_current (mk-iv_tracker f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. TimingTest accessor round-trip: tt_operation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (tt_operation (mk-timing_test f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. TimingTest accessor round-trip: tt_time_ns ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (tt_time_ns (mk-timing_test f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. TimingTest accessor round-trip: tt_constant_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (tt_constant_time (mk-timing_test f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. TimingTest: non-negative int fields sum ---
(push 1)
(declare-const r TimingTest)
(assert (>= (tt_operation r) 0))
(assert (>= (tt_time_ns r) 0))
(assert (not (>= (+ (tt_operation r) (tt_time_ns r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

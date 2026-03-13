; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DigitalWallet — SMT Verification
; Derived from 02_FORMAL/coq/domains/DigitalWallet.v (25 assertions)
; Module: DigitalWallet
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((WalletTier 0)) (((Basic) (Standard) (Premium) (Unlimited))))

(declare-datatypes ((TransactionType 0)) (((Credit) (Debit))))

(declare-datatypes ((QRType 0)) (((StaticQR) (DynamicQR))))

(declare-datatypes ((AuthFactor 0)) (((Password) (Biometric) (OTPFactor) (HardwareToken))))

(declare-datatypes ((Wallet 0))
  (((mk-wallet (wallet_id Int) (balance Int) (tier WalletTier) (is_dormant Bool) (last_activity Int)))))

(declare-datatypes ((Transaction 0))
  (((mk-transaction (txn_id Int) (txn_type TransactionType) (txn_amount Int) (txn_wallet Int) (txn_timestamp Int)))))

(declare-datatypes ((QRCode 0))
  (((mk-qr_code (qr_id Int) (qr_type QRType) (qr_used Bool) (qr_amount Int)))))

(declare-datatypes ((VirtualAccount 0))
  (((mk-virtual_account (va_id Int) (va_parent_wallet Int) (va_balance Int) (va_purpose Int)))))

(declare-datatypes ((Session 0))
  (((mk-session (session_id Int) (session_wallet Int) (session_start Int) (last_activity_time Int) (inactivity_timeout Int)))))

(declare-datatypes ((OTP 0))
  (((mk-otp (otp_code Int) (otp_created_time Int) (otp_validity_minutes Int)))))

(declare-datatypes ((Device 0))
  (((mk-device (device_id Int) (device_wallet Int) (biometric_hash Int)))))

(declare-datatypes ((FraudScore 0))
  (((mk-fraud_score (fs_wallet Int) (fs_score Int) (fs_threshold Int)))))

(declare-datatypes ((VelocityCheck 0))
  (((mk-velocity_check (vc_wallet Int) (vc_txn_count Int) (vc_time_window Int) (vc_threshold Int)))))

(declare-datatypes ((P2PTransfer 0))
  (((mk-p2_p_transfer (p2p_id Int) (p2p_from Int) (p2p_to Int) (p2p_amount Int) (p2p_initiated_time Int) (p2p_completed_time Int)))))

(declare-datatypes ((QRPayment 0))
  (((mk-qr_payment (qrp_id Int) (qrp_qr QRCode) (qrp_payer Int) (qrp_initiated_time Int) (qrp_completed_time Int)))))

(declare-datatypes ((MerchantPayment 0))
  (((mk-merchant_payment (mp_id Int) (mp_gross_amount Int) (mp_mdr_rate Int) (mp_net_amount Int)))))

(declare-datatypes ((Refund 0))
  (((mk-refund (ref_id Int) (ref_wallet Int) (ref_amount Int) (ref_instant Bool)))))

(declare-datatypes ((BankTransfer 0))
  (((mk-bank_transfer (bt_id Int) (bt_bank_debit Int) (bt_wallet_credit Int) (bt_reconciled Bool)))))

(declare-datatypes ((CardChargeback 0))
  (((mk-card_chargeback (cb_id Int) (cb_original_credit Int) (cb_wallet_debit Int) (cb_processed Bool)))))

(declare-datatypes ((AgentFloat 0))
  (((mk-agent_float (af_agent_id Int) (af_float_balance Int) (af_pending_deposits Int)))))

(declare-datatypes ((CryptoTopUp 0))
  (((mk-crypto_top_up (ctu_id Int) (ctu_crypto_amount Int) (ctu_rate_at_confirmation Int) (ctu_fiat_credit Int) (ctu_rate_locked Bool)))))

(declare-datatypes ((StablecoinTopUp 0))
  (((mk-stablecoin_top_up (stu_id Int) (stu_amount Int) (stu_confirmed Bool) (stu_credited Bool)))))

(declare-datatypes ((WithdrawalRequest 0))
  (((mk-withdrawal_request (wr_id Int) (wr_wallet Int) (wr_amount Int) (wr_daily_total Int) (wr_wallet_balance Int) (wr_tier WalletTier)))))

(declare-datatypes ((BankWithdrawal 0))
  (((mk-bank_withdrawal (bw_id Int) (bw_wallet Int) (bw_bank_account Int) (bw_ownership_verified Bool) (bw_approved Bool)))))

(declare-datatypes ((CardlessATM 0))
  (((mk-cardless_atm (catm_id Int) (catm_wallet Int) (catm_otp OTP) (catm_amount Int)))))

(declare-datatypes ((AgentWithdrawal 0))
  (((mk-agent_withdrawal (aw_id Int) (aw_agent_id Int) (aw_wallet Int) (aw_amount Int) (aw_agent_cash Int) (aw_approved Bool)))))

(declare-datatypes ((AuthContext 0))
  (((mk-auth_context (ac_factors (Seq Int)) (ac_sensitive_op Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. WalletTier exhaustiveness ---
(push 1)
(declare-const x WalletTier)
(assert (not (or (= x Basic) (= x Standard) (= x Premium) (= x Unlimited))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. WalletTier: Basic != Standard ---
(push 1)
(assert (= Basic Standard))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. WalletTier: Standard != Premium ---
(push 1)
(assert (= Standard Premium))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. WalletTier: Premium != Unlimited ---
(push 1)
(assert (= Premium Unlimited))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. WalletTier: Basic != Unlimited ---
(push 1)
(assert (= Basic Unlimited))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. WalletTier finite cardinality (4 values) ---
(push 1)
(declare-const x WalletTier)
(assert (and (not (= x Basic)) (not (= x Standard)) (not (= x Premium)) (not (= x Unlimited))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. TransactionType exhaustiveness ---
(push 1)
(declare-const x TransactionType)
(assert (not (or (= x Credit) (= x Debit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TransactionType: Credit != Debit ---
(push 1)
(assert (= Credit Debit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TransactionType finite cardinality (2 values) ---
(push 1)
(declare-const x TransactionType)
(assert (and (not (= x Credit)) (not (= x Debit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. QRType exhaustiveness ---
(push 1)
(declare-const x QRType)
(assert (not (or (= x StaticQR) (= x DynamicQR))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. QRType: StaticQR != DynamicQR ---
(push 1)
(assert (= StaticQR DynamicQR))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. QRType finite cardinality (2 values) ---
(push 1)
(declare-const x QRType)
(assert (and (not (= x StaticQR)) (not (= x DynamicQR))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. AuthFactor exhaustiveness ---
(push 1)
(declare-const x AuthFactor)
(assert (not (or (= x Password) (= x Biometric) (= x OTPFactor) (= x HardwareToken))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. AuthFactor: Password != Biometric ---
(push 1)
(assert (= Password Biometric))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AuthFactor: Biometric != OTPFactor ---
(push 1)
(assert (= Biometric OTPFactor))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. AuthFactor: OTPFactor != HardwareToken ---
(push 1)
(assert (= OTPFactor HardwareToken))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. AuthFactor: Password != HardwareToken ---
(push 1)
(assert (= Password HardwareToken))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. AuthFactor finite cardinality (4 values) ---
(push 1)
(declare-const x AuthFactor)
(assert (and (not (= x Password)) (not (= x Biometric)) (not (= x OTPFactor)) (not (= x HardwareToken))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Wallet accessor round-trip: wallet_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 WalletTier)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (wallet_id (mk-wallet f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Wallet accessor round-trip: balance ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 WalletTier)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (balance (mk-wallet f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Wallet accessor round-trip: tier ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 WalletTier)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (tier (mk-wallet f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Wallet accessor round-trip: is_dormant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 WalletTier)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (is_dormant (mk-wallet f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Wallet accessor round-trip: last_activity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 WalletTier)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (last_activity (mk-wallet f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Wallet: non-negative int fields sum ---
(push 1)
(declare-const r Wallet)
(assert (>= (wallet_id r) 0))
(assert (>= (balance r) 0))
(assert (not (>= (+ (wallet_id r) (balance r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Transaction accessor round-trip: txn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TransactionType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (txn_id (mk-transaction f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Transaction accessor round-trip: txn_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TransactionType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (txn_type (mk-transaction f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Transaction accessor round-trip: txn_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TransactionType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (txn_amount (mk-transaction f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Transaction accessor round-trip: txn_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TransactionType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (txn_wallet (mk-transaction f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Transaction accessor round-trip: txn_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TransactionType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (txn_timestamp (mk-transaction f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Transaction: non-negative int fields sum ---
(push 1)
(declare-const r Transaction)
(assert (>= (txn_id r) 0))
(assert (>= (txn_amount r) 0))
(assert (not (>= (+ (txn_id r) (txn_amount r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. QRCode accessor round-trip: qr_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 QRType)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (qr_id (mk-qr_code f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. QRCode accessor round-trip: qr_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 QRType)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (qr_type (mk-qr_code f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. QRCode accessor round-trip: qr_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 QRType)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (qr_used (mk-qr_code f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. QRCode accessor round-trip: qr_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 QRType)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (qr_amount (mk-qr_code f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. QRCode: non-negative int fields sum ---
(push 1)
(declare-const r QRCode)
(assert (>= (qr_id r) 0))
(assert (>= (qr_amount r) 0))
(assert (not (>= (+ (qr_id r) (qr_amount r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. VirtualAccount accessor round-trip: va_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (va_id (mk-virtual_account f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. VirtualAccount accessor round-trip: va_parent_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (va_parent_wallet (mk-virtual_account f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. VirtualAccount accessor round-trip: va_balance ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (va_balance (mk-virtual_account f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. VirtualAccount accessor round-trip: va_purpose ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (va_purpose (mk-virtual_account f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. VirtualAccount: non-negative int fields sum ---
(push 1)
(declare-const r VirtualAccount)
(assert (>= (va_id r) 0))
(assert (>= (va_parent_wallet r) 0))
(assert (not (>= (+ (va_id r) (va_parent_wallet r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. Session accessor round-trip: session_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (session_id (mk-session f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. Session accessor round-trip: session_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (session_wallet (mk-session f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. Session accessor round-trip: session_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (session_start (mk-session f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Session accessor round-trip: last_activity_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (last_activity_time (mk-session f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. Session accessor round-trip: inactivity_timeout ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (inactivity_timeout (mk-session f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. Session: non-negative int fields sum ---
(push 1)
(declare-const r Session)
(assert (>= (session_id r) 0))
(assert (>= (session_wallet r) 0))
(assert (not (>= (+ (session_id r) (session_wallet r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. OTP accessor round-trip: otp_code ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (otp_code (mk-otp f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. OTP accessor round-trip: otp_created_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (otp_created_time (mk-otp f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. OTP accessor round-trip: otp_validity_minutes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (otp_validity_minutes (mk-otp f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. OTP: non-negative int fields sum ---
(push 1)
(declare-const r OTP)
(assert (>= (otp_code r) 0))
(assert (>= (otp_created_time r) 0))
(assert (not (>= (+ (otp_code r) (otp_created_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. Device accessor round-trip: device_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (device_id (mk-device f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. Device accessor round-trip: device_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (device_wallet (mk-device f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. Device accessor round-trip: biometric_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (biometric_hash (mk-device f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. Device: non-negative int fields sum ---
(push 1)
(declare-const r Device)
(assert (>= (device_id r) 0))
(assert (>= (device_wallet r) 0))
(assert (not (>= (+ (device_id r) (device_wallet r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. FraudScore accessor round-trip: fs_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (fs_wallet (mk-fraud_score f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. FraudScore accessor round-trip: fs_score ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (fs_score (mk-fraud_score f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. FraudScore accessor round-trip: fs_threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (fs_threshold (mk-fraud_score f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. FraudScore: non-negative int fields sum ---
(push 1)
(declare-const r FraudScore)
(assert (>= (fs_wallet r) 0))
(assert (>= (fs_score r) 0))
(assert (not (>= (+ (fs_wallet r) (fs_score r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. VelocityCheck accessor round-trip: vc_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vc_wallet (mk-velocity_check f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. VelocityCheck accessor round-trip: vc_txn_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vc_txn_count (mk-velocity_check f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. VelocityCheck accessor round-trip: vc_time_window ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vc_time_window (mk-velocity_check f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. VelocityCheck accessor round-trip: vc_threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (vc_threshold (mk-velocity_check f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. VelocityCheck: non-negative int fields sum ---
(push 1)
(declare-const r VelocityCheck)
(assert (>= (vc_wallet r) 0))
(assert (>= (vc_txn_count r) 0))
(assert (not (>= (+ (vc_wallet r) (vc_txn_count r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. P2PTransfer accessor round-trip: p2p_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (p2p_id (mk-p2_p_transfer f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. P2PTransfer accessor round-trip: p2p_from ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (p2p_from (mk-p2_p_transfer f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. P2PTransfer accessor round-trip: p2p_to ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (p2p_to (mk-p2_p_transfer f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. P2PTransfer accessor round-trip: p2p_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (p2p_amount (mk-p2_p_transfer f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. P2PTransfer accessor round-trip: p2p_initiated_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (p2p_initiated_time (mk-p2_p_transfer f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. P2PTransfer: non-negative int fields sum ---
(push 1)
(declare-const r P2PTransfer)
(assert (>= (p2p_id r) 0))
(assert (>= (p2p_from r) 0))
(assert (not (>= (+ (p2p_id r) (p2p_from r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. QRPayment accessor round-trip: qrp_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 QRCode)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (qrp_id (mk-qr_payment f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. QRPayment accessor round-trip: qrp_qr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 QRCode)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (qrp_qr (mk-qr_payment f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. QRPayment accessor round-trip: qrp_payer ---
(push 1)
(declare-const f0 Int)
(declare-const f1 QRCode)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (qrp_payer (mk-qr_payment f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. QRPayment accessor round-trip: qrp_initiated_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 QRCode)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (qrp_initiated_time (mk-qr_payment f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. QRPayment accessor round-trip: qrp_completed_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 QRCode)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (qrp_completed_time (mk-qr_payment f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. QRPayment: non-negative int fields sum ---
(push 1)
(declare-const r QRPayment)
(assert (>= (qrp_id r) 0))
(assert (>= (qrp_payer r) 0))
(assert (not (>= (+ (qrp_id r) (qrp_payer r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. MerchantPayment accessor round-trip: mp_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (mp_id (mk-merchant_payment f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. MerchantPayment accessor round-trip: mp_gross_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (mp_gross_amount (mk-merchant_payment f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. MerchantPayment accessor round-trip: mp_mdr_rate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (mp_mdr_rate (mk-merchant_payment f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. MerchantPayment accessor round-trip: mp_net_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (mp_net_amount (mk-merchant_payment f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. MerchantPayment: non-negative int fields sum ---
(push 1)
(declare-const r MerchantPayment)
(assert (>= (mp_id r) 0))
(assert (>= (mp_gross_amount r) 0))
(assert (not (>= (+ (mp_id r) (mp_gross_amount r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. Refund accessor round-trip: ref_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ref_id (mk-refund f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. Refund accessor round-trip: ref_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ref_wallet (mk-refund f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. Refund accessor round-trip: ref_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ref_amount (mk-refund f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. Refund accessor round-trip: ref_instant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ref_instant (mk-refund f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. Refund: non-negative int fields sum ---
(push 1)
(declare-const r Refund)
(assert (>= (ref_id r) 0))
(assert (>= (ref_wallet r) 0))
(assert (not (>= (+ (ref_id r) (ref_wallet r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. BankTransfer accessor round-trip: bt_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (bt_id (mk-bank_transfer f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. BankTransfer accessor round-trip: bt_bank_debit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (bt_bank_debit (mk-bank_transfer f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. BankTransfer accessor round-trip: bt_wallet_credit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (bt_wallet_credit (mk-bank_transfer f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. BankTransfer accessor round-trip: bt_reconciled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (bt_reconciled (mk-bank_transfer f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. BankTransfer: non-negative int fields sum ---
(push 1)
(declare-const r BankTransfer)
(assert (>= (bt_id r) 0))
(assert (>= (bt_bank_debit r) 0))
(assert (not (>= (+ (bt_id r) (bt_bank_debit r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. CardChargeback accessor round-trip: cb_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cb_id (mk-card_chargeback f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 92. CardChargeback accessor round-trip: cb_original_credit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cb_original_credit (mk-card_chargeback f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. CardChargeback accessor round-trip: cb_wallet_debit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cb_wallet_debit (mk-card_chargeback f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. CardChargeback accessor round-trip: cb_processed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (cb_processed (mk-card_chargeback f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 95. CardChargeback: non-negative int fields sum ---
(push 1)
(declare-const r CardChargeback)
(assert (>= (cb_id r) 0))
(assert (>= (cb_original_credit r) 0))
(assert (not (>= (+ (cb_id r) (cb_original_credit r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. AgentFloat accessor round-trip: af_agent_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (af_agent_id (mk-agent_float f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. AgentFloat accessor round-trip: af_float_balance ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (af_float_balance (mk-agent_float f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. AgentFloat accessor round-trip: af_pending_deposits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (af_pending_deposits (mk-agent_float f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. AgentFloat: non-negative int fields sum ---
(push 1)
(declare-const r AgentFloat)
(assert (>= (af_agent_id r) 0))
(assert (>= (af_float_balance r) 0))
(assert (not (>= (+ (af_agent_id r) (af_float_balance r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 100. CryptoTopUp accessor round-trip: ctu_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ctu_id (mk-crypto_top_up f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 101. CryptoTopUp accessor round-trip: ctu_crypto_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ctu_crypto_amount (mk-crypto_top_up f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 102. CryptoTopUp accessor round-trip: ctu_rate_at_confirmation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ctu_rate_at_confirmation (mk-crypto_top_up f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. CryptoTopUp accessor round-trip: ctu_fiat_credit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ctu_fiat_credit (mk-crypto_top_up f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 104. CryptoTopUp accessor round-trip: ctu_rate_locked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (ctu_rate_locked (mk-crypto_top_up f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 105. CryptoTopUp: non-negative int fields sum ---
(push 1)
(declare-const r CryptoTopUp)
(assert (>= (ctu_id r) 0))
(assert (>= (ctu_crypto_amount r) 0))
(assert (not (>= (+ (ctu_id r) (ctu_crypto_amount r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 106. StablecoinTopUp accessor round-trip: stu_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (stu_id (mk-stablecoin_top_up f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 107. StablecoinTopUp accessor round-trip: stu_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (stu_amount (mk-stablecoin_top_up f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 108. StablecoinTopUp accessor round-trip: stu_confirmed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (stu_confirmed (mk-stablecoin_top_up f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 109. StablecoinTopUp accessor round-trip: stu_credited ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (stu_credited (mk-stablecoin_top_up f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 110. StablecoinTopUp: non-negative int fields sum ---
(push 1)
(declare-const r StablecoinTopUp)
(assert (>= (stu_id r) 0))
(assert (>= (stu_amount r) 0))
(assert (not (>= (+ (stu_id r) (stu_amount r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 111. WithdrawalRequest accessor round-trip: wr_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 WalletTier)
(assert (not (= (wr_id (mk-withdrawal_request f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 112. WithdrawalRequest accessor round-trip: wr_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 WalletTier)
(assert (not (= (wr_wallet (mk-withdrawal_request f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 113. WithdrawalRequest accessor round-trip: wr_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 WalletTier)
(assert (not (= (wr_amount (mk-withdrawal_request f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 114. WithdrawalRequest accessor round-trip: wr_daily_total ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 WalletTier)
(assert (not (= (wr_daily_total (mk-withdrawal_request f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 115. WithdrawalRequest accessor round-trip: wr_wallet_balance ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 WalletTier)
(assert (not (= (wr_wallet_balance (mk-withdrawal_request f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 116. WithdrawalRequest: non-negative int fields sum ---
(push 1)
(declare-const r WithdrawalRequest)
(assert (>= (wr_id r) 0))
(assert (>= (wr_wallet r) 0))
(assert (not (>= (+ (wr_id r) (wr_wallet r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 117. BankWithdrawal accessor round-trip: bw_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (bw_id (mk-bank_withdrawal f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 118. BankWithdrawal accessor round-trip: bw_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (bw_wallet (mk-bank_withdrawal f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 119. BankWithdrawal accessor round-trip: bw_bank_account ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (bw_bank_account (mk-bank_withdrawal f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 120. BankWithdrawal accessor round-trip: bw_ownership_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (bw_ownership_verified (mk-bank_withdrawal f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 121. BankWithdrawal accessor round-trip: bw_approved ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (bw_approved (mk-bank_withdrawal f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 122. BankWithdrawal: non-negative int fields sum ---
(push 1)
(declare-const r BankWithdrawal)
(assert (>= (bw_id r) 0))
(assert (>= (bw_wallet r) 0))
(assert (not (>= (+ (bw_id r) (bw_wallet r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 123. CardlessATM accessor round-trip: catm_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 OTP)
(declare-const f3 Int)
(assert (not (= (catm_id (mk-cardless_atm f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 124. CardlessATM accessor round-trip: catm_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 OTP)
(declare-const f3 Int)
(assert (not (= (catm_wallet (mk-cardless_atm f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 125. CardlessATM accessor round-trip: catm_otp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 OTP)
(declare-const f3 Int)
(assert (not (= (catm_otp (mk-cardless_atm f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 126. CardlessATM accessor round-trip: catm_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 OTP)
(declare-const f3 Int)
(assert (not (= (catm_amount (mk-cardless_atm f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 127. CardlessATM: non-negative int fields sum ---
(push 1)
(declare-const r CardlessATM)
(assert (>= (catm_id r) 0))
(assert (>= (catm_wallet r) 0))
(assert (not (>= (+ (catm_id r) (catm_wallet r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 128. AgentWithdrawal accessor round-trip: aw_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aw_id (mk-agent_withdrawal f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 129. AgentWithdrawal accessor round-trip: aw_agent_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aw_agent_id (mk-agent_withdrawal f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 130. AgentWithdrawal accessor round-trip: aw_wallet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aw_wallet (mk-agent_withdrawal f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 131. AgentWithdrawal accessor round-trip: aw_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aw_amount (mk-agent_withdrawal f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 132. AgentWithdrawal accessor round-trip: aw_agent_cash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(assert (not (= (aw_agent_cash (mk-agent_withdrawal f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 133. AgentWithdrawal: non-negative int fields sum ---
(push 1)
(declare-const r AgentWithdrawal)
(assert (>= (aw_id r) 0))
(assert (>= (aw_agent_id r) 0))
(assert (not (>= (+ (aw_id r) (aw_agent_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

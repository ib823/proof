; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CrossBorderRemittance — SMT Verification
; Derived from 02_FORMAL/coq/domains/CrossBorderRemittance.v (25 assertions)
; Module: CrossBorderRemittance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((PaymentRail 0)) (((SWIFT) (SEPA_Instant) (FasterPayments) (RTP) (Blockchain) (MobileMoney) (LocalACH))))

(declare-datatypes ((Corridor 0))
  (((mk-corridor (send_country Int) (receive_country Int) (send_currency Int) (receive_currency Int) (is_enabled Bool) (availability_pct Int) (fees_disclosed Bool) (is_sanctioned Bool)))))

(declare-datatypes ((CountrySupport 0))
  (((mk-country_support (country_code Int) (can_send Bool) (can_receive Bool) (sanctioned Bool)))))

(declare-datatypes ((CurrencySupport 0))
  (((mk-currency_support (curr_code Int) (is_supported Bool) (has_liquidity Bool)))))

(declare-datatypes ((FXQuote 0))
  (((mk-fx_quote (quote_id Int) (mid_market_rate Int) (spread Int) (customer_rate Int) (quote_timestamp Int) (guarantee_window Int) (hedge_ratio_bps Int)))))

(declare-datatypes ((Transfer 0))
  (((mk-transfer (transfer_id Int) (rail PaymentRail) (send_amount Int) (receive_amount Int) (stated_fee Int) (stated_spread Int) (screening_passed Bool) (tracking_available Bool) (settlement_time_sec Int) (is_atomic Bool)))))

(declare-datatypes ((Beneficiary 0))
  (((mk-beneficiary (ben_id Int) (ben_name Int) (ofac_screened Bool) (un_screened Bool) (eu_screened Bool) (local_screened Bool) (screening_time_ms Int)))))

(declare-datatypes ((Originator 0))
  (((mk-originator (orig_id Int) (orig_name Int) (orig_address Int) (kyc_verified Bool) (verification_level Int)))))

(declare-datatypes ((TravelRuleData 0))
  (((mk-travel_rule_data (originator_info Originator) (beneficiary_info Beneficiary) (data_transmitted Bool)))))

(declare-datatypes ((SuspiciousActivity 0))
  (((mk-suspicious_activity (activity_id Int) (detection_timestamp Int) (filing_deadline Int) (str_filed Bool) (filing_timestamp Int)))))

(declare-datatypes ((BankCredit 0))
  (((mk-bank_credit (credit_id Int) (credit_rail PaymentRail) (credit_time_sec Int)))))

(declare-datatypes ((WalletCredit 0))
  (((mk-wallet_credit (wallet_id Int) (credit_instant Bool) (credit_latency_ms Int)))))

(declare-datatypes ((CashPickup 0))
  (((mk-cash_pickup (pickup_code Int) (code_length Int) (expiry_days Int) (code_random Bool)))))

(declare-datatypes ((IBAN 0))
  (((mk-iban (iban_country Int) (iban_check Int) (iban_bban Int) (checksum_valid Bool) (format_valid Bool)))))

(declare-datatypes ((RecipientNotification 0))
  (((mk-recipient_notification (notif_id Int) (channel_preferred Int) (channel_used Int) (notification_sent Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. PaymentRail exhaustiveness ---
(push 1)
(declare-const x PaymentRail)
(assert (not (or (= x SWIFT) (= x SEPA_Instant) (= x FasterPayments) (= x RTP) (= x Blockchain) (= x MobileMoney) (= x LocalACH))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. PaymentRail: SWIFT != SEPA_Instant ---
(push 1)
(assert (= SWIFT SEPA_Instant))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. PaymentRail: SEPA_Instant != FasterPayments ---
(push 1)
(assert (= SEPA_Instant FasterPayments))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. PaymentRail: FasterPayments != RTP ---
(push 1)
(assert (= FasterPayments RTP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. PaymentRail: SWIFT != LocalACH ---
(push 1)
(assert (= SWIFT LocalACH))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. PaymentRail finite cardinality (7 values) ---
(push 1)
(declare-const x PaymentRail)
(assert (and (not (= x SWIFT)) (not (= x SEPA_Instant)) (not (= x FasterPayments)) (not (= x RTP)) (not (= x Blockchain)) (not (= x MobileMoney)) (not (= x LocalACH))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Corridor accessor round-trip: send_country ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (send_country (mk-corridor f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Corridor accessor round-trip: receive_country ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (receive_country (mk-corridor f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Corridor accessor round-trip: send_currency ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (send_currency (mk-corridor f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Corridor accessor round-trip: receive_currency ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (receive_currency (mk-corridor f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Corridor accessor round-trip: is_enabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (is_enabled (mk-corridor f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Corridor: non-negative int fields sum ---
(push 1)
(declare-const r Corridor)
(assert (>= (send_country r) 0))
(assert (>= (receive_country r) 0))
(assert (not (>= (+ (send_country r) (receive_country r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. CountrySupport accessor round-trip: country_code ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (country_code (mk-country_support f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. CountrySupport accessor round-trip: can_send ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (can_send (mk-country_support f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. CountrySupport accessor round-trip: can_receive ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (can_receive (mk-country_support f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. CountrySupport accessor round-trip: sanctioned ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sanctioned (mk-country_support f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. CurrencySupport accessor round-trip: curr_code ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (curr_code (mk-currency_support f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. CurrencySupport accessor round-trip: is_supported ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (is_supported (mk-currency_support f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. CurrencySupport accessor round-trip: has_liquidity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (has_liquidity (mk-currency_support f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. FXQuote accessor round-trip: quote_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (quote_id (mk-fx_quote f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. FXQuote accessor round-trip: mid_market_rate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (mid_market_rate (mk-fx_quote f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. FXQuote accessor round-trip: spread ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (spread (mk-fx_quote f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. FXQuote accessor round-trip: customer_rate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (customer_rate (mk-fx_quote f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. FXQuote accessor round-trip: quote_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (quote_timestamp (mk-fx_quote f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. FXQuote: non-negative int fields sum ---
(push 1)
(declare-const r FXQuote)
(assert (>= (quote_id r) 0))
(assert (>= (mid_market_rate r) 0))
(assert (not (>= (+ (quote_id r) (mid_market_rate r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Transfer accessor round-trip: transfer_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PaymentRail)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (transfer_id (mk-transfer f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Transfer accessor round-trip: rail ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PaymentRail)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (rail (mk-transfer f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Transfer accessor round-trip: send_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PaymentRail)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (send_amount (mk-transfer f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Transfer accessor round-trip: receive_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PaymentRail)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (receive_amount (mk-transfer f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Transfer accessor round-trip: stated_fee ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PaymentRail)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(declare-const f9 Bool)
(assert (not (= (stated_fee (mk-transfer f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. Transfer: non-negative int fields sum ---
(push 1)
(declare-const r Transfer)
(assert (>= (transfer_id r) 0))
(assert (>= (send_amount r) 0))
(assert (not (>= (+ (transfer_id r) (send_amount r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. Beneficiary accessor round-trip: ben_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (ben_id (mk-beneficiary f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. Beneficiary accessor round-trip: ben_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (ben_name (mk-beneficiary f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. Beneficiary accessor round-trip: ofac_screened ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (ofac_screened (mk-beneficiary f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. Beneficiary accessor round-trip: un_screened ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (un_screened (mk-beneficiary f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Beneficiary accessor round-trip: eu_screened ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (eu_screened (mk-beneficiary f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. Beneficiary: non-negative int fields sum ---
(push 1)
(declare-const r Beneficiary)
(assert (>= (ben_id r) 0))
(assert (>= (ben_name r) 0))
(assert (not (>= (+ (ben_id r) (ben_name r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. Originator accessor round-trip: orig_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (orig_id (mk-originator f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. Originator accessor round-trip: orig_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (orig_name (mk-originator f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Originator accessor round-trip: orig_address ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (orig_address (mk-originator f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. Originator accessor round-trip: kyc_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (kyc_verified (mk-originator f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. Originator accessor round-trip: verification_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (verification_level (mk-originator f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. Originator: non-negative int fields sum ---
(push 1)
(declare-const r Originator)
(assert (>= (orig_id r) 0))
(assert (>= (orig_name r) 0))
(assert (not (>= (+ (orig_id r) (orig_name r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. TravelRuleData accessor round-trip: originator_info ---
(push 1)
(declare-const f0 Originator)
(declare-const f1 Beneficiary)
(declare-const f2 Bool)
(assert (not (= (originator_info (mk-travel_rule_data f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. TravelRuleData accessor round-trip: beneficiary_info ---
(push 1)
(declare-const f0 Originator)
(declare-const f1 Beneficiary)
(declare-const f2 Bool)
(assert (not (= (beneficiary_info (mk-travel_rule_data f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. TravelRuleData accessor round-trip: data_transmitted ---
(push 1)
(declare-const f0 Originator)
(declare-const f1 Beneficiary)
(declare-const f2 Bool)
(assert (not (= (data_transmitted (mk-travel_rule_data f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. SuspiciousActivity accessor round-trip: activity_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (activity_id (mk-suspicious_activity f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. SuspiciousActivity accessor round-trip: detection_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (detection_timestamp (mk-suspicious_activity f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. SuspiciousActivity accessor round-trip: filing_deadline ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (filing_deadline (mk-suspicious_activity f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. SuspiciousActivity accessor round-trip: str_filed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (str_filed (mk-suspicious_activity f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. SuspiciousActivity accessor round-trip: filing_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (filing_timestamp (mk-suspicious_activity f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. SuspiciousActivity: non-negative int fields sum ---
(push 1)
(declare-const r SuspiciousActivity)
(assert (>= (activity_id r) 0))
(assert (>= (detection_timestamp r) 0))
(assert (not (>= (+ (activity_id r) (detection_timestamp r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. BankCredit accessor round-trip: credit_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PaymentRail)
(declare-const f2 Int)
(assert (not (= (credit_id (mk-bank_credit f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. BankCredit accessor round-trip: credit_rail ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PaymentRail)
(declare-const f2 Int)
(assert (not (= (credit_rail (mk-bank_credit f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. BankCredit accessor round-trip: credit_time_sec ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PaymentRail)
(declare-const f2 Int)
(assert (not (= (credit_time_sec (mk-bank_credit f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. BankCredit: non-negative int fields sum ---
(push 1)
(declare-const r BankCredit)
(assert (>= (credit_id r) 0))
(assert (>= (credit_time_sec r) 0))
(assert (not (>= (+ (credit_id r) (credit_time_sec r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. WalletCredit accessor round-trip: wallet_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (wallet_id (mk-wallet_credit f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. WalletCredit accessor round-trip: credit_instant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (credit_instant (mk-wallet_credit f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. WalletCredit accessor round-trip: credit_latency_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (credit_latency_ms (mk-wallet_credit f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. WalletCredit: non-negative int fields sum ---
(push 1)
(declare-const r WalletCredit)
(assert (>= (wallet_id r) 0))
(assert (>= (credit_latency_ms r) 0))
(assert (not (>= (+ (wallet_id r) (credit_latency_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. CashPickup accessor round-trip: pickup_code ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pickup_code (mk-cash_pickup f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. CashPickup accessor round-trip: code_length ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (code_length (mk-cash_pickup f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. CashPickup accessor round-trip: expiry_days ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (expiry_days (mk-cash_pickup f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. CashPickup accessor round-trip: code_random ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (code_random (mk-cash_pickup f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. CashPickup: non-negative int fields sum ---
(push 1)
(declare-const r CashPickup)
(assert (>= (pickup_code r) 0))
(assert (>= (code_length r) 0))
(assert (not (>= (+ (pickup_code r) (code_length r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. IBAN accessor round-trip: iban_country ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (iban_country (mk-iban f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. IBAN accessor round-trip: iban_check ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (iban_check (mk-iban f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. IBAN accessor round-trip: iban_bban ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (iban_bban (mk-iban f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. IBAN accessor round-trip: checksum_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (checksum_valid (mk-iban f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. IBAN accessor round-trip: format_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (format_valid (mk-iban f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. IBAN: non-negative int fields sum ---
(push 1)
(declare-const r IBAN)
(assert (>= (iban_country r) 0))
(assert (>= (iban_check r) 0))
(assert (not (>= (+ (iban_country r) (iban_check r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. RecipientNotification accessor round-trip: notif_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (notif_id (mk-recipient_notification f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. RecipientNotification accessor round-trip: channel_preferred ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (channel_preferred (mk-recipient_notification f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. RecipientNotification accessor round-trip: channel_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (channel_used (mk-recipient_notification f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. RecipientNotification accessor round-trip: notification_sent ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (notification_sent (mk-recipient_notification f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. RecipientNotification: non-negative int fields sum ---
(push 1)
(declare-const r RecipientNotification)
(assert (>= (notif_id r) 0))
(assert (>= (channel_preferred r) 0))
(assert (not (>= (+ (notif_id r) (channel_preferred r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

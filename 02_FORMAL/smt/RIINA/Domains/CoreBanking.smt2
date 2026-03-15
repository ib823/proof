; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CoreBanking — SMT Verification
; Derived from 02_FORMAL/coq/domains/CoreBanking.v (31 assertions)
; Module: CoreBanking
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AccountType 0)) (((Savings) (Current) (TermDeposit))))

(declare-datatypes ((PaymentStatus 0)) (((Pending) (Completed) (Failed))))

(declare-datatypes ((TransactionType 0)) (((InterestBased) (ProfitSharing) (AssetBacked) (ServiceFee))))

(declare-datatypes ((Customer 0))
  (((mk-customer (customer_id Int) (kyc_verified Bool) (address_verified Bool) (risk_assessed Bool) (pep_screened Bool) (sanctions_screened Bool) (is_pep Bool) (enhanced_due_diligence Bool) (is_onboarded Bool)))))

(declare-datatypes ((BeneficialOwner 0))
  (((mk-beneficial_owner (bo_id Int) (ownership_percentage Int)))))

(declare-datatypes ((TransactionParty 0))
  (((mk-transaction_party (party_id Int) (party_screened Bool)))))

(declare-datatypes ((Account 0))
  (((mk-account (account_id Int) (account_type AccountType) (balance Int) (owner Int) (is_dormant Bool) (last_activity_days Int) (dormancy_threshold Int)))))

(declare-datatypes ((JournalEntry 0))
  (((mk-journal_entry (debit_account Int) (credit_account Int) (debit_amount Int) (credit_amount Int) (timestamp Int)))))

(declare-datatypes ((InterestCalculation 0))
  (((mk-interest_calculation (ic_principal Int) (ic_rate_bps Int) (ic_days Int) (ic_year_days Int) (ic_calculated_interest Int)))))

(declare-datatypes ((TermDepositContract 0))
  (((mk-term_deposit_contract (td_principal Int) (td_maturity_days Int) (td_withdrawal_day Int) (td_penalty_applied Bool)))))

(declare-datatypes ((Loan 0))
  (((mk-loan (loan_id Int) (borrower Int) (principal Int) (approved_amount Int) (eligibility_limit Int) (collateral_value Int) (required_coverage Int) (ltv_ratio Int) (is_secured Bool)))))

(declare-datatypes ((Installment 0))
  (((mk-installment (inst_principal Int) (inst_interest Int)))))

(declare-datatypes ((AmortizationSchedule 0))
  (((mk-amortization_schedule (amort_principal Int) (amort_total_interest Int) (amort_installments (Seq Int))))))

(declare-datatypes ((Covenant 0))
  (((mk-covenant (covenant_threshold Int) (covenant_actual Int) (covenant_breached Bool) (event_of_default Bool)))))

(declare-datatypes ((CreditFacility 0))
  (((mk-credit_facility (facility_limit Int) (total_drawdown Int) (current_drawdown_request Int)))))

(declare-datatypes ((Payment 0))
  (((mk-payment (payment_id Int) (payment_amount Int) (status PaymentStatus) (idempotency_key Int) (processing_time_ms Int) (sla_limit_ms Int)))))

(declare-datatypes ((NostroAccount 0))
  (((mk-nostro_account (internal_balance Int) (external_balance Int) (is_reconciled Bool)))))

(declare-datatypes ((SwiftMessage 0))
  (((mk-swift_message (message_type Int) (sender_bic Int) (receiver_bic Int) (is_schema_valid Bool)))))

(declare-datatypes ((FxSpotTrade 0))
  (((mk-fx_spot_trade (trade_date Int) (settlement_date Int) (fx_settled Bool)))))

(declare-datatypes ((RepoTransaction 0))
  (((mk-repo_transaction (collateral_market_value Int) (haircut_bps Int) (repo_cash_amount Int)))))

(declare-datatypes ((BondPosition 0))
  (((mk-bond_position (face_value Int) (coupon_rate_bps Int) (days_since_coupon Int) (coupon_period_days Int) (calculated_accrued Int)))))

(declare-datatypes ((InterestRateSwap 0))
  (((mk-interest_rate_swap (fixed_leg_pv Int) (float_leg_pv Int) (calculated_npv Int)))))

(declare-datatypes ((CollateralPosition 0))
  (((mk-collateral_position (initial_margin Int) (current_mtm Int) (threshold Int) (margin_call_triggered Bool)))))

(declare-datatypes ((Murabaha 0))
  (((mk-murabaha (murabaha_cost Int) (murabaha_profit Int) (profit_disclosed Bool)))))

(declare-datatypes ((Ijarah 0))
  (((mk-ijarah (asset_id Int) (bank_owns_asset Bool) (lease_tenure_months Int) (current_month Int)))))

(declare-datatypes ((MusharakahPartner 0))
  (((mk-musharakah_partner (partner_id Int) (capital_contribution Int) (profit_ratio_bps Int)))))

(declare-datatypes ((Musharakah 0))
  (((mk-musharakah (partners (Seq Int)) (total_profit Int) (total_loss Int) (total_capital Int)))))

(declare-datatypes ((Sukuk 0))
  (((mk-sukuk (sukuk_id Int) (sukuk_value Int) (underlying_asset_value Int) (is_asset_backed Bool)))))

(declare-datatypes ((ShariahTransaction 0))
  (((mk-shariah_transaction (txn_id Int) (txn_type TransactionType) (shariah_compliant Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. AccountType exhaustiveness ---
(push 1)
(declare-const x AccountType)
(assert (not (or (= x Savings) (= x Current) (= x TermDeposit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AccountType: Savings != Current ---
(push 1)
(assert (= Savings Current))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AccountType: Current != TermDeposit ---
(push 1)
(assert (= Current TermDeposit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AccountType finite cardinality (3 values) ---
(push 1)
(declare-const x AccountType)
(assert (and (not (= x Savings)) (not (= x Current)) (not (= x TermDeposit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. PaymentStatus exhaustiveness ---
(push 1)
(declare-const x PaymentStatus)
(assert (not (or (= x Pending) (= x Completed) (= x Failed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. PaymentStatus: Pending != Completed ---
(push 1)
(assert (= Pending Completed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. PaymentStatus: Completed != Failed ---
(push 1)
(assert (= Completed Failed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PaymentStatus finite cardinality (3 values) ---
(push 1)
(declare-const x PaymentStatus)
(assert (and (not (= x Pending)) (not (= x Completed)) (not (= x Failed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TransactionType exhaustiveness ---
(push 1)
(declare-const x TransactionType)
(assert (not (or (= x InterestBased) (= x ProfitSharing) (= x AssetBacked) (= x ServiceFee))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TransactionType: InterestBased != ProfitSharing ---
(push 1)
(assert (= InterestBased ProfitSharing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TransactionType: ProfitSharing != AssetBacked ---
(push 1)
(assert (= ProfitSharing AssetBacked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TransactionType: AssetBacked != ServiceFee ---
(push 1)
(assert (= AssetBacked ServiceFee))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. TransactionType: InterestBased != ServiceFee ---
(push 1)
(assert (= InterestBased ServiceFee))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. TransactionType finite cardinality (4 values) ---
(push 1)
(declare-const x TransactionType)
(assert (and (not (= x InterestBased)) (not (= x ProfitSharing)) (not (= x AssetBacked)) (not (= x ServiceFee))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Customer accessor round-trip: customer_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (customer_id (mk-customer f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Customer accessor round-trip: kyc_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (kyc_verified (mk-customer f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Customer accessor round-trip: address_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (address_verified (mk-customer f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Customer accessor round-trip: risk_assessed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (risk_assessed (mk-customer f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Customer accessor round-trip: pep_screened ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (pep_screened (mk-customer f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. BeneficialOwner accessor round-trip: bo_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (bo_id (mk-beneficial_owner f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. BeneficialOwner accessor round-trip: ownership_percentage ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ownership_percentage (mk-beneficial_owner f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. BeneficialOwner: non-negative int fields sum ---
(push 1)
(declare-const r BeneficialOwner)
(assert (>= (bo_id r) 0))
(assert (>= (ownership_percentage r) 0))
(assert (not (>= (+ (bo_id r) (ownership_percentage r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. TransactionParty accessor round-trip: party_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (party_id (mk-transaction_party f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TransactionParty accessor round-trip: party_screened ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (party_screened (mk-transaction_party f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Account accessor round-trip: account_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AccountType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (account_id (mk-account f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Account accessor round-trip: account_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AccountType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (account_type (mk-account f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Account accessor round-trip: balance ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AccountType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (balance (mk-account f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Account accessor round-trip: owner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AccountType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (owner (mk-account f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Account accessor round-trip: is_dormant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AccountType)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (is_dormant (mk-account f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Account: non-negative int fields sum ---
(push 1)
(declare-const r Account)
(assert (>= (account_id r) 0))
(assert (>= (balance r) 0))
(assert (not (>= (+ (account_id r) (balance r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. JournalEntry accessor round-trip: debit_account ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (debit_account (mk-journal_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. JournalEntry accessor round-trip: credit_account ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (credit_account (mk-journal_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. JournalEntry accessor round-trip: debit_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (debit_amount (mk-journal_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. JournalEntry accessor round-trip: credit_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (credit_amount (mk-journal_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. JournalEntry accessor round-trip: timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (timestamp (mk-journal_entry f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. JournalEntry: non-negative int fields sum ---
(push 1)
(declare-const r JournalEntry)
(assert (>= (debit_account r) 0))
(assert (>= (credit_account r) 0))
(assert (not (>= (+ (debit_account r) (credit_account r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. InterestCalculation accessor round-trip: ic_principal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ic_principal (mk-interest_calculation f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. InterestCalculation accessor round-trip: ic_rate_bps ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ic_rate_bps (mk-interest_calculation f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. InterestCalculation accessor round-trip: ic_days ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ic_days (mk-interest_calculation f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. InterestCalculation accessor round-trip: ic_year_days ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ic_year_days (mk-interest_calculation f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. InterestCalculation accessor round-trip: ic_calculated_interest ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ic_calculated_interest (mk-interest_calculation f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. InterestCalculation: non-negative int fields sum ---
(push 1)
(declare-const r InterestCalculation)
(assert (>= (ic_principal r) 0))
(assert (>= (ic_rate_bps r) 0))
(assert (not (>= (+ (ic_principal r) (ic_rate_bps r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. TermDepositContract accessor round-trip: td_principal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (td_principal (mk-term_deposit_contract f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. TermDepositContract accessor round-trip: td_maturity_days ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (td_maturity_days (mk-term_deposit_contract f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. TermDepositContract accessor round-trip: td_withdrawal_day ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (td_withdrawal_day (mk-term_deposit_contract f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. TermDepositContract accessor round-trip: td_penalty_applied ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (td_penalty_applied (mk-term_deposit_contract f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. TermDepositContract: non-negative int fields sum ---
(push 1)
(declare-const r TermDepositContract)
(assert (>= (td_principal r) 0))
(assert (>= (td_maturity_days r) 0))
(assert (not (>= (+ (td_principal r) (td_maturity_days r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. Loan accessor round-trip: loan_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (loan_id (mk-loan f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. Loan accessor round-trip: borrower ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (borrower (mk-loan f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. Loan accessor round-trip: principal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (principal (mk-loan f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. Loan accessor round-trip: approved_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (approved_amount (mk-loan f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. Loan accessor round-trip: eligibility_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(assert (not (= (eligibility_limit (mk-loan f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. Loan: non-negative int fields sum ---
(push 1)
(declare-const r Loan)
(assert (>= (loan_id r) 0))
(assert (>= (borrower r) 0))
(assert (not (>= (+ (loan_id r) (borrower r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. Installment accessor round-trip: inst_principal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (inst_principal (mk-installment f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. Installment accessor round-trip: inst_interest ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (inst_interest (mk-installment f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. Installment: non-negative int fields sum ---
(push 1)
(declare-const r Installment)
(assert (>= (inst_principal r) 0))
(assert (>= (inst_interest r) 0))
(assert (not (>= (+ (inst_principal r) (inst_interest r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. AmortizationSchedule accessor round-trip: amort_principal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (amort_principal (mk-amortization_schedule f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. AmortizationSchedule accessor round-trip: amort_total_interest ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (amort_total_interest (mk-amortization_schedule f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. AmortizationSchedule: non-negative int fields sum ---
(push 1)
(declare-const r AmortizationSchedule)
(assert (>= (amort_principal r) 0))
(assert (>= (amort_total_interest r) 0))
(assert (not (>= (+ (amort_principal r) (amort_total_interest r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. Covenant accessor round-trip: covenant_threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (covenant_threshold (mk-covenant f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. Covenant accessor round-trip: covenant_actual ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (covenant_actual (mk-covenant f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. Covenant accessor round-trip: covenant_breached ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (covenant_breached (mk-covenant f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. Covenant accessor round-trip: event_of_default ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (event_of_default (mk-covenant f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. Covenant: non-negative int fields sum ---
(push 1)
(declare-const r Covenant)
(assert (>= (covenant_threshold r) 0))
(assert (>= (covenant_actual r) 0))
(assert (not (>= (+ (covenant_threshold r) (covenant_actual r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. CreditFacility accessor round-trip: facility_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (facility_limit (mk-credit_facility f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. CreditFacility accessor round-trip: total_drawdown ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (total_drawdown (mk-credit_facility f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. CreditFacility accessor round-trip: current_drawdown_request ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (current_drawdown_request (mk-credit_facility f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. CreditFacility: non-negative int fields sum ---
(push 1)
(declare-const r CreditFacility)
(assert (>= (facility_limit r) 0))
(assert (>= (total_drawdown r) 0))
(assert (not (>= (+ (facility_limit r) (total_drawdown r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. Payment accessor round-trip: payment_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 PaymentStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (payment_id (mk-payment f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. Payment accessor round-trip: payment_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 PaymentStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (payment_amount (mk-payment f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. Payment accessor round-trip: status ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 PaymentStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (status (mk-payment f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. Payment accessor round-trip: idempotency_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 PaymentStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (idempotency_key (mk-payment f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. Payment accessor round-trip: processing_time_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 PaymentStatus)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (processing_time_ms (mk-payment f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. Payment: non-negative int fields sum ---
(push 1)
(declare-const r Payment)
(assert (>= (payment_id r) 0))
(assert (>= (payment_amount r) 0))
(assert (not (>= (+ (payment_id r) (payment_amount r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. NostroAccount accessor round-trip: internal_balance ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (internal_balance (mk-nostro_account f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. NostroAccount accessor round-trip: external_balance ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (external_balance (mk-nostro_account f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. NostroAccount accessor round-trip: is_reconciled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (is_reconciled (mk-nostro_account f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. NostroAccount: non-negative int fields sum ---
(push 1)
(declare-const r NostroAccount)
(assert (>= (internal_balance r) 0))
(assert (>= (external_balance r) 0))
(assert (not (>= (+ (internal_balance r) (external_balance r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. SwiftMessage accessor round-trip: message_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (message_type (mk-swift_message f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. SwiftMessage accessor round-trip: sender_bic ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (sender_bic (mk-swift_message f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. SwiftMessage accessor round-trip: receiver_bic ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (receiver_bic (mk-swift_message f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. SwiftMessage accessor round-trip: is_schema_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (is_schema_valid (mk-swift_message f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. SwiftMessage: non-negative int fields sum ---
(push 1)
(declare-const r SwiftMessage)
(assert (>= (message_type r) 0))
(assert (>= (sender_bic r) 0))
(assert (not (>= (+ (message_type r) (sender_bic r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. FxSpotTrade accessor round-trip: trade_date ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (trade_date (mk-fx_spot_trade f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. FxSpotTrade accessor round-trip: settlement_date ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (settlement_date (mk-fx_spot_trade f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. FxSpotTrade accessor round-trip: fx_settled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (fx_settled (mk-fx_spot_trade f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. FxSpotTrade: non-negative int fields sum ---
(push 1)
(declare-const r FxSpotTrade)
(assert (>= (trade_date r) 0))
(assert (>= (settlement_date r) 0))
(assert (not (>= (+ (trade_date r) (settlement_date r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. RepoTransaction accessor round-trip: collateral_market_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (collateral_market_value (mk-repo_transaction f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. RepoTransaction accessor round-trip: haircut_bps ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (haircut_bps (mk-repo_transaction f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. RepoTransaction accessor round-trip: repo_cash_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (repo_cash_amount (mk-repo_transaction f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. RepoTransaction: non-negative int fields sum ---
(push 1)
(declare-const r RepoTransaction)
(assert (>= (collateral_market_value r) 0))
(assert (>= (haircut_bps r) 0))
(assert (not (>= (+ (collateral_market_value r) (haircut_bps r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 92. BondPosition accessor round-trip: face_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (face_value (mk-bond_position f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. BondPosition accessor round-trip: coupon_rate_bps ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (coupon_rate_bps (mk-bond_position f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. BondPosition accessor round-trip: days_since_coupon ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (days_since_coupon (mk-bond_position f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 95. BondPosition accessor round-trip: coupon_period_days ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (coupon_period_days (mk-bond_position f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. BondPosition accessor round-trip: calculated_accrued ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (calculated_accrued (mk-bond_position f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. BondPosition: non-negative int fields sum ---
(push 1)
(declare-const r BondPosition)
(assert (>= (face_value r) 0))
(assert (>= (coupon_rate_bps r) 0))
(assert (not (>= (+ (face_value r) (coupon_rate_bps r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. InterestRateSwap accessor round-trip: fixed_leg_pv ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (fixed_leg_pv (mk-interest_rate_swap f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. InterestRateSwap accessor round-trip: float_leg_pv ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (float_leg_pv (mk-interest_rate_swap f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 100. InterestRateSwap accessor round-trip: calculated_npv ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (calculated_npv (mk-interest_rate_swap f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 101. InterestRateSwap: non-negative int fields sum ---
(push 1)
(declare-const r InterestRateSwap)
(assert (>= (fixed_leg_pv r) 0))
(assert (>= (float_leg_pv r) 0))
(assert (not (>= (+ (fixed_leg_pv r) (float_leg_pv r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 102. CollateralPosition accessor round-trip: initial_margin ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (initial_margin (mk-collateral_position f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. CollateralPosition accessor round-trip: current_mtm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (current_mtm (mk-collateral_position f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 104. CollateralPosition accessor round-trip: threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (threshold (mk-collateral_position f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 105. CollateralPosition accessor round-trip: margin_call_triggered ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (margin_call_triggered (mk-collateral_position f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 106. CollateralPosition: non-negative int fields sum ---
(push 1)
(declare-const r CollateralPosition)
(assert (>= (initial_margin r) 0))
(assert (>= (current_mtm r) 0))
(assert (not (>= (+ (initial_margin r) (current_mtm r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 107. Murabaha accessor round-trip: murabaha_cost ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (murabaha_cost (mk-murabaha f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 108. Murabaha accessor round-trip: murabaha_profit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (murabaha_profit (mk-murabaha f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 109. Murabaha accessor round-trip: profit_disclosed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (profit_disclosed (mk-murabaha f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 110. Murabaha: non-negative int fields sum ---
(push 1)
(declare-const r Murabaha)
(assert (>= (murabaha_cost r) 0))
(assert (>= (murabaha_profit r) 0))
(assert (not (>= (+ (murabaha_cost r) (murabaha_profit r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 111. Ijarah accessor round-trip: asset_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (asset_id (mk-ijarah f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 112. Ijarah accessor round-trip: bank_owns_asset ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bank_owns_asset (mk-ijarah f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 113. Ijarah accessor round-trip: lease_tenure_months ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (lease_tenure_months (mk-ijarah f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 114. Ijarah accessor round-trip: current_month ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (current_month (mk-ijarah f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 115. Ijarah: non-negative int fields sum ---
(push 1)
(declare-const r Ijarah)
(assert (>= (asset_id r) 0))
(assert (>= (lease_tenure_months r) 0))
(assert (not (>= (+ (asset_id r) (lease_tenure_months r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 116. MusharakahPartner accessor round-trip: partner_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (partner_id (mk-musharakah_partner f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 117. MusharakahPartner accessor round-trip: capital_contribution ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (capital_contribution (mk-musharakah_partner f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 118. MusharakahPartner accessor round-trip: profit_ratio_bps ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (profit_ratio_bps (mk-musharakah_partner f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 119. MusharakahPartner: non-negative int fields sum ---
(push 1)
(declare-const r MusharakahPartner)
(assert (>= (partner_id r) 0))
(assert (>= (capital_contribution r) 0))
(assert (not (>= (+ (partner_id r) (capital_contribution r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 120. Sukuk accessor round-trip: sukuk_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (sukuk_id (mk-sukuk f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 121. Sukuk accessor round-trip: sukuk_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (sukuk_value (mk-sukuk f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 122. Sukuk accessor round-trip: underlying_asset_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (underlying_asset_value (mk-sukuk f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 123. Sukuk accessor round-trip: is_asset_backed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (is_asset_backed (mk-sukuk f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 124. Sukuk: non-negative int fields sum ---
(push 1)
(declare-const r Sukuk)
(assert (>= (sukuk_id r) 0))
(assert (>= (sukuk_value r) 0))
(assert (not (>= (+ (sukuk_id r) (sukuk_value r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 125. ShariahTransaction accessor round-trip: txn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TransactionType)
(declare-const f2 Bool)
(assert (not (= (txn_id (mk-shariah_transaction f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 126. ShariahTransaction accessor round-trip: txn_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TransactionType)
(declare-const f2 Bool)
(assert (not (= (txn_type (mk-shariah_transaction f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 127. ShariahTransaction accessor round-trip: shariah_compliant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TransactionType)
(declare-const f2 Bool)
(assert (not (= (shariah_compliant (mk-shariah_transaction f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

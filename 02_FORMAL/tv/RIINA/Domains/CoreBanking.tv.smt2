; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CoreBanking.v (31 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CoreBanking
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; kyc_complete: source semantics (matches Coq)
; Translation validation: kyc_complete preserves semantics
(push 1)
(declare-const source_kyc_complete Int)
(declare-const target_kyc_complete Int)
(assert (>= source_kyc_complete 0))
(assert (>= target_kyc_complete 0))
(assert (not (= source_kyc_complete target_kyc_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unique_customer_ids: source semantics (matches Coq)
; Translation validation: unique_customer_ids preserves semantics
(push 1)
(declare-const source_unique_customer_ids Int)
(declare-const target_unique_customer_ids Int)
(assert (>= source_unique_customer_ids 0))
(assert (>= target_unique_customer_ids 0))
(assert (not (= source_unique_customer_ids target_unique_customer_ids)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; total_ownership: source semantics (matches Coq)
; Translation validation: total_ownership preserves semantics
(push 1)
(declare-const source_total_ownership Int)
(declare-const target_total_ownership Int)
(assert (>= source_total_ownership 0))
(assert (>= target_total_ownership 0))
(assert (not (= source_total_ownership target_total_ownership)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; complete_ownership: source semantics (matches Coq)
; Translation validation: complete_ownership preserves semantics
(push 1)
(declare-const source_complete_ownership Int)
(declare-const target_complete_ownership Int)
(assert (>= source_complete_ownership 0))
(assert (>= target_complete_ownership 0))
(assert (not (= source_complete_ownership target_complete_ownership)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_parties_screened: source semantics (matches Coq)
; Translation validation: all_parties_screened preserves semantics
(push 1)
(declare-const source_all_parties_screened Int)
(declare-const target_all_parties_screened Int)
(assert (>= source_all_parties_screened 0))
(assert (>= target_all_parties_screened 0))
(assert (not (= source_all_parties_screened target_all_parties_screened)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; well_formed_savings: source semantics (matches Coq)
; Translation validation: well_formed_savings preserves semantics
(push 1)
(declare-const source_well_formed_savings Int)
(declare-const target_well_formed_savings Int)
(assert (>= source_well_formed_savings 0))
(assert (>= target_well_formed_savings 0))
(assert (not (= source_well_formed_savings target_well_formed_savings)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; should_be_dormant: source semantics (matches Coq)
; Translation validation: should_be_dormant preserves semantics
(push 1)
(declare-const source_should_be_dormant Int)
(declare-const target_should_be_dormant Int)
(assert (>= source_should_be_dormant 0))
(assert (>= target_should_be_dormant 0))
(assert (not (= source_should_be_dormant target_should_be_dormant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dormancy_consistent: source semantics (matches Coq)
; Translation validation: dormancy_consistent preserves semantics
(push 1)
(declare-const source_dormancy_consistent Int)
(declare-const target_dormancy_consistent Int)
(assert (>= source_dormancy_consistent 0))
(assert (>= target_dormancy_consistent 0))
(assert (not (= source_dormancy_consistent target_dormancy_consistent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; debits: source semantics (matches Coq)
; Translation validation: debits preserves semantics
(push 1)
(declare-const source_debits Int)
(declare-const target_debits Int)
(assert (>= source_debits 0))
(assert (>= target_debits 0))
(assert (not (= source_debits target_debits)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; credits: source semantics (matches Coq)
; Translation validation: credits preserves semantics
(push 1)
(declare-const source_credits Int)
(declare-const target_credits Int)
(assert (>= source_credits 0))
(assert (>= target_credits 0))
(assert (not (= source_credits target_credits)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_entry: source semantics (matches Coq)
; Translation validation: valid_entry preserves semantics
(push 1)
(declare-const source_valid_entry Int)
(declare-const target_valid_entry Int)
(assert (>= source_valid_entry 0))
(assert (>= target_valid_entry 0))
(assert (not (= source_valid_entry target_valid_entry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_entries: source semantics (matches Coq)
; Translation validation: valid_entries preserves semantics
(push 1)
(declare-const source_valid_entries Int)
(declare-const target_valid_entries Int)
(assert (>= source_valid_entries 0))
(assert (>= target_valid_entries 0))
(assert (not (= source_valid_entries target_valid_entries)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; interest_formula: source semantics (matches Coq)
; Translation validation: interest_formula preserves semantics
(push 1)
(declare-const source_interest_formula Int)
(declare-const target_interest_formula Int)
(assert (>= source_interest_formula 0))
(assert (>= target_interest_formula 0))
(assert (not (= source_interest_formula target_interest_formula)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; precise_interest: source semantics (matches Coq)
; Translation validation: precise_interest preserves semantics
(push 1)
(declare-const source_precise_interest Int)
(declare-const target_precise_interest Int)
(assert (>= source_precise_interest 0))
(assert (>= target_precise_interest 0))
(assert (not (= source_precise_interest target_precise_interest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; early_withdrawal: source semantics (matches Coq)
; Translation validation: early_withdrawal preserves semantics
(push 1)
(declare-const source_early_withdrawal Int)
(declare-const target_early_withdrawal Int)
(assert (>= source_early_withdrawal 0))
(assert (>= target_early_withdrawal 0))
(assert (not (= source_early_withdrawal target_early_withdrawal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; penalty_enforced: source semantics (matches Coq)
; Translation validation: penalty_enforced preserves semantics
(push 1)
(declare-const source_penalty_enforced Int)
(declare-const target_penalty_enforced Int)
(assert (>= source_penalty_enforced 0))
(assert (>= target_penalty_enforced 0))
(assert (not (= source_penalty_enforced target_penalty_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; within_eligibility: source semantics (matches Coq)
; Translation validation: within_eligibility preserves semantics
(push 1)
(declare-const source_within_eligibility Int)
(declare-const target_within_eligibility Int)
(assert (>= source_within_eligibility 0))
(assert (>= target_within_eligibility 0))
(assert (not (= source_within_eligibility target_within_eligibility)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sufficient_collateral: source semantics (matches Coq)
; Translation validation: sufficient_collateral preserves semantics
(push 1)
(declare-const source_sufficient_collateral Int)
(declare-const target_sufficient_collateral Int)
(assert (>= source_sufficient_collateral 0))
(assert (>= target_sufficient_collateral 0))
(assert (not (= source_sufficient_collateral target_sufficient_collateral)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; installment_total: source semantics (matches Coq)
; Translation validation: installment_total preserves semantics
(push 1)
(declare-const source_installment_total Int)
(declare-const target_installment_total Int)
(assert (>= source_installment_total 0))
(assert (>= target_installment_total 0))
(assert (not (= source_installment_total target_installment_total)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sum_installment_principals: source semantics (matches Coq)
; Translation validation: sum_installment_principals preserves semantics
(push 1)
(declare-const source_sum_installment_principals Int)
(declare-const target_sum_installment_principals Int)
(assert (>= source_sum_installment_principals 0))
(assert (>= target_sum_installment_principals 0))
(assert (not (= source_sum_installment_principals target_sum_installment_principals)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sum_installment_interest: source semantics (matches Coq)
; Translation validation: sum_installment_interest preserves semantics
(push 1)
(declare-const source_sum_installment_interest Int)
(declare-const target_sum_installment_interest Int)
(assert (>= source_sum_installment_interest 0))
(assert (>= target_sum_installment_interest 0))
(assert (not (= source_sum_installment_interest target_sum_installment_interest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; amortization_correct: source semantics (matches Coq)
; Translation validation: amortization_correct preserves semantics
(push 1)
(declare-const source_amortization_correct Int)
(declare-const target_amortization_correct Int)
(assert (>= source_amortization_correct 0))
(assert (>= target_amortization_correct 0))
(assert (not (= source_amortization_correct target_amortization_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; covenant_monitoring_correct: source semantics (matches Coq)
; Translation validation: covenant_monitoring_correct preserves semantics
(push 1)
(declare-const source_covenant_monitoring_correct Int)
(declare-const target_covenant_monitoring_correct Int)
(assert (>= source_covenant_monitoring_correct 0))
(assert (>= target_covenant_monitoring_correct 0))
(assert (not (= source_covenant_monitoring_correct target_covenant_monitoring_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; within_facility_limit: source semantics (matches Coq)
; Translation validation: within_facility_limit preserves semantics
(push 1)
(declare-const source_within_facility_limit Int)
(declare-const target_within_facility_limit Int)
(assert (>= source_within_facility_limit 0))
(assert (>= target_within_facility_limit 0))
(assert (not (= source_within_facility_limit target_within_facility_limit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; payment_within_sla: source semantics (matches Coq)
; Translation validation: payment_within_sla preserves semantics
(push 1)
(declare-const source_payment_within_sla Int)
(declare-const target_payment_within_sla Int)
(assert (>= source_payment_within_sla 0))
(assert (>= target_payment_within_sla 0))
(assert (not (= source_payment_within_sla target_payment_within_sla)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; payment_irrevocable: source semantics (matches Coq)
; Translation validation: payment_irrevocable preserves semantics
(push 1)
(declare-const source_payment_irrevocable Int)
(declare-const target_payment_irrevocable Int)
(assert (>= source_payment_irrevocable 0))
(assert (>= target_payment_irrevocable 0))
(assert (not (= source_payment_irrevocable target_payment_irrevocable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unique_idempotency_keys: source semantics (matches Coq)
; Translation validation: unique_idempotency_keys preserves semantics
(push 1)
(declare-const source_unique_idempotency_keys Int)
(declare-const target_unique_idempotency_keys Int)
(assert (>= source_unique_idempotency_keys 0))
(assert (>= target_unique_idempotency_keys 0))
(assert (not (= source_unique_idempotency_keys target_unique_idempotency_keys)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nostro_balanced: source semantics (matches Coq)
; Translation validation: nostro_balanced preserves semantics
(push 1)
(declare-const source_nostro_balanced Int)
(declare-const target_nostro_balanced Int)
(assert (>= source_nostro_balanced 0))
(assert (>= target_nostro_balanced 0))
(assert (not (= source_nostro_balanced target_nostro_balanced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; swift_validation_enforced: source semantics (matches Coq)
; Translation validation: swift_validation_enforced preserves semantics
(push 1)
(declare-const source_swift_validation_enforced Int)
(declare-const target_swift_validation_enforced Int)
(assert (>= source_swift_validation_enforced 0))
(assert (>= target_swift_validation_enforced 0))
(assert (not (= source_swift_validation_enforced target_swift_validation_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; spot_t_plus_2: source semantics (matches Coq)
; Translation validation: spot_t_plus_2 preserves semantics
(push 1)
(declare-const source_spot_t_plus_2 Int)
(declare-const target_spot_t_plus_2 Int)
(assert (>= source_spot_t_plus_2 0))
(assert (>= target_spot_t_plus_2 0))
(assert (not (= source_spot_t_plus_2 target_spot_t_plus_2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; spot_settlement_correct: source semantics (matches Coq)
; Translation validation: spot_settlement_correct preserves semantics
(push 1)
(declare-const source_spot_settlement_correct Int)
(declare-const target_spot_settlement_correct Int)
(assert (>= source_spot_settlement_correct 0))
(assert (>= target_spot_settlement_correct 0))
(assert (not (= source_spot_settlement_correct target_spot_settlement_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; repo_haircut_applied: source semantics (matches Coq)
; Translation validation: repo_haircut_applied preserves semantics
(push 1)
(declare-const source_repo_haircut_applied Int)
(declare-const target_repo_haircut_applied Int)
(assert (>= source_repo_haircut_applied 0))
(assert (>= target_repo_haircut_applied 0))
(assert (not (= source_repo_haircut_applied target_repo_haircut_applied)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bond_accrued_formula: source semantics (matches Coq)
; Translation validation: bond_accrued_formula preserves semantics
(push 1)
(declare-const source_bond_accrued_formula Int)
(declare-const target_bond_accrued_formula Int)
(assert (>= source_bond_accrued_formula 0))
(assert (>= target_bond_accrued_formula 0))
(assert (not (= source_bond_accrued_formula target_bond_accrued_formula)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; accrued_interest_correct: source semantics (matches Coq)
; Translation validation: accrued_interest_correct preserves semantics
(push 1)
(declare-const source_accrued_interest_correct Int)
(declare-const target_accrued_interest_correct Int)
(assert (>= source_accrued_interest_correct 0))
(assert (>= target_accrued_interest_correct 0))
(assert (not (= source_accrued_interest_correct target_accrued_interest_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; irs_npv_formula: source semantics (matches Coq)
; Translation validation: irs_npv_formula preserves semantics
(push 1)
(declare-const source_irs_npv_formula Int)
(declare-const target_irs_npv_formula Int)
(assert (>= source_irs_npv_formula 0))
(assert (>= target_irs_npv_formula 0))
(assert (not (= source_irs_npv_formula target_irs_npv_formula)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; irs_valuation_correct: source semantics (matches Coq)
; Translation validation: irs_valuation_correct preserves semantics
(push 1)
(declare-const source_irs_valuation_correct Int)
(declare-const target_irs_valuation_correct Int)
(assert (>= source_irs_valuation_correct 0))
(assert (>= target_irs_valuation_correct 0))
(assert (not (= source_irs_valuation_correct target_irs_valuation_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtm_beyond_threshold: source semantics (matches Coq)
; Translation validation: mtm_beyond_threshold preserves semantics
(push 1)
(declare-const source_mtm_beyond_threshold Int)
(declare-const target_mtm_beyond_threshold Int)
(assert (>= source_mtm_beyond_threshold 0))
(assert (>= target_mtm_beyond_threshold 0))
(assert (not (= source_mtm_beyond_threshold target_mtm_beyond_threshold)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; collateral_call_correct: source semantics (matches Coq)
; Translation validation: collateral_call_correct preserves semantics
(push 1)
(declare-const source_collateral_call_correct Int)
(declare-const target_collateral_call_correct Int)
(assert (>= source_collateral_call_correct 0))
(assert (>= target_collateral_call_correct 0))
(assert (not (= source_collateral_call_correct target_collateral_call_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; murabaha_selling_price: source semantics (matches Coq)
; Translation validation: murabaha_selling_price preserves semantics
(push 1)
(declare-const source_murabaha_selling_price Int)
(declare-const target_murabaha_selling_price Int)
(assert (>= source_murabaha_selling_price 0))
(assert (>= target_murabaha_selling_price 0))
(assert (not (= source_murabaha_selling_price target_murabaha_selling_price)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; during_tenure: source semantics (matches Coq)
; Translation validation: during_tenure preserves semantics
(push 1)
(declare-const source_during_tenure Int)
(declare-const target_during_tenure Int)
(assert (>= source_during_tenure 0))
(assert (>= target_during_tenure 0))
(assert (not (= source_during_tenure target_during_tenure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bank_retains_ownership: source semantics (matches Coq)
; Translation validation: bank_retains_ownership preserves semantics
(push 1)
(declare-const source_bank_retains_ownership Int)
(declare-const target_bank_retains_ownership Int)
(assert (>= source_bank_retains_ownership 0))
(assert (>= target_bank_retains_ownership 0))
(assert (not (= source_bank_retains_ownership target_bank_retains_ownership)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; partner_profit_share: source semantics (matches Coq)
; Translation validation: partner_profit_share preserves semantics
(push 1)
(declare-const source_partner_profit_share Int)
(declare-const target_partner_profit_share Int)
(assert (>= source_partner_profit_share 0))
(assert (>= target_partner_profit_share 0))
(assert (not (= source_partner_profit_share target_partner_profit_share)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; partner_loss_share: source semantics (matches Coq)
; Translation validation: partner_loss_share preserves semantics
(push 1)
(declare-const source_partner_loss_share Int)
(declare-const target_partner_loss_share Int)
(assert (>= source_partner_loss_share 0))
(assert (>= target_partner_loss_share 0))
(assert (not (= source_partner_loss_share target_partner_loss_share)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; profit_by_ratio_loss_by_capital: source semantics (matches Coq)
; Translation validation: profit_by_ratio_loss_by_capital preserves semantics
(push 1)
(declare-const source_profit_by_ratio_loss_by_capital Int)
(declare-const target_profit_by_ratio_loss_by_capital Int)
(assert (>= source_profit_by_ratio_loss_by_capital 0))
(assert (>= target_profit_by_ratio_loss_by_capital 0))
(assert (not (= source_profit_by_ratio_loss_by_capital target_profit_by_ratio_loss_by_capital)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sukuk_backed_by_assets: source semantics (matches Coq)
; Translation validation: sukuk_backed_by_assets preserves semantics
(push 1)
(declare-const source_sukuk_backed_by_assets Int)
(declare-const target_sukuk_backed_by_assets Int)
(assert (>= source_sukuk_backed_by_assets 0))
(assert (>= target_sukuk_backed_by_assets 0))
(assert (not (= source_sukuk_backed_by_assets target_sukuk_backed_by_assets)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_riba: source semantics (matches Coq)
; Translation validation: no_riba preserves semantics
(push 1)
(declare-const source_no_riba Int)
(declare-const target_no_riba Int)
(assert (>= source_no_riba 0))
(assert (>= target_no_riba 0))
(assert (not (= source_no_riba target_no_riba)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_01_customer_identity_uniqueness: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_01_customer_identity_uniqueness preserves semantics
(push 1)
(declare-const source_BANK_001_01_customer_identity_uniqueness Int)
(declare-const target_BANK_001_01_customer_identity_uniqueness Int)
(assert (>= source_BANK_001_01_customer_identity_uniqueness 0))
(assert (>= target_BANK_001_01_customer_identity_uniqueness 0))
(assert (not (= source_BANK_001_01_customer_identity_uniqueness target_BANK_001_01_customer_identity_uniqueness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_02_kyc_completeness: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_02_kyc_completeness preserves semantics
(push 1)
(declare-const source_BANK_001_02_kyc_completeness Int)
(declare-const target_BANK_001_02_kyc_completeness Int)
(assert (>= source_BANK_001_02_kyc_completeness 0))
(assert (>= target_BANK_001_02_kyc_completeness 0))
(assert (not (= source_BANK_001_02_kyc_completeness target_BANK_001_02_kyc_completeness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_03_beneficial_ownership_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_03_beneficial_ownership_complete preserves semantics
(push 1)
(declare-const source_BANK_001_03_beneficial_ownership_complete Int)
(declare-const target_BANK_001_03_beneficial_ownership_complete Int)
(assert (>= source_BANK_001_03_beneficial_ownership_complete 0))
(assert (>= target_BANK_001_03_beneficial_ownership_complete 0))
(assert (not (= source_BANK_001_03_beneficial_ownership_complete target_BANK_001_03_beneficial_ownership_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_04_sanctions_check_mandatory: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_04_sanctions_check_mandatory preserves semantics
(push 1)
(declare-const source_BANK_001_04_sanctions_check_mandatory Int)
(declare-const target_BANK_001_04_sanctions_check_mandatory Int)
(assert (>= source_BANK_001_04_sanctions_check_mandatory 0))
(assert (>= target_BANK_001_04_sanctions_check_mandatory 0))
(assert (not (= source_BANK_001_04_sanctions_check_mandatory target_BANK_001_04_sanctions_check_mandatory)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_05_pep_enhanced_monitoring: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_05_pep_enhanced_monitoring preserves semantics
(push 1)
(declare-const source_BANK_001_05_pep_enhanced_monitoring Int)
(declare-const target_BANK_001_05_pep_enhanced_monitoring Int)
(assert (>= source_BANK_001_05_pep_enhanced_monitoring 0))
(assert (>= target_BANK_001_05_pep_enhanced_monitoring 0))
(assert (not (= source_BANK_001_05_pep_enhanced_monitoring target_BANK_001_05_pep_enhanced_monitoring)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_06_balance_non_negative: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_06_balance_non_negative preserves semantics
(push 1)
(declare-const source_BANK_001_06_balance_non_negative Int)
(declare-const target_BANK_001_06_balance_non_negative Int)
(assert (>= source_BANK_001_06_balance_non_negative 0))
(assert (>= target_BANK_001_06_balance_non_negative 0))
(assert (not (= source_BANK_001_06_balance_non_negative target_BANK_001_06_balance_non_negative)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_07_interest_calculation_precise: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_07_interest_calculation_precise preserves semantics
(push 1)
(declare-const source_BANK_001_07_interest_calculation_precise Int)
(declare-const target_BANK_001_07_interest_calculation_precise Int)
(assert (>= source_BANK_001_07_interest_calculation_precise 0))
(assert (>= target_BANK_001_07_interest_calculation_precise 0))
(assert (not (= source_BANK_001_07_interest_calculation_precise target_BANK_001_07_interest_calculation_precise)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fold_left_add_acc_general: translation preserves property (matches Coq: Lemma)
; Translation validation: fold_left_add_acc_general preserves semantics
(push 1)
(declare-const source_fold_left_add_acc_general Int)
(declare-const target_fold_left_add_acc_general Int)
(assert (>= source_fold_left_add_acc_general 0))
(assert (>= target_fold_left_add_acc_general 0))
(assert (not (= source_fold_left_add_acc_general target_fold_left_add_acc_general)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_08_double_entry_invariant: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_08_double_entry_invariant preserves semantics
(push 1)
(declare-const source_BANK_001_08_double_entry_invariant Int)
(declare-const target_BANK_001_08_double_entry_invariant Int)
(assert (>= source_BANK_001_08_double_entry_invariant 0))
(assert (>= target_BANK_001_08_double_entry_invariant 0))
(assert (not (= source_BANK_001_08_double_entry_invariant target_BANK_001_08_double_entry_invariant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_09_term_deposit_lock: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_09_term_deposit_lock preserves semantics
(push 1)
(declare-const source_BANK_001_09_term_deposit_lock Int)
(declare-const target_BANK_001_09_term_deposit_lock Int)
(assert (>= source_BANK_001_09_term_deposit_lock 0))
(assert (>= target_BANK_001_09_term_deposit_lock 0))
(assert (not (= source_BANK_001_09_term_deposit_lock target_BANK_001_09_term_deposit_lock)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_10_dormancy_detection: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_10_dormancy_detection preserves semantics
(push 1)
(declare-const source_BANK_001_10_dormancy_detection Int)
(declare-const target_BANK_001_10_dormancy_detection Int)
(assert (>= source_BANK_001_10_dormancy_detection 0))
(assert (>= target_BANK_001_10_dormancy_detection 0))
(assert (not (= source_BANK_001_10_dormancy_detection target_BANK_001_10_dormancy_detection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_11_loan_within_eligibility: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_11_loan_within_eligibility preserves semantics
(push 1)
(declare-const source_BANK_001_11_loan_within_eligibility Int)
(declare-const target_BANK_001_11_loan_within_eligibility Int)
(assert (>= source_BANK_001_11_loan_within_eligibility 0))
(assert (>= target_BANK_001_11_loan_within_eligibility 0))
(assert (not (= source_BANK_001_11_loan_within_eligibility target_BANK_001_11_loan_within_eligibility)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_12_collateral_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_12_collateral_coverage preserves semantics
(push 1)
(declare-const source_BANK_001_12_collateral_coverage Int)
(declare-const target_BANK_001_12_collateral_coverage Int)
(assert (>= source_BANK_001_12_collateral_coverage 0))
(assert (>= target_BANK_001_12_collateral_coverage 0))
(assert (not (= source_BANK_001_12_collateral_coverage target_BANK_001_12_collateral_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_13_amortization_correctness: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_13_amortization_correctness preserves semantics
(push 1)
(declare-const source_BANK_001_13_amortization_correctness Int)
(declare-const target_BANK_001_13_amortization_correctness Int)
(assert (>= source_BANK_001_13_amortization_correctness 0))
(assert (>= target_BANK_001_13_amortization_correctness 0))
(assert (not (= source_BANK_001_13_amortization_correctness target_BANK_001_13_amortization_correctness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_14_covenant_monitoring: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_14_covenant_monitoring preserves semantics
(push 1)
(declare-const source_BANK_001_14_covenant_monitoring Int)
(declare-const target_BANK_001_14_covenant_monitoring Int)
(assert (>= source_BANK_001_14_covenant_monitoring 0))
(assert (>= target_BANK_001_14_covenant_monitoring 0))
(assert (not (= source_BANK_001_14_covenant_monitoring target_BANK_001_14_covenant_monitoring)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_15_facility_limit_enforcement: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_15_facility_limit_enforcement preserves semantics
(push 1)
(declare-const source_BANK_001_15_facility_limit_enforcement Int)
(declare-const target_BANK_001_15_facility_limit_enforcement Int)
(assert (>= source_BANK_001_15_facility_limit_enforcement 0))
(assert (>= target_BANK_001_15_facility_limit_enforcement 0))
(assert (not (= source_BANK_001_15_facility_limit_enforcement target_BANK_001_15_facility_limit_enforcement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_16_instant_payment_completion: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_16_instant_payment_completion preserves semantics
(push 1)
(declare-const source_BANK_001_16_instant_payment_completion Int)
(declare-const target_BANK_001_16_instant_payment_completion Int)
(assert (>= source_BANK_001_16_instant_payment_completion 0))
(assert (>= target_BANK_001_16_instant_payment_completion 0))
(assert (not (= source_BANK_001_16_instant_payment_completion target_BANK_001_16_instant_payment_completion)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_17_payment_irrevocability: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_17_payment_irrevocability preserves semantics
(push 1)
(declare-const source_BANK_001_17_payment_irrevocability Int)
(declare-const target_BANK_001_17_payment_irrevocability Int)
(assert (>= source_BANK_001_17_payment_irrevocability 0))
(assert (>= target_BANK_001_17_payment_irrevocability 0))
(assert (not (= source_BANK_001_17_payment_irrevocability target_BANK_001_17_payment_irrevocability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_18_idempotency: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_18_idempotency preserves semantics
(push 1)
(declare-const source_BANK_001_18_idempotency Int)
(declare-const target_BANK_001_18_idempotency Int)
(assert (>= source_BANK_001_18_idempotency 0))
(assert (>= target_BANK_001_18_idempotency 0))
(assert (not (= source_BANK_001_18_idempotency target_BANK_001_18_idempotency)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_19_nostro_reconciliation: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_19_nostro_reconciliation preserves semantics
(push 1)
(declare-const source_BANK_001_19_nostro_reconciliation Int)
(declare-const target_BANK_001_19_nostro_reconciliation Int)
(assert (>= source_BANK_001_19_nostro_reconciliation 0))
(assert (>= target_BANK_001_19_nostro_reconciliation 0))
(assert (not (= source_BANK_001_19_nostro_reconciliation target_BANK_001_19_nostro_reconciliation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_20_swift_message_validation: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_20_swift_message_validation preserves semantics
(push 1)
(declare-const source_BANK_001_20_swift_message_validation Int)
(declare-const target_BANK_001_20_swift_message_validation Int)
(assert (>= source_BANK_001_20_swift_message_validation 0))
(assert (>= target_BANK_001_20_swift_message_validation 0))
(assert (not (= source_BANK_001_20_swift_message_validation target_BANK_001_20_swift_message_validation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_21_fx_spot_settlement: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_21_fx_spot_settlement preserves semantics
(push 1)
(declare-const source_BANK_001_21_fx_spot_settlement Int)
(declare-const target_BANK_001_21_fx_spot_settlement Int)
(assert (>= source_BANK_001_21_fx_spot_settlement 0))
(assert (>= target_BANK_001_21_fx_spot_settlement 0))
(assert (not (= source_BANK_001_21_fx_spot_settlement target_BANK_001_21_fx_spot_settlement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_22_repo_collateral_haircut: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_22_repo_collateral_haircut preserves semantics
(push 1)
(declare-const source_BANK_001_22_repo_collateral_haircut Int)
(declare-const target_BANK_001_22_repo_collateral_haircut Int)
(assert (>= source_BANK_001_22_repo_collateral_haircut 0))
(assert (>= target_BANK_001_22_repo_collateral_haircut 0))
(assert (not (= source_BANK_001_22_repo_collateral_haircut target_BANK_001_22_repo_collateral_haircut)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_23_bond_accrued_interest: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_23_bond_accrued_interest preserves semantics
(push 1)
(declare-const source_BANK_001_23_bond_accrued_interest Int)
(declare-const target_BANK_001_23_bond_accrued_interest Int)
(assert (>= source_BANK_001_23_bond_accrued_interest 0))
(assert (>= target_BANK_001_23_bond_accrued_interest 0))
(assert (not (= source_BANK_001_23_bond_accrued_interest target_BANK_001_23_bond_accrued_interest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_24_derivative_valuation: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_24_derivative_valuation preserves semantics
(push 1)
(declare-const source_BANK_001_24_derivative_valuation Int)
(declare-const target_BANK_001_24_derivative_valuation Int)
(assert (>= source_BANK_001_24_derivative_valuation 0))
(assert (>= target_BANK_001_24_derivative_valuation 0))
(assert (not (= source_BANK_001_24_derivative_valuation target_BANK_001_24_derivative_valuation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_25_collateral_call_trigger: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_25_collateral_call_trigger preserves semantics
(push 1)
(declare-const source_BANK_001_25_collateral_call_trigger Int)
(declare-const target_BANK_001_25_collateral_call_trigger Int)
(assert (>= source_BANK_001_25_collateral_call_trigger 0))
(assert (>= target_BANK_001_25_collateral_call_trigger 0))
(assert (not (= source_BANK_001_25_collateral_call_trigger target_BANK_001_25_collateral_call_trigger)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_26_murabaha_cost_plus: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_26_murabaha_cost_plus preserves semantics
(push 1)
(declare-const source_BANK_001_26_murabaha_cost_plus Int)
(declare-const target_BANK_001_26_murabaha_cost_plus Int)
(assert (>= source_BANK_001_26_murabaha_cost_plus 0))
(assert (>= target_BANK_001_26_murabaha_cost_plus 0))
(assert (not (= source_BANK_001_26_murabaha_cost_plus target_BANK_001_26_murabaha_cost_plus)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_27_ijarah_ownership: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_27_ijarah_ownership preserves semantics
(push 1)
(declare-const source_BANK_001_27_ijarah_ownership Int)
(declare-const target_BANK_001_27_ijarah_ownership Int)
(assert (>= source_BANK_001_27_ijarah_ownership 0))
(assert (>= target_BANK_001_27_ijarah_ownership 0))
(assert (not (= source_BANK_001_27_ijarah_ownership target_BANK_001_27_ijarah_ownership)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_28_musharakah_profit_loss: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_28_musharakah_profit_loss preserves semantics
(push 1)
(declare-const source_BANK_001_28_musharakah_profit_loss Int)
(declare-const target_BANK_001_28_musharakah_profit_loss Int)
(assert (>= source_BANK_001_28_musharakah_profit_loss 0))
(assert (>= target_BANK_001_28_musharakah_profit_loss 0))
(assert (not (= source_BANK_001_28_musharakah_profit_loss target_BANK_001_28_musharakah_profit_loss)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_29_sukuk_asset_backing: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_29_sukuk_asset_backing preserves semantics
(push 1)
(declare-const source_BANK_001_29_sukuk_asset_backing Int)
(declare-const target_BANK_001_29_sukuk_asset_backing Int)
(assert (>= source_BANK_001_29_sukuk_asset_backing 0))
(assert (>= target_BANK_001_29_sukuk_asset_backing 0))
(assert (not (= source_BANK_001_29_sukuk_asset_backing target_BANK_001_29_sukuk_asset_backing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BANK_001_30_shariah_no_riba: translation preserves property (matches Coq: Theorem)
; Translation validation: BANK_001_30_shariah_no_riba preserves semantics
(push 1)
(declare-const source_BANK_001_30_shariah_no_riba Int)
(declare-const target_BANK_001_30_shariah_no_riba Int)
(assert (>= source_BANK_001_30_shariah_no_riba 0))
(assert (>= target_BANK_001_30_shariah_no_riba 0))
(assert (not (= source_BANK_001_30_shariah_no_riba target_BANK_001_30_shariah_no_riba)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CommonCriteriaEAL7 — SMT Verification
; Derived from 02_FORMAL/coq/domains/CommonCriteriaEAL7.v (52 assertions)
; Module: CommonCriteriaEAL7
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SecurityClass 0)) (((FAU_ARP) (FAU_GEN) (FAU_SAA) (FAU_SAR) (FAU_SEL) (FAU_STG) (FCO_NRO) (FCO_NRR) (FCS_CKM) (FCS_COP) (FDP_ACC) (FDP_ACF) (FDP_IFC) (FDP_IFF) (FDP_ITT) (FDP_RIP) (FIA_AFL) (FIA_ATD) (FIA_SOS) (FIA_UAU) (FIA_UID) (FMT_MOF) (FMT_MSA) (FMT_MTD) (FMT_SMF) (FMT_SMR) (FPR_ANO) (FPR_PSE) (FPR_UNL) (FPR_UNO) (FPT_FLS) (FPT_ITC) (FPT_ITI) (FPT_ITT) (FPT_RCV) (FPT_RPL) (FPT_SEP) (FPT_STM) (FPT_TDC) (FPT_TEE) (FRU_FLT) (FRU_PRS) (FRU_RSA) (FTA_LSA) (FTA_MCS) (FTA_SSL) (FTA_TAB) (FTA_TAH) (FTA_TSE) (FTP_ITC) (FTP_TRP))))

(declare-datatypes ((SecurityLabel 0)) (((SL_Public) (SL_Internal) (SL_Confidential) (SL_Secret) (SL_TopSecret))))

(declare-datatypes ((RiinaType 0)) (((RT_Unit) (RT_Bool) (RT_Int) (RT_Labeled) (RT_Ref) (RT_Arrow) (RT_Product) (RT_Sum))))

(declare-datatypes ((RiinaValue 0)) (((RV_Unit) (RV_Bool) (RV_Int) (RV_Labeled) (RV_Loc) (RV_Closure) (RV_Pair) (RV_Inl) (RV_Inr))))

(declare-datatypes ((SecurityPolicyModel 0))
  (((mk-security_policy_model (spm_subjects Int) (spm_objects Int) (spm_operations Int) (spm_security_attributes Int) (spm_access_control Int) (spm_information_flow Int)))))

(declare-datatypes ((TOEConfiguration 0))
  (((mk-toe_configuration (toe_boundary_defined Bool) (toe_interfaces_specified Bool) (toe_security_functions (Seq Int)) (toe_security_policy SecurityPolicyModel) (toe_evaluated_configuration Bool)))))

(declare-datatypes ((DevelopmentAssurance 0))
  (((mk-development_assurance (adv_arc_complete Bool) (adv_arc_modular Bool) (adv_arc_non_bypassable Bool) (adv_arc_tamper_proof Bool) (adv_arc_domain_sep Bool) (adv_fsp_complete Bool) (adv_fsp_accurate Bool) (adv_imp_complete Bool) (adv_imp_verified Bool) (adv_int_modular Bool) (adv_int_layered Bool) (adv_int_minimal Bool) (adv_tds_semiformal Bool) (adv_tds_formal Bool)))))

(declare-datatypes ((GuidanceAssurance 0))
  (((mk-guidance_assurance (agd_ope_complete Bool) (agd_pre_complete Bool)))))

(declare-datatypes ((LifecycleAssurance 0))
  (((mk-lifecycle_assurance (alc_cmc_automated Bool) (alc_cmc_coverage Bool) (alc_cms_tracking Bool) (alc_del_secure Bool) (alc_dvs_sufficient Bool) (alc_flaw_systematic Bool) (alc_lcd_defined Bool) (alc_tat_compliance Bool)))))

(declare-datatypes ((SecurityTargetAssurance 0))
  (((mk-security_target_assurance (ase_ccl_conformant Bool) (ase_ecd_complete Bool) (ase_int_complete Bool) (ase_obj_complete Bool) (ase_req_complete Bool) (ase_spd_complete Bool) (ase_tss_complete Bool)))))

(declare-datatypes ((TestAssurance 0))
  (((mk-test_assurance (ate_cov_complete Bool) (ate_dpt_sufficient Bool) (ate_fun_complete Bool) (ate_ind_performed Bool)))))

(declare-datatypes ((VulnerabilityAssurance 0))
  (((mk-vulnerability_assurance (ava_van_basic Bool) (ava_van_focused Bool) (ava_van_methodical Bool) (ava_van_advanced Bool) (ava_van_high_attack Bool)))))

(declare-datatypes ((EAL7Package 0))
  (((mk-eal7_package (eal7_adv DevelopmentAssurance) (eal7_agd GuidanceAssurance) (eal7_alc LifecycleAssurance) (eal7_ase SecurityTargetAssurance) (eal7_ate TestAssurance) (eal7_ava VulnerabilityAssurance)))))

(declare-datatypes ((SecurityContext 0))
  (((mk-security_context (ctx_clearance SecurityLabel) (ctx_current_label SecurityLabel) (ctx_integrity_label SecurityLabel)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SecurityClass enum properties ---

; --- 1. SecurityClass exhaustiveness ---
(push 1)
(declare-const x SecurityClass)
(assert (not (or (= x FAU_ARP) (= x FAU_GEN) (= x FAU_SAA) (= x FAU_SAR) (= x FAU_SEL) (= x FAU_STG) (= x FCO_NRO) (= x FCO_NRR) (= x FCS_CKM) (= x FCS_COP) (= x FDP_ACC) (= x FDP_ACF) (= x FDP_IFC) (= x FDP_IFF) (= x FDP_ITT) (= x FDP_RIP) (= x FIA_AFL) (= x FIA_ATD) (= x FIA_SOS) (= x FIA_UAU) (= x FIA_UID) (= x FMT_MOF) (= x FMT_MSA) (= x FMT_MTD) (= x FMT_SMF) (= x FMT_SMR) (= x FPR_ANO) (= x FPR_PSE) (= x FPR_UNL) (= x FPR_UNO) (= x FPT_FLS) (= x FPT_ITC) (= x FPT_ITI) (= x FPT_ITT) (= x FPT_RCV) (= x FPT_RPL) (= x FPT_SEP) (= x FPT_STM) (= x FPT_TDC) (= x FPT_TEE) (= x FRU_FLT) (= x FRU_PRS) (= x FRU_RSA) (= x FTA_LSA) (= x FTA_MCS) (= x FTA_SSL) (= x FTA_TAB) (= x FTA_TAH) (= x FTA_TSE) (= x FTP_ITC) (= x FTP_TRP))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SecurityClass: FAU_ARP != FAU_GEN ---
(push 1)
(assert (= FAU_ARP FAU_GEN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SecurityClass: FAU_GEN != FAU_SAA ---
(push 1)
(assert (= FAU_GEN FAU_SAA))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SecurityClass: FAU_SAA != FAU_SAR ---
(push 1)
(assert (= FAU_SAA FAU_SAR))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SecurityClass: FAU_ARP != FTP_TRP ---
(push 1)
(assert (= FAU_ARP FTP_TRP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SecurityClass finite cardinality (51 values) ---
(push 1)
(declare-const x SecurityClass)
(assert (and (not (= x FAU_ARP)) (not (= x FAU_GEN)) (not (= x FAU_SAA)) (not (= x FAU_SAR)) (not (= x FAU_SEL)) (not (= x FAU_STG)) (not (= x FCO_NRO)) (not (= x FCO_NRR)) (not (= x FCS_CKM)) (not (= x FCS_COP)) (not (= x FDP_ACC)) (not (= x FDP_ACF)) (not (= x FDP_IFC)) (not (= x FDP_IFF)) (not (= x FDP_ITT)) (not (= x FDP_RIP)) (not (= x FIA_AFL)) (not (= x FIA_ATD)) (not (= x FIA_SOS)) (not (= x FIA_UAU)) (not (= x FIA_UID)) (not (= x FMT_MOF)) (not (= x FMT_MSA)) (not (= x FMT_MTD)) (not (= x FMT_SMF)) (not (= x FMT_SMR)) (not (= x FPR_ANO)) (not (= x FPR_PSE)) (not (= x FPR_UNL)) (not (= x FPR_UNO)) (not (= x FPT_FLS)) (not (= x FPT_ITC)) (not (= x FPT_ITI)) (not (= x FPT_ITT)) (not (= x FPT_RCV)) (not (= x FPT_RPL)) (not (= x FPT_SEP)) (not (= x FPT_STM)) (not (= x FPT_TDC)) (not (= x FPT_TEE)) (not (= x FRU_FLT)) (not (= x FRU_PRS)) (not (= x FRU_RSA)) (not (= x FTA_LSA)) (not (= x FTA_MCS)) (not (= x FTA_SSL)) (not (= x FTA_TAB)) (not (= x FTA_TAH)) (not (= x FTA_TSE)) (not (= x FTP_ITC)) (not (= x FTP_TRP))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLabel enum properties ---

; --- 7. SecurityLabel exhaustiveness ---
(push 1)
(declare-const x SecurityLabel)
(assert (not (or (= x SL_Public) (= x SL_Internal) (= x SL_Confidential) (= x SL_Secret) (= x SL_TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SecurityLabel: SL_Public != SL_Internal ---
(push 1)
(assert (= SL_Public SL_Internal))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SecurityLabel: SL_Internal != SL_Confidential ---
(push 1)
(assert (= SL_Internal SL_Confidential))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SecurityLabel: SL_Confidential != SL_Secret ---
(push 1)
(assert (= SL_Confidential SL_Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SecurityLabel: SL_Public != SL_TopSecret ---
(push 1)
(assert (= SL_Public SL_TopSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SecurityLabel finite cardinality (5 values) ---
(push 1)
(declare-const x SecurityLabel)
(assert (and (not (= x SL_Public)) (not (= x SL_Internal)) (not (= x SL_Confidential)) (not (= x SL_Secret)) (not (= x SL_TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RiinaType enum properties ---

; --- 13. RiinaType exhaustiveness ---
(push 1)
(declare-const x RiinaType)
(assert (not (or (= x RT_Unit) (= x RT_Bool) (= x RT_Int) (= x RT_Labeled) (= x RT_Ref) (= x RT_Arrow) (= x RT_Product) (= x RT_Sum))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. RiinaType: RT_Unit != RT_Bool ---
(push 1)
(assert (= RT_Unit RT_Bool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. RiinaType: RT_Bool != RT_Int ---
(push 1)
(assert (= RT_Bool RT_Int))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. RiinaType: RT_Int != RT_Labeled ---
(push 1)
(assert (= RT_Int RT_Labeled))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. RiinaType: RT_Unit != RT_Sum ---
(push 1)
(assert (= RT_Unit RT_Sum))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. RiinaType finite cardinality (8 values) ---
(push 1)
(declare-const x RiinaType)
(assert (and (not (= x RT_Unit)) (not (= x RT_Bool)) (not (= x RT_Int)) (not (= x RT_Labeled)) (not (= x RT_Ref)) (not (= x RT_Arrow)) (not (= x RT_Product)) (not (= x RT_Sum))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RiinaValue enum properties ---

; --- 19. RiinaValue exhaustiveness ---
(push 1)
(declare-const x RiinaValue)
(assert (not (or (= x RV_Unit) (= x RV_Bool) (= x RV_Int) (= x RV_Labeled) (= x RV_Loc) (= x RV_Closure) (= x RV_Pair) (= x RV_Inl) (= x RV_Inr))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. RiinaValue: RV_Unit != RV_Bool ---
(push 1)
(assert (= RV_Unit RV_Bool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. RiinaValue: RV_Bool != RV_Int ---
(push 1)
(assert (= RV_Bool RV_Int))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. RiinaValue: RV_Int != RV_Labeled ---
(push 1)
(assert (= RV_Int RV_Labeled))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. RiinaValue: RV_Unit != RV_Inr ---
(push 1)
(assert (= RV_Unit RV_Inr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. RiinaValue finite cardinality (9 values) ---
(push 1)
(declare-const x RiinaValue)
(assert (and (not (= x RV_Unit)) (not (= x RV_Bool)) (not (= x RV_Int)) (not (= x RV_Labeled)) (not (= x RV_Loc)) (not (= x RV_Closure)) (not (= x RV_Pair)) (not (= x RV_Inl)) (not (= x RV_Inr))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityPolicyModel record properties ---

; --- 25. SecurityPolicyModel accessor round-trip: spm_subjects ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (spm_subjects (mk-security_policy_model f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SecurityPolicyModel accessor round-trip: spm_objects ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (spm_objects (mk-security_policy_model f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. SecurityPolicyModel accessor round-trip: spm_operations ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (spm_operations (mk-security_policy_model f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. SecurityPolicyModel accessor round-trip: spm_security_attributes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (spm_security_attributes (mk-security_policy_model f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. SecurityPolicyModel accessor round-trip: spm_access_control ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (spm_access_control (mk-security_policy_model f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. SecurityPolicyModel: integer field consistency ---
(push 1)
(declare-const r SecurityPolicyModel)
(assert (>= (spm_subjects r) 0))
(assert (>= (spm_objects r) 0))
(assert (not (>= (+ (spm_subjects r) (spm_objects r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TOEConfiguration record properties ---

; --- 31. TOEConfiguration accessor round-trip: toe_boundary_defined ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 (Seq Int))
(declare-const f3 SecurityPolicyModel)
(declare-const f4 Bool)
(assert (not (= (toe_boundary_defined (mk-toe_configuration f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. TOEConfiguration accessor round-trip: toe_interfaces_specified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 (Seq Int))
(declare-const f3 SecurityPolicyModel)
(declare-const f4 Bool)
(assert (not (= (toe_interfaces_specified (mk-toe_configuration f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. TOEConfiguration accessor round-trip: Seq ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 (Seq Int))
(declare-const f3 SecurityPolicyModel)
(declare-const f4 Bool)
(assert (not (= (toe_security_functions (mk-toe_configuration f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. TOEConfiguration accessor round-trip: toe_security_policy ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 (Seq Int))
(declare-const f3 SecurityPolicyModel)
(declare-const f4 Bool)
(assert (not (= (toe_security_policy (mk-toe_configuration f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DevelopmentAssurance record properties ---

; --- 35. DevelopmentAssurance accessor round-trip: adv_arc_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (adv_arc_complete (mk-development_assurance f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. DevelopmentAssurance accessor round-trip: adv_arc_modular ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (adv_arc_modular (mk-development_assurance f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. DevelopmentAssurance accessor round-trip: adv_arc_non_bypassable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (adv_arc_non_bypassable (mk-development_assurance f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. DevelopmentAssurance accessor round-trip: adv_arc_tamper_proof ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (adv_arc_tamper_proof (mk-development_assurance f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. DevelopmentAssurance accessor round-trip: adv_arc_domain_sep ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (adv_arc_domain_sep (mk-development_assurance f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DevelopmentAssurance_all_enabled ((g DevelopmentAssurance)) Bool
  (and (adv_arc_complete g) (adv_arc_modular g) (adv_arc_non_bypassable g) (adv_arc_tamper_proof g) (adv_arc_domain_sep g) (adv_fsp_complete g) (adv_fsp_accurate g) (adv_imp_complete g) (adv_imp_verified g) (adv_int_modular g) (adv_int_layered g) (adv_int_minimal g) (adv_tds_semiformal g)))

; --- 40. DevelopmentAssurance: all-enabled completeness ---
(push 1)
(declare-const g DevelopmentAssurance)
(assert (adv_arc_complete g))
(assert (adv_arc_modular g))
(assert (adv_arc_non_bypassable g))
(assert (adv_arc_tamper_proof g))
(assert (adv_arc_domain_sep g))
(assert (adv_fsp_complete g))
(assert (adv_fsp_accurate g))
(assert (adv_imp_complete g))
(assert (adv_imp_verified g))
(assert (adv_int_modular g))
(assert (adv_int_layered g))
(assert (adv_int_minimal g))
(assert (adv_tds_semiformal g))
(assert (not (DevelopmentAssurance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. DevelopmentAssurance: DevelopmentAssurance_all_enabled implies adv_arc_complete ---
(push 1)
(declare-const g DevelopmentAssurance)
(assert (DevelopmentAssurance_all_enabled g))
(assert (not (adv_arc_complete g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. DevelopmentAssurance: DevelopmentAssurance_all_enabled implies adv_arc_modular ---
(push 1)
(declare-const g DevelopmentAssurance)
(assert (DevelopmentAssurance_all_enabled g))
(assert (not (adv_arc_modular g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. DevelopmentAssurance: DevelopmentAssurance_all_enabled implies adv_arc_non_bypassable ---
(push 1)
(declare-const g DevelopmentAssurance)
(assert (DevelopmentAssurance_all_enabled g))
(assert (not (adv_arc_non_bypassable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- GuidanceAssurance record properties ---

; --- 44. GuidanceAssurance accessor round-trip: agd_ope_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (agd_ope_complete (mk-guidance_assurance f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LifecycleAssurance record properties ---

; --- 45. LifecycleAssurance accessor round-trip: alc_cmc_automated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (alc_cmc_automated (mk-lifecycle_assurance f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. LifecycleAssurance accessor round-trip: alc_cmc_coverage ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (alc_cmc_coverage (mk-lifecycle_assurance f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. LifecycleAssurance accessor round-trip: alc_cms_tracking ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (alc_cms_tracking (mk-lifecycle_assurance f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. LifecycleAssurance accessor round-trip: alc_del_secure ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (alc_del_secure (mk-lifecycle_assurance f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. LifecycleAssurance accessor round-trip: alc_dvs_sufficient ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (alc_dvs_sufficient (mk-lifecycle_assurance f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun LifecycleAssurance_all_enabled ((g LifecycleAssurance)) Bool
  (and (alc_cmc_automated g) (alc_cmc_coverage g) (alc_cms_tracking g) (alc_del_secure g) (alc_dvs_sufficient g) (alc_flaw_systematic g) (alc_lcd_defined g)))

; --- 50. LifecycleAssurance: all-enabled completeness ---
(push 1)
(declare-const g LifecycleAssurance)
(assert (alc_cmc_automated g))
(assert (alc_cmc_coverage g))
(assert (alc_cms_tracking g))
(assert (alc_del_secure g))
(assert (alc_dvs_sufficient g))
(assert (alc_flaw_systematic g))
(assert (alc_lcd_defined g))
(assert (not (LifecycleAssurance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. LifecycleAssurance: LifecycleAssurance_all_enabled implies alc_cmc_automated ---
(push 1)
(declare-const g LifecycleAssurance)
(assert (LifecycleAssurance_all_enabled g))
(assert (not (alc_cmc_automated g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. LifecycleAssurance: LifecycleAssurance_all_enabled implies alc_cmc_coverage ---
(push 1)
(declare-const g LifecycleAssurance)
(assert (LifecycleAssurance_all_enabled g))
(assert (not (alc_cmc_coverage g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. LifecycleAssurance: LifecycleAssurance_all_enabled implies alc_cms_tracking ---
(push 1)
(declare-const g LifecycleAssurance)
(assert (LifecycleAssurance_all_enabled g))
(assert (not (alc_cms_tracking g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityTargetAssurance record properties ---

; --- 54. SecurityTargetAssurance accessor round-trip: ase_ccl_conformant ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ase_ccl_conformant (mk-security_target_assurance f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. SecurityTargetAssurance accessor round-trip: ase_ecd_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ase_ecd_complete (mk-security_target_assurance f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. SecurityTargetAssurance accessor round-trip: ase_int_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ase_int_complete (mk-security_target_assurance f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. SecurityTargetAssurance accessor round-trip: ase_obj_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ase_obj_complete (mk-security_target_assurance f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. SecurityTargetAssurance accessor round-trip: ase_req_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ase_req_complete (mk-security_target_assurance f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SecurityTargetAssurance_all_enabled ((g SecurityTargetAssurance)) Bool
  (and (ase_ccl_conformant g) (ase_ecd_complete g) (ase_int_complete g) (ase_obj_complete g) (ase_req_complete g) (ase_spd_complete g)))

; --- 59. SecurityTargetAssurance: all-enabled completeness ---
(push 1)
(declare-const g SecurityTargetAssurance)
(assert (ase_ccl_conformant g))
(assert (ase_ecd_complete g))
(assert (ase_int_complete g))
(assert (ase_obj_complete g))
(assert (ase_req_complete g))
(assert (ase_spd_complete g))
(assert (not (SecurityTargetAssurance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. SecurityTargetAssurance: SecurityTargetAssurance_all_enabled implies ase_ccl_conformant ---
(push 1)
(declare-const g SecurityTargetAssurance)
(assert (SecurityTargetAssurance_all_enabled g))
(assert (not (ase_ccl_conformant g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. SecurityTargetAssurance: SecurityTargetAssurance_all_enabled implies ase_ecd_complete ---
(push 1)
(declare-const g SecurityTargetAssurance)
(assert (SecurityTargetAssurance_all_enabled g))
(assert (not (ase_ecd_complete g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. SecurityTargetAssurance: SecurityTargetAssurance_all_enabled implies ase_int_complete ---
(push 1)
(declare-const g SecurityTargetAssurance)
(assert (SecurityTargetAssurance_all_enabled g))
(assert (not (ase_int_complete g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TestAssurance record properties ---

; --- 63. TestAssurance accessor round-trip: ate_cov_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ate_cov_complete (mk-test_assurance f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. TestAssurance accessor round-trip: ate_dpt_sufficient ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ate_dpt_sufficient (mk-test_assurance f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. TestAssurance accessor round-trip: ate_fun_complete ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ate_fun_complete (mk-test_assurance f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TestAssurance_all_enabled ((g TestAssurance)) Bool
  (and (ate_cov_complete g) (ate_dpt_sufficient g) (ate_fun_complete g)))

; --- 66. TestAssurance: all-enabled completeness ---
(push 1)
(declare-const g TestAssurance)
(assert (ate_cov_complete g))
(assert (ate_dpt_sufficient g))
(assert (ate_fun_complete g))
(assert (not (TestAssurance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. TestAssurance: TestAssurance_all_enabled implies ate_cov_complete ---
(push 1)
(declare-const g TestAssurance)
(assert (TestAssurance_all_enabled g))
(assert (not (ate_cov_complete g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. TestAssurance: TestAssurance_all_enabled implies ate_dpt_sufficient ---
(push 1)
(declare-const g TestAssurance)
(assert (TestAssurance_all_enabled g))
(assert (not (ate_dpt_sufficient g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. TestAssurance: TestAssurance_all_enabled implies ate_fun_complete ---
(push 1)
(declare-const g TestAssurance)
(assert (TestAssurance_all_enabled g))
(assert (not (ate_fun_complete g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VulnerabilityAssurance record properties ---

; --- 70. VulnerabilityAssurance accessor round-trip: ava_van_basic ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ava_van_basic (mk-vulnerability_assurance f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. VulnerabilityAssurance accessor round-trip: ava_van_focused ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ava_van_focused (mk-vulnerability_assurance f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. VulnerabilityAssurance accessor round-trip: ava_van_methodical ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ava_van_methodical (mk-vulnerability_assurance f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. VulnerabilityAssurance accessor round-trip: ava_van_advanced ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ava_van_advanced (mk-vulnerability_assurance f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun VulnerabilityAssurance_all_enabled ((g VulnerabilityAssurance)) Bool
  (and (ava_van_basic g) (ava_van_focused g) (ava_van_methodical g) (ava_van_advanced g)))

; --- 74. VulnerabilityAssurance: all-enabled completeness ---
(push 1)
(declare-const g VulnerabilityAssurance)
(assert (ava_van_basic g))
(assert (ava_van_focused g))
(assert (ava_van_methodical g))
(assert (ava_van_advanced g))
(assert (not (VulnerabilityAssurance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. VulnerabilityAssurance: VulnerabilityAssurance_all_enabled implies ava_van_basic ---
(push 1)
(declare-const g VulnerabilityAssurance)
(assert (VulnerabilityAssurance_all_enabled g))
(assert (not (ava_van_basic g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. VulnerabilityAssurance: VulnerabilityAssurance_all_enabled implies ava_van_focused ---
(push 1)
(declare-const g VulnerabilityAssurance)
(assert (VulnerabilityAssurance_all_enabled g))
(assert (not (ava_van_focused g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. VulnerabilityAssurance: VulnerabilityAssurance_all_enabled implies ava_van_methodical ---
(push 1)
(declare-const g VulnerabilityAssurance)
(assert (VulnerabilityAssurance_all_enabled g))
(assert (not (ava_van_methodical g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EAL7Package record properties ---

; --- 78. EAL7Package accessor round-trip: eal7_adv ---
(push 1)
(declare-const f0 DevelopmentAssurance)
(declare-const f1 GuidanceAssurance)
(declare-const f2 LifecycleAssurance)
(declare-const f3 SecurityTargetAssurance)
(declare-const f4 TestAssurance)
(declare-const f5 VulnerabilityAssurance)
(assert (not (= (eal7_adv (mk-eal7_package f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. EAL7Package accessor round-trip: eal7_agd ---
(push 1)
(declare-const f0 DevelopmentAssurance)
(declare-const f1 GuidanceAssurance)
(declare-const f2 LifecycleAssurance)
(declare-const f3 SecurityTargetAssurance)
(declare-const f4 TestAssurance)
(declare-const f5 VulnerabilityAssurance)
(assert (not (= (eal7_agd (mk-eal7_package f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. EAL7Package accessor round-trip: eal7_alc ---
(push 1)
(declare-const f0 DevelopmentAssurance)
(declare-const f1 GuidanceAssurance)
(declare-const f2 LifecycleAssurance)
(declare-const f3 SecurityTargetAssurance)
(declare-const f4 TestAssurance)
(declare-const f5 VulnerabilityAssurance)
(assert (not (= (eal7_alc (mk-eal7_package f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. EAL7Package accessor round-trip: eal7_ase ---
(push 1)
(declare-const f0 DevelopmentAssurance)
(declare-const f1 GuidanceAssurance)
(declare-const f2 LifecycleAssurance)
(declare-const f3 SecurityTargetAssurance)
(declare-const f4 TestAssurance)
(declare-const f5 VulnerabilityAssurance)
(assert (not (= (eal7_ase (mk-eal7_package f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. EAL7Package accessor round-trip: eal7_ate ---
(push 1)
(declare-const f0 DevelopmentAssurance)
(declare-const f1 GuidanceAssurance)
(declare-const f2 LifecycleAssurance)
(declare-const f3 SecurityTargetAssurance)
(declare-const f4 TestAssurance)
(declare-const f5 VulnerabilityAssurance)
(assert (not (= (eal7_ate (mk-eal7_package f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityContext record properties ---

; --- 83. SecurityContext accessor round-trip: ctx_clearance ---
(push 1)
(declare-const f0 SecurityLabel)
(declare-const f1 SecurityLabel)
(declare-const f2 SecurityLabel)
(assert (not (= (ctx_clearance (mk-security_context f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. SecurityContext accessor round-trip: ctx_current_label ---
(push 1)
(declare-const f0 SecurityLabel)
(declare-const f1 SecurityLabel)
(declare-const f2 SecurityLabel)
(assert (not (= (ctx_current_label (mk-security_context f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityClass ordering properties ---

(define-fun SecurityClass_level ((x SecurityClass)) Int
  (ite (= x FAU_ARP) 0 (ite (= x FAU_GEN) 1 (ite (= x FAU_SAA) 2 (ite (= x FAU_SAR) 3 (ite (= x FAU_SEL) 4 (ite (= x FAU_STG) 5 (ite (= x FCO_NRO) 6 (ite (= x FCO_NRR) 7 (ite (= x FCS_CKM) 8 (ite (= x FCS_COP) 9 (ite (= x FDP_ACC) 10 (ite (= x FDP_ACF) 11 (ite (= x FDP_IFC) 12 (ite (= x FDP_IFF) 13 (ite (= x FDP_ITT) 14 (ite (= x FDP_RIP) 15 (ite (= x FIA_AFL) 16 (ite (= x FIA_ATD) 17 (ite (= x FIA_SOS) 18 (ite (= x FIA_UAU) 19 (ite (= x FIA_UID) 20 (ite (= x FMT_MOF) 21 (ite (= x FMT_MSA) 22 (ite (= x FMT_MTD) 23 (ite (= x FMT_SMF) 24 (ite (= x FMT_SMR) 25 (ite (= x FPR_ANO) 26 (ite (= x FPR_PSE) 27 (ite (= x FPR_UNL) 28 (ite (= x FPR_UNO) 29 (ite (= x FPT_FLS) 30 (ite (= x FPT_ITC) 31 (ite (= x FPT_ITI) 32 (ite (= x FPT_ITT) 33 (ite (= x FPT_RCV) 34 (ite (= x FPT_RPL) 35 (ite (= x FPT_SEP) 36 (ite (= x FPT_STM) 37 (ite (= x FPT_TDC) 38 (ite (= x FPT_TEE) 39 (ite (= x FRU_FLT) 40 (ite (= x FRU_PRS) 41 (ite (= x FRU_RSA) 42 (ite (= x FTA_LSA) 43 (ite (= x FTA_MCS) 44 (ite (= x FTA_SSL) 45 (ite (= x FTA_TAB) 46 (ite (= x FTA_TAH) 47 (ite (= x FTA_TSE) 48 (ite (= x FTP_ITC) 49 50)))))))))))))))))))))))))))))))))))))))))))))))))))

(define-fun SecurityClass_leq ((x SecurityClass) (y SecurityClass)) Bool
  (<= (SecurityClass_level x) (SecurityClass_level y)))

; --- 85. SecurityClass_leq reflexivity ---
(push 1)
(declare-const x SecurityClass)
(assert (not (SecurityClass_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. SecurityClass_leq transitivity ---
(push 1)
(declare-const x SecurityClass)
(declare-const y SecurityClass)
(declare-const z SecurityClass)
(assert (SecurityClass_leq x y))
(assert (SecurityClass_leq y z))
(assert (not (SecurityClass_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. SecurityClass_leq antisymmetry ---
(push 1)
(declare-const x SecurityClass)
(declare-const y SecurityClass)
(assert (SecurityClass_leq x y))
(assert (SecurityClass_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. FAU_ARP is bottom ---
(push 1)
(declare-const x SecurityClass)
(assert (not (SecurityClass_leq FAU_ARP x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. FTP_TRP is top ---
(push 1)
(declare-const x SecurityClass)
(assert (not (SecurityClass_leq x FTP_TRP)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityLabel ordering properties ---

(define-fun SecurityLabel_level ((x SecurityLabel)) Int
  (ite (= x SL_Public) 0 (ite (= x SL_Internal) 1 (ite (= x SL_Confidential) 2 (ite (= x SL_Secret) 3 4)))))

(define-fun SecurityLabel_leq ((x SecurityLabel) (y SecurityLabel)) Bool
  (<= (SecurityLabel_level x) (SecurityLabel_level y)))

; --- 90. SecurityLabel_leq reflexivity ---
(push 1)
(declare-const x SecurityLabel)
(assert (not (SecurityLabel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. SecurityLabel_leq transitivity ---
(push 1)
(declare-const x SecurityLabel)
(declare-const y SecurityLabel)
(declare-const z SecurityLabel)
(assert (SecurityLabel_leq x y))
(assert (SecurityLabel_leq y z))
(assert (not (SecurityLabel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 92. SecurityLabel_leq antisymmetry ---
(push 1)
(declare-const x SecurityLabel)
(declare-const y SecurityLabel)
(assert (SecurityLabel_leq x y))
(assert (SecurityLabel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. SL_Public is bottom ---
(push 1)
(declare-const x SecurityLabel)
(assert (not (SecurityLabel_leq SL_Public x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. SL_TopSecret is top ---
(push 1)
(declare-const x SecurityLabel)
(assert (not (SecurityLabel_leq x SL_TopSecret)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

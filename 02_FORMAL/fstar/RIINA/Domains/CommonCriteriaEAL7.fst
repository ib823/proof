(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/CommonCriteriaEAL7.v (52 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.CommonCriteriaEAL7
open FStar.All

(* SecurityClass (matches Coq) *)
type security_class =
  | FAU_ARP
  | FAU_GEN
  | FAU_SAA
  | FAU_SAR
  | FAU_SEL
  | FAU_STG
  | FCO_NRO
  | FCO_NRR
  | FCS_CKM
  | FCS_COP
  | FDP_ACC
  | FDP_ACF
  | FDP_IFC
  | FDP_IFF
  | FDP_ITT
  | FDP_RIP
  | FIA_AFL
  | FIA_ATD
  | FIA_SOS
  | FIA_UAU
  | FIA_UID
  | FMT_MOF
  | FMT_MSA
  | FMT_MTD
  | FMT_SMF
  | FMT_SMR
  | FPR_ANO
  | FPR_PSE
  | FPR_UNL
  | FPR_UNO
  | FPT_FLS
  | FPT_ITC
  | FPT_ITI
  | FPT_ITT
  | FPT_RCV
  | FPT_RPL
  | FPT_SEP
  | FPT_STM
  | FPT_TDC
  | FPT_TEE
  | FRU_FLT
  | FRU_PRS
  | FRU_RSA
  | FTA_LSA
  | FTA_MCS
  | FTA_SSL
  | FTA_TAB
  | FTA_TAH
  | FTA_TSE
  | FTP_ITC
  | FTP_TRP

(* SecurityLabel (matches Coq) *)
type security_label =
  | SL_Public
  | SL_Internal
  | SL_Confidential
  | SL_Secret
  | SL_TopSecret

(* RiinaType (matches Coq) *)
type riina_type =
  | RT_Unit
  | RT_Bool
  | RT_Int
  | RT_Labeled of (security_label * riina_type)
  | RT_Ref of riina_type
  | RT_Arrow of (riina_type * riina_type)
  | RT_Product of (riina_type * riina_type)
  | RT_Sum of (riina_type * riina_type)

(* RiinaValue (matches Coq) *)
type riina_value =
  | RV_Unit
  | RV_Bool of bool
  | RV_Int of nat
  | RV_Labeled of (security_label * riina_value)
  | RV_Loc of nat
  | RV_Closure of nat
  | RV_Pair of (riina_value * riina_value)
  | RV_Inl of riina_value
  | RV_Inr of riina_value

(* SecurityPolicyModel (matches Coq) *)
type security_policy_model = {
  f_spm_subjects: Type0;
  f_spm_objects: Type0;
  f_spm_operations: Type0;
  f_spm_security_attributes: Type0;
  f_spm_access_control: nat;
  f_spm_information_flow: nat;
}

(* TOEConfiguration (matches Coq) *)
type toe_configuration = {
  f_toe_boundary_defined: bool;
  f_toe_interfaces_specified: bool;
  f_toe_security_functions: list bool;
  f_toe_security_policy: security_policy_model;
  f_toe_evaluated_configuration: bool;
}

(* DevelopmentAssurance (matches Coq) *)
type development_assurance = {
  f_adv_arc_complete: bool;
  f_adv_arc_modular: bool;
  f_adv_arc_non_bypassable: bool;
  f_adv_arc_tamper_proof: bool;
  f_adv_arc_domain_sep: bool;
  f_adv_fsp_complete: bool;
  f_adv_fsp_accurate: bool;
  f_adv_imp_complete: bool;
  f_adv_imp_verified: bool;
  f_adv_int_modular: bool;
  f_adv_int_layered: bool;
  f_adv_int_minimal: bool;
  f_adv_tds_semiformal: bool;
  f_adv_tds_formal: bool;
}

(* GuidanceAssurance (matches Coq) *)
type guidance_assurance = {
  f_agd_ope_complete: bool;
  f_agd_pre_complete: bool;
}

(* LifecycleAssurance (matches Coq) *)
type lifecycle_assurance = {
  f_alc_cmc_automated: bool;
  f_alc_cmc_coverage: bool;
  f_alc_cms_tracking: bool;
  f_alc_del_secure: bool;
  f_alc_dvs_sufficient: bool;
  f_alc_flaw_systematic: bool;
  f_alc_lcd_defined: bool;
  f_alc_tat_compliance: bool;
}

(* SecurityTargetAssurance (matches Coq) *)
type security_target_assurance = {
  f_ase_ccl_conformant: bool;
  f_ase_ecd_complete: bool;
  f_ase_int_complete: bool;
  f_ase_obj_complete: bool;
  f_ase_req_complete: bool;
  f_ase_spd_complete: bool;
  f_ase_tss_complete: bool;
}

(* TestAssurance (matches Coq) *)
type test_assurance = {
  f_ate_cov_complete: bool;
  f_ate_dpt_sufficient: bool;
  f_ate_fun_complete: bool;
  f_ate_ind_performed: bool;
}

(* VulnerabilityAssurance (matches Coq) *)
type vulnerability_assurance = {
  f_ava_van_basic: bool;
  f_ava_van_focused: bool;
  f_ava_van_methodical: bool;
  f_ava_van_advanced: bool;
  f_ava_van_high_attack: bool;
}

(* EAL7Package (matches Coq) *)
type eal7_package = {
  f_eal7_adv: development_assurance;
  f_eal7_agd: guidance_assurance;
  f_eal7_alc: lifecycle_assurance;
  f_eal7_ase: security_target_assurance;
  f_eal7_ate: test_assurance;
  f_eal7_ava: vulnerability_assurance;
}

(* SecurityContext (matches Coq) *)
type security_context = {
  f_ctx_clearance: security_label;
  f_ctx_current_label: security_label;
  f_ctx_integrity_label: security_label;
}

(* label_leq (matches Coq: Definition label_leq) *)
let label_leq (p_l1: security_label) (p_l2: security_label) : Tot bool =
  match p_l1, p_l2 with
  | SL_Public, _ -> true
  | SL_Internal, SL_Public -> false
  | SL_Internal, _ -> true
  | SL_Confidential, SL_Public -> false
  | SL_Confidential, SL_Internal -> false
  | SL_Confidential, _ -> true
  | SL_Secret, SL_TopSecret -> true
  | SL_Secret, SL_Secret -> true
  | SL_Secret, _ -> false
  | SL_TopSecret, SL_TopSecret -> true
  | SL_TopSecret, _ -> false
  | _ -> false

(* valid_security_context (matches Coq: Definition valid_security_context) *)
let valid_security_context (p_ctx: security_context) : Tot bool =
  label_leq (p_ctx.f_ctx_current_label) (p_ctx.f_ctx_clearance)

(* adv_compliant (matches Coq: Definition adv_compliant) *)
let adv_compliant (p_adv: development_assurance) : Tot bool =
  p_adv.f_adv_arc_complete && p_adv.f_adv_arc_modular && p_adv.f_adv_arc_non_bypassable && p_adv.f_adv_arc_tamper_proof && p_adv.f_adv_arc_domain_sep && p_adv.f_adv_fsp_complete && p_adv.f_adv_fsp_accurate && p_adv.f_adv_imp_complete && p_adv.f_adv_imp_verified && p_adv.f_adv_int_modular && p_adv.f_adv_int_layered && p_adv.f_adv_int_minimal && p_adv.f_adv_tds_semiformal && p_adv.f_adv_tds_formal

(* agd_compliant (matches Coq: Definition agd_compliant) *)
let agd_compliant (p_agd: guidance_assurance) : Tot bool =
  p_agd.f_agd_ope_complete && p_agd.f_agd_pre_complete

(* alc_compliant (matches Coq: Definition alc_compliant) *)
let alc_compliant (p_alc: lifecycle_assurance) : Tot bool =
  p_alc.f_alc_cmc_automated && p_alc.f_alc_cmc_coverage && p_alc.f_alc_cms_tracking && p_alc.f_alc_del_secure && p_alc.f_alc_dvs_sufficient && p_alc.f_alc_flaw_systematic && p_alc.f_alc_lcd_defined && p_alc.f_alc_tat_compliance

(* ase_compliant (matches Coq: Definition ase_compliant) *)
let ase_compliant (p_ase: security_target_assurance) : Tot bool =
  p_ase.f_ase_ccl_conformant && p_ase.f_ase_ecd_complete && p_ase.f_ase_int_complete && p_ase.f_ase_obj_complete && p_ase.f_ase_req_complete && p_ase.f_ase_spd_complete && p_ase.f_ase_tss_complete

(* ate_compliant (matches Coq: Definition ate_compliant) *)
let ate_compliant (p_ate: test_assurance) : Tot bool =
  p_ate.f_ate_cov_complete && p_ate.f_ate_dpt_sufficient && p_ate.f_ate_fun_complete && p_ate.f_ate_ind_performed

(* ava_compliant (matches Coq: Definition ava_compliant) *)
let ava_compliant (p_ava: vulnerability_assurance) : Tot bool =
  p_ava.f_ava_van_basic && p_ava.f_ava_van_focused && p_ava.f_ava_van_methodical && p_ava.f_ava_van_advanced && p_ava.f_ava_van_high_attack

(* eal7_compliant (matches Coq: Definition eal7_compliant) *)
let eal7_compliant (p_pkg: eal7_package) : Tot bool =
  adv_compliant (p_pkg.f_eal7_adv) && agd_compliant (p_pkg.f_eal7_agd) && alc_compliant (p_pkg.f_eal7_alc) && ase_compliant (p_pkg.f_eal7_ase) && ate_compliant (p_pkg.f_eal7_ate) && ava_compliant (p_pkg.f_eal7_ava)

(* no_write_down (matches Coq: Definition no_write_down) *)
let no_write_down (p_src_label: security_label) (p_dst_label: security_label) : Tot bool =
  label_leq p_src_label p_dst_label

(* no_read_up (matches Coq: Definition no_read_up) *)
let no_read_up (p_reader_clearance: security_label) (p_obj_label: security_label) : Tot bool =
  label_leq p_obj_label p_reader_clearance

(* blp_simple_security (matches Coq: Definition blp_simple_security) *)
let blp_simple_security (p_subj_clearance: security_label) (p_obj_class: security_label) : Tot bool =
  label_leq p_obj_class p_subj_clearance

(* blp_star_property (matches Coq: Definition blp_star_property) *)
let blp_star_property (p_subj_current: security_label) (p_obj_class: security_label) : Tot bool =
  label_leq p_subj_current p_obj_class

(* mk_compliant_adv (matches Coq: Definition mk_compliant_adv) *)
let mk_compliant_adv : development_assurance = {f_adv_arc_complete=true; f_adv_arc_modular=true; f_adv_arc_non_bypassable=true; f_adv_arc_tamper_proof=true; f_adv_arc_domain_sep=true; f_adv_fsp_complete=true; f_adv_fsp_accurate=true; f_adv_imp_complete=true; f_adv_imp_verified=true; f_adv_int_modular=true; f_adv_int_layered=true; f_adv_int_minimal=true; f_adv_tds_semiformal=true; f_adv_tds_formal=true}

(* mk_compliant_ava (matches Coq: Definition mk_compliant_ava) *)
let mk_compliant_ava : vulnerability_assurance = {f_ava_van_basic=true; f_ava_van_focused=true; f_ava_van_methodical=true; f_ava_van_advanced=true; f_ava_van_high_attack=true}

(* mk_compliant_agd (matches Coq: Definition mk_compliant_agd) *)
let mk_compliant_agd : guidance_assurance = {f_agd_ope_complete=true; f_agd_pre_complete=true}

(* mk_compliant_alc (matches Coq: Definition mk_compliant_alc) *)
let mk_compliant_alc : lifecycle_assurance = {f_alc_cmc_automated=true; f_alc_cmc_coverage=true; f_alc_cms_tracking=true; f_alc_del_secure=true; f_alc_dvs_sufficient=true; f_alc_flaw_systematic=true; f_alc_lcd_defined=true; f_alc_tat_compliance=true}

(* mk_compliant_ase (matches Coq: Definition mk_compliant_ase) *)
let mk_compliant_ase : security_target_assurance = {f_ase_ccl_conformant=true; f_ase_ecd_complete=true; f_ase_int_complete=true; f_ase_obj_complete=true; f_ase_req_complete=true; f_ase_spd_complete=true; f_ase_tss_complete=true}

(* mk_compliant_ate (matches Coq: Definition mk_compliant_ate) *)
let mk_compliant_ate : test_assurance = {f_ate_cov_complete=true; f_ate_dpt_sufficient=true; f_ate_fun_complete=true; f_ate_ind_performed=true}

(* mk_compliant_eal7 (matches Coq: Definition mk_compliant_eal7) *)
let mk_compliant_eal7 : eal7_package = {f_eal7_adv=mk_compliant_adv; f_eal7_agd=mk_compliant_agd; f_eal7_alc=mk_compliant_alc; f_eal7_ase=mk_compliant_ase; f_eal7_ate=mk_compliant_ate; f_eal7_ava=mk_compliant_ava}

(* has_audit (matches Coq: Definition has_audit) *)
let has_audit (p_classes: (list security_class)) : Tot bool =
  existsb (fun c -> match c with
  | FAU_GEN -> true
  | _ -> false) p_classes

(* has_crypto_key_mgmt (matches Coq: Definition has_crypto_key_mgmt) *)
let has_crypto_key_mgmt (p_classes: (list security_class)) : Tot bool =
  existsb (fun c -> match c with
  | FCS_CKM -> true
  | _ -> false) p_classes

(* has_ifc (matches Coq: Definition has_ifc) *)
let has_ifc (p_classes: (list security_class)) : Tot bool =
  existsb (fun c -> match c with
  | FDP_IFC -> true
  | _ -> false) p_classes

(* has_domain_sep (matches Coq: Definition has_domain_sep) *)
let has_domain_sep (p_classes: (list security_class)) : Tot bool =
  existsb (fun c -> match c with
  | FPT_SEP -> true
  | _ -> false) p_classes

(* has_authentication (matches Coq: Definition has_authentication) *)
let has_authentication (p_classes: (list security_class)) : Tot bool =
  existsb (fun c -> match c with
  | FIA_UAU -> true
  | _ -> false) p_classes

(* riina_spm (matches Coq: Definition riina_spm) *)
let riina_spm : security_policy_model = {f_spm_subjects=nat; f_spm_objects=nat; f_spm_operations=nat; f_spm_security_attributes=SecurityLabel; f_spm_access_control=(fun _ _ _ => true); f_spm_information_flow=(fun _ _ -> true)}

(* riina_toe (matches Coq: Definition riina_toe) *)
let riina_toe : toe_configuration = mkTOE true true riina_security_classes riina_spm true

(* has_complete_coverage (matches Coq: Definition has_complete_coverage) *)
let has_complete_coverage (p_classes: (list security_class)) : Tot bool =
  has_audit p_classes && has_crypto_key_mgmt p_classes && has_ifc p_classes && has_domain_sep p_classes && has_authentication p_classes

(* CC_001_label_reflexivity (matches Coq: Theorem CC_001_label_reflexivity) *)
let cc_001_label_reflexivity (p_l: security_label) : Lemma (label_leq p_l p_l == true) = ()

(* CC_002_label_transitivity (matches Coq: Theorem CC_002_label_transitivity) *)
let cc_002_label_transitivity (p_l1: security_label) (p_l2: security_label) (p_l3: security_label) : Lemma (requires (label_leq p_l1 p_l2 == true /\ label_leq p_l2 p_l3 == true)) (ensures (label_leq p_l1 p_l3 == true)) = ()

(* CC_003_label_antisymmetry (matches Coq: Theorem CC_003_label_antisymmetry) *)
let cc_003_label_antisymmetry (p_l1: security_label) (p_l2: security_label) : Lemma (requires (label_leq p_l1 p_l2 == true /\ label_leq p_l2 p_l1 == true)) (ensures (p_l1 == p_l2)) = ()

(* CC_004_public_is_bottom (matches Coq: Theorem CC_004_public_is_bottom) *)
let cc_004_public_is_bottom (p_l: security_label) : Lemma (label_leq SL_Public p_l == true) = ()

(* CC_005_topsecret_is_top (matches Coq: Theorem CC_005_topsecret_is_top) *)
let cc_005_topsecret_is_top (p_l: security_label) : Lemma (label_leq p_l SL_TopSecret == true) = ()

(* CC_006_valid_context_clearance (matches Coq: Theorem CC_006_valid_context_clearance) *)
let cc_006_valid_context_clearance (p_ctx: security_context) : Lemma (requires (valid_security_context p_ctx == true)) (ensures (label_leq (p_ctx.f_ctx_current_label) (p_ctx.f_ctx_clearance) == true)) = ()

(* CC_007_no_write_down_preserves_confidentiality (matches Coq: Theorem CC_007_no_write_down_preserves_confidentiality) *)
let cc_007_no_write_down_preserves_confidentiality (p_src: security_label) (p_dst: security_label) : Lemma (requires (no_write_down p_src p_dst == true)) (ensures (label_leq p_src p_dst == true)) = ()

(* CC_008_no_read_up_prevents_leakage (matches Coq: Theorem CC_008_no_read_up_prevents_leakage) *)
let cc_008_no_read_up_prevents_leakage (p_clearance: security_label) (p_obj_label: security_label) : Lemma (requires (no_read_up p_clearance p_obj_label == true)) (ensures (label_leq p_obj_label p_clearance == true)) = ()

(* CC_009_blp_simple_security_sound (matches Coq: Theorem CC_009_blp_simple_security_sound) *)
let cc_009_blp_simple_security_sound (p_subj_clear: security_label) (p_obj_class: security_label) : Lemma (requires (blp_simple_security p_subj_clear p_obj_class == true)) (ensures (label_leq p_obj_class p_subj_clear == true)) = ()

(* CC_010_blp_star_property_sound (matches Coq: Theorem CC_010_blp_star_property_sound) *)
let cc_010_blp_star_property_sound (p_subj_curr: security_label) (p_obj_class: security_label) : Lemma (requires (blp_star_property p_subj_curr p_obj_class == true)) (ensures (label_leq p_subj_curr p_obj_class == true)) = ()

(* CC_011_compliant_adv_valid (matches Coq: Theorem CC_011_compliant_adv_valid) *)
let cc_011_compliant_adv_valid () : Lemma (adv_compliant mk_compliant_adv == true) = ()

(* andb_true_iff (matches Coq: Lemma andb_true_iff) *)
let andb_true_iff (p_a: bool) (p_b: bool) : Lemma (p_a && p_b == true <==> p_a == true /\ p_b == true) = ()

(* CC_012_architecture_completeness (matches Coq: Theorem CC_012_architecture_completeness) *)
let cc_012_architecture_completeness (p_adv: development_assurance) : Lemma (requires (adv_compliant p_adv == true)) (ensures (p_adv.f_adv_arc_complete == true)) = ()

(* CC_013_formal_verification_required (matches Coq: Theorem CC_013_formal_verification_required) *)
let cc_013_formal_verification_required (p_adv: development_assurance) : Lemma (requires (adv_compliant p_adv == true)) (ensures (p_adv.f_adv_imp_verified == true)) = ()

(* CC_014_formal_design_required (matches Coq: Theorem CC_014_formal_design_required) *)
let cc_014_formal_design_required (p_adv: development_assurance) : Lemma (requires (adv_compliant p_adv == true)) (ensures (p_adv.f_adv_tds_formal == true)) = ()

(* CC_015_non_bypassability (matches Coq: Theorem CC_015_non_bypassability) *)
let cc_015_non_bypassability (p_adv: development_assurance) : Lemma (requires (adv_compliant p_adv == true)) (ensures (p_adv.f_adv_arc_non_bypassable == true)) = ()

(* CC_016_tamper_proof (matches Coq: Theorem CC_016_tamper_proof) *)
let cc_016_tamper_proof (p_adv: development_assurance) : Lemma (requires (adv_compliant p_adv == true)) (ensures (p_adv.f_adv_arc_tamper_proof == true)) = ()

(* CC_017_domain_separation (matches Coq: Theorem CC_017_domain_separation) *)
let cc_017_domain_separation (p_adv: development_assurance) : Lemma (requires (adv_compliant p_adv == true)) (ensures (p_adv.f_adv_arc_domain_sep == true)) = ()

(* CC_018_compliant_ava_valid (matches Coq: Theorem CC_018_compliant_ava_valid) *)
let cc_018_compliant_ava_valid () : Lemma (ava_compliant mk_compliant_ava == true) = ()

(* CC_019_advanced_analysis_required (matches Coq: Theorem CC_019_advanced_analysis_required) *)
let cc_019_advanced_analysis_required (p_ava: vulnerability_assurance) : Lemma (requires (ava_compliant p_ava == true)) (ensures (p_ava.f_ava_van_advanced == true)) = ()

(* CC_020_high_attack_potential_resistance (matches Coq: Theorem CC_020_high_attack_potential_resistance) *)
let cc_020_high_attack_potential_resistance (p_ava: vulnerability_assurance) : Lemma (requires (ava_compliant p_ava == true)) (ensures (p_ava.f_ava_van_high_attack == true)) = ()

(* CC_021_compliant_eal7_valid (matches Coq: Theorem CC_021_compliant_eal7_valid) *)
let cc_021_compliant_eal7_valid () : Lemma (eal7_compliant mk_compliant_eal7 == true) = ()

(* CC_022_eal7_implies_adv (matches Coq: Theorem CC_022_eal7_implies_adv) *)
let cc_022_eal7_implies_adv (p_pkg: eal7_package) : Lemma (requires (eal7_compliant p_pkg == true)) (ensures (adv_compliant (p_pkg.f_eal7_adv) == true)) = ()

(* CC_023_eal7_implies_ava (matches Coq: Theorem CC_023_eal7_implies_ava) *)
let cc_023_eal7_implies_ava (p_pkg: eal7_package) : Lemma (requires (eal7_compliant p_pkg == true)) (ensures (ava_compliant (p_pkg.f_eal7_ava) == true)) = ()

(* CC_024_eal7_implies_formal_verification (matches Coq: Theorem CC_024_eal7_implies_formal_verification) *)
let cc_024_eal7_implies_formal_verification (p_pkg: eal7_package) : Lemma (requires (eal7_compliant p_pkg == true)) (ensures ((p_pkg.f_eal7_adv).f_adv_imp_verified == true)) = ()

(* CC_025_eal7_implies_high_attack_resistance (matches Coq: Theorem CC_025_eal7_implies_high_attack_resistance) *)
let cc_025_eal7_implies_high_attack_resistance (p_pkg: eal7_package) : Lemma (requires (eal7_compliant p_pkg == true)) (ensures ((p_pkg.f_eal7_ava).f_ava_van_high_attack == true)) = ()

(* orb_true_iff (matches Coq: Lemma orb_true_iff) *)
let orb_true_iff (p_a: bool) (p_b: bool) : Lemma (p_a || p_b == true <==> p_a == true \/ p_b == true) = ()

(* CC_026_audit_generation_verifiable (matches Coq: Theorem CC_026_audit_generation_verifiable) *)
let cc_026_audit_generation_verifiable (p_classes: (list security_class)) : Lemma (requires (has_audit p_classes == true)) (ensures (List.Tot.memP FAU_GEN p_classes)) = ()

(* CC_027_crypto_key_mgmt_verifiable (matches Coq: Theorem CC_027_crypto_key_mgmt_verifiable) *)
let cc_027_crypto_key_mgmt_verifiable (p_classes: (list security_class)) : Lemma (requires (has_crypto_key_mgmt p_classes == true)) (ensures (List.Tot.memP FCS_CKM p_classes)) = ()

(* CC_028_ifc_verifiable (matches Coq: Theorem CC_028_ifc_verifiable) *)
let cc_028_ifc_verifiable (p_classes: (list security_class)) : Lemma (requires (has_ifc p_classes == true)) (ensures (List.Tot.memP FDP_IFC p_classes)) = ()

(* CC_029_domain_sep_verifiable (matches Coq: Theorem CC_029_domain_sep_verifiable) *)
let cc_029_domain_sep_verifiable (p_classes: (list security_class)) : Lemma (requires (has_domain_sep p_classes == true)) (ensures (List.Tot.memP FPT_SEP p_classes)) = ()

(* CC_030_authentication_verifiable (matches Coq: Theorem CC_030_authentication_verifiable) *)
let cc_030_authentication_verifiable (p_classes: (list security_class)) : Lemma (requires (has_authentication p_classes == true)) (ensures (List.Tot.memP FIA_UAU p_classes)) = ()

(* CC_031_riina_has_audit (matches Coq: Theorem CC_031_riina_has_audit) *)
let cc_031_riina_has_audit () : Lemma (has_audit (riina_toe.f_toe_security_functions) == true) = ()

(* CC_032_riina_has_crypto (matches Coq: Theorem CC_032_riina_has_crypto) *)
let cc_032_riina_has_crypto () : Lemma (has_crypto_key_mgmt (riina_toe.f_toe_security_functions) == true) = ()

(* CC_033_riina_has_ifc (matches Coq: Theorem CC_033_riina_has_ifc) *)
let cc_033_riina_has_ifc () : Lemma (has_ifc (riina_toe.f_toe_security_functions) == true) = ()

(* CC_034_riina_has_domain_sep (matches Coq: Theorem CC_034_riina_has_domain_sep) *)
let cc_034_riina_has_domain_sep () : Lemma (has_domain_sep (riina_toe.f_toe_security_functions) == true) = ()

(* CC_035_riina_has_authentication (matches Coq: Theorem CC_035_riina_has_authentication) *)
let cc_035_riina_has_authentication () : Lemma (has_authentication (riina_toe.f_toe_security_functions) == true) = ()

(* CC_036_riina_boundary_defined (matches Coq: Theorem CC_036_riina_boundary_defined) *)
let cc_036_riina_boundary_defined () : Lemma (riina_toe.f_toe_boundary_defined == true) = ()

(* CC_037_riina_interfaces_specified (matches Coq: Theorem CC_037_riina_interfaces_specified) *)
let cc_037_riina_interfaces_specified () : Lemma (riina_toe.f_toe_interfaces_specified == true) = ()

(* CC_038_riina_evaluated_configuration (matches Coq: Theorem CC_038_riina_evaluated_configuration) *)
let cc_038_riina_evaluated_configuration () : Lemma (riina_toe.f_toe_evaluated_configuration == true) = ()

(* CC_039_riina_complete_coverage (matches Coq: Theorem CC_039_riina_complete_coverage) *)
let cc_039_riina_complete_coverage () : Lemma (has_complete_coverage (riina_toe.f_toe_security_functions) == true) = ()

(* CC_040_maximum_assurance (matches Coq: Theorem CC_040_maximum_assurance) *)
let cc_040_maximum_assurance (p_pkg: eal7_package) (p_toe: toe_configuration) : Lemma (requires (eal7_compliant p_pkg == true /\ has_complete_coverage (p_toe.f_toe_security_functions) == true)) (ensures ((p_pkg.f_eal7_adv).f_adv_imp_verified == true /\ (p_pkg.f_eal7_ava).f_ava_van_high_attack == true)) = ()

(* CC_041_lifecycle_compliance (matches Coq: Theorem CC_041_lifecycle_compliance) *)
let cc_041_lifecycle_compliance () : Lemma (alc_compliant mk_compliant_alc == true) = ()

(* CC_042_flaw_remediation (matches Coq: Theorem CC_042_flaw_remediation) *)
let cc_042_flaw_remediation (p_alc: lifecycle_assurance) : Lemma (requires (alc_compliant p_alc == true)) (ensures (p_alc.f_alc_flaw_systematic == true)) = ()

(* CC_043_secure_delivery (matches Coq: Theorem CC_043_secure_delivery) *)
let cc_043_secure_delivery (p_alc: lifecycle_assurance) : Lemma (requires (alc_compliant p_alc == true)) (ensures (p_alc.f_alc_del_secure == true)) = ()

(* CC_044_cm_automation (matches Coq: Theorem CC_044_cm_automation) *)
let cc_044_cm_automation (p_alc: lifecycle_assurance) : Lemma (requires (alc_compliant p_alc == true)) (ensures (p_alc.f_alc_cmc_automated == true)) = ()

(* CC_045_test_compliance (matches Coq: Theorem CC_045_test_compliance) *)
let cc_045_test_compliance () : Lemma (ate_compliant mk_compliant_ate == true) = ()

(* CC_046_independent_testing (matches Coq: Theorem CC_046_independent_testing) *)
let cc_046_independent_testing (p_ate: test_assurance) : Lemma (requires (ate_compliant p_ate == true)) (ensures (p_ate.f_ate_ind_performed == true)) = ()

(* CC_047_coverage_testing (matches Coq: Theorem CC_047_coverage_testing) *)
let cc_047_coverage_testing (p_ate: test_assurance) : Lemma (requires (ate_compliant p_ate == true)) (ensures (p_ate.f_ate_cov_complete == true)) = ()

(* CC_048_st_compliance (matches Coq: Theorem CC_048_st_compliance) *)
let cc_048_st_compliance () : Lemma (ase_compliant mk_compliant_ase == true) = ()

(* CC_049_objectives_complete (matches Coq: Theorem CC_049_objectives_complete) *)
let cc_049_objectives_complete (p_ase: security_target_assurance) : Lemma (requires (ase_compliant p_ase == true)) (ensures (p_ase.f_ase_obj_complete == true)) = ()

(* CC_050_eal7_complete_certification (matches Coq: Theorem CC_050_eal7_complete_certification) *)
let cc_050_eal7_complete_certification (p_pkg: eal7_package) (p_toe: toe_configuration) : Lemma (requires (eal7_compliant p_pkg == true /\ p_toe.f_toe_boundary_defined == true /\ p_toe.f_toe_interfaces_specified == true /\ p_toe.f_toe_evaluated_configuration == true /\ has_complete_coverage (p_toe.f_toe_security_functions) == true)) (ensures (adv_compliant (p_pkg.f_eal7_adv) == true /\ agd_compliant (p_pkg.f_eal7_agd) == true /\ alc_compliant (p_pkg.f_eal7_alc) == true /\ ase_compliant (p_pkg.f_eal7_ase) == true /\ ate_compliant (p_pkg.f_eal7_ate) == true /\ ava_compliant (p_pkg.f_eal7_ava) == true)) = ()

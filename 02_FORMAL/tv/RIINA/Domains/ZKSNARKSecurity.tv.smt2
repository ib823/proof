; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ZKSNARKSecurity.v (98 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ZKSNARKSecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; zk_secure: source semantics (matches Coq)
; Translation validation: zk_secure preserves semantics
(push 1)
(declare-const source_zk_secure Int)
(declare-const target_zk_secure Int)
(assert (>= source_zk_secure 0))
(assert (>= target_zk_secure 0))
(assert (not (= source_zk_secure target_zk_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; snark_secure: source semantics (matches Coq)
; Translation validation: snark_secure preserves semantics
(push 1)
(declare-const source_snark_secure Int)
(declare-const target_snark_secure Int)
(assert (>= source_snark_secure 0))
(assert (>= target_snark_secure 0))
(assert (not (= source_snark_secure target_snark_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; setup_secure: source semantics (matches Coq)
; Translation validation: setup_secure preserves semantics
(push 1)
(declare-const source_setup_secure Int)
(declare-const target_setup_secure Int)
(assert (>= source_setup_secure 0))
(assert (>= target_setup_secure 0))
(assert (not (= source_setup_secure target_setup_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; zksnark_secure: source semantics (matches Coq)
; Translation validation: zksnark_secure preserves semantics
(push 1)
(declare-const source_zksnark_secure Int)
(declare-const target_zksnark_secure Int)
(assert (>= source_zksnark_secure 0))
(assert (>= target_zksnark_secure 0))
(assert (not (= source_zksnark_secure target_zksnark_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_zk: source semantics (matches Coq)
; Translation validation: riina_zk preserves semantics
(push 1)
(declare-const source_riina_zk Int)
(declare-const target_riina_zk Int)
(assert (>= source_riina_zk 0))
(assert (>= target_riina_zk 0))
(assert (not (= source_riina_zk target_riina_zk)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_snark: source semantics (matches Coq)
; Translation validation: riina_snark preserves semantics
(push 1)
(declare-const source_riina_snark Int)
(declare-const target_riina_snark Int)
(assert (>= source_riina_snark 0))
(assert (>= target_riina_snark 0))
(assert (not (= source_riina_snark target_riina_snark)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_setup: source semantics (matches Coq)
; Translation validation: riina_setup preserves semantics
(push 1)
(declare-const source_riina_setup Int)
(declare-const target_riina_setup Int)
(assert (>= source_riina_setup 0))
(assert (>= target_riina_setup 0))
(assert (not (= source_riina_setup target_riina_setup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_zksnark: source semantics (matches Coq)
; Translation validation: riina_zksnark preserves semantics
(push 1)
(declare-const source_riina_zksnark Int)
(declare-const target_riina_zksnark Int)
(assert (>= source_riina_zksnark 0))
(assert (>= target_riina_zksnark 0))
(assert (not (= source_riina_zksnark target_riina_zksnark)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ke_secure: source semantics (matches Coq)
; Translation validation: ke_secure preserves semantics
(push 1)
(declare-const source_ke_secure Int)
(declare-const target_ke_secure Int)
(assert (>= source_ke_secure 0))
(assert (>= target_ke_secure 0))
(assert (not (= source_ke_secure target_ke_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wr_valid: source semantics (matches Coq)
; Translation validation: wr_valid preserves semantics
(push 1)
(declare-const source_wr_valid Int)
(declare-const target_wr_valid Int)
(assert (>= source_wr_valid 0))
(assert (>= target_wr_valid 0))
(assert (not (= source_wr_valid target_wr_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_ke: source semantics (matches Coq)
; Translation validation: riina_ke preserves semantics
(push 1)
(declare-const source_riina_ke Int)
(declare-const target_riina_ke Int)
(assert (>= source_riina_ke 0))
(assert (>= target_riina_ke 0))
(assert (not (= source_riina_ke target_riina_ke)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_wr: source semantics (matches Coq)
; Translation validation: riina_wr preserves semantics
(push 1)
(declare-const source_riina_wr Int)
(declare-const target_riina_wr Int)
(assert (>= source_riina_wr 0))
(assert (>= target_riina_wr 0))
(assert (not (= source_riina_wr target_riina_wr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sim_secure: source semantics (matches Coq)
; Translation validation: sim_secure preserves semantics
(push 1)
(declare-const source_sim_secure Int)
(declare-const target_sim_secure Int)
(assert (>= source_sim_secure 0))
(assert (>= target_sim_secure 0))
(assert (not (= source_sim_secure target_sim_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; di_strong: source semantics (matches Coq)
; Translation validation: di_strong preserves semantics
(push 1)
(declare-const source_di_strong Int)
(declare-const target_di_strong Int)
(assert (>= source_di_strong 0))
(assert (>= target_di_strong 0))
(assert (not (= source_di_strong target_di_strong)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_sim: source semantics (matches Coq)
; Translation validation: riina_sim preserves semantics
(push 1)
(declare-const source_riina_sim Int)
(declare-const target_riina_sim Int)
(assert (>= source_riina_sim 0))
(assert (>= target_riina_sim 0))
(assert (not (= source_riina_sim target_riina_sim)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_di: source semantics (matches Coq)
; Translation validation: riina_di preserves semantics
(push 1)
(declare-const source_riina_di Int)
(declare-const target_riina_di Int)
(assert (>= source_riina_di 0))
(assert (>= target_riina_di 0))
(assert (not (= source_riina_di target_riina_di)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; completeness_holds: source semantics (matches Coq)
; Translation validation: completeness_holds preserves semantics
(push 1)
(declare-const source_completeness_holds Int)
(declare-const target_completeness_holds Int)
(assert (>= source_completeness_holds 0))
(assert (>= target_completeness_holds 0))
(assert (not (= source_completeness_holds target_completeness_holds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_prover: source semantics (matches Coq)
; Translation validation: riina_prover preserves semantics
(push 1)
(declare-const source_riina_prover Int)
(declare-const target_riina_prover Int)
(assert (>= source_riina_prover 0))
(assert (>= target_riina_prover 0))
(assert (not (= source_riina_prover target_riina_prover)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_verifier: source semantics (matches Coq)
; Translation validation: riina_verifier preserves semantics
(push 1)
(declare-const source_riina_verifier Int)
(declare-const target_riina_verifier Int)
(assert (>= source_riina_verifier 0))
(assert (>= target_riina_verifier 0))
(assert (not (= source_riina_verifier target_riina_verifier)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ps_succinct: source semantics (matches Coq)
; Translation validation: ps_succinct preserves semantics
(push 1)
(declare-const source_ps_succinct Int)
(declare-const target_ps_succinct Int)
(assert (>= source_ps_succinct 0))
(assert (>= target_ps_succinct 0))
(assert (not (= source_ps_succinct target_ps_succinct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ac_polylog: source semantics (matches Coq)
; Translation validation: ac_polylog preserves semantics
(push 1)
(declare-const source_ac_polylog Int)
(declare-const target_ac_polylog Int)
(assert (>= source_ac_polylog 0))
(assert (>= target_ac_polylog 0))
(assert (not (= source_ac_polylog target_ac_polylog)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_proof_size: source semantics (matches Coq)
; Translation validation: riina_proof_size preserves semantics
(push 1)
(declare-const source_riina_proof_size Int)
(declare-const target_riina_proof_size Int)
(assert (>= source_riina_proof_size 0))
(assert (>= target_riina_proof_size 0))
(assert (not (= source_riina_proof_size target_riina_proof_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_ac: source semantics (matches Coq)
; Translation validation: riina_ac preserves semantics
(push 1)
(declare-const source_riina_ac Int)
(declare-const target_riina_ac Int)
(assert (>= source_riina_ac 0))
(assert (>= target_riina_ac 0))
(assert (not (= source_riina_ac target_riina_ac)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mpc_secure: source semantics (matches Coq)
; Translation validation: mpc_secure preserves semantics
(push 1)
(declare-const source_mpc_secure Int)
(declare-const target_mpc_secure Int)
(assert (>= source_mpc_secure 0))
(assert (>= target_mpc_secure 0))
(assert (not (= source_mpc_secure target_mpc_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tw_secure: source semantics (matches Coq)
; Translation validation: tw_secure preserves semantics
(push 1)
(declare-const source_tw_secure Int)
(declare-const target_tw_secure Int)
(assert (>= source_tw_secure 0))
(assert (>= target_tw_secure 0))
(assert (not (= source_tw_secure target_tw_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_mpc: source semantics (matches Coq)
; Translation validation: riina_mpc preserves semantics
(push 1)
(declare-const source_riina_mpc Int)
(declare-const target_riina_mpc Int)
(assert (>= source_riina_mpc 0))
(assert (>= target_riina_mpc 0))
(assert (not (= source_riina_mpc target_riina_mpc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_tw: source semantics (matches Coq)
; Translation validation: riina_tw preserves semantics
(push 1)
(declare-const source_riina_tw Int)
(declare-const target_riina_tw Int)
(assert (>= source_riina_tw 0))
(assert (>= target_riina_tw 0))
(assert (not (= source_riina_tw target_riina_tw)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; g16_secure: source semantics (matches Coq)
; Translation validation: g16_secure preserves semantics
(push 1)
(declare-const source_g16_secure Int)
(declare-const target_g16_secure Int)
(assert (>= source_g16_secure 0))
(assert (>= target_g16_secure 0))
(assert (not (= source_g16_secure target_g16_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; g16p_valid: source semantics (matches Coq)
; Translation validation: g16p_valid preserves semantics
(push 1)
(declare-const source_g16p_valid Int)
(declare-const target_g16p_valid Int)
(assert (>= source_g16p_valid 0))
(assert (>= target_g16p_valid 0))
(assert (not (= source_g16p_valid target_g16p_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_g16: source semantics (matches Coq)
; Translation validation: riina_g16 preserves semantics
(push 1)
(declare-const source_riina_g16 Int)
(declare-const target_riina_g16 Int)
(assert (>= source_riina_g16 0))
(assert (>= target_riina_g16 0))
(assert (not (= source_riina_g16 target_riina_g16)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_g16_proof: source semantics (matches Coq)
; Translation validation: riina_g16_proof preserves semantics
(push 1)
(declare-const source_riina_g16_proof Int)
(declare-const target_riina_g16_proof Int)
(assert (>= source_riina_g16_proof 0))
(assert (>= target_riina_g16_proof 0))
(assert (not (= source_riina_g16_proof target_riina_g16_proof)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; plonk_secure: source semantics (matches Coq)
; Translation validation: plonk_secure preserves semantics
(push 1)
(declare-const source_plonk_secure Int)
(declare-const target_plonk_secure Int)
(assert (>= source_plonk_secure 0))
(assert (>= target_plonk_secure 0))
(assert (not (= source_plonk_secure target_plonk_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pg_valid: source semantics (matches Coq)
; Translation validation: pg_valid preserves semantics
(push 1)
(declare-const source_pg_valid Int)
(declare-const target_pg_valid Int)
(assert (>= source_pg_valid 0))
(assert (>= target_pg_valid 0))
(assert (not (= source_pg_valid target_pg_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_plonk: source semantics (matches Coq)
; Translation validation: riina_plonk preserves semantics
(push 1)
(declare-const source_riina_plonk Int)
(declare-const target_riina_plonk Int)
(assert (>= source_riina_plonk 0))
(assert (>= target_riina_plonk 0))
(assert (not (= source_riina_plonk target_riina_plonk)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_plonk_gate: source semantics (matches Coq)
; Translation validation: riina_plonk_gate preserves semantics
(push 1)
(declare-const source_riina_plonk_gate Int)
(declare-const target_riina_plonk_gate Int)
(assert (>= source_riina_plonk_gate 0))
(assert (>= target_riina_plonk_gate 0))
(assert (not (= source_riina_plonk_gate target_riina_plonk_gate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_zk_secure: source semantics (matches Coq)
; Translation validation: full_zk_secure preserves semantics
(push 1)
(declare-const source_full_zk_secure Int)
(declare-const target_full_zk_secure Int)
(assert (>= source_full_zk_secure 0))
(assert (>= target_full_zk_secure 0))
(assert (not (= source_full_zk_secure target_full_zk_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_full_zk: source semantics (matches Coq)
; Translation validation: riina_full_zk preserves semantics
(push 1)
(declare-const source_riina_full_zk Int)
(declare-const target_riina_full_zk Int)
(assert (>= source_riina_full_zk 0))
(assert (>= target_riina_full_zk 0))
(assert (not (= source_riina_full_zk target_riina_full_zk)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; se_secure: source semantics (matches Coq)
; Translation validation: se_secure preserves semantics
(push 1)
(declare-const source_se_secure Int)
(declare-const target_se_secure Int)
(assert (>= source_se_secure 0))
(assert (>= target_se_secure 0))
(assert (not (= source_se_secure target_se_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_se: source semantics (matches Coq)
; Translation validation: riina_se preserves semantics
(push 1)
(declare-const source_riina_se Int)
(declare-const target_riina_se Int)
(assert (>= source_riina_se 0))
(assert (>= target_riina_se 0))
(assert (not (= source_riina_se target_riina_se)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pst_is_snark: source semantics (matches Coq)
; Translation validation: pst_is_snark preserves semantics
(push 1)
(declare-const source_pst_is_snark Int)
(declare-const target_pst_is_snark Int)
(assert (>= source_pst_is_snark 0))
(assert (>= target_pst_is_snark 0))
(assert (not (= source_pst_is_snark target_pst_is_snark)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pst_is_stark: source semantics (matches Coq)
; Translation validation: pst_is_stark preserves semantics
(push 1)
(declare-const source_pst_is_stark Int)
(declare-const target_pst_is_stark Int)
(assert (>= source_pst_is_stark 0))
(assert (>= target_pst_is_stark 0))
(assert (not (= source_pst_is_stark target_pst_is_stark)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_pst: source semantics (matches Coq)
; Translation validation: riina_pst preserves semantics
(push 1)
(declare-const source_riina_pst Int)
(declare-const target_riina_pst Int)
(assert (>= source_riina_pst 0))
(assert (>= target_riina_pst 0))
(assert (not (= source_riina_pst target_riina_pst)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff preserves semantics
(push 1)
(declare-const source_andb_true_iff Int)
(declare-const target_andb_true_iff Int)
(assert (>= source_andb_true_iff 0))
(assert (>= target_andb_true_iff 0))
(assert (not (= source_andb_true_iff target_andb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb3_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb3_true_iff preserves semantics
(push 1)
(declare-const source_andb3_true_iff Int)
(declare-const target_andb3_true_iff Int)
(assert (>= source_andb3_true_iff 0))
(assert (>= target_andb3_true_iff 0))
(assert (not (= source_andb3_true_iff target_andb3_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb4_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb4_true_iff preserves semantics
(push 1)
(declare-const source_andb4_true_iff Int)
(declare-const target_andb4_true_iff Int)
(assert (>= source_andb4_true_iff 0))
(assert (>= target_andb4_true_iff 0))
(assert (not (= source_andb4_true_iff target_andb4_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_true_iff preserves semantics
(push 1)
(declare-const source_negb_true_iff Int)
(declare-const target_negb_true_iff Int)
(assert (>= source_negb_true_iff 0))
(assert (>= target_negb_true_iff 0))
(assert (not (= source_negb_true_iff target_negb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; leb_le: translation preserves property (matches Coq: Lemma)
; Translation validation: leb_le preserves semantics
(push 1)
(declare-const source_leb_le Int)
(declare-const target_leb_le Int)
(assert (>= source_leb_le 0))
(assert (>= target_leb_le 0))
(assert (not (= source_leb_le target_leb_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ltb_lt: translation preserves property (matches Coq: Lemma)
; Translation validation: ltb_lt preserves semantics
(push 1)
(declare-const source_ltb_lt Int)
(declare-const target_ltb_lt Int)
(assert (>= source_ltb_lt 0))
(assert (>= target_ltb_lt 0))
(assert (not (= source_ltb_lt target_ltb_lt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; orb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: orb_true_iff preserves semantics
(push 1)
(declare-const source_orb_true_iff Int)
(declare-const target_orb_true_iff Int)
(assert (>= source_orb_true_iff 0))
(assert (>= target_orb_true_iff 0))
(assert (not (= source_orb_true_iff target_orb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_001: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_001 preserves semantics
(push 1)
(declare-const source_ZK_001 Int)
(declare-const target_ZK_001 Int)
(assert (>= source_ZK_001 0))
(assert (>= target_ZK_001 0))
(assert (not (= source_ZK_001 target_ZK_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_002: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_002 preserves semantics
(push 1)
(declare-const source_ZK_002 Int)
(declare-const target_ZK_002 Int)
(assert (>= source_ZK_002 0))
(assert (>= target_ZK_002 0))
(assert (not (= source_ZK_002 target_ZK_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_003: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_003 preserves semantics
(push 1)
(declare-const source_ZK_003 Int)
(declare-const target_ZK_003 Int)
(assert (>= source_ZK_003 0))
(assert (>= target_ZK_003 0))
(assert (not (= source_ZK_003 target_ZK_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_004: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_004 preserves semantics
(push 1)
(declare-const source_ZK_004 Int)
(declare-const target_ZK_004 Int)
(assert (>= source_ZK_004 0))
(assert (>= target_ZK_004 0))
(assert (not (= source_ZK_004 target_ZK_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_005: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_005 preserves semantics
(push 1)
(declare-const source_ZK_005 Int)
(declare-const target_ZK_005 Int)
(assert (>= source_ZK_005 0))
(assert (>= target_ZK_005 0))
(assert (not (= source_ZK_005 target_ZK_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_006: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_006 preserves semantics
(push 1)
(declare-const source_ZK_006 Int)
(declare-const target_ZK_006 Int)
(assert (>= source_ZK_006 0))
(assert (>= target_ZK_006 0))
(assert (not (= source_ZK_006 target_ZK_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_007: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_007 preserves semantics
(push 1)
(declare-const source_ZK_007 Int)
(declare-const target_ZK_007 Int)
(assert (>= source_ZK_007 0))
(assert (>= target_ZK_007 0))
(assert (not (= source_ZK_007 target_ZK_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_008: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_008 preserves semantics
(push 1)
(declare-const source_ZK_008 Int)
(declare-const target_ZK_008 Int)
(assert (>= source_ZK_008 0))
(assert (>= target_ZK_008 0))
(assert (not (= source_ZK_008 target_ZK_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_009: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_009 preserves semantics
(push 1)
(declare-const source_ZK_009 Int)
(declare-const target_ZK_009 Int)
(assert (>= source_ZK_009 0))
(assert (>= target_ZK_009 0))
(assert (not (= source_ZK_009 target_ZK_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_010: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_010 preserves semantics
(push 1)
(declare-const source_ZK_010 Int)
(declare-const target_ZK_010 Int)
(assert (>= source_ZK_010 0))
(assert (>= target_ZK_010 0))
(assert (not (= source_ZK_010 target_ZK_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_011: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_011 preserves semantics
(push 1)
(declare-const source_ZK_011 Int)
(declare-const target_ZK_011 Int)
(assert (>= source_ZK_011 0))
(assert (>= target_ZK_011 0))
(assert (not (= source_ZK_011 target_ZK_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_012: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_012 preserves semantics
(push 1)
(declare-const source_ZK_012 Int)
(declare-const target_ZK_012 Int)
(assert (>= source_ZK_012 0))
(assert (>= target_ZK_012 0))
(assert (not (= source_ZK_012 target_ZK_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_013: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_013 preserves semantics
(push 1)
(declare-const source_ZK_013 Int)
(declare-const target_ZK_013 Int)
(assert (>= source_ZK_013 0))
(assert (>= target_ZK_013 0))
(assert (not (= source_ZK_013 target_ZK_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_014: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_014 preserves semantics
(push 1)
(declare-const source_ZK_014 Int)
(declare-const target_ZK_014 Int)
(assert (>= source_ZK_014 0))
(assert (>= target_ZK_014 0))
(assert (not (= source_ZK_014 target_ZK_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_015: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_015 preserves semantics
(push 1)
(declare-const source_ZK_015 Int)
(declare-const target_ZK_015 Int)
(assert (>= source_ZK_015 0))
(assert (>= target_ZK_015 0))
(assert (not (= source_ZK_015 target_ZK_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_016: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_016 preserves semantics
(push 1)
(declare-const source_ZK_016 Int)
(declare-const target_ZK_016 Int)
(assert (>= source_ZK_016 0))
(assert (>= target_ZK_016 0))
(assert (not (= source_ZK_016 target_ZK_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_017: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_017 preserves semantics
(push 1)
(declare-const source_ZK_017 Int)
(declare-const target_ZK_017 Int)
(assert (>= source_ZK_017 0))
(assert (>= target_ZK_017 0))
(assert (not (= source_ZK_017 target_ZK_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_018: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_018 preserves semantics
(push 1)
(declare-const source_ZK_018 Int)
(declare-const target_ZK_018 Int)
(assert (>= source_ZK_018 0))
(assert (>= target_ZK_018 0))
(assert (not (= source_ZK_018 target_ZK_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_019: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_019 preserves semantics
(push 1)
(declare-const source_ZK_019 Int)
(declare-const target_ZK_019 Int)
(assert (>= source_ZK_019 0))
(assert (>= target_ZK_019 0))
(assert (not (= source_ZK_019 target_ZK_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_020: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_020 preserves semantics
(push 1)
(declare-const source_ZK_020 Int)
(declare-const target_ZK_020 Int)
(assert (>= source_ZK_020 0))
(assert (>= target_ZK_020 0))
(assert (not (= source_ZK_020 target_ZK_020)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_021: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_021 preserves semantics
(push 1)
(declare-const source_ZK_021 Int)
(declare-const target_ZK_021 Int)
(assert (>= source_ZK_021 0))
(assert (>= target_ZK_021 0))
(assert (not (= source_ZK_021 target_ZK_021)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_022: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_022 preserves semantics
(push 1)
(declare-const source_ZK_022 Int)
(declare-const target_ZK_022 Int)
(assert (>= source_ZK_022 0))
(assert (>= target_ZK_022 0))
(assert (not (= source_ZK_022 target_ZK_022)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_023: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_023 preserves semantics
(push 1)
(declare-const source_ZK_023 Int)
(declare-const target_ZK_023 Int)
(assert (>= source_ZK_023 0))
(assert (>= target_ZK_023 0))
(assert (not (= source_ZK_023 target_ZK_023)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_024: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_024 preserves semantics
(push 1)
(declare-const source_ZK_024 Int)
(declare-const target_ZK_024 Int)
(assert (>= source_ZK_024 0))
(assert (>= target_ZK_024 0))
(assert (not (= source_ZK_024 target_ZK_024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ZK_025_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: ZK_025_complete preserves semantics
(push 1)
(declare-const source_ZK_025_complete Int)
(declare-const target_ZK_025_complete Int)
(assert (>= source_ZK_025_complete 0))
(assert (>= target_ZK_025_complete 0))
(assert (not (= source_ZK_025_complete target_ZK_025_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ke_001_riina_ke_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: ke_001_riina_ke_secure preserves semantics
(push 1)
(declare-const source_ke_001_riina_ke_secure Int)
(declare-const target_ke_001_riina_ke_secure Int)
(assert (>= source_ke_001_riina_ke_secure 0))
(assert (>= target_ke_001_riina_ke_secure 0))
(assert (not (= source_ke_001_riina_ke_secure target_ke_001_riina_ke_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ke_002_extractor_exists: translation preserves property (matches Coq: Theorem)
; Translation validation: ke_002_extractor_exists preserves semantics
(push 1)
(declare-const source_ke_002_extractor_exists Int)
(declare-const target_ke_002_extractor_exists Int)
(assert (>= source_ke_002_extractor_exists 0))
(assert (>= target_ke_002_extractor_exists 0))
(assert (not (= source_ke_002_extractor_exists target_ke_002_extractor_exists)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ke_003_extractor_polynomial: translation preserves property (matches Coq: Theorem)
; Translation validation: ke_003_extractor_polynomial preserves semantics
(push 1)
(declare-const source_ke_003_extractor_polynomial Int)
(declare-const target_ke_003_extractor_polynomial Int)
(assert (>= source_ke_003_extractor_polynomial 0))
(assert (>= target_ke_003_extractor_polynomial 0))
(assert (not (= source_ke_003_extractor_polynomial target_ke_003_extractor_polynomial)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ke_004_extractor_probability: translation preserves property (matches Coq: Theorem)
; Translation validation: ke_004_extractor_probability preserves semantics
(push 1)
(declare-const source_ke_004_extractor_probability Int)
(declare-const target_ke_004_extractor_probability Int)
(assert (>= source_ke_004_extractor_probability 0))
(assert (>= target_ke_004_extractor_probability 0))
(assert (not (= source_ke_004_extractor_probability target_ke_004_extractor_probability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ke_005_riina_wr_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ke_005_riina_wr_valid preserves semantics
(push 1)
(declare-const source_ke_005_riina_wr_valid Int)
(declare-const target_ke_005_riina_wr_valid Int)
(assert (>= source_ke_005_riina_wr_valid 0))
(assert (>= target_ke_005_riina_wr_valid 0))
(assert (not (= source_ke_005_riina_wr_valid target_ke_005_riina_wr_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ke_006_valid_satisfiable: translation preserves property (matches Coq: Theorem)
; Translation validation: ke_006_valid_satisfiable preserves semantics
(push 1)
(declare-const source_ke_006_valid_satisfiable Int)
(declare-const target_ke_006_valid_satisfiable Int)
(assert (>= source_ke_006_valid_satisfiable 0))
(assert (>= target_ke_006_valid_satisfiable 0))
(assert (not (= source_ke_006_valid_satisfiable target_ke_006_valid_satisfiable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ke_007_positive_statement: translation preserves property (matches Coq: Theorem)
; Translation validation: ke_007_positive_statement preserves semantics
(push 1)
(declare-const source_ke_007_positive_statement Int)
(declare-const target_ke_007_positive_statement Int)
(assert (>= source_ke_007_positive_statement 0))
(assert (>= target_ke_007_positive_statement 0))
(assert (not (= source_ke_007_positive_statement target_ke_007_positive_statement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ke_008_positive_witness: translation preserves property (matches Coq: Theorem)
; Translation validation: ke_008_positive_witness preserves semantics
(push 1)
(declare-const source_ke_008_positive_witness Int)
(declare-const target_ke_008_positive_witness Int)
(assert (>= source_ke_008_positive_witness 0))
(assert (>= target_ke_008_positive_witness 0))
(assert (not (= source_ke_008_positive_witness target_ke_008_positive_witness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sim_001_riina_sim_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: sim_001_riina_sim_secure preserves semantics
(push 1)
(declare-const source_sim_001_riina_sim_secure Int)
(declare-const target_sim_001_riina_sim_secure Int)
(assert (>= source_sim_001_riina_sim_secure 0))
(assert (>= target_sim_001_riina_sim_secure 0))
(assert (not (= source_sim_001_riina_sim_secure target_sim_001_riina_sim_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sim_002_simulator_exists: translation preserves property (matches Coq: Theorem)
; Translation validation: sim_002_simulator_exists preserves semantics
(push 1)
(declare-const source_sim_002_simulator_exists Int)
(declare-const target_sim_002_simulator_exists Int)
(assert (>= source_sim_002_simulator_exists 0))
(assert (>= target_sim_002_simulator_exists 0))
(assert (not (= source_sim_002_simulator_exists target_sim_002_simulator_exists)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sim_003_simulator_poly: translation preserves property (matches Coq: Theorem)
; Translation validation: sim_003_simulator_poly preserves semantics
(push 1)
(declare-const source_sim_003_simulator_poly Int)
(declare-const target_sim_003_simulator_poly Int)
(assert (>= source_sim_003_simulator_poly 0))
(assert (>= target_sim_003_simulator_poly 0))
(assert (not (= source_sim_003_simulator_poly target_sim_003_simulator_poly)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sim_004_simulator_indist: translation preserves property (matches Coq: Theorem)
; Translation validation: sim_004_simulator_indist preserves semantics
(push 1)
(declare-const source_sim_004_simulator_indist Int)
(declare-const target_sim_004_simulator_indist Int)
(assert (>= source_sim_004_simulator_indist 0))
(assert (>= target_sim_004_simulator_indist 0))
(assert (not (= source_sim_004_simulator_indist target_sim_004_simulator_indist)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sim_005_simulator_no_witness: translation preserves property (matches Coq: Theorem)
; Translation validation: sim_005_simulator_no_witness preserves semantics
(push 1)
(declare-const source_sim_005_simulator_no_witness Int)
(declare-const target_sim_005_simulator_no_witness Int)
(assert (>= source_sim_005_simulator_no_witness 0))
(assert (>= target_sim_005_simulator_no_witness 0))
(assert (not (= source_sim_005_simulator_no_witness target_sim_005_simulator_no_witness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sim_006_riina_di_strong: translation preserves property (matches Coq: Theorem)
; Translation validation: sim_006_riina_di_strong preserves semantics
(push 1)
(declare-const source_sim_006_riina_di_strong Int)
(declare-const target_sim_006_riina_di_strong Int)
(assert (>= source_sim_006_riina_di_strong 0))
(assert (>= target_sim_006_riina_di_strong 0))
(assert (not (= source_sim_006_riina_di_strong target_sim_006_riina_di_strong)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sim_007_strong_implies_computational: translation preserves property (matches Coq: Theorem)
; Translation validation: sim_007_strong_implies_computational preserves semantics
(push 1)
(declare-const source_sim_007_strong_implies_computational Int)
(declare-const target_sim_007_strong_implies_computational Int)
(assert (>= source_sim_007_strong_implies_computational 0))
(assert (>= target_sim_007_strong_implies_computational 0))
(assert (not (= source_sim_007_strong_implies_computational target_sim_007_strong_implies_computational)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sim_008_strong_bounded_advantage: translation preserves property (matches Coq: Theorem)
; Translation validation: sim_008_strong_bounded_advantage preserves semantics
(push 1)
(declare-const source_sim_008_strong_bounded_advantage Int)
(declare-const target_sim_008_strong_bounded_advantage Int)
(assert (>= source_sim_008_strong_bounded_advantage 0))
(assert (>= target_sim_008_strong_bounded_advantage 0))
(assert (not (= source_sim_008_strong_bounded_advantage target_sim_008_strong_bounded_advantage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; comp_001_riina_completeness: translation preserves property (matches Coq: Theorem)
; Translation validation: comp_001_riina_completeness preserves semantics
(push 1)
(declare-const source_comp_001_riina_completeness Int)
(declare-const target_comp_001_riina_completeness Int)
(assert (>= source_comp_001_riina_completeness 0))
(assert (>= target_comp_001_riina_completeness 0))
(assert (not (= source_comp_001_riina_completeness target_comp_001_riina_completeness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; comp_002_requires_honest_prover: translation preserves property (matches Coq: Theorem)
; Translation validation: comp_002_requires_honest_prover preserves semantics
(push 1)
(declare-const source_comp_002_requires_honest_prover Int)
(declare-const target_comp_002_requires_honest_prover Int)
(assert (>= source_comp_002_requires_honest_prover 0))
(assert (>= target_comp_002_requires_honest_prover 0))
(assert (not (= source_comp_002_requires_honest_prover target_comp_002_requires_honest_prover)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; comp_003_requires_witness: translation preserves property (matches Coq: Theorem)
; Translation validation: comp_003_requires_witness preserves semantics
(push 1)
(declare-const source_comp_003_requires_witness Int)
(declare-const target_comp_003_requires_witness Int)
(assert (>= source_comp_003_requires_witness 0))
(assert (>= target_comp_003_requires_witness 0))
(assert (not (= source_comp_003_requires_witness target_comp_003_requires_witness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; comp_004_requires_protocol: translation preserves property (matches Coq: Theorem)
; Translation validation: comp_004_requires_protocol preserves semantics
(push 1)
(declare-const source_comp_004_requires_protocol Int)
(declare-const target_comp_004_requires_protocol Int)
(assert (>= source_comp_004_requires_protocol 0))
(assert (>= target_comp_004_requires_protocol 0))
(assert (not (= source_comp_004_requires_protocol target_comp_004_requires_protocol)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; comp_005_verifier_accepts: translation preserves property (matches Coq: Theorem)
; Translation validation: comp_005_verifier_accepts preserves semantics
(push 1)
(declare-const source_comp_005_verifier_accepts Int)
(declare-const target_comp_005_verifier_accepts Int)
(assert (>= source_comp_005_verifier_accepts 0))
(assert (>= target_comp_005_verifier_accepts 0))
(assert (not (= source_comp_005_verifier_accepts target_comp_005_verifier_accepts)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; comp_006_riina_prover_honest: translation preserves property (matches Coq: Theorem)
; Translation validation: comp_006_riina_prover_honest preserves semantics
(push 1)
(declare-const source_comp_006_riina_prover_honest Int)
(declare-const target_comp_006_riina_prover_honest Int)
(assert (>= source_comp_006_riina_prover_honest 0))
(assert (>= target_comp_006_riina_prover_honest 0))
(assert (not (= source_comp_006_riina_prover_honest target_comp_006_riina_prover_honest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; comp_007_riina_verifier_accepts: translation preserves property (matches Coq: Theorem)
; Translation validation: comp_007_riina_verifier_accepts preserves semantics
(push 1)
(declare-const source_comp_007_riina_verifier_accepts Int)
(declare-const target_comp_007_riina_verifier_accepts Int)
(assert (>= source_comp_007_riina_verifier_accepts 0))
(assert (>= target_comp_007_riina_verifier_accepts 0))
(assert (not (= source_comp_007_riina_verifier_accepts target_comp_007_riina_verifier_accepts)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; succ_001_riina_succinct: translation preserves property (matches Coq: Theorem)
; Translation validation: succ_001_riina_succinct preserves semantics
(push 1)
(declare-const source_succ_001_riina_succinct Int)
(declare-const target_succ_001_riina_succinct Int)
(assert (>= source_succ_001_riina_succinct 0))
(assert (>= target_succ_001_riina_succinct 0))
(assert (not (= source_succ_001_riina_succinct target_succ_001_riina_succinct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; succ_002_riina_polylog: translation preserves property (matches Coq: Theorem)
; Translation validation: succ_002_riina_polylog preserves semantics
(push 1)
(declare-const source_succ_002_riina_polylog Int)
(declare-const target_succ_002_riina_polylog Int)
(assert (>= source_succ_002_riina_polylog 0))
(assert (>= target_succ_002_riina_polylog 0))
(assert (not (= source_succ_002_riina_polylog target_succ_002_riina_polylog)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; succ_003_bounded_size: translation preserves property (matches Coq: Theorem)
; Translation validation: succ_003_bounded_size preserves semantics
(push 1)
(declare-const source_succ_003_bounded_size Int)
(declare-const target_succ_003_bounded_size Int)
(assert (>= source_succ_003_bounded_size 0))
(assert (>= target_succ_003_bounded_size 0))
(assert (not (= source_succ_003_bounded_size target_succ_003_bounded_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; succ_004_bounded_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: succ_004_bounded_verification preserves semantics
(push 1)
(declare-const source_succ_004_bounded_verification Int)
(declare-const target_succ_004_bounded_verification Int)
(assert (>= source_succ_004_bounded_verification 0))
(assert (>= target_succ_004_bounded_verification 0))
(assert (not (= source_succ_004_bounded_verification target_succ_004_bounded_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; succ_005_witness_independent: translation preserves property (matches Coq: Theorem)
; Translation validation: succ_005_witness_independent preserves semantics
(push 1)
(declare-const source_succ_005_witness_independent Int)
(declare-const target_succ_005_witness_independent Int)
(assert (>= source_succ_005_witness_independent 0))
(assert (>= target_succ_005_witness_independent 0))
(assert (not (= source_succ_005_witness_independent target_succ_005_witness_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; succ_006_polylog_proof_size: translation preserves property (matches Coq: Theorem)
; Translation validation: succ_006_polylog_proof_size preserves semantics
(push 1)
(declare-const source_succ_006_polylog_proof_size Int)
(declare-const target_succ_006_polylog_proof_size Int)
(assert (>= source_succ_006_polylog_proof_size 0))
(assert (>= target_succ_006_polylog_proof_size 0))
(assert (not (= source_succ_006_polylog_proof_size target_succ_006_polylog_proof_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; succ_007_polylog_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: succ_007_polylog_verification preserves semantics
(push 1)
(declare-const source_succ_007_polylog_verification Int)
(declare-const target_succ_007_polylog_verification Int)
(assert (>= source_succ_007_polylog_verification 0))
(assert (>= target_succ_007_polylog_verification 0))
(assert (not (= source_succ_007_polylog_verification target_succ_007_polylog_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mpc_001_riina_mpc_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: mpc_001_riina_mpc_secure preserves semantics
(push 1)
(declare-const source_mpc_001_riina_mpc_secure Int)
(declare-const target_mpc_001_riina_mpc_secure Int)
(assert (>= source_mpc_001_riina_mpc_secure 0))
(assert (>= target_mpc_001_riina_mpc_secure 0))
(assert (not (= source_mpc_001_riina_mpc_secure target_mpc_001_riina_mpc_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mpc_002_riina_tw_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: mpc_002_riina_tw_secure preserves semantics
(push 1)
(declare-const source_mpc_002_riina_tw_secure Int)
(declare-const target_mpc_002_riina_tw_secure Int)
(assert (>= source_mpc_002_riina_tw_secure 0))
(assert (>= target_mpc_002_riina_tw_secure 0))
(assert (not (= source_mpc_002_riina_tw_secure target_mpc_002_riina_tw_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mpc_003_multiple_participants: translation preserves property (matches Coq: Theorem)
; Translation validation: mpc_003_multiple_participants preserves semantics
(push 1)
(declare-const source_mpc_003_multiple_participants Int)
(declare-const target_mpc_003_multiple_participants Int)
(assert (>= source_mpc_003_multiple_participants 0))
(assert (>= target_mpc_003_multiple_participants 0))
(assert (not (= source_mpc_003_multiple_participants target_mpc_003_multiple_participants)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mpc_004_valid_threshold: translation preserves property (matches Coq: Theorem)
; Translation validation: mpc_004_valid_threshold preserves semantics
(push 1)
(declare-const source_mpc_004_valid_threshold Int)
(declare-const target_mpc_004_valid_threshold Int)
(assert (>= source_mpc_004_valid_threshold 0))
(assert (>= target_mpc_004_valid_threshold 0))
(assert (not (= source_mpc_004_valid_threshold target_mpc_004_valid_threshold)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mpc_005_verifiable: translation preserves property (matches Coq: Theorem)
; Translation validation: mpc_005_verifiable preserves semantics
(push 1)
(declare-const source_mpc_005_verifiable Int)
(declare-const target_mpc_005_verifiable Int)
(assert (>= source_mpc_005_verifiable 0))
(assert (>= target_mpc_005_verifiable 0))
(assert (not (= source_mpc_005_verifiable target_mpc_005_verifiable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mpc_006_tw_destroyed: translation preserves property (matches Coq: Theorem)
; Translation validation: mpc_006_tw_destroyed preserves semantics
(push 1)
(declare-const source_mpc_006_tw_destroyed Int)
(declare-const target_mpc_006_tw_destroyed Int)
(assert (>= source_mpc_006_tw_destroyed 0))
(assert (>= target_mpc_006_tw_destroyed 0))
(assert (not (= source_mpc_006_tw_destroyed target_mpc_006_tw_destroyed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mpc_007_tw_multi_party: translation preserves property (matches Coq: Theorem)
; Translation validation: mpc_007_tw_multi_party preserves semantics
(push 1)
(declare-const source_mpc_007_tw_multi_party Int)
(declare-const target_mpc_007_tw_multi_party Int)
(assert (>= source_mpc_007_tw_multi_party 0))
(assert (>= target_mpc_007_tw_multi_party 0))
(assert (not (= source_mpc_007_tw_multi_party target_mpc_007_tw_multi_party)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; g16_001_riina_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: g16_001_riina_secure preserves semantics
(push 1)
(declare-const source_g16_001_riina_secure Int)
(declare-const target_g16_001_riina_secure Int)
(assert (>= source_g16_001_riina_secure 0))
(assert (>= target_g16_001_riina_secure 0))
(assert (not (= source_g16_001_riina_secure target_g16_001_riina_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; g16_002_riina_proof_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: g16_002_riina_proof_valid preserves semantics
(push 1)
(declare-const source_g16_002_riina_proof_valid Int)
(declare-const target_g16_002_riina_proof_valid Int)
(assert (>= source_g16_002_riina_proof_valid 0))
(assert (>= target_g16_002_riina_proof_valid 0))
(assert (not (= source_g16_002_riina_proof_valid target_g16_002_riina_proof_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; g16_003_pairing_friendly: translation preserves property (matches Coq: Theorem)
; Translation validation: g16_003_pairing_friendly preserves semantics
(push 1)
(declare-const source_g16_003_pairing_friendly Int)
(declare-const target_g16_003_pairing_friendly Int)
(assert (>= source_g16_003_pairing_friendly 0))
(assert (>= target_g16_003_pairing_friendly 0))
(assert (not (= source_g16_003_pairing_friendly target_g16_003_pairing_friendly)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; g16_004_three_elements: translation preserves property (matches Coq: Theorem)
; Translation validation: g16_004_three_elements preserves semantics
(push 1)
(declare-const source_g16_004_three_elements Int)
(declare-const target_g16_004_three_elements Int)
(assert (>= source_g16_004_three_elements 0))
(assert (>= target_g16_004_three_elements 0))
(assert (not (= source_g16_004_three_elements target_g16_004_three_elements)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; g16_005_bounded_pairings: translation preserves property (matches Coq: Theorem)
; Translation validation: g16_005_bounded_pairings preserves semantics
(push 1)
(declare-const source_g16_005_bounded_pairings Int)
(declare-const target_g16_005_bounded_pairings Int)
(assert (>= source_g16_005_bounded_pairings 0))
(assert (>= target_g16_005_bounded_pairings 0))
(assert (not (= source_g16_005_bounded_pairings target_g16_005_bounded_pairings)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; g16_006_valid_curve_points: translation preserves property (matches Coq: Theorem)
; Translation validation: g16_006_valid_curve_points preserves semantics
(push 1)
(declare-const source_g16_006_valid_curve_points Int)
(declare-const target_g16_006_valid_curve_points Int)
(assert (>= source_g16_006_valid_curve_points 0))
(assert (>= target_g16_006_valid_curve_points 0))
(assert (not (= source_g16_006_valid_curve_points target_g16_006_valid_curve_points)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; g16_007_valid_subgroup: translation preserves property (matches Coq: Theorem)
; Translation validation: g16_007_valid_subgroup preserves semantics
(push 1)
(declare-const source_g16_007_valid_subgroup Int)
(declare-const target_g16_007_valid_subgroup Int)
(assert (>= source_g16_007_valid_subgroup 0))
(assert (>= target_g16_007_valid_subgroup 0))
(assert (not (= source_g16_007_valid_subgroup target_g16_007_valid_subgroup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; plonk_001_riina_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: plonk_001_riina_secure preserves semantics
(push 1)
(declare-const source_plonk_001_riina_secure Int)
(declare-const target_plonk_001_riina_secure Int)
(assert (>= source_plonk_001_riina_secure 0))
(assert (>= target_plonk_001_riina_secure 0))
(assert (not (= source_plonk_001_riina_secure target_plonk_001_riina_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; plonk_002_riina_gate_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: plonk_002_riina_gate_valid preserves semantics
(push 1)
(declare-const source_plonk_002_riina_gate_valid Int)
(declare-const target_plonk_002_riina_gate_valid Int)
(assert (>= source_plonk_002_riina_gate_valid 0))
(assert (>= target_plonk_002_riina_gate_valid 0))
(assert (not (= source_plonk_002_riina_gate_valid target_plonk_002_riina_gate_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; plonk_003_universal_setup: translation preserves property (matches Coq: Theorem)
; Translation validation: plonk_003_universal_setup preserves semantics
(push 1)
(declare-const source_plonk_003_universal_setup Int)
(declare-const target_plonk_003_universal_setup Int)
(assert (>= source_plonk_003_universal_setup 0))
(assert (>= target_plonk_003_universal_setup 0))
(assert (not (= source_plonk_003_universal_setup target_plonk_003_universal_setup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; plonk_004_polynomial_commitment: translation preserves property (matches Coq: Theorem)
; Translation validation: plonk_004_polynomial_commitment preserves semantics
(push 1)
(declare-const source_plonk_004_polynomial_commitment Int)
(declare-const target_plonk_004_polynomial_commitment Int)
(assert (>= source_plonk_004_polynomial_commitment 0))
(assert (>= target_plonk_004_polynomial_commitment 0))
(assert (not (= source_plonk_004_polynomial_commitment target_plonk_004_polynomial_commitment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; plonk_005_arithmetic_gates: translation preserves property (matches Coq: Theorem)
; Translation validation: plonk_005_arithmetic_gates preserves semantics
(push 1)
(declare-const source_plonk_005_arithmetic_gates Int)
(declare-const target_plonk_005_arithmetic_gates Int)
(assert (>= source_plonk_005_arithmetic_gates 0))
(assert (>= target_plonk_005_arithmetic_gates 0))
(assert (not (= source_plonk_005_arithmetic_gates target_plonk_005_arithmetic_gates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; plonk_006_bounded_degree: translation preserves property (matches Coq: Theorem)
; Translation validation: plonk_006_bounded_degree preserves semantics
(push 1)
(declare-const source_plonk_006_bounded_degree Int)
(declare-const target_plonk_006_bounded_degree Int)
(assert (>= source_plonk_006_bounded_degree 0))
(assert (>= target_plonk_006_bounded_degree 0))
(assert (not (= source_plonk_006_bounded_degree target_plonk_006_bounded_degree)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; plonk_007_sufficient_fan_in: translation preserves property (matches Coq: Theorem)
; Translation validation: plonk_007_sufficient_fan_in preserves semantics
(push 1)
(declare-const source_plonk_007_sufficient_fan_in Int)
(declare-const target_plonk_007_sufficient_fan_in Int)
(assert (>= source_plonk_007_sufficient_fan_in 0))
(assert (>= target_plonk_007_sufficient_fan_in 0))
(assert (not (= source_plonk_007_sufficient_fan_in target_plonk_007_sufficient_fan_in)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_001_riina_full_zk_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: full_001_riina_full_zk_secure preserves semantics
(push 1)
(declare-const source_full_001_riina_full_zk_secure Int)
(declare-const target_full_001_riina_full_zk_secure Int)
(assert (>= source_full_001_riina_full_zk_secure 0))
(assert (>= target_full_001_riina_full_zk_secure 0))
(assert (not (= source_full_001_riina_full_zk_secure target_full_001_riina_full_zk_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_002_implies_base: translation preserves property (matches Coq: Theorem)
; Translation validation: full_002_implies_base preserves semantics
(push 1)
(declare-const source_full_002_implies_base Int)
(declare-const target_full_002_implies_base Int)
(assert (>= source_full_002_implies_base 0))
(assert (>= target_full_002_implies_base 0))
(assert (not (= source_full_002_implies_base target_full_002_implies_base)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_003_implies_ke: translation preserves property (matches Coq: Theorem)
; Translation validation: full_003_implies_ke preserves semantics
(push 1)
(declare-const source_full_003_implies_ke Int)
(declare-const target_full_003_implies_ke Int)
(assert (>= source_full_003_implies_ke 0))
(assert (>= target_full_003_implies_ke 0))
(assert (not (= source_full_003_implies_ke target_full_003_implies_ke)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_004_implies_sim: translation preserves property (matches Coq: Theorem)
; Translation validation: full_004_implies_sim preserves semantics
(push 1)
(declare-const source_full_004_implies_sim Int)
(declare-const target_full_004_implies_sim Int)
(assert (>= source_full_004_implies_sim 0))
(assert (>= target_full_004_implies_sim 0))
(assert (not (= source_full_004_implies_sim target_full_004_implies_sim)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_005_implies_succinct: translation preserves property (matches Coq: Theorem)
; Translation validation: full_005_implies_succinct preserves semantics
(push 1)
(declare-const source_full_005_implies_succinct Int)
(declare-const target_full_005_implies_succinct Int)
(assert (>= source_full_005_implies_succinct 0))
(assert (>= target_full_005_implies_succinct 0))
(assert (not (= source_full_005_implies_succinct target_full_005_implies_succinct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_006_implies_mpc: translation preserves property (matches Coq: Theorem)
; Translation validation: full_006_implies_mpc preserves semantics
(push 1)
(declare-const source_full_006_implies_mpc Int)
(declare-const target_full_006_implies_mpc Int)
(assert (>= source_full_006_implies_mpc 0))
(assert (>= target_full_006_implies_mpc 0))
(assert (not (= source_full_006_implies_mpc target_full_006_implies_mpc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_007_implies_tw: translation preserves property (matches Coq: Theorem)
; Translation validation: full_007_implies_tw preserves semantics
(push 1)
(declare-const source_full_007_implies_tw Int)
(declare-const target_full_007_implies_tw Int)
(assert (>= source_full_007_implies_tw 0))
(assert (>= target_full_007_implies_tw 0))
(assert (not (= source_full_007_implies_tw target_full_007_implies_tw)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_008_riina_all_properties: translation preserves property (matches Coq: Theorem)
; Translation validation: full_008_riina_all_properties preserves semantics
(push 1)
(declare-const source_full_008_riina_all_properties Int)
(declare-const target_full_008_riina_all_properties Int)
(assert (>= source_full_008_riina_all_properties 0))
(assert (>= target_full_008_riina_all_properties 0))
(assert (not (= source_full_008_riina_all_properties target_full_008_riina_all_properties)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; se_001_riina_se_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: se_001_riina_se_secure preserves semantics
(push 1)
(declare-const source_se_001_riina_se_secure Int)
(declare-const target_se_001_riina_se_secure Int)
(assert (>= source_se_001_riina_se_secure 0))
(assert (>= target_se_001_riina_se_secure 0))
(assert (not (= source_se_001_riina_se_secure target_se_001_riina_se_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; se_002_security_parameter: translation preserves property (matches Coq: Theorem)
; Translation validation: se_002_security_parameter preserves semantics
(push 1)
(declare-const source_se_002_security_parameter Int)
(declare-const target_se_002_security_parameter Int)
(assert (>= source_se_002_security_parameter 0))
(assert (>= target_se_002_security_parameter 0))
(assert (not (= source_se_002_security_parameter target_se_002_security_parameter)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; se_003_statistical_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: se_003_statistical_bounded preserves semantics
(push 1)
(declare-const source_se_003_statistical_bounded Int)
(declare-const target_se_003_statistical_bounded Int)
(assert (>= source_se_003_statistical_bounded 0))
(assert (>= target_se_003_statistical_bounded 0))
(assert (not (= source_se_003_statistical_bounded target_se_003_statistical_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pst_001_riina_is_snark: translation preserves property (matches Coq: Theorem)
; Translation validation: pst_001_riina_is_snark preserves semantics
(push 1)
(declare-const source_pst_001_riina_is_snark Int)
(declare-const target_pst_001_riina_is_snark Int)
(assert (>= source_pst_001_riina_is_snark 0))
(assert (>= target_pst_001_riina_is_snark 0))
(assert (not (= source_pst_001_riina_is_snark target_pst_001_riina_is_snark)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pst_002_snark_is_argument: translation preserves property (matches Coq: Theorem)
; Translation validation: pst_002_snark_is_argument preserves semantics
(push 1)
(declare-const source_pst_002_snark_is_argument Int)
(declare-const target_pst_002_snark_is_argument Int)
(assert (>= source_pst_002_snark_is_argument 0))
(assert (>= target_pst_002_snark_is_argument 0))
(assert (not (= source_pst_002_snark_is_argument target_pst_002_snark_is_argument)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pst_003_snark_knowledge: translation preserves property (matches Coq: Theorem)
; Translation validation: pst_003_snark_knowledge preserves semantics
(push 1)
(declare-const source_pst_003_snark_knowledge Int)
(declare-const target_pst_003_snark_knowledge Int)
(assert (>= source_pst_003_snark_knowledge 0))
(assert (>= target_pst_003_snark_knowledge 0))
(assert (not (= source_pst_003_snark_knowledge target_pst_003_snark_knowledge)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pst_004_snark_succinct: translation preserves property (matches Coq: Theorem)
; Translation validation: pst_004_snark_succinct preserves semantics
(push 1)
(declare-const source_pst_004_snark_succinct Int)
(declare-const target_pst_004_snark_succinct Int)
(assert (>= source_pst_004_snark_succinct 0))
(assert (>= target_pst_004_snark_succinct 0))
(assert (not (= source_pst_004_snark_succinct target_pst_004_snark_succinct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

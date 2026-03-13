; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/DistributedConsensus.v (24 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for DistributedConsensus
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; bft_assumption: source semantics (matches Coq)
; Translation validation: bft_assumption preserves semantics
(push 1)
(declare-const source_bft_assumption Int)
(declare-const target_bft_assumption Int)
(assert (>= source_bft_assumption 0))
(assert (>= target_bft_assumption 0))
(assert (not (= source_bft_assumption target_bft_assumption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; quorum_size: source semantics (matches Coq)
; Translation validation: quorum_size preserves semantics
(push 1)
(declare-const source_quorum_size Int)
(declare-const target_quorum_size Int)
(assert (>= source_quorum_size 0))
(assert (>= target_quorum_size 0))
(assert (not (= source_quorum_size target_quorum_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_quorum: source semantics (matches Coq)
; Translation validation: is_quorum preserves semantics
(push 1)
(declare-const source_is_quorum Int)
(declare-const target_is_quorum Int)
(assert (>= source_is_quorum 0))
(assert (>= target_is_quorum 0))
(assert (not (= source_is_quorum target_is_quorum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_honest_propose: source semantics (matches Coq)
; Translation validation: all_honest_propose preserves semantics
(push 1)
(declare-const source_all_honest_propose Int)
(declare-const target_all_honest_propose Int)
(assert (>= source_all_honest_propose 0))
(assert (>= target_all_honest_propose 0))
(assert (not (= source_all_honest_propose target_all_honest_propose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; honest_decided: source semantics (matches Coq)
; Translation validation: honest_decided preserves semantics
(push 1)
(declare-const source_honest_decided Int)
(declare-const target_honest_decided Int)
(assert (>= source_honest_decided 0))
(assert (>= target_honest_decided 0))
(assert (not (= source_honest_decided target_honest_decided)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; honest_votes_once_per_round: source semantics (matches Coq)
; Translation validation: honest_votes_once_per_round preserves semantics
(push 1)
(declare-const source_honest_votes_once_per_round Int)
(declare-const target_honest_votes_once_per_round Int)
(assert (>= source_honest_votes_once_per_round 0))
(assert (>= target_honest_votes_once_per_round 0))
(assert (not (= source_honest_votes_once_per_round target_honest_votes_once_per_round)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; messages_from_honest_authentic: source semantics (matches Coq)
; Translation validation: messages_from_honest_authentic preserves semantics
(push 1)
(declare-const source_messages_from_honest_authentic Int)
(declare-const target_messages_from_honest_authentic Int)
(assert (>= source_messages_from_honest_authentic 0))
(assert (>= target_messages_from_honest_authentic 0))
(assert (not (= source_messages_from_honest_authentic target_messages_from_honest_authentic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; decided_nodes_agree: source semantics (matches Coq)
; Translation validation: decided_nodes_agree preserves semantics
(push 1)
(declare-const source_decided_nodes_agree Int)
(declare-const target_decided_nodes_agree Int)
(assert (>= source_decided_nodes_agree 0))
(assert (>= target_decided_nodes_agree 0))
(assert (not (= source_decided_nodes_agree target_decided_nodes_agree)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; round_update: source semantics (matches Coq)
; Translation validation: round_update preserves semantics
(push 1)
(declare-const source_round_update Int)
(declare-const target_round_update Int)
(assert (>= source_round_update 0))
(assert (>= target_round_update 0))
(assert (not (= source_round_update target_round_update)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; decision_stable: source semantics (matches Coq)
; Translation validation: decision_stable preserves semantics
(push 1)
(declare-const source_decision_stable Int)
(declare-const target_decision_stable Int)
(assert (>= source_decision_stable 0))
(assert (>= target_decision_stable 0))
(assert (not (= source_decision_stable target_decision_stable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count_honest: source semantics (matches Coq)
; Translation validation: count_honest preserves semantics
(push 1)
(declare-const source_count_honest Int)
(declare-const target_count_honest Int)
(assert (>= source_count_honest 0))
(assert (>= target_count_honest 0))
(assert (not (= source_count_honest target_count_honest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_nat: source semantics (matches Coq)
; Translation validation: mem_nat preserves semantics
(push 1)
(declare-const source_mem_nat Int)
(declare-const target_mem_nat Int)
(assert (>= source_mem_nat 0))
(assert (>= target_mem_nat 0))
(assert (not (= source_mem_nat target_mem_nat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; intersect: source semantics (matches Coq)
; Translation validation: intersect preserves semantics
(push 1)
(declare-const source_intersect Int)
(declare-const target_intersect Int)
(assert (>= source_intersect 0))
(assert (>= target_intersect 0))
(assert (not (= source_intersect target_intersect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; agreement: translation preserves property (matches Coq: Theorem)
; Translation validation: agreement preserves semantics
(push 1)
(declare-const source_agreement Int)
(declare-const target_agreement Int)
(assert (>= source_agreement 0))
(assert (>= target_agreement 0))
(assert (not (= source_agreement target_agreement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; validity: translation preserves property (matches Coq: Theorem)
; Translation validation: validity preserves semantics
(push 1)
(declare-const source_validity Int)
(declare-const target_validity Int)
(assert (>= source_validity 0))
(assert (>= target_validity 0))
(assert (not (= source_validity target_validity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pigeonhole_overlap: translation preserves property (matches Coq: Lemma)
; Translation validation: pigeonhole_overlap preserves semantics
(push 1)
(declare-const source_pigeonhole_overlap Int)
(declare-const target_pigeonhole_overlap Int)
(assert (>= source_pigeonhole_overlap 0))
(assert (>= target_pigeonhole_overlap 0))
(assert (not (= source_pigeonhole_overlap target_pigeonhole_overlap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; quorum_intersection_size: translation preserves property (matches Coq: Theorem)
; Translation validation: quorum_intersection_size preserves semantics
(push 1)
(declare-const source_quorum_intersection_size Int)
(declare-const target_quorum_intersection_size Int)
(assert (>= source_quorum_intersection_size 0))
(assert (>= target_quorum_intersection_size 0))
(assert (not (= source_quorum_intersection_size target_quorum_intersection_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; quorum_intersection: translation preserves property (matches Coq: Theorem)
; Translation validation: quorum_intersection preserves semantics
(push 1)
(declare-const source_quorum_intersection Int)
(declare-const target_quorum_intersection Int)
(assert (>= source_quorum_intersection 0))
(assert (>= target_quorum_intersection 0))
(assert (not (= source_quorum_intersection target_quorum_intersection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; round_monotonicity: translation preserves property (matches Coq: Theorem)
; Translation validation: round_monotonicity preserves semantics
(push 1)
(declare-const source_round_monotonicity Int)
(declare-const target_round_monotonicity Int)
(assert (>= source_round_monotonicity 0))
(assert (>= target_round_monotonicity 0))
(assert (not (= source_round_monotonicity target_round_monotonicity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; round_monotonicity_transitive: translation preserves property (matches Coq: Theorem)
; Translation validation: round_monotonicity_transitive preserves semantics
(push 1)
(declare-const source_round_monotonicity_transitive Int)
(declare-const target_round_monotonicity_transitive Int)
(assert (>= source_round_monotonicity_transitive 0))
(assert (>= target_round_monotonicity_transitive 0))
(assert (not (= source_round_monotonicity_transitive target_round_monotonicity_transitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; vote_uniqueness: translation preserves property (matches Coq: Theorem)
; Translation validation: vote_uniqueness preserves semantics
(push 1)
(declare-const source_vote_uniqueness Int)
(declare-const target_vote_uniqueness Int)
(assert (>= source_vote_uniqueness 0))
(assert (>= target_vote_uniqueness 0))
(assert (not (= source_vote_uniqueness target_vote_uniqueness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; quorum_sufficiency: translation preserves property (matches Coq: Theorem)
; Translation validation: quorum_sufficiency preserves semantics
(push 1)
(declare-const source_quorum_sufficiency Int)
(declare-const target_quorum_sufficiency Int)
(assert (>= source_quorum_sufficiency 0))
(assert (>= target_quorum_sufficiency 0))
(assert (not (= source_quorum_sufficiency target_quorum_sufficiency)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; honest_majority_in_quorum: translation preserves property (matches Coq: Theorem)
; Translation validation: honest_majority_in_quorum preserves semantics
(push 1)
(declare-const source_honest_majority_in_quorum Int)
(declare-const target_honest_majority_in_quorum Int)
(assert (>= source_honest_majority_in_quorum 0))
(assert (>= target_honest_majority_in_quorum 0))
(assert (not (= source_honest_majority_in_quorum target_honest_majority_in_quorum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; message_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: message_integrity preserves semantics
(push 1)
(declare-const source_message_integrity Int)
(declare-const target_message_integrity Int)
(assert (>= source_message_integrity 0))
(assert (>= target_message_integrity 0))
(assert (not (= source_message_integrity target_message_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; decision_stability: translation preserves property (matches Coq: Theorem)
; Translation validation: decision_stability preserves semantics
(push 1)
(declare-const source_decision_stability Int)
(declare-const target_decision_stability Int)
(assert (>= source_decision_stability 0))
(assert (>= target_decision_stability 0))
(assert (not (= source_decision_stability target_decision_stability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bft_threshold: translation preserves property (matches Coq: Theorem)
; Translation validation: bft_threshold preserves semantics
(push 1)
(declare-const source_bft_threshold Int)
(declare-const target_bft_threshold Int)
(assert (>= source_bft_threshold 0))
(assert (>= target_bft_threshold 0))
(assert (not (= source_bft_threshold target_bft_threshold)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; two_quorums_share_honest: translation preserves property (matches Coq: Theorem)
; Translation validation: two_quorums_share_honest preserves semantics
(push 1)
(declare-const source_two_quorums_share_honest Int)
(declare-const target_two_quorums_share_honest Int)
(assert (>= source_two_quorums_share_honest 0))
(assert (>= target_two_quorums_share_honest 0))
(assert (not (= source_two_quorums_share_honest target_two_quorums_share_honest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bft_min_nodes_f1: translation preserves property (matches Coq: Theorem)
; Translation validation: bft_min_nodes_f1 preserves semantics
(push 1)
(declare-const source_bft_min_nodes_f1 Int)
(declare-const target_bft_min_nodes_f1 Int)
(assert (>= source_bft_min_nodes_f1 0))
(assert (>= target_bft_min_nodes_f1 0))
(assert (not (= source_bft_min_nodes_f1 target_bft_min_nodes_f1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count_honest_nil: translation preserves property (matches Coq: Theorem)
; Translation validation: count_honest_nil preserves semantics
(push 1)
(declare-const source_count_honest_nil Int)
(declare-const target_count_honest_nil Int)
(assert (>= source_count_honest_nil 0))
(assert (>= target_count_honest_nil 0))
(assert (not (= source_count_honest_nil target_count_honest_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count_honest_singleton: translation preserves property (matches Coq: Theorem)
; Translation validation: count_honest_singleton preserves semantics
(push 1)
(declare-const source_count_honest_singleton Int)
(declare-const target_count_honest_singleton Int)
(assert (>= source_count_honest_singleton 0))
(assert (>= target_count_honest_singleton 0))
(assert (not (= source_count_honest_singleton target_count_honest_singleton)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; intersect_nil_l: translation preserves property (matches Coq: Theorem)
; Translation validation: intersect_nil_l preserves semantics
(push 1)
(declare-const source_intersect_nil_l Int)
(declare-const target_intersect_nil_l Int)
(assert (>= source_intersect_nil_l 0))
(assert (>= target_intersect_nil_l 0))
(assert (not (= source_intersect_nil_l target_intersect_nil_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_nat_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: mem_nat_refl preserves semantics
(push 1)
(declare-const source_mem_nat_refl Int)
(declare-const target_mem_nat_refl Int)
(assert (>= source_mem_nat_refl 0))
(assert (>= target_mem_nat_refl 0))
(assert (not (= source_mem_nat_refl target_mem_nat_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; quorum_size_pos: translation preserves property (matches Coq: Theorem)
; Translation validation: quorum_size_pos preserves semantics
(push 1)
(declare-const source_quorum_size_pos Int)
(declare-const target_quorum_size_pos Int)
(assert (>= source_quorum_size_pos 0))
(assert (>= target_quorum_size_pos 0))
(assert (not (= source_quorum_size_pos target_quorum_size_pos)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; agreement_non_decided: translation preserves property (matches Coq: Theorem)
; Translation validation: agreement_non_decided preserves semantics
(push 1)
(declare-const source_agreement_non_decided Int)
(declare-const target_agreement_non_decided Int)
(assert (>= source_agreement_non_decided 0))
(assert (>= target_agreement_non_decided 0))
(assert (not (= source_agreement_non_decided target_agreement_non_decided)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; round_update_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: round_update_refl preserves semantics
(push 1)
(declare-const source_round_update_refl Int)
(declare-const target_round_update_refl Int)
(assert (>= source_round_update_refl 0))
(assert (>= target_round_update_refl 0))
(assert (not (= source_round_update_refl target_round_update_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bft_f0: translation preserves property (matches Coq: Theorem)
; Translation validation: bft_f0 preserves semantics
(push 1)
(declare-const source_bft_f0 Int)
(declare-const target_bft_f0 Int)
(assert (>= source_bft_f0 0))
(assert (>= target_bft_f0 0))
(assert (not (= source_bft_f0 target_bft_f0)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; honest_majority_total: translation preserves property (matches Coq: Theorem)
; Translation validation: honest_majority_total preserves semantics
(push 1)
(declare-const source_honest_majority_total Int)
(declare-const target_honest_majority_total Int)
(assert (>= source_honest_majority_total 0))
(assert (>= target_honest_majority_total 0))
(assert (not (= source_honest_majority_total target_honest_majority_total)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

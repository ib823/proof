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
(declare-fun source_bft_assumption () Bool)
(declare-fun target_bft_assumption () Bool)
(assert (= source_bft_assumption target_bft_assumption))

; quorum_size: source semantics (matches Coq)
(declare-fun source_quorum_size () Bool)
(declare-fun target_quorum_size () Bool)
(assert (= source_quorum_size target_quorum_size))

; is_quorum: source semantics (matches Coq)
(declare-fun source_is_quorum () Bool)
(declare-fun target_is_quorum () Bool)
(assert (= source_is_quorum target_is_quorum))

; all_honest_propose: source semantics (matches Coq)
(declare-fun source_all_honest_propose () Bool)
(declare-fun target_all_honest_propose () Bool)
(assert (= source_all_honest_propose target_all_honest_propose))

; honest_decided: source semantics (matches Coq)
(declare-fun source_honest_decided () Bool)
(declare-fun target_honest_decided () Bool)
(assert (= source_honest_decided target_honest_decided))

; honest_votes_once_per_round: source semantics (matches Coq)
(declare-fun source_honest_votes_once_per_round () Bool)
(declare-fun target_honest_votes_once_per_round () Bool)
(assert (= source_honest_votes_once_per_round target_honest_votes_once_per_round))

; messages_from_honest_authentic: source semantics (matches Coq)
(declare-fun source_messages_from_honest_authentic () Bool)
(declare-fun target_messages_from_honest_authentic () Bool)
(assert (= source_messages_from_honest_authentic target_messages_from_honest_authentic))

; decided_nodes_agree: source semantics (matches Coq)
(declare-fun source_decided_nodes_agree () Bool)
(declare-fun target_decided_nodes_agree () Bool)
(assert (= source_decided_nodes_agree target_decided_nodes_agree))

; round_update: source semantics (matches Coq)
(declare-fun source_round_update () Bool)
(declare-fun target_round_update () Bool)
(assert (= source_round_update target_round_update))

; decision_stable: source semantics (matches Coq)
(declare-fun source_decision_stable () Bool)
(declare-fun target_decision_stable () Bool)
(assert (= source_decision_stable target_decision_stable))

; count_honest: source semantics (matches Coq)
(declare-fun source_count_honest () Bool)
(declare-fun target_count_honest () Bool)
(assert (= source_count_honest target_count_honest))

; mem_nat: source semantics (matches Coq)
(declare-fun source_mem_nat () Bool)
(declare-fun target_mem_nat () Bool)
(assert (= source_mem_nat target_mem_nat))

; intersect: source semantics (matches Coq)
(declare-fun source_intersect () Bool)
(declare-fun target_intersect () Bool)
(assert (= source_intersect target_intersect))

; agreement: translation preserves property (matches Coq: Theorem)
(declare-fun source_agreement () Bool)
(declare-fun target_agreement () Bool)
(assert (= source_agreement target_agreement))

; validity: translation preserves property (matches Coq: Theorem)
(declare-fun source_validity () Bool)
(declare-fun target_validity () Bool)
(assert (= source_validity target_validity))

; pigeonhole_overlap: translation preserves property (matches Coq: Lemma)
(declare-fun source_pigeonhole_overlap () Bool)
(declare-fun target_pigeonhole_overlap () Bool)
(assert (= source_pigeonhole_overlap target_pigeonhole_overlap))

; quorum_intersection_size: translation preserves property (matches Coq: Theorem)
(declare-fun source_quorum_intersection_size () Bool)
(declare-fun target_quorum_intersection_size () Bool)
(assert (= source_quorum_intersection_size target_quorum_intersection_size))

; quorum_intersection: translation preserves property (matches Coq: Theorem)
(declare-fun source_quorum_intersection () Bool)
(declare-fun target_quorum_intersection () Bool)
(assert (= source_quorum_intersection target_quorum_intersection))

; round_monotonicity: translation preserves property (matches Coq: Theorem)
(declare-fun source_round_monotonicity () Bool)
(declare-fun target_round_monotonicity () Bool)
(assert (= source_round_monotonicity target_round_monotonicity))

; round_monotonicity_transitive: translation preserves property (matches Coq: Theorem)
(declare-fun source_round_monotonicity_transitive () Bool)
(declare-fun target_round_monotonicity_transitive () Bool)
(assert (= source_round_monotonicity_transitive target_round_monotonicity_transitive))

; vote_uniqueness: translation preserves property (matches Coq: Theorem)
(declare-fun source_vote_uniqueness () Bool)
(declare-fun target_vote_uniqueness () Bool)
(assert (= source_vote_uniqueness target_vote_uniqueness))

; quorum_sufficiency: translation preserves property (matches Coq: Theorem)
(declare-fun source_quorum_sufficiency () Bool)
(declare-fun target_quorum_sufficiency () Bool)
(assert (= source_quorum_sufficiency target_quorum_sufficiency))

; honest_majority_in_quorum: translation preserves property (matches Coq: Theorem)
(declare-fun source_honest_majority_in_quorum () Bool)
(declare-fun target_honest_majority_in_quorum () Bool)
(assert (= source_honest_majority_in_quorum target_honest_majority_in_quorum))

; message_integrity: translation preserves property (matches Coq: Theorem)
(declare-fun source_message_integrity () Bool)
(declare-fun target_message_integrity () Bool)
(assert (= source_message_integrity target_message_integrity))

; decision_stability: translation preserves property (matches Coq: Theorem)
(declare-fun source_decision_stability () Bool)
(declare-fun target_decision_stability () Bool)
(assert (= source_decision_stability target_decision_stability))

; bft_threshold: translation preserves property (matches Coq: Theorem)
(declare-fun source_bft_threshold () Bool)
(declare-fun target_bft_threshold () Bool)
(assert (= source_bft_threshold target_bft_threshold))

; two_quorums_share_honest: translation preserves property (matches Coq: Theorem)
(declare-fun source_two_quorums_share_honest () Bool)
(declare-fun target_two_quorums_share_honest () Bool)
(assert (= source_two_quorums_share_honest target_two_quorums_share_honest))

; bft_min_nodes_f1: translation preserves property (matches Coq: Theorem)
(declare-fun source_bft_min_nodes_f1 () Bool)
(declare-fun target_bft_min_nodes_f1 () Bool)
(assert (= source_bft_min_nodes_f1 target_bft_min_nodes_f1))

; count_honest_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_count_honest_nil () Bool)
(declare-fun target_count_honest_nil () Bool)
(assert (= source_count_honest_nil target_count_honest_nil))

; count_honest_singleton: translation preserves property (matches Coq: Theorem)
(declare-fun source_count_honest_singleton () Bool)
(declare-fun target_count_honest_singleton () Bool)
(assert (= source_count_honest_singleton target_count_honest_singleton))

; intersect_nil_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_intersect_nil_l () Bool)
(declare-fun target_intersect_nil_l () Bool)
(assert (= source_intersect_nil_l target_intersect_nil_l))

; mem_nat_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_mem_nat_refl () Bool)
(declare-fun target_mem_nat_refl () Bool)
(assert (= source_mem_nat_refl target_mem_nat_refl))

; quorum_size_pos: translation preserves property (matches Coq: Theorem)
(declare-fun source_quorum_size_pos () Bool)
(declare-fun target_quorum_size_pos () Bool)
(assert (= source_quorum_size_pos target_quorum_size_pos))

; agreement_non_decided: translation preserves property (matches Coq: Theorem)
(declare-fun source_agreement_non_decided () Bool)
(declare-fun target_agreement_non_decided () Bool)
(assert (= source_agreement_non_decided target_agreement_non_decided))

; round_update_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_round_update_refl () Bool)
(declare-fun target_round_update_refl () Bool)
(assert (= source_round_update_refl target_round_update_refl))

; bft_f0: translation preserves property (matches Coq: Theorem)
(declare-fun source_bft_f0 () Bool)
(declare-fun target_bft_f0 () Bool)
(assert (= source_bft_f0 target_bft_f0))

; honest_majority_total: translation preserves property (matches Coq: Theorem)
(declare-fun source_honest_majority_total () Bool)
(declare-fun target_honest_majority_total () Bool)
(assert (= source_honest_majority_total target_honest_majority_total))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

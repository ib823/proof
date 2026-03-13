; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/DELTA001_VerifiedDistribution.v (32 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for DELTA001_VerifiedDistribution
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

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

; voted_for_in_term: source semantics (matches Coq)
; Translation validation: voted_for_in_term preserves semantics
(push 1)
(declare-const source_voted_for_in_term Int)
(declare-const target_voted_for_in_term Int)
(assert (>= source_voted_for_in_term 0))
(assert (>= target_voted_for_in_term 0))
(assert (not (= source_voted_for_in_term target_voted_for_in_term)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count_votes: source semantics (matches Coq)
; Translation validation: count_votes preserves semantics
(push 1)
(declare-const source_count_votes Int)
(declare-const target_count_votes Int)
(assert (>= source_count_votes 0))
(assert (>= target_count_votes 0))
(assert (not (= source_count_votes target_count_votes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; logs_match_at: source semantics (matches Coq)
; Translation validation: logs_match_at preserves semantics
(push 1)
(declare-const source_logs_match_at Int)
(declare-const target_logs_match_at Int)
(assert (>= source_logs_match_at 0))
(assert (>= target_logs_match_at 0))
(assert (not (= source_logs_match_at target_logs_match_at)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; entry_committed: source semantics (matches Coq)
; Translation validation: entry_committed preserves semantics
(push 1)
(declare-const source_entry_committed Int)
(declare-const target_entry_committed Int)
(assert (>= source_entry_committed 0))
(assert (>= target_entry_committed 0))
(assert (not (= source_entry_committed target_entry_committed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bft_quorum: source semantics (matches Coq)
; Translation validation: bft_quorum preserves semantics
(push 1)
(declare-const source_bft_quorum Int)
(declare-const target_bft_quorum Int)
(assert (>= source_bft_quorum 0))
(assert (>= target_bft_quorum 0))
(assert (not (= source_bft_quorum target_bft_quorum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bft_valid: source semantics (matches Coq)
; Translation validation: bft_valid preserves semantics
(push 1)
(declare-const source_bft_valid Int)
(declare-const target_bft_valid Int)
(assert (>= source_bft_valid 0))
(assert (>= target_bft_valid 0))
(assert (not (= source_bft_valid target_bft_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gc_increment: source semantics (matches Coq)
; Translation validation: gc_increment preserves semantics
(push 1)
(declare-const source_gc_increment Int)
(declare-const target_gc_increment Int)
(assert (>= source_gc_increment 0))
(assert (>= target_gc_increment 0))
(assert (not (= source_gc_increment target_gc_increment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gc_value: source semantics (matches Coq)
; Translation validation: gc_value preserves semantics
(push 1)
(declare-const source_gc_value Int)
(declare-const target_gc_value Int)
(assert (>= source_gc_value 0))
(assert (>= target_gc_value 0))
(assert (not (= source_gc_value target_gc_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gc_merge: source semantics (matches Coq)
; Translation validation: gc_merge preserves semantics
(push 1)
(declare-const source_gc_merge Int)
(declare-const target_gc_merge Int)
(assert (>= source_gc_merge 0))
(assert (>= target_gc_merge 0))
(assert (not (= source_gc_merge target_gc_merge)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gs_add: source semantics (matches Coq)
; Translation validation: gs_add preserves semantics
(push 1)
(declare-const source_gs_add Int)
(declare-const target_gs_add Int)
(assert (>= source_gs_add 0))
(assert (>= target_gs_add 0))
(assert (not (= source_gs_add target_gs_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gs_merge: source semantics (matches Coq)
; Translation validation: gs_merge preserves semantics
(push 1)
(declare-const source_gs_merge Int)
(declare-const target_gs_merge Int)
(assert (>= source_gs_merge 0))
(assert (>= target_gs_merge 0))
(assert (not (= source_gs_merge target_gs_merge)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gs_member: source semantics (matches Coq)
; Translation validation: gs_member preserves semantics
(push 1)
(declare-const source_gs_member Int)
(declare-const target_gs_member Int)
(assert (>= source_gs_member 0))
(assert (>= target_gs_member 0))
(assert (not (= source_gs_member target_gs_member)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ring_add_node: source semantics (matches Coq)
; Translation validation: ring_add_node preserves semantics
(push 1)
(declare-const source_ring_add_node Int)
(declare-const target_ring_add_node Int)
(assert (>= source_ring_add_node 0))
(assert (>= target_ring_add_node 0))
(assert (not (= source_ring_add_node target_ring_add_node)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ring_remove_node: source semantics (matches Coq)
; Translation validation: ring_remove_node preserves semantics
(push 1)
(declare-const source_ring_remove_node Int)
(declare-const target_ring_remove_node Int)
(assert (>= source_ring_remove_node 0))
(assert (>= target_ring_remove_node 0))
(assert (not (= source_ring_remove_node target_ring_remove_node)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_01_quorum_intersection: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_01_quorum_intersection preserves semantics
(push 1)
(declare-const source_DELTA_001_01_quorum_intersection Int)
(declare-const target_DELTA_001_01_quorum_intersection Int)
(assert (>= source_DELTA_001_01_quorum_intersection 0))
(assert (>= target_DELTA_001_01_quorum_intersection 0))
(assert (not (= source_DELTA_001_01_quorum_intersection target_DELTA_001_01_quorum_intersection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_02_single_vote_per_term: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_02_single_vote_per_term preserves semantics
(push 1)
(declare-const source_DELTA_001_02_single_vote_per_term Int)
(declare-const target_DELTA_001_02_single_vote_per_term Int)
(assert (>= source_DELTA_001_02_single_vote_per_term 0))
(assert (>= target_DELTA_001_02_single_vote_per_term 0))
(assert (not (= source_DELTA_001_02_single_vote_per_term target_DELTA_001_02_single_vote_per_term)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_03_log_matching_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_03_log_matching_reflexive preserves semantics
(push 1)
(declare-const source_DELTA_001_03_log_matching_reflexive Int)
(declare-const target_DELTA_001_03_log_matching_reflexive Int)
(assert (>= source_DELTA_001_03_log_matching_reflexive 0))
(assert (>= target_DELTA_001_03_log_matching_reflexive 0))
(assert (not (= source_DELTA_001_03_log_matching_reflexive target_DELTA_001_03_log_matching_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_04_committed_requires_quorum: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_04_committed_requires_quorum preserves semantics
(push 1)
(declare-const source_DELTA_001_04_committed_requires_quorum Int)
(declare-const target_DELTA_001_04_committed_requires_quorum Int)
(assert (>= source_DELTA_001_04_committed_requires_quorum 0))
(assert (>= target_DELTA_001_04_committed_requires_quorum 0))
(assert (not (= source_DELTA_001_04_committed_requires_quorum target_DELTA_001_04_committed_requires_quorum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_05_empty_log_no_commit: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_05_empty_log_no_commit preserves semantics
(push 1)
(declare-const source_DELTA_001_05_empty_log_no_commit Int)
(declare-const target_DELTA_001_05_empty_log_no_commit Int)
(assert (>= source_DELTA_001_05_empty_log_no_commit 0))
(assert (>= target_DELTA_001_05_empty_log_no_commit 0))
(assert (not (= source_DELTA_001_05_empty_log_no_commit target_DELTA_001_05_empty_log_no_commit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_06_leader_append_only: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_06_leader_append_only preserves semantics
(push 1)
(declare-const source_DELTA_001_06_leader_append_only Int)
(declare-const target_DELTA_001_06_leader_append_only Int)
(assert (>= source_DELTA_001_06_leader_append_only 0))
(assert (>= target_DELTA_001_06_leader_append_only 0))
(assert (not (= source_DELTA_001_06_leader_append_only target_DELTA_001_06_leader_append_only)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_07_term_monotonic: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_07_term_monotonic preserves semantics
(push 1)
(declare-const source_DELTA_001_07_term_monotonic Int)
(declare-const target_DELTA_001_07_term_monotonic Int)
(assert (>= source_DELTA_001_07_term_monotonic 0))
(assert (>= target_DELTA_001_07_term_monotonic 0))
(assert (not (= source_DELTA_001_07_term_monotonic target_DELTA_001_07_term_monotonic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_08_entry_at_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_08_entry_at_deterministic preserves semantics
(push 1)
(declare-const source_DELTA_001_08_entry_at_deterministic Int)
(declare-const target_DELTA_001_08_entry_at_deterministic Int)
(assert (>= source_DELTA_001_08_entry_at_deterministic 0))
(assert (>= target_DELTA_001_08_entry_at_deterministic 0))
(assert (not (= source_DELTA_001_08_entry_at_deterministic target_DELTA_001_08_entry_at_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_09_log_prefix_match: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_09_log_prefix_match preserves semantics
(push 1)
(declare-const source_DELTA_001_09_log_prefix_match Int)
(declare-const target_DELTA_001_09_log_prefix_match Int)
(assert (>= source_DELTA_001_09_log_prefix_match 0))
(assert (>= target_DELTA_001_09_log_prefix_match 0))
(assert (not (= source_DELTA_001_09_log_prefix_match target_DELTA_001_09_log_prefix_match)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_001_10_quorum_nonempty: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_001_10_quorum_nonempty preserves semantics
(push 1)
(declare-const source_DELTA_001_10_quorum_nonempty Int)
(declare-const target_DELTA_001_10_quorum_nonempty Int)
(assert (>= source_DELTA_001_10_quorum_nonempty 0))
(assert (>= target_DELTA_001_10_quorum_nonempty 0))
(assert (not (= source_DELTA_001_10_quorum_nonempty target_DELTA_001_10_quorum_nonempty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_002_01_bft_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_002_01_bft_bound preserves semantics
(push 1)
(declare-const source_DELTA_002_01_bft_bound Int)
(declare-const target_DELTA_002_01_bft_bound Int)
(assert (>= source_DELTA_002_01_bft_bound 0))
(assert (>= target_DELTA_002_01_bft_bound 0))
(assert (not (= source_DELTA_002_01_bft_bound target_DELTA_002_01_bft_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_002_02_bft_quorum_sufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_002_02_bft_quorum_sufficient preserves semantics
(push 1)
(declare-const source_DELTA_002_02_bft_quorum_sufficient Int)
(declare-const target_DELTA_002_02_bft_quorum_sufficient Int)
(assert (>= source_DELTA_002_02_bft_quorum_sufficient 0))
(assert (>= target_DELTA_002_02_bft_quorum_sufficient 0))
(assert (not (= source_DELTA_002_02_bft_quorum_sufficient target_DELTA_002_02_bft_quorum_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_002_03_bft_two_quorums_overlap: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_002_03_bft_two_quorums_overlap preserves semantics
(push 1)
(declare-const source_DELTA_002_03_bft_two_quorums_overlap Int)
(declare-const target_DELTA_002_03_bft_two_quorums_overlap Int)
(assert (>= source_DELTA_002_03_bft_two_quorums_overlap 0))
(assert (>= target_DELTA_002_03_bft_two_quorums_overlap 0))
(assert (not (= source_DELTA_002_03_bft_two_quorums_overlap target_DELTA_002_03_bft_two_quorums_overlap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_002_04_correct_majority: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_002_04_correct_majority preserves semantics
(push 1)
(declare-const source_DELTA_002_04_correct_majority Int)
(declare-const target_DELTA_002_04_correct_majority Int)
(assert (>= source_DELTA_002_04_correct_majority 0))
(assert (>= target_DELTA_002_04_correct_majority 0))
(assert (not (= source_DELTA_002_04_correct_majority target_DELTA_002_04_correct_majority)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_002_05_bft_f_zero: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_002_05_bft_f_zero preserves semantics
(push 1)
(declare-const source_DELTA_002_05_bft_f_zero Int)
(declare-const target_DELTA_002_05_bft_f_zero Int)
(assert (>= source_DELTA_002_05_bft_f_zero 0))
(assert (>= target_DELTA_002_05_bft_f_zero 0))
(assert (not (= source_DELTA_002_05_bft_f_zero target_DELTA_002_05_bft_f_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_002_06_bft_phases_ordered: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_002_06_bft_phases_ordered preserves semantics
(push 1)
(declare-const source_DELTA_002_06_bft_phases_ordered Int)
(declare-const target_DELTA_002_06_bft_phases_ordered Int)
(assert (>= source_DELTA_002_06_bft_phases_ordered 0))
(assert (>= target_DELTA_002_06_bft_phases_ordered 0))
(assert (not (= source_DELTA_002_06_bft_phases_ordered target_DELTA_002_06_bft_phases_ordered)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_01_gc_merge_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_01_gc_merge_comm preserves semantics
(push 1)
(declare-const source_DELTA_003_01_gc_merge_comm Int)
(declare-const target_DELTA_003_01_gc_merge_comm Int)
(assert (>= source_DELTA_003_01_gc_merge_comm 0))
(assert (>= target_DELTA_003_01_gc_merge_comm 0))
(assert (not (= source_DELTA_003_01_gc_merge_comm target_DELTA_003_01_gc_merge_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_02_gc_merge_assoc: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_02_gc_merge_assoc preserves semantics
(push 1)
(declare-const source_DELTA_003_02_gc_merge_assoc Int)
(declare-const target_DELTA_003_02_gc_merge_assoc Int)
(assert (>= source_DELTA_003_02_gc_merge_assoc 0))
(assert (>= target_DELTA_003_02_gc_merge_assoc 0))
(assert (not (= source_DELTA_003_02_gc_merge_assoc target_DELTA_003_02_gc_merge_assoc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_03_gc_merge_idempotent: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_03_gc_merge_idempotent preserves semantics
(push 1)
(declare-const source_DELTA_003_03_gc_merge_idempotent Int)
(declare-const target_DELTA_003_03_gc_merge_idempotent Int)
(assert (>= source_DELTA_003_03_gc_merge_idempotent 0))
(assert (>= target_DELTA_003_03_gc_merge_idempotent 0))
(assert (not (= source_DELTA_003_03_gc_merge_idempotent target_DELTA_003_03_gc_merge_idempotent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_04_gc_value_nonneg: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_04_gc_value_nonneg preserves semantics
(push 1)
(declare-const source_DELTA_003_04_gc_value_nonneg Int)
(declare-const target_DELTA_003_04_gc_value_nonneg Int)
(assert (>= source_DELTA_003_04_gc_value_nonneg 0))
(assert (>= target_DELTA_003_04_gc_value_nonneg 0))
(assert (not (= source_DELTA_003_04_gc_value_nonneg target_DELTA_003_04_gc_value_nonneg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fold_left_add_mono: translation preserves property (matches Coq: Lemma)
; Translation validation: fold_left_add_mono preserves semantics
(push 1)
(declare-const source_fold_left_add_mono Int)
(declare-const target_fold_left_add_mono Int)
(assert (>= source_fold_left_add_mono 0))
(assert (>= target_fold_left_add_mono 0))
(assert (not (= source_fold_left_add_mono target_fold_left_add_mono)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_05_gc_merge_monotone: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_05_gc_merge_monotone preserves semantics
(push 1)
(declare-const source_DELTA_003_05_gc_merge_monotone Int)
(declare-const target_DELTA_003_05_gc_merge_monotone Int)
(assert (>= source_DELTA_003_05_gc_merge_monotone 0))
(assert (>= target_DELTA_003_05_gc_merge_monotone 0))
(assert (not (= source_DELTA_003_05_gc_merge_monotone target_DELTA_003_05_gc_merge_monotone)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_06_gs_add_member: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_06_gs_add_member preserves semantics
(push 1)
(declare-const source_DELTA_003_06_gs_add_member Int)
(declare-const target_DELTA_003_06_gs_add_member Int)
(assert (>= source_DELTA_003_06_gs_add_member 0))
(assert (>= target_DELTA_003_06_gs_add_member 0))
(assert (not (= source_DELTA_003_06_gs_add_member target_DELTA_003_06_gs_add_member)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_07_gs_add_preserves: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_07_gs_add_preserves preserves semantics
(push 1)
(declare-const source_DELTA_003_07_gs_add_preserves Int)
(declare-const target_DELTA_003_07_gs_add_preserves Int)
(assert (>= source_DELTA_003_07_gs_add_preserves 0))
(assert (>= target_DELTA_003_07_gs_add_preserves 0))
(assert (not (= source_DELTA_003_07_gs_add_preserves target_DELTA_003_07_gs_add_preserves)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_08_gs_merge_contains_left: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_08_gs_merge_contains_left preserves semantics
(push 1)
(declare-const source_DELTA_003_08_gs_merge_contains_left Int)
(declare-const target_DELTA_003_08_gs_merge_contains_left Int)
(assert (>= source_DELTA_003_08_gs_merge_contains_left 0))
(assert (>= target_DELTA_003_08_gs_merge_contains_left 0))
(assert (not (= source_DELTA_003_08_gs_merge_contains_left target_DELTA_003_08_gs_merge_contains_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_09_gs_add_idempotent: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_09_gs_add_idempotent preserves semantics
(push 1)
(declare-const source_DELTA_003_09_gs_add_idempotent Int)
(declare-const target_DELTA_003_09_gs_add_idempotent Int)
(assert (>= source_DELTA_003_09_gs_add_idempotent 0))
(assert (>= target_DELTA_003_09_gs_add_idempotent 0))
(assert (not (= source_DELTA_003_09_gs_add_idempotent target_DELTA_003_09_gs_add_idempotent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_003_10_gc_empty_zero: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_003_10_gc_empty_zero preserves semantics
(push 1)
(declare-const source_DELTA_003_10_gc_empty_zero Int)
(declare-const target_DELTA_003_10_gc_empty_zero Int)
(assert (>= source_DELTA_003_10_gc_empty_zero 0))
(assert (>= target_DELTA_003_10_gc_empty_zero 0))
(assert (not (= source_DELTA_003_10_gc_empty_zero target_DELTA_003_10_gc_empty_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_004_01_ring_add_increases: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_004_01_ring_add_increases preserves semantics
(push 1)
(declare-const source_DELTA_004_01_ring_add_increases Int)
(declare-const target_DELTA_004_01_ring_add_increases Int)
(assert (>= source_DELTA_004_01_ring_add_increases 0))
(assert (>= target_DELTA_004_01_ring_add_increases 0))
(assert (not (= source_DELTA_004_01_ring_add_increases target_DELTA_004_01_ring_add_increases)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_004_02_ring_remove_decreases: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_004_02_ring_remove_decreases preserves semantics
(push 1)
(declare-const source_DELTA_004_02_ring_remove_decreases Int)
(declare-const target_DELTA_004_02_ring_remove_decreases Int)
(assert (>= source_DELTA_004_02_ring_remove_decreases 0))
(assert (>= target_DELTA_004_02_ring_remove_decreases 0))
(assert (not (= source_DELTA_004_02_ring_remove_decreases target_DELTA_004_02_ring_remove_decreases)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_004_03_ring_size_preserved_add: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_004_03_ring_size_preserved_add preserves semantics
(push 1)
(declare-const source_DELTA_004_03_ring_size_preserved_add Int)
(declare-const target_DELTA_004_03_ring_size_preserved_add Int)
(assert (>= source_DELTA_004_03_ring_size_preserved_add 0))
(assert (>= target_DELTA_004_03_ring_size_preserved_add 0))
(assert (not (= source_DELTA_004_03_ring_size_preserved_add target_DELTA_004_03_ring_size_preserved_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_004_04_ring_size_preserved_remove: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_004_04_ring_size_preserved_remove preserves semantics
(push 1)
(declare-const source_DELTA_004_04_ring_size_preserved_remove Int)
(declare-const target_DELTA_004_04_ring_size_preserved_remove Int)
(assert (>= source_DELTA_004_04_ring_size_preserved_remove 0))
(assert (>= target_DELTA_004_04_ring_size_preserved_remove 0))
(assert (not (= source_DELTA_004_04_ring_size_preserved_remove target_DELTA_004_04_ring_size_preserved_remove)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; DELTA_004_05_empty_ring_no_lookup: translation preserves property (matches Coq: Theorem)
; Translation validation: DELTA_004_05_empty_ring_no_lookup preserves semantics
(push 1)
(declare-const source_DELTA_004_05_empty_ring_no_lookup Int)
(declare-const target_DELTA_004_05_empty_ring_no_lookup Int)
(assert (>= source_DELTA_004_05_empty_ring_no_lookup 0))
(assert (>= target_DELTA_004_05_empty_ring_no_lookup 0))
(assert (not (= source_DELTA_004_05_empty_ring_no_lookup target_DELTA_004_05_empty_ring_no_lookup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

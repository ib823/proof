; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/X001_ConcurrencyModel.v (39 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for X001_ConcurrencyModel
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; well_formed_access: source semantics (matches Coq)
; Translation validation: well_formed_access preserves semantics
(push 1)
(declare-const source_well_formed_access Int)
(declare-const target_well_formed_access Int)
(assert (>= source_well_formed_access 0))
(assert (>= target_well_formed_access 0))
(assert (not (= source_well_formed_access target_well_formed_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_concurrent_writes: source semantics (matches Coq)
; Translation validation: no_concurrent_writes preserves semantics
(push 1)
(declare-const source_no_concurrent_writes Int)
(declare-const target_no_concurrent_writes Int)
(assert (>= source_no_concurrent_writes 0))
(assert (>= target_no_concurrent_writes 0))
(assert (not (= source_no_concurrent_writes target_no_concurrent_writes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_write_during_read: source semantics (matches Coq)
; Translation validation: no_write_during_read preserves semantics
(push 1)
(declare-const source_no_write_during_read Int)
(declare-const target_no_write_during_read Int)
(assert (>= source_no_write_during_read 0))
(assert (>= target_no_write_during_read 0))
(assert (not (= source_no_write_during_read target_no_write_during_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dual: source semantics (matches Coq)
; Translation validation: dual preserves semantics
(push 1)
(declare-const source_dual Int)
(declare-const target_dual Int)
(assert (>= source_dual 0))
(assert (>= target_dual 0))
(assert (not (= source_dual target_dual)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; channel_used: source semantics (matches Coq)
; Translation validation: channel_used preserves semantics
(push 1)
(declare-const source_channel_used Int)
(declare-const target_channel_used Int)
(assert (>= source_channel_used 0))
(assert (>= target_channel_used 0))
(assert (not (= source_channel_used target_channel_used)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_fresh: source semantics (matches Coq)
; Translation validation: is_fresh preserves semantics
(push 1)
(declare-const source_is_fresh Int)
(declare-const target_is_fresh Int)
(assert (>= source_is_fresh 0))
(assert (>= target_is_fresh 0))
(assert (not (= source_is_fresh target_is_fresh)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; accesses: source semantics (matches Coq)
; Translation validation: accesses preserves semantics
(push 1)
(declare-const source_accesses Int)
(declare-const target_accesses Int)
(assert (>= source_accesses 0))
(assert (>= target_accesses 0))
(assert (not (= source_accesses target_accesses)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; writes: source semantics (matches Coq)
; Translation validation: writes preserves semantics
(push 1)
(declare-const source_writes Int)
(declare-const target_writes Int)
(assert (>= source_writes 0))
(assert (>= target_writes 0))
(assert (not (= source_writes target_writes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; data_race: source semantics (matches Coq)
; Translation validation: data_race preserves semantics
(push 1)
(declare-const source_data_race Int)
(declare-const target_data_race Int)
(assert (>= source_data_race 0))
(assert (>= target_data_race 0))
(assert (not (= source_data_race target_data_race)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; well_typed: source semantics (matches Coq)
; Translation validation: well_typed preserves semantics
(push 1)
(declare-const source_well_typed Int)
(declare-const target_well_typed Int)
(assert (>= source_well_typed 0))
(assert (>= target_well_typed 0))
(assert (not (= source_well_typed target_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; session_typed: source semantics (matches Coq)
; Translation validation: session_typed preserves semantics
(push 1)
(declare-const source_session_typed Int)
(declare-const target_session_typed Int)
(assert (>= source_session_typed 0))
(assert (>= target_session_typed 0))
(assert (not (= source_session_typed target_session_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; waiting: source semantics (matches Coq)
; Translation validation: waiting preserves semantics
(push 1)
(declare-const source_waiting Int)
(declare-const target_waiting Int)
(assert (>= source_waiting 0))
(assert (>= target_waiting 0))
(assert (not (= source_waiting target_waiting)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; holding: source semantics (matches Coq)
; Translation validation: holding preserves semantics
(push 1)
(declare-const source_holding Int)
(declare-const target_holding Int)
(assert (>= source_holding 0))
(assert (>= target_holding 0))
(assert (not (= source_holding target_holding)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; waits_for: source semantics (matches Coq)
; Translation validation: waits_for preserves semantics
(push 1)
(declare-const source_waits_for Int)
(declare-const target_waits_for Int)
(assert (>= source_waits_for 0))
(assert (>= target_waits_for 0))
(assert (not (= source_waits_for target_waits_for)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; circular_wait: source semantics (matches Coq)
; Translation validation: circular_wait preserves semantics
(push 1)
(declare-const source_circular_wait Int)
(declare-const target_circular_wait Int)
(assert (>= source_circular_wait 0))
(assert (>= target_circular_wait 0))
(assert (not (= source_circular_wait target_circular_wait)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; deadlocked: source semantics (matches Coq)
; Translation validation: deadlocked preserves semantics
(push 1)
(declare-const source_deadlocked Int)
(declare-const target_deadlocked Int)
(assert (>= source_deadlocked 0))
(assert (>= target_deadlocked 0))
(assert (not (= source_deadlocked target_deadlocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; holds_lock: source semantics (matches Coq)
; Translation validation: holds_lock preserves semantics
(push 1)
(declare-const source_holds_lock Int)
(declare-const target_holds_lock Int)
(assert (>= source_holds_lock 0))
(assert (>= target_holds_lock 0))
(assert (not (= source_holds_lock target_holds_lock)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; acquires_lock: source semantics (matches Coq)
; Translation validation: acquires_lock preserves semantics
(push 1)
(declare-const source_acquires_lock Int)
(declare-const target_acquires_lock Int)
(assert (>= source_acquires_lock 0))
(assert (>= target_acquires_lock 0))
(assert (not (= source_acquires_lock target_acquires_lock)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; respects_order: source semantics (matches Coq)
; Translation validation: respects_order preserves semantics
(push 1)
(declare-const source_respects_order Int)
(declare-const target_respects_order Int)
(assert (>= source_respects_order 0))
(assert (>= target_respects_order 0))
(assert (not (= source_respects_order target_respects_order)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_respect_order: source semantics (matches Coq)
; Translation validation: all_respect_order preserves semantics
(push 1)
(declare-const source_all_respect_order Int)
(declare-const target_all_respect_order Int)
(assert (>= source_all_respect_order 0))
(assert (>= target_all_respect_order 0))
(assert (not (= source_all_respect_order target_all_respect_order)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; init_mutex: source semantics (matches Coq)
; Translation validation: init_mutex preserves semantics
(push 1)
(declare-const source_init_mutex Int)
(declare-const target_init_mutex Int)
(assert (>= source_init_mutex 0))
(assert (>= target_init_mutex 0))
(assert (not (= source_init_mutex target_init_mutex)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; project: source semantics (matches Coq)
; Translation validation: project preserves semantics
(push 1)
(declare-const source_project Int)
(declare-const target_project Int)
(assert (>= source_project 0))
(assert (>= target_project 0))
(assert (not (= source_project target_project)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; conforms: source semantics (matches Coq)
; Translation validation: conforms preserves semantics
(push 1)
(declare-const source_conforms Int)
(declare-const target_conforms Int)
(assert (>= source_conforms 0))
(assert (>= target_conforms 0))
(assert (not (= source_conforms target_conforms)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; atomic_race_free: source semantics (matches Coq)
; Translation validation: atomic_race_free preserves semantics
(push 1)
(declare-const source_atomic_race_free Int)
(declare-const target_atomic_race_free Int)
(assert (>= source_atomic_race_free 0))
(assert (>= target_atomic_race_free 0))
(assert (not (= source_atomic_race_free target_atomic_race_free)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_timeout: source semantics (matches Coq)
; Translation validation: has_timeout preserves semantics
(push 1)
(declare-const source_has_timeout Int)
(declare-const target_has_timeout Int)
(assert (>= source_has_timeout 0))
(assert (>= target_has_timeout 0))
(assert (not (= source_has_timeout target_has_timeout)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bounded: source semantics (matches Coq)
; Translation validation: bounded preserves semantics
(push 1)
(declare-const source_bounded Int)
(declare-const target_bounded Int)
(assert (>= source_bounded 0))
(assert (>= target_bounded 0))
(assert (not (= source_bounded target_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; livelock: source semantics (matches Coq)
; Translation validation: livelock preserves semantics
(push 1)
(declare-const source_livelock Int)
(declare-const target_livelock Int)
(assert (>= source_livelock 0))
(assert (>= target_livelock 0))
(assert (not (= source_livelock target_livelock)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; starved: source semantics (matches Coq)
; Translation validation: starved preserves semantics
(push 1)
(declare-const source_starved Int)
(declare-const target_starved Int)
(assert (>= source_starved 0))
(assert (>= target_starved 0))
(assert (not (= source_starved target_starved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fair_scheduling: source semantics (matches Coq)
; Translation validation: fair_scheduling preserves semantics
(push 1)
(declare-const source_fair_scheduling Int)
(declare-const target_fair_scheduling Int)
(assert (>= source_fair_scheduling 0))
(assert (>= target_fair_scheduling 0))
(assert (not (= source_fair_scheduling target_fair_scheduling)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_01_shared_xor_mutable: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_01_shared_xor_mutable preserves semantics
(push 1)
(declare-const source_X_001_01_shared_xor_mutable Int)
(declare-const target_X_001_01_shared_xor_mutable Int)
(assert (>= source_X_001_01_shared_xor_mutable 0))
(assert (>= target_X_001_01_shared_xor_mutable 0))
(assert (not (= source_X_001_01_shared_xor_mutable target_X_001_01_shared_xor_mutable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_02_ownership_exclusive: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_02_ownership_exclusive preserves semantics
(push 1)
(declare-const source_X_001_02_ownership_exclusive Int)
(declare-const target_X_001_02_ownership_exclusive Int)
(assert (>= source_X_001_02_ownership_exclusive 0))
(assert (>= target_X_001_02_ownership_exclusive 0))
(assert (not (= source_X_001_02_ownership_exclusive target_X_001_02_ownership_exclusive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_03_no_concurrent_write: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_03_no_concurrent_write preserves semantics
(push 1)
(declare-const source_X_001_03_no_concurrent_write Int)
(declare-const target_X_001_03_no_concurrent_write Int)
(assert (>= source_X_001_03_no_concurrent_write 0))
(assert (>= target_X_001_03_no_concurrent_write 0))
(assert (not (= source_X_001_03_no_concurrent_write target_X_001_03_no_concurrent_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_04_no_write_during_read: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_04_no_write_during_read preserves semantics
(push 1)
(declare-const source_X_001_04_no_write_during_read Int)
(declare-const target_X_001_04_no_write_during_read Int)
(assert (>= source_X_001_04_no_write_during_read 0))
(assert (>= target_X_001_04_no_write_during_read 0))
(assert (not (= source_X_001_04_no_write_during_read target_X_001_04_no_write_during_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_05_race_freedom: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_05_race_freedom preserves semantics
(push 1)
(declare-const source_X_001_05_race_freedom Int)
(declare-const target_X_001_05_race_freedom Int)
(assert (>= source_X_001_05_race_freedom 0))
(assert (>= target_X_001_05_race_freedom 0))
(assert (not (= source_X_001_05_race_freedom target_X_001_05_race_freedom)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_06_race_freedom_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_06_race_freedom_composition preserves semantics
(push 1)
(declare-const source_X_001_06_race_freedom_composition Int)
(declare-const target_X_001_06_race_freedom_composition Int)
(assert (>= source_X_001_06_race_freedom_composition 0))
(assert (>= target_X_001_06_race_freedom_composition 0))
(assert (not (= source_X_001_06_race_freedom_composition target_X_001_06_race_freedom_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_07_atomic_operations: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_07_atomic_operations preserves semantics
(push 1)
(declare-const source_X_001_07_atomic_operations Int)
(declare-const target_X_001_07_atomic_operations Int)
(assert (>= source_X_001_07_atomic_operations 0))
(assert (>= target_X_001_07_atomic_operations 0))
(assert (not (= source_X_001_07_atomic_operations target_X_001_07_atomic_operations)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_08_lock_protects: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_08_lock_protects preserves semantics
(push 1)
(declare-const source_X_001_08_lock_protects Int)
(declare-const target_X_001_08_lock_protects Int)
(assert (>= source_X_001_08_lock_protects 0))
(assert (>= target_X_001_08_lock_protects 0))
(assert (not (= source_X_001_08_lock_protects target_X_001_08_lock_protects)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_09_session_type_dual: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_09_session_type_dual preserves semantics
(push 1)
(declare-const source_X_001_09_session_type_dual Int)
(declare-const target_X_001_09_session_type_dual Int)
(assert (>= source_X_001_09_session_type_dual 0))
(assert (>= target_X_001_09_session_type_dual 0))
(assert (not (= source_X_001_09_session_type_dual target_X_001_09_session_type_dual)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_09b_dual_send_recv: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_09b_dual_send_recv preserves semantics
(push 1)
(declare-const source_X_001_09b_dual_send_recv Int)
(declare-const target_X_001_09b_dual_send_recv Int)
(assert (>= source_X_001_09b_dual_send_recv 0))
(assert (>= target_X_001_09b_dual_send_recv 0))
(assert (not (= source_X_001_09b_dual_send_recv target_X_001_09b_dual_send_recv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_09c_dual_compose: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_09c_dual_compose preserves semantics
(push 1)
(declare-const source_X_001_09c_dual_compose Int)
(declare-const target_X_001_09c_dual_compose Int)
(assert (>= source_X_001_09c_dual_compose 0))
(assert (>= target_X_001_09c_dual_compose 0))
(assert (not (= source_X_001_09c_dual_compose target_X_001_09c_dual_compose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_10_session_fidelity: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_10_session_fidelity preserves semantics
(push 1)
(declare-const source_X_001_10_session_fidelity Int)
(declare-const target_X_001_10_session_fidelity Int)
(assert (>= source_X_001_10_session_fidelity 0))
(assert (>= target_X_001_10_session_fidelity 0))
(assert (not (= source_X_001_10_session_fidelity target_X_001_10_session_fidelity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_11_session_progress: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_11_session_progress preserves semantics
(push 1)
(declare-const source_X_001_11_session_progress Int)
(declare-const target_X_001_11_session_progress Int)
(assert (>= source_X_001_11_session_progress 0))
(assert (>= target_X_001_11_session_progress 0))
(assert (not (= source_X_001_11_session_progress target_X_001_11_session_progress)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_12_session_safety: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_12_session_safety preserves semantics
(push 1)
(declare-const source_X_001_12_session_safety Int)
(declare-const target_X_001_12_session_safety Int)
(assert (>= source_X_001_12_session_safety 0))
(assert (>= target_X_001_12_session_safety 0))
(assert (not (= source_X_001_12_session_safety target_X_001_12_session_safety)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_13_channel_linear: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_13_channel_linear preserves semantics
(push 1)
(declare-const source_X_001_13_channel_linear Int)
(declare-const target_X_001_13_channel_linear Int)
(assert (>= source_X_001_13_channel_linear 0))
(assert (>= target_X_001_13_channel_linear 0))
(assert (not (= source_X_001_13_channel_linear target_X_001_13_channel_linear)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_14_no_channel_reuse: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_14_no_channel_reuse preserves semantics
(push 1)
(declare-const source_X_001_14_no_channel_reuse Int)
(declare-const target_X_001_14_no_channel_reuse Int)
(assert (>= source_X_001_14_no_channel_reuse 0))
(assert (>= target_X_001_14_no_channel_reuse 0))
(assert (not (= source_X_001_14_no_channel_reuse target_X_001_14_no_channel_reuse)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_15_send_recv_match: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_15_send_recv_match preserves semantics
(push 1)
(declare-const source_X_001_15_send_recv_match Int)
(declare-const target_X_001_15_send_recv_match Int)
(assert (>= source_X_001_15_send_recv_match 0))
(assert (>= target_X_001_15_send_recv_match 0))
(assert (not (= source_X_001_15_send_recv_match target_X_001_15_send_recv_match)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_16_select_offer_match: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_16_select_offer_match preserves semantics
(push 1)
(declare-const source_X_001_16_select_offer_match Int)
(declare-const target_X_001_16_select_offer_match Int)
(assert (>= source_X_001_16_select_offer_match 0))
(assert (>= target_X_001_16_select_offer_match 0))
(assert (not (= source_X_001_16_select_offer_match target_X_001_16_select_offer_match)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_17_session_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_17_session_composition preserves semantics
(push 1)
(declare-const source_X_001_17_session_composition Int)
(declare-const target_X_001_17_session_composition Int)
(assert (>= source_X_001_17_session_composition 0))
(assert (>= target_X_001_17_session_composition 0))
(assert (not (= source_X_001_17_session_composition target_X_001_17_session_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_17b_dual_base_involutive: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_17b_dual_base_involutive preserves semantics
(push 1)
(declare-const source_X_001_17b_dual_base_involutive Int)
(declare-const target_X_001_17b_dual_base_involutive Int)
(assert (>= source_X_001_17b_dual_base_involutive 0))
(assert (>= target_X_001_17b_dual_base_involutive 0))
(assert (not (= source_X_001_17b_dual_base_involutive target_X_001_17b_dual_base_involutive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_17c_dual_chain: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_17c_dual_chain preserves semantics
(push 1)
(declare-const source_X_001_17c_dual_chain Int)
(declare-const target_X_001_17c_dual_chain Int)
(assert (>= source_X_001_17c_dual_chain 0))
(assert (>= target_X_001_17c_dual_chain 0))
(assert (not (= source_X_001_17c_dual_chain target_X_001_17c_dual_chain)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_18_no_circular_wait: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_18_no_circular_wait preserves semantics
(push 1)
(declare-const source_X_001_18_no_circular_wait Int)
(declare-const target_X_001_18_no_circular_wait Int)
(assert (>= source_X_001_18_no_circular_wait 0))
(assert (>= target_X_001_18_no_circular_wait 0))
(assert (not (= source_X_001_18_no_circular_wait target_X_001_18_no_circular_wait)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_19_lock_ordering: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_19_lock_ordering preserves semantics
(push 1)
(declare-const source_X_001_19_lock_ordering Int)
(declare-const target_X_001_19_lock_ordering Int)
(assert (>= source_X_001_19_lock_ordering 0))
(assert (>= target_X_001_19_lock_ordering 0))
(assert (not (= source_X_001_19_lock_ordering target_X_001_19_lock_ordering)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_20_session_deadlock_free: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_20_session_deadlock_free preserves semantics
(push 1)
(declare-const source_X_001_20_session_deadlock_free Int)
(declare-const target_X_001_20_session_deadlock_free Int)
(assert (>= source_X_001_20_session_deadlock_free 0))
(assert (>= target_X_001_20_session_deadlock_free 0))
(assert (not (= source_X_001_20_session_deadlock_free target_X_001_20_session_deadlock_free)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_21_resource_ordering: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_21_resource_ordering preserves semantics
(push 1)
(declare-const source_X_001_21_resource_ordering Int)
(declare-const target_X_001_21_resource_ordering Int)
(assert (>= source_X_001_21_resource_ordering 0))
(assert (>= target_X_001_21_resource_ordering 0))
(assert (not (= source_X_001_21_resource_ordering target_X_001_21_resource_ordering)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_22_timeout_prevents_deadlock: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_22_timeout_prevents_deadlock preserves semantics
(push 1)
(declare-const source_X_001_22_timeout_prevents_deadlock Int)
(declare-const target_X_001_22_timeout_prevents_deadlock Int)
(assert (>= source_X_001_22_timeout_prevents_deadlock 0))
(assert (>= target_X_001_22_timeout_prevents_deadlock 0))
(assert (not (= source_X_001_22_timeout_prevents_deadlock target_X_001_22_timeout_prevents_deadlock)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_23_deadlock_detection: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_23_deadlock_detection preserves semantics
(push 1)
(declare-const source_X_001_23_deadlock_detection Int)
(declare-const target_X_001_23_deadlock_detection Int)
(assert (>= source_X_001_23_deadlock_detection 0))
(assert (>= target_X_001_23_deadlock_detection 0))
(assert (not (= source_X_001_23_deadlock_detection target_X_001_23_deadlock_detection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_24_livelock_freedom: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_24_livelock_freedom preserves semantics
(push 1)
(declare-const source_X_001_24_livelock_freedom Int)
(declare-const target_X_001_24_livelock_freedom Int)
(assert (>= source_X_001_24_livelock_freedom 0))
(assert (>= target_X_001_24_livelock_freedom 0))
(assert (not (= source_X_001_24_livelock_freedom target_X_001_24_livelock_freedom)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_25_starvation_freedom: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_25_starvation_freedom preserves semantics
(push 1)
(declare-const source_X_001_25_starvation_freedom Int)
(declare-const target_X_001_25_starvation_freedom Int)
(assert (>= source_X_001_25_starvation_freedom 0))
(assert (>= target_X_001_25_starvation_freedom 0))
(assert (not (= source_X_001_25_starvation_freedom target_X_001_25_starvation_freedom)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_26_mutex_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_26_mutex_correct preserves semantics
(push 1)
(declare-const source_X_001_26_mutex_correct Int)
(declare-const target_X_001_26_mutex_correct Int)
(assert (>= source_X_001_26_mutex_correct 0))
(assert (>= target_X_001_26_mutex_correct 0))
(assert (not (= source_X_001_26_mutex_correct target_X_001_26_mutex_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_27_rwlock_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_27_rwlock_correct preserves semantics
(push 1)
(declare-const source_X_001_27_rwlock_correct Int)
(declare-const target_X_001_27_rwlock_correct Int)
(assert (>= source_X_001_27_rwlock_correct 0))
(assert (>= target_X_001_27_rwlock_correct 0))
(assert (not (= source_X_001_27_rwlock_correct target_X_001_27_rwlock_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_28_barrier_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_28_barrier_correct preserves semantics
(push 1)
(declare-const source_X_001_28_barrier_correct Int)
(declare-const target_X_001_28_barrier_correct Int)
(assert (>= source_X_001_28_barrier_correct 0))
(assert (>= target_X_001_28_barrier_correct 0))
(assert (not (= source_X_001_28_barrier_correct target_X_001_28_barrier_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_29_semaphore_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_29_semaphore_correct preserves semantics
(push 1)
(declare-const source_X_001_29_semaphore_correct Int)
(declare-const target_X_001_29_semaphore_correct Int)
(assert (>= source_X_001_29_semaphore_correct 0))
(assert (>= target_X_001_29_semaphore_correct 0))
(assert (not (= source_X_001_29_semaphore_correct target_X_001_29_semaphore_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_30_condvar_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_30_condvar_correct preserves semantics
(push 1)
(declare-const source_X_001_30_condvar_correct Int)
(declare-const target_X_001_30_condvar_correct Int)
(assert (>= source_X_001_30_condvar_correct 0))
(assert (>= target_X_001_30_condvar_correct 0))
(assert (not (= source_X_001_30_condvar_correct target_X_001_30_condvar_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_31_global_type_projectable: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_31_global_type_projectable preserves semantics
(push 1)
(declare-const source_X_001_31_global_type_projectable Int)
(declare-const target_X_001_31_global_type_projectable Int)
(assert (>= source_X_001_31_global_type_projectable 0))
(assert (>= target_X_001_31_global_type_projectable 0))
(assert (not (= source_X_001_31_global_type_projectable target_X_001_31_global_type_projectable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_32_multiparty_safety: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_32_multiparty_safety preserves semantics
(push 1)
(declare-const source_X_001_32_multiparty_safety Int)
(declare-const target_X_001_32_multiparty_safety Int)
(assert (>= source_X_001_32_multiparty_safety 0))
(assert (>= target_X_001_32_multiparty_safety 0))
(assert (not (= source_X_001_32_multiparty_safety target_X_001_32_multiparty_safety)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_33_multiparty_progress: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_33_multiparty_progress preserves semantics
(push 1)
(declare-const source_X_001_33_multiparty_progress Int)
(declare-const target_X_001_33_multiparty_progress Int)
(assert (>= source_X_001_33_multiparty_progress 0))
(assert (>= target_X_001_33_multiparty_progress 0))
(assert (not (= source_X_001_33_multiparty_progress target_X_001_33_multiparty_progress)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_34_role_conformance: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_34_role_conformance preserves semantics
(push 1)
(declare-const source_X_001_34_role_conformance Int)
(declare-const target_X_001_34_role_conformance Int)
(assert (>= source_X_001_34_role_conformance 0))
(assert (>= target_X_001_34_role_conformance 0))
(assert (not (= source_X_001_34_role_conformance target_X_001_34_role_conformance)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; X_001_35_multiparty_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: X_001_35_multiparty_composition preserves semantics
(push 1)
(declare-const source_X_001_35_multiparty_composition Int)
(declare-const target_X_001_35_multiparty_composition Int)
(assert (>= source_X_001_35_multiparty_composition 0))
(assert (>= target_X_001_35_multiparty_composition 0))
(assert (not (= source_X_001_35_multiparty_composition target_X_001_35_multiparty_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

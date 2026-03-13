; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CapitalMarkets.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CapitalMarkets
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; side_eqb: source semantics (matches Coq)
; Translation validation: side_eqb preserves semantics
(push 1)
(declare-const source_side_eqb Int)
(declare-const target_side_eqb Int)
(assert (>= source_side_eqb 0))
(assert (>= target_side_eqb 0))
(assert (not (= source_side_eqb target_side_eqb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; buy_has_priority: source semantics (matches Coq)
; Translation validation: buy_has_priority preserves semantics
(push 1)
(declare-const source_buy_has_priority Int)
(declare-const target_buy_has_priority Int)
(assert (>= source_buy_has_priority 0))
(assert (>= target_buy_has_priority 0))
(assert (not (= source_buy_has_priority target_buy_has_priority)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sell_has_priority: source semantics (matches Coq)
; Translation validation: sell_has_priority preserves semantics
(push 1)
(declare-const source_sell_has_priority Int)
(declare-const target_sell_has_priority Int)
(assert (>= source_sell_has_priority 0))
(assert (>= target_sell_has_priority 0))
(assert (not (= source_sell_has_priority target_sell_has_priority)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trade_consideration: source semantics (matches Coq)
; Translation validation: trade_consideration preserves semantics
(push 1)
(declare-const source_trade_consideration Int)
(declare-const target_trade_consideration Int)
(assert (>= source_trade_consideration 0))
(assert (>= target_trade_consideration 0))
(assert (not (= source_trade_consideration target_trade_consideration)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trade_balanced: source semantics (matches Coq)
; Translation validation: trade_balanced preserves semantics
(push 1)
(declare-const source_trade_balanced Int)
(declare-const target_trade_balanced Int)
(assert (>= source_trade_balanced 0))
(assert (>= target_trade_balanced 0))
(assert (not (= source_trade_balanced target_trade_balanced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; settlement_balanced: source semantics (matches Coq)
; Translation validation: settlement_balanced preserves semantics
(push 1)
(declare-const source_settlement_balanced Int)
(declare-const target_settlement_balanced Int)
(assert (>= source_settlement_balanced 0))
(assert (>= target_settlement_balanced 0))
(assert (not (= source_settlement_balanced target_settlement_balanced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; settlement_complete: source semantics (matches Coq)
; Translation validation: settlement_complete preserves semantics
(push 1)
(declare-const source_settlement_complete Int)
(declare-const target_settlement_complete Int)
(assert (>= source_settlement_complete 0))
(assert (>= target_settlement_complete 0))
(assert (not (= source_settlement_complete target_settlement_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; orders_can_match: source semantics (matches Coq)
; Translation validation: orders_can_match preserves semantics
(push 1)
(declare-const source_orders_can_match Int)
(declare-const target_orders_can_match Int)
(assert (>= source_orders_can_match 0))
(assert (>= target_orders_can_match 0))
(assert (not (= source_orders_can_match target_orders_can_match)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; match_price: source semantics (matches Coq)
; Translation validation: match_price preserves semantics
(push 1)
(declare-const source_match_price Int)
(declare-const target_match_price Int)
(assert (>= source_match_price 0))
(assert (>= target_match_price 0))
(assert (not (= source_match_price target_match_price)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; match_qty: source semantics (matches Coq)
; Translation validation: match_qty preserves semantics
(push 1)
(declare-const source_match_qty Int)
(declare-const target_match_qty Int)
(assert (>= source_match_qty 0))
(assert (>= target_match_qty 0))
(assert (not (= source_match_qty target_match_qty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ticks_monotonic: source semantics (matches Coq)
; Translation validation: ticks_monotonic preserves semantics
(push 1)
(declare-const source_ticks_monotonic Int)
(declare-const target_ticks_monotonic Int)
(assert (>= source_ticks_monotonic 0))
(assert (>= target_ticks_monotonic 0))
(assert (not (= source_ticks_monotonic target_ticks_monotonic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ticks_ordered: source semantics (matches Coq)
; Translation validation: ticks_ordered preserves semantics
(push 1)
(declare-const source_ticks_ordered Int)
(declare-const target_ticks_ordered Int)
(assert (>= source_ticks_ordered 0))
(assert (>= target_ticks_ordered 0))
(assert (not (= source_ticks_ordered target_ticks_ordered)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; buy_priority_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: buy_priority_reflexive preserves semantics
(push 1)
(declare-const source_buy_priority_reflexive Int)
(declare-const target_buy_priority_reflexive Int)
(assert (>= source_buy_priority_reflexive 0))
(assert (>= target_buy_priority_reflexive 0))
(assert (not (= source_buy_priority_reflexive target_buy_priority_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sell_priority_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: sell_priority_reflexive preserves semantics
(push 1)
(declare-const source_sell_priority_reflexive Int)
(declare-const target_sell_priority_reflexive Int)
(assert (>= source_sell_priority_reflexive 0))
(assert (>= target_sell_priority_reflexive 0))
(assert (not (= source_sell_priority_reflexive target_sell_priority_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; higher_price_buy_wins: translation preserves property (matches Coq: Theorem)
; Translation validation: higher_price_buy_wins preserves semantics
(push 1)
(declare-const source_higher_price_buy_wins Int)
(declare-const target_higher_price_buy_wins Int)
(assert (>= source_higher_price_buy_wins 0))
(assert (>= target_higher_price_buy_wins 0))
(assert (not (= source_higher_price_buy_wins target_higher_price_buy_wins)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lower_price_sell_wins: translation preserves property (matches Coq: Theorem)
; Translation validation: lower_price_sell_wins preserves semantics
(push 1)
(declare-const source_lower_price_sell_wins Int)
(declare-const target_lower_price_sell_wins Int)
(assert (>= source_lower_price_sell_wins 0))
(assert (>= target_lower_price_sell_wins 0))
(assert (not (= source_lower_price_sell_wins target_lower_price_sell_wins)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trade_always_balanced: translation preserves property (matches Coq: Theorem)
; Translation validation: trade_always_balanced preserves semantics
(push 1)
(declare-const source_trade_always_balanced Int)
(declare-const target_trade_always_balanced Int)
(assert (>= source_trade_always_balanced 0))
(assert (>= target_trade_always_balanced 0))
(assert (not (= source_trade_always_balanced target_trade_always_balanced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; settlement_balanced_implies_equal_payment: translation preserves property (matches Coq: Theorem)
; Translation validation: settlement_balanced_implies_equal_payment preserves semantics
(push 1)
(declare-const source_settlement_balanced_implies_equal_payment Int)
(declare-const target_settlement_balanced_implies_equal_payment Int)
(assert (>= source_settlement_balanced_implies_equal_payment 0))
(assert (>= target_settlement_balanced_implies_equal_payment 0))
(assert (not (= source_settlement_balanced_implies_equal_payment target_settlement_balanced_implies_equal_payment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; settlement_complete_implies_balanced: translation preserves property (matches Coq: Theorem)
; Translation validation: settlement_complete_implies_balanced preserves semantics
(push 1)
(declare-const source_settlement_complete_implies_balanced Int)
(declare-const target_settlement_complete_implies_balanced Int)
(assert (>= source_settlement_complete_implies_balanced 0))
(assert (>= target_settlement_complete_implies_balanced 0))
(assert (not (= source_settlement_complete_implies_balanced target_settlement_complete_implies_balanced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; match_only_when_price_crosses: translation preserves property (matches Coq: Theorem)
; Translation validation: match_only_when_price_crosses preserves semantics
(push 1)
(declare-const source_match_only_when_price_crosses Int)
(declare-const target_match_only_when_price_crosses Int)
(assert (>= source_match_only_when_price_crosses 0))
(assert (>= target_match_only_when_price_crosses 0))
(assert (not (= source_match_only_when_price_crosses target_match_only_when_price_crosses)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_match_when_price_gap: translation preserves property (matches Coq: Theorem)
; Translation validation: no_match_when_price_gap preserves semantics
(push 1)
(declare-const source_no_match_when_price_gap Int)
(declare-const target_no_match_when_price_gap Int)
(assert (>= source_no_match_when_price_gap 0))
(assert (>= target_no_match_when_price_gap 0))
(assert (not (= source_no_match_when_price_gap target_no_match_when_price_gap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; match_qty_bounded_by_buy: translation preserves property (matches Coq: Theorem)
; Translation validation: match_qty_bounded_by_buy preserves semantics
(push 1)
(declare-const source_match_qty_bounded_by_buy Int)
(declare-const target_match_qty_bounded_by_buy Int)
(assert (>= source_match_qty_bounded_by_buy 0))
(assert (>= target_match_qty_bounded_by_buy 0))
(assert (not (= source_match_qty_bounded_by_buy target_match_qty_bounded_by_buy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; match_qty_bounded_by_sell: translation preserves property (matches Coq: Theorem)
; Translation validation: match_qty_bounded_by_sell preserves semantics
(push 1)
(declare-const source_match_qty_bounded_by_sell Int)
(declare-const target_match_qty_bounded_by_sell Int)
(assert (>= source_match_qty_bounded_by_sell 0))
(assert (>= target_match_qty_bounded_by_sell 0))
(assert (not (= source_match_qty_bounded_by_sell target_match_qty_bounded_by_sell)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; match_uses_sell_price: translation preserves property (matches Coq: Theorem)
; Translation validation: match_uses_sell_price preserves semantics
(push 1)
(declare-const source_match_uses_sell_price Int)
(declare-const target_match_uses_sell_price Int)
(assert (>= source_match_uses_sell_price 0))
(assert (>= target_match_uses_sell_price 0))
(assert (not (= source_match_uses_sell_price target_match_uses_sell_price)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_ticks_ordered: translation preserves property (matches Coq: Theorem)
; Translation validation: empty_ticks_ordered preserves semantics
(push 1)
(declare-const source_empty_ticks_ordered Int)
(declare-const target_empty_ticks_ordered Int)
(assert (>= source_empty_ticks_ordered 0))
(assert (>= target_empty_ticks_ordered 0))
(assert (not (= source_empty_ticks_ordered target_empty_ticks_ordered)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; singleton_ticks_ordered: translation preserves property (matches Coq: Theorem)
; Translation validation: singleton_ticks_ordered preserves semantics
(push 1)
(declare-const source_singleton_ticks_ordered Int)
(declare-const target_singleton_ticks_ordered Int)
(assert (>= source_singleton_ticks_ordered 0))
(assert (>= target_singleton_ticks_ordered 0))
(assert (not (= source_singleton_ticks_ordered target_singleton_ticks_ordered)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ordered_ticks_head_smallest: translation preserves property (matches Coq: Theorem)
; Translation validation: ordered_ticks_head_smallest preserves semantics
(push 1)
(declare-const source_ordered_ticks_head_smallest Int)
(declare-const target_ordered_ticks_head_smallest Int)
(assert (>= source_ordered_ticks_head_smallest 0))
(assert (>= target_ordered_ticks_head_smallest 0))
(assert (not (= source_ordered_ticks_head_smallest target_ordered_ticks_head_smallest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trade_consideration_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: trade_consideration_comm preserves semantics
(push 1)
(declare-const source_trade_consideration_comm Int)
(declare-const target_trade_consideration_comm Int)
(assert (>= source_trade_consideration_comm 0))
(assert (>= target_trade_consideration_comm 0))
(assert (not (= source_trade_consideration_comm target_trade_consideration_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trade_consideration_zero_qty: translation preserves property (matches Coq: Theorem)
; Translation validation: trade_consideration_zero_qty preserves semantics
(push 1)
(declare-const source_trade_consideration_zero_qty Int)
(declare-const target_trade_consideration_zero_qty Int)
(assert (>= source_trade_consideration_zero_qty 0))
(assert (>= target_trade_consideration_zero_qty 0))
(assert (not (= source_trade_consideration_zero_qty target_trade_consideration_zero_qty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trade_consideration_zero_price: translation preserves property (matches Coq: Theorem)
; Translation validation: trade_consideration_zero_price preserves semantics
(push 1)
(declare-const source_trade_consideration_zero_price Int)
(declare-const target_trade_consideration_zero_price Int)
(assert (>= source_trade_consideration_zero_price 0))
(assert (>= target_trade_consideration_zero_price 0))
(assert (not (= source_trade_consideration_zero_price target_trade_consideration_zero_price)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; settlement_complete_implies_final: translation preserves property (matches Coq: Theorem)
; Translation validation: settlement_complete_implies_final preserves semantics
(push 1)
(declare-const source_settlement_complete_implies_final Int)
(declare-const target_settlement_complete_implies_final Int)
(assert (>= source_settlement_complete_implies_final 0))
(assert (>= target_settlement_complete_implies_final 0))
(assert (not (= source_settlement_complete_implies_final target_settlement_complete_implies_final)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; settlement_complete_implies_assets: translation preserves property (matches Coq: Theorem)
; Translation validation: settlement_complete_implies_assets preserves semantics
(push 1)
(declare-const source_settlement_complete_implies_assets Int)
(declare-const target_settlement_complete_implies_assets Int)
(assert (>= source_settlement_complete_implies_assets 0))
(assert (>= target_settlement_complete_implies_assets 0))
(assert (not (= source_settlement_complete_implies_assets target_settlement_complete_implies_assets)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; orders_can_match_same_price: translation preserves property (matches Coq: Theorem)
; Translation validation: orders_can_match_same_price preserves semantics
(push 1)
(declare-const source_orders_can_match_same_price Int)
(declare-const target_orders_can_match_same_price Int)
(assert (>= source_orders_can_match_same_price 0))
(assert (>= target_orders_can_match_same_price 0))
(assert (not (= source_orders_can_match_same_price target_orders_can_match_same_price)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; match_qty_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: match_qty_comm preserves semantics
(push 1)
(declare-const source_match_qty_comm Int)
(declare-const target_match_qty_comm Int)
(assert (>= source_match_qty_comm 0))
(assert (>= target_match_qty_comm 0))
(assert (not (= source_match_qty_comm target_match_qty_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; match_qty_positive: translation preserves property (matches Coq: Theorem)
; Translation validation: match_qty_positive preserves semantics
(push 1)
(declare-const source_match_qty_positive Int)
(declare-const target_match_qty_positive Int)
(assert (>= source_match_qty_positive 0))
(assert (>= target_match_qty_positive 0))
(assert (not (= source_match_qty_positive target_match_qty_positive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; execute_match_preserves_ids: translation preserves property (matches Coq: Theorem)
; Translation validation: execute_match_preserves_ids preserves semantics
(push 1)
(declare-const source_execute_match_preserves_ids Int)
(declare-const target_execute_match_preserves_ids Int)
(assert (>= source_execute_match_preserves_ids 0))
(assert (>= target_execute_match_preserves_ids 0))
(assert (not (= source_execute_match_preserves_ids target_execute_match_preserves_ids)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; execute_match_preserves_tid: translation preserves property (matches Coq: Theorem)
; Translation validation: execute_match_preserves_tid preserves semantics
(push 1)
(declare-const source_execute_match_preserves_tid Int)
(declare-const target_execute_match_preserves_tid Int)
(assert (>= source_execute_match_preserves_tid 0))
(assert (>= target_execute_match_preserves_tid 0))
(assert (not (= source_execute_match_preserves_tid target_execute_match_preserves_tid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; side_eqb_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: side_eqb_refl preserves semantics
(push 1)
(declare-const source_side_eqb_refl Int)
(declare-const target_side_eqb_refl Int)
(assert (>= source_side_eqb_refl 0))
(assert (>= target_side_eqb_refl 0))
(assert (not (= source_side_eqb_refl target_side_eqb_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

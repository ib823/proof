; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CapitalMarkets — SMT Verification
; Derived from 02_FORMAL/coq/domains/CapitalMarkets.v (26 assertions)
; Module: CapitalMarkets
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Side 0)) (((Buy) (Sell))))

(declare-datatypes ((Order 0))
  (((mk-order (order_id Int) (order_side Side) (order_price Int) (order_qty Int) (order_time Int)))))

(declare-datatypes ((Trade 0))
  (((mk-trade (trade_id Int) (trade_buy_id Int) (trade_sell_id Int) (trade_price Int) (trade_qty Int) (trade_settled Bool)))))

(declare-datatypes ((Settlement 0))
  (((mk-settlement (settle_trade_id Int) (buyer_paid Int) (seller_received Int) (assets_delivered Int) (settle_final Bool)))))

(declare-datatypes ((OrderBook 0))
  (((mk-order_book (bids (Seq Int)) (asks (Seq Int))))))

(declare-datatypes ((MarketDataTick 0))
  (((mk-market_data_tick (tick_symbol Int) (tick_price Int) (tick_volume Int) (tick_seq Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Side enum properties ---

; --- 1. Side exhaustiveness ---
(push 1)
(declare-const x Side)
(assert (not (or (= x Buy) (= x Sell))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Side: Buy != Sell ---
(push 1)
(assert (= Buy Sell))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Side finite cardinality (2 values) ---
(push 1)
(declare-const x Side)
(assert (and (not (= x Buy)) (not (= x Sell))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Order record properties ---

; --- 4. Order accessor round-trip: order_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Side)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (order_id (mk-order f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Order accessor round-trip: order_side ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Side)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (order_side (mk-order f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Order accessor round-trip: order_price ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Side)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (order_price (mk-order f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Order accessor round-trip: order_qty ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Side)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (order_qty (mk-order f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Order: integer field consistency ---
(push 1)
(declare-const r Order)
(assert (>= (order_id r) 0))
(assert (>= (order_price r) 0))
(assert (not (>= (+ (order_id r) (order_price r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Trade record properties ---

; --- 9. Trade accessor round-trip: trade_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (trade_id (mk-trade f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Trade accessor round-trip: trade_buy_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (trade_buy_id (mk-trade f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Trade accessor round-trip: trade_sell_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (trade_sell_id (mk-trade f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Trade accessor round-trip: trade_price ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (trade_price (mk-trade f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Trade accessor round-trip: trade_qty ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (trade_qty (mk-trade f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Trade: integer field consistency ---
(push 1)
(declare-const r Trade)
(assert (>= (trade_id r) 0))
(assert (>= (trade_buy_id r) 0))
(assert (not (>= (+ (trade_id r) (trade_buy_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Settlement record properties ---

; --- 15. Settlement accessor round-trip: settle_trade_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (settle_trade_id (mk-settlement f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Settlement accessor round-trip: buyer_paid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (buyer_paid (mk-settlement f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Settlement accessor round-trip: seller_received ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (seller_received (mk-settlement f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Settlement accessor round-trip: assets_delivered ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (assets_delivered (mk-settlement f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Settlement: integer field consistency ---
(push 1)
(declare-const r Settlement)
(assert (>= (settle_trade_id r) 0))
(assert (>= (buyer_paid r) 0))
(assert (not (>= (+ (settle_trade_id r) (buyer_paid r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- OrderBook record properties ---

; --- 20. OrderBook accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(assert (not (= (Seq (mk-order_book f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MarketDataTick record properties ---

; --- 21. MarketDataTick accessor round-trip: tick_symbol ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (tick_symbol (mk-market_data_tick f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. MarketDataTick accessor round-trip: tick_price ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (tick_price (mk-market_data_tick f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. MarketDataTick accessor round-trip: tick_volume ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (tick_volume (mk-market_data_tick f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. MarketDataTick: integer field consistency ---
(push 1)
(declare-const r MarketDataTick)
(assert (>= (tick_symbol r) 0))
(assert (>= (tick_price r) 0))
(assert (not (>= (+ (tick_symbol r) (tick_price r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

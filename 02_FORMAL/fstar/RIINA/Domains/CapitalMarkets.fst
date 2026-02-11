(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CapitalMarkets

open FStar.All

type market_guard = {
  best_execution_enforced: bool;
  market_abuse_controls: bool;
  post_trade_audit: bool;
  max_settlement_delay_days: nat;
}

let market_guard_valid (g: market_guard) : Tot bool =
  g.best_execution_enforced
  && g.market_abuse_controls
  && g.post_trade_audit
  && g.max_settlement_delay_days <= 2

let baseline_market_guard : market_guard = {
  best_execution_enforced = true;
  market_abuse_controls = true;
  post_trade_audit = true;
  max_settlement_delay_days = 2;
}

let baseline_market_guard_valid =
  market_guard_valid baseline_market_guard

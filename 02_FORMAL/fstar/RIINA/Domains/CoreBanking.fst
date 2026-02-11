(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CoreBanking

open FStar.All

type ledger_guard = {
  double_entry_preserved: bool;
  balance_never_negative: bool;
  tx_order_deterministic: bool;
  reconciliation_complete: bool;
}

let ledger_guard_valid (g: ledger_guard) : Tot bool =
  g.double_entry_preserved
  && g.balance_never_negative
  && g.tx_order_deterministic
  && g.reconciliation_complete

let baseline_ledger_guard : ledger_guard = {
  double_entry_preserved = true;
  balance_never_negative = true;
  tx_order_deterministic = true;
  reconciliation_complete = true;
}

let baseline_ledger_guard_valid =
  ledger_guard_valid baseline_ledger_guard

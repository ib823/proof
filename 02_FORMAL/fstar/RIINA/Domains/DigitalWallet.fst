(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.DigitalWallet

open FStar.All

type wallet_guard = {
  key_storage_hardened: bool;
  tx_auth_strong: bool;
  anti_replay_enabled: bool;
  settlement_atomic: bool;
}

let wallet_secure (g: wallet_guard) : Tot bool =
  g.key_storage_hardened
  && g.tx_auth_strong
  && g.anti_replay_enabled
  && g.settlement_atomic

let baseline_wallet_guard : wallet_guard = {
  key_storage_hardened = true;
  tx_auth_strong = true;
  anti_replay_enabled = true;
  settlement_atomic = true;
}

let baseline_wallet_secure =
  wallet_secure baseline_wallet_guard

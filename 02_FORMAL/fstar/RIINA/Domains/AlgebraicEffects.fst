(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.AlgebraicEffects

open FStar.All

type effect_budget = {
  io_tokens: nat;
  net_tokens: nat;
  crypto_tokens: nat;
}

let effect_budget_valid (b: effect_budget) : Tot bool =
  b.io_tokens >= 1
  && b.net_tokens >= 1
  && b.crypto_tokens >= 1

let baseline_effect_budget : effect_budget = {
  io_tokens = 1;
  net_tokens = 1;
  crypto_tokens = 1;
}

let hardened_effect_budget : effect_budget = {
  io_tokens = 2;
  net_tokens = 2;
  crypto_tokens = 2;
}

let baseline_effect_budget_valid =
  effect_budget_valid baseline_effect_budget

let hardened_effect_budget_not_weaker =
  effect_budget_valid hardened_effect_budget
  && hardened_effect_budget.io_tokens >= baseline_effect_budget.io_tokens
  && hardened_effect_budget.net_tokens >= baseline_effect_budget.net_tokens
  && hardened_effect_budget.crypto_tokens >= baseline_effect_budget.crypto_tokens

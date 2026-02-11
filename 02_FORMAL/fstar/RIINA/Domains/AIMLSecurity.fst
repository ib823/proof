(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.AIMLSecurity

open FStar.All

type ai_ml_policy = {
  model_integrity_checked: bool;
  input_sanitized: bool;
  privacy_budget_units: nat;
}

let ai_ml_policy_secure (p: ai_ml_policy) : Tot bool =
  p.model_integrity_checked
  && p.input_sanitized
  && p.privacy_budget_units >= 1

let baseline_ai_ml_policy : ai_ml_policy = {
  model_integrity_checked = true;
  input_sanitized = true;
  privacy_budget_units = 1;
}

let hardened_ai_ml_policy : ai_ml_policy = {
  model_integrity_checked = true;
  input_sanitized = true;
  privacy_budget_units = 2;
}

let baseline_ai_ml_policy_secure =
  ai_ml_policy_secure baseline_ai_ml_policy

let hardened_ai_ml_not_weaker =
  ai_ml_policy_secure hardened_ai_ml_policy
  && hardened_ai_ml_policy.privacy_budget_units >= baseline_ai_ml_policy.privacy_budget_units

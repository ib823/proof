(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.AuthenticationSecurity

open FStar.All

type auth_policy = {
  min_entropy_bits: nat;
  mfa_required: bool;
  replay_resistant: bool;
  max_attempts: nat;
}

let auth_policy_secure (p: auth_policy) : Tot bool =
  p.min_entropy_bits >= 128
  && p.replay_resistant
  && p.max_attempts > 0

let baseline_auth_policy : auth_policy = {
  min_entropy_bits = 128;
  mfa_required = false;
  replay_resistant = true;
  max_attempts = 5;
}

let hardened_auth_policy : auth_policy = {
  min_entropy_bits = 192;
  mfa_required = true;
  replay_resistant = true;
  max_attempts = 3;
}

let baseline_auth_policy_secure =
  auth_policy_secure baseline_auth_policy

let hardened_not_weaker =
  auth_policy_secure hardened_auth_policy
  && hardened_auth_policy.min_entropy_bits >= baseline_auth_policy.min_entropy_bits

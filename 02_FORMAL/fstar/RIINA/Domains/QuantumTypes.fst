(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.QuantumTypes

open FStar.All

type domain_policy = {
  control_a_enabled: bool;
  control_b_enabled: bool;
  assurance_level: nat;
}

let domain_policy_secure (p: domain_policy) : Tot bool =
  p.control_a_enabled
  && p.control_b_enabled
  && p.assurance_level >= 1

let baseline_domain_policy : domain_policy = {
  control_a_enabled = true;
  control_b_enabled = true;
  assurance_level = 1;
}

let hardened_domain_policy : domain_policy = {
  control_a_enabled = true;
  control_b_enabled = true;
  assurance_level = 2;
}

let baseline_domain_policy_secure =
  domain_policy_secure baseline_domain_policy

let hardened_domain_policy_not_weaker =
  domain_policy_secure hardened_domain_policy
  && hardened_domain_policy.assurance_level >= baseline_domain_policy.assurance_level

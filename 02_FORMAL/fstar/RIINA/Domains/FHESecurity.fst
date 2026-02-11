(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.FHESecurity

open FStar.All

type fhe_security_profile = {
  ciphertext_integrity_checked: bool;
  key_switching_verified: bool;
  noise_budget_sufficient: bool;
  parameter_set_validated: bool;
}

let fhe_security_profile_secure (p: fhe_security_profile) : Tot bool =
  p.ciphertext_integrity_checked
  && p.key_switching_verified
  && p.noise_budget_sufficient
  && p.parameter_set_validated

let baseline_fhe_security : fhe_security_profile = {
  ciphertext_integrity_checked = true;
  key_switching_verified = true;
  noise_budget_sufficient = true;
  parameter_set_validated = true;
}

let hardened_fhe_security : fhe_security_profile = {
  ciphertext_integrity_checked = true;
  key_switching_verified = true;
  noise_budget_sufficient = true;
  parameter_set_validated = true;
}

let baseline_fhe_security_secure =
  fhe_security_profile_secure baseline_fhe_security

let hardened_fhe_security_secure =
  fhe_security_profile_secure hardened_fhe_security

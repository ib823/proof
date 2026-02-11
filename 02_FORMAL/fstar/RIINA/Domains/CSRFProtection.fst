(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CSRFProtection

open FStar.All

type csrf_policy = {
  token_bound_to_session: bool;
  token_rotated_on_login: bool;
  same_site_enforced: bool;
}

let csrf_policy_secure (p: csrf_policy) : Tot bool =
  p.token_bound_to_session
  && p.token_rotated_on_login
  && p.same_site_enforced

let baseline_csrf_policy : csrf_policy = {
  token_bound_to_session = true;
  token_rotated_on_login = true;
  same_site_enforced = true;
}

let hardened_csrf_policy : csrf_policy = {
  token_bound_to_session = true;
  token_rotated_on_login = true;
  same_site_enforced = true;
}

let baseline_csrf_secure =
  csrf_policy_secure baseline_csrf_policy

let hardened_csrf_secure =
  csrf_policy_secure hardened_csrf_policy

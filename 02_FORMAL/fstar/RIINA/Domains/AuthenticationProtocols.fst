(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.AuthenticationProtocols

open FStar.All

type session_config = {
  token_entropy_bits: nat;
  token_ttl_seconds: nat;
  rotate_on_use: bool;
  require_mfa: bool;
}

let valid_session_config (c: session_config) : Tot bool =
  c.token_entropy_bits >= 128
  && c.token_ttl_seconds > 0
  && c.token_ttl_seconds <= 86400

let baseline_session_config : session_config = {
  token_entropy_bits = 128;
  token_ttl_seconds = 3600;
  rotate_on_use = true;
  require_mfa = false;
}

let hardened_session_config : session_config = {
  token_entropy_bits = 192;
  token_ttl_seconds = 900;
  rotate_on_use = true;
  require_mfa = true;
}

let baseline_session_config_valid () : Lemma
  (ensures (valid_session_config baseline_session_config)) =
  ()

let hardened_session_config_valid () : Lemma
  (ensures (valid_session_config hardened_session_config)) =
  ()

let hardened_entropy_not_weaker () : Lemma
  (ensures (hardened_session_config.token_entropy_bits >= baseline_session_config.token_entropy_bits)) =
  ()

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.NetworkSecurity

open FStar.All

type network_guard = {
  tls13_only: bool;
  replay_protected: bool;
  mtls_required: bool;
  max_payload_bytes: nat;
}

let network_secure (g: network_guard) : Tot bool =
  g.tls13_only
  && g.replay_protected
  && g.mtls_required
  && g.max_payload_bytes > 0

let edge_guard : network_guard = {
  tls13_only = true;
  replay_protected = true;
  mtls_required = true;
  max_payload_bytes = 16384;
}

let network_guard_secure =
  network_secure edge_guard

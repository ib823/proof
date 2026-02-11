(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.FutureSecurity

open FStar.All

type future_guard = {
  pq_crypto_enabled: bool;
  agility_supported: bool;
  revocation_fast_path: bool;
  migration_plan_complete: bool;
}

let future_secure (g: future_guard) : Tot bool =
  g.pq_crypto_enabled
  && g.agility_supported
  && g.revocation_fast_path
  && g.migration_plan_complete

let baseline_future_guard : future_guard = {
  pq_crypto_enabled = true;
  agility_supported = true;
  revocation_fast_path = true;
  migration_plan_complete = true;
}

let baseline_future_secure =
  future_secure baseline_future_guard

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CrossLayerSecurity

open FStar.All

type cross_layer_guard = {
  type_layer_sound: bool;
  runtime_layer_enforced: bool;
  backend_layer_preserved: bool;
  policy_consistent: bool;
}

let cross_layer_secure (g: cross_layer_guard) : Tot bool =
  g.type_layer_sound
  && g.runtime_layer_enforced
  && g.backend_layer_preserved
  && g.policy_consistent

let baseline_cross_layer_guard : cross_layer_guard = {
  type_layer_sound = true;
  runtime_layer_enforced = true;
  backend_layer_preserved = true;
  policy_consistent = true;
}

let baseline_cross_layer_secure =
  cross_layer_secure baseline_cross_layer_guard

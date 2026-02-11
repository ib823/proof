(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.KeyLifecycle

open FStar.All

type key_state =
  | Generated
  | Active
  | Rotated
  | Retired
  | Destroyed

let transition_ok (from: key_state) (to_: key_state) : Tot bool =
  match from, to_ with
  | Generated, Active -> true
  | Active, Rotated -> true
  | Active, Retired -> true
  | Rotated, Retired -> true
  | Retired, Destroyed -> true
  | _, _ -> false

let generated_not_destroyed_directly =
  not (transition_ok Generated Destroyed)

let destroyed_terminal (s: key_state) =
  not (transition_ok Destroyed s)

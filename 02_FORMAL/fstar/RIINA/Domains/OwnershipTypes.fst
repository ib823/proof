(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.OwnershipTypes

open FStar.All

type owner_state =
  | Owned
  | Moved
  | Dropped

let transition_ok (from: owner_state) (to_: owner_state) : Tot bool =
  match from, to_ with
  | Owned, Moved -> true
  | Owned, Dropped -> true
  | Moved, Dropped -> true
  | _, _ -> false

let no_move_after_move =
  not (transition_ok Moved Moved)

let dropped_terminal (s: owner_state) =
  not (transition_ok Dropped s)

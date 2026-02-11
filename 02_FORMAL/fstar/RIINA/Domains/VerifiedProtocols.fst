(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.VerifiedProtocols

open FStar.All

type protocol_state =
  | Init
  | Authenticated
  | Closed

let step_ok (s1: protocol_state) (s2: protocol_state) : Tot bool =
  match s1, s2 with
  | Init, Init -> true
  | Init, Authenticated -> true
  | Authenticated, Authenticated -> true
  | Authenticated, Closed -> true
  | Closed, Closed -> true
  | _, _ -> false

let no_init_to_closed () : Lemma
  (ensures (not (step_ok Init Closed))) =
  ()

let closure_requires_auth (s: protocol_state) : Lemma
  (requires (step_ok s Closed))
  (ensures (s == Authenticated \/ s == Closed)) =
  ()

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.ConstantTimeCrypto

open FStar.All

type ct_trace = {
  branch_on_secret: bool;
  addr_on_secret: bool;
  cycle_upper_bound: nat;
}

let valid_ct_trace (t: ct_trace) : Tot bool =
  (not t.branch_on_secret)
  && (not t.addr_on_secret)
  && t.cycle_upper_bound > 0

let merge_trace (a: ct_trace) (b: ct_trace) : Tot ct_trace = {
  branch_on_secret = a.branch_on_secret || b.branch_on_secret;
  addr_on_secret = a.addr_on_secret || b.addr_on_secret;
  cycle_upper_bound = if a.cycle_upper_bound >= b.cycle_upper_bound then a.cycle_upper_bound else b.cycle_upper_bound;
}

let merge_preserves_ct (a: ct_trace) (b: ct_trace) : Lemma
  (requires (valid_ct_trace a /\ valid_ct_trace b))
  (ensures (valid_ct_trace (merge_trace a b))) =
  ()

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CovertChannels

open FStar.All

type covert_channel_guard = {
  timing_channel_blocked: bool;
  cache_channel_blocked: bool;
  bandwidth_limited: bool;
  residual_leakage_bits: nat;
}

let covert_channel_resistant (g: covert_channel_guard) : Tot bool =
  g.timing_channel_blocked
  && g.cache_channel_blocked
  && g.bandwidth_limited
  && g.residual_leakage_bits = 0

let baseline_covert_channel_guard : covert_channel_guard = {
  timing_channel_blocked = true;
  cache_channel_blocked = true;
  bandwidth_limited = true;
  residual_leakage_bits = 0;
}

let baseline_covert_channel_resistant =
  covert_channel_resistant baseline_covert_channel_guard

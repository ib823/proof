(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CovertChannelElimination

open FStar.All

type covert_channel_profile = {
  timing_variance_bounded: bool;
  cache_access_pattern_constant: bool;
  message_size_padding_enabled: bool;
  scheduler_noise_hardened: bool;
}

let covert_channel_profile_secure (p: covert_channel_profile) : Tot bool =
  p.timing_variance_bounded
  && p.cache_access_pattern_constant
  && p.message_size_padding_enabled
  && p.scheduler_noise_hardened

let baseline_covert_channel_profile : covert_channel_profile = {
  timing_variance_bounded = true;
  cache_access_pattern_constant = true;
  message_size_padding_enabled = true;
  scheduler_noise_hardened = true;
}

let hardened_covert_channel_profile : covert_channel_profile = {
  timing_variance_bounded = true;
  cache_access_pattern_constant = true;
  message_size_padding_enabled = true;
  scheduler_noise_hardened = true;
}

let baseline_covert_channel_secure =
  covert_channel_profile_secure baseline_covert_channel_profile

let hardened_covert_channel_secure =
  covert_channel_profile_secure hardened_covert_channel_profile

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.AnonymousComm

open FStar.All

type anonymity_profile = {
  sender_hidden: bool;
  receiver_hidden: bool;
  metadata_minimized: bool;
  relay_hops: nat;
}

let anonymity_profile_secure (p: anonymity_profile) : Tot bool =
  p.sender_hidden
  && p.receiver_hidden
  && p.metadata_minimized
  && p.relay_hops >= 1

let baseline_anonymity_profile : anonymity_profile = {
  sender_hidden = true;
  receiver_hidden = true;
  metadata_minimized = true;
  relay_hops = 1;
}

let hardened_anonymity_profile : anonymity_profile = {
  sender_hidden = true;
  receiver_hidden = true;
  metadata_minimized = true;
  relay_hops = 3;
}

let baseline_anonymity_secure =
  anonymity_profile_secure baseline_anonymity_profile

let hardened_anonymity_not_weaker =
  anonymity_profile_secure hardened_anonymity_profile
  && hardened_anonymity_profile.relay_hops >= baseline_anonymity_profile.relay_hops

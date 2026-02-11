(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.NetworkDefense

open FStar.All

type network_defense_profile = {
  ingress_filtering_enabled: bool;
  egress_filtering_enabled: bool;
  ids_enabled: bool;
  max_open_ports: nat;
}

let network_defense_profile_secure (p: network_defense_profile) : Tot bool =
  p.ingress_filtering_enabled
  && p.egress_filtering_enabled
  && p.ids_enabled
  && p.max_open_ports >= 1

let baseline_network_defense : network_defense_profile = {
  ingress_filtering_enabled = true;
  egress_filtering_enabled = true;
  ids_enabled = true;
  max_open_ports = 8;
}

let hardened_network_defense : network_defense_profile = {
  ingress_filtering_enabled = true;
  egress_filtering_enabled = true;
  ids_enabled = true;
  max_open_ports = 4;
}

let baseline_network_defense_secure =
  network_defense_profile_secure baseline_network_defense

let hardened_network_defense_secure =
  network_defense_profile_secure hardened_network_defense

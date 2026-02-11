(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.MemorySafety

open FStar.All

type memory_region = {
  bytes: nat;
  in_bounds: bool;
  no_uaf: bool;
  no_double_free: bool;
}

let memory_safe (r: memory_region) : Tot bool =
  r.bytes > 0
  && r.in_bounds
  && r.no_uaf
  && r.no_double_free

let baseline_region : memory_region = {
  bytes = 64;
  in_bounds = true;
  no_uaf = true;
  no_double_free = true;
}

let hardened_region : memory_region = {
  bytes = 256;
  in_bounds = true;
  no_uaf = true;
  no_double_free = true;
}

let baseline_region_safe =
  memory_safe baseline_region

let hardened_not_weaker =
  memory_safe hardened_region
  && hardened_region.bytes >= baseline_region.bytes

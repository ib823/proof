(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.VerifiedIsolation

open FStar.All

type isolation_profile = {
  process_isolation_enforced: bool;
  memory_isolation_enforced: bool;
  io_isolation_enforced: bool;
  compartment_count: nat;
}

let isolation_profile_secure (p: isolation_profile) : Tot bool =
  p.process_isolation_enforced
  && p.memory_isolation_enforced
  && p.io_isolation_enforced
  && p.compartment_count >= 1

let baseline_isolation_profile : isolation_profile = {
  process_isolation_enforced = true;
  memory_isolation_enforced = true;
  io_isolation_enforced = true;
  compartment_count = 1;
}

let hardened_isolation_profile : isolation_profile = {
  process_isolation_enforced = true;
  memory_isolation_enforced = true;
  io_isolation_enforced = true;
  compartment_count = 2;
}

let baseline_isolation_secure =
  isolation_profile_secure baseline_isolation_profile

let hardened_isolation_not_weaker =
  isolation_profile_secure hardened_isolation_profile
  && hardened_isolation_profile.compartment_count >= baseline_isolation_profile.compartment_count

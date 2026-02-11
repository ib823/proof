(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.LinearTypes

open FStar.All

type linear_resource_profile = {
  acquired_resources: nat;
  released_resources: nat;
  duplicates_prevented: bool;
}

let linear_resource_profile_sound (p: linear_resource_profile) : Tot bool =
  p.duplicates_prevented
  && p.acquired_resources = p.released_resources

let baseline_linear_profile : linear_resource_profile = {
  acquired_resources = 1;
  released_resources = 1;
  duplicates_prevented = true;
}

let hardened_linear_profile : linear_resource_profile = {
  acquired_resources = 2;
  released_resources = 2;
  duplicates_prevented = true;
}

let baseline_linear_profile_sound =
  linear_resource_profile_sound baseline_linear_profile

let hardened_linear_profile_sound =
  linear_resource_profile_sound hardened_linear_profile

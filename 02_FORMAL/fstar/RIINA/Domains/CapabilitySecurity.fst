(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CapabilitySecurity

open FStar.All

type capability = {
  can_read: bool;
  can_write: bool;
  can_execute: bool;
  lease_seconds: nat;
  unforgeable: bool;
}

let capability_valid (c: capability) : Tot bool =
  c.unforgeable
  && c.lease_seconds > 0
  && (c.can_read || c.can_write || c.can_execute)

let baseline_capability : capability = {
  can_read = true;
  can_write = false;
  can_execute = false;
  lease_seconds = 300;
  unforgeable = true;
}

let elevated_capability : capability = {
  can_read = true;
  can_write = true;
  can_execute = false;
  lease_seconds = 120;
  unforgeable = true;
}

let baseline_capability_valid =
  capability_valid baseline_capability

let elevated_capability_valid =
  capability_valid elevated_capability

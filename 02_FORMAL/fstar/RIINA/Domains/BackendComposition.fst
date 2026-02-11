(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.BackendComposition

open FStar.All

type backend_kind =
  | Native
  | Wasm
  | Ebpf
  | Sgx

type backend_bundle = {
  target_count: nat;
  deterministic_passes: bool;
  security_preserved: bool;
}

let valid_backend_bundle (b: backend_bundle) : Tot bool =
  b.target_count >= 1
  && b.deterministic_passes
  && b.security_preserved

let baseline_bundle : backend_bundle = {
  target_count = 1;
  deterministic_passes = true;
  security_preserved = true;
}

let full_target_bundle : backend_bundle = {
  target_count = 4;
  deterministic_passes = true;
  security_preserved = true;
}

let baseline_bundle_valid =
  valid_backend_bundle baseline_bundle

let full_bundle_dominates_baseline =
  valid_backend_bundle full_target_bundle
  && full_target_bundle.target_count >= baseline_bundle.target_count

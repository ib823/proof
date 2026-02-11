(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.BinarySizeBounds

open FStar.All

type size_budget = {
  code_bytes: nat;
  metadata_bytes: nat;
  max_total_bytes: nat;
}

let total_bytes (b: size_budget) : Tot nat =
  b.code_bytes + b.metadata_bytes

let within_budget (b: size_budget) : Tot bool =
  b.max_total_bytes > 0
  && total_bytes b <= b.max_total_bytes

let baseline_size_budget : size_budget = {
  code_bytes = 200000;
  metadata_bytes = 10000;
  max_total_bytes = 250000;
}

let baseline_within_budget =
  within_budget baseline_size_budget

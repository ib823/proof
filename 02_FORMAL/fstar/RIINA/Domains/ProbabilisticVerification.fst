(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.ProbabilisticVerification

open FStar.All

type probabilistic_bound = {
  failure_numerator: nat;
  failure_denominator: nat;
  confidence_threshold_met: bool;
}

let probabilistic_bound_valid (b: probabilistic_bound) : Tot bool =
  b.failure_denominator > 0
  && b.failure_numerator <= b.failure_denominator
  && b.confidence_threshold_met

let baseline_probabilistic_bound : probabilistic_bound = {
  failure_numerator = 1;
  failure_denominator = 1000;
  confidence_threshold_met = true;
}

let hardened_probabilistic_bound : probabilistic_bound = {
  failure_numerator = 1;
  failure_denominator = 10000;
  confidence_threshold_met = true;
}

let baseline_probabilistic_bound_valid =
  probabilistic_bound_valid baseline_probabilistic_bound

let hardened_probabilistic_bound_valid =
  probabilistic_bound_valid hardened_probabilistic_bound

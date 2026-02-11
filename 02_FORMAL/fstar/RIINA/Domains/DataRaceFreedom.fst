(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.DataRaceFreedom

open FStar.All

type race_report = {
  shared_regions: nat;
  conflicting_writes: bool;
  lock_discipline: bool;
  atomic_required_paths: bool;
}

let race_free (r: race_report) : Tot bool =
  (not r.conflicting_writes)
  && r.lock_discipline
  && r.atomic_required_paths

let baseline_race_report : race_report = {
  shared_regions = 2;
  conflicting_writes = false;
  lock_discipline = true;
  atomic_required_paths = true;
}

let hardened_race_report : race_report = {
  shared_regions = 4;
  conflicting_writes = false;
  lock_discipline = true;
  atomic_required_paths = true;
}

let baseline_race_free =
  race_free baseline_race_report

let hardened_race_free =
  race_free hardened_race_report

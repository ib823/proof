(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CompilerCorrectness

open FStar.All

type compilation_report = {
  source_well_typed: bool;
  target_semantics_preserved: bool;
  translation_validated: bool;
  target_count: nat;
}

let valid_compilation_report (r: compilation_report) : Tot bool =
  r.source_well_typed
  && r.target_semantics_preserved
  && r.translation_validated
  && r.target_count >= 1

let native_report : compilation_report = {
  source_well_typed = true;
  target_semantics_preserved = true;
  translation_validated = true;
  target_count = 1;
}

let multi_target_report : compilation_report = {
  source_well_typed = true;
  target_semantics_preserved = true;
  translation_validated = true;
  target_count = 4;
}

let native_report_valid =
  valid_compilation_report native_report

let multi_target_report_valid =
  valid_compilation_report multi_target_report
  && multi_target_report.target_count >= 4

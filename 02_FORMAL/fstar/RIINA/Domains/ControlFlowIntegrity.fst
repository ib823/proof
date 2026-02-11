(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.ControlFlowIntegrity

open FStar.All

type cfi_report = {
  indirect_targets_checked: bool;
  shadow_stack_enabled: bool;
  cfi_violations: nat;
}

let cfi_holds (r: cfi_report) : Tot bool =
  r.indirect_targets_checked
  && r.shadow_stack_enabled
  && r.cfi_violations = 0

let production_cfi : cfi_report = {
  indirect_targets_checked = true;
  shadow_stack_enabled = true;
  cfi_violations = 0;
}

let production_cfi_holds =
  cfi_holds production_cfi

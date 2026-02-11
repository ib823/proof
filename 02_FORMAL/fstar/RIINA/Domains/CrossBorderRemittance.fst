(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CrossBorderRemittance

open FStar.All

type remittance_guard = {
  aml_screening_passed: bool;
  sanctions_checked: bool;
  beneficiary_verified: bool;
  settlement_window_hours: nat;
}

let remittance_secure (g: remittance_guard) : Tot bool =
  g.aml_screening_passed
  && g.sanctions_checked
  && g.beneficiary_verified
  && g.settlement_window_hours <= 24

let baseline_remittance_guard : remittance_guard = {
  aml_screening_passed = true;
  sanctions_checked = true;
  beneficiary_verified = true;
  settlement_window_hours = 24;
}

let baseline_remittance_secure =
  remittance_secure baseline_remittance_guard

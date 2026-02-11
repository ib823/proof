(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CertificationEvidence

open FStar.All

type evidence_pack = {
  signed_artifacts: bool;
  reproducible_builds: bool;
  provenance_recorded: bool;
  traceable_requirements: bool;
}

let evidence_pack_complete (e: evidence_pack) : Tot bool =
  e.signed_artifacts
  && e.reproducible_builds
  && e.provenance_recorded
  && e.traceable_requirements

let baseline_evidence_pack : evidence_pack = {
  signed_artifacts = true;
  reproducible_builds = true;
  provenance_recorded = true;
  traceable_requirements = true;
}

let baseline_evidence_pack_complete =
  evidence_pack_complete baseline_evidence_pack

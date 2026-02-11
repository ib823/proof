(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.DependentTypes

open FStar.All

type dep_type_guard = {
  refinement_checked: bool;
  index_constraints_proved: bool;
  totality_preserved: bool;
  extraction_sound: bool;
}

let dep_type_sound (g: dep_type_guard) : Tot bool =
  g.refinement_checked
  && g.index_constraints_proved
  && g.totality_preserved
  && g.extraction_sound

let baseline_dep_type_guard : dep_type_guard = {
  refinement_checked = true;
  index_constraints_proved = true;
  totality_preserved = true;
  extraction_sound = true;
}

let baseline_dep_type_sound =
  dep_type_sound baseline_dep_type_guard

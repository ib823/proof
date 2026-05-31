\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE Preservation ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/type_system/Preservation.v (21 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* free_in_context (matches Coq: Lemma free_in_context)
THEOREM free_in_context == Init => TypeOK

\* store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
THEOREM store_lookup_update_eq == Init => TypeOK

\* store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
THEOREM store_lookup_update_neq == Init => TypeOK

\* store_ty_lookup_update_eq (matches Coq: Lemma store_ty_lookup_update_eq)
THEOREM store_ty_lookup_update_eq == Init => TypeOK

\* store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
THEOREM store_ty_lookup_update_neq == Init => TypeOK

\* store_ty_extends_update_fresh (matches Coq: Lemma store_ty_extends_update_fresh)
THEOREM store_ty_extends_update_fresh == Init => TypeOK

\* store_ty_extends_preserves_typing (matches Coq: Lemma store_ty_extends_preserves_typing)
THEOREM store_ty_extends_preserves_typing == Init => TypeOK

\* store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
THEOREM store_ty_extends_refl == Init => TypeOK

\* store_wf_update_existing (matches Coq: Lemma store_wf_update_existing)
THEOREM store_wf_update_existing == Init => TypeOK

\* store_wf_update_fresh (matches Coq: Lemma store_wf_update_fresh)
THEOREM store_wf_update_fresh == Init => TypeOK

\* store_ty_lookup_fresh_none (matches Coq: Lemma store_ty_lookup_fresh_none)
THEOREM store_ty_lookup_fresh_none == Init => TypeOK

\* context_invariance (matches Coq: Lemma context_invariance)
THEOREM context_invariance == Init => TypeOK

\* closed_typing_weakening (matches Coq: Lemma closed_typing_weakening)
THEOREM closed_typing_weakening == Init => TypeOK

\* substitution_preserves_typing (matches Coq: Lemma substitution_preserves_typing)
THEOREM substitution_preserves_typing == Init => TypeOK

\* value_has_pure_effect (matches Coq: Lemma value_has_pure_effect)
THEOREM value_has_pure_effect == Init => TypeOK

\* preservation_helper (matches Coq: Lemma preservation_helper)
THEOREM preservation_helper == Init => TypeOK

\* preservation (matches Coq: Theorem preservation)
THEOREM preservation == Init => TypeOK

\* store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans)
THEOREM store_ty_extends_trans == Init => TypeOK

\* multi_step_preservation (matches Coq: Theorem multi_step_preservation)
THEOREM multi_step_preservation == Init => TypeOK

\* store_wf_typed_loc_value (matches Coq: Lemma store_wf_typed_loc_value)
THEOREM store_wf_typed_loc_value == Init => TypeOK

\* store_wf_lookup_has_type (matches Coq: Lemma store_wf_lookup_has_type)
THEOREM store_wf_lookup_has_type == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

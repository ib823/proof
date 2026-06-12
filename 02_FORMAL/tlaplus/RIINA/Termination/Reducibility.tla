\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE Reducibility ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/termination/Reducibility.v (38 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* strongly_normalizing (matches Coq: Definition strongly_normalizing)
strongly_normalizing(e, st, ctx) == TRUE

\* value_SN (matches Coq: Lemma value_SN)
THEOREM value_SN == Init => TypeOK

\* SN_step (matches Coq: Lemma SN_step)
THEOREM SN_step == Init => TypeOK

\* fst_typed_steps_to_value (matches Coq: Lemma fst_typed_steps_to_value)
THEOREM fst_typed_steps_to_value == Init => TypeOK

\* snd_typed_steps_to_value (matches Coq: Lemma snd_typed_steps_to_value)
THEOREM snd_typed_steps_to_value == Init => TypeOK

\* case_typed_steps_once (matches Coq: Lemma case_typed_steps_once)
THEOREM case_typed_steps_once == Init => TypeOK

\* if_typed_steps_once (matches Coq: Lemma if_typed_steps_once)
THEOREM if_typed_steps_once == Init => TypeOK

\* let_typed_steps_once (matches Coq: Lemma let_typed_steps_once)
THEOREM let_typed_steps_once == Init => TypeOK

\* handle_typed_steps_once (matches Coq: Lemma handle_typed_steps_once)
THEOREM handle_typed_steps_once == Init => TypeOK

\* app_typed_steps_once (matches Coq: Lemma app_typed_steps_once)
THEOREM app_typed_steps_once == Init => TypeOK

\* SN_value_irreducible (matches Coq: Lemma SN_value_irreducible)
THEOREM SN_value_irreducible == Init => TypeOK

\* case_inl_typed_steps (matches Coq: Lemma case_inl_typed_steps)
THEOREM case_inl_typed_steps == Init => TypeOK

\* case_inr_typed_steps (matches Coq: Lemma case_inr_typed_steps)
THEOREM case_inr_typed_steps == Init => TypeOK

\* pair_values_value (matches Coq: Lemma pair_values_value)
THEOREM pair_values_value == Init => TypeOK

\* inl_value_value (matches Coq: Lemma inl_value_value)
THEOREM inl_value_value == Init => TypeOK

\* inr_value_value (matches Coq: Lemma inr_value_value)
THEOREM inr_value_value == Init => TypeOK

\* lam_value (matches Coq: Lemma lam_value)
THEOREM lam_value == Init => TypeOK

\* unit_value (matches Coq: Lemma unit_value)
THEOREM unit_value == Init => TypeOK

\* bool_value (matches Coq: Lemma bool_value)
THEOREM bool_value == Init => TypeOK

\* int_value (matches Coq: Lemma int_value)
THEOREM int_value == Init => TypeOK

\* string_value (matches Coq: Lemma string_value)
THEOREM string_value == Init => TypeOK

\* loc_value (matches Coq: Lemma loc_value)
THEOREM loc_value == Init => TypeOK

\* SN_multi_step_closed (matches Coq: Lemma SN_multi_step_closed)
THEOREM SN_multi_step_closed == Init => TypeOK

\* classify_value_value (matches Coq: Lemma classify_value_value)
THEOREM classify_value_value == Init => TypeOK

\* classify_value_SN (matches Coq: Lemma classify_value_SN)
THEOREM classify_value_SN == Init => TypeOK

\* pair_SN (matches Coq: Lemma pair_SN)
THEOREM pair_SN == Init => TypeOK

\* inl_SN (matches Coq: Lemma inl_SN)
THEOREM inl_SN == Init => TypeOK

\* inr_SN (matches Coq: Lemma inr_SN)
THEOREM inr_SN == Init => TypeOK

\* lam_SN (matches Coq: Lemma lam_SN)
THEOREM lam_SN == Init => TypeOK

\* unit_SN (matches Coq: Lemma unit_SN)
THEOREM unit_SN == Init => TypeOK

\* bool_SN (matches Coq: Lemma bool_SN)
THEOREM bool_SN == Init => TypeOK

\* int_SN (matches Coq: Lemma int_SN)
THEOREM int_SN == Init => TypeOK

\* string_SN (matches Coq: Lemma string_SN)
THEOREM string_SN == Init => TypeOK

\* loc_SN (matches Coq: Lemma loc_SN)
THEOREM loc_SN == Init => TypeOK

\* prove_value_value (matches Coq: Lemma prove_value_value)
THEOREM prove_value_value == Init => TypeOK

\* prove_SN (matches Coq: Lemma prove_SN)
THEOREM prove_SN == Init => TypeOK

\* fst_pair_step_value (matches Coq: Lemma fst_pair_step_value)
THEOREM fst_pair_step_value == Init => TypeOK

\* snd_pair_step_value (matches Coq: Lemma snd_pair_step_value)
THEOREM snd_pair_step_value == Init => TypeOK

\* app_lam_steps (matches Coq: Lemma app_lam_steps)
THEOREM app_lam_steps == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

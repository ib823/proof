\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE TerminationLemmas ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (30 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* val_rel_0 (matches Coq: Definition val_rel_0)
val_rel_0(sigma, T, v1, v2) == TRUE

\* store_rel_0 (matches Coq: Definition store_rel_0)
store_rel_0(sigma, st1, st2) == TRUE

\* exp_rel_step1_fst_typed (matches Coq: Lemma exp_rel_step1_fst_typed)
THEOREM exp_rel_step1_fst_typed == Init => TypeOK

\* exp_rel_step1_snd_typed (matches Coq: Lemma exp_rel_step1_snd_typed)
THEOREM exp_rel_step1_snd_typed == Init => TypeOK

\* exp_rel_step1_case_typed (matches Coq: Lemma exp_rel_step1_case_typed)
THEOREM exp_rel_step1_case_typed == Init => TypeOK

\* exp_rel_step1_if_typed (matches Coq: Lemma exp_rel_step1_if_typed)
THEOREM exp_rel_step1_if_typed == Init => TypeOK

\* exp_rel_step1_let_typed (matches Coq: Lemma exp_rel_step1_let_typed)
THEOREM exp_rel_step1_let_typed == Init => TypeOK

\* exp_rel_step1_handle_typed (matches Coq: Lemma exp_rel_step1_handle_typed)
THEOREM exp_rel_step1_handle_typed == Init => TypeOK

\* exp_rel_step1_app_typed (matches Coq: Lemma exp_rel_step1_app_typed)
THEOREM exp_rel_step1_app_typed == Init => TypeOK

\* multi_step_step_left (matches Coq: Lemma multi_step_step_left)
THEOREM multi_step_step_left == Init => TypeOK

\* val_rel_0_trivial (matches Coq: Lemma val_rel_0_trivial)
THEOREM val_rel_0_trivial == Init => TypeOK

\* store_rel_0_trivial (matches Coq: Lemma store_rel_0_trivial)
THEOREM store_rel_0_trivial == Init => TypeOK

\* val_rel_0_type_irrelevant (matches Coq: Lemma val_rel_0_type_irrelevant)
THEOREM val_rel_0_type_irrelevant == Init => TypeOK

\* val_rel_0_store_irrelevant (matches Coq: Lemma val_rel_0_store_irrelevant)
THEOREM val_rel_0_store_irrelevant == Init => TypeOK

\* store_rel_0_sym (matches Coq: Lemma store_rel_0_sym)
THEOREM store_rel_0_sym == Init => TypeOK

\* fst_terminates (matches Coq: Lemma fst_terminates)
THEOREM fst_terminates == Init => TypeOK

\* snd_terminates (matches Coq: Lemma snd_terminates)
THEOREM snd_terminates == Init => TypeOK

\* if_true_terminates (matches Coq: Lemma if_true_terminates)
THEOREM if_true_terminates == Init => TypeOK

\* if_false_terminates (matches Coq: Lemma if_false_terminates)
THEOREM if_false_terminates == Init => TypeOK

\* let_terminates (matches Coq: Lemma let_terminates)
THEOREM let_terminates == Init => TypeOK

\* app_lam_terminates (matches Coq: Lemma app_lam_terminates)
THEOREM app_lam_terminates == Init => TypeOK

\* value_terminates (matches Coq: Lemma value_terminates)
THEOREM value_terminates == Init => TypeOK

\* case_inl_terminates (matches Coq: Lemma case_inl_terminates)
THEOREM case_inl_terminates == Init => TypeOK

\* case_inr_terminates (matches Coq: Lemma case_inr_terminates)
THEOREM case_inr_terminates == Init => TypeOK

\* handle_terminates (matches Coq: Lemma handle_terminates)
THEOREM handle_terminates == Init => TypeOK

\* terminates_trans (matches Coq: Lemma terminates_trans)
THEOREM terminates_trans == Init => TypeOK

\* value_terminates_refl (matches Coq: Lemma value_terminates_refl)
THEOREM value_terminates_refl == Init => TypeOK

\* val_rel_0_refl (matches Coq: Lemma val_rel_0_refl)
THEOREM val_rel_0_refl == Init => TypeOK

\* val_rel_0_sym (matches Coq: Lemma val_rel_0_sym)
THEOREM val_rel_0_sym == Init => TypeOK

\* store_rel_0_trans (matches Coq: Lemma store_rel_0_trans)
THEOREM store_rel_0_trans == Init => TypeOK

\* terminates_step (matches Coq: Lemma terminates_step)
THEOREM terminates_step == Init => TypeOK

\* if_terminates (matches Coq: Lemma if_terminates)
THEOREM if_terminates == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

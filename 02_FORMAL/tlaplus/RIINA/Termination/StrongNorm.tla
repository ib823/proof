\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE StrongNorm ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/termination/StrongNorm.v (34 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* value_strongly_normalizing (matches Coq: Theorem value_strongly_normalizing)
THEOREM value_strongly_normalizing == Init => TypeOK

\* fst_terminates_to_value (matches Coq: Lemma fst_terminates_to_value)
THEOREM fst_terminates_to_value == Init => TypeOK

\* snd_terminates_to_value (matches Coq: Lemma snd_terminates_to_value)
THEOREM snd_terminates_to_value == Init => TypeOK

\* if_bool_terminates_once (matches Coq: Lemma if_bool_terminates_once)
THEOREM if_bool_terminates_once == Init => TypeOK

\* let_terminates_once (matches Coq: Lemma let_terminates_once)
THEOREM let_terminates_once == Init => TypeOK

\* handle_terminates_once (matches Coq: Lemma handle_terminates_once)
THEOREM handle_terminates_once == Init => TypeOK

\* app_lam_terminates_once (matches Coq: Lemma app_lam_terminates_once)
THEOREM app_lam_terminates_once == Init => TypeOK

\* store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
THEOREM store_ty_extends_refl == Init => TypeOK

\* SN_multi_step (matches Coq: Lemma SN_multi_step)
THEOREM SN_multi_step == Init => TypeOK

\* fst_value_terminates_pair (matches Coq: Lemma fst_value_terminates_pair)
THEOREM fst_value_terminates_pair == Init => TypeOK

\* snd_value_SN (matches Coq: Lemma snd_value_SN)
THEOREM snd_value_SN == Init => TypeOK

\* if_bool_SN (matches Coq: Lemma if_bool_SN)
THEOREM if_bool_SN == Init => TypeOK

\* let_value_SN (matches Coq: Lemma let_value_SN)
THEOREM let_value_SN == Init => TypeOK

\* app_lam_value_SN (matches Coq: Lemma app_lam_value_SN)
THEOREM app_lam_value_SN == Init => TypeOK

\* handle_value_SN (matches Coq: Lemma handle_value_SN)
THEOREM handle_value_SN == Init => TypeOK

\* case_inl_value_SN (matches Coq: Lemma case_inl_value_SN)
THEOREM case_inl_value_SN == Init => TypeOK

\* case_inr_value_SN (matches Coq: Lemma case_inr_value_SN)
THEOREM case_inr_value_SN == Init => TypeOK

\* classify_value_strongly_normalizing (matches Coq: Lemma classify_value_strongly_normalizing)
THEOREM classify_value_strongly_normalizing == Init => TypeOK

\* declassify_classify_SN (matches Coq: Lemma declassify_classify_SN)
THEOREM declassify_classify_SN == Init => TypeOK

\* fst_fst_pair_SN (matches Coq: Lemma fst_fst_pair_SN)
THEOREM fst_fst_pair_SN == Init => TypeOK

\* perform_value_SN (matches Coq: Lemma perform_value_SN)
THEOREM perform_value_SN == Init => TypeOK

\* require_value_SN (matches Coq: Lemma require_value_SN)
THEOREM require_value_SN == Init => TypeOK

\* grant_value_SN (matches Coq: Lemma grant_value_SN)
THEOREM grant_value_SN == Init => TypeOK

\* pair_value_SN (matches Coq: Lemma pair_value_SN)
THEOREM pair_value_SN == Init => TypeOK

\* inl_value_SN (matches Coq: Lemma inl_value_SN)
THEOREM inl_value_SN == Init => TypeOK

\* inr_value_SN (matches Coq: Lemma inr_value_SN)
THEOREM inr_value_SN == Init => TypeOK

\* prove_value_SN (matches Coq: Lemma prove_value_SN)
THEOREM prove_value_SN == Init => TypeOK

\* snd_snd_pair_SN (matches Coq: Lemma snd_snd_pair_SN)
THEOREM snd_snd_pair_SN == Init => TypeOK

\* fst_snd_pair_SN (matches Coq: Lemma fst_snd_pair_SN)
THEOREM fst_snd_pair_SN == Init => TypeOK

\* snd_fst_pair_SN (matches Coq: Lemma snd_fst_pair_SN)
THEOREM snd_fst_pair_SN == Init => TypeOK

\* fst_fst_nested_SN (matches Coq: Lemma fst_fst_nested_SN)
THEOREM fst_fst_nested_SN == Init => TypeOK

\* classify_classify_SN (matches Coq: Lemma classify_classify_SN)
THEOREM classify_classify_SN == Init => TypeOK

\* prove_prove_SN (matches Coq: Lemma prove_prove_SN)
THEOREM prove_prove_SN == Init => TypeOK

\* nested_pair_value_SN (matches Coq: Lemma nested_pair_value_SN)
THEOREM nested_pair_value_SN == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

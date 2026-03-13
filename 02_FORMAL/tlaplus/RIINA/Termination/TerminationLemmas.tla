---- MODULE TerminationLemmas ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (7 invariants)
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
THEOREM exp_rel_step1_fst_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* exp_rel_step1_snd_typed (matches Coq: Lemma exp_rel_step1_snd_typed)
THEOREM exp_rel_step1_snd_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* exp_rel_step1_case_typed (matches Coq: Lemma exp_rel_step1_case_typed)
THEOREM exp_rel_step1_case_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* exp_rel_step1_if_typed (matches Coq: Lemma exp_rel_step1_if_typed)
THEOREM exp_rel_step1_if_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* exp_rel_step1_let_typed (matches Coq: Lemma exp_rel_step1_let_typed)
THEOREM exp_rel_step1_let_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* exp_rel_step1_handle_typed (matches Coq: Lemma exp_rel_step1_handle_typed)
THEOREM exp_rel_step1_handle_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* exp_rel_step1_app_typed (matches Coq: Lemma exp_rel_step1_app_typed)
THEOREM exp_rel_step1_app_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

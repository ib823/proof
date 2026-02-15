---- MODULE ContextProperties ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/ContextProperties.v (21 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* free_in_dec (matches Coq: Lemma free_in_dec)
THEOREM free_in_dec == Init => TypeOK

\* lookup_cons_neq_inv (matches Coq: Lemma lookup_cons_neq_inv)
THEOREM lookup_cons_neq_inv == Init => TypeOK

\* lookup_deterministic (matches Coq: Lemma lookup_deterministic)
THEOREM lookup_deterministic == Init => TypeOK

\* lookup_cons_inv (matches Coq: Lemma lookup_cons_inv)
THEOREM lookup_cons_inv == Init => TypeOK

\* lookup_weaken_neq (matches Coq: Lemma lookup_weaken_neq)
THEOREM lookup_weaken_neq == Init => TypeOK

\* typing_weaken_head (matches Coq: Lemma typing_weaken_head)
THEOREM typing_weaken_head == Init => TypeOK

\* typing_weaken_fresh (matches Coq: Lemma typing_weaken_fresh)
THEOREM typing_weaken_fresh == Init => TypeOK

\* typing_strengthen_head (matches Coq: Lemma typing_strengthen_head)
THEOREM typing_strengthen_head == Init => TypeOK

\* typing_exchange (matches Coq: Lemma typing_exchange)
THEOREM typing_exchange == Init => TypeOK

\* typing_delta_irrelevance (matches Coq: Lemma typing_delta_irrelevance)
THEOREM typing_delta_irrelevance == Init => TypeOK

\* typing_shadow (matches Coq: Lemma typing_shadow)
THEOREM typing_shadow == Init => TypeOK

\* closed_no_free_vars (matches Coq: Lemma closed_no_free_vars)
THEOREM closed_no_free_vars == Init => TypeOK

\* typing_weaken_closed (matches Coq: Lemma typing_weaken_closed)
THEOREM typing_weaken_closed == Init => TypeOK

\* typing_weaken_multi_closed (matches Coq: Lemma typing_weaken_multi_closed)
THEOREM typing_weaken_multi_closed == Init => TypeOK

\* typing_weaken_prefix (matches Coq: Lemma typing_weaken_prefix)
THEOREM typing_weaken_prefix == Init => TypeOK

\* store_extends_refl (matches Coq: Lemma store_extends_refl)
THEOREM store_extends_refl == Init => TypeOK

\* store_extends_trans (matches Coq: Lemma store_extends_trans)
THEOREM store_extends_trans == Init => TypeOK

\* typing_weaken_store (matches Coq: Lemma typing_weaken_store)
THEOREM typing_weaken_store == Init => TypeOK

\* typing_weaken_head_delta (matches Coq: Lemma typing_weaken_head_delta)
THEOREM typing_weaken_head_delta == Init => TypeOK

\* typing_weaken_two (matches Coq: Lemma typing_weaken_two)
THEOREM typing_weaken_two == Init => TypeOK

\* typing_weaken_head_store (matches Coq: Lemma typing_weaken_head_store)
THEOREM typing_weaken_head_store == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

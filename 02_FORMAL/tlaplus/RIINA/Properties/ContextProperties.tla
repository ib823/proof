\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ContextProperties ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/ContextProperties.v (42 invariants)
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

\* lookup_app_l (matches Coq: Lemma lookup_app_l)
THEOREM lookup_app_l == Init => TypeOK

\* lookup_app_r (matches Coq: Lemma lookup_app_r)
THEOREM lookup_app_r == Init => TypeOK

\* lookup_nil (matches Coq: Lemma lookup_nil)
THEOREM lookup_nil == Init => TypeOK

\* lookup_head_eq (matches Coq: Lemma lookup_head_eq)
THEOREM lookup_head_eq == Init => TypeOK

\* typing_contract (matches Coq: Lemma typing_contract)
THEOREM typing_contract == Init => TypeOK

\* store_wf_runtime_entry_typed (matches Coq: Lemma store_wf_runtime_entry_typed)
THEOREM store_wf_runtime_entry_typed == Init => TypeOK

\* store_wf_bidirectional (matches Coq: Lemma store_wf_bidirectional)
THEOREM store_wf_bidirectional == Init => TypeOK

\* subst_closed_typing (matches Coq: Lemma subst_closed_typing)
THEOREM subst_closed_typing == Init => TypeOK

\* typing_weaken_fresh_list (matches Coq: Lemma typing_weaken_fresh_list)
THEOREM typing_weaken_fresh_list == Init => TypeOK

\* lookup_singleton (matches Coq: Lemma lookup_singleton)
THEOREM lookup_singleton == Init => TypeOK

\* lookup_cons_tail (matches Coq: Lemma lookup_cons_tail)
THEOREM lookup_cons_tail == Init => TypeOK

\* lookup_dec (matches Coq: Lemma lookup_dec)
THEOREM lookup_dec == Init => TypeOK

\* closed_typing_any_ctx (matches Coq: Lemma closed_typing_any_ctx)
THEOREM closed_typing_any_ctx == Init => TypeOK

\* typing_weaken_exchange (matches Coq: Lemma typing_weaken_exchange)
THEOREM typing_weaken_exchange == Init => TypeOK

\* typing_weaken_append (matches Coq: Lemma typing_weaken_append)
THEOREM typing_weaken_append == Init => TypeOK

\* typing_prefix_sufficient (matches Coq: Lemma typing_prefix_sufficient)
THEOREM typing_prefix_sufficient == Init => TypeOK

\* typing_singleton_var (matches Coq: Lemma typing_singleton_var)
THEOREM typing_singleton_var == Init => TypeOK

\* nil_ctx_no_free_vars (matches Coq: Lemma nil_ctx_no_free_vars)
THEOREM nil_ctx_no_free_vars == Init => TypeOK

\* typing_weaken_cons_right (matches Coq: Lemma typing_weaken_cons_right)
THEOREM typing_weaken_cons_right == Init => TypeOK

\* typing_weaken_singleton (matches Coq: Lemma typing_weaken_singleton)
THEOREM typing_weaken_singleton == Init => TypeOK

\* typing_weaken_double (matches Coq: Lemma typing_weaken_double)
THEOREM typing_weaken_double == Init => TypeOK

\* nil_ctx_typed_closed (matches Coq: Lemma nil_ctx_typed_closed)
THEOREM nil_ctx_typed_closed == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

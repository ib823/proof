\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE MLSafetyTypes ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/MLSafetyTypes.v (24 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* shape_eq (matches Coq: Definition shape_eq)
shape_eq(s1, s2) == TRUE

\* dp_compose (matches Coq: Definition dp_compose)
dp_compose(d1, d2) == TRUE

\* lipschitz_bound (matches Coq: Definition lipschitz_bound)
lipschitz_bound(k, f) == TRUE

\* forallb_combine_refl (matches Coq: Lemma forallb_combine_refl)
THEOREM forallb_combine_refl == Init => TypeOK

\* forallb_combine_sym (matches Coq: Lemma forallb_combine_sym)
THEOREM forallb_combine_sym == Init => TypeOK

\* shape_eq_refl (matches Coq: Theorem shape_eq_refl)
THEOREM shape_eq_refl == Init => TypeOK

\* shape_eq_sym (matches Coq: Theorem shape_eq_sym)
THEOREM shape_eq_sym == Init => TypeOK

\* matmul_shape_correct (matches Coq: Theorem matmul_shape_correct)
THEOREM matmul_shape_correct == Init => TypeOK

\* matmul_incompat (matches Coq: Theorem matmul_incompat)
THEOREM matmul_incompat == Init => TypeOK

\* dp_composition_additive (matches Coq: Theorem dp_composition_additive)
THEOREM dp_composition_additive == Init => TypeOK

\* dp_compose_assoc (matches Coq: Theorem dp_compose_assoc)
THEOREM dp_compose_assoc == Init => TypeOK

\* lipschitz_compose (matches Coq: Theorem lipschitz_compose)
THEOREM lipschitz_compose == Init => TypeOK

\* lipschitz_id (matches Coq: Theorem lipschitz_id)
THEOREM lipschitz_id == Init => TypeOK

\* lipschitz_const (matches Coq: Theorem lipschitz_const)
THEOREM lipschitz_const == Init => TypeOK

\* dp_queries_additive (matches Coq: Theorem dp_queries_additive)
THEOREM dp_queries_additive == Init => TypeOK

\* dp_compose_zero_l (matches Coq: Theorem dp_compose_zero_l)
THEOREM dp_compose_zero_l == Init => TypeOK

\* dp_compose_zero_r (matches Coq: Theorem dp_compose_zero_r)
THEOREM dp_compose_zero_r == Init => TypeOK

\* dp_compose_comm (matches Coq: Theorem dp_compose_comm)
THEOREM dp_compose_comm == Init => TypeOK

\* shape_eq_implies_same_length (matches Coq: Theorem shape_eq_implies_same_length)
THEOREM shape_eq_implies_same_length == Init => TypeOK

\* shape_eq_nil (matches Coq: Theorem shape_eq_nil)
THEOREM shape_eq_nil == Init => TypeOK

\* shape_eq_singleton (matches Coq: Theorem shape_eq_singleton)
THEOREM shape_eq_singleton == Init => TypeOK

\* matmul_square (matches Coq: Theorem matmul_square)
THEOREM matmul_square == Init => TypeOK

\* matmul_col_vector (matches Coq: Theorem matmul_col_vector)
THEOREM matmul_col_vector == Init => TypeOK

\* dp_epsilon_nonneg (matches Coq: Theorem dp_epsilon_nonneg)
THEOREM dp_epsilon_nonneg == Init => TypeOK

\* lipschitz_mono (matches Coq: Theorem lipschitz_mono)
THEOREM lipschitz_mono == Init => TypeOK

\* compose_fn_assoc (matches Coq: Theorem compose_fn_assoc)
THEOREM compose_fn_assoc == Init => TypeOK

\* compose_fn_id_l (matches Coq: Theorem compose_fn_id_l)
THEOREM compose_fn_id_l == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

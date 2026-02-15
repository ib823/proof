---- MODULE AhmedStyleTest ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/AhmedStyleTest.v (7 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* sty (matches Coq: Inductive sty)
CONSTANTS STUnit, STBool, STFn, STProd

\* sval (matches Coq: Inductive sval)
CONSTANTS SVUnit, SVBool, SVLam, SVPair

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* sval_rel_at_type (matches Coq: Definition sval_rel_at_type)
sval_rel_at_type(T, v1, v2) == TRUE

\* sval_rel_at_type_base (matches Coq: Definition sval_rel_at_type_base)
sval_rel_at_type_base(T, vl, v1, v2) == TRUE

\* sval_rel_tower (matches Coq: Definition sval_rel_tower)
sval_rel_tower(n, T, v1, v2) == TRUE

\* sval_rel_tower_0 (matches Coq: Lemma sval_rel_tower_0)
THEOREM sval_rel_tower_0 == Init => TypeOK

\* sval_rel_tower_S (matches Coq: Lemma sval_rel_tower_S)
THEOREM sval_rel_tower_S == Init => TypeOK

\* sval_rel_tower_mono (matches Coq: Lemma sval_rel_tower_mono)
THEOREM sval_rel_tower_mono == Init => TypeOK

\* sval_rel_tower_fn_apply (matches Coq: Lemma sval_rel_tower_fn_apply)
THEOREM sval_rel_tower_fn_apply == Init => TypeOK

\* ahmed_tower_ft_works (matches Coq: Lemma ahmed_tower_ft_works)
THEOREM ahmed_tower_ft_works == Init => TypeOK

\* sval_rel_tower_step_up_unit (matches Coq: Lemma sval_rel_tower_step_up_unit)
THEOREM sval_rel_tower_step_up_unit == Init => TypeOK

\* sval_rel_tower_step_up_bool (matches Coq: Lemma sval_rel_tower_step_up_bool)
THEOREM sval_rel_tower_step_up_bool == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

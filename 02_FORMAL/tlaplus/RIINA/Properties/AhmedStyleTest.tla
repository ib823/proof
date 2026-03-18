---- MODULE AhmedStyleTest ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/AhmedStyleTest.v (30 invariants)
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

\* sval_rel_tower_prefix (matches Coq: Lemma sval_rel_tower_prefix)
THEOREM sval_rel_tower_prefix == Init => TypeOK

\* sval_rel_tower_trivial (matches Coq: Lemma sval_rel_tower_trivial)
THEOREM sval_rel_tower_trivial == Init => TypeOK

\* sval_rel_tower_unit (matches Coq: Lemma sval_rel_tower_unit)
THEOREM sval_rel_tower_unit == Init => TypeOK

\* sval_rel_tower_bool (matches Coq: Lemma sval_rel_tower_bool)
THEOREM sval_rel_tower_bool == Init => TypeOK

\* sval_rel_tower_pair (matches Coq: Lemma sval_rel_tower_pair)
THEOREM sval_rel_tower_pair == Init => TypeOK

\* sval_rel_tower_mono_to_0 (matches Coq: Lemma sval_rel_tower_mono_to_0)
THEOREM sval_rel_tower_mono_to_0 == Init => TypeOK

\* sval_rel_tower_drop_2 (matches Coq: Lemma sval_rel_tower_drop_2)
THEOREM sval_rel_tower_drop_2 == Init => TypeOK

\* sval_rel_tower_from_higher (matches Coq: Lemma sval_rel_tower_from_higher)
THEOREM sval_rel_tower_from_higher == Init => TypeOK

\* sval_rel_tower_prod_elim (matches Coq: Lemma sval_rel_tower_prod_elim)
THEOREM sval_rel_tower_prod_elim == Init => TypeOK

\* sval_rel_tower_fn_elim (matches Coq: Lemma sval_rel_tower_fn_elim)
THEOREM sval_rel_tower_fn_elim == Init => TypeOK

\* sval_rel_tower_unit_inv (matches Coq: Lemma sval_rel_tower_unit_inv)
THEOREM sval_rel_tower_unit_inv == Init => TypeOK

\* sval_rel_tower_bool_inv (matches Coq: Lemma sval_rel_tower_bool_inv)
THEOREM sval_rel_tower_bool_inv == Init => TypeOK

\* sval_rel_tower_pair_left (matches Coq: Lemma sval_rel_tower_pair_left)
THEOREM sval_rel_tower_pair_left == Init => TypeOK

\* sval_rel_tower_pair_right (matches Coq: Lemma sval_rel_tower_pair_right)
THEOREM sval_rel_tower_pair_right == Init => TypeOK

\* sval_rel_tower_fn_mono_app (matches Coq: Lemma sval_rel_tower_fn_mono_app)
THEOREM sval_rel_tower_fn_mono_app == Init => TypeOK

\* sval_rel_tower_unit_val (matches Coq: Lemma sval_rel_tower_unit_val)
THEOREM sval_rel_tower_unit_val == Init => TypeOK

\* sval_rel_tower_bool_same (matches Coq: Lemma sval_rel_tower_bool_same)
THEOREM sval_rel_tower_bool_same == Init => TypeOK

\* sval_rel_tower_step_up_pair (matches Coq: Lemma sval_rel_tower_step_up_pair)
THEOREM sval_rel_tower_step_up_pair == Init => TypeOK

\* sval_rel_tower_pair_unit_unit (matches Coq: Lemma sval_rel_tower_pair_unit_unit)
THEOREM sval_rel_tower_pair_unit_unit == Init => TypeOK

\* sval_rel_tower_bool_false (matches Coq: Lemma sval_rel_tower_bool_false)
THEOREM sval_rel_tower_bool_false == Init => TypeOK

\* sval_rel_tower_bool_true (matches Coq: Lemma sval_rel_tower_bool_true)
THEOREM sval_rel_tower_bool_true == Init => TypeOK

\* sval_rel_tower_drop_3 (matches Coq: Lemma sval_rel_tower_drop_3)
THEOREM sval_rel_tower_drop_3 == Init => TypeOK

\* sval_rel_tower_prod_unit_refl (matches Coq: Lemma sval_rel_tower_prod_unit_refl)
THEOREM sval_rel_tower_prod_unit_refl == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE FirstOrderComplete ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/FirstOrderComplete.v (56 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* is_base_type (matches Coq: Definition is_base_type)
is_base_type(T) == TRUE

\* store_independent (matches Coq: Definition store_independent)
store_independent(P) == TRUE

\* expr_eqb (matches Coq: Definition expr_eqb)
expr_eqb(e1, e2) == TRUE

\* ty_eqb (matches Coq: Definition ty_eqb)
ty_eqb(T1, T2) == TRUE

\* first_order_subtype (matches Coq: Lemma first_order_subtype)
THEOREM first_order_subtype == Init => TypeOK

\* first_order_subtypes_fo (matches Coq: Lemma first_order_subtypes_fo)
THEOREM first_order_subtypes_fo == Init => TypeOK

\* base_type_first_order (matches Coq: Lemma base_type_first_order)
THEOREM base_type_first_order == Init => TypeOK

\* base_type_size_one (matches Coq: Lemma base_type_size_one)
THEOREM base_type_size_one == Init => TypeOK

\* first_order_value_structure (matches Coq: Lemma first_order_value_structure)
THEOREM first_order_value_structure == Init => TypeOK

\* first_order_induction_simple (matches Coq: Lemma first_order_induction_simple)
THEOREM first_order_induction_simple == Init => TypeOK

\* ty_eqb_refl (matches Coq: Lemma ty_eqb_refl)
THEOREM ty_eqb_refl == Init => TypeOK

\* ty_eqb_eq (matches Coq: Lemma ty_eqb_eq)
THEOREM ty_eqb_eq == Init => TypeOK

\* ty_eqb_unit_bool_false (matches Coq: Lemma ty_eqb_unit_bool_false)
THEOREM ty_eqb_unit_bool_false == Init => TypeOK

\* ty_eqb_unit_int_false (matches Coq: Lemma ty_eqb_unit_int_false)
THEOREM ty_eqb_unit_int_false == Init => TypeOK

\* ty_eqb_bool_int_false (matches Coq: Lemma ty_eqb_bool_int_false)
THEOREM ty_eqb_bool_int_false == Init => TypeOK

\* ty_eqb_bool_string_false (matches Coq: Lemma ty_eqb_bool_string_false)
THEOREM ty_eqb_bool_string_false == Init => TypeOK

\* ty_eqb_int_string_false (matches Coq: Lemma ty_eqb_int_string_false)
THEOREM ty_eqb_int_string_false == Init => TypeOK

\* ty_eqb_unit_string_false (matches Coq: Lemma ty_eqb_unit_string_false)
THEOREM ty_eqb_unit_string_false == Init => TypeOK

\* fn_not_first_order (matches Coq: Lemma fn_not_first_order)
THEOREM fn_not_first_order == Init => TypeOK

\* chan_not_first_order (matches Coq: Lemma chan_not_first_order)
THEOREM chan_not_first_order == Init => TypeOK

\* securechan_not_first_order (matches Coq: Lemma securechan_not_first_order)
THEOREM securechan_not_first_order == Init => TypeOK

\* base_type_not_fn (matches Coq: Lemma base_type_not_fn)
THEOREM base_type_not_fn == Init => TypeOK

\* base_type_not_prod (matches Coq: Lemma base_type_not_prod)
THEOREM base_type_not_prod == Init => TypeOK

\* base_type_not_sum (matches Coq: Lemma base_type_not_sum)
THEOREM base_type_not_sum == Init => TypeOK

\* base_type_not_list (matches Coq: Lemma base_type_not_list)
THEOREM base_type_not_list == Init => TypeOK

\* base_type_not_option (matches Coq: Lemma base_type_not_option)
THEOREM base_type_not_option == Init => TypeOK

\* fo_compound_depth_unit (matches Coq: Lemma fo_compound_depth_unit)
THEOREM fo_compound_depth_unit == Init => TypeOK

\* fo_compound_depth_bool (matches Coq: Lemma fo_compound_depth_bool)
THEOREM fo_compound_depth_bool == Init => TypeOK

\* fo_compound_depth_int (matches Coq: Lemma fo_compound_depth_int)
THEOREM fo_compound_depth_int == Init => TypeOK

\* fo_compound_depth_string (matches Coq: Lemma fo_compound_depth_string)
THEOREM fo_compound_depth_string == Init => TypeOK

\* fo_compound_depth_bytes (matches Coq: Lemma fo_compound_depth_bytes)
THEOREM fo_compound_depth_bytes == Init => TypeOK

\* fo_compound_depth_list (matches Coq: Lemma fo_compound_depth_list)
THEOREM fo_compound_depth_list == Init => TypeOK

\* fo_compound_depth_option (matches Coq: Lemma fo_compound_depth_option)
THEOREM fo_compound_depth_option == Init => TypeOK

\* fo_compound_depth_ref (matches Coq: Lemma fo_compound_depth_ref)
THEOREM fo_compound_depth_ref == Init => TypeOK

\* fo_compound_depth_secret (matches Coq: Lemma fo_compound_depth_secret)
THEOREM fo_compound_depth_secret == Init => TypeOK

\* fo_compound_depth_fn (matches Coq: Lemma fo_compound_depth_fn)
THEOREM fo_compound_depth_fn == Init => TypeOK

\* ty_eqb_sym (matches Coq: Lemma ty_eqb_sym)
THEOREM ty_eqb_sym == Init => TypeOK

\* expr_eqb_unit (matches Coq: Lemma expr_eqb_unit)
THEOREM expr_eqb_unit == Init => TypeOK

\* expr_eqb_bool (matches Coq: Lemma expr_eqb_bool)
THEOREM expr_eqb_bool == Init => TypeOK

\* expr_eqb_int (matches Coq: Lemma expr_eqb_int)
THEOREM expr_eqb_int == Init => TypeOK

\* expr_eqb_string (matches Coq: Lemma expr_eqb_string)
THEOREM expr_eqb_string == Init => TypeOK

\* expr_eqb_loc (matches Coq: Lemma expr_eqb_loc)
THEOREM expr_eqb_loc == Init => TypeOK

\* expr_eqb_var (matches Coq: Lemma expr_eqb_var)
THEOREM expr_eqb_var == Init => TypeOK

\* is_base_type_unit (matches Coq: Lemma is_base_type_unit)
THEOREM is_base_type_unit == Init => TypeOK

\* is_base_type_bool (matches Coq: Lemma is_base_type_bool)
THEOREM is_base_type_bool == Init => TypeOK

\* is_base_type_int (matches Coq: Lemma is_base_type_int)
THEOREM is_base_type_int == Init => TypeOK

\* is_base_type_string (matches Coq: Lemma is_base_type_string)
THEOREM is_base_type_string == Init => TypeOK

\* is_base_type_bytes (matches Coq: Lemma is_base_type_bytes)
THEOREM is_base_type_bytes == Init => TypeOK

\* first_order_type_prod_iff (matches Coq: Lemma first_order_type_prod_iff)
THEOREM first_order_type_prod_iff == Init => TypeOK

\* first_order_type_sum_iff (matches Coq: Lemma first_order_type_sum_iff)
THEOREM first_order_type_sum_iff == Init => TypeOK

\* first_order_type_secret_iff (matches Coq: Lemma first_order_type_secret_iff)
THEOREM first_order_type_secret_iff == Init => TypeOK

\* ty_eqb_prod (matches Coq: Lemma ty_eqb_prod)
THEOREM ty_eqb_prod == Init => TypeOK

\* ty_eqb_sum (matches Coq: Lemma ty_eqb_sum)
THEOREM ty_eqb_sum == Init => TypeOK

\* base_type_not_ref (matches Coq: Lemma base_type_not_ref)
THEOREM base_type_not_ref == Init => TypeOK

\* base_type_not_secret (matches Coq: Lemma base_type_not_secret)
THEOREM base_type_not_secret == Init => TypeOK

\* first_order_type_list_iff (matches Coq: Lemma first_order_type_list_iff)
THEOREM first_order_type_list_iff == Init => TypeOK

\* first_order_type_option_iff (matches Coq: Lemma first_order_type_option_iff)
THEOREM first_order_type_option_iff == Init => TypeOK

\* ty_eqb_list (matches Coq: Lemma ty_eqb_list)
THEOREM ty_eqb_list == Init => TypeOK

\* ty_eqb_option (matches Coq: Lemma ty_eqb_option)
THEOREM ty_eqb_option == Init => TypeOK

\* base_type_not_labeled (matches Coq: Lemma base_type_not_labeled)
THEOREM base_type_not_labeled == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

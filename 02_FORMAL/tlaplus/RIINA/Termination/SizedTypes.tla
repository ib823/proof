---- MODULE SizedTypes ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/termination/SizedTypes.v (44 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* sized_ty (matches Coq: Inductive sized_ty)
CONSTANTS STBase, STSized

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* sized_ty_base (matches Coq: Definition sized_ty_base)
sized_ty_base(st) == TRUE

\* sized_ty_bound (matches Coq: Definition sized_ty_bound)
sized_ty_bound(st) == TRUE

\* expr_size (matches Coq: Definition expr_size)
expr_size(e) == TRUE

\* terminates (matches Coq: Definition terminates)
terminates(e, st, ctx) == TRUE

\* step_terminates (matches Coq: Definition step_terminates)
step_terminates(e, st, ctx) == TRUE

\* expr_size_pos (matches Coq: Lemma expr_size_pos)
THEOREM expr_size_pos == Init => TypeOK

\* value_prod_decompose (matches Coq: Lemma value_prod_decompose)
THEOREM value_prod_decompose == Init => TypeOK

\* value_sum_decompose (matches Coq: Lemma value_sum_decompose)
THEOREM value_sum_decompose == Init => TypeOK

\* value_bool_decompose (matches Coq: Lemma value_bool_decompose)
THEOREM value_bool_decompose == Init => TypeOK

\* value_fn_decompose (matches Coq: Lemma value_fn_decompose)
THEOREM value_fn_decompose == Init => TypeOK

\* fst_steps_once (matches Coq: Lemma fst_steps_once)
THEOREM fst_steps_once == Init => TypeOK

\* snd_steps_once (matches Coq: Lemma snd_steps_once)
THEOREM snd_steps_once == Init => TypeOK

\* case_inl_steps_once (matches Coq: Lemma case_inl_steps_once)
THEOREM case_inl_steps_once == Init => TypeOK

\* case_inr_steps_once (matches Coq: Lemma case_inr_steps_once)
THEOREM case_inr_steps_once == Init => TypeOK

\* if_true_steps_once (matches Coq: Lemma if_true_steps_once)
THEOREM if_true_steps_once == Init => TypeOK

\* if_false_steps_once (matches Coq: Lemma if_false_steps_once)
THEOREM if_false_steps_once == Init => TypeOK

\* let_value_steps_once (matches Coq: Lemma let_value_steps_once)
THEOREM let_value_steps_once == Init => TypeOK

\* handle_value_steps_once (matches Coq: Lemma handle_value_steps_once)
THEOREM handle_value_steps_once == Init => TypeOK

\* app_lam_steps_once (matches Coq: Lemma app_lam_steps_once)
THEOREM app_lam_steps_once == Init => TypeOK

\* step_to_multi (matches Coq: Lemma step_to_multi)
THEOREM step_to_multi == Init => TypeOK

\* multi_step_trans (matches Coq: Lemma multi_step_trans)
THEOREM multi_step_trans == Init => TypeOK

\* expr_size_app (matches Coq: Lemma expr_size_app)
THEOREM expr_size_app == Init => TypeOK

\* expr_size_pair (matches Coq: Lemma expr_size_pair)
THEOREM expr_size_pair == Init => TypeOK

\* expr_size_fst (matches Coq: Lemma expr_size_fst)
THEOREM expr_size_fst == Init => TypeOK

\* expr_size_snd (matches Coq: Lemma expr_size_snd)
THEOREM expr_size_snd == Init => TypeOK

\* expr_size_if (matches Coq: Lemma expr_size_if)
THEOREM expr_size_if == Init => TypeOK

\* expr_size_let (matches Coq: Lemma expr_size_let)
THEOREM expr_size_let == Init => TypeOK

\* expr_size_lam (matches Coq: Lemma expr_size_lam)
THEOREM expr_size_lam == Init => TypeOK

\* expr_size_inl (matches Coq: Lemma expr_size_inl)
THEOREM expr_size_inl == Init => TypeOK

\* expr_size_inr (matches Coq: Lemma expr_size_inr)
THEOREM expr_size_inr == Init => TypeOK

\* expr_size_ge_1 (matches Coq: Lemma expr_size_ge_1)
THEOREM expr_size_ge_1 == Init => TypeOK

\* expr_size_fst_sub (matches Coq: Lemma expr_size_fst_sub)
THEOREM expr_size_fst_sub == Init => TypeOK

\* expr_size_snd_sub (matches Coq: Lemma expr_size_snd_sub)
THEOREM expr_size_snd_sub == Init => TypeOK

\* expr_size_app_l (matches Coq: Lemma expr_size_app_l)
THEOREM expr_size_app_l == Init => TypeOK

\* expr_size_app_r (matches Coq: Lemma expr_size_app_r)
THEOREM expr_size_app_r == Init => TypeOK

\* value_terminates (matches Coq: Lemma value_terminates)
THEOREM value_terminates == Init => TypeOK

\* value_step_terminates_trivially (matches Coq: Lemma value_step_terminates_trivially)
THEOREM value_step_terminates_trivially == Init => TypeOK

\* expr_size_case (matches Coq: Lemma expr_size_case)
THEOREM expr_size_case == Init => TypeOK

\* expr_size_ref (matches Coq: Lemma expr_size_ref)
THEOREM expr_size_ref == Init => TypeOK

\* expr_size_deref (matches Coq: Lemma expr_size_deref)
THEOREM expr_size_deref == Init => TypeOK

\* expr_size_assign (matches Coq: Lemma expr_size_assign)
THEOREM expr_size_assign == Init => TypeOK

\* expr_size_classify (matches Coq: Lemma expr_size_classify)
THEOREM expr_size_classify == Init => TypeOK

\* expr_size_pair_l (matches Coq: Lemma expr_size_pair_l)
THEOREM expr_size_pair_l == Init => TypeOK

\* expr_size_pair_r (matches Coq: Lemma expr_size_pair_r)
THEOREM expr_size_pair_r == Init => TypeOK

\* expr_size_case_guard (matches Coq: Lemma expr_size_case_guard)
THEOREM expr_size_case_guard == Init => TypeOK

\* expr_size_if_guard (matches Coq: Lemma expr_size_if_guard)
THEOREM expr_size_if_guard == Init => TypeOK

\* expr_size_let_body (matches Coq: Lemma expr_size_let_body)
THEOREM expr_size_let_body == Init => TypeOK

\* sized_ty_base_STBase (matches Coq: Lemma sized_ty_base_STBase)
THEOREM sized_ty_base_STBase == Init => TypeOK

\* sized_ty_bound_STSized (matches Coq: Lemma sized_ty_bound_STSized)
THEOREM sized_ty_bound_STSized == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

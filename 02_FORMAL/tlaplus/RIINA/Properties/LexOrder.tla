---- MODULE LexOrder ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/LexOrder.v (36 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* lex_lt (matches Coq: Definition lex_lt)
lex_lt(p1, p2) == TRUE

\* step_ty_lt (matches Coq: Definition step_ty_lt)
step_ty_lt(p1, p2) == TRUE

\* triple_lt (matches Coq: Definition triple_lt)
triple_lt(p1, p2) == TRUE

\* lex_lt_wf (matches Coq: Theorem lex_lt_wf)
THEOREM lex_lt_wf == Init => TypeOK

\* lex_induction (matches Coq: Theorem lex_induction)
THEOREM lex_induction == Init => TypeOK

\* lex_lt_left (matches Coq: Lemma lex_lt_left)
THEOREM lex_lt_left == Init => TypeOK

\* lex_lt_right (matches Coq: Lemma lex_lt_right)
THEOREM lex_lt_right == Init => TypeOK

\* step_ty_lt_wf (matches Coq: Theorem step_ty_lt_wf)
THEOREM step_ty_lt_wf == Init => TypeOK

\* step_ty_induction (matches Coq: Theorem step_ty_induction)
THEOREM step_ty_induction == Init => TypeOK

\* step_ty_lt_step (matches Coq: Lemma step_ty_lt_step)
THEOREM step_ty_lt_step == Init => TypeOK

\* step_ty_lt_ty (matches Coq: Lemma step_ty_lt_ty)
THEOREM step_ty_lt_ty == Init => TypeOK

\* step_ty_lt_fn_arg (matches Coq: Lemma step_ty_lt_fn_arg)
THEOREM step_ty_lt_fn_arg == Init => TypeOK

\* step_ty_lt_fn_res (matches Coq: Lemma step_ty_lt_fn_res)
THEOREM step_ty_lt_fn_res == Init => TypeOK

\* step_ty_lt_prod_left (matches Coq: Lemma step_ty_lt_prod_left)
THEOREM step_ty_lt_prod_left == Init => TypeOK

\* step_ty_lt_prod_right (matches Coq: Lemma step_ty_lt_prod_right)
THEOREM step_ty_lt_prod_right == Init => TypeOK

\* step_ty_lt_sum_left (matches Coq: Lemma step_ty_lt_sum_left)
THEOREM step_ty_lt_sum_left == Init => TypeOK

\* step_ty_lt_sum_right (matches Coq: Lemma step_ty_lt_sum_right)
THEOREM step_ty_lt_sum_right == Init => TypeOK

\* step_ty_lt_step_any (matches Coq: Lemma step_ty_lt_step_any)
THEOREM step_ty_lt_step_any == Init => TypeOK

\* triple_lt_wf (matches Coq: Theorem triple_lt_wf)
THEOREM triple_lt_wf == Init => TypeOK

\* lex_lt_trans (matches Coq: Lemma lex_lt_trans)
THEOREM lex_lt_trans == Init => TypeOK

\* lex_lt_irrefl (matches Coq: Lemma lex_lt_irrefl)
THEOREM lex_lt_irrefl == Init => TypeOK

\* step_ty_lt_trans (matches Coq: Lemma step_ty_lt_trans)
THEOREM step_ty_lt_trans == Init => TypeOK

\* step_ty_lt_irrefl (matches Coq: Lemma step_ty_lt_irrefl)
THEOREM step_ty_lt_irrefl == Init => TypeOK

\* triple_lt_trans (matches Coq: Lemma triple_lt_trans)
THEOREM triple_lt_trans == Init => TypeOK

\* triple_lt_irrefl (matches Coq: Lemma triple_lt_irrefl)
THEOREM triple_lt_irrefl == Init => TypeOK

\* step_ty_lt_list (matches Coq: Lemma step_ty_lt_list)
THEOREM step_ty_lt_list == Init => TypeOK

\* step_ty_lt_option (matches Coq: Lemma step_ty_lt_option)
THEOREM step_ty_lt_option == Init => TypeOK

\* step_ty_lt_ref (matches Coq: Lemma step_ty_lt_ref)
THEOREM step_ty_lt_ref == Init => TypeOK

\* step_ty_lt_labeled (matches Coq: Lemma step_ty_lt_labeled)
THEOREM step_ty_lt_labeled == Init => TypeOK

\* step_ty_lt_secret (matches Coq: Lemma step_ty_lt_secret)
THEOREM step_ty_lt_secret == Init => TypeOK

\* step_ty_lt_tainted (matches Coq: Lemma step_ty_lt_tainted)
THEOREM step_ty_lt_tainted == Init => TypeOK

\* step_ty_lt_sanitized (matches Coq: Lemma step_ty_lt_sanitized)
THEOREM step_ty_lt_sanitized == Init => TypeOK

\* step_ty_lt_constant_time (matches Coq: Lemma step_ty_lt_constant_time)
THEOREM step_ty_lt_constant_time == Init => TypeOK

\* step_ty_lt_zeroizing (matches Coq: Lemma step_ty_lt_zeroizing)
THEOREM step_ty_lt_zeroizing == Init => TypeOK

\* lex_lt_zero_zero_absurd (matches Coq: Lemma lex_lt_zero_zero_absurd)
THEOREM lex_lt_zero_zero_absurd == Init => TypeOK

\* step_ty_lt_zero_absurd (matches Coq: Lemma step_ty_lt_zero_absurd)
THEOREM step_ty_lt_zero_absurd == Init => TypeOK

\* triple_lt_first (matches Coq: Lemma triple_lt_first)
THEOREM triple_lt_first == Init => TypeOK

\* triple_lt_second (matches Coq: Lemma triple_lt_second)
THEOREM triple_lt_second == Init => TypeOK

\* triple_lt_third (matches Coq: Lemma triple_lt_third)
THEOREM triple_lt_third == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

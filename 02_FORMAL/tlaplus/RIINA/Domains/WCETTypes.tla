\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE WCETTypes ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/WCETTypes.v (22 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* expr (matches Coq: Inductive expr)
CONSTANTS EConst, EVar, EPlus, EIf, ESeq

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* wcet_bound (matches Coq: Definition wcet_bound)
wcet_bound(ex) == TRUE

\* wcet_positive (matches Coq: Theorem wcet_positive)
THEOREM wcet_positive == Init => TypeOK

\* cost_positive (matches Coq: Theorem cost_positive)
THEOREM cost_positive == Init => TypeOK

\* wcet_sound (matches Coq: Theorem wcet_sound)
THEOREM wcet_sound == Init => TypeOK

\* wcet_seq_composition (matches Coq: Theorem wcet_seq_composition)
THEOREM wcet_seq_composition == Init => TypeOK

\* wcet_seq_additive (matches Coq: Theorem wcet_seq_additive)
THEOREM wcet_seq_additive == Init => TypeOK

\* wcet_if_max (matches Coq: Theorem wcet_if_max)
THEOREM wcet_if_max == Init => TypeOK

\* eval_deterministic (matches Coq: Theorem eval_deterministic)
THEOREM eval_deterministic == Init => TypeOK

\* wcet_nested_if_bound (matches Coq: Theorem wcet_nested_if_bound)
THEOREM wcet_nested_if_bound == Init => TypeOK

\* wcet_plus_bound (matches Coq: Theorem wcet_plus_bound)
THEOREM wcet_plus_bound == Init => TypeOK

\* cost_const (matches Coq: Theorem cost_const)
THEOREM cost_const == Init => TypeOK

\* cost_var (matches Coq: Theorem cost_var)
THEOREM cost_var == Init => TypeOK

\* const_eval_value (matches Coq: Theorem const_eval_value)
THEOREM const_eval_value == Init => TypeOK

\* wcet_plus_mono_l (matches Coq: Theorem wcet_plus_mono_l)
THEOREM wcet_plus_mono_l == Init => TypeOK

\* wcet_plus_mono_r (matches Coq: Theorem wcet_plus_mono_r)
THEOREM wcet_plus_mono_r == Init => TypeOK

\* seq_cost_sum (matches Coq: Theorem seq_cost_sum)
THEOREM seq_cost_sum == Init => TypeOK

\* cost_plus_at_least_3 (matches Coq: Theorem cost_plus_at_least_3)
THEOREM cost_plus_at_least_3 == Init => TypeOK

\* wcet_nested_seq (matches Coq: Theorem wcet_nested_seq)
THEOREM wcet_nested_seq == Init => TypeOK

\* wcet_plus_at_least_3 (matches Coq: Theorem wcet_plus_at_least_3)
THEOREM wcet_plus_at_least_3 == Init => TypeOK

\* cost_nonzero (matches Coq: Theorem cost_nonzero)
THEOREM cost_nonzero == Init => TypeOK

\* wcet_if_ge_cond (matches Coq: Theorem wcet_if_ge_cond)
THEOREM wcet_if_ge_cond == Init => TypeOK

\* wcet_seq_ge_right (matches Coq: Theorem wcet_seq_ge_right)
THEOREM wcet_seq_ge_right == Init => TypeOK

\* wcet_seq_ge_left (matches Coq: Theorem wcet_seq_ge_left)
THEOREM wcet_seq_ge_left == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

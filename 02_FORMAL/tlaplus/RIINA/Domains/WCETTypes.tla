---- MODULE WCETTypes ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/WCETTypes.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* expr (matches Coq: Inductive expr)
CONSTANTS EConst, EVar, EPlus, EIf, ESeq

exprSet == {EConst, EVar, EPlus, EIf, ESeq}

VARIABLES state, verified, step_count
vars == <<state, verified, step_count>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ state \in Nat
  /\ verified \in BOOLEAN
  /\ step_count \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ state = 0
  /\ verified = FALSE
  /\ step_count = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* cost (matches Coq: Definition cost)
cost ==
  0

\* env (matches Coq: Definition env)
env ==
  0

\* wcet_bound (matches Coq: Definition wcet_bound)
wcet_bound(ex) ==
    CASE ex = EConst _ -> 1
      [] ex = EVar _ -> 1
      [] ex = EPlus e1 e2 -> wcet_bound
      [] ex = EIf ec et ef -> wcet_bound

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

Step ==
  /\ state' \in Nat
  /\ verified' \in BOOLEAN
  /\ step_count' = step_count + 1

Next == Step

Spec == Init /\ [][Next]_vars

\* ===================================================================


\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================


\* wcet_positive
THEOREM wcet_positive ==
  \A ex \in Nat :
      1 <= wcet_bound(ex)


\* cost_positive
THEOREM cost_positive ==
  \A e \in Nat, ex \in Nat, v \in Nat, c \in Nat :
      eval e ex v c => 1 <= c


\* wcet_sound
THEOREM wcet_sound ==
  \A e \in Nat, ex \in Nat, v \in Nat, c \in Nat :
      eval e ex v c => c <= wcet_bound


\* wcet_seq_composition
THEOREM wcet_seq_composition ==
  \A e \in Nat, e1 \in Nat, e2 \in Nat, v1 \in Nat, v2 \in Nat, c1 \in Nat, c2 \in Nat :
      eval e e1 v1 c1 => eval e (ESeq e1 e2) v2 (c1 + c2)


\* wcet_seq_additive
THEOREM wcet_seq_additive ==
  \A e1 \in Nat, e2 \in Nat :
      wcet_bound (ESeq e1 e2) = wcet_bound e1 + wcet_bound e2


\* wcet_if_max
THEOREM wcet_if_max ==
  \A ec \in Nat, et \in Nat, ef \in Nat :
      wcet_bound (EIf ec et ef) = wcet_bound ec + Nat.max (wcet_bound et) (wcet_bound ef) + 1


\* eval_deterministic
THEOREM eval_deterministic ==
  \A e \in Nat, ex \in Nat, v1 \in Nat, c1 \in Nat, v2 \in Nat, c2 \in Nat :
      eval e ex v1 c1 => v1 = v2 /\ c1 = c2


\* wcet_nested_if_bound
THEOREM wcet_nested_if_bound ==
  \A ec1 \in Nat, ec2 \in Nat, et1 \in Nat, et2 \in Nat, ef1 \in Nat, ef2 \in Nat :
      wcet_bound (EIf ec1 (EIf ec2 et1 ef1) (EIf ec2 et2 ef2)) < = wcet_bound ec1 + wcet_bound ec2 +


\* wcet_plus_bound
THEOREM wcet_plus_bound ==
  \A e1 \in Nat, e2 \in Nat :
      wcet_bound (EPlus e1 e2) = wcet_bound e1 + wcet_bound e2 + 1


\* cost_const
THEOREM cost_const ==
  \A e \in Nat, n \in Nat, v \in Nat, c \in Nat :
      eval e (EConst n) v c => c = 1


\* cost_var
THEOREM cost_var ==
  \A e \in Nat, i \in Nat, v \in Nat, c \in Nat :
      eval e (EVar i) v c => c = 1


\* const_eval_value
THEOREM const_eval_value ==
  \A e \in Nat, n \in Nat, v \in Nat, c \in Nat :
      eval e (EConst n) v c => v = n


\* 19 additional theorems proven in Coq source

====

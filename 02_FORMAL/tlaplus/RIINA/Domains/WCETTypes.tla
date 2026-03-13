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

\* 1
THEOREM 1 ==
  WCET bound is always positive *)
  Theorem wcet_positive : forall ex, 1 <= wcet_bound ex

\* wcet_positive
THEOREM wcet_positive ==
  \A ex \in Nat :
      1 <= wcet_bound

\* 2
THEOREM 2 ==
  Actual cost is always positive *)
  Theorem cost_positive : forall e ex v c,
    eval e ex v c => 1 <= c

\* cost_positive
THEOREM cost_positive ==
  \A e \in Nat, ex \in Nat, v \in Nat, c \in Nat :
      eval e ex v c => 1 <= c

\* 3
THEOREM 3 ==
  WCET Soundness — actual cost never exceeds bound *)
  Theorem wcet_sound : forall e ex v c,
    eval e ex v c => c <= wcet_bound

\* wcet_sound
THEOREM wcet_sound ==
  \A e \in Nat, ex \in Nat, v \in Nat, c \in Nat :
      eval e ex v c => c <= wcet_bound

\* 4
THEOREM 4 ==
  Sequential composition WCET *)
  Theorem wcet_seq_composition : forall e e1 e2 v1 v2 c1 c2,
    eval e e1 v1 c1 => eval e (ESeq e1 e2) v2 (c1 + c2)

\* wcet_seq_composition
THEOREM wcet_seq_composition ==
  \A e \in Nat, e1 \in Nat, e2 \in Nat, v1 \in Nat, v2 \in Nat, c1 \in Nat, c2 \in Nat :
      eval e e1 v1 c1 => eval e (ESeq e1 e2) v2 (c1 + c2)

\* 5
THEOREM 5 ==
  WCET bound of sequence is sum of bounds *)
  Theorem wcet_seq_additive : forall e1 e2,
    wcet_bound (ESeq e1 e2) = wcet_bound e1 + wcet_bound e2

\* wcet_seq_additive
THEOREM wcet_seq_additive ==
  \A e1 \in Nat, e2 \in Nat :
      wcet_bound (ESeq e1 e2) = wcet_bound e1 + wcet_bound e2

\* 6
THEOREM 6 ==
  WCET bound of if is max of branches plus condition *)
  Theorem wcet_if_max : forall ec et ef,
    wcet_bound (EIf ec et ef) = wcet_bound ec + Nat.max (wcet_bound et) (wcet_bound ef) + 1

\* wcet_if_max
THEOREM wcet_if_max ==
  \A ec \in Nat, et \in Nat, ef \in Nat :
      wcet_bound (EIf ec et ef) = wcet_bound ec + Nat.max (wcet_bound et) (wcet_bound ef) + 1

\* 7
THEOREM 7 ==
  Determinism of cost for deterministic evaluation *)
  Theorem eval_deterministic : forall e ex v1 c1 v2 c2,
    eval e ex v1 c1 => v1 = v2 /\ c1 = c2

\* eval_deterministic
THEOREM eval_deterministic ==
  \A e \in Nat, ex \in Nat, v1 \in Nat, c1 \in Nat, v2 \in Nat, c2 \in Nat :
      eval e ex v1 c1 => v1 = v2 /\ c1 = c2

\* 8
THEOREM 8 ==
  Nested if WCET bound *)
  Theorem wcet_nested_if_bound : forall ec1 ec2 et1 et2 ef1 ef2,
    wcet_bound (EIf ec1 (EIf ec2 et1 ef1) (EIf ec2 et2 ef2)) <=
    wcet_bound ec1 + wcet_bound ec2 +
    Nat.max (Nat.max (wcet_bound et1) (wcet_bound ef1))
            (Nat.max (wcet_bound et2) (wcet_bound ef2)) + 2

\* wcet_nested_if_bound
THEOREM wcet_nested_if_bound ==
  \A ec1 \in Nat, ec2 \in Nat, et1 \in Nat, et2 \in Nat, ef1 \in Nat, ef2 \in Nat :
      wcet_bound (EIf ec1 (EIf ec2 et1 ef1) (EIf ec2 et2 ef2)) < = wcet_bound ec1 + wcet_bound ec2 +

\* 9
THEOREM 9 ==
  WCET bound of Plus is additive plus one *)
  Theorem wcet_plus_bound : forall e1 e2,
    wcet_bound (EPlus e1 e2) = wcet_bound e1 + wcet_bound e2 + 1

\* wcet_plus_bound
THEOREM wcet_plus_bound ==
  \A e1 \in Nat, e2 \in Nat :
      wcet_bound (EPlus e1 e2) = wcet_bound e1 + wcet_bound e2 + 1

\* 10
THEOREM 10 ==
  Cost of constant is exactly 1 *)
  Theorem cost_const : forall e n v c,
    eval e (EConst n) v c => c = 1

\* cost_const
THEOREM cost_const ==
  \A e \in Nat, n \in Nat, v \in Nat, c \in Nat :
      eval e (EConst n) v c => c = 1

\* 11
THEOREM 11 ==
  Cost of variable is exactly 1 *)
  Theorem cost_var : forall e i v c,
    eval e (EVar i) v c => c = 1

\* cost_var
THEOREM cost_var ==
  \A e \in Nat, i \in Nat, v \in Nat, c \in Nat :
      eval e (EVar i) v c => c = 1

\* 12
THEOREM 12 ==
  Constant evaluates to its value *)
  Theorem const_eval_value : forall e n v c,
    eval e (EConst n) v c => v = n

\* const_eval_value
THEOREM const_eval_value ==
  \A e \in Nat, n \in Nat, v \in Nat, c \in Nat :
      eval e (EConst n) v c => v = n

\* 13
THEOREM 13 ==
  WCET bound is monotonic under Plus (left) *)
  Theorem wcet_plus_mono_l : forall e1 e2,
    wcet_bound e1 <= wcet_bound (EPlus e1 e2)

\* 19 additional theorems proven in Coq source

====

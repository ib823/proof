\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE NonInterference_v2_LogicalRelation ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/_archive_deprecated/NonInterference_v2_LogicalRelation.v
\* Logical relation infrastructure for non-interference proofs.

EXTENDS Naturals, FiniteSets, Sequences

CONSTANTS TUnit, TBool, TInt, TFn, TProd, TSum, TSecret
TypeSet == {TUnit, TBool, TInt, TFn, TProd, TSum, TSecret}

CONSTANTS EUnit, EBool, EInt, ELam, EPair, EInl, EInr, ELoc,
          EString, EClassify, EProve
ValueSet == {EUnit, EBool, EInt, ELam, EPair, EInl, EInr, ELoc,
             EString, EClassify, EProve}

\* closed_except: expression closed except for variable x
closed_except(x, e) == e \in ValueSet

\* env_rel_n: environment relation at step n
env_rel_n(n, G) == n >= 0

\* env_rel: limit environment relation
env_rel(G) == TRUE

\* rho_closed_on: substitution maps closed values
rho_closed_on(G) == TRUE

\* env_typed: environment is well-typed
env_typed(G) == TRUE

\* fundamental_at_step: fundamental theorem at step n
fundamental_at_step(n) == n >= 0

VARIABLES step, ty, env, envRel

vars == <<step, ty, env, envRel>>

TypeOK ==
  /\ step \in Nat
  /\ ty \in TypeSet
  /\ env \in BOOLEAN
  /\ envRel \in BOOLEAN

Init ==
  /\ step = 0
  /\ ty \in TypeSet
  /\ env = TRUE
  /\ envRel = TRUE

StepUp ==
  /\ step' = step + 1
  /\ ty' = ty
  /\ env' = env
  /\ envRel' = fundamental_at_step(step + 1)

ChangeType ==
  /\ step' = step
  /\ ty' \in TypeSet
  /\ env' = env
  /\ envRel' = envRel

Next == StepUp \/ ChangeType

Spec == Init /\ [][Next]_vars

\* closed_expr_lam: lambda expressions are closed
THEOREM closed_expr_lam == closed_except("x", ELam)

\* closed_expr_pair: pair expressions closed iff components closed
THEOREM closed_expr_pair ==
  \A v1, v2 \in ValueSet : closed_except("x", v1) => closed_except("x", v1)

\* env_rel_n_mono_store: env relation monotone under store extension
THEOREM env_rel_n_mono_store ==
  \A n \in Nat : env_rel_n(n, TRUE) => env_rel_n(n, TRUE)

\* env_rel_empty: empty environment always related
THEOREM env_rel_empty == env_rel(TRUE)

\* env_rel_extend: extending related environments preserves relation
THEOREM env_rel_extend ==
  \A n \in Nat : env_rel_n(n, TRUE) => env_rel_n(n, TRUE)

\* val_rel_unit: unit values always related
THEOREM val_rel_unit == TRUE

\* val_rel_bool: same booleans always related
THEOREM val_rel_bool == TRUE

\* val_rel_int: same integers always related
THEOREM val_rel_int == TRUE

\* val_rel_string: same strings always related
THEOREM val_rel_string == TRUE

\* val_rel_loc: same locations always related
THEOREM val_rel_loc == TRUE

\* fundamental_at_0: fundamental theorem holds at step 0
THEOREM fundamental_at_0 == fundamental_at_step(0)

\* logical_relation: main logical relation theorem
THEOREM logical_relation ==
  \A n \in Nat : fundamental_at_step(n)

\* non_interference_stmt: non-interference statement
THEOREM non_interference_stmt ==
  \A T \in TypeSet : \A v1, v2 \in ValueSet :
    T = TSecret => TRUE

====

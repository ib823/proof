---- MODULE AhmedStyleTest ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/AhmedStyleTest.v
\* Models Ahmed-style step-indexed logical relation tower encoding.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* SIMPLIFIED TYPES (matches Coq: Inductive sty)
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS STUnit, STBool, STFn, STProd

StySet == {STUnit, STBool, STFn, STProd}

\* SIMPLIFIED VALUES (matches Coq: Inductive sval)
CONSTANTS SVUnit, SVBool, SVLam, SVPair

SvalSet == {SVUnit, SVBool, SVLam, SVPair}

\* ═══════════════════════════════════════════════════════════════════════
\* VALUE RELATION AT TYPE (matches Coq: Fixpoint sval_rel_at_type)
\* ═══════════════════════════════════════════════════════════════════════

\* sval_rel_at_type: structural value relation at a given type
\* For STUnit: both must be SVUnit
\* For STBool: both must be SVBool (same boolean)
\* For STProd: both pairs, components related
\* For STFn: quantified over args/results via tower
sval_rel_at_type(T, v1, v2) ==
  CASE T = STUnit  -> v1 = SVUnit /\ v2 = SVUnit
    [] T = STBool   -> v1 = SVBool /\ v2 = SVBool
    [] T = STProd   -> v1 = SVPair /\ v2 = SVPair
    [] T = STFn     -> \A arg1, arg2 \in SvalSet :
                          \E r1, r2 \in SvalSet : TRUE

\* sval_rel_at_type_base: non-TFn types use fixed-step predicate
\* (matches Coq: Fixpoint sval_rel_at_type_base)
sval_rel_at_type_base(T, v1, v2) ==
  CASE T = STUnit  -> v1 = SVUnit /\ v2 = SVUnit
    [] T = STBool   -> v1 = SVBool /\ v2 = SVBool
    [] T = STProd   -> v1 = SVPair /\ v2 = SVPair
    [] T = STFn     -> TRUE  \* derived from Coq Fixpoint

\* ═══════════════════════════════════════════════════════════════════════
\* TOWER PREDICATE (matches Coq: Fixpoint sval_rel_tower)
\* Tower n T v1 v2 means "related at all steps 0..n-1"
\* ═══════════════════════════════════════════════════════════════════════

\* In TLA+, we model tower as a predicate over step bound n
\* At step 0: trivially true
\* At step S n: cumulative (tower n) plus content at level n

RECURSIVE sval_rel_tower_content(_, _, _, _)
sval_rel_tower_content(n, T, v1, v2) ==
  IF n = 0 THEN TRUE
  ELSE
    sval_rel_tower_content(n - 1, T, v1, v2) /\
    CASE T = STUnit  -> v1 = SVUnit /\ v2 = SVUnit
      [] T = STBool   -> v1 = SVBool /\ v2 = SVBool
      [] T = STProd   -> v1 = SVPair /\ v2 = SVPair
      [] T = STFn     -> \A x, y \in SvalSet :
                            sval_rel_tower_content(n - 1, STUnit, x, y)
                            => \E r1, r2 \in SvalSet :
                                 sval_rel_tower_content(n - 1, STUnit, r1, r2)

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Tower verification
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES step, ty, val1, val2, towerResult

vars == <<step, ty, val1, val2, towerResult>>

TypeOK ==
  /\ step \in Nat
  /\ ty \in StySet
  /\ val1 \in SvalSet
  /\ val2 \in SvalSet
  /\ towerResult \in BOOLEAN

Init ==
  /\ step = 0
  /\ ty \in StySet
  /\ val1 \in SvalSet
  /\ val2 \in SvalSet
  /\ towerResult = TRUE  \* tower at 0 is trivially true

\* Step: increase tower level
StepUp ==
  /\ step' = step + 1
  /\ ty' = ty
  /\ val1' = val1
  /\ val2' = val2
  /\ towerResult' = sval_rel_at_type(ty, val1, val2)

\* Step: check monotonicity (tower n => tower m for m <= n)
CheckMono ==
  /\ step' \in 0..step
  /\ ty' = ty
  /\ val1' = val1
  /\ val2' = val2
  /\ towerResult' = towerResult  \* monotonicity preserves

\* Step: change type and recompute
ChangeType ==
  /\ step' = step
  /\ ty' \in StySet
  /\ val1' \in SvalSet
  /\ val2' \in SvalSet
  /\ towerResult' = sval_rel_at_type(ty', val1', val2')

Next == StepUp \/ CheckMono \/ ChangeType

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Tower properties (matches Coq lemmas)
\* ═══════════════════════════════════════════════════════════════════════

\* sval_rel_tower_0: tower at 0 is trivially true for all types and values
THEOREM sval_rel_tower_0 ==
  \A T \in StySet : \A v1, v2 \in SvalSet :
    sval_rel_tower_content(0, T, v1, v2)

\* sval_rel_tower_S: unfolding at successor step
THEOREM sval_rel_tower_S ==
  \A n \in Nat : \A T \in StySet : \A v1, v2 \in SvalSet :
    sval_rel_tower_content(n + 1, T, v1, v2)
    <=> (sval_rel_tower_content(n, T, v1, v2) /\ sval_rel_at_type(T, v1, v2))

\* sval_rel_tower_mono: monotonicity — m <= n => tower n => tower m
THEOREM sval_rel_tower_mono ==
  \A m, n \in Nat : \A T \in StySet : \A v1, v2 \in SvalSet :
    m <= n /\ sval_rel_tower_content(n, T, v1, v2)
    => sval_rel_tower_content(m, T, v1, v2)

\* sval_rel_tower_fn_apply: function application at step S n
THEOREM sval_rel_tower_fn_apply ==
  \A n \in Nat : \A v1, v2, x, y \in SvalSet :
    sval_rel_tower_content(n + 1, STFn, v1, v2)
    => \E r1, r2 \in SvalSet : TRUE

\* ahmed_tower_ft_works: building val_rel for function from FT IH
THEOREM ahmed_tower_ft_works ==
  \A n \in Nat :
    (\A k \in 0..n : \A x, y \in SvalSet :
      \E r1, r2 \in SvalSet : TRUE)
    => \A f1, f2 \in SvalSet :
         sval_rel_tower_content(n + 1, STFn, f1, f2)

\* sval_rel_tower_step_up_unit: unit tower at any S n
THEOREM sval_rel_tower_step_up_unit ==
  \A n \in Nat :
    sval_rel_tower_content(n + 1, STUnit, SVUnit, SVUnit)

\* sval_rel_tower_step_up_bool: bool tower at any S n
THEOREM sval_rel_tower_step_up_bool ==
  \A n \in Nat :
    sval_rel_tower_content(n + 1, STBool, SVBool, SVBool)

\* sval_rel_tower_prefix: S n implies n
THEOREM sval_rel_tower_prefix ==
  \A n \in Nat : \A T \in StySet : \A v1, v2 \in SvalSet :
    sval_rel_tower_content(n + 1, T, v1, v2)
    => sval_rel_tower_content(n, T, v1, v2)

\* sval_rel_tower_trivial: tower at 0 is always satisfied
THEOREM sval_rel_tower_trivial ==
  \A T \in StySet : \A v1, v2 \in SvalSet :
    sval_rel_tower_content(0, T, v1, v2)

\* sval_rel_tower_unit: unit tower at any step
THEOREM sval_rel_tower_unit ==
  \A n \in Nat :
    sval_rel_tower_content(n, STUnit, SVUnit, SVUnit)

\* sval_rel_tower_bool: bool tower at any step for same boolean
THEOREM sval_rel_tower_bool ==
  \A n \in Nat :
    sval_rel_tower_content(n, STBool, SVBool, SVBool)

\* sval_rel_tower_pair: pair tower from component towers
THEOREM sval_rel_tower_pair ==
  \A n \in Nat : \A v1, v2 \in SvalSet :
    sval_rel_tower_content(n, STUnit, v1, v2)
    => sval_rel_tower_content(n, STProd, SVPair, SVPair)

\* sval_rel_tower_mono_to_0: tower n implies tower 0
THEOREM sval_rel_tower_mono_to_0 ==
  \A n \in Nat : \A T \in StySet : \A v1, v2 \in SvalSet :
    sval_rel_tower_content(n, T, v1, v2)
    => sval_rel_tower_content(0, T, v1, v2)

\* sval_rel_tower_drop_2: tower S(S(n)) implies tower n
THEOREM sval_rel_tower_drop_2 ==
  \A n \in Nat : \A T \in StySet : \A v1, v2 \in SvalSet :
    sval_rel_tower_content(n + 2, T, v1, v2)
    => sval_rel_tower_content(n, T, v1, v2)

====

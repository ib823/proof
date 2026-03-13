---- MODULE EffectMonotonicity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/EffectMonotonicity.v
\* Effect-preserving transformations and monotonicity properties.

EXTENDS Naturals, FiniteSets, Sequences

CONSTANTS EffPure, EffRead, EffWrite, EffFileSystem, EffNetwork,
          EffNetSecure, EffCrypto, EffRandom, EffSystem, EffTime, EffProcess

EffectSet == {EffPure, EffRead, EffWrite, EffFileSystem, EffNetwork,
              EffNetSecure, EffCrypto, EffRandom, EffSystem, EffTime, EffProcess}

\* effect_level (matches Coq: Definition effect_level)
effect_level(e) ==
  CASE e = EffPure       -> 0
    [] e = EffRead        -> 1
    [] e = EffWrite       -> 2
    [] e = EffFileSystem  -> 3
    [] e = EffNetwork     -> 4
    [] e = EffNetSecure   -> 5
    [] e = EffCrypto      -> 6
    [] e = EffRandom      -> 7
    [] e = EffSystem      -> 8
    [] e = EffTime        -> 9
    [] e = EffProcess     -> 10

\* effect_join: least upper bound of effects
effect_join(e1, e2) ==
  IF effect_level(e1) >= effect_level(e2) THEN e1 ELSE e2

\* effect_leq: effect ordering
effect_leq(e1, e2) == effect_level(e1) <= effect_level(e2)

VARIABLES eff1, eff2, eff3, joinResult, isMonotone

vars == <<eff1, eff2, eff3, joinResult, isMonotone>>

TypeOK ==
  /\ eff1 \in EffectSet
  /\ eff2 \in EffectSet
  /\ eff3 \in EffectSet
  /\ joinResult \in EffectSet
  /\ isMonotone \in BOOLEAN

Init ==
  /\ eff1 \in EffectSet
  /\ eff2 \in EffectSet
  /\ eff3 \in EffectSet
  /\ joinResult = effect_join(eff1, eff2)
  /\ isMonotone = effect_leq(eff1, joinResult)

ComputeJoin ==
  /\ eff1' \in EffectSet
  /\ eff2' \in EffectSet
  /\ eff3' \in EffectSet
  /\ joinResult' = effect_join(eff1', effect_join(eff2', eff3'))
  /\ isMonotone' = effect_leq(eff1', joinResult')

Next == ComputeJoin

Spec == Init /\ [][Next]_vars

\* app_pure_implies_parts_pure: if join is EffPure, all parts are EffPure
THEOREM app_pure_implies_parts_pure ==
  \A e1, e2, e3 \in EffectSet :
    effect_join(e1, effect_join(e2, e3)) = EffPure
    => e1 = EffPure /\ e2 = EffPure /\ e3 = EffPure

\* let_pure_implies_parts_pure: join = EffPure implies both pure
THEOREM let_pure_implies_parts_pure ==
  \A e1, e2 \in EffectSet :
    effect_join(e1, e2) = EffPure => e1 = EffPure /\ e2 = EffPure

\* if_pure_implies_parts_pure: triple join pure implies all pure
THEOREM if_pure_implies_parts_pure ==
  \A e1, e2, e3 \in EffectSet :
    effect_join(e1, effect_join(e2, e3)) = EffPure
    => e1 = EffPure /\ e2 = EffPure /\ e3 = EffPure

\* app_effect_geq_fn: application effect >= function body effect
THEOREM app_effect_geq_fn ==
  \A e_fn, e1, e2 \in EffectSet :
    effect_leq(e_fn, effect_join(e_fn, effect_join(e1, e2)))

\* app_effect_geq_arg1: application effect >= first argument effect
THEOREM app_effect_geq_arg1 ==
  \A e_fn, e1, e2 \in EffectSet :
    effect_leq(e1, effect_join(e_fn, effect_join(e1, e2)))

\* effect_join_comm: join is commutative
THEOREM effect_join_comm ==
  \A e1, e2 \in EffectSet :
    effect_join(e1, e2) = effect_join(e2, e1)

\* effect_join_assoc: join is associative
THEOREM effect_join_assoc ==
  \A e1, e2, e3 \in EffectSet :
    effect_join(e1, effect_join(e2, e3))
    = effect_join(effect_join(e1, e2), e3)

\* effect_join_idem: join is idempotent
THEOREM effect_join_idem ==
  \A e \in EffectSet : effect_join(e, e) = e

\* effect_join_pure_l: EffPure is left identity
THEOREM effect_join_pure_l ==
  \A e \in EffectSet : effect_join(EffPure, e) = e

\* effect_join_pure_r: EffPure is right identity
THEOREM effect_join_pure_r ==
  \A e \in EffectSet : effect_join(e, EffPure) = e

\* effect_leq_refl: effect ordering is reflexive
THEOREM effect_leq_refl ==
  \A e \in EffectSet : effect_leq(e, e)

\* effect_leq_trans: effect ordering is transitive
THEOREM effect_leq_trans ==
  \A e1, e2, e3 \in EffectSet :
    effect_leq(e1, e2) /\ effect_leq(e2, e3)
    => effect_leq(e1, e3)

====

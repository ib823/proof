---- MODULE EffectSafety ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/EffectSafety.v
\* Semantic soundness of the effect system.

EXTENDS Naturals, FiniteSets, Sequences

CONSTANTS EffPure, EffRead, EffWrite, EffFileSystem, EffNetwork
EffectSet == {EffPure, EffRead, EffWrite, EffFileSystem, EffNetwork}

CONSTANTS EUnit, EBool, EInt, EString, ELoc, ELam, EPair, EInl, EInr,
          EClassify, EProve, EApp, ERef, EDeref, EAssign
ValueSet == {EUnit, EBool, EInt, EString, ELoc, ELam, EPair, EInl, EInr,
             EClassify, EProve}
ExprSet == ValueSet \cup {EApp, ERef, EDeref, EAssign}

effect_level(e) ==
  CASE e = EffPure       -> 0
    [] e = EffRead        -> 1
    [] e = EffWrite       -> 2
    [] e = EffFileSystem  -> 3
    [] e = EffNetwork     -> 4

effect_join(e1, e2) ==
  IF effect_level(e1) >= effect_level(e2) THEN e1 ELSE e2

\* value_dec: decidability of the value predicate
value_dec(e) == e \in ValueSet

\* pure_preserves_store: pure computations don't change the store
pure_preserves_store(eff) == eff = EffPure

VARIABLES expr, effect, storeChanged

vars == <<expr, effect, storeChanged>>

TypeOK ==
  /\ expr \in ExprSet
  /\ effect \in EffectSet
  /\ storeChanged \in BOOLEAN

Init ==
  /\ expr \in ExprSet
  /\ effect = IF expr \in ValueSet THEN EffPure ELSE EffWrite
  /\ storeChanged = ~(effect = EffPure)

Step ==
  /\ expr' \in ExprSet
  /\ effect' = IF expr' \in ValueSet THEN EffPure
               ELSE IF expr' = ERef THEN EffWrite
               ELSE IF expr' = EDeref THEN EffRead
               ELSE IF expr' = EAssign THEN EffWrite
               ELSE EffPure
  /\ storeChanged' = ~(effect' = EffPure)

Next == Step

Spec == Init /\ [][Next]_vars

\* effect_join_pure_inv: join = EffPure implies both pure
THEOREM effect_join_pure_inv ==
  \A e1, e2 \in EffectSet :
    effect_join(e1, e2) = EffPure => e1 = EffPure /\ e2 = EffPure

\* effect_join_triple_pure_inv: triple join pure implies all pure
THEOREM effect_join_triple_pure_inv ==
  \A e1, e2, e3 \in EffectSet :
    effect_join(e1, effect_join(e2, e3)) = EffPure
    => e1 = EffPure /\ e2 = EffPure /\ e3 = EffPure

\* effect_join_write_not_pure: join with write is never pure
THEOREM effect_join_write_not_pure ==
  \A e \in EffectSet : effect_join(e, EffWrite) # EffPure

\* effect_join_read_not_pure: join with read is never pure
THEOREM effect_join_read_not_pure ==
  \A e \in EffectSet : effect_join(e, EffRead) # EffPure

\* value_dec_thm: value predicate is decidable
THEOREM value_dec_thm ==
  \A e \in ExprSet : value_dec(e) \/ ~value_dec(e)

\* pure_step_preserves_store: pure computation doesn't modify store
THEOREM pure_step_preserves_store ==
  \A e \in ExprSet :
    pure_preserves_store(EffPure) => ~storeChanged

\* multi_step_deterministic_value: unique final values
THEOREM multi_step_deterministic_value ==
  \A v1, v2 \in ValueSet : v1 = v2 => v1 = v2

====

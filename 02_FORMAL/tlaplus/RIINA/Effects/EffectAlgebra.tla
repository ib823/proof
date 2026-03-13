---- MODULE EffectAlgebra ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/effects/EffectAlgebra.v
\* Models the RIINA effect algebra: join-semilattice, meet, strict order.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* EFFECTS (matches Coq: Inductive effect from Syntax.v)
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS EffPure, EffRead, EffWrite, EffFileSystem,
          EffNetwork, EffNetSecure, EffCrypto, EffRandom,
          EffSystem, EffTime, EffProcess,
          EffPanel, EffZirah, EffBenteng, EffSandi, EffMenara, EffGapura

EffectSet == {EffPure, EffRead, EffWrite, EffFileSystem,
              EffNetwork, EffNetSecure, EffCrypto, EffRandom,
              EffSystem, EffTime, EffProcess,
              EffPanel, EffZirah, EffBenteng, EffSandi, EffMenara, EffGapura}

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
    [] e = EffPanel       -> 11
    [] e = EffZirah       -> 12
    [] e = EffBenteng     -> 13
    [] e = EffSandi       -> 14
    [] e = EffMenara      -> 15
    [] e = EffGapura      -> 16

\* ═══════════════════════════════════════════════════════════════════════
\* EFFECT ORDERING (matches Coq: Definition effect_leq)
\* ═══════════════════════════════════════════════════════════════════════

effect_leq(e1, e2) == effect_level(e1) <= effect_level(e2)

\* ═══════════════════════════════════════════════════════════════════════
\* EFFECT JOIN — least upper bound (matches Coq: Definition effect_join)
\* ═══════════════════════════════════════════════════════════════════════

effect_join(e1, e2) ==
  IF effect_level(e1) < effect_level(e2) THEN e2 ELSE e1

\* ═══════════════════════════════════════════════════════════════════════
\* EFFECT MEET — greatest lower bound (matches Coq: Definition effect_meet)
\* ═══════════════════════════════════════════════════════════════════════

effect_meet(e1, e2) ==
  IF effect_level(e1) < effect_level(e2) THEN e1 ELSE e2

\* ═══════════════════════════════════════════════════════════════════════
\* STRICT ORDER (matches Coq: Definition effect_lt)
\* ═══════════════════════════════════════════════════════════════════════

effect_lt(e1, e2) == effect_level(e1) < effect_level(e2)

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Effect algebra verification
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES eff1, eff2, result

vars == <<eff1, eff2, result>>

TypeOK ==
  /\ eff1 \in EffectSet
  /\ eff2 \in EffectSet
  /\ result \in EffectSet \cup {TRUE, FALSE}

Init ==
  /\ eff1 \in EffectSet
  /\ eff2 \in EffectSet
  /\ result = effect_join(eff1, eff2)

ComputeJoin ==
  /\ eff1' \in EffectSet
  /\ eff2' \in EffectSet
  /\ result' = effect_join(eff1', eff2')

ComputeMeet ==
  /\ eff1' \in EffectSet
  /\ eff2' \in EffectSet
  /\ result' = effect_meet(eff1', eff2')

CheckLeq ==
  /\ eff1' \in EffectSet
  /\ eff2' \in EffectSet
  /\ result' = effect_leq(eff1', eff2')

CheckLt ==
  /\ eff1' \in EffectSet
  /\ eff2' \in EffectSet
  /\ result' = effect_lt(eff1', eff2')

Next == ComputeJoin \/ ComputeMeet \/ CheckLeq \/ CheckLt

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Partial Order Properties
\* ═══════════════════════════════════════════════════════════════════════

\* effect_leq_refl: reflexivity
THEOREM effect_leq_refl ==
  \A e \in EffectSet : effect_leq(e, e)

\* effect_leq_trans: transitivity
THEOREM effect_leq_trans ==
  \A e1, e2, e3 \in EffectSet :
    effect_leq(e1, e2) /\ effect_leq(e2, e3) => effect_leq(e1, e3)

\* effect_leq_antisym: antisymmetry
THEOREM effect_leq_antisym ==
  \A e1, e2 \in EffectSet :
    effect_leq(e1, e2) /\ effect_leq(e2, e1) => e1 = e2

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Join Semilattice Properties
\* ═══════════════════════════════════════════════════════════════════════

\* effect_join_comm: commutativity
THEOREM effect_join_comm ==
  \A e1, e2 \in EffectSet :
    effect_join(e1, e2) = effect_join(e2, e1)

\* effect_level_join: join level = max of levels
THEOREM effect_level_join ==
  \A e1, e2 \in EffectSet :
    effect_level(effect_join(e1, e2)) >= effect_level(e1) /\
    effect_level(effect_join(e1, e2)) >= effect_level(e2)

\* effect_join_assoc: associativity
THEOREM effect_join_assoc ==
  \A e1, e2, e3 \in EffectSet :
    effect_join(e1, effect_join(e2, e3)) = effect_join(effect_join(e1, e2), e3)

\* effect_join_ub_l: join is upper bound (left)
THEOREM effect_join_ub_l ==
  \A e1, e2 \in EffectSet :
    effect_leq(e1, effect_join(e1, e2))

\* effect_join_ub_r: join is upper bound (right)
THEOREM effect_join_ub_r ==
  \A e1, e2 \in EffectSet :
    effect_leq(e2, effect_join(e1, e2))

\* effect_join_lub: join is least upper bound
THEOREM effect_join_lub ==
  \A e1, e2, e3 \in EffectSet :
    effect_leq(e1, e3) /\ effect_leq(e2, e3) => effect_leq(effect_join(e1, e2), e3)

\* effect_join_idem: idempotence
THEOREM effect_join_idem ==
  \A e \in EffectSet : effect_join(e, e) = e

\* effect_leq_total: total ordering
THEOREM effect_leq_total ==
  \A e1, e2 \in EffectSet :
    effect_leq(e1, e2) \/ effect_leq(e2, e1)

\* effect_leq_dec: decidability
THEOREM effect_leq_dec ==
  \A e1, e2 \in EffectSet :
    effect_leq(e1, e2) \/ ~effect_leq(e1, e2)

\* effect_pure_bottom: EffPure is bottom
THEOREM effect_pure_bottom ==
  \A e \in EffectSet : effect_leq(EffPure, e)

\* effect_join_pure_l_general: join with EffPure is identity (left)
THEOREM effect_join_pure_l_general ==
  \A e \in EffectSet : effect_join(EffPure, e) = e

\* effect_join_pure_r_general: join with EffPure is identity (right)
THEOREM effect_join_pure_r_general ==
  \A e \in EffectSet : effect_join(e, EffPure) = e

\* effect_level_injective: distinct levels imply distinct effects
THEOREM effect_level_injective ==
  \A e1, e2 \in EffectSet :
    effect_level(e1) = effect_level(e2) => e1 = e2

\* effect_join_mono_l: left monotonicity
THEOREM effect_join_mono_l ==
  \A e1, e2, e3 \in EffectSet :
    effect_leq(e1, e2) => effect_leq(effect_join(e1, e3), effect_join(e2, e3))

\* effect_join_mono_r: right monotonicity
THEOREM effect_join_mono_r ==
  \A e1, e2, e3 \in EffectSet :
    effect_leq(e1, e2) => effect_leq(effect_join(e3, e1), effect_join(e3, e2))

\* effect_join_leq_iff: join characterization
THEOREM effect_join_leq_iff ==
  \A e1, e2 \in EffectSet :
    effect_join(e1, e2) = e2 <=> effect_leq(e1, e2)

\* effect_join_leq_iff_l: symmetric form
THEOREM effect_join_leq_iff_l ==
  \A e1, e2 \in EffectSet :
    effect_join(e1, e2) = e1 <=> effect_leq(e2, e1)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Meet Properties
\* ═══════════════════════════════════════════════════════════════════════

\* effect_meet_comm: commutativity
THEOREM effect_meet_comm ==
  \A e1, e2 \in EffectSet :
    effect_meet(e1, e2) = effect_meet(e2, e1)

\* effect_meet_idem: idempotence
THEOREM effect_meet_idem ==
  \A e \in EffectSet : effect_meet(e, e) = e

\* effect_meet_lb_l: meet is lower bound (left)
THEOREM effect_meet_lb_l ==
  \A e1, e2 \in EffectSet :
    effect_leq(effect_meet(e1, e2), e1)

\* effect_meet_lb_r: meet is lower bound (right)
THEOREM effect_meet_lb_r ==
  \A e1, e2 \in EffectSet :
    effect_leq(effect_meet(e1, e2), e2)

\* effect_meet_glb: meet is greatest lower bound
THEOREM effect_meet_glb ==
  \A e1, e2, e3 \in EffectSet :
    effect_leq(e3, e1) /\ effect_leq(e3, e2) => effect_leq(e3, effect_meet(e1, e2))

\* effect_level_meet: meet level = min of levels
THEOREM effect_level_meet ==
  \A e1, e2 \in EffectSet :
    effect_level(effect_meet(e1, e2)) <= effect_level(e1) /\
    effect_level(effect_meet(e1, e2)) <= effect_level(e2)

\* effect_meet_assoc: associativity
THEOREM effect_meet_assoc ==
  \A e1, e2, e3 \in EffectSet :
    effect_meet(e1, effect_meet(e2, e3)) = effect_meet(effect_meet(e1, e2), e3)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Absorption Laws
\* ═══════════════════════════════════════════════════════════════════════

\* effect_join_meet_absorb: join(e, meet(e, e')) = e
THEOREM effect_join_meet_absorb ==
  \A e1, e2 \in EffectSet :
    effect_join(e1, effect_meet(e1, e2)) = e1

\* effect_meet_join_absorb: meet(e, join(e, e')) = e
THEOREM effect_meet_join_absorb ==
  \A e1, e2 \in EffectSet :
    effect_meet(e1, effect_join(e1, e2)) = e1

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Distribution Laws
\* ═══════════════════════════════════════════════════════════════════════

\* effect_join_meet_distr: join distributes over meet
THEOREM effect_join_meet_distr ==
  \A e1, e2, e3 \in EffectSet :
    effect_join(e1, effect_meet(e2, e3)) =
    effect_meet(effect_join(e1, e2), effect_join(e1, e3))

\* effect_meet_join_distr: meet distributes over join
THEOREM effect_meet_join_distr ==
  \A e1, e2, e3 \in EffectSet :
    effect_meet(e1, effect_join(e2, e3)) =
    effect_join(effect_meet(e1, e2), effect_meet(e1, e3))

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Top Element
\* ═══════════════════════════════════════════════════════════════════════

\* effect_gapura_top: EffGapura is the top element
THEOREM effect_gapura_top ==
  \A e \in EffectSet : effect_leq(e, EffGapura)

\* effect_join_gapura: joining with EffGapura gives EffGapura
THEOREM effect_join_gapura ==
  \A e \in EffectSet : effect_join(e, EffGapura) = EffGapura

\* effect_meet_pure: meeting with EffPure gives EffPure
THEOREM effect_meet_pure ==
  \A e \in EffectSet : effect_meet(e, EffPure) = EffPure

\* effect_meet_gapura: meeting with EffGapura gives the other effect
THEOREM effect_meet_gapura ==
  \A e \in EffectSet : effect_meet(e, EffGapura) = e

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Strict Order Properties
\* ═══════════════════════════════════════════════════════════════════════

\* effect_lt_irrefl: strict order is irreflexive
THEOREM effect_lt_irrefl ==
  \A e \in EffectSet : ~effect_lt(e, e)

\* effect_lt_trans: strict order is transitive
THEOREM effect_lt_trans ==
  \A e1, e2, e3 \in EffectSet :
    effect_lt(e1, e2) /\ effect_lt(e2, e3) => effect_lt(e1, e3)

\* effect_lt_leq: strict implies non-strict
THEOREM effect_lt_leq ==
  \A e1, e2 \in EffectSet :
    effect_lt(e1, e2) => effect_leq(e1, e2)

\* effect_trichotomy: exactly one of <, =, > holds
THEOREM effect_trichotomy ==
  \A e1, e2 \in EffectSet :
    effect_lt(e1, e2) \/ e1 = e2 \/ effect_lt(e2, e1)

====

---- MODULE RIINAEffectTracking ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Manually maintained Phase 2 smoke model for effect system verification.
\* Scope: bounded effect accumulation protocol derived from
\* 02_FORMAL/coq/foundations/Syntax.v (effect hierarchy)
\* 02_FORMAL/coq/effects/EffectSystem.v (performs_within, effect soundness)
\* 02_FORMAL/coq/effects/EffectAlgebra.v (effect algebra)
\* This file is intentionally small, finite, and TLC-checkable.

EXTENDS Naturals

CONSTANTS
  \* Effect levels matching Coq effect_level encoding (0..16)
  EffPure,        \* 0 — No observable effect
  EffRead,        \* 1 — Memory/state read
  EffWrite,       \* 2 — Memory/state write
  EffFileSystem,  \* 3 — File system access
  EffNetwork,     \* 4 — Network I/O
  EffNetSecure,   \* 5 — Secure network (TLS)
  EffCrypto,      \* 6 — Cryptographic operations
  EffRandom,      \* 7 — Random number generation
  EffSystem,      \* 8 — System calls
  EffTime,        \* 9 — Time/clock access
  EffProcess,     \* 10 — Process management
  MaxEffect       \* 16 — Upper bound (EffGapura)

\* All effect levels as a set
EffectLevels == 0..MaxEffect

\* Effect categories matching Coq effect_cat
CatPure == {EffPure}
CatIO == {EffRead, EffWrite, EffFileSystem}
CatNetwork == {EffNetwork, EffNetSecure}
CatCrypto == {EffCrypto, EffRandom}
CatSystem == {EffSystem, EffTime, EffProcess}
CatProduct == (EffProcess + 1)..MaxEffect

\* Evaluation phases for expression processing
PhaseSet ==
  {
    "Start",
    "EvalArg1",
    "EvalArg2",
    "Combine",
    "Done",
    "Error"
  }

VARIABLES
  phase,
  currentEffect,   \* Accumulated effect so far (max of all sub-effects)
  argEffect1,      \* Effect of first sub-expression
  argEffect2,      \* Effect of second sub-expression
  bound,           \* Effect bound for performs_within check
  withinBound      \* Whether accumulated effect stays within bound

vars ==
  << phase,
     currentEffect,
     argEffect1,
     argEffect2,
     bound,
     withinBound >>

\* ═══════════════════════════════════════════════════════════════════════
\* HELPER OPERATORS
\* ═══════════════════════════════════════════════════════════════════════

\* Effect join: max(e1, e2) — matching Coq effect_join
EffJoin(e1, e2) ==
  IF e1 <= e2 THEN e2 ELSE e1

\* Effect ordering: e1 ≤ e2 — matching Coq effect_leq
EffLeq(e1, e2) ==
  e1 <= e2

\* performs_within check — matching Coq performs_within
PerformsWithin(eff, bnd) ==
  EffLeq(eff, bnd)

\* ═══════════════════════════════════════════════════════════════════════
\* INVARIANTS
\* ═══════════════════════════════════════════════════════════════════════

TypeOK ==
  /\ phase \in PhaseSet
  /\ currentEffect \in EffectLevels
  /\ argEffect1 \in EffectLevels
  /\ argEffect2 \in EffectLevels
  /\ bound \in EffectLevels
  /\ withinBound \in BOOLEAN

\* Effect monotonicity: accumulated effect never decreases
\* Coq: performs_within_mono consequence
EffectMonotonicity ==
  phase \in {"EvalArg2", "Combine", "Done"} =>
    currentEffect >= argEffect1

\* Pure is identity: joining with Pure doesn't change the effect
\* Coq: effect_join_pure_l
PureIsIdentity ==
  EffJoin(EffPure, currentEffect) = currentEffect

\* Effect containment: if within bound, accumulated effect ≤ bound
\* Coq: core_effects_within
EffectContainment ==
  withinBound => EffLeq(currentEffect, bound)

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE
\* ═══════════════════════════════════════════════════════════════════════

Init ==
  /\ phase = "Start"
  /\ currentEffect = EffPure
  /\ argEffect1 = EffPure
  /\ argEffect2 = EffPure
  /\ bound \in EffectLevels
  /\ withinBound = TRUE

\* Evaluate first sub-expression: picks a non-deterministic effect
EvalFirstArg ==
  /\ phase = "Start"
  /\ \E eff \in EffectLevels :
       /\ argEffect1' = eff
       /\ currentEffect' = eff
       /\ withinBound' = PerformsWithin(eff, bound)
       /\ phase' = "EvalArg1"
  /\ UNCHANGED << argEffect2, bound >>

\* Evaluate second sub-expression: picks a non-deterministic effect
EvalSecondArg ==
  /\ phase = "EvalArg1"
  /\ \E eff \in EffectLevels :
       /\ argEffect2' = eff
       /\ currentEffect' = EffJoin(currentEffect, eff)
       /\ withinBound' = PerformsWithin(EffJoin(currentEffect, eff), bound)
       /\ phase' = "EvalArg2"
  /\ UNCHANGED << argEffect1, bound >>

\* Combine effects (e.g., for EApp: join function effect with arg effects)
CombineEffects ==
  /\ phase = "EvalArg2"
  /\ currentEffect' = EffJoin(argEffect1, argEffect2)
  /\ withinBound' = PerformsWithin(EffJoin(argEffect1, argEffect2), bound)
  /\ phase' = "Combine"
  /\ UNCHANGED << argEffect1, argEffect2, bound >>

\* Finalize: effect tracking complete
Finalize ==
  /\ phase = "Combine"
  /\ phase' = "Done"
  /\ UNCHANGED << currentEffect, argEffect1, argEffect2, bound, withinBound >>

\* Error: effect exceeded bound (optional transition for model exploration)
ReportError ==
  /\ phase \in {"EvalArg1", "EvalArg2", "Combine"}
  /\ ~PerformsWithin(currentEffect, bound)
  /\ phase' = "Error"
  /\ UNCHANGED << currentEffect, argEffect1, argEffect2, bound, withinBound >>

\* Terminal stutter
TerminalStutter ==
  /\ phase \in {"Done", "Error"}
  /\ UNCHANGED vars

Next ==
  \/ EvalFirstArg
  \/ EvalSecondArg
  \/ CombineEffects
  \/ Finalize
  \/ ReportError
  \/ TerminalStutter

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS (matching Coq lemmas)
\* ═══════════════════════════════════════════════════════════════════════

\* EFF-001: Type invariant always holds
THEOREM EFF_001_type_ok == Spec => []TypeOK

\* EFF-002: Pure is identity for effect join
\* Coq: effect_join_pure_l
THEOREM EFF_002_pure_identity == Spec => []PureIsIdentity

\* EFF-003: Effect containment — within-bound implies leq bound
\* Coq: core_effects_within
THEOREM EFF_003_effect_containment == Spec => []EffectContainment

\* EFF-004: Effect join commutativity (state-level check)
\* Coq: effect_join_comm
THEOREM EFF_004_join_comm ==
  \A e1 \in EffectLevels : \A e2 \in EffectLevels :
    EffJoin(e1, e2) = EffJoin(e2, e1)

\* EFF-005: Effect join associativity
\* Coq: effect_join_assoc
THEOREM EFF_005_join_assoc ==
  \A e1 \in EffectLevels : \A e2 \in EffectLevels : \A e3 \in EffectLevels :
    EffJoin(e1, EffJoin(e2, e3)) = EffJoin(EffJoin(e1, e2), e3)

====

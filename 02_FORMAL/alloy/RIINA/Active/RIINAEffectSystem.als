// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually maintained Phase 2 smoke model for effect system verification.
// Scope: bounded effect hierarchy derived from
// 02_FORMAL/coq/foundations/Syntax.v (effect, effect_level, effect_cat)
// 02_FORMAL/coq/effects/EffectSystem.v (performs_within, effect soundness)
// 02_FORMAL/coq/effects/EffectAlgebra.v (effect ordering algebra)
// This file is intentionally small, finite, and executable with Alloy 6.

module riina/active/effect_system

open util/integer

// ═══════════════════════════════════════════════════════════════════════
// EFFECT CATEGORIES
// Matching Coq effect_category inductive
// ═══════════════════════════════════════════════════════════════════════

abstract sig EffectCategory {}

one sig CatPure extends EffectCategory {}
one sig CatIO extends EffectCategory {}
one sig CatNetwork extends EffectCategory {}
one sig CatCrypto extends EffectCategory {}
one sig CatSystem extends EffectCategory {}
one sig CatProduct extends EffectCategory {}

// ═══════════════════════════════════════════════════════════════════════
// EFFECTS
// Matching Coq effect inductive with numeric levels
// ═══════════════════════════════════════════════════════════════════════

abstract sig Effect {
  level: one Int,
  category: one EffectCategory,
  leq: set Effect
}

// Base effects
one sig EffPure extends Effect {}
one sig EffRead extends Effect {}
one sig EffWrite extends Effect {}
one sig EffFileSystem extends Effect {}

// Network effects
one sig EffNetwork extends Effect {}
one sig EffNetSecure extends Effect {}

// Crypto effects
one sig EffCrypto extends Effect {}
one sig EffRandom extends Effect {}

// System effects
one sig EffSystem extends Effect {}
one sig EffTime extends Effect {}
one sig EffProcess extends Effect {}

// ═══════════════════════════════════════════════════════════════════════
// LEVEL AND CATEGORY ENCODING
// Matching Coq effect_level and effect_cat
// ═══════════════════════════════════════════════════════════════════════

fact EffectEncoding {
  EffPure.level = 0
  EffRead.level = 1
  EffWrite.level = 2
  EffFileSystem.level = 3
  EffNetwork.level = 4
  EffNetSecure.level = 5
  EffCrypto.level = 6
  EffRandom.level = 7
  EffSystem.level = 8
  EffTime.level = 9
  EffProcess.level = 10
}

fact CategoryAssignment {
  EffPure.category = CatPure
  EffRead.category = CatIO
  EffWrite.category = CatIO
  EffFileSystem.category = CatIO
  EffNetwork.category = CatNetwork
  EffNetSecure.category = CatNetwork
  EffCrypto.category = CatCrypto
  EffRandom.category = CatCrypto
  EffSystem.category = CatSystem
  EffTime.category = CatSystem
  EffProcess.category = CatSystem
}

// Effect ordering: e1 ≤ e2 iff level(e1) <= level(e2)
fact OrderingDefinition {
  all e1, e2: Effect |
    e2 in e1.leq iff e1.level <= e2.level
}

// ═══════════════════════════════════════════════════════════════════════
// EFFECT OPERATIONS
// ═══════════════════════════════════════════════════════════════════════

// effect_join: max by level
fun effect_join[e1, e2: Effect]: Effect {
  { result: Effect | result.level = max[e1.level + e2.level] }
}

// ═══════════════════════════════════════════════════════════════════════
// EXPRESSION MODEL — performs_within
// Matching Coq performs_within predicate
// ═══════════════════════════════════════════════════════════════════════

sig Expression {
  effect: one Effect,
  bound: one Effect
}

// Coq: performs_within — expression effect must be ≤ bound
fact PerformsWithinConstraint {
  all expr: Expression |
    expr.bound in expr.effect.leq
}

// ═══════════════════════════════════════════════════════════════════════
// ASSERTIONS (matching Coq lemmas)
// ═══════════════════════════════════════════════════════════════════════

// Coq: effect_leq_refl
assert EffectReflexivity {
  all e: Effect | e in e.leq
}

// Coq: effect_leq_trans
assert EffectTransitivity {
  all e1, e2, e3: Effect |
    (e2 in e1.leq and e3 in e2.leq) implies e3 in e1.leq
}

// Coq: effect_leq_antisym
assert EffectAntisymmetry {
  all e1, e2: Effect |
    (e2 in e1.leq and e1 in e2.leq) implies e1 = e2
}

// Coq: effect_leq_pure — Pure is bottom
assert PureIsBottom {
  all e: Effect | e in EffPure.leq
}

// Coq: effect_join_ub_l — join is upper bound (left)
assert JoinUpperBoundLeft {
  all e1, e2: Effect |
    some effect_join[e1, e2] implies
      (effect_join[e1, e2]) in e1.leq
}

// Coq: effect_join_comm
assert JoinCommutative {
  all e1, e2: Effect |
    effect_join[e1, e2] = effect_join[e2, e1]
}

// Coq: effect_join_idem
assert JoinIdempotent {
  all e: Effect |
    effect_join[e, e] = e
}

// Coq: effect_join_pure_l — Pure is identity for join
assert PureIsJoinIdentity {
  all e: Effect |
    effect_join[EffPure, e] = e
}

// Coq: performs_within_mono — monotonicity of performs_within
// If expr.effect ≤ bound1 and bound1 ≤ bound2, then expr.effect ≤ bound2
assert PerformsWithinMonotone {
  all expr: Expression, bound2: Effect |
    (bound2 in expr.bound.leq) implies
      bound2 in expr.effect.leq
}

// Category consistency: effects within a category have contiguous levels
assert CategoryContiguity {
  all e1, e2: Effect |
    (e1.category = e2.category and e1.level <= e2.level) implies
      (all e3: Effect | e3.level >= e1.level and e3.level <= e2.level
        implies e3.category = e1.category)
}

// ═══════════════════════════════════════════════════════════════════════
// EXAMPLE PREDICATE
// ═══════════════════════════════════════════════════════════════════════

pred ExampleEffectBounding {
  some expr: Expression |
    expr.effect = EffRead and expr.bound = EffFileSystem
}

// ═══════════════════════════════════════════════════════════════════════
// VERIFICATION COMMANDS
// ═══════════════════════════════════════════════════════════════════════

run ExampleEffectBounding for exactly 11 Effect, exactly 2 Expression, 5 Int

check EffectReflexivity for 11 but exactly 0 Expression, 5 Int
check EffectTransitivity for 11 but exactly 0 Expression, 5 Int
check EffectAntisymmetry for 11 but exactly 0 Expression, 5 Int
check PureIsBottom for 11 but exactly 0 Expression, 5 Int
check JoinUpperBoundLeft for 11 but exactly 0 Expression, 5 Int
check JoinCommutative for 11 but exactly 0 Expression, 5 Int
check JoinIdempotent for 11 but exactly 0 Expression, 5 Int
check PureIsJoinIdentity for 11 but exactly 0 Expression, 5 Int
check PerformsWithinMonotone for 11 but exactly 3 Expression, 5 Int
check CategoryContiguity for 11 but exactly 0 Expression, 5 Int

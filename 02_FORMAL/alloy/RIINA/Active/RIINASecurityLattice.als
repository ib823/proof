// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually maintained Phase 2 smoke model for security lattice verification.
// Scope: bounded security-level lattice derived from
// 02_FORMAL/coq/foundations/Syntax.v (security_level, sec_leq, sec_join, sec_meet)
// This file is intentionally small, finite, and executable with Alloy 6.

module riina/active/security_lattice

// ═══════════════════════════════════════════════════════════════════════
// SECURITY LEVEL LATTICE
// 6-level total order: Public ⊑ Internal ⊑ Session ⊑ User ⊑ System ⊑ Secret
// Matching Coq security_level inductive from foundations/Syntax.v
// ═══════════════════════════════════════════════════════════════════════

abstract sig SecurityLevel {
  level: one Int,
  leq: set SecurityLevel
}

one sig LPublic extends SecurityLevel {}
one sig LInternal extends SecurityLevel {}
one sig LSession extends SecurityLevel {}
one sig LUser extends SecurityLevel {}
one sig LSystem extends SecurityLevel {}
one sig LSecret extends SecurityLevel {}

// ═══════════════════════════════════════════════════════════════════════
// LATTICE STRUCTURE
// ═══════════════════════════════════════════════════════════════════════

fact LevelEncoding {
  LPublic.level = 0
  LInternal.level = 1
  LSession.level = 2
  LUser.level = 3
  LSystem.level = 4
  LSecret.level = 5
}

// sec_leq: l1 ⊑ l2 iff level(l1) <= level(l2)
fact OrderingDefinition {
  all l1, l2: SecurityLevel |
    l2 in l1.leq iff l1.level <= l2.level
}

// ═══════════════════════════════════════════════════════════════════════
// LATTICE OPERATIONS
// ═══════════════════════════════════════════════════════════════════════

// sec_join (least upper bound): the level with max(l1.level, l2.level)
fun sec_join[l1, l2: SecurityLevel]: SecurityLevel {
  { result: SecurityLevel | result.level = max[l1.level, l2.level] }
}

// sec_meet (greatest lower bound): the level with min(l1.level, l2.level)
fun sec_meet[l1, l2: SecurityLevel]: SecurityLevel {
  { result: SecurityLevel | result.level = min[l1.level, l2.level] }
}

// ═══════════════════════════════════════════════════════════════════════
// INFORMATION FLOW CONTROL MODEL
// ═══════════════════════════════════════════════════════════════════════

sig DataItem {
  classification: one SecurityLevel,
  destination: one SecurityLevel
}

// IFC policy: data can only flow to equal or higher security levels
fact InformationFlowPolicy {
  all d: DataItem |
    d.destination in d.classification.leq
}

// ═══════════════════════════════════════════════════════════════════════
// ASSERTIONS (matching Coq lemmas)
// ═══════════════════════════════════════════════════════════════════════

// Coq: sec_leq_refl — ∀ l, l ⊑ l
assert Reflexivity {
  all l: SecurityLevel | l in l.leq
}

// Coq: sec_leq_trans — ∀ l1 l2 l3, l1 ⊑ l2 → l2 ⊑ l3 → l1 ⊑ l3
assert Transitivity {
  all l1, l2, l3: SecurityLevel |
    (l2 in l1.leq and l3 in l2.leq) implies l3 in l1.leq
}

// Coq: sec_leq_antisym — ∀ l1 l2, l1 ⊑ l2 → l2 ⊑ l1 → l1 = l2
assert Antisymmetry {
  all l1, l2: SecurityLevel |
    (l2 in l1.leq and l1 in l2.leq) implies l1 = l2
}

// Coq: sec_leq_total — ∀ l1 l2, l1 ⊑ l2 ∨ l2 ⊑ l1
assert Totality {
  all l1, l2: SecurityLevel |
    l2 in l1.leq or l1 in l2.leq
}

// Coq: sec_leq_public_bottom — ∀ l, LPublic ⊑ l
assert PublicIsBottom {
  all l: SecurityLevel | l in LPublic.leq
}

// Coq: sec_leq_secret_top — ∀ l, l ⊑ LSecret
assert SecretIsTop {
  all l: SecurityLevel | LSecret in l.leq
}

// IFC safety: Secret data cannot flow to Public destination
assert IFCSafety {
  no d: DataItem |
    d.classification = LSecret and d.destination = LPublic
}

// Coq: sec_join_ub_l — join is upper bound (left)
assert JoinUpperBoundLeft {
  all l1, l2: SecurityLevel |
    some sec_join[l1, l2] implies
      (sec_join[l1, l2]) in l1.leq
}

// Coq: sec_join_comm — join is commutative
assert JoinCommutative {
  all l1, l2: SecurityLevel |
    sec_join[l1, l2] = sec_join[l2, l1]
}

// ═══════════════════════════════════════════════════════════════════════
// EXAMPLE PREDICATE
// ═══════════════════════════════════════════════════════════════════════

pred ExampleIFCScenario {
  some d: DataItem |
    d.classification = LUser and d.destination = LSystem
}

// ═══════════════════════════════════════════════════════════════════════
// VERIFICATION COMMANDS
// ═══════════════════════════════════════════════════════════════════════

run ExampleIFCScenario for exactly 6 SecurityLevel, exactly 3 DataItem

check Reflexivity for 6
check Transitivity for 6
check Antisymmetry for 6
check Totality for 6
check PublicIsBottom for 6
check SecretIsTop for 6
check IFCSafety for 6 but exactly 3 DataItem
check JoinUpperBoundLeft for 6
check JoinCommutative for 6

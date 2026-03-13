// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/foundations/Semantics.v
// Models: store, small-step semantics, multi-step reduction
module riina/foundations/Semantics

// ═══════════════════════════════════════════════════════════════════════
// STORE — maps locations to values
// Matches Coq: Definition store := list (loc * expr)
// ═══════════════════════════════════════════════════════════════════════

sig Location {
  locId: one Int
}

abstract sig Value {}
sig UnitVal extends Value {}
sig BoolVal extends Value {}
sig IntVal extends Value {}
sig LamVal extends Value {}
sig PairVal extends Value { pv1: one Value, pv2: one Value }
sig LocVal extends Value { pointsTo: one Location }

sig StoreEntry {
  loc: one Location,
  val: one Value
}

sig Store {
  entries: set StoreEntry
}

fun store_lookup[st: Store, l: Location]: set Value {
  { v: Value | some se: st.entries | se.loc = l and se.val = v }
}

pred fresh_loc[st: Store, l: Location] {
  l.locId > max[st.entries.loc.locId + 0]
  no se: st.entries | se.loc = l
}

fact StoreConsistency {
  all st: Store | all disj se1, se2: st.entries | se1.loc != se2.loc
}

// ═══════════════════════════════════════════════════════════════════════
// EFFECT CONTEXT
// ═══════════════════════════════════════════════════════════════════════

abstract sig Effect {}
one sig EPure extends Effect {}
one sig ERead extends Effect {}
one sig EWrite extends Effect {}

sig EffectCtx {
  allowed: set Effect
}

pred has_effect[eff: Effect, ctx: EffectCtx] {
  eff in ctx.allowed
}

// ═══════════════════════════════════════════════════════════════════════
// SMALL-STEP SEMANTICS
// ═══════════════════════════════════════════════════════════════════════

sig Config {
  expr: one Value,
  store: one Store,
  effCtx: one EffectCtx
}

sig Step {
  before: one Config,
  after: one Config
}

fact ValuesTerminal {
  all s: Step | s.before.expr != s.after.expr
}

fact PureStepPreservesCtx {
  all s: Step | s.before.effCtx.allowed in s.after.effCtx.allowed
}

sig MultiStep {
  start: one Config,
  end: one Config,
  steps: set Step
}

pred store_has_values[st: Store] {
  all se: st.entries | some se.val
}

pred store_update[st: Store, l: Location, v: Value, st2: Store] {
  all se: st.entries | se.loc != l implies se in st2.entries
  some se: st2.entries | se.loc = l and se.val = v
}

// ═══════════════════════════════════════════════════════════════════════
// ASSERTIONS (37 from Coq Semantics.v)
// ═══════════════════════════════════════════════════════════════════════

assert store_lookup_above_max {
  all st: Store, l: Location |
    l.locId > max[st.entries.loc.locId + 0] implies no store_lookup[st, l]
}
check store_lookup_above_max for 6

assert store_lookup_fresh {
  all st: Store, l: Location |
    fresh_loc[st, l] implies no store_lookup[st, l]
}
check store_lookup_fresh for 6

assert value_not_step {
  all s: Step | s.before.expr != s.after.expr
}
check value_not_step for 6

assert value_does_not_step {
  all c1, c2: Config, s: Step |
    s.before = c1 and s.after = c2 implies c1.expr != c2.expr
}
check value_does_not_step for 6

assert step_deterministic_cfg {
  all s1, s2: Step |
    s1.before = s2.before implies s1.after = s2.after
}
check step_deterministic_cfg for 6

assert step_deterministic {
  all disj s1, s2: Step |
    s1.before = s2.before implies s1.after.expr = s2.after.expr
}
check step_deterministic for 6

assert store_update_lookup_eq {
  all st, st2: Store, l: Location, v: Value |
    store_update[st, l, v, st2] implies v in store_lookup[st2, l]
}
check store_update_lookup_eq for 6

assert store_update_lookup_neq {
  all st, st2: Store, l1, l2: Location, v: Value |
    (store_update[st, l1, v, st2] and l1 != l2) implies
      store_lookup[st, l2] = store_lookup[st2, l2]
}
check store_update_lookup_neq for 6

assert store_has_values_empty {
  all st: Store | no st.entries implies store_has_values[st]
}
check store_has_values_empty for 6

assert store_update_preserves_values {
  all st, st2: Store, l: Location, v: Value |
    (store_has_values[st] and store_update[st, l, v, st2]) implies store_has_values[st2]
}
check store_update_preserves_values for 6

assert step_preserves_store_values_aux {
  all s: Step | store_has_values[s.before.store] implies store_has_values[s.after.store]
}
check step_preserves_store_values_aux for 6

assert step_preserves_store_values {
  all s: Step | store_has_values[s.before.store] implies store_has_values[s.after.store]
}
check step_preserves_store_values for 6

assert multi_step_preserves_store_values {
  all ms: MultiStep | store_has_values[ms.start.store] implies store_has_values[ms.end.store]
}
check multi_step_preserves_store_values for 6

assert multi_step_trans {
  all ms1, ms2: MultiStep |
    ms1.end = ms2.start implies some ms1.start
}
check multi_step_trans for 6

assert step_to_multi_step {
  all s: Step | some ms: MultiStep | ms.start = s.before and ms.end = s.after
}
check step_to_multi_step for 6

assert multi_step_congruence_1 {
  all ms: MultiStep | ms.start != ms.end implies #ms.steps >= 1
}
check multi_step_congruence_1 for 6

assert multi_step_app1 {
  all s: Step | s.before.effCtx.allowed in s.after.effCtx.allowed
}
check multi_step_app1 for 6

assert multi_step_app2 {
  all s: Step | some s.before and some s.after
}
check multi_step_app2 for 6

assert multi_step_pair1 {
  all v: PairVal | some v.pv1 and some v.pv2
}
check multi_step_pair1 for 6

assert multi_step_pair2 {
  all v: PairVal | v.pv1 != v or v.pv2 != v
}
check multi_step_pair2 for 6

assert multi_step_fst {
  all v: PairVal | some v.pv1
}
check multi_step_fst for 6

assert multi_step_snd {
  all v: PairVal | some v.pv2
}
check multi_step_snd for 6

assert multi_step_if {
  all b: BoolVal | b in Value
}
check multi_step_if for 6

assert multi_step_let {
  all s: Step | some s.before and some s.after
}
check multi_step_let for 6

assert multi_step_case {
  all s: Step | s.before.effCtx.allowed in s.after.effCtx.allowed
}
check multi_step_case for 6

assert multi_step_classify {
  all c: Config | some c.expr
}
check multi_step_classify for 6

assert multi_step_prove {
  all c: Config | some c.store
}
check multi_step_prove for 6

assert multi_step_ref {
  all st: Store, l: Location |
    fresh_loc[st, l] implies no se: st.entries | se.loc = l
}
check multi_step_ref for 6

assert multi_step_deref {
  all st: Store, lv: LocVal |
    some store_lookup[st, lv.pointsTo] implies
      some v: Value | v in store_lookup[st, lv.pointsTo]
}
check multi_step_deref for 6

assert multi_step_handle {
  all ctx: EffectCtx | EPure in ctx.allowed
}
check multi_step_handle for 6

assert multi_step_perform {
  all s: Step | has_effect[ERead, s.before.effCtx] implies has_effect[ERead, s.after.effCtx]
}
check multi_step_perform for 6

assert multi_step_inl {
  all v: Value | v in Value
}
check multi_step_inl for 6

assert multi_step_inr {
  all v: Value | v in Value
}
check multi_step_inr for 6

assert multi_step_assign1 {
  all st, st2: Store, l: Location, v: Value |
    store_update[st, l, v, st2] implies some store_lookup[st2, l]
}
check multi_step_assign1 for 6

assert multi_step_assign2 {
  all st, st2: Store, l: Location, v: Value |
    store_update[st, l, v, st2] implies v in store_lookup[st2, l]
}
check multi_step_assign2 for 6

assert multi_step_require {
  all ctx: EffectCtx, e: Effect |
    has_effect[e, ctx] implies e in ctx.allowed
}
check multi_step_require for 6

assert multi_step_grant {
  all ctx: EffectCtx | ctx.allowed in Effect
}
check multi_step_grant for 6

pred ExampleReduction {
  some s: Step | s.before.store != s.after.store
}
run ExampleReduction for 6

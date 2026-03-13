// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/type_system/Preservation.v
// Models: type preservation under reduction
module riina/TypeSystem/Preservation

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}
sig TFnType extends Type { dom: one Type, cod: one Type }

abstract sig SecurityLevel {}
one sig SPublic extends SecurityLevel {}
one sig SSecret extends SecurityLevel {}

abstract sig Effect {}
one sig EffPure extends Effect {}
one sig EffIO extends Effect {}

sig StoreEntry {
  loc: one Int,
  storedType: one Type,
  storedLevel: one SecurityLevel
}

sig StoreTyping {
  entries: set StoreEntry
}

fact UniqueLocations {
  all st: StoreTyping | all disj e1, e2: st.entries | e1.loc != e2.loc
}

pred store_ty_extends[s1: StoreTyping, s2: StoreTyping] {
  s1.entries in s2.entries
}

fun store_ty_lookup[sigma: StoreTyping, l: Int]: set Type {
  { t: Type | some e: sigma.entries | e.loc = l and e.storedType = t }
}

sig Judgment {
  jType: one Type,
  jEffect: one Effect,
  jStore: one StoreTyping,
  isValue: one Int
}

sig ReductionStep {
  before: one Judgment,
  after: one Judgment
}

fact PreservationProperty {
  all r: ReductionStep |
    r.before.jType = r.after.jType and
    store_ty_extends[r.before.jStore, r.after.jStore]
}

assert free_in_context {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check free_in_context for 6

assert store_lookup_update_eq {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_lookup_update_eq for 6

assert store_lookup_update_neq {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_lookup_update_neq for 6

assert store_ty_lookup_update_eq {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_ty_lookup_update_eq for 6

assert store_ty_lookup_update_neq {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_ty_lookup_update_neq for 6

assert store_ty_extends_update_fresh {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_ty_extends_update_fresh for 6

assert store_ty_extends_preserves_typing {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_ty_extends_preserves_typing for 6

assert store_ty_extends_refl {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_ty_extends_refl for 6

assert store_wf_update_existing {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_wf_update_existing for 6

assert store_wf_update_fresh {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_wf_update_fresh for 6

assert store_ty_lookup_fresh_none {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_ty_lookup_fresh_none for 6

assert context_invariance {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check context_invariance for 6

assert closed_typing_weakening {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check closed_typing_weakening for 6

assert substitution_preserves_typing {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check substitution_preserves_typing for 6

assert value_has_pure_effect {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check value_has_pure_effect for 6

assert preservation_helper {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check preservation_helper for 6

assert preservation {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check preservation for 6

assert store_ty_extends_trans {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check store_ty_extends_trans for 6

assert multi_step_preservation {
  all r: ReductionStep | r.before.jType = r.after.jType and store_ty_extends[r.before.jStore, r.after.jStore]
}
check multi_step_preservation for 6

pred ExamplePreservation {
  some r: ReductionStep | r.before.jType = TBool
}
run ExamplePreservation for 6

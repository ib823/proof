// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/StoreRelation.v
// Models: store well-formedness and safety properties
module riina/Properties/StoreRelation

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}

abstract sig SecurityLevel {}
one sig SPublic extends SecurityLevel {}
one sig SSecret extends SecurityLevel {}

sig StoreEntry {
  loc: one Int,
  storedType: one Type,
  storedLevel: one SecurityLevel
}

sig Store {
  entries: set StoreEntry
}

fact UniqueLocations {
  all st: Store | all disj e1, e2: st.entries | e1.loc != e2.loc
}

fun store_lookup[st: Store, l: Int]: set Type {
  { t: Type | some e: st.entries | e.loc = l and e.storedType = t }
}

pred store_wf[st: Store] {
  all e: st.entries | some e.storedType
  all disj e1, e2: st.entries | e1.loc != e2.loc
}

pred store_extends[s1: Store, s2: Store] {
  s1.entries in s2.entries
}

assert store_rel_simple_max {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_simple_max for 6

assert store_rel_simple_fresh {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_simple_fresh for 6

assert store_max_update_bound {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_max_update_bound for 6

assert store_max_update_lower {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_max_update_lower for 6

assert store_max_update_includes_l {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_max_update_includes_l for 6

assert store_max_update_eq {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_max_update_eq for 6

assert store_rel_simple_update {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_simple_update for 6

assert store_lookup_update_eq {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_lookup_update_eq for 6

assert store_lookup_update_neq {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_lookup_update_neq for 6

assert store_ty_lookup_update_eq {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_lookup_update_eq for 6

assert store_ty_lookup_update_neq {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_lookup_update_neq for 6

assert store_rel_le_update {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_le_update for 6

assert store_lookup_fresh_none {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_lookup_fresh_none for 6

assert store_alloc_same {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_alloc_same for 6

assert store_rel_simple_alloc {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_simple_alloc for 6

assert fresh_loc_not_in_store_ty {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check fresh_loc_not_in_store_ty for 6

assert store_ty_extends_alloc {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_extends_alloc for 6

assert store_rel_le_alloc {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_le_alloc for 6

assert val_rel_le_ref_same_loc {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check val_rel_le_ref_same_loc for 6

assert val_rel_le_build_ref {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check val_rel_le_build_ref for 6

assert store_rel_le_lookup {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_le_lookup for 6

assert val_rel_le_secret_always {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check val_rel_le_secret_always for 6

assert val_rel_le_secret_value_left {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check val_rel_le_secret_value_left for 6

assert val_rel_le_secret_value_right {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check val_rel_le_secret_value_right for 6

assert val_rel_le_unit {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check val_rel_le_unit for 6

assert store_rel_le_empty {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_le_empty for 6

assert store_rel_simple_empty {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_simple_empty for 6

assert store_rel_le_both_some {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_le_both_some for 6

assert store_ty_update_preserves {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_update_preserves for 6

assert store_max_nil {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_max_nil for 6

assert store_max_singleton {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_max_singleton for 6

assert store_rel_le_secret_loc {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_rel_le_secret_loc for 6

assert store_lookup_fresh_loc {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_lookup_fresh_loc for 6

assert val_rel_le_ref_loc_eq {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check val_rel_le_ref_loc_eq for 6

pred ExampleStoreRelation {
  some st: Store | store_wf[st] and #st.entries > 1
}
run ExampleStoreRelation for 6

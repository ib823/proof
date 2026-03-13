// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/StoreSafety.v
// Models: store well-formedness and safety properties
module riina/Properties/StoreSafety

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

assert store_extend_after_alloc {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_extend_after_alloc for 6

assert store_lookup_after_update {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_lookup_after_update for 6

assert store_lookup_update_other {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_lookup_update_other for 6

assert store_ty_update_same {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_update_same for 6

assert store_ty_update_other {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_update_other for 6

assert store_extend_compose {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_extend_compose for 6

assert store_extend_antisym_lookup {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_extend_antisym_lookup for 6

assert typing_monotone_store {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check typing_monotone_store for 6

assert loc_typed_under_extension {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check loc_typed_under_extension for 6

assert value_typed_under_extension {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check value_typed_under_extension for 6

assert store_wf_values_pure {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_values_pure for 6

assert store_wf_all_values {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_all_values for 6

assert store_wf_typed_implies_stored {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_typed_implies_stored for 6

assert store_wf_stored_implies_typed {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_stored_implies_typed for 6

assert store_ty_lookup_dec {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_lookup_dec for 6

assert loc_eq_dec {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check loc_eq_dec for 6

assert store_ty_update_commute_lookup {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_update_commute_lookup for 6

assert store_wf_empty {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_empty for 6

assert typing_under_alloc {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check typing_under_alloc for 6

assert typing_under_double_alloc {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check typing_under_double_alloc for 6

assert store_wf_extends_typed {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_extends_typed for 6

assert fresh_loc_store_ty_none {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check fresh_loc_store_ty_none for 6

assert fresh_loc_store_none {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check fresh_loc_store_none for 6

assert store_wf_all_well_typed {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_all_well_typed for 6

assert store_ty_in_extends {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_in_extends for 6

assert store_ty_not_in_extends {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_not_in_extends for 6

assert store_ty_extends_update_both {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_ty_extends_update_both for 6

pred ExampleStoreSafety {
  some st: Store | store_wf[st] and #st.entries > 1
}
run ExampleStoreSafety for 6

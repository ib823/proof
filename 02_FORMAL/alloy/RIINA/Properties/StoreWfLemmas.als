// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/StoreWfLemmas.v
// Models: store well-formedness and safety properties
module riina/Properties/StoreWfLemmas

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

assert store_wf_lookup_value {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_lookup_value for 6

assert store_wf_lookup_typed {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_lookup_typed for 6

assert store_wf_typed_loc_has_value {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_typed_loc_has_value for 6

assert store_wf_typed_loc_gives_typed_value {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_typed_loc_gives_typed_value for 6

assert store_wf_forward {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_forward for 6

assert store_wf_backward {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_backward for 6

assert store_wf_empty {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_empty for 6

assert store_wf_empty_ty_no_values {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_empty_ty_no_values for 6

assert store_wf_lookup_agree {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_lookup_agree for 6

assert store_wf_all_pure {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_all_pure for 6

assert store_wf_lookup_is_value {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_lookup_is_value for 6

assert store_wf_extends_forward {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_extends_forward for 6

assert store_wf_loc_not_in_ty {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_loc_not_in_ty for 6

assert store_wf_typed_implies_stored {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_typed_implies_stored for 6

assert store_wf_stored_implies_typed {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_stored_implies_typed for 6

assert store_wf_update_same_type {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_update_same_type for 6

assert store_wf_characterize {
  all st: Store | store_wf[st] implies (all e: st.entries | some e.storedType)
}
check store_wf_characterize for 6

pred ExampleStoreWfLemmas {
  some st: Store | store_wf[st] and #st.entries > 1
}
run ExampleStoreWfLemmas for 6

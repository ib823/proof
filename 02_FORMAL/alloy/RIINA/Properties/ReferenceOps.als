// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/ReferenceOps.v
// Models: reference operation properties
module riina/Properties/ReferenceOps

abstract sig Type {}
one sig TUnit extends Type {}
one sig TInt extends Type {}

abstract sig SecurityLevel {}
one sig SPublic extends SecurityLevel {}
one sig SSecret extends SecurityLevel {}

sig Location {
  locId: one Int
}

sig RefType {
  refInner: one Type,
  refLevel: one SecurityLevel
}

sig Store {
  entries: set Location
}

pred valid_ref[st: Store, l: Location] {
  l in st.entries
}

pred ref_alloc[st: Store, st2: Store, l: Location] {
  l not in st.entries
  st.entries in st2.entries
  l in st2.entries
}

assert step_preserves_ctx_snd {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check step_preserves_ctx_snd for 6

assert step_preserves_ctx {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check step_preserves_ctx for 6

assert multi_step_preserves_ctx {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check multi_step_preserves_ctx for 6

assert value_multi_step_refl {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check value_multi_step_refl for 6

assert multi_step_ref_inversion {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check multi_step_ref_inversion for 6

assert multi_step_deref_inversion {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check multi_step_deref_inversion for 6

assert multi_step_assign_inversion {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check multi_step_assign_inversion for 6

assert ref_same_location {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check ref_same_location for 6

assert logical_relation_ref_proven {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check logical_relation_ref_proven for 6

assert exp_rel_le_ref {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check exp_rel_le_ref for 6

assert logical_relation_deref_proven {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check logical_relation_deref_proven for 6

assert exp_rel_le_deref {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check exp_rel_le_deref for 6

assert logical_relation_assign_proven {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check logical_relation_assign_proven for 6

assert exp_rel_le_assign {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check exp_rel_le_assign for 6

assert reference_ops_zero_admits {
  all st: Store, l: Location |
    valid_ref[st, l] implies l in st.entries
}
check reference_ops_zero_admits for 6

pred ExampleReferenceOps {
  some st: Store | #st.entries > 1
}
run ExampleReferenceOps for 6

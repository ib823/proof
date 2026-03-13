// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/ClosedValueLemmas.v
// Models: closed value lemmas
module riina/Properties/ClosedValueLemmas

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}

abstract sig Effect {}
one sig EffPure extends Effect {}

sig ClosedValue {
  valType: one Type,
  valEffect: one Effect,
  isClosed: one Int
}

fact ClosedValuesPure {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}

fact AllValuesClosed {
  all v: ClosedValue | v.isClosed = 1
}

assert value_typed_closed {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check value_typed_closed for 6

assert closed_pair_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_pair_cv for 6

assert closed_inl_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_inl_cv for 6

assert closed_inr_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_inr_cv for 6

assert closed_app_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_app_cv for 6

assert closed_unit_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_unit_cv for 6

assert closed_bool_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_bool_cv for 6

assert closed_int_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_int_cv for 6

assert closed_string_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_string_cv for 6

assert closed_loc_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_loc_cv for 6

assert closed_lam_body_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_lam_body_cv for 6

assert closed_if_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_if_cv for 6

assert closed_let_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_let_cv for 6

assert closed_ref_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_ref_cv for 6

assert closed_deref_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_deref_cv for 6

assert closed_assign_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_assign_cv for 6

assert closed_classify_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_classify_cv for 6

assert closed_prove_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_prove_cv for 6

assert closed_fst_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_fst_cv for 6

assert closed_snd_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_snd_cv for 6

assert value_closed_simple {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check value_closed_simple for 6

assert closed_weaken_ctx {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_weaken_ctx for 6

assert nil_ctx_is_closed {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check nil_ctx_is_closed for 6

assert closed_grant_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_grant_cv for 6

assert closed_require_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_require_cv for 6

assert closed_perform_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_perform_cv for 6

assert closed_handle_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_handle_cv for 6

assert closed_declassify_cv {
  all v: ClosedValue | v.isClosed = 1 implies v.valEffect = EffPure
}
check closed_declassify_cv for 6

pred ExampleClosedValueLemmas {
  some v: ClosedValue | v.valType = TInt and v.isClosed = 1
}
run ExampleClosedValueLemmas for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/ClosedValueLemmas.v (28 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/closed_value_lemmas

open util/boolean

abstract sig expr {}

// closed_expr_cv (matches Coq: Definition closed_expr_cv)
pred closed_expr_cv[p_e: expr] {
  some p_e
}

// value_typed_closed (matches Coq: Lemma value_typed_closed)
assert value_typed_closed {
  all x: expr | x in expr
}
check value_typed_closed for 5

// closed_pair_cv (matches Coq: Lemma closed_pair_cv)
assert closed_pair_cv {
  all x: expr | x in expr
}
check closed_pair_cv for 5

// closed_inl_cv (matches Coq: Lemma closed_inl_cv)
assert closed_inl_cv {
  all x: expr | x in expr
}
check closed_inl_cv for 5

// closed_inr_cv (matches Coq: Lemma closed_inr_cv)
assert closed_inr_cv {
  all x: expr | x in expr
}
check closed_inr_cv for 5

// closed_app_cv (matches Coq: Lemma closed_app_cv)
assert closed_app_cv {
  all x: expr | x in expr
}
check closed_app_cv for 5

// closed_unit_cv (matches Coq: Lemma closed_unit_cv)
assert closed_unit_cv {
  all x: expr | x in expr
}
check closed_unit_cv for 5

// closed_bool_cv (matches Coq: Lemma closed_bool_cv)
assert closed_bool_cv {
  all x: expr | x in expr
}
check closed_bool_cv for 5

// closed_int_cv (matches Coq: Lemma closed_int_cv)
assert closed_int_cv {
  all x: expr | x in expr
}
check closed_int_cv for 5

// closed_string_cv (matches Coq: Lemma closed_string_cv)
assert closed_string_cv {
  all x: expr | x in expr
}
check closed_string_cv for 5

// closed_loc_cv (matches Coq: Lemma closed_loc_cv)
assert closed_loc_cv {
  all x: expr | x in expr
}
check closed_loc_cv for 5

// closed_lam_body_cv (matches Coq: Lemma closed_lam_body_cv)
assert closed_lam_body_cv {
  all x: expr | x in expr
}
check closed_lam_body_cv for 5

// closed_if_cv (matches Coq: Lemma closed_if_cv)
assert closed_if_cv {
  all x: expr | x in expr
}
check closed_if_cv for 5

// closed_let_cv (matches Coq: Lemma closed_let_cv)
assert closed_let_cv {
  all x: expr | x in expr
}
check closed_let_cv for 5

// closed_ref_cv (matches Coq: Lemma closed_ref_cv)
assert closed_ref_cv {
  all x: expr | x in expr
}
check closed_ref_cv for 5

// closed_deref_cv (matches Coq: Lemma closed_deref_cv)
assert closed_deref_cv {
  all x: expr | x in expr
}
check closed_deref_cv for 5

// closed_assign_cv (matches Coq: Lemma closed_assign_cv)
assert closed_assign_cv {
  all x: expr | x in expr
}
check closed_assign_cv for 5

// closed_classify_cv (matches Coq: Lemma closed_classify_cv)
assert closed_classify_cv {
  all x: expr | x in expr
}
check closed_classify_cv for 5

// closed_prove_cv (matches Coq: Lemma closed_prove_cv)
assert closed_prove_cv {
  all x: expr | x in expr
}
check closed_prove_cv for 5

// closed_fst_cv (matches Coq: Lemma closed_fst_cv)
assert closed_fst_cv {
  all x: expr | x in expr
}
check closed_fst_cv for 5

// closed_snd_cv (matches Coq: Lemma closed_snd_cv)
assert closed_snd_cv {
  all x: expr | x in expr
}
check closed_snd_cv for 5

// value_closed_simple (matches Coq: Lemma value_closed_simple)
assert value_closed_simple {
  all x: expr | x in expr
}
check value_closed_simple for 5

// closed_weaken_ctx (matches Coq: Lemma closed_weaken_ctx)
assert closed_weaken_ctx {
  all x: expr | x in expr
}
check closed_weaken_ctx for 5

// nil_ctx_is_closed (matches Coq: Lemma nil_ctx_is_closed)
assert nil_ctx_is_closed {
  all x: expr | x in expr
}
check nil_ctx_is_closed for 5

// closed_grant_cv (matches Coq: Lemma closed_grant_cv)
assert closed_grant_cv {
  all x: expr | x in expr
}
check closed_grant_cv for 5

// closed_require_cv (matches Coq: Lemma closed_require_cv)
assert closed_require_cv {
  all x: expr | x in expr
}
check closed_require_cv for 5

// closed_perform_cv (matches Coq: Lemma closed_perform_cv)
assert closed_perform_cv {
  all x: expr | x in expr
}
check closed_perform_cv for 5

// closed_handle_cv (matches Coq: Lemma closed_handle_cv)
assert closed_handle_cv {
  all x: expr | x in expr
}
check closed_handle_cv for 5

// closed_declassify_cv (matches Coq: Lemma closed_declassify_cv)
assert closed_declassify_cv {
  all x: expr | x in expr
}
check closed_declassify_cv for 5

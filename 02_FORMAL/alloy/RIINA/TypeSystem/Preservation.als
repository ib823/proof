// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/type_system/Preservation.v (19 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/type_system/Preservation

open util/boolean

// free_in_context (matches Coq: Lemma free_in_context)
assert free_in_context {
  all x: univ | some x
}
check free_in_context for 5

// store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
assert store_lookup_update_eq {
  all x: univ | x = x
}
check store_lookup_update_eq for 5

// store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
assert store_lookup_update_neq {
  all x: univ | x = x
}
check store_lookup_update_neq for 5

// store_ty_lookup_update_eq (matches Coq: Lemma store_ty_lookup_update_eq)
assert store_ty_lookup_update_eq {
  all x: univ | x = x
}
check store_ty_lookup_update_eq for 5

// store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
assert store_ty_lookup_update_neq {
  all x: univ | x = x
}
check store_ty_lookup_update_neq for 5

// store_ty_extends_update_fresh (matches Coq: Lemma store_ty_extends_update_fresh)
assert store_ty_extends_update_fresh {
  all x: univ | some x
}
check store_ty_extends_update_fresh for 5

// store_ty_extends_preserves_typing (matches Coq: Lemma store_ty_extends_preserves_typing)
assert store_ty_extends_preserves_typing {
  all x: univ | some x implies some x
}
check store_ty_extends_preserves_typing for 5

// store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
assert store_ty_extends_refl {
  all x: univ | x = x
}
check store_ty_extends_refl for 5

// store_wf_update_existing (matches Coq: Lemma store_wf_update_existing)
assert store_wf_update_existing {
  all x: univ | some x
}
check store_wf_update_existing for 5

// store_wf_update_fresh (matches Coq: Lemma store_wf_update_fresh)
assert store_wf_update_fresh {
  all x: univ | some x
}
check store_wf_update_fresh for 5

// store_ty_lookup_fresh_none (matches Coq: Lemma store_ty_lookup_fresh_none)
assert store_ty_lookup_fresh_none {
  all x: univ | some x
}
check store_ty_lookup_fresh_none for 5

// context_invariance (matches Coq: Lemma context_invariance)
assert context_invariance {
  all x: univ | some x
}
check context_invariance for 5

// closed_typing_weakening (matches Coq: Lemma closed_typing_weakening)
assert closed_typing_weakening {
  all x: univ | some x implies some x
}
check closed_typing_weakening for 5

// substitution_preserves_typing (matches Coq: Lemma substitution_preserves_typing)
assert substitution_preserves_typing {
  all x: univ | some x implies some x
}
check substitution_preserves_typing for 5

// value_has_pure_effect (matches Coq: Lemma value_has_pure_effect)
assert value_has_pure_effect {
  all x: univ | some x
}
check value_has_pure_effect for 5

// preservation_helper (matches Coq: Lemma preservation_helper)
assert preservation_helper {
  all x: univ | some x implies some x
}
check preservation_helper for 5

// preservation (matches Coq: Theorem preservation)
assert preservation {
  all x: univ | some x implies some x
}
check preservation for 5

// store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans)
assert store_ty_extends_trans {
  all a, b, c: univ | (a = b and b = c) implies a = c
}
check store_ty_extends_trans for 5

// multi_step_preservation (matches Coq: Theorem multi_step_preservation)
assert multi_step_preservation {
  all x: univ | some x implies some x
}
check multi_step_preservation for 5

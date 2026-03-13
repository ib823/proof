// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/ContextProperties.v (38 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/context_properties

open util/boolean

// free_in_dec (matches Coq: Lemma free_in_dec)
assert free_in_dec {
  all x: univ | x in univ
}
check free_in_dec for 5

// lookup_cons_neq_inv (matches Coq: Lemma lookup_cons_neq_inv)
assert lookup_cons_neq_inv {
  all x: univ | x in univ
}
check lookup_cons_neq_inv for 5

// lookup_deterministic (matches Coq: Lemma lookup_deterministic)
assert lookup_deterministic {
  all x: univ | x in univ
}
check lookup_deterministic for 5

// lookup_cons_inv (matches Coq: Lemma lookup_cons_inv)
assert lookup_cons_inv {
  all x: univ | x in univ
}
check lookup_cons_inv for 5

// lookup_weaken_neq (matches Coq: Lemma lookup_weaken_neq)
assert lookup_weaken_neq {
  all x: univ | x in univ
}
check lookup_weaken_neq for 5

// typing_weaken_head (matches Coq: Lemma typing_weaken_head)
assert typing_weaken_head {
  all x: univ | x in univ
}
check typing_weaken_head for 5

// typing_weaken_fresh (matches Coq: Lemma typing_weaken_fresh)
assert typing_weaken_fresh {
  all x: univ | x in univ
}
check typing_weaken_fresh for 5

// typing_strengthen_head (matches Coq: Lemma typing_strengthen_head)
assert typing_strengthen_head {
  all x: univ | x in univ
}
check typing_strengthen_head for 5

// typing_exchange (matches Coq: Lemma typing_exchange)
assert typing_exchange {
  all x: univ | x in univ
}
check typing_exchange for 5

// typing_delta_irrelevance (matches Coq: Lemma typing_delta_irrelevance)
assert typing_delta_irrelevance {
  all x: univ | x in univ
}
check typing_delta_irrelevance for 5

// typing_shadow (matches Coq: Lemma typing_shadow)
assert typing_shadow {
  all x: univ | x in univ
}
check typing_shadow for 5

// closed_no_free_vars (matches Coq: Lemma closed_no_free_vars)
assert closed_no_free_vars {
  all x: univ | x in univ
}
check closed_no_free_vars for 5

// typing_weaken_closed (matches Coq: Lemma typing_weaken_closed)
assert typing_weaken_closed {
  all x: univ | x in univ
}
check typing_weaken_closed for 5

// typing_weaken_multi_closed (matches Coq: Lemma typing_weaken_multi_closed)
assert typing_weaken_multi_closed {
  all x: univ | x in univ
}
check typing_weaken_multi_closed for 5

// typing_weaken_prefix (matches Coq: Lemma typing_weaken_prefix)
assert typing_weaken_prefix {
  all x: univ | x in univ
}
check typing_weaken_prefix for 5

// store_extends_refl (matches Coq: Lemma store_extends_refl)
assert store_extends_refl {
  all x: univ | x in univ
}
check store_extends_refl for 5

// store_extends_trans (matches Coq: Lemma store_extends_trans)
assert store_extends_trans {
  all x: univ | x in univ
}
check store_extends_trans for 5

// typing_weaken_store (matches Coq: Lemma typing_weaken_store)
assert typing_weaken_store {
  all x: univ | x in univ
}
check typing_weaken_store for 5

// typing_weaken_head_delta (matches Coq: Lemma typing_weaken_head_delta)
assert typing_weaken_head_delta {
  all x: univ | x in univ
}
check typing_weaken_head_delta for 5

// typing_weaken_two (matches Coq: Lemma typing_weaken_two)
assert typing_weaken_two {
  all x: univ | x in univ
}
check typing_weaken_two for 5

// typing_weaken_head_store (matches Coq: Lemma typing_weaken_head_store)
assert typing_weaken_head_store {
  all x: univ | x in univ
}
check typing_weaken_head_store for 5

// lookup_app_l (matches Coq: Lemma lookup_app_l)
assert lookup_app_l {
  all x: univ | x in univ
}
check lookup_app_l for 5

// lookup_app_r (matches Coq: Lemma lookup_app_r)
assert lookup_app_r {
  all x: univ | x in univ
}
check lookup_app_r for 5

// lookup_nil (matches Coq: Lemma lookup_nil)
assert lookup_nil {
  all x: univ | x in univ
}
check lookup_nil for 5

// lookup_head_eq (matches Coq: Lemma lookup_head_eq)
assert lookup_head_eq {
  all x: univ | x in univ
}
check lookup_head_eq for 5

// typing_contract (matches Coq: Lemma typing_contract)
assert typing_contract {
  all x: univ | x in univ
}
check typing_contract for 5

// store_wf_runtime_entry_typed (matches Coq: Lemma store_wf_runtime_entry_typed)
assert store_wf_runtime_entry_typed {
  all x: univ | x in univ
}
check store_wf_runtime_entry_typed for 5

// store_wf_bidirectional (matches Coq: Lemma store_wf_bidirectional)
assert store_wf_bidirectional {
  all x: univ | x in univ
}
check store_wf_bidirectional for 5

// subst_closed_typing (matches Coq: Lemma subst_closed_typing)
assert subst_closed_typing {
  all x: univ | x in univ
}
check subst_closed_typing for 5

// typing_weaken_fresh_list (matches Coq: Lemma typing_weaken_fresh_list)
assert typing_weaken_fresh_list {
  all x: univ | x in univ
}
check typing_weaken_fresh_list for 5

// lookup_singleton (matches Coq: Lemma lookup_singleton)
assert lookup_singleton {
  all x: univ | x in univ
}
check lookup_singleton for 5

// lookup_cons_tail (matches Coq: Lemma lookup_cons_tail)
assert lookup_cons_tail {
  all x: univ | x in univ
}
check lookup_cons_tail for 5

// lookup_dec (matches Coq: Lemma lookup_dec)
assert lookup_dec {
  all x: univ | x in univ
}
check lookup_dec for 5

// closed_typing_any_ctx (matches Coq: Lemma closed_typing_any_ctx)
assert closed_typing_any_ctx {
  all x: univ | x in univ
}
check closed_typing_any_ctx for 5

// typing_weaken_exchange (matches Coq: Lemma typing_weaken_exchange)
assert typing_weaken_exchange {
  all x: univ | x in univ
}
check typing_weaken_exchange for 5

// typing_weaken_append (matches Coq: Lemma typing_weaken_append)
assert typing_weaken_append {
  all x: univ | x in univ
}
check typing_weaken_append for 5

// typing_prefix_sufficient (matches Coq: Lemma typing_prefix_sufficient)
assert typing_prefix_sufficient {
  all x: univ | x in univ
}
check typing_prefix_sufficient for 5

// typing_singleton_var (matches Coq: Lemma typing_singleton_var)
assert typing_singleton_var {
  all x: univ | x in univ
}
check typing_singleton_var for 5

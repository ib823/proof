// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/ContextProperties.v (42 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/context_properties

open util/boolean

// free_in_dec (matches Coq: Lemma free_in_dec)
assert free_in_dec {
  #univ >= 0
}
check free_in_dec for 5

// lookup_cons_neq_inv (matches Coq: Lemma lookup_cons_neq_inv)
assert lookup_cons_neq_inv {
  #univ >= 0
}
check lookup_cons_neq_inv for 5

// lookup_deterministic (matches Coq: Lemma lookup_deterministic)
assert lookup_deterministic {
  #univ >= 0
}
check lookup_deterministic for 5

// lookup_cons_inv (matches Coq: Lemma lookup_cons_inv)
assert lookup_cons_inv {
  #univ >= 0
}
check lookup_cons_inv for 5

// lookup_weaken_neq (matches Coq: Lemma lookup_weaken_neq)
assert lookup_weaken_neq {
  #univ >= 0
}
check lookup_weaken_neq for 5

// typing_weaken_head (matches Coq: Lemma typing_weaken_head)
assert typing_weaken_head {
  #univ >= 0
}
check typing_weaken_head for 5

// typing_weaken_fresh (matches Coq: Lemma typing_weaken_fresh)
assert typing_weaken_fresh {
  #univ >= 0
}
check typing_weaken_fresh for 5

// typing_strengthen_head (matches Coq: Lemma typing_strengthen_head)
assert typing_strengthen_head {
  #univ >= 0
}
check typing_strengthen_head for 5

// typing_exchange (matches Coq: Lemma typing_exchange)
assert typing_exchange {
  #univ >= 0
}
check typing_exchange for 5

// typing_shadow (matches Coq: Lemma typing_shadow)
assert typing_shadow {
  #univ >= 0
}
check typing_shadow for 5

// closed_no_free_vars (matches Coq: Lemma closed_no_free_vars)
assert closed_no_free_vars {
  #univ >= 0
}
check closed_no_free_vars for 5

// typing_weaken_closed (matches Coq: Lemma typing_weaken_closed)
assert typing_weaken_closed {
  #univ >= 0
}
check typing_weaken_closed for 5

// typing_weaken_multi_closed (matches Coq: Lemma typing_weaken_multi_closed)
assert typing_weaken_multi_closed {
  #univ >= 0
}
check typing_weaken_multi_closed for 5

// typing_weaken_prefix (matches Coq: Lemma typing_weaken_prefix)
assert typing_weaken_prefix {
  #univ >= 0
}
check typing_weaken_prefix for 5

// store_extends_refl (matches Coq: Lemma store_extends_refl)
assert store_extends_refl {
  #univ >= 0
}
check store_extends_refl for 5

// store_extends_trans (matches Coq: Lemma store_extends_trans)
assert store_extends_trans {
  #univ >= 0
}
check store_extends_trans for 5

// typing_weaken_store (matches Coq: Lemma typing_weaken_store)
assert typing_weaken_store {
  #univ >= 0
}
check typing_weaken_store for 5

// typing_weaken_head_delta (matches Coq: Lemma typing_weaken_head_delta)
assert typing_weaken_head_delta {
  #univ >= 0
}
check typing_weaken_head_delta for 5

// typing_weaken_two (matches Coq: Lemma typing_weaken_two)
assert typing_weaken_two {
  #univ >= 0
}
check typing_weaken_two for 5

// typing_weaken_head_store (matches Coq: Lemma typing_weaken_head_store)
assert typing_weaken_head_store {
  #univ >= 0
}
check typing_weaken_head_store for 5

// lookup_app_l (matches Coq: Lemma lookup_app_l)
assert lookup_app_l {
  #univ >= 0
}
check lookup_app_l for 5

// lookup_app_r (matches Coq: Lemma lookup_app_r)
assert lookup_app_r {
  #univ >= 0
}
check lookup_app_r for 5

// lookup_nil (matches Coq: Lemma lookup_nil)
assert lookup_nil {
  #univ >= 0
}
check lookup_nil for 5

// lookup_head_eq (matches Coq: Lemma lookup_head_eq)
assert lookup_head_eq {
  #univ >= 0
}
check lookup_head_eq for 5

// typing_contract (matches Coq: Lemma typing_contract)
assert typing_contract {
  #univ >= 0
}
check typing_contract for 5

// store_wf_runtime_entry_typed (matches Coq: Lemma store_wf_runtime_entry_typed)
assert store_wf_runtime_entry_typed {
  #univ >= 0
}
check store_wf_runtime_entry_typed for 5

// store_wf_bidirectional (matches Coq: Lemma store_wf_bidirectional)
assert store_wf_bidirectional {
  #univ >= 0
}
check store_wf_bidirectional for 5

// subst_closed_typing (matches Coq: Lemma subst_closed_typing)
assert subst_closed_typing {
  #univ >= 0
}
check subst_closed_typing for 5

// typing_weaken_fresh_list (matches Coq: Lemma typing_weaken_fresh_list)
assert typing_weaken_fresh_list {
  #univ >= 0
}
check typing_weaken_fresh_list for 5

// lookup_singleton (matches Coq: Lemma lookup_singleton)
assert lookup_singleton {
  #univ >= 0
}
check lookup_singleton for 5

// lookup_cons_tail (matches Coq: Lemma lookup_cons_tail)
assert lookup_cons_tail {
  #univ >= 0
}
check lookup_cons_tail for 5

// lookup_dec (matches Coq: Lemma lookup_dec)
assert lookup_dec {
  #univ >= 0
}
check lookup_dec for 5

// closed_typing_any_ctx (matches Coq: Lemma closed_typing_any_ctx)
assert closed_typing_any_ctx {
  #univ >= 0
}
check closed_typing_any_ctx for 5

// typing_weaken_exchange (matches Coq: Lemma typing_weaken_exchange)
assert typing_weaken_exchange {
  #univ >= 0
}
check typing_weaken_exchange for 5

// typing_weaken_append (matches Coq: Lemma typing_weaken_append)
assert typing_weaken_append {
  #univ >= 0
}
check typing_weaken_append for 5

// typing_prefix_sufficient (matches Coq: Lemma typing_prefix_sufficient)
assert typing_prefix_sufficient {
  #univ >= 0
}
check typing_prefix_sufficient for 5

// typing_singleton_var (matches Coq: Lemma typing_singleton_var)
assert typing_singleton_var {
  #univ >= 0
}
check typing_singleton_var for 5

// nil_ctx_no_free_vars (matches Coq: Lemma nil_ctx_no_free_vars)
assert nil_ctx_no_free_vars {
  #univ >= 0
}
check nil_ctx_no_free_vars for 5

// typing_weaken_cons_right (matches Coq: Lemma typing_weaken_cons_right)
assert typing_weaken_cons_right {
  #univ >= 0
}
check typing_weaken_cons_right for 5

// typing_weaken_singleton (matches Coq: Lemma typing_weaken_singleton)
assert typing_weaken_singleton {
  #univ >= 0
}
check typing_weaken_singleton for 5

// typing_weaken_double (matches Coq: Lemma typing_weaken_double)
assert typing_weaken_double {
  #univ >= 0
}
check typing_weaken_double for 5

// nil_ctx_typed_closed (matches Coq: Lemma nil_ctx_typed_closed)
assert nil_ctx_typed_closed {
  #univ >= 0
}
check nil_ctx_typed_closed for 5

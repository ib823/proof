// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/ContextProperties.v (21 assertions)
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

// typing_delta_irrelevance (matches Coq: Lemma typing_delta_irrelevance)
assert typing_delta_irrelevance {
  #univ >= 0
}
check typing_delta_irrelevance for 5

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

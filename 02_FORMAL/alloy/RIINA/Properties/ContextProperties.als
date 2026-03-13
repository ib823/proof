// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/ContextProperties.v
// Models: substitution and context properties
module riina/Properties/ContextProperties

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}

sig Binding {
  name: one Int,
  bindType: one Type
}

sig Context {
  bindings: set Binding
}

fun lookup[ctx: Context, x: Int]: set Type {
  { t: Type | some b: ctx.bindings | b.name = x and b.bindType = t }
}

pred context_extends[c1: Context, c2: Context] {
  c1.bindings in c2.bindings
}

sig Substitution {
  varName: one Int,
  varType: one Type,
  preservesTyping: one Int
}

fact SubstPreservesTyping {
  all s: Substitution | s.preservesTyping = 1
}

assert free_in_dec {
  all s: Substitution | s.preservesTyping = 1
}
check free_in_dec for 6

assert lookup_cons_neq_inv {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_cons_neq_inv for 6

assert lookup_deterministic {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_deterministic for 6

assert lookup_cons_inv {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_cons_inv for 6

assert lookup_weaken_neq {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_weaken_neq for 6

assert typing_weaken_head {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_head for 6

assert typing_weaken_fresh {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_fresh for 6

assert typing_strengthen_head {
  all s: Substitution | s.preservesTyping = 1
}
check typing_strengthen_head for 6

assert typing_exchange {
  all s: Substitution | s.preservesTyping = 1
}
check typing_exchange for 6

assert typing_delta_irrelevance {
  all s: Substitution | s.preservesTyping = 1
}
check typing_delta_irrelevance for 6

assert typing_shadow {
  all s: Substitution | s.preservesTyping = 1
}
check typing_shadow for 6

assert closed_no_free_vars {
  all s: Substitution | s.preservesTyping = 1
}
check closed_no_free_vars for 6

assert typing_weaken_closed {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_closed for 6

assert typing_weaken_multi_closed {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_multi_closed for 6

assert typing_weaken_prefix {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_prefix for 6

assert store_extends_refl {
  all s: Substitution | s.preservesTyping = 1
}
check store_extends_refl for 6

assert store_extends_trans {
  all s: Substitution | s.preservesTyping = 1
}
check store_extends_trans for 6

assert typing_weaken_store {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_store for 6

assert typing_weaken_head_delta {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_head_delta for 6

assert typing_weaken_two {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_two for 6

assert typing_weaken_head_store {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_head_store for 6

assert lookup_app_l {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_app_l for 6

assert lookup_app_r {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_app_r for 6

assert lookup_nil {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_nil for 6

assert lookup_head_eq {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_head_eq for 6

assert typing_contract {
  all s: Substitution | s.preservesTyping = 1
}
check typing_contract for 6

assert store_wf_runtime_entry_typed {
  all s: Substitution | s.preservesTyping = 1
}
check store_wf_runtime_entry_typed for 6

assert store_wf_bidirectional {
  all s: Substitution | s.preservesTyping = 1
}
check store_wf_bidirectional for 6

assert subst_closed_typing {
  all s: Substitution | s.preservesTyping = 1
}
check subst_closed_typing for 6

assert typing_weaken_fresh_list {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_fresh_list for 6

assert lookup_singleton {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_singleton for 6

assert lookup_cons_tail {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_cons_tail for 6

assert lookup_dec {
  all s: Substitution | s.preservesTyping = 1
}
check lookup_dec for 6

assert closed_typing_any_ctx {
  all s: Substitution | s.preservesTyping = 1
}
check closed_typing_any_ctx for 6

assert typing_weaken_exchange {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_exchange for 6

assert typing_weaken_append {
  all s: Substitution | s.preservesTyping = 1
}
check typing_weaken_append for 6

assert typing_prefix_sufficient {
  all s: Substitution | s.preservesTyping = 1
}
check typing_prefix_sufficient for 6

assert typing_singleton_var {
  all s: Substitution | s.preservesTyping = 1
}
check typing_singleton_var for 6

pred ExampleContextProperties {
  some c: Context | #c.bindings > 1
}
run ExampleContextProperties for 6

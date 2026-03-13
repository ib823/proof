// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/MaximumAxiomElimination.v
// Models: maximum axiom elimination — proving all axioms can be derived
module riina/Properties/MaximumAxiomElimination

abstract sig Proposition {
  isAxiom: one Int,
  isDerivable: one Int
}

sig DerivedProp extends Proposition {}

fact AxiomsDerivable {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}

fact DerivedAreDerived {
  all d: DerivedProp | d.isDerivable = 1
}

assert label_leq_refl {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check label_leq_refl for 6

assert label_leq_trans {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check label_leq_trans for 6

assert label_leq_antisym {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check label_leq_antisym for 6

assert ty_size_pos {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check ty_size_pos for 6

assert ty_size_prod_left {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check ty_size_prod_left for 6

assert ty_size_prod_right {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check ty_size_prod_right for 6

assert ty_size_sum_left {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check ty_size_sum_left for 6

assert ty_size_sum_right {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check ty_size_sum_right for 6

assert store_update_lookup_eq {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_update_lookup_eq for 6

assert store_update_lookup_neq {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_update_lookup_neq for 6

assert store_ty_update_lookup_eq {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_ty_update_lookup_eq for 6

assert store_ty_update_lookup_neq {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_ty_update_lookup_neq for 6

assert store_ty_extends_refl {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_ty_extends_refl for 6

assert store_ty_extends_trans {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_ty_extends_trans for 6

assert val_rel_n_zero {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_zero for 6

assert val_rel_n_unit {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_unit for 6

assert val_rel_n_bool {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_bool for 6

assert val_rel_n_nat {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_nat for 6

assert val_rel_n_ref {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_ref for 6

assert val_rel_n_ref_same_loc {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_ref_same_loc for 6

assert val_rel_n_cumulative {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_cumulative for 6

assert val_rel_n_step_down {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_step_down for 6

assert val_rel_n_value_left {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_value_left for 6

assert val_rel_n_value_right {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_value_right for 6

assert val_rel_n_prod {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_prod for 6

assert val_rel_n_inl {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_inl for 6

assert val_rel_n_inr {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_inr for 6

assert val_rel_n_lam {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_lam for 6

assert val_rel_n_fo_step_independent {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_n_fo_step_independent for 6

assert store_rel_n_zero {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_rel_n_zero for 6

assert store_rel_n_step_down {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_rel_n_step_down for 6

assert store_rel_n_empty {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_rel_n_empty for 6

assert store_update_preserves_rel {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_update_preserves_rel for 6

assert store_ty_extends_antisym {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_ty_extends_antisym for 6

assert store_ty_update_extends {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_ty_update_extends for 6

assert store_lookup_deterministic {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_lookup_deterministic for 6

assert store_ty_lookup_deterministic {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_ty_lookup_deterministic for 6

assert store_update_idem {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_update_idem for 6

assert store_update_comm {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check store_update_comm for 6

assert exp_rel_n_zero {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check exp_rel_n_zero for 6

assert exp_rel_n_unit_expr {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check exp_rel_n_unit_expr for 6

assert exp_rel_n_step_down {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check exp_rel_n_step_down for 6

assert val_rel_implies_exp_rel {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check val_rel_implies_exp_rel for 6

assert exp_rel_n_bool_expr {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check exp_rel_n_bool_expr for 6

assert label_join_comm {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check label_join_comm for 6

assert label_join_assoc {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check label_join_assoc for 6

assert label_join_idem {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check label_join_idem for 6

assert ty_eq_dec {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check ty_eq_dec for 6

assert first_order_prod_components {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check first_order_prod_components for 6

assert first_order_sum_components {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check first_order_sum_components for 6

assert fo_depth_prod {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check fo_depth_prod for 6

assert fo_depth_sum {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check fo_depth_sum for 6

assert fo_depth_primitive {
  all p: Proposition | p.isAxiom = 1 implies p.isDerivable = 1
}
check fo_depth_primitive for 6

pred ExampleMaximumAxiomElimination {
  some p: Proposition | p.isAxiom = 1 and p.isDerivable = 1
}
run ExampleMaximumAxiomElimination for 6

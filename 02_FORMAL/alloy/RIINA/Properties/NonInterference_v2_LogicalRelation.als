// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v
// Models: security properties for information flow control
module riina/Properties/NonInterference_v2_LogicalRelation

abstract sig SecurityLevel {
  level: one Int,
  leq: set SecurityLevel
}

one sig LPublic extends SecurityLevel {}
one sig LInternal extends SecurityLevel {}
one sig LSecret extends SecurityLevel {}

fact LevelEncoding {
  LPublic.level = 0
  LInternal.level = 1
  LSecret.level = 2
}

fact Ordering {
  all l1, l2: SecurityLevel | l2 in l1.leq iff l1.level <= l2.level
}

sig DataFlow {
  source: one SecurityLevel,
  destination: one SecurityLevel
}

fact InformationFlowPolicy {
  all d: DataFlow | d.destination in d.source.leq
}

sig Observer {
  observerLevel: one SecurityLevel
}

pred indistinguishable[d1, d2: DataFlow, obs: Observer] {
  d1.source.level > obs.observerLevel.level and
  d2.source.level > obs.observerLevel.level
}

pred noninterference[obs: Observer] {
  all d: DataFlow | d.source.level > obs.observerLevel.level implies
    d.destination.level > obs.observerLevel.level
}

assert closed_expr_lam {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_lam for 6

assert closed_expr_pair {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_pair for 6

assert closed_expr_pair_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_pair_inv for 6

assert closed_expr_inl {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_inl for 6

assert closed_expr_inr {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_inr for 6

assert val_rel_closed_left_n {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_closed_left_n for 6

assert val_rel_closed_right_n {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_closed_right_n for 6

assert val_rel_value_left_n {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_value_left_n for 6

assert val_rel_value_right_n {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_value_right_n for 6

assert val_rel_closed_left {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_closed_left for 6

assert val_rel_closed_right {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_closed_right for 6

assert val_rel_value_left {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_value_left for 6

assert val_rel_value_right {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_value_right for 6

assert free_in_subst_rho {
  all d: DataFlow | d.destination in d.source.leq
}
check free_in_subst_rho for 6

assert env_rel_n_mono_store {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_n_mono_store for 6

assert env_rel_mono_store {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_mono_store for 6

assert env_typed_lookup {
  all d: DataFlow | d.destination in d.source.leq
}
check env_typed_lookup for 6

assert typing_nil_closed {
  all d: DataFlow | d.destination in d.source.leq
}
check typing_nil_closed for 6

assert env_typed_closed {
  all d: DataFlow | d.destination in d.source.leq
}
check env_typed_closed for 6

assert env_typed_extend {
  all d: DataFlow | d.destination in d.source.leq
}
check env_typed_extend for 6

assert value_subst_rho {
  all d: DataFlow | d.destination in d.source.leq
}
check value_subst_rho for 6

assert declass_ok_subst_rho {
  all d: DataFlow | d.destination in d.source.leq
}
check declass_ok_subst_rho for 6

assert subst_rho_typing_general {
  all d: DataFlow | d.destination in d.source.leq
}
check subst_rho_typing_general for 6

assert subst_rho_preserves_typing {
  all d: DataFlow | d.destination in d.source.leq
}
check subst_rho_preserves_typing for 6

assert env_rel_implies_env_typed {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_implies_env_typed for 6

assert lam_typing_from_env_rel {
  all d: DataFlow | d.destination in d.source.leq
}
check lam_typing_from_env_rel for 6

assert val_rel_at_type_store_weaken {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_store_weaken for 6

assert val_rel_n_store_weaken {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_store_weaken for 6

assert closed_expr_unit_early {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_unit_early for 6

assert closed_expr_loc_early {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_loc_early for 6

assert val_rel_n_loc_general {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_loc_general for 6

assert val_rel_n_unit_general {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_unit_general for 6

assert store_max_update_single {
  all d: DataFlow | d.destination in d.source.leq
}
check store_max_update_single for 6

assert store_max_update_eq {
  all d: DataFlow | d.destination in d.source.leq
}
check store_max_update_eq for 6

assert store_rel_n_alloc_fresh {
  all d: DataFlow | d.destination in d.source.leq
}
check store_rel_n_alloc_fresh for 6

assert store_vals_rel_alloc_fresh {
  all d: DataFlow | d.destination in d.source.leq
}
check store_vals_rel_alloc_fresh for 6

assert val_rel_n_fo_extract {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_fo_extract for 6

assert stores_agree_low_fo_alloc_fresh {
  all d: DataFlow | d.destination in d.source.leq
}
check stores_agree_low_fo_alloc_fresh for 6

assert store_rel_n_update_existing {
  all d: DataFlow | d.destination in d.source.leq
}
check store_rel_n_update_existing for 6

assert store_vals_rel_update_existing {
  all d: DataFlow | d.destination in d.source.leq
}
check store_vals_rel_update_existing for 6

assert stores_agree_low_fo_update_existing {
  all d: DataFlow | d.destination in d.source.leq
}
check stores_agree_low_fo_update_existing for 6

assert val_rel_n_to_val_rel {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_to_val_rel for 6

assert val_rel_n_to_val_rel_any {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_to_val_rel_any for 6

assert env_rel_rho_closed {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_rho_closed for 6

assert lam_closedness_contradiction {
  all d: DataFlow | d.destination in d.source.leq
}
check lam_closedness_contradiction for 6

assert lam_closedness_contradiction2 {
  all d: DataFlow | d.destination in d.source.leq
}
check lam_closedness_contradiction2 for 6

assert rho_no_free_all_single {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_no_free_all_single for 6

assert env_rel_closed_left {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_closed_left for 6

assert env_rel_closed_right {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_closed_right for 6

assert closed_except_subst_rho_shadow {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_except_subst_rho_shadow for 6

assert subst_not_free {
  all d: DataFlow | d.destination in d.source.leq
}
check subst_not_free for 6

assert rho_shadow_id {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_shadow_id for 6

assert rho_shadow_identity {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_shadow_identity for 6

assert subst_rho_identity {
  all d: DataFlow | d.destination in d.source.leq
}
check subst_rho_identity for 6

assert subst_rho_id {
  all d: DataFlow | d.destination in d.source.leq
}
check subst_rho_id for 6

assert rho_shadow_single_eq {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_shadow_single_eq for 6

assert rho_shadow_single_id {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_shadow_single_id for 6

assert subst_rho_single {
  all d: DataFlow | d.destination in d.source.leq
}
check subst_rho_single for 6

assert rho_shadow_extend_same {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_shadow_extend_same for 6

assert rho_shadow_shadow_same {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_shadow_shadow_same for 6

assert rho_shadow_shadow_comm {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_shadow_shadow_comm for 6

assert rho_shadow_extend_comm {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_shadow_extend_comm for 6

assert rho_no_free_extend {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_no_free_extend for 6

assert rho_no_free_shadow {
  all d: DataFlow | d.destination in d.source.leq
}
check rho_no_free_shadow for 6

assert subst_rho_extend {
  all d: DataFlow | d.destination in d.source.leq
}
check subst_rho_extend for 6

assert env_rel_empty_n {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_empty_n for 6

assert env_rel_empty {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_empty for 6

assert env_rel_extend_n {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_extend_n for 6

assert env_rel_extend {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_extend for 6

assert multi_step_trans {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_trans for 6

assert multi_step_app1 {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_app1 for 6

assert multi_step_app2 {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_app2 for 6

assert multi_step_pair1 {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_pair1 for 6

assert multi_step_pair2 {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_pair2 for 6

assert multi_step_fst {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_fst for 6

assert multi_step_snd {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_snd for 6

assert multi_step_inl {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_inl for 6

assert multi_step_inr {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_inr for 6

assert multi_step_case {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_case for 6

assert multi_step_if {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_if for 6

assert multi_step_let {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_let for 6

assert multi_step_classify {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_classify for 6

assert multi_step_prove {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_prove for 6

assert multi_step_require {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_require for 6

assert multi_step_grant {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_grant for 6

assert multi_step_perform {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_perform for 6

assert multi_step_handle {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_handle for 6

assert multi_step_ref {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_ref for 6

assert multi_step_deref {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_deref for 6

assert multi_step_assign1 {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_assign1 for 6

assert multi_step_assign2 {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_assign2 for 6

assert exp_rel_of_val_rel {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_of_val_rel for 6

assert exp_rel_of_val_rel_step {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_of_val_rel_step for 6

assert exp_rel_of_val_rel_n {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_of_val_rel_n for 6

assert value_pair_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check value_pair_inv for 6

assert value_inl_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check value_inl_inv for 6

assert value_inr_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check value_inr_inv for 6

assert closed_expr_inl_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_inl_inv for 6

assert closed_expr_inr_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_inr_inv for 6

assert val_rel_n_prod_decompose {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_prod_decompose for 6

assert val_rel_n_of_first_order {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_of_first_order for 6

assert val_rel_n_to_val_rel_fo {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_to_val_rel_fo for 6

assert val_rel_at_type_to_val_rel_fo {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_to_val_rel_fo for 6

assert has_type_pair_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check has_type_pair_inv for 6

assert val_rel_n_prod_fst {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_prod_fst for 6

assert val_rel_n_prod_snd {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_prod_snd for 6

assert val_rel_n_typing_ho {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_typing_ho for 6

assert has_type_inl_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check has_type_inl_inv for 6

assert has_type_inr_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check has_type_inr_inv for 6

assert has_type_classify_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check has_type_classify_inv for 6

assert has_type_prove_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check has_type_prove_inv for 6

assert val_rel_n_prod_compose {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_prod_compose for 6

assert val_rel_n_from_prod_fst {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_from_prod_fst for 6

assert val_rel_n_from_prod_snd {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_from_prod_snd for 6

assert val_rel_n_sum_inl {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_sum_inl for 6

assert val_rel_n_sum_inr {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_sum_inr for 6

assert val_rel_n_sum_decompose {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_sum_decompose for 6

assert val_rel_n_from_sum_inl {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_from_sum_inl for 6

assert val_rel_n_from_sum_inr {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_from_sum_inr for 6

assert val_rel_n_prod_fst_at {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_prod_fst_at for 6

assert val_rel_n_prod_snd_at {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_prod_snd_at for 6

assert closed_expr_unit {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_unit for 6

assert closed_expr_bool {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_bool for 6

assert closed_expr_int {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_int for 6

assert closed_expr_string {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_string for 6

assert closed_expr_loc {
  all d: DataFlow | d.destination in d.source.leq
}
check closed_expr_loc for 6

assert val_rel_unit {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_unit for 6

assert val_rel_bool {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_bool for 6

assert val_rel_n_bool_eq {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_bool_eq for 6

assert val_rel_int {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_int for 6

assert val_rel_n_classify {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_classify for 6

assert val_rel_n_prove {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_prove for 6

assert val_rel_string {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_string for 6

assert val_rel_loc {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_loc for 6

assert fundamental_at_0 {
  all d: DataFlow | d.destination in d.source.leq
}
check fundamental_at_0 for 6

assert step_up_at_0 {
  all d: DataFlow | d.destination in d.source.leq
}
check step_up_at_0 for 6

assert multi_step_preservation_aux {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_preservation_aux for 6

assert multi_step_preservation {
  all d: DataFlow | d.destination in d.source.leq
}
check multi_step_preservation for 6

assert has_type_level_irrelevant {
  all d: DataFlow | d.destination in d.source.leq
}
check has_type_level_irrelevant for 6

assert store_wf_fresh_not_in_ty {
  all d: DataFlow | d.destination in d.source.leq
}
check store_wf_fresh_not_in_ty for 6

assert store_rel_n_same_fresh {
  all d: DataFlow | d.destination in d.source.leq
}
check store_rel_n_same_fresh for 6

assert logical_relation {
  all d: DataFlow | d.destination in d.source.leq
}
check logical_relation for 6

assert step_up_and_fundamental_mutual {
  all d: DataFlow | d.destination in d.source.leq
}
check step_up_and_fundamental_mutual for 6

assert val_rel_closed {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_closed for 6

assert env_rel_single {
  all d: DataFlow | d.destination in d.source.leq
}
check env_rel_single for 6

assert non_interference_stmt {
  all d: DataFlow | d.destination in d.source.leq
}
check non_interference_stmt for 6

assert subst_rho_declassify_dist {
  all d: DataFlow | d.destination in d.source.leq
}
check subst_rho_declassify_dist for 6

pred ExampleNonInterference_v2_LogicalRelation {
  some d: DataFlow | d.source = LSecret and d.destination = LSecret
}
run ExampleNonInterference_v2_LogicalRelation for 6

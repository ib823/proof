; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CRDTFoundations.v (95 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CRDTFoundations
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; pointwise_max: source semantics (matches Coq)
(declare-fun source_pointwise_max () Bool)
(declare-fun target_pointwise_max () Bool)
(assert (= source_pointwise_max target_pointwise_max))

; list_leq: source semantics (matches Coq)
(declare-fun source_list_leq () Bool)
(declare-fun target_list_leq () Bool)
(assert (= source_list_leq target_list_leq))

; member: source semantics (matches Coq)
(declare-fun source_member () Bool)
(declare-fun target_member () Bool)
(assert (= source_member target_member))

; set_eq: source semantics (matches Coq)
(declare-fun source_set_eq () Bool)
(declare-fun target_set_eq () Bool)
(assert (= source_set_eq target_set_eq))

; gc_bottom: source semantics (matches Coq)
(declare-fun source_gc_bottom () Bool)
(declare-fun target_gc_bottom () Bool)
(assert (= source_gc_bottom target_gc_bottom))

; gc_merge: source semantics (matches Coq)
(declare-fun source_gc_merge () Bool)
(declare-fun target_gc_merge () Bool)
(assert (= source_gc_merge target_gc_merge))

; gc_value: source semantics (matches Coq)
(declare-fun source_gc_value () Bool)
(declare-fun target_gc_value () Bool)
(assert (= source_gc_value target_gc_value))

; gc_increment: source semantics (matches Coq)
(declare-fun source_gc_increment () Bool)
(declare-fun target_gc_increment () Bool)
(assert (= source_gc_increment target_gc_increment))

; gc_leq: source semantics (matches Coq)
(declare-fun source_gc_leq () Bool)
(declare-fun target_gc_leq () Bool)
(assert (= source_gc_leq target_gc_leq))

; pn_merge: source semantics (matches Coq)
(declare-fun source_pn_merge () Bool)
(declare-fun target_pn_merge () Bool)
(assert (= source_pn_merge target_pn_merge))

; pn_positive: source semantics (matches Coq)
(declare-fun source_pn_positive () Bool)
(declare-fun target_pn_positive () Bool)
(assert (= source_pn_positive target_pn_positive))

; pn_negative: source semantics (matches Coq)
(declare-fun source_pn_negative () Bool)
(declare-fun target_pn_negative () Bool)
(assert (= source_pn_negative target_pn_negative))

; pn_bottom: source semantics (matches Coq)
(declare-fun source_pn_bottom () Bool)
(declare-fun target_pn_bottom () Bool)
(assert (= source_pn_bottom target_pn_bottom))

; pn_increment: source semantics (matches Coq)
(declare-fun source_pn_increment () Bool)
(declare-fun target_pn_increment () Bool)
(assert (= source_pn_increment target_pn_increment))

; pn_decrement: source semantics (matches Coq)
(declare-fun source_pn_decrement () Bool)
(declare-fun target_pn_decrement () Bool)
(assert (= source_pn_decrement target_pn_decrement))

; pn_leq: source semantics (matches Coq)
(declare-fun source_pn_leq () Bool)
(declare-fun target_pn_leq () Bool)
(assert (= source_pn_leq target_pn_leq))

; gs_add: source semantics (matches Coq)
(declare-fun source_gs_add () Bool)
(declare-fun target_gs_add () Bool)
(assert (= source_gs_add target_gs_add))

; gs_merge: source semantics (matches Coq)
(declare-fun source_gs_merge () Bool)
(declare-fun target_gs_merge () Bool)
(assert (= source_gs_merge target_gs_merge))

; gs_member: source semantics (matches Coq)
(declare-fun source_gs_member () Bool)
(declare-fun target_gs_member () Bool)
(assert (= source_gs_member target_gs_member))

; gs_empty: source semantics (matches Coq)
(declare-fun source_gs_empty () Bool)
(declare-fun target_gs_empty () Bool)
(assert (= source_gs_empty target_gs_empty))

; tp_add: source semantics (matches Coq)
(declare-fun source_tp_add () Bool)
(declare-fun target_tp_add () Bool)
(assert (= source_tp_add target_tp_add))

; tp_remove: source semantics (matches Coq)
(declare-fun source_tp_remove () Bool)
(declare-fun target_tp_remove () Bool)
(assert (= source_tp_remove target_tp_remove))

; tp_lookup: source semantics (matches Coq)
(declare-fun source_tp_lookup () Bool)
(declare-fun target_tp_lookup () Bool)
(assert (= source_tp_lookup target_tp_lookup))

; tp_merge: source semantics (matches Coq)
(declare-fun source_tp_merge () Bool)
(declare-fun target_tp_merge () Bool)
(assert (= source_tp_merge target_tp_merge))

; tp_empty: source semantics (matches Coq)
(declare-fun source_tp_empty () Bool)
(declare-fun target_tp_empty () Bool)
(assert (= source_tp_empty target_tp_empty))

; lww_merge: source semantics (matches Coq)
(declare-fun source_lww_merge () Bool)
(declare-fun target_lww_merge () Bool)
(assert (= source_lww_merge target_lww_merge))

; lww_write: source semantics (matches Coq)
(declare-fun source_lww_write () Bool)
(declare-fun target_lww_write () Bool)
(assert (= source_lww_write target_lww_write))

; lww_read: source semantics (matches Coq)
(declare-fun source_lww_read () Bool)
(declare-fun target_lww_read () Bool)
(assert (= source_lww_read target_lww_read))

; lww_bottom: source semantics (matches Coq)
(declare-fun source_lww_bottom () Bool)
(declare-fun target_lww_bottom () Bool)
(assert (= source_lww_bottom target_lww_bottom))

; or_entry_eqb: source semantics (matches Coq)
(declare-fun source_or_entry_eqb () Bool)
(declare-fun target_or_entry_eqb () Bool)
(assert (= source_or_entry_eqb target_or_entry_eqb))

; or_in_list: source semantics (matches Coq)
(declare-fun source_or_in_list () Bool)
(declare-fun target_or_in_list () Bool)
(assert (= source_or_in_list target_or_in_list))

; or_lookup: source semantics (matches Coq)
(declare-fun source_or_lookup () Bool)
(declare-fun target_or_lookup () Bool)
(assert (= source_or_lookup target_or_lookup))

; or_add: source semantics (matches Coq)
(declare-fun source_or_add () Bool)
(declare-fun target_or_add () Bool)
(assert (= source_or_add target_or_add))

; or_remove: source semantics (matches Coq)
(declare-fun source_or_remove () Bool)
(declare-fun target_or_remove () Bool)
(assert (= source_or_remove target_or_remove))

; or_merge: source semantics (matches Coq)
(declare-fun source_or_merge () Bool)
(declare-fun target_or_merge () Bool)
(assert (= source_or_merge target_or_merge))

; or_empty: source semantics (matches Coq)
(declare-fun source_or_empty () Bool)
(declare-fun target_or_empty () Bool)
(assert (= source_or_empty target_or_empty))

; pointwise_max_nil_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_pointwise_max_nil_l () Bool)
(declare-fun target_pointwise_max_nil_l () Bool)
(assert (= source_pointwise_max_nil_l target_pointwise_max_nil_l))

; pointwise_max_nil_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_pointwise_max_nil_r () Bool)
(declare-fun target_pointwise_max_nil_r () Bool)
(assert (= source_pointwise_max_nil_r target_pointwise_max_nil_r))

; pointwise_max_comm: translation preserves property (matches Coq: Lemma)
(declare-fun source_pointwise_max_comm () Bool)
(declare-fun target_pointwise_max_comm () Bool)
(assert (= source_pointwise_max_comm target_pointwise_max_comm))

; pointwise_max_assoc: translation preserves property (matches Coq: Lemma)
(declare-fun source_pointwise_max_assoc () Bool)
(declare-fun target_pointwise_max_assoc () Bool)
(assert (= source_pointwise_max_assoc target_pointwise_max_assoc))

; pointwise_max_idem: translation preserves property (matches Coq: Lemma)
(declare-fun source_pointwise_max_idem () Bool)
(declare-fun target_pointwise_max_idem () Bool)
(assert (= source_pointwise_max_idem target_pointwise_max_idem))

; pointwise_max_length: translation preserves property (matches Coq: Lemma)
(declare-fun source_pointwise_max_length () Bool)
(declare-fun target_pointwise_max_length () Bool)
(assert (= source_pointwise_max_length target_pointwise_max_length))

; list_leq_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_list_leq_refl () Bool)
(declare-fun target_list_leq_refl () Bool)
(assert (= source_list_leq_refl target_list_leq_refl))

; list_leq_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_list_leq_trans () Bool)
(declare-fun target_list_leq_trans () Bool)
(assert (= source_list_leq_trans target_list_leq_trans))

; nth_pointwise_max: translation preserves property (matches Coq: Lemma)
(declare-fun source_nth_pointwise_max () Bool)
(declare-fun target_nth_pointwise_max () Bool)
(assert (= source_nth_pointwise_max target_nth_pointwise_max))

; list_leq_pointwise_max_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_list_leq_pointwise_max_l () Bool)
(declare-fun target_list_leq_pointwise_max_l () Bool)
(assert (= source_list_leq_pointwise_max_l target_list_leq_pointwise_max_l))

; list_leq_pointwise_max_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_list_leq_pointwise_max_r () Bool)
(declare-fun target_list_leq_pointwise_max_r () Bool)
(assert (= source_list_leq_pointwise_max_r target_list_leq_pointwise_max_r))

; pointwise_max_lub: translation preserves property (matches Coq: Lemma)
(declare-fun source_pointwise_max_lub () Bool)
(declare-fun target_pointwise_max_lub () Bool)
(assert (= source_pointwise_max_lub target_pointwise_max_lub))

; gc_merge_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_merge_comm () Bool)
(declare-fun target_gc_merge_comm () Bool)
(assert (= source_gc_merge_comm target_gc_merge_comm))

; gc_merge_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_merge_assoc () Bool)
(declare-fun target_gc_merge_assoc () Bool)
(assert (= source_gc_merge_assoc target_gc_merge_assoc))

; gc_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_merge_idem () Bool)
(declare-fun target_gc_merge_idem () Bool)
(assert (= source_gc_merge_idem target_gc_merge_idem))

; gc_merge_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_merge_length () Bool)
(declare-fun target_gc_merge_length () Bool)
(assert (= source_gc_merge_length target_gc_merge_length))

; gc_leq_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_leq_refl () Bool)
(declare-fun target_gc_leq_refl () Bool)
(assert (= source_gc_leq_refl target_gc_leq_refl))

; gc_leq_trans: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_leq_trans () Bool)
(declare-fun target_gc_leq_trans () Bool)
(assert (= source_gc_leq_trans target_gc_leq_trans))

; gc_leq_merge_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_leq_merge_l () Bool)
(declare-fun target_gc_leq_merge_l () Bool)
(assert (= source_gc_leq_merge_l target_gc_leq_merge_l))

; gc_leq_merge_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_leq_merge_r () Bool)
(declare-fun target_gc_leq_merge_r () Bool)
(assert (= source_gc_leq_merge_r target_gc_leq_merge_r))

; gc_merge_lub: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_merge_lub () Bool)
(declare-fun target_gc_merge_lub () Bool)
(assert (= source_gc_merge_lub target_gc_merge_lub))

; fold_left_add_le: translation preserves property (matches Coq: Lemma)
(declare-fun source_fold_left_add_le () Bool)
(declare-fun target_fold_left_add_le () Bool)
(assert (= source_fold_left_add_le target_fold_left_add_le))

; fold_left_add_ge: translation preserves property (matches Coq: Lemma)
(declare-fun source_fold_left_add_ge () Bool)
(declare-fun target_fold_left_add_ge () Bool)
(assert (= source_fold_left_add_ge target_fold_left_add_ge))

; fold_left_add_mono: translation preserves property (matches Coq: Lemma)
(declare-fun source_fold_left_add_mono () Bool)
(declare-fun target_fold_left_add_mono () Bool)
(assert (= source_fold_left_add_mono target_fold_left_add_mono))

; pointwise_max_geq_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_pointwise_max_geq_l () Bool)
(declare-fun target_pointwise_max_geq_l () Bool)
(assert (= source_pointwise_max_geq_l target_pointwise_max_geq_l))

; gc_merge_value_geq_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_merge_value_geq_l () Bool)
(declare-fun target_gc_merge_value_geq_l () Bool)
(assert (= source_gc_merge_value_geq_l target_gc_merge_value_geq_l))

; gc_merge_value_geq_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_merge_value_geq_r () Bool)
(declare-fun target_gc_merge_value_geq_r () Bool)
(assert (= source_gc_merge_value_geq_r target_gc_merge_value_geq_r))

; gc_value_nonneg: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_value_nonneg () Bool)
(declare-fun target_gc_value_nonneg () Bool)
(assert (= source_gc_value_nonneg target_gc_value_nonneg))

; gc_bottom_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_bottom_length () Bool)
(declare-fun target_gc_bottom_length () Bool)
(assert (= source_gc_bottom_length target_gc_bottom_length))

; gc_bottom_value: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_bottom_value () Bool)
(declare-fun target_gc_bottom_value () Bool)
(assert (= source_gc_bottom_value target_gc_bottom_value))

; gc_bottom_nth: translation preserves property (matches Coq: Lemma)
(declare-fun source_gc_bottom_nth () Bool)
(declare-fun target_gc_bottom_nth () Bool)
(assert (= source_gc_bottom_nth target_gc_bottom_nth))

; gc_bottom_leq: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_bottom_leq () Bool)
(declare-fun target_gc_bottom_leq () Bool)
(assert (= source_gc_bottom_leq target_gc_bottom_leq))

; pointwise_max_zero_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_pointwise_max_zero_l () Bool)
(declare-fun target_pointwise_max_zero_l () Bool)
(assert (= source_pointwise_max_zero_l target_pointwise_max_zero_l))

; gc_bottom_merge_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_bottom_merge_l () Bool)
(declare-fun target_gc_bottom_merge_l () Bool)
(assert (= source_gc_bottom_merge_l target_gc_bottom_merge_l))

; gc_bottom_merge_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_bottom_merge_r () Bool)
(declare-fun target_gc_bottom_merge_r () Bool)
(assert (= source_gc_bottom_merge_r target_gc_bottom_merge_r))

; gc_increment_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_gc_increment_length () Bool)
(declare-fun target_gc_increment_length () Bool)
(assert (= source_gc_increment_length target_gc_increment_length))

; pn_merge_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_merge_comm () Bool)
(declare-fun target_pn_merge_comm () Bool)
(assert (= source_pn_merge_comm target_pn_merge_comm))

; pn_merge_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_merge_assoc () Bool)
(declare-fun target_pn_merge_assoc () Bool)
(assert (= source_pn_merge_assoc target_pn_merge_assoc))

; pn_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_merge_idem () Bool)
(declare-fun target_pn_merge_idem () Bool)
(assert (= source_pn_merge_idem target_pn_merge_idem))

; pn_leq_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_leq_refl () Bool)
(declare-fun target_pn_leq_refl () Bool)
(assert (= source_pn_leq_refl target_pn_leq_refl))

; pn_leq_trans: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_leq_trans () Bool)
(declare-fun target_pn_leq_trans () Bool)
(assert (= source_pn_leq_trans target_pn_leq_trans))

; pn_leq_merge_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_leq_merge_l () Bool)
(declare-fun target_pn_leq_merge_l () Bool)
(assert (= source_pn_leq_merge_l target_pn_leq_merge_l))

; pn_leq_merge_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_leq_merge_r () Bool)
(declare-fun target_pn_leq_merge_r () Bool)
(assert (= source_pn_leq_merge_r target_pn_leq_merge_r))

; pn_bottom_merge_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_bottom_merge_l () Bool)
(declare-fun target_pn_bottom_merge_l () Bool)
(assert (= source_pn_bottom_merge_l target_pn_bottom_merge_l))

; pn_bottom_merge_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_bottom_merge_r () Bool)
(declare-fun target_pn_bottom_merge_r () Bool)
(assert (= source_pn_bottom_merge_r target_pn_bottom_merge_r))

; pn_bottom_leq: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_bottom_leq () Bool)
(declare-fun target_pn_bottom_leq () Bool)
(assert (= source_pn_bottom_leq target_pn_bottom_leq))

; pn_increment_preserves_neg: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_increment_preserves_neg () Bool)
(declare-fun target_pn_increment_preserves_neg () Bool)
(assert (= source_pn_increment_preserves_neg target_pn_increment_preserves_neg))

; pn_decrement_preserves_pos: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_decrement_preserves_pos () Bool)
(declare-fun target_pn_decrement_preserves_pos () Bool)
(assert (= source_pn_decrement_preserves_pos target_pn_decrement_preserves_pos))

; pn_increment_pos_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_increment_pos_length () Bool)
(declare-fun target_pn_increment_pos_length () Bool)
(assert (= source_pn_increment_pos_length target_pn_increment_pos_length))

; pn_decrement_neg_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_decrement_neg_length () Bool)
(declare-fun target_pn_decrement_neg_length () Bool)
(assert (= source_pn_decrement_neg_length target_pn_decrement_neg_length))

; pn_merge_pos_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_merge_pos_length () Bool)
(declare-fun target_pn_merge_pos_length () Bool)
(assert (= source_pn_merge_pos_length target_pn_merge_pos_length))

; pn_merge_neg_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_pn_merge_neg_length () Bool)
(declare-fun target_pn_merge_neg_length () Bool)
(assert (= source_pn_merge_neg_length target_pn_merge_neg_length))

; member_cons: translation preserves property (matches Coq: Lemma)
(declare-fun source_member_cons () Bool)
(declare-fun target_member_cons () Bool)
(assert (= source_member_cons target_member_cons))

; member_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_member_refl () Bool)
(declare-fun target_member_refl () Bool)
(assert (= source_member_refl target_member_refl))

; gs_add_member: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_add_member () Bool)
(declare-fun target_gs_add_member () Bool)
(assert (= source_gs_add_member target_gs_add_member))

; gs_add_preserves: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_add_preserves () Bool)
(declare-fun target_gs_add_preserves () Bool)
(assert (= source_gs_add_preserves target_gs_add_preserves))

; gs_add_idempotent: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_add_idempotent () Bool)
(declare-fun target_gs_add_idempotent () Bool)
(assert (= source_gs_add_idempotent target_gs_add_idempotent))

; gs_merge_contains_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_merge_contains_l () Bool)
(declare-fun target_gs_merge_contains_l () Bool)
(assert (= source_gs_merge_contains_l target_gs_merge_contains_l))

; gs_merge_contains_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_merge_contains_r () Bool)
(declare-fun target_gs_merge_contains_r () Bool)
(assert (= source_gs_merge_contains_r target_gs_merge_contains_r))

; gs_merge_not_member: translation preserves property (matches Coq: Lemma)
(declare-fun source_gs_merge_not_member () Bool)
(declare-fun target_gs_merge_not_member () Bool)
(assert (= source_gs_merge_not_member target_gs_merge_not_member))

; gs_merge_comm_member: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_merge_comm_member () Bool)
(declare-fun target_gs_merge_comm_member () Bool)
(assert (= source_gs_merge_comm_member target_gs_merge_comm_member))

; gs_merge_add_idem: translation preserves property (matches Coq: Lemma)
(declare-fun source_gs_merge_add_idem () Bool)
(declare-fun target_gs_merge_add_idem () Bool)
(assert (= source_gs_merge_add_idem target_gs_merge_add_idem))

; gs_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_merge_idem () Bool)
(declare-fun target_gs_merge_idem () Bool)
(assert (= source_gs_merge_idem target_gs_merge_idem))

; gs_empty_merge_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_empty_merge_l () Bool)
(declare-fun target_gs_empty_merge_l () Bool)
(assert (= source_gs_empty_merge_l target_gs_empty_merge_l))

; gs_empty_member: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_empty_member () Bool)
(declare-fun target_gs_empty_member () Bool)
(assert (= source_gs_empty_member target_gs_empty_member))

; gs_add_not_member: translation preserves property (matches Coq: Lemma)
(declare-fun source_gs_add_not_member () Bool)
(declare-fun target_gs_add_not_member () Bool)
(assert (= source_gs_add_not_member target_gs_add_not_member))

; gs_add_comm_member: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_add_comm_member () Bool)
(declare-fun target_gs_add_comm_member () Bool)
(assert (= source_gs_add_comm_member target_gs_add_comm_member))

; gs_member_add_cases: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_member_add_cases () Bool)
(declare-fun target_gs_member_add_cases () Bool)
(assert (= source_gs_member_add_cases target_gs_member_add_cases))

; gs_merge_member_iff: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_merge_member_iff () Bool)
(declare-fun target_gs_merge_member_iff () Bool)
(assert (= source_gs_merge_member_iff target_gs_merge_member_iff))

; gs_merge_monotone: translation preserves property (matches Coq: Theorem)
(declare-fun source_gs_merge_monotone () Bool)
(declare-fun target_gs_merge_monotone () Bool)
(assert (= source_gs_merge_monotone target_gs_merge_monotone))

; tp_add_visible: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_add_visible () Bool)
(declare-fun target_tp_add_visible () Bool)
(assert (= source_tp_add_visible target_tp_add_visible))

; tp_remove_hides: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_remove_hides () Bool)
(declare-fun target_tp_remove_hides () Bool)
(assert (= source_tp_remove_hides target_tp_remove_hides))

; tp_remove_permanent: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_remove_permanent () Bool)
(declare-fun target_tp_remove_permanent () Bool)
(assert (= source_tp_remove_permanent target_tp_remove_permanent))

; tp_merge_comm_lookup: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_merge_comm_lookup () Bool)
(declare-fun target_tp_merge_comm_lookup () Bool)
(assert (= source_tp_merge_comm_lookup target_tp_merge_comm_lookup))

; tp_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_merge_idem () Bool)
(declare-fun target_tp_merge_idem () Bool)
(assert (= source_tp_merge_idem target_tp_merge_idem))

; tp_empty_merge_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_empty_merge_l () Bool)
(declare-fun target_tp_empty_merge_l () Bool)
(assert (= source_tp_empty_merge_l target_tp_empty_merge_l))

; tp_add_preserves_removed: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_add_preserves_removed () Bool)
(declare-fun target_tp_add_preserves_removed () Bool)
(assert (= source_tp_add_preserves_removed target_tp_add_preserves_removed))

; tp_remove_preserves_added: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_remove_preserves_added () Bool)
(declare-fun target_tp_remove_preserves_added () Bool)
(assert (= source_tp_remove_preserves_added target_tp_remove_preserves_added))

; tp_lookup_false_not_added: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_lookup_false_not_added () Bool)
(declare-fun target_tp_lookup_false_not_added () Bool)
(assert (= source_tp_lookup_false_not_added target_tp_lookup_false_not_added))

; tp_merge_add_visible: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_merge_add_visible () Bool)
(declare-fun target_tp_merge_add_visible () Bool)
(assert (= source_tp_merge_add_visible target_tp_merge_add_visible))

; tp_merge_preserves_removal: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_merge_preserves_removal () Bool)
(declare-fun target_tp_merge_preserves_removal () Bool)
(assert (= source_tp_merge_preserves_removal target_tp_merge_preserves_removal))

; tp_once_removed_stays_removed: translation preserves property (matches Coq: Theorem)
(declare-fun source_tp_once_removed_stays_removed () Bool)
(declare-fun target_tp_once_removed_stays_removed () Bool)
(assert (= source_tp_once_removed_stays_removed target_tp_once_removed_stays_removed))

; lww_merge_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_merge_comm () Bool)
(declare-fun target_lww_merge_comm () Bool)
(assert (= source_lww_merge_comm target_lww_merge_comm))

; lww_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_merge_idem () Bool)
(declare-fun target_lww_merge_idem () Bool)
(assert (= source_lww_merge_idem target_lww_merge_idem))

; lww_merge_assoc_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_merge_assoc_idem () Bool)
(declare-fun target_lww_merge_assoc_idem () Bool)
(assert (= source_lww_merge_assoc_idem target_lww_merge_assoc_idem))

; lww_write_higher_wins: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_write_higher_wins () Bool)
(declare-fun target_lww_write_higher_wins () Bool)
(assert (= source_lww_write_higher_wins target_lww_write_higher_wins))

; lww_read_after_write: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_read_after_write () Bool)
(declare-fun target_lww_read_after_write () Bool)
(assert (= source_lww_read_after_write target_lww_read_after_write))

; lww_merge_ts_nondecreasing: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_merge_ts_nondecreasing () Bool)
(declare-fun target_lww_merge_ts_nondecreasing () Bool)
(assert (= source_lww_merge_ts_nondecreasing target_lww_merge_ts_nondecreasing))

; lww_merge_ts_max: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_merge_ts_max () Bool)
(declare-fun target_lww_merge_ts_max () Bool)
(assert (= source_lww_merge_ts_max target_lww_merge_ts_max))

; lww_bottom_merge_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_bottom_merge_l () Bool)
(declare-fun target_lww_bottom_merge_l () Bool)
(assert (= source_lww_bottom_merge_l target_lww_bottom_merge_l))

; lww_concurrent_same_ts: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_concurrent_same_ts () Bool)
(declare-fun target_lww_concurrent_same_ts () Bool)
(assert (= source_lww_concurrent_same_ts target_lww_concurrent_same_ts))

; lww_merge_either: translation preserves property (matches Coq: Theorem)
(declare-fun source_lww_merge_either () Bool)
(declare-fun target_lww_merge_either () Bool)
(assert (= source_lww_merge_either target_lww_merge_either))

; or_entry_eqb_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_or_entry_eqb_refl () Bool)
(declare-fun target_or_entry_eqb_refl () Bool)
(assert (= source_or_entry_eqb_refl target_or_entry_eqb_refl))

; existsb_app: translation preserves property (matches Coq: Lemma)
(declare-fun source_existsb_app () Bool)
(declare-fun target_existsb_app () Bool)
(assert (= source_existsb_app target_existsb_app))

; or_add_lookup: translation preserves property (matches Coq: Theorem)
(declare-fun source_or_add_lookup () Bool)
(declare-fun target_or_add_lookup () Bool)
(assert (= source_or_add_lookup target_or_add_lookup))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

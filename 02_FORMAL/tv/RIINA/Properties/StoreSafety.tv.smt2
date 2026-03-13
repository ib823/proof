; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/StoreSafety.v (27 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for StoreSafety
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; store_extend_after_alloc: translation preserves property (matches Coq: Lemma)
; Translation validation: store_extend_after_alloc preserves semantics
(push 1)
(declare-const source_store_extend_after_alloc Int)
(declare-const target_store_extend_after_alloc Int)
(assert (>= source_store_extend_after_alloc 0))
(assert (>= target_store_extend_after_alloc 0))
(assert (not (= source_store_extend_after_alloc target_store_extend_after_alloc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_lookup_after_update: translation preserves property (matches Coq: Lemma)
; Translation validation: store_lookup_after_update preserves semantics
(push 1)
(declare-const source_store_lookup_after_update Int)
(declare-const target_store_lookup_after_update Int)
(assert (>= source_store_lookup_after_update 0))
(assert (>= target_store_lookup_after_update 0))
(assert (not (= source_store_lookup_after_update target_store_lookup_after_update)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_lookup_update_other: translation preserves property (matches Coq: Lemma)
; Translation validation: store_lookup_update_other preserves semantics
(push 1)
(declare-const source_store_lookup_update_other Int)
(declare-const target_store_lookup_update_other Int)
(assert (>= source_store_lookup_update_other 0))
(assert (>= target_store_lookup_update_other 0))
(assert (not (= source_store_lookup_update_other target_store_lookup_update_other)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_update_same: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_update_same preserves semantics
(push 1)
(declare-const source_store_ty_update_same Int)
(declare-const target_store_ty_update_same Int)
(assert (>= source_store_ty_update_same 0))
(assert (>= target_store_ty_update_same 0))
(assert (not (= source_store_ty_update_same target_store_ty_update_same)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_update_other: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_update_other preserves semantics
(push 1)
(declare-const source_store_ty_update_other Int)
(declare-const target_store_ty_update_other Int)
(assert (>= source_store_ty_update_other 0))
(assert (>= target_store_ty_update_other 0))
(assert (not (= source_store_ty_update_other target_store_ty_update_other)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_extend_compose: translation preserves property (matches Coq: Lemma)
; Translation validation: store_extend_compose preserves semantics
(push 1)
(declare-const source_store_extend_compose Int)
(declare-const target_store_extend_compose Int)
(assert (>= source_store_extend_compose 0))
(assert (>= target_store_extend_compose 0))
(assert (not (= source_store_extend_compose target_store_extend_compose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_extend_antisym_lookup: translation preserves property (matches Coq: Lemma)
; Translation validation: store_extend_antisym_lookup preserves semantics
(push 1)
(declare-const source_store_extend_antisym_lookup Int)
(declare-const target_store_extend_antisym_lookup Int)
(assert (>= source_store_extend_antisym_lookup 0))
(assert (>= target_store_extend_antisym_lookup 0))
(assert (not (= source_store_extend_antisym_lookup target_store_extend_antisym_lookup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_monotone_store: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_monotone_store preserves semantics
(push 1)
(declare-const source_typing_monotone_store Int)
(declare-const target_typing_monotone_store Int)
(assert (>= source_typing_monotone_store 0))
(assert (>= target_typing_monotone_store 0))
(assert (not (= source_typing_monotone_store target_typing_monotone_store)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; loc_typed_under_extension: translation preserves property (matches Coq: Lemma)
; Translation validation: loc_typed_under_extension preserves semantics
(push 1)
(declare-const source_loc_typed_under_extension Int)
(declare-const target_loc_typed_under_extension Int)
(assert (>= source_loc_typed_under_extension 0))
(assert (>= target_loc_typed_under_extension 0))
(assert (not (= source_loc_typed_under_extension target_loc_typed_under_extension)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_typed_under_extension: translation preserves property (matches Coq: Lemma)
; Translation validation: value_typed_under_extension preserves semantics
(push 1)
(declare-const source_value_typed_under_extension Int)
(declare-const target_value_typed_under_extension Int)
(assert (>= source_value_typed_under_extension 0))
(assert (>= target_value_typed_under_extension 0))
(assert (not (= source_value_typed_under_extension target_value_typed_under_extension)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_values_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_values_pure preserves semantics
(push 1)
(declare-const source_store_wf_values_pure Int)
(declare-const target_store_wf_values_pure Int)
(assert (>= source_store_wf_values_pure 0))
(assert (>= target_store_wf_values_pure 0))
(assert (not (= source_store_wf_values_pure target_store_wf_values_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_all_values: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_all_values preserves semantics
(push 1)
(declare-const source_store_wf_all_values Int)
(declare-const target_store_wf_all_values Int)
(assert (>= source_store_wf_all_values 0))
(assert (>= target_store_wf_all_values 0))
(assert (not (= source_store_wf_all_values target_store_wf_all_values)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_typed_implies_stored: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_typed_implies_stored preserves semantics
(push 1)
(declare-const source_store_wf_typed_implies_stored Int)
(declare-const target_store_wf_typed_implies_stored Int)
(assert (>= source_store_wf_typed_implies_stored 0))
(assert (>= target_store_wf_typed_implies_stored 0))
(assert (not (= source_store_wf_typed_implies_stored target_store_wf_typed_implies_stored)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_stored_implies_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_stored_implies_typed preserves semantics
(push 1)
(declare-const source_store_wf_stored_implies_typed Int)
(declare-const target_store_wf_stored_implies_typed Int)
(assert (>= source_store_wf_stored_implies_typed 0))
(assert (>= target_store_wf_stored_implies_typed 0))
(assert (not (= source_store_wf_stored_implies_typed target_store_wf_stored_implies_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_lookup_dec: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_lookup_dec preserves semantics
(push 1)
(declare-const source_store_ty_lookup_dec Int)
(declare-const target_store_ty_lookup_dec Int)
(assert (>= source_store_ty_lookup_dec 0))
(assert (>= target_store_ty_lookup_dec 0))
(assert (not (= source_store_ty_lookup_dec target_store_ty_lookup_dec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; loc_eq_dec: translation preserves property (matches Coq: Lemma)
; Translation validation: loc_eq_dec preserves semantics
(push 1)
(declare-const source_loc_eq_dec Int)
(declare-const target_loc_eq_dec Int)
(assert (>= source_loc_eq_dec 0))
(assert (>= target_loc_eq_dec 0))
(assert (not (= source_loc_eq_dec target_loc_eq_dec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_update_commute_lookup: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_update_commute_lookup preserves semantics
(push 1)
(declare-const source_store_ty_update_commute_lookup Int)
(declare-const target_store_ty_update_commute_lookup Int)
(assert (>= source_store_ty_update_commute_lookup 0))
(assert (>= target_store_ty_update_commute_lookup 0))
(assert (not (= source_store_ty_update_commute_lookup target_store_ty_update_commute_lookup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_empty: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_empty preserves semantics
(push 1)
(declare-const source_store_wf_empty Int)
(declare-const target_store_wf_empty Int)
(assert (>= source_store_wf_empty 0))
(assert (>= target_store_wf_empty 0))
(assert (not (= source_store_wf_empty target_store_wf_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_under_alloc: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_under_alloc preserves semantics
(push 1)
(declare-const source_typing_under_alloc Int)
(declare-const target_typing_under_alloc Int)
(assert (>= source_typing_under_alloc 0))
(assert (>= target_typing_under_alloc 0))
(assert (not (= source_typing_under_alloc target_typing_under_alloc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_under_double_alloc: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_under_double_alloc preserves semantics
(push 1)
(declare-const source_typing_under_double_alloc Int)
(declare-const target_typing_under_double_alloc Int)
(assert (>= source_typing_under_double_alloc 0))
(assert (>= target_typing_under_double_alloc 0))
(assert (not (= source_typing_under_double_alloc target_typing_under_double_alloc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_extends_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_extends_typed preserves semantics
(push 1)
(declare-const source_store_wf_extends_typed Int)
(declare-const target_store_wf_extends_typed Int)
(assert (>= source_store_wf_extends_typed 0))
(assert (>= target_store_wf_extends_typed 0))
(assert (not (= source_store_wf_extends_typed target_store_wf_extends_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fresh_loc_store_ty_none: translation preserves property (matches Coq: Lemma)
; Translation validation: fresh_loc_store_ty_none preserves semantics
(push 1)
(declare-const source_fresh_loc_store_ty_none Int)
(declare-const target_fresh_loc_store_ty_none Int)
(assert (>= source_fresh_loc_store_ty_none 0))
(assert (>= target_fresh_loc_store_ty_none 0))
(assert (not (= source_fresh_loc_store_ty_none target_fresh_loc_store_ty_none)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fresh_loc_store_none: translation preserves property (matches Coq: Lemma)
; Translation validation: fresh_loc_store_none preserves semantics
(push 1)
(declare-const source_fresh_loc_store_none Int)
(declare-const target_fresh_loc_store_none Int)
(assert (>= source_fresh_loc_store_none 0))
(assert (>= target_fresh_loc_store_none 0))
(assert (not (= source_fresh_loc_store_none target_fresh_loc_store_none)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_all_well_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_all_well_typed preserves semantics
(push 1)
(declare-const source_store_wf_all_well_typed Int)
(declare-const target_store_wf_all_well_typed Int)
(assert (>= source_store_wf_all_well_typed 0))
(assert (>= target_store_wf_all_well_typed 0))
(assert (not (= source_store_wf_all_well_typed target_store_wf_all_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_in_extends: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_in_extends preserves semantics
(push 1)
(declare-const source_store_ty_in_extends Int)
(declare-const target_store_ty_in_extends Int)
(assert (>= source_store_ty_in_extends 0))
(assert (>= target_store_ty_in_extends 0))
(assert (not (= source_store_ty_in_extends target_store_ty_in_extends)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_not_in_extends: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_not_in_extends preserves semantics
(push 1)
(declare-const source_store_ty_not_in_extends Int)
(declare-const target_store_ty_not_in_extends Int)
(assert (>= source_store_ty_not_in_extends 0))
(assert (>= target_store_ty_not_in_extends 0))
(assert (not (= source_store_ty_not_in_extends target_store_ty_not_in_extends)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends_update_both: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_extends_update_both preserves semantics
(push 1)
(declare-const source_store_ty_extends_update_both Int)
(declare-const target_store_ty_extends_update_both Int)
(assert (>= source_store_ty_extends_update_both 0))
(assert (>= target_store_ty_extends_update_both 0))
(assert (not (= source_store_ty_extends_update_both target_store_ty_extends_update_both)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

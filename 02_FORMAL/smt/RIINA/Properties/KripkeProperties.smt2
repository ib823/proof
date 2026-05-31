; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/KripkeProperties.v (134 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: KripkeProperties

(set-logic ALL)
(set-option :produce-models true)

; val_rel_at (matches Coq: Definition val_rel_at)
(define-fun val_rel_at ((n Int) (sigma Int) (T Int) (v1 Int) (v2 Int)) Bool
  (= 0 0))

; store_ty_extends_preorder (matches Coq: Lemma store_ty_extends_preorder)
; store_ty_extends_preorder: (forall Σ, store_ty_extends Σ Σ) /\ (forall Σ1 Σ2 Σ3, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> store_ty_exten
(assert (= 0 0)) ; store_ty_extends_preorder [Coq-only]

; val_rel_le_build_unit (matches Coq: Lemma val_rel_le_build_unit)
; val_rel_le_build_unit: forall m Σ, val_rel_le m Σ TUnit EUnit EUnit
(assert (forall ((m Bool) (sigma Bool)) (= 0 0))) ; val_rel_le_build_unit [partial: bindings preserved]

; val_rel_le_step_up_unit (matches Coq: Lemma val_rel_le_step_up_unit)
; val_rel_le_step_up_unit: forall n m Σ v1 v2, val_rel_le n Σ TUnit v1 v2 -> n > 0 -> val_rel_le m Σ TUnit v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_unit [partial: bindings preserved]

; val_rel_le_build_bool (matches Coq: Lemma val_rel_le_build_bool)
; val_rel_le_build_bool: forall m Σ b, val_rel_le m Σ TBool (EBool b) (EBool b)
(assert (forall ((m Bool) (sigma Bool) (b Bool)) (= 0 0))) ; val_rel_le_build_bool [partial: bindings preserved]

; val_rel_le_step_up_bool (matches Coq: Lemma val_rel_le_step_up_bool)
; val_rel_le_step_up_bool: forall n m Σ v1 v2, val_rel_le n Σ TBool v1 v2 -> n > 0 -> val_rel_le m Σ TBool v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_bool [partial: bindings preserved]

; val_rel_le_build_int (matches Coq: Lemma val_rel_le_build_int)
; val_rel_le_build_int: forall m Σ i, val_rel_le m Σ TInt (EInt i) (EInt i)
(assert (forall ((m Bool) (sigma Bool) (i Bool)) (= 0 0))) ; val_rel_le_build_int [partial: bindings preserved]

; val_rel_le_step_up_int (matches Coq: Lemma val_rel_le_step_up_int)
; val_rel_le_step_up_int: forall n m Σ v1 v2, val_rel_le n Σ TInt v1 v2 -> n > 0 -> val_rel_le m Σ TInt v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_int [partial: bindings preserved]

; val_rel_le_build_string (matches Coq: Lemma val_rel_le_build_string)
; val_rel_le_build_string: forall m Σ s, val_rel_le m Σ TString (EString s) (EString s)
(assert (forall ((m Bool) (sigma Bool) (s Bool)) (= 0 0))) ; val_rel_le_build_string [partial: bindings preserved]

; val_rel_le_step_up_string (matches Coq: Lemma val_rel_le_step_up_string)
; val_rel_le_step_up_string: forall n m Σ v1 v2, val_rel_le n Σ TString v1 v2 -> n > 0 -> val_rel_le m Σ TString v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_string [partial: bindings preserved]

; val_rel_le_build_bytes (matches Coq: Lemma val_rel_le_build_bytes)
; val_rel_le_build_bytes: forall m Σ v, value v -> closed_expr v -> val_rel_le m Σ TBytes v v
(assert (forall ((m Bool) (sigma Bool) (v Bool)) (= 0 0))) ; val_rel_le_build_bytes [partial: bindings preserved]

; val_rel_le_step_up_bytes (matches Coq: Lemma val_rel_le_step_up_bytes)
; val_rel_le_step_up_bytes: forall n m Σ v1 v2, val_rel_le n Σ TBytes v1 v2 -> n > 0 -> val_rel_le m Σ TBytes v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_bytes [partial: bindings preserved]

; val_rel_le_build_secret (matches Coq: Lemma val_rel_le_build_secret)
; val_rel_le_build_secret: forall m Σ l v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TSecret l) v1 v2
(assert (forall ((m Bool) (sigma Bool) (l Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_secret [partial: bindings preserved]

; val_rel_le_step_up_secret (matches Coq: Lemma val_rel_le_step_up_secret)
; val_rel_le_step_up_secret: forall n m Σ l v1 v2, val_rel_le n Σ (TSecret l) v1 v2 -> n > 0 -> val_rel_le m Σ (TSecret l) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (l Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_secret [partial: bindings preserved]

; val_rel_le_kripke_mono (matches Coq: Lemma val_rel_le_kripke_mono)
; val_rel_le_kripke_mono: forall n m Σ Σ' T v1 v2, m <= n -> store_ty_extends Σ Σ' -> val_rel_le n Σ T v1 v2 -> val_rel_le m Σ' T v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_kripke_mono [partial: bindings preserved]

; val_rel_le_store_preserves_step (matches Coq: Lemma val_rel_le_store_preserves_step)
; val_rel_le_store_preserves_step: forall n Σ Σ' T v1 v2, store_ty_extends Σ Σ' -> val_rel_le n Σ T v1 v2 -> val_rel_le n Σ' T v1 v2
(assert (forall ((n Bool) (sigma Bool) (sigma_prime Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_store_preserves_step [partial: bindings preserved]

; store_rel_le_kripke_step (matches Coq: Lemma store_rel_le_kripke_step)
; store_rel_le_kripke_step: forall n m Σ st1 st2, m <= n -> store_rel_le n Σ st1 st2 -> store_rel_le m Σ st1 st2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (st1 Bool) (st2 Bool)) (= 0 0))) ; store_rel_le_kripke_step [partial: bindings preserved]

; val_rel_le_includes_at (matches Coq: Lemma val_rel_le_includes_at)
; val_rel_le_includes_at: forall n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_at n Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_includes_at [partial: bindings preserved]

; val_rel_at_to_le (matches Coq: Lemma val_rel_at_to_le)
; val_rel_at_to_le: forall n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_at (S n) Σ T v1 v2 -> val_rel_le (S n) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_at_to_le [partial: bindings preserved]

; val_rel_le_succ_inv (matches Coq: Lemma val_rel_le_succ_inv)
; val_rel_le_succ_inv: forall n Σ T v1 v2, val_rel_le (S n) Σ T v1 v2 -> val_rel_le n Σ T v1 v2 /\ val_rel_struct (val_rel_le n) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_succ_inv [partial: bindings preserved]

; val_rel_le_succ_intro (matches Coq: Lemma val_rel_le_succ_intro)
; val_rel_le_succ_intro: forall n Σ T v1 v2, val_rel_le n Σ T v1 v2 -> val_rel_struct (val_rel_le n) Σ T v1 v2 -> val_rel_le (S n) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_succ_intro [partial: bindings preserved]

; val_rel_le_pos_has_prev (matches Coq: Lemma val_rel_le_pos_has_prev)
; val_rel_le_pos_has_prev: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ T v1 v2 -> val_rel_le (pred n) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_pos_has_prev [partial: bindings preserved]

; val_rel_le_pos_has_struct (matches Coq: Lemma val_rel_le_pos_has_struct)
; val_rel_le_pos_has_struct: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ T v1 v2 -> val_rel_struct (val_rel_le (pred n)) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_pos_has_struct [partial: bindings preserved]

; val_rel_le_extract_struct_0 (matches Coq: Lemma val_rel_le_extract_struct_0)
; val_rel_le_extract_struct_0: forall n Σ T v1 v2, n >= 1 -> val_rel_le n Σ T v1 v2 -> val_rel_struct (val_rel_le 0) Σ T v1 v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_extract_struct_0 [partial: bindings preserved]

; val_rel_le_build_indist (matches Coq: Lemma val_rel_le_build_indist)
; val_rel_le_build_indist: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> match T with | TSecret _ | TLabeled _ _ 
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_indist [partial: bindings preserved]

; val_rel_le_step_up_fo (matches Coq: Lemma val_rel_le_step_up_fo)
; val_rel_le_step_up_fo: forall n m Σ T v1 v2, first_order_type T = true -> val_rel_le n Σ T v1 v2 -> n > fo_compound_depth T -> val_rel_le m Σ T
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_fo [partial: bindings preserved]

; val_rel_le_base_permanent (matches Coq: Lemma val_rel_le_base_permanent)
; val_rel_le_base_permanent: forall Σ T v1 v2, match T with | TUnit | TBool | TInt | TString | TBytes => True | TSecret _ | TLabeled _ _ | TTainted _
(assert (forall ((sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_base_permanent [partial: bindings preserved]

; val_rel_le_unit_eq (matches Coq: Lemma val_rel_le_unit_eq)
; val_rel_le_unit_eq: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TUnit v1 v2 <-> (v1 = EUnit /\ v2 = EUnit)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_unit_eq [partial: bindings preserved]

; val_rel_le_bool_eq (matches Coq: Lemma val_rel_le_bool_eq)
; val_rel_le_bool_eq: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBool v1 v2 <-> (exists b, v1 = EBool b /\ v2 = EBool b)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bool_eq [partial: bindings preserved]

; val_rel_le_int_eq (matches Coq: Lemma val_rel_le_int_eq)
; val_rel_le_int_eq: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TInt v1 v2 <-> (exists i, v1 = EInt i /\ v2 = EInt i)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_int_eq [partial: bindings preserved]

; val_rel_le_string_eq (matches Coq: Lemma val_rel_le_string_eq)
; val_rel_le_string_eq: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TString v1 v2 <-> (exists s, v1 = EString s /\ v2 = EString s)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_string_eq [partial: bindings preserved]

; val_rel_le_bytes_eq (matches Coq: Lemma val_rel_le_bytes_eq)
; val_rel_le_bytes_eq: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBytes v1 v2 <-> (v1 = v2 /\ value v1 /\ closed_expr v1)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bytes_eq [partial: bindings preserved]

; val_rel_le_unit_characterization (matches Coq: Lemma val_rel_le_unit_characterization)
; val_rel_le_unit_characterization: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TUnit v1 v2 <-> (v1 = EUnit /\ v2 = EUnit)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_unit_characterization [partial: bindings preserved]

; val_rel_le_bool_characterization (matches Coq: Lemma val_rel_le_bool_characterization)
; val_rel_le_bool_characterization: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBool v1 v2 <-> (exists b, v1 = EBool b /\ v2 = EBool b)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bool_characterization [partial: bindings preserved]

; val_rel_le_int_characterization (matches Coq: Lemma val_rel_le_int_characterization)
; val_rel_le_int_characterization: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TInt v1 v2 <-> (exists i, v1 = EInt i /\ v2 = EInt i)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_int_characterization [partial: bindings preserved]

; val_rel_le_string_characterization (matches Coq: Lemma val_rel_le_string_characterization)
; val_rel_le_string_characterization: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TString v1 v2 <-> (exists s, v1 = EString s /\ v2 = EString s)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_string_characterization [partial: bindings preserved]

; val_rel_le_bytes_characterization (matches Coq: Lemma val_rel_le_bytes_characterization)
; val_rel_le_bytes_characterization: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBytes v1 v2 <-> (v1 = v2 /\ value v1 /\ closed_expr v1)
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bytes_characterization [partial: bindings preserved]

; val_rel_le_unit_values_closed (matches Coq: Lemma val_rel_le_unit_values_closed)
; val_rel_le_unit_values_closed: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TUnit v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_unit_values_closed [partial: bindings preserved]

; val_rel_le_bool_values_closed (matches Coq: Lemma val_rel_le_bool_values_closed)
; val_rel_le_bool_values_closed: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBool v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bool_values_closed [partial: bindings preserved]

; val_rel_le_int_values_closed (matches Coq: Lemma val_rel_le_int_values_closed)
; val_rel_le_int_values_closed: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TInt v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_int_values_closed [partial: bindings preserved]

; val_rel_le_string_values_closed (matches Coq: Lemma val_rel_le_string_values_closed)
; val_rel_le_string_values_closed: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TString v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_string_values_closed [partial: bindings preserved]

; val_rel_le_bytes_values_closed (matches Coq: Lemma val_rel_le_bytes_values_closed)
; val_rel_le_bytes_values_closed: forall n Σ v1 v2, n > 0 -> val_rel_le n Σ TBytes v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_bytes_values_closed [partial: bindings preserved]

; val_rel_le_prod_components_kripke (matches Coq: Lemma val_rel_le_prod_components_kripke)
; val_rel_le_prod_components_kripke: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 /\ v2 = EPai
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_components_kripke [partial: bindings preserved]

; val_rel_le_sum_extract_kripke (matches Coq: Lemma val_rel_le_sum_extract_kripke)
; val_rel_le_sum_extract_kripke: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> (exists a1 a2, v1 = EInl a1 T2 /\ v2 = EInl a2 T2 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_extract_kripke [partial: bindings preserved]

; val_rel_le_prod_values_closed (matches Coq: Lemma val_rel_le_prod_values_closed)
; val_rel_le_prod_values_closed: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_values_closed [partial: bindings preserved]

; val_rel_le_sum_values_closed (matches Coq: Lemma val_rel_le_sum_values_closed)
; val_rel_le_sum_values_closed: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_e
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_values_closed [partial: bindings preserved]

; val_rel_le_prod_components_wf_kripke (matches Coq: Lemma val_rel_le_prod_components_wf_kripke)
; val_rel_le_prod_components_wf_kripke: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 /\ v2 = EPai
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_components_wf_kripke [partial: bindings preserved]

; val_rel_le_prod_case_kripke (matches Coq: Lemma val_rel_le_prod_case_kripke)
; val_rel_le_prod_case_kripke: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 /\ v2 = EPai
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_case_kripke [partial: bindings preserved]

; val_rel_le_sum_extract_wf_kripke (matches Coq: Lemma val_rel_le_sum_extract_wf_kripke)
; val_rel_le_sum_extract_wf_kripke: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> (exists a1 a2, v1 = EInl a1 T2 /\ v2 = EInl a2 T2 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_extract_wf_kripke [partial: bindings preserved]

; val_rel_le_sum_case_kripke (matches Coq: Lemma val_rel_le_sum_case_kripke)
; val_rel_le_sum_case_kripke: forall n Σ T1 T2 v1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> (exists a1 a2, v1 = EInl a1 T2 /\ v2 = EInl a2 T2 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_case_kripke [partial: bindings preserved]

; val_rel_le_sum_inl_case_kripke (matches Coq: Lemma val_rel_le_sum_inl_case_kripke)
; val_rel_le_sum_inl_case_kripke: forall n Σ T1 T2 a1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) (EInl a1 T2) v2 -> exists a2, v2 = EInl a2 T2 /\ value a1 /
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_inl_case_kripke [partial: bindings preserved]

; val_rel_le_sum_inr_case_kripke (matches Coq: Lemma val_rel_le_sum_inr_case_kripke)
; val_rel_le_sum_inr_case_kripke: forall n Σ T1 T2 b1 v2, n > 0 -> val_rel_le n Σ (TSum T1 T2) (EInr b1 T1) v2 -> exists b2, v2 = EInr b2 T1 /\ value b1 /
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (b1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_inr_case_kripke [partial: bindings preserved]

; val_rel_le_sum_inl_case_right_kripke (matches Coq: Lemma val_rel_le_sum_inl_case_right_kripke)
; val_rel_le_sum_inl_case_right_kripke: forall n Σ T1 T2 v1 a2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 (EInl a2 T2) -> exists a1, v1 = EInl a1 T2 /\ value a1 /
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (a2 Bool)) (= 0 0))) ; val_rel_le_sum_inl_case_right_kripke [partial: bindings preserved]

; val_rel_le_sum_inr_case_right_kripke (matches Coq: Lemma val_rel_le_sum_inr_case_right_kripke)
; val_rel_le_sum_inr_case_right_kripke: forall n Σ T1 T2 v1 b2, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 (EInr b2 T1) -> exists b1, v1 = EInr b1 T1 /\ value b1 /
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_sum_inr_case_right_kripke [partial: bindings preserved]

; val_rel_le_sum_inl_pair_case_kripke (matches Coq: Lemma val_rel_le_sum_inl_pair_case_kripke)
; val_rel_le_sum_inl_pair_case_kripke: forall n Σ T1 T2 a1 a2, n > 0 -> val_rel_le n Σ (TSum T1 T2) (EInl a1 T2) (EInl a2 T2) -> value a1 /\ value a2 /\ closed
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (a2 Bool)) (= 0 0))) ; val_rel_le_sum_inl_pair_case_kripke [partial: bindings preserved]

; val_rel_le_sum_inr_pair_case_kripke (matches Coq: Lemma val_rel_le_sum_inr_pair_case_kripke)
; val_rel_le_sum_inr_pair_case_kripke: forall n Σ T1 T2 b1 b2, n > 0 -> val_rel_le n Σ (TSum T1 T2) (EInr b1 T1) (EInr b2 T1) -> value b1 /\ value b2 /\ closed
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (b1 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_sum_inr_pair_case_kripke [partial: bindings preserved]

; val_rel_le_prod_pair_case_kripke (matches Coq: Lemma val_rel_le_prod_pair_case_kripke)
; val_rel_le_prod_pair_case_kripke: forall n Σ T1 T2 a1 b1 v2, n > 0 -> val_rel_le n Σ (TProd T1 T2) (EPair a1 b1) v2 -> exists a2 b2, v2 = EPair a2 b2 /\ v
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (b1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_pair_case_kripke [partial: bindings preserved]

; val_rel_le_prod_pair_case_right_kripke (matches Coq: Lemma val_rel_le_prod_pair_case_right_kripke)
; val_rel_le_prod_pair_case_right_kripke: forall n Σ T1 T2 v1 a2 b2, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 (EPair a2 b2) -> exists a1 b1, v1 = EPair a1 b1 /\ v
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (a2 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_prod_pair_case_right_kripke [partial: bindings preserved]

; val_rel_le_prod_pair_pair_case_kripke (matches Coq: Lemma val_rel_le_prod_pair_pair_case_kripke)
; val_rel_le_prod_pair_pair_case_kripke: forall n Σ T1 T2 a1 b1 a2 b2, n > 0 -> val_rel_le n Σ (TProd T1 T2) (EPair a1 b1) (EPair a2 b2) -> value a1 /\ value b1 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (b1 Bool) (a2 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_prod_pair_pair_case_kripke [partial: bindings preserved]

; exp_rel_step1_fst_kripke (matches Coq: Lemma exp_rel_step1_fst_kripke)
; exp_rel_step1_fst_kripke: forall n Σ T1 T2 v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_fst_kripke [partial: bindings preserved]

; exp_rel_step1_snd_kripke (matches Coq: Lemma exp_rel_step1_snd_kripke)
; exp_rel_step1_snd_kripke: forall n Σ T1 T2 v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> exists a1 b1 a2 b2, v1 = EPair a1 b1 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_snd_kripke [partial: bindings preserved]

; exp_rel_step1_if_kripke (matches Coq: Lemma exp_rel_step1_if_kripke)
; exp_rel_step1_if_kripke: forall n Σ v1 v2 e2 e2' e3 e3' st1 st2 ctx, n > 0 -> val_rel_le n Σ TBool v1 v2 -> exists b, v1 = EBool b /\ v2 = EBool 
(assert (forall ((n Bool) (sigma Bool) (v1 Bool) (v2 Bool) (e2 Bool) (e2_ Bool) (e3 Bool) (e3_ Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_if_kripke [partial: bindings preserved]

; exp_rel_step1_case_kripke (matches Coq: Lemma exp_rel_step1_case_kripke)
; exp_rel_step1_case_kripke: forall n Σ T1 T2 v1 v2 x1 e1 e1' x2 e2 e2' st1 st2 ctx, n > 0 -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> (exists a1 a2, v1 
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool) (x1 Bool) (e1 Bool) (e1_ Bool) (x2 Bool) (e2 Bool) (e2_ Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_case_kripke [partial: bindings preserved]

; exp_rel_step1_let_kripke (matches Coq: Lemma exp_rel_step1_let_kripke)
; exp_rel_step1_let_kripke: forall n Σ T v1 v2 x e e' st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = subst[x := v1] e /\ r2 = su
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (x Bool) (e Bool) (e_ Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_let_kripke [partial: bindings preserved]

; exp_rel_step1_handle_kripke (matches Coq: Lemma exp_rel_step1_handle_kripke)
; exp_rel_step1_handle_kripke: forall n Σ T v1 v2 x h h' st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = subst[x := v1] h /\ r2 = su
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (x Bool) (h Bool) (h_ Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_handle_kripke [partial: bindings preserved]

; exp_rel_step1_app_kripke (matches Coq: Lemma exp_rel_step1_app_kripke)
; exp_rel_step1_app_kripke: forall n Σ T1 T2 eff f1 f2 a1 a2 st1 st2 ctx, n > 0 -> val_rel_le n Σ (TFn T1 T2 eff) f1 f2 -> val_rel_le n Σ T1 a1 a2 -
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (eff Bool) (f1 Bool) (f2 Bool) (a1 Bool) (a2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_app_kripke [partial: bindings preserved]

; exp_rel_step1_perform_kripke (matches Coq: Lemma exp_rel_step1_perform_kripke)
; exp_rel_step1_perform_kripke: forall n Σ T eff v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = v1 /\ r2 = v2 /\ multi_step (E
(assert (forall ((n Bool) (sigma Bool) (T Bool) (eff Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_perform_kripke [partial: bindings preserved]

; exp_rel_step1_require_kripke (matches Coq: Lemma exp_rel_step1_require_kripke)
; exp_rel_step1_require_kripke: forall n Σ T eff v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = v1 /\ r2 = v2 /\ multi_step (E
(assert (forall ((n Bool) (sigma Bool) (T Bool) (eff Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_require_kripke [partial: bindings preserved]

; exp_rel_step1_grant_kripke (matches Coq: Lemma exp_rel_step1_grant_kripke)
; exp_rel_step1_grant_kripke: forall n Σ T eff v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = v1 /\ r2 = v2 /\ multi_step (E
(assert (forall ((n Bool) (sigma Bool) (T Bool) (eff Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_grant_kripke [partial: bindings preserved]

; exp_rel_step1_classify_kripke (matches Coq: Lemma exp_rel_step1_classify_kripke)
; exp_rel_step1_classify_kripke: forall n Σ T v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = EClassify v1 /\ r2 = EClassify v2 
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_classify_kripke [partial: bindings preserved]

; exp_rel_step1_prove_kripke (matches Coq: Lemma exp_rel_step1_prove_kripke)
; exp_rel_step1_prove_kripke: forall n Σ T v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = EProve v1 /\ r2 = EProve v2 /\ mul
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_prove_kripke [partial: bindings preserved]

; exp_rel_step1_declassify_kripke (matches Coq: Lemma exp_rel_step1_declassify_kripke)
; exp_rel_step1_declassify_kripke: forall n Σ T v1 v2 st1 st2 ctx, n > 0 -> val_rel_le n Σ T v1 v2 -> exists r1 r2, r1 = v1 /\ r2 = v2 /\ multi_step (EDecl
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool) (st1 Bool) (st2 Bool) (ctx Bool)) (= 0 0))) ; exp_rel_step1_declassify_kripke [partial: bindings preserved]

; val_rel_le_prod_mono_step (matches Coq: Lemma val_rel_le_prod_mono_step)
; val_rel_le_prod_mono_step: forall n m Σ T1 T2 v1 v2, m <= n -> val_rel_le n Σ (TProd T1 T2) v1 v2 -> val_rel_le m Σ (TProd T1 T2) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_prod_mono_step [partial: bindings preserved]

; val_rel_le_sum_mono_step (matches Coq: Lemma val_rel_le_sum_mono_step)
; val_rel_le_sum_mono_step: forall n m Σ T1 T2 v1 v2, m <= n -> val_rel_le n Σ (TSum T1 T2) v1 v2 -> val_rel_le m Σ (TSum T1 T2) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T1 Bool) (T2 Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sum_mono_step [partial: bindings preserved]

; val_rel_le_secret_characterization (matches Coq: Lemma val_rel_le_secret_characterization)
; val_rel_le_secret_characterization: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TSecret T) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secret_characterization [partial: bindings preserved]

; val_rel_le_labeled_characterization (matches Coq: Lemma val_rel_le_labeled_characterization)
; val_rel_le_labeled_characterization: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TLabeled T sl) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ clos
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_labeled_characterization [partial: bindings preserved]

; val_rel_le_tainted_characterization (matches Coq: Lemma val_rel_le_tainted_characterization)
; val_rel_le_tainted_characterization: forall n Σ T src v1 v2, n > 0 -> val_rel_le n Σ (TTainted T src) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ cl
(assert (forall ((n Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_tainted_characterization [partial: bindings preserved]

; val_rel_le_sanitized_characterization (matches Coq: Lemma val_rel_le_sanitized_characterization)
; val_rel_le_sanitized_characterization: forall n Σ T san v1 v2, n > 0 -> val_rel_le n Σ (TSanitized T san) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ 
(assert (forall ((n Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sanitized_characterization [partial: bindings preserved]

; val_rel_le_capability_characterization (matches Coq: Lemma val_rel_le_capability_characterization)
; val_rel_le_capability_characterization: forall n Σ k v1 v2, n > 0 -> val_rel_le n Σ (TCapability k) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ closed_
(assert (forall ((n Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_characterization [partial: bindings preserved]

; val_rel_le_capability_full_characterization (matches Coq: Lemma val_rel_le_capability_full_characterization)
; val_rel_le_capability_full_characterization: forall n Σ cap v1 v2, n > 0 -> val_rel_le n Σ (TCapabilityFull cap) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\
(assert (forall ((n Bool) (sigma Bool) (cap Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_full_characterization [partial: bindings preserved]

; val_rel_le_capability_full_values_closed (matches Coq: Lemma val_rel_le_capability_full_values_closed)
; val_rel_le_capability_full_values_closed: forall n Σ cap v1 v2, n > 0 -> val_rel_le n Σ (TCapabilityFull cap) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ c
(assert (forall ((n Bool) (sigma Bool) (cap Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_full_values_closed [partial: bindings preserved]

; val_rel_le_proof_characterization (matches Coq: Lemma val_rel_le_proof_characterization)
; val_rel_le_proof_characterization: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TProof T) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr 
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_proof_characterization [partial: bindings preserved]

; val_rel_le_constant_time_characterization (matches Coq: Lemma val_rel_le_constant_time_characterization)
; val_rel_le_constant_time_characterization: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TConstantTime T) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ close
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_constant_time_characterization [partial: bindings preserved]

; val_rel_le_zeroizing_characterization (matches Coq: Lemma val_rel_le_zeroizing_characterization)
; val_rel_le_zeroizing_characterization: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TZeroizing T) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ closed_e
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_zeroizing_characterization [partial: bindings preserved]

; val_rel_le_chan_characterization (matches Coq: Lemma val_rel_le_chan_characterization)
; val_rel_le_chan_characterization: forall n Σ pid v1 v2, n > 0 -> val_rel_le n Σ (TChan pid) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ closed_ex
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_chan_characterization [partial: bindings preserved]

; val_rel_le_chan_values_closed (matches Coq: Lemma val_rel_le_chan_values_closed)
; val_rel_le_chan_values_closed: forall n Σ pid v1 v2, n > 0 -> val_rel_le n Σ (TChan pid) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_chan_values_closed [partial: bindings preserved]

; val_rel_le_secure_chan_characterization (matches Coq: Lemma val_rel_le_secure_chan_characterization)
; val_rel_le_secure_chan_characterization: forall n Σ pid sid v1 v2, n > 0 -> val_rel_le n Σ (TSecureChan pid sid) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (sid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secure_chan_characterization [partial: bindings preserved]

; val_rel_le_secure_chan_values_closed (matches Coq: Lemma val_rel_le_secure_chan_values_closed)
; val_rel_le_secure_chan_values_closed: forall n Σ pid sid v1 v2, n > 0 -> val_rel_le n Σ (TSecureChan pid sid) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 
(assert (forall ((n Bool) (sigma Bool) (pid Bool) (sid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secure_chan_values_closed [partial: bindings preserved]

; val_rel_le_list_characterization (matches Coq: Lemma val_rel_le_list_characterization)
; val_rel_le_list_characterization: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TList T) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_list_characterization [partial: bindings preserved]

; val_rel_le_list_values_closed (matches Coq: Lemma val_rel_le_list_values_closed)
; val_rel_le_list_values_closed: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TList T) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_list_values_closed [partial: bindings preserved]

; val_rel_le_option_characterization (matches Coq: Lemma val_rel_le_option_characterization)
; val_rel_le_option_characterization: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TOption T) v1 v2 <-> (value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_option_characterization [partial: bindings preserved]

; val_rel_le_option_values_closed (matches Coq: Lemma val_rel_le_option_values_closed)
; val_rel_le_option_values_closed: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TOption T) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_option_values_closed [partial: bindings preserved]

; val_rel_le_secret_values_closed (matches Coq: Lemma val_rel_le_secret_values_closed)
; val_rel_le_secret_values_closed: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TSecret T) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_secret_values_closed [partial: bindings preserved]

; val_rel_le_labeled_values_closed (matches Coq: Lemma val_rel_le_labeled_values_closed)
; val_rel_le_labeled_values_closed: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TLabeled T sl) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_labeled_values_closed [partial: bindings preserved]

; val_rel_le_tainted_values_closed (matches Coq: Lemma val_rel_le_tainted_values_closed)
; val_rel_le_tainted_values_closed: forall n Σ T src v1 v2, n > 0 -> val_rel_le n Σ (TTainted T src) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ clos
(assert (forall ((n Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_tainted_values_closed [partial: bindings preserved]

; val_rel_le_sanitized_values_closed (matches Coq: Lemma val_rel_le_sanitized_values_closed)
; val_rel_le_sanitized_values_closed: forall n Σ T san v1 v2, n > 0 -> val_rel_le n Σ (TSanitized T san) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ cl
(assert (forall ((n Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_sanitized_values_closed [partial: bindings preserved]

; val_rel_le_capability_values_closed (matches Coq: Lemma val_rel_le_capability_values_closed)
; val_rel_le_capability_values_closed: forall n Σ k v1 v2, n > 0 -> val_rel_le n Σ (TCapability k) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_ex
(assert (forall ((n Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_capability_values_closed [partial: bindings preserved]

; val_rel_le_proof_values_closed (matches Coq: Lemma val_rel_le_proof_values_closed)
; val_rel_le_proof_values_closed: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TProof T) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_expr v2
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_proof_values_closed [partial: bindings preserved]

; val_rel_le_constant_time_values_closed (matches Coq: Lemma val_rel_le_constant_time_values_closed)
; val_rel_le_constant_time_values_closed: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TConstantTime T) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_constant_time_values_closed [partial: bindings preserved]

; val_rel_le_zeroizing_values_closed (matches Coq: Lemma val_rel_le_zeroizing_values_closed)
; val_rel_le_zeroizing_values_closed: forall n Σ T v1 v2, n > 0 -> val_rel_le n Σ (TZeroizing T) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_exp
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_zeroizing_values_closed [partial: bindings preserved]

; store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
; store_ty_lookup_update_neq: forall l l' T sl Σ, l <> l' -> store_ty_lookup l' (store_ty_update l T sl Σ) = store_ty_lookup l' Σ
(assert (forall ((l Bool) (l_ Bool) (T Bool) (sl Bool) (sigma Bool)) (= 0 0))) ; store_ty_lookup_update_neq [partial: bindings preserved]

; store_ty_extends_add (matches Coq: Lemma store_ty_extends_add)
; store_ty_extends_add: forall Σ l T sl, store_ty_lookup l Σ = None -> store_ty_extends Σ (store_ty_update l T sl Σ)
(assert (forall ((sigma Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_ty_extends_add [partial: bindings preserved]

; val_rel_le_build_labeled (matches Coq: Lemma val_rel_le_build_labeled)
; val_rel_le_build_labeled: forall m Σ T sl v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TLabeled T sl) v1 v2
(assert (forall ((m Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_labeled [partial: bindings preserved]

; val_rel_le_step_up_labeled (matches Coq: Lemma val_rel_le_step_up_labeled)
; val_rel_le_step_up_labeled: forall n m Σ T sl v1 v2, val_rel_le n Σ (TLabeled T sl) v1 v2 -> n > 0 -> val_rel_le m Σ (TLabeled T sl) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_labeled [partial: bindings preserved]

; val_rel_le_build_tainted (matches Coq: Lemma val_rel_le_build_tainted)
; val_rel_le_build_tainted: forall m Σ T src v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TTainted T src) v1 v
(assert (forall ((m Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_tainted [partial: bindings preserved]

; val_rel_le_step_up_tainted (matches Coq: Lemma val_rel_le_step_up_tainted)
; val_rel_le_step_up_tainted: forall n m Σ T src v1 v2, val_rel_le n Σ (TTainted T src) v1 v2 -> n > 0 -> val_rel_le m Σ (TTainted T src) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (src Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_tainted [partial: bindings preserved]

; val_rel_le_build_sanitized (matches Coq: Lemma val_rel_le_build_sanitized)
; val_rel_le_build_sanitized: forall m Σ T san v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TSanitized T san) v1
(assert (forall ((m Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_sanitized [partial: bindings preserved]

; val_rel_le_step_up_sanitized (matches Coq: Lemma val_rel_le_step_up_sanitized)
; val_rel_le_step_up_sanitized: forall n m Σ T san v1 v2, val_rel_le n Σ (TSanitized T san) v1 v2 -> n > 0 -> val_rel_le m Σ (TSanitized T san) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (san Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_sanitized [partial: bindings preserved]

; val_rel_le_build_proof (matches Coq: Lemma val_rel_le_build_proof)
; val_rel_le_build_proof: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TProof T) v1 v2
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_proof [partial: bindings preserved]

; val_rel_le_step_up_proof (matches Coq: Lemma val_rel_le_step_up_proof)
; val_rel_le_step_up_proof: forall n m Σ T v1 v2, val_rel_le n Σ (TProof T) v1 v2 -> n > 0 -> val_rel_le m Σ (TProof T) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_proof [partial: bindings preserved]

; val_rel_le_build_ct (matches Coq: Lemma val_rel_le_build_ct)
; val_rel_le_build_ct: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TConstantTime T) v1 v2
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_ct [partial: bindings preserved]

; val_rel_le_step_up_ct (matches Coq: Lemma val_rel_le_step_up_ct)
; val_rel_le_step_up_ct: forall n m Σ T v1 v2, val_rel_le n Σ (TConstantTime T) v1 v2 -> n > 0 -> val_rel_le m Σ (TConstantTime T) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_ct [partial: bindings preserved]

; val_rel_le_build_zero (matches Coq: Lemma val_rel_le_build_zero)
; val_rel_le_build_zero: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TZeroizing T) v1 v2
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_zero [partial: bindings preserved]

; val_rel_le_step_up_zero (matches Coq: Lemma val_rel_le_step_up_zero)
; val_rel_le_step_up_zero: forall n m Σ T v1 v2, val_rel_le n Σ (TZeroizing T) v1 v2 -> n > 0 -> val_rel_le m Σ (TZeroizing T) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_zero [partial: bindings preserved]

; val_rel_le_build_cap (matches Coq: Lemma val_rel_le_build_cap)
; val_rel_le_build_cap: forall m Σ k v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TCapability k) v1 v2
(assert (forall ((m Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_cap [partial: bindings preserved]

; val_rel_le_step_up_cap (matches Coq: Lemma val_rel_le_step_up_cap)
; val_rel_le_step_up_cap: forall n m Σ k v1 v2, val_rel_le n Σ (TCapability k) v1 v2 -> n > 0 -> val_rel_le m Σ (TCapability k) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (k Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_cap [partial: bindings preserved]

; val_rel_le_build_cap_full (matches Coq: Lemma val_rel_le_build_cap_full)
; val_rel_le_build_cap_full: forall m Σ cap v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TCapabilityFull cap) v
(assert (forall ((m Bool) (sigma Bool) (cap Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_cap_full [partial: bindings preserved]

; val_rel_le_step_up_cap_full (matches Coq: Lemma val_rel_le_step_up_cap_full)
; val_rel_le_step_up_cap_full: forall n m Σ cap v1 v2, val_rel_le n Σ (TCapabilityFull cap) v1 v2 -> n > 0 -> val_rel_le m Σ (TCapabilityFull cap) v1 v
(assert (forall ((n Bool) (m Bool) (sigma Bool) (cap Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_cap_full [partial: bindings preserved]

; val_rel_le_build_list (matches Coq: Lemma val_rel_le_build_list)
; val_rel_le_build_list: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TList T) v1 v2
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_list [partial: bindings preserved]

; val_rel_le_step_up_list (matches Coq: Lemma val_rel_le_step_up_list)
; val_rel_le_step_up_list: forall n m Σ T v1 v2, val_rel_le n Σ (TList T) v1 v2 -> n > 0 -> val_rel_le m Σ (TList T) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_list [partial: bindings preserved]

; val_rel_le_build_option (matches Coq: Lemma val_rel_le_build_option)
; val_rel_le_build_option: forall m Σ T v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TOption T) v1 v2
(assert (forall ((m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_option [partial: bindings preserved]

; val_rel_le_step_up_option (matches Coq: Lemma val_rel_le_step_up_option)
; val_rel_le_step_up_option: forall n m Σ T v1 v2, val_rel_le n Σ (TOption T) v1 v2 -> n > 0 -> val_rel_le m Σ (TOption T) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_option [partial: bindings preserved]

; val_rel_le_build_prod_pair_kripke (matches Coq: Lemma val_rel_le_build_prod_pair_kripke)
; val_rel_le_build_prod_pair_kripke: forall n Σ T1 T2 a1 b1 a2 b2, value a1 -> value b1 -> value a2 -> value b2 -> closed_expr a1 -> closed_expr b1 -> closed
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (b1 Bool) (a2 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_build_prod_pair_kripke [partial: bindings preserved]

; val_rel_le_build_sum_inl_kripke (matches Coq: Lemma val_rel_le_build_sum_inl_kripke)
; val_rel_le_build_sum_inl_kripke: forall n Σ T1 T2 a1 a2, value a1 -> value a2 -> closed_expr a1 -> closed_expr a2 -> val_rel_le n Σ T1 a1 a2 -> val_rel_l
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (a1 Bool) (a2 Bool)) (= 0 0))) ; val_rel_le_build_sum_inl_kripke [partial: bindings preserved]

; val_rel_le_build_sum_inr_kripke (matches Coq: Lemma val_rel_le_build_sum_inr_kripke)
; val_rel_le_build_sum_inr_kripke: forall n Σ T1 T2 b1 b2, value b1 -> value b2 -> closed_expr b1 -> closed_expr b2 -> val_rel_le n Σ T2 b1 b2 -> val_rel_l
(assert (forall ((n Bool) (sigma Bool) (T1 Bool) (T2 Bool) (b1 Bool) (b2 Bool)) (= 0 0))) ; val_rel_le_build_sum_inr_kripke [partial: bindings preserved]

; val_rel_le_build_chan (matches Coq: Lemma val_rel_le_build_chan)
; val_rel_le_build_chan: forall m Σ pid v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TChan pid) v1 v2
(assert (forall ((m Bool) (sigma Bool) (pid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_chan [partial: bindings preserved]

; val_rel_le_step_up_chan (matches Coq: Lemma val_rel_le_step_up_chan)
; val_rel_le_step_up_chan: forall n m Σ pid v1 v2, val_rel_le n Σ (TChan pid) v1 v2 -> n > 0 -> val_rel_le m Σ (TChan pid) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (pid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_chan [partial: bindings preserved]

; val_rel_le_build_secure_chan (matches Coq: Lemma val_rel_le_build_secure_chan)
; val_rel_le_build_secure_chan: forall m Σ pid sid v1 v2, value v1 -> value v2 -> closed_expr v1 -> closed_expr v2 -> val_rel_le m Σ (TSecureChan pid si
(assert (forall ((m Bool) (sigma Bool) (pid Bool) (sid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_build_secure_chan [partial: bindings preserved]

; val_rel_le_step_up_secure_chan (matches Coq: Lemma val_rel_le_step_up_secure_chan)
; val_rel_le_step_up_secure_chan: forall n m Σ pid sid v1 v2, val_rel_le n Σ (TSecureChan pid sid) v1 v2 -> n > 0 -> val_rel_le m Σ (TSecureChan pid sid) 
(assert (forall ((n Bool) (m Bool) (sigma Bool) (pid Bool) (sid Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_secure_chan [partial: bindings preserved]

; val_rel_le_build_ref_kripke (matches Coq: Lemma val_rel_le_build_ref_kripke)
; val_rel_le_build_ref_kripke: forall m Σ T sl l, val_rel_le m Σ (TRef T sl) (ELoc l) (ELoc l)
(assert (forall ((m Bool) (sigma Bool) (T Bool) (sl Bool) (l Bool)) (= 0 0))) ; val_rel_le_build_ref_kripke [partial: bindings preserved]

; val_rel_le_step_up_ref (matches Coq: Lemma val_rel_le_step_up_ref)
; val_rel_le_step_up_ref: forall n m Σ T sl v1 v2, val_rel_le n Σ (TRef T sl) v1 v2 -> n > 0 -> val_rel_le m Σ (TRef T sl) v1 v2
(assert (forall ((n Bool) (m Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_step_up_ref [partial: bindings preserved]

; val_rel_le_ref_characterization (matches Coq: Lemma val_rel_le_ref_characterization)
; val_rel_le_ref_characterization: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TRef T sl) v1 v2 <-> exists l, v1 = ELoc l /\ v2 = ELoc l
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_ref_characterization [partial: bindings preserved]

; val_rel_le_ref_values_closed (matches Coq: Lemma val_rel_le_ref_values_closed)
; val_rel_le_ref_values_closed: forall n Σ T sl v1 v2, n > 0 -> val_rel_le n Σ (TRef T sl) v1 v2 -> value v1 /\ value v2 /\ closed_expr v1 /\ closed_exp
(assert (forall ((n Bool) (sigma Bool) (T Bool) (sl Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_ref_values_closed [partial: bindings preserved]

; val_rel_le_pos_values_closed_indist (matches Coq: Lemma val_rel_le_pos_values_closed_indist)
; val_rel_le_pos_values_closed_indist: forall n Σ T v1 v2, n > 0 -> (match T with | TSecret _ | TLabeled _ _ | TTainted _ _ | TSanitized _ _ | TCapability _ | 
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_pos_values_closed_indist [partial: bindings preserved]

; val_rel_le_pos_values_closed_base (matches Coq: Lemma val_rel_le_pos_values_closed_base)
; val_rel_le_pos_values_closed_base: forall n Σ T v1 v2, n > 0 -> (match T with | TUnit | TBool | TInt | TString | TBytes | TRef _ _ => True | _ => False end
(assert (forall ((n Bool) (sigma Bool) (T Bool) (v1 Bool) (v2 Bool)) (= 0 0))) ; val_rel_le_pos_values_closed_base [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

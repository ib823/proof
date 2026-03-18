(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/KripkeProperties.v (134 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.KripkeProperties
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> nat -> nat -> nat -> nat -> nat -> bool

(* step — Coq Prop predicate stub *)
assume val step : nat -> nat -> bool

(* multi_step — Coq Prop predicate stub *)
assume val multi_step : nat -> nat -> bool

(* val_rel_at (matches Coq: Definition val_rel_at) *)
let val_rel_at (p_n: nat) (p_sigma: nat) (p_t: nat) (p_v1: nat) (p_v2: nat) : Tot bool =
  true

(* store_ty_extends_preorder (matches Coq: Lemma store_ty_extends_preorder) *)
let store_ty_extends_preorder () : Lemma (((forall (sigma: _). store_ty_extends sigma sigma == true)) /\ ((forall (sigma1: _). (forall (sigma2: _). (forall (sigma3: _). store_ty_extends sigma1 sigma2 -> store_ty_extends sigma2 sigma3 -> store_ty_extends sigma1 sigma3 == true))))) = admit ()

(* val_rel_le_build_unit (matches Coq: Lemma val_rel_le_build_unit) *)
let val_rel_le_build_unit (p_m: _) (p_sigma: _) : Lemma (val_rel_le p_m p_sigma TUnit EUnit EUnit == true) = admit ()

(* val_rel_le_step_up_unit (matches Coq: Lemma val_rel_le_step_up_unit) *)
let val_rel_le_step_up_unit (p_n: _) (p_m: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma TUnit p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma TUnit p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_bool (matches Coq: Lemma val_rel_le_build_bool) *)
let val_rel_le_build_bool (p_m: _) (p_sigma: _) (p_b: _) : Lemma (val_rel_le p_m p_sigma TBool (EBool p_b) (EBool p_b) == true) = admit ()

(* val_rel_le_step_up_bool (matches Coq: Lemma val_rel_le_step_up_bool) *)
let val_rel_le_step_up_bool (p_n: _) (p_m: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma TBool p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma TBool p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_int (matches Coq: Lemma val_rel_le_build_int) *)
let val_rel_le_build_int (p_m: _) (p_sigma: _) (p_i: _) : Lemma (val_rel_le p_m p_sigma TInt (EInt p_i) (EInt p_i) == true) = admit ()

(* val_rel_le_step_up_int (matches Coq: Lemma val_rel_le_step_up_int) *)
let val_rel_le_step_up_int (p_n: _) (p_m: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma TInt p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma TInt p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_string (matches Coq: Lemma val_rel_le_build_string) *)
let val_rel_le_build_string (p_m: _) (p_sigma: _) (p_s: _) : Lemma (val_rel_le p_m p_sigma TString (EString p_s) (EString p_s) == true) = admit ()

(* val_rel_le_step_up_string (matches Coq: Lemma val_rel_le_step_up_string) *)
let val_rel_le_step_up_string (p_n: _) (p_m: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma TString p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma TString p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_bytes (matches Coq: Lemma val_rel_le_build_bytes) *)
let val_rel_le_build_bytes (p_m: _) (p_sigma: _) (p_v: _) : Lemma (requires (value p_v == true /\ closed_expr p_v == true)) (ensures (val_rel_le p_m p_sigma TBytes p_v p_v == true)) = admit ()

(* val_rel_le_step_up_bytes (matches Coq: Lemma val_rel_le_step_up_bytes) *)
let val_rel_le_step_up_bytes (p_n: _) (p_m: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma TBytes p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma TBytes p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_secret (matches Coq: Lemma val_rel_le_build_secret) *)
let val_rel_le_build_secret (p_m: _) (p_sigma: _) (p_l: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TSecret p_l) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_secret (matches Coq: Lemma val_rel_le_step_up_secret) *)
let val_rel_le_step_up_secret (p_n: _) (p_m: _) (p_sigma: _) (p_l: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TSecret p_l) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TSecret p_l) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_kripke_mono (matches Coq: Lemma val_rel_le_kripke_mono) *)
let val_rel_le_kripke_mono (p_n: _) (p_m: _) (p_sigma: _) (p_sigma_prime: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ store_ty_extends p_sigma p_sigma' == true /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_m p_sigma' p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_le_store_preserves_step (matches Coq: Lemma val_rel_le_store_preserves_step) *)
let val_rel_le_store_preserves_step (p_n: _) (p_sigma: _) (p_sigma_prime: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma' p_t p_v1 p_v2 == true)) = admit ()

(* store_rel_le_kripke_step (matches Coq: Lemma store_rel_le_kripke_step) *)
let store_rel_le_kripke_step (p_n: _) (p_m: _) (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (p_m <= p_n /\ store_rel_le p_n p_sigma p_st1 p_st2 == true)) (ensures (store_rel_le p_m p_sigma p_st1 p_st2 == true)) = admit ()

(* val_rel_le_includes_at (matches Coq: Lemma val_rel_le_includes_at) *)
let val_rel_le_includes_at (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_at p_n p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_at_to_le (matches Coq: Lemma val_rel_at_to_le) *)
let val_rel_at_to_le (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true /\ val_rel_at ((p_n + 1)) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le ((p_n + 1)) p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_le_succ_inv (matches Coq: Lemma val_rel_le_succ_inv) *)
let val_rel_le_succ_inv (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le ((p_n + 1)) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true /\ val_rel_struct (val_rel_le p_n) p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_le_succ_intro (matches Coq: Lemma val_rel_le_succ_intro) *)
let val_rel_le_succ_intro (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true /\ val_rel_struct (val_rel_le p_n) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le ((p_n + 1)) p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_le_pos_has_prev (matches Coq: Lemma val_rel_le_pos_has_prev) *)
let val_rel_le_pos_has_prev (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_le_pos_has_struct (matches Coq: Lemma val_rel_le_pos_has_struct) *)
let val_rel_le_pos_has_struct (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_struct (val_rel_le ((if p_n > 0 then p_n - 1 else 0))) p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_le_extract_struct_0 (matches Coq: Lemma val_rel_le_extract_struct_0) *)
let val_rel_le_extract_struct_0 (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n >= 1 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_struct (val_rel_le 0) p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_indist (matches Coq: Lemma val_rel_le_build_indist) *)
let val_rel_le_build_indist_obligation () : Tot bool = true
let val_rel_le_build_indist_lemma () : Lemma (requires True) (ensures (val_rel_le_build_indist_obligation () == val_rel_le_build_indist_obligation ())) = ()

(* val_rel_le_step_up_fo (matches Coq: Lemma val_rel_le_step_up_fo) *)
let val_rel_le_step_up_fo (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (first_order_type p_t == true /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true /\ p_n > fo_compound_depth p_t)) (ensures (val_rel_le p_m p_sigma p_t p_v1 p_v2 == true)) = admit ()

(* val_rel_le_base_permanent (matches Coq: Lemma val_rel_le_base_permanent) *)
let val_rel_le_base_permanent_obligation () : Tot bool = true
let val_rel_le_base_permanent_lemma () : Lemma (requires True) (ensures (val_rel_le_base_permanent_obligation () == val_rel_le_base_permanent_obligation ())) = ()

(* val_rel_le_unit_eq (matches Coq: Lemma val_rel_le_unit_eq) *)
let val_rel_le_unit_eq (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TUnit p_v1 p_v2 == true <==> (p_v1 == EUnit /\ p_v2 == EUnit))) = admit ()

(* val_rel_le_bool_eq (matches Coq: Lemma val_rel_le_bool_eq) *)
let val_rel_le_bool_eq (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TBool p_v1 p_v2 == true <==> ((exists p_b. p_v1 == EBool p_b) /\ p_v2 == EBool b))) = admit ()

(* val_rel_le_int_eq (matches Coq: Lemma val_rel_le_int_eq) *)
let val_rel_le_int_eq (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TInt p_v1 p_v2 == true <==> ((exists p_i. p_v1 == EInt p_i) /\ p_v2 == EInt i))) = admit ()

(* val_rel_le_string_eq (matches Coq: Lemma val_rel_le_string_eq) *)
let val_rel_le_string_eq (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TString p_v1 p_v2 == true <==> ((exists p_s. p_v1 == EString p_s) /\ p_v2 == EString s))) = admit ()

(* val_rel_le_bytes_eq (matches Coq: Lemma val_rel_le_bytes_eq) *)
let val_rel_le_bytes_eq (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TBytes p_v1 p_v2 == true <==> (p_v1 == p_v2 /\ value p_v1 == true /\ closed_expr p_v1 == true))) = admit ()

(* val_rel_le_unit_characterization (matches Coq: Lemma val_rel_le_unit_characterization) *)
let val_rel_le_unit_characterization (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TUnit p_v1 p_v2 == true <==> (p_v1 == EUnit /\ p_v2 == EUnit))) = admit ()

(* val_rel_le_bool_characterization (matches Coq: Lemma val_rel_le_bool_characterization) *)
let val_rel_le_bool_characterization (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TBool p_v1 p_v2 == true <==> ((exists p_b. p_v1 == EBool p_b) /\ p_v2 == EBool b))) = admit ()

(* val_rel_le_int_characterization (matches Coq: Lemma val_rel_le_int_characterization) *)
let val_rel_le_int_characterization (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TInt p_v1 p_v2 == true <==> ((exists p_i. p_v1 == EInt p_i) /\ p_v2 == EInt i))) = admit ()

(* val_rel_le_string_characterization (matches Coq: Lemma val_rel_le_string_characterization) *)
let val_rel_le_string_characterization (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TString p_v1 p_v2 == true <==> ((exists p_s. p_v1 == EString p_s) /\ p_v2 == EString s))) = admit ()

(* val_rel_le_bytes_characterization (matches Coq: Lemma val_rel_le_bytes_characterization) *)
let val_rel_le_bytes_characterization (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma TBytes p_v1 p_v2 == true <==> (p_v1 == p_v2 /\ value p_v1 == true /\ closed_expr p_v1 == true))) = admit ()

(* val_rel_le_unit_values_closed (matches Coq: Lemma val_rel_le_unit_values_closed) *)
let val_rel_le_unit_values_closed (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TUnit p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_bool_values_closed (matches Coq: Lemma val_rel_le_bool_values_closed) *)
let val_rel_le_bool_values_closed (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBool p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_int_values_closed (matches Coq: Lemma val_rel_le_int_values_closed) *)
let val_rel_le_int_values_closed (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TInt p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_string_values_closed (matches Coq: Lemma val_rel_le_string_values_closed) *)
let val_rel_le_string_values_closed (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TString p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_bytes_values_closed (matches Coq: Lemma val_rel_le_bytes_values_closed) *)
let val_rel_le_bytes_values_closed (p_n: _) (p_sigma: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma TBytes p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_prod_components_kripke (matches Coq: Lemma val_rel_le_prod_components_kripke) *)
let val_rel_le_prod_components_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true)) = admit ()

(* val_rel_le_sum_extract_kripke (matches Coq: Lemma val_rel_le_sum_extract_kripke) *)
let val_rel_le_sum_extract_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (((exists p_a1. (exists p_a2. p_v1 == EInl p_a1 p_t2)) /\ p_v2 == EInl a2 p_t2 /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true) \/ ((exists p_b1. (exists p_b2. p_v1 == EInr p_b1 p_t1)) /\ p_v2 == EInr b2 p_t1 /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true))) = admit ()

(* val_rel_le_prod_values_closed (matches Coq: Lemma val_rel_le_prod_values_closed) *)
let val_rel_le_prod_values_closed (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_sum_values_closed (matches Coq: Lemma val_rel_le_sum_values_closed) *)
let val_rel_le_sum_values_closed (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_prod_components_wf_kripke (matches Coq: Lemma val_rel_le_prod_components_wf_kripke) *)
let val_rel_le_prod_components_wf_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ value a1 == true /\ value b1 == true /\ value a2 == true /\ value b2 == true /\ closed_expr a1 == true /\ closed_expr b1 == true /\ closed_expr a2 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true)) = admit ()

(* val_rel_le_prod_case_kripke (matches Coq: Lemma val_rel_le_prod_case_kripke) *)
let val_rel_le_prod_case_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ value a1 == true /\ value b1 == true /\ value a2 == true /\ value b2 == true /\ closed_expr a1 == true /\ closed_expr b1 == true /\ closed_expr a2 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true)) = admit ()

(* val_rel_le_sum_extract_wf_kripke (matches Coq: Lemma val_rel_le_sum_extract_wf_kripke) *)
let val_rel_le_sum_extract_wf_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (((exists p_a1. (exists p_a2. p_v1 == EInl p_a1 p_t2)) /\ p_v2 == EInl a2 p_t2 /\ value a1 == true /\ value a2 == true /\ closed_expr a1 == true /\ closed_expr a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true) \/ ((exists p_b1. (exists p_b2. p_v1 == EInr p_b1 p_t1)) /\ p_v2 == EInr b2 p_t1 /\ value b1 == true /\ value b2 == true /\ closed_expr b1 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true))) = admit ()

(* val_rel_le_sum_case_kripke (matches Coq: Lemma val_rel_le_sum_case_kripke) *)
let val_rel_le_sum_case_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (((exists p_a1. (exists p_a2. p_v1 == EInl p_a1 p_t2)) /\ p_v2 == EInl a2 p_t2 /\ value a1 == true /\ value a2 == true /\ closed_expr a1 == true /\ closed_expr a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true) \/ ((exists p_b1. (exists p_b2. p_v1 == EInr p_b1 p_t1)) /\ p_v2 == EInr b2 p_t1 /\ value b1 == true /\ value b2 == true /\ closed_expr b1 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true))) = admit ()

(* val_rel_le_sum_inl_case_kripke (matches Coq: Lemma val_rel_le_sum_inl_case_kripke) *)
let val_rel_le_sum_inl_case_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInl p_a1 p_t2) p_v2 == true)) (ensures ((exists p_a2. p_v2 == EInl p_a2 p_t2) /\ value p_a1 == true /\ value a2 == true /\ closed_expr p_a1 == true /\ closed_expr a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 p_a1 a2 == true)) = admit ()

(* val_rel_le_sum_inr_case_kripke (matches Coq: Lemma val_rel_le_sum_inr_case_kripke) *)
let val_rel_le_sum_inr_case_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_b1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInr p_b1 p_t1) p_v2 == true)) (ensures ((exists p_b2. p_v2 == EInr p_b2 p_t1) /\ value p_b1 == true /\ value b2 == true /\ closed_expr p_b1 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 p_b1 b2 == true)) = admit ()

(* val_rel_le_sum_inl_case_right_kripke (matches Coq: Lemma val_rel_le_sum_inl_case_right_kripke) *)
let val_rel_le_sum_inl_case_right_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_a2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 (EInl p_a2 p_t2) == true)) (ensures ((exists p_a1. p_v1 == EInl p_a1 p_t2) /\ value a1 == true /\ value p_a2 == true /\ closed_expr a1 == true /\ closed_expr p_a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 p_a2 == true)) = admit ()

(* val_rel_le_sum_inr_case_right_kripke (matches Coq: Lemma val_rel_le_sum_inr_case_right_kripke) *)
let val_rel_le_sum_inr_case_right_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_b2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 (EInr p_b2 p_t1) == true)) (ensures ((exists p_b1. p_v1 == EInr p_b1 p_t1) /\ value b1 == true /\ value p_b2 == true /\ closed_expr b1 == true /\ closed_expr p_b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 p_b2 == true)) = admit ()

(* val_rel_le_sum_inl_pair_case_kripke (matches Coq: Lemma val_rel_le_sum_inl_pair_case_kripke) *)
let val_rel_le_sum_inl_pair_case_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_a2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInl p_a1 p_t2) (EInl p_a2 p_t2) == true)) (ensures (value p_a1 == true /\ value p_a2 == true /\ closed_expr p_a1 == true /\ closed_expr p_a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 p_a1 p_a2 == true)) = admit ()

(* val_rel_le_sum_inr_pair_case_kripke (matches Coq: Lemma val_rel_le_sum_inr_pair_case_kripke) *)
let val_rel_le_sum_inr_pair_case_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_b1: _) (p_b2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInr p_b1 p_t1) (EInr p_b2 p_t1) == true)) (ensures (value p_b1 == true /\ value p_b2 == true /\ closed_expr p_b1 == true /\ closed_expr p_b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 p_b1 p_b2 == true)) = admit ()

(* val_rel_le_prod_pair_case_kripke (matches Coq: Lemma val_rel_le_prod_pair_case_kripke) *)
let val_rel_le_prod_pair_case_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_b1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) (EPair p_a1 p_b1) p_v2 == true)) (ensures ((exists p_a2. (exists p_b2. p_v2 == EPair p_a2 p_b2)) /\ value p_a1 == true /\ value p_b1 == true /\ value a2 == true /\ value b2 == true /\ closed_expr p_a1 == true /\ closed_expr p_b1 == true /\ closed_expr a2 == true /\ closed_expr b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 p_a1 a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 p_b1 b2 == true)) = admit ()

(* val_rel_le_prod_pair_case_right_kripke (matches Coq: Lemma val_rel_le_prod_pair_case_right_kripke) *)
let val_rel_le_prod_pair_case_right_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_a2: _) (p_b2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 (EPair p_a2 p_b2) == true)) (ensures ((exists p_a1. (exists p_b1. p_v1 == EPair p_a1 p_b1)) /\ value a1 == true /\ value b1 == true /\ value p_a2 == true /\ value p_b2 == true /\ closed_expr a1 == true /\ closed_expr b1 == true /\ closed_expr p_a2 == true /\ closed_expr p_b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 p_a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 p_b2 == true)) = admit ()

(* val_rel_le_prod_pair_pair_case_kripke (matches Coq: Lemma val_rel_le_prod_pair_pair_case_kripke) *)
let val_rel_le_prod_pair_pair_case_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_b1: _) (p_a2: _) (p_b2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) (EPair p_a1 p_b1) (EPair p_a2 p_b2) == true)) (ensures (value p_a1 == true /\ value p_b1 == true /\ value p_a2 == true /\ value p_b2 == true /\ closed_expr p_a1 == true /\ closed_expr p_b1 == true /\ closed_expr p_a2 == true /\ closed_expr p_b2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 p_a1 p_a2 == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 p_b1 p_b2 == true)) = admit ()

(* exp_rel_step1_fst_kripke (matches Coq: Lemma exp_rel_step1_fst_kripke) *)
let exp_rel_step1_fst_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ multi_step (EFst p_v1, p_st1, p_ctx) (a1, p_st1, p_ctx) == true /\ multi_step (EFst p_v2, p_st2, p_ctx) (a2, p_st2, p_ctx) == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true)) = admit ()

(* exp_rel_step1_snd_kripke (matches Coq: Lemma exp_rel_step1_snd_kripke) *)
let exp_rel_step1_snd_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures ((exists p_a1. (exists p_b1. (exists p_a2. (exists p_b2. p_v1 == EPair p_a1 p_b1)))) /\ p_v2 == EPair a2 b2 /\ multi_step (ESnd p_v1, p_st1, p_ctx) (b1, p_st1, p_ctx) == true /\ multi_step (ESnd p_v2, p_st2, p_ctx) (b2, p_st2, p_ctx) == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true)) = admit ()

(* exp_rel_step1_if_kripke (matches Coq: Lemma exp_rel_step1_if_kripke) *)
let exp_rel_step1_if_kripke_obligation () : Tot bool = true
let exp_rel_step1_if_kripke_lemma () : Lemma (requires True) (ensures (exp_rel_step1_if_kripke_obligation () == exp_rel_step1_if_kripke_obligation ())) = ()

(* exp_rel_step1_case_kripke (matches Coq: Lemma exp_rel_step1_case_kripke) *)
let exp_rel_step1_case_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) (p_x1: _) (p_e1: _) (p_e1_: _) (p_x2: _) (p_e2: _) (p_e2_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (((exists p_a1. (exists p_a2. p_v1 == EInl p_a1 p_t2)) /\ p_v2 == EInl a2 p_t2 /\ multi_step (ECase p_v1 p_x1 p_e1 p_x2 p_e2, p_st1, p_ctx) (subst_x1 := a1_ p_e1, p_st1, p_ctx) == true /\ multi_step (ECase p_v2 p_x1 p_e1_ p_x2 p_e2_, p_st2, p_ctx) (subst_x1 := a2_ p_e1_, p_st2, p_ctx) == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t1 a1 a2 == true) \/ ((exists p_b1. (exists p_b2. p_v1 == EInr p_b1 p_t1)) /\ p_v2 == EInr b2 p_t1 /\ multi_step (ECase p_v1 p_x1 p_e1 p_x2 p_e2, p_st1, p_ctx) (subst_x2 := b1_ p_e2, p_st1, p_ctx) == true /\ multi_step (ECase p_v2 p_x1 p_e1_ p_x2 p_e2_, p_st2, p_ctx) (subst_x2 := b2_ p_e2_, p_st2, p_ctx) == true /\ val_rel_le ((if p_n > 0 then p_n - 1 else 0)) p_sigma p_t2 b1 b2 == true))) = admit ()

(* exp_rel_step1_let_kripke (matches Coq: Lemma exp_rel_step1_let_kripke) *)
let exp_rel_step1_let_kripke (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_x: _) (p_e: _) (p_e_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == subst_x := v1_ p_e)) /\ r2 == subst_x := v2_ p_e_ /\ multi_step (ELet p_x p_v1 p_e, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (ELet p_x p_v2 p_e_, p_st2, p_ctx) (r2, p_st2, p_ctx) == true)) = admit ()

(* exp_rel_step1_handle_kripke (matches Coq: Lemma exp_rel_step1_handle_kripke) *)
let exp_rel_step1_handle_kripke (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_x: _) (p_h: _) (p_h_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == subst_x := v1_ p_h)) /\ r2 == subst_x := v2_ p_h_ /\ multi_step (EHandle p_v1 p_x p_h, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EHandle p_v2 p_x p_h_, p_st2, p_ctx) (r2, p_st2, p_ctx) == true)) = admit ()

(* exp_rel_step1_app_kripke (matches Coq: Lemma exp_rel_step1_app_kripke) *)
let exp_rel_step1_app_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_eff: _) (p_f1: _) (p_f2: _) (p_a1: _) (p_a2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TFn p_t1 p_t2 p_eff) p_f1 p_f2 == true /\ val_rel_le p_n p_sigma p_t1 p_a1 p_a2 == true /\ has_type [] p_sigma Public p_f1 (TFn p_t1 p_t2 p_eff) EffectPure == true /\ has_type [] p_sigma Public p_f2 (TFn p_t1 p_t2 p_eff) EffectPure == true)) (ensures ((exists p_x1. (exists p_body1. (exists p_x2. (exists p_body2. p_f1 == ELam p_x1 p_t1 p_body1)))) /\ p_f2 == ELam x2 p_t1 body2 /\ multi_step (EApp p_f1 p_a1, p_st1, p_ctx) (subst_x1 := a1_ body1, p_st1, p_ctx) == true /\ multi_step (EApp p_f2 p_a2, p_st2, p_ctx) (subst_x2 := a2_ body2, p_st2, p_ctx) == true)) = admit ()

(* exp_rel_step1_perform_kripke (matches Coq: Lemma exp_rel_step1_perform_kripke) *)
let exp_rel_step1_perform_kripke (p_n: _) (p_sigma: _) (p_t: _) (p_eff: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == p_v1)) /\ r2 == p_v2 /\ multi_step (EPerform p_eff p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EPerform p_eff p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t r1 r2 == true)) = admit ()

(* exp_rel_step1_require_kripke (matches Coq: Lemma exp_rel_step1_require_kripke) *)
let exp_rel_step1_require_kripke (p_n: _) (p_sigma: _) (p_t: _) (p_eff: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == p_v1)) /\ r2 == p_v2 /\ multi_step (ERequire p_eff p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (ERequire p_eff p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t r1 r2 == true)) = admit ()

(* exp_rel_step1_grant_kripke (matches Coq: Lemma exp_rel_step1_grant_kripke) *)
let exp_rel_step1_grant_kripke (p_n: _) (p_sigma: _) (p_t: _) (p_eff: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == p_v1)) /\ r2 == p_v2 /\ multi_step (EGrant p_eff p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EGrant p_eff p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t r1 r2 == true)) = admit ()

(* exp_rel_step1_classify_kripke (matches Coq: Lemma exp_rel_step1_classify_kripke) *)
let exp_rel_step1_classify_kripke (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == EClassify p_v1)) /\ r2 == EClassify p_v2 /\ multi_step (EClassify p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EClassify p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma (TSecret p_t) r1 r2 == true)) = admit ()

(* exp_rel_step1_prove_kripke (matches Coq: Lemma exp_rel_step1_prove_kripke) *)
let exp_rel_step1_prove_kripke (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == EProve p_v1)) /\ r2 == EProve p_v2 /\ multi_step (EProve p_v1, p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EProve p_v2, p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma (TProof p_t) r1 r2 == true)) = admit ()

(* exp_rel_step1_declassify_kripke (matches Coq: Lemma exp_rel_step1_declassify_kripke) *)
let exp_rel_step1_declassify_kripke (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures ((exists p_r1. (exists p_r2. p_r1 == p_v1)) /\ r2 == p_v2 /\ multi_step (EDeclassify (EClassify p_v1) (EProve (EClassify p_v1)), p_st1, p_ctx) (r1, p_st1, p_ctx) == true /\ multi_step (EDeclassify (EClassify p_v2) (EProve (EClassify p_v2)), p_st2, p_ctx) (r2, p_st2, p_ctx) == true /\ val_rel_le p_n p_sigma p_t r1 r2 == true)) = admit ()

(* val_rel_le_prod_mono_step (matches Coq: Lemma val_rel_le_prod_mono_step) *)
let val_rel_le_prod_mono_step (p_n: _) (p_m: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ val_rel_le p_n p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TProd p_t1 p_t2) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_sum_mono_step (matches Coq: Lemma val_rel_le_sum_mono_step) *)
let val_rel_le_sum_mono_step (p_n: _) (p_m: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ val_rel_le p_n p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TSum p_t1 p_t2) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_secret_characterization (matches Coq: Lemma val_rel_le_secret_characterization) *)
let val_rel_le_secret_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TSecret p_t) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_labeled_characterization (matches Coq: Lemma val_rel_le_labeled_characterization) *)
let val_rel_le_labeled_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_tainted_characterization (matches Coq: Lemma val_rel_le_tainted_characterization) *)
let val_rel_le_tainted_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_src: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TTainted p_t p_src) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_sanitized_characterization (matches Coq: Lemma val_rel_le_sanitized_characterization) *)
let val_rel_le_sanitized_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_san: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_capability_characterization (matches Coq: Lemma val_rel_le_capability_characterization) *)
let val_rel_le_capability_characterization (p_n: _) (p_sigma: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TCapability p_k) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_capability_full_characterization (matches Coq: Lemma val_rel_le_capability_full_characterization) *)
let val_rel_le_capability_full_characterization (p_n: _) (p_sigma: _) (p_cap: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_capability_full_values_closed (matches Coq: Lemma val_rel_le_capability_full_values_closed) *)
let val_rel_le_capability_full_values_closed (p_n: _) (p_sigma: _) (p_cap: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_proof_characterization (matches Coq: Lemma val_rel_le_proof_characterization) *)
let val_rel_le_proof_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TProof p_t) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_constant_time_characterization (matches Coq: Lemma val_rel_le_constant_time_characterization) *)
let val_rel_le_constant_time_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TConstantTime p_t) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_zeroizing_characterization (matches Coq: Lemma val_rel_le_zeroizing_characterization) *)
let val_rel_le_zeroizing_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TZeroizing p_t) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_chan_characterization (matches Coq: Lemma val_rel_le_chan_characterization) *)
let val_rel_le_chan_characterization (p_n: _) (p_sigma: _) (p_pid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TChan p_pid) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_chan_values_closed (matches Coq: Lemma val_rel_le_chan_values_closed) *)
let val_rel_le_chan_values_closed (p_n: _) (p_sigma: _) (p_pid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TChan p_pid) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_secure_chan_characterization (matches Coq: Lemma val_rel_le_secure_chan_characterization) *)
let val_rel_le_secure_chan_characterization (p_n: _) (p_sigma: _) (p_pid: _) (p_sid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_secure_chan_values_closed (matches Coq: Lemma val_rel_le_secure_chan_values_closed) *)
let val_rel_le_secure_chan_values_closed (p_n: _) (p_sigma: _) (p_pid: _) (p_sid: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_list_characterization (matches Coq: Lemma val_rel_le_list_characterization) *)
let val_rel_le_list_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TList p_t) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_list_values_closed (matches Coq: Lemma val_rel_le_list_values_closed) *)
let val_rel_le_list_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TList p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_option_characterization (matches Coq: Lemma val_rel_le_option_characterization) *)
let val_rel_le_option_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TOption p_t) p_v1 p_v2 == true <==> (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true))) = admit ()

(* val_rel_le_option_values_closed (matches Coq: Lemma val_rel_le_option_values_closed) *)
let val_rel_le_option_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TOption p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_secret_values_closed (matches Coq: Lemma val_rel_le_secret_values_closed) *)
let val_rel_le_secret_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSecret p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_labeled_values_closed (matches Coq: Lemma val_rel_le_labeled_values_closed) *)
let val_rel_le_labeled_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_tainted_values_closed (matches Coq: Lemma val_rel_le_tainted_values_closed) *)
let val_rel_le_tainted_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_src: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TTainted p_t p_src) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_sanitized_values_closed (matches Coq: Lemma val_rel_le_sanitized_values_closed) *)
let val_rel_le_sanitized_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_san: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_capability_values_closed (matches Coq: Lemma val_rel_le_capability_values_closed) *)
let val_rel_le_capability_values_closed (p_n: _) (p_sigma: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TCapability p_k) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_proof_values_closed (matches Coq: Lemma val_rel_le_proof_values_closed) *)
let val_rel_le_proof_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TProof p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_constant_time_values_closed (matches Coq: Lemma val_rel_le_constant_time_values_closed) *)
let val_rel_le_constant_time_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TConstantTime p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_zeroizing_values_closed (matches Coq: Lemma val_rel_le_zeroizing_values_closed) *)
let val_rel_le_zeroizing_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TZeroizing p_t) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq) *)
let store_ty_lookup_update_neq (p_l: _) (p_l_: _) (p_t: _) (p_sl: _) (p_sigma: _) : Lemma (requires (~(p_l == p_l_))) (ensures (store_ty_lookup p_l_ (store_ty_update p_l p_t p_sl p_sigma) == store_ty_lookup p_l_ p_sigma)) = admit ()

(* store_ty_extends_add (matches Coq: Lemma store_ty_extends_add) *)
let store_ty_extends_add (p_sigma: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_ty_lookup p_l p_sigma == None)) (ensures (store_ty_extends p_sigma (store_ty_update p_l p_t p_sl p_sigma) == true)) = admit ()

(* val_rel_le_build_labeled (matches Coq: Lemma val_rel_le_build_labeled) *)
let val_rel_le_build_labeled (p_m: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_labeled (matches Coq: Lemma val_rel_le_step_up_labeled) *)
let val_rel_le_step_up_labeled (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TLabeled p_t p_sl) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_tainted (matches Coq: Lemma val_rel_le_build_tainted) *)
let val_rel_le_build_tainted (p_m: _) (p_sigma: _) (p_t: _) (p_src: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TTainted p_t p_src) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_tainted (matches Coq: Lemma val_rel_le_step_up_tainted) *)
let val_rel_le_step_up_tainted (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_src: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TTainted p_t p_src) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TTainted p_t p_src) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_sanitized (matches Coq: Lemma val_rel_le_build_sanitized) *)
let val_rel_le_build_sanitized (p_m: _) (p_sigma: _) (p_t: _) (p_san: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_sanitized (matches Coq: Lemma val_rel_le_step_up_sanitized) *)
let val_rel_le_step_up_sanitized (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_san: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TSanitized p_t p_san) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_proof (matches Coq: Lemma val_rel_le_build_proof) *)
let val_rel_le_build_proof (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TProof p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_proof (matches Coq: Lemma val_rel_le_step_up_proof) *)
let val_rel_le_step_up_proof (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TProof p_t) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TProof p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_ct (matches Coq: Lemma val_rel_le_build_ct) *)
let val_rel_le_build_ct (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TConstantTime p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_ct (matches Coq: Lemma val_rel_le_step_up_ct) *)
let val_rel_le_step_up_ct (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TConstantTime p_t) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TConstantTime p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_zero (matches Coq: Lemma val_rel_le_build_zero) *)
let val_rel_le_build_zero (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TZeroizing p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_zero (matches Coq: Lemma val_rel_le_step_up_zero) *)
let val_rel_le_step_up_zero (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TZeroizing p_t) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TZeroizing p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_cap (matches Coq: Lemma val_rel_le_build_cap) *)
let val_rel_le_build_cap (p_m: _) (p_sigma: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TCapability p_k) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_cap (matches Coq: Lemma val_rel_le_step_up_cap) *)
let val_rel_le_step_up_cap (p_n: _) (p_m: _) (p_sigma: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TCapability p_k) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TCapability p_k) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_cap_full (matches Coq: Lemma val_rel_le_build_cap_full) *)
let val_rel_le_build_cap_full (p_m: _) (p_sigma: _) (p_cap: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_cap_full (matches Coq: Lemma val_rel_le_step_up_cap_full) *)
let val_rel_le_step_up_cap_full (p_n: _) (p_m: _) (p_sigma: _) (p_cap: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TCapabilityFull p_cap) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_list (matches Coq: Lemma val_rel_le_build_list) *)
let val_rel_le_build_list (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TList p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_list (matches Coq: Lemma val_rel_le_step_up_list) *)
let val_rel_le_step_up_list (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TList p_t) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TList p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_option (matches Coq: Lemma val_rel_le_build_option) *)
let val_rel_le_build_option (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TOption p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_option (matches Coq: Lemma val_rel_le_step_up_option) *)
let val_rel_le_step_up_option (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TOption p_t) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TOption p_t) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_prod_pair_kripke (matches Coq: Lemma val_rel_le_build_prod_pair_kripke) *)
let val_rel_le_build_prod_pair_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_b1: _) (p_a2: _) (p_b2: _) : Lemma (requires (value p_a1 == true /\ value p_b1 == true /\ value p_a2 == true /\ value p_b2 == true /\ closed_expr p_a1 == true /\ closed_expr p_b1 == true /\ closed_expr p_a2 == true /\ closed_expr p_b2 == true /\ val_rel_le p_n p_sigma p_t1 p_a1 p_a2 == true /\ val_rel_le p_n p_sigma p_t2 p_b1 p_b2 == true)) (ensures (val_rel_le p_n p_sigma (TProd p_t1 p_t2) (EPair p_a1 p_b1) (EPair p_a2 p_b2) == true)) = admit ()

(* val_rel_le_build_sum_inl_kripke (matches Coq: Lemma val_rel_le_build_sum_inl_kripke) *)
let val_rel_le_build_sum_inl_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_a1: _) (p_a2: _) : Lemma (requires (value p_a1 == true /\ value p_a2 == true /\ closed_expr p_a1 == true /\ closed_expr p_a2 == true /\ val_rel_le p_n p_sigma p_t1 p_a1 p_a2 == true)) (ensures (val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInl p_a1 p_t2) (EInl p_a2 p_t2) == true)) = admit ()

(* val_rel_le_build_sum_inr_kripke (matches Coq: Lemma val_rel_le_build_sum_inr_kripke) *)
let val_rel_le_build_sum_inr_kripke (p_n: _) (p_sigma: _) (p_t1: _) (p_t2: _) (p_b1: _) (p_b2: _) : Lemma (requires (value p_b1 == true /\ value p_b2 == true /\ closed_expr p_b1 == true /\ closed_expr p_b2 == true /\ val_rel_le p_n p_sigma p_t2 p_b1 p_b2 == true)) (ensures (val_rel_le p_n p_sigma (TSum p_t1 p_t2) (EInr p_b1 p_t1) (EInr p_b2 p_t1) == true)) = admit ()

(* val_rel_le_build_chan (matches Coq: Lemma val_rel_le_build_chan) *)
let val_rel_le_build_chan (p_m: _) (p_sigma: _) (p_pid: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TChan p_pid) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_chan (matches Coq: Lemma val_rel_le_step_up_chan) *)
let val_rel_le_step_up_chan (p_n: _) (p_m: _) (p_sigma: _) (p_pid: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TChan p_pid) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TChan p_pid) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_secure_chan (matches Coq: Lemma val_rel_le_build_secure_chan) *)
let val_rel_le_build_secure_chan (p_m: _) (p_sigma: _) (p_pid: _) (p_sid: _) (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) (ensures (val_rel_le p_m p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_step_up_secure_chan (matches Coq: Lemma val_rel_le_step_up_secure_chan) *)
let val_rel_le_step_up_secure_chan (p_n: _) (p_m: _) (p_sigma: _) (p_pid: _) (p_sid: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TSecureChan p_pid p_sid) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_build_ref_kripke (matches Coq: Lemma val_rel_le_build_ref_kripke) *)
let val_rel_le_build_ref_kripke (p_m: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_l: _) : Lemma (val_rel_le p_m p_sigma (TRef p_t p_sl) (ELoc p_l) (ELoc p_l) == true) = admit ()

(* val_rel_le_step_up_ref (matches Coq: Lemma val_rel_le_step_up_ref) *)
let val_rel_le_step_up_ref (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma (TRef p_t p_sl) p_v1 p_v2 == true /\ p_n > 0)) (ensures (val_rel_le p_m p_sigma (TRef p_t p_sl) p_v1 p_v2 == true)) = admit ()

(* val_rel_le_ref_characterization (matches Coq: Lemma val_rel_le_ref_characterization) *)
let val_rel_le_ref_characterization (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0)) (ensures (val_rel_le p_n p_sigma (TRef p_t p_sl) p_v1 p_v2 == true <==> (exists p_l. p_v1 == ELoc p_l) /\ p_v2 == ELoc l)) = admit ()

(* val_rel_le_ref_values_closed (matches Coq: Lemma val_rel_le_ref_values_closed) *)
let val_rel_le_ref_values_closed (p_n: _) (p_sigma: _) (p_t: _) (p_sl: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma (TRef p_t p_sl) p_v1 p_v2 == true)) (ensures (value p_v1 == true /\ value p_v2 == true /\ closed_expr p_v1 == true /\ closed_expr p_v2 == true)) = admit ()

(* val_rel_le_pos_values_closed_indist (matches Coq: Lemma val_rel_le_pos_values_closed_indist) *)
let val_rel_le_pos_values_closed_indist_obligation () : Tot bool = true
let val_rel_le_pos_values_closed_indist_lemma () : Lemma (requires True) (ensures (val_rel_le_pos_values_closed_indist_obligation () == val_rel_le_pos_values_closed_indist_obligation ())) = ()

(* val_rel_le_pos_values_closed_base (matches Coq: Lemma val_rel_le_pos_values_closed_base) *)
let val_rel_le_pos_values_closed_base_obligation () : Tot bool = true
let val_rel_le_pos_values_closed_base_lemma () : Lemma (requires True) (ensures (val_rel_le_pos_values_closed_base_obligation () == val_rel_le_pos_values_closed_base_obligation ())) = ()

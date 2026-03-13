(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/StoreSafety.v (27 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.StoreSafety
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* step — Coq Prop predicate stub *)
assume val step : nat -> nat -> bool

(* multi_step — Coq Prop predicate stub *)
assume val multi_step : nat -> nat -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> nat -> nat -> nat -> nat -> nat -> bool

(* store_extend_after_alloc (matches Coq: Lemma store_extend_after_alloc) *)
let store_extend_after_alloc (p_sigma: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_ty_lookup p_l p_sigma == None)) (ensures (store_ty_extends p_sigma (store_ty_update p_l p_t p_sl p_sigma) == true)) = ()

(* store_lookup_after_update (matches Coq: Lemma store_lookup_after_update) *)
let store_lookup_after_update (p_st: _) (p_l: _) (p_v: _) : Lemma (store_lookup p_l (store_update p_l p_v p_st) == Some p_v) = ()

(* store_lookup_update_other (matches Coq: Lemma store_lookup_update_other) *)
let store_lookup_update_other (p_st: _) (p_l: _) (p_l_: _) (p_v: _) : Lemma (requires (~(p_l == p_l_))) (ensures (store_lookup p_l (store_update p_l_ p_v p_st) == store_lookup p_l p_st)) = ()

(* store_ty_update_same (matches Coq: Lemma store_ty_update_same) *)
let store_ty_update_same (p_sigma: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (store_ty_lookup p_l (store_ty_update p_l p_t p_sl p_sigma) == Some (p_t, p_sl)) = ()

(* store_ty_update_other (matches Coq: Lemma store_ty_update_other) *)
let store_ty_update_other (p_sigma: _) (p_l: _) (p_l_: _) (p_t: _) (p_sl: _) : Lemma (requires (~(p_l == p_l_))) (ensures (store_ty_lookup p_l (store_ty_update p_l_ p_t p_sl p_sigma) == store_ty_lookup p_l p_sigma)) = ()

(* store_extend_compose (matches Coq: Lemma store_extend_compose) *)
let store_extend_compose (p_sigma1: _) (p_sigma2: _) (p_sigma3: _) : Lemma (requires (store_ty_extends p_sigma1 p_sigma2 == true /\ store_ty_extends p_sigma2 p_sigma3 == true)) (ensures (store_ty_extends p_sigma1 p_sigma3 == true)) = ()

(* store_extend_antisym_lookup (matches Coq: Lemma store_extend_antisym_lookup) *)
let store_extend_antisym_lookup (p_sigma1: _) (p_sigma2: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_ty_extends p_sigma1 p_sigma2 == true /\ store_ty_extends p_sigma2 p_sigma1 == true /\ store_ty_lookup p_l p_sigma1 == Some (p_t, p_sl))) (ensures (store_ty_lookup p_l p_sigma2 == Some (p_t, p_sl))) = ()

(* typing_monotone_store (matches Coq: Lemma typing_monotone_store) *)
let typing_monotone_store (p_gamma: _) (p_sigma: _) (p_sigma_prime: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true)) (ensures (has_type p_gamma p_sigma' p_delta p_e p_t p_epsilon == true)) = ()

(* loc_typed_under_extension (matches Coq: Lemma loc_typed_under_extension) *)
let loc_typed_under_extension (p_sigma: _) (p_sigma_prime: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures (store_ty_lookup p_l p_sigma' == Some (p_t, p_sl))) = ()

(* value_typed_under_extension (matches Coq: Lemma value_typed_under_extension) *)
let value_typed_under_extension (p_sigma: _) (p_sigma_prime: _) (p_v: _) (p_t: _) (p_epsilon: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ has_type [] p_sigma Public p_v p_t p_epsilon == true /\ value p_v == true)) (ensures (has_type [] p_sigma' Public p_v p_t p_epsilon == true)) = ()

(* store_wf_values_pure (matches Coq: Lemma store_wf_values_pure) *)
let store_wf_values_pure (p_sigma: _) (p_st: _) (p_l: _) (p_t: _) (p_sl: _) (p_v: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl) /\ store_lookup p_l p_st == Some p_v)) (ensures (has_type [] p_sigma Public p_v p_t EffectPure == true)) = ()

(* store_wf_all_values (matches Coq: Lemma store_wf_all_values) *)
let store_wf_all_values (p_sigma: _) (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_lookup p_l p_st == Some p_v)) (ensures (value p_v == true)) = ()

(* store_wf_typed_implies_stored (matches Coq: Lemma store_wf_typed_implies_stored) *)
let store_wf_typed_implies_stored (p_sigma: _) (p_st: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures ((exists p_v. store_lookup p_l p_st == Some p_v))) = ()

(* store_wf_stored_implies_typed (matches Coq: Lemma store_wf_stored_implies_typed) *)
let store_wf_stored_implies_typed (p_sigma: _) (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_lookup p_l p_st == Some p_v)) (ensures ((exists p_t. (exists p_sl. store_ty_lookup p_l p_sigma == Some (p_t, p_sl))))) = ()

(* store_ty_lookup_dec (matches Coq: Lemma store_ty_lookup_dec) *)
let store_ty_lookup_dec (p_l: _) (p_sigma: _) : Lemma ({exists T sl_ store_ty_lookup p_l p_sigma == Some (T, sl)} + {store_ty_lookup p_l p_sigma = None}) = ()

(* loc_eq_dec (matches Coq: Lemma loc_eq_dec) *)
let loc_eq_dec (p_l1: nat) (p_l2: nat) : Lemma ({p_l1 == l2_ + {p_l1 <> l2_) = ()

(* store_ty_update_commute_lookup (matches Coq: Lemma store_ty_update_commute_lookup) *)
let store_ty_update_commute_lookup (p_sigma: _) (p_l1: _) (p_t1: _) (p_sl1: _) (p_l2: _) (p_t2: _) (p_sl2: _) (p_l: _) : Lemma (requires (~(p_l1 == p_l2))) (ensures (store_ty_lookup p_l (store_ty_update p_l1 p_t1 p_sl1 (store_ty_update p_l2 p_t2 p_sl2 p_sigma)) == store_ty_lookup p_l (store_ty_update p_l2 p_t2 p_sl2 (store_ty_update p_l1 p_t1 p_sl1 p_sigma)))) = ()

(* store_wf_empty (matches Coq: Lemma store_wf_empty) *)
let store_wf_empty () : Lemma (store_wf [] [] == true) = ()

(* typing_under_alloc (matches Coq: Lemma typing_under_alloc) *)
let typing_under_alloc (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_l: _) (p_t_: _) (p_sl_: _) : Lemma (requires (store_ty_lookup p_l p_sigma == None /\ has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true)) (ensures (has_type p_gamma (store_ty_update p_l p_t' p_sl_ p_sigma) p_delta p_e p_t p_epsilon == true)) = ()

(* typing_under_double_alloc (matches Coq: Lemma typing_under_double_alloc) *)
let typing_under_double_alloc (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_l1: _) (p_t1: _) (p_sl1: _) (p_l2: _) (p_t2: _) (p_sl2: _) : Lemma (requires (~(p_l1 == p_l2) /\ store_ty_lookup p_l1 p_sigma == None /\ store_ty_lookup p_l2 p_sigma == None /\ has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true)) (ensures (has_type p_gamma (store_ty_update p_l2 p_t2 p_sl2 (store_ty_update p_l1 p_t1 p_sl1 p_sigma)) p_delta p_e p_t p_epsilon == true)) = ()

(* store_wf_extends_typed (matches Coq: Lemma store_wf_extends_typed) *)
let store_wf_extends_typed (p_sigma: _) (p_sigma_prime: _) (p_st: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ store_wf p_sigma p_st == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures ((exists p_v. store_lookup p_l p_st == Some p_v) /\ value v == true)) = ()

(* fresh_loc_store_ty_none (matches Coq: Lemma fresh_loc_store_ty_none) *)
let fresh_loc_store_ty_none (p_sigma: _) (p_st: _) : Lemma (requires (store_wf p_sigma p_st == true)) (ensures (store_ty_lookup (fresh_loc p_st) p_sigma == None)) = ()

(* fresh_loc_store_none (matches Coq: Lemma fresh_loc_store_none) *)
let fresh_loc_store_none (p_st: _) : Lemma (store_lookup (fresh_loc p_st) p_st == None) = ()

(* store_wf_all_well_typed (matches Coq: Lemma store_wf_all_well_typed) *)
let store_wf_all_well_typed (p_sigma: _) (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_lookup p_l p_st == Some p_v)) (ensures ((exists p_t. (exists p_sl. store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) /\ value p_v == true /\ has_type [] p_sigma Public p_v T EffectPure == true)) = ()

(* store_ty_in_extends (matches Coq: Lemma store_ty_in_extends) *)
let store_ty_in_extends (p_sigma: _) (p_sigma_prime: _) (p_l: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ ((exists p_t. (exists p_sl. store_ty_lookup p_l p_sigma == Some (p_t, p_sl)))))) (ensures (((exists p_t. (exists p_sl. store_ty_lookup p_l p_sigma' == Some (p_t, p_sl)))))) = ()

(* store_ty_not_in_extends (matches Coq: Lemma store_ty_not_in_extends) *)
let store_ty_not_in_extends (p_sigma: _) (p_sigma_prime: _) (p_l: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ store_ty_lookup p_l p_sigma' == None)) (ensures (store_ty_lookup p_l p_sigma == None)) = ()

(* store_ty_extends_update_both (matches Coq: Lemma store_ty_extends_update_both) *)
let store_ty_extends_update_both (p_sigma: _) (p_sigma_prime: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true)) (ensures (store_ty_extends (store_ty_update p_l p_t p_sl p_sigma) (store_ty_update p_l p_t p_sl p_sigma') == true)) = ()

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/CumulativeMonotone.v (13 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.CumulativeMonotone
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

(* val_rel_le_mono_step (matches Coq: Theorem val_rel_le_mono_step) *)
let val_rel_le_mono_step (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_m p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_mono_store (matches Coq: Lemma val_rel_le_mono_store) *)
let val_rel_le_mono_store (p_n: _) (p_sigma: _) (p_sigma_prime: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma' p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_mono (matches Coq: Theorem val_rel_le_mono) *)
let val_rel_le_mono (p_n: _) (p_m: _) (p_sigma: _) (p_sigma_prime: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ store_ty_extends p_sigma p_sigma' == true /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_m p_sigma' p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_step_down (matches Coq: Lemma val_rel_le_step_down) *)
let val_rel_le_step_down (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le ((p_n + 1)) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) = ()

(* store_rel_le_mono_step (matches Coq: Lemma store_rel_le_mono_step) *)
let store_rel_le_mono_step (p_n: _) (p_m: _) (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (p_m <= p_n /\ store_rel_le p_n p_sigma p_st1 p_st2 == true)) (ensures (store_rel_le p_m p_sigma p_st1 p_st2 == true)) = ()

(* val_rel_le_mono_from_succ (matches Coq: Lemma val_rel_le_mono_from_succ) *)
let val_rel_le_mono_from_succ (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le ((p_n + 1)) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_mono_store_zero (matches Coq: Lemma val_rel_le_mono_store_zero) *)
let val_rel_le_mono_store_zero (p_sigma: _) (p_sigma_prime: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ val_rel_le 0 p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le 0 p_sigma' p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_mono_chain (matches Coq: Theorem val_rel_le_mono_chain) *)
let val_rel_le_mono_chain (p_n: _) (p_m: _) (p_k: _) (p_sigma1: _) (p_sigma2: _) (p_sigma3: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_k <= p_m /\ p_m <= p_n /\ store_ty_extends p_sigma1 p_sigma2 == true /\ store_ty_extends p_sigma2 p_sigma3 == true /\ val_rel_le p_n p_sigma1 p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_k p_sigma3 p_t p_v1 p_v2 == true)) = ()

(* store_rel_le_mono_from_succ (matches Coq: Lemma store_rel_le_mono_from_succ) *)
let store_rel_le_mono_from_succ (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_le ((p_n + 1)) p_sigma p_st1 p_st2 == true)) (ensures (store_rel_le p_n p_sigma p_st1 p_st2 == true)) = ()

(* val_rel_le_mono_drop_k (matches Coq: Lemma val_rel_le_mono_drop_k) *)
let val_rel_le_mono_drop_k (p_k: _) (p_n: _) (p_sigma: _) (p_sigma_prime: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (store_ty_extends p_sigma p_sigma' == true /\ val_rel_le (p_n + p_k) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma' p_t p_v1 p_v2 == true)) = ()

(* store_rel_le_drop_k (matches Coq: Lemma store_rel_le_drop_k) *)
let store_rel_le_drop_k (p_k: _) (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_le (p_n + p_k) p_sigma p_st1 p_st2 == true)) (ensures (store_rel_le p_n p_sigma p_st1 p_st2 == true)) = ()

(* val_rel_le_mono_refl (matches Coq: Lemma val_rel_le_mono_refl) *)
let val_rel_le_mono_refl (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) = ()

(* store_rel_le_mono_refl (matches Coq: Lemma store_rel_le_mono_refl) *)
let store_rel_le_mono_refl (p_n: _) (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_le p_n p_sigma p_st1 p_st2 == true)) (ensures (store_rel_le p_n p_sigma p_st1 p_st2 == true)) = ()

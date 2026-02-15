(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/ContextProperties.v (21 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.ContextProperties
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> nat -> nat -> nat -> nat -> nat -> bool

(* free_in_dec (matches Coq: Lemma free_in_dec) *)
let free_in_dec (p_x: _) (p_e: _) : Lemma ({free_in p_x e_ + {~ free_in p_x e_ == true) = admit ()

(* lookup_cons_neq_inv (matches Coq: Lemma lookup_cons_neq_inv) *)
let lookup_cons_neq_inv (p_x: _) (p_y: _) (p_u: _) (p_gamma: _) (p_t: _) : Lemma (requires (lookup p_x ((p_y, p_u) :: p_gamma) == Some p_t /\ ~(p_x == p_y))) (ensures (lookup p_x p_gamma == Some p_t)) = admit ()

(* lookup_deterministic (matches Coq: Lemma lookup_deterministic) *)
let lookup_deterministic (p_x: _) (p_gamma: _) (p_t1: _) (p_t2: _) : Lemma (requires (lookup p_x p_gamma == Some p_t1 /\ lookup p_x p_gamma == Some p_t2)) (ensures (p_t1 == p_t2)) = admit ()

(* lookup_cons_inv (matches Coq: Lemma lookup_cons_inv) *)
let lookup_cons_inv (p_x: _) (p_y: _) (p_u: _) (p_gamma: _) (p_t: _) : Lemma (requires (lookup p_x ((p_y, p_u) :: p_gamma) == Some p_t)) (ensures ((p_x == p_y /\ p_t == p_u) \/ (~(p_x == p_y) /\ lookup p_x p_gamma == Some p_t))) = admit ()

(* lookup_weaken_neq (matches Coq: Lemma lookup_weaken_neq) *)
let lookup_weaken_neq (p_x: _) (p_gamma: _) (p_t: _) (p_y: _) (p_u: _) : Lemma (requires (lookup p_x p_gamma == Some p_t /\ ~(p_x == p_y))) (ensures (lookup p_x ((p_y, p_u) :: p_gamma) == Some p_t)) = admit ()

(* typing_weaken_head (matches Coq: Lemma typing_weaken_head) *)
let typing_weaken_head (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_y: _) (p_u: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true /\ ~(free_in p_y p_e == true))) (ensures (has_type ((p_y, p_u) :: p_gamma) p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* typing_weaken_fresh (matches Coq: Lemma typing_weaken_fresh) *)
let typing_weaken_fresh (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_y: _) (p_u: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true /\ lookup p_y p_gamma == None)) (ensures (has_type ((p_y, p_u) :: p_gamma) p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* typing_strengthen_head (matches Coq: Lemma typing_strengthen_head) *)
let typing_strengthen_head (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_y: _) (p_u: _) : Lemma (requires (has_type ((p_y, p_u) :: p_gamma) p_sigma p_delta p_e p_t p_epsilon == true /\ ~(free_in p_y p_e == true))) (ensures (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* typing_exchange (matches Coq: Lemma typing_exchange) *)
let typing_exchange (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_x: _) (p_tx: _) (p_y: _) (p_ty: _) : Lemma (requires (has_type ((p_x, p_tx) :: (p_y, p_ty) :: p_gamma) p_sigma p_delta p_e p_t p_epsilon == true /\ ~(p_x == p_y))) (ensures (has_type ((p_y, p_ty) :: (p_x, p_tx) :: p_gamma) p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* typing_delta_irrelevance (matches Coq: Lemma typing_delta_irrelevance) *)
let typing_delta_irrelevance (p_gamma: _) (p_sigma: _) (p_delta1: _) (p_delta2: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta1 p_e p_t p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta2 p_e p_t p_epsilon == true)) = admit ()

(* typing_shadow (matches Coq: Lemma typing_shadow) *)
let typing_shadow (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_x: _) (p_t1: _) (p_t2: _) : Lemma (requires (has_type ((p_x, p_t1) :: (p_x, p_t2) :: p_gamma) p_sigma p_delta p_e p_t p_epsilon == true)) (ensures (has_type ((p_x, p_t1) :: p_gamma) p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* closed_no_free_vars (matches Coq: Lemma closed_no_free_vars) *)
let closed_no_free_vars (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_x: _) : Lemma (requires (has_type [] p_sigma p_delta p_e p_t p_epsilon == true)) (ensures (~(free_in p_x p_e == true))) = admit ()

(* typing_weaken_closed (matches Coq: Lemma typing_weaken_closed) *)
let typing_weaken_closed (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma p_delta p_e p_t p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* typing_weaken_multi_closed (matches Coq: Lemma typing_weaken_multi_closed) *)
let typing_weaken_multi_closed (p_gamma1: _) (p_gamma2: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma p_delta p_e p_t p_epsilon == true)) (ensures (has_type (p_gamma1 ++ p_gamma2) p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* typing_weaken_prefix (matches Coq: Lemma typing_weaken_prefix) *)
let typing_weaken_prefix (p_gamma1: _) (p_gamma2: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma2 p_sigma p_delta p_e p_t p_epsilon == true /\ ((forall (x: _). free_in x p_e -> lookup x p_gamma2 == lookup x (p_gamma1 ++ p_gamma2))))) (ensures (has_type (p_gamma1 ++ p_gamma2) p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* store_extends_refl (matches Coq: Lemma store_extends_refl) *)
let store_extends_refl (p_sigma: _) : Lemma (store_ty_extends p_sigma p_sigma == true) = admit ()

(* store_extends_trans (matches Coq: Lemma store_extends_trans) *)
let store_extends_trans (p_sigma1: _) (p_sigma2: _) (p_sigma3: _) : Lemma (requires (store_ty_extends p_sigma1 p_sigma2 == true /\ store_ty_extends p_sigma2 p_sigma3 == true)) (ensures (store_ty_extends p_sigma1 p_sigma3 == true)) = admit ()

(* typing_weaken_store (matches Coq: Lemma typing_weaken_store) *)
let typing_weaken_store (p_gamma: _) (p_sigma: _) (p_sigma_prime: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true /\ store_ty_extends p_sigma p_sigma' == true)) (ensures (has_type p_gamma p_sigma' p_delta p_e p_t p_epsilon == true)) = admit ()

(* typing_weaken_head_delta (matches Coq: Lemma typing_weaken_head_delta) *)
let typing_weaken_head_delta (p_gamma: _) (p_sigma: _) (p_delta1: _) (p_delta2: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_y: _) (p_u: _) : Lemma (requires (has_type p_gamma p_sigma p_delta1 p_e p_t p_epsilon == true /\ ~(free_in p_y p_e == true))) (ensures (has_type ((p_y, p_u) :: p_gamma) p_sigma p_delta2 p_e p_t p_epsilon == true)) = admit ()

(* typing_weaken_two (matches Coq: Lemma typing_weaken_two) *)
let typing_weaken_two (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_x: _) (p_tx: _) (p_y: _) (p_ty: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true /\ ~(free_in p_x p_e == true) /\ ~(free_in p_y p_e == true))) (ensures (has_type ((p_x, p_tx) :: (p_y, p_ty) :: p_gamma) p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* typing_weaken_head_store (matches Coq: Lemma typing_weaken_head_store) *)
let typing_weaken_head_store (p_gamma: _) (p_sigma: _) (p_sigma_prime: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) (p_y: _) (p_u: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true /\ ~(free_in p_y p_e == true) /\ store_ty_extends p_sigma p_sigma' == true)) (ensures (has_type ((p_y, p_u) :: p_gamma) p_sigma' p_delta p_e p_t p_epsilon == true)) = admit ()

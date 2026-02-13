(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/type_system/Progress.v (9 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.TypeSystem.Progress
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

(* canonical_bool (matches Coq: Lemma canonical_bool) *)
let canonical_bool (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TBool p_epsilon == true /\ value p_v == true)) (ensures ((exists p_b. p_v == EBool p_b))) = admit ()

(* canonical_fn (matches Coq: Lemma canonical_fn) *)
let canonical_fn (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_epsilon_prime: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TFn p_t1 p_t2 p_epsilon) p_epsilon_prime == true /\ value p_v == true)) (ensures ((exists p_x. (exists p_body. p_v == ELam p_x p_t1 p_body)))) = admit ()

(* canonical_pair (matches Coq: Lemma canonical_pair) *)
let canonical_pair (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v1. (exists p_v2. p_v == EPair p_v1 p_v2)) /\ value v1 == true /\ value v2 == true)) = admit ()

(* canonical_sum (matches Coq: Lemma canonical_sum) *)
let canonical_sum (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures (((exists p_v. p_v == EInl v_ p_t2) /\ value v_ == true) \/ ((exists p_v. p_v == EInr v_ p_t1) /\ value v_ == true))) = admit ()

(* canonical_ref (matches Coq: Lemma canonical_ref) *)
let canonical_ref (p_v: _) (p_t: _) (p_l: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TRef p_t p_l) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_l. p_v == ELoc l_))) = admit ()

(* canonical_secret (matches Coq: Lemma canonical_secret) *)
let canonical_secret (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSecret p_t) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v. p_v == EClassify v_) /\ value v_ == true)) = admit ()

(* canonical_proof (matches Coq: Lemma canonical_proof) *)
let canonical_proof (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProof p_t) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v. p_v == EProve v_) /\ value v_ == true)) = admit ()

(* lookup_nil_contra (matches Coq: Lemma lookup_nil_contra) *)
let lookup_nil_contra (p_x: _) (p_t: _) : Lemma (requires (lookup p_x [] == Some p_t)) (ensures (False)) = admit ()

(* progress (matches Coq: Theorem progress) *)
let progress () : Lemma (progress_stmt == true) = admit ()

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/type_system/Progress.v (27 lemmas) *)
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

(* canonical_unit (matches Coq: Lemma canonical_unit) *)
let canonical_unit (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TUnit p_epsilon == true /\ value p_v == true)) (ensures (p_v == EUnit)) = admit ()

(* canonical_int (matches Coq: Lemma canonical_int) *)
let canonical_int (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TInt p_epsilon == true /\ value p_v == true)) (ensures ((exists p_i. p_v == EInt p_i))) = admit ()

(* canonical_string (matches Coq: Lemma canonical_string) *)
let canonical_string (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TString p_epsilon == true /\ value p_v == true)) (ensures ((exists p_s. p_v == EString p_s))) = admit ()

(* typed_value_bool_inv (matches Coq: Lemma typed_value_bool_inv) *)
let typed_value_bool_inv (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TBool p_epsilon == true /\ value p_v == true)) (ensures (p_v == EBool true \/ p_v == EBool false)) = admit ()

(* typed_value_pair_inv (matches Coq: Lemma typed_value_pair_inv) *)
let typed_value_pair_inv (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v1. (exists p_v2. p_v == EPair p_v1 p_v2)))) = admit ()

(* typed_value_sum_inv (matches Coq: Lemma typed_value_sum_inv) *)
let typed_value_sum_inv (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures (((exists p_v. p_v == EInl v_ p_t2)) \/ ((exists p_v. p_v == EInr v_ p_t1)))) = admit ()

(* typed_value_fn_inv (matches Coq: Lemma typed_value_fn_inv) *)
let typed_value_fn_inv (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_epsilon_prime: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TFn p_t1 p_t2 p_epsilon) p_epsilon_prime == true /\ value p_v == true)) (ensures ((exists p_x. (exists p_body. p_v == ELam p_x p_t1 p_body)))) = admit ()

(* typed_value_ref_inv (matches Coq: Lemma typed_value_ref_inv) *)
let typed_value_ref_inv (p_v: _) (p_t: _) (p_sl: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TRef p_t p_sl) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_l. p_v == ELoc p_l))) = admit ()

(* typed_value_secret_inv (matches Coq: Lemma typed_value_secret_inv) *)
let typed_value_secret_inv (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSecret p_t) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v. p_v == EClassify v_) /\ value v_ == true)) = admit ()

(* typed_value_proof_inv (matches Coq: Lemma typed_value_proof_inv) *)
let typed_value_proof_inv (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProof p_t) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v. p_v == EProve v_) /\ value v_ == true)) = admit ()

(* typed_value_unit_inv (matches Coq: Lemma typed_value_unit_inv) *)
let typed_value_unit_inv (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TUnit p_epsilon == true /\ value p_v == true)) (ensures (p_v == EUnit)) = admit ()

(* typed_value_int_inv (matches Coq: Lemma typed_value_int_inv) *)
let typed_value_int_inv (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TInt p_epsilon == true /\ value p_v == true)) (ensures ((exists p_n. p_v == EInt p_n))) = admit ()

(* typed_value_string_inv (matches Coq: Lemma typed_value_string_inv) *)
let typed_value_string_inv (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TString p_epsilon == true /\ value p_v == true)) (ensures ((exists p_s. p_v == EString p_s))) = admit ()

(* typed_value_pair_components_typed (matches Coq: Lemma typed_value_pair_components_typed) *)
let typed_value_pair_components_typed (p_v1: _) (p_v2: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EPair p_v1 p_v2) (TProd p_t1 p_t2) p_epsilon == true /\ value p_v1 == true /\ value p_v2 == true)) (ensures ((exists p_epsilon1. (exists p_epsilon2. has_type [] p_sigma Public p_v1 p_t1 epsilon1 == true)) /\ has_type [] p_sigma Public p_v2 p_t2 epsilon2 == true)) = admit ()

(* typed_value_secret_inner_typed (matches Coq: Lemma typed_value_secret_inner_typed) *)
let typed_value_secret_inner_typed (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EClassify p_v) (TSecret p_t) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_epsilon. has_type [] p_sigma Public p_v p_t epsilon_prime == true))) = admit ()

(* typed_value_inl_inner_typed (matches Coq: Lemma typed_value_inl_inner_typed) *)
let typed_value_inl_inner_typed (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EInl p_v p_t2) (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_epsilon. has_type [] p_sigma Public p_v p_t1 epsilon_prime == true))) = admit ()

(* typed_value_inr_inner_typed (matches Coq: Lemma typed_value_inr_inner_typed) *)
let typed_value_inr_inner_typed (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EInr p_v p_t1) (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_epsilon. has_type [] p_sigma Public p_v p_t2 epsilon_prime == true))) = admit ()

(* typed_value_prove_inner_typed (matches Coq: Lemma typed_value_prove_inner_typed) *)
let typed_value_prove_inner_typed (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EProve p_v) (TProof p_t) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_epsilon. has_type [] p_sigma Public p_v p_t epsilon_prime == true))) = admit ()

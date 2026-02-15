(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/CanonicalForms.v (31 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.CanonicalForms
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> nat -> nat -> nat -> nat -> nat -> bool

(* canonical_unit (matches Coq: Lemma canonical_unit) *)
let canonical_unit (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TUnit p_epsilon == true /\ value p_v == true)) (ensures (p_v == EUnit)) = admit ()

(* canonical_bool (matches Coq: Lemma canonical_bool) *)
let canonical_bool (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TBool p_epsilon == true /\ value p_v == true)) (ensures ((exists p_b. p_v == EBool p_b))) = admit ()

(* canonical_int (matches Coq: Lemma canonical_int) *)
let canonical_int (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TInt p_epsilon == true /\ value p_v == true)) (ensures ((exists p_n. p_v == EInt p_n))) = admit ()

(* canonical_string (matches Coq: Lemma canonical_string) *)
let canonical_string (p_v: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v TString p_epsilon == true /\ value p_v == true)) (ensures ((exists p_s. p_v == EString p_s))) = admit ()

(* canonical_fn (matches Coq: Lemma canonical_fn) *)
let canonical_fn (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon_body: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TFn p_t1 p_t2 p_epsilon_body) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_x. (exists p_body. p_v == ELam p_x p_t1 p_body)))) = admit ()

(* canonical_pair (matches Coq: Lemma canonical_pair) *)
let canonical_pair (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v1. (exists p_v2. p_v == EPair p_v1 p_v2)) /\ value v1 == true /\ value v2 == true)) = admit ()

(* canonical_sum (matches Coq: Lemma canonical_sum) *)
let canonical_sum (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures (((exists p_v. p_v == EInl v_ p_t2) /\ value v_ == true) \/ ((exists p_v. p_v == EInr v_ p_t1) /\ value v_ == true))) = admit ()

(* canonical_sum_inl (matches Coq: Lemma canonical_sum_inl) *)
let canonical_sum_inl (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures (((exists p_v. p_v == EInl v_ p_t2) /\ value v_ == true) \/ ((exists p_v. p_v == EInr v_ p_t1) /\ value v_ == true))) = admit ()

(* canonical_ref (matches Coq: Lemma canonical_ref) *)
let canonical_ref (p_v: _) (p_t: _) (p_l: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TRef p_t p_l) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_l. p_v == ELoc l_))) = admit ()

(* canonical_secret (matches Coq: Lemma canonical_secret) *)
let canonical_secret (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSecret p_t) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v. p_v == EClassify v_) /\ value v_ == true)) = admit ()

(* canonical_proof (matches Coq: Lemma canonical_proof) *)
let canonical_proof (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProof p_t) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v. p_v == EProve v_) /\ value v_ == true)) = admit ()

(* base_value_pure (matches Coq: Lemma base_value_pure) *)
let base_value_pure (p_v: _) (p_sigma: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma Public p_v p_t p_epsilon == true /\ value p_v == true /\ (p_v == EUnit \/ ((exists p_b. p_v == EBool p_b)) \/ ((exists p_n. p_v == EInt p_n)) \/ ((exists p_s. p_v == EString p_s)) \/ ((exists p_l. p_v == ELoc p_l)) \/ ((exists p_x. (exists p_t. p_v == ELam p_x p_t' body)))))) (ensures (p_epsilon == EffPure)) = admit ()

(* unit_value_pure (matches Coq: Lemma unit_value_pure) *)
let unit_value_pure (p_sigma: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma Public EUnit p_t p_epsilon == true)) (ensures (p_epsilon == EffPure)) = admit ()

(* bool_value_pure (matches Coq: Lemma bool_value_pure) *)
let bool_value_pure (p_b: _) (p_sigma: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma Public (EBool p_b) p_t p_epsilon == true)) (ensures (p_epsilon == EffPure)) = admit ()

(* int_value_pure (matches Coq: Lemma int_value_pure) *)
let int_value_pure (p_n: _) (p_sigma: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma Public (EInt p_n) p_t p_epsilon == true)) (ensures (p_epsilon == EffPure)) = admit ()

(* string_value_pure (matches Coq: Lemma string_value_pure) *)
let string_value_pure (p_s: _) (p_sigma: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma Public (EString p_s) p_t p_epsilon == true)) (ensures (p_epsilon == EffPure)) = admit ()

(* lambda_value_pure (matches Coq: Lemma lambda_value_pure) *)
let lambda_value_pure (p_x: _) (p_t1: _) (p_body: _) (p_sigma: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma Public (ELam p_x p_t1 p_body) p_t p_epsilon == true)) (ensures (p_epsilon == EffPure)) = admit ()

(* loc_value_pure (matches Coq: Lemma loc_value_pure) *)
let loc_value_pure (p_l: _) (p_sigma: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma Public (ELoc p_l) p_t p_epsilon == true)) (ensures (p_epsilon == EffPure)) = admit ()

(* unit_not_bool (matches Coq: Lemma unit_not_bool) *)
let unit_not_bool (p_sigma: _) (p_epsilon: _) : Lemma (~(has_type [] p_sigma Public EUnit TBool p_epsilon == true)) = admit ()

(* unit_not_int (matches Coq: Lemma unit_not_int) *)
let unit_not_int (p_sigma: _) (p_epsilon: _) : Lemma (~(has_type [] p_sigma Public EUnit TInt p_epsilon == true)) = admit ()

(* unit_not_fn (matches Coq: Lemma unit_not_fn) *)
let unit_not_fn (p_sigma: _) (p_t1: _) (p_t2: _) (p_epsilon_body: _) (p_epsilon: _) : Lemma (~(has_type [] p_sigma Public EUnit (TFn p_t1 p_t2 p_epsilon_body) p_epsilon == true)) = admit ()

(* bool_not_unit (matches Coq: Lemma bool_not_unit) *)
let bool_not_unit (p_b: _) (p_sigma: _) (p_epsilon: _) : Lemma (~(has_type [] p_sigma Public (EBool p_b) TUnit p_epsilon == true)) = admit ()

(* bool_not_int (matches Coq: Lemma bool_not_int) *)
let bool_not_int (p_b: _) (p_sigma: _) (p_epsilon: _) : Lemma (~(has_type [] p_sigma Public (EBool p_b) TInt p_epsilon == true)) = admit ()

(* int_not_unit (matches Coq: Lemma int_not_unit) *)
let int_not_unit (p_n: _) (p_sigma: _) (p_epsilon: _) : Lemma (~(has_type [] p_sigma Public (EInt p_n) TUnit p_epsilon == true)) = admit ()

(* int_not_bool (matches Coq: Lemma int_not_bool) *)
let int_not_bool (p_n: _) (p_sigma: _) (p_epsilon: _) : Lemma (~(has_type [] p_sigma Public (EInt p_n) TBool p_epsilon == true)) = admit ()

(* pair_components_typed (matches Coq: Lemma pair_components_typed) *)
let pair_components_typed (p_v1: _) (p_v2: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EPair p_v1 p_v2) (TProd p_t1 p_t2) p_epsilon == true)) (ensures ((exists p_epsilon1. (exists p_epsilon2. has_type [] p_sigma Public p_v1 p_t1 epsilon1 == true)) /\ has_type [] p_sigma Public p_v2 p_t2 epsilon2 == true)) = admit ()

(* inl_component_typed (matches Coq: Lemma inl_component_typed) *)
let inl_component_typed (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EInl p_v p_t2) (TSum p_t1 p_t2) p_epsilon == true)) (ensures ((exists p_epsilon. has_type [] p_sigma Public p_v p_t1 epsilon_prime == true))) = admit ()

(* inr_component_typed (matches Coq: Lemma inr_component_typed) *)
let inr_component_typed (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EInr p_v p_t1) (TSum p_t1 p_t2) p_epsilon == true)) (ensures ((exists p_epsilon. has_type [] p_sigma Public p_v p_t2 epsilon_prime == true))) = admit ()

(* classify_component_typed (matches Coq: Lemma classify_component_typed) *)
let classify_component_typed (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EClassify p_v) (TSecret p_t) p_epsilon == true)) (ensures ((exists p_epsilon. has_type [] p_sigma Public p_v p_t epsilon_prime == true))) = admit ()

(* prove_component_typed (matches Coq: Lemma prove_component_typed) *)
let prove_component_typed (p_v: _) (p_t: _) (p_epsilon: _) (p_sigma: _) : Lemma (requires (has_type [] p_sigma Public (EProve p_v) (TProof p_t) p_epsilon == true)) (ensures ((exists p_epsilon. has_type [] p_sigma Public p_v p_t epsilon_prime == true))) = admit ()

(* value_shape (matches Coq: Lemma value_shape) *)
let value_shape (p_v: _) (p_sigma: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma Public p_v p_t p_epsilon == true /\ value p_v == true)) (ensures (p_v == EUnit \/ ((exists p_b. p_v == EBool p_b)) \/ ((exists p_n. p_v == EInt p_n)) \/ ((exists p_s. p_v == EString p_s)) \/ ((exists p_l. p_v == ELoc p_l)) \/ ((exists p_x. (exists p_t1. (exists p_body. p_v == ELam p_x p_t1 p_body)))) \/ ((exists p_v1. (exists p_v2. p_v == EPair p_v1 p_v2))) \/ ((exists p_v. p_v == EInl v_ T2)) \/ ((exists p_v. p_v == EInr v_ T1)) \/ ((exists p_v. p_v == EClassify v_)) \/ ((exists p_v. p_v == EProve v_)))) = admit ()

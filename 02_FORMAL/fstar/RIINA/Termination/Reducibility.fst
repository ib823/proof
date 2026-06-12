(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/Reducibility.v (38 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Termination.Reducibility
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

(* strongly_normalizing (matches Coq: Definition strongly_normalizing) *)
let strongly_normalizing (p_e: nat) (p_st: nat) (p_ctx: nat) : Tot bool =
  true

(* value_SN (matches Coq: Lemma value_SN) *)
let value_sn (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx p_v == true)) = admit ()

(* SN_step (matches Coq: Lemma SN_step) *)
let sn_step (p_e: _) (p_e_: _) (p_st: _) (p_st_: _) (p_ctx: _) (p_ctx_: _) : Lemma (requires (SN p_st p_ctx p_e == true /\ step (p_e, p_st, p_ctx) (p_e_, p_st_, p_ctx_) == true)) (ensures (SN p_st_ p_ctx_ p_e_ == true)) = admit ()

(* fst_typed_steps_to_value (matches Coq: Lemma fst_typed_steps_to_value) *)
let fst_typed_steps_to_value (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v1. (exists p_st. step (EFst p_v, p_st, p_ctx) (p_v1, st_, ctx_) == true)) /\ value v1 == true /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* snd_typed_steps_to_value (matches Coq: Lemma snd_typed_steps_to_value) *)
let snd_typed_steps_to_value (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v2. (exists p_st. step (ESnd p_v, p_st, p_ctx) (p_v2, st_, ctx_) == true)) /\ value v2 == true /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* case_typed_steps_once (matches Coq: Lemma case_typed_steps_once) *)
let case_typed_steps_once (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_e. step (ECase p_v p_x1 p_e1 p_x2 p_e2, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* if_typed_steps_once (matches Coq: Lemma if_typed_steps_once) *)
let if_typed_steps_once (p_v: _) (p_epsilon: _) (p_sigma: _) (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_v TBool p_epsilon == true /\ value p_v == true)) (ensures ((exists p_e. step (EIf p_v p_e2 p_e3, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* let_typed_steps_once (matches Coq: Lemma let_typed_steps_once) *)
let let_typed_steps_once (p_v: _) (p_x: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures ((exists p_e. step (ELet p_x p_v p_e2, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* handle_typed_steps_once (matches Coq: Lemma handle_typed_steps_once) *)
let handle_typed_steps_once (p_v: _) (p_x: _) (p_h: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures ((exists p_e. step (EHandle p_v p_x p_h, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* app_typed_steps_once (matches Coq: Lemma app_typed_steps_once) *)
let app_typed_steps_once (p_f: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_epsilon_prime: _) (p_sigma: _) (p_a: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_f (TFn p_t1 p_t2 p_epsilon) p_epsilon_prime == true /\ value p_f == true /\ value p_a == true)) (ensures ((exists p_e. step (EApp p_f p_a, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* SN_value_irreducible (matches Coq: Lemma SN_value_irreducible) *)
let sn_value_irreducible (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ SN p_st p_ctx p_v == true)) (ensures ((forall (e: _). ~((step (p_v, p_st, p_ctx) (e_, st_, ctx_) == true))))) = admit ()

(* case_inl_typed_steps (matches Coq: Lemma case_inl_typed_steps) *)
let case_inl_typed_steps (p_v: _) (p_t2: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures ((exists p_e. step (ECase (EInl p_v p_t2) p_x1 p_e1 p_x2 p_e2, p_st, p_ctx) (e_, st_, ctx_) == true) /\ e_ == subst_x1 := v_ p_e1 /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* case_inr_typed_steps (matches Coq: Lemma case_inr_typed_steps) *)
let case_inr_typed_steps (p_v: _) (p_t1: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures ((exists p_e. step (ECase (EInr p_v p_t1) p_x1 p_e1 p_x2 p_e2, p_st, p_ctx) (e_, st_, ctx_) == true) /\ e_ == subst_x2 := v_ p_e2 /\ st_ == p_st /\ ctx_ == p_ctx)) = admit ()

(* pair_values_value (matches Coq: Lemma pair_values_value) *)
let pair_values_value (p_v1: _) (p_v2: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures (value (EPair p_v1 p_v2) == true)) = admit ()

(* inl_value_value (matches Coq: Lemma inl_value_value) *)
let inl_value_value (p_v: _) (p_t: _) : Lemma (requires (value p_v == true)) (ensures (value (EInl p_v p_t) == true)) = admit ()

(* inr_value_value (matches Coq: Lemma inr_value_value) *)
let inr_value_value (p_v: _) (p_t: _) : Lemma (requires (value p_v == true)) (ensures (value (EInr p_v p_t) == true)) = admit ()

(* lam_value (matches Coq: Lemma lam_value) *)
let lam_value (p_x: _) (p_t: _) (p_body: _) : Lemma (value (ELam p_x p_t p_body) == true) = admit ()

(* unit_value (matches Coq: Lemma unit_value) *)
let unit_value () : Lemma (value EUnit == true) = admit ()

(* bool_value (matches Coq: Lemma bool_value) *)
let bool_value (p_b: _) : Lemma (value (EBool p_b) == true) = admit ()

(* int_value (matches Coq: Lemma int_value) *)
let int_value (p_n: _) : Lemma (value (EInt p_n) == true) = admit ()

(* string_value (matches Coq: Lemma string_value) *)
let string_value (p_s: _) : Lemma (value (EString p_s) == true) = admit ()

(* loc_value (matches Coq: Lemma loc_value) *)
let loc_value (p_l: _) : Lemma (value (ELoc p_l) == true) = admit ()

(* SN_multi_step_closed (matches Coq: Lemma SN_multi_step_closed) *)
let sn_multi_step_closed (p_cfg: _) (p_cfg_: _) : Lemma (requires (step p_cfg * p_cfg_ == true /\ (forall (e: _). (forall (st: _). (forall (ctx: _). (forall (e: _). p_cfg == (e, st, ctx))))) /\ p_cfg_ == (e_, st_, ctx_) /\ SN st ctx e == true)) (ensures (SN st_ ctx_ e_ == true)) = admit ()

(* classify_value_value (matches Coq: Lemma classify_value_value) *)
let classify_value_value (p_v: _) : Lemma (requires (value p_v == true)) (ensures (value (EClassify p_v) == true)) = admit ()

(* classify_value_SN (matches Coq: Lemma classify_value_SN) *)
let classify_value_sn (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EClassify p_v) == true)) = admit ()

(* pair_SN (matches Coq: Lemma pair_SN) *)
let pair_sn (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures (SN p_st p_ctx (EPair p_v1 p_v2) == true)) = admit ()

(* inl_SN (matches Coq: Lemma inl_SN) *)
let inl_sn (p_v: _) (p_t: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EInl p_v p_t) == true)) = admit ()

(* inr_SN (matches Coq: Lemma inr_SN) *)
let inr_sn (p_v: _) (p_t: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EInr p_v p_t) == true)) = admit ()

(* lam_SN (matches Coq: Lemma lam_SN) *)
let lam_sn (p_x: _) (p_t: _) (p_body: _) (p_st: _) (p_ctx: _) : Lemma (SN p_st p_ctx (ELam p_x p_t p_body) == true) = admit ()

(* unit_SN (matches Coq: Lemma unit_SN) *)
let unit_sn (p_st: _) (p_ctx: _) : Lemma (SN p_st p_ctx EUnit == true) = admit ()

(* bool_SN (matches Coq: Lemma bool_SN) *)
let bool_sn (p_b: _) (p_st: _) (p_ctx: _) : Lemma (SN p_st p_ctx (EBool p_b) == true) = admit ()

(* int_SN (matches Coq: Lemma int_SN) *)
let int_sn (p_n: _) (p_st: _) (p_ctx: _) : Lemma (SN p_st p_ctx (EInt p_n) == true) = admit ()

(* string_SN (matches Coq: Lemma string_SN) *)
let string_sn (p_s: _) (p_st: _) (p_ctx: _) : Lemma (SN p_st p_ctx (EString p_s) == true) = admit ()

(* loc_SN (matches Coq: Lemma loc_SN) *)
let loc_sn (p_l: _) (p_st: _) (p_ctx: _) : Lemma (SN p_st p_ctx (ELoc p_l) == true) = admit ()

(* prove_value_value (matches Coq: Lemma prove_value_value) *)
let prove_value_value (p_v: _) : Lemma (requires (value p_v == true)) (ensures (value (EProve p_v) == true)) = admit ()

(* prove_SN (matches Coq: Lemma prove_SN) *)
let prove_sn (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx (EProve p_v) == true)) = admit ()

(* fst_pair_step_value (matches Coq: Lemma fst_pair_step_value) *)
let fst_pair_step_value (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures ((exists p_v. step (EFst (EPair p_v1 p_v2), p_st, p_ctx) (p_v, p_st, p_ctx) == true) /\ value v == true)) = admit ()

(* snd_pair_step_value (matches Coq: Lemma snd_pair_step_value) *)
let snd_pair_step_value (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures ((exists p_v. step (ESnd (EPair p_v1 p_v2), p_st, p_ctx) (p_v, p_st, p_ctx) == true) /\ value v == true)) = admit ()

(* app_lam_steps (matches Coq: Lemma app_lam_steps) *)
let app_lam_steps (p_x: _) (p_t: _) (p_body: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (step (EApp (ELam p_x p_t p_body) p_v, p_st, p_ctx) (subst_x := v_ p_body, p_st, p_ctx) == true)) = admit ()

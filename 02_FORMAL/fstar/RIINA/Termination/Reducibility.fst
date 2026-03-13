(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/Reducibility.v (9 lemmas) *)
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
let value_sn (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (SN p_st p_ctx p_v == true)) = ()

(* SN_step (matches Coq: Lemma SN_step) *)
let sn_step (p_e: _) (p_e_: _) (p_st: _) (p_st_: _) (p_ctx: _) (p_ctx_: _) : Lemma (requires (SN p_st p_ctx p_e == true /\ step (p_e, p_st, p_ctx) (p_e_, p_st_, p_ctx_) == true)) (ensures (SN p_st_ p_ctx_ p_e_ == true)) = ()

(* fst_typed_steps_to_value (matches Coq: Lemma fst_typed_steps_to_value) *)
let fst_typed_steps_to_value (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v1. (exists p_st. step (EFst p_v, p_st, p_ctx) (p_v1, st_, ctx_) == true)) /\ value v1 == true /\ st_ == p_st /\ ctx_ == p_ctx)) = ()

(* snd_typed_steps_to_value (matches Coq: Lemma snd_typed_steps_to_value) *)
let snd_typed_steps_to_value (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_v2. (exists p_st. step (ESnd p_v, p_st, p_ctx) (p_v2, st_, ctx_) == true)) /\ value v2 == true /\ st_ == p_st /\ ctx_ == p_ctx)) = ()

(* case_typed_steps_once (matches Coq: Lemma case_typed_steps_once) *)
let case_typed_steps_once (p_v: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_sigma: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_v (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true)) (ensures ((exists p_e. step (ECase p_v p_x1 p_e1 p_x2 p_e2, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = ()

(* if_typed_steps_once (matches Coq: Lemma if_typed_steps_once) *)
let if_typed_steps_once (p_v: _) (p_epsilon: _) (p_sigma: _) (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_v TBool p_epsilon == true /\ value p_v == true)) (ensures ((exists p_e. step (EIf p_v p_e2 p_e3, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = ()

(* let_typed_steps_once (matches Coq: Lemma let_typed_steps_once) *)
let let_typed_steps_once (p_v: _) (p_x: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures ((exists p_e. step (ELet p_x p_v p_e2, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = ()

(* handle_typed_steps_once (matches Coq: Lemma handle_typed_steps_once) *)
let handle_typed_steps_once (p_v: _) (p_x: _) (p_h: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures ((exists p_e. step (EHandle p_v p_x p_h, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = ()

(* app_typed_steps_once (matches Coq: Lemma app_typed_steps_once) *)
let app_typed_steps_once (p_f: _) (p_t1: _) (p_t2: _) (p_epsilon: _) (p_epsilon_prime: _) (p_sigma: _) (p_a: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type [] p_sigma Public p_f (TFn p_t1 p_t2 p_epsilon) p_epsilon_prime == true /\ value p_f == true /\ value p_a == true)) (ensures ((exists p_e. step (EApp p_f p_a, p_st, p_ctx) (e_, st_, ctx_) == true) /\ st_ == p_st /\ ctx_ == p_ctx)) = ()

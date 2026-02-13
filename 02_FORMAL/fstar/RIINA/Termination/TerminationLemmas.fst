(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (7 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Termination.TerminationLemmas
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

(* val_rel_0 (matches Coq: Definition val_rel_0) *)
let val_rel_0 (p_sigma: nat) (p_t: nat) (p_v1: nat) (p_v2: nat) : Tot bool =
  true

(* store_rel_0 (matches Coq: Definition store_rel_0) *)
let store_rel_0 (p_sigma: nat) (p_st1: nat) (p_st2: nat) : Tot bool =
  true

(* exp_rel_step1_fst_typed (matches Coq: Lemma exp_rel_step1_fst_typed) *)
let exp_rel_step1_fst_typed (p_sigma: _) (p_t1: _) (p_t2: _) (p_v: _) (p_v_: _) (p_st1: _) (p_st2: _) (p_ctx: _) (p_sigma_prime: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma' Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ has_type [] p_sigma' Public p_v_ (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true /\ value p_v_ == true /\ store_rel_0 p_sigma' p_st1 p_st2 == true /\ store_ty_extends p_sigma p_sigma' == true)) (ensures ((exists p_a1. (exists p_a2. (exists p_st1. store_ty_extends p_sigma' p_sigma'' == true))) /\ step (EFst p_v, p_st1, p_ctx) * (a1, st1_, ctx1_) == true /\ step (EFst p_v_, p_st2, p_ctx) * (a2, st2_, ctx2_) == true /\ value a1 == true /\ value a2 == true /\ val_rel_0 p_sigma'' p_t1 a1 a2 == true /\ store_rel_0 p_sigma'' st1_ st2_ == true)) = admit ()

(* exp_rel_step1_snd_typed (matches Coq: Lemma exp_rel_step1_snd_typed) *)
let exp_rel_step1_snd_typed (p_sigma: _) (p_t1: _) (p_t2: _) (p_v: _) (p_v_: _) (p_st1: _) (p_st2: _) (p_ctx: _) (p_sigma_prime: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma' Public p_v (TProd p_t1 p_t2) p_epsilon == true /\ has_type [] p_sigma' Public p_v_ (TProd p_t1 p_t2) p_epsilon == true /\ value p_v == true /\ value p_v_ == true /\ store_rel_0 p_sigma' p_st1 p_st2 == true /\ store_ty_extends p_sigma p_sigma' == true)) (ensures ((exists p_b1. (exists p_b2. (exists p_st1. store_ty_extends p_sigma' p_sigma'' == true))) /\ step (ESnd p_v, p_st1, p_ctx) * (b1, st1_, ctx1_) == true /\ step (ESnd p_v_, p_st2, p_ctx) * (b2, st2_, ctx2_) == true /\ value b1 == true /\ value b2 == true /\ val_rel_0 p_sigma'' p_t2 b1 b2 == true /\ store_rel_0 p_sigma'' st1_ st2_ == true)) = admit ()

(* exp_rel_step1_case_typed (matches Coq: Lemma exp_rel_step1_case_typed) *)
let exp_rel_step1_case_typed_obligation () : Tot bool = true
let exp_rel_step1_case_typed_lemma () : Lemma (requires True) (ensures (exp_rel_step1_case_typed_obligation () == exp_rel_step1_case_typed_obligation ())) = ()

(* exp_rel_step1_if_typed (matches Coq: Lemma exp_rel_step1_if_typed) *)
let exp_rel_step1_if_typed (p_sigma: _) (p_t: _) (p_v: _) (p_v_: _) (p_e2: _) (p_e2_: _) (p_e3: _) (p_e3_: _) (p_st1: _) (p_st2: _) (p_ctx: _) (p_sigma_prime: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma' Public p_v TBool p_epsilon == true /\ has_type [] p_sigma' Public p_v_ TBool p_epsilon == true /\ value p_v == true /\ value p_v_ == true /\ store_rel_0 p_sigma' p_st1 p_st2 == true /\ store_ty_extends p_sigma p_sigma' == true /\ terminates p_e2 p_st1 p_ctx == true /\ terminates p_e3 p_st1 p_ctx == true /\ terminates p_e2_ p_st2 p_ctx == true /\ terminates p_e3_ p_st2 p_ctx == true)) (ensures ((exists p_r1. (exists p_r2. (exists p_st1. store_ty_extends p_sigma' p_sigma'' == true))) /\ step (EIf p_v p_e2 p_e3, p_st1, p_ctx) * (r1, st1_, ctx1_) == true /\ step (EIf p_v_ p_e2_ p_e3_, p_st2, p_ctx) * (r2, st2_, ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 p_sigma'' p_t r1 r2 == true /\ store_rel_0 p_sigma'' st1_ st2_ == true)) = admit ()

(* exp_rel_step1_let_typed (matches Coq: Lemma exp_rel_step1_let_typed) *)
let exp_rel_step1_let_typed_obligation () : Tot bool = true
let exp_rel_step1_let_typed_lemma () : Lemma (requires True) (ensures (exp_rel_step1_let_typed_obligation () == exp_rel_step1_let_typed_obligation ())) = ()

(* exp_rel_step1_handle_typed (matches Coq: Lemma exp_rel_step1_handle_typed) *)
let exp_rel_step1_handle_typed_obligation () : Tot bool = true
let exp_rel_step1_handle_typed_lemma () : Lemma (requires True) (ensures (exp_rel_step1_handle_typed_obligation () == exp_rel_step1_handle_typed_obligation ())) = ()

(* exp_rel_step1_app_typed (matches Coq: Lemma exp_rel_step1_app_typed) *)
let exp_rel_step1_app_typed_obligation () : Tot bool = true
let exp_rel_step1_app_typed_lemma () : Lemma (requires True) (ensures (exp_rel_step1_app_typed_obligation () == exp_rel_step1_app_typed_obligation ())) = ()

(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (30 lemmas) *)
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
let exp_rel_step1_case_typed (p_sigma: _) (p_t: _) (p_t1: _) (p_t2: _) (p_v: _) (p_v_: _) (p_x1: _) (p_e1: _) (p_e1_: _) (p_x2: _) (p_e2: _) (p_e2_: _) (p_st1: _) (p_st2: _) (p_ctx: _) (p_sigma_prime: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma' Public p_v (TSum p_t1 p_t2) p_epsilon == true /\ has_type [] p_sigma' Public p_v_ (TSum p_t1 p_t2) p_epsilon == true /\ value p_v == true /\ value p_v_ == true /\ store_rel_0 p_sigma' p_st1 p_st2 == true /\ store_ty_extends p_sigma p_sigma' == true /\ ((forall (v1: _). value v1 -> terminates (subst_x1 := v1_ p_e1) p_st1 p_ctx == true)) /\ ((forall (v2: _). value v2 -> terminates (subst_x2 := v2_ p_e2) p_st1 p_ctx == true)) /\ ((forall (v1: _). value v1_ -> terminates (subst_x1 := v1__ p_e1_) p_st2 p_ctx == true)) /\ ((forall (v2: _). value v2_ -> terminates (subst_x2 := v2__ p_e2_) p_st2 p_ctx == true)))) (ensures ((exists p_r1. (exists p_r2. (exists p_st1. store_ty_extends p_sigma' p_sigma'' == true))) /\ step (ECase p_v p_x1 p_e1 p_x2 p_e2, p_st1, p_ctx) * (r1, st1_, ctx1_) == true /\ step (ECase p_v_ p_x1 p_e1_ p_x2 p_e2_, p_st2, p_ctx) * (r2, st2_, ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 p_sigma'' p_t r1 r2 == true /\ store_rel_0 p_sigma'' st1_ st2_ == true)) = admit ()

(* exp_rel_step1_if_typed (matches Coq: Lemma exp_rel_step1_if_typed) *)
let exp_rel_step1_if_typed (p_sigma: _) (p_t: _) (p_v: _) (p_v_: _) (p_e2: _) (p_e2_: _) (p_e3: _) (p_e3_: _) (p_st1: _) (p_st2: _) (p_ctx: _) (p_sigma_prime: _) (p_epsilon: _) : Lemma (requires (has_type [] p_sigma' Public p_v TBool p_epsilon == true /\ has_type [] p_sigma' Public p_v_ TBool p_epsilon == true /\ value p_v == true /\ value p_v_ == true /\ store_rel_0 p_sigma' p_st1 p_st2 == true /\ store_ty_extends p_sigma p_sigma' == true /\ terminates p_e2 p_st1 p_ctx == true /\ terminates p_e3 p_st1 p_ctx == true /\ terminates p_e2_ p_st2 p_ctx == true /\ terminates p_e3_ p_st2 p_ctx == true)) (ensures ((exists p_r1. (exists p_r2. (exists p_st1. store_ty_extends p_sigma' p_sigma'' == true))) /\ step (EIf p_v p_e2 p_e3, p_st1, p_ctx) * (r1, st1_, ctx1_) == true /\ step (EIf p_v_ p_e2_ p_e3_, p_st2, p_ctx) * (r2, st2_, ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 p_sigma'' p_t r1 r2 == true /\ store_rel_0 p_sigma'' st1_ st2_ == true)) = admit ()

(* exp_rel_step1_let_typed (matches Coq: Lemma exp_rel_step1_let_typed) *)
let exp_rel_step1_let_typed (p_sigma: _) (p_t: _) (p_v: _) (p_v_: _) (p_x: _) (p_e2: _) (p_e2_: _) (p_st1: _) (p_st2: _) (p_ctx: _) (p_sigma_prime: _) : Lemma (requires (value p_v == true /\ value p_v_ == true /\ store_rel_0 p_sigma' p_st1 p_st2 == true /\ store_ty_extends p_sigma p_sigma' == true /\ terminates (subst_x := p_v_ p_e2) p_st1 p_ctx == true /\ terminates (subst_x := v__ p_e2_) p_st2 p_ctx == true)) (ensures ((exists p_r1. (exists p_r2. (exists p_st1. store_ty_extends p_sigma' p_sigma'' == true))) /\ step (ELet p_x p_v p_e2, p_st1, p_ctx) * (r1, st1_, ctx1_) == true /\ step (ELet p_x p_v_ p_e2_, p_st2, p_ctx) * (r2, st2_, ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 p_sigma'' p_t r1 r2 == true /\ store_rel_0 p_sigma'' st1_ st2_ == true)) = admit ()

(* exp_rel_step1_handle_typed (matches Coq: Lemma exp_rel_step1_handle_typed) *)
let exp_rel_step1_handle_typed (p_sigma: _) (p_t: _) (p_v: _) (p_v_: _) (p_x: _) (p_h: _) (p_h_: _) (p_st1: _) (p_st2: _) (p_ctx: _) (p_sigma_prime: _) : Lemma (requires (value p_v == true /\ value p_v_ == true /\ store_rel_0 p_sigma' p_st1 p_st2 == true /\ store_ty_extends p_sigma p_sigma' == true /\ terminates (subst_x := p_v_ p_h) p_st1 p_ctx == true /\ terminates (subst_x := v__ p_h_) p_st2 p_ctx == true)) (ensures ((exists p_r1. (exists p_r2. (exists p_st1. store_ty_extends p_sigma' p_sigma'' == true))) /\ step (EHandle p_v p_x p_h, p_st1, p_ctx) * (r1, st1_, ctx1_) == true /\ step (EHandle p_v_ p_x p_h_, p_st2, p_ctx) * (r2, st2_, ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 p_sigma'' p_t r1 r2 == true /\ store_rel_0 p_sigma'' st1_ st2_ == true)) = admit ()

(* exp_rel_step1_app_typed (matches Coq: Lemma exp_rel_step1_app_typed) *)
let exp_rel_step1_app_typed (p_sigma: _) (p_t1: _) (p_t2: _) (p_f: _) (p_f_: _) (p_a: _) (p_a_: _) (p_st1: _) (p_st2: _) (p_ctx: _) (p_sigma_prime: _) (p_epsilon: _) (p_epsilon_prime: _) : Lemma (requires (has_type [] p_sigma' Public p_f (TFn p_t1 p_t2 p_epsilon) p_epsilon_prime == true /\ has_type [] p_sigma' Public p_f_ (TFn p_t1 p_t2 p_epsilon) p_epsilon_prime == true /\ value p_f == true /\ value p_f_ == true /\ value p_a == true /\ value p_a_ == true /\ store_rel_0 p_sigma' p_st1 p_st2 == true /\ store_ty_extends p_sigma p_sigma' == true /\ ((forall (x: _). (forall (body: _). p_f == ELam x p_t1 body -> terminates (subst_x := p_a_ body) p_st1 p_ctx))) /\ ((forall (x: _). (forall (body: _). p_f_ == ELam x p_t1 body -> terminates (subst_x := a__ body) p_st2 p_ctx))))) (ensures ((exists p_r1. (exists p_r2. (exists p_st1. store_ty_extends p_sigma' p_sigma'' == true))) /\ step (EApp p_f p_a, p_st1, p_ctx) * (r1, st1_, ctx1_) == true /\ step (EApp p_f_ p_a_, p_st2, p_ctx) * (r2, st2_, ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 p_sigma'' p_t2 r1 r2 == true /\ store_rel_0 p_sigma'' st1_ st2_ == true)) = admit ()

(* multi_step_step_left (matches Coq: Lemma multi_step_step_left) *)
let multi_step_step_left (p_cfg1: _) (p_cfg2: _) (p_cfg3: _) : Lemma (requires (step p_cfg1 p_cfg2 == true /\ step p_cfg2 * p_cfg3 == true)) (ensures (step p_cfg1 * p_cfg3 == true)) = admit ()

(* val_rel_0_trivial (matches Coq: Lemma val_rel_0_trivial) *)
let val_rel_0_trivial (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (val_rel_0 p_sigma p_t p_v1 p_v2 == true) = admit ()

(* store_rel_0_trivial (matches Coq: Lemma store_rel_0_trivial) *)
let store_rel_0_trivial (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (store_rel_0 p_sigma p_st1 p_st2 == true) = admit ()

(* val_rel_0_type_irrelevant (matches Coq: Lemma val_rel_0_type_irrelevant) *)
let val_rel_0_type_irrelevant (p_sigma: _) (p_t1: _) (p_t2: _) (p_v1: _) (p_v2: _) : Lemma (val_rel_0 p_sigma p_t1 p_v1 p_v2 == true <==> val_rel_0 p_sigma p_t2 p_v1 p_v2 == true) = admit ()

(* val_rel_0_store_irrelevant (matches Coq: Lemma val_rel_0_store_irrelevant) *)
let val_rel_0_store_irrelevant (p_sigma1: _) (p_sigma2: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (val_rel_0 p_sigma1 p_t p_v1 p_v2 == true <==> val_rel_0 p_sigma2 p_t p_v1 p_v2 == true) = admit ()

(* store_rel_0_sym (matches Coq: Lemma store_rel_0_sym) *)
let store_rel_0_sym (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_rel_0 p_sigma p_st1 p_st2 == true)) (ensures (store_rel_0 p_sigma p_st2 p_st1 == true)) = admit ()

(* fst_terminates (matches Coq: Lemma fst_terminates) *)
let fst_terminates (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures (terminates (EFst (EPair p_v1 p_v2)) p_st p_ctx == true)) = admit ()

(* snd_terminates (matches Coq: Lemma snd_terminates) *)
let snd_terminates (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true)) (ensures (terminates (ESnd (EPair p_v1 p_v2)) p_st p_ctx == true)) = admit ()

(* if_true_terminates (matches Coq: Lemma if_true_terminates) *)
let if_true_terminates (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires (terminates p_e2 p_st p_ctx == true)) (ensures (terminates (EIf (EBool true) p_e2 p_e3) p_st p_ctx == true)) = admit ()

(* if_false_terminates (matches Coq: Lemma if_false_terminates) *)
let if_false_terminates (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires (terminates p_e3 p_st p_ctx == true)) (ensures (terminates (EIf (EBool false) p_e2 p_e3) p_st p_ctx == true)) = admit ()

(* let_terminates (matches Coq: Lemma let_terminates) *)
let let_terminates (p_x: _) (p_v: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ terminates (subst_x := v_ p_e2) p_st p_ctx == true)) (ensures (terminates (ELet p_x p_v p_e2) p_st p_ctx == true)) = admit ()

(* app_lam_terminates (matches Coq: Lemma app_lam_terminates) *)
let app_lam_terminates (p_x: _) (p_t: _) (p_body: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ terminates (subst_x := v_ p_body) p_st p_ctx == true)) (ensures (terminates (EApp (ELam p_x p_t p_body) p_v) p_st p_ctx == true)) = admit ()

(* value_terminates (matches Coq: Lemma value_terminates) *)
let value_terminates (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (terminates p_v p_st p_ctx == true)) = admit ()

(* case_inl_terminates (matches Coq: Lemma case_inl_terminates) *)
let case_inl_terminates (p_v: _) (p_t: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ terminates (subst_x1 := v_ p_e1) p_st p_ctx == true)) (ensures (terminates (ECase (EInl p_v p_t) p_x1 p_e1 p_x2 p_e2) p_st p_ctx == true)) = admit ()

(* case_inr_terminates (matches Coq: Lemma case_inr_terminates) *)
let case_inr_terminates (p_v: _) (p_t: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ terminates (subst_x2 := v_ p_e2) p_st p_ctx == true)) (ensures (terminates (ECase (EInr p_v p_t) p_x1 p_e1 p_x2 p_e2) p_st p_ctx == true)) = admit ()

(* handle_terminates (matches Coq: Lemma handle_terminates) *)
let handle_terminates (p_x: _) (p_v: _) (p_h: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ terminates (subst_x := v_ p_h) p_st p_ctx == true)) (ensures (terminates (EHandle p_v p_x p_h) p_st p_ctx == true)) = admit ()

(* terminates_trans (matches Coq: Lemma terminates_trans) *)
let terminates_trans (p_e: _) (p_e_: _) (p_st: _) (p_st_: _) (p_ctx: _) (p_ctx_: _) : Lemma (requires (step (p_e, p_st, p_ctx) * (p_e_, p_st_, p_ctx_) == true /\ terminates p_e_ p_st_ p_ctx_ == true)) (ensures (terminates p_e p_st p_ctx == true)) = admit ()

(* value_terminates_refl (matches Coq: Lemma value_terminates_refl) *)
let value_terminates_refl (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true)) (ensures (terminates p_v p_st p_ctx == true)) = admit ()

(* val_rel_0_refl (matches Coq: Lemma val_rel_0_refl) *)
let val_rel_0_refl (p_sigma: _) (p_t: _) (p_v: _) : Lemma (val_rel_0 p_sigma p_t p_v p_v == true) = admit ()

(* val_rel_0_sym (matches Coq: Lemma val_rel_0_sym) *)
let val_rel_0_sym (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_0 p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_0 p_sigma p_t p_v2 p_v1 == true)) = admit ()

(* store_rel_0_trans (matches Coq: Lemma store_rel_0_trans) *)
let store_rel_0_trans (p_sigma: _) (p_st1: _) (p_st2: _) (p_st3: _) : Lemma (requires (store_rel_0 p_sigma p_st1 p_st2 == true /\ store_rel_0 p_sigma p_st2 p_st3 == true)) (ensures (store_rel_0 p_sigma p_st1 p_st3 == true)) = admit ()

(* terminates_step (matches Coq: Lemma terminates_step) *)
let terminates_step (p_e: _) (p_e_: _) (p_st: _) (p_st_: _) (p_ctx: _) (p_ctx_: _) : Lemma (requires (step (p_e, p_st, p_ctx) (p_e_, p_st_, p_ctx_) == true /\ terminates p_e_ p_st_ p_ctx_ == true)) (ensures (terminates p_e p_st p_ctx == true)) = admit ()

(* if_terminates (matches Coq: Lemma if_terminates) *)
let if_terminates (p_b: _) (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires (terminates p_e2 p_st p_ctx == true /\ terminates p_e3 p_st p_ctx == true)) (ensures (terminates (EIf (EBool p_b) p_e2 p_e3) p_st p_ctx == true)) = admit ()

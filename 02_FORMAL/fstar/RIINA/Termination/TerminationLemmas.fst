(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (7 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Termination.TerminationLemmas
open FStar.All

(* val_rel_0 (matches Coq: Definition val_rel_0) *)
let val_rel_0 (p_t: nat) (p_v1: nat) (p_v2: nat) : Tot bool =
  (0 = 0)

(* store_rel_0 (matches Coq: Definition store_rel_0) *)
let store_rel_0 (p_st1: nat) (p_st2: nat) : Tot bool =
  (0 = 0)

(* exp_rel_step1_fst_typed (matches Coq: Lemma exp_rel_step1_fst_typed) *)
let exp_rel_step1_fst_typed (p_t1: _) (p_t2: _) (p_v: _) (p_v_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (has_type nil Σ' Public p_v (TProd p_t1 p_t2) _ == true /\ has_type nil Σ' Public v_ (TProd p_t1 p_t2) _ == true /\ value p_v == true /\ value v_ == true /\ store_rel_0 Σ' p_st1 p_st2 == true /\ store_ty_extends Σ Σ' == true /\ exists a1 a2 st1_ st2_ ctx1_ ctx2_ Σ'', store_ty_extends Σ' Σ'' == true /\ (EFst p_v, p_st1, p_ctx) - == true /\ * (a1_ st1__ ctx1_) == true /\ (EFst p_v', p_st2, p_ctx) - == true) (ensures (* (a2_ st2__ ctx2_) == true /\ value a1 == true /\ value a2 == true /\ val_rel_0 Σ'' p_t1 a1 a2 == true /\ store_rel_0 Σ'' st1_ st2_ == true))) = admit ()

(* exp_rel_step1_snd_typed (matches Coq: Lemma exp_rel_step1_snd_typed) *)
let exp_rel_step1_snd_typed (p_t1: _) (p_t2: _) (p_v: _) (p_v_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (has_type nil Σ' Public p_v (TProd p_t1 p_t2) _ == true /\ has_type nil Σ' Public v_ (TProd p_t1 p_t2) _ == true /\ value p_v == true /\ value v_ == true /\ store_rel_0 Σ' p_st1 p_st2 == true /\ store_ty_extends Σ Σ' == true /\ exists b1 b2 st1_ st2_ ctx1_ ctx2_ Σ'', store_ty_extends Σ' Σ'' == true /\ (ESnd p_v, p_st1, p_ctx) - == true /\ * (b1_ st1__ ctx1_) == true /\ (ESnd p_v', p_st2, p_ctx) - == true) (ensures (* (b2_ st2__ ctx2_) == true /\ value b1 == true /\ value b2 == true /\ val_rel_0 Σ'' p_t2 b1 b2 == true /\ store_rel_0 Σ'' st1_ st2_ == true))) = admit ()

(* exp_rel_step1_case_typed (matches Coq: Lemma exp_rel_step1_case_typed) *)
let exp_rel_step1_case_typed (p_t: _) (p_t1: _) (p_t2: _) (p_v: _) (p_v_: _) (p_x1: _) (p_e1: _) (p_e1_: _) (p_x2: _) (p_e2: _) (p_e2_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (has_type nil Σ' Public p_v (TSum p_t1 p_t2) _ == true /\ has_type nil Σ' Public v_ (TSum p_t1 p_t2) _ == true /\ value p_v == true /\ value v_ == true /\ store_rel_0 Σ' p_st1 p_st2 == true /\ store_ty_extends Σ Σ' == true /\ (forall v1_ value v1 -> terminates ([p_x1 := v1_ p_e1) p_st1 p_ctx == true) /\ (forall v2_ value v2 -> terminates ([p_x2 := v2_ p_e2) p_st1 p_ctx == true) /\ (forall v1__ value v1_ -> terminates ([p_x1 := v1__ e1_) p_st2 p_ctx == true) /\ (forall v2__ value v2_ -> terminates ([p_x2 := v2__ e2_) p_st2 p_ctx == true) /\ exists r1 r2 st1_ st2_ ctx1_ ctx2_ Σ'', store_ty_extends Σ' Σ'' == true /\ (ECase p_v p_x1 p_e1 p_x2 p_e2, p_st1, p_ctx) - == true /\ * (r1_ st1__ ctx1_) == true /\ (ECase p_v' p_x1 p_e1' p_x2 p_e2', p_st2, p_ctx) - == true) (ensures (* (r2_ st2__ ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 Σ'' p_t r1 r2 == true /\ store_rel_0 Σ'' st1_ st2_ == true))) = admit ()

(* exp_rel_step1_if_typed (matches Coq: Lemma exp_rel_step1_if_typed) *)
let exp_rel_step1_if_typed (p_t: _) (p_v: _) (p_v_: _) (p_e2: _) (p_e2_: _) (p_e3: _) (p_e3_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (has_type nil Σ' Public p_v TBool _ == true /\ has_type nil Σ' Public v_ TBool _ == true /\ value p_v == true /\ value v_ == true /\ store_rel_0 Σ' p_st1 p_st2 == true /\ store_ty_extends Σ Σ' == true /\ terminates p_e2 p_st1 p_ctx == true /\ terminates p_e3 p_st1 p_ctx == true /\ terminates e2_ p_st2 p_ctx == true /\ terminates e3_ p_st2 p_ctx == true /\ exists r1 r2 st1_ st2_ ctx1_ ctx2_ Σ'', store_ty_extends Σ' Σ'' == true /\ (EIf p_v p_e2 p_e3, p_st1, p_ctx) - == true /\ * (r1_ st1__ ctx1_) == true /\ (EIf p_v' p_e2' p_e3', p_st2, p_ctx) - == true) (ensures (* (r2_ st2__ ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 Σ'' p_t r1 r2 == true /\ store_rel_0 Σ'' st1_ st2_ == true))) = admit ()

(* exp_rel_step1_let_typed (matches Coq: Lemma exp_rel_step1_let_typed) *)
let exp_rel_step1_let_typed (p_t: _) (p_v: _) (p_v_: _) (p_x: _) (p_e2: _) (p_e2_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ value v_ == true /\ store_rel_0 Σ' p_st1 p_st2 == true /\ store_ty_extends Σ Σ' == true /\ terminates ([p_x := v_ p_e2) p_st1 p_ctx == true /\ terminates ([p_x := v__ e2_) p_st2 p_ctx == true /\ exists r1 r2 st1_ st2_ ctx1_ ctx2_ Σ'', store_ty_extends Σ' Σ'' == true /\ (ELet p_x p_v p_e2, p_st1, p_ctx) - == true /\ * (r1_ st1__ ctx1_) == true /\ (ELet p_x p_v' p_e2', p_st2, p_ctx) - == true) (ensures (* (r2_ st2__ ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 Σ'' p_t r1 r2 == true /\ store_rel_0 Σ'' st1_ st2_ == true))) = admit ()

(* exp_rel_step1_handle_typed (matches Coq: Lemma exp_rel_step1_handle_typed) *)
let exp_rel_step1_handle_typed (p_t: _) (p_v: _) (p_v_: _) (p_x: _) (p_h: _) (p_h_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ value v_ == true /\ store_rel_0 Σ' p_st1 p_st2 == true /\ store_ty_extends Σ Σ' == true /\ terminates ([p_x := v_ p_h) p_st1 p_ctx == true /\ terminates ([p_x := v__ h_) p_st2 p_ctx == true /\ exists r1 r2 st1_ st2_ ctx1_ ctx2_ Σ'', store_ty_extends Σ' Σ'' == true /\ (EHandle p_v p_x p_h, p_st1, p_ctx) - == true /\ * (r1_ st1__ ctx1_) == true /\ (EHandle p_v' p_x p_h', p_st2, p_ctx) - == true) (ensures (* (r2_ st2__ ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 Σ'' p_t r1 r2 == true /\ store_rel_0 Σ'' st1_ st2_ == true))) = admit ()

(* exp_rel_step1_app_typed (matches Coq: Lemma exp_rel_step1_app_typed) *)
let exp_rel_step1_app_typed (p_t1: _) (p_t2: _) (p_f: _) (p_f_: _) (p_a: _) (p_a_: _) (p_st1: _) (p_st2: _) (p_ctx: _) : Lemma (requires (has_type nil Σ' Public p_f (TFn p_t1 p_t2 _) __ == true /\ has_type nil Σ' Public f_ (TFn p_t1 p_t2 _) __ == true /\ value p_f == true /\ value f_ == true /\ value p_a == true /\ value a_ == true /\ store_rel_0 Σ' p_st1 p_st2 == true /\ store_ty_extends Σ Σ' == true /\ (forall x body_ p_f == ELam x p_t1 body -> terminates ([x := a_ body) p_st1 p_ctx) /\ (forall x body_ f_ == ELam x p_t1 body -> terminates ([x := a__ body) p_st2 p_ctx) /\ exists r1 r2 st1_ st2_ ctx1_ ctx2_ Σ'', store_ty_extends Σ' Σ'' == true /\ (EApp p_f p_a, p_st1, p_ctx) - == true /\ * (r1_ st1__ ctx1_) == true /\ (EApp p_f' p_a', p_st2, p_ctx) - == true) (ensures (* (r2_ st2__ ctx2_) == true /\ value r1 == true /\ value r2 == true /\ val_rel_0 Σ'' p_t2 r1 r2 == true /\ store_rel_0 Σ'' st1_ st2_ == true))) = admit ()

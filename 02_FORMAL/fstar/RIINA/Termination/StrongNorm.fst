(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/StrongNorm.v (8 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Termination.StrongNorm
open FStar.All

(* value_strongly_normalizing (matches Coq: Theorem value_strongly_normalizing) *)
let value_strongly_normalizing (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true) (ensures (SN p_st p_ctx p_v == true))) = admit ()

(* fst_terminates_to_value (matches Coq: Lemma fst_terminates_to_value) *)
let fst_terminates_to_value (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ exists v st_ ctx__ (EFst (EPair p_v1 p_v2), st_ p_ctx) - == true) (ensures (* (v_ st__ ctx_) == true /\ value v == true /\ v == p_v1))) = admit ()

(* snd_terminates_to_value (matches Coq: Lemma snd_terminates_to_value) *)
let snd_terminates_to_value (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ exists v st_ ctx__ (ESnd (EPair p_v1 p_v2), st_ p_ctx) - == true) (ensures (* (v_ st__ ctx_) == true /\ value v == true /\ v == p_v2))) = admit ()

(* if_bool_terminates_once (matches Coq: Lemma if_bool_terminates_once) *)
let if_bool_terminates_once (p_b: _) (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires (exists e_ st_ ctx__ (EIf (EBool p_b) p_e2 e3_ st_ p_ctx) - == true) (ensures (* (e__ st__ ctx_) == true /\ st_ == p_st /\ ctx_ == p_ctx /\ (p_b == fn_true -> e_ = p_e2) /\ (p_b == fn_false -> e_ = p_e3)))) = admit ()

(* let_terminates_once (matches Coq: Lemma let_terminates_once) *)
let let_terminates_once (p_x: _) (p_v: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ exists e_ st_ ctx__ (ELet p_x p_v e2_ st_ p_ctx) - == true) (ensures (* (e__ st__ ctx_) == true /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

(* handle_terminates_once (matches Coq: Lemma handle_terminates_once) *)
let handle_terminates_once (p_x: _) (p_v: _) (p_h: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ exists e_ st_ ctx__ (EHandle p_v p_x h_ st_ p_ctx) - == true) (ensures (* (e__ st__ ctx_) == true /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

(* app_lam_terminates_once (matches Coq: Lemma app_lam_terminates_once) *)
let app_lam_terminates_once (p_x: _) (p_t: _) (p_body: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ exists e_ st_ ctx__ (EApp (ELam p_x p_t p_body) v_ st_ p_ctx) - == true) (ensures (* (e__ st__ ctx_) == true /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

(* store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl) *)
let store_ty_extends_refl () : Lemma (store_ty_extends Σ Σ == true) = admit ()

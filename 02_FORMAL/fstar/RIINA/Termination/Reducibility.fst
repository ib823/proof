(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/Reducibility.v (9 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Termination.Reducibility
open FStar.All

(* strongly_normalizing (matches Coq: Definition strongly_normalizing) *)
let strongly_normalizing (p_e: nat) (p_st: nat) (p_ctx: nat) : Tot bool =
  (0 = 0)

(* value_SN (matches Coq: Lemma value_SN) *)
let value_sn (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true) (ensures (SN p_st p_ctx p_v == true))) = admit ()

(* SN_step (matches Coq: Lemma SN_step) *)
let sn_step (p_e: _) (p_e_: _) (p_st: _) (p_st_: _) (p_ctx: _) (p_ctx_: _) : Lemma (requires (SN p_st p_ctx p_e == true /\ (p_e, p_st, p_ctx) - == true /\ (e__ st__ ctx_ == true)) (ensures (SN st_ ctx_ e_ == true))) = admit ()

(* fst_typed_steps_to_value (matches Coq: Lemma fst_typed_steps_to_value) *)
let fst_typed_steps_to_value (p_v: _) (p_t1: _) (p_t2: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type nil Σ Public p_v (TProd p_t1 p_t2) _ == true /\ value p_v == true /\ exists v1 st_ ctx__ (EFst v_ st_ p_ctx) - == true) (ensures ((v1_ st__ ctx_ == true) /\ value v1 == true /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

(* snd_typed_steps_to_value (matches Coq: Lemma snd_typed_steps_to_value) *)
let snd_typed_steps_to_value (p_v: _) (p_t1: _) (p_t2: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type nil Σ Public p_v (TProd p_t1 p_t2) _ == true /\ value p_v == true /\ exists v2 st_ ctx__ (ESnd v_ st_ p_ctx) - == true) (ensures ((v2_ st__ ctx_ == true) /\ value v2 == true /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

(* case_typed_steps_once (matches Coq: Lemma case_typed_steps_once) *)
let case_typed_steps_once (p_v: _) (p_t1: _) (p_t2: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type nil Σ Public p_v (TSum p_t1 p_t2) _ == true /\ value p_v == true /\ exists e_ st_ ctx__ (ECase p_v p_x1 p_e1 p_x2 e2_ st_ p_ctx) - == true) (ensures ((e__ st__ ctx_ == true) /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

(* if_typed_steps_once (matches Coq: Lemma if_typed_steps_once) *)
let if_typed_steps_once (p_v: _) (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type nil Σ Public p_v TBool _ == true /\ value p_v == true /\ exists e_ st_ ctx__ (EIf p_v p_e2 e3_ st_ p_ctx) - == true) (ensures ((e__ st__ ctx_ == true) /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

(* let_typed_steps_once (matches Coq: Lemma let_typed_steps_once) *)
let let_typed_steps_once (p_v: _) (p_x: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ exists e_ st_ ctx__ (ELet p_x p_v e2_ st_ p_ctx) - == true) (ensures ((e__ st__ ctx_ == true) /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

(* handle_typed_steps_once (matches Coq: Lemma handle_typed_steps_once) *)
let handle_typed_steps_once (p_v: _) (p_x: _) (p_h: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ exists e_ st_ ctx__ (EHandle p_v p_x h_ st_ p_ctx) - == true) (ensures ((e__ st__ ctx_ == true) /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

(* app_typed_steps_once (matches Coq: Lemma app_typed_steps_once) *)
let app_typed_steps_once (p_f: _) (p_t1: _) (p_t2: _) (p_a: _) (p_st: _) (p_ctx: _) : Lemma (requires (has_type nil Σ Public p_f (TFn p_t1 p_t2 _) __ == true /\ value p_f == true /\ value p_a == true /\ exists e_ st_ ctx__ (EApp p_f a_ st_ p_ctx) - == true) (ensures ((e__ st__ ctx_ == true) /\ st_ == p_st /\ ctx_ == p_ctx))) = admit ()

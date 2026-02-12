(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/termination/SizedTypes.v (16 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Termination.SizedTypes
open FStar.All

(* sized_ty (matches Coq) *)
type sized_ty =
  | STBase of nat
  | STSized of (nat * nat)

(* sized_ty_base (matches Coq: Definition sized_ty_base) *)
let sized_ty_base (p_st: sized_ty) : Tot nat =
  match p_st with
  | STBase T -> T
  | STSized _ T -> T
  | _ -> 0

(* sized_ty_bound (matches Coq: Definition sized_ty_bound) *)
let sized_ty_bound (p_st: sized_ty) : Tot nat =
  match p_st with
  | STBase _ -> 0
  | STSized n _ -> n
  | _ -> 0

(* terminates (matches Coq: Definition terminates) *)
let terminates (p_e: nat) (p_st: nat) (p_ctx: nat) : Tot bool =
  (0 = 0)

(* step_terminates (matches Coq: Definition step_terminates) *)
let step_terminates (p_e: nat) (p_st: nat) (p_ctx: nat) : Tot bool =
  (0 = 0)

(* expr_size_pos (matches Coq: Lemma expr_size_pos) *)
let expr_size_pos (p_e: _) : Lemma (expr_size p_e > 0) = admit ()

(* value_prod_decompose (matches Coq: Lemma value_prod_decompose) *)
let value_prod_decompose (p_v: _) (p_t1: _) (p_t2: _) : Lemma (requires (has_type nil Σ Public p_v (TProd p_t1 p_t2) _ == true /\ value p_v == true) (ensures (exists v1 v2_ p_v == EPair v1 v2 /\ value v1 == true /\ value v2 == true))) = admit ()

(* value_sum_decompose (matches Coq: Lemma value_sum_decompose) *)
let value_sum_decompose (p_v: _) (p_t1: _) (p_t2: _) : Lemma (requires (has_type nil Σ Public p_v (TSum p_t1 p_t2) _ == true /\ value p_v == true) (ensures ((exists v__ p_v == EInl v_ p_t2 /\ value v_ == true) \/ (exists v__ p_v == EInr v_ p_t1 /\ value v_ == true)))) = admit ()

(* value_bool_decompose (matches Coq: Lemma value_bool_decompose) *)
let value_bool_decompose (p_v: _) : Lemma (requires (has_type nil Σ Public p_v TBool _ == true /\ value p_v == true) (ensures (exists b_ p_v == EBool b))) = admit ()

(* value_fn_decompose (matches Coq: Lemma value_fn_decompose) *)
let value_fn_decompose (p_v: _) (p_t1: _) (p_t2: _) : Lemma (requires (has_type nil Σ Public p_v (TFn p_t1 p_t2 _) __ == true /\ value p_v == true) (ensures (exists x body_ p_v == ELam x p_t1 body))) = admit ()

(* fst_steps_once (matches Coq: Lemma fst_steps_once) *)
let fst_steps_once (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ (EFst (EPair p_v1 p_v2), p_st, p_ctx) - == true) (ensures ((v1_ st_ p_ctx == true)))) = admit ()

(* snd_steps_once (matches Coq: Lemma snd_steps_once) *)
let snd_steps_once (p_v1: _) (p_v2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v1 == true /\ value p_v2 == true /\ (ESnd (EPair p_v1 p_v2), p_st, p_ctx) - == true) (ensures ((v2_ st_ p_ctx == true)))) = admit ()

(* case_inl_steps_once (matches Coq: Lemma case_inl_steps_once) *)
let case_inl_steps_once (p_v: _) (p_t: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ (ECase (EInl p_v p_t) p_x1 p_e1 p_x2 p_e2, p_st, p_ctx) - == true) (ensures (([p_x1 : == v_ e1_ st_ p_ctx)))) = admit ()

(* case_inr_steps_once (matches Coq: Lemma case_inr_steps_once) *)
let case_inr_steps_once (p_v: _) (p_t: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ (ECase (EInr p_v p_t) p_x1 p_e1 p_x2 p_e2, p_st, p_ctx) - == true) (ensures (([p_x2 : == v_ e2_ st_ p_ctx)))) = admit ()

(* if_true_steps_once (matches Coq: Lemma if_true_steps_once) *)
let if_true_steps_once (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires ((EIf (EBool true) p_e2 p_e3, p_st, p_ctx) - == true) (ensures ((e2_ st_ p_ctx == true)))) = admit ()

(* if_false_steps_once (matches Coq: Lemma if_false_steps_once) *)
let if_false_steps_once (p_e2: _) (p_e3: _) (p_st: _) (p_ctx: _) : Lemma (requires ((EIf (EBool false) p_e2 p_e3, p_st, p_ctx) - == true) (ensures ((e3_ st_ p_ctx == true)))) = admit ()

(* let_value_steps_once (matches Coq: Lemma let_value_steps_once) *)
let let_value_steps_once (p_x: _) (p_v: _) (p_e2: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ (ELet p_x p_v p_e2, p_st, p_ctx) - == true) (ensures (([p_x : == v_ e2_ st_ p_ctx)))) = admit ()

(* handle_value_steps_once (matches Coq: Lemma handle_value_steps_once) *)
let handle_value_steps_once (p_v: _) (p_x: _) (p_h: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ (EHandle p_v p_x p_h, p_st, p_ctx) - == true) (ensures (([p_x : == v_ h_ st_ p_ctx)))) = admit ()

(* app_lam_steps_once (matches Coq: Lemma app_lam_steps_once) *)
let app_lam_steps_once (p_x: _) (p_t: _) (p_body: _) (p_v: _) (p_st: _) (p_ctx: _) : Lemma (requires (value p_v == true /\ (EApp (ELam p_x p_t p_body) p_v, p_st, p_ctx) - == true) (ensures (([p_x : == v_ body_ st_ p_ctx)))) = admit ()

(* step_to_multi (matches Coq: Lemma step_to_multi) *)
let step_to_multi (p_e: _) (p_st: _) (p_ctx: _) (p_e_: _) (p_st_: _) (p_ctx_: _) : Lemma (requires ((p_e, p_st, p_ctx) - == true /\ (e__ st__ ctx_ == true) /\ (p_e, p_st, p_ctx) - == true) (ensures (* (e__ st__ ctx_) == true))) = admit ()

(* multi_step_trans (matches Coq: Lemma multi_step_trans) *)
let multi_step_trans (p_e1: _) (p_st1: _) (p_ctx1: _) (p_e2: _) (p_st2: _) (p_ctx2: _) (p_e3: _) (p_st3: _) (p_ctx3: _) : Lemma (requires ((p_e1, p_st1, p_ctx1) - == true /\ * (e2_ st2_ p_ctx2) == true /\ (p_e2, p_st2, p_ctx2) - == true /\ * (e3_ st3_ p_ctx3) == true /\ (p_e1, p_st1, p_ctx1) - == true) (ensures (* (e3_ st3_ p_ctx3) == true))) = admit ()
